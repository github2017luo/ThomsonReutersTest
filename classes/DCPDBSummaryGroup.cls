/********************************************************************************
Class Name : DCPDynamicBundlingHelper
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBSummaryGroup{ 

   
    /**
     * Get summary group based on Configuration ids
    */
    /**
        @description
        @param grpMap
        @param configId
     */
    public static void createSummaryGroup(Map<Id, APTS_Group__c> grpMap, id configId ){
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
                                                                   WHERE Apttus_Config2__ConfigurationId__c =: configId
                                                                  ];
        
        }
        System.debug(LoggingLevel.DEBUG,'-----------summaryGrouplist-'+ summaryGrouplist.size());
        
        for(Apttus_Config2__SummaryGroup__c smg : summaryGrouplist){
            System.debug(LoggingLevel.DEBUG,'name  ------'+ smg.Name);
            
            
            if(smg.Apttus_Config2__LineType__c == 'Group Total'){
                removeGroup.add(smg);
            }
            
            if(smg.Apttus_Config2__LineType__c =='Total'){
                addGroup.add(smg.clone());
            }
            
        }
        System.debug(LoggingLevel.DEBUG,'removeGroup -------------- '+ removeGroup.size());
        System.debug(LoggingLevel.DEBUG,'addGroup --------------'+ addGroup.size());
        if (Schema.sObjectType.Apttus_Config2__SummaryGroup__c.isDeletable()) {
            delete removeGroup;
         }
        
        for(Apttus_Config2__SummaryGroup__c smg : addGroup){
            smg.Apttus_Config2__LineType__c = 'Group Total';
            smg.Apttus_Config2__LineNumber__c= 1;
            smg.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            smg.Name = smg.Name.replace('Total', grpMap.get(smg.Apttus_Config2__ConfigurationId__c).APTS_Primary_Material__c +' ' +' Bundle A');
            System.debug(LoggingLevel.DEBUG,'name  ---39 ---'+ smg.Name);
        }
        if(Schema.sObjectType.Apttus_Config2__SummaryGroup__c.isCreateable()){
            insert addGroup;
        }
        updateLineItemSummaryGroup(addGroup, configId );

    }
    
    private static void updateLineItemSummaryGroup(List<Apttus_Config2__SummaryGroup__c> addGroup, id configId ){
        
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
                                               FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :configId 
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
            System.debug(LoggingLevel.DEBUG,'Exception ex ------------'+ ex);
        }
    }
    
    
    
}