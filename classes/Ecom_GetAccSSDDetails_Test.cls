/* CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 23-07-2020   Rahul Natarajan         DLT-20035 - Remove Segmentation Field References from CX Digital components.
 * =============================================================================
 */
@isTest
public class Ecom_GetAccSSDDetails_Test {

    public static String accssdid;
    public static Source_System_Detail__c accountSSDlst;
    public static string assetLineItemId;

    @testSetup
    public static void createData() {

        KeyValueListStore__c testKeyValueSetting = new KeyValueListStore__c();
        testKeyValueSetting.name = 'ANZUsersProfileId';
        testKeyValueSetting.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;

        insert testKeyValueSetting;

        List < RecordtypeIds__c > rectype = new List < RecordtypeIds__c > ();
        RecordtypeIds__c RecordtypeIds = new RecordtypeIds__c();
        RecordtypeIds.name = 'Pre-Pipeline Opportunities';
        RecordtypeIds.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;
        rectype.add(RecordtypeIds);

        RecordtypeIds__c RecordtypeIds1 = new RecordtypeIds__c();
        RecordtypeIds1.name = 'Pipeline Opportunities';
        RecordtypeIds1.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;
        rectype.add(RecordtypeIds1);
        insert rectype;

        WebServiceSettings__c web1Service = new WebServiceSettings__c();
        web1Service.Endpoint__c = 'test.endpoint';
        web1Service.Name = 'ODTReactivateEntitlementService';
        web1Service.Username__c = 'test.user';
        web1Service.Password__c = 'test:123';
        web1Service.Service_Unavailable_Message__c = 'testservice';
        insert web1Service;

        List < WebServiceSettings__c > WebserviceList = new List < WebServiceSettings__c > {
            new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
            new WebServiceSettings__c(Name = 'PaymentCreditIncrease', Endpoint__c = 'https://securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease', Service_Unavailable_Message__c = 'Service not Available')
        };
        insert WebserviceList;

        //LCRMLeadTerritoryService.stopTrigger();

        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true;
        APTS_ProductConfigurationTriggerHandler.afterInsert = true;

        String accountName = 'TestAccount';
        Account acc = DCTestData.createAccount(accountName);
        acc.Is_GLI__c = true;
        insert acc;
        Source_System_Detail__c ssd = createSourceSystemDetail(acc);
        Opportunity opp = DCTestData.createOpportunityRec('TestOpty', acc.Id, 'Order Complete', System.Today() + 30, String.valueOf(ssd.Id));
        opp.Reason__c = 'Budget';
        insert opp;

        Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;


        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opp.Id;
        insert quote;
        Apttus_Config2__ProductConfiguration__c cart = DCTestData.createCart(acc.id, quote.Id, null, priceList.Id);
        insert cart;

        Product2 p1 = DCTestData.createProduct('WestLaw Product', '41053157', '41053157', 'Arizona');

        List < Apttus_Config2__LineItem__c > listLines = new List < Apttus_Config2__LineItem__c > ();
        Apttus_Config2__LineItem__c line1 = DCTestData.createLineItem(cart.Id, 1, 1, true, 'Product/Service', p1.id, null, 2, priceList.Id, null, false, false);
        listLines.add(line1);

        Apttus_Config2__LineItem__c line2 = DCTestData.createLineItem(cart.Id, 1, 1, true, 'Product/Service', p1.id, null, 2, priceList.Id, null, false, true);
        listLines.add(line2);
        Insert listLines;


        createAssetLineItem(quote.Id, p1.id);



        LIST < WebServiceSettings__c > webList = new LIST < WebServiceSettings__c > ();
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'ODTGenericEntitlementService';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        webList.add(web);


        insert webList;


    }
    public static Ecom_GetAccSSDDetailsRequest createRequest(String accNum, String zipCode, String storeName) {
        Ecom_GetAccSSDDetailsRequest.cls_GetAccSSDDetailsRequest reqObj = new Ecom_GetAccSSDDetailsRequest.cls_GetAccSSDDetailsRequest();
        reqObj.AccountNumber = accNum;
        reqObj.zipCode = zipCode;
        reqObj.storeName = storeName;

        Ecom_GetAccSSDDetailsRequest.cls_validations validationObj = new Ecom_GetAccSSDDetailsRequest.cls_validations();
        validationObj.creditCheck = true;
        validationObj.activeOnlineSubsCheck = true;
        validationObj.inactiveOnlineSubsCheck = true;

        Ecom_GetAccSSDDetailsRequest request = new Ecom_GetAccSSDDetailsRequest(reqObj, validationObj);
        return request;
    }
    @isTest
    public static void start1() {

        List < Source_System_Detail__c > ssd = [SELECT id, name, Source_System_Account_Number__c, Postal_Code__c FROM Source_System_Detail__c LIMIT 1];
        Test.startTest();

        Ecom_GetAccSSDDetailsRequest request = createRequest('12345', '00000', ''); //new Ecom_GetAccSSDDetailsRequest(reqObj,validationObj);

        try {
            Ecom_GetAccSSDDetailsService.getAccSSDDetailsResponse response = Ecom_GetAccSSDDetailsService.api(null);
            System.assertEquals(1002, response.responseCode);


            response = Ecom_GetAccSSDDetailsService.api(request);
            system.debug(response);

            System.assertEquals(1001, response.responseCode);
        } catch (Exception ex) {}
        Test.stopTest();
    }

