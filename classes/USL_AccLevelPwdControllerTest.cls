@isTest
public class USL_AccLevelPwdControllerTest {
    
    static testMethod void testAccLevelPwdController(){
        case c = new Case();
        insert c;
       	GenerateForm__c cf = new GenerateForm__c();
        insert cf;
        case c1 = new Case();
        insert c1;
       	GenerateForm__c cf1 = new GenerateForm__c();
        insert cf1;
        
       //List<ESC_Case_Form_Extension__c> cflist= new List<ESC_Case_Form_Extension__c>();
        
        ESC_Case_Form_Extension__c cfe = new ESC_Case_Form_Extension__c();
        cfe.ESC_Case__c = c.id;
        cfe.ESC_Form__c = cf.id;
        cfe.USL_Concurrent_Access__c = 'Yes';
        cfe.Share_Folders__c = 'Yes';
        cfe.Westlaw_LT__c = 'Yes';
        cfe.LSI_Web_Import__c = 'Yes';
        cfe.Display_Out_of_Plan_Icon__c = 'Yes';
        cfe.Skip_Out_of_Plan__c = 'Yes';
        cfe.Folder_Billing_Option__c = 'I PAY YOU PAY';
        cfe.Detail_Other_Westlaw_Access_Control__c = 'true';
        cfe.ProDoc_Web_Import__c = 'Yes';
        cfe.Max_Concurrent_Access__c = '2';
        cfe.Print_Billing_Option__c = 'Document';
        cfe.Usage_Billing_Option__c = 'Ask at Sign-on';
        cfe.Detail_Other_Westlaw_Preferences__c = 'true';
        Insert cfe;
        
              
        ESC_Case_Form_Extension_Line_Item__c cfeli = new ESC_Case_Form_Extension_Line_Item__c();
        cfeli.ESC_Case_Form_Extension__c=cfe.id;
        insert cfeli;
        List<ESC_Case_Form_Extension_Line_Item__c> cflilist= new List<ESC_Case_Form_Extension_Line_Item__c>();
        cflilist.add(cfeli);
        Test.startTest();
        PageReference pageRef = Page.USL_AccLevelPwdForm;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('caseid', c.id);
        ApexPages.currentPage().getParameters().put('formId', cf.id);
        ApexPages.currentPage().getParameters().put('sn', 'USL_Concurrent_Access__c');
        ApexPages.currentPage().getParameters().put('sename', 'USL_Concurrent_Access__c');
        ApexPages.currentPage().getParameters().put('secn', 'USL_Concurrent_Access__c');
        ApexPages.currentPage().getParameters().put('rn', '0');
        USL_AccLevelPwdController uspc= new USL_AccLevelPwdController();
        uspc.userFldmap.put('USL_Concurrent_Access__c','USL_All_Users_CA__c');
        uspc.SecheaderMap.put('USL_Concurrent_Access__c','USL_All_Users_CA__c');
        uspc.option1=true;
        uspc.Showsec();
        uspc.validate();
        uspc.iserror=false;
        uspc.Submit();
        uspc.usertoggle();
        uspc.hidesec('USL_Concurrent_Access__c',true);
        uspc.Tablemap.put('USL_Concurrent_Access__c',cflilist);
        uspc.addRow();
        uspc.deleteRow();
        Test.stopTest();
      
      
    }
    static testMethod void testmethod2(){
        case c = new Case();
        insert c;
       	GenerateForm__c cf = new GenerateForm__c();
        insert cf;
        case c1 = new Case();
        insert c1;
       	GenerateForm__c cf1 = new GenerateForm__c();
        insert cf1;
        
       //List<ESC_Case_Form_Extension__c> cflist= new List<ESC_Case_Form_Extension__c>();
        
        ESC_Case_Form_Extension__c cfe = new ESC_Case_Form_Extension__c();
        cfe.ESC_Case__c = c.id;
        cfe.ESC_Form__c = cf.id;
        cfe.USL_Concurrent_Access__c = 'Yes';
        cfe.Share_Folders__c = 'Yes';
        cfe.Westlaw_LT__c = 'Yes';
        cfe.LSI_Web_Import__c = 'Yes';
        cfe.Display_Out_of_Plan_Icon__c = 'Yes';
        cfe.Skip_Out_of_Plan__c = 'Yes';
        cfe.Folder_Billing_Option__c = 'I PAY YOU PAY';
        cfe.Detail_Other_Westlaw_Access_Control__c = 'true';
        cfe.ProDoc_Web_Import__c = 'Yes';
        cfe.Max_Concurrent_Access__c = '2';
        cfe.Print_Billing_Option__c = 'Document';
        cfe.Usage_Billing_Option__c = 'Ask at Sign-on';
        cfe.Detail_Other_Westlaw_Preferences__c = 'true';
        cfe.USL_All_Users_CA__c='No';
        Insert cfe;
        
              
        ESC_Case_Form_Extension_Line_Item__c cfeli = new ESC_Case_Form_Extension_Line_Item__c();
        cfeli.ESC_Case_Form_Extension__c=cfe.id;
        insert cfeli;
        
        Test.startTest();
        PageReference pageRef = Page.USL_AccLevelPwdForm;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('caseid', c.id);
        ApexPages.currentPage().getParameters().put('formId', cf.id);
        ApexPages.currentPage().getParameters().put('sn', 'USL_Concurrent_Access__c');
        ApexPages.currentPage().getParameters().put('sename', 'USL_Concurrent_Access__c');
        ApexPages.currentPage().getParameters().put('rn', '0');
        USL_AccLevelPwdController uspc= new USL_AccLevelPwdController();
        uspc.option2=true;
        uspc.Showsec();
        uspc.option3=true;
        uspc.Showsec();
        uspc.option3=true;
        uspc.Showsec();
        uspc.option4=true;
        uspc.Showsec();
        uspc.option5=true;
        uspc.Showsec();
        uspc.option6=true;
        uspc.Showsec();
        uspc.option7=true;
        uspc.Showsec();
        
        uspc.userFldmap.put('USL_Concurrent_Access__c','USL_All_Users_CA__c');
        uspc.SecheaderMap.put('USL_Concurrent_Access__c','USL_All_Users_CA__c');
        uspc.Tablemap.put('USL_Concurrent_Access__c',new List<ESC_Case_Form_Extension_Line_Item__c>{cfeli});
        uspc.validate();
        uspc.Submit();
        uspc.usertoggle();
        uspc.hidesec('USL_Concurrent_Access__c',true);
        Test.stopTest();
      
      
    }
}