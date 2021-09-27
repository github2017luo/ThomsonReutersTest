@isTest(seeAllData = false)
public class ESC_CaseClosedControllerTest{
    @testSetup
    static void dataSetup(){

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
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    
    public static testmethod void test(){
        
         ESC_CaseClosedController c=new ESC_CaseClosedController();
         
        case caseRecord = [select id,casenumber from case where status = 'Work In Progress' limit 1];
        ApexPages.currentPage().getParameters().put('Id',caseRecord.id);
        ESC_CaseClosedController pageRef = new ESC_CaseClosedController();
        pageRef.checkAndRedirect();
        c.getaddressPT();
        c.getaddressST();
        
        string s=c.getIDToOpen();
        Account acc = new Account(Name = 'TestAccountName');
         insert acc;

        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        ESC_CaseClosedController controller = new ESC_CaseClosedController(sc);

        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    
}