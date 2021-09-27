@isTest 
private class RenewalQuoteBatch_Test{
    
    static testMethod void testRenewalBatch(){
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='System Administrator');
        insert test2;
            
        //list<ContentVersion> cvList = new list<ContentVersion>();
        //map<ID,Renewal_Quote__c> mapOfRenewalIDtoQuote = new map<ID,Renewal_Quote__c>();
    
        //Preparing Account data
        Account objAcct = UnitTest.getAccountInstance();                
        insert objAcct;
        System.assert(objAcct.Id != null,'Account not null');
        

        //Preparing RenewalQuote data
        Renewal_Quote__c rQuote = new Renewal_Quote__c(Sold_to_Account__c = objAcct.Id,CurrencyIsoCode='USD',
                                                       Renewal_Date__c=System.Today(),Customer_Support_URL__c = 'Test URL',Salesorg__c = 'TA78' );
                                                       
        insert rQuote;
        Renewal_Quote__c rQuoteUk = new Renewal_Quote__c(Sold_to_Account__c = objAcct.Id,CurrencyIsoCode='USD',
                                                       Renewal_Date__c=System.Today(),Customer_Support_URL__c = 'Test URL',Salesorg__c = 'TA61' );
                                                       
        insert rQuoteuk;
        Renewal_Quote__c rQuoteWEST = new Renewal_Quote__c(Sold_to_Account__c = objAcct.Id,CurrencyIsoCode='USD',
                                                       Renewal_Date__c=System.Today(),Customer_Support_URL__c = 'Test URL',Salesorg__c = 'WEST' );
                                                       
        insert rQuoteWEST;
        Renewal_Line_Item__c rQouteItem = new Renewal_Line_Item__c();
        rQouteItem.SAP_Quote_Num_and_Line_Num__c = '789456';
        rQouteItem.Renewal_Quote__c = rQuote.Id;
        rQouteItem.Quantity__c = 1;
        rQouteItem.Agreement_Number__c = '0024356';
        rQouteItem.Deal_Number__c = '098765';        
        insert rQouteItem;
        
        Test.startTest();

        
        Test.setMock(HttpCalloutMock.class, new RenewalMockHttpResponseGenerator());
        new RenewalQuoteBatch().execute(null,new Renewal_Quote__c[]{rQuote});
        RenewalQuoteBatch obj = new RenewalQuoteBatch();
        Database.executeBatch(obj);
        RenewalQuoteBatch.getAgrOrDealNumber(rQouteItem.Agreement_Number__c,rQouteItem.Deal_Number__c);
        Test.stopTest();
    }
}