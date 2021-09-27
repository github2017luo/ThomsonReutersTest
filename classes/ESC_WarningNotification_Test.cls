@isTest
public class ESC_WarningNotification_Test{
    
    static testmethod void RunSupportClass(){
        
        
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            case1.Bu_segment__c ='';
            case1.LCRM_Sub_BU__c = 'USL';
            insert case1; 
            
            GenerateForm__c form1 = new GenerateForm__c(Name ='Warning Notification',LabelName__c='Warning Notification',Description__c='Test');
            insert form1;
             
            GenerateForm__c gForm1 = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
           
            ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform1.Id;
            oForm.ESC_Form_Label_Name__c = 'Warning Notification';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/ESC_FormGenerator?id=';
            oForm.ESC_Region__c ='USL';
            oForm.ESC_Segment__c = '';
            insert oForm;
            
            ESC_Referral_Form_Assign_Selector_List__c oref = new ESC_Referral_Form_Assign_Selector_List__c();
            oref.ESC_Form_Field1__c = 'Warning Notification';
            oref.ESC_Referral_Queue_Name__c = 'USL_EBO_USL_Entitlement_Passwords';
            oref.Referral_Creation_Required__c = true;
            oref.Form_Segment_Region_Id__c = oForm.id;
            insert oref;
            
            ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(case1.id,gForm1.id,gForm1.name);                  
           
           
            Test.startTest();
           
            ESC_WarningNotification ESCT = new ESC_WarningNotification();
            ESCT.caseid = case1.id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
              
            Test.stopTest();
        
        
    }
    static testmethod void RunSupportClass1(){
        
        
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            case1.Bu_segment__c ='';
            case1.LCRM_Sub_BU__c = 'USL';
            //insert case1; 
            
            GenerateForm__c form1 = new GenerateForm__c(Name ='Warning Notification',LabelName__c='Warning Notification',Description__c='Test');
            insert form1;
             
            GenerateForm__c gForm1 = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :form1.id ];
           
            ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = gform1.Id;
            oForm.ESC_Form_Label_Name__c = 'Warning Notification';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/ESC_FormGenerator?id=';
            oForm.ESC_Region__c ='USL';
            oForm.ESC_Segment__c = '';
            insert oForm;
            
            ESC_Referral_Form_Assign_Selector_List__c oref = new ESC_Referral_Form_Assign_Selector_List__c();
            oref.ESC_Form_Field1__c = 'Warning Notification';
            oref.ESC_Referral_Queue_Name__c = 'USL_EBO_USL_Entitlement_Passwords';
            oref.Referral_Creation_Required__c = true;
            oref.Form_Segment_Region_Id__c = oForm.id;
            insert oref;
            
           // ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(case1.id,gForm1.id,gForm1.name);                  
           
            ESC_WarningNotification ESCT = new ESC_WarningNotification();
            ESCT.caseid = case1.id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
             try{
                system.debug('HI');
            }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
        
        
    }
    
}