/* CHANGE HISTORY
 ==================================================================================================================================
Date            Name                    Description
2018-06-19      Srikanth Kota           DLT-9753 - APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
2020-02-10      Benjamin Her            DLT-17814 - Handle accounts with more than 10 assets. Reprice calls moved to this class.
2020-03-25      Benjamin Her            DLT-19819 - Fixed issue with approvals not getting submitted.  
2020-06-29      Brenda Shields          DLT-20241 - Exclude dynamic bundlings for Federal Gov customers  
2020-07-22      Brenda Shields          DLT-20324 - Fix Initial query time out 
2021-02-19      Benjamin Her            DLT-21463 - Dynamic bundles is not added for plus and premium quote when goes to approvals
==================================================================================================================================   
 */
/**
    @description Runs logic for initial reprice, sending for approvals, and dynamic bundling
 */
public class DigitalBundleBatch implements Database.AllowsCallouts, Database.Batchable<Apttus_Config2__ProductConfiguration__c>{
    private static String bundleGroup = System.Label.BundleGroup;

    /**
        @description start() method for batch job
        @param bC Batch job parameter
        @return Iterable of carts to be ran in batch job
     */
    public Iterable<Apttus_Config2__ProductConfiguration__c> start(database.batchablecontext bC){   
        list<Apttus_Config2__ProductConfiguration__c> cartList = new list<Apttus_Config2__ProductConfiguration__c>();   
        list<Product_Account_Detail__c> lstDSNotBypassed = new list<Product_Account_Detail__c>();
        list<string> lstSSDids = new list<string>();
        string strSSDAcct;
        
        // DLT-20324 - Get Digital Subscription records that aren't bypassed to limit cart selection 
        if (schema.sObjectType.Product_Account_Detail__c.isAccessible()) {
            // Get subscriptions whose renewal date is greater than today and with non empty fields that are needed for processing
            lstDSNotBypassed = [SELECT AccountSSD__c  FROM Product_Account_Detail__c 
                            where Bypass_Automation__c = false and AccountSSD__c != null order by AccountSSD__c]; 
            for (Product_Account_Detail__c dsRecord : lstDSNotBypassed) {
                // weed out any duplicates - only process one record for each SSD account record   
                strSSDAcct = String.valueOf(dsRecord.AccountSSD__c).substring(0, 15);
                if (!lstSSDids.contains(strSSDAcct)) {      
                    lstSSDids.add(strSSDAcct);
                }
            }
        }
        system.debug(LoggingLevel.DEBUG,'DS SSD IDs not Bypassed: ' + lstSSDids);   
        // get carts to process based on DS which is not bypassed   
        if (schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()) {            
            cartList = [SELECT id, name, Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, 
                         Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, 
                         Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, 
                         Apttus_Config2__AccountId__c, APTS_SSD_Sold_To__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                         Apttus_CQApprov__Approval_Status__c, 
                         (select id, Apttus_Config2__AdjustmentType__c, Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c 
                         from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1) 
                         FROM Apttus_Config2__ProductConfiguration__c 
                         WHERE is_Digital_Channel__c = TRUE AND Digital_Pending_Cart__c = TRUE AND Apttus_Config2__NumberOfItems__c > 0
                         AND Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c in ('Draft','Approval','In Review','Approved','Approval Required')
                         and APTS_SSD_Sold_To__c in : lstSSDids];
        }
        return cartList;
    }
    
    /**
        @description execute() method for batch jobs
        @param bC Batch job parameter
        @param scope Records being process
     */
    public void execute(Database.BatchableContext bC, List<Apttus_Config2__ProductConfiguration__c> scope){  
        
        try{
            cartPriceUpdateHelper(scope); 
        }
        catch(Exception e){
            DCUtils.trackLog(e,'DigitalBundleBatch','cartPriceUpdateHelper()');
        }   
        try{
            dynamicBundleHelper(getUpdatedCartList(scope));
        }
        catch(Exception e){
            DCUtils.trackLog(e,'DigitalBundleBatch','dynamicBundleHelper()');
        }   
        try{
            cartApprovalHelper(getUpdatedCartList(scope));
        }
        catch(Exception e){
            DCUtils.trackLog(e,'DigitalBundleBatch','cartApprovalHelper()');
        }       

    }
    
    /**
        @description finish() method for batch jobs
        @param info Batch job parameter
     */
    public void finish(Database.BatchableContext info){
        if(!test.isrunningtest()){  
            Database.executeBatch(new Digital_FinalizeCart(), 1);
        }
    }

    /**
        @description Calls callApttusPriceUpdateAPI() when given a list of carts
        @param cartList List of carts to be repriced
     */
    public static void cartPriceUpdateHelper(List<Apttus_Config2__ProductConfiguration__c> cartList){
        
        for(Apttus_Config2__ProductConfiguration__c cart: cartList){ 
            callApttusPriceUpdateAPI(cart.id);
        }  
    }//end of cartPriceUpdateHelper() method

