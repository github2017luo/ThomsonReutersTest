@isTest()
public class ESC_FormsLaunchController_Test{
    
    static testmethod void  FormsLaunchControllerTestmethod1(){
        
            string formname='abcd';
            string formid ='dummyid';
            string onlinesubsformid ='dummyid1';
            string printsubsformid ='dummyid2';
            GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_Apply_Cash_Credits',Description__c='Test');
            insert form1;
    
            GenerateForm__c gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
            
           
            GenerateForm__c gform1= new GenerateForm__c();
            gform1.name ='OnlineSubsLapseForm';
            insert gform1;
            
            GenerateForm__c gform2= new GenerateForm__c();
            gform2.name ='PrintSubsLapseForm';
            insert gform2;
            
            GenerateForm__c gform3= new GenerateForm__c();
            gform3.name ='Credit/Debit Payment';
            insert gform3;
            
            
            GenerateForm__c gform4= new GenerateForm__c();
            gform4.name ='Prepayment Form';
            insert gform4;
            
            
            GenerateForm__c gform5 = new GenerateForm__c();
            gform5.name ='IFF Adjustment';
            insert gform5;
            
            GenerateForm__c gform6= new GenerateForm__c();
            gform1.name ='Westlaw Access Control & Preferences';
            insert gform6;
            
             ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform3.Id;
            oForm.ESC_Form_Label_Name__c = 'Credit/Debit Payment';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USLARPaymentPage?';
            oForm.ESC_Region__c ='US';
            oForm.ESC_Segment__c = 'Professional Tax';
            oForm.ESC_Product_Segment_Brand__c = 'Onvio';
            insert oForm;
            
            
            Profile profile = [SELECT Id FROM Profile where Name='TR Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, Segment__c = 'Professional Tax',
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
            
                Test.startTest(); 
                
                Account Acc1 = new Account();
                Contact Contact1 = new Contact();
                Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
                 Acc1.BU_Region__c='US';
                 Acc1.Bu_Segment__c='Professional Tax';
                insert Acc1; 
                Contact1 =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
                insert Contact1;
                Case case1=new Case();
                case1 = ESC_GenericTestutility.TestCaseUtil(Contact1.ID,Acc1.ID,'New');
                case1.ESC_Product_Segment_Brand__c = 'Onvio';
                insert case1;
                ID caseid=case1.Id;
                
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'Credit/Debit Payment';
                caseForm1.esc_form__c = gform3.id;
                caseForm1.ESC_Case__c = case1.Id;
                insert caseForm1;
                        
                ApexPages.StandardController con = new ApexPages.StandardController(case1);
                ESC_FormsLaunchController ins = new ESC_FormsLaunchController(con);
                PageReference p = Page.ESC_FormsLaunchPage;
                p.getParameters().put('formname','Credit/Debit Payment');
                Test.setCurrentPage(p);
                ins.displayform();
                ins.westlawformid='westlawformid';
                ins.ccformid='ccformid';
                ins.isnotfederal=true;                
                
                Test.stopTest();
            }
            
            
     }
     
