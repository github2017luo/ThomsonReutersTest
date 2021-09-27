/* Class: DCP_OrderTest
 * Purpose: This class is unit test class for DCP_OrderService
 * Created: 16-Jun-2021
 * Author: Kanishk Singhvi
 * 
 * CHANGE HISTORY
 * =============================================================================
 * Date           Name             JIRA        Description
 * 16-Jun-2021   Kanishk Singhvi  DCP-1694     Order service test
 * 23-Aug-2021   Anitha Kodimyala DCP-2451     Order service changes test
 * =============================================================================
 */
@isTest(seeAllData = false)
public class DCP_OrderTest {
    @testSetup static void properTestData() {
        Map < String, Id > proposalMap = new Map < String, Id > ();
        DCPTestDataFactory.disableApplicationAutomation();
        // insert static values
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePELeadConvertCode', value__c='LeadConvert'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='NewSaleOrderConfirmation', value__c='OrderConfirmation'),
            new Static_Values__c(name='LeadSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='DocusignDelayTimer', value__c='3'),
            new Static_Values__c(name='DCPCCVersion', value__c='v1'),
             new Static_Values__c(name='DCPOrderVersioning', value__c='v2')
            };
        insert staticCSList;
        
          LTS_Disable_Application_Automation__c lts = new LTS_Disable_Application_Automation__c(LTS_Disable_Process_Builders__c=true, LTS_Disable_Validation_Rules__c=true);
         insert lts;
        
        Apttus_Config2__PriceList__c plSO1 = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO1;


        Profile p = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'AND Profile.id =:p.id limit 1];
        LIST<KeyValueListStore__c> keyValueList = new LIST<KeyValueListStore__c>();
        KeyValueListStore__c kv = new KeyValueListStore__c(TextValue__c=p.id, name='ANZUsersProfileId' );
         KeyValueListStore__c kv1 = new KeyValueListStore__c(TextValue__c='Content,Functionality', name='ReasonWithCompetitor');
        keyValueList.add(kv);
        keyValueList.add(kv1);
        insert keyValueList;
        
        string rtId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        string rtId2 = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        LIST < RecordtypeIds__c > rtIds = new LIST < RecordtypeIds__c > ();

        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c = rtId);
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c = rtId2);
        rtIds.add(rt);
        rtIds.add(rt2);
        insert rtIds;
        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;

        product2 pd1 = new product2();
        pd1.Name = 'Test Product';
        pd1.ProductCode = '98765';
        pd1.Description = 'Test Desc';
        pd1.Service_Number__c = '87654';
        pd1.product_offering__c = 'Test';
        pd1.Apttus_Filter_Jurisdiction__c = 'Colorado';
        pd1.Practice_Area__c = 'General';
        pd1.APTS_Media_High_Level_Code__c = '21';
        pd1.APTS_Item_Category_Group__c = 'ZVSU';
        pd1.APTS_Media_Lower_Level_Code__c = 'F4';
        pd1.LCRM_Sub_Bu__c = 'USL';
        pd1.Format__c = 'eBook';
        pd1.IsActive = true;
        pd1.Apttus_Config2__HasOptions__c = false;
        pd1.Apttus_Config2__HasAttributes__c = false;
        pd1.Apttus_Config2__HasDefaults__c = false;
        pd1.CPD_Sellable_Description__c = 'Display and Sell';
        insert pd1;

        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;

        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO.Apttus_Config2__ProductId__c = pd1.id;
        pliSo.Apttus_Config2__ChargeType__c = 'Standard Price';
        pliSO.Apttus_Config2__PriceType__c = 'One time';
        pliSO.Apttus_Config2__Frequency__c = 'One time';
        pliSO.Apttus_Config2__ListPrice__c = 80;


        database.insert(pliSO, true);
        // insert acc
        Account acc = APTS_TestDataFactory.createAccount('Test');
        Insert acc;

        APTS_Product_Variant__c prodVar = new APTS_Product_Variant__c(Name = 'Test1', APTS_Product_ID__c = pd1.Id, APTS_Product_Delivery__c = 'eBook');
        insert prodVar;
        // insert ssd
        Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD = new Source_System_Detail__c(RecordtypeId = ssdRecorType, Name = 'ABC', Source_System_Name__c = 'ABC', Account_Name__c = acc.ID, APTS_Customer_Category__c = '1',
            LCRM_Customer_Group__c = 'Academic', Account_Inactive__c = false, LCRM_Sales_Org__c = 'WEST', Source_System_Account_Number__c = '123456',
            LCRM_Name_2__c = 'DEF', LCRM_Name_3__c = 'XYZ', Number_Street__c = 'Street5', LCRM_Street_2__c = 'Street2', LCRM_Street3__c = 'Street3', LCRM_Street4__c = 'Street4',
            City__c = 'TestCity', State__c = 'ON', Country__c = 'US', Postal_Code__c = '12345', LCRM_Phone__c = '9876540000', LCRM_Fax__c = '8765432109', LCRM_PO_Box__c = 'PO-156');
        insert accountSSD;

        Source_System_Detail__c accountSSD1 = new Source_System_Detail__c(RecordtypeId = ssdRecorType, Name = 'ABCD', Source_System_Name__c = 'ABCD', Account_Name__c = acc.ID, APTS_Customer_Category__c = '1',
            LCRM_Customer_Group__c = 'Academic', Account_Inactive__c = false, LCRM_Sales_Org__c = 'WEST', Source_System_Account_Number__c = '123456',
            LCRM_Name_2__c = 'DEF', LCRM_Name_3__c = 'XYZ', Number_Street__c = 'Street5', LCRM_Street_2__c = 'Street2', LCRM_Street3__c = 'Street3', LCRM_Street4__c = 'Street4',
            City__c = 'TestCity', State__c = 'ON', Country__c = 'US', Postal_Code__c = 'V1A 0X1', LCRM_Phone__c = '9876540001', LCRM_Fax__c = '8765432109', LCRM_PO_Box__c = 'PO-156');
        insert accountSSD1;

        // insert contact
        contact con = APTS_TestDataFactory.createContact('test', acc.id);
        con.FirstName = 'Amy';
        insert con;

        //create opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = rt.recTypeId__c;
        opp.Owner = u;
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        opp.Pricebook2id = pbook.id;
        opp.Source_System_Detail__c = accountSSD.Id;
        opp.ShipTo_Source_System_Detail__c = accountSSD1.id;
        insert opp;
       
        Apttus_Proposal__Proposal__c propObj = APTS_TestDataFactory.createProposal(opp.Id, AccountSSD.Id);
        propObj.Apttus_QPConfig__PriceListId__c = plSO1.Id;
        propObj.APTS_Proposal_Business_Unit__c = 'SCS';
        propObj.APTS_Authorization_Number__c = '123';  
        insert propObj;
        proposalMap.put('proposalId', propObj.Id);

        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__Status__c = 'New';
        prodConfigObj.Apttus_Config2__BusinessObjectId__c = propObj.Id;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigObj.Apttus_Config2__PriceListId__c = plSO1.Id;
        insert prodConfigObj;
        proposalMap.put('prodConfigId', prodConfigObj.Id);

        Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
        lineSO.Apttus_Config2__ConfigurationId__c = prodConfigObj.Id;
        lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
        lineSO.Mark_Removed__c = true;
        lineSO.Apttus_Config2__LineNumber__c = 1;
        lineSO.Apttus_Config2__PrimaryLineNumber__c = lineSO.Apttus_Config2__LineNumber__c;
        lineSO.Apttus_Config2__ItemSequence__c = lineSO.Apttus_Config2__LineNumber__c;
        lineSO.Apttus_Config2__IsPrimaryLine__c = true;
        lineSO.Apttus_Config2__NetPrice__c = 80.00;
        lineSO.Apttus_Config2__ProductId__c = pd1.Id;
        insert lineSO;
        proposalMap.put('lineId', lineSO.Id);

        // insert lead
        lead ld = new lead();
        ld.FirstName = 'Amy';
        ld.Lead_region__c = 'TR Store Canada Print';
        ld.LastName = 'anto';
        ld.Email = 'testfirst.testfirst@test.com';
        ld.IsConverted = true;
        ld.Company = 'TCS';
        ld.Product_Configuration__c = proposalMap.get('prodConfigId');
        ld.ConvertedAccountId = acc.id;
        ld.ConvertedContactId = con.id;
        ld.ConvertedOpportunityId = opp.id;
        ld.TRstore_Billadd_differenceto_shipping__c = true;
        ld.Language_Preference__c = 'English';
        insert ld;
        proposalMap.put('lead1', ld.id);
        // insert lead
        lead ld2 = new lead();
        ld2.FirstName = 'Test';
        ld2.LastName = 'Lead';
        ld2.Email = 'testfirst.testlast@test.com';
        ld2.IsConverted = true;
        ld2.Company = 'TCS';
        ld2.Product_Configuration__c = proposalMap.get('prodConfigId');
        ld2.Billing_Street__c = 'Banito Blanco 822';
        ld2.Billing_City__c = 'New Yark';
        ld2.Billing_State__c = 'New yark';
        ld2.Billing_Country__c = 'United States';
        ld2.Billing_Zip__c = '51123';
        ld2.TRstore_Billadd_differenceto_shipping__c = false;
        ld2.Street = 'Banito Blanco 823';
        ld2.City = 'Toronto';
        ld2.State = 'ON';
        ld2.Country = 'CA';
        ld2.PostalCode = '12345';
        ld2.SAPAccountNumber__c = '';
        ld2.ConvertedAccountId = acc.id;
        ld2.ConvertedContactId = con.id;
        ld2.ConvertedOpportunityId = opp.id;
        insert ld2;
        proposalMap.put('lead2', ld2.id);

        Online_Contacts__c onlineContact = new Online_Contacts__c();

        onlineContact.First_Name__c = 'pFirstName';
        onlineContact.Last_Name__c = 'pLastName';
        onlineContact.Email__c = 'pEmail@mailinator.com';
        onlineContact.WLEc_Juris__c = 'jurisdiction';
        onlineContact.Position__c = 'pTitle';
        onlineContact.Type__c = 'pType';
        onlineContact.Lead__c = ld.Id;
        onlineContact.QuoteId__c = propObj.Id;
        onlineContact.Product_Configuration__c = proposalMap.get('prodConfigId');
        insert onlineContact;

        Customer_Master_Contacts__c msd = new Customer_Master_Contacts__c();
        msd.First_Name__c = 'FirstName';
        msd.Last_Name__c = 'pLastName';
        msd.Email_Address__c = 'pEmail@mailinator.com';
        msd.Lead__c = ld.Id;
        msd.Quote__c = propObj.Id;
        msd.Material__c = '25478';
        insert msd;
        //return proposalMap;
    }

    /********************************************************************************************************
     *  @description Prepare test data
     
     *********************************************************************************************************/
    @isTest static void testData() {
        test.startTest();
         // insert static values
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePELeadConvertCode', value__c='LeadConvert'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='NewSaleOrderConfirmation', value__c='OrderConfirmation'),
            new Static_Values__c(name='LeadSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='DocusignDelayTimer', value__c='3'),
            new Static_Values__c(name='DCPCCVersion', value__c='v1')
            };
        insert staticCSList;
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        System.assert(oWebServiceSettings != null, 'Inserted webserviceList');

        MAP < string, id > billingAndShippingMap = new MAP < string, id > ();
        List<Source_System_Detail__c> ssdList= [Select id from Source_System_Detail__c limit 2];
        billingAndShippingMap.put('shipTo', ssdList[0].id);
        billingAndShippingMap.put('BillTo', ssdList[1].id);

        DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        DCP_OrderService.CCInformation ccInform = new DCP_OrderService.CCInformation();
        Lead ld = [Select id from Lead limit 1];
        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c limit 1];
        orderReq.quoteId = String.valueOf(prop.Id);
        orderReq.emailId = 'email2@email.com';
        orderReq.accNumber = '';
        orderReq.autopay = 'true';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '-E343-6785-5YMB44533000000D';
        orderReq.cardType = 'VISA';
        orderReq.cardLast4Digit = '1234';
        ccInform.authorizationNumber = '123';
        ccInform.transactionId='123';  
        ccInform.ccVendorTransactionId = '123'; 
        ccInform.transactionMessageType = '123';
        orderReq.cardExpiry = '1225';
        orderReq.site = 'UEUS';
        orderReq.requestFor = 'OrderConfirmation';
        orderReq.ccInfo = ccInform;
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead'};
            DCPOrderConfirmationQueue.logExceptions(errorHandlerMap);

        
    }
    /********************************************************************************************************
     * @description :test data 1
     
     *********************************************************************************************************/
    @isTest static void runNegativeLogic() {
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings; 
        System.assert(oWebServiceSettings != null, 'Inserted webserviceList');

        DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        Lead ld = [Select id from Lead limit 1];

        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        DCP_OrderService.CCInformation ccInform = new DCP_OrderService.CCInformation();
        List<Apttus_Proposal__Proposal__c> prop = [Select id,APTS_Authorization_Number__c from Apttus_Proposal__Proposal__c  limit 1];
        
        orderReq.quoteId = String.valueOf(prop[0].Id);
        orderReq.emailId = 'email@email.com';
        orderReq.accNumber = '';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '-E343-6785-5YMB44533000000D';
        orderReq.cardType = 'VISA';
        orderReq.cardLast4Digit = '1234';
        orderReq.cardExpiry = '1225';
        orderReq.autopay = 'true';
        orderReq.site = 'UEUS';
        orderReq.requestFor = 'OrderConfirmation';
        ccInform.authorizationNumber = '123';
        ccInform.transactionId='123';  
        ccInform.ccVendorTransactionId = '123'; 
        ccInform.transactionMessageType = '123';
        orderReq.ccInfo = ccInform;
        RestRequest req;
        req = new RestRequest();
        DCP_OrderService.DCP_OrderServiceResponse res;
        //Test.setMock(HttpCalloutMock.class, new DCP_CCAUTHMockResponse());
        test.startTest();
        res = DCP_OrderService.getDetailsForOrderSubmission(orderReq);
        Map<String,String> resMap = new Map<String,String>{'quoteId'=>orderReq.quoteId,'leadId'=>orderReq.leadId,'cartId'=>orderReq.cartId,'emailId'=>orderReq.emailId};
        System.enqueueJob(new DCPOrderConfirmationQueue(resMap));
        /*System.enqueueJob(new DCPDocusignBatchController(prop.id));
        System.enqueueJob(new DCPNewSaleCreateEnvQueue(prop.id));*/
        
        test.stoptest();
    }
    
    @isTest static  void testccAuthCallout() {
       DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        Lead ld = [Select id from Lead limit 1];
        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c limit 1];
        orderReq.quoteId = String.valueOf(prop.Id);
        orderReq.emailId = 'email@email.com';
        orderReq.accNumber = '';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '-E343-6785-5YMB44533000000D';
        orderReq.cardType = 'VISA';
        orderReq.cardLast4Digit = '1234';
        orderReq.cardExpiry = '1225';
        orderReq.site = 'UEUS';
        orderReq.autopay = 'true';
        orderReq.requestFor = 'OrderConfirmation';
        String sandboxName = 'CCAUTH';//URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = 'callout:Transact_test_Auth';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
        DCP_CCAuth cc = new DCP_CCAuth();    
        Test.setMock(HttpCalloutMock.class, new DCP_CCAUTHMockResponse());

        DCP_CCAuth.AuthResponse response = cc.processRequest(orderReq);
        System.assert(true, response<>null);
    }

  @isTest static  void testccAuthPRODCallout() {
    DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        Lead ld = [Select id from Lead limit 1];
        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c limit 1];
        orderReq.quoteId = String.valueOf(prop.Id);
        orderReq.emailId = 'email@email.com';
        orderReq.accNumber = '';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '-E343-6785-5YMB44533000000D';
        orderReq.cardType = 'VISA';
        orderReq.cardLast4Digit = '1234';
        orderReq.cardExpiry = '1225';
        orderReq.site = 'UEUS';
        orderReq.requestFor = 'OrderConfirmation';
        orderReq.autopay = 'true';
        String sandboxName = 'CCAUTH';
        Static_Values__c staticValues = new Static_Values__c();
        Static_Values__c st = new Static_Values__c(name='DCPCCVersion', value__c='v3');
        insert st;
        staticValues.Value__c = 'callout:Transact_test_Auth';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
        DCP_CCAuth cc = new DCP_CCAuth();    
    Test.setMock(HttpCalloutMock.class, new DCP_CCAUTHMockResponse());

        DCP_CCAuth.AuthResponse response = cc.processRequest(orderReq);
        System.assert(true, response<>null);
    }
    
    @isTest static  void testccAuthFakeCallout() {
    DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        Lead ld = [Select id from Lead limit 1];
        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c limit 1];
        orderReq.quoteId = String.valueOf(prop.Id);
        orderReq.emailId = 'email@email.com';
        orderReq.accNumber = '';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '-E343-6785-5YMB44533000000D';
        orderReq.cardType = 'VISA';
        orderReq.cardLast4Digit = '1234';
        orderReq.autopay = 'true';
        orderReq.cardExpiry = '1225';
        orderReq.site = 'UEUS';
        orderReq.requestFor = 'OrderConfirmation';
        String sandboxName = 'CCAUTH';//URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = 'callout:Transact_test_Auth';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
        DCP_CCAuth cc = new DCP_CCAuth();
        cc.fakeItForTest = true;
    Test.setMock(HttpCalloutMock.class, new DCP_CCAUTHMockResponse());

        DCP_CCAuth.AuthResponse response = cc.processRequest(orderReq);
        System.assert(true, response<>null);
    }
    
    @isTest static  void testccAuthImproperReqCallout() {
     DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        Lead ld = [Select id from Lead limit 1];
        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c limit 1];
        orderReq.quoteId = String.valueOf(prop.Id);
        orderReq.emailId = 'email@email.com';
        orderReq.accNumber = '';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '-E343-6785-5YMB44533000000D';
        orderReq.cardType = 'VISA';
        orderReq.cardLast4Digit = '1234';
        orderReq.autopay = 'false';
        orderReq.cardExpiry = '1225';
        orderReq.site = 'UEUS';
        orderReq.requestFor = 'OrderConfirmation';
         String sandboxName = 'CCAUTH';//URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = '';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
         DCP_CCAuth cc = new DCP_CCAuth();
    Test.setMock(HttpCalloutMock.class, new DCP_CCAUTHMockResponse());

        DCP_CCAuth.AuthResponse response = cc.processRequest(orderReq);
        System.assert(true, response<>null);
    }
    
    
    @isTest static  void testccAuthEmptyReqCallout() {
    DCP_OrderService.DCP_OrderRequestClass orderReq = new DCP_OrderService.DCP_OrderRequestClass();
        Lead ld = [Select id from Lead limit 1];
        orderReq.leadId = String.valueOf(ld.Id);
        Apttus_Config2__ProductConfiguration__c pc = [Select id from Apttus_Config2__ProductConfiguration__c limit 1];
        orderReq.cartId = String.valueOf(pc.Id);
        Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c limit 1];
        orderReq.quoteId = String.valueOf(prop.Id);
        orderReq.emailId = 'email@email.com';
        orderReq.accNumber = '';
        orderReq.paymentOption = 'Credit Card';
        orderReq.cardToken = '';
        orderReq.cardType = '';
        orderReq.cardLast4Digit = '';
        orderReq.cardExpiry = '';
        orderReq.autopay = 'false';
        orderReq.site = 'UEUS';
        orderReq.requestFor = 'OrderConfirmation';
         DCP_CCAuth cc = new DCP_CCAuth();
        cc.fakeItForTest = true;
        DCP_CCAuth.AuthResponse response = cc.processRequest(orderReq);
        System.assert(true, response<>null);
         Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead'};
            DCPOrderConfirmationQueue.logExceptions(errorHandlerMap);
}

}