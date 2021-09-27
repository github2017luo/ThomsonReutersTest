/********************************************************************** 
Name: LCRMPopulateBURegion
====================================================== 
Req:  Class will populate Bu Region and Bu Segment data differentiate by objects.
====================================================== 
Purpose: To populate Bu Region and Bu Segment data differentiate by objects.
====================================================== 
* CHANGE HISTORY
* =============================================================================
* Date         Name              Project          Description
* 2019-02-20   Miriam Ghosh      LCRM             Created for Opportunity object
* =============================================================================
***********************************************************************/

public without sharing class LCRMPopulateBuRegionSegment 
{
    
    public static void OpportunityBURegionPopulation(List<sObject> sobjectList)
    {
        //DPS-1442 changes
        Map<Id, Account> mapAccId;
        Set<Id> AccountIDSet = new Set<Id>();
        //List<Id> listId = new List<Id>();
    
        //DPS-1828 changes
        //Pricebook population depending upon opportunity region starting
        Map<String, String> pbSubBUMap = new  Map<String, String>();
        //Getting all the values stored in LCRMPriceBooksMapping custom settings
        List<LCRMPriceBooksMapping__c> pblist = LCRMPriceBooksMapping__c.getall().values();
        List<Pricebook2> pricebooklst = new List<Pricebook2>([select Id, Name from Pricebook2]);
        Map<String,Id> mapValPriceBookMap = new Map<String,Id>();
        
        //for all the pricebooks having name and ID, putting value to a map
        if(pricebooklst.size() > 0)
        {
            for(pricebook2 pb:pricebooklst)
            {
                mapValPriceBookMap.put(pb.name, pb.Id);
            }
        }
        
        //for all the values stored in custom setting, putting corresponding sub-bu and pricebook value to a map
        if(!pblist.isEmpty())
        {
            for(LCRMPriceBooksMapping__c pb :pblist)
            {
             pbSubBUMap.put(pb.Sub_Bu__c,pb.Pricebook__c);
            }   
        }   
        //Pricebook population depending upon opportunity region ending
        
        //getting account details which is associated with opportunity
        if(sobjectList.size() > 0)
        {
            for(sobject sobj:sobjectList)
            {
                AccountIDSet.add(((Opportunity)sobj).AccountId);
            }
        }
        
        //getting region segment and isGli value from the corresponding accounts
        if(AccountIDSet.Size()>0)
        {
            mapAccId = new Map<Id, Account>([select Id, BU_Region__c,Bu_Segment__c,Is_GLI__c from Account where ID =:AccountIdSet]);
        }
       // System.debug('@@printing mapAccId from new code'+mapAccId);
       if(sobjectList.size() > 0)
       {
        for(sobject sobj:sobjectList)
        {    
            if(mapAccId.size() > 0 && mapAccId.get(((Opportunity)sobj).AccountId).Is_GLI__c==true)
            { 
             sobj.put(Opportunity.Is_GLI__c,mapAccId.get(((Opportunity)sobj).AccountId).Is_GLI__c);
                if(mapAccId.get(((Opportunity)sobj).AccountId).Is_GLI__c==true && mapAccId.get(((Opportunity)sobj).AccountId).BU_Region__c != null &&         mapAccId.get(((Opportunity)sobj).AccountId).BU_Region__c != '' ){
                    sobj.put(Opportunity.LCRM_Sub_BU__c,mapAccId.get(((Opportunity)sobj).AccountId).BU_Region__c);
                }
                if(mapAccId.get(((Opportunity)sobj).AccountId).Is_GLI__c==true && mapAccId.get(((Opportunity)sobj).AccountId).Bu_Segment__c != null && mapAccId.get(((Opportunity)sobj).AccountId).Bu_Segment__c != ''){
                    sobj.put(Opportunity.BU_Segment__c,mapAccId.get(((Opportunity)sobj).AccountId).Bu_Segment__c);
                }    
                //cheking if pricebook and sub-bu value is there 
                if(mapValPriceBookMap.size() > 0 && pbSubBUMap.size() > 0)
                {
                    //assigning pricebook value depending upon the opportunity region v/s pricebook mapping.
                    sobj.put(Opportunity.Pricebook2Id, mapValPriceBookMap.get(pbSubBUMap.get(mapAccId.get(((Opportunity)sobj).AccountId).BU_Region__c)));
                }
            }
            
        }
       }
    }
    //DPS-2725,DPS-2727
    public static void AccSSDBURegionPopulation(List<sObject> sobjectList)
    {
        Map<Id, Account> mapAccId;
        Set<Id> AccountIDSet = new Set<Id>();
        
        if(sobjectList.size()>0){           
            for(sobject sobj:sobjectList)
            {
                AccountIDSet.add(((Source_System_Detail__c)sobj).Account_Name__c);
            }
        }
        if(AccountIDSet.Size()>0)
        {
            mapAccId = new Map<Id, Account>([select Id, BU_Region__c,Bu_Segment__c,Is_GLI__c from Account where ID =:AccountIdSet]);
        }
        System.debug('@@printing mapAccId from new code'+mapAccId);
        if(sobjectList.size()>0){
            for(sobject sobj:sobjectList)
            { 
                if(mapAccId.size() > 0 && mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).Is_GLI__c==true && mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).BU_Region__c != null && mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).BU_Region__c != '' )
                {
                    sobj.put(Source_System_Detail__c.LCRM_Sub_BU__c,mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).BU_Region__c);
                }
                if(mapAccId.size() > 0 && mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).Is_GLI__c==true && mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).Bu_Segment__c != null && mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).Bu_Segment__c != ''){
                 sobj.put(Source_System_Detail__c.BU_Segment__c,mapAccId.get(((Source_System_Detail__c)sobj).Account_Name__c).Bu_Segment__c); 
                }
              
            }
        }
    }
    
    //DPS-3328
    public static void AccCaseBURegionPopulation(List<sObject> sobjectList)
    {
        Map<Id, Account> mapAccId;
        Set<Id> AccountIDSet = new Set<Id>();
        List<String> gliCaseRTList = new List<String>();
        List<CaseRecordTypeIds__c> caseRecIdList = CaseRecordTypeIds__c.getAll().Values();
        if(caseRecIdList.Size()>0){         
            for(CaseRecordTypeIds__c CaseRecType:caseRecIdList){
               gliCaseRTList.add(CaseRecType.RecordTypeId__c);
            }
        }
        if(sobjectList.Size()>0){           
            for(sobject sobj:sobjectList)
            {            
                AccountIDSet.add(((Case)sobj).AccountId);
            }
        }
        if(AccountIDSet.Size()>0)
        {
            mapAccId = new Map<Id, Account>([select Id, BU_Region__c,Bu_Segment__c,Is_GLI__c from Account where ID =:AccountIdSet]);
        }
        if(sobjectList.Size()>0){
            for(sobject sobj:sobjectList)
            {                            
                if(gliCaseRTList.contains(String.valueOf(((Case)sobj).RecordTypeId).subString(0,15))){
                  
                    if(mapAccId.size() > 0 && mapAccId.get(((Case)sobj).AccountId).Is_GLI__c==true){
                        sobj.put(Case.Is_GLI__c,mapAccId.get(((Case)sobj).AccountId).Is_GLI__c);   
                    }
                    if(mapAccId.size() > 0 && mapAccId.get(((Case)sobj).AccountId).Is_GLI__c==true && mapAccId.get(((Case)sobj).AccountId).BU_Region__c != null && mapAccId.get(((Case)sobj).AccountId).BU_Region__c != ''){
                        sobj.put(Case.LCRM_Sub_BU__c,mapAccId.get(((Case)sobj).AccountId).BU_Region__c);
                    }
                    if(mapAccId.size() > 0 && mapAccId.get(((Case)sobj).AccountId).Is_GLI__c==true && mapAccId.get(((Case)sobj).AccountId).Bu_Segment__c != null && mapAccId.get(((Case)sobj).AccountId).Bu_Segment__c != ''){
                        sobj.put(Case.BU_Segment__c,mapAccId.get(((Case)sobj).AccountId).Bu_Segment__c);
                    }
                                                 
                }
            }
        }
    }
    
    
    //DPS-2729
    public static void AccTEBURegionPopulation(List<sObject> sobjectList)
    {
        Map<Id, Account> mapAccId;
        Set<Id> AccountIDSet = new Set<Id>();
        if(sobjectList.Size()>0){           
        for(sobject sobj:sobjectList)
        {
            AccountIDSet.add(((Training_Event__c)sobj).Account__c);
            ((Training_Event__c)sobj).LCRM_Is_GLI__c=true;  //added as a part of DPS-11770 by Ankit Raj
        }
        }
        if(AccountIDSet.Size()>0)
        {
            mapAccId = new Map<Id, Account>([select Id, BU_Region__c,BU_Segment__c,Is_GLI__c from Account where ID =:AccountIdSet]);
        }
        System.debug('@@printing mapAccId from new code'+mapAccId);
        if(sobjectList.Size()>0){
        for(sobject sobj:sobjectList)
        {
           
            if(mapAccId.size() > 0 && mapAccId.get(((Training_Event__c)sobj).Account__c).Is_GLI__c==true && mapAccId.get(((Training_Event__c)sobj).Account__c).BU_Region__c != null && mapAccId.get(((Training_Event__c)sobj).Account__c).BU_Region__c != ''){
                sobj.put(Training_Event__c.LCRM_Sub_BU__c,mapAccId.get(((Training_Event__c)sobj).Account__c).BU_Region__c);
            }
            if(mapAccId.size() > 0 && mapAccId.get(((Training_Event__c)sobj).Account__c).Is_GLI__c==true && mapAccId.get(((Training_Event__c)sobj).Account__c).BU_Segment__c != null && mapAccId.get(((Training_Event__c)sobj).Account__c).BU_Segment__c != ''){
                sobj.put(Training_Event__c.BU_Segment__c,mapAccId.get(((Training_Event__c)sobj).Account__c).BU_Segment__c);
            }
            if(mapAccId.size() > 0 && mapAccId.get(((Training_Event__c)sobj).Account__c).Is_GLI__c==true){
                sobj.put(Training_Event__c.LCRM_Is_GLI__c,mapAccId.get(((Training_Event__c)sobj).Account__c).Is_GLI__c);              
            }
           
        }
        }
    }
     
