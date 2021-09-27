/**
 * This test class is used to test the OrderConfirmationController class.  That class builds order information for the Order 
 * Confirmation email
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-02-21   Brenda Shields          DLT-19568 - For Option Products, display the Option Product Name, not the Product name
 * =============================================================================
 */
/** 
 * @description Select order details to display on the Order Confirmation Email
 */ 
public with sharing class OrderConfirmationController {
	/** 
 	 * @description Select order ID
	 */ 
    public string orderId {get;set;}
    //public List<Apttus_Config2__OrderLineItem__c> OrderLineItemList;
    public List<Apttus_Config2__LineItem__c> orderLineItemList;
    /** 
 	 * @description Select splash char for bullet in front of Product Names
 	 */ 
    public string splcharStr {get;set;}
    
    /*
    public List<Apttus_Config2__OrderLineItem__c> getOrderLineItemList(){
        system.debug('-----Rajan---Inside getter-----orderId---' + orderId);
        if(!String.isBlank(orderId)){
            OrderLineItemList = [SELECT id,name,Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name, 
                                    APTS_Contract_Term__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Quantity__c 
                                FROM Apttus_Config2__OrderLineItem__c 
                                WHERE Apttus_Config2__OrderId__c =: orderId];
        }
        return OrderLineItemList;
    }
    */
    
    /** 
 	 * @description select the order details
 	 * @return List of Order Line Items
 	 */
    public List<Apttus_Config2__LineItem__c> getOrderLineItemList(){
        system.debug(LoggingLevel.INFO, '-----Rajan---Inside getter-----orderId---' + orderId);
        if(!String.isBlank(orderId)){
            orderLineItemList = [SELECT id,name,Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name, 
            						Apttus_Config2__OptionId__r.Name, Apttus_Config2__LineType__c,
                                    APTS_Contract_Term__c,Apttus_Config2__SellingFrequency__c,Apttus_Config2__Quantity__c,
                                    Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c,
                                    Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.id
                                FROM Apttus_Config2__LineItem__c 
                                WHERE (Apttus_Config2__ConfigurationId__c != null AND Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c != null 
                                AND Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =: orderId)];
            
            
        }
        return orderLineItemList;
    }
    
    /** 
 	 * @description set bullet char for Product Listing
 	 */    
    public OrderConfirmationController(){
        splcharStr = '•';
    }
}