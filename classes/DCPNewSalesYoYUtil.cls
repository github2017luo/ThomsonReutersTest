/* Class: DCPNewSalesYoYUtil
* Purpose: A utility class to build year over year pricing data
* Created: 6/18/2021
**/
/**
* @description A utility class to build year over year pricing data 
*/
public without sharing class DCPNewSalesYoYUtil {
    /**
* @description class properties
*/
    public String serviceVersion = 'v1';
    private static String version;
    public DCPNewSalesDataUtil.ContractTermPlanWrapper termWrapper;
    public List<Apttus_Config2__PriceMatrixEntry__c> matrixLst;
    /**
* @description Custom exception to handle yoy calculation errors
*/
    class YoYException extends Exception {}
    
    /**
* @description method holds the logic to calculate price after applying YoY uplift
* @param pricematrixentry, list of priceMatix
*/
    
    /********************************************************************************************************
    *  @description  getYoyMatrixData - method holds the logic to calculate price after applying YoY uplift 
    *  @return Booelan: return success and failure as True and False respectively 
    *  @param prodId - ProductId,  
    * @param entry - matrix entry and sequence
    * @param priceMatrixList - List of price matrix entries
    *********************************************************************************************************/

    public Boolean getYoyMatrixData(Id prodId, Apttus_Config2__PriceMatrixEntry__c entry, List<PriceMatrix> priceMatrixList){
        if(termWrapper == null || termWrapper.planMap.isEmpty()){
            return false;
        }
        
        DCPNewSalesDataUtil.PlanWrapper wrap = termWrapper.planMap.get(termWrapper.productToPlanIds.get(prodId));
        try{
            
            for(DCPNewSalesDataUtil.ContractTermWrapper ctWrap : wrap.plantoTermList){
                ctWrap.productId = prodId;
                this.calcPriceYOY(ctWrap,entry,priceMatrixList);
            }
        }catch(Exception ex){
            DCPNewSalesDataUtil.errorMessage =  'Cause:'+ ex.getCause() +' Stack trace:'+ ex.getStackTraceString();
            return false;
        }
        return true;        
    }
  
    /********************************************************************************************************
    *  @description  calcPriceYOY - method holds the logic to calculate price after applying YoY uplift 
    *  @param ctWrap - ContractTermWrapper,  
    * @param entry - matrix entry and sequence
    * @param priceMatrixList - List of price matrix entries
    *********************************************************************************************************/
    private void calcPriceYOY(DCPNewSalesDataUtil.ContractTermWrapper ctWrap,Apttus_Config2__PriceMatrixEntry__c entry,List<PriceMatrix> priceMatrixList){
        Decimal tempAmount = 0;
                Decimal tempYoY = 0;
                tempAmount = (tempAmount == 0 && tempYoY == 0) || (tempYoY < ctWrap.YoY1) ? entry.Apttus_Config2__AdjustmentAmount__c : tempAmount;
                Integer maxYear = ctWrap.contractTerm;
                if(this.serviceVersion == 'v3'){
                    maxYear = 1;    
                }
        		System.debug(LoggingLevel.INFO,'Version:'+serviceVersion+'>Year>'+maxYear);
        		for(Integer i=1; i<=maxYear;i++){
                    PriceMatrixYoY pm = new PriceMatrixYoY();
                    Decimal amount = 0.00;
                    if(i == 1){
                        amount = tempAmount;
                        amount = this.assignmentMethod(ctWrap,amount);
                    }else{
                        amount =  (tempAmount*(ctWrap.yoy2/100))+tempAmount;
                    }
                    
                    pm.adjustmentType = ctWrap.adjustmentType;
            		pm.adjustmentAmount = ctWrap.adjustmentAmount;
                    pm.amount = amount <> null ? String.valueOf(amount) : '0.00';
                    pm.yoy1 = ctWrap.yoy1;
                    pm.yoy2 = ctWrap.yoy2;
                    pm.productId = ctWrap.productId;
                    pm.year = i;
                    pm.contractTerm = ctWrap.contractTerm == 1? String.valueOf(ctWrap.contractTerm) + ' Year' : String.valueOf(ctWrap.contractTerm) + ' Years';
                    pm.quantity = entry.Apttus_Config2__Dimension1Value__c;
                    tempAmount = Decimal.valueOf(pm.amount);
                    tempYoY = ctWrap.yoy1;
                    priceMatrixList.add(pm);                    
                }
    }
/********************************************************************************************************
    *  @description  calcPriceYOY - method holds the logic to calculate price after applying YoY uplift 
    *  @return PriceMatrixYoY - priceMatrixYOY,  
    * @param pm - matrix entry and sequence
    * @param ctWrap - ContractTermWrapper
    * @param amount - amount
    *********************************************************************************************************/
    private Decimal assignmentMethod(DCPNewSalesDataUtil.ContractTermWrapper ctWrap, Decimal amount){
    
        if(String.isEmpty(ctWrap.adjustmentType) && ctWrap.adjustmentAmount == null){
            return amount;
        }  
        
        if(ctWrap.adjustmentType == '% Discount'){
            amount = amount - ((ctWrap.adjustmentAmount*amount)/100);
        }else if(ctWrap.adjustmentType == '% Markup'){
            amount = amount + ((ctWrap.adjustmentAmount*amount)/100);
        }else{
            return amount;
        }
        
        return amount;
        
    }
    

    /**
* @description wrapper for price matrix
*/
    public virtual class PriceMatrix {
        public String quantity;
        public String amount;
       
    }
      /**
* @description priceMatrixYOY extenstion cls
*/
    public class PriceMatrixYoY extends PriceMatrix {
        public String contractTerm;
        public Decimal yoy1;
        public Decimal yoy2;
        public String productId;
        public Integer year;
        public String adjustmentType;
        public Decimal adjustmentAmount;
    }
    
    /**
* @description wrapper for year over year request
*/
    public class YoYRequestWrapper{
        public Set<Id> productIds;
        Public String storeName;
        Public String storeType;
        Public String customerSegment;
    }
}