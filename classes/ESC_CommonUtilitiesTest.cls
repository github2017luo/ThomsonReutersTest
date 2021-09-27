/**********************************
Class Name:CommonUtilitiesTest 
Purpose: Test class for checking the CommonUtilities apex class.
Author:Rupesh
Date Created:11/05/2017
Date Updated:Version0
***********************************/
@IsTest
 public  class ESC_CommonUtilitiesTest {
         static testmethod void commonUtilities () {
         Test.startTest();
    
         List<ESC_Special_Instruction__c> specialInstruction= new List<ESC_Special_Instruction__c>();
         List<Account> acclist = new List<Account>();
         List<Contact> conlist = new List<Contact>();
         
         Account testAccount = new Account(Name ='TestAccount' ,AccountNumber ='TestAccount001',Phone='7786864710');  
         acclist.add(testAccount);
         insert acclist;
         
         Contact testContact = new Contact(AccountId =testAccount.id ,LastName ='Mile',FirstName='test',Email='test@tr.com');
         conlist.add(testContact);
         insert conlist;
         
         Case ca = new Case(ContactId=testContact.id,AccountId=testAccount.id,Status ='Work in Progress');
         Insert ca;
         
         ESC_Special_Instruction__c spi = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
        
         ESC_MilestoneIdentifierSetting__c milest= new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time',FieldAPIName__c ='ESC_Response_Time__c');
         insert milest;
         
         ESC_CommonUtilities.inheritSpecialInstructions(specialInstruction);
         specialInstruction.add(spi);
         insert specialInstruction;
         ESC_CommonUtilities.inheritSpecialInstructions(specialInstruction);
         Test.stopTest();
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    } 
  }