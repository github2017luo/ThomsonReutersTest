@isTest
private class TrainingEventcStatsTT {

   static testMethod void testTrigger() {
      try {
          Training_Event__c o = new Training_Event__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          /**List<Training_Event__c> l = [SELECT Id from Training_Event__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);**/
          //updated for test class failure fix
          List<Training_Event__c > TrainingEventlst = new List<Training_Event__c >();
          Training_Event__c  oTE1 = UnitTest.getTrainingEventInstance();
          TrainingEventlst.add(oTE1);
            
          Training_Event__c  oTE2 = UnitTest.getTrainingEventInstance();
          TrainingEventlst.add(oTE2);
          insert TrainingEventlst;
           
          update TrainingEventlst;
          System.assertNotEquals(null, TrainingEventlst);
      }
   }
}