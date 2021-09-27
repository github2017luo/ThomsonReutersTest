/*
======================================================================================================================
TEST CLASS NAME: GenerateCCTokenController_test
======================================================================================================================
PURPOSE: Validates the functionality provided by the GenerateCCTokenController class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest (seeAllData=false)
public class GenerateCCTokenController_test {
    public static testMethod void testController(){
            UnitTest.createTestData();
            Account testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
            testcontact.LastName = 'testContact';
            testcontact.FirstName = 'testContact';
            testcontact.AccountId = testAcc.Id;
            testcontact.email = 'testfirst.testlast@thomson.com';
            insert testcontact;
            Opportunity testOpp = UnitTest.getOpportunityInstance(testAcc.Id);
            insert testOpp;
            Quote testQuote = new Quote(Name ='testQuote',ContactId =testcontact.Id,OpportunityId=TestOpp.Id);
            insert testQuote;
            
            KeyValueListStore__c oKeyValue = new KeyValueListStore__c();
            oKeyValue.name = 'ProductId';       
            oKeyValue.TextValue__c = 'SF03';
            INSERT oKeyValue;
            KeyValueListStore__c oKeyValue1 = new KeyValueListStore__c();
            oKeyValue1.name = 'PaymetricEndpoint';       
            oKeyValue1.TextValue__c = 'https://securepayment.thomsonreuters.com/TokenizationService/TokenizationService.svc/GetCreditCardToken?callback=jQuery1640026312726782634854_1318003982698&_=1318003989847';
            INSERT oKeyValue1;
        
            PageReference pref=Page.generateCreditCardToken;
            pref.getParameters().put('id',testQuote.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(testQuote);
            generateCCTokenController con = new generateCCTokenController(sc);
            Test.startTest();
                //case 1: null token
                RequestMock fakeResponse = new RequestMock('[{"StatusCode": "1300","Token":null,"Message":"Invalid Card Data","Timestamp":"2013-07-16 06:15:28:736"}]');
                Test.setMock(HttpCalloutMock.class, fakeResponse);
                con.refreshPage();
                pref=con.generateToken();
               // System.assertEquals(con.statusCode, '1300');
               // System.assertEquals(con.sToken, 'null');
                pref=con.clear();
                //case 2:Token Generated
                RequestMock fakeResponse1 = new RequestMock('[{"StatusCode": "1000","Token":"-E803-1111-5000000000000N","Message":"Success","Timestamp":"2011-10-07 11:13:09:862"}]');
                Test.setMock(HttpCalloutMock.class, fakeResponse1);
                pref=con.generateToken();
               // System.assertEquals(con.statusCode, '1000');
              //  System.assertEquals(con.sToken, '-E803-1111-5000000000000N');
                //case 3:Exception thrown
                delete testQuote;
                pref=con.generateToken();
               // System.assertEquals(con.showInputFields , true);
            Test.stopTest(); 
       
        
    }
}