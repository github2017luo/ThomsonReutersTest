@isTest(seeAllData=false)
public class TRStore_OrderTest {
    public class PrepareDataWrapper {
        String lname;
        String leadId;
        String actionParm;
        String cartId;
    }
    
    public static TRStore_OrderRequest.TRstoreOrders prepareData(PrepareDataWrapper pdw) {
        
        TRStore_OrderRequest.TRstoreOrders trStoreOrder = new TRStore_OrderRequest.TRstoreOrders();
        TRStore_OrderRequest.TRstoreOrder od = new TRStore_OrderRequest.TRstoreOrder();
        TRStore_OrderRequest.TRStorecustomerDetails cd = new TRStore_OrderRequest.TRStorecustomerDetails();
        TRStore_OrderRequest.TRStoreAccountDetails ad= new TRStore_OrderRequest.TRStoreAccountDetails();
        TRStore_OrderRequest.customerAddress ca = new  TRStore_OrderRequest.customerAddress();
        TRStore_OrderRequest.References ref = new TRStore_OrderRequest.References();
        TRStore_OrderRequest.ActionParams ap = new TRStore_OrderRequest.ActionParams();
        TRStore_OrderRequest.micrositeFieldsClass mfc = new TRStore_OrderRequest.micrositeFieldsClass();
        TRStore_OrderRequest.OnlineContactsFieldsClass olc  = new TRStore_OrderRequest.OnlineContactsFieldsClass();
        List<TRStore_OrderRequest.OnlineContactsFieldsClass> olcList = new List<TRStore_OrderRequest.OnlineContactsFieldsClass>();
        
        LIST<TRStore_OrderRequest.proviewIds> proviewids = new LIST<TRStore_OrderRequest.proviewIds>();
        TRStore_OrderRequest.proviewIds p1= new TRStore_OrderRequest.proviewIds();
        p1.pCode = '365214';
        proviewids.add(p1);
        
        LIST<TRStore_OrderRequest.OnlineContactsFieldsClass> proviewOnlineContacts = new LIST<TRStore_OrderRequest.OnlineContactsFieldsClass>();
        TRStore_OrderRequest.OnlineContactsFieldsClass poc = new TRStore_OrderRequest.OnlineContactsFieldsClass();
        poc.pFirstName = 'HelloName';
        poc.pLastName = 'HelloLastName';
        poc.pEmail = 'HelloName342@xingxong.com';
        poc.pTitle = 'Attorny';
        poc.pType = 'Contact';
        poc.jurisdiction = 'Test juri';
        poc.proviewProducts = proviewids;
        
        proviewOnlineContacts.add(poc);
        
        od.totalPrice = String.valueof(158.0);   
        od.isExistingCustomer = false;
        od.isAbandonedLead = false; 
        od.LeadsourceCountryCode = 'CA';
        od.LeadOriginSite = 'CAPR';
        
        cd.firstName = 'Rohit';
        cd.lastName = pdw.lname;
        cd.businessEmail = 'testfirst.testlast@test.com';
        cd.isPhysicalSameAsBillingAddress = true;
        cd.isOLCAvailalble = true;
        cd.businessPhoneNumber = '254173978';
        cd.shippingPhoneNumber = '324178923';
        cd.shippingFirstName = 'Rohit';
        cd.shippingLastName = 'S';
        
        ad.organizationName = 'TCS';
        ad.AccountANumber = '123456';
        ad.billingAddress = ca;
        ad.organizationType = 'Law Firm';
        
        ca.street1='610 Opperman Dr';
        ca.street2='';
        ca.city='Eagan';
        ca.state='AL';
        ca.zipCode='55123';
        ca.country='US';
        
        mfc.leadOriginCode='trc';
        mfc.chargeCode='123';
        mfc.orderCompleted=true;
        
        olc.pFirstName = 'OlcFirst';
        olc.pLastName = 'OlcLast';
        olc.pEmail = 'testolc123@abc.com';
        olc.pTitle = 'Attorney';
        olc.pType = 'User';
        olc.jurisdiction = 'Alaska';
        olcList.add(olc);
       
        
        ref.leadId=pdw.leadId;
        ref.cartId=pdw.cartId;
        ap.leadAction=pdw.actionParm;
                
        cd.organizationDetails=ad;
        cd.shippingAddress=ca;
        
        od.customerDetails=cd;
        od.micrositeFields=mfc;
        od.proviewContacts=olcList;
        od.proviewContacts = proviewOnlineContacts;
        
        trStoreOrder.OrderDetails=od;
        trStoreOrder.actionParamsDetails=ap;
        trStoreOrder.referencesDetails=ref;
        
        return trStoreOrder;
        
    }
    public static testMethod  void testTRStoreCreateProcess(){
        
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
        
        
        // insert lead
        lead ldb = new lead();
        ldb.FirstName='rohit';
        ldb.LastName='sharma';
        ldb.Email='testfirst.testlast5874@test.com';        
        ldb.IsConverted=false;
        ldb.Company='TCS';
          
        ldb.Billing_Street__c = 'Banito Blanco 822';
        ldb.Billing_City__c = 'New Yark';
        ldb.Billing_State__c = 'NY';
        ldb.Billing_Country__c ='US';
        ldb.TRstore_Billadd_differenceto_shipping__c = true;
        ldb.SAPAccountNumber__c = '12345623';
        ldb.Is_GLI__c=true;
        ldb.Lead_Microsite__c='TR Store';
        insert ldb;
        System.assert(ldb != null, 'Inserted lead');
         String jsonMsg='{"trStoreOrder":{"OrderDetails":{"totalPrice":"158.0","isExistingCustomer":true,"isAbandonedLead":false,"LeadsourceCountryCode":"CA","customerDetails":{"firstName":"CustomerFirstName","lastName":"CustomerLastName","businessEmail":"customeremailtestFeb20@mailinator.com","isPhysicalSameAsBillingAddress":true,"isOLCAvailalble":true,"businessPhoneNumber":"(987) 654- 1230","shippingPhoneNumber":"(987) 654- 1230","organizationDetails":{"organizationName":"ABC Corp","AccountANumber":"1001000","organizationType":"SLF 2-3","billingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"1001000"}},"shippingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"12345"}},"micrositeFields":{"leadOriginCode":"PWC","chargeCode":"123","orderCompleted":true},"proviewContacts":[{"pFirstName":"proviewFirstName","pLastName":"proviewlastName","pEmail":"proview@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]},{"pFirstName":"proviewFirstName2","pLastName":"proviewlastName2","pEmail":"proview2@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]}]},"referencesDetails":{"leadId": "'+ ldb.id +'" ,"cartId": "'+  cartRec.id +'" },"actionParamsDetails":{"leadAction":"create"}}}';
       
         
        
        Test.startTest();
        createStaticValues();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/TRStoreLeadAction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        
        PrepareDataWrapper pdw1 = new PrepareDataWrapper();
        pdw1.lname = 'Sharma';
        pdw1.leadId = '';
        pdw1.actionParm = 'create';
        pdw1.cartId = cartRec.id;
        
        TRStore_OrderRequest.TRstoreOrders trStoreOrder = TRStore_OrderTest.prepareData(pdw1);
        system.debug('olc contacts fromproview.............'+trStoreOrder);
        system.debug('olc contacts fromproview.............'+trStoreOrder.OrderDetails.proviewContacts);
        TRStore_OrderRequest.processLead(trStoreOrder);
        
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';
        ld.IsConverted=false;
        ld.Company='TCS';
        
        ld.Product_Configuration__c=cartRec.Id;
        insert ld;
        
        Online_Contacts__c onlineContact = new Online_Contacts__c();
                     Customer_Master_Contacts__c ms = new Customer_Master_Contacts__c();
                        
                        onlineContact.First_Name__c = 'pFirstName';
                        onlineContact.Last_Name__c = 'pLastName';
                        onlineContact.Email__c = 'pEmail@mailinator.com';
                        onlineContact.WLEc_Juris__c = 'jurisdiction';
                        onlineContact.Position__c = 'pTitle';                        
                        onlineContact.Type__c = 'pType';

                        onlineContact.Lead__c = ld.Id;
                        onlineContact.Product_Configuration__c = cartRec.id; 
           
           insert       onlineContact;        
        
        Customer_Master_Contacts__c  msd = new Customer_Master_Contacts__c();
        msd.First_Name__c = 'FirstName';
                        msd.Last_Name__c = 'pLastName';
                        msd.Email_Address__c = 'pEmail@mailinator.com';
                        msd.Lead__c = ld.Id;
                        msd.Material__c = '25478';
                        
                        
                        insert msd;
        
        PrepareDataWrapper pdw2 = new PrepareDataWrapper();
        pdw2.lname = null;
        pdw2.leadId = ld.id;
        pdw2.actionParm = 'create';
        pdw2.cartId = cartRec.id;
        TRStore_OrderRequest.TRstoreOrders trStoreOrder2 = TRStore_OrderTest.prepareData(pdw2);
        TRStore_OrderRequest.processLead(trStoreOrder2);
        
        PrepareDataWrapper pdw3 = new PrepareDataWrapper();
        pdw3.lname ='sharma';
        pdw3.leadId = ld.id;
        pdw3.actionParm = 'AccountCheck'; 
        pdw3.cartId = cartRec.id;
        TRStore_OrderRequest.TRstoreOrders trStoreOrder3 = TRStore_OrderTest.prepareData(pdw3);
        TRStore_OrderRequest.processLead(trStoreOrder3);
        
        PrepareDataWrapper pdw4 = new PrepareDataWrapper();
        pdw4.lname = null;
        pdw4.leadId = null;
        pdw4.actionParm = null;
        pdw4.cartId = null;
        TRStore_OrderRequest.TRstoreOrders trStoreOrder4 = TRStore_OrderTest.prepareData(pdw4);
        TRStore_OrderRequest.processLead(trStoreOrder4);
        Test.stopTest();
        
    }
    
