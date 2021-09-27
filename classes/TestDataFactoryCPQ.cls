public with sharing class TestDataFactoryCPQ {

    public static Apttus_Config2__PriceList__c getPriceList(String plName) {
        Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c ();
        if(Schema.sObjectType.Apttus_Config2__PriceList__c .isAccessible() && Schema.sObjectType.Apttus_Config2__PriceList__c .isQueryable()){
        priceList = [select Id, Name, CurrencyIsoCode from 
                                                 Apttus_Config2__PriceList__c where Name =: plName];
        }
        return priceList;
    }
    
    public static Product2 getProduct(String pName, String pFamily) {
       Product2 prod = new Product2(
           name=pName, 
           CurrencyIsoCode = 'USD', 
           Family = pFamily, 
           List_Price__c = 10.22
       );
       switch on pFamily{
               when 'CLEAR'{
                   prod.APTS_Cat_L2__c =label.APTS_Clear_Product_Family;
               }
               when 'HighQ'{
                   prod.APTS_Cat_L2__c =label.APTS_HighQ_Product_Family;
               }
               when 'PRINT LEGAL SOLUTIONS'{
                   prod.APTS_Cat_L2__c =label.APTS_Print_Product_Family;
               }
               when 'PROVIEW LEGAL SOLUTIONS'{
                   prod.APTS_Cat_L2__c =label.APTS_Proview_Product_Family;
               }
               when 'Rutter'{
                   prod.APTS_Cat_L3__c =label.APTS_Rutter_Product_Family;
               }
               when 'Case Logistix'{
                   prod.APTS_Cat_L3__c =label.APTS_Case_Logistix_Product_Family;
               }
               when 'Ediscovery'{
                   prod.APTS_Cat_L3__c =label.APTS_Ediscovery_Product_Family;
               }
               
           }
           System.debug(pfamily+'prod.APTS_Cat_L2__c' +prod.APTS_Cat_L2__c);
       return prod;
       
    }
    
    public static Apttus_Config2__ProductConfiguration__c getConfiguration(Apttus_Proposal__Proposal__c proposal, Id priceListId,
        Account act) {
        
        Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(
            Name = 'prod-conf1', 
            CurrencyIsoCode = 'USD', 
            Apttus_QPConfig__Proposald__c = proposal.Id, 
            Apttus_Config2__AccountId__c = act.Id,
            Apttus_Config2__PriceListId__c = priceListId,
            APTS_Incremental_Growth__c = 100.00,
            APTS_New_Holdings__c = 20.00,
            APTS_Current_Holdings__c = 30.00,
            APTS_Lapsed_Holdings__c = 50.00,
            APTS_Additional_Approval_Legal__c = false,
            APTS_Additional_Approval_Other__c = false          
        );

        return prodConf;
    }
    
   public static Apttus_Config2__AssetLineItem__c getAssetLineItem(String strName, Account act,Source_system_detail__c ssd, Product2 prod) {
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(
            Name = strName, 
            Apttus_Config2__ListPrice__c = 12.00, 
            Apttus_Config2__AccountId__c = act.Id, 
            APTS_SSD_Sold_To__c = ssd.Id,
            APTS_Number_of_Attorneys__c = 5,
            Apttus_Config2__ProductId__c = prod.Id,
            Apttus_Config2__NetPrice__c = 10.00,
            Apttus_Config2__BasePrice__c = 12.00,
            APTS_Contract_Term__c = '5 Years', 
            APTS_Year_2_Adjustment__c = '5', 
            Apttus_Config2__EndDate__c= Date.parse('12/15/20'),
            Apttus_Config2__AssetStatus__c = 'New', 
            Apttus_Config2__Quantity__c = 1,
            CurrencyIsoCode = 'USD'
        );
        
        return asset;
    }
    
    public static Apttus_Config2__AssetLineItem__c lapsedAssetLineItem(String name, Account account,Source_system_detail__c ssd, Product2 prod) {
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(
            Name = name, 
            Apttus_Config2__NetPrice__c = 10.00,
            Apttus_Config2__AssetStatus__c = 'Cancelled',
            Apttus_Config2__ListPrice__c = 12.00, 
            Apttus_Config2__AccountId__c = account.Id,
            APTS_SSD_Sold_To__c = ssd.Id, 
            CurrencyIsoCode = 'USD'
        );
        
        return asset;
    }
    
    public static Apttus_Config2__LineItem__c getPRINTConfigLineItem(Apttus_Config2__ProductConfiguration__c prodConfig, Product2 prod, 
        Apttus_Config2__AssetLineItem__c asset) {
        
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__ProductId__c = prod.id
        );
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.Apttus_Config2__LineStatus__c = 'New';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Yr_1_Renewal_Adjustment__c = '4';
        lineItem.APTS_Bridge__c = '5 Months';
        lineItem.APTS_Product_Family__c = Label.APTS_Print_Product_Family_Value;
        
        if(asset != null) {
            lineItem.Apttus_Config2__AssetLineItemId__c = asset.Id;
        }
        
        return lineItem;
    }    
        
}