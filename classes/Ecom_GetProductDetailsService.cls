/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                     Name                                          Description
 * 2019-02-13   Shiva Sri Arun Koralla         DLT-15150 [NSE ALL][Tech Story] Salesforce service to get pricing for Materials
 * ==================================================================================================================================   
 */
@RestResource(urlMapping='/ecom/getProductDetails/*')
Global with sharing class Ecom_GetProductDetailsService {

  @HTTPPost
    Global static Ecom_GetProductDetails_Response getProductDetails(Ecom_GetProductDetails_Request request){
        System.debug('Request >> '+Json.serialize(request));
        Ecom_GetProductDetails_Response response = new Ecom_GetProductDetails_Response();
        if(String.isBlank(request.storeName)){
            throw new DCCustomException('lead Id should not be null');
        }
        //Boolean isValid = true;
        if(request.products.isEmpty()) {
            throw new DCCustomException('products should not be null');
        }
        /*
        for(Ecom_GetProductDetails_Request.cls_products prod : request.products) {
            if(String.isBlank(prod[0].materialNumber) || String.isBlank(prod[0].subscriptionNumber)) {
                isValid=false;
            }        
            
        }
        if(!isValid) {
           throw new DCCustomException('material number and subscription number should not be null'); 
        }
        */
        try{
          Ecom_GetProductDetailsService service = new Ecom_GetProductDetailsService();
         // Ecom_GetProductDetails_Request.cls_storeDetails products = new Ecom_GetProductDetails_Request.cls_products();
       
          response = service.getProducts(request.storeName, request.products);
           // response.products = prodresp;
           
        } catch(Exception ex) {
          DCUtils.trackLog(ex, 'Ecom_GetProductDetailsService', 'getProductDetails');
          throw new DCCustomException(ex);
        }
        return response;
    }
    
    public String storeId;
    public String leastPriceJson;
    public Set<Id> selectionProductIdSet;
    public Integer maxNoOfAttorneys = 0;
    public String customerPricingSegment ;
    public String adjustmentType = Label.DC_PERCENT_DISCOUNT;
    public Decimal adjustmentAmount = 0;
    public String mainCategory = '';
    public String newCategory = '';
    
    public List<String> jurisdictions = new List<String>();
   
    public Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>> categoryToMatrix = new Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>>();
    public Map<Id,List<Apttus_Config2__ProductClassification__c>> categoryProdClassificationMap;
    public Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>> productToPriceMatricesMap = new Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>>();
    public Map<String,Map<String,List<Ecom_GetProductDetails_Response.Material>>> productIdToMaterial = new Map<String,Map<String,List<Ecom_GetProductDetails_Response.Material>>>();
  
    Map<String, List<Ecom_GetProductDetails_Response.PriceMatrix>> categoryToquantityToPriceMatrixMap = new Map<String, List<Ecom_GetProductDetails_Response.PriceMatrix>>();
    Map<Integer, Map<String, Ecom_GetProductDetails_Response.PriceMatrix>> productQuantityToPriceMatrixMap = new Map<Integer, Map<String, Ecom_GetProductDetails_Response.PriceMatrix>>();
    public Map<String,Map<String, Ecom_GetProductDetails_Response.Adjustments>> categoryToContractTermDiscount = new Map<String,Map<String, Ecom_GetProductDetails_Response.Adjustments>>();
    

    public Ecom_GetProductDetails_Response getProducts(String storeName, List<Ecom_GetProductDetails_Request.cls_products> products){
        
        Ecom_GetProductDetails_Response response = new Ecom_GetProductDetails_Response();
        List<APTSECOM_Store__c> stores = Ecom_StoreService.getStoreList(storeName);
        
        response.contractTermDetails = getContractTerm(storeName);
        
        Set<String> materialNumberSet = new Set<String>();
        Set<String> subscriptionNumberSet = new Set<String>();
        for(Ecom_GetProductDetails_Request.cls_products obj : products) {
            if(String.isNotBlank(obj.materialNumber))   materialNumberSet.add(obj.materialNumber);
            if(String.isNotBlank(obj.subscriptionNumber))   subscriptionNumberSet.add(obj.subscriptionNumber);
        }
        if(stores.isEmpty()){
            throw new DCCustomException('Store Name does not exist anymore');
        }
     
        //Ecom_StoreResponse.cls_storeDetails storeDetail = new Ecom_StoreResponse.cls_storeDetails();
        for(APTSECOM_Store__c store : stores){
            
            storeId = store.Id;
            //System.debug('jurisdiction > '+jurisdiction);
            
          //  jurisdictions = jurisdiction;
             maxNoOfAttorneys = Integer.valueOf(store.APTSECOM_Max_No_Of_Attorneys__c);
            if(String.isNotBlank(store.APTSECOM_Adjustment_Type__c))
            {
                adjustmentType = store.APTSECOM_Adjustment_Type__c;
            }
            if(store.APTSECOM_Adjustment_Amount__c != null)
            {
              adjustmentAmount = store.APTSECOM_Adjustment_Amount__c;
            }
            leastPriceJson = store.APTSECOM_Least_Prices__c;
            customerPricingSegment = store.APTSECOM_Customer_Pricing_Segment__c;
            //mainCategory = store.APTSECOM_Category_Hierarchy__c;
          
            
        //    System.debug('adjustmentAmount > '+adjustmentAmount);
            //storeDetail.productCatalog = customerPricingSegment;
        }
       
        if(String.isNotBlank(leastPriceJson)){
            categoryToMatrix = (Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>>)Json.deserialize(leastPriceJson, Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>>.class);
        }
        /*
        if(String.isBlank(mainCategory)){
            throw new DCCustomException('There is No Category Hierarchy associated with Store');
        }
        */
        if(maxNoOfAttorneys < 1){
            throw new DCCustomException('Max No of Attorneys should be more than 0');
        }
       
        List<Apttus_Config2__ClassificationHierarchy__c> categoryList; 
        if(Schema.sObjectType.Apttus_Config2__ClassificationHierarchy__c.isAccessible()){
            categoryList = [SELECT  Id, 
                                    Name, 
                                    DC_Is_Title_Visible__c, 
                                    Apttus_Config2__Label__c, 
                                    DC_Sequence_No__c, 
                                    Apttus_Config2__ProductCount__c, 
                                    Apttus_Config2__AncestorId__c,
                                    Apttus_Config2__PrimordialId__c,
                                    Apttus_Config2__Level__c             
                         FROM       Apttus_Config2__ClassificationHierarchy__c
                         WHERE      Name =: Label.Ecom_CustomPlanName 
                         ORDER BY   Apttus_Config2__Level__c, DC_Sequence_No__c];
                         
                         System.debug('====categoryList response======'+categoryList );

        }
        mainCategory = categoryList[0].id;
          System.debug('====mainCategory ======'+mainCategory );
        setDiscountForEveryCategory(categoryList);
        getProducts(subscriptionNumberSet,materialNumberSet);
        getDigitalProductsBySelectedProducts(selectionProductIdSet);
        productToPriceMatricesMap = getPriceMatrixV2(selectionProductIdSet, maxNoOfAttorneys, customerPricingSegment);
       // storeDetail.productCatalog.sections = new List<Ecom_GetProductDetails_Response.cls_sections>();
       // storeDetail.productCatalog.sections = getCategoryHierarchy();
       
       
        List<Ecom_GetProductDetails_Response.cls_products> returnProducts = new List<Ecom_GetProductDetails_Response.cls_products>();
        for(Apttus_Config2__ClassificationHierarchy__c category : categoryList) {
        System.debug('====categoryList Id======'+category.Id );
            List<Ecom_GetProductDetails_Response.cls_products> items = getProductsForCategory(category .Id);
            returnProducts.addAll(items);
            
            System.debug('====returnProducts response======'+returnProducts);
        }
        //Ecom_GetProductDetails_Response response = new Ecom_GetProductDetails_Response();
        //response.products = 
        response.priceMatrix = getPriceMatricesFromQuantityContractTermMap(productQuantityToPriceMatrixMap);
        response.products = returnProducts;
        return response;
    }
    private void getProducts(Set<String> subscriptionNumberSet,Set<String> materialNumberSet){
        
        List<DC_State_Circuit_Mapping__mdt> stCircuitMappingList;
        List<Apttus_Config2__ProductClassification__c> prodClassificationSelectionList;
        
        
        
        if(Schema.sObjectType.Apttus_Config2__ProductClassification__c.isAccessible()){
            prodClassificationSelectionList = [Select Id,name,Apttus_Config2__ClassificationId__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__c,Apttus_Config2__ClassificationId__r.Name,  Apttus_Config2__ProductId__c,
                                               Apttus_Config2__ProductId__r.DC_Long_Description__c,Apttus_Config2__ProductId__r.DC_Short_Description__c,Apttus_Config2__ProductId__r.DC_Product_Title__c,Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,  
                                               Apttus_Config2__ProductId__r.DC_Jurisdiction__c,Apttus_Config2__ProductId__r.Subscription_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__ProductId__r.Name,
                                               Apttus_Config2__ProductId__r.Description,Apttus_Config2__Sequence__c, Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c                         
                                               from Apttus_Config2__ProductClassification__c
                                               where Apttus_Config2__ClassificationId__r.Name =: Label.Ecom_CustomPlanName
                                               AND Apttus_Config2__ProductId__r.Subscription_Number__c IN :subscriptionNumberSet
                                               AND Apttus_Config2__ProductId__r.ProductCode IN :materialNumberSet];
          System.debug('====prodClassificationSelectionList response======'+prodClassificationSelectionList);
        
        }
        
        Map<String,String> productToCategory = new Map<String,String>();
        categoryProdClassificationMap = new Map<Id,List<Apttus_Config2__ProductClassification__c>>(); 
        selectionProductIdSet = new Set<Id>();
        for (Apttus_Config2__ProductClassification__c prodClassification : prodClassificationSelectionList) {
            if (categoryProdClassificationMap.containsKey(prodClassification.Apttus_Config2__ClassificationId__c)) {
                List<Apttus_Config2__ProductClassification__c> prodClassificationList = categoryProdClassificationMap.get(prodClassification.Apttus_Config2__ClassificationId__c);
                prodClassificationList.add(prodClassification);
                categoryProdClassificationMap.put(prodClassification.Apttus_Config2__ClassificationId__c, prodClassificationList);
            }
            else {
                List<Apttus_Config2__ProductClassification__c> prodClassificationList = new List<Apttus_Config2__ProductClassification__c>();
                prodClassificationList.add(prodClassification);
                categoryProdClassificationMap.put(prodClassification.Apttus_Config2__ClassificationId__c, prodClassificationList);
            }
            productToCategory.put(prodClassification.Apttus_Config2__ProductId__c, prodClassification.Apttus_Config2__ClassificationId__c);
            selectionProductIdSet.add(prodClassification.Apttus_Config2__ProductId__c);
        }
        System.debug('====selectionProductIdSet response======'+selectionProductIdSet);
    }
    
    /**
     * will get the Materials by Opporunity 
     */
    public Map<String,Map<String,List<Ecom_GetProductDetails_Response.Material>>> getDigitalProductsBySelectedProducts(Set<Id> productIdSet){
        List<Digital_Product_Plans__c> plans;
        if(Schema.sObjectType.Digital_Product_Plans__c.isAccessible()){
          System.debug('====productIdSet response======'+productIdSet);
            plans = [Select id, name, Material_Number__c,Material_Description__c, Product__c, Subscription_Number__c,SLF_Jurisdiction__c, DB_Group__c, DB_Group_Sort_Order__c,DB_Category__c,DB_Category_Sort_Order__c,SLF_Help_Text__c
                                                from Digital_Product_Plans__c 
                                                where Product__c in : productIdSet ];
                                                
            System.debug('====plans ======'+plans);
    
        }

        for(Digital_Product_Plans__c plan : plans){
            //if(String.isNotBlank(plan.Material_Number__c) && materialNumberSet.contains(plan.Material_Number__c)) {
                Ecom_GetProductDetails_Response.Material material = new Ecom_GetProductDetails_Response.Material();
                material.materialId = plan.Id;
                material.materialNumber = plan.Material_Number__c;
                material.materialDescription = plan.Material_Description__c;
                material.internalDescription = plan.SLF_Help_Text__c;
                material.classificationValue = plan.DB_Category__c;
                material.classificationValueSortOrder = Integer.valueOf(plan.DB_Category_Sort_Order__c);
                material.subscriptionNumber = plan.Subscription_Number__c;
                material.jurisdiction = plan.SLF_Jurisdiction__c;
                material.productPlanId = plan.Product__c;
                material.productGroup = plan.DB_Group__c;
                material.productGroupSortOrder = Integer.valueOf(plan.DB_Group_Sort_Order__c);
                if(productIdToMaterial.get(plan.Product__c) == null){
                    productIdToMaterial.put(plan.Product__c,new Map<String,List<Ecom_GetProductDetails_Response.Material>>()); 
                }
                if(productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c) == null){
                    productIdToMaterial.get(plan.Product__c).put(plan.Subscription_Number__c,New List<Ecom_GetProductDetails_Response.Material>());
                }
                productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c).add(material);


              System.debug('====material response======'+material);
            //}
        }     
        System.debug('====productIdToMaterial response======'+productIdToMaterial);
        return productIdToMaterial;
    }
    
    /*
    Prepares Pricing map for Products using the Product Matrix based on the Products, Quantity and Customer Pricing Segment
    passed as parameter.
    */    
    public Map<String,List<Ecom_GetProductDetails_Response.PriceMatrix>> getPriceMatrixV2(Set<Id> productIdSet, Integer maxNoOfAttorneys, String customerPricingSegment) {
        
        Set<String> attorneys = new Set<String>();
        
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }
        
        set<Id> clonedProductset = productIdSet.clone();
        
        Map<String, Ecom_GetProductDetails_Response.PriceMatrix> defaultProductToPriceMatrix = new Map<String, Ecom_GetProductDetails_Response.PriceMatrix>();
        
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, Apttus_Config2__Dimension1Value__c,Ecom_Dimension1Value__c,
                                                               Apttus_Config2__AdjustmentAmount__c, 
                                                               Apttus_Config2__AdjustmentType__c 
                                                               FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                               WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :productIdSet
                                                               AND Apttus_Config2__Dimension1Value__c not in :attorneys
                                                               AND Ecom_Dimension1Value__c != 0
                                                               AND Apttus_Config2__Dimension2Value__c = : customerPricingSegment Order by Ecom_Dimension1Value__c ASC ]){
            
            String productId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;      
            if(!clonedProductset.contains(productId) )
            {
                 continue; 
            }
            Ecom_GetProductDetails_Response.PriceMatrix matrix = new Ecom_GetProductDetails_Response.PriceMatrix();
            //matrix.ProductId = productId;
            if(matrixEntry.Apttus_Config2__AdjustmentAmount__c != null)
            {
                matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
            }
            matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);        
            defaultProductToPriceMatrix.put(productId , matrix);
            
            clonedProductset.remove(productId);
            if(clonedProductset.isEmpty()) 
            { 
                break;
            }                                                       
        }
        
        Map<String, List<Ecom_GetProductDetails_Response.PriceMatrix>> productToPriceMatrices = new Map<String, List<Ecom_GetProductDetails_Response.PriceMatrix>>();
        Map<String, Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix>> quantityPriceMatrixMap = new Map<String, Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix>>();
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                                                               Apttus_Config2__Dimension1Value__c,
                                                               Apttus_Config2__AdjustmentAmount__c, 
                                                               Apttus_Config2__AdjustmentType__c 
                                                               FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                               WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :productIdSet 
                                                               AND Apttus_Config2__Dimension1Value__c in :attorneys  
                                                               AND Apttus_Config2__Dimension2Value__c =: customerPricingSegment]) {
            Ecom_GetProductDetails_Response.PriceMatrix matrix = new Ecom_GetProductDetails_Response.PriceMatrix();
            String productId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;                                                       
            //matrix.ProductId = productId;
            if(matrixEntry.Apttus_Config2__AdjustmentAmount__c != null)
            {
                matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
            }
            matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);
            if(quantityPriceMatrixMap.get(productId) == null)   
            {
                quantityPriceMatrixMap.put(productId, new Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix>());
            }
            quantityPriceMatrixMap.get(productId).put(matrix.quantity, matrix); 
    }
        
        for(String prodId : quantityPriceMatrixMap.keySet()) {
            Ecom_GetProductDetails_Response.PriceMatrix prevMatrix = null;
            
            for(Integer i=maxNoOfAttorneys; i >= 1; i--) {
                
                if(!quantityPriceMatrixMap.get(prodId).keySet().contains(i)) {
                    if(prevMatrix == null) {
                        prevMatrix = new Ecom_GetProductDetails_Response.PriceMatrix();
                        prevMatrix.amount = defaultProductToPriceMatrix.get(prodId).amount;
                        //prevMatrix.ProductId = prodId;
                    }
                    prevMatrix.quantity = i;
                    quantityPriceMatrixMap.get(prodId).put(i, prevMatrix.clone());            
                }
                prevMatrix = quantityPriceMatrixMap.get(prodId).get(i).clone();
            }
        }
        
        for(String prodId : quantityPriceMatrixMap.keySet()) {
            productToPriceMatrices.put(prodId,  sortMap(quantityPriceMatrixMap.get(prodId), 'ASC').values());
        }
         
        System.debug(JSON.serialize(productToPriceMatrices));
        System.debug('====productToPriceMatrices response======'+productToPriceMatrices);
        return productToPriceMatrices;     
    } 
    /*
        Prepares Sort priceMap based on priceMap, Order passed as parameters.
    */
    private Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix> sortMap (Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix> theMap, String theOrder) {
        //create the return map
        Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix> returnMap = new Map<Integer, Ecom_GetProductDetails_Response.PriceMatrix>();
        //get the set of the keys of the map we want to sort
        Set<Integer> keySet = theMap.keySet();
        //create a list and add all the keys from the set to sort
        List<Integer> keyList = new List<Integer>();
        keyList.addAll(keySet);
        //sort the list ascending (predefined behaviour)
        keyList.sort();
        if (theOrder == 'DESC')
        {
            //iterate from the last to the first key over the ascending ordered key list
            for (Integer i = (keyList.size() - 1); i >= 0; i--)
            {
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        }
        else
        {
            //iterate from the first to the last key over the ascending ordered key list
            for (Integer i = 0; i < keyList.size(); i++)
            {
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        }
        //return the sorted map
        return returnMap;
    }
    /*
    Creates List of Cart Items for the category passed as parameter.
    The Category passed to this method should have underlying Products.
    */
    private List<Ecom_GetProductDetails_Response.cls_products> getProductsForCategory(Id categoryId) {
        
        List<Ecom_GetProductDetails_Response.cls_products> itemsList = new List<Ecom_GetProductDetails_Response.cls_products>();
        Map<String,Ecom_GetProductDetails_Response.Adjustments> contractTermAdjustments = categoryToContractTermDiscount.get(newCategory);
        
        System.debug('==============categoryProdClassificationMap : '+categoryProdClassificationMap);
        System.debug('==============categoryId : '+categoryId);
        List<Apttus_Config2__ProductClassification__c> prodDetailsList;
        if (categoryProdClassificationMap.containsKey(categoryId)) {
            prodDetailsList = categoryProdClassificationMap.get(categoryId);
        }
        else {
            prodDetailsList = new List<Apttus_Config2__ProductClassification__c>();
        }
        System.debug('==============prodDetailsList : '+prodDetailsList );
        Decimal selectedSeqNumber = 0;     
        for (Apttus_Config2__ProductClassification__c prodDetail : prodDetailsList) {
            
            Ecom_GetProductDetails_Response.cls_products item = new Ecom_GetProductDetails_Response.cls_products();
            item.productId = prodDetail.Apttus_Config2__ProductId__c;
            item.productName = prodDetail.Apttus_Config2__ProductId__r.Name;
            item.productTitle =  prodDetail.Apttus_Config2__ProductId__r.DC_Product_Title__c;
            //item.jurisdiction = prodDetail.Apttus_Config2__ProductId__r.DC_Jurisdiction__c; 
            //item.longDescription = prodDetail.Apttus_Config2__ProductId__r.DC_Long_Description__c; 
            item.shortDescription = prodDetail.Apttus_Config2__ProductId__r.DC_Short_Description__c; 
            item.pricingModel = prodDetail.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c; 
            //item.cType = prodDetail.Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c;  
            
            List<Ecom_GetProductDetails_Response.PriceMatrix> matrices = productToPriceMatricesMap.get(prodDetail.Apttus_Config2__ProductId__c);
            
            
            List<Ecom_GetProductDetails_Response.PriceMatrix> matrices1 = new List<Ecom_GetProductDetails_Response.PriceMatrix>();
            if(matrices != null)
            {
                matrices1 = getDiscountedPriceByPriceMatrix(matrices, contractTermAdjustments );
                //matrices1 = matrices;
            }
            item.priceMatrix = matrices1;  // check
            sumUpPriceMatrixByCategory(matrices1);
            
            item.material = new List<Ecom_GetProductDetails_Response.Material>();
            if(productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c) != null && productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c).get(prodDetail.Apttus_Config2__ProductId__r.Subscription_Number__c) != null )
               {
                 item.material = productIdToMaterial.get(prodDetail.Apttus_Config2__ProductId__c).get(prodDetail.Apttus_Config2__ProductId__r.Subscription_Number__c);                    
               }
            itemsList.add(item);
            System.debug('=====itemlist===='+item);
        } 
        
        return itemsList;
    }

    private void sumUpPriceMatrixByCategory(List<Ecom_GetProductDetails_Response.PriceMatrix> matrices){
        // , Map<String, Map<Integer, Ecom_StoreResponse.PriceMatrix>> idToquantityToPriceMatrixMap
        for( Ecom_GetProductDetails_Response.PriceMatrix matrix : matrices ){
            if(productQuantityToPriceMatrixMap.get(matrix.quantity) != null && productQuantityToPriceMatrixMap.get(matrix.quantity).get(matrix.contractTerm) != null ){
                if( matrix.amount != NULL ){ 
                    Ecom_GetProductDetails_Response.PriceMatrix value = productQuantityToPriceMatrixMap.get(matrix.quantity).get(matrix.contractTerm);
                    if(value.amount == null)
                    { 
                        value.amount = 0;
                    }
                    {
                    value.amount += matrix.amount;
                    }
                }
            } else{                
                if(productQuantityToPriceMatrixMap.get(matrix.quantity) == null ){
                    productQuantityToPriceMatrixMap.put(matrix.quantity,new Map<String, Ecom_GetProductDetails_Response.PriceMatrix>());
                    productQuantityToPriceMatrixMap.get(matrix.quantity).put(matrix.contractTerm, matrix.clone());
                }else if(productQuantityToPriceMatrixMap.get(matrix.quantity) != null && productQuantityToPriceMatrixMap.get(matrix.quantity).get(matrix.contractTerm) == null ){
                    productQuantityToPriceMatrixMap.get(matrix.quantity).put(matrix.contractTerm, matrix.clone());
                }
            }
            
        }
        
    }
    
    // calculate the amount based contractTerm and category adjustments and return list of priceMatrix wrapper
    public List<Ecom_GetProductDetails_Response.PriceMatrix> getDiscountedPriceByPriceMatrix(List<Ecom_GetProductDetails_Response.PriceMatrix> matrices, Map<String,Ecom_GetProductDetails_Response.Adjustments> contractTermAdjustments ){
        
        if(contractTermAdjustments == null || contractTermAdjustments.isEmpty()){
            return matrices;
        }
        
        // create the return List
        List<Ecom_GetProductDetails_Response.PriceMatrix> cloneMatrices = new List<Ecom_GetProductDetails_Response.PriceMatrix>();
        // iterate price matix to update the discount prices
        for(Ecom_GetProductDetails_Response.PriceMatrix matrix : matrices){

            if(contractTermAdjustments == null ){
                continue;
            }
            // iterate contractTermAdjustments to add prices for contactTerm level
            for(String contractTerm : contractTermAdjustments.keySet()){
                Ecom_GetProductDetails_Response.PriceMatrix clone = matrix.clone();
                Ecom_GetProductDetails_Response.Adjustments adjustment = contractTermAdjustments.get(contractTerm);
                clone.amount = getDiscountedPrice(clone.amount, adjustment.adjustmentAmount, adjustment.adjustmentType);
                clone.contractTerm = contractTerm;
                cloneMatrices.add(clone);
            }
            
        }
        return cloneMatrices;
    }
    
    private List<Ecom_GetProductDetails_Response.PriceMatrix> getPriceMatricesFromQuantityContractTermMap(Map<Integer,Map<String,Ecom_GetProductDetails_Response.PriceMatrix>> quantityToContractTermPrice ){
        List<Ecom_GetProductDetails_Response.PriceMatrix> priceMatrices = new List<Ecom_GetProductDetails_Response.PriceMatrix>();
        if(quantityToContractTermPrice == null)
        {
             return priceMatrices;
        }
        for(Integer quantity : quantityToContractTermPrice.keySet()) {
            
            priceMatrices.addAll( quantityToContractTermPrice.get(quantity).values());
        }
        
        return priceMatrices;
    }
    
    // calculate the price and return
    private Decimal getDiscountedPrice( Decimal adjustedPrice, Decimal adjustmentAmount, String adjustmentType) {
        
        //Check whether % discount is required or % markup
        if(adjustmentType == Label.DC_PERCENT_DISCOUNT) {
            adjustedPrice = adjustedPrice * ((100 - adjustmentAmount)/100);
        } else {            
            if(adjustmentType == Label.DC_PERCENT_MARKUP) {
                adjustedPrice = adjustedPrice * ((100 + adjustmentAmount)/100);
            }
        }
        return adjustedPrice;    
    }
    
    private void setDiscountForEveryCategory(List<Apttus_Config2__ClassificationHierarchy__c> categoryList){
        // create a map to hold the plan level discount
        Map<String, Ecom_GetProductDetails_Response.Adjustments> categoryToDiscount = new Map<String, Ecom_GetProductDetails_Response.Adjustments>();
        List<APTSECOM_Store__c> adjustments;
        
        if(Schema.sObjectType.APTSECOM_Store__c.isQueryable()){
         adjustments = [select id,name, 
                       (Select id,name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,Contract_Term__c 
                        From New_Sales_Contract_Term_Settings__r 
                        where Related_Category_Hierarchy__r.name = :Label.Ecom_CustomPlanName ),
                       (Select id,APTSECOM_Category_Hierarchy__c,APTSECOM_Adjustment_Type__c,APTSECOM_Adjustment_Amount__c 
                        From Store_Price_Adjustments__r 
                        Where APTSECOM_Category_Hierarchy__r.Name = :Label.Ecom_CustomPlanName) 
                       From APTSECOM_Store__c 
                       Where Id =: storeId ];
        
        }
        // Itarate plan level adjustments and add to map
        for(APTSECOM_Store_Price_Adjustment__c adjustment : adjustments[0].Store_Price_Adjustments__r){
            Ecom_GetProductDetails_Response.Adjustments ads = new Ecom_GetProductDetails_Response.Adjustments();
            ads.adjustmentType = adjustment.APTSECOM_Adjustment_Type__c;
            ads.adjustmentAmount = adjustment.APTSECOM_Adjustment_Amount__c;
            // Update to default values if values are empty
            if(String.isBlank(adjustment.APTSECOM_Adjustment_Type__c) || adjustment.APTSECOM_Adjustment_Amount__c == null ){
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            categoryToDiscount.put(adjustment.APTSECOM_Category_Hierarchy__c, ads);
        }
        // top level category is used for iterate the categories from high to low level
        Integer topLevel = 0;
        Map<String,String> childToParent = new Map<String,String>();
        Map<String,List<String>> parentToChilds = new Map<String, List<String>>();
        Map<Integer,List<String>> levelToHierarchy = new Map<Integer, List<String>>();
        // iterate category list, add child category as a key and parent category as a value and vice-versa
        for(Apttus_Config2__ClassificationHierarchy__c hierarchy : categoryList){
            childToParent.put(hierarchy.Id, hierarchy.Apttus_Config2__AncestorId__c);
            if(parentToChilds.get(hierarchy.Apttus_Config2__AncestorId__c) == null)
            {
                parentToChilds.put(hierarchy.Apttus_Config2__AncestorId__c,new List<String>());
            }
            parentToChilds.get(hierarchy.Apttus_Config2__AncestorId__c).add(hierarchy.Id);
            // to know category level
            Integer level = Integer.valueOf(hierarchy.Apttus_Config2__Level__c);
            if(topLevel < level ) 
            {
                topLevel = level;
            }
            if(levelToHierarchy.get(level) == null)
            {
                levelToHierarchy.put(level, new List<String>());
            }
            levelToHierarchy.get(level).add(hierarchy.Id);
        }
        // add adjustments to low level categories
        
        // iterate contract term adjustments
        for(New_Sales_Contract_Term_Setting__c contractTerm : adjustments[0].New_Sales_Contract_Term_Settings__r){
            // id,name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,Contract_Term__c
            
            if(categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c) == null)
            {
              categoryToContractTermDiscount.put(contractTerm.Related_Category_Hierarchy__c, New Map<String, Ecom_GetProductDetails_Response.Adjustments>());
            }
             if(String.isBlank(contractTerm.Contract_Term__c))
             {
                continue;
             }
            Ecom_GetProductDetails_Response.Adjustments ads = categoryToDiscount.get(contractTerm.Related_Category_Hierarchy__c);
            if( ads == null || String.isBlank(ads.adjustmentType) || ads.adjustmentAmount == null ){
                ads = new Ecom_GetProductDetails_Response.Adjustments();
                ads.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                ads.adjustmentAmount = 0;
            }
            Ecom_GetProductDetails_Response.Adjustments newAdjustment = calculateAdjustment(contractTerm.Adjustment_Amount__c, contractTerm.Adjustment_Type__c, ads.adjustmentAmount, ads.adjustmentType);
            
            if(categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).get(contractTerm.Contract_Term__c) == null)
               {
                 categoryToContractTermDiscount.get(contractTerm.Related_Category_Hierarchy__c).put(contractTerm.Contract_Term__c, newAdjustment);
               }
            }   
        // add adjustments to low level categories
        for(Integer level = 1; topLevel >= level; level++){
            for(String category : levelToHierarchy.get(level)){
                if(level > 1){
                    categoryToContractTermDiscount.put(category, categoryToContractTermDiscount.get(childToParent.get(category)));
                }else{
                    Map<String,Ecom_GetProductDetails_Response.Adjustments> adjMap = categoryToContractTermDiscount.get(category);
                    Ecom_GetProductDetails_Response.Adjustments defaultPlanlevel = categoryToDiscount.get(category);
                    // if plan does not have any adjustments then set default values which should not impact the price
                    if( defaultPlanlevel == null || String.isBlank(defaultPlanlevel.adjustmentType) || defaultPlanlevel.adjustmentAmount == null ){
                        defaultPlanlevel = new Ecom_GetProductDetails_Response.Adjustments();
                        defaultPlanlevel.adjustmentType = Label.DC_PERCENT_DISCOUNT;
                        defaultPlanlevel.adjustmentAmount = 0;
                    }
                    // if we donot have contract term discount then default will have a plan level discount.
                    if( adjMap == null )
                    {
                        adjMap = new Map<String,Ecom_GetProductDetails_Response.Adjustments>{'default'=> defaultPlanlevel};
                    }
                    else
                    {
                        adjMap.put('default', defaultPlanlevel);
                    }
                    categoryToContractTermDiscount.put(category, adjMap); 
                }
            }    
        }

        System.debug('categoryToContractTermDiscount 2 > '+ Json.serialize(categoryToContractTermDiscount));
    }
    
    // calculate the plan level adjustments and contractterm level adjustments
    public static Ecom_GetProductDetails_Response.Adjustments calculateAdjustment(Decimal newAdjustmentAmount, String newAdjustmentType, Decimal defaultAdjustmentAmount, String defaultAdjustmentType ){
      // check if new adjustments are empty then set to defaults
        if(newAdjustmentAmount == null)
        {
             newAdjustmentAmount = 0;
        }
        {
        if(String.isBlank(newAdjustmentType)) 
        {
            newAdjustmentType = Label.DC_PERCENT_DISCOUNT;
        }
        }
        // discount - markup calculation
        if(defaultAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
      if(newAdjustmentType == Label.DC_PERCENT_DISCOUNT){
        newAdjustmentAmount = defaultAdjustmentAmount + newAdjustmentAmount;
      }else if(newAdjustmentType == Label.DC_PERCENT_MARKUP) {
        newAdjustmentAmount = defaultAdjustmentAmount - newAdjustmentAmount;
      }
    }else if(defaultAdjustmentType == Label.DC_PERCENT_MARKUP) {
      if(newAdjustmentType == Label.DC_PERCENT_DISCOUNT){
        newAdjustmentAmount = newAdjustmentAmount - defaultAdjustmentAmount;
                // newAdjustmentAmount is greater then zero then set defaultAdjustmentType to same as newAdjustmentType     
                // since we are returning defaultAdjustmentType
        if(newAdjustmentAmount > 0) {
          defaultAdjustmentType = Label.DC_PERCENT_DISCOUNT;
        }
      }else if(newAdjustmentType == Label.DC_PERCENT_MARKUP) {
        newAdjustmentAmount = defaultAdjustmentAmount + newAdjustmentAmount;
      }
    }
        
        if(newAdjustmentAmount < 0) {
            newAdjustmentAmount = newAdjustmentAmount * (-1);
            newAdjustmentType = Label.DC_PERCENT_MARKUP;
        } else {        
            if(newAdjustmentAmount > 100) 
            {
                newAdjustmentAmount = 100;
            }
            {
            newAdjustmentType = defaultAdjustmentType;
            }
        }
        // create a wrapper to return calculated adjustments
        Ecom_GetProductDetails_Response.Adjustments newAdjustment = new Ecom_GetProductDetails_Response.Adjustments();
        newAdjustment.adjustmentAmount = newAdjustmentAmount;
        newAdjustment.adjustmentType = newAdjustmentType;
        return newAdjustment;
    }
    
 //Get details of New Sales contract terms
    private List<Ecom_StoreResponse.cls_ContractTermDetails> getContractTerm(String storeName){     
        
        List<New_Sales_Contract_Term_Setting__c> nsContractTerms= null;
        Map<String, List<Ecom_StoreResponse.ContractTermDetail>> planToContractterms = new Map<String, List<Ecom_StoreResponse.ContractTermDetail>>();
        if(Schema.sObjectType.New_Sales_Contract_Term_Setting__c.isQueryable()){
            nsContractTerms=[Select Markup_Percentage__c, Contract_Term__c, YoY_1__c, YoY_2__c, Related_Category_Hierarchy__c, Related_Category_Hierarchy__r.name 
                             from New_Sales_Contract_Term_Setting__c 
                             where Related_Store__r.name=:storeName
                             And Related_Category_Hierarchy__r.name =: Label.Ecom_CustomPlanName ];
        }
        for(New_Sales_Contract_Term_Setting__c term : nsContractTerms){
            Ecom_StoreResponse.ContractTermDetail termDetail = new Ecom_StoreResponse.ContractTermDetail();
            termDetail.markupPercentage=term.Markup_Percentage__c;
            termDetail.planID = term.Related_Category_Hierarchy__c;
            termDetail.planName=term.Related_Category_Hierarchy__r.name;
            termDetail.term=term.Contract_Term__c;
            termDetail.yearOnYearRenewal=term.YoY_1__c;
            termDetail.yearOnYearTwoPlus=term.YoY_2__c;
            if(planToContractterms.get(term.Related_Category_Hierarchy__c) == null )
            {
                planToContractterms.put(term.Related_Category_Hierarchy__c, new List<Ecom_StoreResponse.ContractTermDetail>());
            }
            planToContractterms.get(term.Related_Category_Hierarchy__c).add(termDetail);
            
        }
        
        List<Ecom_StoreResponse.cls_ContractTermDetails> contractTermDetails = new List<Ecom_StoreResponse.cls_ContractTermDetails>();
        
        for( String key : planToContractterms.keyset() ){
            Ecom_StoreResponse.cls_ContractTermDetails details = new Ecom_StoreResponse.cls_ContractTermDetails();
            details.categoryId = key;
            newCategory = key;
            details.terms = planToContractterms.get(key);
            contractTermDetails.add(details);
        }
        
        return contractTermDetails;
        
    }

    }