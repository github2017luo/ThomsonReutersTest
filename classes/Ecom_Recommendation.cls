/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-05-15   Ramesh Reddy          DLT-7685 - Text on top half of add-on 'tile' to be presented in bullet format
 * 2018-07-17   Prashob Anto          DLT-1063 [Code Scan] Fix Ecom_Recommendation
 * 2018-08-27   Raviteja              DLT-11731 [Code Scan] Fix Ecom_Recommendation
 * 2018-09-20   Ramesh Reddy          DLT-12344 - [NSE SL/CP][Tech Story] Ability to add product having 3-5 attorney pricing
 * 2018-10-23   Samreen Ali           DLT-11477 [NSE GOV] Offer Dynamic Set of Add Ons for Government store
 * 2018-10-26   Ramesh Reddy          DLT-13185 - update PriceMatrix logic
 * 2021-02-04   Brenda Shields        DLT-21293 - [SFDC]NSE-GOVT-Incorrect price is displaying in the OrderForm when Add-On is added in QA
 * ==================================================================================================================================   
 */
  /** 
 * @description : Utility function for Ecom Recommendations
 */ 
@RestResource(urlMapping='/digitalconfigurator/getrecommendations/*')
global with sharing class Ecom_Recommendation{
    private static Final String STR_DIMENSION1_NAME = 'Quantity';
    private static Final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static Final String CART_STATUS_FINALIZED = 'Finalized';    
    
    public map<String,map<String,list<Material>>> productIdToMaterial = new map<String,map<String,list<Material>>>();
    public map<String,list<Pricematrix>> productIdToPriceMatrices = new map<String,list<Pricematrix>>();
    private map<String,map<Integer,Pricematrix>> productIdToQuantityPriceMatrices = new map<String,map<Integer,Pricematrix>>();
    public map<String,Product> allProducts = new map<String,Product>(); 
    public Set<id> prodset = new Set<id>();
    public Set<String> selectedProducts = new Set<String>();
    public list<APTSECOM_Store__c> storee;
    public String seg;
    public Set<id> bandedProducts = new Set<id>();
    public Set<id> perSeatProducts = new Set<id>();
    private static Integer maxNoOfAttorneys = 0;
    public String adjustmentType;
    public Decimal adjustmentAmount;
    // Contract Terms Settings
    public String ctAdjustmentType;
    public Decimal ctAdjustmentAmount;
    
    
    /** 
     * @description : api method
     * @param storeName : Store Name 
     * @param sourceprod : Source Product 
     * @param planId : Plan Id
     * @param contractTerm : Contract Term value
     * @return : Recommresponse
	 */     
    @HttpPost  
    global static Recomresponse api(String storeName, list<String> sourceprod, String planId, string contractTerm){
        Recomresponse response = new Recomresponse();  
        if (String.isBlank(storeName)) {
            response.responseCode = 400;
            response.responseMessage = 'Store Name should not be blank';
            return response; 
        }
		try {
            Ecom_Recommendation data = new Ecom_Recommendation();
            response.Recommendations = data.relatedrecomm(storeName, sourceprod, planId, contractTerm);
            response.responseCode = 200;
            response.responseMessage = '';
        } Catch(Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception '+ex);
            DCUtils.trackLog(ex,'relatedrecomm','api');
            response.responseCode = 400;
            response.responseMessage = ex.getMessage();
        }
        //system.debug(logginglevel.INFO, 'recomresponse > '+response);
        return response;
       // system.debug(logginglevel.INFO, 'response2'+response);
    }


    /** 
     * @description : relatedrecomm method
     * @param storeName : Store Name 
     * @param sourceprod : Source Product 
     * @param planId : Plan Id
     * @param contractTerm : Contract Term value
     * @return : Recommendations
	 */ 
    public Recommendations relatedrecomm(String storeName, list<String> sourceprod, String planId, string contractTerm) {
        sourceprod = sourceprod != null ? sourceprod : (new List<String>());
        
        if (!Schema.sObjectType.APTSECOM_Store__c.isQueryable() || 
        	!Schema.sObjectType.New_Sales_Contract_Term_Setting__c.isQueryable()) {
            throw new DCCustomException('Store or Contract Terms Settings object does not have access for this User: '+UserInfo.getUserId());
        }
        // get contract term settings for the adjustment type and amount
        list<New_Sales_Contract_Term_Setting__c> contractTermSetting = [SELECT Contract_Term__c, Adjustment_Amount__c, Adjustment_Type__c,  Related_Category_Hierarchy__c, Related_Category_Hierarchy__r.Name
													FROM New_Sales_Contract_Term_Setting__c 
													where Related_Category_Hierarchy__c =: planId and Contract_Term__c =: contractTerm];
		// set default values
		ctAdjustmentType = Label.DC_PERCENT_DISCOUNT;
		ctAdjustmentAmount = 0;
		// set plan values
		if (contractTermSetting.size() > 0) {
			if (String.isNotBlank(contractTermSetting[0].Adjustment_Type__c)) {
            	ctAdjustmentType = contractTermSetting[0].Adjustment_Type__c;
	        }
    	    if (contractTermSetting[0].Adjustment_Amount__c != null) {
            	ctAdjustmentAmount = contractTermSetting[0].Adjustment_Amount__c;
    	    }
        }
        system.debug(logginglevel.INFO, 'Contract Term Settings - Adjusted Amount: ' + ctAdjustmentAmount + ' Adjusted Type: ' + ctAdjustmentType);
            
        storee = [Select id, Name, Max_Quantity_PM_Recom_PerSeat__c, Max_Quantity_PM_Recom_Banded__c, APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c, 
                            (Select id, Name, APTSECOM_Product__c, APTSECOM_Product__r.APTS_Product_Pricing_Model__c, APTSECOM_Recommendation_Type__c, APTSECOM_Source_Product__c, APTSECOM_Store__c 
                            from Product_Recommendations__r 
                            where APTSECOM_Category_ID__c =: planId OR  APTSECOM_Source_Product__c in: sourceprod
                            OR ( APTSECOM_Category_ID__c = null AND APTSECOM_Source_Product__c = null)) 
                    from APTSECOM_Store__c where Name =:storeName WITH SECURITY_ENFORCED limit 1]; 
        system.debug(logginglevel.INFO, 'Store details-->'+storee);
        if(Storee.size()== 0){
            throw new DCCustomException('criteria does not match with any record, storeName: '+storeName);
        }
        
        Recommendations rec = new Recommendations ();
        map<String,String> prodSourceid = new map<String,String>();
        //Public Map<APTSECOM_Product__c,APTSECOM_Source_Product__c> prodSourceid = new Map<APTSECOM_Product__c,APTSECOM_Source_Product__c>();
        for(APTSECOM_Store__c stor : storee){
            if(Storee.size()== 0){
                throw new DCCustomException('criteria does not match with any record, storeName: '+storeName);
            }
            system.debug(logginglevel.INFO, 'Stor recom-->'+stor.Product_Recommendations__r);
            rec.storeName = Stor.Name;
            perSeatProducts = new Set<id>();
            bandedProducts = new Set<id>();
            adjustmentType = stor.APTSECOM_Adjustment_Type__c;
            adjustmentAmount = stor.APTSECOM_Adjustment_Amount__c;     
            adjustmentAmount = adjustmentAmount != null ? adjustmentAmount : 0.0;
            
            for(APTSECOM_Product_Recommendation__c recomm: stor.Product_Recommendations__r){
                // DLT-12344
                if(recomm.APTSECOM_Product__r.APTS_Product_Pricing_Model__c == 'Banded'){
                    bandedProducts.add(recomm.APTSECOM_Product__c);
                } else if(recomm.APTSECOM_Product__r.APTS_Product_Pricing_Model__c == 'Per Seat'){
                    perSeatProducts.add(recomm.APTSECOM_Product__c);
                } else {
                    prodset.add(recomm.APTSECOM_Product__c);
                }
                
                prodSourceid.put(recomm.APTSECOM_Product__c, recomm.APTSECOM_Source_Product__c);
            }
           
            // Max_Quantity_PM_Recom_PerSeat__c, Max_Quantity_PM_Recom_Banded__c    
            seg= stor.APTSECOM_Customer_Pricing_Segment__c;
            // DLT-12344
            
            if(!prodset.isEmpty()) {
            	getPricematricesV2(prodset, Integer.valueOf(stor.Max_Quantity_PM_Recom_PerSeat__c), seg);    
            }
            getPricematricesV2(perSeatProducts, Integer.valueOf(stor.Max_Quantity_PM_Recom_PerSeat__c), seg);
            getPricematricesV2(bandedProducts, Integer.valueOf(stor.Max_Quantity_PM_Recom_Banded__c), seg);
        }
        adjustmentAmount = adjustmentAmount != null ? adjustmentAmount : 0.0;
        
        prodset.addAll(perSeatProducts);
        prodset.addAll(bandedProducts);
        
        if(!Schema.sObjectType.Product2.isQueryable()) {
            throw new DCCustomException('Product object does not have access for this User: '+UserInfo.getUserId());
        }
        
        List<Product2> prods = [Select Id,Name,Subscription_Number__c,productCode,Service_Number__c,DC_Jurisdiction__c,DC_Long_Description__c,DC_Short_Description__c,DC_Product_Title__c,Apttus_Filter_Jurisdiction__c,APTS_Product_Pricing_Model__c 
                                From Product2 Where id in :prodset];

        getDigitalProductsByOpportunityId();
        for(Product2 prod : prods ){
            
            Product recomP = new Product();
            recomP.productId = prod.Id;
            recomp.sourceProductId = prodSourceid.get(prod.Id);
            recomp.prodSourceid = prodSourceid;
            recomP.productName = prod.Name; 
            recomP.productTitle = prod.DC_Product_Title__c;
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
            recomP.shortDescription = finalArray; 
            recomP.longDescription = prod.DC_Long_Description__c;
            recomP.jurisdiction = prod.DC_Jurisdiction__c;
            recomP.pricingModel = prod.APTS_Product_Pricing_Model__c;
            recomP.priceMatrix = productIdToPriceMatrices.get(prod.Id);
            recomP.material = new List<Material>();
            
            if(productIdToMaterial.get(prod.Id) != null && productIdToMaterial.get(prod.Id).get(prod.Subscription_Number__c) != null )
            {
                recomP.material = productIdToMaterial.get(prod.Id).get(prod.Subscription_Number__c);           
            }
            allProducts.put(prod.Id,recomP);
            rec.recomProducts.add(recomP);
            
            system.debug(logginglevel.INFO, 'allProductsdetails-->'+allProducts);
            prodset.add(Prod.Id);
            system.debug(logginglevel.INFO, 'Prodsetdetails-->'+prodset);
            
        }
        return rec;
    }  
  /*  public void getMaxNoOfAttorneys(){
        List<DC_Global_Settings__mdt> globalSetting = [SELECT   Max_No_Of_Attorneys__c
                                                       FROM     DC_Global_Settings__mdt ];
        if(globalSetting != null && !globalSetting.isEmpty()){
            maxNoOfAttorneys = globalSetting[0].Max_No_Of_Attorneys__c != null ? Integer.valueOf(globalSetting[0].Max_No_Of_Attorneys__c) : 0;
        }
        
    }*/
    
    
    /** 
     * @description : Build Price Matrix
     * @param productIds : set of product Ids
     * @param maxNoOfAttorneys : number of attorneys
     * @param customerPricingSegment : pricing segment
	 */ 
    public void getPricematricesV2(Set<Id> productIds, Integer maxNoOfAttorneys, String customerPricingSegment){
        
        Set<String> attorneys = new Set<String>();
        for(Integer i=1; i<= maxNoOfAttorneys ; i++){
            attorneys.add(String.valueOf(i));
        }
        
        set<Id> clonedProductset = productIds.clone();
        
        Map<String, Ecom_StoreResponse.PriceMatrix> defaultProductToPriceMatrix = new Map<String, Ecom_StoreResponse.PriceMatrix>();
        system.debug(logginglevel.ERROR, 'PriceMatrixEntry - Attorneys: ' + attorneys + ' Cust Pricing Segment: ' + customerPricingSegment);
        
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, 
                                                               Apttus_Config2__Dimension1Value__c,        
                                                               Apttus_Config2__AdjustmentAmount__c, 
                                                               Apttus_Config2__AdjustmentType__c 
                                                               FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                               WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :productIds
                                                               AND Apttus_Config2__Dimension1Value__c not in :attorneys
                                                               AND Ecom_Dimension1Value__c != 0
                                                               AND Apttus_Config2__Dimension2Value__c = : customerPricingSegment Order by Ecom_Dimension1Value__c asc ]){
            
            String productId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;                                                       
            if(!clonedProductset.contains(productId) ) {
                 continue;
            }
                                                                   
            Ecom_StoreResponse.PriceMatrix matrix = new Ecom_StoreResponse.PriceMatrix();
            matrix.ProductId = productId;
            if(matrixEntry.Apttus_Config2__AdjustmentAmount__c != null){
                matrix.amount = getDiscountedPrice(matrixEntry.Apttus_Config2__AdjustmentAmount__c);
            }    
            matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);        
            defaultProductToPriceMatrix.put(productId , matrix); 
            clonedProductset.remove(productId);
            if(clonedProductset.isEmpty()){
                break;
            }    
                                                                  
        }
        
        if(!Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isQueryable()) {
            throw new DCCustomException('Apttus_Config2__PriceMatrixEntry__c object does not have access for this User: '+UserInfo.getUserId());
        }
        
        
        List<Apttus_Config2__PriceMatrixEntry__c> entries = [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                                                             Apttus_Config2__Dimension1Value__c,
                                                             Apttus_Config2__AdjustmentAmount__c,
                                                             Apttus_Config2__AdjustmentType__c 
                                                             FROM  Apttus_Config2__PriceMatrixEntry__c   
                                                             WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension1Id__r.name = :STR_DIMENSION1_NAME  
                                                             And Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c in :productIds 
                                                             And Apttus_Config2__Dimension1Value__c in :attorneys 
                                                             And Apttus_Config2__Dimension2Value__c =: customerPricingSegment];
        
        for(Apttus_Config2__PriceMatrixEntry__c entry : entries){
            String productId = entry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
            Pricematrix matrix = new Pricematrix();
            matrix.quantity = Integer.valueOf(entry.Apttus_Config2__Dimension1Value__c);
            if(entry.Apttus_Config2__AdjustmentAmount__c != null){
                matrix.amount = getDiscountedPrice(entry.Apttus_Config2__AdjustmentAmount__c);
            }
            if(productIdToQuantityPriceMatrices.get(productId) == null){
                productIdToQuantityPriceMatrices.put(productId, new Map<Integer,Pricematrix>());
            }    
            productIdToQuantityPriceMatrices.get(productId).put(matrix.quantity,matrix);
        }
        system.debug(logginglevel.INFO, JSON.serialize(productIdToPriceMatrices));
        
        for(String prodId : productIdToQuantityPriceMatrices.keySet()) {
            Pricematrix prevMatrix = null;
            for(Integer i = maxNoOfAttorneys; i >= 1; i--) {
                if(!productIdToQuantityPriceMatrices.get(prodId).keySet().contains(i)) {
        
                    if(prevMatrix == null) {
                        prevMatrix = new Pricematrix();
                        prevMatrix.amount = defaultProductToPriceMatrix.get(prodId) == null ? 0 : defaultProductToPriceMatrix.get(prodId).amount;
                    }
                    prevMatrix.quantity = i;
                    productIdToQuantityPriceMatrices.get(prodId).put(i, prevMatrix.clone());            
                }
                prevMatrix = productIdToQuantityPriceMatrices.get(prodId).get(i).clone();
            }
        }
        system.debug(logginglevel.INFO, JSON.serialize(productIdToQuantityPriceMatrices));
        
        for (String prodId : productIdToQuantityPriceMatrices.keySet()) {
            productIdToPriceMatrices.put(prodId, productIdToQuantityPriceMatrices.get(prodId).values());
        }
        system.debug(logginglevel.INFO, JSON.serialize(productIdToPriceMatrices));
        
    } 
      
    
  	/** 
     * @description : getDigitalProductsByOpportunityId method
	 */   
     public void getDigitalProductsByOpportunityId(){
        
        if(!Schema.sObjectType.Digital_Product_Plans__c.isQueryable()) {
            throw new DCCustomException('Digital_Product_Plans__c object does not have access for this User: '+UserInfo.getUserId());
        }
        
        List<Digital_Product_Plans__c> plans = [Select id, name, Material_Number__c,Material_Description__c, Product__c, Subscription_Number__c,SLF_Jurisdiction__c, DB_Group__c, DB_Group_Sort_Order__c,DB_Category__c,DB_Category_Sort_Order__c,SLF_Help_Text__c
                                                from Digital_Product_Plans__c 
                                                where Product__c in: prodset];
            system.debug(logginglevel.INFO, 'Plans-->'+plans);
        
        for(Digital_Product_Plans__c plan : plans){
            Material material = new Material();
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
            system.debug(logginglevel.INFO, 'material details-->'+material);
            if(productIdToMaterial.get(plan.Product__c) == null){
                productIdToMaterial.put(plan.Product__c,new Map<String,List<Material>>()); 
            }
            if(productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c) == null){
                productIdToMaterial.get(plan.Product__c).put(plan.Subscription_Number__c,New List<Material>());
            }
            productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c).add(material);
        }     
    }


	// set the adjusted amount
	// DLT-21293 - add in any discount from Contract Terms Settings
	private Decimal getDiscountedPrice(Decimal adjustedPrice) {

    	// Contract Terms adjustments are all discounts
    	adjustedPrice = adjustedPrice * ((100 - ctAdjustmentAmount)/100); 
    	  
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
     * @description : Recommendation Response Variables
	 */     
    global class Recomresponse {
        public String responseMessage;  
        public Integer responseCode;    
        public Recommendations recommendations ;     
    }
    
    
 	/** 
     * @description : Recommendation Variables
	 */ 
    public class Recommendations {
        public String storeName;
        public List<Product> recomProducts = new List<Product>();
    }
    
    
 	/** 
     * @description : Product Variables
	 */     
    public class Product {
        public String productId;  
        public String sourceProductId;    
        public String productName;    
        public String productTitle; 
        public String jurisdiction;
        public List<String> shortDescription;
        public String longDescription;
        public String pricingModel;
        public List<PriceMatrix> priceMatrix = new List<PriceMatrix>();
        public List<Material> material = new List<Material>();
        Public Map<String,String> prodSourceid = new Map<String,String>();
    }
    
    
     /** 
     * @description : Price Matrix Variables
	 */ 
    public class PriceMatrix {
        public Integer quantity;    //10
        public Decimal amount;  //1749
    }
    
    
 	/** 
     * @description : Material Variables
	 */     
    public class Material {
        public String materialId;
        public String materialNumber;
        public String materialDescription;
        public String internalDescription;
        public String classificationValue;
        public Integer classificationValueSortOrder;
        public String subscriptionNumber;
        public String jurisdiction;
        public String productPlanId;
        public String productGroup;
        public Integer productGroupSortOrder;
    }
}