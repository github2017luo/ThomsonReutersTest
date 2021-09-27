global with sharing class APTS_CustomPricingCallback implements Apttus_Config2.CustomClass.IPricingCallback2{

    private Apttus_Config2.CustomClass.PricingMode mode = null;
    private Apttus_Config2.ProductConfiguration cart = null;
    private Set<ID> lineItemIDs;
    private List<Apttus_Config2__LineItem__c> lineItemsToUpdate;
    
    //Constructor
    global APTS_CustomPricingCallback(){
    
    }
    
    /**
    * Callback at the beginning of the pricing call.
    * Use the start method to initialize state
    * @param cart the cart object
    */
    global void start(Apttus_Config2.ProductConfiguration cart) {
        this.cart = cart;
    }
    
    /**
    * Callback to indicate the pricing mode
    * @param mode the pricing mode
    */
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        this.mode = mode;
        //enum type field -> get current mode of callback -> this could be ADJUSTMENT, BASEPRICE(when
        //goto price) or ROLLOUT (if(Apttus_Config2.CustomClass.PricingMode.BASEPRICE == mode))
    }
    
    /**
    * Callback before pricing the line item collection
    * Use this method to do all required pre-processing to prepare the line items for pricing.
    * @param itemColl the line item collection to pre-process
    */
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
    
    }
    
    /**
    * Callback before pricing the given line item in the line item collection
    * Use this method to do all required pre-processing to prepare the line item for pricing.
    * @param itemColl the line item collectionholding the line item
    * @param lineItemMO the line item to pre-process
    */
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
    
    }
    
    /**
    * Callback after pricing the given line item in the line item collection
    * Use this method to do all required post-processing after the line item is priced
    * @param itemColl the line item collection holding the line item
    * @param lineItemMO the line item to post-process
    */
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
    
    }
    
    /**
    * Callback after pricing the line item collection
    * Use this method to do all required post-processing after line items are priced.
    * @param itemColl the line item collection to post-process
    */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        //get all lineitems
        List<Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        for(Apttus_Config2.LineItem lineItemMO : allLines) {
            // get the main product line item sobject
            Apttus_Config2__LineItem__c lineItemSO = lineItemMO.getLineItemSO();
        }
    }
    
    /**
    * Callback after all batches of line items are processed
    * Use the finish method to release state
    */
    global void finish() {
        // update included line items
        if (!lineItemsToUpdate.isEmpty()) {
            Database.update(lineItemsToUpdate);
            //Clear List
            lineItemsToUpdate.clear();
        }
    }
}