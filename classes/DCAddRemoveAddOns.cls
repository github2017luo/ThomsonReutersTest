/*
* CHANGE HISTORY
* ==================================================================================================================================
* Date         Name                    Description
* 2018-01-25   Ramesh Reddy          DLT-6822 - [Add On Journey] Add On Page available for Plus or Premium Plans
*
*
*Date          Name                    Description
*2018-02-28    Bishnu Prasad         DLT-7666 -[Password Holder information updated with any add-on selections made]
*
* 2018-06-12   Rajan Tatuskar        DLT-9759 - Updates Account/Contact reference For Add On Product classes
* 2018-10-19   Rajan Tatuskar        DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns" 
* 2018-12-20   Benjamin Her          DLT-14153 - Code Scan fixes
* 2019-01-10   Bishanka Dassarma     DLT-14347 - Code Scan Fixes
* 2019-06-21   Harika Sai P          DLT-16918 - [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCBundleSynchronizeControllerTest, DCCartServiceV2
* 2019-06-24   Srikanth kota         DLT-16787- [Code Scan] -Fix code scan MAJOR issues in this DCAcceptQuoteTest ,DCAddRemoveAddOns, DCAddRemoveOnlineContacts
* 2019-06-25   Pavithra              DLT-16916- [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveAddOns, DCAddRemoveAddOns_Test, DCAddRemoveOnlineContacts, DCAddRemoveOnlineContacts_Test
* 2019-06-24   Navleen Kaur          DLT-16914 - Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveAddOns, DCBundleFinalizeService
* 2020-06-18   Brenda Shields        DLT-20162 - Add-on removal not reflecting in confirmation page and landing page, Add-on is displayed in main plan
* 2020-12-02   Benjamin Her          DLT-21025 - PMD Fix
* ==================================================================================================================================   
*/

