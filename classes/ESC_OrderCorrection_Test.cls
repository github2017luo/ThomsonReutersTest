@isTest
public class ESC_OrderCorrection_Test{
    
    static testmethod void RunSupportClass(){
        
        
     /*      
            
        Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
      
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin2@testorg.com');
      insert u;
      System.runAs(u) { 
     */
       test.starttest() ;  
       Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            insert case1;
             system.debug('case1 :' +case1);
                GenerateForm__C GF= new GenerateForm__C();
            GF.Name='Order Correction 1';
            Insert GF;
            
            system.debug('GF :' +GF);
      
          ESC_Case_Form_Extension__c c =new ESC_Case_Form_Extension__c();
                c.ESC_Case__c=case1.id;
                c.ESC_Form__c=GF.id;
                c.Material_Correction_Required__c='Incorrect Price - Findlaw Only';
             insert c;
             
             ESC_Case_Form_Extension__c c1 =new ESC_Case_Form_Extension__c();
                c1.ESC_Case__c=case1.id;
                c1.ESC_Form__c=GF.id;
                c1.Material_Correction_Required__c='Missing Product';
             insert c1;
             system.debug('Gc :' +c);
             
              ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                    ref.ESC_Role__c = 'Accountable Resolver';
                    ref.ESC_Referral_Status__c = 'New';
                    ref.ESC_Case__c = case1.id;
                    
                    insert ref;
               
             
           ESC_OrderCorrection ESCT = new ESC_OrderCorrection();
            ESCT.caseid = case1.id;
            ESCT.formId = GF.id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
            test.stoptest();  
      }
               
     
        
  //  }
    
}