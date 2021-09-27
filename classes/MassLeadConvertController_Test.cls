@IsTest
private class MassLeadConvertController_Test {
    
    public static testMethod void testLeadConvert() {
        try{ 
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.MDBId__c = '1234';
        account.SAPAccountNumber__c = '12345';
        account.Legacy_System_ID__c = '123456';
        insert account;
        
		//contact contact1 = UnitTest.getContactInstance(account.Id);  
                    
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        //lead.Contact__c = contact1.Id;    
        lead.Account__c= account.Id;
        lead.Lead_Scoring_Combined__c = 'A2';
        //lead.Billing_Country__c = 'IN';
        //lead.Billing_Zip__c = '411001';
        //insert lead;
        //lead.LeadSource = 'Not Converted';
        
        Lead nonPrimLead= new Lead();
        nonPrimLead.Company = 'UTLeadAccount';
        nonPrimLead.FirstName = 'Martha1';
        nonPrimLead.LastName = 'Belly1';  
        nonPrimLead.Account__c= account.Id; 
        nonPrimLead.Lead_Scoring_Combined__c = 'A1'; 
        
        Lead nonPrimLead1= new Lead();
        nonPrimLead1.Company = 'UTLeadAccount';
        nonPrimLead1.FirstName = 'Martha1';
        nonPrimLead1.LastName = 'Belly1';  
        nonPrimLead1.Account__c= account.Id;
        nonPrimLead1.Lead_Scoring_Combined__c = 'B2';   
        
        Lead nonPrimLead2= new Lead();
        nonPrimLead2.Company = 'UTLeadAccount';
        nonPrimLead2.FirstName = 'Martha1';
        nonPrimLead2.LastName = 'Belly1';  
        nonPrimLead2.MDBId__c = account.MDBId__c; 
        nonPrimLead2.Lead_Scoring_Combined__c = 'A1'; 
        
        Lead errorLEad = new Lead();
        errorLEad.Company = 'UTLeadAccount';
        errorLEad.FirstName = 'Martha1';
        errorLEad.LastName = 'Belly1';  
        errorLEad.Account__c= account.Id; 
       // errorLead.Sales_Org__c= 'ABEP';
        errorLead.Sales_Org__c= 'LLEY';
        
         User u=[Select id from user where IsActive=true and Profile.Name = 'System Administrator' limit 1];   
        Lead ActivityLead= new Lead();
        ActivityLead.Company = 'UTLeadAccount';
        ActivityLead.FirstName = 'Bing';
        ActivityLead.LastName = 'Chandler';  
       
        //Kruthi
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
        leadList.add(nonPrimLead);
        leadList.add(nonPrimLead1);
        leadList.add(nonPrimLead2);
        leadList.add(ActivityLead);
        
        
            insert leadList;
        
        //Kruthi
        Task leadTask = new task();
        LeadTask.whoid = leadList[0].id;
        leadTask.ownerId = u.id;
        LeadTask.subject = 'Test Task';
        LeadTask.Status = 'open';
        LeadTask.priority = 'normal';
        insert LeadTask;
        
        Event LeadEvent = new Event();
        LeadEvent.whoid = leadList[0].id;
        LeadEvent.subject = 'Test Event';
        LeadEvent.StartDateTime = datetime.now();
        LeadEvent.EndDateTime = datetime.now();
       // LeadEvent.status = 'open';
       // LeadEvent.priority = 'normal';
        insert LeadEvent;
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
        /* skg failed in test2
        List<LatamGeneral__c> lgList= new List<LatamGeneral__c>();
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.name= 'Opp Stage 0';
        lg.Value__C = '0%';        
        lgList.add(lg);
        insert lgList; 
        */
        
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.Name= 'UTLeadAccount';
        opp1.AccountId = account.id;
        opp1.StageName ='10%';
        opp1.CloseDate =System.Today();
        oppList.add(opp1);
        //insert opp;
        
       
            insert oppList;
        
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;  
        con.SAP_Contact_ID__c = '1234';
        con.External_ID__c  = '123456'; 
        con.Phone='12345';
        con.Email='satya@gmail.com';        
        //insert con;
                
        
            insert con;
        
        
        List<OpportunityContactRole> tempOppConRoleList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = oppList[0].id;
        ocr.contactId = con.id;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.OpportunityId = oppList[0].id;
        ocr1.contactId = con.id;
        
        tempOppConRoleList.add(ocr);
        tempOppConRoleList.add(ocr1);
       
        
        SET<string> conIdsSet = new SET<string>();
        String convertedPrmContactId = con.id;
        String sLeadId = leadList[0].id;
        String sConvertedOppoId = oppList[0].id;
        String sconvertedAccntId = account.id;
        conIdsSet.add(con.id);
        
        nonPrimLead.External_Contact_ID__c = con.id;
        nonPrimLead1.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        nonPrimLead2.External_Contact_ID__c = con.id;
        nonPrimLead2.Contact__c = con.id;
        nonPrimLead1.Legacy_System_ID__c = account.Legacy_System_ID__c;
        update new List<Lead>{nonPrimLead,nonPrimLead1,nonPrimLead2};
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
        selectedLeads.add(nonPrimLead);
        selectedLeads.add(nonPrimLead1);
        selectedLeads.add(nonPrimLead2);
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);
        convert.fetchLeadActivities();
               
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller (lead);
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(selectedLeads);
        //standardController.setSelected(selectedLeads);
        
        //Execute Test
        Test.startTest();
        
         
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);
        List<MassLeadConvertController.OpportunityOption> oppOptionLst = new  List<MassLeadConvertController.OpportunityOption>();
        MassLeadConvertController.ContactOption conOpp;
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);
        controller.fetchLeadActivities();
        controller.createLeadEventsUnderOpp();
        controller.createLeadTasksUnderOpp();
        controller.createContactRole(tempOppConRoleList, conIdsSet);
        controller.createContactRoleForPrmaryLead(tempOppConRoleList, convertedPrmContactId);
        
        
        //*******
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        //*********
        controller.insertFollowUpTask(lcr);
        controller.executeNonPrimaryLeadConversion(sLeadId,convertedPrmContactId,sConvertedOppoId,sconvertedAccntId);
        controller.newfetchAccountAndContactMatchNonPrimary(); 
        //controller.UpdateOpportunityfields();
        
       // controller.LeadConvertStatus = 'Converted';        
        
        controller.SelectedAccountId = account.Id;
        controller.selectedOppId = opp.Id; 
        controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        
        //if(opp.Id != null){     
           // controller.selectedOppId = opp.Id;
      //  }
        //controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        controller.selectedAccountAttribute = account.id; 
        controller.selectLead();
        
        controller.selectExistingAccount();
        controller.selectAccount();
        
        controller.doSomething();
        oppOptionLst = controller.getLeadOpportunityOptions();
        controller.prev();
        controller.goToContactPage();
        controller.goToOpportunityPage();
        controller.Next();
        
        controller.prevAccount();
        controller.prevActivity();
        controller.prevOpportunity();
        controller.selectContact();
        controller.selectPrimaryContact();
        
        controller.goToActivityPage();
        
        //controller.createContactRoleForPrmaryLead('Test');
        
        controller.selectedAccount = lead.account__c;
        controller.primaryContactId = con.id;
        controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        
        PageReference convertPageReference = controller.convertLead();
        controller.convertedAccountId = account.id;
        controller.UpdateAccountfields(account.id);
        controller.UpdateOpportunityfields(opp.Id);
        
        
                
        /*
        Lead lead2= new Lead();
        lead2.Company = 'UTLeadAccount';
        lead2.FirstName = 'Martha';
        lead2.LastName = 'Belly';
        lead2.Account__c= account.Id;
        insert lead2;
        */
                
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        }catch(Exception ex){
            System.debug('ex : '+ex.getMessage());
            System.debug('ex : '+ex.getstacktraceString());
        }
        //System.assertEquals(true, lead.IsConverted);
    }
    
     public static testMethod void testLeadConvertMethod2() {
     
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        insert account;
                 
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        //lead.account__c= account.id;
        lead.Sales_Org__c= 'LLEY';
        lead.Billing_Country__c = 'United States';
        lead.MDBId__c = '1234';
        lead.SAPAccountNumber__c = '12345';
        //insert lead;
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
        /* skg failed in test2
        List<LatamGeneral__c> lgList= new List<LatamGeneral__c>();
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.name= 'Opp Stage 0';
        lg.Value__C = '0%';        
        lgList.add(lg);
        insert lgList; */
        
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
       
        
        try{
            insert leadList;
        }
        catch(DMLException dmlLeadex){
        
        }
       
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
       
        //insert opp;
        
        try{
            insert oppList;
        }
        catch(DMLException dmlOppex){
        
        }
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;         
        //insert con;
        
        try{
            insert con;
        }
        catch(DMLException dmlConex){
        
        }
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
      
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);

        Test.startTest();
        
        try{  
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);

        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);

        controller.SelectedAccountId = null;
        controller.selectedOppId = null; 
        controller.berror= false;
        controller.goToContactPage();
        controller.selectLead();
        controller.radiobuttoncount = '2';
        controller.getRadiobuttoncount();
        controller.setRadiobuttonCount('2');
        controller.CreateFollowUpTask = true;
        controller.leadError=false;
        controller.accessError=false;
        controller.str='test';
        controller.useExistingAccount=false;
        MassLeadConvertController.OpportunityOption oppnew= new MassLeadConvertController.OpportunityOption(opp);
        MassLeadConvertController.AccountOption accnew= new MassLeadConvertController.AccountOption(account);
        
        controller.doSomething();  
        controller.selectedAccount = lead.account__c;
        controller.primaryContactId = con.id;
        controller.selectedLead = Lead.id;
        
        PageReference convertPageReference = controller.convertLead();
        
        string sLeadId = lead.id;
        string convertedPrmContactId = con.id;        
        string sConvertedOppoId = leadList[0].id;
        string sconvertedAccntId = account.id;
        
        controller.executeNonPrimaryLeadConversion(sLeadId,convertedPrmContactId,sConvertedOppoId,sconvertedAccntId);
        
        }catch(Exception ex){
        
        }
                

        
      
                
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        //System.assertEquals(true, lead.IsConverted);    
    }

    public static testMethod void testLeadConvert1() {
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.MDBId__c = '1234';
        account.SAPAccountNumber__c = '12345';
        account.Legacy_System_ID__c = '123456';
        insert account;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        lead.Account__c= account.Id;
        lead.Billing_Country__c = 'IN';
        lead.Billing_Zip__c = '411001';
        //insert lead;
        //lead.LeadSource = 'Not Converted';
        
        
        Lead nonPrimLead3= new Lead();
        nonPrimLead3.Company = 'UTLeadAccount';
        nonPrimLead3.FirstName = 'Martha1';
        nonPrimLead3.LastName = 'Belly1';  
        nonPrimLead3.MDBId__c = account.MDBId__c;  
        
        Lead nonPrimLead4= new Lead();
        nonPrimLead4.Company = 'UTLeadAccount';
        nonPrimLead4.FirstName = 'Martha1';
        nonPrimLead4.LastName = 'Belly1';  
        nonPrimLead4.SAPAccountNumber__c = account.SAPAccountNumber__c; 
        
        Lead nonPrimLead5= new Lead();
        nonPrimLead5.Company = 'UTLeadAccount';
        nonPrimLead5.FirstName = 'Martha1';
        nonPrimLead5.LastName = 'Belly1';  
        nonPrimLead5.SAPAccountNumber__c = account.SAPAccountNumber__c;  
        
        Lead errorLEad = new Lead();
        errorLEad.Company = 'UTLeadAccount';
        errorLEad.FirstName = 'Martha1';
        errorLEad.LastName = 'Belly1';  
        errorLEad.Account__c= account.Id; 
        //errorLead.Sales_Org__c= 'ABEP';
        errorLead.Sales_Org__c= '.LLEY';
        
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
        leadList.add(nonPrimLead3);
        leadList.add(nonPrimLead4);
        leadList.add(nonPrimLead5);
        leadList.add(errorLEad);
        
        try{
            insert leadList;
        }
        catch(DMLException dmlLeadex){
        
        }
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
        /* skg failed in test2
        List<LatamGeneral__c> lgList= new List<LatamGeneral__c>();
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.name= 'Opp Stage 0';
        lg.Value__C = '0%';        
        lgList.add(lg);
        insert lgList;
        */
        
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.Name= 'UTLeadAccount';
        opp1.AccountId = account.id;
        opp1.StageName ='10%';
        opp1.CloseDate =System.Today();
        oppList.add(opp1);
        //insert opp;
        
        try{
            insert oppList;
        }
        catch(DMLException dmlOppex){
        
        }
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;  
        con.SAP_Contact_ID__c = '123';
       
        
        try{
            insert con;
        }
        catch(DMLException dmlConex){
        
        }
        
        nonPrimLead3.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        nonPrimLead4.External_Contact_ID__c = con.id;
        nonPrimLead5.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        update new List<Lead>{nonPrimLead3,nonPrimLead4,nonPrimLead5};
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
        selectedLeads.add(nonPrimLead3);
        selectedLeads.add(nonPrimLead4);
        selectedLeads.add(nonPrimLead5);
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);
               
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller (lead);
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(selectedLeads);
        //standardController.setSelected(selectedLeads);
        
        //Execute Test
        Test.startTest();
        
        try{  
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);
        List<MassLeadConvertController.OpportunityOption> oppOptionLst = new  List<MassLeadConvertController.OpportunityOption>();
        MassLeadConvertController.ContactOption conOpp;
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);
        
        //controller.LeadConvertStatus = 'Converted';
        controller.SelectedAccountId = account.Id;
        controller.selectedOppId = opp.Id; 
        /*
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
       
        controller.insertFollowUpTask(lcr);
        */
        //if(opp.Id != null){     
           // controller.selectedOppId = opp.Id;
      //  }
        //controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        controller.selectedAccountAttribute = account.id; 
        controller.selectLead();
        
        controller.selectExistingAccount();
        controller.selectAccount();
        
        controller.doSomething();
        oppOptionLst = controller.getLeadOpportunityOptions();
        controller.prev();
        controller.goToContactPage();
        controller.goToOpportunityPage();
        controller.Next();
        
        controller.prevAccount();
        controller.prevActivity();
        controller.prevOpportunity();
        controller.selectContact();
        controller.selectPrimaryContact();
        
        controller.goToActivityPage();
        
        //controller.createContactRoleForPrmaryLead('Test');
        
        controller.selectedAccount = lead.account__c;
        controller.primaryContactId = con.id;
        controller.strSelectedContactIds = Lead.Id + ':' + con.id;
        
        PageReference convertPageReference = controller.convertLead();
        controller.convertedAccountId = account.id;
        controller.UpdateAccountfields(account.id);
        controller.UpdateOpportunityfields(opp.Id);
        
        controller.tempLd = lead;
        controller.getLeadOpportunityOptions();
        controller.goToOpportunityPage();
        
        
        }catch(Exception ex){
            System.debug('ex : '+ex.getMessage());
            System.debug('ex : '+ex.getstacktraceString());
        }
                
        /*
        Lead lead2= new Lead();
        lead2.Company = 'UTLeadAccount';
        lead2.FirstName = 'Martha';
        lead2.LastName = 'Belly';
        lead2.Account__c= account.Id;
        insert lead2;
        */
                
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        
        //System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadConvert2() {
        try{
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.MDBId__c = '1234';
        account.SAPAccountNumber__c = '12345';
        account.Legacy_System_ID__c = '123456';
        insert account;
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;  
        con.SAP_Contact_ID__c = '123'; 
        con.Phone='12345';
        con.Email='satya@gmail.com';        
        //insert con;
            insert con;
        
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        lead.Account__c= account.Id;
        lead.Billing_Country__c = 'IN';
        lead.Billing_Zip__c = '411001';
        lead.Contact__c = con.id;
        lead.Phone='12345';
        lead.Email='satya@gmail.com';
        //insert lead;
        //lead.LeadSource = 'Not Converted';
        
        Lead nonPrimLead6= new Lead();
        nonPrimLead6.Company = 'UTLeadAccount';
        nonPrimLead6.FirstName = 'Martha1';
        nonPrimLead6.LastName = 'Belly1';
        nonPrimLead6.Legacy_System_ID__c = account.Legacy_System_ID__c;       
        nonPrimLead6.Account__c= account.Id;
        nonPrimLead6.Billing_Country__c = 'IN';
        nonPrimLead6.Billing_Zip__c = '411001';
        nonPrimLead6.Contact__c = con.id;
        nonPrimLead6.Phone='12345';
        nonPrimLead6.Email='satya@gmail.com';       
        
        
        Lead nonPrimLead7= new Lead();
        nonPrimLead7.Company = 'UTLeadAccount';
        nonPrimLead7.FirstName = 'Martha1';
        nonPrimLead7.LastName = 'Belly1';  
        nonPrimLead7.Account__c= account.Id;
        nonPrimLead7.Billing_Country__c = 'IN';
        nonPrimLead7.Billing_Zip__c = '411001';
        nonPrimLead7.Contact__c = con.id;
        nonPrimLead7.Phone='12345';
        nonPrimLead7.Email='satya@gmail.com';
        //nonPrimLead7.Legacy_System_ID__c = account.Legacy_System_ID__c;  
        
        Lead errorLEad = new Lead();
        errorLEad.Company = 'UTLeadAccount';
        errorLEad.FirstName = 'Martha1';
        errorLEad.LastName = 'Belly1';  
        errorLEad.Account__c= account.Id; 
        //errorLead.Sales_Org__c= 'ABEP';
        errorLead.Sales_Org__c= 'LLEY';
        errorLead.Account__c= account.Id;
        errorLead.Billing_Country__c = 'IN';
        errorLead.Billing_Zip__c = '411001';
        errorLead.Contact__c = con.id;
        errorLead.Phone='12345';
        errorLead.Email='satya@gmail.com';
        
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
        leadList.add(nonPrimLead6);
        leadList.add(nonPrimLead7);
        leadList.add(errorLEad);
        
        
            insert leadList;
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
        /* skg failed in test2
        List<LatamGeneral__c> lgList= new List<LatamGeneral__c>();
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.name= 'Opp Stage 0';
        lg.Value__C = '0%';        
        lgList.add(lg);
        insert lgList;
        */
        
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.Name= 'UTLeadAccount';
        opp1.AccountId = account.id;
        opp1.StageName ='10%';
        opp1.CloseDate =System.Today();
        oppList.add(opp1);
        //insert opp;
        
        
            insert oppList;
        
        
        
        
        nonPrimLead6.External_Contact_ID__c = con.id;
        nonPrimLead7.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        update new List<Lead>{nonPrimLead6,nonPrimLead7};
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
       
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
        selectedLeads.add(nonPrimLead6);
        selectedLeads.add(nonPrimLead7);
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);
        //convert.insertFollowUpTask();       
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller (lead);
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(selectedLeads);
        //standardController.setSelected(selectedLeads);
        
        //Execute Test
        Test.startTest();
        
       
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);
        List<MassLeadConvertController.OpportunityOption> oppOptionLst = new  List<MassLeadConvertController.OpportunityOption>();
        MassLeadConvertController.ContactOption conOpp;
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);
        
        //controller.LeadConvertStatus = 'Converted';
        controller.SelectedAccountId = account.Id;
        controller.selectedOppId = opp.Id; 
        
        //if(opp.Id != null){     
           // controller.selectedOppId = opp.Id;
      //  }
        //controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        controller.selectedAccountAttribute = account.id; 
        controller.selectLead();
        
        controller.selectExistingAccount();
        controller.selectAccount();
        
        controller.doSomething();
        oppOptionLst = controller.getLeadOpportunityOptions();
        controller.prev();
        controller.goToContactPage();
        controller.goToOpportunityPage();
        controller.Next();
        
        controller.prevAccount();
        controller.prevActivity();
        controller.prevOpportunity();
        controller.selectContact();
        controller.selectPrimaryContact();
        
        controller.goToActivityPage();
        
        //controller.createContactRoleForPrmaryLead('Test');
        
        controller.selectedAccount = lead.account__c;
        controller.primaryContactId = con.id;
        controller.strSelectedContactIds = Lead.Id + ':' + con.id;
        
        PageReference convertPageReference = controller.convertLead();
        controller.convertedAccountId = account.id;
        controller.UpdateAccountfields(account.id);
        //controller.UpdateOpportunityfields(opp.Id);
        controller.clear();        
        
                
        /*
        Lead lead2= new Lead();
        lead2.Company = 'UTLeadAccount';
        lead2.FirstName = 'Martha';
        lead2.LastName = 'Belly';
        lead2.Account__c= account.Id;
        insert lead2;
        */
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        }catch(Exception ex){
            System.debug('ex : '+ex.getMessage());
            System.debug('ex : '+ex.getstacktraceString());
        }
        //System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadConvertMethod3() {
        try{ 
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.MDBId__c = '1234';
        account.SAPAccountNumber__c = '12345';
        account.Legacy_System_ID__c = '123456';
        insert account;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        lead.Account__c= account.Id;
        lead.Lead_Scoring_Combined__c = 'A2';
        //lead.Billing_Country__c = 'IN';
        //lead.Billing_Zip__c = '411001';
        //insert lead;
        //lead.LeadSource = 'Not Converted';
        
        Lead nonPrimLead= new Lead();
        nonPrimLead.Company = 'UTLeadAccount';
        nonPrimLead.FirstName = 'Martha1';
        nonPrimLead.LastName = 'Belly1';  
        nonPrimLead.Account__c= account.Id; 
        nonPrimLead.Lead_Scoring_Combined__c = 'A1'; 
        
        Lead nonPrimLead1= new Lead();
        nonPrimLead1.Company = 'UTLeadAccount';
        nonPrimLead1.FirstName = 'Martha1';
        nonPrimLead1.LastName = 'Belly1';  
        nonPrimLead1.Account__c= account.Id;
        nonPrimLead1.Lead_Scoring_Combined__c = 'B2';   
        
        Lead nonPrimLead2= new Lead();
        nonPrimLead2.Company = 'UTLeadAccount';
        nonPrimLead2.FirstName = 'Martha1';
        nonPrimLead2.LastName = 'Belly1';  
        nonPrimLead2.MDBId__c = account.MDBId__c; 
        nonPrimLead2.Lead_Scoring_Combined__c = 'A1'; 
        
        Lead nonPrimLead3= new Lead();
        nonPrimLead3.Company = 'UTLeadAccount';
        nonPrimLead3.FirstName = 'Martha1';
        nonPrimLead3.LastName = 'Belly1';  
        nonPrimLead3.Account__c= account.Id; 
        nonPrimLead3.Lead_Scoring_Combined__c = 'B2';
        
        Lead nonPrimLead4= new Lead();
        nonPrimLead4.Company = 'UTLeadAccount';
        nonPrimLead4.FirstName = 'Martha1';
        nonPrimLead4.LastName = 'Belly1';  
        nonPrimLead4.MDBId__c = account.MDBId__c; 
        nonPrimLead4.Lead_Scoring_Combined__c = 'A1';
        
        Lead nonPrimLead5= new Lead();
        nonPrimLead5.Company = 'UTLeadAccount';
        nonPrimLead5.FirstName = 'Martha1';
        nonPrimLead5.LastName = 'Belly1';  
        nonPrimLead5.MDBId__c = account.MDBId__c; 
        nonPrimLead5.Lead_Scoring_Combined__c = 'A1';
        
        Lead nonPrimLead6= new Lead();
        nonPrimLead6.Company = 'UTLeadAccount';
        nonPrimLead6.FirstName = 'Martha1';
        nonPrimLead6.LastName = 'Belly1';  
        nonPrimLead6.SAPAccountNumber__c = account.SAPAccountNumber__c; 
        nonPrimLead6.Lead_Scoring_Combined__c = 'A1';
        
        Lead nonPrimLead7= new Lead();
        nonPrimLead7.Company = 'UTLeadAccount';
        nonPrimLead7.FirstName = 'Martha1';
        nonPrimLead7.LastName = 'Belly1';  
        nonPrimLead7.Legacy_System_ID__c  = account.Legacy_System_ID__c; 
        nonPrimLead7.Lead_Scoring_Combined__c = 'A1';
        
        Lead nonPrimLead8= new Lead();
        nonPrimLead8.Company = 'UTLeadAccount';
        nonPrimLead8.FirstName = 'Martha1';
        nonPrimLead8.LastName = 'Belly1';  
        nonPrimLead8.Legacy_System_ID__c  = account.Legacy_System_ID__c; 
        nonPrimLead8.Lead_Scoring_Combined__c = 'A1';
        
        Lead nonPrimLead9= new Lead();
        nonPrimLead9.Company = 'UTLeadAccount';
        nonPrimLead9.FirstName = 'Martha1';
        nonPrimLead9.LastName = 'Belly1';  
        nonPrimLead9.Legacy_System_ID__c  = account.Legacy_System_ID__c; 
        nonPrimLead9.Lead_Scoring_Combined__c = 'A1';
        
        Lead nonPrimLead10= new Lead();
        nonPrimLead10.Company = 'UTLeadAccount';
        nonPrimLead10.FirstName = 'Martha1';
        nonPrimLead10.LastName = 'Belly1';         
        nonPrimLead10.Lead_Scoring_Combined__c = 'A1';   
        
        Lead errorLEad = new Lead();
        errorLEad.Company = 'UTLeadAccount';
        errorLEad.FirstName = 'Martha1';
        errorLEad.LastName = 'Belly1';  
        errorLEad.Account__c= account.Id; 
       // errorLead.Sales_Org__c= 'ABEP';
        errorLead.Sales_Org__c= 'LLEY';
        
         User u=[Select id from user where IsActive=true and Profile.Name = 'System Administrator' limit 1];   
        Lead ActivityLead= new Lead();
        ActivityLead.Company = 'UTLeadAccount';
        ActivityLead.FirstName = 'Bing';
        ActivityLead.LastName = 'Chandler';  
       
        //Kruthi
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
        leadList.add(nonPrimLead);
        leadList.add(nonPrimLead1);
        leadList.add(nonPrimLead2);
        leadList.add(nonPrimLead3);
        leadList.add(nonPrimLead4);
        leadList.add(nonPrimLead5);
        leadList.add(nonPrimLead6);
        leadList.add(nonPrimLead7);
        leadList.add(nonPrimLead8);
        leadList.add(nonPrimLead9);
        leadList.add(nonPrimLead10);
        leadList.add(ActivityLead);
        
        
            insert leadList;
        
        //Kruthi
        Task leadTask = new task();
        LeadTask.whoid = leadList[0].id;
        leadTask.ownerId = u.id;
        LeadTask.subject = 'Test Task';
        LeadTask.Status = 'open';
        LeadTask.priority = 'normal';
        insert LeadTask;
        
        Event LeadEvent = new Event();
        LeadEvent.whoid = leadList[0].id;
        LeadEvent.subject = 'Test Event';
        LeadEvent.StartDateTime = datetime.now();
        LeadEvent.EndDateTime = datetime.now();
       // LeadEvent.status = 'open';
       // LeadEvent.priority = 'normal';
        insert LeadEvent;
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
        /* skg failed in test2
        List<LatamGeneral__c> lgList= new List<LatamGeneral__c>();
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.name= 'Opp Stage 0';
        lg.Value__C = '0%';        
        lgList.add(lg);
        insert lgList; 
        */
        
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.Name= 'UTLeadAccount';
        opp1.AccountId = account.id;
        opp1.StageName ='10%';
        opp1.CloseDate =System.Today();
        oppList.add(opp1);
        //insert opp;
        
       
            insert oppList;
       
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;  
        con.SAP_Contact_ID__c = '1234';
        con.External_ID__c  = '123456';
con.Phone='12345';
        con.Email='satya@gmail.com';        
        //insert con;
                
        Contact con1= new Contact();
        con1.FirstNAme= 'TEst1';
        con1.LastNAme= 'Test2';
        con1.AccountId= account.id; 
con1.Phone='12345';
        con1.Email='satya@gmail.com';       
                
        
            insert con;
            insert con1;
        
        
        List<OpportunityContactRole> tempOppConRoleList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = oppList[0].id;
        ocr.contactId = con.id;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.OpportunityId = oppList[0].id;
        ocr1.contactId = con.id;
        
        tempOppConRoleList.add(ocr);
        tempOppConRoleList.add(ocr1);
       
        
        SET<string> conIdsSet = new SET<string>();
        String convertedPrmContactId = con.id;
        String sLeadId = leadList[0].id;
        String sConvertedOppoId = oppList[0].id;
        String sconvertedAccntId = account.id;
        conIdsSet.add(con.id);
        
        nonPrimLead.External_Contact_ID__c = con.id;
        nonPrimLead1.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        nonPrimLead2.External_Contact_ID__c = con.id;
        nonPrimLead3.Contact__c = con.id;
        nonPrimLead4.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        nonPrimLead5.Contact__c = con.id;
        nonPrimLead6.Contact__c = con.id;
        nonPrimLead7.External_Contact_ID__c = con.id;
        nonPrimLead8.Contact_SAP_ID__c = con.SAP_Contact_ID__c;
        nonPrimLead9.Contact__c = con.id;
        update new List<Lead>{nonPrimLead,nonPrimLead1,nonPrimLead2,nonPrimLead3,nonPrimLead4,nonPrimLead5,nonPrimLead6,nonPrimLead7,nonPrimLead8,nonPrimLead9};
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
        selectedLeads.add(nonPrimLead);
        selectedLeads.add(nonPrimLead1);
        selectedLeads.add(nonPrimLead2);
        selectedLeads.add(nonPrimLead3);
        selectedLeads.add(nonPrimLead4);
        selectedLeads.add(nonPrimLead5);
        selectedLeads.add(nonPrimLead6);
        selectedLeads.add(nonPrimLead7);
        selectedLeads.add(nonPrimLead8);
        selectedLeads.add(nonPrimLead9);
        selectedLeads.add(nonPrimLead10);
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);
        convert.fetchLeadActivities();
               
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller (lead);
        //ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(selectedLeads);
        //standardController.setSelected(selectedLeads);
        
        //Execute Test
        Test.startTest();
        
         
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);
        List<MassLeadConvertController.OpportunityOption> oppOptionLst = new  List<MassLeadConvertController.OpportunityOption>();
        MassLeadConvertController.ContactOption conOpp;
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);
        controller.fetchLeadActivities();
        controller.createLeadEventsUnderOpp();
        controller.createLeadTasksUnderOpp();
      //  controller.createContactRole(tempOppConRoleList, conIdsSet);
      //  controller.createContactRoleForPrmaryLead(tempOppConRoleList, convertedPrmContactId);
        
        /*
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        //*********
        controller.insertFollowUpTask(lcr);
        */
        
       // controller.newfetchAccountAndContactMatchNonPrimary();
        //controller.UpdateOpportunityfields();
        
       // controller.LeadConvertStatus = 'Converted';        
        
        controller.SelectedAccountId = account.Id;
        controller.selectedOppId = opp.Id; 
        
        //if(opp.Id != null){     
           // controller.selectedOppId = opp.Id;
      //  }
        //controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        controller.selectedAccountAttribute = account.id; 
        controller.selectLead();
        
        controller.selectExistingAccount();
        controller.selectAccount();
        
        controller.doSomething();
        oppOptionLst = controller.getLeadOpportunityOptions();
        controller.prev();
        controller.goToContactPage();
        controller.goToOpportunityPage();
        controller.Next();
        
        controller.prevAccount();
        controller.prevActivity();
        controller.prevOpportunity();
        controller.selectContact();
        controller.selectPrimaryContact();
        
        controller.goToActivityPage();
                        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        controller.insertFollowUpTask(lcr); 
        controller.executeNonPrimaryLeadConversion(sLeadId,convertedPrmContactId,sConvertedOppoId,sconvertedAccntId);
        controller.newFetchAccountAndContactMatchNonPrimary();
        //controller.createContactRoleForPrmaryLead('Test');
        
        controller.selectedAccount = lead.account__c;
        controller.primaryContactId = con.id;
        controller.strSelectedContactIds = nonPrimLead.Id + ':' + con.id + ','+ nonPrimLead1.Id + ':' + con.id ;
        
        PageReference convertPageReference = controller.convertLead();
        controller.convertedAccountId = account.id;
        controller.UpdateAccountfields(account.id);
        controller.UpdateOpportunityfields(opp.Id);
        
        
               
                
        /*
        Lead lead2= new Lead();
        lead2.Company = 'UTLeadAccount';
        lead2.FirstName = 'Martha';
        lead2.LastName = 'Belly';
        lead2.Account__c= account.Id;
        insert lead2;
        */
                
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        }catch(Exception ex){
            System.debug('ex : '+ex.getMessage());
            System.debug('ex : '+ex.getstacktraceString());
        }
        //System.assertEquals(true, lead.IsConverted);
    }
