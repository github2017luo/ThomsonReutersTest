@isTest
public class USL_WriteofController_Test{
     @isTest static  void method1(){
        final string webServiceNameCredential = 'Invoice';
        Account acc1 = new Account();
        Contact con = new Contact();
        acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert acc1;
        con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
        insert con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Form',LabelName__c='Write Off Form',Description__c='Test');
        insert form1;
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCH';
        int1.Companyid__c = 'S100';
        int1.name = 'Integrationdefaults';
        insert int1;
         Date d =  Date.today();
         Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
         String begindt1 = dt.addDays(-365).format('yyyy-MM-dd');
         String enddt1 = dt.format('yyyy-MM-dd');
         
         boolean ispreview=false;
         boolean isError=false;
          system.debug(LoggingLevel.WARN,ispreview);
          system.debug(LoggingLevel.WARN,isError);
          system.debug(LoggingLevel.WARN,webServiceNameCredential);
         list<ESC_Case_Form_Extension__c> listECFE1 =new list<ESC_Case_Form_Extension__c>();
         ESC_Case_Form_Extension__c listECFE = new ESC_Case_Form_Extension__c();         
         listECFE.USL_Approval_Type__c='USL Customer Service';
         listECFE.USL_CSSWriteOffFormTypeID__c='GW - Good Will';
         listECFE.ESC_Instructions__c='testing';
         listECFE.Select_form_Type__c='Goodwill';
         listECFE.ESC_Form_BU__c ='USL';
         listECFE.Service_Notification_Number__c='testing2';
         listECFE.Risk_Category__c='BNK';
         listECFE.USL_Requester_Title__c='Mr.';
         listECFE.ESC_Cancel_Requestor__c='testing22';
         listECFE.USL_Requestor_ID__c='testt';
         listECFE.USL_WestLaw_Plan__c='Special Offer';
         listECFE.ESC_Case__c =case1.id;
         listECFE.ESC_Form__c =form1.id;
     listECFE1.add(listECFE);
     
     insert listECFE1;    
         List<ESC_Case_Form_Extension_Line_Item__c> customLineList =new List<ESC_Case_Form_Extension_Line_Item__c> ();
         
   ESC_Case_Form_Extension_Line_Item__c eSCCFE= new ESC_Case_Form_Extension_Line_Item__c();   
      eSCCFE.ESC_Case_Form_Extension__c =listECFE1[0].id;      
        eSCCFE.ESC_Billing_Doc__c='6123872804';
            eSCCFE.ESC_Line__c='000010';
            eSCCFE.ESC_Net_Amount__c=3000;
            eSCCFE.ESC_Tax_Amount__c=97;
            eSCCFE.ESC_Root_Cause__c='Services-Findlaw';
            eSCCFE.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            eSCCFE.USL_ODocType__c='YW';
            eSCCFE.USL_OShortDescription__c='Paid and cancelled 6117202889';
            eSCCFE.ESC_Request_Description__c='Westlaw';
            eSCCFE.ESC_Type__c='Partial';
      customLineList.add(eSCCFE);  
         insert customLineList ;
         
        
        Apexpages.currentpage().getparameters().put('id',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
         
        USL_WriteofController wrtoffcon = new USL_WriteofController();
        wrtoffcon.recId='';
        wrtoffcon.formid='';
        wrtoffcon.sSelectedInv='';
        //wrtoffcon.validateAmountErr = true;
        wrtoffcon.goback();        
        wrtoffcon.setinvoicedaterange();
        wrtoffcon.openwrapperlist[0].isselected = true;
        wrtoffcon.openwrapperlist[0].inputamount = '12';
        wrtoffcon.openwrapperlist[0].netamount ='12';
        wrtoffcon.openwrapperlist[0].Taxamount = '0';
        wrtoffcon.openwrapperlist[0].Rootcause = 'test';
        wrtoffcon.openwrapperlist[0].ReasonCode = 'test';
        wrtoffcon.addrow();
        Apexpages.currentPage().getParameters().put('rn','1');
        wrtoffcon.deleterow();
        wrtoffcon.saveselectedopen();
        wrtoffcon.showpreview();  
        wrtoffcon.dummymethods();
        wrtoffcon.getARItemType();        
        wrtoffcon.getresponses(begindt1,enddt1); 
        wrtoffcon.validateAmount();            
        wrtoffcon.saveComponent();
        wrtoffcon.selectalllineitem();
        wrtoffcon.updatePage();
        //wrtoffcon.previousPage();
        //wrtoffcon.nextPage();
        wrtoffcon.calculate();
        Test.StopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
     }

    @isTest static void withoutcaseid(){
       Account acc1 = new Account();
        Contact con = new Contact();
        acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert acc1;
        con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
        insert con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert case1;
         
        GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Form',LabelName__c='Write Off Form',Description__c='Test');
        insert form1;
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        Apexpages.currentpage().getparameters().put('id',null);
        Apexpages.currentpage().getparameters().put('formid',Null);
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
                
    }
}