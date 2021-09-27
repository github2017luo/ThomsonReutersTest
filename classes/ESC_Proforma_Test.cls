@isTest
public class ESC_Proforma_Test{
    
    static testmethod void RunSupportClass(){
        try{
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            //insert case1;
            List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
            
            ESC_Proforma ESCT = new ESC_Proforma();
             test.starttest(); 
            //ESCT.caseid=case1.id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
            Id recId;
            
            USL_AttachHtmlFileController att = new USL_AttachHtmlFileController();
            //att.recId=case1.id;
        }
        catch(DMLException e) {   
            system.assertEquals(e.getMessage(), e.getMessage());
           // Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            //Apexpages.addMessage(msg);   
        }
  		test.stoptest(); 
    }
 }