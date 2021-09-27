/* Class: TRStore_PromotionServiceTest
* Purpose: Coverage for  Class TRStore_PromotionService (Rest API Service to bring the JSON formatted Promotions related Apttus objects for products)
* Created: 03/03/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-03-03   Avudaiappan A     DUE-622   Test Coverage Started
* 2020-07-10   Avudaiappan A     DUE-3883  Store valid promocode in server side cart
* =============================================================================
*/
@isTest(seeAllData = False)
public class TRStore_PromotionServiceTest {
/** 
 * @description : Test Class for TRStore_PromotionService ckass
 */ 
    public static testMethod void testData(){
        
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        system.assertEquals((plSO!=null),true,'Pass');
        
        product2 pd1 = new product2();
         pd1.Name = 'Test Product';
         pd1.ProductCode = '98765';
         pd1.Description = 'Test Desc';
         pd1.Service_Number__c = '87654';
         pd1.Apttus_Filter_Brand__c = 'Test';
         pd1.Apttus_Filter_Jurisdiction__c = 'Colorado';
         pd1.LCRM_Sub_Bu__c = 'USL';
         pd1.Format__c= 'Format';
         pd1.IsActive = true;
         pd1.Apttus_Config2__HasOptions__c = true;
         pd1.Apttus_Config2__HasAttributes__c = true;
         pd1.Apttus_Config2__HasDefaults__c = false;
         pd1.CPD_Sellable_Description__c ='Display and Sell';
        insert pd1;
        
        Apttus_Config2__Incentive__c inc = new Apttus_Config2__Incentive__c(Name='Test Incentive', Apttus_Config2__Active__c=true, Apttus_Config2__AutoApply__c=True, Apttus_Config2__Sequence__c=1,
                                                                Apttus_Config2__IncentiveCode__c ='TRTEST01',Apttus_Config2__EffectiveDate__c=Date.today()-1, Apttus_Config2__ExpirationDate__c=Date.today()+1);
         Database.insert(inc,true);
        
        Apttus_Config2__PriceRuleset__c prs = new Apttus_Config2__PriceRuleset__c(Apttus_Config2__Active__c=true,Apttus_Config2__Category__c='All',Apttus_Config2__EffectiveDate__c=System.now()-1,Apttus_Config2__ExpirationDate__c=system.now()+1 ,
                                                                                 Apttus_Config2__IncentiveId__c = Inc.id, Apttus_Config2__PriceListId__c=plSO.id,Apttus_Config2__Sequence__c=1,
                                                                                 Apttus_Config2__StopProcessingMoreRules__c =false, Apttus_Config2__UseType__c ='Line Item',Apttus_Config2__Type__c='Incentive',
                                                                                 Apttus_Config2__Criteria__c ='TRStore_Site__c:Canada', Name = 'TestRuleSet');
        Database.insert (prs,true);
        
        Apttus_Config2__ProductAttributeGroup__c pag = new Apttus_Config2__ProductAttributeGroup__c(Apttus_Config2__BusinessObject__c = 'Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Description__c = 'SCS Print');
        Database.insert(pag, true);
        
        Apttus_Config2__ProductAttribute__c pa = new Apttus_Config2__ProductAttribute__c(Apttus_Config2__AttributeGroupId__c = PAG.id,Apttus_Config2__Field__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__DisplayType__c ='Picklist',Apttus_Config2__IsPrimary__c = true,
                                                                                        Apttus_Config2__IsHidden__c = false,Apttus_Config2__IsReadOnly__c = false,Apttus_Config2__Sequence__c=1);
        Database.insert (pa,true);
        
        Apttus_Config2__PriceDimension__c pd = new Apttus_Config2__PriceDimension__c(Apttus_Config2__AttributeId__c=PA.id,Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        Database.insert(pd,true);
        
        Apttus_Config2__PriceRule__c pr = new Apttus_Config2__PriceRule__c(Apttus_Config2__Active__c=True, Apttus_Config2__BeneficiaryType__c='Account',Apttus_Config2__BenefitType__c='Price Only',
                                                                          Apttus_Config2__Dimension1Id__c=PD.Id,Apttus_Config2__Dimension1ValueType__c='Discrete',Apttus_Config2__Dimension2Id__c=PD.id,Apttus_Config2__Dimension3Id__c=PD.id,
                                                                          Apttus_Config2__Dimension4Id__c=PD.id,Apttus_Config2__Dimension5Id__c=PD.id,Apttus_Config2__Dimension6Id__c=PD.id,Apttus_Config2__EffectiveDate__c=Date.today()-1, Apttus_Config2__ExpirationDate__c=Date.today()+1,
                                                                          Apttus_Config2__InitialRows__c = 5,Apttus_Config2__ProductCriteriaOper__c = 'in',Apttus_Config2__ProductCriteria__c=pd1.id,
                                                                          Apttus_Config2__RulesetId__c = PRS.id,Apttus_Config2__Sequence__c=1);
        Database.insert(pr,true);
        
        Apttus_Config2__PriceRuleEntry__c pre = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__AdjustmentAmount__c=10,Apttus_Config2__PriceRuleId__c=PR.Id,
                                                                                     Apttus_Config2__Products__c=pd1.Id,Apttus_Config2__Quantity__c=5,Apttus_Config2__Sequence__c=1);
        Database.insert(pre,true);
        Apttus_Config2__PriceRuleEntry__c pre1 = new Apttus_Config2__PriceRuleEntry__c(Apttus_Config2__AdjustmentAmount__c=20,Apttus_Config2__PriceRuleId__c=PR.Id,
                                                                                     Apttus_Config2__Products__c=pd1.Id,Apttus_Config2__Quantity__c=10,Apttus_Config2__Sequence__c=2);
        Database.insert(pre1,true);
        
        Account acc =new account();
        acc.Name='Test';
        insert acc;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = plSO.Id;
        propObj.Apttus_Proposal__Account__c = acc.id;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfigObj.Apttus_Config2__AccountId__c = acc.Id;
        insert prodConfigObj;
        
        /*LIST<Auto_Promo_Codes_Json__c> autoCodeList = new LIST<Auto_Promo_Codes_Json__c>(); 
        Auto_Promo_Codes_Json__c json = new Auto_Promo_Codes_Json__c();
        json.Active__c = true;
        json.Auto_Promo_json__c = '';
        json.TRStore_Site__c = 'Canada';
        autoCodeList.add(json);
        insert autoCodeList;*/
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>();
        Static_Values__c stLse = new Static_Values__c(name='LeadSupportEmail', value__c= 'kanishk.singhvi@thomsonreuters.com');
        staticCSList.add(stLse);
        insert staticCSList;
        
         RestRequest req = new RestRequest();
         req.requestURI = '/services/apexrest/GetPromotionDetails';  //Request URL
         req.httpMethod = 'POST';//HTTP Request Type
         req.addHeader('Content-Type', 'application/json');
         RestContext.request = req;
         RestResponse res = new RestResponse();
         RestContext.response = res;
         TRStore_PromotionService.TRStore_PromotionRequestClass ps = new TRStore_PromotionService.TRStore_PromotionRequestClass();
         List<String> promos = new List<string>{'TRTEST01'};
         ps.promoList = promos;
         ps.autoApply = false;
         ps.site = 'Canada';
         ps.cartId = prodConfigObj.Id;
         TRStore_PromotionService.getPromotionData(ps);
         promos.clear(); 
         TRStore_PromotionService.getPromotionData(ps);
         promos.add('TRTEST02');
         TRStore_PromotionService.getPromotionData(ps);
         
         TRStore_PromotionService.TRStore_PromotionRequestClass ps1 = new TRStore_PromotionService.TRStore_PromotionRequestClass();
         promos.clear();
         ps1.promoList = promos;
         ps1.autoApply = true;
         ps1.site = 'Canada';
         ps1.cartId = prodConfigObj.Id;
         TRStore_PromotionService.getPromotionData(ps1);

         TRStore_PromotionService.TRStore_PromotionRequestClass ps2 = new TRStore_PromotionService.TRStore_PromotionRequestClass();
         promos.clear();
         ps2.promoList = promos;
         ps2.autoApply = true;
         ps2.site = 'Canada';
         ps2.cartId = '';
         TRStore_PromotionService.getPromotionData(ps2);
        
            
         
    }
}