@RestResource(urlMapping='/digitalconfigurator/DCAddRemoveAddOns/*')
Global with sharing class DCAddRemoveAddOns {
    
    private static Final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static Final String CART_STATUS_FINALIZED = 'Finalized';    
    private static List<DCUtils.OCAddRemoveRequest> ocAddRemoveReqList;
    
    private static String bandedStandardMaterialNum;
    private static Set<String> selectedProducts = new Set<String>();
    private static Map<String, ProductDetails> prodIdProductDetailsMap = new Map<String, ProductDetails>();
    private static Map<String,Integer> productIdsToLineNumber = new Map<String,Integer>();
    private static Integer iQuantity;
    
    /**
* The API used to Add or Remove the AddOn products to Cart.
*/ 
    @HttpPost
    global static DCQuoteUpdate.QuoteUpdateResponse addRemoveAddOns(List<QuoteUpdateRequest> updateDetails){
        DCQuoteUpdate.QuoteUpdateResponse response = new DCQuoteUpdate.QuoteUpdateResponse();
        if(updateDetails == null || (updateDetails != null && updateDetails.isEmpty() )){
            response.responseCode = 400;
            response.responseMessage = 'Invalid Parameters';
            return response;
        }
        DCAddRemoveAddOns service = new DCAddRemoveAddOns();
        response = service.updateAllLineItems(updateDetails); 
        return response;        
    }
    
    /**
* used to Add or Remove the AddOn products to Cart.Return the Pricing status of Quote.
*/    
    
    private DCQuoteUpdate.QuoteUpdateResponse updateAllLineItems(List<QuoteUpdateRequest> landings){
        System.debug('landings  '+landings);
        Set<String> quoteIds = new Set<String>();
        Map<String,QuoteUpdateRequest> quoteIdToUpdateRequestLanding = new Map<String,QuoteUpdateRequest>();
        
        DCQuoteUpdate.QuoteUpdateResponse response = new DCQuoteUpdate.QuoteUpdateResponse();
        
        for(QuoteUpdateRequest landing : landings){
            if(String.isNotBlank(landing.quoteId)){
                quoteIds.add(landing.quoteId);
                quoteIdToUpdateRequestLanding.put(landing.quoteId,landing);
            }else{
                DCUtils.trackLog(new DCCustomException('Missing required parameter \'quoteId\' '),'DCAddRemoveAddons','updateAllLineItems()');
                response.responseCode = 400;
                response.responseMessage = 'Missing required parameter \'quoteId\' ';
                return response;
            }
        }
        System.debug('quoteIds  '+quoteIds);        
        List<Apttus_Config2__ProductConfiguration__c> carts = 
                [SELECT Id, Apttus_QPConfig__Proposald__c, Ecom_No_of_Attorneys__c, 
                Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c,
                Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c, Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,
                Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,
                Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, 
                Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,
                Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,
                Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c,
                Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                (SELECT Id, Name, Apttus_Config2__ProductId__c, DC_Is_Add_On__c, Apttus_Config2__PrimaryLineNumber__c,
                Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.ProductCode, 
                Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__Quantity__c, 
                Apttus_Config2__NetPrice__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,
                APTS_Years_2_Plus_Adjustment__c, APTS_Bridge_Discount__c, APTS_Bridge__c
                FROM Apttus_Config2__LineItems__r 
                WHERE Apttus_Config2__LineStatus__c != :LINE_STATUS_CANCELLED  ) 
                FROM Apttus_Config2__ProductConfiguration__c 
                WHERE Apttus_QPConfig__Proposald__c in : quoteIds 
                AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED  
                WITH SECURITY_ENFORCED];
    
        
        System.debug('carts  '+carts);
        try{
            if(carts.isEmpty() || carts == null){
                throw new DCCustomException('Invalid quoteId or Cart is not finalized.');
            }
            response = updateAllLineItemsHelper(carts,quoteIdToUpdateRequestLanding);

            return response;
        }catch(Exception ex){
            response = new DCQuoteUpdate.QuoteUpdateResponse();
            response.responseCode = 400;
            response.responseMessage = ex.getMessage();
            DCUtils.trackLog(ex,'DCQuoteService','updateAllLineItems');
            return response;
        }    
    }   

    //updateAllLineItemsHelper()
    //Exteneds updateAllLineItems() method
    private static DCQuoteUpdate.QuoteUpdateResponse updateAllLineItemsHelper(List<Apttus_Config2__ProductConfiguration__c> carts,Map<String,QuoteUpdateRequest> quoteIdToUpdateRequestLanding){
    
        DCQuoteUpdate.QuoteUpdateResponse response = new DCQuoteUpdate.QuoteUpdateResponse();

        Map<String,DCQuoteUpdate.QuotePricingStatus> quoteIdToPricingStatus = new Map<String,DCQuoteUpdate.QuotePricingStatus>();
        Map<String,Apttus_Proposal__Proposal__c> quoteIdToToBeUpdatedQuotes = new Map<String,Apttus_Proposal__Proposal__c>();

        ocAddRemoveReqList = new List<DCUtils.OCAddRemoveRequest>();

        for( Apttus_Config2__ProductConfiguration__c cart : carts){
            QuoteUpdateRequest request = quoteIdToUpdateRequestLanding.get(cart.Apttus_QPConfig__Proposald__c);
            
            if(request.productDetails != null && !request.productDetails.isEmpty()){
                
                addMultipleProducts(cart, request);
                DCQuoteUpdate.QuotePricingStatus pricingStatus = new DCQuoteUpdate.QuotePricingStatus();
                pricingStatus.quoteId = cart.Apttus_QPConfig__Proposald__c;
                pricingStatus.isPricingPending = true;
                quoteIdToPricingStatus.put(cart.Apttus_QPConfig__Proposald__c, pricingStatus);
                
                Apttus_Proposal__Proposal__c updateflag = new Apttus_Proposal__Proposal__c(Id = cart.Apttus_QPConfig__Proposald__c,
                                                                                            DC_Contract_Not_In_Sync__c = true);
                quoteIdToToBeUpdatedQuotes.put(cart.Apttus_QPConfig__Proposald__c, updateflag);
            }else{
                throw new DCCustomException('ProductDetails are not present for cart ' + cart.id);
            }     
        }
        if(quoteIdToToBeUpdatedQuotes.values() != null && quoteIdToToBeUpdatedQuotes.size() > 0){
            update quoteIdToToBeUpdatedQuotes.values();
        }
        
        if(!ocAddRemoveReqList.isEmpty()) {
            DCUtils.addRemoveOnlineContacts(ocAddRemoveReqList);
        }
        
        response.quotePricingStatus = quoteIdToPricingStatus.values();

        response = callCartReprice(response);

        response.responseCode = 200;
        response.responseMessage = 'Success';    
        return response;

    }

    //callCartReprice()
    //Calls Apttus reprice service
    private static DCQuoteUpdate.QuoteUpdateResponse callCartReprice(DCQuoteUpdate.QuoteUpdateResponse res ){
        DCQuoteUpdate.QuoteUpdateResponse response = res;
        if(response.quotePricingStatus != null && response.quotePricingStatus.size() > 0){
            String quoteId = response.quotePricingStatus[0].quoteId;
            boolean status = DCUtils.repriceByQuoteId(quoteId);
            response.quotePricingStatus[0].isPricingPending = status;
        }
        return response;
    }

    //setQuantityFromCart() 
    //Gets the quantity from cart line items, else return original
    private static Integer setQuantityFromCart(Integer quantity, Apttus_Config2__ProductConfiguration__c cart){
        Integer tempQuantity = quantity;
        if( cart != null && !cart.Apttus_Config2__LineItems__r.isEmpty()
            && tempQuantity == null || tempQuantity < 1 ){

            tempQuantity = cart.Apttus_Config2__LineItems__r[0].Apttus_Config2__Quantity__c.intValue(); 
        }
        
        return tempQuantity;
    }

    //populateDefaultPricingDetails() 
    //Sets the pricing details for new line item based on existing cart line items
    private static Apttus_Config2__LineItem__c populateDefaultPricingDetails(Apttus_Config2__LineItem__c liSO,Apttus_Config2__ProductConfiguration__c cart){
        Apttus_Config2__LineItem__c customData = liSO;
        
        if( cart != null && !cart.Apttus_Config2__LineItems__r.isEmpty()){
            Apttus_Config2__LineItem__c lineItem = cart.Apttus_Config2__LineItems__r[0];
            customData.Apttus_Config2__AdjustmentAmount__c = lineItem.Apttus_Config2__AdjustmentAmount__c;
            DCUtils.addToLineItem(customData,'Apttus_Config2__AdjustmentType__c',lineItem.Apttus_Config2__AdjustmentType__c);
            DCUtils.addToLineItem(customData,'APTS_Yr_1_Renewal_Adjustment__c',lineItem.APTS_Yr_1_Renewal_Adjustment__c);            
            DCUtils.addToLineItem(customData,'APTS_Years_2_Plus_Adjustment__c',lineItem.APTS_Years_2_Plus_Adjustment__c);           
            DCUtils.addToLineItem(customData,'APTS_Bridge_Discount__c',lineItem.APTS_Bridge_Discount__c);            
            DCUtils.addToLineItem(customData,'APTS_Bridge__c',lineItem.APTS_Bridge__c);           
            DCUtils.addToLineItem(customData,'APTS_Contract_Term__c',lineItem.APTS_Contract_Term__c);
        }

        return customData;
    }

    //populateSelectedProductData()
    //Adds selected products (line items in the cart) to class variables
    private static void populateSelectedProductData(List<ProductDetails> productIds){
        for( ProductDetails req : productIds){
            if(String.isBlank(req.productId)){
                throw new DCCustomException('Missing productId');
            }

            if(req.isSelected != null && req.isSelected ) {
                selectedProducts.add(req.productId);
                prodIdProductDetailsMap.put(req.productId, req);
            }
        }
    }

    //checkCartLineItems()
    //Iterates over all line items in the cart and run logic based on whether line item is an addon or not
    private static void checkCartLineItems(Apttus_Config2__ProductConfiguration__c cart){

            Set<String> standardProductIds = new Set<String>();
            List<Apttus_Config2__LineItem__c> lineItemQuantityUpdatedList = new List<Apttus_Config2__LineItem__c>();

            for( Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
                if(lineItem.DC_Is_Add_On__c != null && lineItem.DC_Is_Add_On__c) {
                    productIdsToLineNumber.put(lineItem.Apttus_Config2__ProductId__c, lineItem.Apttus_Config2__PrimaryLineNumber__c.intValue());
                    lineItemQuantityUpdatedList = addUpdatedAddonProduct(lineItemQuantityUpdatedList,lineItem);

                } else {
                    standardProductIds.add(lineItem.Apttus_Config2__ProductId__c);
                    setBandedStandardMaterialNum(lineItem);
                }
            }
            
            if(Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable() && !lineItemQuantityUpdatedList.isEmpty()) {
                Update lineItemQuantityUpdatedList;
            }
            selectedProducts.removeAll(standardProductIds);

    }

    //addUpdateAddonProduct()
    //Checks if the addon is updated and add to list, else return original list
    private static List<Apttus_Config2__LineItem__c> addUpdatedAddonProduct(List<Apttus_Config2__LineItem__c> lineItemList, Apttus_Config2__LineItem__c lineItem){
        List<Apttus_Config2__LineItem__c> lineItemQuantityUpdatedList = lineItemList;
        if(prodIdProductDetailsMap.containsKey(lineItem.Apttus_Config2__ProductId__c)
            && (prodIdProductDetailsMap.get(lineItem.Apttus_Config2__ProductId__c).noOfUsers != null) 
            && (prodIdProductDetailsMap.get(lineItem.Apttus_Config2__ProductId__c).noOfUsers != lineItem.Apttus_Config2__Quantity__c)) {

            lineItem.Apttus_Config2__Quantity__c = prodIdProductDetailsMap.get(lineItem.Apttus_Config2__ProductId__c).noOfUsers;
            lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
            lineItemQuantityUpdatedList.add(lineItem);
            
        }
        return lineItemQuantityUpdatedList;
    }
    
    //setBandedStandardMaterialNum()
    private static void setBandedStandardMaterialNum(Apttus_Config2__LineItem__c lineItem){
        if((bandedStandardMaterialNum == null) && (lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded')){
            bandedStandardMaterialNum = lineItem.Apttus_Config2__ProductId__r.ProductCode;
        }
    }
 /**
* used to Add and remove products to Cart using Apttus API.
*/
    private static void addMultipleProducts(Apttus_Config2__ProductConfiguration__c cart, QuoteUpdateRequest request){
        List<ProductDetails> productIds = request.productDetails;
        iQuantity = request.quantity;

        try{
            Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
            List<Integer> removablelines = new list<integer>();
            DCUtils.addToLineItem(customData,'Apttus_Config2__BillingFrequency__c','Monthly'); 
            customData.put('DC_Is_Add_On__c',true);

            customData = populateDefaultPricingDetails(customData,cart);

            iQuantity = setQuantityFromCart(iQuantity,cart);
            //Set<String> unselectedProducts = new Set<String>();
            populateSelectedProductData(productIds);

            checkCartLineItems(cart);
            Set<String> lineItemProductIds = productIdsToLineNumber.keyset();
            Set<String> cloneAddProductIds = new Set<String>(selectedProducts);
            cloneAddProductIds.removeAll(lineItemProductIds);
            productIdsToLineNumber.keyset().removeAll(selectedProducts);
            if( !productIdsToLineNumber.isEmpty()) {
                removablelines = new list<integer>(productIdsToLineNumber.values());
                DCUtils.removeLineItems(removablelines, cart.Id);
                
            } 
            List<DCUtils.ProductDetails> utilProductDetailsList = new List<DCUtils.ProductDetails>(); 

            utilProductDetailsList = populateProductDetails(utilProductDetailsList,productIds,cloneAddProductIds);

            if(!utilProductDetailsList.isEmpty()) {
                DCUtils.addMultipleProducts(utilProductDetailsList, cart.Id, customData);
                
                // DLT-20162 Copied code from Cart Creation common code class as new method 
                // to this class as a work-around
                /*
                * --------------------------NOTE-----------------------------
                * This code has been added as a workaround due to Apttus Summer '19 package having a known issue with addMultiProducts api.
                * Apttus has developed a fix for the issues in Summer '19 package that is in their Winter '19 package.
                * Once Apttus Winter '19 package is used in all environments, this code should be removed.
                * -----------------------------------------------------------
                */
                list<Apttus_CPQApi.CPQ.SelectedProductDO> listSelectedProducts = new list<Apttus_CPQApi.CPQ.SelectedProductDO>();
                for (DCUtils.ProductDetails prodDetail : utilProductDetailsList ) {
                    Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
                    selectedProduct.productId = prodDetail.productId;
                    selectedProduct.Quantity = prodDetail.quantity;
                    selectedProduct.comments = 'Inserted via Ecommerce';
                    Map<String,Object> line = customData.getPopulatedFieldsAsMap(); 
                    System.debug('line  '+line);
                    if (line.keySet() != null && line.keySet().size() > 0) {
                        List<String> allFields = new List<String>(line.keySet());
                        selectedProduct.CustomFields = allFields;
                        selectedProduct.CustomData = customData; 
                    }        
                    listSelectedProducts.add(selectedProduct);  
                } 
                updateLineItemFields(cart.Id, listSelectedProducts);
                // DLT-20162 - End new code             
            }  
            
            ocAddRemoveReqList.addAll(updateOCRequestInstance(cart, productIds,new List<String>(cloneAddProductIds)));
            //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        }catch(Exception ex){
            DCUtils.trackLog(ex,'DCAddRemoveAddons','addMultipleProducts()');
        }
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
    }

    //populateProductDetails()
    //populates the product detail request that will be sent to Apttus
    private static List<DCUtils.ProductDetails> populateProductDetails(List<DCUtils.ProductDetails> productDetailList,List<ProductDetails> productIds, Set<String> cloneAddProductIds){
        List<DCUtils.ProductDetails> utilProductDetailsList = productDetailList;
        for(ProductDetails requestProdDetails : productIds) {
            if(cloneAddProductIds.contains(requestProdDetails.productId)) {
                DCUtils.ProductDetails utilProductDetails = new DCUtils.ProductDetails();
                utilProductDetails.productId = requestProdDetails.productId;
                if(requestProdDetails.noOfUsers != null ){
                        utilProductDetails.quantity = requestProdDetails.noOfUsers;
                }
                else{
                    utilProductDetails.quantity = iQuantity;
                }
                utilProductDetailsList.add(utilProductDetails);
            }
        }
        return utilProductDetailsList;
    }

    //addRemovedProductsToOLCRemovalList()
    private static List<DCUtils.OCAddRemoveRequest> addRemovedProductsToOLCRemovalList(List<DCUtils.OCAddRemoveRequest> ocAddRemoveList,Apttus_Config2__ProductConfiguration__c cart){
        List<DCUtils.OCAddRemoveRequest> ocAddRemoveRequestList = ocAddRemoveList;
        List<String> removalProductIdList = new List<String>();
        removalProductIdList.addAll(productIdsToLineNumber.keySet());
        for(String removeProductId : removalProductIdList) { 
            DCUtils.OCAddRemoveRequest addRemoveRequest = new DCUtils.OCAddRemoveRequest(); 
            addRemoveRequest.productId = removeProductId;
            addRemoveRequest.quoteId = cart.Apttus_QPConfig__Proposald__c;
            //*** START :: Added by Rajan :: DLT-9759 - Updates Account/Contact reference For Add On Product classes
            addRemoveRequest.accountId = cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c;
            //*** END :: Added by Rajan :: DLT-9759 - Updates Account/Contact reference For Add On Product classes
            addRemoveRequest.removeOnlineContact = true;
            ocAddRemoveRequestList.add(addRemoveRequest);
        }
        return ocAddRemoveRequestList;
    }

    //getOnlineContactList()
    private static List<DCUtils.OnlineContact> getOnlineContactList(ProductDetails prodDetails, List<Online_Contacts__c> bandedOnlineContactList){
        
        List<DCUtils.OnlineContact> olcList = new List<DCUtils.OnlineContact>();
        if(prodDetails.onlineContacts != null) {
            for(OnlineContacts onlineContact : prodDetails.onlineContacts) {
                DCUtils.OnlineContact dcUtilOC = new DCUtils.OnlineContact();
                dcUtilOC.contactId = onlineContact.contactId;
                dcUtilOC.firstName = onlineContact.firstName;
                dcUtilOC.lastName = onlineContact.lastName;
                dcUtilOC.email = onlineContact.email;
                dcUtilOC.companyId = onlineContact.companyId;
                dcUtilOC.sourceId = onlineContact.sourceId;
                dcUtilOC.onlineContactType = onlineContact.onlineContactType;
                dcUtilOC.onlineContactTypeDescription = onlineContact.onlineContactTypeDescription;
                dcUtilOC.allowContactEmails = onlineContact.allowContactEmails;
                olcList.add(dcUtilOC);
            }
        } 
        else if(!bandedOnlineContactList.isEmpty()) {
            for(Online_Contacts__c onlineContact : bandedOnlineContactList) {
                DCUtils.OnlineContact dcUtilOC = new DCUtils.OnlineContact();
                dcUtilOC.contactId = onlineContact.ContactID__c;
                dcUtilOC.firstName = onlineContact.First_Name__c;
                dcUtilOC.lastName = onlineContact.Last_Name__c;
                dcUtilOC.email = onlineContact.Email__c;
                dcUtilOC.companyId = onlineContact.APTS_Source_System_Detail__c;                              
                dcUtilOC.onlineContactType = onlineContact.Type__c;
                dcUtilOC.onlineContactTypeDescription = onlineContact.Position__c;
                olcList.add(dcUtilOC);
            }
        }
        return olcList;
    }

    @testVisible
    private static List<DCUtils.OCAddRemoveRequest> updateOCRequestInstance(Apttus_Config2__ProductConfiguration__c cart, List<ProductDetails> productDetailsList, List<String> addProductIdList) {

        List<DCUtils.OCAddRemoveRequest> ocAddRemoveRequestList = new List<DCUtils.OCAddRemoveRequest>();
        try{
            List<Online_Contacts__c> bandedOnlineContactList = getBandedOnlineContacts(cart.Apttus_QPConfig__Proposald__c, bandedStandardMaterialNum);
            
            ocAddRemoveRequestList = addRemovedProductsToOLCRemovalList(ocAddRemoveRequestList,cart);

            for(String addProductId : addProductIdList) { 
                for(ProductDetails prodDetails : productDetailsList) {      
                    if(prodDetails.productId == addProductId) {    
                        DCUtils.OCAddRemoveRequest addRemoveRequest = new DCUtils.OCAddRemoveRequest(); 
                        addRemoveRequest.productId = addProductId;
                        addRemoveRequest.quoteId = cart.Apttus_QPConfig__Proposald__c;
                        //*** START :: Added by Rajan :: DLT-9759 - Updates Account/Contact reference For Add On Product classes
                        addRemoveRequest.accountId = cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c;
                        //*** END :: Added by Rajan :: DLT-9759 - Updates Account/Contact reference For Add On Product classes
                        addRemoveRequest.removeOnlineContact = false;
                        addRemoveRequest.onlineContactList = getOnlineContactList(prodDetails,bandedOnlineContactList);
                        ocAddRemoveRequestList.add(addRemoveRequest);
                    }
                }
            }
            System.debug(JSON.serialize(ocAddRemoveRequestList));
            return ocAddRemoveRequestList; 
            //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        }catch(Exception ex){
            //throw ex; //DLT-16787
            DCUtils.trackLog(ex,'DCAddRemoveAddons','updateOCRequestInstance()');
        }
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        return ocAddRemoveRequestList;
    }
    
    private  static List<Online_Contacts__c> getBandedOnlineContacts(String quoteId, String bandedMaterialNumber){
        
        List<Online_Contacts__c> onlineContactList =new List<Online_Contacts__c>();
        try{
            if(Schema.sObjectType.Online_Contacts__c.isAccessible()){
                 onlineContactList =[SELECT Id, Name, APTS_Source_System_Detail__c, Email__c, ContactID__c, First_Name__c, Is_Banded_Product__c, 
                                                         Last_Name__c, Material__c, ProductId__c, Middle_Name__c, QuoteId__c, QuoteLineItem__c, SAP_Account_Number__c,
                                                         Account_Address__c, WLEc_Juris__c, Type__c, Sftwr_Admin__c, Product_Attribute__c,Position__c
                                                         FROM Online_Contacts__c 
                                                         WHERE QuoteId__c = :quoteId And Material__c = :bandedMaterialNumber];
            }       
            return onlineContactList;
        }catch(Exception ex){
            DCUtils.trackLog(ex,'DCAddRemoveAddons','getBandedOnlineContacts()');
        }
        return onlineContactList;
    }
    
    global class QuoteUpdateRequest{
         @testVisible
        private String quoteId;
         @testVisible
        private Integer quantity;
         @testVisible
        private String contractTerm;
        private String quoteType;
         @testVisible
        private List<ProductDetails> productDetails;
    }
    
    public class ProductDetails {
         @testVisible
        private String productId;
         @testVisible
        private Boolean isSelected;
         @testVisible
        private Integer noOfUsers;
         @testVisible
        private List<OnlineContacts> onlineContacts;
    }
    
    public class OnlineContacts {
        private String contactId;
        @testVisible
        private String firstName;
        @testVisible
        private String lastName;
        private String email;
        private String companyId;
        private String sourceId;
        private String onlineContactType;
        private String onlineContactTypeDescription;
        private Boolean allowContactEmails;
    }

    //updateLineItemFields() method
    //Updates the line item fields based on the values contained in corresponding Apttus SelectedProductDO
    //Added DLT-19857
    /*
     * --------------------------NOTE-----------------------------
     * This code has been added as a workaround due to Apttus Summer '19 package having a known issue with addMultiProducts api.
     * Apttus has developed a fix for the issues in Summer '19 package that is in their Winter '19 package.
     * Once Apttus Winter '19 package is used in all environments, this code should be removed.
     * -----------------------------------------------------------
     */
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

        System.debug('lineItemList BEFORE FIELD UPDATE:::::::::::::::::'+lineItemList);
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
        System.debug('lineItemList AFTER FIELD UPDATE:::::::::::::::::'+lineItemList);
        update lineItemList;
    }    
    
}