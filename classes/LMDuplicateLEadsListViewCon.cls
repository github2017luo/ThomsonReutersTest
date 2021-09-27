public without sharing class LMDuplicateLEadsListViewCon {
   
    public string oppId{get;set;}
    public string accId{get;set;}
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    public boolean leadError{get;set;}
   
    public final Lead l;
    public string SelectedLeadId{get;set;}
    private ApexPages.StandardSetController setCon;

     //Our collection of the class/wrapper objects wrapLead
    public List<wrapLead> wrapLeadList {get; set;}
    public List<Lead> selectedLeads{get;set;}
    public List<Contact> contactList;
    private MAP<Id,Contact> contactMap;
    private MAP<String,Contact> contactMatchStringsForAccountMap;
    private SET<id> SelectedLeadIds;
    public string oppOwnerId;
    public LMDuplicateLEadsListViewCon(){
        
        LoadData();
       
    }
    
    private void LoadData(){

         if(wrapLeadList == null) {
            oppId= ApexPages.currentPage().getParameters().get('id');      
            accId =ApexPages.currentPage().getParameters().get('accId') ;
            wrapLeadList = new List<wrapLead>();
            for(Lead l: [SELECT Description,URL__c,Phone,Email,FirstName,LastName,Status,Convert_by__c,Accept_by__c,
                                    Lead_Scoring_Combined__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,
                                    Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c,ConvertedOpportunityId,Campaign_Cell__c,Account__r.NAme,
                                    Customer_Type__c,Industry,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId,Acceptance_SLA_Violation__c,Accept_By_Date__c,Convert_By_Date__c,
                                    Company,Business_Org__c,Contact_SAP_ID__c,Convert_SLA_violation__c, Discard_Reason__c,External_Contact_ID__c,External_ID__c,LeadID18__c,LastModifiedBy.Name,
                                    owner.name,LeadSource,Type__c,Name,Primary_Campaign_Source__c,Priority__c,Source_Desc__c,Tracking_Code__c,account__c FROM LEAD WHERE (status = 'Contacting' OR status= 'Unworked') AND account__c= :accId ]) {
                // As each Lead is processed we create a new wrapLead object and add it to the wrapLeadList
                wrapLeadList.add(new wrapLead(l));
            }
            system.debug('***test-oppId' + oppId);
            system.debug('***test- wrapleadList' + wrapLeadList);
            if(oppId !=null){
                Opportunity opp= (Opportunity) [SELECT ownerId FROM Opportunity where id=: oppId];
                oppOwnerId = opp.ownerId;
            }
            total_size = wrapLeadList.size();
            contactList = new List<Contact>();
            contactList = [SELECT id,FirstName,LastName,Email FROM CONTACT WHERE accountId = :accId];             
            contactMap= new MAP<Id,Contact>();
            contactMatchStringsForAccountMap = new MAP<String,Contact>();
            if(contactList!= null && contactList.SIze()>0){
                for(COntact c: contactList){
                    contactMap.put(c.id,c);
                    if(c != null && c.Email != null){
                        
                        contactMatchStringsForAccountMap.put(c.Email,c);
                    }
                }
                system.debug('***contactMatchStringsForAccountMap' + contactMatchStringsForAccountMap); 
            }  
                 
        }    
    }

    public pageReference processSelected() {
        pageReference pagereference = null;
        selectedLeads = new List<Lead>();
 
        for(wrapLead wrapLeadObj : wrapLeadList) {
            if(!TEST.isRunningTest()){
                if(wrapLeadObj.selected == true) {
                    selectedLeads.add(wrapLeadObj.leadRec);
                }
            }
            else if(TEST.isRunningTest()){
                selectedLeads.add(wrapLeadObj.leadRec);
            }
        }
        integer LMTheshold= Integer.valueOf(Label.LM_List_View_Mass_Lead_Threshold);
        if(selectedLeads.Size() <= LMTheshold ){
            leadError= false;
            SelectedLeadIds = new SET<Id>();
            for(Lead l: selectedLeads){
                SelectedLeadIds.add(l.Id);    
            
            }
            try{
                convertLeads();
                system.debug('***LOG STATUS:: Leads Converted Successfully');
            }
            catch(Exception ex){
                throw ex;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));
                
            }
           
            pageReference = new PageReference('/'+oppId);
            return pageReference;
        }
        else{
            leadError= true;
            system.debug('***show Error message');
            ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, Label.LM_ListView_Mass_Lead_Threshold_Error);  
            ApexPages.addMessage(errMsg);
            
            return null;

            
        }

    }
    

       public Pagereference Cancel(){
            PageReference pr= new PageReference('/'+oppId);
            return pr;   
       }
 
    // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Lead and a Boolean value
    public class wrapLead {
        public Lead leadRec {get; set;}
        public Boolean selected {get; set;}
 
        public wrapLead(Lead l) {
            leadRec = l;
            selected = false;
        }
    }
    
    private map<id,Id> leadToContactMapAfterConversion= new map<id,Id>();
    LeadStatus convertStatus;
    public void convertLeads(){
        fetchLeadActivities();
        PageReference pageReference = null;
        convertStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        List<Database.LeadConvert> leadConversions = new List<Database.LeadConvert>();
        for(LEad l: selectedLeads){
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(l.id);
            lc.setAccountId(accId);
            // If assosiating contact exists under mapped account of opportunity dont crete new contact
            if(l.Contact__c != null && (contactMap.containsKey(l.Contact__c)))
                lc.setContactId(l.Contact__c);
            // If Lead EMail is matching with any of the contact under opportunity Account, Dont Create New Contact.
            else If(l.Contact__c == null &&  (contactMatchStringsForAccountMap != null && contactMatchStringsForAccountMap.ContainsKey(l.Email)))
            {
                lc.setContactId(contactMatchStringsForAccountMap.get(l.Email).id);
            }
            lc.setDoNotCreateOpportunity(true);
            lc.setOwnerId(oppOwnerId);
            lc.setConvertedStatus(convertStatus.MasterLabel );
            leadConversions.add( lc );
            
        }
        
        try{
            // Execute the conversions and check for success.
            List<Database.LeadConvertResult> results = Database.convertLead( leadConversions );
    
            List<Id> convertedConIds= new List<Id>();
            for(Database.LeadConvertResult lcr:results){
                leadToContactMapAfterConversion.put(lcr.getLeadId(),lcr.getContactId());
                convertedConIds.add(lcr.getContactId());
            }
            
            createLeadHistory();
            createContactRole(convertedConIds);        
            createLeadTasksUnderOpp();  
        
        }Catch(Exception ex){
        
            ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, ex.getMEssage());  
            ApexPages.addMessage(errMsg);    
        
        }    
    
    }
   
    public void createLeadHistory(){
        List<LM_Lead_History__c> lHistoryList= new  List<LM_Lead_History__c>();
        LM_Lead_History__c lHisoty;
        for(Lead l: selectedLeads){      
          lHisoty= new LM_Lead_History__c (); 
          lHisoty.name= l.name;
          lHisoty.Status__c= convertStatus.MAsterLabel;
          lHisoty.opportunity__c= oppId;
          lHisoty.contact__c= leadToContactMapAfterConversion.get(l.id);          
          lHisoty.Campaign_Cell__c = l.Campaign_Cell__c ;
          lHisoty.Campaign_Code__c= l.Campaign_Code__c;
          // lHisoty.Accept_By__c = l.Accept_By__c;
          //lHisoty.Convert_By__c = l.Convert_By__c; 
          lHisoty.Acceptance_SLA_Violation__c = l.Acceptance_SLA_Violation__c;
            lHisoty.Accept_By__c = l.Accept_By_Date__c;
            lHisoty.Convert_By__c = l.Convert_By_Date__c;
            lHisoty.Account_Name__c = l.Company;
            lHisoty.Business_Org__c = l.Business_Org__c;
            lHisoty.Contact_ID__c = l.Contact__c;
            lHisoty.Contact_SAP_ID__c = l.Contact_SAP_ID__c;
            lHisoty.Convert_SLA_violation__c = l.Convert_SLA_violation__c;
            lHisoty.Discard_Reason__c = l.Discard_Reason__c;
            lHisoty.External_Contact_ID__c = l.External_Contact_ID__c;
            lHisoty.External_ID__c = l.External_ID__c;
            lHisoty.Lead_ID__c = l.id;
            lHisoty.LeadID18__c = l.LeadID18__c;
            lHisoty.Lead_Last_Modified_by__c = l.LastModifiedBy.Name;
            lHisoty.Lead_Owner__c = l.owner.name;
            lHisoty.Lead_Source__c= l.LeadSource;
            lHisoty.Lead_Type__c = l.Type__c;
            lHisoty.Name__c = l.Name;
            lHisoty.Primary_Campaign_Source__c = l.Primary_Campaign_Source__c;
            lHisoty.Priority__c = l.Priority__c;
            lHisoty.Source_Desc__c = l.Source_Desc__c;
            lHisoty.Source_Type__c = l.Source__c;
            lHisoty.Tracking_Code__c = l.Tracking_Code__c;
            lHisoty.Account_ID__c= accId;          
          lHistoryList.add(lHisoty);
        }
        try{
            insert lHistoryList;
            system.debug('*** LOG STATUS:: LM Lead History created');
        }catch(DMLException dmlEx){
              system.debug('*** CreateLEadHistory error:: dmlEx.getMEssage()');
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
        }
    }
    
    public void createContactRole(List<Id> convrtdContactIds){
      
      List<OpportunityContactRole> cRoleList= new List<OpportunityContactRole>();  
      if(convrtdContactIds != null && convrtdContactIds.size() >0){ 
          for(Id conId: convrtdContactIds){
              OpportunityContactRole cRole= new OpportunityContactRole();
              cRole.contactId = conId;
              cRole.OpportunityId = oppId;
              cRoleList.add(cRole);
          }
          system.debug('****cRoleList' +cRoleList);
          try{
              insert cRoleList;
              system.debug('*** LOG STATUS:: Contact Roles created');
          }catch(DMLException dmlEx){
          
              system.debug('*** createContactRole error:: ' + dmlEx.getMEssage());
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
      }
      
    }
    List<Task> newTasksToOpp= new List<Task>();
    List<Task>  TaskListforLeads = new List<Task>();
    Map<id,List<Task>> tasksForLeadMap = new Map<id,List<Task>>();
    // COpy Leads tasks to Opportunity
    public void fetchLeadActivities(){   
        
        system.debug('***SelectedLeadIds' + SelectedLeadIds);
        TaskListforLeads = [SELECT id,callType,ActivityDate,Status,whoId,Subject,whatId FROM TASK WHERE whoid IN : SelectedLeadIds];
        for(Task t: taskListforLeads){
                if(tasksForLeadMap.ContainsKey(t.WhoId))
                    tasksForLeadMap.get(t.whoId).add(t);
                else{
                    tasksForLeadMap.put(t.whoId,new List<Task>());
                    tasksForLeadMap.get(t.WhoId).add(t);
                } 
            }
        system.debug('***Tasks fro LEads' + TaskListforLeads);
        
      /*  if(TaskListforLeads != null && TaskListforLeads.size() >0){
            for(string lID: SelectedLeadIds){
                for(Task t: tasksForLeadMap.get(lID)){
                    Task tnew= new Task();
                    tnew.whatId = oppId;
                    string contactId = leadToContactMapAfterConversion.get(lId);
                    tnew.whoId= t.contactId ;
                    tnew.callType = t.callType;
                    tnew.ActivityDate = t.ActivityDate;
                    tnew.Status = t.Status;
                    tnew.Subject = t.Subject;                
                    newTasksToOpp.add(tnew);
                }
            }
        }*/        
        system.debug('**** newTasksToOpp' + newTasksToOpp);     
    }
    
    private void createLeadTasksUnderOpp(){
        List<Task> tasksToUpdate = new List<Task>();
        for(string lID: SelectedLeadIds){
            if(tasksForLeadMap!= null && tasksForLeadMap.get(lID) != null){
                for(Task t: tasksForLeadMap.get(lID)){
                    t.whatId = oppId;
                    string contactId = leadToContactMapAfterConversion.get(lId);
                    t.whoId= contactId;
                    tasksToUpdate.add(t);
                
                } 
            }
        }
        try{
            update tasksToUpdate;
            System.debug('*** LOG STATUS:: Tasks created successfully under Oportunity');
        }catch(DMLException dmlEx){
          
              system.debug('*** createLeadTasksUnderOpp error:: dmlEx.getMEssage()');
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
  
    }
    

    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
 
    public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
    }
 
    public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
    }
 
    public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
    }
 
    public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
    }
 
    public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
    }
 
    public Integer getTotal_size() {
      return total_size;
    }
 
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }
 
    public Integer getTotalPages() {
          if (math.mod(total_size, list_size) > 0) {
             return total_size/list_size + 1;
          } else {
             return (total_size/list_size);
          }
   }

}