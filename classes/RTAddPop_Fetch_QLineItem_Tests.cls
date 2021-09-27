/***********************************************************************************************
Purpose      : Test Class for RenewalTemplatePriceFormat and RenewalTemplateAddressPopulation
               and RenewalTemplateShipBillAddressPopulation and TRFetchQuoteLineItems 
Developed By : TCS Offshore-Renewal Notice
Date         : 09/20/2016
Changed Log  :
************************************************************************************************/

@isTest(SeeAllData=false)
public class RTAddPop_Fetch_QLineItem_Tests 
{
    static testmethod void testLogicForUpdateQuoteOnCaseClosure()
    {
        UnitTest.createTestData();
        //Preparing Account data
        Decimal totalPrice1;
        Decimal totalPrice2;
        Decimal totalPrice3;
          Account objAcc = UnitTest.getAccountInstance();
         INSERT objAcc;
        
        //Preparing Opportunity data        
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp.Renewal_Flag__c = true;
        //objOpp.CurrencyIsoCode = 'USD';
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
        INSERT objOpp;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;


        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.OpportunityId = objOpp.id;
        objQty.Pricebook2Id = Test.getStandardPricebookId();
        objQty.Approval_Status__c = 'Cancellation Approved';
        objQty.RenewalNoticeComments__c = 'Test Comment';
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
        INSERT objQty;
        
        ///Update Opportunity data
        objOpp.SyncedQuoteId = objQty.Id;
        UPSERT objOpp;
        
        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 2;
        objQLI.UnitPrice = 2000.3;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;        
        INSERT objQLI;
        totalPrice1 = objQLI.Quantity * objQLI.UnitPrice;
        objQLI.UnitPrice = 2000;
        UPSERT objQLI;
        totalPrice2 = objQLI.Quantity * objQLI.UnitPrice;

                
        Test.startTest();
        
        RenewalTemplateAddressPopulation rTAP = new RenewalTemplateAddressPopulation();
        rTAP.opportunityId = objOpp.Id;
        rTAP.getaddressMapping();
        
        TRFetchQuoteLineItems trFetch = new TRFetchQuoteLineItems();
        trFetch.totalPrice = totalPrice1; 
        trFetch.quoteId =objQty.Id;
        trFetch.getqutLineItems();
        trFetch.getRenewalDispatchComments();
        trFetch.getIsoCode();
        trFetch.getTotalAmount();
        trFetch.totalPrice = totalPrice2; 
        trFetch.getTotalAmount();

        
        RenewalTemplatePriceFormat rTPF=new RenewalTemplatePriceFormat();
        rTPF.price = totalPrice1;
        rTPF.getTotalPrice();
        rTPF.price = totalPrice2;
        rTPF.getTotalPrice();
        Test.stopTest();
        
        RenewalTemplateShipBillAddressPopulation rTSBAP=new RenewalTemplateShipBillAddressPopulation();
        rTSBAP.accountId = objAcc.Id;
        rTSBAP.getaddressMapping();
        
    }
}