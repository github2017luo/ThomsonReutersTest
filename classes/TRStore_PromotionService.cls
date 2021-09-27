/* Class: TRStore_PromotionService
* Purpose: Rest API Service to bring the JSON formatted Promotion related Apttus objects for pricelist
* Created: 02/24/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================================================================
* Date         Name             JIRA        Description
* 2020-02-24   Avudaiappan A     DUE-622   Creating Promotion Object JSON 
* 2020-05-04   Ameeta A          DUE-2373  Cart Page:Apply Promo Code SFDC-Added additional fields as per the new JSON structure
* 2020-06-26   Ameeta A          DUE-3628  Promocode API changes to support auto promotion
* 2020-07-10   Avudaiappan A     DUE-3883  Store valid promocode in server side cart
* 2020-11-04   Avudaiappan A     DUE-6164  Code Refactor for PMD
* 2020-12-02   Avudaiappan A     DUE-6415  Added IncentiveCode in response.
* 2021-01-15   Kanishk           DUE-6415  Status code extra 'space' removal
* 2021-02-23   Kanishk           DUE-6956  Auto apply flag and incentive name addition in response
* =============================================================================================================================
*/
@RestResource(urlMapping='/GetPromotionDetails')
/** 
 * @description : Provides promotion details to the front end
 */ 
