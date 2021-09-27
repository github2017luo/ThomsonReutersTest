/*
* Class provided webservices to get the Journey details based on Lead Id
* CHANGE HISTORY
* ==================================================================================================================================
* Date          Name                 Description
* 2019-02-06    Ramesh Reddy            DLT-14806 - [NSE ALL][Tech Story] Salesforce service to get journey details
* 2021-03-04    Benjamin Her            DLT-21500 - Name not displayed with cart is forwarded
* ==================================================================================================================================   
*/
/**
    @description Rest Service that provides NSE offer detail when offer is forwarded.
*/
@RestResource(urlMapping='/ecom/getJourneyDetails/*')
global with sharing class Ecom_GetJourneyDetails {

    Map<String,Map<String,List<Ecom_StoreResponse.Material>>> productIdToMaterials = new Map<String,Map<String,List<Ecom_StoreResponse.Material>>>();
    Map<String,List<Ecom_StoreResponse.PriceMatrix>> productToPriceMatricesMap = new Map<String,List<Ecom_StoreResponse.PriceMatrix>>();
    Map<String,Map<String, Ecom_StoreResponse.Adjustments>> productIdToDiscounts = new Map<String,Map<String, Ecom_StoreResponse.Adjustments>>();
    public static string selectedContractTerm;
    public static string selectedPlanId;

    /**
        @description Returns offer details
        @param leadId Id of lead
        @return Returns offer details
     */
    @HTTPPost
    global static Ecom_Response getJourneyDetails(String leadId){
        
        Ecom_Response res = new Ecom_Response();
        if(String.isBlank(leadId)){
            throw new DCCustomException('lead Id should not be null');
        }
        try{
            res = getDetails(leadId);
        } catch(Exception ex) {
            DCUtils.trackLog(ex, 'Ecom_GetJourneyDetails', 'getJourneyDetails');
            throw new DCCustomException(ex.getMessage() ,ex);
        }
        return res;
    }
    /**
        @description Gets order details based on leadId
        @param leadId Id of the lead
        @return Returns the order details
     */
    public static Ecom_Response getDetails(String leadId){
        
        Ecom_Response res = new Ecom_Response();
        Ecom_OrderRequest orderRes = new Ecom_OrderRequest();
        Lead lead;
        
        if(Schema.sObjectType.Lead.isQueryable()) { 
            lead = [Select Id, Name, APTSECOM_Order__c, ConvertedAccountId, ConvertedOpportunityID, ConvertedContactId, IsConverted, 
                        APTSECOM_Order__r.Name, APTSECOM_Order__r.APTSECOM_Customer_Details__c, APTSECOM_Order__r.APTSECOM_Total_Price__c, APTSECOM_Order__r.APTSECOM_Plan_Name__c, APTSECOM_Order__r.APTSECOM_Store__c
                     From Lead 
                     Where Id =: leadId];
        } else {
            throw new DCCustomException('Lead object does not have access for this User: '+UserInfo.getUserId());
        }
        
        
        if( lead.APTSECOM_Order__r.APTSECOM_Customer_Details__c != null) {
            Ecom_OrderRequest.cls_storeOrder storeOrder = (Ecom_OrderRequest.cls_storeOrder)JSON.deserialize(lead.APTSECOM_Order__r.APTSECOM_Customer_Details__c, Ecom_OrderRequest.cls_storeOrder.class);
            orderRes.storeOrder = storeOrder;
            selectedContractTerm = storeOrder.selectedProducts[0].contractTerm;
            selectedPlanId = storeOrder.planId;
        }
        
        List<Apttus_Proposal__Proposal__c> proposals;
        
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable() && !Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()) {
            throw new DCCustomException('Proposal object does not have access for this User: '+UserInfo.getUserId());
        }
        
        if(lead.ConvertedOpportunityID != null){
            proposals = [SELECT Id, Name,
                        (SELECT Id FROM Apttus_QPConfig__Configurations__r)
                        FROM Apttus_Proposal__Proposal__c 
                        WHERE Apttus_Proposal__Opportunity__c =: lead.ConvertedOpportunityId
                        WITH SECURITY_ENFORCED];         
        }
        
        Ecom_GetJourneyDetails journeyService = new Ecom_GetJourneyDetails();
        res = journeyService.getAllProducts(orderRes.storeOrder, res);
        
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_References();
        ref.leadId = lead.Id;
        ref.orderId = lead.APTSECOM_Order__c;
        ref.accountId = lead.ConvertedAccountId;
        ref.contactId = lead.ConvertedContactId;
        ref.opportunityId = lead.ConvertedOpportunityId;
        ref.orderNumber = lead.APTSECOM_Order__r.Name;
        populateProposalCartInfo(ref,proposals);
     
        orderRes.references = ref;
        res.orderInfo = orderRes;
        return res;
    } 
    private static void populateProposalCartInfo(Ecom_OrderRequest.cls_References ref,List<Apttus_Proposal__Proposal__c> proposals){
        if(proposals != null && proposals.size() > 0) {
            ref.proposalId = proposals[0].Id; 
            ref.cartId = proposals[0].Apttus_QPConfig__Configurations__r.isEmpty() ? null : proposals[0].Apttus_QPConfig__Configurations__r[0].Id;
            ref.proposalNumber = proposals[0].Name;
        }  
    }

    /**
        @description Returns response of product details
        @param storeOrder The order request
        @param res The response, to be modifed
        @return Returns the modified response
     */
    public Ecom_Response getAllProducts(Ecom_OrderRequest.cls_storeOrder storeOrder, Ecom_Response res){
        if(storeOrder == null){ 
            System.debug(LoggingLevel.DEBUG,'storeOrder is null');
        }
        
        String storeName = storeOrder.storeName;
        String planId = storeOrder.planId; 
        Ecom_OrderRequest.cls_selectedProducts[] selectedProducts = storeOrder.selectedProducts;
        Set<Id> productIdSet = new Set<Id>();
        Set<Id> rProductIdSet = new Set<Id>();
        for(Ecom_OrderRequest.cls_selectedProducts prod : selectedProducts){
            if(prod.isRecommendedProduct == 'true'){
                rProductIdSet.add(prod.productId);
            }else{
                productIdSet.add(prod.productId);    
            }
            
        }
        
        Ecom_StoreService store = new Ecom_StoreService();
         
        List<APTSECOM_Store__c> adjustments = [SELECT  Id, name, APTSECOM_Store_Title__c, APTSECOM_Max_No_Of_PerSeatUsers__c, APTSECOM_Adjustment_Amount__c,
                                                 APTSECOM_Adjustment_Type__c, APTSECOM_Max_No_Of_Attorneys__c, APTSECOM_Category_Hierarchy__c,
                                                 APTSECOM_Price_List__c, APTSECOM_Default_Contract_Term__c, Max_Quantity_PM_Recom_PerSeat__c,
                                                 Max_Quantity_PM_Recom_Banded__c,
                                                 APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Least_Prices__c, 
                                               (SELECT id,name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,Contract_Term__c 
                                                FROM New_Sales_Contract_Term_Settings__r 
                                                WHERE Related_Category_Hierarchy__c =: planId ),
                                               (SELECT id,APTSECOM_Category_Hierarchy__c,APTSECOM_Adjustment_Type__c,APTSECOM_Adjustment_Amount__c 
                                                FROM Store_Price_Adjustments__r 
                                                WHERE APTSECOM_Category_Hierarchy__c =: planId ) 
                                               FROM APTSECOM_Store__c 
                                               WHERE Name =: storeName 
                                               WITH SECURITY_ENFORCED];
        res.recomProducts = getRecommendedProducts(rProductIdSet, adjustments[0]);
        productToPriceMatricesMap = store.getPriceMatrixV2(productIdSet,3, adjustments[0].APTSECOM_Customer_Pricing_Segment__c);
        productIdToMaterials =  store.getDigitalProductsBySelectedProducts(productIdSet);
        productIdToDiscounts =  getDiscount(adjustments);
         
        res.planProducts = wrap( productIdSet, planId);
        return res;
    }
    
    /**
        @description Populates product details
        @param productIdSet Set of products in the order
        @param planId Id of the plan
        @return Returns a list of products in the order
     */
    public List<Ecom_StoreResponse.cls_products> wrap(Set<Id> productIdSet, string planId){
        System.debug(LoggingLevel.DEBUG,' planId '+planId);
        System.debug(LoggingLevel.DEBUG,'productToPriceMatricesMap '+productToPriceMatricesMap.keySet());
        List<Ecom_StoreResponse.cls_products> itemsList = new List<Ecom_StoreResponse.cls_products>();
                
        if(!Schema.sObjectType.Product2.isQueryable()) {
            throw new DCCustomException('Product object does not have access for this User: '+UserInfo.getUserId());
        }
        List<Product2> prods = [Select Id,Name,Subscription_Number__c,Apttus_Config2__ConfigurationType__c,productCode,Service_Number__c,DC_Jurisdiction__c,DC_Long_Description__c,DC_Short_Description__c,DC_Product_Title__c,Apttus_Filter_Jurisdiction__c,APTS_Product_Pricing_Model__c 
                                From Product2 Where id in :productIdSet];
        
        for (Product2 prodDetail : prods) {
            
            Ecom_StoreResponse.cls_products item = new Ecom_StoreResponse.cls_products();
            item.productId = prodDetail.Id;
            item.productName = prodDetail.Name;
            item.productTitle =  prodDetail.DC_Product_Title__c;
            item.jurisdiction = prodDetail.DC_Jurisdiction__c; 
            item.longDescription = prodDetail.DC_Long_Description__c; 
            item.shortDescription = prodDetail.DC_Short_Description__c; 
            item.pricingModel = prodDetail.APTS_Product_Pricing_Model__c; 
            item.cType = prodDetail.Apttus_Config2__ConfigurationType__c;  
            
            Ecom_StoreService store = new Ecom_StoreService();
            
            List<Ecom_StoreResponse.PriceMatrix> matrices = productToPriceMatricesMap.get(prodDetail.Id);
            Map<String,Ecom_StoreResponse.Adjustments> contractTermAdjustments = productIdToDiscounts.get(planId);
            
            List<Ecom_StoreResponse.PriceMatrix> matrices1 = new List<Ecom_StoreResponse.PriceMatrix>();
            if(matrices != null)
            {
                matrices1 = store.getDiscountedPriceByPriceMatrix(matrices, contractTermAdjustments );
            }
            item.priceMatrix = matrices1;  // check
            
           item.material = new List<Ecom_StoreResponse.Material>();
            if(productIdToMaterials.get(prodDetail.Id) != null && productIdToMaterials.get(prodDetail.Id).get(prodDetail.Subscription_Number__c) != null )
            {
                item.material = productIdToMaterials.get(prodDetail.Id).get(prodDetail.Subscription_Number__c);                    
            }
            itemsList.add(item);
        } 
        
        return itemsList; 
    }
    /**
        @description Gets the discount values
        @param adjustments Ecom Store variable
        @return Returns map of planId to contractTerm to adjustmentt
     */
    public Map<String,Map<String, Ecom_StoreResponse.Adjustments>> getDiscount(List<APTSECOM_Store__c> adjustments){
        Map<String,Map<String, Ecom_StoreResponse.Adjustments>> categoryToContractTermDiscount = new Map<String,Map<String, Ecom_StoreResponse.Adjustments>>();
        Map<String, Ecom_StoreResponse.Adjustments> categoryToDiscount = new Map<String, Ecom_StoreResponse.Adjustments>();
        getStoreAdjustment(categoryToDiscount,adjustments);
        
        // iterate contract term adjustments
        for(New_Sales_Contract_Term_Setting__c contractTerm : adjustments[0].New_Sales_Contract_Term_Settings__r){
            // id,name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,Contract_Term__c
            
            if(categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c) == null)
            {
                categoryToContractTermDiscount.put(contractTerm.Related_Category_Hierarchy__c, New Map<String, Ecom_StoreResponse.Adjustments>());
            }
            if(String.isBlank(contractTerm.Contract_Term__c))
            {
                continue;
            }
            
            Ecom_StoreResponse.Adjustments ads = categoryToDiscount.get(contractTerm.Related_Category_Hierarchy__c);
            if( ads == null || String.isBlank(ads.adjustmentType) || ads.adjustmentAmount == null ){
                ads = new Ecom_StoreResponse.Adjustments();
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            Ecom_StoreResponse.Adjustments newAdjustment = Ecom_StoreService.calculateAdjustment(contractTerm.Adjustment_Amount__c, contractTerm.Adjustment_Type__c, ads.adjustmentAmount, ads.adjustmentType);
            
            if(categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).get(contractTerm.Contract_Term__c) == null)
            {
                categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).put(contractTerm.Contract_Term__c, newAdjustment);
            }
        }
        
        return categoryToContractTermDiscount;
    }
    private void getStoreAdjustment(Map<String, Ecom_StoreResponse.Adjustments> categoryToDiscount,List<APTSECOM_Store__c> adjustments){
        for(APTSECOM_Store_Price_Adjustment__c adjustment : adjustments[0].Store_Price_Adjustments__r){
            Ecom_StoreResponse.Adjustments ads = new Ecom_StoreResponse.Adjustments();
            ads.adjustmentType = adjustment.APTSECOM_Adjustment_Type__c;
            ads.adjustmentAmount = adjustment.APTSECOM_Adjustment_Amount__c;
            // Update to default values if values are empty
            if(String.isBlank(adjustment.APTSECOM_Adjustment_Type__c) || adjustment.APTSECOM_Adjustment_Amount__c == null ){
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            categoryToDiscount.put(adjustment.APTSECOM_Category_Hierarchy__c, ads);
        }
    }
    /**
        @description Returns list of recommended products found in the order
        @param prodset Set of product id for the recommended product found in the order
        @param store Ecom store variable
        @return Returns list of recommended product found in the order
     */
    public List<Ecom_Recommendation.Product> getRecommendedProducts(Set<Id> prodset, APTSECOM_Store__c store){
        
        Ecom_Recommendation rec = new Ecom_Recommendation();
        System.debug(LoggingLevel.DEBUG,'prodset '+prodset);
        List<Product2> prods = [Select Id,Name,Subscription_Number__c,productCode,Service_Number__c,DC_Jurisdiction__c,DC_Long_Description__c,DC_Short_Description__c,DC_Product_Title__c,Apttus_Filter_Jurisdiction__c,APTS_Product_Pricing_Model__c 
                                From Product2 Where id in :prodset];
        
        setContractTermAdjustments(rec);

        Decimal adjustmentAmount = store.APTSECOM_Adjustment_Amount__c != null ? store.APTSECOM_Adjustment_Amount__c : 0.0;
        rec.adjustmentAmount = adjustmentAmount ;
        rec.adjustmentType  = store.APTSECOM_Adjustment_Type__c;
        
        set<Id> bandedProducts = new set<Id>();
        set<Id> perSeatProducts = new set<Id>();
        populateProductSet(prods,bandedProducts,perSeatProducts);

        // Max_Quantity_PM_Recom_PerSeat__c, Max_Quantity_PM_Recom_Banded__c    
        String seg = store.APTSECOM_Customer_Pricing_Segment__c;
        // DLT-12344
        rec.getPricematricesV2(perSeatProducts, Integer.valueOf(store.Max_Quantity_PM_Recom_PerSeat__c), seg);
        rec.getPricematricesV2(bandedProducts, Integer.valueOf(store.Max_Quantity_PM_Recom_Banded__c), seg);
        
        rec.prodset = prodset;
        rec.getDigitalProductsByOpportunityId();
        
        Map<String,Ecom_Recommendation.Product> allProducts = new Map<String,Ecom_Recommendation.Product>(); 
        
        for(Product2 prod : prods ){
            
            Ecom_Recommendation.Product recomP = new Ecom_Recommendation.Product();
            recomP.productId = prod.Id;
            recomP.productName = prod.Name; 
            recomP.productTitle = prod.DC_Product_Title__c;        
            List<String> finalArray = formatShortDescription(prod);
            recomP.shortDescription = finalArray; 
            recomP.longDescription = prod.DC_Long_Description__c;
            recomP.jurisdiction = prod.DC_Jurisdiction__c;
            recomP.pricingModel = prod.APTS_Product_Pricing_Model__c;
            recomP.priceMatrix = rec.productIdToPriceMatrices.get(prod.Id);
            recomP.material = new List<Ecom_Recommendation.Material>();
            
            if(rec.productIdToMaterial.get(prod.Id) != null && rec.productIdToMaterial.get(prod.Id).get(prod.Subscription_Number__c) != null )
            {
                recomP.material = rec.productIdToMaterial.get(prod.Id).get(prod.Subscription_Number__c);           
            }
            allProducts.put(prod.Id,recomP);
            //rec.recomProducts.add(recomP);
            
            System.debug(LoggingLevel.DEBUG,'allProductsdetails-->'+rec.allProducts);
            prodset.add(Prod.Id);
            System.debug(LoggingLevel.DEBUG,'Prodsetdetails-->'+prodset);
            
        }
        return allProducts.values();    
    }
    private List<String> formatShortDescription(Product2 prod){

        String shortDescription = prod.DC_Short_Description__c;
        String[] discriptionArray = String.isBlank(shortDescription) ? new String[]{} : shortDescription.split('\\{\\{bullet}}');
        List<String> finalArray = new List<String>();
        if(discriptionArray != null){
            for(String discription : discriptionArray){
                if(String.isNotBlank(discription)){
                    discription = discription.trim();
                    finalArray.add(discription);
                }
            }
        }
        return finalArray;
    }

    private void populateProductSet(List<Product2> prods,set<Id> bandedProducts,set<Id> perSeatProducts){
        for(Product2 prod : prods ){
            
            if(prod.APTS_Product_Pricing_Model__c == 'Banded'){
                bandedProducts.add(prod.Id);
            }
            if(prod.APTS_Product_Pricing_Model__c == 'Per Seat'){
                perSeatProducts.add(prod.Id);
            }
        }
    }
    private void setContractTermAdjustments(Ecom_Recommendation rec){
        list<New_Sales_Contract_Term_Setting__c> contractTermSetting = 
            [SELECT Contract_Term__c, Adjustment_Amount__c, Adjustment_Type__c,  Related_Category_Hierarchy__c, Related_Category_Hierarchy__r.Name
            FROM New_Sales_Contract_Term_Setting__c 
            WHERE Related_Category_Hierarchy__c =: selectedPlanId 
            AND Contract_Term__c =: selectedContractTerm
            WITH SECURITY_ENFORCED];

        if (contractTermSetting.size() > 0) {
            if (String.isNotBlank(contractTermSetting[0].Adjustment_Type__c)) {
                rec.ctAdjustmentType = contractTermSetting[0].Adjustment_Type__c;
            }
            if (contractTermSetting[0].Adjustment_Amount__c != null) {
                rec.ctAdjustmentAmount = contractTermSetting[0].Adjustment_Amount__c;
            }
        }
    }
    /**
        @description Global class to store response sent to outside services
     */
    global class Ecom_Response{
        public Ecom_OrderRequest orderInfo;
        public List<Ecom_StoreResponse.cls_products> planProducts;
        public List<Ecom_Recommendation.Product> recomProducts;
    }
    
}