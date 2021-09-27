@isTest
public class ESC_TaxExemption_Test{
    
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
            insert case1;
            List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
            Group g=[Select Id from Group where name='USL Tax']; 
            ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c(ESC_Role__c = 'Accountable Resolver', ESC_Referral_Status__c = 'New',ESC_Case__c = case1.ID);
            ref.ownerid = g.id;
            referralinsertlist.add(ref);
            insert referralinsertlist;
            
            ESC_TaxExemption ESCT = new ESC_TaxExemption();
            ESCT.executePreRender();
            ESCT.validateForms();
            ESCT.executePostSubmit();
            
        
        }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
    }
    
}