global with sharing class TRStore_PromotionService {
    public static list<string> promos;
    public static JSONGenerator gen;
    /** 
     * @description : Promotion service request
     */ 
    global class TRStore_PromotionRequestClass
    {
        public list<string> promoList;
        public boolean autoApply;
        public string site;
        public string cartId;
    }
    
     
    @HttpPost
    /** 
     * @description : Prepares promotion data based on the request
     * @param promoReq : request body for the service
     */ 
    global static void getPromotionData(TRStore_PromotionService.TRStore_PromotionRequestClass promoReq) {
        String promoJsonData;
        promos = new List<string>();
        system.debug(loggingLevel.INFO,'promo@@@'+promoReq);
        RestRequest req = RestContext.request;
        gen = JSON.createGenerator(true); 
        RestContext.request = req;
        
        if(promoReq.autoApply && promoReq.site != null){
            promoJsonData = TRStore_PromotionService.callMainMethod(gen,promoReq);
        }else{
            promoJsonData = TRStore_PromotionService.errorResponse(gen,promoReq);
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        try{ 
            RestContext.response.responseBody = Blob.valueOf(promoJsonData);
        }catch(Exception e){
            system.debug(loggingLevel.INFO,'Exception:'+e);
            String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        
        if(!promos.isEmpty() && String.isNotBlank(promoReq.cartId)){
            updateCartWithPromo(promos,promoReq.cartId);
        }
        
    }

    private static string callMainMethod(JSONGenerator gen,TRStore_PromotionService.TRStore_PromotionRequestClass promoReq){
        string promoJsonData;
         
        Map<Id,Apttus_Config2__PriceRuleSet__c> priceRulSetMap = new  Map<Id,Apttus_Config2__PriceRuleSet__c>([select Id, Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c , Apttus_Config2__Criteria__c, Apttus_Config2__IncentiveId__r.Apttus_Config2__AutoApply__c, Apttus_Config2__IncentiveId__r.Name
                                                                            from Apttus_Config2__PriceRuleset__c  where Apttus_Config2__IncentiveId__r.Apttus_Config2__EffectiveDate__c <= TODAY and Apttus_Config2__IncentiveId__r.Apttus_Config2__ExpirationDate__c >= TODAY 
                                                                            and Apttus_Config2__ExpirationDate__c >= TODAY and Apttus_Config2__EffectiveDate__c <= TODAY and Apttus_Config2__Active__c = true and Apttus_Config2__IncentiveId__r.Apttus_Config2__Active__c = TRUE 
                                                                            AND Apttus_Config2__IncentiveId__r.Apttus_Config2__AutoApply__c = TRUE ]);

        List<string> countryPromocodes = new LIST<string>();
        for( Apttus_Config2__PriceRuleSet__c prs : priceRulSetMap.values()){
            if(prs.Apttus_Config2__Criteria__c != null && prs.Apttus_Config2__Criteria__c.containsIgnoreCase('TRStore_Site__c')  &&  prs.Apttus_Config2__Criteria__c.containsIgnoreCase(promoReq.site) ){
                countryPromocodes.add(prs.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c); 
            }                    
        }

        if(!countryPromocodes.isEmpty()){
            promoJsonData = getPromoCodeDetails(gen,countryPromocodes,promoReq.autoApply);
        }else{
            gen = TRStore_PromotionService.getErrorResponse();
            promoJsonData = gen.getAsString();
        }
        return promoJsonData;
    }

    private static string errorResponse(JSONGenerator gen,TRStore_PromotionService.TRStore_PromotionRequestClass promoReq){
        string promoJsonData;
        if(!promoReq.promoList.isEmpty() && String.isNotBlank(promoReq.cartId)){
            promoJsonData = getPromoCodeDetails(gen,promoReq.promoList,promoReq.autoApply);
            system.debug(loggingLevel.INFO,'@@JSON String:'+promoJsonData); 
         }else{
             gen.writeStartObject(); 
             gen.writeFieldName('status');
                 gen.writeStartObject();
                 gen.writeStringField('statusDesc',TRStoreConstants.REQUIREDFIELDSMISSING);
                 gen.writeStringField('statusCode',TRStoreConstants.ERROR_CODE);
                 gen.writeStringField('status',TRStoreConstants.FAILURESTATUS);
                 gen.writeEndObject();
                 gen.writeEndObject();
             promoJsonData = gen.getAsString();
         }
        return promoJsonData;

    }
    
/********************************************************************************************************
* updateCartWithPromo: Method to update promocode in the server side cart 
*  @input promoCodeList,cartId
*********************************************************************************************************/
    @future
     /** 
     * @description : Start method
     * @param promos : List of promo codes
     * @param cartId : Id of current cart
     */ 
    public static void updateCartWithPromo (List<string> promos, String cartId){
        try{
            String query = 'select id,Apttus_Config2__CouponCodes__c from Apttus_Config2__ProductConfiguration__c where Id=:CartId limit 1';
            Apttus_Config2__ProductConfiguration__c pc = Database.Query(query);
               if(pc!=null){
                   for(String promo: promos){
                     if( String.isBlank(pc.Apttus_Config2__CouponCodes__c) || !String.valueOf(pc.Apttus_Config2__CouponCodes__c).contains(promo)){
                       pc.Apttus_Config2__CouponCodes__c = String.isNotBlank(pc.Apttus_Config2__CouponCodes__c)?pc.Apttus_Config2__CouponCodes__c+','+promo: promo;
                     }
                   }
               Database.update(pc,false);
            }
         }catch(Exception e){
            system.debug(loggingLevel.INFO,'Exception:'+e);
            String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Promo Update on Cart','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);
        }
    }
/********************************************************************************************************
* getAttributeDetails: Common Method to retrieve the attribute details for each price dimension.
*  @input AttributeID, JSONGenerator
*********************************************************************************************************/  
    /** 
     * @description : Fetches attribute details
     * @param attributeId : attribute ID
     * @param gen : instance of JSON generator 
     */ 
    public static void getAttributeDetails(Id attributeId, JSONGenerator gen){
        system.debug(loggingLevel.INFO,'Attribute Id:'+attributeId);
        if(attributeId != null){
            for(Apttus_Config2__ProductAttribute__c prodAtt :[select id,Apttus_Config2__AttributeGroupId__c,Apttus_Config2__AttributeGroupId__r.Name,Apttus_Config2__DisplayType__c,Apttus_Config2__Field__c,Apttus_Config2__FieldUpdateId__c,
                                                                     Apttus_Config2__IsHidden__c,Apttus_Config2__IsPrimary__c,Apttus_Config2__IsReadOnly__c,Apttus_Config2__ProductAttributeValueField__c,Apttus_Config2__Sequence__c
                                                                     from Apttus_Config2__ProductAttribute__c where ID =: attributeId]){
                gen.writeFieldName('Attribute');
                gen.writeStartObject();
                gen.writeStringField('AttributeGroupId', String.isNotBlank(prodAtt.Apttus_Config2__AttributeGroupId__c)?String.valueof(prodAtt.Apttus_Config2__AttributeGroupId__c):TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('AttributeGroup', TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('DisplayType', String.isNotBlank(prodAtt.Apttus_Config2__DisplayType__c)?prodAtt.Apttus_Config2__DisplayType__c:TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('Field', String.isNotBlank(prodAtt.Apttus_Config2__Field__c)?prodAtt.Apttus_Config2__Field__c:TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('FieldUpdateId', String.isNotBlank(prodAtt.Apttus_Config2__FieldUpdateId__c)?String.valueof(prodAtt.Apttus_Config2__FieldUpdateId__c):TRStoreConstants.NOT_AVAILABLE);
                gen.writeBooleanField('IsHidden', prodAtt.Apttus_Config2__IsHidden__c);
                gen.writeBooleanField('IsPrimary', prodAtt.Apttus_Config2__IsPrimary__c);
                gen.writeBooleanField('IsReadOnly', prodAtt.Apttus_Config2__IsReadOnly__c); 
                gen.writeStringField('ProductAttributeValueField', String.isNotBlank(prodAtt.Apttus_Config2__ProductAttributeValueField__c)?prodAtt.Apttus_Config2__ProductAttributeValueField__c:TRStoreConstants.NOT_AVAILABLE);
                gen.writeNumberField('Sequence', (prodAtt.Apttus_Config2__Sequence__c != null)?prodAtt.Apttus_Config2__Sequence__c:0);     
                gen.writeEndObject();                                                        
            }
        }
    }
    
   
    
    
/********************************************************************************************************
* getPromoCodeDetails: Method to retrieve the JSON structure of the promotion details for the given promo code list.
*  @input promoCodeList
*********************************************************************************************************/
    /** 
     * @description : Fetches promotion data for the requested promocode
     * @param gen : JSON generator instance
     * @param promoCodeList : List of promo codes
     * @param autoApply : Auto apply flag
     * @return : promocode details
     */ 
    public static String getPromoCodeDetails(JSONGenerator gen,List<string> promoCodeList, boolean autoApply){
        Map<Id,List<Apttus_Config2__PriceRule__c>> priceRulMap = new  Map<Id,List<Apttus_Config2__PriceRule__c>>();
        TRStore_PromotionService.PriceRuleCls prc = new TRStore_PromotionService.PriceRuleCls();
        Map<Id,List<Apttus_Config2__PriceRuleEntry__c>> priceRulEntryMap = new  Map<Id,List<Apttus_Config2__PriceRuleEntry__c>>();
        List<Apttus_Config2__PriceRule__c> prlist = new List<Apttus_Config2__PriceRule__c>();
        if(promos==null){
            promos = new List<string>();
        }
        Set<Id> prIds = new Set<Id>();
        //Set<Id> prodIds = new Set<Id>();
        //Set<String> prodGrpIds = new Set<String>();
        
        if( (promoCodeList!= null && promoCodeList.size()>0)){ //&& (promoReq.productList!= null && promoReq.productList.size()>0)){
            Map<Id,Apttus_Config2__PriceRuleSet__c> priceRulSetMap = new  Map<Id,Apttus_Config2__PriceRuleSet__c>([select Id,Apttus_Config2__IncentiveId__r.Apttus_Config2__PriceListScope__c,Apttus_Config2__HasCriteria__c, Apttus_Config2__Criteria__c, Apttus_Config2__ExclusionCriteria__c, Apttus_Config2__IncentiveId__r.Apttus_Config2__ExcludeChildrenWithActivePrograms__c,
                                                                            Apttus_Config2__IncentiveId__r.Name,Apttus_Config2__IncentiveId__r.Apttus_Config2__Active__c,Apttus_Config2__IncentiveId__r.Apttus_Config2__EffectiveDate__c,Apttus_Config2__IncentiveId__r.Apttus_Config2__ExpirationDate__c,
                                                                            Apttus_Config2__IncentiveId__r.Apttus_Config2__AutoApply__c, Apttus_Config2__IncentiveId__r.Apttus_Config2__StopProcessingMoreIncentives__c,Apttus_Config2__Active__c, Apttus_Config2__EffectiveDate__c, Apttus_Config2__ExpirationDate__c,
                                                                            Apttus_Config2__AdjustmentAppliesTo__c,Apttus_Config2__UseType__c,Apttus_Config2__Category__c,Apttus_Config2__PriceListId__c,Apttus_Config2__Sequence__c,Apttus_Config2__StopProcessingMoreRules__c,Apttus_Config2__Type__c
                                                                            from Apttus_Config2__PriceRuleset__c where  Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c IN:promoCodeList and Apttus_Config2__IncentiveId__r.Apttus_Config2__EffectiveDate__c <= TODAY and Apttus_Config2__IncentiveId__r.Apttus_Config2__ExpirationDate__c >= TODAY 
                                                                            and Apttus_Config2__ExpirationDate__c >= TODAY and Apttus_Config2__EffectiveDate__c <= TODAY and Apttus_Config2__Active__c = true and Apttus_Config2__IncentiveId__r.Apttus_Config2__Active__c = true]);
                
                   
             system.debug(loggingLevel.INFO,'Promotion:'+priceRulSetMap.values()); 
            if(!priceRulSetMap.isEmpty()){
                
                prc = TRStore_PromotionService.getPriceRule(priceRulSetMap);
                //if(!priceRulMap.isEmpty()){
                    prIds = prc.prIds;
                    prlist = prc.prList;
                    priceRulMap = prc.prRulMap;
                //}
                system.debug(loggingLevel.INFO,'PriceRule:'+prlist);
            }
            if(!prIds.isEmpty()){
                priceRulEntryMap = TRStore_PromotionService.segPriceRuleEntry(prIds);
            }
            if(!prList.isEmpty() && !priceRulEntryMap.isEmpty()){
               for(Apttus_Config2__PriceRule__c pr: prList){
                    TRStore_PromotionService.callPrimaryMethod(gen,autoapply,pr);
                    TRStore_PromotionService.callPRE(gen,pr,priceRulEntryMap);
                    gen.writeEndArray();
                    gen.writeEndObject();
                }
            }else{
                gen = TRStore_PromotionService.getErrorResponse();
            }
            
        }else{
            gen = TRStore_PromotionService.getFieldErrorResponse();  
        }
         String jsonData = gen.getAsString();
         return jsonData;
    }
    /** 
     * @description : Price rule wrapper class
     */ 
    public class PriceRuleCls{
        public Set<Id> prIds;
        public List<Apttus_Config2__PriceRule__c> prList;
        public Map<Id, List<Apttus_Config2__PriceRule__c>> prRulMap;
        
        /** 
         * @description : Price rule wrapper constructor
         */        
        public priceRuleCls(){
            prIds = new Set<Id>();
            prList = new List<Apttus_Config2__PriceRule__c>();
            prRulMap = new Map<Id, List<Apttus_Config2__PriceRule__c>>();
        }
    }

    private static void callPrimaryMethod(JSONGenerator gen,boolean autoApply,Apttus_Config2__PriceRule__c pr){
        TRStore_PromotionService.promoJson(gen,pr);
        TRStore_PromotionService.promoJson1(gen,pr,autoapply);
        TRStore_PromotionService.promoJson2(gen,pr);
        TRStore_PromotionService.promoJson3(gen,pr);
        TRStore_PromotionService.promoJson4(gen,pr);
        TRStore_PromotionService.promoJson5(gen,pr);
        TRStore_PromotionService.promoJson6(gen,pr);
        TRStore_PromotionService.promoJson7(gen,pr);
        TRStore_PromotionService.promoJson8(gen,pr);
        TRStore_PromotionService.callProductInfo1(gen,pr);
        TRStore_PromotionService.callProductInfo2(gen,pr);
        TRStore_PromotionService.callProductInfo3(gen,pr);
        TRStore_PromotionService.callProductInfo4(gen,pr);
        TRStore_PromotionService.callProductInfo5(gen,pr);
        TRStore_PromotionService.callProductInfo6(gen,pr);
        TRStore_PromotionService.callProductInfo7(gen,pr);
        TRStore_PromotionService.callProductInfo8(gen,pr);
        TRStore_PromotionService.callProductInfo9(gen,pr);
    }

    private static void callPRE(JSONGenerator gen,Apttus_Config2__PriceRule__c pr,Map<Id,List<Apttus_Config2__PriceRuleEntry__c>> priceRulEntryMap){
        TRStore_PromotionService.doPriceRuleEntry(gen,pr,priceRulEntryMap);
    }

    private static JsonGenerator getErrorResponse(){
        JSONGenerator gen1 = JSON.createGenerator(true); 
        gen1.writeStartObject(); 
        gen1.writeFieldName('status');
        gen1.writeStartObject();
        gen1.writeStringField('statusDesc',TRStoreConstants.DETAILS_NOT_FOUND);
        gen1.writeStringField('statusCode',TRStoreConstants.DETAILS_NOT_FOUND_CODE);
        gen1.writeStringField('status',TRStoreConstants.SUCCESS_STATUS);
        gen1.writeEndObject();
        gen1.writeEndObject();
        return gen1;
    }

    private static JSONGenerator getFieldErrorResponse(){
        JSONGenerator gen1 = JSON.createGenerator(true); 
        gen1.writeStartObject(); 
        gen1.writeFieldName('status');
        gen1.writeStartObject();
        gen1.writeStringField('statusDesc',TRStoreConstants.REQUIREDFIELDSMISSING);
        gen1.writeStringField('statusCode',TRStoreConstants.ERROR_CODE);
        gen1.writeStringField('status',TRStoreConstants.FAILURESTATUS);
        gen1.writeEndObject();
        gen1.writeEndObject();
        return gen1;
    }

    private Static TRStore_PromotionService.PriceRuleCls getPriceRule(Map<Id,Apttus_Config2__PriceRuleSet__c> priceRulSetMap){
        TRStore_PromotionService.PriceRuleCls prc = new TRStore_PromotionService.PriceRuleCls();
        Set<Id> prIds = new Set<Id>();
        List<Apttus_Config2__PriceRule__c> prList = new List<Apttus_Config2__PriceRule__c>();
        Map<Id,List<Apttus_Config2__PriceRule__c>> priceRulMap = new  Map<Id,List<Apttus_Config2__PriceRule__c>>();
        for(Apttus_Config2__PriceRule__c pRule: [Select id,Apttus_Config2__Sequence__c,Apttus_Config2__RuleType__c,Apttus_Config2__RuleSubType__c,Apttus_Config2__StopProcessingMoreRules__c,Apttus_Config2__RulesetId__c,
            Apttus_Config2__AdjustmentChargeType__c,Apttus_Config2__AdjustmentAppliesTo__c,Apttus_Config2__ProductCriteria__c,Apttus_Config2__ProductCriteriaOper__c,
            Apttus_Config2__AllowableAction__c,Apttus_Config2__AllowRemovalOfAdjustment__c,Apttus_Config2__ApplicationMethod__c,Apttus_Config2__BeneficiaryId__c,Apttus_Config2__BeneficiaryType__c,Apttus_Config2__BenefitType__c,
            Apttus_Config2__ChargeTypeCriteria__c,Apttus_Config2__ChargeTypeCriteriaOper__c,Apttus_Config2__CountryCriteria__c,Apttus_Config2__CountryCriteriaOper__c,Apttus_Config2__CustomPricePointSource__c,Apttus_Config2__Description__c,
            Apttus_Config2__Dimension1Id__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__AttributeId__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__ChildFilterName__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__ContextType__c,
            Apttus_Config2__Dimension1Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension1Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension1ValueType__c,
            Apttus_Config2__Dimension2Id__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__AttributeId__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__ChildFilterName__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__ContextType__c,
            Apttus_Config2__Dimension2Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension2Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension2ValueType__c,
            Apttus_Config2__Dimension3Id__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__AttributeId__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__ChildFilterName__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__ContextType__c,
            Apttus_Config2__Dimension3Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension3Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension3ValueType__c,
            Apttus_Config2__Dimension4Id__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__AttributeId__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__ChildFilterName__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__ContextType__c,
            Apttus_Config2__Dimension4Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension4Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension4ValueType__c,
            Apttus_Config2__Dimension5Id__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__AttributeId__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__ChildFilterName__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__ContextType__c,
            Apttus_Config2__Dimension5Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension5Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension5ValueType__c,
            Apttus_Config2__Dimension6Id__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__AttributeId__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__BusinessObject__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__ChildFilterName__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__ContextType__c,
            Apttus_Config2__Dimension6Id__r.Apttus_Config2__Datasource__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__RelationType__c,Apttus_Config2__Dimension6Id__r.Apttus_Config2__Type__c,Apttus_Config2__Dimension6ValueType__c,
            Apttus_Config2__ExpirationDate__c,Apttus_Config2__EffectiveDate__c,Apttus_Config2__ForEveryXCriteriaDimensionId__c,Apttus_Config2__ForEveryXCriteriaDimensionId__r.id,Apttus_Config2__ForEveryXCriteriaDimensionType__c,Apttus_Config2__ForEveryXCriteriaDimensionValue__c,Apttus_Config2__FutureBenefitValidityOffset__c,Apttus_Config2__FutureBenefitValidityType__c,
            Apttus_Config2__InitialRows__c,Apttus_Config2__MetricValueSource__c,Apttus_Config2__MilestoneCriteria__c,Apttus_Config2__MilestoneStatusCriteriaOper__c,Apttus_Config2__NumberOfEntries__c,Apttus_Config2__PriceListCriteria__c,Apttus_Config2__PriceListCriteriaOper__c,Apttus_Config2__TierMetricRollupDuration__c,
            Apttus_Config2__TierMetricType__c,Apttus_Config2__ProductFamilyCriteria__c,Apttus_Config2__ProductFamilyCriteriaOper__c,Apttus_Config2__ProductGroupCriteria__c,Apttus_Config2__ProductGroupCriteriaOper__c,Apttus_Config2__RegionCriteria__c,Apttus_Config2__RegionCriteriaOper__c,Apttus_Config2__Criteria__c,
            Apttus_Config2__RulesetId__r.Apttus_Config2__HasCriteria__c, Apttus_Config2__RulesetId__r.Apttus_Config2__Criteria__c, Apttus_Config2__RulesetId__r.Apttus_Config2__ExclusionCriteria__c,Apttus_Config2__RulesetId__r.Apttus_Config2__ChargeType__c,Apttus_Config2__RulesetId__r.Apttus_Config2__Description__c,
            Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c, Apttus_Config2__RulesetId__r.Apttus_Config2__EffectiveDate__c, Apttus_Config2__RulesetId__r.Apttus_Config2__ExpirationDate__c,Apttus_Config2__RulesetId__r.Apttus_Config2__ProductCategory__c,Apttus_Config2__RulesetId__r.Apttus_Config2__ProductFamily__c,
            Apttus_Config2__RulesetId__r.Apttus_Config2__AdjustmentAppliesTo__c,Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c,Apttus_Config2__RulesetId__r.Apttus_Config2__ApplicationMethod__c,Apttus_Config2__RulesetId__r.Apttus_Config2__Category__c,Apttus_Config2__RulesetId__r.Apttus_Config2__ProductGroupId__c,
            Apttus_Config2__RulesetId__r.Apttus_Config2__PriceListId__c,Apttus_Config2__RulesetId__r.Apttus_Config2__Sequence__c,Apttus_Config2__RulesetId__r.Apttus_Config2__StopProcessingMoreRules__c,
            Apttus_Config2__RulesetId__r.Apttus_Config2__Type__c,Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__c,Apttus_Config2__Active__c,Apttus_Config2__RulesetId__r.Apttus_Config2__PriceListId__r.Name,Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c,Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__AutoApply__c,
            Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Name
            from Apttus_Config2__PriceRule__c where (Apttus_Config2__RulesetId__c IN: priceRulSetMap.keyset() and Apttus_Config2__Active__c=true
            and Apttus_Config2__ExpirationDate__c >= TODAY and Apttus_Config2__EffectiveDate__c <= TODAY) ]){
    //and (Apttus_Config2__ProductGroupCriteria__c IN: prodGrpIds or Apttus_Config2__ProductCriteria__c like :prodIds or Apttus_Config2__ProductCriteria__c ='All' )]){ 
            if (priceRulMap.containsKey(pRule.Apttus_Config2__RulesetId__c)){
                priceRulMap.get(pRule.Apttus_Config2__RulesetId__c).add(pRule);
            } else{
                priceRulMap.put(pRule.Apttus_Config2__RulesetId__c, new  List <Apttus_Config2__PriceRule__c> { pRule });                                                  
            }
            prIds.add(pRule.Id);
            prList.add(pRule);
        }
        prc.prIds = prIds;
        prc.prList = prList;
        prc.prRulMap = priceRulMap;
        return prc;
    }

    private Static map<Id,list<Apttus_Config2__PriceRuleEntry__c>> segPriceRuleEntry(set<Id> prIds){
        Map<id,list<Apttus_Config2__PriceRuleEntry__c>> priceRulEntryMap = new Map<Id,list<Apttus_Config2__PriceRuleEntry__c>>();
        for(Apttus_Config2__PriceRuleEntry__c prEntry: [Select id,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentValueType__c,Apttus_Config2__AdjustmentReason__c,Apttus_Config2__AdjustmentValueSource__c,Apttus_Config2__BandSize__c,Apttus_Config2__ChargeTypes__c,Apttus_Config2__Condition__c,
                                                                    Apttus_Config2__Dimension1ListValue__c,Apttus_Config2__Dimension1Value__c,Apttus_Config2__Dimension2ListValue__c,Apttus_Config2__Dimension2Value__c,Apttus_Config2__Dimension3ListValue__c,Apttus_Config2__Dimension3Value__c,Apttus_Config2__Dimension4ListValue__c,Apttus_Config2__Dimension4Value__c,
                                                                    Apttus_Config2__Dimension5ListValue__c,Apttus_Config2__Dimension5Value__c,Apttus_Config2__Dimension6ListValue__c,Apttus_Config2__Dimension6Value__c,Apttus_Config2__EndFactor__c,Apttus_Config2__InclusionMethod__c,Apttus_Config2__LoyaltyLevel__c,Apttus_Config2__MatchProductGroupId__c,
                                                                    Apttus_Config2__MatchInAsset__c,Apttus_Config2__MaxProducts__c,Apttus_Config2__MaxQuantity__c,Apttus_Config2__MinProducts__c,Apttus_Config2__MinQuantity__c,Apttus_Config2__PriceOverride__c,Apttus_Config2__Sequence__c,Apttus_Config2__PriceRuleId__c,Apttus_Config2__ProductCategory__c,
                                                                    Apttus_Config2__ProductFamilies__c,Apttus_Config2__ProductFamily__c,Apttus_Config2__ProductGroupId__c,Apttus_Config2__ProductGroups__c,Apttus_Config2__Products__c,Apttus_Config2__Quantity__c,Apttus_Config2__StartFactor__c,Apttus_Config2__Term__c,Apttus_Config2__TermPeriodStart__c
                                                                    from Apttus_Config2__PriceRuleEntry__c where Apttus_Config2__PriceRuleId__c IN: prIds]){
            if (priceRulEntryMap.containsKey(prEntry.Apttus_Config2__PriceRuleId__c)){
            priceRulEntryMap.get(prEntry.Apttus_Config2__PriceRuleId__c).add(prEntry);
            } else{
                priceRulEntryMap.put(prEntry.Apttus_Config2__PriceRuleId__c, new  List <Apttus_Config2__PriceRuleEntry__c> { prEntry });                                                  
            }
                                                                            
        }
        return priceRulEntryMap;
    }

    private Static void doPriceRuleEntry(JSONGenerator gen,Apttus_Config2__PriceRule__c pr,Map<Id,List<Apttus_Config2__PriceRuleEntry__c>> priceRulEntryMap){
        gen.writeFieldName('RuleEntries');
        gen.writeStartArray();
        if(priceRulEntryMap.get(PR.Id) != Null && priceRulEntryMap.get(PR.Id).size()>0){
            for(Apttus_Config2__PriceRuleEntry__c pre:priceRulEntryMap.get(PR.Id)){
                gen.writeStartObject();
                gen.writeStringField('Id',pre.Id);
                gen.writeNumberField('AdjustmentAmount', PRE.Apttus_Config2__adjustmentAmount__c);
                gen.writeStringField('AdjustmentReason', String.isNotBlank(PRE.Apttus_Config2__AdjustmentReason__c)?PRE.Apttus_Config2__AdjustmentReason__c:TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('AdjustmentType', String.isNotBlank(PRE.Apttus_Config2__adjustmentType__c)?PRE.Apttus_Config2__adjustmentType__c:TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('AdjustmentValueSource', String.isNotBlank(PRE.Apttus_Config2__AdjustmentValueSource__c)?PRE.Apttus_Config2__AdjustmentValueSource__c:TRStoreConstants.NOT_AVAILABLE);
                gen.writeStringField('AdjustmentValueType', String.isNotBlank(PRE.Apttus_Config2__adjustmentValueType__c)?PRE.Apttus_Config2__adjustmentValueType__c:TRStoreConstants.NOT_AVAILABLE);
                
                TRStore_PromotionService.doPriceRuleEntry1(gen,pre);
                TRStore_PromotionService.doPriceRuleEntry2(gen,pre);
                TRStore_PromotionService.doPriceRuleEntry3(gen,pre);
                TRStore_PromotionService.doPriceRuleEntry4(gen,pre);
                TRStore_PromotionService.doPriceRuleEntry5(gen,pre);
                TRStore_PromotionService.doPriceRuleEntry6(gen,pre);
            }
        }
    }

    private Static void doPriceRuleEntry1(JSONGenerator gen,Apttus_Config2__PriceRuleEntry__c pre){
        gen.writeNumberField('BandSize', (PRE.Apttus_Config2__BandSize__c != null)?PRE.Apttus_Config2__BandSize__c:0);
        gen.writeStringField('ChargeTypes', String.isNotBlank(PRE.Apttus_Config2__ChargeTypes__c)?PRE.Apttus_Config2__ChargeTypes__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Condition', String.isNotBlank(PRE.Apttus_Config2__Condition__c)?PRE.Apttus_Config2__Condition__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension1ListValue', String.isNotBlank(PRE.Apttus_Config2__Dimension1ListValue__c)?PRE.Apttus_Config2__Dimension1ListValue__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension1Value', String.isNotBlank(PRE.Apttus_Config2__Dimension1Value__c)?PRE.Apttus_Config2__Dimension1Value__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension2ListValue', String.isNotBlank(PRE.Apttus_Config2__Dimension2ListValue__c)?PRE.Apttus_Config2__Dimension2ListValue__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension2Value', String.isNotBlank(PRE.Apttus_Config2__Dimension2Value__c)?PRE.Apttus_Config2__Dimension2Value__c:TRStoreConstants.NOT_AVAILABLE);
                
    }

    private Static void doPriceRuleEntry2(JSONGenerator gen,Apttus_Config2__PriceRuleEntry__c pre){
        gen.writeStringField('Dimension3ListValue', String.isNotBlank(PRE.Apttus_Config2__Dimension3ListValue__c)?PRE.Apttus_Config2__Dimension3ListValue__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension3Value', String.isNotBlank(PRE.Apttus_Config2__Dimension3Value__c)?PRE.Apttus_Config2__Dimension3Value__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension4ListValue', String.isNotBlank(PRE.Apttus_Config2__Dimension4ListValue__c)?PRE.Apttus_Config2__Dimension4ListValue__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension4Value', String.isNotBlank(PRE.Apttus_Config2__Dimension4Value__c)?PRE.Apttus_Config2__Dimension4Value__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension5ListValue', String.isNotBlank(PRE.Apttus_Config2__Dimension5ListValue__c)?PRE.Apttus_Config2__Dimension5ListValue__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension5Value', String.isNotBlank(PRE.Apttus_Config2__Dimension5Value__c)?PRE.Apttus_Config2__Dimension5Value__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Dimension6ListValue', String.isNotBlank(PRE.Apttus_Config2__Dimension6ListValue__c)?PRE.Apttus_Config2__Dimension6ListValue__c:TRStoreConstants.NOT_AVAILABLE);
                
    }

    private Static void doPriceRuleEntry3(JSONGenerator gen,Apttus_Config2__PriceRuleEntry__c pre){
        gen.writeStringField('Dimension6Value', String.isNotBlank(PRE.Apttus_Config2__Dimension6Value__c)?PRE.Apttus_Config2__Dimension6Value__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('EndFactor', (PRE.Apttus_Config2__EndFactor__c != null)?PRE.Apttus_Config2__EndFactor__c:0);
        gen.writeStringField('InclusionMethod', String.isNotBlank(PRE.Apttus_Config2__InclusionMethod__c)?PRE.Apttus_Config2__InclusionMethod__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('LoyaltyLevel', String.isNotBlank(PRE.Apttus_Config2__LoyaltyLevel__c)?PRE.Apttus_Config2__LoyaltyLevel__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeBooleanField('MatchInAsset', PRE.Apttus_Config2__matchInAsset__c);
        gen.writeStringField('MatchProductGroupId', String.isNotBlank(PRE.Apttus_Config2__MatchProductGroupId__c)?String.valueof(PRE.Apttus_Config2__MatchProductGroupId__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('MaxProducts', (PRE.Apttus_Config2__MaxProducts__c != null)?PRE.Apttus_Config2__MaxProducts__c:0);
        
    }

    private Static void doPriceRuleEntry4(JSONGenerator gen,Apttus_Config2__PriceRuleEntry__c pre){
        gen.writeNumberField('MaxQuantity', (PRE.Apttus_Config2__MaxQuantity__c != null)?PRE.Apttus_Config2__MaxQuantity__c:0);
        gen.writeNumberField('MinProducts', (PRE.Apttus_Config2__MinProducts__c != null)?PRE.Apttus_Config2__MinProducts__c:0);
        gen.writeNumberField('MinQuantity', (PRE.Apttus_Config2__MinQuantity__c != null)?PRE.Apttus_Config2__MinQuantity__c:0);
        gen.writeNumberField('PriceOverride', (PRE.Apttus_Config2__PriceOverride__c != null)?PRE.Apttus_Config2__PriceOverride__c:0);
        gen.writeStringField('PriceRuleId', String.isNotBlank(PRE.Apttus_Config2__PriceRuleId__c)?PRE.Apttus_Config2__PriceRuleId__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductCategory', String.isNotBlank(PRE.Apttus_Config2__ProductCategory__c)?PRE.Apttus_Config2__ProductCategory__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductFamilies', String.isNotBlank(PRE.Apttus_Config2__ProductFamilies__c)?PRE.Apttus_Config2__ProductFamilies__c:TRStoreConstants.NOT_AVAILABLE);
                
    }

    private Static void doPriceRuleEntry5(JSONGenerator gen,Apttus_Config2__PriceRuleEntry__c pre){
        gen.writeStringField('ProductFamily', String.isNotBlank(PRE.Apttus_Config2__ProductFamily__c)?PRE.Apttus_Config2__ProductFamily__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductGroupId', String.isNotBlank(PRE.Apttus_Config2__ProductGroupId__c)?String.valueof(PRE.Apttus_Config2__ProductGroupId__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductGroups', String.isNotBlank(PRE.Apttus_Config2__ProductGroups__c)?PRE.Apttus_Config2__ProductGroups__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Products', String.isNotBlank(PRE.Apttus_Config2__Products__c)?PRE.Apttus_Config2__Products__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('Quantity', (PRE.Apttus_Config2__Quantity__c != null)?PRE.Apttus_Config2__Quantity__c:0);
        
    }

    private Static void doPriceRuleEntry6(JSONGenerator gen,Apttus_Config2__PriceRuleEntry__c pre){
        gen.writeStringField('Sequence', (PRE.Apttus_Config2__Sequence__c!=null)?String.valueOf(PRE.Apttus_Config2__Sequence__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('StartFactor', (PRE.Apttus_Config2__StartFactor__c != null)?PRE.Apttus_Config2__StartFactor__c:0);
        gen.writeNumberField('Term', (PRE.Apttus_Config2__Term__c != null)?PRE.Apttus_Config2__Term__c:0);
        gen.writeStringField('TermPeriodStart', String.isNotBlank(PRE.Apttus_Config2__TermPeriodStart__c)?PRE.Apttus_Config2__TermPeriodStart__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeEndObject();
    }

    

    private Static void promoJson(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStartObject();
        gen.writeFieldName('status');
        gen.writeStartObject();
        gen.writeStringField('statusDesc',TRStoreConstants.DETAILS_FOUND);
        gen.writeStringField('statusCode',TRStoreConstants.SUCCESS_CODE);
        gen.writeStringField('status',TRStoreConstants.SUCCESS_STATUS);
        gen.writeEndObject();
        
    }

    private Static void promoJson1(JSONGenerator gen,Apttus_Config2__PriceRule__c pr,boolean autoApply){
        if(!autoApply && string.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c)){
            promos.add(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c);
        }
        
        //gen.writeStringField('promoCode',String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Id', pr.Id);
        gen.writeStringField('IncentiveCode',pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__IncentiveCode__c);
        gen.writeBooleanField('Active', pr.Apttus_Config2__Active__c);
        gen.writeStringField('AdjustmentAppliesTo', (String.isNotBlank(pr.Apttus_Config2__AdjustmentAppliesTo__c))?pr.Apttus_Config2__AdjustmentAppliesTo__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('AdjustmentChargeType', (String.isNotBlank(pr.Apttus_Config2__AdjustmentChargeType__c))?pr.Apttus_Config2__AdjustmentChargeType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('AllowableAction', (String.isNotBlank(pr.Apttus_Config2__AllowableAction__c))?pr.Apttus_Config2__AllowableAction__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeBooleanField('AllowRemovalOfAdjustment', pr.Apttus_Config2__AllowRemovalOfAdjustment__c);
        gen.writeBooleanField('AutoApply',pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Apttus_Config2__AutoApply__c);
        gen.writeStringField('Name',pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.Name);
    }

    private Static void promoJson2(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('ApplicationMethod', (String.isNotBlank(pr.Apttus_Config2__ApplicationMethod__c))?pr.Apttus_Config2__ApplicationMethod__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('BeneficiaryId', String.isNotBlank(pr.Apttus_Config2__BeneficiaryId__c)?pr.Apttus_Config2__BeneficiaryId__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('BeneficiaryType', String.isNotBlank(pr.Apttus_Config2__BeneficiaryType__c)?pr.Apttus_Config2__BeneficiaryType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('BenefitType', (String.isNotBlank(pr.Apttus_Config2__BenefitType__c))?pr.Apttus_Config2__BenefitType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ChargeTypeCriteria', (String.isNotBlank(pr.Apttus_Config2__ChargeTypeCriteria__c))?pr.Apttus_Config2__ChargeTypeCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        
    }

    private Static void promoJson3(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('ChargeTypeCriteriaOper', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__ChargeTypeCriteriaOper__c,TRStoreConstants.NOT_AVAILABLE));
        gen.writeStringField('CountryCriteria', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__CountryCriteria__c,TRStoreConstants.NOT_AVAILABLE));
        gen.writeStringField('CountryCriteriaOper', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__CountryCriteriaOper__c,TRStoreConstants.NOT_AVAILABLE));
        gen.writeStringField('CustomPricePointSource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__CustomPricePointSource__c,TRStoreConstants.NOT_AVAILABLE));
        
        gen.writeStringField('Description', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Description__c,TRStoreConstants.NOT_AVAILABLE));
        if(String.isNotBlank(pr.Apttus_Config2__Dimension1Id__c)){

        gen.writeFieldName('Dimension1');
        gen.writeStartObject();

        System.debug(loggingLevel.INFO, 'Dim1......');
            if(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__ContextType__c.equals('Product Attribute') && pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__AttributeId__c != Null){
                getAttributeDetails(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__AttributeId__c, gen);
        }
        //gen.writeStringField('Attribute', (String.isNotBlank(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__AttributeId__c))?String.valueof(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__AttributeId__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('BusinessObject', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__BusinessObject__c, TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ChildFilterName', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__ChildFilterName__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ContextType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__ContextType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Datasource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__Datasource__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('IncentiveId', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__IncentiveId__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('RelationType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__RelationType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Type', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension1Id__r.Apttus_Config2__Type__c,TRStoreConstants.NOT_AVAILABLE));
            //gen.writeStringField('Dimension1ValueType', (String.isNotBlank(pr.Apttus_Config2__Dimension1ValueType__c))?pr.Apttus_Config2__Dimension1ValueType__c:TRStoreConstants.NOT_AVAILABLE);

            gen.writeEndObject();
            gen.writeStringField('Dimension1ValueType', (String.isNotBlank(pr.Apttus_Config2__Dimension1ValueType__c))?pr.Apttus_Config2__Dimension1ValueType__c:TRStoreConstants.NOT_AVAILABLE);
        }
    }

    private Static void promoJson4(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        if(String.isNotBlank(pr.Apttus_Config2__Dimension2Id__c)){
            gen.writeFieldName('Dimension2');
            gen.writeStartObject();
            if(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__ContextType__c.equals('Product Attribute') && pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__AttributeId__c!=null){
                    getAttributeDetails(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__AttributeId__c, gen);
            }                           //gen.writeStringField('Attribute', (String.isNotBlank(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__AttributeId__c))?String.valueof(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__AttributeId__c):TRStoreConstants.NOT_AVAILABLE);
            gen.writeStringField('BusinessObject', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__BusinessObject__c, TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ChildFilterName', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__ChildFilterName__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ContextType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__ContextType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Datasource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__Datasource__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('IncentiveId', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__IncentiveId__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('RelationType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__RelationType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Type', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension2Id__r.Apttus_Config2__Type__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeEndObject();
            gen.writeStringField('Dimension2ValueType', (String.isNotBlank(pr.Apttus_Config2__Dimension2ValueType__c))?pr.Apttus_Config2__Dimension2ValueType__c:TRStoreConstants.NOT_AVAILABLE);
            }
    }

    private Static void promoJson5(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        if(String.isNotBlank(pr.Apttus_Config2__Dimension3Id__c)){
            gen.writeFieldName('Dimension3');
            gen.writeStartObject();
            if(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__ContextType__c.equals('Product Attribute') && pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__AttributeId__c!=null){
                    getAttributeDetails(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__AttributeId__c, gen);
            }
            gen.writeStringField('BusinessObject', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__BusinessObject__c, TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ChildFilterName', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__ChildFilterName__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ContextType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__ContextType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Datasource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__Datasource__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('IncentiveId', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__IncentiveId__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('RelationType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__RelationType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Type', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension3Id__r.Apttus_Config2__Type__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeEndObject();
            gen.writeStringField('Dimension3ValueType', (String.isNotBlank(pr.Apttus_Config2__Dimension3ValueType__c))?pr.Apttus_Config2__Dimension3ValueType__c:TRStoreConstants.NOT_AVAILABLE);
            }
    }

    private Static void promoJson6(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        if(String.isNotBlank(pr.Apttus_Config2__Dimension4Id__c)){
            gen.writeFieldName('Dimension4');
            gen.writeStartObject();
            if(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__ContextType__c.equals('Product Attribute') && pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__AttributeId__c!=null){
                    getAttributeDetails(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__AttributeId__c, gen);
            }                          
            gen.writeStringField('BusinessObject', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__BusinessObject__c, TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ChildFilterName', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__ChildFilterName__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ContextType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__ContextType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Datasource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__Datasource__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('IncentiveId', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__IncentiveId__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('RelationType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__RelationType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Type', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension4Id__r.Apttus_Config2__Type__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeEndObject();
            gen.writeStringField('Dimension4ValueType', (String.isNotBlank(pr.Apttus_Config2__Dimension4ValueType__c))?pr.Apttus_Config2__Dimension4ValueType__c:TRStoreConstants.NOT_AVAILABLE);
            }
    }


    private Static void promoJson7(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        
        if(String.isNotBlank(pr.Apttus_Config2__Dimension5Id__c)){
            gen.writeFieldName('Dimension5');
            gen.writeStartObject();
            if(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__ContextType__c.equals('Product Attribute') && pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__AttributeId__c!=null){
                    getAttributeDetails(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__AttributeId__c, gen);
            }
            gen.writeStringField('BusinessObject', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__BusinessObject__c, TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ChildFilterName', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__ChildFilterName__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ContextType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__ContextType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Datasource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__Datasource__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('IncentiveId', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__IncentiveId__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('RelationType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__RelationType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Type', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5Id__r.Apttus_Config2__Type__c,TRStoreConstants.NOT_AVAILABLE));
            
            gen.writeEndObject();
            gen.writeStringField('Dimension5ValueType', (String.isNotBlank(pr.Apttus_Config2__Dimension5ValueType__c))?pr.Apttus_Config2__Dimension5ValueType__c:TRStoreConstants.NOT_AVAILABLE);
            }
    }

    private Static void promoJson8(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        if(String.isNotBlank(pr.Apttus_Config2__Dimension6Id__c)){
            gen.writeFieldName('Dimension6');
            gen.writeStartObject();
            if(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__ContextType__c.equals('Product Attribute') && pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__AttributeId__c!=null){
                    getAttributeDetails(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__AttributeId__c, gen);
            }
            
            gen.writeStringField('BusinessObject', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__BusinessObject__c, TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ChildFilterName', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__ChildFilterName__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('ContextType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__ContextType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Datasource', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__Datasource__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('IncentiveId', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__IncentiveId__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('RelationType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__RelationType__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeStringField('Type', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension6Id__r.Apttus_Config2__Type__c,TRStoreConstants.NOT_AVAILABLE));
            gen.writeEndObject();
            gen.writeStringField('Dimension6ValueType', TRStore_PromotionService.handleEmptyString(pr.Apttus_Config2__Dimension5ValueType__c,TRStoreConstants.NOT_AVAILABLE));
            }
    }

    private static string handleEmptyString(String source, String target){
        String returnString = source;
        if(String.isBlank(returnString) && String.isBlank(target)){
            returnString = TRStoreConstants.NOT_AVAILABLE;
        }else if(String.isBlank(returnString)){
            returnString = target;
        }
        return returnString;
    }

    private static void callProductInfo1(JSONGenerator gen,Apttus_Config2__PriceRule__c pr) {
        gen.writeStringField('EffectiveDate', ((pr.Apttus_Config2__EffectiveDate__c) != null)?String.valueof(pr.Apttus_Config2__EffectiveDate__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ExpirationDate', ((pr.Apttus_Config2__ExpirationDate__c) != null)?String.valueof(pr.Apttus_Config2__ExpirationDate__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ForEveryXCriteriaDimensionId', String.isNotBlank(pr.Apttus_Config2__ForEveryXCriteriaDimensionId__c)?String.valueof(pr.Apttus_Config2__ForEveryXCriteriaDimensionId__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ForEveryXCriteriaDimensionType', (String.isNotBlank(pr.Apttus_Config2__ForEveryXCriteriaDimensionType__c))?pr.Apttus_Config2__ForEveryXCriteriaDimensionType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('ForEveryXCriteriaDimensionValue', (pr.Apttus_Config2__ForEveryXCriteriaDimensionValue__c != null)?pr.Apttus_Config2__ForEveryXCriteriaDimensionValue__c:0);
        gen.writeNumberField('FutureBenefitValidityOffset', (pr.Apttus_Config2__FutureBenefitValidityOffset__c != null)?pr.Apttus_Config2__FutureBenefitValidityOffset__c:0);
        
    }
    private static void callProductInfo2(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('FutureBenefitValidityType', (String.isNotBlank(pr.Apttus_Config2__FutureBenefitValidityType__c))?pr.Apttus_Config2__FutureBenefitValidityType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('InitialRows', (pr.Apttus_Config2__InitialRows__c != null)?String.valueof(pr.Apttus_Config2__InitialRows__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('MetricValueSource', (String.isNotBlank(pr.Apttus_Config2__MetricValueSource__c))?pr.Apttus_Config2__MetricValueSource__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('MilestoneCriteria', (String.isNotBlank(pr.Apttus_Config2__MilestoneCriteria__c))?pr.Apttus_Config2__MilestoneCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('MilestoneStatusCriteriaOper', (String.isNotBlank(pr.Apttus_Config2__MilestoneStatusCriteriaOper__c))?pr.Apttus_Config2__MilestoneStatusCriteriaOper__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('NumberOfEntries', pr.Apttus_Config2__NumberOfEntries__c); 
        
    }
    private static void callProductInfo3(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('PriceListCriteria', (String.isNotBlank(pr.Apttus_Config2__PriceListCriteria__c))?pr.Apttus_Config2__PriceListCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('PriceListCriteriaOper', (String.isNotBlank(pr.Apttus_Config2__PriceListCriteriaOper__c))?pr.Apttus_Config2__PriceListCriteriaOper__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductCriteria', (String.isNotBlank(pr.Apttus_Config2__ProductCriteria__c))?pr.Apttus_Config2__ProductCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductCriteriaOper', (String.isNotBlank(pr.Apttus_Config2__ProductCriteriaOper__c))?pr.Apttus_Config2__ProductCriteriaOper__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductFamilyCriteria', (String.isNotBlank(pr.Apttus_Config2__ProductFamilyCriteria__c))?pr.Apttus_Config2__ProductFamilyCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        
    }

    private static void callProductInfo4(JSONGenerator gen,Apttus_Config2__PriceRule__c pr) {
        gen.writeStringField('ProductFamilyCriteriaOper', (String.isNotBlank(pr.Apttus_Config2__ProductFamilyCriteriaOper__c))?pr.Apttus_Config2__ProductFamilyCriteriaOper__c:TRStoreConstants.NOT_AVAILABLE); 
        gen.writeStringField('ProductGroupCriteria', (String.isNotBlank(pr.Apttus_Config2__ProductGroupCriteria__c))?pr.Apttus_Config2__ProductGroupCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductGroupCriteriaOper', (String.isNotBlank(pr.Apttus_Config2__ProductGroupCriteriaOper__c))?pr.Apttus_Config2__ProductGroupCriteriaOper__c:TRStoreConstants.NOT_AVAILABLE); 
        gen.writeStringField('RegionCriteria', (String.isNotBlank(pr.Apttus_Config2__RegionCriteria__c))?pr.Apttus_Config2__RegionCriteria__c:TRStoreConstants.NOT_AVAILABLE); 
        
        gen.writeStringField('RegionCriteriaOper', (String.isNotBlank(pr.Apttus_Config2__RegionCriteriaOper__c))?pr.Apttus_Config2__RegionCriteriaOper__c:TRStoreConstants.NOT_AVAILABLE); 
        gen.writeStringField('Criteria', (String.isNotBlank(pr.Apttus_Config2__Criteria__c))?pr.Apttus_Config2__Criteria__c:TRStoreConstants.NOT_AVAILABLE); 
        
    
    }
    private static void callProductInfo5(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeFieldName('Ruleset');
        gen.writeStartObject();
        //gen.writeStringField('id', pr.Apttus_Config2__RulesetId__r.Id);
        gen.writeBooleanField('Active', pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Active__c);
        gen.writeStringField('AdjustmentAppliesTo', (String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__AdjustmentAppliesTo__c))?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__AdjustmentAppliesTo__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('UseType', (String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c))?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__UseType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ApplicationMethod', (String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ApplicationMethod__c))?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ApplicationMethod__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Category', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Category__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Category__c:TRStoreConstants.NOT_AVAILABLE);
        
    }
    private static void callProductInfo6(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('ChargeType', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ChargeType__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ChargeType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Description', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Description__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Description__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('EffectiveDate', ((pr.Apttus_Config2__RulesetId__r.Apttus_Config2__EffectiveDate__c) != null)?String.valueof(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__EffectiveDate__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ExpirationDate', ((pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ExpirationDate__c) != null)?String.valueof(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ExpirationDate__c):TRStoreConstants.NOT_AVAILABLE);      
        gen.writeBooleanField('HasCriteria', pr.Apttus_Config2__RulesetId__r.Apttus_Config2__HasCriteria__c);
        gen.writeStringField('IncentiveId', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__c:TRStoreConstants.NOT_AVAILABLE);
        
    }

    private static void callProductInfo7(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        if(String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__PriceListId__c)){
            gen.writeStringField('PriceListId',pr.Apttus_Config2__RulesetId__r.Apttus_Config2__PriceListId__c);
            //gen.writeStringField('priceListName',pr.Apttus_Config2__RulesetId__r.Apttus_Config2__PriceListId__r.Name);
        }else{
            gen.writeNullField('PriceListId');
        }
        gen.writeStringField('ProductCategory', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ProductCategory__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ProductCategory__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductFamily', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ProductFamily__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ProductFamily__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('ProductGroupId', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ProductGroupId__c)?String.valueof(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ProductGroupId__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Criteria', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Criteria__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Criteria__c:TRStoreConstants.NOT_AVAILABLE);
        
    }
    private static void callProductInfo8(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('ExclusionCriteria', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ExclusionCriteria__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__ExclusionCriteria__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('Sequence', (pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Sequence__c!=null)?String.valueOf(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Sequence__c):TRStoreConstants.NOT_AVAILABLE);
        gen.writeBooleanField('StopProcessingMoreRules', pr.Apttus_Config2__RulesetId__r.Apttus_Config2__StopProcessingMoreRules__c);
        gen.writeStringField('Type', String.isNotBlank(pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Type__c)?pr.Apttus_Config2__RulesetId__r.Apttus_Config2__Type__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeEndObject();
        
    }
    private static void callProductInfo9(JSONGenerator gen,Apttus_Config2__PriceRule__c pr){
        gen.writeStringField('RuleSubType', (String.isNotBlank(pr.Apttus_Config2__RuleSubType__c))?pr.Apttus_Config2__RuleSubType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeStringField('RuleType', (String.isNotBlank(pr.Apttus_Config2__RuleType__c))?pr.Apttus_Config2__RuleType__c:TRStoreConstants.NOT_AVAILABLE);
        gen.writeNumberField('Sequence', pr.Apttus_Config2__Sequence__c); 
        gen.writeBooleanField('StopProcessingMoreRules', PR.Apttus_Config2__StopProcessingMoreRules__c);
        gen.writeStringField('TierMetricRollupDuration', (String.isNotBlank(PR.Apttus_Config2__TierMetricRollupDuration__c))?PR.Apttus_Config2__TierMetricRollupDuration__c:TRStoreConstants.NOT_AVAILABLE); 
        gen.writeStringField('TierMetricType', (String.isNotBlank(PR.Apttus_Config2__TierMetricType__c))?PR.Apttus_Config2__TierMetricType__c:TRStoreConstants.NOT_AVAILABLE);
    
    }

}