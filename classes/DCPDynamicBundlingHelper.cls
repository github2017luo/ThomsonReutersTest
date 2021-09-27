/********************************************************************************
Class Name : DCPDynamicBundlingHelper
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDynamicBundlingHelper{ 
         
    /**
        @description
        @param groupName
        @return
     */   
     public static List<string> getGroupPicklistValues(String groupName){
        List<string> pickValues= new List<string>();        
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.APTS_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){   
            if(groupName.equals(f.getValue())){
                pickValues.add(f.getValue());
            }    
            
        }       
        return pickValues;
    }
            
    /**
        @description
        @param lineItemList
        @return
     */  
    public static decimal getExistingSubscriptionTotal(List<Apttus_Config2__LineItem__c> lineItemList){
        decimal existingTotal = 0.0;
        for(Apttus_Config2__LineItem__c ln: lineItemList){
            if(ln.Apttus_Config2__NetPrice__c != null && ln.Apttus_Config2__LineStatus__c != 'New'){
                existingTotal += ln.Apttus_Config2__NetPrice__c;
            } 
        }
        return existingTotal;
    }
    
    /**
        @description
        @param lineItemList
        @return
     */
    public static decimal getNewSubscriptionTotal(List<Apttus_Config2__LineItem__c> lineItemList){
        decimal newTotal = 0.0;
        for(Apttus_Config2__LineItem__c ln : lineItemList){
            if(ln.Apttus_Config2__NetPrice__c != null && ln.Apttus_Config2__LineStatus__c == 'New'){
                newTotal += ln.Apttus_Config2__NetPrice__c;
            } 
        }
        return newTotal;
    }
    
    /**
    @description /Calls the Apttus API to update the cart pricing
    @param cartId Id of cart getting repriced
    @return Apttus response
    */
    public static Apttus_CpqApi.CPQ.UpdatePriceResponseDO callApttusPriceUpdateAPI(id cartId){
        
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = cartId;
    
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
        while (result.IsPricePending) {
            result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);  
        }
    
        return result;
        
    }//end of callApttusUpdateAPI() method

     /**
        @description Updates the line item fields based on the values contained in corresponding Apttus SelectedProductDO
        @param cartId Id of cart
        @param selectedProducts Apttus product request object
     * --------------------------NOTE-----------------------------
     * This code has been added as a workaround due to Apttus Summer '19 package having a known issue with addMultiProducts api.
     * Apttus has developed a fix for the issues in Summer '19 package that is in their Winter '19 package.
     * Once Apttus Winter '19 package is used in all environments, this code should be removed.
     * -----------------------------------------------------------
     */
    /*
    public static void updateLineItemFields(Id cartId, List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts){

        Map<id, Apttus_CPQApi.CPQ.SelectedProductDO> productIDtoApttusProductMap = new Map<id, Apttus_CPQApi.CPQ.SelectedProductDO>();

        //Stores a map of product IDs to its corresponding Apttus product request.
        for(Apttus_CPQApi.CPQ.SelectedProductDO apttusProduct : selectedProducts){
            productIDtoApttusProductMap.put(apttusProduct.ProductID, apttusProduct);
        }

        //CRUD Validation
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() 
            || !Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()) {

            return;
        }

        //Query all new, standalone line items that are in the cart
        List<Apttus_Config2__LineItem__c> lineItemList = 
            [SELECT APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,
                Apttus_Config2__SellingTerm__c,Apttus_Config2__Comments__c,Apttus_Config2__BillingFrequency__c,
                Apttus_Config2__SellingFrequency__c,Apttus_Config2__PriceType__c,Apttus_Config2__Frequency__c,
                Apttus_Config2__PriceListItemId__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceUom__c,
                Apttus_Config2__PriceMethod__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,
                APTS_Combination_Key__c,Apttus_Config2__IsCustomPricing__c,Apttus_Config2__Quantity__c,
                Apttus_Config2__ProductId__c
            FROM Apttus_Config2__LineItem__c 
            WHERE Apttus_Config2__ConfigurationId__c =: cartId 
            AND Apttus_Config2__LineStatus__c = 'New'
            AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Standalone'];

        System.debug(LoggingLevel.DEBUG,'lineItemList BEFORE FIELD UPDATE:::::::::::::::::'+lineItemList);
        for(Apttus_Config2__LineItem__c lineItem : lineItemList){

            if(productIDtoApttusProductMap.containsKey(lineItem.Apttus_Config2__ProductId__c)){
                Apttus_CPQApi.CPQ.SelectedProductDO apttusTemp = productIDtoApttusProductMap.get(lineItem.Apttus_Config2__ProductId__c);
                lineItem.APTS_Contract_Term__c = apttusTemp.CustomData.APTS_Contract_Term__c;
                lineItem.APTS_Yr_1_Renewal_Adjustment__c = apttusTemp.CustomData.APTS_Yr_1_Renewal_Adjustment__c;
                lineItem.APTS_Years_2_Plus_Adjustment__c = apttusTemp.CustomData.APTS_Years_2_Plus_Adjustment__c;
                lineItem.Apttus_Config2__SellingTerm__c = apttusTemp.CustomData.Apttus_Config2__SellingTerm__c;
                lineItem.Apttus_Config2__Comments__c = apttusTemp.CustomData.Apttus_Config2__Comments__c;
                lineItem.Apttus_Config2__BillingFrequency__c = apttusTemp.CustomData.Apttus_Config2__BillingFrequency__c;
                lineItem.Apttus_Config2__SellingFrequency__c = apttusTemp.CustomData.Apttus_Config2__SellingFrequency__c;
                lineItem.Apttus_Config2__PriceType__c = apttusTemp.CustomData.Apttus_Config2__PriceType__c;
                lineItem.Apttus_Config2__Frequency__c = apttusTemp.CustomData.Apttus_Config2__Frequency__c;
                lineItem.Apttus_Config2__PriceListItemId__c = apttusTemp.CustomData.Apttus_Config2__PriceListItemId__c;
                lineItem.Apttus_Config2__ChargeType__c = apttusTemp.CustomData.Apttus_Config2__ChargeType__c;
                lineItem.Apttus_Config2__PriceUom__c = apttusTemp.CustomData.Apttus_Config2__PriceUom__c;
                lineItem.Apttus_Config2__PriceMethod__c = apttusTemp.CustomData.Apttus_Config2__PriceMethod__c;
                lineItem.Apttus_Config2__AdjustmentType__c = apttusTemp.CustomData.Apttus_Config2__AdjustmentType__c;
                lineItem.Apttus_Config2__AdjustmentAmount__c = apttusTemp.CustomData.Apttus_Config2__AdjustmentAmount__c;
                lineItem.APTS_Combination_Key__c = apttusTemp.CustomData.APTS_Combination_Key__c;
                lineItem.Apttus_Config2__IsCustomPricing__c = apttusTemp.CustomData.Apttus_Config2__IsCustomPricing__c;
                lineItem.DC_Is_Add_On__c = apttusTemp.CustomData.DC_Is_Add_On__c;

                //Renewals use SelectedProductDO's Quantity, NSE does not.
                if(apttusTemp.Quantity != null){
                    lineItem.Apttus_Config2__Quantity__c = apttusTemp.Quantity;
                }
                else{
                    lineItem.Apttus_Config2__Quantity__c = apttusTemp.CustomData.Apttus_Config2__Quantity__c;
                }
            }
        }
        System.debug(LoggingLevel.DEBUG,'lineItemList AFTER FIELD UPDATE:::::::::::::::::'+lineItemList);
        update lineItemList;
    }*/
    
    /**
        @description
        @param configId
     */
     public static void updateCartToNewStatus(Id configId){

        List<Apttus_Config2__ProductConfiguration__c> configList =new List<Apttus_Config2__ProductConfiguration__c>();
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
            configList = [Select id, name , Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where id =: configId];
        }
        for(Apttus_Config2__ProductConfiguration__c pc : configList){
            
            pc.Apttus_Config2__Status__c = 'New';
        }
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()){
            update configList;
        }
        System.debug(LoggingLevel.DEBUG,'Configuration status list' + configList);
    }
    
    /**
        @description
        @param ln
        @param tempBundleData
        @return updatedbundle;
     */
    public static DCPDBWrapper.BundleData updateBundleDataPrice(Apttus_Config2__LineItem__c ln, DCPDBWrapper.BundleData tempBundleData){
        if((ln.Apttus_Config2__LineStatus__c == 'New' || ln.Apttus_Config2__LineStatus__c == 'Amended')  
            && ((ln.APTS_Product_Code__c != null && !System.Label.APTS_Proflex_Materials.contains(ln.APTS_Product_Code__c))
            || (ln.APTS_Product_Code__c == null && ln.Apttus_Config2__HasOptions__c))){
            tempBundleData.basevalue = tempBundleData.basevalue + ln.Apttus_Config2__BasePrice__c;
            tempBundleData.listvalue = tempBundleData.listvalue + ln.Apttus_Config2__ListPrice__c;
            tempBundleData.adjustvalue = ln.Apttus_Config2__AdjustmentAmount__c;
            tempBundleData.adjusttype = ln.Apttus_Config2__AdjustmentType__c;
        } 

        return tempBundleData;
    }
    
    /**
        @description
        @param ln
        @param tempBundleData
        @return updatedbundle;
     */
    public static DCPDBWrapper.BundleData updateBundleDataName(Apttus_Config2__LineItem__c ln, DCPDBWrapper.BundleData tempBundleData){
        if((ln.Apttus_Config2__LineStatus__c == 'New' || ln.Apttus_Config2__LineStatus__c == 'Amended')  && ln.APTS_Product_Group_Primary_Material__c != null && ln.APTS_Group__c != null){
            tempBundleData.bundlename = ln.APTS_Group_Primary_Material_Name__c+';'+ln.APTS_Group__c+':'+ln.APTS_Product_Group_Primary_Material__c.substringAfter(':');
        }
        return tempBundleData;
    }
    
    /**
        @description
        @param ln
        @param tempBundleData
        @return updatedbundle;
     */
    public static DCPDBWrapper.BundleData updateBundleDataLineStatusCheck(Apttus_Config2__LineItem__c ln, DCPDBWrapper.BundleData tempBundleData){
        System.debug(LoggingLevel.DEBUG,'ln.Apttus_Config2__LineStatus__c'+ln.Apttus_Config2__LineStatus__c);
        if(ln.Apttus_Config2__LineStatus__c =='Amended' || ln.Apttus_Config2__LineStatus__c =='Renewed' || (ln.APTS_Product_Code__c != null && System.Label.APTS_Proflex_Materials.contains(ln.APTS_Product_Code__c) && tempBundleData.bundles.containsKey(tempBundleData.bundlename) )){
            tempBundleData.isNotNewLineItem =true;
        }
        return tempBundleData;
    }
    
     
}