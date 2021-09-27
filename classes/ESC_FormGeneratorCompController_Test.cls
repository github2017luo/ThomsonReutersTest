@isTest
public class ESC_FormGeneratorCompController_Test{

    static testmethod void Mytestmethod1(){
        test.starttest();
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        ID formid = form1.ID;
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        Acc1.BillingCountry ='US';
            Acc1.BillingState = 'WA';
            Acc1.BillingPostalCode = '98363-8409';
            Acc1.BillingStreet = '2851 LOWER ELWHA RD';
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert case1;
        ID caseid=case1.Id;
        ESC_Section__c TestSection1=new ESC_Section__c(Name='Testsection1',ESC_Referenced_Fieldset__c ='Order_Correction_Form',ESC_Referenced_Object__c ='ESC_Case_Form_Extension__c',ESC_Layout__c='Tabular',ESC_Default_Render__c=false);
        insert TestSection1;
        ESC_Section__c TestSection3=new ESC_Section__c(Name='Testsection1',ESC_Referenced_Fieldset__c ='Revenue_save_form',ESC_Referenced_Object__c ='ESC_Case_Form_Extension_Line_Item__c',ESC_Layout__c='Visual Force',ESC_Default_Render__c=false);
        insert TestSection3;
        ESC_Section__c TestSection2 =new ESC_Section__c(Name='Testsection1',ESC_Referenced_Fieldset__c ='Case_Acc_and_Con_fields',ESC_Referenced_Object__c ='case',ESC_Layout__c='Visual Force',ESC_Visual_Force_Page_Name__c='ESC_Tranfer_Credits');
        insert TestSection2;            
        ESC_Case_Form_Extension__c Cextn = new ESC_Case_Form_Extension__c(Correction_Required__c = 'Price Correction',ESC_case__c = case1.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments');
        insert Cextn ;
        ESC_Case_Form_Extension_Line_Item__c ExtLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='Cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test');
        insert ExtLineitem ;
        Form_Section__c FormEscSec=new Form_Section__c( GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=TestSection1.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c ='id' );
        insert FormEscSec;
        ESC_Section_Field__c secfield= new ESC_Section_Field__c(ESC_Field_API__c='Correction_Required__c',ESC_Mandatory__c=true,ESC_Section__c=TestSection1.id);
        insert secfield;
        ESC_Section_Special_Events__c secevent= new ESC_Section_Special_Events__c(ESC_Field_API__c='ESC_Sales_Org__c',ESC_Section__c=TestSection1.id,ESC_RerenderedSection__c=TestSection1.id,ESC_Value__c='WEST');
        insert secevent;
        List<ESC_Section_Special_Events__c> specialeventlist = new List<ESC_Section_Special_Events__c >();
        specialeventlist.add(secevent);
        ApexPages.currentPage().getParameters().put('id',case1.id);
        ApexPages.currentPage().getParameters().put('formId',form1.id);
        List<Form_Section__c> formseclist = new List<Form_Section__c> ();
        formseclist.add(FormEscSec);
        ESC_SectionDetails secdetails = new ESC_SectionDetails();
        secdetails.allformSections = formseclist;
        secdetails.masterRecord = FormEscSec;
        ESC_SectionDescriber secdesc= new ESC_SectionDescriber();            
        secdesc.objectname = 'ESC_Case_Form_Extension__c';
        secdesc.isEditableSection = true;
        List<string> fieldset = new List<string>();
        secdesc.referencedRecordType = 'Salesorg';
        List<ESC_Case_Form_Extension__c > caseextlist = new List<ESC_Case_Form_Extension__c> ();
        caseextlist.add(cextn);
        secdesc.sobj = Cextn ;
        secdesc.sobjlist = caseextlist;
        ESC_FormGeneratorCompController compcon = new ESC_FormGeneratorCompController();
        compcon.getSobj('ESC_Case_Form_Extension_Line_Item__c',fieldset,'RecordId');
        compcon.sectionIDE = TestSection1.id;
        compcon.fieldval = caseextlist;
        compcon.scd = secdetails;
        secdesc.isInitilaized = false;
        
        compcon.currentDescribedSection = secdesc;
        Apexpages.currentPage().getParameters().put('statusRendered','true');
        compcon.formRerenderCall();
        
        compcon.getSection();
        compcon.populateFieldDescriberMapEvents(specialeventlist);
        
        compcon.imitateFormSubmit();            
        compcon.savecomponent();
        compcon.addrow();
        compcon.rowNumberParam = 1;
        ESC_FormGeneratorCompController.FieldDescriber flddesc = new ESC_FormGeneratorCompController.FieldDescriber(); 
        compcon.delrow();            
        test.stoptest();
    }
    static testmethod void Mytestmethod2(){
        test.starttest();
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        ID formid = form1.ID;
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        Acc1.BillingCountry ='US';
            Acc1.BillingState = 'WA';
            Acc1.BillingPostalCode = '98363-8409';
            Acc1.BillingStreet = '2851 LOWER ELWHA RD';
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert case1;
        ID caseid=case1.Id;
        
        ESC_Section__c TestSection3=new ESC_Section__c(Name='Testsection1',ESC_Referenced_Fieldset__c ='Revenue_save_form',ESC_Referenced_Object__c ='ESC_Case_Form_Extension_Line_Item__c',ESC_Layout__c='Tabular',ESC_Default_Render__c=false);
        insert TestSection3;                       
        ESC_Case_Form_Extension__c Cextn = new ESC_Case_Form_Extension__c(Correction_Required__c = 'Price Correction',ESC_case__c = case1.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments');
        insert Cextn ;
        ESC_Case_Form_Extension_Line_Item__c ExtLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='Cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test');
        insert ExtLineitem ;
        Form_Section__c FormEscSec=new Form_Section__c( GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=TestSection3.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c ='id' );
        insert FormEscSec;
        ESC_Section_Field__c secfield= new ESC_Section_Field__c(ESC_Field_API__c='Correction_Required__c',ESC_Mandatory__c=true,ESC_Section__c=TestSection3.id);
        insert secfield;
        ESC_Section_Special_Events__c secevent= new ESC_Section_Special_Events__c(ESC_Field_API__c='ESC_Sales_Org__c',ESC_Section__c=TestSection3.id,ESC_RerenderedSection__c=TestSection3.id,ESC_Value__c='WEST');
        insert secevent;
        ApexPages.currentPage().getParameters().put('id',case1.id);
        ApexPages.currentPage().getParameters().put('formId',form1.id);
        List<Form_Section__c> formseclist = new List<Form_Section__c> ();
        formseclist.add(FormEscSec);
        ESC_SectionDetails secdetails = new ESC_SectionDetails();
        secdetails.allformSections = formseclist;
        ESC_SectionDescriber secdesc= new ESC_SectionDescriber();            
        secdesc.objectname = 'ESC_Case_Form_Extension_line_item__c';
        secdesc.referencedRecordType = 'Salesorg';
        secdesc.isEditableSection = true;
        list<SObject> sobjlist = new list<SObject>();
        secdesc.setsobjList(sobjlist);
        secdesc.getsobjList();
        secdesc.count = 10;
        secdesc.vfComponentName = 'test';
        List<string> relListName = new List<string>{'AccountTeam'};     
        List<ESC_Case_Form_Extension_Line_Item__c> caseextlist = new List<ESC_Case_Form_Extension_Line_Item__c> ();
        caseextlist.add(ExtLineitem );
        secdesc.sobj = ExtLineitem ;
        secdesc.sobjlist = caseextlist;
        
        ESC_FormGeneratorCompController compcon = new ESC_FormGeneratorCompController();
        compcon.sectionIDE = TestSection3.id;
        compcon.scd = secdetails;
        secdesc.isInitilaized = false;
        compcon.currentDescribedSection = secdesc;
        //compcon.getSobj('ESC_Case_Form_Extension__c',relListName,'RecordId');
        Apexpages.currentPage().getParameters().put('statusRendered','true');
        compcon.formRerenderCall();
        
        compcon.getSection();
        
        Apexpages.currentPage().getParameters().put('rownum','1');
        compcon.imitateFormSubmit(); 
        
        Apexpages.currentPage().getParameters().put('rownum','1'); 
        compcon.imitateFormSubmit();          
        compcon.savecomponent();            
        
        test.stoptest();
    }

}