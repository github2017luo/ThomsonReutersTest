@isTest
private class LMDuplicateLEadsListViewCon_Test{

public static testMethod void testDuplicateLeadsListView(){

        
        
    //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        insert account;
        //key value store custom setting
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        
        insert kvs;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        try{
            insert opp;
        }catch(DMLException dmlEx){
        system.debug('Test Class:: Exception occured' + dmlEx.getLineNumber());    
        
        }
        
        
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Satyajit';
        lead.LastName = 'Chanda';
        lead.Status= 'Contacting';
        lead.Account__c= account.Id;
        insert lead;
        //lead.LeadSource = 'Not Converted';
        
        Lead lead1= new Lead();
        lead1.Company = 'UTLeadAccount';
        lead1.FirstName = 'saty';
        lead1.LastName = 'chan'; 
        lead1.Status= 'Contacting'; 
        lead1.Account__c= account.Id;      
        insert lead1;
        
        List<Contact> contactList= new List<Contact>();
        
        Contact con= new Contact();
        con.FirstNAme= 'Satyajit';
        con.LastNAme= 'Chanda';
        con.AccountId= account.id;
        contactList.add(con);
        
        Contact con1= new Contact();
        con1.FirstNAme= 'saty';
        con1.LastNAme= 'chan';
        con1.AccountId= account.id;
        contactList.add(con1);
            
        insert contactList;
        
        
        
        
        PageReference testPageReference = new PageReference('/apex/LMduplicateListView');
        testPageReference.getParameters().put('leadid', lead.Id);
        testPageReference.getParameters().put('id', opp.id);
        testPageReference.getParameters().put('accId', account.Id);
        
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
        selectedLeads.add(lead1);
        
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller (selectedLeads);
        standardController.setSelected(selectedLeads);
             
        
        //Execute Test
        Test.startTest();
        
        LMDuplicateLEadsListViewCon controller = new LMDuplicateLEadsListViewCon();
         
        //controller.LoadData();
        PageReference convertPageReference = controller.processSelected();
        //convertPageReference.LoadData();
        //convertLeads();
        //controller.SelectedLeadIds
        controller.Beginning();
        controller.Previous();
        controller.Next();
        controller.End();
        controller.getDisablePrevious();
        
        controller.getDisableNext();
        controller.getTotal_size();
        controller.getPageNumber();
        controller.getTotalPages();
        controller.Cancel();
        
            
        //controller .createLeadTasksUnderOpp();
        
        //LMDuplicateLEadsListViewCon.wrapLead wrap = new LMDuplicateLEadsListViewCon.wrapLead(lead);
        
        
        /*List<Database.LeadConvert> leadConversions = new List<Database.LeadConvert>();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setAccountId(account.id);
        lc.setContactId(con.Id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Converted');
        leadConversions.add(lc);
        List<Database.LeadConvertResult> results = Database.convertLead( leadConversions );*/
        //lc.setConvertedStatus(convertStatus.MasterLabel );
        
        List<Id> convertedConIds= new List<Id>();
        
        
         Test.stopTest();
}

   public  static void testcreateLeadHistory(){
        LMDuplicateLEadsListViewCon con2= new LMDuplicateLEadsListViewCon();
        con2.createLeadHistory();
    }

      
      
}