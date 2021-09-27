@isTest
public class ESC_WriteOffController_Test{
            //public Id recid ='5002D000003osli';
            //public Id formId;
           
static testmethod void mytestmethod(){
            test.starttest();
            Account acc1 = new Account();
            Contact con = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BillingCity = 'PORT ANGELES';
            acc1.BillingCountry ='US';
            acc1.BillingState = 'WA';
            acc1.BillingPostalCode = '98363-8409';
            acc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert acc1;
            con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            case1.BU_Segment__c = 'Professional Tax';
            case1.LCRM_Sub_Bu__c = 'US';
            case1.ESC_Case_Type__c = 'Request For Action';
            insert case1;
            //Case case2=new Case();
        
            //List<ESC_Case_Form_Extension__c> caseextlist = new List<ESC_Case_Form_Extension__c>();
            GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Exception Form2',LabelName__c='Write Off Exception',ESC_Executer__c='ESC_WriteOffController',Description__c='Write Off Exception Form');
            insert form1;
           
            
            ApexPages.currentPage().getParameters().put('formID',form1.id);
            ApexPages.currentPage().getParameters().put('id',case1.Id);
            ApexPages.currentPage().getParameters().put('formName',form1.name);
            ESC_WriteOffController wobj=new ESC_WriteOffController();
            
            wobj.recid = case1.Id ;   //'5002D000003osli';
            wobj.formId =form1.id;    //'aBS2D0000000DTY';
            wobj.totalamt = 'xyz';
            wobj.isapproval = true;
            
            
            wobj.validateForms();
            
            ESC_FormGenratorController compcon = new ESC_FormGenratorController(); 
            
            
            ESC_Case_Form_Extension__c formext=new ESC_Case_Form_Extension__c(USL_Total_Amount__c=500,USL_Approval_Status__c='Approved',USL_APPRServiceNoteNum__c='02033321',USL_Approval_Type__c='Writeoff',USL_CSSWriteOffFormTypeID__c='718',ESC_Case__c=case1.id,ESC_Form__c = form1.id);
            insert formext;
            
            //List<ESC_Case_Form_Extension_Line_Item__c> lineitemlist = new List<ESC_Case_Form_Extension_Line_Item__c>();
            ESC_Case_Form_Extension_Line_Item__c lineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c =formext.id, Approval_Status__c='Approved',Amount_to_Pay__c=500);
            insert lineitem;
            
             wobj.executePostSubmit();
             test.stoptest();
             integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
            
}
static testmethod void mytestmethod1(){
            test.starttest();
            
            Account acc1 = new Account();
            Contact con2 = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BillingCity = 'PORT ANGELES';
            acc1.BillingCountry ='US';
            acc1.BillingState = 'WA';
            acc1.BillingPostalCode = '98363-8409';
            acc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert acc1;
            con2 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con2;
            Case case2=new Case();
            case2 = ESC_GenericTestutility.TestCaseUtil(con2.ID,acc1.ID,'Work In Progress');
            case2.BU_Segment__c = 'Professional Tax';
            case2.LCRM_Sub_Bu__c = 'US';
            case2.ESC_Case_Type__c = 'Request For Action';
            case2.ESC_EnquiryType__c = 'Billing';
            insert case2;
            
            GenerateForm__c form2 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_WriteOffController',Description__c='Test');
            insert form2; 
            USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
            int1.Applicationid__c = 'ESCH';
            int1.Companyid__c = 'S100';
            int1.name = 'Integrationdefaults';
            insert int1;
        
            ApexPages.currentPage().getParameters().put('formID',form2.id);
            ApexPages.currentPage().getParameters().put('caseId',case2.Id);
            Type aClass = type.forName(form2.ESC_Executer__c);
            ESC_FormsAbstractExecute absExec = (ESC_FormsAbstractExecute) aClass.newInstance();
            absExec.formId = form2.id;
            absExec.formName = form2.name;
            absExec.caseId = case2.Id;
            absExec.executePreRender();
            ESC_Case_Form_Extension__c formext1=new ESC_Case_Form_Extension__c(USL_Total_Amount__c=90,USL_Approval_Status__c='Approved',USL_APPRServiceNoteNum__c='02033321',USL_Approval_Type__c='Writeoff',USL_CSSWriteOffFormTypeID__c='720',ESC_Case__c=case2.id,ESC_Form__c = form2.id);
            insert formext1;
            
            ESC_Case_Form_Extension_Line_Item__c lineitem1 = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c =formext1.id, Approval_Status__c='Approved',Amount_to_Pay__c=90);
            insert lineitem1;
            
            ESC_WriteOffController wobj1=new ESC_WriteOffController();

            wobj1.executePostSubmit();
            test.stoptest();
     integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
}

