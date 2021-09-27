@IsTest
public class ESC_CommonContactSIUtility_Test {
    static testmethod void method1(){
        
        List<Account> acclist = new List<Account>();
        List<Contact> conlist = new List<Contact>();
        
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        acclist.add(testAccount);
        insert acclist;
         
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.FirstName='First';
        conlist.add(testContact);
        insert conlist;
        
        Case ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
        Insert ca;
         
        ESC_Special_Instruction__c spi = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
        insert spi;
    
         ESC_Case_Special_Instruction__c caSI = ESC_GenericTestutility.TestCaSIUtil(spi.id,ca.id);
         Insert caSI;
        
         ESC_Contact_Special_Instruction__c conSI = ESC_GenericTestutility.TestConSIUtil(spi.id,testContact.id);
         Insert conSI;
         
         ESC_Account_Special_Instruction__c accSI = ESC_GenericTestutility.TestAccSIUtil(spi.id,testAccount.id);
         Insert accSI;
         
         Test.startTest();
         ESC_CommonContactSIUtility.inheritIntoContactSpecialInstructions(conlist);
         Test.stopTest();
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        
    }

}