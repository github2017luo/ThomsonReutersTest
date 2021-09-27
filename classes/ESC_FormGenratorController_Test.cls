@isTest
public class ESC_FormGenratorController_Test{
static testmethod void Method1(){
    test.starttest();
    GenerateForm__c form1 = new GenerateForm__c(Name ='IFF Adjustment',LabelName__c='IFF Adjustment',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
    insert form1; 
    Account Acc1 = new Account();
    Contact Con = new Contact();
    Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
    Acc1.BillingCity = 'PORT ANGELES';
            Acc1.BillingCountry ='US';
            Acc1.BillingState = 'WA';
            Acc1.BillingPostalCode = '98363-8409';
            Acc1.BillingStreet = '2851 LOWER ELWHA RD';
    insert Acc1;
    Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
    insert Con;
    Case case1=new Case();
    case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
    insert case1; 
    ApexPages.currentPage().getParameters().put('formid',form1.Id);
    ApexPages.currentPage().getParameters().put('formName',form1.name);
    ApexPages.currentPage().getParameters().put('id',case1.Id);  
    ESC_Section__c TestSection1=new ESC_Section__c(Name='Sec-0049');
    insert TestSection1; 
    //list<string> casevalue= new list<string>();
    Form_Section__c FormEscSec=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=TestSection1.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c =case1.Id );
    insert FormEscSec;  
    string masterQueryparamKey;
    
    masterQueryparamKey =FormEscSec.ESC_QPIdentfier__c;
    
    
    ESC_Section_Special_Events__c secevent= new ESC_Section_Special_Events__c(ESC_URL__c = 'test@test.com',ESC_Field_API__c='ESC_Sales_Org__c',ESC_Section__c=TestSection1.id,ESC_RerenderedSection__c=TestSection1.id,ESC_Value__c='WEST');
    insert secevent;
    ESC_Case_Form_Extension__c Cextn = new ESC_Case_Form_Extension__c(Request_Type_Post_Prod_Lapse__c='Post Pro Lapse - Zero Out Current Month',Correction_Required__c = 'Price Correction',ESC_case__c = case1.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments');
    insert Cextn ;
    ESC_Case_Form_Extension_Line_Item__c ExtLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='Cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test');
    insert ExtLineitem ;
    ESC_FormGenratorController compcon = new ESC_FormGenratorController ();
    ESC_FormGeneratorCompController compconbase = new ESC_FormGeneratorCompController ();
    compconbase.fieldDescpn = new map<String,String>();
    
    List<ESC_FormGeneratorCompController.FieldDescriber> eventsDescribed = new List<ESC_FormGeneratorCompController.FieldDescriber>();   
    ESC_FormGeneratorCompController.FieldDescriber fld = new ESC_FormGeneratorCompController.FieldDescriber();    
    fld.sectionToReRender = secevent.ESC_RerenderedSection__c;
    fld.fieldRerenederValue =secevent.ESC_Value__c;
    fld.url = secevent.ESC_URL__c;
    eventsDescribed.add(fld);
    List<ESC_Case_Form_Extension__c > caseextlist = new List<ESC_Case_Form_Extension__c> ();
    caseextlist.add(cextn);
    ESC_SectionDescriber secdesc= new ESC_SectionDescriber();            
    secdesc.objectname = 'ESC_Case_Form_Extension__c';
    secdesc.isEditableSection = true;
    secdesc.sobj = Cextn ;
    
    secdesc.sobjlist = caseextlist;
    
    compconbase.currentDescribedSection = secdesc;
    compconbase.fieldDescpn.put('ESC_Sales_Org__c',json.serialize(eventsDescribed));
    //compconbase.preDescribedFieldMap.put('ContactId',FieldDescriber:[fieldAPI=null, fieldRerenederValue=xxx, isMandatory=false, labelName=xxx, sectionToReRender=xxx, url=xxx], ContactPhone=FieldDescriber:[fieldAPI=null, fieldRerenederValue=xxx, isMandatory=false, labelName=xxx, sectionToReRender=xxx, url=xxx]} 
    compcon.adderrorMessage();
    compcon.setComponentControllerMap('Sec-0049',compconbase );
    compcon.onloadrerender();
    compcon.saveTheResults();
    compcon.getMyComponentController();
    compcon.setComponentController(compconbase);
    compconbase.key = 'test';
    compconbase.pageController = compcon;
    ESC_SectionDetails secdet = new ESC_SectionDetails();
    secdet.masterRecordID = masterQueryparamKey ;
    secdet.getSectionDetails(cextn.id,'Correction_Required__c','ESC_Case_Form_Extension__c');
    secdet.getSectionDetailsSOBJ(cextn.id,'Correction_Required__c','ESC_Case_Form_Extension__c');
    secdet.getSectionDetailsSOBJ(case1.id,form1.id,'Correction_Required__c','ESC_Case_Form_Extension__c');
    secdet.getSectionDetailsSOBJ(case1.id,form1.id,'Correction_Required__c','ESC_Case_Form_Extension__c');
    secdet.getSectionDetailsSOBJ(case1.id,form1.id,'ESC_Material_Number__c','ESC_Case_Form_Extension_Line_Item__c');
    test.stoptest();
}

}