    @isTest
    public static void testCreditCheck() {
        LTS_Disable_Application_Automation__c auto = LTS_Disable_Application_Automation__c.getInstance(UserInfo.getOrganizationId());
        auto.LTS_Disable_Process_Builders__c = true;
        auto.LTS_Disable_Workflow_Rules__c = false;
        auto.LTS_Disable_Triggers__c = true;
        upsert auto;
        List < Source_System_Detail__c > ssd = [SELECT id, name, Source_System_Account_Number__c, Postal_Code__c, LCRM_Credit_Risk_Category__c FROM Source_System_Detail__c LIMIT 1];
        ssd[0].LCRM_Credit_Risk_Category__c = 'West Bankruptcy Customers';
        update ssd;
        Test.startTest();
        Ecom_GetAccSSDDetailsRequest request = createRequest(ssd[0].Source_System_Account_Number__c, ssd[0].Postal_Code__c, '');
        try {
            Ecom_GetAccSSDDetailsService.getAccSSDDetailsResponse response = Ecom_GetAccSSDDetailsService.api(request);
            System.assertEquals(1003, response.responseCode);
        } catch (Exception ex) {}
        Test.stopTest();

    }
    @isTest
    public static void testSubscription() {
        List < Source_System_Detail__c > ssd = [SELECT id, name, Source_System_Account_Number__c, Postal_Code__c, LCRM_Credit_Risk_Category__c FROM Source_System_Detail__c LIMIT 1];
        ssd[0].LCRM_Credit_Risk_Category__c = '';
        update ssd;


        Test.startTest();
        Ecom_GetAccSSDDetailsRequest request = createRequest(ssd[0].Source_System_Account_Number__c, ssd[0].Postal_Code__c, '');
        //HTTPResponse result = Ecom_GetAccSSDDetailsService.getEntitlementDetails(ssd[0].Source_System_Account_Number__c);
        try {
            Ecom_GetAccSSDDetailsService.getAccSSDDetailsResponse res = Ecom_GetAccSSDDetailsService.api(request);
            Ecom_GetAccSSDDetailsService Service = new Ecom_GetAccSSDDetailsService();
            Ecom_GetAccSSDDetailsService.getAccSSDDetailsResponse response = Service.ValidateAccount(ssd[0].Source_System_Account_Number__c, res, true, true);
            //System.assertEquals(200, response.responseCode);
        } catch (Exception ex) {}
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        Test.stopTest();

    }


