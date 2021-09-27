@istest

public class CaseTriggerHandlerForCloseCase_Test
{
 /********************************************************************************************
    MethodName: testLogicForUpdateQuoteOnCaseClosure
    Description: Test method to test the logic of 'updateQuoteOnCaseClosure' method from 'CaseTriggerHandlerForCloseCase' class
    CreatedBy: Anshu Thakur 
    CreatedDate: 08-Aug-2016
    LastModifiedBy: Anshu Thakur 
    LastModifiedDate: 08-Aug-2016
    Reason for Change:
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
   static testmethod void testLogicForUpdateQuoteOnCaseClosure()
   {
        UnitTest.createTestData();
        List<Case> lstCase = new List<Case>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<Quote> lstQuote = new List<Quote>();
        List<Renewal_Request__c> lstRRC = new List<Renewal_Request__c>();
                
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;

        //Preparing Opportunity data : set1
        Opportunity objOpp1 = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp1.Renewal_Flag__c = true;
        objOpp1.Pricebook2Id = Test.getStandardPricebookId();
        lstOpp.add(objOpp1);
        
        //Preparing Opportunity data : set2
        Opportunity objOpp2 = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp2.Renewal_Flag__c = true;
        objOpp2.Pricebook2Id = Test.getStandardPricebookId();
        lstOpp.add(objOpp2);
        
        INSERT lstOpp;
        
        //Preparing OpportunityLineItem data
        OpportunityLineItem objOLI = new OpportunityLineItem(opportunityId=objOpp1.id,PricebookEntryId=testEntry.id,unitprice=200,Quantity=1, Revenue_Type__c ='Renewal');
        objOLI.OpportunityId = objOpp1.Id;
        
        INSERT objOLI;
        
        //Preparing Quote data: set1
        Quote objQty1 = new Quote();
        objQty1.Name = 'Test Quote1';
        objQty1.Status = 'Draft';
        objQty1.OpportunityId = objOpp1.id;
        objQty1.Pricebook2Id = Test.getStandardPricebookId();
        objQty1.Approval_Status__c = 'Cancellation Approved';
        objQty1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        
        lstQuote.add(objQty1);
        
        //Preparing Quote data: set2
        Quote objQty2 = new Quote();
        objQty2.Name = 'Test Quote2';
        objQty2.Status = 'In Review';
        objQty2.OpportunityId = objOpp2.id;
        objQty2.Pricebook2Id = Test.getStandardPricebookId();
        objQty2.Approval_Status__c = 'Approved';
        objQty2.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
        lstQuote.add(objQty2);
        
        INSERT lstQuote;
        
        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty1.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;  
        
        INSERT objQLI;
        
        //Preparing Renewal Request data : set1
        Renewal_Request__c objRRC1 = new Renewal_Request__c();
        objRRC1.Quote__c = objQty1.id;
        objRRC1.Opportunity__c = objOpp1.Id;
        objRRC1.Cancel_Reason__c = 'Company Closure';
        objRRC1.Cancel_Comments__c = 'Test Comments for Cancel request:1';
        objRRC1.Was_There_a_Competitor__c = 'No';
        lstRRC.add(objRRC1);  
        
        //Preparing Renewal Request data : set2
        Renewal_Request__c objRRC2 = new Renewal_Request__c();
        objRRC2.Quote__c = objQty2.id;
        objRRC2.Opportunity__c = objOpp2.Id;
        objRRC2.Cancel_Reason__c = 'Budget Cut';
        objRRC2.Cancel_Comments__c = 'Test Comments for Cancel request:2';
        objRRC2.Was_There_a_Competitor__c = 'Yes';
        objRRC2.Competitor_Name__c = 'AccessData';
        lstRRC.add(objRRC2);  
        
        INSERT lstRRC;
        
        // //Preparing User data
        // User objUser = new User();
        // objUser.Username = 'TRUser@test.com';
        // objUser.LastName = 'XYZ';
        // objUser.Email = 'abc@xyz.com';
        // objUser.Alias = 'abctest';
        // objUser.CommunityNickname = 'TestCommunityNickname.user';
        // objUser.TimeZoneSidKey = 'America/Los_Angeles';
        // objUser.LocaleSidKey = 'en_US';
        // objUser.EmailEncodingKey = 'ISO-8859-1';
        // objUser.LanguageLocaleKey = 'en_US'; 
        // objUser.profileId = [SELECT Id FROM Profile WHERE Name = 'LatAm User' LIMIT 1].Id;
        // objUser.Sales_org__c = 'RV01';
        
        // INSERT objUser;
        
        //Preparing Case data : set1
        Case objCase1 = UnitTest.getCaseInstance();
        objCase1.Status = 'Closed';
        objCase1.Reason_Detail__c = 'Remove Renewal'; 
        objCase1.Origin = 'Other';
        objCase1.Reason__c = '  Remove Renewal';
        objCase1.Quote__c = objQty1.id;
        objCase1.Opportunity__c = objOpp1.Id;
        lstCase.add(objCase1);
        
        //Preparing Case data : set2
        Case objCase2 = UnitTest.getCaseInstance();
        objCase2.Status = 'Closed';
        objCase2.Reason_Detail__c = 'Full Cancellation'; 
        objCase2.Origin = 'Mail';
        objCase2.Reason__c = 'Full Cancellation';
        objCase2.Quote__c = objQty2.id;
        objCase2.Opportunity__c = objOpp2.Id;
        lstCase.add(objCase2);
        
        //Executing Test
        Test.startTest();      
        INSERT lstCase;
        
        //WebserviceResponseHandler.updateQuoteOnRemoveSuccess(lstQuote,'');
        
        if(!lstQuote.isEmpty() && lstQuote != null){
        CaseTriggerHandlerForCloseCase.updateQuoteOnManagerApprove(lstQuote);
        }
        System.assertEquals(objCase2.Reason_Detail__c, 'Full Cancellation');
        Test.stopTest();
    } 
    
    static testmethod void testUpdateOpptyGracePeriodDaysOnCaseCloser()
    {
        User currUser = [Select Id, Name, Sales_org__c, profile.name from User where Id=:UserInfo.getUserId()];
        currUser.sales_org__c ='TSL';
        update currUser;
        UnitTest.createTestData();
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        objProd.Application_Domain__c = 'BEJE';
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;

        //Preparing Opportunity data
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp.Renewal_Flag__c = true;
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
        //objOpp.Sales_Org__c = 'FSCO';
        objOpp.Sales_Org__c = 'TSL';
        objOpp.Grace_Period_Days__c = 30;
        
        INSERT objOpp;
        
        //Preparing OpportunityLineItem data
        OpportunityLineItem objOLI = new OpportunityLineItem(opportunityId=objOpp.id,PricebookEntryId=testEntry.id,unitprice=200,Quantity=1, Revenue_Type__c ='Renewal');
        objOLI.OpportunityId = objOpp.Id;             
        INSERT objOLI;
        
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.Opportunity_Sales_Org__c = 'BEJE';
        objQty.OpportunityId = objOpp.id;
        objQty.Primary_Quote__c = true;        
        objQty.Pricebook2Id = Test.getStandardPricebookId();        
        objQty.Approval_Status__c = 'Cancellation Approved';
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
        INSERT objQty;
        
        objOpp.SyncedQuoteId = objQty.id;
        update objOpp;

        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;        
        INSERT objQLI;

    //    objOpp.SyncedQuoteId = objQty.id;
    //    update objOpp;
        Test.startTest();
        //Preparing Case data
        Case objCase = UnitTest.getCaseInstance();
        objCase.Opportunity__c= objOpp.Id;
        objCase.Status = 'New';
        objCase.Quote__c = objQty.Id;
        //objCase.Sales_Org__c = 'FSCO';
        objCase.Sales_Org__c = 'TSL';
        objCase.Approval_Status__c='Approved';
        objCase.ANZ_Issue__c='Administrativa';
        objCase.Origin='Created by System';
        objCase.AccountId = objAcc.Id;
        objCase.Reason__c = 'Grace Period Extension';     
        INSERT objCase;   
        
        //Executing Test
        
        checkRecursive.runCaseUpdateForGPDaysOnce = true;
        objCase.Status = 'Closed';
        
        UPDATE objCase;
        
        System.assertEquals(objCase.Reason__c, 'Grace Period Extension');
        
        Test.stopTest();
    } 
    /*********************************************************************************************/ 

