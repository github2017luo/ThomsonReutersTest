/* Class: TRStore_GetPricingDetails
* Purpose: Service to bring the JSON formatted Pricing and other related Apttus objects for products
* Created: 07 APR 2020
* Author: Kanishk
* 
* CHANGE HISTORY
* =================================================================================
* Date         Name             JIRA        Description
* 07 APR 2020   Kanishk        DUE-2069   Created this class to fetch product details JSON 
* 20 MAY 2020   Kanishk        DUE-2707   Updated Attribute and option sections
* 08 JUN 2020   Kanishk        DUE-2707   Removing custom setting | introducing custom object for field mapping
* 29 JUL 2020   Kanishk        DLT-20303  Adding format array, Adding 0 price check
* 07 AUG 2020   Ameeta         DUE-4487   Bundle products SFDC (Transact) UI PDP Change -Array
* 08 Oct 2020   Kanishk        DUE-5445   EPM changes 
* 10 Oct 2020   Avudaiappan A  DUE-5445   Refactoring code for PMD
* 21 Oct 2020   Avudaiappan A  DUE-5665   Negative case scenario adjusted
* 28 Dec 2020   Avudaiappan A  DUE-7561   Publisher remapped to product Offering
* ==================================================================================
*/

/** 
* @description : Fetches product details
*/ 
public without sharing class TRStore_GetPricingDetails {

    private static LIST<Product2> productRecDetails{get; set;}
    
    /** 
     * @description : get field information
     */ 
    public static Map<String,Map<String,String>> productModelAPIs {
        get {
            if(productModelAPIs == null) {
                productModelAPIs = TRStore_GetPricingDetails.getFieldAPIs();
            }
            return productModelAPIs;
        }
        set;
    }

    /** 
     * @description : Wrapper Class
     */ 
    public class Describe{
        public string type;
        public List<picklistFields> picklistValues;
    }
    
    /** 
     * @description : Wrapper Class
     */ 
    public class PicklistFields{
        public string label;
        public string value;
        public boolean active;
       
        /** 
         * @description : Wrapper Constructor
         */ 
        public PicklistFields(){
            label = this.label;
            value = this.value;
            active = this.active;
        }
    }
    
    /** 
     * @description : Wrapper Class
     */ 
    public class ProductFormats{
        /** 
         * @description : Format
         */ 
        public string format{get; set;}
        /** 
         * @description : Product ID
         */ 
        public string productId{get; set;}
    }

    
    private Static Map<String,TRStore_GetPricingDetails.Describe> describeMethod(set<string> fields){
        Map<String,TRStore_GetPricingDetails.Describe> describeJson = new Map<String,TRStore_GetPricingDetails.Describe>();
        if(!fields.isEmpty()) {
                Schema.DescribeSObjectResult sobj = Apttus_Config2__ProductAttributevalue__c.getSObjectType().getDescribe();
                Map<String, Schema.SObjectField> objectFields = sobj.fields.getMap();
                for(String field : fields){
                    if (objectFields.containsKey(field) && String.ValueOf(objectFields.get(field).getDescribe().getType()) == 'PICKLIST') {
                        Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
                        system.debug(loggingLevel.INFO,'DR>>>'+dr);
                        TRStore_GetPricingDetails.Describe describe = new TRStore_GetPricingDetails.Describe();
                        describe.type =  String.valueOf(dr.getType());
                        describe.picklistValues = new List<TRStore_GetPricingDetails.PicklistFields>();
                            for(Schema.PicklistEntry p: dr.getPicklistValues()){
                                TRStore_GetPricingDetails.PicklistFields pf = new TRStore_GetPricingDetails.PicklistFields();
                                pf.label = p.getLabel();
                                pf.value = p.getValue();
                                pf.active = p.isActive();
                                describe.picklistValues.add(pf);
                            }                         
                        
                        describeJson.put(field,describe);
                    }
                }
                  
            }
            return describeJson;
    }

    private static List<Object> calculatePriceMatrices(Map<String, List<Apttus_Config2__PriceMatrix__c>> mapMatrices, string priceListId){
        List<Object> priceMatrixObjectLst = new List<Object>();
        for (Apttus_Config2__PriceMatrix__c priceMatrix : mapMatrices.get(priceListId)) {
                                
            Map<String,Object> pmxMap =   TRStore_GetPricingDetails.createSobjectMap(priceMatrix,'PriceMatrix');
            List<Object> matrixEntryLst = new List<Object>();
            for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : priceMatrix.Apttus_Config2__MatrixEntries__r){
                matrixEntryLst.add(TRStore_GetPricingDetails.createSobjectMap(matrixEntry,'PriceMatrixEntry')); 
            }
            if(priceMatrix.Apttus_Config2__Dimension1Id__r <> null){
                pmxMap.put('Dimension1',TRStore_GetPricingDetails.createSobjectMap(priceMatrix.Apttus_Config2__Dimension1Id__r,'dimension'));
            }
            if(priceMatrix.Apttus_Config2__Dimension2Id__r <> null){
                pmxMap.put('Dimension2',TRStore_GetPricingDetails.createSobjectMap(priceMatrix.Apttus_Config2__Dimension2Id__r,'dimension'));
            }
            if(priceMatrix.Apttus_Config2__Dimension3Id__r <> null){
                pmxMap.put('Dimension3',TRStore_GetPricingDetails.createSobjectMap(priceMatrix.Apttus_Config2__Dimension3Id__r,'dimension'));
            }
            if(priceMatrix.Apttus_Config2__Dimension4Id__r <> null){
                pmxMap.put('Dimension4',TRStore_GetPricingDetails.createSobjectMap(priceMatrix.Apttus_Config2__Dimension4Id__r,'dimension'));
            }
            if(priceMatrix.Apttus_Config2__Dimension5Id__r <> null){
                pmxMap.put('Dimension5',TRStore_GetPricingDetails.createSobjectMap(priceMatrix.Apttus_Config2__Dimension5Id__r,'dimension'));
            }
            if(priceMatrix.Apttus_Config2__Dimension6Id__r <> null){
                pmxMap.put('Dimension6',TRStore_GetPricingDetails.createSobjectMap(priceMatrix.Apttus_Config2__Dimension6Id__r,'dimension'));
            }
            pmxMap.put('MatrixEntries',matrixEntryLst);
            priceMatrixObjectLst.add(pmxMap);
        }
        return priceMatrixObjectLst;
    }

    private Static Map<String,Object> createSobjectMap(sObject objItem,String objectType) {
        Map<String,String> productPricing = TRStore_GetPricingDetails.productModelAPIs.get(objectType);
        Map<String,Object> mapObjects = new Map<String,Object>();
        if(!productPricing.isEmpty()) { 
            mapObjects = TRStore_GetPricingDetails.getFieldMappings(objItem,objectType,productPricing);
        }
        return mapObjects;
    }
    
    private static string getFrenchTraslatedValue(string fieldAPIName, string engVal){
        
        LIST<Apttus_Config2__ProductTranslation__c> pTrans = new LIST<Apttus_Config2__ProductTranslation__c>();
        Apttus_Config2__ProductTranslation__c frpTrans = new Apttus_Config2__ProductTranslation__c();
        
        pTrans = getTranslatedRec();
        
        for( Apttus_Config2__ProductTranslation__c ptl : pTrans ){
            
            if(ptl.Apttus_Config2__Language__c == 'French')  {
                frpTrans = ptl;
                break;
            }      
        } 
 
        if(frpTrans != null){    
            return returnFieldValueBasedOnField(frpTrans, fieldAPIName ,  engVal);
        }
        return engVal;
    }
    
    private static LIST<Apttus_Config2__ProductTranslation__c> getTranslatedRec(){
        return (!productRecDetails.isEmpty())? productRecDetails[0].Apttus_Config2__Translation__r : new LIST<Apttus_Config2__ProductTranslation__c>() ;
    }
    
    
    private static string returnFieldValueBasedOnField( Apttus_Config2__ProductTranslation__c frpTrans , string fieldAPIName, string engVal ){
        
            if(fieldAPIName == 'Apttus_Filter_Jurisdiction__c'){
                return (frpTrans.Jurisdiction__c != null)? frpTrans.Jurisdiction__c : engVal;
            }else if(fieldAPIName == 'Practice_Area__c'){
                return (frpTrans.Practice_Area__c != null) ? frpTrans.Practice_Area__c : engVal;
            }else if(fieldAPIName == 'Stock__c'){
                 return (frpTrans.Stock__c != null) ? frpTrans.Stock__c : engVal;
            }
        
        return engVal ;
    }
    
    private static string getValueFromEngFr(sObject objItem, string fieldAPI ){
        return (TRStoreProductPricingService.language == 'FR') ? getFrenchTraslatedValue(fieldAPI, (String)objItem.get(fieldAPI)) : (String)objItem.get(fieldAPI);  
    }
    
    private static Map<String,Object> processjsonForProductObj(sObject objItem,string fieldAPI, Map<String,String> productPricing){
         Map<String,Object> mapObjects = new Map<String,Object>();
          if(fieldAPI  == 'Apttus_Filter_Jurisdiction__c'){
                       
              string juris = getValueFromEngFr(objItem, fieldAPI); 
               juris =  TRStore_GetPricingDetails.stringReplace(juris); 
               juris = (juris=='')?null:juris;
               mapObjects.put(productPricing.get(fieldAPI),juris);
           } 
           else if(fieldAPI  == 'Practice_Area__c') {
            
              String practiceArea = getValueFromEngFr(objItem, fieldAPI); 
               practiceArea =  TRStore_GetPricingDetails.stringReplace(practiceArea); 
               practiceArea = (practiceArea =='')?null:practiceArea;
               mapObjects.put(productPricing.get(fieldAPI),practiceArea);
           }else if(fieldAPI  == 'Stock__c'){

               String stock =  getValueFromEngFr(objItem, fieldAPI); 
               mapObjects.put(productPricing.get(fieldAPI), stock);
           }
           else{
              mapObjects.put(productPricing.get(fieldAPI),objItem.get(fieldAPI));          
           }
           
           return mapObjects ;
    }
    
    
    private Static Map<String,Object> getFieldMappings(sObject objItem,String objectType, Map<String,String> productPricing){
        Map<String,Object> mapObjects = new Map<String,Object>();
           for(String fieldAPI : productPricing.keySet()) {
               if('Product2'.equalsIgnoreCase(objectType)) {
                   if(fieldAPI  == 'Apttus_Config2__HasAttributes__c' || fieldAPI =='Apttus_Config2__HasOptions__c'){
                       mapObjects.put(productPricing.get(fieldAPI),false);
                   } else{
                       mapObjects.put(productPricing.get(fieldAPI),objItem.get(fieldAPI)); 
                   } 
                   
                 mapObjects.putAll( processjsonForProductObj(objItem, fieldAPI , productPricing));
               } else {
                   mapObjects.put(productPricing.get(fieldAPI),objItem.get(fieldAPI));
               } 
           }
        return mapObjects;           
   }

   private Static String stringReplace(String originalString) {
    String targetString = '';
    System.debug(loggingLevel.INFO,'originalString'+originalString);
    if(String.isNotBlank(originalString)){
        List<String> valueList=originalString.split(';|,');
        System.debug(loggingLevel.INFO,'valueList'+valueList);
        for(String s : valueList){
            String trimmedString = s.trim();
            targetString+= trimmedString+', ';
        }
        System.debug(loggingLevel.INFO,'targetString'+targetString);
        targetString = targetString.subString(0, targetString.length() - 2);
         System.debug(loggingLevel.INFO,'targetString'+targetString);
    }
    return targetString;
   }
   
   private Static List<Product2> getProductSnapShot(String productId, String priceListId) {
           
        String collateral = Static_Values__c.getAll().containsKey('TRStoreCollateral')?Static_Values__c.getValues('TRStoreCollateral').Value__c:'';
        List<String> collateralList=collateral.split(',');   
        System.debug(loggingLevel.INFO, 'collateralList'+collateralList);   
        String featureExclude = Static_Values__c.getValues('TRStoreFeaturesToExclude').Value__c;
        List<String> featureExcludeList=featureExclude.split(',');  
        System.debug(loggingLevel.INFO, 'featureExcludeList'+featureExcludeList);   
        String featureSetInclude = Static_Values__c.getValues('TRStoreFeatureSetToInclude').Value__c;
        List<String> featureSetIncludeList=featureSetInclude.split(',');
        System.debug(loggingLevel.INFO, 'featureSetIncludeList'+featureSetIncludeList); 
       
        String query = 'SELECT Id,Name,Apttus_Config2__ConfigurationType__c,Stock__c,LCRM_Publication_Date__c,Subscription_Number__c,LCRM_Product_type__c,cpd_sellable_description__c,ISBN__c,Apttus_Config2__Uom__c,DC_Long_Description__c,Description,Family,ProductCode,IsActive,Apttus_Config2__HasAttributes__c,Apttus_Config2__HasDefaults__c,Apttus_Config2__HasOptions__c,Apttus_Config2__ExpirationDate__c,Apttus_Config2__EffectiveStartDate__c,Apttus_Config2__EffectiveDate__c,(SELECT id, name, Product_AuthorId__c, Product_AuthorId__r.Author_ID__c, Product_AuthorId__r.Name,Display_Order__c  FROM Product_Author_Values__r ORDER BY Display_Order__c ASC NULLS LAST),(SELECT Id,Apttus_Config2__ExpirationDate__c,Apttus_Config2__EffectiveDate__c,Apttus_Config2__ContractPrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__Active__c,Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c,Apttus_Config2__PriceUom__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceType__c,Apttus_Config2__NumberOfMatrices__c,Apttus_Config2__DefaultSellingTerm__c,Apttus_Config2__Sequence__c,Apttus_Config2__Criteria__c FROM Apttus_Config2__PriceLists__r WHERE (Apttus_Config2__PriceListId__c = :pricelistId AND Apttus_Config2__Active__c = true AND Apttus_Config2__ListPrice__c <> NULL AND Apttus_Config2__ListPrice__c <> 0) AND ((Apttus_Config2__EffectiveDate__c = NULL OR Apttus_Config2__EffectiveDate__c <= Today) AND (Apttus_Config2__ExpirationDate__c = NULL OR Apttus_Config2__ExpirationDate__c > Today))),(SELECT Id,Name,Apttus_Config2__ContentType__c,Apttus_Config2__Sequence__c,Apttus_Config2__OptionGroupId__c,Apttus_Config2__DetailPage__c,Apttus_Config2__IsHidden__c,Apttus_Config2__IsLeaf__c,Apttus_Config2__IsPicklist__c,Apttus_Config2__Left__c,Apttus_Config2__Level__c,Apttus_Config2__MaxOptions__c,Apttus_Config2__MaxTotalQuantity__c,Apttus_Config2__MaxTotalQuantityExpressionId__c,Apttus_Config2__MinOptions__c,Apttus_Config2__MinTotalQuantity__c,Apttus_Config2__MinTotalQuantityExpressionId__c,Apttus_Config2__ModifiableType__c,Apttus_Config2__ParentOptionGroupId__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductAttributeGroupMemberId__c,Apttus_Config2__Right__c,Apttus_Config2__RootOptionGroupId__c,Apttus_Config2__RootSequence__c FROM Apttus_Config2__OptionGroups__r),(SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Apttus_Config2__AllowCloning__c, Apttus_Config2__AutoUpdateQuantity__c, Apttus_Config2__ComponentProductId__c,Apttus_Config2__ConfigType__c, Apttus_Config2__DefaultQuantityExpressionId__c, Apttus_Config2__DefaultQuantity__c, Apttus_Config2__Default__c, Apttus_Config2__InclusionCriteria__c, Apttus_Config2__MaxQuantityExpressionId__c, Apttus_Config2__MaxQuantity__c, Apttus_Config2__MinQuantityExpressionId__c, Apttus_Config2__MinQuantity__c, Apttus_Config2__Modifiable__c, Apttus_Config2__ParentProductId__c, Apttus_Config2__ProductOptionGroupId__c, Apttus_Config2__RelationshipType__c, Apttus_Config2__Required__c, Apttus_Config2__Sequence__c FROM Apttus_Config2__Options__r WHERE Apttus_Config2__ParentProductId__r.ProductCode =:productId),(SELECT Id,Apttus_Config2__Description__c,Apttus_Config2__Family__c,Apttus_Config2__Language__c,Apttus_Config2__Name__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductCode__c,Format__c,Jurisdiction__c,Practice_Area__c,Stock__c FROM Apttus_Config2__Translation__r),(SELECT Id,Apttus_Config2__AttributeGroupId__c,CreatedDate,LastModifiedDate,LastModifiedById,CreatedById,Apttus_Config2__AttributeGroupId__r.Id,Apttus_Config2__AttributeGroupId__r.CreatedDate,Apttus_Config2__AttributeGroupId__r.LastModifiedDate,Apttus_Config2__AttributeGroupId__r.LastModifiedById,Apttus_Config2__AttributeGroupId__r.CreatedById,Apttus_Config2__AttributeGroupId__r.Name,Apttus_Config2__AttributeGroupId__r.Apttus_Config2__AttributeValueMatrixId__c,Apttus_Config2__AttributeGroupId__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__AttributeGroupId__r.Apttus_Config2__Description__c,Apttus_Config2__AttributeGroupId__r.Apttus_Config2__TwoColumnAttributeDisplay__c,Apttus_Config2__AttributeGroupId__r.Apttus_Config2__ThreeColumnAttributeDisplay__c,Apttus_Config2__FieldUpdateCriteriaIds__c,Apttus_Config2__ProductId__c,Apttus_Config2__Sequence__c FROM Apttus_Config2__AttributeGroups__r),(SELECT Id,Apttus_Config2__Value__c,Apttus_Config2__ProductId__c,Apttus_Config2__IsIncluded__c,Apttus_Config2__FeatureId__r.Id,Apttus_Config2__FeatureId__r.Name,Apttus_Config2__FeatureId__r.Apttus_Config2__Description__c,Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name,Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Apttus_Config2__Description__c,Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Apttus_Config2__Sequence__c,Apttus_Config2__FeatureId__r.Apttus_Config2__Sequence__c FROM Apttus_Config2__ProductFeatureValues__r WHERE Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name IN: featureSetIncludeList AND Apttus_Config2__FeatureId__r.Name NOT IN: featureExcludeList),(Select id, name, Product_Collateral__c, Product__r.Name,Product_Collateral__r.Name,Product_Collateral__r.Collateral_Path__c, Product_Collateral__r.Collateral_Title__c, Product_Collateral__r.Collateral_Type__c from Product_Collateral_Values__r where Product_Collateral__r.Collateral_Type__c IN: collateralList),(SELECT Id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductGroupId__c,Apttus_Config2__ProductGroupId__r.Id,Apttus_Config2__ProductGroupId__r.Name,Apttus_Config2__ProductGroupId__r.Apttus_Config2__Description__c,Apttus_Config2__ProductGroupId__r.Apttus_Config2__GroupType__c,Apttus_Config2__ProductGroupId__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Ratio__c,Apttus_Config2__Sequence__c FROM Apttus_Config2__ProductGroups__r),Service_Number__c,Format__c,Apttus_Filter_Brand__c,product_offering__c,LCRM_Author__c,Practice_Area__c,Apttus_Filter_Jurisdiction__c,DC_Short_Description__c,LCRM_Sub_Bu__c,APTS_Media_High_Level_Code__c,APTS_Media_Lower_Level_Code__c,APTS_Item_Category_Group__c,APTS_Product_Pricing_Model__c FROM Product2 WHERE (ProductCode = :productId) AND (IsActive = true) LIMIT 1';  
        return Database.query(query);
 
    }

 private static Map<String, List<Apttus_Config2__PriceMatrix__c>> getMatixData(String prodCode, String priceListId) {
    Map<String, List<Apttus_Config2__PriceMatrix__c>> mapMatrices = new Map<String, List<Apttus_Config2__PriceMatrix__c>>();
    String query = 'SELECT Id,Apttus_Config2__Description__c,Apttus_Config2__Dimension1Id__r.Id,Apttus_Config2__Dimension1Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__childFilterName__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__contextType__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension1ValueType__c,Apttus_Config2__Dimension2Id__r.Id,Apttus_Config2__Dimension2Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__childFilterName__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__contextType__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension2ValueType__c,Apttus_Config2__Dimension3Id__r.Id,Apttus_Config2__Dimension3Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__childFilterName__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__contextType__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension3ValueType__c,Apttus_Config2__Dimension4Id__r.Id,Apttus_Config2__Dimension4Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__childFilterName__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__contextType__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension4ValueType__c,Apttus_Config2__Dimension5Id__r.Id,Apttus_Config2__Dimension5Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__childFilterName__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__contextType__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension5ValueType__c,Apttus_Config2__Dimension6Id__r.Id,Apttus_Config2__Dimension6Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__childFilterName__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__contextType__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension6ValueType__c,Apttus_Config2__EnableDateRange__c,Apttus_Config2__InitialRows__c,Apttus_Config2__IsCumulativeRange__c,Apttus_Config2__MatrixType__c,Apttus_Config2__NumberOfEntries__c,Apttus_Config2__PriceListItemId__c,Apttus_Config2__Sequence__c,Apttus_Config2__StopProcessingMoreMatrices__c,(SELECT Id,Apttus_Config2__PriceMatrixId__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__BandSize__c,Apttus_Config2__condition__c,Apttus_Config2__Dimension1Value__c,Apttus_Config2__Dimension2Value__c,Apttus_Config2__Dimension3Value__c,Apttus_Config2__Dimension4Value__c,Apttus_Config2__Dimension5Value__c,Apttus_Config2__Dimension6Value__c,Apttus_Config2__PeriodEndDate__c,Apttus_Config2__EndFactor__c,Apttus_Config2__EntryKey__c,Apttus_Config2__FlatPrice__c,Apttus_Config2__TierStartValue__c,Apttus_Config2__IsIncluded__c,Apttus_Config2__PriceOverride__c,Apttus_Config2__Sequence__c,Apttus_Config2__PeriodStartDate__c,Apttus_Config2__StartFactor__c,Apttus_Config2__TierEndValue__c,Apttus_Config2__UsageRate__c FROM Apttus_Config2__MatrixEntries__r) FROM Apttus_Config2__PriceMatrix__c WHERE (Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.ProductCode = :prodCode and Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c = :priceListId)';
    for(Apttus_Config2__PriceMatrix__c matrix: Database.query(query)){
        if(mapMatrices.containsKey(matrix.Apttus_Config2__PriceListItemId__c)) {
            List<Apttus_Config2__PriceMatrix__c> matrixList = mapMatrices.get(matrix.Apttus_Config2__PriceListItemId__c);
            matrixList.add(matrix);
            mapMatrices.put(matrix.Apttus_Config2__PriceListItemId__c,matrixList);
        } else {
            List<Apttus_Config2__PriceMatrix__c> matrixList = new List<Apttus_Config2__PriceMatrix__c>();
            matrixList.add(matrix);
            mapMatrices.put(matrix.Apttus_Config2__PriceListItemId__c,matrixList);
        }
    }
    
    return mapMatrices;
}

