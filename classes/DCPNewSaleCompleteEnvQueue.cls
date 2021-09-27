/** 
 * @description : This is the class to handle the complete envelope call
 * @Author : Avudaiappan A
 */ 
public without sharing class DCPNewSaleCompleteEnvQueue implements Schedulable{

    
    private String quoteId;
    private String envelopeId;
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    public Static String priceListNameUS = Static_Values__c.getValues('PriceListName').Value__c;//Fetch the name of PL :'Thomson Reuters Master - US Legal'
    public Static String delayInMin = Static_Values__c.getValues('DocusignDelayTimer').Value__c;

    /** 
 * @description : Constructor
 * @param quoteId - quoteId as param
 */ 
    public DCPNewSaleCompleteEnvQueue(String quoteId){
         this.quoteId = quoteId;
         //this.envelopeId = envelopeId;
    }
    /** 
 * @description : This is the execute method
 * @param context - schedulable Context
 */ 
    public void execute(SchedulableContext context) {
        system.debug(LoggingLevel.INFO, 'Queuable Started');
        
        try{
            String query ='SELECT id,Apttus_DocuApi__EnvelopeId__c FROM Apttus_DocuApi__DocuSignEnvelope__c WHERE Apttus_QPDSign__QuoteProposal__c =:QuoteId LIMIT 1';
            Apttus_DocuApi__DocuSignEnvelope__c envelope = database.query(query);
            envelopeId = envelope.Apttus_DocuApi__EnvelopeId__c;
            system.debug(LoggingLevel.INFO, 'Queuable Started'+','+delayInMin+','+priceListNameUS);
            if(String.isNotBlank(quoteId) && String.isNotBlank(envelopeId)){
                DCPNewSaleCompleteDocusignEnvelope.completeEnvelope(envelopeId,quoteId);
        	}
            //database.executeBatch(new APTS_CreateOrderAssetJob ());
		}catch(Exception e){
            //Map<String,String> errorHandlerMap = 
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