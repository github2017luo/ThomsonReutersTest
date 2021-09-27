/*
This Class is used to on-demand share Opportunities & Activities
 
Name             Description                                        Date
-----------------------------------------------------------------------------------
Samarpreet      Changes to user redirect for Lightning Page    15-Feb-2019
Surendra Kamma	commented this class as part of DPS-14173	   29-May-2020


--------------------------------------------------------------------------------------------
*/

global without sharing class LCRMOnDemandShare
{
     // Added this method to cover the code in test class: DPS-14173.
    global LCRMOnDemandShare(){}
    /* START: DPS-14173 - Commented this Class.
    public string strObjId;
    public string strAccId;
    public string strConId;
    public LCRMOnDemandShare() 
    {
        String strParams = ApexPages.currentPage().getParameters().get('urlparm');
        Map<String, String> UrlParameterMap = ApexPages.currentPage().getParameters();
        if (UrlParameterMap.containsKey('Id'))
            strObjId = UrlParameterMap.get('Id');
        if(strObjId.mid(0, 3)== '001'){
            strAccId = strObjId;
        }else if(strObjId.mid(0, 3)== '003'){
            strConId = strObjId;
        }
        //system.Debug ('@@@@@ strObjId : ' + strObjId);
        system.Debug ('@@@@@ strAccId : ' + strAccId);
        //system.Debug ('@@@@@ strConId : ' + strConId);
        
    } 
    
    public PageReference ShareAcctChildRecords()
    {
        ID idUsr = UserInfo.getUserId();
        List <Opportunity> Opptys;
            if(strAccId != null){
                Opptys = [SELECT Id, Name FROM Opportunity WHERE AccountId = :strAccId];
            }else if(strConId != null){
                Opptys = [SELECT Id, Name FROM Opportunity WHERE Key_Contact__c = :strConId];
            }
        List<OpportunityShare> osharesExist = new List<OpportunityShare>([SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel  FROM OpportunityShare WHERE OpportunityId = :Opptys]);
        List<OpportunityShare> osharesToCreate = new List<OpportunityShare>();               
        try{
            Boolean bExists = false;
            for (Opportunity oppty : Opptys) {
                bExists = false;                    
                for (OpportunityShare ose : osharesExist){
                    if (ose.OpportunityId == oppty.Id && ose.UserOrGroupId == idUsr){
                        bExists = true;
                        break;
                    }                                           
                }
                if (bExists)
                    continue;
                else{     
                    OpportunityShare os = new OpportunityShare();
                    os.OpportunityAccessLevel = 'Read';
                    os.OpportunityId = oppty.Id;
                    os.UserOrGroupId =  idUsr;
                    osharesToCreate.add(os);
                }                        
            }
            for (OpportunityShare o : osharesToCreate)
                System.Debug('Share : ' + o);
            Database.SaveResult[] dr;                    
            if (osharesToCreate.size() > 0)
                dr = DataBase.insert(osharesToCreate);
            System.Debug('Share Size : ' + osharesToCreate.size() + dr);    
            
            ShareCases();
            ShareLeads();
            ShareTrainingEvents();
            ShareSSD();
           
        }Catch(exception e){
            apexpages.addmessages(e);
        }
        system.Debug ('strAccId : ' + strAccId);
        String theme=getContextUserUiThemeDisplayed();
        PageReference pageDetail;
        if(strAccId != null){
        if(theme=='Theme4d')
        pageDetail =new PageReference('/lightning/r/Account/' + strAccID +'/view');
        else
            pageDetail = new PageReference('/apex/AccountDetail?id=' + strAccId + '&sfdc.override=1');
        }
        else if(strConId != null){
            pageDetail = new PageReference('/' + strConId);
        }
        return pageDetail;
                       
    }
   
    public void ShareCases()
    {
        
        ID idUsr = UserInfo.getUserId();
        List <Case> Cases;
        
        if(strAccId != null){
        Cases= [SELECT Id FROM Case WHERE AccountId = :strAccId];
        }else if(strConId != null){
        Cases= [SELECT Id FROM Case WHERE ContactId = :strConId];
        }
        List<CaseShare> csharesExist = new List<CaseShare>([SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel  FROM CaseShare WHERE CaseId = :Cases]);
        List<CaseShare> csharesToCreate = new List<CaseShare>();               

        Boolean bExists = false;
        for (Case ocase: Cases) 
        {
            bExists = false;                    
            for (CaseShare cse : csharesExist)
            {
                if (cse.CaseId == ocase.Id && cse.UserOrGroupId == idUsr)
                {
                    bExists = true;
                    break;
                }                                           
            }
            
            if (bExists)
                continue;
            else
            {     
                CaseShare cs = new CaseShare();
                cs.CaseAccessLevel = 'Read';
                cs.CaseId = ocase.Id;
                cs.UserOrGroupId =  idUsr;
                csharesToCreate.add(cs);
            }                        
        }
        
        for (CaseShare c : csharesToCreate)
            System.Debug('Share : ' + c);

        Database.SaveResult[] dr;                    
        if (csharesToCreate.size() > 0)
            dr = DataBase.insert(csharesToCreate);
                       
        System.Debug('Share Size : ' + csharesToCreate.size() + dr);    

        return;                
    }
    
    public void ShareLeads()
    {
        ID idUsr = UserInfo.getUserId();
        List <Lead> Leads;
        if(strAccId != null){
        Leads= [SELECT Id FROM Lead WHERE Account__c = :strAccId];
        }
        if(strConId != null){
        Leads= [SELECT Id FROM Lead WHERE Contact__c = :strConId];
        }
        List<LeadShare> lsharesExist = new List<leadShare>([SELECT Id, LeadId, UserOrGroupId, LeadAccessLevel  FROM LeadShare WHERE LeadId = :Leads]);
        List<LeadShare> lsharesToCreate = new List<LeadShare>();               

        Boolean bExists = false;
        for (Lead olead: Leads) 
        {
            bExists = false;                    
            for (Leadshare lse : lsharesExist)
            {
                if (lse.LeadId == olead.Id && lse.UserOrGroupId == idUsr)
                {
                    bExists = true;
                    break;
                }                                           
            }
            
            if (bExists)
                continue;
            else
            {     
                Leadshare ls = new Leadshare();
                ls.LeadAccessLevel = 'Read';
                ls.LeadId = olead.Id;
                ls.UserOrGroupId =  idUsr;
                lsharesToCreate.add(ls);
            }                        
        }
        
        for (Leadshare l : lsharesToCreate)
            System.Debug('Share : ' + l);

        Database.SaveResult[] dr;                    
        if (lsharesToCreate.size() > 0)
            dr = DataBase.insert(lsharesToCreate);
                       
        System.Debug('Share Size : ' + lsharesToCreate.size() + dr);    

        return;                
    }
    
    public void ShareTrainingEvents()
    {
        ID idUsr = UserInfo.getUserId();
        List <Training_Event__c> trainingEvents;
        
        if(strAccId != null){
        trainingEvents = [SELECT Id FROM Training_Event__c WHERE Account__c = :strAccId];
        }else if(strConId != null){
        trainingEvents = [SELECT Id FROM Training_Event__c WHERE LCRM_Primary_Contact__c = :strConId];
        }
        List<Training_Event__Share> tesharesExist = new List<Training_Event__Share>([SELECT Id, ParentId, UserOrGroupId, AccessLevel  FROM Training_Event__Share WHERE ParentId = :trainingEvents]);
        List<Training_Event__Share> tesharesToCreate = new List<Training_Event__Share>();               

        Boolean bExists = false;
        for (Training_Event__c ote: trainingEvents) 
        {
            bExists = false;                    
            for (Training_Event__Share tese : tesharesExist)
            {
                if (tese.ParentId == ote.Id && tese.UserOrGroupId == idUsr)
                {
                    bExists = true;
                    break;
                }                                           
            }
            
            if (bExists)
                continue;
            else
            {     
                Training_Event__Share tes = new Training_Event__Share();
                tes.AccessLevel = 'Read';
                tes.ParentId = ote.Id;
                tes.UserOrGroupId =  idUsr;
                tesharesToCreate.add(tes);
            }                        
        }
        
        for (Training_Event__Share te : tesharesToCreate)
            System.Debug('Share : ' + te);

        Database.SaveResult[] dr;                    
        if (tesharesToCreate.size() > 0)
            dr = DataBase.insert(tesharesToCreate);
                       
        System.Debug('Share Size : ' + tesharesToCreate.size() + dr);    

        return;                
    }
   
    // As part of Filtered Account Team View (by Sub-BU) CRM-8672
   public void ShareSSD()
    {
         ID idUsr = UserInfo.getUserId();
        List <Source_System_Detail__c> lstSourceSystemDetail;
        //List <LCRM_Contact_SSD__c> contactssd;
        
        if(strAccId != null){
        lstSourceSystemDetail = [SELECT Id,Account_Name__r.Name,LCRM_Sub_BU__c FROM Source_System_Detail__c WHERE Account_Name__c= :strAccId ];
       
        }        
        //List<Source_System_Detail__Share> SSDsharesExist = new List<Source_System_Detail__Share>([SELECT Id, ParentId, UserOrGroupId, AccessLevel  FROM Source_System_Detail__Share WHERE ParentId =:lstSourceSystemDetail]);
        Map<Id, Source_System_Detail__Share> SSDsharesExist = new Map<Id, Source_System_Detail__Share>([SELECT Id, ParentId, UserOrGroupId, AccessLevel  FROM Source_System_Detail__Share WHERE ParentId =:lstSourceSystemDetail]);
        List<Source_System_Detail__Share> SSDsharesToCreate = new List<Source_System_Detail__Share>();
         //Boolean bExists = false;
          for(Source_System_Detail__c oSSD:lstSourceSystemDetail) 
        {          
            if(SSDsharesExist != null && SSDsharesExist.containsKey(oSSD.Id) && SSDsharesExist.get(oSSD.Id).UserOrGroupId == idUsr)
                continue;
                
               else{                 
                Source_System_Detail__Share ssd = new Source_System_Detail__Share ();
                ssd.AccessLevel= 'Read';
                ssd.ParentId= oSSD.Id;
                ssd.UserOrGroupId =  idUsr;
                SSDsharesToCreate.add(ssd);
              }                      
        }  
         
        try{
        Database.SaveResult[] dr;                    
        if(SSDsharesToCreate.size() > 0)
            dr = DataBase.insert(SSDsharesToCreate);
                       
        System.Debug('@@SSDshares ToCreate : ' + SSDsharesToCreate.size() + dr); 
        }Catch(exception e){}
                       
    }       
    
    public PageReference RemoveShareAcctChildRecords ()
    {
        ID idUsr = UserInfo.getUserId();
        
        //START deleting Opportunity Share.
        List <Opportunity> Opptys;
            if(strAccId != null){
                Opptys = [SELECT Id, Name FROM Opportunity WHERE AccountId = :strAccId];
            }else if(strConId != null){
                Opptys = [SELECT Id, Name FROM Opportunity WHERE Key_Contact__c = :strConId];
            }   
        List<OpportunityShare> osharesExist ;
        if(Opptys != null){
            osharesExist = new List<OpportunityShare>([SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel  FROM OpportunityShare WHERE OpportunityId = :Opptys and UserOrGroupId =:idUsr and rowcause = 'manual']);
        }
        Database.DeleteResult[] drOpp; 
        if (osharesExist!= null && osharesExist.size() > 0){             
        drOpp = DataBase.delete(osharesExist);
        System.debug('***drOpp: '+drOpp);
        }
        
        //START deleting Case Share.
        List <Case> Cases;
        if(strAccId != null){
            Cases= [SELECT Id FROM Case WHERE AccountId = :strAccId];
        }else if(strConId != null){
            Cases= [SELECT Id FROM Case WHERE ContactId = :strConId];
        }
        List<CaseShare> csharesExist;
        if(Cases != null){
            csharesExist = new List<CaseShare>([SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel  FROM CaseShare WHERE CaseId = :Cases and UserOrGroupId =:idUsr and rowcause = 'manual']);
        }
        Database.DeleteResult[] drCase;
        if (csharesExist!= null && csharesExist.size() > 0){               
            drCase = DataBase.delete(csharesExist);
            System.debug('***drCase: '+drCase);
        }
        
        
        //START deleting Lead Share.
        List <Lead> Leads;
        if(strAccId != null){
            Leads= [SELECT Id FROM Lead WHERE Account__c = :strAccId];
        }
        if(strConId != null){
            Leads= [SELECT Id FROM Lead WHERE Contact__c = :strConId];
        }
        List<LeadShare> lsharesExist;
        if(Leads != null){
            lsharesExist = new List<LeadShare>([SELECT Id, LeadId, UserOrGroupId, LeadAccessLevel  FROM LeadShare WHERE LeadId = :Leads and UserOrGroupId =:idUsr and rowcause = 'manual']);
        }
        Database.DeleteResult[] drLead;
        if (lsharesExist!= null && lsharesExist.size() > 0){               
            drLead = DataBase.delete(lsharesExist);
            System.debug('***drLead: '+drLead);
        }
        
        //START deleting Training Event Share.
        List <Training_Event__c> trainingEvents;
        if(strAccId != null){
            trainingEvents = [SELECT Id FROM Training_Event__c WHERE Account__c = :strAccId];
        }else if(strConId != null){
            trainingEvents = [SELECT Id FROM Training_Event__c WHERE LCRM_Primary_Contact__c = :strConId];
            System.debug('***trainingEvents: '+ trainingEvents);
        }
        List<Training_Event__Share> tesharesExist;
        if(trainingEvents != null){
            tesharesExist = new List<Training_Event__Share>([SELECT Id, ParentId, UserOrGroupId, AccessLevel  FROM Training_Event__Share WHERE ParentId = :trainingEvents and UserOrGroupId =:idUsr and rowcause = 'manual']);
                System.debug('***tesharesExist: '+ tesharesExist);
        }
        Database.DeleteResult[] drTrainingEvent;
        if (tesharesExist!= null && tesharesExist.size() > 0){               
            drTrainingEvent = DataBase.delete(tesharesExist);
            System.debug('***drTrainingEvent: '+drTrainingEvent);
        }
        
        // As part of Filtered Account Team View (by Sub-BU) CRM-8672
             //START deleting Source System Detail Share.
        List <Source_System_Detail__c> SourceSystemDetails;
        if(strAccId != null){
            SourceSystemDetails = [SELECT Id FROM Source_System_Detail__c WHERE Account_Name__c= :strAccId];
             System.debug('***SourceSystemDetails: '+ SourceSystemDetails);
          }
        List<Source_System_Detail__Share> SsdsharesExist;
        if(SourceSystemDetails != null){
           SsdsharesExist= new List<Source_System_Detail__Share >([SELECT Id, ParentId, UserOrGroupId, AccessLevel  FROM Source_System_Detail__Share  WHERE ParentId = :SourceSystemDetails and UserOrGroupId =:idUsr and rowcause = 'manual']);
           System.debug('***SsdsharesExist: '+ SsdsharesExist);
          
        }
        Database.DeleteResult[] drSourceSystemDetail;
        if (SsdsharesExist!= null && SsdsharesExist.size() > 0){               
            drSourceSystemDetail = DataBase.delete(SsdsharesExist);
            System.debug('***drSourceSystemDetail: '+drSourceSystemDetail);
        }
        
        PageReference pageDetail;
        String theme=getContextUserUiThemeDisplayed();
        if(strAccId != null){
        if(theme=='Theme4d'){
        pageDetail =new PageReference('/lightning/r/Account/' + strAccID +'/view');
        }
        else{
            pageDetail = new PageReference('/apex/AccountDetail?id=' + strAccId + '&sfdc.override=1');
        }
        }
        else if(strConId != null){
            pageDetail = new PageReference('/' + strConId);
        }
        return pageDetail;
                       
    } 
    
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    } 
  	END: DPS-14173 - Commented this Class. */              
}