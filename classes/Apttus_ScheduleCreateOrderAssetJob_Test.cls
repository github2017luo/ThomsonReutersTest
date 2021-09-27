@istest
public class Apttus_ScheduleCreateOrderAssetJob_Test{
    static testmethod void testmethod1(){
       
        test.startTest();
        Apttus_ScheduleCreateOrderAssetJob   abc=new Apttus_ScheduleCreateOrderAssetJob();
        abc.execute(null);
        test.stopTest();
    }
}