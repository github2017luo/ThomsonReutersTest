@isTest
public class ESC_WPkDealCreation_Test{
    
    static testmethod void RunSupportClass(){
        
       
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            insert case1;
            
            ESC_WPkDealCreation ESCT = new ESC_WPkDealCreation();
            ESCT.caseid=case1.id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
        
    }
    
}