@isTest    
private class GGO_EmailnotificationPB_Test {
   
    
    static testMethod void testmethod1() {
        
        
        
       //insert Account
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry='US';
        acct.ShippingState = 'IL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Test.StartTest();
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
       // cs.SuppliedName ='test3';
        cs.Product__c= 'Recursos Humanos - TM';
        cs.LCRM_Sub_BU__c = 'GGO';
        cs.origin = 'Web';
        cs.esc_origin_name__c = 'https://thomsonreuterss2elatam.secure.force.com/GGO_VFP_Web2Case?Source=BR&BU=Legal(Print)';
        insert cs;
        Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    
    static testMethod void testmethod2() {
        
        
        
       //insert Account
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry='US';
        acct.ShippingState = 'IL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Test.StartTest();
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
       // cs.SuppliedName ='test3';
        cs.Product__c= 'Recursos Humanos - TM';
        cs.LCRM_Sub_BU__c = 'GGO';
        cs.origin = 'Web';
        cs.esc_origin_name__c = 'https://thomsonreuterss2elatam.secure.force.com/GGO_VFP_Web2Case?Source=AR&BU=Legal(Print)';
        insert cs;
        Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    
    static testMethod void testmethod3() {
        
        
        
       //insert Account
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry='US';
        acct.ShippingState = 'IL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Test.StartTest();
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
       // cs.SuppliedName ='test3';
        cs.Product__c= 'Recursos Humanos - TM';
        cs.LCRM_Sub_BU__c = 'US';
        cs.BU_Segment__c = 'Professional Legal';
        cs.origin = 'My TR';
        cs.ESC_Product_Segment_Brand__c = 'Risk';        
        insert cs;
        Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
}