/* Class: DCPNewSalesPlanUtility
* Purpose: A utility class to gather plan infomration from a store
* Created: 6/18/2021
**/
/**
* @description A utility class to gather plan infomration from a store
*/
public without sharing class DCPNewSalesPlanUtility {
    private DCPNewSalesDataUtil.ContractTermPlanWrapper contractTerm;
    class TermException extends Exception {}
    /**
* @description class constructor to initialze the properties
*/
    public DCPNewSalesPlanUtility(){
        this.contractTerm = new DCPNewSalesDataUtil.ContractTermPlanWrapper();
    }   
    
    /********************************************************************************************************
    *  @description  getContractTerms - get contract terms based on store data
    *  @param storeData - Wrapper for store data
    *********************************************************************************************************/
   
    private void getContractTerms(DCPNewSalesStoreUtility.StoreWrapper storeData){
        try{
            if(storeData == null || String.isEmpty(storeData.storeType) || String.isEmpty(storeData.segment)){
                throw new TermException('Store data is empty ');
            }    
            
            Set<Id> planIds = new Set<Id>();
            List<DCPNewSalesDataUtil.ContractTermWrapper> wrapperList = null;
            Map<Id,List<DCPNewSalesDataUtil.ContractTermWrapper>> planToTermMap = new Map<Id,List<DCPNewSalesDataUtil.ContractTermWrapper>>();
            if (Schema.sObjectType.New_Sales_Contract_Term_Setting__c.isQueryable()){
                for(New_Sales_Contract_Term_Setting__c plan : [Select Id,Name,Plan__c,YoY_1__c, YoY_2__c, Contract_Term__c, Adjustment_Amount__c, Adjustment_Type__c from New_Sales_Contract_Term_Setting__c 
                                                               where Related_Store__r.APTSECOM_Customer_Pricing_Segment__c = :storeData.segment 
                                                               and Related_Store__r.Type__c = :storeData.storeType order by Contract_Term__c])
                {
                    planIds.add(plan.Plan__c);
                    this.buildTermWrapperMap(plan, wrapperList, planToTermMap);
                    
                }
            }
            this.contractTerm.planIds = planIds;
            this.contractTerm.planToTermMap = planToTermMap;
        }catch(TermException ex){
            DCPNewSalesDataUtil.errorMessage =  'Term Exception Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
        }catch(Exception ex){
            DCPNewSalesDataUtil.errorMessage =  'Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
        }       
    }
    
    /********************************************************************************************************
    *  @description  buildTermWrapperMap - Build term wrapper
    *  @param plan
    * @param wrapperList
    * @param planToTermMap
    *********************************************************************************************************/
    private void buildTermWrapperMap(New_Sales_Contract_Term_Setting__c plan, List<DCPNewSalesDataUtil.ContractTermWrapper> wrapperList, Map<Id,List<DCPNewSalesDataUtil.ContractTermWrapper>> planToTermMap){
        try{
            DCPNewSalesDataUtil.ContractTermWrapper wrap = new DCPNewSalesDataUtil.ContractTermWrapper();
            wrap.planId=plan.Id;
            wrap.planName = plan.Name;
            wrap.productGroupId=plan.Plan__c;
            wrap.yoy1=plan.YoY_1__c <> null ? Integer.valueOf(plan.YoY_1__c) : 0.0;
            wrap.yoy2=plan.YoY_2__c <> null ? Integer.valueOf(plan.YoY_2__c) : 0.0;
            wrap.adjustmentAmount = plan.Adjustment_Amount__c;
            wrap.adjustmentType = plan.Adjustment_Type__c;           
            wrap.contractTerm=plan.Contract_Term__c == '1 Year'? 1 : plan.Contract_Term__c == '2 Years' ? 2 : plan.Contract_Term__c == '3 Years' ? 3 : null ;
            if(planToTermMap.containsKey(plan.Plan__c)){
                wrapperList = planToTermMap.get(plan.Plan__c);
                wrapperList.add(wrap); 
            }else{
                wrapperList = new List<DCPNewSalesDataUtil.ContractTermWrapper>();
                wrapperList.add(wrap);
                planToTermMap.put(plan.Plan__c,wrapperList);
            }
        }catch(Exception ex){
            DCPNewSalesDataUtil.errorMessage  =  'Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
        } 
        
    }
    
    
    /********************************************************************************************************
    *  @description  getPlanProducts - get all the products related to the plan  
    *  @param productIds - Set of product Ids
    *********************************************************************************************************/

    private void getPlanProducts(Set<Id> productIds){
        try{
            Set<Id> groupMembers = null;
            Map<Id,Id> productToPlanIds = new Map<Id,Id>();
            Map<Id,Set<Id>> planToProdMap = new Map<Id,Set<Id>>();
            if (Schema.sObjectType.Apttus_Config2__ProductGroupMember__c.isQueryable()){
                for(Apttus_Config2__ProductGroupMember__c member : [Select Id, Apttus_Config2__ProductGroupId__c, Apttus_Config2__ProductId__c 
                                                                    from Apttus_Config2__ProductGroupMember__c 
                                                                    where Apttus_Config2__ProductId__c in :productIds
                                                                    and Apttus_Config2__ProductGroupId__c in :this.contractTerm.planIds ])
                {
                    if(planToProdMap.containsKey(member.Apttus_Config2__ProductGroupId__c)){
                        groupMembers = planToProdMap.get(member.Apttus_Config2__ProductGroupId__c);
                        groupMembers.add(member.Apttus_Config2__ProductId__c);
                        
                    }else{
                        groupMembers = new Set<Id>();
                        groupMembers.add(member.Apttus_Config2__ProductId__c);
                        planToProdMap.put(member.Apttus_Config2__ProductGroupId__c,groupMembers);
                        //productToPlanIds.put(member.Apttus_Config2__ProductId__c,member.Apttus_Config2__ProductGroupId__c);
                    }
          productToPlanIds.put(member.Apttus_Config2__ProductId__c,member.Apttus_Config2__ProductGroupId__c);
                }
            }
            this.contractTerm.planToProdMap = planToProdMap;
            this.contractTerm.productToPlanIds = productToPlanIds;
        }catch(Exception ex){
            DCPNewSalesDataUtil.errorMessage =  'Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
        }
    }
    

    /********************************************************************************************************
    *  @description  consolidateProductPlans - gather plan products and contract terms in a map  
    *  @return DCPNewSalesDataUtil.ContractTermPlanWrapper  : New Sales Contract Term and Plan mapping in ContractTermPlanWrapper  
    *********************************************************************************************************/

    public DCPNewSalesDataUtil.ContractTermPlanWrapper consolidateProductPlans(){
        
        Map<Id,DCPNewSalesDataUtil.PlanWrapper> planMap = new Map<Id,DCPNewSalesDataUtil.PlanWrapper>();
        try{
            if(this.contractTerm.planToTermMap == null){
                throw new TermException('Invalid contract term map ');
            }
            for(Id planId : this.contractTerm.planToTermMap.keySet()){
                DCPNewSalesDataUtil.PlanWrapper planWrap = new DCPNewSalesDataUtil.PlanWrapper();
                planWrap.planId = planId;
                planWrap.planToProdList = this.contractTerm.planToProdMap.get(planId);
                planWrap.plantoTermList = this.contractTerm.planToTermMap.get(planId);
                planMap.put(planId,planWrap);
                
            }
            this.contractTerm.planMap = planMap;
        }catch(TermException ex){
            DCPNewSalesDataUtil.errorMessage =  'Term Exception Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
        }catch(Exception ex){
            DCPNewSalesDataUtil.errorMessage =  'Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
        }
        return this.contractTerm;
    }
    
    /********************************************************************************************************
    *  @description  getContractPlans - method to return New Sales Contract Term and Plan mapping in ContractTermPlanWrapper  
    *  @return DCPNewSalesDataUtil.ContractTermPlanWrapper  : New Sales Contract Term and Plan mapping in ContractTermPlanWrapper  
    *  @param storeData
    * @param productIds
    *********************************************************************************************************/

    public static DCPNewSalesDataUtil.ContractTermPlanWrapper getContractPlans(DCPNewSalesStoreUtility.StoreWrapper storeData, Set<Id> productIds){
        DCPNewSalesDataUtil.ContractTermPlanWrapper contractTerms;
        try{
            if(storeData <> null){                
                DCPNewSalesPlanUtility util = new DCPNewSalesPlanUtility();
                util.getContractTerms(storeData);
                util.getPlanProducts(productIds);
                contractTerms = util.consolidateProductPlans();
            }
        }catch(Exception cte){
            DCPNewSalesDataUtil.errorMessage =  'Cause:'+ cte.getCause() +' Stack trace:'+ cte.getStackTraceString();
        }
        return contractTerms;
    }    
    
     /********************************************************************************************************
* @description logException: Upsert Exception
*  @param logMap
*********************************************************************************************************/ 
    public static void logExceptions(Map<String,String> logMap){
        if(logMap!=null){
            DCPNewSaleUtilityCls.logException(logMap);
        }
    }
    
}