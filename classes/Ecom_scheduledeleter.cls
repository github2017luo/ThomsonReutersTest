global without sharing class Ecom_scheduledeleter implements Schedulable{
 public void execute(SchedulableContext ctx){
 Database.executeBatch(new Ecom_DeleteDigitalExceptionlogs(),200);
 }
}