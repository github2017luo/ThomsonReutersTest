/* CHANGE HISTORY
==================================================================================================================================
Date            Name                    Description

2020-12-14      Benjamin Her            DLT-21165 - Create Dynamic Bundle as a line item (Order Capture update)
==================================================================================================================================   
*/

public without sharing class DCDynamicBundleHelper{

    // Retrive line item based on config ids
    public static Map<Id,List<Apttus_Config2__LineItem__c>> retriveLineItemList(List<Id> configIdsList,Set<String> ineligibleExistingDealsList){

        Map<Id,List<Apttus_Config2__LineItem__c>> itemMap =new Map<Id, List<Apttus_Config2__LineItem__c>>();

        for(Apttus_Config2__LineItem__c item :[SELECT Id, Name, APTS_Deal_Number__c, APTS_DefaultNetPrice__c, Apttus_Config2__BaseExtendedPrice__c,  APTS_Product_Name__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, 
                                               APTS_Product_Or_Option_Name__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ChargeType__c, Apttus_Config2__ExtendedCost__c,Apttus_Config2__Quantity__c, 
                                               Apttus_Config2__ExtendedPrice__c, APTS_Group__c, Apttus_Config2__LineType__c, Apttus_Config2__ListPrice__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PricingStatus__c, 
                                               Apttus_Config2__ProductId__c, Apttus_Config2__ProductOptionId__c, Apttus_Config2__PriceAdjustment__c,Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c,Apttus_Config2__SellingTerm__c, 
                                               Apttus_Config2__NetPrice__c, Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c, Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,  
                                               Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c, Apttus_Config2__ProductId__r.Service_Number__c,Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c, 
                                               Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, 
                                               APTS_Years_2_Plus_Adjustment__c, APTS_YoY_Adjustment_Type__c, APTS_Year_2_Adj_Default__c, APTS_Years_3_5_Adj_Default__c, APTS_Years_6_10_Adj_Default__c, APTS_SAP_Deal_Number__c, 
                                               APTS_SAP_Deal_Type__c, APTS_SAP_Deal_Primary_Material__c, Apttus_Config2__AssetLineItemId__c,APTS_Bundle__c, APTS_Product_Group_Primary_Material__c, APTS_Group_Primary_Material__c, 
                                               APTS_Contract_Term_Default__c, APTS_Group_Primary_Material_Name__c, APTS_Keep_Terms__c, APTS_Max_Discount__c, APTS_WestPack_Discount__c, APTS_SAP_MLA_Agreement_Number__c, 
                                               APTS_Years_2_Plus_Default__c, APTS_Yr_1_Renewal_Default__c, Apttus_Config2__ShipToAccountId__c, APTS_Proposal_Group__r.APTS_Group_Name__c, 
                                               APTS_Proposal_Group__c, APTS_Deal_Type__c, Apttus_Config2__ConfigurationId__c,APTS_Product_Code__c,Apttus_Config2__HasOptions__c,Apttus_Config2__OptionId__c
                                               FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c IN : configIdsList
                                               AND Apttus_Config2__LineStatus__c!= 'Cancelled' 
                                               AND Apttus_Config2__LineType__c ='Product/Service'
                                               AND APTS_SAP_Deal_Type__c not in :ineligibleExistingDealsList order by Name,Apttus_Config2__LineNumber__c]){

            if(itemMap.containsKey(item.Apttus_Config2__ConfigurationId__c)){
                List<Apttus_Config2__LineItem__c> tempList = new List<Apttus_Config2__LineItem__c>();
                tempList = itemMap.get(item.Apttus_Config2__ConfigurationId__c);
                tempList.add(item);
                itemMap.put(item.Apttus_Config2__ConfigurationId__c, tempList);
            }else{
                List<Apttus_Config2__LineItem__c> tempList = new List<Apttus_Config2__LineItem__c>();
                tempList.add(item);
                itemMap.put(item.Apttus_Config2__ConfigurationId__c, tempList);
            }
        }
        
        return itemMap;
    }
    
    /**
     * Get summary group based on Configuration ids
    */
    public static void createSummaryGroup(Map<Id, APTS_Group__c> grpMap, List<id> configIds){
        List<Apttus_Config2__SummaryGroup__c> removeGroup = new List<Apttus_Config2__SummaryGroup__c>();
        List<Apttus_Config2__SummaryGroup__c> addGroup = new List<Apttus_Config2__SummaryGroup__c>();
        List<Apttus_Config2__SummaryGroup__c> summaryGrouplist = new List<Apttus_Config2__SummaryGroup__c>();
        if(Schema.sObjectType.Apttus_Config2__SummaryGroup__c.isAccessible()){
         summaryGrouplist=  [ SELECT Apttus_Config2__AdHocGroupDescription__c,Apttus_Config2__AdjustedPrice__c,Apttus_Config2__AdjustmentAmount__c,
                                                                   Apttus_Config2__AdjustmentType__c,Apttus_Config2__AllowableAction__c,Apttus_Config2__AllowManualAdjustment__c,Apttus_Config2__AllowRemoval__c,
                                                                   Apttus_Config2__BaseExtendedCost__c,Apttus_Config2__BaseExtendedPrice__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ClassificationId__c,
                                                                   Apttus_Config2__Comments__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__Description__c,
                                                                   Apttus_Config2__ExtendedCost__c,Apttus_Config2__ExtendedListPrice__c,Apttus_Config2__ExtendedPrice__c,Apttus_Config2__ExtendedRollupPrice__c,
                                                                   Apttus_Config2__Frequency__c,Apttus_Config2__GroupAdjustmentPercent__c,Apttus_Config2__GroupType__c,Apttus_Config2__IsPrimaryLine__c,
                                                                   Apttus_Config2__ItemSequence__c,Apttus_Config2__LineNumber__c,Apttus_Config2__LineType__c,Apttus_Config2__NetAdjustmentPercent__c,
                                                                   Apttus_Config2__NetPrice__c,Apttus_Config2__OptionCost__c,Apttus_Config2__OptionPrice__c,Apttus_Config2__PriceAdjustmentAmount__c,
                                                                   Apttus_Config2__PriceAdjustmentType__c,Apttus_Config2__PriceAdjustment__c,Apttus_Config2__RulesetName__c,Id,Name FROM Apttus_Config2__SummaryGroup__c  
                                                                   WHERE Apttus_Config2__ConfigurationId__c IN :configIds
                                                                  ];
        
        }
        System.debug('-----------summaryGrouplist-'+ summaryGrouplist.size());
        
        for(Apttus_Config2__SummaryGroup__c smg : summaryGrouplist){
            System.debug('name  ------'+ smg.Name);
            
            
            if(smg.Apttus_Config2__LineType__c == 'Group Total'){
                removeGroup.add(smg);
            }
            
            if(smg.Apttus_Config2__LineType__c =='Total'){
                addGroup.add(smg.clone());
            }
            
        }
        System.debug('removeGroup -------------- '+ removeGroup.size());
        System.debug('addGroup --------------'+ addGroup.size());
        if (Schema.sObjectType.Apttus_Config2__SummaryGroup__c.isDeletable()) {
            delete removeGroup;
         }
        
        for(Apttus_Config2__SummaryGroup__c smg : addGroup){
            smg.Apttus_Config2__LineType__c = 'Group Total';
            smg.Apttus_Config2__LineNumber__c= 1;
            smg.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            smg.Name = smg.Name.replace('Total', grpMap.get(smg.Apttus_Config2__ConfigurationId__c).APTS_Primary_Material__c +' ' +' Bundle A');
            System.debug('name  ---39 ---'+ smg.Name);
        }
        if(Schema.sObjectType.Apttus_Config2__SummaryGroup__c.isCreateable()){
            insert addGroup;
        }
        updateLineItemSummaryGroup(addGroup, configIds);

    }
    private static void updateLineItemSummaryGroup(List<Apttus_Config2__SummaryGroup__c> addGroup, List<id> configIds){
        
        List<Apttus_Config2__LineItem__c> itemList= new List<Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2__LineItem__c item :[SELECT  Id, Name, APTS_Deal_Number__c, APTS_DefaultNetPrice__c, Apttus_Config2__BaseExtendedPrice__c,  APTS_Product_Name__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, 
                                               APTS_Product_Or_Option_Name__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ChargeType__c, Apttus_Config2__ExtendedCost__c,Apttus_Config2__Quantity__c, 
                                               Apttus_Config2__ExtendedPrice__c, APTS_Group__c, Apttus_Config2__LineType__c, Apttus_Config2__ListPrice__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PricingStatus__c, 
                                               Apttus_Config2__ProductId__c, Apttus_Config2__ProductOptionId__c, Apttus_Config2__PriceAdjustment__c,Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c,Apttus_Config2__SellingTerm__c, 
                                               Apttus_Config2__NetPrice__c, Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c, Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,  
                                               Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c, Apttus_Config2__ProductId__r.Service_Number__c,Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c, 
                                               Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, 
                                               APTS_Years_2_Plus_Adjustment__c, APTS_YoY_Adjustment_Type__c, APTS_Year_2_Adj_Default__c, APTS_Years_3_5_Adj_Default__c, APTS_Years_6_10_Adj_Default__c, APTS_SAP_Deal_Number__c, 
                                               APTS_SAP_Deal_Type__c, APTS_SAP_Deal_Primary_Material__c, Apttus_Config2__AssetLineItemId__c,APTS_Bundle__c, APTS_Product_Group_Primary_Material__c, APTS_Group_Primary_Material__c, 
                                               APTS_Contract_Term_Default__c, APTS_Group_Primary_Material_Name__c, APTS_Keep_Terms__c, APTS_Max_Discount__c, APTS_WestPack_Discount__c, APTS_SAP_MLA_Agreement_Number__c, 
                                               APTS_Years_2_Plus_Default__c, APTS_Yr_1_Renewal_Default__c, Apttus_Config2__ShipToAccountId__c, APTS_Proposal_Group__r.APTS_Group_Name__c, 
                                               APTS_Proposal_Group__c, APTS_Deal_Type__c   
                                               FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c IN :configIds
                                               AND Apttus_Config2__LineStatus__c!= 'Cancelled' 
                                               AND Apttus_Config2__LineType__c ='Product/Service' order by Name,Apttus_Config2__LineNumber__c]){
            if(!addGroup.isEmpty() && addGroup[0]!=null && addGroup[0].id!=null){
                item.Apttus_Config2__SummaryGroupId__c = addGroup[0].Id;
            }
            itemList.add(item);
        }
        
        try{
            if(Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
                update itemList;
            }
        }catch(Exception ex){
            System.debug('Exception ex ------------'+ ex);
        }
    }
    
    // get group line items if any
    public static list<APTS_Group__c> getGrouplnItems(Set<Id> proposalIds){
        list<APTS_Group__c> listOfGroups = new list<APTS_Group__c>();
        if(Schema.sObjectType.APTS_Group__c.isAccessible()){
        listOfGroups =  [SELECT Id, Name, APTS_Adjustment_Value__c, APTS_Adjustment_Type__c,APTS_Primary_Material__c, APTS_Agreement__c, APTS_Discount__c, APTS_GrossAmount__c, APTS_Group_Name__c, APTS_Group_Name_Original__c, APTS_NetAmount__c, APTS_ProductConfiguration__c, APTS_Quote_Proposal__c, APTS_Online_Incremental__c, APTS_Existing_Agreement_Total__c, APTS_MLA__c, APTS_Decentralized__c FROM APTS_Group__c WHERE APTS_Quote_Proposal__c IN : proposalIds];
        }
        return listOfGroups;
    }
    
    public static List<APTS_Quote_Agreement_Locations__c> getExistingAgreementLocations(Set<Id> proposalIds){
        List<APTS_Quote_Agreement_Locations__c> listOfLocation = new List<APTS_Quote_Agreement_Locations__c>();
        if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isAccessible()){
        listOfLocation = [Select Id, APTS_Subscriber_Location__c, APTS_Status__c FROM APTS_Quote_Agreement_Locations__c WHERE APTS_Quote_Proposal__c IN: proposalIds]; 
        }
        return listOfLocation;
    }
    
    public static List<APTS_Additional_Subscription_Actions__c> getExistingSubscriptionActions(Set<Id> proposalIds){
        List<APTS_Additional_Subscription_Actions__c> listOfActions = new List<APTS_Additional_Subscription_Actions__c>();
        if(Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isAccessible()){
        listOfActions =[Select Id, APTS_Subscription_Number__c, APTS_Product__c FROM APTS_Additional_Subscription_Actions__c WHERE APTS_Quote_Proposal__c IN: proposalIds];
        }
        return listOfActions;
    }


    
    public static Apttus_Config2__LineItem__c getFirstLineItem(List<Apttus_Config2__LineItem__c> lnItems){

        if(lnItems != null && lnItems.size() > 0){
            return lnItems.get(0);
        }
        else{
            return new Apttus_Config2__LineItem__c();
        }
    }
    
    public static Map<id,List<Apttus_Config2__LineItem__c>> getCartLineItems(List<id> configIds){
        
        Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap = new Map<id,List<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c ln: [SELECT Id,Apttus_Config2__LineStatus__c,APTS_Product_Group_Primary_Material__c,APTS_Totaling_Summary_Group__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Uom__c,Apttus_Config2__PriceUom__c,APTS_Product_Code__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c  ,Apttus_Config2__LineNumber__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c, Apttus_Config2__ConfigurationId__c ,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c ,currencyisocode,Apttus_Config2__SellingTerm__c ,Apttus_Config2__PriceType__c ,Apttus_Config2__LineType__c,Apttus_Config2__ItemSequence__c ,Apttus_Config2__LineSequence__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__ChargeType__c, Apttus_Config2__NetPrice__c  ,Apttus_Config2__NetUnitPrice__c ,Apttus_Config2__PriceMethod__c, APTS_Bundle__c,Apttus_Config2__OptionId__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__HasOptions__c
                                            FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c IN: configIds
                                            AND (Apttus_Config2__LineStatus__c = 'New' OR Apttus_Config2__LineStatus__c='Amended') 
                                            ORDER BY APTS_Group_Primary_Material_Name__c ASC]){
            
            if(!cartIDToLineItemsMap.containsKey(ln.Apttus_Config2__ConfigurationId__c)){
                cartIDToLineItemsMap.put(ln.Apttus_Config2__ConfigurationId__c, new List<Apttus_Config2__LineItem__c>());
            }
            cartIDToLineItemsMap.get(ln.Apttus_Config2__ConfigurationId__c).add(ln);
        }
        return cartIDToLineItemsMap;
    }

    public static Map<id,List<Apttus_Config2__LineItem__c>> getCartLineItems2(List<id> configIds){
        
        Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap = new Map<id,List<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c ln: [SELECT Id,Apttus_Config2__LineStatus__c,APTS_Product_Group_Primary_Material__c,APTS_Totaling_Summary_Group__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Uom__c,Apttus_Config2__PriceUom__c,APTS_Product_Code__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c  ,Apttus_Config2__LineNumber__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c, Apttus_Config2__ConfigurationId__c ,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c ,currencyisocode,Apttus_Config2__SellingTerm__c ,Apttus_Config2__PriceType__c ,Apttus_Config2__LineType__c,Apttus_Config2__ItemSequence__c ,Apttus_Config2__LineSequence__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__ChargeType__c, Apttus_Config2__NetPrice__c  ,Apttus_Config2__NetUnitPrice__c ,Apttus_Config2__PriceMethod__c, APTS_Bundle__c,Apttus_Config2__OptionId__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__HasOptions__c
                                            FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c IN: configIds
                                            ORDER BY APTS_Group_Primary_Material_Name__c,Apttus_Config2__LineNumber__c  ASC]){
            
            if(!cartIDToLineItemsMap.containsKey(ln.Apttus_Config2__ConfigurationId__c)){
                cartIDToLineItemsMap.put(ln.Apttus_Config2__ConfigurationId__c, new List<Apttus_Config2__LineItem__c>());
            }
            cartIDToLineItemsMap.get(ln.Apttus_Config2__ConfigurationId__c).add(ln);
        }
        return cartIDToLineItemsMap;
    }
    
    public static boolean isValidPrint(String tabName, Apttus_Config2__LineItem__c li){
        if (tabName == 'Print' && li.APTS_SAP_Deal_Number__c!=null && li.APTS_SAP_Deal_Type__c!=null) {
            return true;
        }
        else{
            return false;
        }
    }
    public static boolean isValidOnlineSoftware(String tabName, Apttus_Config2__LineItem__c li){
        if (tabName == 'Online/Software' && li.APTS_SAP_MLA_Agreement_Number__c!=null){
            return true;
        }
        else{
            return false;
        }
    }
    public static String getKeyValue(String tabName,Apttus_Config2__LineItem__c li){
        if(tabName == 'Print' && li.APTS_SAP_Deal_Number__c!=null && li.APTS_SAP_Deal_Type__c!=null){
            return li.APTS_SAP_Deal_Number__c + li.APTS_SAP_Deal_Type__c;
        } else{
            return li.APTS_SAP_MLA_Agreement_Number__c;
        }
    }
    public static void removeSingleValueKey(Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap){
        //So only values with more than one value are assigned to a bundle
        for(String key : assetPreGroupMap.keySet()){
            if(assetPreGroupMap.get(key).size() < 2){
            assetPreGroupMap.remove(key);
            }
        }
    }
    public static decimal getLowestLineNumber(List<Apttus_Config2__LineItem__c> lilist){
        decimal lineNumber;
        for(Apttus_Config2__LineItem__c li : lilist){
            if(lineNumber == null && li.Apttus_Config2__LineNumber__c != null){
                lineNumber = li.Apttus_Config2__LineNumber__c;
            }
            else if(li.Apttus_Config2__LineNumber__c != null && li.Apttus_Config2__LineNumber__c < lineNumber){
                lineNumber = li.Apttus_Config2__LineNumber__c;
            }
        }
        return lineNumber;
    }
    
    public static decimal getExistingSubscriptionTotal(List<Apttus_Config2__LineItem__c> lineItemList){
        decimal existingTotal = 0.0;
        for(Apttus_Config2__LineItem__c ln: lineItemList){
            if(ln.Apttus_Config2__NetPrice__c != null && ln.Apttus_Config2__LineStatus__c != 'New'){
                existingTotal += ln.Apttus_Config2__NetPrice__c;
            } 
        }
        return existingTotal;
    }
    public static decimal getNewSubscriptionTotal(List<Apttus_Config2__LineItem__c> lineitemlist){
        decimal newTotal = 0.0;
        for(Apttus_Config2__LineItem__c ln : lineItemList){
            if(ln.Apttus_Config2__NetPrice__c != null && ln.Apttus_Config2__LineStatus__c == 'New'){
                newTotal += ln.Apttus_Config2__NetPrice__c;
            } 
        }
        return newTotal;
    }
    
    public static void updateCartToNewStatus(List<Id> configIds){

        List<Apttus_Config2__ProductConfiguration__c> configList =new List<Apttus_Config2__ProductConfiguration__c>();
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
            configList = [Select id, name , Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where id in : configIds];
        }
        for(Apttus_Config2__ProductConfiguration__c pc : configList){
            
            pc.Apttus_Config2__Status__c = 'New';
        }
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()){
            update configList;
        }
        System.debug('Configuration status list' + configList);
    }
}