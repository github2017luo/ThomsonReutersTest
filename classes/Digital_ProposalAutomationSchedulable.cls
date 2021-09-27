/*****Change History *********************************************************************************************/
/*** JIRA           Modified By    JIRA Description   ************************************************************/
/*** DLT-10575      Harika Sai P   Duplicate automation jobs in Production if it run for more than day 
/*** DLT-21366      Kavya S         PMD FIX
/*****************************************************************************************************************/
/** 
 * @description : Digital_ProposalAutomationSchedulable
 */
global Class Digital_ProposalAutomationSchedulable implements Schedulable{
    Integer intervalHours = Integer.valueof(System.label.Digital_Quote_Automation_Schedule.trim());
      /** 
     * @description :execute
     * @param scContext : scContext
     */
     global void execute(SchedulableContext scContext) {
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addHours(intervalHours);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        if(!Test.isRunningTest()){
            Id sId = System.schedule(Digital_ProposalAutomationSchedulable.class.getName() + '-' + now.format(), cronString, new Digital_ProposalAutomationSchedulable());
            System.debug(logginglevel.INFO,'sId>>'+sId);
        }
        //Filtering the jobs under processing/In progress status
        try{
            string strBatchClsNames = Label.Digital_Batch_Classes_Query_Filter;
            SET<String> btchClsSet= new SET<String>();
            btchClsSet.AddAll(strBatchClsNames .Split(','));            
            List<AsyncApexJob> scheduleJobInProgressLst = [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name IN : btchClsSet AND Status NOT IN ('Completed','Aborted','Failed')  order by CreatedDate DESC LIMIT 1];          
            if(scContext != NULL){
                Id jobId = scContext.getTriggerId();
                System.abortJob(jobId);
            }  
            system.debug(logginglevel.INFO,'***scheduleJobInProgressLst '+scheduleJobInProgressLst );
            //All triggered jobs are completed then only next run will be scheduled.    
            if(scheduleJobInProgressLst.isEmpty() ){               
                Digital_ProposalAutomationnewOpp dpb = new Digital_ProposalAutomationnewOpp();
                Database.executeBatch(dpb, 1);
            } 
        }Catch(Exception ex){
            throw ex;
        }
        
        
     }
}