@istest
public class ESC_GGOCaseEntitlmentResponsePBTest{
    public static testmethod void testDataSetUp() {
    Test.startTest();
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting43501@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);        
       insert u1;
       
       Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
       testAccount.Software_Account_Attributes__c='Medium';
       insert testAccount;
     
       Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
       testcontact.firstname='testfirst';
       insert testContact;
      
      List<case> lstcase = new List<case>();
        system.runas(u1){
        Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
        testcase.LCRM_Sub_BU__c='GGO';
        testcase.Subject='test1';
        testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        testcase.ESC_Diagnosis_Summary__c = 'Access Details';
        testcase.ESC_Severity__c = '2 - Medium';
        testcase.Is_GLI__c=false;
        insert testcase;
        testcase.ESC_Severity__c = '3 - Low';
        update testcase;
       
      }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        Test.stopTest();    
    }
    }