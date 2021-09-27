/********************************************************************************
Class Name : DCPDynamicBundlingHelper
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBCartQuery{ 

       //Retrive Cart fields
    /**
        @description
        @param cartId
        @return
     */
    public static Apttus_Config2__ProductConfiguration__c  getCartDetails(id cartId){
    
        Apttus_Config2__ProductConfiguration__c objectCart = [SELECT id, name, Apttus_Config2__PriceListId__c,
                      Apttus_QPConfig__Proposald__c,APTS_SSD_Sold_To__c, 
                      Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, 
                      Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,
                      Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 
                      Apttus_Config2__AccountId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, 
                      Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c 
                      WHERE id =: cartId AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Straight Renewal'
                      AND (Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c != 'Government' 
                      OR Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.BU_Segment_Level_2__c != 'Federal')
                      WITH SECURITY_ENFORCED]; 
                      
      return objectCart;
    }
    /**
        @description
        @param configId
        @return
     */  
     public static Map<id,List<Apttus_Config2__LineItem__c>> getCartLineItems(id configId){
        
        Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap = new Map<id,List<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c ln: [SELECT Id,Apttus_Config2__LineStatus__c,APTS_Product_Group_Primary_Material__c,APTS_Totaling_Summary_Group__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Uom__c,Apttus_Config2__PriceUom__c,APTS_Product_Code__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c  ,Apttus_Config2__LineNumber__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c, Apttus_Config2__ConfigurationId__c ,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c ,currencyisocode,Apttus_Config2__SellingTerm__c ,Apttus_Config2__PriceType__c ,Apttus_Config2__LineType__c,Apttus_Config2__ItemSequence__c ,Apttus_Config2__LineSequence__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__ChargeType__c, Apttus_Config2__NetPrice__c  ,Apttus_Config2__NetUnitPrice__c ,Apttus_Config2__PriceMethod__c, APTS_Bundle__c,Apttus_Config2__OptionId__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__HasOptions__c
                                            FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c =: configId
                                            AND (Apttus_Config2__LineStatus__c = 'New' OR Apttus_Config2__LineStatus__c='Amended') 
                                            ORDER BY APTS_Group_Primary_Material_Name__c ASC]){
            
            if(!cartIDToLineItemsMap.containsKey(ln.Apttus_Config2__ConfigurationId__c)){
                cartIDToLineItemsMap.put(ln.Apttus_Config2__ConfigurationId__c, new List<Apttus_Config2__LineItem__c>());
            }
            cartIDToLineItemsMap.get(ln.Apttus_Config2__ConfigurationId__c).add(ln);
        }
        return cartIDToLineItemsMap;
    }
    
    /**
        @description
        @param configId
        @return
     */  
      public static Map<id,List<Apttus_Config2__LineItem__c>> getCartLineItems2(id configId){
        
        Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap = new Map<id,List<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c ln: [SELECT Id,Apttus_Config2__LineStatus__c,APTS_Product_Group_Primary_Material__c,APTS_Totaling_Summary_Group__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Uom__c,Apttus_Config2__PriceUom__c,APTS_Product_Code__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c  ,Apttus_Config2__LineNumber__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c, Apttus_Config2__ConfigurationId__c ,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c ,currencyisocode,Apttus_Config2__SellingTerm__c ,Apttus_Config2__PriceType__c ,Apttus_Config2__LineType__c,Apttus_Config2__ItemSequence__c ,Apttus_Config2__LineSequence__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__ChargeType__c, Apttus_Config2__NetPrice__c  ,Apttus_Config2__NetUnitPrice__c ,Apttus_Config2__PriceMethod__c, APTS_Bundle__c,Apttus_Config2__OptionId__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__HasOptions__c
                                            FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c =: configId
                                            ORDER BY APTS_Group_Primary_Material_Name__c,Apttus_Config2__LineNumber__c  ASC]){
            
            if(!cartIDToLineItemsMap.containsKey(ln.Apttus_Config2__ConfigurationId__c)){
                cartIDToLineItemsMap.put(ln.Apttus_Config2__ConfigurationId__c, new List<Apttus_Config2__LineItem__c>());
            }
            cartIDToLineItemsMap.get(ln.Apttus_Config2__ConfigurationId__c).add(ln);
        }
        return cartIDToLineItemsMap;
    }
    
    
    
}