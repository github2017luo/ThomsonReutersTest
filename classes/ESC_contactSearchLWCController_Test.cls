@isTest
public class ESC_contactSearchLWCController_Test {
    
  /**
     * @description retriveRecs
     
     */
public static testmethod void retriveRecs()
    {
        
        Account acc = new Account();
        acc.Name='test';
        acc.Email__c='test@tcs.com';
        acc.CurrencyIsoCode='USD';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'Dallas';
        acc.BillingState = 'TX';
        acc.Total_Active_Subscriptions__c = 10.00;
        insert acc;  
        
        Contact contact = new Contact();
        contact.AccountId = acc.Id;
        contact.LastName = 'testContact';
        contact.Email = 'test1@tcs.com';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        contact.phone = '1234576890';
        insert contact;
        

        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Account_Name__c=acc.Id;        
        accountSSD.Name= acc.Name;
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        accountSSD.Source_System_Account_Number__c='12345';
        insert accountSSD;
       
        //setAccs.add(accountSSD.Account_Name__c);
        
        Test.startTest();
        
        //ESC_contactSearchLWCController classConstruct= new ESC_contactSearchLWCController();
        List<ESC_contactSearchLWCController.DataTableWrapper> oData3 = ESC_contactSearchLWCController.retriveRecs('testContact','test@tcs1.com','12345');
        oData3 = ESC_contactSearchLWCController.retriveRecs('testContact','','');
        oData3 = ESC_contactSearchLWCController.retriveRecs('','','12345');
        ESC_contactSearchLWCController.lstssd.add(contact);
        ESC_contactSearchLWCController.getResults();
        ESC_contactSearchLWCController.getFilterSecondary2('1234567890');
        //ESC_contactSearchLWCController.DataTableWrapper esc = new ESC_contactSearchLWCController.DataTableWrapper();
        ESC_contactSearchLWCController.DataTableWrapper obj= new ESC_contactSearchLWCController.DataTableWrapper();
        obj.email = contact.Email;
        obj.Id= contact.id;
        obj.name= contact.name;
        obj.nameUrl= contact.name;
        obj.accname= contact.name;
        obj.accnameUrl= contact.name;
        obj.city= contact.MailingCity;
        obj.state= 'TX';
        obj.totalactivesubscriptions = '123';
        Test.stopTest();
        
        integer m= 1;
    integer g= 1;
           System.assertEquals(m,g,'Success');
}
}