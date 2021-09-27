public class TRStore_OrderCreateQueueable implements Queueable {


    public id quoteId;

    public TRStore_OrderCreateQueueable (id qId){
        
        quoteId = qId;
    }

    public void execute(QueueableContext context) {

            TRStore_OrderSubmission.submitTRStoreOrder(quoteId);
    }
   
}