    public static testMethod void testTRStoreConvertProcess() {
    
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                
                insert webserviceList;
        System.assert(webserviceList != null, 'Inserted webserviceList');
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
        
        // insert lead
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';        
        ld.IsConverted=false;
        ld.Company='TCS';
        ld.Shipping_FirstName__c = 'Rohit';
        ld.Shipping_LastName__c = 'N';
        ld.Product_Configuration__c=cartRec.Id;   
        ld.Billing_Street__c = 'Banito Blanco 822';
        ld.Billing_City__c = 'New Yark';
        ld.Billing_State__c = 'NY';
        ld.Billing_Country__c ='US';
        ld.TRstore_Billadd_differenceto_shipping__c = true;
        ld.SAPAccountNumber__c = '123456';
        ld.Is_GLI__c=true;
        ld.Lead_Microsite__c='TR Store';
        insert ld;
        
         // insert lead
        lead ld2 = new lead();
        ld2.FirstName='rohit';
        ld2.LastName='sharma';
        ld2.Email='testfirst.testlast@test.com';        
        ld2.IsConverted=false;
        ld2.Company='TCS';
        ld2.Product_Configuration__c=cartRec.Id;   
        ld2.Billing_Street__c = 'Banito Blanco 822';
        ld2.Billing_City__c = 'New Yark';
        ld2.Billing_State__c = 'NY';
        ld2.Billing_Country__c ='US';
        ld2.TRstore_Billadd_differenceto_shipping__c = true;
        ld2.SAPAccountNumber__c = '';
        ld2.Is_GLI__c=true;
        ld2.Lead_Microsite__c='TR Store';
        insert ld2;
        
         String jsonMsg='{"trStoreOrder":{"OrderDetails":{"totalPrice":"158.0","isExistingCustomer":true,"isAbandonedLead":false,"LeadsourceCountryCode":"CA","customerDetails":{"firstName":"CustomerFirstName","lastName":"CustomerLastName","businessEmail":"customeremailtestFeb20@mailinator.com","isPhysicalSameAsBillingAddress":true,"isOLCAvailalble":true,"businessPhoneNumber":"(987) 654- 1230","shippingPhoneNumber":"(987) 654- 1230","organizationDetails":{"organizationName":"ABC Corp","AccountANumber":"1001000","organizationType":"SLF 2-3","billingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"1001000"}},"shippingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"12345"}},"micrositeFields":{"leadOriginCode":"PWC","chargeCode":"123","orderCompleted":true},"proviewContacts":[{"pFirstName":"proviewFirstName","pLastName":"proviewlastName","pEmail":"proview@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]},{"pFirstName":"proviewFirstName2","pLastName":"proviewlastName2","pEmail":"proview2@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]}]},"referencesDetails":{"leadId": "'+ ld.id +'" ,"cartId": "'+  cartRec.id +'" },"actionParamsDetails":{"leadAction":"create"}}}';
       
        
        // insert acc
        Account acc =APTS_TestDataFactory.createAccount('Test');
        Insert acc;
        
        // insert ssd
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='AL',Country__c='US',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD;
        
        
        // insert contact
        contact con = APTS_TestDataFactory.createContact('test',acc.id);
        con.FirstName='rohit';
        insert con ;
        
        // insert contactSSD
        LCRM_Contact_SSD__c contactSSD = new LCRM_Contact_SSD__c();
        contactSSD.Name ='test';
        contactSSD.LCRM_First_Name__c='rohit';
        contactSSD.LCRM_Email__c='rohit.sharma@thomsonreuters.com';
        contactSSD.LCRM_Contact__c=con.id;
        insert contactSSD;
        
        // insert campaign
        Campaign c1 = new Campaign();
        c1.Name = 'Test Campaign 1';
        insert c1;
        
        createStaticValues();
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1];
        KeyValueListStore__c kv = new KeyValueListStore__c(TextValue__c=p.id, name='ANZUsersProfileId' );
        insert kv;
        
