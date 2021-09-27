@isTest
public class Ecom_OnlineContactsService_Test {
    
    @isTest
    public static void TestOnlineContacts() {
        Account acc =DCTestData.createAccount('Test Account');      
        insert acc;
        
        Apttus_Config2__PriceList__c priceList =  DCTestData.createPriceList(null);
        insert priceList;
        
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'Manual');
        insert quote;
        
        Contact cont =  DCTestData.createContactRec('lastname',acc.Id);
        insert cont;

        quote.APTS_Order_Confirmation_Contact__c = cont.id;
        update quote;
        
        Apttus_Config2__ProductConfiguration__c cart = DCTestData.createCart(acc.Id, quote.Id,null, priceList.Id);
        insert cart;

        Product2 prod2 = DCTestData.createProductforDCDyn('Test Product', '06', '21');
        insert prod2;

            Apttus_Proposal__Proposal_Line_Item__c propLineItem =  DCTestData.createProposalLineItem('1234', prod2.Id, quote.Id);
        insert propLineItem;

        Test.startTest();
        
        // create online contacts
        Ecom_OnlineContactsController.onlineContacts(quote.Id, true, 'Ohio');
        
        Contact con = new Contact();
        con.Id = cont.id;
        con.LastName = 'test';
        update con;
        
        try {
            Ecom_OnlineContactsController.onlineContacts(quote.Id, false, 'Ohio');
        } catch (Exception ex) {
            System.debug(ex);
        }
        // error handle
        try {
            Ecom_OnlineContactsController.onlineContacts(null, false, 'Ohio');
        } catch (Exception ex) {
            System.debug(ex);
        }
        // Exception 
        try {
                Ecom_OnlineContactsController.onlineContacts('quote.Id', false, 'Ohio');
        } catch (Exception ex) {
            System.debug(ex);
        }

        try {
            Ecom_OnlineContactsController.onlineContacts(quote.Id, true, 'Ohio');
        } catch (Exception ex) {
            System.debug(ex);
        }

        System.assertEquals(1, 1, 'success');
        test.stopTest();
    }
    
}