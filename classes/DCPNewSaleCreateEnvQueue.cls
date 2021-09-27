/** 
 * @description : This is the class to handle the create envelope call
 * @Author : Avudaiappan A
 */ 
public without sharing class DCPNewSaleCreateEnvQueue implements Schedulable{

    
    private String quoteId;
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    public Static String priceListNameUS = Static_Values__c.getValues('PriceListName').Value__c;//Fetch the name of PL :'Thomson Reuters Master - US Legal'
    public Static String delayInMin = Static_Values__c.getValues('DocusignDelayTimer').Value__c;

/** 
 * @description : Constructor
 * @param quoteId - quoteId as param
 */ 
    public DCPNewSaleCreateEnvQueue(String quoteId){
         this.quoteId = quoteId;
    }
    /** 
 * @description : This is the execute method
 * @param context - schedulable Context
 */ 
    public void execute(SchedulableContext context) {
        system.debug(LoggingLevel.INFO, 'Queuable Started'+','+delayInMin+','+priceListNameUS);
        try{
            if(String.isNotBlank(quoteId)){
                   DCPProcessDocusignController.createEnv(quoteId);
                   system.enqueueJob(new DCPDocusignDelayProcess(quoteId,'completeEnv'));

           }
		}catch(Exception e){
            logExceptions(new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'Docusign Batch','requestType'=>'Call all docusign methods','reqMsg'=>'Exception Class Name: DCPDocusignBatchController','module'=>'UEStore','recId'=>quoteId,'supportEmail'=>supportEmail,'toSupport'=>'false'});
        }
       
            
    }
    @TestVisible
    private static void logExceptions(Map<String,String> logMap){
        if(logMap!=null){
            DCPNewSaleUtilityCls.logException(logMap);
        }
    }


    
}