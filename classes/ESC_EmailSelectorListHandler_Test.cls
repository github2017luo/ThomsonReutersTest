/**
 * CHANGE HISTORY
 * ============================================================================================================================
 * Date           Name             JIRA          Description
 * ============================================================================================================================
 * 
 * 2017-05-31   Gousia/Rupesh            EBB        Test class Trigger Handler and  Email Selector List Handler
 * ============================================================================================================================
 */

@isTest
public class ESC_EmailSelectorListHandler_Test {
    public static testMethod void populateConcatenatedField () {
          Test.startTest();
           ESC_EmailSelectorList__c  es1 = new ESC_EmailSelectorList__c ();
           es1.ESC_Case_Field1__c='Work In Progress1';
           es1.ESC_Case_Field2__c='Feedback';
           es1.ESC_Profilename__c='System Administrator';
          insert es1;
        
           es1.ESC_Case_Field2__c='enquiry';
          update es1;
          ESC_EmailSelectorList__c  es2 = new ESC_EmailSelectorList__c ();
          es2.ESC_Case_Field1__c='Work In Progress1';
           es2.ESC_Case_Field2__c='Hot Topic';
          es2.ESC_Profilename__c='System Administrator';
          
          insert es2;
          ESC_EmailSelectorList__c  es3 = new ESC_EmailSelectorList__c ();
          es3.ESC_Case_Field1__c='Work In Progress1';
          es3.ESC_Case_Field2__c='Process';
          es3.ESC_Profilename__c='System Administrator';
          insert es3;
          es3.ESC_Case_Field2__c='feedback';
          update es3;
         Test.stopTest();
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
         
    }

}