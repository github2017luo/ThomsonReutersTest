/********************************************************************************************************
*  @description ODTDG_CallEloquaFromQueueable : This is the main class to call OMNI implemented entitlements 
*********************************************************************************************************/ 
public with sharing class ODTDG_CallEloquaFromQueueable implements Queueable, Database.AllowsCallouts {
    
    private id trialId;
    private List<id> trialContacts;
    private List<id> trialProducts ;

/********************************************************************************************************
*  @description ODTDG_CallEntitlementFromQueueable: This is the constructor to call entitlement service 
* 
* @param trialId : this is expected Trial record Id
* @param trialContacts : this is expected Trial intended email ids
* @param trialProducts : this is expected Trial intended product codes
*********************************************************************************************************/ 

    public ODTDG_CallEloquaFromQueueable (id trialId, List<id> trialContacts, List<id> trialProducts) {
        this.trialId = trialId;
        this.trialContacts= new List<id>();
        this.trialProducts = new List<id>();

        this.trialContacts.addAll(trialContacts);
        this.trialProducts.addAll(trialProducts);

    }


/********************************************************************************************************
*  @description execute: This is the main method to call entitlement 
*  @param context it is expected standard parameters 
*********************************************************************************************************/ 


    public void execute(QueueableContext context) {
        boolean isSuccess = FALSE;
        if(!Test.isRunningTest()){
            isSuccess = OmniCalltoEloqua.getOmniTrialsEloquaCalls(this.trialId, this.trialContacts, this.trialProducts);
        }
        System.debug(LoggingLevel.INFO,'isSuccess...............'+isSuccess);
        
    }

}