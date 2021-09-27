@isTest
public class ESC_RevenueSaveForm_Test{
    
    static testmethod void RunSupportClass(){
        
        List<Case> caseupdatelist=new List<Case>();
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            insert case1;
            
            //Group g=[Select Id from Group where name='USL Subscription Team']; 
                       
            ESC_RevenueSaveForm ESCT = new ESC_RevenueSaveForm();
            ESCT.caseid = case1.id;
            //case1.OwnerId = g.Id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
            
        
        
         try{
            
            system.debug('HI');
        }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
    }
    
    static testmethod void RunSupportClass1(){
        
        List<Case> caseupdatelist=new List<Case>();
            Account Acc1 = new Account();
            Contact Con = new Contact();
            Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert Acc1;
            Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
            insert Con;
            Case case1=new Case();
            case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'Work In Progress');
            //insert case1;
            
            //Group g=[Select Id from Group where name='USL Subscription Team']; 
                       
            ESC_RevenueSaveForm ESCT = new ESC_RevenueSaveForm();
            ESCT.caseid = case1.id;
            //case1.OwnerId = g.Id;
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
            
        
        
         try{
            
            system.debug('HI');
        }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
    }
    
}