        string rtId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        string rtId2 = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        LIST<RecordtypeIds__c> rtIds = new LIST<RecordtypeIds__c >();
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name='Pre-Pipeline Opportunities', recTypeId__c =rtId); 
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name='Pipeline Opportunities', recTypeId__c =rtId2); 
        rtIds.add(rt);
        rtIds.add(rt2);        
        insert rtIds;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/TRStoreLeadAction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        
       // createStaticValues();
        
       Test.startTest();
       TRStore_OrderService.TRStore_RequestClass trsc = new TRStore_OrderService.TRStore_RequestClass();
       trsc.leadId = ld.id;
       trsc.cartId = cartRec.id;
       trsc.emailID = 'rohit.sharma@thomsonreuters.com';
       trsc.accNumber = '123456';
       trsc.requestFor = 'LeadConvert';
       
       TRStore_OrderService.getDetailsForOrderSubmission(trsc);
       TRStoreLeadprocess.convertLead(ld.id,cartRec.id,'rohit.sharma@thomsonreuters.com','123456');
       
       TRStore_OrderService.TRStore_RequestClass trsc2 = new TRStore_OrderService.TRStore_RequestClass();
       trsc2.leadId = null;
       trsc2.cartId = cartRec.id;
       trsc2.emailID = 'rohit.sharma@thomsonreuters.com';
       trsc2.accNumber = '123456';
       trsc2.requestFor = 'LeadConvert';
       TRStore_OrderService.getDetailsForOrderSubmission(trsc2);
       TRStoreLeadprocess.convertLead(null,cartRec.id,'rohit.sharma@thomsonreuters.com','123456');
       
       system.debug('Lead Address.......'+ld.Billing_Street__c);
       
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        insert propObj;
        
       TRStore_OrderService.TRStore_RequestClass trsc3 = new TRStore_OrderService.TRStore_RequestClass();
       trsc3.leadId = ld.id;
       trsc3.cartId = cartRec.id;
       trsc3.emailID = 'rohit.sharma@thomsonreuters.com';
       trsc3.accNumber = '123456';
       trsc3.requestFor = 'OrderConfirmation';
       trsc3.quoteId = propObj.id;
        //TRStore_OrderServiceResponse resp = new TRStore_OrderServiceResponse resp();
       TRStore_OrderService.TRStore_OrderServiceResponse resp = TRStore_OrderService.getDetailsForOrderSubmission(trsc3);
       System.assert(resp != null, 'order response');
       Test.stopTest();
    }
    
    public static testMethod void testTRStoreConvertProcesstwo() {
    
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                
                insert webserviceList;
        System.assert(webserviceList != null, 'Inserted webserviceList');  
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
        
        // insert lead
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';        
        ld.IsConverted=false;
        ld.Company='TCS';
        ld.Product_Configuration__c=cartRec.Id;   
        ld.Billing_Street__c = 'Banito Blanco 822';
        ld.Billing_City__c = 'New Yark';
        ld.Billing_State__c = 'NY';
        ld.Billing_Country__c ='US';
        ld.TRstore_Billadd_differenceto_shipping__c = true;
        ld.SAPAccountNumber__c = '123456';
        ld.Is_GLI__c=true;
        ld.Lead_Microsite__c='TR Store';
        insert ld;
        
         // insert lead
        lead ld2 = new lead();
        ld2.FirstName='rohit';
        ld2.LastName='sharma';
        ld2.Email='testfirst.testlast@test.com';        
        ld2.IsConverted=false;
        ld2.Company='TCS';
        ld2.Product_Configuration__c=cartRec.Id;   
        ld2.Billing_Street__c = 'Banito Blanco 822';
        ld2.Billing_City__c = 'New Yark';
        ld2.Billing_State__c = 'NY';
        ld2.Billing_Country__c ='US';
        ld2.TRstore_Billadd_differenceto_shipping__c = true;
        ld2.SAPAccountNumber__c = '';
        ld2.Is_GLI__c=true;
        ld2.Lead_Microsite__c='TR Store';
        insert ld2;
        
         String jsonMsg='{"trStoreOrder":{"OrderDetails":{"totalPrice":"158.0","isExistingCustomer":true,"isAbandonedLead":false,"LeadsourceCountryCode":"CA","customerDetails":{"firstName":"CustomerFirstName","lastName":"CustomerLastName","businessEmail":"customeremailtestFeb20@mailinator.com","isPhysicalSameAsBillingAddress":true,"isOLCAvailalble":true,"businessPhoneNumber":"(987) 654- 1230","shippingPhoneNumber":"(987) 654- 1230","organizationDetails":{"organizationName":"ABC Corp","AccountANumber":"1001000","organizationType":"SLF 2-3","billingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"1001000"}},"shippingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"12345"}},"micrositeFields":{"leadOriginCode":"PWC","chargeCode":"123","orderCompleted":true},"proviewContacts":[{"pFirstName":"proviewFirstName","pLastName":"proviewlastName","pEmail":"proview@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]},{"pFirstName":"proviewFirstName2","pLastName":"proviewlastName2","pEmail":"proview2@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]}]},"referencesDetails":{"leadId": "'+ ld.id +'" ,"cartId": "'+  cartRec.id +'" },"actionParamsDetails":{"leadAction":"create"}}}';
       
        // insert acc
        Account acc =APTS_TestDataFactory.createAccount('Test');
        Insert acc;
        
        // insert ssd
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='AL',Country__c='US',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD;
        
        
        // insert contact
        contact con = APTS_TestDataFactory.createContact('test',acc.id);
        con.FirstName='rohit';
        insert con ;
        
        // insert contactSSD
        LCRM_Contact_SSD__c contactSSD = new LCRM_Contact_SSD__c();
        contactSSD.Name ='test';
        contactSSD.LCRM_First_Name__c='rohit';
        contactSSD.LCRM_Email__c='rohit.sharma@thomsonreuters.com';
        contactSSD.LCRM_Contact__c=con.id;
        insert contactSSD;
        
        // insert campaign
        Campaign c1 = new Campaign();
        c1.Name = 'Test Campaign 1';
        insert c1;
        
        createStaticValues();
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1];
        KeyValueListStore__c kv = new KeyValueListStore__c(TextValue__c=p.id, name='ANZUsersProfileId' );
        insert kv;
        
        string rtId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        string rtId2 = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        LIST<RecordtypeIds__c> rtIds = new LIST<RecordtypeIds__c >();
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name='Pre-Pipeline Opportunities', recTypeId__c =rtId); 
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name='Pipeline Opportunities', recTypeId__c =rtId2); 
        rtIds.add(rt);
        rtIds.add(rt2);        
        insert rtIds;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/TRStoreLeadAction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        
       Test.startTest();
               
       TRStore_OrderService.TRStore_RequestClass trsc3 = new TRStore_OrderService.TRStore_RequestClass();
       trsc3.leadId = ld2.id;
       trsc3.cartId = cartRec.id;
       trsc3.emailID = 'rohit.sharma@thomsonreuters.com';
       trsc3.accNumber = null;
       trsc3.requestFor = 'MicrositeOrderComplete';
       TRStore_OrderService.getDetailsForOrderSubmission(trsc3);
       TRStoreLeadprocess.convertLead(ld2.id,cartRec.id,'rohit.sharma@thomsonreuters.com',null);
       Test.stopTest();
       TRStoreLeadprocess.checkAccountStatus('123456', null, ld.Id);
       TRStoreLeadprocess.checkAccountStatus('76543', '87657', ld.Id);
    
        PrepareDataWrapper pdw5 = new PrepareDataWrapper();
        pdw5.lname = 'Sharma';
        pdw5.leadId = ld.id;
        pdw5.actionParm = 'AccountCheck';
        pdw5.cartId = cartRec.id;
       TRStore_OrderRequest.TRstoreOrders trStoreOrder2 = TRStore_OrderTest.prepareData(pdw5);
       TRStore_OrderRequest.processLead(trStoreOrder2);
        
       TRStoreLeadprocess.fetchLeadDetailsByEmail('rohit.sharma@thomsonreuters.com', '123456');
    }
    public static testMethod void testMicrositeQuoteCreate() {
    
        createStaticValues();
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
          // insert lead
        List<Lead> leadInfo = new List<Lead>();
        lead ld = new lead();
        ld.FirstName='rohit1';
        ld.LastName='sharma1';
        ld.Email='testfirst.testlast@test.com';        
        ld.IsConverted=false;
        ld.Product_Configuration__c=cartRec.Id;
        ld.Company='TCS';   
        ld.Billing_Street__c = 'Banito Blanco 822';
        ld.Billing_City__c = 'New Yark';
        ld.Billing_State__c = 'NY';
        ld.Billing_Country__c ='US';
        ld.TRstore_Billadd_differenceto_shipping__c = true;
        ld.SAPAccountNumber__c = '123456';
        ld.Is_GLI__c=true;
        ld.Lead_Microsite__c='TR Store';
        //insert ld;
        leadInfo.add(ld);
        // if(leadInfo!=Null)
        insert leadInfo;
        System.assert(leadInfo != null, 'Inserted lead'); 
        test.startTest();
        TRStore_MicrositeQuote.mapMicrositeProposal(leadInfo);
       // conts.setLeadId(ld.id);
        //test.stopTest();
    }

    
    
    public static testMethod void testMicrositeOrderEmailCon() {
    
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
          // insert lead
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';        
        ld.IsConverted=false;
        ld.Product_Configuration__c=cartRec.Id;
        ld.Company='TCS';   
        ld.Billing_Street__c = 'Banito Blanco 822';
        ld.Billing_City__c = 'New Yark';
        ld.Billing_State__c = 'NY';
        ld.Billing_Country__c ='US';
        ld.TRstore_Billadd_differenceto_shipping__c = true;
        ld.SAPAccountNumber__c = '123456';
        ld.Is_GLI__c=true;
        ld.Lead_Microsite__c='TR Store';
        insert ld;
        System.assert(ld != null, 'Inserted lead');
        test.startTest();
        TRStoreMicrositeOrderCompleteEmailCon conts = new TRStoreMicrositeOrderCompleteEmailCon();
        conts.getLeadId();
        conts.setLeadId(ld.id);
        test.stopTest();
    }
    
    public static Apttus_Config2__ProductConfiguration__c  createProductConfigurations() {
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        // insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        insert prodConfigObj;
        
        return prodConfigObj;
        
    }
    
    public static testMethod void testTRStoreFetchLeadDetails() {
        
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
        
        // insert acc
        Account acc =new account();
        acc.Name='Test';
        
        Insert acc;
        
        // insert contact
        contact con = APTS_TestDataFactory.createContact('test',acc.id);
        con.FirstName='Amy';
        insert con ;
        
        // insert lead
        lead ld = new lead();
        ld.FirstName='Amy';
        ld.LastName='anto';
        ld.Email='testfirst.testfirst@test.com';        
        ld.IsConverted=true;
        ld.Company='TCS';
        ld.Product_Configuration__c=cartRec.Id;
        ld.ConvertedAccountId =acc.id;
        ld.ConvertedContactId=con.id;
        insert ld;
        System.assert(ld != null, 'Inserted lead');
         Online_Contacts__c onlineContact = new Online_Contacts__c();
                     Customer_Master_Contacts__c ms = new Customer_Master_Contacts__c();
                        
                        onlineContact.First_Name__c = 'pFirstName';
                        onlineContact.Last_Name__c = 'pLastName';
                        onlineContact.Email__c = 'pEmail@mailinator.com';
                        onlineContact.WLEc_Juris__c = 'jurisdiction';
                        onlineContact.Position__c = 'pTitle';                        
                        onlineContact.Type__c = 'pType';

                        onlineContact.Lead__c = ld.Id;
                        onlineContact.Product_Configuration__c = cartRec.id; 
           
           insert       onlineContact;        
        
        Customer_Master_Contacts__c  msd = new Customer_Master_Contacts__c();
        msd.First_Name__c = 'FirstName';
                        msd.Last_Name__c = 'pLastName';
                        msd.Email_Address__c = 'pEmail@mailinator.com';
                        msd.Lead__c = ld.Id;
                        msd.Material__c = '25478';
                        
                        
                        insert msd;
        
        
        TRStoreLeadprocess.fetchLeadDetails(ld.id, ld.email, cartRec.id);
        
        TRStoreLeadprocess.fetchLeadDetails(null, ld.email, cartRec.id);
        
        //unit test to check the error response when lead id and email is null
        TRStoreLeadprocess.fetchLeadDetails(null, null, cartRec.id);
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('leadId', ld.id);
        RestContext.request = request;
        TRStore_OrderRequest.getLeadDetails();
    }
    
    public static testMethod void testLogTRSException() {
    
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';
        ld.IsConverted=false;
        ld.Company='TCS';
        
        ld.Product_Configuration__c=cartRec.Id;
        
        insert ld;
        System.assert(ld != null, 'Inserted lead');
        TRStoreLeadprocess.logTRSException('Submit Order Error', 'exception', 'TRstoreService', ld.Id, 'Lead', 'Lead Convert/ order confirmation', 'kanishk@tr.com', false);
        TRStoreLeadprocess.logTRSException('Lead convert process', 'exception', 'TRstoreService', ld.Id, 'Lead', 'Lead Convert/ order confirmation', 'kanishk@tr.com', false);
        TRStoreLeadprocess.logTRSException('cart update error', 'exception', 'TRstoreService', ld.Id, 'Lead', 'Lead Convert/ order confirmation', 'kanishk@tr.com', false); 
        
        TRStoreLeadprocess.logTRStoreException('Submit Order Error', 'exception', 'TRstoreService', ld.Id);
        TRStoreLeadprocess.logTRStoreException('Lead convert process', 'exception', 'TRstoreService', ld.Id);
        TRStoreLeadprocess.logTRStoreException('cart update error', 'exception', 'TRstoreService', ld.Id); 
    }
       
    
    
    public static void createStaticValues() {
        
        // insert campaign
        Campaign c1 = new Campaign();
        c1.Name = 'Test Campaign 1';
        insert c1;
        
        // insert price book
        pricebook2 cpb = new pricebook2();
        cpb.name = 'GLI Price Book - US Legal/LMS';
        
        insert cpb;
        
        // insert custom settings [Static_Values__c ]
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>();
        Static_Values__c stl = new Static_Values__c(name='LeadConvertOwnerId', value__c=userInfo.getUserId());
        Static_Values__c sth = new Static_Values__c(name='Hive9Code', value__c='432217');
        Static_Values__c stc = new Static_Values__c(name='SFDCCampaignId', value__c=c1.id);
        Static_Values__c sts = new Static_Values__c(name='SSDNotFound', value__c='Sample Text'); 
        Static_Values__c stpb = new Static_Values__c(name='PriceBookName', value__c= 'GLI Price Book - US Legal/LMS');
        Static_Values__c stlc = new Static_Values__c(name='TRStorePELeadConvertCode', value__c= 'LeadConvert');
        Static_Values__c stoc = new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c= 'OrderConfirmation');
        Static_Values__c stmc = new Static_Values__c(name='TRStoremicrositeOrderComplete', value__c= 'MicrositeOrderComplete');        
        Static_Values__c strt = new Static_Values__c(name='SSDRecordType', value__c= 'LOTUS Source Systems'); 
        Static_Values__c stca = new Static_Values__c(name='Hive9CodeCA', value__c='9009510'); 
        Static_Values__c stcca = new Static_Values__c(name='SFDCCampaignIdCA', value__c=c1.id);
        Static_Values__c stcus = new Static_Values__c(name='SFDCCampaignIdUS', value__c=c1.id);         
        Static_Values__c stlgid = new Static_Values__c(name='LeadOwnerGroupId', value__c= 'aemconnect.user@trpcorelegal.com');
        Static_Values__c stlrtn = new Static_Values__c(name='LeadRecordTypeName', value__c= 'GLI');     
        Static_Values__c stmic = new Static_Values__c(name='trc', value__c= 'TR Store');
        Static_Values__c stLse = new Static_Values__c(name='LeadSupportEmail', value__c= 'kanishk.singhvi@thomsonreuters.com');
        Static_Values__c stOse = new Static_Values__c(name='OrderProcessSupportEmail', value__c= 'kanishk.singhvi@thomsonreuters.com');
        Static_Values__c stIntBestRate = new Static_Values__c(name='ShipMethodMicrositeIntBestPrice', value__c= 'International best Rate');
        Static_Values__c stPayOptMicro = new Static_Values__c(name='PaymentOptionMicrosite', value__c= 'Pay by Charge Code');
        Static_Values__c olcType = new Static_Values__c(name='OlcCustomerType', value__c= 'olc');
        Static_Values__c storpDe = new Static_Values__c(name='cartOrphanCartDeleteDays', value__c= '0');
        Static_Values__c stcn = new Static_Values__c(name='cartName', value__c= 'Auto Generated');
        Static_Values__c stcs = new Static_Values__c(name='cartStatus', value__c= 'New');
        Static_Values__c stclm = new Static_Values__c(name='cartModifiedAliase', value__c= userInfo.getUserId());
        Static_Values__c stcsc = new Static_Values__c(name='cartDeleteTimeFrame', value__c= '0 0 21 ? * MON-FRI *');
        
        
        staticCSList.add(stl);
        staticCSList.add(sth);
        staticCSList.add(stc); 
        staticCSList.add(sts);
        staticCSList.add(stpb);
        staticCSList.add(stlc);
        staticCSList.add(stoc);
        staticCSList.add(strt);
        staticCSList.add(stca);
        staticCSList.add(stcca);
        staticCSList.add(stcus);
        staticCSList.add(stmc);
        staticCSList.add(stlgid);
        staticCSList.add(stlrtn);
        staticCSList.add(stmic);
        staticCSList.add(stLse);
        staticCSList.add(stOse);
        staticCSList.add(stIntBestRate);
        staticCSList.add(stPayOptMicro);
        staticCSList.add(storpDe);
        staticCSList.add(stcn);
        staticCSList.add(stcs);
        staticCSList.add(stclm);
        staticCSList.add(stcsc);
        staticCSList.add(olcType);
         
        insert staticCSList;              
    }   
    
    
    public static testmethod void processrepriceCart(){
        
        
                
        createStaticValues();
        
        
        Apttus_Config2__PriceList__c priceList =  APTS_TestDataFactory.createPriceList(label.CanadaPriceList);
        insert priceList;
        
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO3;  
        
        
        
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c ();
         prodConfig =  TRStoreDeleteOrphancartsUtilityTest.insertDummyCart(); //
         prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfig;
        
        
       Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD');
         prod.ProductCode = '98765';
         prod.Description = 'Test Desc';
         prod.Service_Number__c = '87654';
         prod.Apttus_Filter_Brand__c = 'Test';
         prod.Apttus_Filter_Jurisdiction__c = 'Colorado';
         prod.LCRM_Sub_Bu__c = 'USL';
         prod.Format__c= 'Format';
         prod.IsActive = true;
         prod.CPD_Sellable_Description__c ='Display and Sell';
        insert prod;
        
        List<Apttus_Config2__LineItem__c> cartLineItemList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c li1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConfig.id , Apttus_Config2__ProductId__c=prod.id);
        li1.Apttus_Config2__AddedBy__c = 'User';
        li1.Apttus_Config2__AdjustedPrice__c = 50;
        li1.Apttus_Config2__AdjustmentAmount__c = 50;
        li1.Apttus_Config2__AdjustmentType__c = '% Discount';
        li1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li1.Apttus_Config2__AllowProration__c = FALSE;
        li1.Apttus_Config2__AllowRemoval__c = TRUE;
        li1.Apttus_Config2__AutoRenew__c = FALSE;
        li1.Apttus_Config2__BaseExtendedCost__c = 0;
        li1.Apttus_Config2__BaseExtendedPrice__c = 100;
        li1.Apttus_Config2__BasePrice__c = 100;
        li1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li1.Apttus_Config2__ConfigStatus__c = 'Complete';
        li1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li1.Apttus_Config2__Customizable__c = FALSE;
        li1.Apttus_Config2__DeltaPrice__c = 50;
        li1.Apttus_Config2__DeltaQuantity__c = 1;
        li1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li1.Apttus_Config2__ExtendedCost__c = 0;
        li1.Apttus_Config2__ExtendedPrice__c = 100;
        li1.Apttus_Config2__Frequency__c = 'Monthly';
        li1.Apttus_Config2__Guidance__c = 'Red';       
        li1.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li1.Apttus_Config2__ItemSequence__c = 1;
        li1.Apttus_Config2__LineNumber__c = 1;
        li1.Apttus_Config2__LineSequence__c = 1;
        li1.Apttus_Config2__LineStatus__c = 'New';
        li1.APTS_Yr_1_Renewal_Adjustment__c='1';
        li1.Apttus_Config2__LineType__c = 'Product/Service';
        li1.Apttus_Config2__ListPrice__c = 100;
        li1.Apttus_Config2__NetAdjustmentPercent__c = -50;
       /* li1.Apttus_Config2__NetPrice__c = 50;
        li1.Apttus_Config2__NetUnitPrice__c = 50; */
        li1.Apttus_Config2__OptionSequence__c = 0;        
        li1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li1.Apttus_Config2__PriceType__c = 'Recurring';
        li1.Apttus_Config2__PriceUom__c = 'Attorneys';
        li1.Apttus_Config2__PricingStatus__c = 'Complete';       
        li1.APTS_Product_Family__c='RUTTER';
        li1.Apttus_Config2__Quantity__c = 1;
        li1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li1.Apttus_Config2__SellingTerm__c = 1;        
        li1.Apttus_Config2__Taxable__c = FALSE;
        li1.Apttus_Config2__TaxInclusive__c = FALSE;
        li1.Apttus_Config2__Term__c = 1;
        li1.Apttus_Config2__TotalQuantity__c = 1;
        li1.Apttus_Config2__Uom__c = 'Each';        
        li1.CurrencyIsoCode = 'CAD';
        li1.APTS_Product_Family__c = 'CLEAR';
        li1.APTS_Contract_Term__c = '2 Years';
        li1.APTS_Years_2_Plus_Adjustment__c = '5';
        li1.Apttus_Config2__IncentiveCode__c = '';
        li1.APTS_Bridge__c='1 Month';
        
        insert li1;
        
        
        system.debug('started test coverage...........');
        
        TRStore_LeadConvertQueueable.checkRepriceCartStatus(prodConfig.id);
        
        system.debug('Completed test coverage...........');
    }
    
    
}