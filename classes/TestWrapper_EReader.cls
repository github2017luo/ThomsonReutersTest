@istest(seeAllData=true)
private class TestWrapper_EReader {
    
    public static testmethod void test() {
        
        Date dt = system.today();
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Induvidual';
        acc1.Customer_Group__c = 'ACADEMIC';
        acc1.Industry = 'Energy';
        acc1.SAPAccountNumber__c = '';
        try{
        insert acc1;        
        }
        catch(exception ex){
        }
        
        Opportunity oppty1 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId =acc1.Id,name='testClass_Oppty1',StageName = '10%');
        try{
        insert oppty1;        
        }
        catch(exception ex){
        }
          
        Contact contact = UnitTest.getContactInstance(acc1.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = acc1.Id;
        contact.email = 'testfirst.testlast@thomson.com';
        try{
        insert contact;
        }
        catch(exception ex){
        }
        
        Contact contact1 = UnitTest.getContactInstance(acc1.Id);
        contact1.LastName = 'testContact1';
        contact1.FirstName = 'testContact1';
        contact1.AccountId = acc1.Id;
        try{
        insert contact1;
        }
        catch(exception ex){
        }        
        
        Product2 prod =UnitTest.getProductInstance();
        try{
        insert prod;
        }
        catch(exception ex){
        }
        
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
        
        Pricebook2 book = [Select ID From Pricebook2 Where IsStandard = true limit 1];
        
        PricebookEntry entry = new PricebookEntry();
        entry.Product2Id = prod.ID;
        entry.UnitPrice = 1;
        entry.Pricebook2Id = book.id;
        entry.UseStandardPrice = false;
        entry.IsActive = true;
        try{
        insert entry;
        }
        catch(exception ex){
        }
        
        
        OpportunityLineItem item = new OpportunityLineItem();
        item.PricebookEntryId = entry.id;
        item.Quantity = 1;
        item.OpportunityId = oppty1.id;
        item.UnitPrice = 100;
        try{
        insert item;
        }
        catch(exception ex){
        }
          
        Test.startTest();
        Wrapper_EReader.generateAccessEReaderWS(oppty1.id);
      
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)item.ID).substring(0,15));
        d.Opportunity__c = oppty1.id;
        d.Contact__c = contact.id;
        d.Product__c = prod.id;
        try{
        insert d;
        }
        catch(exception ex){
        }
        
        Wrapper_EReader.generateAccessEReaderWS(oppty1.id);        
       
       
         //test WS_EReader
         
         WS_EReader.CreateOnlineContact_element testCreateOnlineCon = new WS_EReader.CreateOnlineContact_element();
         WS_EReader.CreateOnlineContactResponse_element testCreateOnlineConRes = new WS_EReader.CreateOnlineContactResponse_element();
         WS_EReader.EReaderWSSoap  ereader= new WS_EReader.EReaderWSSoap ();
         ereader.CreateOnlineContact('','','','','','','','');
         
         
        Test.stopTest();
         
    }
}