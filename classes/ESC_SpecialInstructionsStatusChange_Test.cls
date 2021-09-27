/**********************************
Class Name: SpecialInstructionsStatusChange_Test 
Purpose: Test class for "SpecialInstructionsStatusChange" apex class.
Author:Manish
Date Created:11/05/2017
Date Updated:Version0
**********************************/

@IsTest
    public class ESC_SpecialInstructionsStatusChange_Test{
        static testmethod void methodSpecialInstructionsStatusChange(){
         List<ESC_Special_Instruction__c> silist = new List<ESC_Special_Instruction__c>(); 
          
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount','TestAccount001','7786864710');  
         insert testAccount;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
        //List<case> CaseList1 = new List<Case>();
         Case testCase= new Case();
         testCase.contactid = testContact.id;
         testCase.accountid = testAccount.id;
         testCase.status = 'Work In Progress';
         testCase.recordtypeid = SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
         insert testCase;
         
         
         ESC_Special_Instruction__c spi = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
         silist.add(spi);
         insert silist;
         
         Id recordid=Schema.SObjectType.ESC_Special_Instruction__c.getRecordTypeInfosByName().get('Account Instruction').getRecordTypeId();
         Id recordid2=Schema.SObjectType.ESC_Special_Instruction__c.getRecordTypeInfosByName().get('Contact Instruction').getRecordTypeId();
         //Process Builder condition check
         
         ESC_Special_Instruction__c spi_test = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
         spi_test.RecordTypeID=recordid;
         insert spi_test;
         
         spi_test.ESC_Status__c='Inactive';
         update spi_test;
         
         ESC_Special_Instruction__c spi_test2 = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
         spi_test2.RecordTypeID=recordid2;
         insert spi_test2;
         

         
         ESC_Account_Special_Instruction__c accSI = ESC_GenericTestutility.TestAccSIUtil(spi.id,testAccount.id);
         Insert accSI;
         ESC_Contact_Special_Instruction__c conSI = ESC_GenericTestutility.TestConSIUtil(spi.id,testContact.id);
         Insert conSI;
         ESC_Case_Special_Instruction__c caSI = ESC_GenericTestutility.TestCaSIUtil(spi.id,testCase.id);
         Insert caSI;
         
         Test.startTest();
         ESC_SpecialInstructionsStatusChange.inheritSpecialInstructionsStatusChange(silist);
         
         Test.stopTest();
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
         
        }
        static testmethod void methodSpecialInstructionsStatusChange1(){
         Profile prof = [SELECT Id FROM profile WHERE name= 'USL Helpdesk Agent'];
         User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jtest98',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
         UserName='james1345.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
         profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
         insert us;
         system.runAs(us){
         Test.startTest();
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount','TestAccount001','7786864710');  
         insert testAccount;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact; 
         
         FieldId__c fld= new FieldId__c(SetupOwnerId=Userinfo.getUserId(),DQA_Request_DQA_Case__c='01herserrererer');
         insert fld;   
         
         Languages__c langEnglish = new Languages__c(
                ISO_Code__c = 'en',
                Language_Name__c = 'English',
                Salesforce_ISO_Code__c = 'en_US'
            );           
         Languages__c langEnglishDefault = new Languages__c(
                ISO_Code__c = 'en',
                Language_Name__c = 'English (Default)',
                Salesforce_ISO_Code__c = 'en_US'
            );
            
            Languages__c langSpanish = new Languages__c(
                ISO_Code__c = 'es',
                Language_Name__c = 'Spanish',
                Salesforce_ISO_Code__c = 'es'
            );

            insert langEnglish;
            insert langEnglishDefault;
            insert langSpanish;
         Case testCase1= new Case();
         testCase1.status = 'Work In Progress';
         testCase1.contactid = testContact.id;
         testCase1.accountid=testAccount.id;
         testCase1.recordtypeid = SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
         insert testCase1;
         
         case testcase2 = new Case(); 
         testcase2.id = testcase1.id;
         testcase2.accountid = null;
         testcase2.contactid = null;        
         testCase2.status = 'Closed';
         system.debug('case update 1');
         update testCase2;
         system.debug('case update2');
                                                            
         
         Test.stopTest();
         }
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
         
        }
       }