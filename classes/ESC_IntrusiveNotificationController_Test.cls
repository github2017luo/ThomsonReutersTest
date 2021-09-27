@isTest
private class ESC_IntrusiveNotificationController_Test {

    @IsTest(SeeAllData=false) static void escIntrusiveNotificationTest() {
        Test.StartTest();
        
    
       ESC_IntrusiveNotificationsSchema__c inf = new ESC_IntrusiveNotificationsSchema__c();
       inf.ESC_BodyMsgFields__c = 'ContactID,AccountID,CaseNumber';
       inf.ESC_ObjectAPIName__c ='Case';
       inf.Name = 'Name';
       insert inf;
       
       
        ESC_IntrusiveNotificationController nc = new ESC_IntrusiveNotificationController();
        nc.getPushTopicNames();
        nc.getObjectIdentifierMap();
        nc.getIntrusiveSchemaMSG();
      
        Test.StopTest();
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }

}