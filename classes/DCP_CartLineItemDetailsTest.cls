/* Class: DCP_CartLineItemDetailsTest
* Purpose: Test Class for DCP_CartLineItemDetails
* cart page to UI as part of DCP-New Sales
* Created: 02/06/2021
*  
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 02/06/2021   Kanishk           DCP-1947     Test Class created
* =============================================================================
*/

@istest(seealldata=false)
public class DCP_CartLineItemDetailsTest {
    /** 
     * @description : Method to test fetching line items from Cart 
     */
      public static testmethod void getCartLineItemDetails() {
        
        // insert static value
        
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePELeadConvertCode', value__c='LeadConvert'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c='OrderConfirmation'),
            new Static_Values__c(name='LeadSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com')
            };
   
       insert staticCSList;
        
       
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectRefId__c =propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfigObj;
               
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
         prod.ProductCode = '98765';
         prod.Description = 'Test Desc';
         prod.Service_Number__c = '87654';
         prod.Apttus_Filter_Brand__c = 'Test';
         prod.Apttus_Filter_Jurisdiction__c = 'Colorado';
         prod.LCRM_Sub_Bu__c = 'USL';
         prod.Format__c= 'Format';
         prod.IsActive = true;
         prod.CPD_Sellable_Description__c ='Display and Sell';
        system.assert(prod.Name=='prod1','Good to Proceed');
        
        List<Apttus_Config2__LineItem__c> cartLineItemList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfigObj.id , Apttus_Config2__ProductId__c=prod.id);
        li1.Apttus_Config2__AddedBy__c = 'User';
        li1.Apttus_Config2__AdjustedPrice__c = 50;
        li1.Apttus_Config2__AdjustmentAmount__c = 50;
        li1.Apttus_Config2__AdjustmentType__c = '% Discount';
        li1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowProration__c = FALSE;
        li1.Apttus_Config2__AllowRemoval__c = TRUE;
        li1.Apttus_Config2__AutoRenew__c = FALSE;
        li1.Apttus_Config2__BaseExtendedCost__c = 0;
        li1.Apttus_Config2__BaseExtendedPrice__c = 100;
        li1.Apttus_Config2__BasePrice__c = 100;
        li1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li1.Apttus_Config2__ConfigStatus__c = 'Complete';
        li1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li1.Apttus_Config2__Customizable__c = FALSE;
        li1.Apttus_Config2__DeltaPrice__c = 50;
        li1.Apttus_Config2__DeltaQuantity__c = 1;
        li1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li1.Apttus_Config2__ExtendedCost__c = 0;
        li1.Apttus_Config2__ExtendedPrice__c = 100;
        li1.Apttus_Config2__Frequency__c = 'Monthly';
        li1.Apttus_Config2__Guidance__c = 'Red';       
        li1.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li1.Apttus_Config2__ItemSequence__c = 1;
        li1.Apttus_Config2__LineNumber__c = 1;
        li1.Apttus_Config2__LineSequence__c = 1;
        li1.Apttus_Config2__LineStatus__c = 'New';
        li1.APTS_Yr_1_Renewal_Adjustment__c='1';
        li1.Apttus_Config2__LineType__c = 'Product/Service';
        li1.Apttus_Config2__ListPrice__c = 100;
        li1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li1.Apttus_Config2__NetPrice__c = 50;
        li1.Apttus_Config2__NetUnitPrice__c = 50;
        li1.Apttus_Config2__OptionSequence__c = 0;        
        li1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__PriceType__c = 'Recurring';
        li1.Apttus_Config2__PriceUom__c = 'Attorneys';
        li1.Apttus_Config2__PricingStatus__c = 'Complete';       
        li1.APTS_Product_Family__c='RUTTER';
        li1.Apttus_Config2__Quantity__c = 1;
        li1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li1.Apttus_Config2__SellingTerm__c = 1;        
        li1.Apttus_Config2__Taxable__c = FALSE;
        li1.Apttus_Config2__TaxInclusive__c = FALSE;
        li1.Apttus_Config2__Term__c = 1;
        li1.Apttus_Config2__TotalQuantity__c = 1;
        li1.Apttus_Config2__Uom__c = 'Each';        
        li1.CurrencyIsoCode = 'CAD';
        li1.APTS_Product_Family__c = 'CLEAR';
        li1.APTS_Contract_Term__c = '2 Years';
        li1.APTS_Years_2_Plus_Adjustment__c = '5';
        li1.Apttus_Config2__IncentiveCode__c = '';
        li1.APTS_Bridge__c='1 Month';
        cartLineItemList.add(li1);
        insert cartLineItemList;
    
    
         RestRequest req1 = new RestRequest();
         req1.params.put('cartId',prodConfigObj.Id);
         
         req1.requestURI = '/services/apexrest/newsale/DCPGetCartLineItemDetails';  //Request URL
         req1.httpMethod = 'GET';//HTTP Request Type
         req1.addHeader('Content-Type', 'application/json');
         RestContext.request = req1;
         RestResponse res1 = new RestResponse();
         RestContext.response = res1;
         DCP_CartLineItemDetails.getCartLineItemDetails();
         
          
         RestRequest req2 = new RestRequest();
         //req2.params.put('CartId',prodConfigObj.Id);
         
         req2.requestURI = '/services/apexrest/newsale/DCPGetCartLineItemDetails';  //Request URL
         req2.httpMethod = 'GET';//HTTP Request Type
         req2.addHeader('Content-Type', 'application/json');
         RestContext.request = req2;
         RestResponse res2 = new RestResponse();
         RestContext.response = res2;
         DCP_CartLineItemDetails.getCartLineItemDetails();
      }

}