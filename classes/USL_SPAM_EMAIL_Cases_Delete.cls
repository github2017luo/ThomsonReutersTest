global class USL_SPAM_EMAIL_Cases_Delete implements Schedulable{
    global void execute(SchedulableContext sc){         


 USL_DeleteCaseRecord delBatch = new USL_DeleteCaseRecord ();  
  Id BatchProcessId = Database.ExecuteBatch(delBatch);

        
       
    }
}