private Static List<Object> getAuthorData(String prodCode) {
    List<Object> authOb = new List<Object>();
    Map<String,Object> authorBioMap = new Map<String,Object>();
    LIST<String> authorListWithoutDisplayOrder = new LIST<String>();
    
    Map<String,Product_Author__c> authorMapForSorting = new Map<String,Product_Author__c>();
    Map<String,Product_Author__c> authorMapSorted = new Map<String,Product_Author__c>();
    List<String> orderingList = new List<String>();
    List<Product_Author__c> sortedAuthorList = new List<Product_Author__c>();
    List<Product_Author__c> authors = new List<Product_Author__c>();
    if(Schema.sObjectType.Product_Author_Value__c.isAccessible()) {
        List<Product_Author_Value__c> authorList = [select Id, ProductId__r.name, ProductId__r.ProductCode, Display_Order__c,
                                                 Product_AuthorId__r.Author_Biography__c,Product_AuthorId__r.Name, 
                                                 Product_AuthorId__r.Author_ID__c 
                                                 from Product_Author_Value__c 
                                                 where ProductId__r.ProductCode =:prodCode
                                                 ORDER BY Display_Order__c ASC NULLS LAST];
        for(Product_Author_Value__c  authValue : authorList) {
           if(authValue.Display_Order__c!=null){
              Product_Author__c author = authValue.Product_AuthorId__r;
              authorBioMap = TRStore_GetPricingDetails.createSobjectMap(author,'ProductAuthor');
              authOb.add(authorBioMap);
           }    
           else {
              authorListWithoutDisplayOrder.add(authValue.Product_AuthorId__r.Name);
           }
         }
         for (Product_Author_Value__c pav: authorList){
             if (pav.Display_Order__c==null){
                Product_Author__c pa = pav.Product_AuthorId__r;
                authors.add(pa);
             }
         }
         for (Product_Author__c prodAuthor : authors) {
             authorMapForSorting.put(prodAuthor.Name,prodAuthor);
         }
         //Add all elements of Set into a list
         orderingList.addAll(authorMapForSorting.keyset());
         //Sort the List
         orderingList.sort();
             
         for ( Integer i= 0;i < orderingList.size(); i++){
             authorMapSorted.put(orderingList[i],authorMapForSorting.get(orderingList[i]));
         }
         //Get the sorted list
         sortedAuthorList = authorMapSorted.values();
         for(sObject ob : sortedAuthorList){
            authorBioMap = TRStore_GetPricingDetails.createSobjectMap(ob,'ProductAuthor');
            authOb.add(authorBioMap);
         }
     }
        return authOb;
    
}
/** 
* @description : Feetch field API names
* @return : Field API Names
*/ 
public Static Map<String,Map<String,String>> getFieldAPIs(){
    
    Map<String,Map<String,String>> mapFields = new Map<String,Map<String,String>>();
    for(Product_Pricing_Field__c model : [Select Field_API_Name__c, Service_Field_Name__c, Object_Name__c 
                                          from Product_Pricing_Field__c
                                          order by Object_Name__c]) {
        if(mapFields.containsKey(model.Object_Name__c)) {
            Map<String,String> mapAPIs = mapFields.get(model.Object_Name__c);
            mapAPIs.put(model.Field_API_Name__c,model.Service_Field_Name__c);
        }else {
            Map<String,String> mapAPIs = new Map<String,String>();
            mapAPIs.put(model.Field_API_Name__c,model.Service_Field_Name__c);
            mapFields.put(model.Object_Name__c,mapAPIs);
        }
    }
    return mapFields;
}

    /** 
    * @description : Product details Class
    */ 
    public class ProductDetails {
        /** 
        * @description : Fetches product details
        * @param productId : productId
        * @param priceListId : priceListId
        * @return : Product JSON
        */ 
        public String getProductDetails(String productId, String priceListId) {
            
            Map<String,Object> jsonMap = new Map<String,Object>();
            List<Product2> products = TRStore_GetPricingDetails.getProductSnapShot(productId, priceListId);
             TRStore_GetPricingDetails.productRecDetails =  products ; 
             system.debug(loggingLevel.INFO,'Products from GetPriceing Details111.......'+products ); 
            
            try {
             //Change Start - DCP-1382//
            String displayDoNotSellProducts = Static_Values__c.getValues('TransactDisplayProducts').Value__c;
            List<String> displayDontSellList=displayDoNotSellProducts.split(',');
            Set<String> displayDontSell = new Set<String>(displayDontSellList);
              
            Boolean isValidProduct = false;
            if(products.isEmpty()) {                
                isValidProduct = false;
            }else if(displayDontSell.contains(products[0].cpd_sellable_description__c)){
                isValidProduct = True;
            }else if(products[0].Apttus_Config2__PriceLists__r.isEmpty()){
                isValidProduct = false;
            }else{
                isValidProduct = True;
            }
                
            if(!isValidProduct) {                
                jsonMap.put('status',TRStore_GetPricingDetails.errorResponse());
            }//Change End - DCP-1382//
            else{
                  //Change Start - DCP-1338//
                String validSellableStatus = Static_Values__c.getValues('TransactSellableFlag').Value__c;
                List<String> sellableValuesList=validSellableStatus.split(',');
                    Set<String> valSellable = new Set<String>(sellableValuesList);
                  if(!valSellable.contains(products[0].cpd_sellable_description__c)){
                        jsonMap.put('status',TRStore_GetPricingDetails.errorResponse());
                    }else{
                        jsonMap = TRStore_GetPricingDetails.processData(productId,priceListId,products);
                     system.debug(loggingLevel.INFO,'jsonMap from GetPriceing Details222.......'+jsonMap);
                    }
                  //Change End - DCP-1338//
                }            
            }catch(exception e){
                System.debug(loggingLevel.INFO,'exception >' + e);
            }
            return JSON.serialize(jsonMap);
        }
    }
    
    Private Static Map<String,Object> processData(String productId, String priceListId,List<Product2> products){
        Map<String,Object> jsonMap = new Map<String,Object>();
        try{
        jsonMap = TRStore_GetPricingDetails.createSobjectMap(products[0],'Product2');
              //Change Start - DCP-1382//
              String displayDoNotSellProducts = Static_Values__c.getValues('TransactDisplayProducts').Value__c;
              List<String> displayDontSellList=displayDoNotSellProducts.split(',');
              Set<String> displayDontSell = new Set<String>(displayDontSellList);
              Boolean isValidProduct = false;
                if(jsonMap.isEmpty() || products.isEmpty()) {                
                    isValidProduct = false;
                }else if(displayDontSell.contains(products[0].cpd_sellable_description__c)){
                    isValidProduct = True;
                }else if(products[0].Apttus_Config2__PriceLists__r.isEmpty()){
                    isValidProduct = false;
                }else{
                    isValidProduct = True;
                }
            
            
                if(!isValidProduct) {
                    jsonMap.put('status',TRStore_GetPricingDetails.errorResponse());  //Change End - DCP-1382//
                } else{
                    List<Object> lstAuth =  TRStore_GetPricingDetails.getAuthorData(productId);
                    jsonMap.put('AuthorDetails', lstAuth);
                    List<Object> pliOb = TRStore_GetPricingDetails.pliMethod(products[0],TRStore_GetPricingDetails.getMatixData(productId, priceListId));
                    
                    Set<String> fields = new Set<String>();
                    List<Map<String,Object>> prodOptionsList = TRStore_GetPricingDetails.productOptionMethod(products[0].Apttus_Config2__OptionGroups__r,products[0].Apttus_Config2__Options__r);
                    jsonMap.put('OptionGroups',prodOptionsList);
                    List<Apttus_Config2__ProductAttribute__c> productAttributeList = TRStore_GetPricingDetails.productAttributeGroupMethod(products[0].Apttus_Config2__AttributeGroups__r);
                    if(!productAttributeList.isEmpty()){
                            fields = TRStore_GetPricingDetails.attributeFields(productAttributeList);
                        List<Map<String,Object>> prodAttList = TRStore_GetPricingDetails.productAttributeMethod(productAttributeList,TRStore_GetPricingDetails.describeMethod(fields));
                        jsonMap.put('ProductAttributes',prodAttList); 
                        }
                    LIST<ProductFormats> productFormatList = TRStore_GetPricingDetails.prodFormat(products[0]);
                    TRStore_GetPricingDetails.productFeatureWrapper mapProductFeatures = TRStore_GetPricingDetails.productFeatureMethod(products[0].Product_Collateral_Values__r,products[0].Apttus_Config2__ProductFeatureValues__r);
                    jsonMap.put('status',TRStore_GetPricingDetails.successResponse());
                    productFormatList.addAll(mapProductFeatures.productFormatList); //commented as part of french translation
                   System.debug(loggingLevel.INFO,' Sending value 368  ' + mapProductFeatures.productFormatList);
                   
                   LIST<ProductFormats> productFormatListTranslated = new LIST<ProductFormats> ();
                   productFormatListTranslated.addAll( (TRStoreProductPricingService.language == 'FR')? translateFrench(productFormatList) : productFormatList );
                     
                    jsonMap.put('ProductFormat', productFormatListTranslated); 
                    jsonMap.put('PriceLists',pliOb);
                    jsonMap.put('ProductFeatureValues',mapProductFeatures.objList);
                }
            }catch(Exception e){
                System.debug(loggingLevel.INFO,'exception >' + e);
            }
          return jsonMap;
    }

    private static LIST<ProductFormats> translateFrench(LIST<ProductFormats> pfm){
        map<string, string> engFormats = new map<string, string>();
        map<string, string> frFormats = new map<string, string>();
        
        System.debug(loggingLevel.INFO,' ProductFormats 384  ' + pfm);
        
        for(ProductFormats pf: pfm){
            engFormats.put(pf.format, pf.format);
        }
        
        System.debug(loggingLevel.INFO,' engFormats 390  ' + engFormats);
        
        for(Language_Translations__mdt lmd: [SELECT id, Eng_Values__c, Translated_Value__c FROM Language_Translations__mdt  WHERE Eng_Values__c IN: engFormats.values() AND Language__c = 'French' ]){
            frFormats.put(lmd.Eng_Values__c, lmd.Translated_Value__c );
        }
        System.debug(loggingLevel.INFO,' frFormats 395  ' + frFormats);
        
        for(ProductFormats pf: pfm){
             pf.format = ( frFormats.containsKey(pf.format) ) ? frFormats.get(pf.format) : pf.format ;
        }
        System.debug(loggingLevel.INFO,' return 395  ' + pfm);
        
        return pfm;
    }


    Private Static Set<String> attributeFields(List<Apttus_Config2__ProductAttribute__c> productAttributeList){
        Set<String> fields = new Set<String>();
        for(Apttus_Config2__ProductAttribute__c prodAtt: productAttributeList){
            fields.add(prodAtt.Apttus_Config2__Field__c);
        }
        return fields;
    }

    Private Static LIST<ProductFormats> prodFormat(Product2 products){
        LIST<ProductFormats> productFormatList = new LIST<ProductFormats>();
        TRStore_GetPricingDetails.ProductFormats prdtFormat =  new TRStore_GetPricingDetails.ProductFormats();
                    prdtFormat.format = products.Format__c;
                    prdtFormat.productId = products.ProductCode;
                    productFormatList.add(prdtFormat);
         return productFormatList;
    }

    Private Static list<Object> pliMethod(Product2 product, Map<String, List<Apttus_Config2__PriceMatrix__c>> mapMatrices){
        List<Object> pliOb = new List<Object>();
        List<Apttus_Config2__PriceListItem__c> priceLists = product.Apttus_Config2__PriceLists__r;
        Boolean gPPCheck = false;
        if(Static_Values__c.getValues('GPPCheck') <> null){
            gPPCheck = Static_Values__c.getValues('GPPCheck').Value__c == 'Enabled';
        }
        Boolean isZVSUProduct = product.APTS_Media_High_Level_Code__c == '21' && product.APTS_Item_Category_Group__c == 'ZVSU' && product.APTS_Media_Lower_Level_Code__c == 'F4' && gPPCheck;
        
        if(isZVSUProduct){
            for(Integer i=0; i< priceLists.size();i++) {
                if(priceLists[0].Apttus_Config2__ChargeType__c == 'Standard Price' && priceLists[0].Apttus_Config2__ListPrice__c <> 0){
                    Apttus_Config2__PriceListItem__c copyPli = new Apttus_Config2__PriceListItem__c();
                    copyPli.Apttus_Config2__Criteria__c = '{"sObjectName" : "Apttus_Config2__LineItem__c","sObjectLabel" : "Line Item","searchText" : null,"filter" : {"predicates" : [ {"RowNum" : 1,"RHSSObjectName" : null,"RHSFieldType" : null,"RHSFieldName" : null,"RHSFieldLabel" : null,"RHSChildFilterName" : null,"RefFieldName" : null,"OffsetValue" : null,"LHSSObjectName" : null,"LHSChildFilterName" : null,"FieldValue" : "Ship & Entitle Sub","FieldType" : "STRING","FieldName" : "Purchase_Option_Bundle_Print__c","FieldLabel" : "Purchase Option","CompOper" : "equal to","BoolOper" : null} ],"hasRHSFields" : false,"condExpr" : "1","childFilter" : null},"fields" : [ "Purchase_Option_Bundle_Print__c" ],"exprStr" : "(Purchase Option = Ship & Entitle Sub)"}';
                  copyPli.Apttus_Config2__ChargeType__c = 'Subscription Fee';
                    copyPli.Apttus_Config2__Sequence__c = 200;
                    copyPli.Apttus_Config2__ExpirationDate__c = priceLists[i].Apttus_Config2__ExpirationDate__c;
                    copyPli.Apttus_Config2__EffectiveDate__c = priceLists[i].Apttus_Config2__EffectiveDate__c;
                    copyPli.Apttus_Config2__ContractPrice__c = priceLists[i].Apttus_Config2__ContractPrice__c;
                    copyPli.Apttus_Config2__Active__c = priceLists[i].Apttus_Config2__Active__c;
                    copyPli.Apttus_Config2__ProductId__c = priceLists[i].Apttus_Config2__ProductId__c;
                    copyPli.Apttus_Config2__PriceListId__c =  priceLists[i].Apttus_Config2__PriceListId__c;
                    copyPli.Apttus_Config2__PriceUom__c = priceLists[i].Apttus_Config2__PriceUom__c;
                    copyPli.Apttus_Config2__PriceMethod__c =  priceLists[i].Apttus_Config2__PriceMethod__c;
                    copyPli.Apttus_Config2__Frequency__c = priceLists[i].Apttus_Config2__Frequency__c;
                    copyPli.Apttus_Config2__PriceType__c = priceLists[i].Apttus_Config2__PriceType__c;
                    copyPli.Apttus_Config2__DefaultSellingTerm__c = priceLists[i].Apttus_Config2__DefaultSellingTerm__c;
                    copyPli.Apttus_Config2__ListPrice__c = priceLists[i].Apttus_Config2__ListPrice__c;
                    String pId = priceLists[i].Id;
                    pId = pId.substring(0, 15) + 'ABC';
                    copyPli.Id = pId;
                    priceLists.add(copyPli);
                    break;
                }
            }
        }
        for(Integer i=0; i< priceLists.size();i++) {
            Map<String,Object> pliMap = TRStore_GetPricingDetails.createSobjectMap(priceLists[i],'PriceListItem');
            List<Object> priceMatrixLst = new List<Object>();
            if(priceLists[i].Apttus_Config2__NumberOfMatrices__c > 0 && priceLists[i].Apttus_Config2__Sequence__c <> 200) {
                priceMatrixLst = TRStore_GetPricingDetails.calculatePriceMatrices(mapMatrices,priceLists[i].Id);
            }
            pliMap.put('PriceMatrices',priceMatrixLst);
            pliOb.add(pliMap); 
        }
        return pliOb;
    }

    Private Static Map<String,String> errorResponse(){
        Map<String,String> errorMap = new Map<String,String>();
        errorMap.put('statusDesc',TRStoreConstants.DETAILS_NOT_FOUND);
        errorMap.put('statusCode',TRStoreConstants.DETAILS_NOT_FOUND_CODE);
        errorMap.put('status',TRStoreConstants.SUCCESS_STATUS);
        return errorMap;
    }

        /** 
        * @description : Required Field Missing Response
        * @return : Error JSON response 
        */ 
    public Static Map<String,String> fieldMissingResponse(){
        Map<String,String> errorMap = new Map<String,String>();
        errorMap.put('statusDesc',TRStoreConstants.REQUIREDFIELDSMISSING);
        errorMap.put('statusCode',TRStoreConstants.ERROR_CODE);
        errorMap.put('status',TRStoreConstants.FAILURESTATUS);
        return errorMap;
    }

    Private Static Map<String,String> successResponse(){
        Map<String,String> successMap= new Map<String,String>();
                    successMap.put('statusDesc',TRStoreConstants.DETAILS_FOUND);
                    successMap.put('statusCode',TRStoreConstants.SUCCESS_CODE);
                    successMap.put('status',TRStoreConstants.SUCCESS_STATUS);
                    return successMap;
    }

    Private Static  List<Apttus_Config2__ProductAttribute__c> productAttributeGroupMethod(List<Apttus_Config2__ProductAttributeGroupMember__c> prodAttributeGM){
        Set<Id> prodAttributeGrpIDs = new Set<Id>();

        for(Apttus_Config2__ProductAttributeGroupMember__c grpMem : prodAttributeGM) {
            ID tempAttID = grpMem.apttus_config2__attributegroupid__r.id;
            prodAttributeGrpIDs.add(tempAttID);
         }
         
         List<Apttus_Config2__ProductAttribute__c> productAttributeList = new List<Apttus_Config2__ProductAttribute__c>();
         if (prodAttributeGrpIDs!=null){
              if(Schema.sObjectType.Apttus_Config2__ProductAttribute__c.isAccessible()){
                  productAttributeList = [SELECT Id,  Name, Apttus_Config2__AttributeGroupId__c, Apttus_Config2__DisplayType__c, Apttus_Config2__FieldUpdateId__c, Apttus_Config2__Field__c, Apttus_Config2__IsHidden__c, Apttus_Config2__IsPrimary__c, Apttus_Config2__IsReadOnly__c, Apttus_Config2__ProductAttributeValueField__c, Apttus_Config2__Sequence__c
                                                                FROM Apttus_Config2__ProductAttribute__c 
                                                                WHERE Apttus_Config2__AttributeGroupId__c IN: prodAttributeGrpIDs];                                                     
              }
         }
         return productAttributeList;
        
    }

    Private Static List<Map<String,Object>> productOptionMethod(List<Apttus_Config2__ProductOptionGroup__c> prodOptionGroup,List<Apttus_Config2__ProductOptionComponent__c> prodOptionComponent){
        List<Map<String,Object>> prodOptionsList = new List<Map<String,Object>>();
        for(Apttus_Config2__ProductOptionGroup__c og : prodOptionGroup) {
            //Map<String, Object> mapOG = TRStore_GetPricingDetails.createSobjectMap(og,'ProductOptionGroup');
            for(Integer i=0; i< prodOptionComponent.size(); ++i){ 
                    if(prodOptionComponent[i].Apttus_Config2__ProductOptionGroupId__c == og.id){
                        prodOptionsList.add(TRStore_GetPricingDetails.createSobjectMap(prodOptionComponent[i],'ProductOptionComponent'));
                    }
                }
            }
            return prodOptionsList;
    }

    Private Static List<Map<String,Object>> productAttributeMethod(List<Apttus_Config2__ProductAttribute__c> productAttributeList,Map<String,TRStore_GetPricingDetails.Describe> describeJson){
        List<Map<String,Object>> prodAttList = new List<Map<String,Object>>();             
              for(Apttus_Config2__ProductAttribute__c patt: productAttributeList) {
                  
                  //string toCheckFieldType = patt.Apttus_Config2__Field__c;
                  Map<string, object > localProdAttr = new Map<string, object>();
                  localProdAttr  = TRStore_GetPricingDetails.createSobjectMap(patt,'ProductAttribute');
                  if(describeJson.containsKey(patt.Apttus_Config2__Field__c)){
                      localProdAttr.put('type',(describeJson.get(patt.Apttus_Config2__Field__c).type));
                      localProdAttr.put('picklistValues',(describeJson.get(patt.Apttus_Config2__Field__c).picklistvalues));
                  }
                  prodAttList.add(localProdAttr);                  
               }
               return prodAttList;
    }


    private Static TRStore_GetPricingDetails.productFeatureWrapper productFeatureMethod(List<Product_Collateral_Value__c> prodCollateralValueList,List<Apttus_Config2__ProductFeatureValue__c> prodFeatValList) {
        List<Object> lstOb = new List<Object>();
                    
                    List<Apttus_Config2__ProductFeatureValue__c> localPfvList = new List<Apttus_Config2__ProductFeatureValue__c>();
                    List<Apttus_Config2__Feature__c> localPfList = new List<Apttus_Config2__Feature__c>();
                    List<Apttus_Config2__FeatureSet__c> localFeatSetList = new List<Apttus_Config2__FeatureSet__c>();
                    Map<String,Object> prodfeatValMap = new Map<String,Object>();
                    Map<String,Object> featureMap = new Map<String,Object>();
                    Apttus_Config2__FeatureSet__c localFeatSet = new Apttus_Config2__FeatureSet__c();
                    localFeatSet.Apttus_Config2__Description__c = null;
                    localFeatSet.Apttus_Config2__Sequence__c = 2;
                    localFeatSet.Name = 'Hardcover Specifications';
                    
                    string  relNote = Static_Values__c.getValues('Release Note').Value__c;
                    string  index = Static_Values__c.getValues('Index').Value__c;
                    string  tableOfContent = Static_Values__c.getValues('Table of Contents').Value__c;
                    
                    Map<String, String> mapTitle = new Map<String,String>{relNote=>'ReleaseNote',index=>'IndexNote',tableOfContent=>'Table of content'};
                    Map<String, String> mapPath = new Map<String,String>{relNote=>'ReleaseFileName',index=>'IndexFileName',tableOfContent=>'TOCFileName'};
                   
                    for(Product_Collateral_Value__c prodCollateral : prodCollateralValueList){
                        system.debug(loggingLevel.INFO,'prodCollateralValueList>>>'+prodCollateralValueList);
                        if((mapTitle.containsKey(prodCollateral.Product_Collateral__r.Collateral_Type__c))) {
                            Apttus_Config2__ProductFeatureValue__c localPfv = new Apttus_Config2__ProductFeatureValue__c();
                            Apttus_Config2__Feature__c localPf = new Apttus_Config2__Feature__c();
                    
                            localFeatSet.Id = null;
                            localFeatSetList.add(localFeatSet);
                            
                            localPf.Apttus_Config2__Description__c = null;
                            localPf.Apttus_Config2__Sequence__c = 1;
                            localPf.name = mapTitle.get(prodCollateral.Product_Collateral__r.Collateral_Type__c);
                            localPfList.add(localPf);
                            
                            localPfv.Apttus_Config2__IsIncluded__c = false;
                            localPfv.Apttus_Config2__ProductId__c = prodCollateral.Product__r.Id;
                            localPfv.Apttus_Config2__Value__c = (prodCollateral.Product_Collateral__r.Collateral_Path__c != null )? 'Yes' : 'No' ;
                             localPfvList.add(localPfv);
                            prodfeatValMap = TRStore_GetPricingDetails.createSobjectMap(localPfv,'ProductFeatureValue');
                            featureMap = TRStore_GetPricingDetails.createSobjectMap(localPf,'Feature');
                            prodfeatValMap.put('Feature',featureMap);  
                            featureMap.put('FeatureSet',TRStore_GetPricingDetails.createSobjectMap(localFeatSet,'Featureset'));
                            lstOb.add(prodfeatValMap);
                            
                        }
                        
                        if(string.isNotBlank(prodCollateral.Product_Collateral__r.Collateral_Path__c) 
                               && mapPath.containsKey(prodCollateral.Product_Collateral__r.Collateral_Type__c)) {
                            Apttus_Config2__ProductFeatureValue__c localPfv = new Apttus_Config2__ProductFeatureValue__c();
                            Apttus_Config2__Feature__c localPf = new Apttus_Config2__Feature__c();
                    
                            localFeatSet.Id = null;
                            localFeatSetList.add(localFeatSet);
                            
                            localPf.Apttus_Config2__Description__c = null;
                            localPf.Apttus_Config2__Sequence__c = 1;
                            localPf.name = mapPath.get(prodCollateral.Product_Collateral__r.Collateral_Type__c);
                            localPfList.add(localPf);
                            
                            localPfv.Apttus_Config2__IsIncluded__c = false;
                            localPfv.Apttus_Config2__ProductId__c = prodCollateral.Product__r.Id;
                            localPfv.Apttus_Config2__Value__c = (string.isNotBlank(prodCollateral.Product_Collateral__r.Collateral_Path__c))?prodCollateral.Product_Collateral__r.Collateral_Path__c:TRStoreConstants.NOT_AVAILABLE;
                            localPfvList.add(localPfv);
                            prodfeatValMap = TRStore_GetPricingDetails.createSobjectMap(localPfv,'ProductFeatureValue');
                            featureMap = TRStore_GetPricingDetails.createSobjectMap(localPf,'Feature');
                            prodfeatValMap.put('Feature',featureMap);  
                            featureMap.put('FeatureSet',TRStore_GetPricingDetails.createSobjectMap(localFeatSet,'Featureset'));
                            lstOb.add(prodfeatValMap);
                        }
                        
                    }
                    TRStore_GetPricingDetails.productFeatureWrapper  lstObUpdate = TRStore_GetPricingDetails.productFeatureListMethod(prodFeatValList,lstOb);
                    
                    return lstObUpdate;
    }
    
    /** 
    * @description : Fetched product feature data
    * @param prodFeatValList : product feature value list
    * @param lstOb : List of objects
    * @return : Product feature array
    */   
    public static TRStore_GetPricingDetails.productFeatureWrapper  productFeatureListMethod(List<Apttus_Config2__ProductFeatureValue__c> prodFeatValList,List<object> lstOb){
        List<Object> objList = lstOb;
        TRStore_GetPricingDetails.productFeatureWrapper  listFormatFeature = new TRStore_GetPricingDetails.productFeatureWrapper();
        list<ProductFormats> productFormatList = new list<ProductFormats>();
        for(Integer i=0; i< prodFeatValList.size();i++) {
            Map<String,Object> prodfeatValMap = TRStore_GetPricingDetails.createSobjectMap(prodFeatValList[i],'ProductFeatureValue');   
            system.debug(loggingLevel.INFO,'prodFeatValList>>>'+prodFeatValList);
            Apttus_Config2__Feature__c feature = prodFeatValList[i].Apttus_Config2__FeatureId__r;
            
            if(feature != null ) {
                Map<String,Object> featureMap = TRStore_GetPricingDetails.createSobjectMap(feature,'Feature');
                prodfeatValMap.put('Feature',featureMap);
                Apttus_Config2__FeatureSet__c featureSet = feature.Apttus_Config2__FeatureSetId__r;
                if(featureSet <> null) {
                    featureMap.put('FeatureSet',TRStore_GetPricingDetails.createSobjectMap(featureSet,'Featureset'));
                }
                if(featureSet.Name == 'Formats') {
                      //formatMap.put(feature.Name, prodFeatValList[i].Apttus_Config2__Value__c);
                    TRStore_GetPricingDetails.ProductFormats pdtFormat = new TRStore_GetPricingDetails.ProductFormats();
                    pdtFormat.format = feature.Name;
                    pdtFormat.productId = prodFeatValList[i].Apttus_Config2__Value__c;
                    productFormatList.add(pdtFormat);
                }
            } 
            
            objList.add(prodfeatValMap);    
            listFormatFeature.objList=objList;
            listFormatFeature.productFormatList=productFormatList;     
        }
        return listFormatFeature;
    }

    /** 
    * @description : Product feature Wrapper
    */  
    public class ProductFeatureWrapper{
        public List<Object> objList;
        public List<ProductFormats> productFormatList;
        /** 
        * @description : Product feature Wrapper constructor
        */
        public productFeatureWrapper(){
            this.objList = new List<object>();
            this.productFormatList = new List<ProductFormats>();
        }
    }
    
}