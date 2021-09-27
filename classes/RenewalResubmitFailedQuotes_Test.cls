@isTest
private class RenewalResubmitFailedQuotes_Test{
    
    static testMethod void testResubmitFailedFromList(){
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='System Administrator');
        insert test2;
            
        list<Renewal_Quote__c> rQuoteList = new list<Renewal_Quote__c>();
        //map<ID,Renewal_Quote__c> mapOfRenewalIDtoQuote = new map<ID,Renewal_Quote__c>();
    
        //Preparing Account data
        Account objAcct = UnitTest.getAccountInstance();                
        insert objAcct;
        System.assert(objAcct.Id != null,'');
        
 
        //Preparing RenewalQuote data
        Renewal_Quote__c rQuote = new Renewal_Quote__c(Sold_to_Account__c = objAcct.Id,
                                                       Status__c = 'Failed',
                                                       Renewal_Date__c=System.Today());
                                                       
        insert rQuote;
        System.assert(rQuote.Id != null,'');
        
        rQuoteList.add(rQuote);
        
        list<list<Renewal_Quote__c>> listOfQuotesSubmitted = new list<list<Renewal_Quote__c>>();
        listOfQuotesSubmitted.add(rQuoteList);
        RenewalResubmitFailedQuotes.resubmitFailedRenewalQuotesFromList(listOfQuotesSubmitted);
   
     }
}