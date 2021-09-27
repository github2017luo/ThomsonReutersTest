/**
 * test class for load product details controllers
 *
 * @author  Anshita Sharma
 * @version 2013-07-14
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-14   Anshita Sharma          Created                                                                
 * =============================================================================
 */

@istest(seeAllData=true)
private class TestEReaderLoadProductController  {
    
    public static testmethod void test() {
        
        Date dt = system.today();
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Induvidual';
        acc1.Customer_Group__c = 'ACADEMIC';
        acc1.Industry = 'Energy';
        acc1.SAPAccountNumber__c = '1111111111';       
        insert acc1;
       
        Opportunity oppty1 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId =acc1.Id,name='testClass_Oppty1',StageName = '10%');
        insert oppty1;
       
        Contact contact = UnitTest.getContactInstance(acc1.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = acc1.Id;
        contact.email = 'test.test@test.com';
        
        Contact contact1 = UnitTest.getContactInstance(acc1.Id);
        contact1.LastName = 'testContact';
        contact1.FirstName = 'testContact';
        contact1.AccountId = acc1.Id;
        contact1.email = '';
        
        List<Contact> conList = new List<Contact>{contact,contact1};
        insert conList;
        
        Product2 prod = new Product2();
        prod.Name = 'TEST';
        insert prod;
       
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
       
        
        List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];    
             
        PricebookEntry entry= new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert entry;
       
               
        OpportunityLineItem item = new OpportunityLineItem();
        item.PricebookEntryId = entry.id;
        item.Quantity = 1;
        item.OpportunityId = oppty1.id;       
        item.UnitPrice = 100;
        insert item;
      
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)item.ID).substring(0,15));
        d.Opportunity__c = oppty1.id;
        d.Contact__c = contact.id;
        d.Product__c = prod.Id;
        insert d;
      
        
        Opportunity_Product_Detail_Contact__c opdc = new Opportunity_Product_Detail_Contact__c();
        opdc.Product_Detail__c = d.Id;
        opdc.Contact__c = contact.Id;
        opdc.Email__c = 'jivuv@ghvh.com';
       
        Opportunity_Product_Detail_Contact__c opdc1 = new Opportunity_Product_Detail_Contact__c();
        opdc1.Product_Detail__c = d.Id;
        opdc1.Contact__c = contact1.Id;
        opdc1.Email__c = 'jivuv123@ghvh.com';
        List<Opportunity_Product_Detail_Contact__c> opdcList = new List<Opportunity_Product_Detail_Contact__c>{opdc,opdc1};
        insert opdcList;
        
        
        System.currentPageReference().getParameters().put('oppId', oppty1.id);
        
        //test loadOppProductController
        
        loadOppProductDetailController controller = new loadOppProductDetailController(new ApexPages.StandardController(new OpportunityProductDetail__c()));
        
        controller.quickSave();
        controller.cancel(); 
        controller.getContactSelectOptions();
        controller.selectedProd = 0;
        controller.addContact();
        controller.selectedCon = 1;
        controller.handleContactChange();
        
      
        opdc.Email__c = '';
        controller.Save();
        
        Entitlement__c e = new Entitlement__c(Name = '123456');
        try{
            insert e;
        }
        catch(exception ex){
        } 
        
        EntitlementProduct__c ep = new EntitlementProduct__c(Product__c = prod.id, Entitlement__c = e.id);
        try{
        insert ep;
        }
        catch(exception ex){
        } 
        //test loadOppProductBJController
        loadOppProductDetailBJController controllerBJ = new loadOppProductDetailBJController (new ApexPages.StandardController(new OpportunityProductDetail__c()));
        
        controllerBJ.quickSave();
        controllerBJ.cancel(); 
        controllerBJ.getContactSelectOptions();
        
        //test triggerOpportunityProductDetail/opportunityProductDetailTriggerHandler
        
        OpportunityProductDetail__c d1 = new OpportunityProductDetail__c();
        d1.Opportunity_Line_Item_Id__c = (((String)item.ID).substring(0,15));
        d1.Opportunity__c = oppty1.id;
        d1.Contact__c = contact.id;
        try{
            insert d1;
        }
        catch(exception ex){
        } 
        
        
    }
}