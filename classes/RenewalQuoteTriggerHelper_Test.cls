@isTest 
private class RenewalQuoteTriggerHelper_Test{
    
    static testMethod void testContentDocProcess(){
    
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='System Administrator');
        insert test2;
            
        list<ContentVersion> cvList = new list<ContentVersion>();
        map<ID,Renewal_Quote__c> mapOfRenewalIDtoQuote = new map<ID,Renewal_Quote__c>();
    
        //Preparing Account data
        Account objAcct = UnitTest.getAccountInstance();                
        insert objAcct;
        System.assert(objAcct.Id != null,'Account not null');
        

        //Preparing RenewalQuote data
        Renewal_Quote__c rQuote = new Renewal_Quote__c(Sold_to_Account__c = objAcct.Id,
                                                       Renewal_Date__c=System.Today());
                                                       
        insert rQuote;
        System.assert(rQuote.Id != null,'Quote not null');
        mapOfRenewalIDtoQuote.put(rQuote.ID,rQuote);
                                                       
        //Preparing Content Version Data
        ContentVersion cv=new Contentversion();
        cv.title='Test Document';
        cv.PathOnClient ='test';
        //Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.Renewal_Quote_ID__c = rQuote.ID;
        //insert cv;
        cvList.add(cv);
        
        
        RenewalQuoteTriggerHelper.processContentDocuments(cvList,mapOfRenewalIDtoQuote);
        Renewal_Quote__c tempRQuote = [SELECT ID,Content_Version_ID__c FROM Renewal_Quote__c WHERE Id = :rQuote.Id LIMIT 1];
        system.assertEquals(tempRQuote.Content_Version_ID__c,cv.ID,'');
        
        
    }
    static testMethod void testResubmitFailed(){
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
        
        RenewalQuoteTriggerHelper.resubmitFailedRenewalQuotes(rQuoteList);
        Renewal_Quote__c tempRQuote = [SELECT ID,Status__c FROM Renewal_Quote__c WHERE Id = :rQuote.Id LIMIT 1];
        system.assertEquals(tempRQuote.Status__c,'In Progress','');
        
        
        
         
     }
}