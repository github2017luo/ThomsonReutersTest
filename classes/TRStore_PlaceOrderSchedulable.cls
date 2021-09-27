public with sharing class TRStore_PlaceOrderSchedulable implements  Schedulable {


    private id quoteId;
     
    public TRStore_PlaceOrderSchedulable(id qId){
        this.quoteId = qId;
    }
    
    
    
    public void execute(SchedulableContext sc){
        // planning to check here - 1. in Cart, status = finalized && quoteId != null, 2. quote has billTo and ShipTo, Oppty populated
         System.debug('quoteid2......'+quoteId);
        if(quoteId != null /*&& !test.isRunningTest()*/ ){
            String query = 'select id,TR_Store_Source__c from Apttus_Proposal__Proposal__c where Id=:quoteId limit 1';
            Apttus_Proposal__Proposal__c prop = Database.Query(query);
            if(prop.TR_Store_Source__c == 'TR Store Canada Print'){
               //System.enqueueJob(new TRStore_OrderCreateQueueable(quoteId)); old queueable class 
            	TRStore_OrderSubmission.submitTRStoreOrder(quoteId); 
            }else if(prop.TR_Store_Source__c == 'UE Store Canada PRINT'){
                TRStore_TransactOrderSubmission.submitTransactOrder(quoteId); 
            }
            
        }
    }
    
    
  
}