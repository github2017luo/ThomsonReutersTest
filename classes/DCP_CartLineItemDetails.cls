/* Class: DCP_CartLineItemDetails
* Purpose: This service provides the cart line items present on the view 
* cart page to UI as part of DCP-New Sales
* Created: 2/06/2021 
*  
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2/06/2021   Kanishk           DCP-1947    GetCartLineItemDetails Service created 
* =============================================================================
*/

/** 
 * @description : This is the class to fetch line items from Cart 
 */ 
@RestResource(urlMapping='/newsale/DCPGetCartLineItemDetails/*')
global with sharing class DCP_CartLineItemDetails {
    /** 
     * @description : Method to fetch line items from Cart 
     */ 
    @Httpget
    global static void getCartLineItemDetails(){
 
        RestRequest req = RestContext.request;
        RestResponse res = new RestResponse();
        string cartId = req.params.get('cartId');
        List<Apttus_Config2__LineItem__c> cartLineItemList = new List<Apttus_Config2__LineItem__c>();
        String outputJSON;
        res = RestContext.response;
        if(cartId != null){
           cartLineItemList = retrieveCartLineItems(cartId);
        }
        
        system.debug(LoggingLevel.Info,'cartLineItemList:'+cartLineItemList);
        JSONGenerator gen = JSON.createGenerator(true);
        if(!cartLineItemList.isEmpty()){
            gen = DCP_CartLineItemDetails.responseMethod(gen,true);
            outputJSON = '['+gen.getAsString();
       
            outputJSON += ','+JSON.serialize(cartLineItemList)+']';
            outputJSON = outputJSON.replaceAll('Apttus_Config2__','').replaceAll('__c','').replaceAll('APTS_','').replaceAll('_','');
                  
        }else{
            gen = DCP_CartLineItemDetails.responseMethod(gen,false);
            outputJSON = '['+gen.getAsString()+']';
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        try{ 
            RestContext.response.responseBody = Blob.valueOf(outputJSON);
        }catch(Exception e){
            system.debug(LoggingLevel.Info,'Exception:'+e);
            TRStoreLeadprocess.logTRSException('GetCartLineItemDetails Failed', string.valueof(e), 'GetCartLineItemDetailsService for AutoPromo', cartId, 'Product Configuration', 'GetCartLineItemDetails', '', false);
        }
    }
    
    private static JSONGenerator responseMethod(JSONGenerator gen1, Boolean isSuccess){
          JSONGenerator gen = gen1;
      gen.writeStartObject(); 
            gen.writeFieldName('status');
            gen.writeStartObject();
            gen.writeStringField('statusDesc',(isSuccess)?TRStoreConstants.DETAILS_FOUND:TRStoreConstants.DETAILS_NOT_FOUND);
            gen.writeStringField('statusCode',(isSuccess)?TRStoreConstants.SUCCESS_CODE:TRStoreConstants.DETAILS_NOT_FOUND_CODE);
            gen.writeStringField('status',TRStoreConstants.SUCCESS_STATUS);
            gen.writeEndObject();
      gen.writeEndObject();
      return gen;
    }

/********************************************************************************************************
* retrieveCartLineItems: Method to retrieve the cart line item details for the given cart id. 
* @description : Method to fetch line items from Cart
* @param cartId : Cart id
* @input cartId
* @return : List of cart line items
*********************************************************************************************************/
    public static List<Apttus_Config2__LineItem__c> retrieveCartLineItems(String cartId){
        List<Apttus_Config2__LineItem__c> cartLineItems = new List<Apttus_Config2__LineItem__c>();
        try{
           if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
           cartLineItems = [SELECT APTS_Approval_Segment__c,APTS_Auto_Renew_Price_Basis__c,APTS_Auto_Renew_Price_Percentage__c,APTS_Availability_Date__c,APTS_Billing_Frequency_Default__c,APTS_Bridge_Discount__c,APTS_Bridge_Eligibility__c,APTS_Bridge_Length__c,APTS_Bridge_Monthly_Charge__c,APTS_Bridge__c,APTS_Bundle__c,APTS_Calculated_Auto_Renewal__c,
                APTS_Calculated_Min_YOY__c,APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_Canada_Approval_Required__c,APTS_Cancelled_Adjustment_Amount__c,APTS_Cat_L5__c,APTS_Combination_Key__c,APTS_Contract_End_Date__c,APTS_Contract_Line_Number__c,APTS_Contract_Number__c,
                APTS_Contract_Start_Date__c,APTS_Contract_Term_Default__c,APTS_Contract_Term_Number__c,APTS_Contract_Term_Whole_Years__c,APTS_Contract_Term__c,APTS_Corporate_Approval_Required__c,APTS_Corporate_Select_Option__c,APTS_Count_APP__c,APTS_Customer_Category__c,APTS_Customer_Group__c,APTS_Deal_Not_Complete__c,APTS_Deal_Number__c,APTS_Deal_Type__c,
                APTS_DefaultNetPrice__c,APTS_End_Date__c,APTS_ExposurePack_Approval_Required__c,APTS_Exposure_Pack_Disc__c,APTS_FLDirectoryProducts__c,APTS_FLDirectory_Approval_Required__c,APTS_FL_Current_price__c,APTS_FL_Qty__c,APTS_FL_Renewal_List_Price__c,APTS_FL_Renewal_Only_Clone__c,APTS_Format__c,APTS_Frozen_Market_Segment__c,APTS_FS_IM_Approval_Required__c,
                APTS_Government_Approval_Required__c,APTS_Group_Primary_Material_Name__c,APTS_Group_Primary_Material__c,APTS_Group_Type__c,APTS_Group__c,APTS_Guidance_Approval_Required__c,APTS_Has_Online_Assets__c,APTS_Industry_Code__c,APTS_Info_PlanType__c,APTS_Is_Multi_Tiered_Pricing__c,APTS_Item_Category_Group__c,APTS_Keep_Terms__c,APTS_Legal_Contract_Clauses__c,
                APTS_Line_Level_Approval_Required__c,APTS_Margin_Type__c,APTS_MaxQuantity_Approval_Required__c,APTS_Max_Discount__c,APTS_Max_Effective_Discount__c,APTS_Media_High_Level_Code__c,APTS_Media_High_Level__c,APTS_New_Bridge_Discount__c,APTS_NFC_Qty_Approval_Required__c,APTS_Number_of_Attorneys_on_Acct__c,APTS_Number_of_Attorneys__c,APTS_Original_Quantity__c,
                APTS_PAGEO_Price__c,APTS_Partial_Year_Charge_Eligible__c,APTS_PPC_Approval_Required__c,APTS_PPC_Landing_Approval_Required__c,APTS_PPC_Mgmt_Fee_Override__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Print_Branding__c,APTS_Print_Product_Approval_Required__c,APTS_Print_Purchase_Options__c,APTS_Print_Type__c,APTS_Product_Code__c,APTS_Product_Details__c,
                APTS_Product_Detail__c,APTS_Product_Family__c,APTS_Product_Group_Primary_Material__c,APTS_Product_Name__c,APTS_Product_Or_Option_Name__c,APTS_Product_Pricing_Model__c,APTS_Product_Variant_ID__c,APTS_Program_ID__c,APTS_Promo_Quote_Yearly_Value__c,APTS_Proposal_Business_Unit__c,APTS_Proposal_Group__c,APTS_Purchase_Options__c,APTS_Renewal_Description__c,
                APTS_Renewal_Type_Default__c,APTS_Renewal_Type__c,APTS_RepType_Approval_Required__c,APTS_Rep_Type_Description__c,APTS_RLP_FLApproval_Required__c,APTS_SAP_Deal_Number__c,APTS_SAP_Deal_Primary_Material__c,APTS_SAP_Deal_Type__c,APTS_SAP_MLA_Agreement_Number__c,APTS_Service_Number__c,APTS_Short_Term_Bridge_Approval__c,APTS_Small_Law_Approval_Required__c,
                APTS_SSD_ship_to__c,APTS_Start_Date__c,APTS_Subscription_Number__c,APTS_Tax_Prof_Renewal_Type__c,APTS_Term_Type__c,APTS_Todays_Date__c,APTS_Totaling_Summary_Group__c,APTS_Total_Contract_Length__c,APTS_User_Lookup__c,APTS_WaivedProduct_Approval_Required__c,APTS_WestPack_Discount__c,APTS_WLEC_Product_Category__c,APTS_Yearly_Total__c,
                APTS_Years_2_3_Charges_Disc_Surc__c,APTS_Years_2_Plus_Adjustment__c,APTS_Years_2_Plus_Default__c,APTS_Years_3_5_Adjustment__c,APTS_Years_3_5_Adj_Default__c,APTS_Years_6_10_Adjustment__c,APTS_Years_6_10_Adj_Default__c,APTS_Year_2_3_Price__c,APTS_Year_2_Adjustment__c,APTS_Year_2_Adj_Default__c,APTS_YoY_Adjustment_Type__c,APTS_YOY_Least_Increase__c,
                APTS_Yr_1_Renewal_Adjustment__c,APTS_Yr_1_Renewal_Default__c,APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,Apttus_Config2__AddedByRuleInfo__c,Apttus_Config2__AddedBy__c,Apttus_Config2__AdHocGroupId__c,Apttus_Config2__AdjustedPrice__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,
                Apttus_Config2__AllocateGroupAdjustment__c,Apttus_Config2__AllowableAction__c,Apttus_Config2__AllowManualAdjustment__c,Apttus_Config2__AllowProration__c,Apttus_Config2__AllowRemoval__c,Apttus_Config2__AssetId__c,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__AssetQuantity__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__AutoRenewalTerm__c,
                Apttus_Config2__AutoRenewalType__c,Apttus_Config2__AutoRenew__c,Apttus_Config2__BaseCostOverride__c,Apttus_Config2__BaseCost__c,Apttus_Config2__BaseExtendedCost__c,Apttus_Config2__BaseExtendedPrice__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__BasePriceOverride__c,Apttus_Config2__BasePrice__c,Apttus_Config2__BaseProductId__c,
                Apttus_Config2__BillingFrequency__c,Apttus_Config2__BillingPreferenceId__c,Apttus_Config2__BillingRule__c,Apttus_Config2__BillToAccountId__c,Apttus_Config2__ChargeGroupId__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ClassificationHierarchyInfo__c,Apttus_Config2__ClassificationHierarchy__c,Apttus_Config2__ClassificationId__c,Apttus_Config2__CollaborationParentLineNumber__c,
                Apttus_Config2__CollaborationRequestId__c,Apttus_Config2__Comments__c,Apttus_Config2__CommitmentQuantity__c,Apttus_Config2__ConfigStatus__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConstraintCheckStatus__c,Apttus_Config2__ContractNumbers__c,Apttus_Config2__CopySourceBundleNumber__c,Apttus_Config2__CopySourceLineNumber__c,Apttus_Config2__CopySourceNumber__c,
                Apttus_Config2__Cost__c,Apttus_Config2__CouponCode__c,Apttus_Config2__Customizable__c,Apttus_Config2__DeltaPrice__c,Apttus_Config2__DeltaQuantity__c,Apttus_Config2__DerivedFromId__c,Apttus_Config2__Description__c,Apttus_Config2__EndDate__c,Apttus_Config2__ExtendedCost__c,Apttus_Config2__ExtendedDescription__c,Apttus_Config2__ExtendedPrice__c,Apttus_Config2__ExtendedQuantity__c,
                Apttus_Config2__FlatOptionPrice__c,Apttus_Config2__Frequency__c,Apttus_Config2__GroupAdjustmentPercent__c,Apttus_Config2__Guidance__c,Apttus_Config2__HasAttributes__c,Apttus_Config2__HasBaseProduct__c,Apttus_Config2__HasDefaults__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__HasOptions__c,Apttus_Config2__HasTieredPrice__c,Apttus_Config2__HideCopyAction__c,
                Apttus_Config2__HideInvoiceDisplay__c,Apttus_Config2__IncentiveAdjustmentAmount__c,Apttus_Config2__IncentiveBasePrice__c,Apttus_Config2__IncentiveCode__c,Apttus_Config2__IncentiveExtendedPrice__c,Apttus_Config2__IncentiveId__c,Apttus_Config2__IncentiveType__c,Apttus_Config2__IsAssetPricing__c,Apttus_Config2__IsCustomPricing__c,Apttus_Config2__IsHidden__c,Apttus_Config2__IsOptional__c,
                Apttus_Config2__IsOptionRollupLine__c,Apttus_Config2__IsPrimaryLine__c,Apttus_Config2__IsPrimaryRampLine__c,Apttus_Config2__IsQuantityModifiable__c,Apttus_Config2__IsReadOnly__c,Apttus_Config2__IsSellingTermReadOnly__c,Apttus_Config2__IsUsageTierModifiable__c,Apttus_Config2__ItemSequence__c,Apttus_Config2__LineNumber__c,Apttus_Config2__LineSequence__c,Apttus_Config2__LineStatus__c,
                Apttus_Config2__LineType__c,Apttus_Config2__ListPrice__c,Apttus_Config2__LocationId__c,Apttus_Config2__MaxPrice__c,Apttus_Config2__MaxUsageQuantity__c,Apttus_Config2__MinMaxPriceAppliesTo__c,Apttus_Config2__MinPrice__c,Apttus_Config2__MinUsageQuantity__c,Apttus_Config2__NetAdjustmentPercent__c,Apttus_Config2__NetPrice__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__OptionCost__c,
                Apttus_Config2__OptionGroupLabel__c,Apttus_Config2__OptionId__c,Apttus_Config2__OptionPrice__c,Apttus_Config2__OptionSequence__c,Apttus_Config2__OrderLineItemId__c,Apttus_Config2__OrderLineStatus__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__PaymentTermId__c,Apttus_Config2__PriceAdjustmentAmount__c,Apttus_Config2__PriceAdjustmentAppliesTo__c,Apttus_Config2__PriceAdjustmentType__c,
                Apttus_Config2__PriceAdjustment__c,Apttus_Config2__PriceGroup__c,Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__PriceListId__c,Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__PricingDate__c,Apttus_Config2__PricingGuidance__c,Apttus_Config2__PricingStatus__c,Apttus_Config2__PricingSteps__c,
                Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Apttus_Config2__ProductVersion__c,Apttus_Config2__Quantity__c,Apttus_Config2__RelatedAdjustmentAmount__c,Apttus_Config2__RelatedAdjustmentAppliesTo__c,Apttus_Config2__RelatedAdjustmentType__c,Apttus_Config2__RelatedItemId__c,Apttus_Config2__RelatedPercentAppliesTo__c,
                Apttus_Config2__RelatedPercent__c,Apttus_Config2__RenewalAdjustmentAmount__c,Apttus_Config2__RenewalAdjustmentType__c,Apttus_Config2__RollupPriceMethod__c,Apttus_Config2__RollupPriceToBundle__c,Apttus_Config2__SellingFrequency__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__SellingUom__c,Apttus_Config2__ServiceLocationId__c,Apttus_Config2__ShipToAccountId__c,Apttus_Config2__StartDate__c,
                Apttus_Config2__StatusDetails__c,Apttus_Config2__SummaryGroupId__c,Apttus_Config2__SyncStatus__c,Apttus_Config2__Taxable__c,Apttus_Config2__TaxCodeId__c,Apttus_Config2__TaxInclusive__c,Apttus_Config2__Term__c,Apttus_Config2__TotalQuantity__c,Apttus_Config2__TransferPriceLineItemId__c,Apttus_Config2__UnitCostAdjustment__c,Apttus_Config2__UnitPriceAdjustmentAuto__c,
                Apttus_Config2__UnitPriceAdjustmentManual__c,Apttus_Config2__Uom__c,Apttus_CQApprov__Approval_Status__c,Apttus_Filter_Brand__c,Apttus_product_variant__c,CurrencyIsoCode,Customer_Accepted_IPAddress__c,Customer_Pricing_Segment__c,DC_Is_Add_On__c,Findlaw_LapseApproval_Required__c,FL_Years_2_3_Charges__c,Id,Inventory_Applicable__c,Inventory_Available_Product_Detail__c,
                LastActivityDate,Mark_Removed__c,Name,Product_level_5__c,Product_URL__c,Rollup_Base_Price__c,Rollup_Netprice__c,SAP_Account_Number__c,TRStore_Site__c FROM Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:cartId];
           }
        }catch(Exception e){
          system.debug(LoggingLevel.Info,'Exception:'+e);  
        }
        return cartLineItems;
    }
}