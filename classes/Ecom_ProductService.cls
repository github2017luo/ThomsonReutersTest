/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-02-19   Ramesh Reddy          DLT-7674 - [New Customer] Initial Pricing on Landing Page load
 * 2018-08-29   Raviteja              DLT-11731  [Code Scan] Fix Ecom_ProductService
 * ==================================================================================================================================   
 */
global without sharing class Ecom_ProductService {

    public string storeId;
    public String mainCategory = '';
    public Integer maxNoOfAttorneys = 0;
    public String customerPricingSegment ;
    public String adjustmentType = '';
    public Decimal adjustmentAmount = 0;
    public Set<Id> selectionProductIdSet;
    public Map<String,String> productIdToState = new Map<String,String>();
    public Map<String, List<String>> categoryToProductIds = new Map<String, List<String>>();
    public Map<String, List<Ecom_StoreResponse.PriceMatrix>> categoryToPriceMatrices = new Map<String, List<Ecom_StoreResponse.PriceMatrix>>();
    
    
    /**
     * used to get call from SF UI Button and update the least prices for Category which is on Store
     */     
    WebService Static String updatePricesOnStore(String storeId) {
        APTSECOM_Store__c store = new APTSECOM_Store__c(Id = storeId );  
        try {
            Ecom_ProductService ecom = new Ecom_ProductService();
            ecom.getStoreDetails(storeId);
            ecom.getProducts();
            if(ecom.selectionProductIdSet.isEmpty()){
                return 'Nothing to update since Products are not associated with store';
            }
            String priceMatricesJson = ecom.getLeastPrices();
            store.APTSECOM_Least_Prices__c = priceMatricesJson;
            store.APTSECOM_Has_Error__c = false;
            store.APTSECOM_Error_Details__c = '';
            return 'updated successfully';
        } catch (Exception ex) {
            Digital_Exception_Log__c log = DCUtils.trackLog(ex,'Ecom_ProductService','updatePricesOnStore');
            store.APTSECOM_Least_Prices__c = '';
            store.APTSECOM_Has_Error__c = true;
            store.APTSECOM_Error_Details__c = 'Log-'+log.Id+ ' : ' +ex.getMessage();
            return 'Please check the errors or contact admin';
        }finally{
          
            update store;
            
        }
        
    }
    /**
     * used to get the details of Store
     */     
    public String getStoreDetails(String storeId){
        List<APTSECOM_Store__c> stores = [Select Id,name,APTSECOM_Adjustment_Amount__c,APTSECOM_Adjustment_Type__c,APTSECOM_Category_Hierarchy__c,APTSECOM_Max_No_Of_Attorneys__c,APTSECOM_Customer_Pricing_Segment__c
                                          From APTSECOM_Store__c 
                                          Where Id =: storeId];
        if(stores.isEmpty()){
            throw new DCCustomException('Record does not exist anymore');
        }
        maxNoOfAttorneys = Integer.valueOf(stores[0].APTSECOM_Max_No_Of_Attorneys__c);
        mainCategory = stores[0].APTSECOM_Category_Hierarchy__c;
        adjustmentType = stores[0].APTSECOM_Adjustment_Type__c;
        adjustmentAmount = stores[0].APTSECOM_Adjustment_Amount__c;
        customerPricingSegment = stores[0].APTSECOM_Customer_Pricing_Segment__c;
        return '';
    }

    /**
     * used to get All products based on categoryHierarchy
     */     
    public void getProducts(){
        if(String.isBlank(mainCategory)){
            throw new DCCustomException('Update Category Hierarchy for Store');
        }
        if(maxNoOfAttorneys < 1){
            throw new DCCustomException('Max No of Attorneys should be more than 0');
        }
        List<Apttus_Config2__ProductClassification__c> prodClassificationSelectionList = 
                [Select Apttus_Config2__ClassificationId__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__c, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.DC_Jurisdiction__c              
                 from Apttus_Config2__ProductClassification__c
                 where Apttus_Config2__ClassificationId__r.Apttus_Config2__PrimordialId__c =: mainCategory 
                // and ((DC_Product_Jurisdiction__c = :referenceState ) OR  (DC_Product_Jurisdiction__c = :referenceCircuit ) OR 
                //        DC_Product_Jurisdiction__c = :national )
                ];

        selectionProductIdSet = new Set<Id>();
        for (Apttus_Config2__ProductClassification__c prodClassification : prodClassificationSelectionList) {
            
            if(categoryToProductIds.get(prodClassification.Apttus_Config2__ClassificationId__c) == null ){
                categoryToProductIds.put(prodClassification.Apttus_Config2__ClassificationId__c, new List<String>());
            }
            categoryToProductIds.get(prodClassification.Apttus_Config2__ClassificationId__c).add(prodClassification.Apttus_Config2__ProductId__c);
            if(String.isNotBlank(prodClassification.Apttus_Config2__ProductId__r.DC_Jurisdiction__c))
            {
                productIdToState.put(prodClassification.Apttus_Config2__ProductId__c,prodClassification.Apttus_Config2__ProductId__r.DC_Jurisdiction__c );
            }
            selectionProductIdSet.add(prodClassification.Apttus_Config2__ProductId__c);
        }
    }
    
    /**
     * used to get Discounted amount based on AdjustmentAmount and Type.
    */     
    public Decimal getDiscountedPrice( Decimal adjustedPrice) {
        adjustmentAmount = adjustmentAmount != null ? adjustmentAmount : 0.0;
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

    /**
     * used to get least prices from Price matrix based on category
     */     
    public String getLeastPrices() {
        Set<String> attorneys = new Set<String>();
        
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }
        Map<String,Set<String>> circuitToStates = getStatesByCircuit();
        Map<String, List<Ecom_StoreResponse.PriceMatrix>> productToPriceMatrices = new Map<String, List<Ecom_StoreResponse.PriceMatrix>>();
        Map<String, Map<Integer, Ecom_StoreResponse.PriceMatrix>> quantityPriceMatrixMap = new Map<String, Map<Integer, Ecom_StoreResponse.PriceMatrix>>();
        Map<String, Map<Integer, Map<String, Decimal>>> leastPriceByCatState = new Map<String, Map<Integer, Map<String, Decimal>>>();
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, Apttus_Config2__Dimension1Value__c,
                                                               Apttus_Config2__AdjustmentAmount__c, 
                                                               Apttus_Config2__AdjustmentType__c                                                               
                                                               FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                               WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :selectionProductIdSet 
                                                               AND Apttus_Config2__Dimension1Value__c in :attorneys  
                                                               AND Apttus_Config2__Dimension2Value__c =: customerPricingSegment]) {
            Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
            matrix.ProductId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
            matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
            matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);
            if(!quantityPriceMatrixMap.keySet().contains(matrix.ProductId))
            {
                quantityPriceMatrixMap.put(matrix.ProductId, new Map<Integer, Ecom_StoreResponse.PriceMatrix>());
            }
            quantityPriceMatrixMap.get(matrix.ProductId).put(matrix.quantity, matrix);                                                                                                             
        }

        for(String prodId : quantityPriceMatrixMap.keySet()) {
            Ecom_StoreResponse.PriceMatrix prevMatrix = null;
            for(Integer i=maxNoOfAttorneys; i >= 1; i--) {
                if(!quantityPriceMatrixMap.get(prodId).keySet().contains(i)) {
                    if(prevMatrix == null) {
                        prevMatrix = new Ecom_StoreResponse.PriceMatrix();
                        prevMatrix.amount = 0;
                        prevMatrix.ProductId = prodId;
                    }
                    prevMatrix.quantity = i;
                    quantityPriceMatrixMap.get(prodId).put(i, prevMatrix.clone());            
                }
                prevMatrix = quantityPriceMatrixMap.get(prodId).get(i).clone();
            }
        }
        
        for(String prodId : quantityPriceMatrixMap.keySet()) {
            productToPriceMatrices.put(prodId, sortMap(quantityPriceMatrixMap.get(prodId), 'ASC').values());
        }
        
        for(String cat : categoryToProductIds.keySet()){
            for(String prodId : categoryToProductIds.get(cat)) {
                String state = productIdToState.get(prodId);
                for( Ecom_StoreResponse.PriceMatrix matrix : productToPriceMatrices.get(prodId)){
                    //circuitToStates
                    if(String.isNotBlank(state) && state.containsIgnoreCase('circuit') && circuitToStates.get(state) != null){
                        for(String stateCircuit : circuitToStates.get(state)){
                            updateLeastPriceByCatState(stateCircuit, cat, leastPriceByCatState, matrix);
                        }                                                           
                    } else{
                        if(String.isNotBlank(state))
                        {
                            updateLeastPriceByCatState(state, cat, leastPriceByCatState, matrix);
                        }
                    }   
                }
            }
        }  
        Map<String,Map<Integer,Decimal>> catToAmount = new Map<String,Map<Integer,Decimal>>();
        Map<String,List<Ecom_StoreResponse.PriceMatrix>> categoryToMatrix = new Map<String,List<Ecom_StoreResponse.PriceMatrix>>();
        Map<String,Map<Integer,Ecom_StoreResponse.PriceMatrix>> categoryToQuantityMatrix = new Map<String,Map<Integer,Ecom_StoreResponse.PriceMatrix>>();
        Map<String,Map<Integer,String>> catToState = new Map<String,Map<Integer,String>>();
        for(String cat : leastPriceByCatState.keySet()){
            Map<Integer,Decimal> finalPrice = new Map<Integer,Decimal>();
            Map<Integer,Ecom_StoreResponse.PriceMatrix> quantityToPriceMatrix = new Map<Integer,Ecom_StoreResponse.PriceMatrix>();
            Map<Integer,String> quantityToState = new Map<Integer,String>();
            for(Integer quantity : leastPriceByCatState.get(cat).keySet()){
                Decimal stand = 0;
                Integer count = 0; String lState = '';
                Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
                for(String state : leastPriceByCatState.get(cat).get(quantity).keySet()){
                    Decimal temp = leastPriceByCatState.get(cat).get(quantity).get(state);
                    if(count++ == 0 || stand > temp){
                        stand = temp;
                        lState = state;
                        matrix.amount = stand; // getDiscountedPrice(stand);
                        matrix.quantity = quantity;
                    }
                }
                quantityToPriceMatrix.put(quantity, matrix);
                finalPrice.put(quantity, stand);
                quantityToState.put(quantity, lState);
            }
            catToAmount.put(cat, finalPrice);
            catToState.put(cat, quantityToState);
            categoryToMatrix.put(cat, quantityToPriceMatrix.values());
            categoryToQuantityMatrix.put(cat, quantityToPriceMatrix);
        }
        sumUpToParentCategory(categoryToMatrix, categoryToQuantityMatrix);
        String leastPrices = JSON.serialize(categoryToMatrix);
        return leastPrices;     
    }  
    /**
     * add values to least price map based on State and category
     */     
    public static void updateLeastPriceByCatState(String state, String cat, Map<String, Map<Integer, Map<String, Decimal>>> leastPriceByCatState, Ecom_StoreResponse.PriceMatrix matrix){
        
        if(leastPriceByCatState.get(cat) != null && leastPriceByCatState.get(cat).get(matrix.quantity) != null && leastPriceByCatState.get(cat).get(matrix.quantity).get(state) != null ){
            if( matrix.amount != NULL ){ 
                Decimal value = leastPriceByCatState.get(cat).get(matrix.quantity).get(state);
                value += matrix.amount;
                leastPriceByCatState.get(cat).get(matrix.quantity).put(state,value);
            }
        } else{                
            if(leastPriceByCatState.get(cat) == null){
                leastPriceByCatState.put(cat, new Map<Integer, Map<String, Decimal>>());
                leastPriceByCatState.get(cat).put(matrix.quantity,new Map<String, Decimal>());
                leastPriceByCatState.get(cat).get(matrix.quantity).put(state, matrix.amount);
            }else if(leastPriceByCatState.get(cat) != null && leastPriceByCatState.get(cat).get(matrix.quantity) == null ){
                leastPriceByCatState.get(cat).put(matrix.quantity,new Map<String, Decimal>());
                leastPriceByCatState.get(cat).get(matrix.quantity).put(state, matrix.amount);
            }else if(leastPriceByCatState.get(cat) != null && leastPriceByCatState.get(cat).get(matrix.quantity) != null && leastPriceByCatState.get(cat).get(matrix.quantity).get(state) == null ){
                leastPriceByCatState.get(cat).get(matrix.quantity).put(state, matrix.amount);
            }
        }            
    }

    /**
    * sum up least price value to Parent category from child 
    */  
    public void sumUpToParentCategory(Map<String,List<Ecom_StoreResponse.PriceMatrix>> categoryToMatrix, Map<String,Map<Integer,Ecom_StoreResponse.PriceMatrix>> categoryToQuantityMatrix){
        
        List<Apttus_Config2__ClassificationHierarchy__c> hierarchs = [Select Id,name,Apttus_Config2__Level__c,Apttus_Config2__AncestorId__c,Apttus_Config2__AncestorId__r.name, Apttus_Config2__HierarchyId__c,Apttus_Config2__PrimordialId__c             
                                                                      From Apttus_Config2__ClassificationHierarchy__c
                                                                      Where  Apttus_Config2__PrimordialId__c  =: mainCategory ];
        
        Integer topLevel = 0;
        Map<String,String> childToParent = new Map<String,String>();
        Map<String,List<String>> parentToChilds = new Map<String, List<String>>();
        Map<Integer,List<String>> levelToHierarchy = new Map<Integer, List<String>>();
        
        for(Apttus_Config2__ClassificationHierarchy__c hierarchy : hierarchs){
            childToParent.put(hierarchy.Id, hierarchy.Apttus_Config2__AncestorId__c);
            if(parentToChilds.get(hierarchy.Apttus_Config2__AncestorId__c) == null)
            {
                parentToChilds.put(hierarchy.Apttus_Config2__AncestorId__c,new List<String>());
            }
            parentToChilds.get(hierarchy.Apttus_Config2__AncestorId__c).add(hierarchy.Id);
            
            Integer level = Integer.valueOf(hierarchy.Apttus_Config2__Level__c);
            if(topLevel < level ) topLevel = level;
            if(levelToHierarchy.get(level) == null)
            {
                levelToHierarchy.put(level, new List<String>());
            }
            levelToHierarchy.get(level).add(hierarchy.Id);
        }
        
        do{            
            Set<String> parentIds = new Set<String>();
            for(String category : levelToHierarchy.get(topLevel)){
                if(childToParent.get(category) != null){
                    String parent = childToParent.get(category);
                    parentIds.add(parent);
                    childToParent.remove(category);
                }
            }
            for(String parent : parentIds){
                Map<Integer,Ecom_StoreResponse.PriceMatrix> parentToQuantityMatrix = new Map<Integer,Ecom_StoreResponse.PriceMatrix>();
                for(String child : parentToChilds.get(parent)){
                    Map<Integer,Ecom_StoreResponse.PriceMatrix> quantiyToMatrix = categoryToQuantityMatrix.get(child);
                    if(quantiyToMatrix == null){break;}
                    for(Integer quantity : quantiyToMatrix.keyset() ){
                        if( parentToQuantityMatrix.get(quantity) == null ){
                            parentToQuantityMatrix.put(quantity, quantiyToMatrix.get(quantity).clone()); 
                        }else {
                            parentToQuantityMatrix.get(quantity).amount += quantiyToMatrix.get(quantity).amount;
                        }
                    }
                }
                categoryToMatrix.put(parent, parentToQuantityMatrix.values());
                categoryToQuantityMatrix.put(parent, parentToQuantityMatrix);
            }
        }while(childToParent != null && !childToParent.isEmpty() && --topLevel < -1);
    }
    /**
    * sort the map based on key which is Integer 
    */  
    public Map<Integer, Ecom_StoreResponse.PriceMatrix> sortMap (Map<Integer, Ecom_StoreResponse.PriceMatrix> theMap, String theOrder) {
        //create the return map
        Map<Integer, Ecom_StoreResponse.PriceMatrix> returnMap = new Map<Integer, Ecom_StoreResponse.PriceMatrix>();
        //get the set of the keys of the map we want to sort
        Set<Integer> keySet = theMap.keySet();
        //create a list and add all the keys from the set to sort
        List<Integer> keyList = new List<Integer>();
        keyList.addAll(keySet);
        //sort the list ascending (predefined behaviour)
        keyList.sort();
        if (theOrder == 'DESC')
            //iterate from the last to the first key over the ascending ordered key list
            for (Integer i = (keyList.size() - 1); i >= 0; i--)
            {
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        else
            //iterate from the first to the last key over the ascending ordered key list
            for (Integer i = 0; i < keyList.size(); i++)
            {
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        //return the sorted map
        return returnMap;
    }
    /**
    * Get all circuits and states. assign all states as value to Map based on Circuit as a Key.
    */  
    public static Map<String,Set<String>> getStatesByCircuit(){
        Map<String,Set<String>> circuitToStates = new Map<String,Set<String>>();
        List<DC_State_Circuit_Mapping__mdt> stCircuitMappingList = [SELECT Circuit__c,State__c FROM  DC_State_Circuit_Mapping__mdt ];
        
        for(DC_State_Circuit_Mapping__mdt state_Circuit : stCircuitMappingList){
            if(circuitToStates.get(state_Circuit.Circuit__c) == null){
                circuitToStates.put(state_Circuit.Circuit__c, new Set<String>());
            }
            circuitToStates.get(state_Circuit.Circuit__c).add(state_Circuit.State__c);
        }
        return circuitToStates;
    }

}