/*public static String LeadBURegionPopulation()
{
String data;
return data; 
}*/
    public static void populateAccountRegion(List<sObject> sobjectList){//LTS_1709 NK
        List<Lotus_countrycode_region_mappings__mdt> countryRegionMappingList = new List<Lotus_countrycode_region_mappings__mdt>();
        Map<String,String> countryRegionMap = new Map<String,String>();
        String regionValue; 
        //Get all countrycode and region values 
        if(Schema.sObjectType.Lotus_countrycode_region_mappings__mdt.isQueryable())
        countryRegionMappingList= [Select LTS_Country_Code__c,LTS_Country_Name__c,LTS_Region__c FROM Lotus_countrycode_region_mappings__mdt];
        
        for(Lotus_countrycode_region_mappings__mdt conReg : countryRegionMappingList){
            countryRegionMap.put(conReg.LTS_Country_Code__c,conReg.LTS_Region__c);
        }
        System.debug('SIZE :: '+countryRegionMap.size());
        System.debug('countryRegionMap'+countryRegionMap);
        // check if billincountry is present if yes then populate region accordingly 
        
        for(sobject sobjRec :sobjectList){
            Account accRec = (Account) sobjRec;
            // ***Start*** DPS-11122: Added standard Country Code scenario to map BU Region for Lead
            if(accRec.billingcountrycode != null && countryRegionMap.ContainsKey(accRec.billingcountrycode)){
                accRec.BU_Region__c = countryRegionMap.get(accRec.billingcountrycode);
                accRec.Is_GLI__c = true;
            }
            // ***End*** DPS-11122: Added standard Country Code scenario to map BU Region for Lead
            else if(accRec.billingcountry != null && countryRegionMap.ContainsKey(accRec.billingcountry)){
                accRec.BU_Region__c = countryRegionMap.get(accRec.billingcountry);
                accRec.Is_GLI__c = true;
            }
        }
        
    }
    //For Update
    /*public static void updateAccountBURegiaon(List<sobject> sobjectList,Map<id,sobject> sobjectoldmap){
        
        Map<Id,Account> oldAccountMap = new Map<Id,Account>();
        // oldAccountMap.putAll(sobjectoldmap);
        for(Sobject sobjecrec : sobjectoldmap.values()){
            Account oldAccIns = (Account)sobjecrec;
            oldAccountMap.put(oldAccIns.Id,oldAccIns);
        }
        SYSTEM.DEBUG('@@@@@@@@ oldAccountMap @@@@@@' +oldAccountMap);
        
        List<Lotus_countrycode_region_mappings__mdt> countryRegionMappingList = new List<Lotus_countrycode_region_mappings__mdt>();
        Map<String,String> countryRegionMap = new Map<String,String>();
        String regionValue; 
        //Get all countrycode and region values 
        
        countryRegionMappingList= [Select LTS_Country_Code__c,LTS_Country_Name__c,LTS_Region__c FROM Lotus_countrycode_region_mappings__mdt];
        
        for(Lotus_countrycode_region_mappings__mdt conReg : countryRegionMappingList){
            countryRegionMap.put(conReg.LTS_Country_Code__c,conReg.LTS_Region__c);
        }
        System.debug('SIZE :: '+countryRegionMap.size());
        System.debug('countryRegionMap'+countryRegionMap);
        List<Account> updateAccountList = new List<Account>();
        for(sobject sobjRec :sobjectList){
            System.debug('@@@@@INSIDE NEW LIST@@@@@');
            Account accRec = (Account) sobjRec;
            if(String.isNotBlank(accRec.BU_Region__c) && accRec.BU_Region__c != oldAccountMap.get(accRec.id).BU_Region__c){//
                if(accRec.billingcountry != null && countryRegionMap.ContainsKey(accRec.billingcountry)){
                    accRec.BU_Region__c = countryRegionMap.get(accRec.billingcountry);
                   // updateAccountList.add(accRec);
                }
            }
        }*/
        /*if(!updateAccountList.isEmpty()){
            
            update updateAccountList;
            
        }*/
        
    //}
    
    //Method is called from accountaddress vf page controller
    public  String updateAccountBURegion(Id AccountId,String billingCountry){
    SYSTEM.DEBUG('@@@@@ INSIDE UPDATEBUREGION @@@@');
    List<Lotus_countrycode_region_mappings__mdt> countryRegionMappingList = new List<Lotus_countrycode_region_mappings__mdt>();
        Map<String,String> countryRegionMap = new Map<String,String>();
        String regionValue; 
        //Get all countrycode and region values 
        if(Schema.sObjectType.Lotus_countrycode_region_mappings__mdt.isQueryable())
        countryRegionMappingList= [Select LTS_Country_Code__c,LTS_Country_Name__c,LTS_Region__c FROM Lotus_countrycode_region_mappings__mdt];
        
        for(Lotus_countrycode_region_mappings__mdt conReg : countryRegionMappingList){
            countryRegionMap.put(conReg.LTS_Country_Code__c,conReg.LTS_Region__c);
        }
        System.debug('SIZE :: '+countryRegionMap.size());
        System.debug('countryRegionMap'+countryRegionMap);
        List<Account> updateAccountList = new List<Account>();
        account updateRec = new account();
        if(String.isNOtBlank(billingCountry) && !LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()){
            
            
            updateRec.BU_Region__c = countryRegionMap.get(billingCountry);
            
            
        }
        return  updateRec.BU_Region__c;
        
    }
    /* Created for DPS- 2200 */    
    
      public static void populateRegionSegmentOnActvts(List<sObject> sobjectList){
        set<Id> parentIDs = new  set<Id>();
        String query ;
        List<String> fieldApiNames = new LIst<String>();
        List<sobject> parentRecsLst = new List<sobject>();
        List<string> parentobjNameLst = new List<string>();
        system.debug('events==='+sobjectList);
        Map<string,string> objQueryMap = new Map<string,string>();
        Map<String,List<String>> objFieldsMap = new Map<String,List<String>>();
        Map<String,List<String>> objFieldValuesMap = new Map<String,List<String>>();
        Map<Id,String> parentIdRegionMap = new Map<Id,String>();
        Map<Id,String> parentIdSegmentMap = new Map<Id,String>();
        
       if(sobjectList.size()>0){
        for(sobject e : sobjectList){
           if(e.getSObjectType().getDescribe().getName() == 'Event'){
              Event evnt =(event)e;
               if(evnt.whoId!=null && (String.valueOf(evnt.whoId.getSObjectType())== 'Lead' || String.valueOf(evnt.whoId.getSObjectType())== 'Contact' )){
                parentIDs.add(evnt.whoId);       
                schema.SObjectType sobjTyp = evnt.whoid.getSObjectType();
                system.debug('sobjTyp===>'+sobjTyp);
               }
              else{
                if(evnt.whatid!=null){
                   parentIDs.add(evnt.whatid);        
                  schema.SObjectType sobjTyp = evnt.whatid.getSObjectType();
                  system.debug('sobjTyp===>'+sobjTyp);
                }
                
              }
           }
           if(e.getSObjectType().getDescribe().getName() == 'Task'){
              Task tsk =(Task)e;
               if(tsk.whoId!=null && (String.valueOf(tsk.whoId.getSObjectType())== 'Lead' || String.valueOf(tsk.whoId.getSObjectType())== 'Contact' )){
                parentIDs.add(tsk.whoId);       
                schema.SObjectType sobjTyp = tsk.whoid.getSObjectType();
                system.debug('sobjTyp===>'+sobjTyp);
               }
              else{
                if(tsk.whatid!=null){
                  parentIDs.add(tsk.whatid);        
                  schema.SObjectType sobjTyp = tsk.whatid.getSObjectType();
                  system.debug('sobjTyp===>'+sobjTyp);
                }
                
              }
           }
            
        }
       }  
        system.debug('parentIDs===>'+parentIDs);
        for(LOTUS_Region_and_Segmentation_Control__mdt cstmd : [select id,MasterLabel,Region__c,Segment__c from LOTUS_Region_and_Segmentation_Control__mdt]){
            parentobjNameLst.add(cstmd.MasterLabel);
            fieldApiNames = new List<string>();
            fieldApiNames.add(cstmd.Region__c);
            fieldApiNames.add(cstmd.Segment__c);
            if(!objFieldsMap.containsKey(cstmd.MasterLabel)){
               objFieldsMap.put(cstmd.MasterLabel,fieldApiNames);
            }
        }
        system.debug('fieldApiNames'+fieldApiNames);
        system.debug('objFieldsMap111111===>'+objFieldsMap);
        
        if(parentIDs.size()>0){
          for(Id pID : parentIDs){
           String sobjTyp = pID.getSObjectType().getDescribe().getName();
           if(objFieldsMap.containsKey(sobjTyp)){
              query = 'select id';
              for(string s : objFieldsMap.get(sobjTyp)){
                 
                 query+= ','+ s; 
              } 
               query+= ' '+'from ' + sobjTyp+ ' '+'where Id IN:'+ 'parentIDs';
               objQueryMap.put(sobjTyp,query);
           }
           system.debug('objQueryMap===>'+objQueryMap); 
            
          }
        }
        
       if(!objQueryMap.isEmpty()){
        for(string s : objQueryMap.values()){
            system.debug('s===>'+s);
            parentRecsLst.addAll(database.query(s));
        }
       } 
        //parentRecsLst = database.query(query);
        system.debug('parentRecsLst===>'+parentRecsLst);
       if(parentRecsLst.size()>0){ 
        for(sobject sob : parentRecsLst){
            String sobjTyp = sob.getSObjectType().getDescribe().getName();
             /*for(String s : objFieldsMap.get(sobjTyp)){
               if(s.contains('Region')){
                  parentIdRegionMap.put(sob.id, String.valueOf(sob.get(s)));
               }
                 if(s.contains('Segment')){
                    parentIdSegmentMap.put(sob.id, String.valueOf(sob.get(s)));  
                 }  
               
             }*/ 
            parentIdRegionMap.put(sob.id, String.valueOf(sob.get(objFieldsMap.get(sobjTyp)[0])));
            parentIdSegmentMap.put(sob.id, String.valueOf(sob.get(objFieldsMap.get(sobjTyp)[1])));
        }
       } 
        system.debug('parentIdRegionMap'+parentIdRegionMap);
        system.debug('parentIdSegmentMap'+parentIdSegmentMap);
       
       if(sobjectList.size()>0){ 
        for(sobject e : sobjectList){
           if(e.getSObjectType().getDescribe().getName() == 'Event'){
              Event evnt =(event)e;
              if(evnt.whoid!=null && (String.valueOf(evnt.whoid.getSObjectType())== 'Lead' || String.valueOf(evnt.whoid.getSObjectType())== 'Contact')){
                evnt.BU_Segment__c = parentIdSegmentMap.get(evnt.whoid);
                evnt.LCRM_Sub_BU__c = parentIdRegionMap.get(evnt.whoid);
              }
              else{
                evnt.BU_Segment__c = parentIdSegmentMap.get(evnt.whatid);
                evnt.LCRM_Sub_BU__c = parentIdRegionMap.get(evnt.whatid);
             }
          }
          if(e.getSObjectType().getDescribe().getName() == 'Task'){
              Task tsk =(Task)e;
              if(tsk.whoid!=null && (String.valueOf(tsk.whoid.getSObjectType())== 'Lead' || String.valueOf(tsk.whoid.getSObjectType())== 'Contact')){
                tsk.BU_Segment__c = parentIdSegmentMap.get(tsk.whoid);
                tsk.LCRM_Sub_BU__c = parentIdRegionMap.get(tsk.whoid);
              }
              else{
                tsk.BU_Segment__c = parentIdSegmentMap.get(tsk.whatid);
                tsk.LCRM_Sub_BU__c = parentIdRegionMap.get(tsk.whatid);
             }
          }       
                        
        }
      }                 
    }
    
     /*
    Created by:
            Radhika Pawar
    
    Story Info: 
            DPS-1711 Create Pick List Field for BU Segment and Text Field for BU Region for Lead Records
    
    Purpose:
        When Lead is created and Account is NOT Present (both user & Eloqua),
        It should be populated from Country Code vs Region Mapping from backend code. The mapping should be present in "Lotus_countrycode_region_mappings" custom metadata type.
    
    */

     public static void populateRegiononLeadCreation(List<Lead> sobjectList){
        set<Id> accountIdSet=new set<Id>();
        for(sobject sobjRec :sobjectList){
            Lead leadval = (Lead) sobjRec;
            if(String.isnotblank(leadval.Account__c)){
                accountIdSet.add(leadval.Account__c);
            } 
        }
        
        System.debug('accountIdSet**'+accountIdSet);
        System.debug('accountIdSet**'+accountIdSet.size());
        
        Map<String, Account> accountmap = new Map<String, Account>();
        if(accountIdSet.size()>0){
            for (Account a : [select Name,Id,BU_Region__c,Bu_Segment__c,Is_GLI__c,Industry from Account where Id in :accountIdSet]) {
                accountmap.put(a.Id, a);
            }
        }
        System.debug('accountmap**'+accountmap.Values());
        List<Lotus_countrycode_region_mappings__mdt> countryRegionMappingList = new List<Lotus_countrycode_region_mappings__mdt>();
        Map<String,String> countryRegionMap = new Map<String,String>();
        String regionValue; 
        //Get all countrycode and region values 
        if(Schema.sObjectType.Lotus_countrycode_region_mappings__mdt.isQueryable())
        countryRegionMappingList= [Select LTS_Country_Code__c,LTS_Country_Name__c,LTS_Region__c FROM Lotus_countrycode_region_mappings__mdt];
        if(countryRegionMappingList.size()>0){
            for(Lotus_countrycode_region_mappings__mdt conReg : countryRegionMappingList){
                countryRegionMap.put(conReg.LTS_Country_Code__c,conReg.LTS_Region__c);
            }
        }
        System.debug('SIZE :: '+countryRegionMap.size());
        System.debug('countryRegionMap'+countryRegionMap);
        // check if billincountry is present if yes then populate region accordingly 
        for(Lead leadRec :sobjectList){
        
        System.debug('leadRec ***'+leadRec );
        if(String.isblank(leadRec.Account__c)){
            if(String.Isnotblank(leadRec.Billing_Country__c) && countryRegionMap.ContainsKey(leadRec.Billing_Country__c)){
                leadRec.LCRM_Sub_BU__c = countryRegionMap.get(leadRec.Billing_Country__c);
                leadRec.IS_GLI__c=true;
                System.debug('Lead Record with Region and Segment'+leadRec );
            }
            // ***Start*** DPS-12740: Added standard Country scenario to map BU Region for Lead
            else if(String.Isnotblank(leadRec.CountryCode) && countryRegionMap.ContainsKey(leadRec.CountryCode)){
                leadRec.LCRM_Sub_BU__c = countryRegionMap.get(leadRec.CountryCode);
                leadRec.IS_GLI__c=true;
                System.debug('Lead Record with Region and Segment'+leadRec );
            }
            // ***End*** DPS-12740: Added standard Country scenario to map BU Region for Lead
        }else{
        //System.debug('accountmap.get(leadRec.Account__c).Industry**'+accountmap.get(leadRec.Account__c).Industry);
        //System.debug('accountmap.get(leadRec.Account__c).IS_GLI__c**'+accountmap.get(leadRec.Account__c).IS_GLI__c);
            if(accountmap.size() > 0 && accountmap.get(leadRec.Account__c).Is_GLI__c==true){
                leadRec.IS_GLI__c=accountmap.get(leadRec.Account__c).IS_GLI__c;
            }
            
            if(accountmap.size() > 0 && accountmap.get(leadRec.Account__c).Is_GLI__c==true && String.isnotblank(accountmap.get(leadRec.Account__c).BU_Region__c)){
                leadRec.LCRM_Sub_BU__c=accountmap.get(leadRec.Account__c).BU_Region__c;
                //leadRec.BU_Segment__c=accountmap.get(leadRec.Account__c).Bu_Segment__c;
                //leadRec.IS_GLI__c=accountmap.get(leadRec.Account__c).IS_GLI__c;
            }
            
            if(accountmap.size() > 0 && accountmap.get(leadRec.Account__c).Is_GLI__c==true && String.isnotblank(accountmap.get(leadRec.Account__c).Bu_Segment__c)){
                //leadRec.LCRM_Sub_BU__c=accountmap.get(leadRec.Account__c).BU_Region__c;
                leadRec.BU_Segment__c=accountmap.get(leadRec.Account__c).Bu_Segment__c;
                //leadRec.IS_GLI__c=accountmap.get(leadRec.Account__c).IS_GLI__c;
            }
            
            if(accountmap.size() > 0 && accountmap.get(leadRec.Account__c).IS_GLI__c ==true && String.isnotblank(accountmap.get(leadRec.Account__c).Industry)){
                leadRec.Industry = accountmap.get(leadRec.Account__c).Industry;
                System.debug('leadRec.Industry**'+leadRec.Industry);
                System.debug('accountmap.get(leadRec.Account__c).Industry**'+accountmap.get(leadRec.Account__c).Industry);
            } 
            System.debug('Account is not blank'+accountmap.get(leadRec.Account__c));
            
            
        }
        
        System.debug('Final Lead Record with Region and Segment'+leadRec );
        }
        
    } 
  /*
  This method is used for populating the BU Region and BU segment based on Country and Account
  DPS-941: Updating Industry value based on Account
  */
  
     public static void populateRegiononLeadupdate(Map<Id,Lead> newleadMap, Map<id,Lead> oldLeadMap){
        System.debug('New Lead **'+newleadMap);
        System.debug('Old Lead**'+oldLeadMap);
        List<Lotus_countrycode_region_mappings__mdt> countryRegionMappingList = new List<Lotus_countrycode_region_mappings__mdt>();
        Map<String,String> countryRegionMap = new Map<String,String>();
        String regionValue; 
        //Get all countrycode and region values         
        countryRegionMappingList= [Select LTS_Country_Code__c,LTS_Country_Name__c,LTS_Region__c FROM Lotus_countrycode_region_mappings__mdt];
        
        for(Lotus_countrycode_region_mappings__mdt conReg : countryRegionMappingList){
            countryRegionMap.put(conReg.LTS_Country_Code__c,conReg.LTS_Region__c);
        }
        System.debug('countryRegionMap'+countryRegionMap);
        System.debug('LeadmapKeyset**'+newleadMap.keyset());
        // check if billincountry is present if yes then populate region accordingly 
        set<Id> AccIds =new Set<Id>();
        for(Lead leadRec :newleadMap.values()){
            if(String.isnotblank(leadRec.Account__c)){
                AccIds.add(leadRec.Account__c);
            }
        }
        System.debug('AccIds**'+AccIds);
        Map<String, Account> accountNameToId = new Map<String, Account>();
        if(AccIds.size()>0){
            for (Account a : [select Name,Id,BU_Region__c,Bu_Segment__c,IS_GLI__c,Industry from Account where Id in :AccIds and IS_GLI__c =true]) {
                   if(string.isnotblank(a.Id)){
                    accountNameToId.put(a.Id, a);
                    }
            }
        }
        
        System.debug('accountNameToId**'+accountNameToId.size());
        for(Lead leadRec :newleadMap.values()){
        
        //Populate Industry
        if(accountNameToId.size()>0){
         if(String.IsNotBlank(leadRec.Account__c)&& String.isnotblank(accountNameToId.get(leadRec.Account__c).Industry) &&(String.isblank(oldLeadMap.get(leadRec.id).Account__c)) && (leadRec.Industry != oldLeadMap.get(leadRec.id).Industry || (leadRec.Industry != accountNameToId.get(leadRec.Account__c).Industry)) ){
            leadRec.Industry = accountNameToId.get(leadRec.Account__c).Industry;            
        }
        }
        
        if(String.Isnotblank(leadRec.Billing_Country__c)&& countryRegionMap.ContainsKey(leadRec.Billing_Country__c)&& (leadRec.Billing_Country__c != oldLeadMap.get(leadRec.id).Billing_Country__c)&& String.IsBlank(leadRec.Account__c)){
            System.debug('Creteria Matched for Lead');
            leadRec.LCRM_Sub_BU__c = countryRegionMap.get(leadRec.Billing_Country__c);
            leadRec.IS_GLI__c=true;
            System.debug('Lead Record with Region and Segment'+leadRec );
          }
         // ***Start*** DPS-12740: Added standard Country scenario to map BU Region for Lead
        else if(String.Isnotblank(leadRec.CountryCode)&& countryRegionMap.ContainsKey(leadRec.CountryCode)&& (leadRec.CountryCode != oldLeadMap.get(leadRec.id).Country) && String.IsBlank(leadRec.Account__c)){
            System.debug('Creteria Matched for Lead');
            leadRec.LCRM_Sub_BU__c = countryRegionMap.get(leadRec.CountryCode);
            leadRec.IS_GLI__c=true;
            System.debug('Lead Record with Region and Segment'+leadRec );
          }
         // ***End*** DPS-12740: Added standard Country scenario to map BU Region for Lead
          else if(String.IsNotBlank(leadRec.Account__c)&& (leadRec.Account__c !=oldLeadMap.get(leadRec.id).Account__c)){
            System.debug('leadRec.Account__c**'+leadRec.Account__c);
            System.debug('BU_Region__c**'+accountNameToId.get(leadRec.Account__c).BU_Region__c);
            
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).BU_Region__c)){
           //  if(String.isnotblank(leadRec.Account__r.BU_Region__c) && String.isnotblank(leadRec.Account__r.Bu_Segment__c))
                leadRec.LCRM_Sub_BU__c=accountNameToId.get(leadRec.Account__c).BU_Region__c;
                leadRec.IS_GLI__c=accountNameToId.get(leadRec.Account__c).IS_GLI__c;
                System.debug('LeadRecRegion**'+leadRec);
            }
            
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).Bu_Segment__c)){
           //  if(String.isnotblank(leadRec.Account__r.BU_Region__c) && String.isnotblank(leadRec.Account__r.Bu_Segment__c))
                leadRec.BU_Segment__c=accountNameToId.get(leadRec.Account__c).Bu_Segment__c;
                leadRec.IS_GLI__c=accountNameToId.get(leadRec.Account__c).IS_GLI__c;
                System.debug('LeadRecSegment**'+leadRec);
            }
            
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).Industry) && (leadRec.Industry != oldLeadMap.get(leadRec.id).Industry || (leadRec.Industry != accountNameToId.get(leadRec.Account__c).Industry))){
                leadRec.Industry = accountNameToId.get(leadRec.Account__c).Industry;
                
            }
        // ***Start*** DPS-12740: Updated code to add standard Country scenario to map BU Region for Lead
        }else if(((String.Isnotblank(leadRec.Billing_Country__c) && countryRegionMap.ContainsKey(leadRec.Billing_Country__c) && (leadRec.Billing_Country__c != oldLeadMap.get(leadRec.id).Billing_Country__c)) || (String.Isnotblank(leadRec.CountryCode) && countryRegionMap.ContainsKey(leadRec.CountryCode) && (leadRec.CountryCode != oldLeadMap.get(leadRec.id).Country))) && String.IsNotBlank(leadRec.Account__c) && (leadRec.Account__c ==oldLeadMap.get(leadRec.id).Account__c)){
        // ***End*** DPS-12740: Updated code to add standard Country scenario to map BU Region for Lead
            System.debug('Country changes but Account not  changed');
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).BU_Region__c) && leadRec.LCRM_Sub_BU__c != accountNameToId.get(leadRec.Account__c).BU_Region__c){          
                leadRec.LCRM_Sub_BU__c=accountNameToId.get(leadRec.Account__c).BU_Region__c;
                leadRec.IS_GLI__c=accountNameToId.get(leadRec.Account__c).IS_GLI__c;
                System.debug('LeadRecRegion1**'+leadRec);
            }
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).Bu_Segment__c) && leadRec.BU_Segment__c  !=accountNameToId.get(leadRec.Account__c).Bu_Segment__c ){          
                leadRec.BU_Segment__c=accountNameToId.get(leadRec.Account__c).Bu_Segment__c;
                leadRec.IS_GLI__c=accountNameToId.get(leadRec.Account__c).IS_GLI__c;
                System.debug('LeadRecSegment1**'+leadRec);
            }
            
        }else if(String.Isnotblank(leadRec.Billing_Country__c)&& countryRegionMap.ContainsKey(leadRec.Billing_Country__c)&& (leadRec.Billing_Country__c == oldLeadMap.get(leadRec.id).Billing_Country__c)&& String.IsBlank(leadRec.Account__c)){
             System.debug('Account set as blank from Set account values');
             leadRec.LCRM_Sub_BU__c = countryRegionMap.get(leadRec.Billing_Country__c);
             leadRec.IS_GLI__c=true;
        }
        // ***Start*** DPS-12740: Added standard Country scenario to map BU Region for Lead
        else if(String.Isnotblank(leadRec.CountryCode)&& countryRegionMap.ContainsKey(leadRec.CountryCode)&& (leadRec.CountryCode == oldLeadMap.get(leadRec.id).Country)&& String.IsBlank(leadRec.Account__c)){
             System.debug('Account set as blank from Set account values');
             leadRec.LCRM_Sub_BU__c = countryRegionMap.get(leadRec.CountryCode);
             leadRec.IS_GLI__c=true;
        }
        // ***Start*** DPS-12740: Added standard Country scenario to map BU Region for Lead
        
        System.debug('LeadRec**'+Label.LCRMErrorOnLeadRegion);
        /*if(String.isnotblank(accountNameToId.get(leadRec.Account__c).BU_Region__c) && leadRec.LCRM_Sub_BU__c != oldLeadMap.get(leadRec.id).LCRM_Sub_BU__c && (leadRec.Billing_Country__c == oldLeadMap.get(leadRec.id).Billing_Country__c)&& String.isnotblank(leadRec.Account__c) && (leadRec.Account__c ==oldLeadMap.get(leadRec.id).Account__c)){
        System.debug('Final Lead Record with Region and Segment'+leadRec );
            leadRec.addError(Label.LCRMErrorOnLeadRegion);
            System.debug('LeadRec**'+leadRec);
       
       }*/
        /*System.debug('LeadRec**'+Label.LCRMErrorOnLeadSegment);
       if(leadRec.BU_Segment__c != oldLeadMap.get(leadRec.id).BU_Segment__c && (leadRec.Billing_Country__c == oldLeadMap.get(leadRec.id).Billing_Country__c) && String.isnotblank(leadRec.Account__c) && (leadRec.Account__c ==oldLeadMap.get(leadRec.id).Account__c)){
            leadRec.addError(Label.LCRMErrorOnLeadSegment);
            System.debug('LeadRec**'+leadRec);
       }
       */
      if(accountNameToId.size()>0){
        if(String.isnotblank(leadRec.Account__c) && (leadRec.Account__c ==oldLeadMap.get(leadRec.id).Account__c) ){
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).BU_Region__c) && (leadRec.LCRM_Sub_BU__c != oldLeadMap.get(leadRec.id).LCRM_Sub_BU__c) &&leadRec.LCRM_Sub_BU__c != accountNameToId.get(leadRec.Account__c).BU_Region__c){
            System.debug('Final Lead Record with Region and Segment'+leadRec );
                leadRec.LCRM_Sub_BU__c.addError(Label.LCRMErrorOnLeadRegion);
            System.debug('LeadRec**'+leadRec);
            }else if(String.isnotblank(accountNameToId.get(leadRec.Account__c).BU_Segment__c)&& (leadRec.BU_Segment__c != oldLeadMap.get(leadRec.id).BU_Segment__c) && leadRec.BU_Segment__c!= accountNameToId.get(leadRec.Account__c).BU_Segment__c){
                leadRec.BU_Segment__c.addError(Label.LCRMErrorOnLeadSegment);               
            }
            
            if(String.isnotblank(accountNameToId.get(leadRec.Account__c).Industry)&& (leadRec.Industry != oldLeadMap.get(leadRec.id).Industry) && leadRec.Industry != (accountNameToId.get(leadRec.Account__c).Industry))
                leadRec.Industry.addError(Label.LCRMErrorOnLeadIndustry);               
            }
         }
     
        System.debug('Final Lead Record with Region and Segment'+leadRec );
      }//End  for
        
    
    }

}