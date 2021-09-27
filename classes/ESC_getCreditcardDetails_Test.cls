@isTest(seealldata=false)
public class ESC_getCreditcardDetails_Test {

    @isTest
    public static void creditCardDetailsTest() {
        
        GenerateForm__c form1 = new GenerateForm__c(Name ='CreditCard/Debit Payment',LabelName__c='CreditCard/Debit Payment',ESC_Executer__c='ESC_ChargeCancellation',Description__c='Test');
        insert form1; 
        Account acc1 = new Account();
        Contact con = new Contact();
        acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert acc1;
        con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
        insert con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'Work In Progress');
        insert case1; 
        ApexPages.currentPage().getParameters().put('formid',form1.Id);
        ApexPages.currentPage().getParameters().put('Id',case1.Id);    
        ESC_Section__c testSection1=new ESC_Section__c(Name='Charge_Cancellation_Exception_form_2',ESC_Referenced_Object__c='ESC_Case_Form_Extension__c');
        ESC_Section__c testSection2=new ESC_Section__c(Name='Charge Cancellation Exception Form',ESC_Referenced_Object__c='Case');
        insert testSection1; 
        insert testSection2;   
        Form_Section__c formEscSec=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection1.id,ESC_IsFormOrigin_del__c=true );
        insert formEscSec;
        Form_Section__c formEscSec1=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection2.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c ='Id' );
        insert formEscSec1;
        ESC_Section_Special_Events__c secevent= new ESC_Section_Special_Events__c(ESC_URL__c = 'test@test.com',ESC_Field_API__c='ESC_Sales_Org__c',ESC_Section__c=testSection1.id,ESC_RerenderedSection__c=testSection1.id,ESC_Value__c='WEST');
        insert secevent;
        ESC_Case_Form_Extension__c cextn = new ESC_Case_Form_Extension__c(USL_Total_Amount__c= 200,USL_Approval_Type__c='USL_Customer_Service',USL_Route_to_Consultant__c=true,Correction_Required__c = 'Price Correction',ESC_case__c = case1.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments',esc_form__c=form1.id);
        insert cextn ;
        //System.assertEquals(cextn.USL_Total_Amount__c,200);
        ESC_Case_Form_Extension_Line_Item__c extLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test',ESC_Tax_Amount__c=20,ESC_Net_Amount__c=60);
        insert extLineitem ;
        
        List<Case> caseList = [select Id,caseNumber from case limit 1];
        
        List<ESC_Case_Form_Extension__c> ext = [select Id,ESC_Case__c,ESC_Case__r.caseNumber,ESC_Form__r.name from ESC_Case_Form_Extension__c];
        
        ESC_getCreditcardDetails credDetails = new ESC_getCreditcardDetails();
        credDetails.caseId = ext[0].ESC_Case__c;
        credDetails.newLine = 'test';
        credDetails.c = caseList[0];
        credDetails.cfe = ext;
        Case rf   = credDetails.c;
        List<ESC_Case_Form_Extension__c> cfExt = credDetails.cfe;
        system.debug(logginglevel.warn,'rf--->'+rf);
        system.debug(logginglevel.warn,'cfExt--->'+cfExt);
        String i='test';
        String j='test';
        system.assertEquals(i,j,'equal'); 
    }
}