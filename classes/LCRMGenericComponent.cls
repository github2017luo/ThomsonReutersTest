/********************************************************************** 
Name: LCRMGenericComponent
====================================================== 
Req:  Generic Class used for Legal CRM project to distinguish the GLI side and S2E side data.
====================================================== 
Purpose: Generic class for Legal CRM project to distinguish the GLI side and S2E side data.
====================================================== 
History 
------- 
VERSION    AUTHOR     DATE             DETAIL                             PROJECT         RELEASE
1.0         TCS        10-Oct-2016    Initial Development                Legal CRM        R1
2.0         TCS        25-Dec-2016    Added changes for CRM-18           Legal CRM        R2
3.0     TCS        20-June-2019   Added changes for TaX Proff 
***********************************************************************/

public without sharing class LCRMGenericComponent{
    public static boolean validateUserBU(String businessUnit){
        boolean flag = false;
        if(businessUnit == null || businessUnit == ''){
            return flag;
        }
        Set<String> allowedUserSet = getPermittedList('LCRMBUList');
        if(businessUnit != null && businessUnit != '' && allowedUserSet.contains(businessUnit.toUpperCase())){
            flag = true;
        }
        return flag;
    }
    
    public static Set<String> getPermittedList(String permissionString){
        if(!Test.isRunningTest()){
        List<String> allowedUserList = (LCRM_Profile_Permissions__c.getValues(permissionString) == null || LCRM_Profile_Permissions__c.getValues(permissionString).Profile_List__c == null || LCRM_Profile_Permissions__c.getValues(permissionString).Profile_List__c == '')?new List<String>():LCRM_Profile_Permissions__c.getValues(permissionString).Profile_List__c.split('\n');
        Set<String> allowedUserSet = new Set<String>();
        for(String str : allowedUserList){
            allowedUserSet.add(str.trim().toUpperCase());
        }
        System.debug('allowedUserSet**'+allowedUserSet);
        return allowedUserSet;
        } else {return new Set<String>{'UKI','ELITE','USL','FindLaw','LMS'};}
    }
    
    public static User userObj{
        get{
            if(userObj == null && Schema.sObjectType.USER.isAccessible())
            {
                userObj = [SELECT ID,Sub_Bu__c,Profile.Name,Segment__c FROM USER WHERE ID = :UserInfo.getUserId()];
            }
            return userObj;
        }
        set;
    }

    
    public static String getUserBU(){
        //User userObj = [SELECT ID,Business_Unit__c,Profile.Name FROM USER WHERE ID = :UserInfo.getUserId()];
        //return userObj.Business_Unit__c;
        //User userObj = new User();
        //if(Schema.sObjectType.USER.isAccessible())
        //{userObj = [SELECT ID,Sub_Bu__c,Profile.Name FROM USER WHERE ID = :UserInfo.getUserId()];}
        return LCRMGenericComponent.userObj.Sub_Bu__c;
    }
    
    public static void populatebuRegionSegmentLotus(List<sobject> sobjectList){
        if(sobjectList.size()>0){
            system.debug('@@@@printing objectlist'+sobjectList);
            String objectName= sobjectList[0].getSObjectType().getDescribe().getName();
            //Map<String, GenericObject__c> mapOfGenericObject = GenericObject__c.getAll();
            //Map<String, AccountBU__c> mapOfLCRMCountryRegion = AccountBU__c.getAll();//DPS-1709
            //String gliapiname= '';
            
            /*if(mapOfGenericObject.containsKey(ObjectName))
            {
                gliapiname = mapOfGenericObject.get(ObjectName).Isglifieldapiname__c;
            } */
            
            if(objectName == 'Opportunity') //DPS-2068
            {
                System.debug('@@checking inside opp loop');
                LCRMPopulateBuRegionSegment.OpportunityBURegionPopulation(sobjectList);
               
            }
            if(objectName == 'Account') //LTS_1709 NK
            {
                System.debug('@@@@@@@ Account Loop @@@@@@@@');
                LCRMPopulateBuRegionSegment.populateAccountRegion(sobjectList);
               
            }
            
            //DPS-2725, DPS-2727
            if(objectName == 'Source_System_Detail__c'){
                system.debug('@@SSD Update');
                LCRMPopulateBuRegionSegment.AccSSDBURegionPopulation(sobjectList);
            }       
            
            //DPS-3328
            if(objectName == 'Case'){
                LCRMPopulateBuRegionSegment.AccCaseBURegionPopulation(sobjectList);
            }

            //DPS- 2200 
            if(objectName == 'Event' || objectName == 'Task'){
                LCRMPopulateBuRegionSegment.populateRegionSegmentOnActvts(sobjectList);
            }

            System.debug('Verify For Lead Object Info**'+objectName );            
            //DPS-2729
            if(objectName == 'Training_Event__c')
            {
                System.debug('@@checking inside opp loop');
                LCRMPopulateBuRegionSegment.AccTEBURegionPopulation(sobjectList);
                
            }
            populatebuRegionSegmentLotusContinue1(sobjectList, objectName);
        }
    }
    
    private static void populatebuRegionSegmentLotusContinue1(List<sobject> sobjectList, String objectName){
        //DPS-1711 
        System.debug('ObjectName **'+ObjectName );
         if(objectName == 'Lead'){
         LCRMPopulateBuRegionSegment.populateRegiononLeadCreation(sobjectList);
         }     
    }
    
  
    public static void populateSubbu(List<sobject> sobjectList){
        System.debug('populateSubbu**sobjectList**'+sobjectList);
        //if(!Test.isRunningTest()){
        if(sobjectList.size()<=0){
            return;
        }
        system.debug('@@@@'+sobjectList);
        String objectName= sobjectList[0].getSObjectType().getDescribe().getName();
        System.debug('ObjectName**'+objectName);
        Map<String, GenericObject__c> mapOfGenericObject = GenericObject__c.getAll();
        //Map<String, AccountBU__c> mapOfLCRMCountryRegion = AccountBU__c.getAll();//DPS-1709
        //Map<String, RegionSegmentControl__c> mapOfRegionSegmentControl = RegionSegmentControl__c.getAll(); //DPS-2068
        String apiname= '';
        String gliapiname= '';
        String salesorgapiname='';
        //String regionName = '';//DPS-1709
        
        System.debug('mapOfGenericObject**'+mapOfGenericObject.values());
                                
        
        if(mapOfGenericObject.containsKey(objectName))
        {
            apiname = mapOfGenericObject.get(objectName).Apifieldname__c;
            gliapiname = mapOfGenericObject.get(objectName).Isglifieldapiname__c;
            salesorgapiname = mapOfGenericObject.get(objectName).Salesorgapiname__c;
            //regionName = mapOfLCRMCountryRegion.get(ObjectName).Value__c; //DPS-1709
        }    
        System.debug('apiname **'+apiname+'gliapiname **'+gliapiname+'gliapiname **'+gliapiname);
        /*String apiname= GenericObject__c.getValues(ObjectName).Apifieldname__c;
        String gliapiname=GenericObject__c.getValues(ObjectName).Isglifieldapiname__c;
        String salesorgapiname=GenericObject__c.getValues(ObjectName).Salesorgapiname__c;*/
        
        if(String.isNotBlank(apiname)){
            user currentuser= new User();
            
                
            try{
                if(Schema.sObjectType.User.isAccessible()){
                    LIST<User> usersList = new LIST<User>([Select Id,Sub_Bu__c,Sales_Org__c from User where Id=:userinfo.getuserId()]);
                    for(user u: usersList){
                        currentuser = u;
                    }
                }
            }catch(exception e){system.debug('Message '+e.getMessage());}
            
            if(LCRMGenericComponent.validateUserBU(currentuser.Sub_Bu__c)){
                System.debug('@@@curent user SUB-BU'+currentuser.Sub_Bu__c);

                Map<String, String> paramMap = new Map<String, String>{'objectName'=>objectName, 'apiname'=>apiname, 'gliapiname'=>gliapiname, 'salesorgapiname'=>salesorgapiname};
                populateSubbuContinue(sobjectList, paramMap, currentuser);
            }
        }
    }
    
    private static void populateSubbuContinue(List<sobject> sobjectList, Map<String, String> paramMap, User currentuser){
        String objectName = paramMap.get('objectName');
        String apiname= paramMap.get('apiname');
        String gliapiname= paramMap.get('gliapiname');
        String salesorgapiname=paramMap.get('salesorgapiname');

        List<LCRMPriceBooksMapping__c> pblist = LCRMPriceBooksMapping__c.getall().values();
        Map<String, String> pbSubBUMap = new  Map<String, String>();
        if(!pblist.isEmpty()){
            for(LCRMPriceBooksMapping__c pb :pblist){
                pbSubBUMap.put(pb.Sub_Bu__c,pb.Pricebook__c);
            }
            /*Pricebook2 pbObj = new Pricebook2();
            if(!Test.isRunningTest() && Schema.sObjectType.Pricebook2.isAccessible() && currentuser.Sub_Bu__c != null && currentuser.Sub_Bu__c != '' && pbSubBUMap.size() > 0)
            {pbObj = [SELECT Id FROM Pricebook2 WHERE Name = :pbSubBUMap.get(currentuser.Sub_Bu__c)];}*/
            Pricebook2 pbObj = populateSubbuGetPB(currentuser, pbSubBUMap);
            for(sobject obj: sobjectList){
                obj = populateSubbuContinue1(obj, paramMap, currentuser);
            
                
                //added by Saloni for CRM-736  //Updated for CRM-6277 & 7422
                if(objectName=='Opportunity'){
                    Opportunity oppty = (Opportunity)obj;
                    oppty = populateSubbuOppty(oppty, pbObj, pbSubBUMap.containsKey(currentuser.Sub_Bu__c));
                    /*//Added for CRM-6277 & 7422
                    CrossSelling_Pricebooks__c pricebookValues = CrossSelling_Pricebooks__c.getInstance(UserInfo.getUserId()); 
                            
                    if(oppty.APTS_Proposal_Business_Unit__c == 'SCS'){
                            oppty.Pricebook2Id = pricebookValues.SCSPriceBookID__c;
                    }
                    else if(oppty.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                            oppty.Pricebook2Id = pricebookValues.FindlawPricebookId__c;
                    }
                    else if(pbSubBUMap.containsKey(currentuser.Sub_Bu__c)){
                        if(pbObj!=null){
                            oppty.Pricebook2Id = pbObj.id;
                        }
                    }*/
                } 
            }
        }
    }

    private static Pricebook2 populateSubbuGetPB(User currentuser, Map<String, String> pbSubBUMap){
        Pricebook2 pbObj = new Pricebook2();
        if(!Test.isRunningTest() && Schema.sObjectType.Pricebook2.isAccessible() && currentuser.Sub_Bu__c != null && currentuser.Sub_Bu__c != '' && pbSubBUMap.size() > 0)
        {pbObj = [SELECT Id FROM Pricebook2 WHERE Name = :pbSubBUMap.get(currentuser.Sub_Bu__c)];}
        return pbObj;
    }

    private static Opportunity populateSubbuOppty(Opportunity oppty, Pricebook2 pbObj, Boolean pbSubBUMapFlag){
        //Added for CRM-6277 & 7422
        CrossSelling_Pricebooks__c pricebookValues = CrossSelling_Pricebooks__c.getInstance(UserInfo.getUserId()); 
                
        if(oppty.APTS_Proposal_Business_Unit__c == 'SCS'){
                oppty.Pricebook2Id = pricebookValues.SCSPriceBookID__c;
        }
        else if(oppty.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                oppty.Pricebook2Id = pricebookValues.FindlawPricebookId__c;
        }
        else if(pbSubBUMapFlag){
            if(pbObj!=null){
                oppty.Pricebook2Id = pbObj.id;
            }
        }
        return oppty;
    }

    private static sobject populateSubbuContinue1(sobject obj, Map<String, String> paramMap, User currentuser){
        String objectName = paramMap.get('objectName');
        String apiname= paramMap.get('apiname');
        String gliapiname= paramMap.get('gliapiname');
        String salesorgapiname=paramMap.get('salesorgapiname');
        
        if(objectName != 'Account' && objectName != 'Campaign')
        {
            if(obj.get(apiname)==null || obj.get(apiname)=='')
                {
                    obj.put(apiname,currentuser.Sub_Bu__c);
                }
        }
        //System.debug('gliapiname **'+gliapiname );
        //System.debug('obj.get(gliapiname)**'+obj.get(gliapiname));
        if(gliapiname != null && objectName != 'Campaign'){
            if(obj.get(gliapiname)!= null && obj.get(gliapiname) == false){
                obj.put(gliapiname,true);
                System.debug('gliapiname **'+gliapiname );
                System.debug('obj*'+obj);
            }
        }

        obj = populateSubbuContinue2(obj, paramMap, currentuser);
  
        return obj;
    }

    private static sobject populateSubbuContinue2(sobject obj, Map<String, String> paramMap, User currentuser){
        String objectName = paramMap.get('objectName');
        String apiname= paramMap.get('apiname');
        String gliapiname= paramMap.get('gliapiname');
        String salesorgapiname=paramMap.get('salesorgapiname');

        //System.debug('obj.get(gliapiname)**'+obj.get(gliapiname));
        Set<String> buSet = new Set<String>{'UKI', 'USL', 'Elite', 'LMS', 'FindLaw'};
        if(gliapiname != null && objectName == 'Campaign' && (buSet.contains(currentuser.Sub_Bu__c) ||
                isLotusUser() )){
            if(obj.get(gliapiname)!= null && obj.get(gliapiname) == false){
                obj.put(gliapiname,true);
                System.debug('gliapiname **'+gliapiname );
                System.debug('obj*'+obj);
            }
        }

        obj = populateSubbuContinue3(obj, paramMap, currentuser);

        return obj;
    }

    private static sobject populateSubbuContinue3(sobject obj, Map<String, String> paramMap, User currentuser){
        String objectName = paramMap.get('objectName');
        String apiname= paramMap.get('apiname');
        String gliapiname= paramMap.get('gliapiname');
        String salesorgapiname=paramMap.get('salesorgapiname');

        if(objectName == 'Lead' && salesorgapiname != null){
            obj.put(salesorgapiname,currentuser.Sales_Org__c);
        } 
        
        if(objectName == 'Case' && salesorgapiname != null){
            obj.put(salesorgapiname,currentuser.Sales_Org__c);
        }
        return obj;
    }
    
    public static void changerecordtypesubuonlead(Map<Id,Lead>leadNewMap,Map<Id,Lead>leadOldMap){
        System.debug('Method called@@@@');
        Set<Id> ownerLead = new Set<Id>();
        map<Id,Lead>leadusermap = new map<Id,Lead>();
        map<ID,User>userdetailmap = new map<Id,User>();
        for(Lead newLead : leadNewMap.values()){
            if(newLead.ownerId !=leadOldMap.get(newLead.id).ownerId && newLead.OwnerId.getSobjectType() != Group.SObjectType){
                System.debug('queue@@2'+ newLead.owner.type );
                System.debug('@@@@@@@@@@'+newLead.OwnerId.getSobjectType());
                ownerLead.add(newLead.ownerId);
                leadusermap.put(newLead.id,newLead);
            }
        }
        System.debug('Lead usermap @@@@@' + leadusermap);
        if(leadusermap.size()>0){
            for (User usersobj : [SELECT Id,Sub_Bu__c,Sales_Org__c, Segment__c FROM User WHERE Id IN :ownerLead])
            {
                userdetailmap.put(usersobj.Id,usersobj);
            }
            System.debug('Userdetailmap@@@@@'+ userdetailmap);
        }
        changerecordtypesubuonleadContinue(leadusermap, userdetailmap);
    }

    private static void changerecordtypesubuonleadContinue(map<Id,Lead> leadusermap, map<ID,User> userdetailmap){
        if(leadusermap.size()>0){
            for(Lead obj : leadusermap.values()){
                User userobj=userdetailmap.get(obj.ownerid);
                //obj.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(userobj.Sub_Bu__c).getRecordTypeId();
                /*if(userobj.Sub_Bu__c != null && userobj.Sub_Bu__c !=''){
                    RecordTypeInfo recordtypeobj=Schema.SObjectType.Lead.getRecordTypeInfosByName().get(userobj.Sub_Bu__c);
                    if(recordtypeobj != null){
                    obj.LCRM_Sub_BU__c = userobj.Sub_Bu__c;
                    obj.recordtypeid = recordtypeobj.recordtypeid;
                    }
                }//end of if
                System.debug('Code excuted@@@@@@@@'); */
                if(userobj.Sub_Bu__c == 'UKI'){
                    obj.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('UKI').getRecordTypeId();
                    obj.LCRM_Sub_BU__c = userobj.Sub_Bu__c;
                    obj.Sales_Org__c=userobj.Sales_Org__c;
                    obj.Is_GLI__c=true;   
                }else if(userobj.Sub_Bu__c == 'Elite'){
                    obj.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite').getRecordTypeId();
                    obj.LCRM_Sub_BU__c = userobj.Sub_Bu__c;
                    obj.Sales_Org__c= userobj.Sales_Org__c;
                    obj.Is_GLI__c=true;
                }
                //Start :  added for R4 functionality
                else if(userobj.Sub_Bu__c == 'USL' || userobj.Sub_Bu__c == 'FindLaw' || userobj.Sub_Bu__c == 'LMS'){
                    obj.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
                    obj.LCRM_Sub_BU__c = userobj.Sub_Bu__c;
                    obj.Sales_Org__c= userobj.Sales_Org__c;
                    obj.Is_GLI__c=true;
                }
                else{
                    obj = changerecordtypesubuonleadContinue1(obj, userobj);
                }
                System.debug('obj**'+obj);
            }
            system.debug('=== TA == Leadusermap: ' + leadusermap);
        }
    }

    private static Lead changerecordtypesubuonleadContinue1(Lead obj, User userobj){
        //Inclusion of LOTUS user logic for Lead owner transfer
        if(userobj.Segment__c != '' && userobj.Segment__c != null){
            obj.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
            obj.Sales_Org__c= userobj.Sales_Org__c;
            obj.Is_GLI__c=true;
        }
        //End :  added for R4 functionality
        else{
            obj.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
            obj.LCRM_Sub_BU__c = userobj.Sub_Bu__c;
            obj.Sales_Org__c=userobj.Sales_Org__c;
            obj.Is_GLI__c=false;
        }
        return obj;
    }
    
    
    public static void populateKeycontactonoppty(Map<Id,Lead> newleadMap, Map<id,Lead> oldLeadMap){
        Map<ID,ID> oppToContact = new Map<ID,ID>();
        for(Lead ld: newleadMap.values()){
            if(ld.isConverted && oldLeadMap.get(ld.id).isConverted){ continue;}
            if (ld.ConvertedOpportunityId != null && ld.ConvertedContactId != null){                    
                    oppToContact.put(ld.ConvertedOpportunityId,ld.ConvertedContactID);  
                }
        }
        populateKeycontactonopptyContinue(oppToContact);
    }

    private static void populateKeycontactonopptyContinue(Map<ID,ID> oppToContact){
        List<Opportunity> lstOpp = new List<Opportunity>();
        if (!oppToContact.isEmpty()) {
                for(Opportunity opps:[select Id,AccountId,CampaignId from Opportunity where Id in :oppToContact.keySet()]){
                    if(oppToContact.containsKey(opps.id)){
                        opps.Key_Contact__c = oppToContact.get(opps.id);
                        lstOpp.add(opps);
                    }
                }
        }

        if (!lstOpp.isEmpty() && Schema.sObjectType.Opportunity.isUpdateable() ) {
            Update lstOpp;
        }
    }
    
    public static String convertedLeadStatus(String isgli){
        String convertedLeadStatusvalue ;
        ConvertedLeadStatus__c convertedLeadStatus = ConvertedLeadStatus__c.getValues(isgli);
        if(convertedLeadStatus != null){
            convertedLeadStatusvalue =convertedLeadStatus.Value__c; 
        }
        return convertedLeadStatusvalue ;
    }
    
    
    /* Description:
        Method to change the owner from queue to the user who changes the status for lead to either of the below values
        Updated: For CRM-18, to change owner when lead status is changed to disqualified.
    */
    public static void ownerChangeForGlilead(Map<Id,Lead> newleadMap, Map<id,Lead> oldLeadMap){
    
    for(Lead newLead : newleadMap.values()){
        System.debug('isgli@@'+newLead.Is_GLI__c +'@@@ownertype'+newLead.Owner.Type+'newleadstatus@@@'+newLead.Status + 'oldleadstatus@@@'+oldLeadMap.get(newLead.id).Status);
        if(newLead.Is_GLI__c == true && newLead.OwnerId.getSobjectType() == Group.SObjectType && (newLead.Status != oldLeadMap.get(newLead.id).Status) && (newLead.Status=='Sales Accepted' || newLead.Status=='Telesales Accepted' || newLead.Status=='Sales Qualified' || newLead.Status=='Disqualified')){
            system.debug('implemented@@@@@');
           newLead.OwnerID = UserInfo.getUserId();
        }
    }
    }
    
    static Boolean isSandbox = [SELECT ID, IsSandbox FROM Organization LIMIT 1].IsSandbox;
        
    //method used in strikeiron functionality to check for logged in user and disable callouts
    public static Boolean strikeIronCheckActive() {
        System.debug('isSandbox : '+isSandbox);
        LIST<String> userList= new LIST<String>();         
        SET<String> userSet= new SET<String>();
        //custom setting to store user names which will be bypassed from strikeiron functionality
        KeyValueListStore__c tempValueStore = KeyValueListStore__c.getValues('LCRMStrikeIronInformaticaUsers'); //LTS_InformaticaUsers
        if(tempValueStore !=null && tempValueStore.Failure_Email__c !=null && tempValueStore.Failure_Email__c !=''){
            userList = tempValueStore.Failure_Email__c.split('\n');
        }
        
        System.debug('userList : '+userList);
        for(String s : userList){
            userSet.add(s.trim().toLowerCase());
        }
        System.debug('userSet : '+userSet);
        
        //flag is true when logged in user is informatia user that matches name stored in custom setting
        
        System.debug(''+userSet.contains(UserInfo.getName().toLowerCase())+''+UserInfo.getName());
        Boolean loggedinUserFlag = userSet.contains(UserInfo.getName().toLowerCase());
        System.debug('loggedinUserFlag : '+loggedinUserFlag+' : '+UserInfo.getName().toLowerCase());
        
        /**** comment this line to enable StrikeIron for Informatica in Production ****/
        //isSandbox = true;
        
        Boolean strikeIronInActive = ((isSandbox && loggedinUserFlag == true) || (!isSandbox && loggedinUserFlag == true));
        system.debug('strikeIronInActive **'+strikeIronInActive );
        return strikeIronInActive;
    }
    
     public static boolean validateTaxProfUser(){
          
        Boolean flag = false;            
        Tax_Proff_GLI_Setting__c tpgs = Tax_Proff_GLI_Setting__c.getOrgDefaults();
        String subBU = tpgs.SubBU__c;
        String segment = tpgs.Segment__c ;
        //User u =[Select Id,Sub_Bu__c,Segment__c from User where Id=:userinfo.getuserId()];
        User u = LCRMGenericComponent.userObj;
        if(u.Sub_Bu__c == subBU && u.Segment__c == segment){
            flag =true;
        }
        System.debug('flag'+flag);
        return flag;  
    }
     public static boolean isLotusUser(){
        return LotusUser.getLotusUser(); 
     }
     public static Set<String> getBuRegionValues(){
       List<String> buRegionList = new List<String>();
       Set<String> buRegionValueSet=new Set<String>();
       KeyValueListStore__c buRegionValueStore = KeyValueListStore__c.getValues('LTS_BURegion_Values');
        
        if(buRegionValueStore !=null && buRegionValueStore.TextValue__c !=null && buRegionValueStore.TextValue__c !=''){
            buRegionList = buRegionValueStore.TextValue__c.split(',');
        }               
        for(String buRegion : buRegionList){            
            buRegionValueSet.add(buRegion);
        }   
       return buRegionValueSet;
  }

  @future
  private static void updateAccountRecType(Set<Id> accIdSet) {
    
    List<Account> updateAccList =  new List<Account>();
    List<Account> accList =  new List<Account>();
    if(Account.sObjectType.getDescribe().isAccessible())
    {
        accList = [ select ECM_Party_ID__c,LCRM_Is_Account_Archived__c  from Account where id in : accIdSet];
    }
    Id gliECMRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account-ECM').getRecordTypeId();
    Id gliAccountRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
    
    if (!accList.isEmpty()) {
       
        for(Account acc: accList){
            system.debug('inside method updateAccountRecType Account'+acc);
                    if(acc.ECM_Party_ID__c != null){
                        acc.recordtypeid = gliECMRecId;
                     }
                     else {
                        acc.recordtypeid = gliAccountRecId;
                     }
                     if( acc.LCRM_Is_Account_Archived__c ==true){
                         acc.LCRM_Is_Account_Archived__c =false;
                      }
                      else{
                          acc.LCRM_Is_Account_Archived__c =true;
                       }
                     updateAccList.add(acc);

                }
                system.debug('inside method updateAccountRecType'+updateAccList);
        }

        if (!updateAccList.isEmpty() && Schema.sObjectType.Account.isUpdateable() ) {
          Update updateAccList;
         }
         system.debug('inside method updateAccountRecType');
    
  }
    
    public static void checkArchiveAccountType(List<sObject> sobjectList)
    {
        Set<Id> accountIDSet = new Set<Id>();
        Set<Id> ssdIDSet = new Set<Id>();
        //Id archiveCaseRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GLI Archive Requests').getRecordTypeId();
        Id archiveCaseRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GLI_Archive_Requests').getRecordTypeId();
        if(sobjectList.size()>0){       
            String objectName= sobjectList[0].getSObjectType().getDescribe().getName();
            for(sobject sobj:sobjectList){
                if(sobj.getSObjectType().getDescribe().getName() == 'Opportunity'){
                    system.debug('inside class');
                    accountIDSet.add(((Opportunity)sobj).AccountId);
                }
                else if(sobj.getSObjectType().getDescribe().getName() == 'Contact'){
                    accountIDSet.add(((Contact)sobj).AccountId);
                }
                else if(sobj.getSObjectType().getDescribe().getName() == 'Case' && ((Case)sobj).recordtypeid!=archiveCaseRecId){
                    accountIDSet.add(((Case)sobj).AccountId);
                }
                else if(sobj.getSObjectType().getDescribe().getName() == 'Trial__c' && ((Trial__c)sobj).Source_System_Detail__c!= null){
                    ssdIDSet.add(((Trial__c)sobj).Source_System_Detail__c);
                }
            }
            checkArchiveAccountTypeContinue(ssdIDSet, accountIDSet);
        }
    }

    public static void checkArchiveAccountTypeContinue(Set<Id> ssdIDSet, Set<Id> accountIDSet){
        if(ssdIDSet.size() > 0){
            List<Source_System_Detail__c > ssdList =  new List<Source_System_Detail__c>([SELECT Account_Name__c FROM  Source_System_Detail__c where id =:ssdIDSet]);
            for (Source_System_Detail__c  ssd :ssdList)
            {
              accountIDSet.add(ssd.Account_Name__c);
            }

        }
        List<Account> accList = new List<Account>();
        Set<Id> updateAccIDSet = new Set<Id>();
        Boolean accountListSize = false;
        if(accountIDSet.Size()>0)
        {
             system.debug('inside class1');
             accList  = new List<Account>([select Id,recordtype.Name, Is_GLI__c from Account where ID=:AccountIdSet]);
        }
        if(!accList.isEmpty())
        {
            accountListSize = true;
        }else{
            return;
        }

        for (Account acc : accList)
        {   
            if(acc.Is_GLI__c == TRUE && acc.recordtype.Name == 'GLI Archive')
            {
                system.debug('inside class3');
                updateAccIDSet.add(acc.id);
            }
        }
        
        if(!updateAccIDSet.isEmpty()){
            system.debug('inside class4'+updateAccIDSet);
            updateAccountRecType(updateAccIDSet);
        }
    }
       //Check whether the contentDocumentLink assigned to Archived Account or Not
    public static void onAfterInsertContentDocuLink(Boolean isInsert,Boolean isAfter, Map<id, ContentDocumentLink> cdLinkMap)
    {
        //Variable Declaration
        set<Id> ssdIDSet = new Set<Id>();
        set<Id> accountIDSet= new set<Id>();
        //Checking Exclusion Framework
        if(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){return;}
        if(isInsert && isAfter){
        
            for (ContentDocumentLink cdlk : cdLinkMap.values()) 
            {
                //Checking whether the object is Account or not
                string cdlId = cdlk.LinkedEntityId;
                if (cdlId.startsWith('001')) {
                    //Collecting all the Account IDs
                    accountIDSet.add(cdlk.LinkedEntityId);
                }
            }
            
            if(accountIDSet!= null){
                        checkArchiveAccountTypeContinue(ssdIDSet, accountIDSet);
            }
        }
    }
   
     //get Content  and related Lins to collet Account Ids
    @testVisible
    private static Map<Id, ContentDocument> getContentDocumentwithLinks(Set<Id> contentDocuIds){
        Map<Id, ContentDocument> mapCD = new Map<Id, ContentDocument>();
        if(contentDocuIds != null && Schema.sObjectType.ContentDocument.isAccessible()){
            mapCD = new Map<Id, ContentDocument>(
                    [Select Id, FileType,Title, (select LinkedEntityId,ContentDocumentId FROM ContentDocumentLinks) 
                    from ContentDocument where Id in: contentDocuIds]);
        }
        return mapCD;    
    }
    
     //Check whether the contentDocument assigned to Archived Account or Not
    public static void onAfterInsertContentDocument(Boolean isInsert,Boolean isAfter, Map<id, ContentDocument> cdNewmap)
    {
        //Variable Declaration
        set<Id> ssdIDSet = new Set<Id>();
        set<Id> accountIDSet= new set<Id>();
        //Checking Exclusion Framework
        if(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){return;}
        if(isInsert && isAfter && Schema.sObjectType.ContentDocument.isAccessible()){
            Map<Id, ContentDocument> mapCD = getContentDocumentwithLinks(cdNewmap.keyset()); 
            
             for(ContentDocument cdd : mapCD.values()){
                     for(ContentDocumentLink cdlink: mapCD.get(cdd.Id).ContentDocumentLinks){
                        //get only Account related Ids
                        if(String.valueOf(cdlink.LinkedEntityId).startsWith('001')){
                            accountIDSet.add(cdlink.LinkedEntityId);
                        }
                  }
           
              }
         if(accountIDSet!= null){
                        checkArchiveAccountTypeContinue(ssdIDSet, accountIDSet);
            }
        }
    }
   

}