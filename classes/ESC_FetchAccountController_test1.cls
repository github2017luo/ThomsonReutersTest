@istest(seeAllData=false)
public class ESC_FetchAccountController_test1{

 @IsTest(SeeAllData= false) 
    public static void setaccdata(){
        //insert account data
        Account acc = new Account();
        Acc.name = 'Test account';
        Acc.Phone = '91 80 23456789';
        Acc.BillingCountry = 'KP';
        Acc.BillingState='IL';
        Acc.BillingPostalCode = '60603-3801';
        Acc.SAPAccountNumber__c = 'UTSAP002';      
        insert acc;
        
        Contact Cont=new Contact();
        Cont.firstname = 'Steve';
        Cont.lastname = 'Smith';
        Cont.Email = 'Fred@Smith.com';
        Cont.MDB_Contact_ID__c = '1234567890';
        insert Cont;
        
       List<ESC_Special_Instruction__c> splinstlist = new List<ESC_Special_Instruction__c>();
        ESC_Special_Instruction__c splinst = new ESC_Special_Instruction__c();
        splinst.ESC_Account__c = acc.Id;
        splinst.ESC_Category_Account__c = 'No Remote Support';
        splinst.ESC_Detailed_Instructions__c = 'Special Instruction detail';
        splinst.ESC_Status__c = 'Active';
        splinstlist.add(splinst);
           insert splinstlist;
        
        ESC_FetchAccountController.getSObjDetails(acc.id,'Account');
        ESC_FetchAccountController.getSObjDetails(Cont.id,'Contact');
        ESC_FetchAccountController.getAccList(acc.id);
        ESC_FetchAccountController.getRecTypeId(acc.id);
        ESC_FetchAccountController.getRecordTypeId();
        ESC_FetchAccountController.getCaseRecordTypeID();
    }
}