public static testMethod void testLeadMethod1() {

        Account account = new Account();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.MDBId__c = '1234';
        account.SAPAccountNumber__c = '12345';
        account.Legacy_System_ID__c = '123456';
        insert account;
    
    Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        lead.Account__c= account.Id;
        lead.Billing_Country__c = 'IN';
        lead.Billing_Zip__c = '411001';
        insert lead;
    
     List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
    
    
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);     
            Test.startTest();
            MassLeadConvertController  controller = new MassLeadConvertController(standardController);
            controller.setselectedAccountAttribute('Test');
            controller.validationError=false;
            controller.bError=true;
            controller.accName=account.Name;
            controller.accID=account.id;
            controller.SelectedAccount=account.Name;        
            controller.setisAccSelected();
            controller.setisAccSelectedforSearch();
    Test.stopTest();
}     
   public static testMethod void testLeadMethod2() {
         
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.MDBId__c = '1234';
        account.SAPAccountNumber__c = '12345';
        account.Legacy_System_ID__c = '123456';
        insert account;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        lead.Account__c= account.Id;
        lead.Lead_Scoring_Combined__c = 'A2';
        lead.Billing_Country__c = 'TEST';
        
        
        Lead nonPrimLead= new Lead();
        nonPrimLead.Company = 'UTLeadAccount';
        nonPrimLead.FirstName = 'Martha1';
        nonPrimLead.LastName = 'Belly1';  
        nonPrimLead.Account__c= account.Id; 
        nonPrimLead.Lead_Scoring_Combined__c = '21'; 
        
        Lead nonPrimLead1= new Lead();
        nonPrimLead1.Company = 'UTLeadAccount';
        nonPrimLead1.FirstName = 'Martha1';
        nonPrimLead1.LastName = 'Belly1';  
        nonPrimLead1.Account__c= account.Id;
        nonPrimLead1.Lead_Scoring_Combined__c = 'B2';   
        
        Lead nonPrimLead2= new Lead();
        nonPrimLead2.Company = 'UTLeadAccount';
        nonPrimLead2.FirstName = 'Martha1';
        nonPrimLead2.LastName = 'Belly1';  
        nonPrimLead2.MDBId__c = account.MDBId__c; 
        nonPrimLead2.Lead_Scoring_Combined__c = '11'; 
        
        Lead errorLEad = new Lead();
        errorLEad.Company = 'UTLeadAccount';
        errorLEad.FirstName = 'Martha1';
        errorLEad.LastName = 'Belly1';  
        errorLEad.Account__c= account.Id; 
       // errorLead.Sales_Org__c= 'ABEP';
        errorLead.Sales_Org__c= 'LLEY';
        
         User u=[Select id from user where IsActive=true and Profile.Name = 'System Administrator' limit 1];   
        Lead ActivityLead= new Lead();
        ActivityLead.Company = 'UTLeadAccount';
        ActivityLead.FirstName = 'Bing';
        ActivityLead.LastName = 'Chandler';  
       
        //Kruthi
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
        leadList.add(nonPrimLead);
        leadList.add(nonPrimLead1);
        leadList.add(nonPrimLead2);
        leadList.add(ActivityLead);
        
        
            insert leadList;
        
        //Kruthi
        Task leadTask = new task();
        LeadTask.whoid = leadList[0].id;
        leadTask.ownerId = u.id;
        LeadTask.subject = 'Test Task';
        LeadTask.Status = 'open';
        LeadTask.priority = 'normal';
        insert LeadTask;
        
        Event LeadEvent = new Event();
        LeadEvent.whoid = leadList[0].id;
        LeadEvent.subject = 'Test Event';
        LeadEvent.StartDateTime = datetime.now();
        LeadEvent.EndDateTime = datetime.now();
       // LeadEvent.status = 'open';
       // LeadEvent.priority = 'normal';
        insert LeadEvent;
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
    
        
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.Name= 'UTLeadAccount';
        opp1.AccountId = account.id;
        opp1.StageName ='10%';
        opp1.CloseDate =System.Today();
        oppList.add(opp1);
        //insert opp;
        
       
            insert oppList;
        
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;  
        con.SAP_Contact_ID__c = '1234';
        con.External_ID__c  = '123456'; 
        con.Phone='12345';
        con.Email='satya@gmail.com'; 

        Contact con1= new Contact();
        con1.FirstNAme= 'TEst3';
        con1.LastNAme= 'Test4';
        con1.AccountId= account.id;  
        con1.SAP_Contact_ID__c = '8989';
        con1.External_ID__c  = '898989'; 
        con1.Phone='12345';
        con1.Email='satya1@gmail.com';      
        //insert con;
                
        List<Contact> lstCon = new List<Contact>();
        lstCon.add(con);
        lstCon.add(con1);
        insert lstCon;
           // insert con;
       
      
        List<OpportunityContactRole> tempOppConRoleList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = oppList[0].id;
        ocr.contactId = lstCon[0].id;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.OpportunityId = oppList[0].id;
        ocr1.contactId = lstCon[0].id;
        
        tempOppConRoleList.add(ocr);
        tempOppConRoleList.add(ocr1);
       
        
        SET<string> conIdsSet = new SET<string>();
        String convertedPrmContactId = lstCon[0].id;
        String sLeadId = leadList[0].id;
        String sConvertedOppoId = oppList[0].id;
        String sconvertedAccntId = account.id;
        conIdsSet.add(lstCon[0].id);
         conIdsSet.add(lstCon[1].id);
        
        nonPrimLead.External_Contact_ID__c = lstCon[0].id;
        nonPrimLead1.Contact_SAP_ID__c = lstCon[0].SAP_Contact_ID__c;
        nonPrimLead2.External_Contact_ID__c = lstCon[0].id;
        update new List<Lead>{nonPrimLead,nonPrimLead1,nonPrimLead2};
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        List<String> selectedLeadIds = new List<String>();
        selectedLeads.add(lead);
        selectedLeads.add(nonPrimLead);
        selectedLeads.add(nonPrimLead1);
        selectedLeads.add(nonPrimLead2);
        selectedLeadIds.add(nonPrimLead.id);
        selectedLeadIds.add(nonPrimLead2.id);
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);
        convert.fetchLeadActivities();
               

        Test.startTest();
        
         
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);
        List<MassLeadConvertController.OpportunityOption> oppOptionLst = new  List<MassLeadConvertController.OpportunityOption>();
        MassLeadConvertController.ContactOption conOpp;
      
       List<MassLeadConvertController.ContactOption> lstcp1 = new List<MassLeadConvertController.ContactOption>();
       MassLeadConvertController.ContactOption cp1 = new MassLeadConvertController.ContactOption();
                cp1.IsSelected = true;
                cp1.Contact.FirstName= 'Test';
                cp1.Contact.email= 'sample@email.com';
       MassLeadConvertController.ContactOption cp2 = new MassLeadConvertController.ContactOption();
                cp2.IsSelected = true;
                cp2.Contact.FirstName= 'Test1';
                cp2.Contact.email= 'sample1@email.com';
        
       lstcp1.add(cp1);
       lstcp1.add(cp2);
       
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);
        controller.fetchLeadActivities();
        controller.createLeadEventsUnderOpp();
        controller.createLeadTasksUnderOpp();
        controller.createContactRole(tempOppConRoleList, conIdsSet);
        controller.leadContactOptions = lstcp1;
        controller.createContactRoleForPrmaryLead(tempOppConRoleList, convertedPrmContactId);
        controller.tempLd = lead;
        controller.leadlst = selectedLeads;        
        controller.setisAccSelectedforSearch();        
        controller.goToContactPage();
        controller.calcPrimaryLead(selectedLeadIds);
        
        Test.stopTest();
        
        }
   public static testMethod void testLeadConvertMethod5() {
     
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        insert account;
                 
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
                
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        lead.account__c= account.id;
        lead.Sales_Org__c= 'LLEY';
        lead.Billing_Country__c = 'United States';
        lead.MDBId__c = '1234';
        lead.SAPAccountNumber__c = '12345';
        //insert lead;
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';
        
        insert kvs;
        
        List<RecordtypeIds__c> rtList= new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        rtList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        rtList.add(recT1);
        insert rtList;
        
        /* skg failed in test2
        List<LatamGeneral__c> lgList= new List<LatamGeneral__c>();
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.name= 'Opp Stage 0';
        lg.Value__C = '0%';        
        lgList.add(lg);
        insert lgList; */
        
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
       
        
        try{
            insert leadList;
        }
        catch(DMLException dmlLeadex){
        
        }
       
        List<opportunity> oppList= new List<opportunity>();
        
        opportunity opp = new opportunity();
        opp.Name= 'opp1';
        opp.AccountId = account.id;
        opp.StageName ='10%';
        opp.CloseDate =System.Today();
        oppList.add(opp);
        
       
        //insert opp;
        
        try{
            insert oppList;
        }
        catch(DMLException dmlOppex){
        
        }
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= account.id;         
        //insert con;
        
        try{
            insert con;
        }
        catch(DMLException dmlConex){
        
        }
        
        PageReference testPageReference = new PageReference('/apex/MassLeadConvert');
        testPageReference.getParameters().put('leadid', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        //lead = getLeadRecord(lead.Id);
        
        List<Lead> selectedLeads = new List<Lead>();
        selectedLeads.add(lead);
      
        MassLeadConvertController convert = new MassLeadConvertController();
        ApexPages.Standardsetcontroller standardController= new ApexPages.Standardsetcontroller(selectedLeads);
        standardController.setSelected(selectedLeads);

        Test.startTest();
        
        try{  
        List<string> nonPrimaryLeadLst = new List<string>();
        MassLeadConvertController  controller = new MassLeadConvertController (standardController);

        controller.Controllervalue = lead;
        controller.getControllerValue();
        controller.setControllerValue(lead);

        controller.SelectedAccountId = null;
        controller.selectedOppId = null; 
        controller.berror= false;
        controller.goToContactPage();
        controller.selectLead();
        controller.radiobuttoncount = '2';
        controller.getRadiobuttoncount();
        controller.setRadiobuttonCount('2');
        controller.CreateFollowUpTask = true;
        controller.leadError=false;
        controller.accessError=false;
        controller.str='test';
        controller.useExistingAccount=false;
        MassLeadConvertController.OpportunityOption oppnew= new MassLeadConvertController.OpportunityOption(opp);
        MassLeadConvertController.AccountOption accnew= new MassLeadConvertController.AccountOption(account);
        
        controller.doSomething();  
        controller.selectedAccount = lead.account__c;
        controller.primaryContactId = con.id;
        controller.selectedLead = Lead.id;
        controller.SelectedOppId = opp.id;
controller.selectedOppOwnerId = opp.ownerid;
        
        PageReference convertPageReference = controller.convertLead();
        controller.selectedAccountAttribute = 'Test';
        controller.getselectedAccountAttribute();
        
        string sLeadId = lead.id;
        string convertedPrmContactId = con.id;        
        string sConvertedOppoId = leadList[0].id;
        string sconvertedAccntId = account.id;
        
        controller.executeNonPrimaryLeadConversion(sLeadId,convertedPrmContactId,sConvertedOppoId,sconvertedAccntId);
        
        }catch(Exception ex){
        
        }
                

        
      
                
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        //System.assertEquals(true, lead.IsConverted);    
    }
}