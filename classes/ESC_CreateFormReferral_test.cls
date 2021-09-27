@isTest()
public class ESC_CreateFormReferral_test{
    
    static testmethod void  createFormReferralTestmethod1(){
           Profile profile = [SELECT Id FROM Profile where Name='GLI Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
        
                       
            Test.startTest(); 
                
            Account acc1 = new Account();
            Contact contact1 = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BU_Region__c='UKI';
            //acc1.Bu_Segment__c='';
            insert acc1; 
            contact1 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert contact1;
            List<Case> case1=new List<Case>();
            Case testcase= new case();
            testcase= ESC_GenericTestutility.TestCaseUtil(contact1.ID,acc1.ID,'New');
            testcase.LCRM_Sub_BU__c='UKI';
            testcase.BU_Segment__c='';
            testcase.Subject='Test Subject';
            testcase.Description = 'Test Description111';
            case1.add(testcase);
            insert case1;
                
            System.assertEquals(testcase.status, 'New','Invalid Status');
                
            ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
            cc.OwnerId = user.id;
            cc.ESC_Case__c = testcase.id;
            cc.ESC_Role__c = 'Accountable Resolver';
            cc.ESC_referral_status__c = 'New';
            cc.ESC_Form_Name__c ='Write Off Form';
            cc.OwnerId=userInfo.getuserid();
            insert cc;
                           
            GenerateForm__c gform1= new GenerateForm__c();
            gform1.name ='Write Off Form';
            insert gform1;
            
           
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'Write Off Form';
                caseForm1.esc_form__c = gform1.id;
                caseForm1.ESC_Case__c = testcase.Id;
                caseform1.USL_Approval_Type__c ='Writeoff';
                insert caseForm1;
                
            GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Form',LabelName__c='Write Off Form',Description__c='Test');
            insert form1;
             
           // GenerateForm__c gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
            
           
            
            
            ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform1.Id;
            oForm.ESC_Form_Label_Name__c = 'Write Off Form';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USL_WriteoffPage?Id=';
            oForm.ESC_Region__c ='UKI';
            oForm.ESC_Segment__c = '';
            insert oForm;
            
           
           System.assertEquals(oForm.ESC_Form_Label_Name__c, 'Write Off Form','Invalid label Name'); 
                
                ESC_CreateFormReferral.createFormReferral(case1);
                
                Test.stopTest();
            }
    }
         static testmethod void  createFormReferralTestmethod2(){
           Profile profile = [SELECT Id FROM Profile where Name='GLI Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
        
                       
            Test.startTest(); 
                
            Account acc1 = new Account();
            Contact contact1 = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BU_Region__c='UKI';
            //acc1.Bu_Segment__c='';
            insert acc1; 
            contact1 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert contact1;
            List<Case> case1=new List<Case>();
            Case testcase= new case();
            testcase= ESC_GenericTestutility.TestCaseUtil(contact1.ID,acc1.ID,'New');
            testcase.LCRM_Sub_BU__c='UKI';
            testcase.BU_Segment__c='';
            testcase.Subject='Test Subject';
            testcase.Description = 'Test Description111';
            case1.add(testcase);
            insert case1;
                
            ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
            cc.OwnerId = user.id;
            cc.ESC_Case__c = testcase.id;
            cc.ESC_Role__c = 'Accountable Resolver';
            cc.ESC_referral_status__c = 'New';
            cc.ESC_Form_Name__c ='Charge cancellation';
            cc.OwnerId=userInfo.getuserid();
            insert cc;
                           
            GenerateForm__c gform1= new GenerateForm__c();
            gform1.name ='Write Off Form';
            insert gform1;
            
           
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'Write Off Form';
                caseForm1.esc_form__c = gform1.id;
                caseForm1.ESC_Case__c = testcase.Id;
                caseform1.USL_Approval_Type__c ='Writeoff';
                insert caseForm1;
                
            GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Form',LabelName__c='Write Off Form',Description__c='Test');
            insert form1;
             
            //GenerateForm__c gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
            
           
            
            
             ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform1.Id;
            oForm.ESC_Form_Label_Name__c = 'Write Off Form';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USL_WriteoffPage?Id=';
            oForm.ESC_Region__c ='UKI';
            oForm.ESC_Segment__c = '';
            insert oForm;
            System.assertEquals(oForm.ESC_Form_Label_Name__c, 'Write Off Form','Invalid Status');            
           
            
                
                ESC_CreateFormReferral.createFormReferral(case1);
                
                Test.stopTest();
            }
     }
     static testmethod void  createFormReferralTestmethod4(){
           Profile profile = [SELECT Id FROM Profile where Name='USL Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
        
                       
            Test.startTest(); 
                
            Account  acc1 = new Account();
            Contact contact1 = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BU_Region__c='USL';
            //acc1.Bu_Segment__c='';
            insert acc1; 
            contact1 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert contact1;
            List<Case> case1=new List<Case>();
            Case testcase= new case();
            testcase= ESC_GenericTestutility.TestCaseUtil(contact1.ID,acc1.ID,'New');
            testcase.LCRM_Sub_BU__c='USL';
            testcase.BU_Segment__c='';
            testcase.Subject='Test Subject';
            testcase.Description = 'Test Description111';
            case1.add(testcase);
            insert case1;
                
            /*ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
            cc.OwnerId = user.id;
            cc.ESC_Case__c = testcase.id;
            cc.ESC_Role__c = 'Accountable Resolver';
            cc.ESC_referral_status__c = 'New';
            cc.ESC_Form_Name__c ='Writeoff';
            cc.OwnerId=userInfo.getuserid();
            insert cc;*/
                           
            GenerateForm__c gform1= new GenerateForm__c();
            gform1.name ='Write Off Form';
            insert gform1;
            
           
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'Write Off Form';
                caseForm1.esc_form__c = gform1.id;
                caseForm1.ESC_Case__c = testcase.Id;
                caseform1.USL_Approval_Type__c ='Writeoff';
                insert caseForm1;
                
            GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Form',LabelName__c='Write Off Form',Description__c='Test');
            insert form1;
                System.assertEquals(caseForm1.name, 'Write Off Form','Invalid Name');
             
           // GenerateForm__c gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
                
                ESC_CreateFormReferral.createFormReferral(case1);
                
                Test.stopTest();
            }
     }
     static testmethod void  createFormReferralTestmethod3(){
           Profile profile = [SELECT Id FROM Profile where Name='GLI Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
        
                       
            Test.startTest(); 
                
            Account  acc1= new Account();
            Contact contact1 = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BU_Region__c='UKI';
            //acc1.Bu_Segment__c='';
            insert acc1; 
            contact1 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert contact1;
            List<Case> case1=new List<Case>();
            Case testcase= new case();
            testcase= ESC_GenericTestutility.TestCaseUtil(contact1.ID,acc1.ID,'New');
            testcase.LCRM_Sub_BU__c='UKI';
            testcase.BU_Segment__c='';
            testcase.Subject='Test Subject';
            testcase.Description = 'Test Description111';
            case1.add(testcase);
            insert case1;
                
            ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
            cc.OwnerId = user.id;
            cc.ESC_Case__c = testcase.id;
            cc.ESC_Role__c = 'Accountable Resolver';
            cc.ESC_referral_status__c = 'New';
            cc.ESC_Form_Name__c ='TRTA Corp Form';
            cc.OwnerId=userInfo.getuserid();
            insert cc;
                           
            GenerateForm__c gform1= new GenerateForm__c();
            gform1.name ='TRTA Corp Form';
            insert gform1;
            
           
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'TRTA Corp Form';
                caseForm1.esc_form__c = gform1.id;
                caseForm1.ESC_Case__c = testcase.Id;
                caseform1.USL_Approval_Type__c ='TRTA_Corporates';
                insert caseForm1;
                
            GenerateForm__c form1 = new GenerateForm__c(Name ='TRTA Corp Form',LabelName__c='TRTA Corp Form',Description__c='Test');
            insert form1;
             
        //    GenerateForm__c gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
            
           
            
            
             ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform1.Id;
            oForm.ESC_Form_Label_Name__c = 'TRTA Corp Form';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USL_WriteoffPage?Id=';
            oForm.ESC_Region__c ='UKI';
            oForm.ESC_Segment__c = '';
            insert oForm;
            
           
            
                
                ESC_CreateFormReferral.createFormReferral(case1);
                
                Test.stopTest();
            }
     }
     
     
     }