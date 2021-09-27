@isTest
private class RenewalProcessStuckQuotesTest{
    
    static testMethod void testRenewalBatch(){
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='System Administrator');
        insert test2;
            
        //list<ContentVersion> cvList = new list<ContentVersion>();
        //map<ID,Renewal_Quote__c> mapOfRenewalIDtoQuote = new map<ID,Renewal_Quote__c>();
    
        //Preparing Account data
        Account objAcct = UnitTest.getAccountInstance();                
        insert objAcct;
        System.assert(objAcct.Id != null,'objAcct.Id is not equal to null.');
        
 
        //Preparing RenewalQuote data
        Renewal_Quote__c rQuote = new Renewal_Quote__c(Sold_to_Account__c = objAcct.Id,
                                                       Salesorg__c = 'TA61',
                                                       Renewal_Date__c=System.Today());
                                                       
        insert rQuote;
        Renewal_line_item__c rLI = new Renewal_line_item__c(CurrencyIsoCode='USD',
                                                            Renewal_Quote__c=rQuote.id,
                                                            Agreement_Number__c = '0024356',
                                                            Deal_Number__c = '098765');
        insert rLI;
        Test.startTest();
 
        
        
        new RenewalProcessStuckQuotes().execute(null,new Renewal_Quote__c[]{rQuote});
        RenewalProcessStuckQuotes obj = new RenewalProcessStuckQuotes();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}