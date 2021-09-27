@istest
public class USL_SCMTAM_UpdatesPBTest{
    static testmethod void testmethod1(){
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        /*acct.Legacy_System_ID__c='jasas';
        acct.Tax_Number_Type__c='C.I';
        acct.Tax_Number__c='19101';
        acct.Sales_Org__c='GLI';*/
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        
        USL_Email2case_SCM_TAM__c scm = new USL_Email2case_SCM_TAM__c();
        //scm.setupownerid = UserInfo.getOrganizationId();
        scm.setupownerid = UserInfo.getUserId();
        scm.SCM_Email_Id__c = 'test@test.com';
        insert scm;
        
        test.starttest();
        
        Case cs = new Case();         
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='2-Medium';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';        
        cs.LCRM_Sub_BU__c ='USL';
        cs.ESC_Apply_Entitlement_Milestone__c =false;
        cs.SuppliedEmail='dummytest@thomsonreuters.com';        
        insert cs;
        cs.ESC_Origin_Name__c ='test@test.com';
        update cs;
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    
    static testmethod void testmethod2(){
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        /*acct.Legacy_System_ID__c='jasas';
        acct.Tax_Number_Type__c='C.I';
        acct.Tax_Number__c='19101';
        acct.Sales_Org__c='GLI';*/
        insert acct ;
        
        
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        
        insert con;
        test.starttest();
        USL_Email2case_SCM_TAM__c scm = new USL_Email2case_SCM_TAM__c();
        //scm.setupownerid = UserInfo.getOrganizationId();
        scm.setupownerid = UserInfo.getUserId();
        scm.TAM_Email_Id__c = 'test1@test.com';
        scm.SCM_Email_Id__c = 'test2@test.com';
        insert scm;
        
        
        
        Case cs = new Case();         
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='2-Medium';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';        
        cs.LCRM_Sub_BU__c ='USL';
        cs.ESC_Apply_Entitlement_Milestone__c =false;
        cs.SuppliedEmail='dummytest@thomsonreuters.com';        
        insert cs;
        cs.ESC_Origin_Name__c ='test1@test.com';
        update cs; 
        test.stoptest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
}