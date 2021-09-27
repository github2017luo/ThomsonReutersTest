@isTest
public class Ecom_scheduledeletertest {
    static testmethod void testScheduledJob(){
       List<Digital_Exception_Log__c> dbcs=new  List<Digital_Exception_Log__c>();
        Integer i=0;
        for(i=0;i<10;i++)
        {
            Digital_Exception_Log__c dbc=new Digital_Exception_Log__c();
      		dbcs.add(dbc);
        }
    	insert dbcs;
        for(Digital_Exception_Log__c dbc : dbcs){
            Datetime olddate1 = Datetime.now().addDays(-200);
      		Test.setCreatedDate(dbc.Id,olddate1);
        }
        update dbcs;
        Test.startTest();
          String jobi=System.schedule('Test DL', '0 0 0 ? * *', new Ecom_scheduledeleter());
        Test.stopTest();
    }
}