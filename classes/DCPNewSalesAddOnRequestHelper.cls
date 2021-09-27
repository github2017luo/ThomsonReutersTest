/* Class: DCPNewSalesAddOnRequestHelper
* Purpose: A helper class to handle the business logic class
* Created: 9/3/2021
**/
/**
* @description A helper class for business logic
*/
public with sharing class DCPNewSalesAddOnRequestHelper {

    /********************************************************************************************************
    *  @description  getAddonProducts - Method to get the Addons for the product/plan
    *  @return Map<String,product2>  : this is a return statement and having return list of addon products 
    *  @param requestParams - expected the request parameters 
    *********************************************************************************************************/
        public static Map<String,product2> getAddonProducts (Map<String,String> requestParams){
            String prodCode = requestParams.get('productCode');
            String segment = requestParams.get('segment');
            String validSellableStatus = Static_Values__c.getValues('NewSaleSellableFlag').Value__c;
            List<String> sellableValuesList = validSellableStatus.split(',');
            system.debug(LoggingLevel.INFO,'Print:'+prodCode+segment+validSellableStatus+sellableValuesList);
            Map<string,product2> addOnList = new Map<String,product2>();
            String query = 'Select Product_To__c,Product_To__r.Name,Product_To__r.DC_Short_Description__c,Product_To__r.productcode,Product_To__r.Apttus_Filter_Jurisdiction__c,Product_To__r.CPD_Sellable_Description__c,Product_To__r.Product_Offering__c,Product_From__r.productcode,Relationship_Type__c, Relationship_Link_Type__c, Segment__c, Sub_Segment__c from Product_Relationship__c where (product_from__r.productCode =:prodCode and segment__c=:segment and Product_To__r.CPD_Sellable_Description__c IN:sellableValuesList and Relationship_Type__c = \'' + String.escapeSingleQuotes('Accessory Product') + '\')';
            for(Product_Relationship__c prodRel:Database.query(query)){
                       addOnList.put(prodRel.Product_To__r.productCode,new product2(Name=prodRel.product_To__r.Name,Id=prodRel.product_To__c,DC_Short_Description__c=prodRel.Product_To__r.DC_Short_Description__c,productCode=prodRel.Product_To__r.productcode,CPD_Sellable_Description__c=prodRel.Product_To__r.CPD_Sellable_Description__c,Product_Offering__c=prodRel.Product_To__r.Product_Offering__c,Apttus_Filter_Jurisdiction__c=prodRel.Product_To__r.Apttus_Filter_Jurisdiction__c));
            }
            return addOnList;
        }
        
          /********************************************************************************************************
    *  @description  getPrice - This is the main method to handle the pricing Array  
    *  @return Map<String,list<Apttus_Config2__PriceMatrixEntry__c>>  : this is a return statement and having the price matrix Array
    *  @param productCodes - expected the product parameters 
    *  @param segment - expected the segment parameters 
    *********************************************************************************************************/
        
        public static Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> getPrice (Map<string,product2> productCodes, String segment){
            Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> quantityPriceMatrixMap = new Map<String,List<Apttus_Config2__PriceMatrixEntry__c>>();
            Map<Decimal, Apttus_Config2__PriceMatrixEntry__c> mapPriceMatrixEntry = new Map<Decimal, Apttus_Config2__PriceMatrixEntry__c>();
            Set<String> prodCodes =  productCodes.keyset();
            system.debug(loggingLevel.INFO,'ProductCodes >>'+prodCodes);
            Set < String > attorneys = new Set < String > ();
            for (Integer i = 1; i <= 25; i++) {
                attorneys.add(String.valueOf(i));
            }
            string query = 'SELECT Id,Apttus_Config2__Sequence__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.CurrencyIsoCode,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__Frequency__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.Product_Offering__c,Apttus_Config2__Dimension1Value__c, Apttus_Config2__Dimension2Value__c, Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c FROM Apttus_Config2__PriceMatrixEntry__c WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode IN:prodCodes  AND Apttus_Config2__Dimension2Value__c =:segment AND Apttus_Config2__Dimension1Value__c IN:attorneys order by Id DESC ';
            Map<Decimal, Decimal> dim1SeqMap;
            dim1SeqMap = new Map<Decimal,Decimal>();
            
            
            for(Apttus_Config2__PriceMatrixEntry__c pme: Database.Query(query)){
            system.debug(loggingLevel.INFO,'pme>>'+pme);
            // if (pme!=null){
             system.debug(loggingLevel.INFO,'pme>>'+pme);
              String productId = pme.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode;
                if(quantityPriceMatrixMap.containsKey(productId)) {
                    List<Apttus_Config2__PriceMatrixEntry__c> pmeList = quantityPriceMatrixMap.get(productId);
                    pmelist.add(pme);
                    quantityPriceMatrixMap.put(productId,pmelist);
                } else {
                    quantityPriceMatrixMap.put(productId, new List<Apttus_Config2__PriceMatrixEntry__c> { pme });
                }
            // }
            }
            Map<String, List<Apttus_Config2__PriceMatrixEntry__c>> mapMatrixEntry = getCorrectMatrixEntries(quantityPriceMatrixMap);
            if(!mapMatrixEntry.isEmpty()){
                system.debug(loggingLevel.INFO,'mapMatrixEntry>>'+mapPriceMatrixEntry);
                return mapMatrixEntry;
            }else {
                system.debug(loggingLevel.INFO,'mapMatrixEntry>>'+mapMatrixEntry);
                return quantityPriceMatrixMap;
            }
            //return quantityPriceMatrixMap;
        }
        
      
        private static Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> getCorrectMatrixEntries(Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> quantityPriceMatrixMap){
           Map<String, List<Apttus_Config2__PriceMatrixEntry__c>> mapMatrixEntry = new Map<String, List<Apttus_Config2__PriceMatrixEntry__c>>();
            for(String prodId : quantityPriceMatrixMap.keySet()){
                List<Apttus_Config2__PriceMatrixEntry__c> pmList = quantityPriceMatrixMap.get(prodId);
                //List<Apttus_Config2__PriceMatrixEntry__c> entryList= new List<Apttus_Config2__PriceMatrixEntry__c>();
                //Map<Decimal, Decimal> dim1SeqMap = new Map<Decimal,Decimal>();
                fetchCorrectEntries(prodId,pmList,mapMatrixEntry);            
            }
            return mapMatrixEntry;
        }
        
        private static void fetchCorrectEntries(String prodCode, List<Apttus_Config2__PriceMatrixEntry__c> pmList, Map<String, List<Apttus_Config2__PriceMatrixEntry__c>> mapMatrixEntry){
            Map<Decimal, Apttus_Config2__PriceMatrixEntry__c> mapPriceMatrixEntry = new Map<Decimal, Apttus_Config2__PriceMatrixEntry__c>();
            Map<Decimal, Decimal> dim1SeqMap = new Map<Decimal,Decimal>();
            for(Apttus_Config2__PriceMatrixEntry__c entry:pmList){
                    Decimal key = Decimal.valueOf(entry.Apttus_Config2__Dimension1Value__c);
                Decimal value = entry.Apttus_Config2__Sequence__c;  
                    
                    if(dim1SeqMap.containsKey(key)){
                        if(dim1SeqMap.get(key) > value) {
                           dim1SeqMap.put(key,value);
                           mapPriceMatrixEntry.put(key, entry);
                        }
                    }else{
                        dim1SeqMap.put(key,Value); 
                        mapPriceMatrixEntry.put(key, entry);
                    }
                        
             }
    
        if(!mapPriceMatrixEntry.isEmpty()){
               mapMatrixEntry.put(prodCode,mapPriceMatrixEntry.values());
            }
        }
       /********************************************************************************************************
    *  @description  getProducts - This is the main method to handle the product mapping
    *  @return DCPNewSalesAddOnRequest.ProductArray  : this is a return statement and having product mapping detail
    *  @param prod - expected the product  parameters 
    *********************************************************************************************************/
        public static DCPNewSalesAddOnRequest.ProductArray getProducts(product2 prod){
            DCPNewSalesAddOnRequest.ProductArray prodDetail = new DCPNewSalesAddOnRequest.ProductArray();
            prodDetail.productName = prod.Name;
            prodDetail.productId = prod.Id;
            prodDetail.productCode = prod.productCode;
            prodDetail.shortDescription = DCPNewSaleUtilityCls.handleEmptyString(prod.DC_Short_Description__c, DCPNewSaleUtilityCls.notAvail);
            
            return prodDetail;
        }
    
      /********************************************************************************************************
    *  @description  getPricing - This is the main method to handle the product pricing map
    *  @return List<DCPNewSalesAddOnRequest.PriceList>  : this is a return statement and having product pricing mapping detail
    *  @param prod - expected the product  parameters 
    *  @param priceMatrixMap - priceMatrixMap contains the possible prices
    *********************************************************************************************************/
        public static List<DCPNewSalesAddOnRequest.PriceList> getPricing(product2 prod,Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap){
            List<DCPNewSalesAddOnRequest.PriceList> priceDetailList = new List<DCPNewSalesAddOnRequest.PriceList>();
            if(priceMatrixMap!=null &&priceMatrixMap.get(prod.productCode)!=null){
                for(Apttus_Config2__PriceMatrixEntry__c pme:priceMatrixMap.get(prod.productCode)){
                    DCPNewSalesAddOnRequest.PriceList priceDetail = new DCPNewSalesAddOnRequest.PriceList();
                    priceDetail.quantity = pme.Apttus_Config2__Dimension1Value__c;
                    priceDetail.Amount = String.valueOf(pme.Apttus_Config2__AdjustmentAmount__c);
                    priceDetailList.add(priceDetail);
                }
            }
                return priceDetailList;
        }
        
    /********************************************************************************************************
    *  @description  getPLIInfo - This is the main method to handle the PLI INFO
    *  @return Map<String,Apttus_Config2__PriceListItem__c>  : this is a return statement and having product pricing mapping detail
    *  @param prodMap - expected the product  parameters 
    *********************************************************************************************************/
        public static Map<String,Apttus_Config2__PriceListItem__c> getPLIInfo(Map<String,Product2> prodMap){
            set<String> prodCodes = prodMap.Keyset();
            system.debug(LoggingLevel.INFO,'Print:'+prodCodes);
            Map<String,Apttus_Config2__PriceListItem__c> pliItems = new Map<String,Apttus_Config2__PriceListItem__c>();
            string query = 'Select id,Apttus_Config2__ProductId__r.productcode,Apttus_Config2__PriceListId__c,Apttus_Config2__BillingFrequency__c, CurrencyIsoCode from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__r.productcode IN:prodCodes';
            for(Apttus_Config2__PriceListItem__c pli:Database.Query(query)){
                pliItems.put(pli.Apttus_Config2__ProductId__r.productcode,pli);
            }
            
            return pliItems;
        }
     
    }