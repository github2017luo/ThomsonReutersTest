/********************************************************************************************************
*  @description ODTDG_CallEntitlementFromQueueable: This is the main class to call OMNI implemented entitlements 
*********************************************************************************************************/ 
public with sharing class ODTDG_CallEntitlementFromQueueable implements Queueable , Database.AllowsCallouts{
    
    private id trialId;
    private List<string> emailIds;
    private List<string> productCodes ;

/********************************************************************************************************
*  @description ODTDG_CallEntitlementFromQueueable: This is the constructor to call entitlement service 
* 
* @param trialId : this is expected Trial record Id
* @param emailIds : this is expected Trial intended email ids
* @param productCodes : this is expected Trial intended product codes
*********************************************************************************************************/ 

    public ODTDG_CallEntitlementFromQueueable(id trialId, List<string> emailIds, List<string> productCodes) {
        this.trialId = trialId;
        this.emailIds = new List<string>();
        this.productCodes = new List<string>();

        this.emailIds.addAll(emailIds);
        this.productCodes.addAll(productCodes);

    }


/********************************************************************************************************
*  @description execute: This is the main method to call entitlement 
*  @param context it is expected standard parameters 
*********************************************************************************************************/ 


    public void execute(QueueableContext context) {
        boolean isSuccess = FALSE;
        if(!Test.isRunningTest()){
            isSuccess = OmniCalltoSubmitEntitlement.callToSubmitEntitlement(this.trialId, this.emailIds, this.productCodes);
        }
        System.debug(LoggingLevel.INFO,'isSuccess...............'+isSuccess);
        
    }

}