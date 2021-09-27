@isTest
private class APTS_CreateAddressFromProposalCtrlTest {
    
    @isTest static void test_SuccessfulInsert() {
        insert APTS_TestDataFactory.createPriceList(null);
         Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
         
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;


        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a; 
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

        Apttus_Proposal__Proposal__c p = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert p;

        Test.startTest();
        PageReference pf = new PageReference('/apex/APTS_CreateAddressFromProposal?id='+p.Id+'&accountId='+a.Id);
        Test.setCurrentPage(pf);

        APTS_CreateAddressFromProposalCtrl ctrl = new APTS_CreateAddressFromProposalCtrl();
        //ctrl.doAction();
        ctrl.newAddress.Name = 'Change Address';
        ctrl.doSave();
        ctrl.doCancel();
        ctrl.newAddress.Name = 'Change Address Change Address Change Address';
        ctrl.doSave();
        Test.stopTest();

        System.assertEquals(1, [SELECT Count() FROM Address__c]);
    }

    @isTest static void test_FailInsert(){
        insert APTS_TestDataFactory.createPriceList(null);
         Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
                
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
         
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a; 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c p = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert p;

        Test.startTest();
        PageReference pf = new PageReference('/apex/APTS_CreateAddressFromProposal?id='+p.Id+'&accountId='+a.Id);
        Test.setCurrentPage(pf);

        APTS_CreateAddressFromProposalCtrl ctrl = new APTS_CreateAddressFromProposalCtrl();
        //ctrl.doAction();
        ctrl.doSave();
        ctrl.doCancel();
        PageReference pageRef = Page.AddressEdit;
        Address__c ad = new Address__c(Name='Sreenu', Country__c='US');
        insert ad;
        pageRef.getParameters().put('id', ad.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ad);
        APTS_CreateAddressFromProposalCtrl contr= new APTS_CreateAddressFromProposalCtrl(sc);
        contr.doSave();
        Test.stopTest();

        p = [SELECT APTS_One_Time_Ship_To__c FROM Apttus_Proposal__Proposal__c limit 1];
        System.assertEquals(null, p.APTS_One_Time_Ship_To__c);
    }
    
    /*
    @isTest static void test_SuccessfulDelete() {
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test');
        insert a;

        Address__c newAddress = new Address__c();
        newAddress.Address_Type__c = 'One Time Ship To';
        newAddress.AccountId__c = a.Id;
        newAddress.Parent_Type__c = 'Account';
        insert newAddress;

        insert APTS_TestDataFactory.createPriceList(null);

        Apttus_Proposal__Proposal__c p = APTS_TestDataFactory.createProposal(null, a.Id);
        p.APTS_One_Time_Ship_To__c = newAddress.Id;
        insert p;

        Test.startTest();
        PageReference pf = new PageReference('/apex/APTS_CreateAddressFromProposal?newAddressId='+newAddress.Id+'&id='+p.Id);
        Test.setCurrentPage(pf);

        APTS_CreateAddressFromProposalCtrl ctrl = new APTS_CreateAddressFromProposalCtrl();
        //ctrl.doAction();
        ctrl.doSave();
        Test.stopTest();

        p = [SELECT APTS_One_Time_Ship_To__c FROM Apttus_Proposal__Proposal__c limit 1];
        System.assertEquals(null, p.APTS_One_Time_Ship_To__c);
    }
    */
        
    /*
    @isTest static void test_FailDelete(){
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test');
        insert a;

        Address__c newAddress = new Address__c();
        newAddress.Address_Type__c = 'One Time Ship To';
        newAddress.AccountId__c = a.Id;
        newAddress.Parent_Type__c = 'Account';
        insert newAddress;

        insert APTS_TestDataFactory.createPriceList(null);
        Apttus_Proposal__Proposal__c p = APTS_TestDataFactory.createProposal(null, a.Id);
        p.APTS_One_Time_Ship_To__c = newAddress.Id;
        Apttus_Proposal__Proposal__c p2 = p.clone(false, true, false, false);
        insert new List<Apttus_Proposal__Proposal__c>{p, p2};

        Test.startTest();
        PageReference pf = new PageReference('/apex/APTS_CreateAddressFromProposal?newAddressId='+newAddress.Id+'&id='+p.Id);
        Test.setCurrentPage(pf);

        APTS_CreateAddressFromProposalCtrl ctrl = new APTS_CreateAddressFromProposalCtrl();
        //ctrl.doAction();
        ctrl.doSave();
        Test.stopTest();

        System.assertEquals(1, [SELECT count() from Address__c]);
    }*/
}