    /**
        @description Calls callApttusApprovalAPI() when given a list of carts
        @param cartList List of carts to be send for approval
     */
    public static void cartApprovalHelper(List<Apttus_Config2__ProductConfiguration__c> cartList){
        
        for(Apttus_Config2__ProductConfiguration__c cart: cartList){ 
            callApttusApprovalAPI(cart);
        }
    }//end of cartApprovalHelper() method

    /**
        @description Calls DCDynamicBundle.performBundling() for Plus/Premium when given a list of carts
        @param cartList List of carts to be processed for dynamic bundling
     */
    public static void dynamicBundleHelper(List<Apttus_Config2__ProductConfiguration__c> cartList){

        list<id> lstQuoteIDs = new list<id>();
        map<id, string> mapQuoteSegment = new map<id, string>();
        map<id, string> mapQuoteLevel2 = new map<id, string>();
        for (Apttus_Config2__ProductConfiguration__c cartItem: cartList) { 
            lstQuoteIDs.add(cartItem.Apttus_QPConfig__Proposald__c);    
        }
        // DLT-20241 - Select fields to determine Government Federal Proposals 
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
             for (Apttus_Proposal__Proposal__c listquote : [SELECT id, APTS_Approval_Segment__c, APTS_SSD_Sold_To__r.BU_Segment_Level_2__c
                        FROM Apttus_Proposal__Proposal__c
                        WHERE id IN: lstQuoteIDs]) {
                mapQuoteSegment.put(listquote.id, listquote.APTS_Approval_Segment__c);  
                mapQuoteLevel2.put(listquote.id, listquote.APTS_SSD_Sold_To__r.BU_Segment_Level_2__c);
                system.debug(LoggingLevel.DEBUG,'Dynamic Bundling: Quote ID: ' + listquote.id
                             + ' Quote Approval Segment: ' + listquote.APTS_Approval_Segment__c
                             + ' Quote Approval Level 2: ' + listquote.APTS_SSD_Sold_To__r.BU_Segment_Level_2__c);
             }
        }


        for(Apttus_Config2__ProductConfiguration__c cart: cartList){ 
            
            List<Apttus_Config2__ProductConfiguration__c> configList = new List<Apttus_Config2__ProductConfiguration__c>(); 
            String quoteType =    cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
            string quoteSegment = mapQuoteSegment.get(cart.Apttus_QPConfig__Proposald__c);
            string quoteBULevel = mapQuoteLevel2.get(cart.Apttus_QPConfig__Proposald__c);
            system.debug(LoggingLevel.DEBUG,'Dynamic Bundling: Cart ID: ' + quoteType + ' Quote Type: ' + quoteType
                             + ' Quote Approval Segment: ' + quoteSegment + ' Quote BU Level 2: ' + quoteBULevel);
            //Bundles the line items for Plus/Premium
            configList.add(cart);
            // Exclude Straight Renewals
            // DLT-20241 - exclude Government Federal Proposals 
            if (!quoteType.equalsIgnoreCase('Straight Renewal') &&
                    (quoteSegment != 'Government' || quoteBULevel != 'Federal')) {
                DCDynamicBundle.performBundling(bundleGroup, configList);   
            }

        }
    }

    //getUpdatedCartList() method
    //Returns an updated list of cart data. 
    //Added DLT-19819
    private static List<Apttus_Config2__ProductConfiguration__c> getUpdatedCartList(List<Apttus_Config2__ProductConfiguration__c> cartList){
        
        Set<id> setCartId = new Set<id>();
        for (Apttus_Config2__ProductConfiguration__c cart : cartList){
            setCartId.add(cart.id);
        }

        return [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, 
                    Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, 
                    Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, 
                    Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                    Apttus_CQApprov__Approval_Status__c,
                    (select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1) 
                FROM Apttus_Config2__ProductConfiguration__c 
                WHERE id IN: setCartId];
    
    }//end of getUpdatedCartList() method

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
        @description Calls the Apttus API to submit for approvals
        @param cart Cart getting sent for approval
     */
    //Added DLT-17814
    public static void callApttusApprovalAPI(Apttus_Config2__ProductConfiguration__c cart){
        if (cart.Apttus_CQApprov__Approval_Status__c == 'Approval Required' 
                                || cart.Apttus_CQApprov__Approval_Status__c == 'Pending Approval' 
                                || cart.Apttus_Config2__Status__c  == 'Approval Required' 
                                || cart.Apttus_Config2__Status__c == 'Pending Approval') {
            
            Apttus_Approval.ApprovalsWebService.submitForApprovals('Apttus_Config2__ProductConfiguration__c', cart.Id);
        }
    }//end of callApttusApprovalAPI() method
}