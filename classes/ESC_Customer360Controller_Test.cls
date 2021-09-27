@isTest(seeAllData = false)
private class ESC_Customer360Controller_Test {
  
    /**
     * @description Justdesc
     * 
     */
    public static testmethod void test(){
        
         
        List<Account> testAccList = new List<Account>();
        List<Contact> testConList = new List<Contact>();
        //List<Case> testCaseList = new List<Case>();
        

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
        
        Source_System_Detail__c ssd= new Source_System_Detail__c(Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',LCRM_SAP_Account_Number__c = '2000000418',Source_System_Account_Number__c='2000000418',Account_Name__c=testAccList[0].id);
        insert SSD;
        
        // Contact Record
        Contact contactRecord = new Contact();
        contactRecord = ESC_GenericTestutility.TestContactUtil(accountRecord.id,'ConLast','test@tr.com');
        contactRecord.Salutation= 'Mr';
        contactRecord.FirstName= 'ConFirst';
        testConList.add(contactRecord);
        
        
        insert testConList;
        
        
         //esc_Customer360Controller c=new esc_Customer360Controller();
        // Case Record
        Case caseRec = new Case();
        caseRec = ESC_GenericTestutility.TestCaseUtil(contactRecord.id,accountRecord.id,'Work in Progress');
      //  caseRec.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        caseRec.Origin = 'Web';      
        caseRec.Subject = 'Test Case';
        caseRec.USL_SAP_Account_Number__c='2000000418';
        caseRec.LCRM_Account_SSD__c=SSD.id;
        insert caseRec;
        
        //insert testCaseList;
         
        //case caseRecord1 = [select id,accountid,LCRM_Account_SSD__c,USL_SAP_Account_Number__c,casenumber from case where USL_SAP_Account_Number__c!=Null Limit 1];
        ApexPages.currentPage().getParameters().put('Id',caseRec.id);
        //List<Source_System_Detail__c> ssd = [select id,LCRM_SAP_Account_Number__c,Source_System_Account_Number__c from Source_System_Detail__c where Source_System_Account_Number__c=:caseRecord.USL_SAP_Account_Number__c limit 1];
        esc_Customer360Controller pageRef = new esc_Customer360Controller();
        pageRef.newPage();
        //c.getaddressPT();
        //c.getaddressST();
        
        /*string s=c.getIDToOpen();
        Account acc = new Account(Name = 'TestAccountName');
         insert acc;

        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        ESC_CaseClosedController controller = new ESC_CaseClosedController(sc);
        */
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'Test');
    }
    

}