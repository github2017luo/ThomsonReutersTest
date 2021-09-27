@istest(seeAllData=true)
private class Wrapper_EReader_Test {

 
    
    static testmethod void test() {
        Date dt = system.today();
        
        //Account a = UnitTest.getAccountInstance();
        //a.BillingCity = 'Mar del Plata';
        //a.BillingStreet = 'Colon 2393';
        //a.Zona_de_Cobranza__c = 'La placita';
        //insert a;
        
        List<Contact> Conlist = new List<Contact>();
        
         Account a= UnitTest.getAccountInstance();
        a.Name = 'testAccount';
        a.Customer_Type__c = 'Induvidual';
        a.Customer_Group__c = 'ACADEMIC';
        a.Industry = 'Energy';
        a.SAPAccountNumber__c = '';
        try{
        insert a;        
        }
        catch(exception ex){
        }
        
        //Contact cont =  UnitTest.getContactInstance(a.id);
        //cont.accountId = a.id;
        //insert cont;
         Contact contact = UnitTest.getContactInstance(a.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = a.Id;
        contact.email = 'testfirst.testlast@thomson.com';
        try{
        insert contact;
        }
        catch(exception ex){
        }
        
        Conlist.add(contact);
        
         Contact contact1 = UnitTest.getContactInstance(a.Id);
         contact.FirstName = 'testContact1';
        contact.LastName = 'testContact1';
        
        contact.AccountId = a.Id;
        contact.email = 'testfirst1.testlast1@thomson.com';
        try{
        insert contact1;
        }
        catch(exception ex){
        }
        
        Conlist.add(contact1);
    
        
        Opportunity oppty1 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId =a.Id,name='testClass_Oppty1',StageName = '10%');
        try{
        insert oppty1;        
        }
        catch(exception ex){
        }
        
       
        Product2 prod =UnitTest.getProductInstance();
        try{
        insert prod;
        }
        catch(exception ex){
        }
        
        //Entitlement__c e = UnitTest.getEntitlement();
        //insert e;
        Entitlement__c e = new Entitlement__c(Name = '123456');
        try{
        insert e;
        }
        catch(exception ex){
        }
        
        //EntitlementProduct__c ep = TestTools.getEntitlementProduct(prod.id, e.id);
        //insert ep;
       
        //Pricebook2 book = TestTools.getPricebookStandard();
        
        //PricebookEntry entry = TestTools.getPricebookEntry(book.id, prod.id);   
        //insert entry;
        
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
        
        
        //OpportunityLineItem li = TestTools.getOpportunityLineItem(op.id, entry.id);
        //insert li;
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
        
        //OpportunityProductDetail__c d = TestTools.getdetailLineItem(op.id, li.id, cont.id);
        //d.product__c = prod.id;
        //insert d;
        Test.startTest();
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)item.ID).substring(0,15));
        d.Opportunity__c = oppty1.id;
        d.Contact__c = contact.id;
        d.Product__c = prod.id;
        insert d;
       
        Opportunity_Product_Detail_Contact__c dc =  new Opportunity_Product_Detail_Contact__c();
        dc.Product_Detail__c = d.id;
        dc.Contact__c = contact.id;
        dc.Email__c = 'test@test.com';
      
        insert dc;
             
         EntitlementProduct__c ep = new EntitlementProduct__c(Product__c = prod.id, Entitlement__c = e.id);
       
        insert ep;
       
        
       
         Wrapper_EReader.generateAccessEReaderWS(oppty1.id);
          Wrapper_EReader.OnlineContact oc = new Wrapper_EReader.OnlineContact();
          oc.fname='test';
          oc.lname='test1';
          oc.email = 'test@test.com';
          oc.allowContactEmails = true;
          oc.getAppUserGuid();
          oc.log();
          oc.getMessages();
        
        
          Wrapper_EReader.Subscription sub = new Wrapper_EReader.Subscription();
          sub.applicationId = 'test1';
          sub.status = 'test1';
          sub.message = 'test1';
          sub.log();
          sub.hasStatusMessage();
          
        
          Wrapper_EReader.Entitlement ent = new Wrapper_EReader.Entitlement();
          ent.applicationId = 'test1';
          ent.status = 'Pending';
          ent.appuserId = 'test1';
          ent.appUserPassword = 'test1';
          ent.appUserGuid = 'test1';
          ent.getSubscriptionMessages();
          ent.log();
        
          Wrapper_EReader.Material mat = new Wrapper_EReader.Material();
          mat.materialNumber = 'test2';
          mat.description = 'test1';
          sub.mater = mat;
          mat.log();
        
          Wrapper_EReader.XMLReader xmlr = new Wrapper_EReader.XMLReader();
           String wsResponse='<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><ns3:TocHeader xmlns:ns3="http://toc.schemas.thomson.com/headers/2006-02-01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://tlr.schemas.thomson.com/headers/2006-02-01" xmlns:ns2="http://ecom.toc.schemas.thomson.com/headers/2007-06-01" softwareName="" softwareId="" versionXsd=""><ns3:Message><ns3:Id><ns3:MessageId>8d42cc06-950f-4b8f-a4c3-675c7ada3d5d</ns3:MessageId><ns3:MessageGroupId xsi:nil="true" /><ns3:TimeStamp>2012-08-23T08:28:50.091-0500</ns3:TimeStamp></ns3:Id><ns3:X><ns1:RootId>i0adc45960000013953abc4ac68ba0781</ns1:RootId><ns1:ParentId xsi:nil="true" /><ns1:UserId xsi:nil="true" /><ns1:SessionId xsi:nil="true" /><ns1:BusinessUnit xsi:nil="true" /><ns1:ProductFeature xsi:nil="true" /><ns2:ServerName>eccsoa009-11.int.westgroup.com</ns2:ServerName><ns2:ServiceVersion>12.05</ns2:ServiceVersion></ns3:X></ns3:Message></ns3:TocHeader></soapenv:Header><soapenv:Body><ns1:CreateOnlineContactResponse xmlns:ns1="http://ecom.toc.services.thomson.com/1.0/entitlement" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><confirmations xsi:nil="true" /><trackingId>i0adc45960000013953abc4af68ba0782</trackingId><onlineContact><contactId xsi:nil="true" /><firstName>Cristian</firstName><lastName>Marrapodi</lastName><email>cristian.marrapodi@thomsonreuters.com</email><phone xsi:nil="true" /><contactType xsi:nil="true" /><status xsi:nil="true" /><createDate xsi:nil="true" /><companyId xsi:nil="true" /><sourceId xsi:nil="true" /><account xsi:nil="true" /><endDate xsi:nil="true" /><entitlements><applicationId>EREADER</applicationId><inactivatable>true</inactivatable><logonName xsi:nil="true" /><status>ACTIVE</status><appUserId>9995002374</appUserId><appUserPassword>086C1063345054</appUserPassword><appUserRefId xsi:nil="true" /><appUserGuid>i0adc1e100000013953abc5e4ce0ada07</appUserGuid><accessStartDate xsi:nil="true" /><accessEndDate xsi:nil="true" /><lastLogonDate xsi:nil="true" /><registered>false</registered><transparent>false</transparent><authenticationSystem /><authId /><appUserRefIdNickName xsi:nil="true" /><appUserRefIdPrimary xsi:nil="true" /><authFirstName xsi:nil="true" /><authLastName xsi:nil="true" /><authEmail xsi:nil="true" /><lastPasswordChangeDate xsi:nil="true" /><statusReason xsi:nil="true" /><detailsIncomplete>true</detailsIncomplete><subscriptions><number xsi:nil="true" /><material><materialNumber>40065649</materialNumber><description>CICLO DE ACTUAL IMPOSIT AGROPECU NC 2011</description><materialType /><internalDescription xsi:nil="true" /></material><soldToAccount /><applicationId>EREADER</applicationId><lines xsi:nil="true" /><type /><bandRange xsi:nil="true" /><licenseKeyCode xsi:nil="true" /><mlaNumber xsi:nil="true" /><purchaseOrder xsi:nil="true" /><startDate xsi:nil="true" /><endDate xsi:nil="true" /><trialOffer>false</trialOffer><rentalSub>false</rentalSub><status>SUCCESS</status><message>Material 40065649 not configured for ebook access.</message></subscriptions></entitlements><position xsi:nil="true" /><initials xsi:nil="true" /><unit xsi:nil="true" /><activity xsi:nil="true" /><onlineContactType xsi:nil="true" /><onlineContactTypeDescription xsi:nil="true" /><summerAssociateYear xsi:nil="true" /><warningFlag xsi:nil="true" /><allowContactEmails>true</allowContactEmails><gradDate xsi:nil="true" /><contactStatus>SUCCESS</contactStatus><requestId></requestId></onlineContact></ns1:CreateOnlineContactResponse></soapenv:Body></soapenv:Envelope>';
     
          xmlr.parseXML(wsResponse);
       
        
           WS_EReader.CreateOnlineContact_element testCreateOnlineCon = new WS_EReader.CreateOnlineContact_element();
         WS_EReader.CreateOnlineContactResponse_element testCreateOnlineConRes = new WS_EReader.CreateOnlineContactResponse_element();
         WS_EReader.EReaderWSSoap  ereader= new WS_EReader.EReaderWSSoap ();
          ereader.CreateOnlineContact('test','test','test','test','test','test','test','test');
        Test.stopTest();
    }
    
}