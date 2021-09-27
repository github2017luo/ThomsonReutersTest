/* 
 *@author Original : Tejaswi Nissankula (UX010800)
 *@date Original   : 12 Dec 2017
 *@description     CRM-9456) Class to schedule the batch class of Order submission to ESI for every 15 mins.
*/
global without sharing class Apttus_ScheduleOrderSubmission implements Schedulable{
    public integer interval=integer.valueOf(System.label.Order_Submission_Schedule.trim());
    global void execute(Schedulablecontext sc){    
        system.debug('In Scheduleorder execute');
        DateTime now=DateTime.now();
        DateTime nextRunTime=now.addMinutes(interval);
        string cronString=''+nextRunTime.second()+' '+nextRunTime.minute()+' '+nextRunTime.hour()+' '+nextRunTime.day()+' '+nextRunTime.month()+' ? '+nextRunTime.year();
        system.debug('now:: '+now+' nextRunTime ::'+nextRunTime+' cronString ::'+cronString+' schedule context ::'+sc);
        if(!Test.isRunningTest()){
            system.schedule(Apttus_ScheduleOrderSubmission.class.getName()+'-'+now.format(),cronstring,new Apttus_ScheduleOrderSubmission());
        }
        system.debug(' schedule context 1::'+sc);
        if(sc==NULL){
            Database.executeBatch(new Aptts_BatchOrderSubmission(),1);
        }
        if(Schema.sObjectType.AsyncApexJob.isAccessible()) {
        AsyncApexJob scheduleJobStatus = [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];          
        if(SC!=null) system.abortJob(sc.getTriggerId());
        if(scheduleJobStatus!=null && (scheduleJobStatus.status=='Completed' ||scheduleJobStatus.status=='Aborted' || scheduleJobStatus.status=='Failed')){
            Database.executeBatch(new Aptts_BatchOrderSubmission(),1);
            //break;
        }  
        
       } 
    }

}