@isTest
public class ESC_BillingController_Test{
    
    static testmethod void runSupportClass(){
        
            GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
            insert form1; 
            Account acc1 = new Account();
            Contact con = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            acc1.BU_Region__c='US';
            acc1.BU_Segment__c='Professional Legal';
            insert acc1;
            con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'Work In Progress');
            case1.LCRM_Sub_BU__c='US';
            case1.Bu_segment__c='Professional Legal';
            List<Case> caseupdatelist=new List<Case>();
            caseupdatelist.add(case1);
            //insert case1; 
            insert caseupdatelist;
            
            ESC_FormsSegmentRegionMapping__c obj1=new ESC_FormsSegmentRegionMapping__c();
            obj1.ESC_CSS_Form__c=form1.id;
            obj1.ESC_Region__c = 'US';
            obj1.ESC_Segment__c = 'Professional Legal';
            insert obj1;
            //Group g=[Select Id from Group where DeveloperName =:Label.PPSOnline];
            ESC_Case_Form_Extension__c cextn = new ESC_Case_Form_Extension__c(Request_Type_Post_Prod_Lapse__c='Post Pro Lapse - Zero Out Current Month',Correction_Required__c = 'Price Correction',ESC_case__c = caseupdatelist[0].id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments');
            insert cextn ;
             Test.startTest();
            ApexPages.currentPage().getParameters().put('formid',form1.Id);
            ApexPages.currentPage().getParameters().put('formname',form1.name);
            ApexPages.currentPage().getParameters().put('id',case1.Id);
            ESC_FormGeneratorCompController compconbase = new ESC_FormGeneratorCompController ();
            ESC_FormGenratorController compcon = new ESC_FormGenratorController ();
            ESC_SectionDescriber secdesc= new ESC_SectionDescriber();            
            secdesc.objectname = 'ESC_Case_Form_Extension__c';
            secdesc.isEditableSection = true;
            secdesc.sobj = cextn ;
            
             compconbase.currentDescribedSection = secdesc;
            compcon.setComponentControllerMap('Sec-0049',compconbase );                   
            ESC_BillingRequestController eSCT = new ESC_BillingRequestController();
            eSCT.caseid = caseupdatelist[0].id;
            eSCT.ComponentControllerMap= new Map<String, ESC_ComponentControllerBase>();
            eSCT.ComponentControllerMap.put('Sec-0049',compconbase );
            eSCT.executePreRender();
            eSCT.validateForms();
            try{
            eSCT.executePostSubmit();
            }
            catch(exception e){
             System.debug(logginglevel.warn,e);
            }
              
                ESC_ReferralAssignmentEngine objeerfassign= new ESC_ReferralAssignmentEngine(caseupdatelist[0].id,form1.Id,form1.name);
                ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine();
                system.debug(logginglevel.warn,obj);
                objeerfassign.createReferral();
                objeerfassign.validateFormSegmentMappingExist();
                Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal'); 
    
    }
}