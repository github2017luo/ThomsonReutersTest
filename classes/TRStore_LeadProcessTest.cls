@isTest(seeAllData=false)
public class TRStore_LeadProcessTest {
    /** 
     * @description : Test Data Wrapper
     */ 
    public class PrepareDataWrapper {
        String lname;
        String leadId;
        String actionParm;
        String cartId;
    }
    
    /** 
     * @description : Method to prepare test data
     * @param pdw : data wrapper class object
     * @return : lead request
     */ 
    public static TRStore_LeadRequest.TRstoreOrders prepareData(PrepareDataWrapper pdw) {
        
        TRStore_LeadRequest.TRstoreOrders trStoreOrder = new TRStore_LeadRequest.TRstoreOrders();
        TRStore_LeadRequest.TRstoreOrder od = new TRStore_LeadRequest.TRstoreOrder();
        TRStore_LeadRequest.TRStorecustomerDetails cd = new TRStore_LeadRequest.TRStorecustomerDetails();
        TRStore_LeadRequest.TRStoreAccountDetails ad= new TRStore_LeadRequest.TRStoreAccountDetails();
        TRStore_LeadRequest.customerAddress ca = new  TRStore_LeadRequest.customerAddress();
        TRStore_LeadRequest.References ref = new TRStore_LeadRequest.References();
        TRStore_LeadRequest.ActionParams ap = new TRStore_LeadRequest.ActionParams();
        TRStore_LeadRequest.micrositeFieldsClass mfc = new TRStore_LeadRequest.micrositeFieldsClass();
        TRStore_LeadRequest.OnlineContactsFieldsClass olc  = new TRStore_LeadRequest.OnlineContactsFieldsClass();
        List<TRStore_LeadRequest.OnlineContactsFieldsClass> olcList = new List<TRStore_LeadRequest.OnlineContactsFieldsClass>();
        
        LIST<TRStore_LeadRequest.proviewIds> proviewids = new LIST<TRStore_LeadRequest.proviewIds>();
        TRStore_LeadRequest.proviewIds p1= new TRStore_LeadRequest.proviewIds();
        p1.pCode = '365214';
        proviewids.add(p1);
        
        LIST<TRStore_LeadRequest.OnlineContactsFieldsClass> proviewOnlineContacts = new LIST<TRStore_LeadRequest.OnlineContactsFieldsClass>();
        TRStore_LeadRequest.OnlineContactsFieldsClass poc = new TRStore_LeadRequest.OnlineContactsFieldsClass();
        poc.pFirstName = 'HelloName';
        poc.pLastName = 'HelloLastName';
        poc.pEmail = 'HelloName342@xingxong.com';
        poc.pTitle = 'Attorny';
        poc.pType = 'Contact';
        poc.jurisdiction = 'Test juri';
        poc.proviewProducts = proviewids;
        
        proviewOnlineContacts.add(poc);
        
          
        od.isExistingCustomer = false;
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
       
        
        ref.leadId= pdw.leadId;
        ref.cartId= pdw.cartId;
        ap.leadAction= pdw.actionParm;
                
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

    /** 
     * @description : test create lead
     */ 
    public static testMethod void testTRStoreCreateProcess(){
        
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
         String jsonMsg='{"trStoreOrder":{"OrderDetails":{ "isExistingCustomer":true, "LeadsourceCountryCode":"CA","customerDetails":{"firstName":"CustomerFirstName","lastName":"CustomerLastName","businessEmail":"customeremailtestFeb20@mailinator.com","isPhysicalSameAsBillingAddress":true,"isOLCAvailalble":true,"businessPhoneNumber":"(987) 654- 1230","shippingPhoneNumber":"(987) 654- 1230","organizationDetails":{"organizationName":"ABC Corp","AccountANumber":"1001000","organizationType":"SLF 2-3","billingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"1001000"}},"shippingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"12345"}},"micrositeFields":{"leadOriginCode":"PWC","chargeCode":"123","orderCompleted":true},"proviewContacts":[{"pFirstName":"proviewFirstName","pLastName":"proviewlastName","pEmail":"proview@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]},{"pFirstName":"proviewFirstName2","pLastName":"proviewlastName2","pEmail":"proview2@mailinator.com","pTitle":"proviewTitle","pType":"proviewType","jurisdiction":"District of Columbia","proviewId":"","proviewProducts":[{"pCode":"30844994","id":""},{"pCode":"30845197","id":""}]}]},"referencesDetails":{"leadId": "'+ ldb.id +'" ,"cartId": "'+  cartRec.id +'" },"actionParamsDetails":{"leadAction":"create"}}}';
       
         
        
        Test.startTest();
        createStaticValues();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/TRStoreLeadAPI';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        
        PrepareDataWrapper pdw1 = new PrepareDataWrapper();
        pdw1.lname = 'Sharma';
        pdw1.leadId = '';
        pdw1.actionParm = 'create';
        pdw1.cartId = cartRec.id;
        
        TRStore_LeadRequest.TRstoreOrders trStoreOrder = TRStore_LeadProcessTest.prepareData(pdw1);
        system.debug(loggingLevel.INFO,'olc contacts fromproview.............'+trStoreOrder);
        system.debug(loggingLevel.INFO,'olc contacts fromproview.............'+trStoreOrder.OrderDetails.proviewContacts);
        TRStore_LeadRequest.processLead(trStoreOrder);
        
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';
        ld.IsConverted=false;
        ld.Company='TCS';
        
        ld.Product_Configuration__c=cartRec.Id;
        insert ld;
        
        System.assertEquals( ld.Email , 'testfirst.testlast@test.com','invalid email');
 
        
        Online_Contacts__c onlineContact = new Online_Contacts__c();
                        
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
        TRStore_LeadRequest.TRstoreOrders trStoreOrder2 = TRStore_LeadProcessTest.prepareData(pdw2);
        TRStore_LeadRequest.processLead(trStoreOrder2);
        
        PrepareDataWrapper pdw3 = new PrepareDataWrapper();
        pdw3.lname ='sharma';
        pdw3.leadId = ld.id;
        pdw3.actionParm = 'AccountCheck'; 
        pdw3.cartId = cartRec.id;
        TRStore_LeadRequest.TRstoreOrders trStoreOrder3 = TRStore_LeadProcessTest.prepareData(pdw3);
        TRStore_LeadRequest.processLead(trStoreOrder3);
        
        PrepareDataWrapper pdw4 = new PrepareDataWrapper();
        pdw4.lname = null;
        pdw4.leadId = null;
        pdw4.actionParm = null;
        pdw4.cartId = null;
        TRStore_LeadRequest.TRstoreOrders trStoreOrder4 = TRStore_LeadProcessTest.prepareData(pdw4);
        TRStore_LeadRequest.processLead(trStoreOrder4);
        Test.stopTest();
     
        TRStoreLeadProcess_Createlead.updateMicrositeLeadOrder(ld.id, false);
        
    }
    
    /** 
     * @description : test lead convert
     */ 
    public static testMethod void testTRStoreConvertProcess(){
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
        ld.Phone = '(123) 654- 1230';
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
        ld2.Phone = '(123)  6545-  1230';
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
        LIST<contact> conList = new LIST<contact>();
        
        contact con = APTS_TestDataFactory.createContact('test',acc.id);
        con.FirstName='rohit';
        con.email = 'testtodayDec17_001@mailinator.com';
        conList.add(con);
          
        contact con2 = APTS_TestDataFactory.createContact('test',acc.id);
        con2.FirstName='Mallik';
        con2.email = 'testtodayDec17_001@mailinator.com';
        conList.add(con2);
        
        contact con3 = APTS_TestDataFactory.createContact('test',acc.id);
        con3.FirstName='Mallik';
        con3.email = 'testtodayDec17_002@mailinator.com';
        conList.add(con3);
        
        
        insert conList;
        
        
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
        req.requestURI = '/services/apexrest/TRStoreLeadAction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;

        TRStore_TransactMapAccount.fetchLeadDetails(new List<Lead>{ld2});
        
        Test.startTest();
        TRStoreLeadProcess_Convertlead cl1 = new TRStoreLeadProcess_Convertlead();
       TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails clwd1 = new TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails();
       clwd1.leadId = ld2.id;
       clwd1.cartId = cartRec.id;
       clwd1.emailId = 'rohit.sharma@thomsonreuters.com';
       clwd1.westAccNumber = null;
       
       TRStore_LeadRequest.TRStoreResponse leadConvertWrap = cl1.convertLead(clwd1);
             
             System.assertEquals( leadConvertWrap.responseCode , TRStoreConstants.SUCCESS_CODE, '400');
       
       
       
        Test.stopTest();
        
        
        
    }
    
    /** 
     * @description : Second Method to prepare test data
     */ 
    public static testMethod void testTRStoreConvertProcessTwo(){
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
        ld.Phone = '(123) 654- 1230';
        insert ld;
        
         
        
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
        req.requestURI = '/services/apexrest/TRStoreLeadAction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        
        Test.startTest();
        TRStoreLeadProcess_Convertlead cl2 = new TRStoreLeadProcess_Convertlead();
       TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails clwd2 = new TRStoreLeadProcess_Convertlead.ConvertLeadWrapperDetails();
       clwd2.leadId = ld.id;
       clwd2.cartId = cartRec.id;
       clwd2.emailId = 'rohit.sharma@thomsonreuters.com';
       clwd2.westAccNumber = '123456';
       TRStore_LeadRequest.TRStoreResponse leadConvertWrap =  cl2.convertLead(clwd2);
             
       System.assertEquals(leadConvertWrap.responseCode , TRStoreConstants.SUCCESS_CODE,'400');
        Test.stopTest();
        
        
        
    }
    
    /** 
     * @description : Create cart 
     * @return : cart record
     */ 
    public static Apttus_Config2__ProductConfiguration__c  createProductConfigurations() {
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        //insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        insert prodConfigObj;
        
        return prodConfigObj;
        
    }
    
    /** 
     * @description : create static values
     */ 
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
        
        Static_Values__c stusow = new Static_Values__c(name='TransactLeadOwnerGroupUS', value__c= userinfo.getUserName());
        Static_Values__c stcaow = new Static_Values__c(name='TransactLeadOwnerGroupCA', value__c= userinfo.getUserName());
        Static_Values__c stuest = new Static_Values__c(name='UECAPR', value__c= 'UE Store Canada PRINT');
        Static_Values__c stueoc = new Static_Values__c(name='TransactOrderConfirmationCode', value__c= 'OrderConfirmation');
        
        
        
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
        staticCSList.add(stcaow);
        staticCSList.add(stusow);
        staticCSList.add(stuest);
        staticCSList.add(stueoc);
         
         
        insert staticCSList;              
    }   
}