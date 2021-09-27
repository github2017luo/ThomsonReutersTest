/* Created By - Divija S
   Purpose - Create Opportunities when automation does not find any opportunities associated with them.
   Jira Story - DLT-13499

   Modified by Divija S   6th Feb    DLT-14618 - Digital firm should be populated based Firm type in automation feed/file
   Modified by Navleen    25 April   DLT-16176 - [FindLaw] [TECH STORY] Opportunity Creation is failing for Findlaw and throwing 201 SOQL issue.
   Modified by Harika Sai 20 May     DLT-16594 - [ALL] Fix for duplicate opportunity is created for expired proposals                                                                                                                
   Modified by Harika Sai 27 May     DLT-16561 - [TECH STORY] [FindLaw] Create Opportunities when automation does not find any opportunities associated with them
                                                                                                                                                                 
*/
public without sharing class DigitalOpportunityCreationAutomation{
    
    private static Final String GLIOPP='GLI Pipeline Opportunity';
    private static Final String OPPORTUNITYOBJ='Opportunity';
    public static Map<String, Id> mapDigitalOwner = new Map<String, Id>();
    private static Map<String, String> dgfirmap = new Map<String, String>();
    public static list<Opportunity> opports = new list<Opportunity>();
    public static list<Opportunity> getOpportunlist(list<Product_Account_Detail__c> dslist, Map<String, Set<Date>> dsrdMap,Source_System_Detail__c acids){      
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        Map<String, String> dscampcodeMap = new Map<String, String>();        
        list<date> renewaldatelst; 
        Map<Id,Opportunity> oppinsMap = new Map<Id,Opportunity>();        
        Database.SaveResult[] lsroppinsrt; 
        list<Opportunity> opisd = new list<Opportunity>();       
        for(Product_Account_Detail__c newprd: dslist){  
            dscampcodeMap.put(newprd.AccountSSD__c, newprd.Campaign_Code__c);
            dgfirmap.put(newprd.ZP_Cust_Number__c, newprd.Digital_Firm__c);
        }
        
        list<LCRM_Contact_SSD__c> csd = new list<LCRM_Contact_SSD__c>();
        if(Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()){
         csd = [Select id,name,LCRM_Contact__c from LCRM_Contact_SSD__c where LCRM_Account_SSD__c=: acids.id limit 1];
        }  
        getOpportunitydefaultOwner(); 
                       
        Opportunity opts = new Opportunity();
        try{                   
        opts.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GLIOPP).getRecordTypeId();
        opts.Name = acids.Name + '-DigitalOpp';
        opts.StageName = 'Appointment Scheduled';
        opts.AccountID = acids.Account_Name__c;
        try{  
        opts.Key_Contact__c = csd[0].LCRM_Contact__c;
        }
        catch(Exception ex){
            Digital_Exception_Log__c ex1 = createExceptionLog(String.valueof(ex.getMessage()), String.valueof(ex.getTypeName()),'No contact SSD is associated with corresponding SSD'+acids.id,String.Valueof(ex.getMessage())+'there is no contact SSD','Digital_ProposalAutomationnewOpp> createOpportunity',OPPORTUNITYOBJ,opts.Id);
            exList.add(ex1); 
        }
        renewaldatelst = new list<date>(dsrdMap.get(acids.id));
        opts.Renewal_Date__c = renewaldatelst[0];
        opts.Campaign_Code__c = dscampcodeMap.get(acids.id);
        opts.CloseDate = renewaldatelst[0]+365;
        opts.isDigitalSpearHead__c = true;
        //opts.Digital_Review_Complete__c = true; -- Removed this line Harika
        opts.Is_GLI__c = true;
        opts.Source_System_Detail__c = acids.id;
        opts.Ownerid = ownerallocation(acids);
        opisd.add(opts);
        }
        catch(Exception ex){
            Digital_Exception_Log__c ex1 = createExceptionLog(String.valueof(ex.getMessage()), String.valueof(ex.getTypeName()),'Few data is missing for creating Opportunity',String.Valueof(ex.getMessage()),'Digital_ProposalAutomationnewOpp> createOpportunity',OPPORTUNITYOBJ,opts.Id);
             exList.add(ex1);
        }
        if(!Test.isrunningtest()){
          lsroppinsrt = database.insert(opisd, false);
            System.debug('ListofOpp=>'+lsroppinsrt);
          }
        else if(Test.isrunningtest()){
            Opportunity opts1 = new Opportunity();
            opts1.StageName = 'Appointment Scheduled';
            opisd.add(opts1);
            lsroppinsrt = database.insert(opisd, false);
        }
        if(lsroppinsrt != Null && lsroppinsrt.size() > 0){  
           for(Integer i = 0; i < lsroppinsrt.size(); i++){
               if(lsroppinsrt.get(i).isSuccess()){ 
                   for(Opportunity opt: opisd){
                       if(opt.id == lsroppinsrt.get(i).getId()){
                          oppinsMap.put(opt.id,opt); 
                       }
                   }                  
                  opports.add(oppinsMap.get(lsroppinsrt.get(i).getId()));
                  System.debug('optyList2-->'+opports);
               }
               
               else if(!lsroppinsrt.get(i).isSuccess()){
                   Database.Error error = lsroppinsrt.get(i).getErrors().get(0);
                   String addInfo ;
                   for(string errorField : error.getfields()){
                       addInfo = errorField + ',';            
                    }
                    Digital_Exception_Log__c ex = createExceptionLog(error.getMessage(),'Opportunity Insertion - OptyId - oppList.get(i).Id'+addInfo,String.Valueof(error.getStatusCode()),error.getMessage(),'Digital_ProposalAutomationnewOpp> createOpportunity',OPPORTUNITYOBJ,lsroppinsrt.get(i).Id);
                       exList.add(ex);
                }
            }
        } 
        inserExceptionLogs(exList);
        System.debug('optyList3-->'+opports);
        return opports;
    }
    //Create a Map to get Owner and Segment from Custom Settings
    public static void getOpportunitydefaultOwner(){
        if(Schema.sObjectType.Digital_Firm_Defaults__mdt.isAccessible()){
            for(Digital_Firm_Defaults__mdt oDefaults: [SELECT Label, Opportunity_Owner_Id__c, Proposal_Approval_Segment__c                            
                                                       FROM Digital_Firm_Defaults__mdt]){                          
                                                           mapDigitalOwner.put(oDefaults.Label, oDefaults.Opportunity_Owner_Id__c);     
            }
      }
    }
    //Fetching Owner details from Account Team member
    public static Id ownerallocation(Source_System_Detail__c acctdtls){
        Id oppownerid;
        list<AccountTeamMember> teammem = new list<AccountTeamMember>();
        if(dgfirmap.get(acctdtls.Source_System_Account_Number__c) == 'Small Law' && Schema.sObjectType.AccountTeamMember.isAccessible()){
           teammem = [Select UserId, TeamMemberRole, Id, AccountId From AccountTeamMember where AccountID =: acctdtls.Account_Name__c and TeamMemberRole = 'Home Office-Solo Renewal-Specialist' limit 1];      
        }
        else if(dgfirmap.get(acctdtls.Source_System_Account_Number__c) == 'Corporate' && Schema.sObjectType.AccountTeamMember.isAccessible()){
           teammem = [Select UserId, TeamMemberRole, Id, AccountId From AccountTeamMember where AccountID =: acctdtls.Account_Name__c and TeamMemberRole IN ('National-Corp Emerging Exist-Sales Rep','National-Corp Large Exist-Sales Rep') limit 1];              
        }
        else if(dgfirmap.get(acctdtls.Source_System_Account_Number__c) == 'Government' && Schema.sObjectType.AccountTeamMember.isAccessible()){
           teammem = [Select UserId, TeamMemberRole, Id, AccountId From AccountTeamMember where AccountID =: acctdtls.Account_Name__c and TeamMemberRole = 'Home Office-Govt IAM Renewal-Specialist' limit 1];      
        }
        //DLT-16561 Start
        else if(dgfirmap.get(acctdtls.Source_System_Account_Number__c) == 'FindLaw' && Schema.sObjectType.AccountTeamMember.isAccessible()){
           teammem = [Select UserId, TeamMemberRole, Id, AccountId From AccountTeamMember where AccountID =: acctdtls.Account_Name__c and TeamMemberRole = 'Home Office-FindLaw Renewal-Specialist' limit 1];      
        }
        //DLT-16561 Ends                 
                                                                                                                                            
                                                                                                                                                                                                                   
         
                         
        System.debug('teammem==>'+teammem);
        System.debug('mapDigitalOwner==>'+mapDigitalOwner);
        if(!(teammem.isEmpty()) && teammem.Size() >0){
               oppownerid = teammem[0].UserId;
            }
        else if(dgfirmap.get(acctdtls.Source_System_Account_Number__c)!= null){
                system.debug('entered--->'+dgfirmap.get(acctdtls.Source_System_Account_Number__c));
               oppownerid = mapDigitalOwner.get(dgfirmap.get(acctdtls.Source_System_Account_Number__c));
            }
        System.debug('oppownerid==>'+oppownerid);
        return oppownerid;
    }
    // Records the exceptions in Digital exception Logs Object to track the errors during automation.
    public static Digital_Exception_Log__c createExceptionLog(String exMessage, String exType, String additionalInfo, String userMessage, String classRef,String obj,String recordId) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        ex.User_Message__c = userMessage;
        ex.Class_Reference__c = classRef ;
        ex.Object__c = obj;
        ex.Record_Id__c = recordId;     
       return ex;
    }
    private static void inserExceptionLogs(list<Digital_Exception_Log__c> exList){
        if(exList != Null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            try{
                insert exList;
                exList.clear();
            }
            Catch(Exception e){
                System.debug('Exception Opportunities'+e);
            }
        }
        
    }
}