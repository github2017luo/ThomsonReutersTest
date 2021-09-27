@istest(seeAllData=false)
public class LTGS_FetchAccountController_test {

    @IsTest(SeeAllData= false) 
    public static void setaccdata(){
        //insert account data
        Account acc = new Account();
        Acc.name = 'Test account';
        Acc.Phone = '91 80 23456789';
        Acc.BillingCountry = 'IN';
        Acc.BillingState ='GJ';
        Acc.BillingPostalCode = '60603-3801';
        Acc.SAPAccountNumber__c = 'UTSAP002';      
        insert acc;
        
        Contact Cont=new Contact();
        Cont.firstname = 'Steve';
        Cont.lastname = 'Smith';
        Cont.Email = 'Fred@Smith.com';
        Cont.MDB_Contact_ID__c = '1234567890';
        insert Cont;
        
        LTGS_FetchAccountController.getSObjDetails(acc.id,'Account');
        LTGS_FetchAccountController.getSObjDetails(Cont.id,'Contact');
        LTGS_FetchAccountController.getAccList(acc.id);
        LTGS_FetchAccountController.getRecTypeId(acc.id);
        LTGS_FetchAccountController.getCaseRecordTypeID();
    }
    
}