    @isTest
    public static void testFindLawSubscription() {
        LTS_Disable_Application_Automation__c auto = LTS_Disable_Application_Automation__c.getInstance(UserInfo.getOrganizationId());
        auto.LTS_Disable_Process_Builders__c = true;
        auto.LTS_Disable_Workflow_Rules__c = false;
        auto.LTS_Disable_Triggers__c = true;
        upsert auto;

        List < Source_System_Detail__c > ssd = [SELECT id, name, Source_System_Account_Number__c, Postal_Code__c, LCRM_Credit_Risk_Category__c FROM Source_System_Detail__c LIMIT 1];
        ssd[0].LCRM_Credit_Risk_Category__c = '';
        update ssd;

        List < Product2 > pvalues = [Select id, ProductCode from Product2 WHERE ProductCode =: '41053157'
            LIMIT 1
        ];


        List < Apttus_Proposal__Proposal__c > quote = [SELECT id, Name FROM Apttus_Proposal__Proposal__c LIMIT 1];
        List < Apttus_Config2__LineItem__c > lineItemList = [Select id, Apttus_Config2__EndDate__c, APTS_Media_High_Level__c, Apttus_Config2__ProductId__c, Apttus_Config2__AssetLineItemId__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c
            from Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =: quote[0].Id LIMIT 3
        ];

        List < Apttus_Config2__AssetLineItem__c > assetLineItemResult = [select id, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__AssetStatus__c, APTS_SSD_Sold_To__c
            from Apttus_Config2__AssetLineItem__c WHERE Apttus_Config2__ProductId__r.ProductCode =: '41053157'
            LIMIT 8
        ];
        System.debug('check test asset be4 result====' + assetLineItemResult);
        for (Apttus_Config2__AssetLineItem__c ali: assetLineItemResult) {
            ali.APTS_SSD_Sold_To__c = ssd[0].Id;
        }
        update assetLineItemResult;

        System.debug('check test asset result====' + assetLineItemResult);
        System.debug('check test line result====' + lineItemList);


        Test.startTest();
        Ecom_GetAccSSDDetailsRequest request = createRequest(ssd[0].Source_System_Account_Number__c, ssd[0].Postal_Code__c, 'FindLaw');
        //HTTPResponse result = Ecom_GetAccSSDDetailsService.getEntitlementDetails(ssd[0].Source_System_Account_Number__c);
        try {
            Ecom_GetAccSSDDetailsService.getAccSSDDetailsResponse res = Ecom_GetAccSSDDetailsService.api(request);
            Ecom_GetAccSSDDetailsService Service = new Ecom_GetAccSSDDetailsService();
            Ecom_GetAccSSDDetailsService.getAccSSDDetailsResponse response = Service.ValidateAccount(ssd[0].Source_System_Account_Number__c, res, true, true);


            //for cancelled Assetline item
            for (Apttus_Config2__AssetLineItem__c ali: assetLineItemResult) {
                ali.APTS_SSD_Sold_To__c = ssd[0].Id;
                ali.Apttus_Config2__AssetStatus__c = 'Cancelled';
            }
            update assetLineItemResult;

            for (Apttus_Config2__LineItem__c lineItem: lineItemList) {
                lineItem.Apttus_Config2__AssetLineItemId__c = assetLineItemResult[0].Id;

            }
            update lineItemList;

            response = Ecom_GetAccSSDDetailsService.api(request);
            //System.assertEquals(1004, response.responseCode);
            //Test.startTest();
            //test case for asset more than 120 days
            for (Apttus_Config2__LineItem__c lineItem: lineItemList) {
                lineItem.Apttus_Config2__AssetLineItemId__c = assetLineItemResult[0].Id;
                lineItem.Apttus_Config2__EndDate__c = System.today().addDays(-180);
            }
            update lineItemList;
            response = Ecom_GetAccSSDDetailsService.api(request);

            //System.assertEquals(200, response.responseCode);
        } catch (Exception ex) {}
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        Test.stopTest();

    }



    public static Account createAccount(String name) {
        // Commented Segmentation Field - DLT-20035   
        Account acc = new Account(Name = name);
        //  acc.FrozenMarketSegment__c = 'Solo Law Firm';
        acc.SAPAccountNumber__c = '1004284494';
        //  acc.Customer_Group__c = 'FIRM';
        acc.APTS_Band_Number__c = 1;
        acc.APTS_Customer_Category__c = '3';
        acc.APTS_eOutput_Eligibilty__c = '';

        return acc;
    }

    public static Source_System_Detail__c createSourceSystemDetail(Account acc) {

        Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD = new Source_System_Detail__c();
        accountSSD.RecordtypeId = ssdRecorType;
        accountSSD.Name = 'TestAccount';
        accountSSD.Source_System_Name__c = 'TestAccount';
        accountSSD.Account_Name__c = acc.ID;
        accountSSD.Account_Inactive__c = false;
        accountSSD.Source_System_Account_Number__c = '1004284494'; //acc.SAPAccountNumber__c;    
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
        accountSSD.LCRM_SAP_Account_Number__c = '1004284494';
        accountSSD.LCRM_APTS_Band_Number__c = 1;
        accountSSD.APTS_Customer_Category__c = '3';
        accountSSD.LCRM_eOutput_Eligibility__c = '';
        accountSSD.LCRM_Sales_Org__c = 'WEST';
        accountSSD.State__c = 'California';
        accountSSD.LCRM_Customer_Group__c = 'FIRM';
        accountSSD.Number_Street__c = '1170 Northwood Drive';
        accountSSD.City__c = 'Eagan';
        accountSSD.State__c = 'MN';
        accountSSD.Country__c = 'US';
        accountSSD.Postal_Code__c = '55121';
        accountSSD.LCRM_Phone__c = '9912112122';
        accountSSD.LCRM_Email__c = 'shiva@abc.com';

        insert accountSSD;
        accssdid = accountSSD.id;
        accountSSDlst = accountSSD;
        return accountSSD;

    }

    public static void createAssetLineItem(String proposalId, String productId) {
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_QPConfig__ProposalId__c = proposalId;
        ali.Apttus_Config2__ProductId__c = productId;
        //ali.APTS_SAP_Deal_Type__c = 'TO00';
        insert ali;
        assetLineItemId = ali.Id;
    }


}