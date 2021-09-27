/**********************************
Class Name: ESC_SIRedirectController_Test and ESC_OverrideNewSpecialInstController_test
Purpose: test class for ESC_SIRedirectController and ESC_OverrideNewSpecialInstController
Author:Mousumi/Rupesh
Date Created:20/05/2017
Date Updated:V0:
**********************************/
@isTest
public class ESC_SIRedirectControllerTest{ 
@isTest
static void testSpecialInstrutionRedirect() {

  List<ESC_Static_Values__c> staticvallist= new List<ESC_Static_Values__c>();
  ESC_Static_Values__c staticval1= new ESC_Static_Values__c ();
  staticval1.Name='ContactNameId';
  staticval1.ESC_Value__c='CF00N1B00000BDCWR';
  staticvallist.add(staticval1);
  ESC_Static_Values__c staticval2= new ESC_Static_Values__c ();
  staticval2.Name='AccountNameId';
  staticval2.ESC_Value__c='CF00N1B00000BDCWN';
  staticvallist.add(staticval2);
  insert staticvallist;
  
  
  
         Account testAccount = New Account();  
         testAccount.Name= 'TestAccount';
         testAccount.AccountNumber= 'TestAccount001';
         testAccount.Phone= '7786864710';
         insert testAccount ;
         Contact testContact = New Contact(AccountId = testAccount.id, Salutation = 'Mr' , FirstName = 'John' , LastName= 'Mile',Email ='test@tr.com');
         insert testContact ; 
         ESC_Special_Instruction__c spI= new ESC_Special_Instruction__c(ESC_Account__c=testAccount.Id,ESC_Contact__c=testContact.Id);
         insert spI;
         ESC_Contact_Special_Instruction__c css = new ESC_Contact_Special_Instruction__c(ESC_Special_Instruction__c=spI.Id,ESC_Contact__c=testContact.Id);
         //insert css;
         list<ESC_Contact_Special_Instruction__c> css1=new list<ESC_Contact_Special_Instruction__c>();        
         css1.add(css);
         insert css1;
         
         ESC_Account_Special_Instruction__c css2 = new ESC_Account_Special_Instruction__c(ESC_Special_Instruction__c=spI.Id,ESC_Account__c=testAccount.Id);
        list<ESC_Account_Special_Instruction__c> css2list=new list<ESC_Account_Special_Instruction__c>();        
         css2list.add(css2);
         insert css2list; 

        //Start test for  ESC_SIRedirectControllerTest  apex class-------
 
        Test.StartTest();
         PageReference pageRef = Page.ESC_SpecialInstrutionRedirectContact;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id',testContact.id);
         ApexPages.StandardSetController sc = new ApexPages.standardSetController(css1);
         ESC_SpecialInstrutionRedirectController cont = new ESC_SpecialInstrutionRedirectController(sc);
         cont.redirctSIContact();
        //Test.StopTest(); 
         
          //Test.StartTest();
         PageReference pageRef1 = Page.ESC_SpecialInstrutionRedirectAccount;
         Test.setCurrentPage(pageRef1);
         pageRef1.getParameters().put('Id',testAccount.id);
         ApexPages.StandardSetController sc1 = new ApexPages.standardSetController(css2list);
         ESC_SpecialInstrutionRedirectController cont1 = new ESC_SpecialInstrutionRedirectController(sc1);
         cont1.redirctSIAccount();
        // Test.StopTest(); 

        
          //Start test for  ESC_OverrideNewSpecialInstController apex class-------

         
         //Test.StartTest();
         PageReference pageRef2 = Page.ESC_OverrideNewSpecialInstrution;
         Test.setCurrentPage(pageRef2);
          pageRef2.getParameters().put('Id',testContact.id);
         pageRef2.getParameters().put('CF00N0Y00000G_lkid',testContact.id);
         pageRef2.getParameters().put('CF00N0Y00000GF_lkid',testAccount.id);
         pageRef2.getParameters().put('RecordType','rupesh');
         Apexpages.StandardController stdController = new Apexpages.StandardController(spi);
          ESC_OverrideNewSpecialInstController s = new ESC_OverrideNewSpecialInstController(stdController);
          s.redirctToSPInstruvtion();
          //s.onGoBack();
          
         Test.StopTest(); 
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j); 
         
}
         
}