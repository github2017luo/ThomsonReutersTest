@isTest
private class AEMTrial_Test {
    @isTest static void testTrialDetails(){
        createTestData();
        
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod='GET';
        request.params.put('sapAccountNum','1000212139');
        request.params.put('sapContactId','15836157');
        RestContext.request = request;
       
        AEM_Trial.Tr();
        Test.stopTest();
    }
    //helper method
    static void createTestData(){
        
        Account a = new Account();
        a.Name = 'LARRY';
        a.SAPAccountNumber__c = '10002121';
        insert a;
        
        Source_System_Detail__c ssdacc =new Source_System_Detail__c();
        ssdacc.Account_Name__c=a.id;
        ssdacc.Source_System_Account_Number__c='10002121';
        ssdacc.name='test';
        ssdacc.Source_System_Name__c='test';
        insert ssdacc;
        
        LCRM_Contact_SSD__c c1 = new LCRM_Contact_SSD__c();
        c1.name= 'Testcontssd1';
        c1.LCRM_Account_SSD__c=ssdacc.id;
        c1.LCRM_Contact_ID__c= '12345';
        insert c1;
        
        Lead l = new Lead();
        l.FirstName='test11';
        l.LastName='test12';
        l.Company='xyzz';
        insert l;
        
        Contact c = new Contact();
        c.FirstName = 'Test1';
        c.LastName = 'Test2';
        c.SAP_Contact_ID__c = '12345';
        insert c;
        
        Trial__c tr = new Trial__c();
        tr.Contact_LeadId__c = l.id;        
        tr.Account_Name__c = a.id;
        tr.Trial_Status__c ='Invited';
        insert tr;
      }      
}