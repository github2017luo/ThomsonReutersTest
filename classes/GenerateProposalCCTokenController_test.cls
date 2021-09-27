@istest(seeAllData=true)
public class GenerateProposalCCTokenController_test {
    public static testMethod void testController(){
        try{
            Account testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            Opportunity testOpp = UnitTest.getOpportunityInstance(testAcc.Id);
            insert testOpp;
            Apttus_Proposal__Proposal__c testQuote= New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = testAcc.Id, Apttus_Proposal__Opportunity__c = testOpp.Id);
            insert testQuote;
            PageReference pref=Page.generateProposalCreditCardToken;
            pref.getParameters().put('id',testQuote.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(testQuote);
            generateProposalCCTokenController con = new generateProposalCCTokenController(sc);
            Test.startTest();
                //case 1: null token
                RequestMock fakeResponse = new RequestMock('[{"StatusCode": "1300","Token":null,"Message":"Invalid Card Data","Timestamp":"2013-07-16 06:15:28:736"}]');
                Test.setMock(HttpCalloutMock.class, fakeResponse);
                con.refreshPage();
                pref=con.generateToken();
                System.assertEquals(con.statusCode, '1300');
                System.assertEquals(con.sToken, 'null');
                pref=con.clear();
                //case 2:Token Generated
                RequestMock fakeResponse1 = new RequestMock('[{"StatusCode": "1000","Token":"-E803-1111-5000000000000N","Message":"Success","Timestamp":"2011-10-07 11:13:09:862"}]');
                Test.setMock(HttpCalloutMock.class, fakeResponse1);
                pref=con.generateToken();
                System.assertEquals(con.statusCode, '1000');
                System.assertEquals(con.sToken, '-E803-1111-5000000000000N');
                //case 3:Exception thrown
                delete testQuote;
                pref=con.generateToken();
                System.assertEquals(con.showInputFields , true);
            Test.stopTest(); 
        }catch(Exception ex){
            system.debug('Error occured in Test CLass::' + ex.getMessage());
        }
        
    }
}