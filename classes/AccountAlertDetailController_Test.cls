@isTest
public class AccountAlertDetailController_Test{

    @testSetup static void setup() {
        /*
        Embargoed_Country_List__c ebbargoedCountry = new  Embargoed_Country_List__c();
        ebbargoedCountry.Name = 'KP';
        insert ebbargoedCountry;
        */
        List<Account> accList = new List<Account>();
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        accList.add(gliAccount);
        
        Account embargoedAccount = UnitTest.getAccountInstance();
        embargoedAccount.Name = 'Test Embargoed Account';
        embargoedAccount.Phone = '91 80 67254199';
        embargoedAccount.BillingCountry = 'IN';
        embargoedAccount.BillingState='GJ';
        embargoedAccount.BillingPostalCode = '60603-3801';
        embargoedAccount.SAPAccountNumber__c = 'UTSAP002';
        //embargoedAccount.Sanctioned_Status__c = 'No Sanctions';
        embargoedAccount.LCRM_Embargoed_Account__c = true;
        accList.add(embargoedAccount);
        
        insert accList;
    }
    public static testMethod void testAccWithAccAlert() {
    Account gliAccount = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
    
    List <Account_Alert__c> accAlertList = new List<Account_Alert__c>();
    
    Account_Alert__c accAlertSales1 = new Account_Alert__c(Account__c = gliAccount.Id, Active_Alert__c = true, Account_Alert_Expiry__c = Date.today().addDays(2), Alert_Subject__c = 'AR Hold', Sub_BU__c = 'All', Alert_Category__c = 'Sales');
    
    Account_Alert__c accAlertSales2 = new Account_Alert__c(Account__c = gliAccount.Id, Active_Alert__c = true, Account_Alert_Expiry__c = Date.today().addDays(2), Alert_Subject__c = 'AR Hold', Sub_BU__c = 'All', Alert_Category__c = 'Sales');
    
    Account_Alert__c accAlertGovernance = new Account_Alert__c(Account__c = gliAccount.Id, Active_Alert__c = true, Account_Alert_Expiry__c = Date.today().addDays(2), Alert_Subject__c = 'AR Hold', Sub_BU__c = 'All', Alert_Category__c = 'Governance');
    
    Account_Alert__c accAlertFinancial = new Account_Alert__c(Account__c = gliAccount.Id, Active_Alert__c = true, Account_Alert_Expiry__c = Date.today().addDays(2), Alert_Subject__c = 'AR Hold', Sub_BU__c = 'All', Alert_Category__c = 'Financial');
    
    accAlertList.add(accAlertSales1);
    accAlertList.add(accAlertSales2);
    accAlertList.add(accAlertGovernance);
    accAlertList.add(accAlertFinancial);
    
    Database.Insert(accAlertList);
    
    Test.startTest(); 
        PageReference oPage = Page.AccountAlertDetail;
        Test.setCurrentPage(oPage);
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(gliAccount);  
        AccountAlertDetailController controller = new AccountAlertDetailController(oStandardController);
        System.assertEquals(4, [SELECT Id FROM Account_Alert__c WHERE Account__c =: gliAccount.Id].Size());
    Test.stopTest();
    }
    
    public static testMethod void testAccWithoutAccAlert() {
    Account gliEmbargoedAccount = [SELECT Id FROM Account WHERE Name='Test Embargoed Account' LIMIT 1];
    
    Test.startTest(); 
        PageReference oPage = Page.AccountAlertDetail;
        Test.setCurrentPage(oPage);
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(gliEmbargoedAccount);  
        AccountAlertDetailController controller = new AccountAlertDetailController(oStandardController);
        System.assertEquals(0, [SELECT Id FROM Account_Alert__c WHERE Account__c =: gliEmbargoedAccount.Id].Size());
    Test.stopTest();
    }
}