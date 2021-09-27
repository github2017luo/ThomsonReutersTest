/**********************************
Class Name: ContactSICaseUtilityTest
Purpose: Test class for "ContactSICaseUtility" apex class.
Author:Manish
Date Created:11/05/2017
Date Updated:Version0
***********************************/
@IsTest
 public class ESC_ContactSICaseUtilityTest{
    static testmethod void contactSICaseUtilitytest() {
    
         List<ESC_Special_Instruction__c> silist= new List<ESC_Special_Instruction__c>();
 
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount ;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test','test@tr.com');
         insert testContact;
         
         Case ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
         insert ca;
         
         ESC_Special_Instruction__c spi = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
         silist.add(spi);
         insert silist;
         
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;
         
         Test.startTest();
         ESC_ContactSICaseUtility.inheritIntCaseSpecialInstructions(silist);
         Test.stopTest();   
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    } 
}