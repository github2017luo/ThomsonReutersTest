/* Class: LTGS_ExceptionHandling_Test
 * Purpose: Test class for the Controller class LTGS_ExceptionHandling
 * Created: 3/8/2019
 * Author: Raghawendra
 
 * CHANGE HISTORY
 * ==========================================================================================================
 *  Date          Name                 Description
 *  2019-03-07    Raghawendra            Initial Version
 * ==========================================================================================================
 
 */
@isTest
public class LTGS_ExceptionHandling_Test {
	static testMethod void testExceptionHandling() {
        /**Digital_Exception_Log__c var=new Digital_Exception_Log__c();
        var.Exception_Message__c='Error Exception';
        var.Exception_Message__c='Exmp';
        var.Additional_Information__c='Exmp';
        var.User_Message__c='Exmp';
        var.Class_Reference__c='Exmp';
        var.Object__c='Proposal';
        var.Record_Id__c='Exmp';
        insert var;*/
        LTGS_ExceptionHandling.createExceptionLog('Error Exception','Error Exception','Error Exception','Error Exception','Error Exception','Proposal','Error Exception');
        
    }
}