/* Class: LTGS_massMuteReAssign_TrainingEvent_Test
 * Purpose: To cover all the scenarios of classe:LTGS_NewOpportunity.
 * Created: 03/20/2019
 * Author: Vaishali Gayatri 
 * 
 */
@isTest 
public class LTGS_massMuteReAssign_TrainingEvent_Test {
  
  
 /********************************************************************************************************
 setdata: Method to create dummy Training Event.
********************************************************************************************************/     
 @istest static void eventone()
    { 
        List<Training_Event__c> trnngEvnt =new List<Training_Event__c>();
        Training_Event__c trnngEvent1 =new Training_Event__c();
        trnngEvent1.Training_Name__c ='Test Event';
        trnngEvent1.Status__c='Pending';
        trnngEvnt.add(trnngEvent1);
        insert trnngEvnt;
      Test.startTest();
        test.setCurrentPage(Page.LTGS_MassMuteReAssignmentTrainingEvent);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(TrnngEvnt);
        stdSetController.setSelected(trnngEvnt);
        LTGS_massMuteReAssign_TrainingEvent  ext = new LTGS_massMuteReAssign_TrainingEvent (stdSetController);
        ext.changecbx();
        Test.stopTest();  
    }
    
 /********************************************************************************************************
 setdata: Method to create dummy Training Event.
********************************************************************************************************/   
    @istest static void eventtwo(){
        List<Training_Event__c> trnngEvnt2 =new List<Training_Event__c>();
        Training_Event__c trnngEvent2 =new Training_Event__c();
        trnngEvent2.Training_Name__c='Test Event2';
        trnngEvent2.Status__c='Contacted';
        trnngEvnt2.add(TrnngEvent2);
        insert trnngEvnt2;
         
        Test.startTest();
        test.setCurrentPage(Page.LTGS_MassMuteReAssignmentTrainingEvent);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(trnngEvnt2);
        stdSetController.setSelected(trnngEvnt2);
        LTGS_massMuteReAssign_TrainingEvent  ext = new LTGS_massMuteReAssign_TrainingEvent (stdSetController);
        ext.changecbx();
        Test.stopTest();
    }
     @istest static void eventthree(){
     List<Training_Event__c> trnngEvnt3 =new List<Training_Event__c>();
        Training_Event__c trnngEvent3 =new Training_Event__c();
        insert trnngEvnt3;
         
         Test.startTest();
        test.setCurrentPage(Page.LTGS_MassMuteReAssignmentTrainingEvent);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(trnngEvnt3);
        stdSetController.setSelected(trnngEvnt3);
        LTGS_massMuteReAssign_TrainingEvent  ext = new LTGS_massMuteReAssign_TrainingEvent (stdSetController);
        ext.changecbx();
        Test.stopTest();
     }
    
}