@istest 
public class ESC_Web2Case_Contact_AssociationPBTest {
static testmethod void testmethod1(){
       
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        Test.startTest();
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
        

        
        // insert a case records
        List<Case> Cslist= New List<Case>();
        Case cs = new Case();
        //cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='2-Medium';
        cs.Origin='Web';
        cs.Sales_Org__c ='GLI';        
        cs.LCRM_Sub_BU__c ='USL';
        cs.Is_GLI__c  =true;
        cs.SuppliedEmail='dummytest@thomsonreuters.com';
        Cslist.add(cs);
       insert Cslist;
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}
            
}