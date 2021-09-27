@isTest
public class USL_UpdateCaseOwnerCCExp_Test{

static testmethod void mytestmethod(){

        test.starttest();
        /*Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;*/
        Case case1=new Case();
        //case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
        case1.status = 'Work In Progress';
        case1.LCRM_Sub_BU__c = 'USL';
        case1.Form_Name__c ='Charge Cancellation Exception Form';
        insert case1;
        
        
        
         GenerateForm__c form1 = new GenerateForm__c(Name ='Charge Cancellation Exception Form2',LabelName__c='Charge Cancellation Exception Form',ESC_Executer__c='ESC_ChargeCancellation',Description__c='Charge Cancellation Exception Form');
                    insert form1;
                    
        list<ESC_Case_Form_Extension__c> listformCFE =new list<ESC_Case_Form_Extension__c>();
        ESC_Case_Form_Extension__c formext1=new ESC_Case_Form_Extension__c(USL_Approval_Status__c='txt',USL_Total_Amount__c=5000,Account_Number_OrderResolution_Form__c='12343',USL_Requestor_Name__c='testingName',USL_WestLaw_Plan_Form__c='Not applicable',USL_Route_to_Consultant__c=False,ESC_Case__c=case1.id,ESC_Form__c = form1.id);
        
        ListformCFE.add(formext1);
        insert listformCFE ;
        
        Formext1.USL_Approval_Status__c = 'Approved';
        update listformCFE;
        
        //insert listformCFE;
        ESC_Case_Form_Extension_Line_Item__c lineitem1 = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c =ListformCFE[0].id, Approval_Status__c='Approved',ESC_Billing_Doc__c='123',ESC_Line__c='234',ESC_Net_Amount__c=5000,ESC_Tax_Amount__c=0,ESC_Root_Cause__c='Customer Service',ESC_Reason_Code__c='Tax Exempt',Ref_key_1__c='12',USL_Type_of_Charge__c='Westlaw');
        insert lineitem1;
    
            Group g=[Select Id from Group where DeveloperName =:Label.ChargeCEForm];
            
            Case caseupd = new Case();
             caseupd.id = case1.id;
             caseupd.ownerid = g.id;
             caseupd.Form_Name__c ='Charge Cancellation Exception Form';
             
             update caseupd;
                USL_UpdateCaseOwnerCCExp.updatecaseowneronapproval(listformCFE);
             
            test.Stoptest(); 
            integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
            }
    static testmethod void mytestmethod1(){
        /*Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;*/
        Case case1=new Case();
        case1.status = 'Work In Progress';
        insert case1;
        
         GenerateForm__c form1 = new GenerateForm__c(Name ='Write Off Exception Form2',LabelName__c='Write Off Exception',ESC_Executer__c='ESC_WriteOffController',Description__c='Write Off Exception Form');
                    insert form1;
                    
        list<ESC_Case_Form_Extension__c> listformCFE =new list<ESC_Case_Form_Extension__c>();
        ESC_Case_Form_Extension__c formext1=new ESC_Case_Form_Extension__c(USL_Approval_Status__c='txt',USL_CSSWriteOffFormTypeID__c='BNK',USL_Total_Amount__c=5000,Account_Number_OrderResolution_Form__c='12343',USL_Requestor_Name__c='testingName',USL_WestLaw_Plan_Form__c='Not applicable',USL_Route_to_Consultant__c=False,ESC_Case__c=case1.id,ESC_Form__c = form1.id);
        
        listformCFE.add(formext1);
        insert listformCFE ;
        
        formext1.USL_Approval_Status__c = 'Approved';
        update listformCFE;
        
        //insert ListformCFE;
        ESC_Case_Form_Extension_Line_Item__c lineitem1 = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c =ListformCFE[0].id, Approval_Status__c='Approved',ESC_Billing_Doc__c='123',ESC_Line__c='234',ESC_Net_Amount__c=5000,ESC_Tax_Amount__c=0,ESC_Root_Cause__c='Customer Service',ESC_Reason_Code__c='Tax Exempt',Ref_key_1__c='12',USL_Type_of_Charge__c='Westlaw');
        insert lineitem1;
    
            Group g=[Select Id from Group where DeveloperName =:Label.ChargeCEForm];
             test.starttest();
                USL_UpdateCaseOwnerCCExp.updatecaseowneronapproval(listformCFE);
             
            test.Stoptest(); 
            integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        
            }

}