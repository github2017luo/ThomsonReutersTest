@isTest
public class ESC_Homepageflow_Test{
    private static testmethod void testflow(){
        List<Account> testAccList = new List<Account>();
        List<Contact> testConList = new List<Contact>();
        List<Case> testCaseList = new List<Case>();
        

       // Account Record 
        Account accountRecord = new Account();
        accountRecord = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
        accountRecord.ShippingCity = 'San Francisco';
        accountRecord.ShippingCountry = 'US';
        accountRecord.ShippingPostalCode = '90001';
        accountRecord.ShippingStreet = 'Alaska';
        accountRecord.ShippingState ='CA';
        testAccList.add(accountRecord);
        
        insert testAccList;
        
        // Contact Record
        Contact contactRecord = new Contact();
        contactRecord = ESC_GenericTestutility.TestContactUtil(accountRecord.id,'ConLast','test@tr.com');
        contactRecord.Salutation= 'Mr';
        contactRecord.FirstName= 'ConFirst';
        testConList.add(contactRecord);
        
        
        insert testConList;
        
        
        // Case Record
        Case caseRec = new Case();
        caseRec = ESC_GenericTestutility.TestCaseUtil(contactRecord.id,accountRecord.id,'Work in Progress');
      //  caseRec.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        caseRec.Origin = 'Web';      
        caseRec.Subject = 'Test Case';
        testCaseList.add(caseRec);
        
        insert testCaseList;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.ESC_Case__c = testCaseList[0].id;
        cc.ESC_Role__c = 'Escalation';
       // cc.ESC_referral_status__c = 'Work In Progress';
        cc.ESC_referral_status__c = 'In Progress';
        cc.ESC_ReferralUPD__c = False;
        
        insert cc;
        
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('CaseId', testCaseList[0].id);                                   
        Flow.Interview.ESC_Home_Page_Owner_Change myFlow = new Flow.Interview.ESC_Home_Page_Owner_Change(inputs);                         
        myFlow.start();
        
        Map<String, Object> inputs1 = new Map<String, Object>();
        inputs1.put('CaseId', cc.id);                                   
        Flow.Interview.ESC_Home_Page_Owner_Change myFlow1 = new Flow.Interview.ESC_Home_Page_Owner_Change(inputs1);                         
        myFlow1.start();
    }
}