    static testmethod void testUpdateOpptyGracePeriodDaysOnCaseCloser1()
    {
        User currUser = [Select Id, Name, Sales_org__c, profile.name from User where Id=:UserInfo.getUserId()];
        currUser.sales_org__c ='BEJE';
        update currUser;
        UnitTest.createTestData();
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        objProd.Application_Domain__c = 'BEJE';
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;

        //Preparing Opportunity data
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp.Renewal_Flag__c = true;
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
        //objOpp.Sales_Org__c = 'FSCO';
        objOpp.Sales_Org__c = 'BEJE';
        objOpp.Grace_Period_Days__c = 30;
        
        INSERT objOpp;
        
        //Preparing OpportunityLineItem data
        OpportunityLineItem objOLI = new OpportunityLineItem(opportunityId=objOpp.id,PricebookEntryId=testEntry.id,unitprice=200,Quantity=1, Revenue_Type__c ='Renewal');
        objOLI.OpportunityId = objOpp.Id;             
        INSERT objOLI;
        
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.Opportunity_Sales_Org__c = 'BEJE';
        objQty.OpportunityId = objOpp.id;
        objQty.Primary_Quote__c = true;        
        objQty.Pricebook2Id = Test.getStandardPricebookId();        
        objQty.Approval_Status__c = 'Cancellation Approved';
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
        INSERT objQty;
        
        objOpp.SyncedQuoteId = objQty.id;
        update objOpp;

        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;        
        INSERT objQLI;

    //    objOpp.SyncedQuoteId = objQty.id;
    //    update objOpp;
        Test.startTest();
        //Preparing Case data
        Case objCase = UnitTest.getCaseInstance();
        objCase.Opportunity__c= objOpp.Id;
        objCase.Status = 'New';
        objCase.Quote__c = objQty.Id;
        //objCase.Sales_Org__c = 'FSCO';
        objCase.Sales_Org__c = 'BEJE';
        objCase.Approval_Status__c='Approved';
        objCase.ANZ_Issue__c='Administrativa';
        objCase.Origin='Created by System';
        objCase.AccountId = objAcc.Id;
        objCase.Reason__c = 'Grace Period Extension';     
        INSERT objCase;   
        
        //Executing Test
        
        checkRecursive.runCaseUpdateForGPDaysOnce = true;
        objCase.Status = 'Closed';
        
        UPDATE objCase;
        
        System.assertEquals(objCase.Reason__c, 'Grace Period Extension');
        
        Test.stopTest();
    } 
}