/* 
 *@author Original : Priyanka Pawar (UX007471)
 *@date Original   : 18th Jan 2019
 *@description     SOC-9607) Class to schedule the batch class of Order and asset creation every 5 mins.
*/
global class Apttus_ScheduleCreateOrderAssetJob  implements Schedulable{
    public integer interval=integer.valueOf(System.label.OrderAssetBatchJobInterval.trim());
    public integer BatchSize=integer.valueOf(System.label.OrderAssetJobBatchSize);
    global void execute(Schedulablecontext sc){    
        system.debug('In Scheduleorder execute');
        DateTime now=DateTime.now();
        DateTime nextRunTime=now.addMinutes(interval);
        string cronString=''+nextRunTime.second()+' '+nextRunTime.minute()+' '+nextRunTime.hour()+' '+nextRunTime.day()+' '+nextRunTime.month()+' ? '+nextRunTime.year();
        system.debug('now:: '+now+' nextRunTime ::'+nextRunTime+' cronString ::'+cronString+' schedule context ::'+sc);
        if(!Test.isRunningTest()){
            system.schedule(Apttus_ScheduleCreateOrderAssetJob.class.getName()+'-'+now.format(),cronstring,new Apttus_ScheduleCreateOrderAssetJob());
        }
        system.debug(' schedule context 1::'+sc);
        if(sc==NULL){
            Database.executeBatch(new APTS_CreateOrderAssetJob(),1);
        }
        AsyncApexJob scheduleJobStatus = [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'APTS_CreateOrderAssetJob' order by CreatedDate DESC limit 1];          
        if(SC!=null) system.abortJob(sc.getTriggerId());
        if(scheduleJobStatus!=null && (scheduleJobStatus.status=='Completed' ||scheduleJobStatus.status=='Aborted' || scheduleJobStatus.status=='Failed')){
            Database.executeBatch(new APTS_CreateOrderAssetJob(),BatchSize);
            //break;
        }  
        
        
    }

}