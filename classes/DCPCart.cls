/**
    @description Product Configuration (Cart) data layer class for DCP projects.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
    2021-06-02      Vishnu Santhosh     DCP-1781 Added getCartLineItems method
    2021-07-19      Vishnu Santhosh     DCP-2144 Added AssetLineItem.ProposalField for query in getCartLineItems method
    2021-07-23      Kavya S             DCP-3193 Added a query qualifier tag
    2021-09-02       Vishnu Santhosh     DCP-2942 Added field - Has Options, Line Type Fields in Query for getFinalizeCartFromProposal method
 */
public without sharing class DCPCart{

    private static final String CART_STATUS_FINALIZED = 'Finalized';

    /**
        @description Stores the queried Product Configuration (Cart)
     */
    public static List<Apttus_Config2__ProductConfiguration__c> cartList;
    public static List<Apttus_Config2__LineItem__c> lineItemList;
    
    /**
        @description Run queries on Product Configuration (Cart)object
        @param cartIds List of Product Configuration (Cart) ids to query
        @return Returns the queried Product Configuration (Cart)
     */
    public static List<Apttus_Config2__ProductConfiguration__c> getCart(List<id> cartIds){
        cartList=   
                [SELECT id,Apttus_Config2__Status__c,
                    APTS_Proposal_Business_Unit__c,
                    (SELECT id, Name, 
                    Apttus_Config2__PricingStatus__c                   
                    FROM Apttus_Config2__LineItems__r
                    WHERE Apttus_Config2__LineStatus__c != 'Cancelled')
                FROM Apttus_Config2__ProductConfiguration__c
                WHERE id IN : cartIds
                WITH SECURITY_ENFORCED];
                
        return cartList;
    }    
    
    /**
        @description Queries for the Finalized Cart
         NOTE: Only a single cart can ever be finalized on a Proposal
        @param proposals Proposal ID where finalized cart is pulled from
        @return Returns the queried Product Configuration (Cart)
     */
    public static List<Apttus_Config2__ProductConfiguration__c> getFinalizeCartFromProposal(List<Apttus_Proposal__Proposal__c> proposals){
        cartList=   
                [SELECT id,Apttus_QPConfig__Proposald__c, APTS_Current_Holdings__c, Rollup_Net_Price__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                APTS_SSD_bill_to__r.APTS_Apttus_Customer_Pricing_Segment__c,APTS_SSD_bill_to__r.Digital_Firm__c,Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c,
                Apttus_QPConfig__Proposald__r.Contract_Type__c,APTS_Approval_Segment__c,APTS_Proposal_Business_Unit__c,
                    (SELECT id,Apttus_Config2__BillingFrequency__c,APTS_Contract_Term__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,
                    Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,
                    Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Product_Name__c,APTS_Product_Pricing_Model__c,Apttus_Config2__LineStatus__c,
                    Apttus_Config2__ListPrice__c,Apttus_Config2__AssetLineItemId__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c,
                    Apttus_Config2__BasePrice__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c,
                    Apttus_Config2__HasOptions__c,Apttus_Config2__LineType__c
                    FROM Apttus_Config2__LineItems__r
                    WHERE Apttus_Config2__LineStatus__c != 'Cancelled')
                FROM Apttus_Config2__ProductConfiguration__c
                WHERE  Apttus_QPConfig__Proposald__c IN: proposals
                AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED
                WITH SECURITY_ENFORCED];
                
        return cartList;
    }

    /**
    @description Retrieve cart Line Items from a single cart
    @param cartId Cart Id to get the associated line items
    @return lineItemList List of queried Line Items 
    */
    public static List<Apttus_Config2__LineItem__c> getCartLineItems(Id cartId){

        lineItemList = [SELECT  id, 
                        Name, 
                        Apttus_Config2__Quantity__c, 
                        APTS_Product_Pricing_Model__c, 
                        Apttus_Config2__PricingStatus__c, 
                        APTS_Product_Name__c,
                        Apttus_Config2__ProductId__c,
                        Apttus_Config2__NetPrice__c,
                        Apttus_Config2__AssetLineItemId__r.Apttus_QPConfig__ProposalId__c,
                        APTS_Combination_Key__c,
                        APTS_Combination_Key__r.APTS_Attribute_Value1__r.name,
                        APTS_Combination_Key__r.APTS_Attribute_Value3__r.name,
                        Apttus_Config2__ProductId__r.ProductCode,
                        Apttus_Config2__ProductId__r.name,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__c,
                        APTS_Contract_Number__c
                        FROM Apttus_Config2__LineItem__c
                        WHERE Apttus_Config2__ConfigurationId__c =: cartId
                        AND Apttus_Config2__LineStatus__c != 'Cancelled'];
        return lineItemList;
    }
    /**
        @description Updates Account object
        @param accUpdateList List of account ids to update
     */
    /**
    public static void updateCart(List<Apttus_Config2__ProductConfiguration__c> cartUpdateList){
        Database.SaveResult[] results = Database.update(cartUpdateList,false);
    }
    */
}