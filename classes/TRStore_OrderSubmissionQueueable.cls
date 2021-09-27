public class TRStore_OrderSubmissionQueueable implements Queueable{


    private id quoteId;
    private id cartId;
    private id leadId;


    public TRStore_OrderSubmissionQueueable(id qId, id cId, id lId){
        
         this.quoteId = qId;
         this.cartId = cId;
         this.leadId = lId;
    }

     
    public void execute(QueueableContext context) {
           TRStore_OrderSubmission.processTRStoreOrder(quoteId, cartId, leadId);
           // planning to check here - 1. in Cart, status = finalized && quoteId != null, 2. quote has billTo and ShipTo, Oppty populated
         
        
        getStaticValues();
         
        string timeframeToProcessOrder = staticValues.containsKey('TRStoreOrderProcessTimeFrame')?staticValues.get('TRStoreOrderProcessTimeFrame') : '10';  
        
        integer schMin = 10;
        
        if(timeframeToProcessOrder.isNumeric()){
            schmin = integer.valueOf(timeframeToProcessOrder);
        }
        
        TRStore_PlaceOrderSchedulable os = new TRStore_PlaceOrderSchedulable(this.quoteId);
        dateTime dt = system.now();
        dt = dt.addMinutes(schmin);
        
        system.debug('Hello Time 11111111.......'+dt);
        
        
        String day = string.valueOf(dt.day());
        String month = string.valueOf(dt.month());
        String hour = string.valueOf(dt.hour());
        String minute = string.valueOf(dt.minute() );
        String second = string.valueOf(dt.second());
        String year = string.valueOf(dt.year());
        
        String strJobName = 'TRSTR-'+quoteId+'-'+DateTime.now();
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        
        
        system.debug('Hello Time 2222222.......'+strSchedule );
        
        String jobID = system.schedule(strJobName , strSchedule, os);
        
    }
    
    
    
    
    public Map<String,String> staticValues;
     /* Retrieve static values and store it in a map */
    private void getStaticValues(){
        for(Static_Values__c instance : Static_Values__c.getAll().values() ){
            if(this.staticValues == null) {
                this.staticValues = new Map<String,String>();
            }
            this.staticValues.put(instance.name, instance.Value__c);
        }
    }
    
  
}