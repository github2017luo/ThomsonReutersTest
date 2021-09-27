/********************************************************************************************************
@description LTGS_NewCaseButtonController_Test
@comment Apex class .
@return None
********************************************************************************************************/  
@istest(seeAllData=false)
public class LTGS_NewCaseButtonController_Test {
    
   /********************************************************************************************************
@description setdata
@comment Apex class testMethod.

********************************************************************************************************/ 
    static testMethod void setdata(){
        //insert account data
        Account acc = new Account();
        Acc.name = 'Test account';
        Acc.Phone = '91 80 23456789';
        Acc.BillingCountry = 'IN';
        Acc.BillingState='GJ';
        Acc.BillingPostalCode = '60603-3801';
        Acc.SAPAccountNumber__c = 'UTSAP002';      
        insert acc;
        
        Contact cont=new Contact();
        cont.firstname = 'Steve';
        cont.lastname = 'Smith';
        cont.Email = 'Fred@Smith.com';
        cont.MDB_Contact_ID__c = '1234567890';
        cont.AccountId = acc.Id;
        insert cont;
        System.assertEquals(true, cont!=null, 'Case from Account');
        LTGS_NewCaseButtonController.fetchRecordTypeValues('Account');
        LTGS_NewCaseButtonController.getCurrentUserProfile();
        LTGS_NewCaseButtonController.executeProfiles();
        LTGS_NewCaseButtonController.getParentAccountId(String.valueOf(cont.Id));
      
}
}