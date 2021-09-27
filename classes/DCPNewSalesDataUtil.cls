/* Class: DCPNewSalesDataUtil
* Purpose: A utility class to hold bunch of wrapper models
* Created: 6/18/2021
**/
/**
* @description This class holds bunch of wrapper models 
*/
public without sharing class DCPNewSalesDataUtil {

    public static String errorMessage;
    
    /**
     * @description wrapper for contract terms
     */
    public class ContractTermWrapper{
        public string planId;
        public string planName;
        public String productGroupId;
        public String productId;
        public Decimal yoy1;
        public Decimal yoy2;
        public String adjustmentType;
        public Decimal adjustmentAmount;
        public Integer contractTerm;        
    }
    
    
    /**
     * @description wrapper for plans
     */
    public class PlanWrapper{
        public Id planId;
        public Set<Id> planToProdList;
        public List<ContractTermWrapper> plantoTermList;        
    }

    /**
     * @description wrapper for contract term plans
     */
    public Class ContractTermPlanWrapper {
        public Set<Id> planIds;
        public Map<Id,Id> productToPlanIds;
        public Map<Id,DCPNewSalesDataUtil.PlanWrapper> planMap;
        public Map<Id,Set<Id>> planToProdMap;
        public Map<Id,List<DCPNewSalesDataUtil.ContractTermWrapper>> planToTermMap;
        
    }
    /**
     * @description : Constructor
     */
    public DCPNewSalesDataUtil(){
        system.debug(LoggingLevel.INFO,'DCPNewSalesDataUtil Class constructor');
    }
    
    /**
     * @description logs the exception
     * @param exceptionMessage, requestData that is being set in the logger record
     * @return no return
     */
    /*public static void logException(String exceptionMessage, String requestData){
        if(Schema.sObjectType.Integration_Logger__c.isCreateable()){
            insert new Integration_Logger__c(Exception_Message__c = exceptionMessage, Request_Message__c=requestData);
        }
    }*/
}