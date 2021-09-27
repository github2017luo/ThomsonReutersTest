global class ESC_delAttachmentScheduler implements Schedulable{  

   global void execute(SchedulableContext sc){ 
     ESC_delAttachmentsOverCaseBatch delBatch = new ESC_delAttachmentsOverCaseBatch();  
     Id BatchProcessId = Database.ExecuteBatch(delBatch);     
       
    }
}