     static testmethod void  FormsLaunchControllerTestmethod2(){
        
            string formname='abcd';
            string formid ='dummyid';
            string onlinesubsformid ='dummyid1';
            string printsubsformid ='dummyid2';
            GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_Apply_Cash_Credits',Description__c='Test');
            insert form1;
    
            GenerateForm__c gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
            
           
            GenerateForm__c gform1= new GenerateForm__c();
            gform1.name ='OnlineSubsLapseForm';
            insert gform1;
            
            GenerateForm__c gform2= new GenerateForm__c();
            gform2.name ='PrintSubsLapseForm';
            insert gform2;
            
            GenerateForm__c gform3= new GenerateForm__c();
            gform3.name ='Credit/Debit Payment';
            insert gform3;
            
            
            GenerateForm__c gform4= new GenerateForm__c();
            gform4.name ='Prepayment Form';
            insert gform4;
            
            
            GenerateForm__c gform5 = new GenerateForm__c();
            gform5.name ='IFF Adjustment';
            insert gform5;
            
            GenerateForm__c gform6= new GenerateForm__c();
            gform1.name ='Westlaw Access Control & Preferences';
            insert gform6;
            
             ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform5.Id;
            oForm.ESC_Form_Label_Name__c = 'IFF Adjustment';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USLARPaymentPage?';
             oForm.ESC_Product_Segment_Brand__c = 'Onvio';
            //oForm.ESC_Region__c ='US';
            //oForm.ESC_Segment__c = 'Professional Tax';
            insert oForm;
            
            
            Profile profile = [SELECT Id FROM Profile where Name='TR Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
            
                Test.startTest(); 
                
                Account Acc1 = new Account();
                Contact Contact1 = new Contact();
                Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
                 Acc1.BU_Region__c='US';
                 Acc1.Bu_Segment__c='Professional Tax';
                insert Acc1; 
                Contact1 =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
                insert Contact1;
                Case case1=new Case();
                case1 = ESC_GenericTestutility.TestCaseUtil(Contact1.ID,Acc1.ID,'New');
                 case1.ESC_Product_Segment_Brand__c = 'Onvio';
                insert case1;
                ID caseid=case1.Id;
                
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'IFF Adjustment';
                caseForm1.esc_form__c = gform5.id;
                caseForm1.ESC_Case__c = case1.Id;
                insert caseForm1;
                        
                ApexPages.StandardController con = new ApexPages.StandardController(case1);
                ESC_FormsLaunchController ins = new ESC_FormsLaunchController(con);
                PageReference p = Page.ESC_FormsLaunchPage;
                p.getParameters().put('formname','IFF Adjustment');
                Test.setCurrentPage(p);
                ins.displayform();
                ins.westlawformid='westlawformid';
                ins.ccformid='ccformid';
                ins.isnotfederal=true;
                Test.stopTest();
            }
            
            
     }
     
     static testmethod void  FormsLaunchControllerTestmethod3(){
        
            string formname='abcd';
            string formid ='dummyid';
            string onlinesubsformid ='dummyid1';
            string printsubsformid ='dummyid2';
            
                
            
            GenerateForm__c gform6= new GenerateForm__c();
            gform6.name ='Westlaw Access Control & Preferences';
            insert gform6;
            
             ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform6.Id;
            oForm.ESC_Form_Label_Name__c = 'IFF Adjustment';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USLARPaymentPage?';
             oForm.ESC_Product_Segment_Brand__c = 'Onvio';
            //oForm.ESC_Region__c ='US';
            //oForm.ESC_Segment__c = 'Professional Tax';
            insert oForm;
            
            
            Profile profile = [SELECT Id FROM Profile where Name='TR Helpdesk Agent'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
            
                Test.startTest(); 
                
                Account Acc1 = new Account();
                Contact Contact1 = new Contact();
                Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
                 Acc1.BU_Region__c='US';
                 Acc1.Bu_Segment__c='Professional Tax';
                insert Acc1; 
                Contact1 =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
                insert Contact1;
                Case case1=new Case();
                case1 = ESC_GenericTestutility.TestCaseUtil(Contact1.ID,Acc1.ID,'New');
                 case1.ESC_Product_Segment_Brand__c = 'Onvio';
                insert case1;
                ID caseid=case1.Id;
                
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'IFF Adjustment';
                caseForm1.esc_form__c = gform6.id;
                caseForm1.ESC_Case__c = case1.Id;
                insert caseForm1;
                        
                ApexPages.StandardController con = new ApexPages.StandardController(case1);
                ESC_FormsLaunchController ins = new ESC_FormsLaunchController(con);
                PageReference p = Page.ESC_FormsLaunchPage;
                p.getParameters().put('formname','IFF Adjustment');
                Test.setCurrentPage(p);
                
                Test.stopTest();
            }
            
            
     }
     
    
     
    }