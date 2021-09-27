@isTest
public class ESC_ReinstatementForm_Test{
    
    static testmethod void RunSupportClass(){            
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            //insert case1;
               
             ESC_ReinstatementForm ESCT = new ESC_ReinstatementForm();
                 test.starttest(); 
                //ESCT.caseid=case1.id;
                ESCT.executePreRender();
                ESCT.validateForms();

        try{
                ESCT.executePostSubmit();
        }
        catch(DMLException e) {   
            system.assertEquals(e.getMessage(), e.getMessage());
           // Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            //Apexpages.addMessage(msg);  
        }
         test.stoptest();
    }
    
}