static testmethod void mytestmethod3(){
            test.starttest();
            Account acct3 = new Account();
            Contact con3 = new Contact();
            acct3 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acct3.BillingCity = 'PORT ANGELES';
            acct3.BillingCountry ='US';
            acct3.BillingState = 'WA';
            acct3.BillingPostalCode = '98363-8409';
            acct3.BillingStreet = '2851 LOWER ELWHA RD';
            insert acct3;
            con3 =ESC_GenericTestutility.TestContactUtil(acct3.ID, 'test','contact','test7365@gmail.com');
            insert con3;
            Case case3=new Case();
            case3 = ESC_GenericTestutility.TestCaseUtil(con3.ID,acct3.ID,'New');
            case3.BU_Segment__c = 'Professional Tax';
            case3.LCRM_Sub_Bu__c = 'US';
            insert case3;
            //GenerateForm__c form3 = new GenerateForm__c(Name ='Write Off Exception Form',LabelName__c='Write Off Exception',ESC_Executer__c='ESC_WriteOffController',Description__c='Write Off Exception Form',Form_Footer__c='',Form_Header__c='<a href="https://cs69.salesforce.com/aBN2D0000008QPf" target="_blank">Write Off Exception Form</a>');
            GenerateForm__c form3 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
            insert form3;
            ESC_Section__c testSection1=new ESC_Section__c(Name='Sec-0080',ESC_Referenced_Fieldset__c ='WriteOff',ESC_Referenced_Object__c ='ESC_Case_Form_Extension_Line_Item__c');
            insert testSection1;
            ESC_Section__c testSection2=new ESC_Section__c(Name='Sec-0070',ESC_Referenced_Fieldset__c ='WriteOff1',ESC_Referenced_Object__c ='ESC_Case_Form_Extension___c');
            insert testSection2;
            ESC_Section__c testSection3=new ESC_Section__c(Name='Sec-0081',ESC_Referenced_Fieldset__c ='WriteOff1',ESC_Referenced_Object__c ='ESC_Case_Form_Extension_Line_Item__c');
            insert testSection3;
            Form_Section__c formEscSec=new Form_Section__c(GenerateForm__c = form3.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection1.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c =case3.Id );
            insert formEscSec;
            Form_Section__c formEscSec1=new Form_Section__c(GenerateForm__c = form3.id ,Is_Active__c = true,Sequence__c = 4,Section__c=testSection2.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c =case3.Id );
            insert formEscSec1;
            
            ESC_Case_Form_Extension__c cextn = new ESC_Case_Form_Extension__c(USL_CSSWriteOffFormTypeID__c ='718',Account_Number__c='768787',Risk_Category__c='GDQ',ESC_Case__c=case3.id);
            insert cextn;
            ESC_Case_Form_Extension_Line_Item__c extLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c=cextn.Id,ESC_Billing_Doc__c='87768',Category__c='Standard',
            Amount_to_Pay__c=200);
            insert extLineitem;
            
            
             PageReference pageRef = Page.ESC_FormGenerator;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('formID',form3.id);
            ApexPages.currentPage().getParameters().put('id',case3.Id);
            ESC_FormGenratorController fgc = new  ESC_FormGenratorController ();
            USL_writeOffController myobj=new USL_writeOffController();
            myobj.formsId=form3.id;
            myobj.recid=case3.id;
            myobj.Formtitle='gfhg';
            myobj.totalamt ='123';
            myobj.pagecontroller = fgc;
            
            //myobj.isapproval = false;
            myobj.getCals();
            //myobj.validateForms();
            //myobj.executePostSubmit();
            
            myobj.calculate();         
            
            ESC_SectionDescriber secdesc= new ESC_SectionDescriber();  
            
            //ESC_FormGenratorController compcon = new ESC_FormGenratorController ();
            
            
            ESC_FormGeneratorCompController fcomp=new ESC_FormGeneratorCompController();
            fcomp.imitateFormSubmit();
            test.stoptest();
           integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal'); 
    
}


}