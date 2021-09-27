/* CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-10-25   Dev Team                Created   
 * 2018-06-11   Harika Sai P            DLT-9765 - Optimized the class and added SSD reference in the test method. 
 * 2018-12-20   Benjamin Her            DLT-14153 - Code Scan fixes
 * 2020-06-29   Brenda Shields          DLT-20241 - Increase code coverage
 * 23-07-2020   Rahul Natarajan         DLT-20035 - Remove Segmentation Field References from CX Digital components.
 * =============================================================================
 */
@istest
public class DCBundleSynchronizeControllerTest {
    private static Account a;
    private static Apttus_Config2__PriceList__c priceList;
    private static Source_System_Detail__c accountSSD;

    //public static String cQuoteID;
    @testSetup
    static void setupData() {
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Apttus_Proposal__Proposal__c proposal = [select id, APTS_Approval_Segment__c from Apttus_Proposal__Proposal__c limit 1];

        proposal = prepareCommonTestData();
        insert proposal;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';
        oWebServiceSettings.Name = 'PaymentCreditIncrease';
        oWebServiceSettings.Timeout__c = 120;
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        Test.stopTest();
    }
    private static testMethod void doTest() {
        Apttus_Proposal__Proposal__c proposal = [select id from Apttus_Proposal__Proposal__c limit 1];
        List < Apttus_Config2__ProductConfiguration__c > prodConfigList = [select id, Apttus_QPConfig__Proposald__c, Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c];
        Apttus_Config2__ProductConfiguration__c prodConfig = prodConfigList[0];
        List < Apttus_Config2__LineItem__c > listOfLineItems = New List < Apttus_Config2__LineItem__c > ();
        priceList = [select id from Apttus_Config2__PriceList__c limit 1];
        List < Apttus_Config2__PriceListItem__c > listOfPriceListItems = new List < Apttus_Config2__PriceListItem__c > ();
        listOfPriceListItems = DCTestData.createPriceListItems(priceList.Id, 3);
        Product2 prodObj = new product2();
        prodObj = DCTestData.createProduct('Network Services 1.0', '05', true);
        Product2 prod2Obj = new product2();
        prod2Obj = DCTestData.createProduct('Network Services 2.0', '21', false);
        Product2 prod3Obj = new Product2();
        prod3Obj = DCTestData.createProduct('Network Services 2.0', '21', false);


        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_QPConfig__ProposalId__c = proposal.Id;
        insert ali;
        listOfLineItems = [select id from Apttus_Config2__LineItem__c];
        Test.startTest();
        List < Apttus_Config2__ProductAttributeValue__c > pavObj = new List < Apttus_Config2__ProductAttributeValue__c > ();
        for (Apttus_Config2__LineItem__c lineItem: listOfLineItems) {
            pavObj.add(new Apttus_Config2__ProductAttributeValue__c(eBook_Purchase_Options__c = 'APP', APTS_FillUp_Start_Date__c = date.today(),
                Apttus_Config2__LineItemId__c = lineItem.id));
        }
        insert pavObj;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Incremental_Revenue_Required__c = 2;
        insert bundlePageSettings;
        System.debug('prodConfig.id ---------' + prodConfig.id);
        DCDynamicBundle.performBundling('Bundle A', prodConfigList);
        List < String > str = new List < String > ();
        str.add(proposal.id);
        DCBundleSynchronizeController.DynamicBundleRequest req1 = new DCBundleSynchronizeController.DynamicBundleRequest();
        req1.quoteIds = str;
        String msgbody = JSON.serializePretty(req1);


        try {
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/digitalconfigurator/bundleSynchronize/'; //Request URL
            req.httpMethod = 'POST'; //HTTP Request Type
            req.requestBody = Blob.valueof(msgbody);
            RestContext.request = req;
            RestContext.response = res;
            DCBundleSynchronizeController.DynamicBundleResponse resp = new DCBundleSynchronizeController.DynamicBundleResponse();
            resp = DCBundleSynchronizeController.bundleAndSynchronize();
            //For Assersion 
            system.assertEquals(resp.responseCode, 200);
            List < Apttus_Config2__ProductConfiguration__c > configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,
                Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                Apttus_Config2__AccountId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c
                WHERE Apttus_QPConfig__Proposald__c =: proposal.Id AND Apttus_Config2__Status__c = 'Finalized'
                AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Straight Renewal'
            ];
            system.assertEquals(configList[0].Apttus_Config2__Status__c, 'Finalized');
            //Assersion ends here
            DigitalBundleBatch dmc = new DigitalBundleBatch();
            Database.executeBatch(dmc, 1);
        }
        Catch(Exception ex) {
            system.debug('Exception Occured:' + ex.getMessage());
        }
        Test.stopTest();
    }

    private static testMethod void doTest1() {
        DCTestData.createKeyValueListStoreSetting();
        Digital_Campaigns__c dcCamp = new Digital_Campaigns__c(Name = '00237KI', YoY_1_Renewal__c = 2, YoY_2__c = 2, Best_Value__c = true);
        insert dcCamp;

        Test.startTest();
        try {
            DigitalBundleBatch dmc = new DigitalBundleBatch();
            Database.executeBatch(dmc, 1);
        }
        Catch(Exception ex) {
            DCBundleFinalizeService.doLogException(ex);
        }
        Test.stopTest();

    }

    private static testMethod void doTestBundle() {

        Apttus_Proposal__Proposal__c proposal = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Bundle Test'
            limit 1
        ];

        system.debug('doTestBundle - Proposal ID: ' + proposal.id);
        List < Apttus_Config2__ProductConfiguration__c > prodConfigList = [select id, Apttus_QPConfig__Proposald__c, Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c];
        Apttus_Config2__ProductConfiguration__c prodConfig = prodConfigList[0];
        prodConfig.Apttus_QPConfig__Proposald__c = proposal.id;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;

        List < Apttus_Config2__LineItem__c > listOfLineItems = New List < Apttus_Config2__LineItem__c > ();
        priceList = [select id from Apttus_Config2__PriceList__c limit 1];
        List < Apttus_Config2__PriceListItem__c > listOfPriceListItems = new List < Apttus_Config2__PriceListItem__c > ();
        listOfPriceListItems = DCTestData.createPriceListItems(priceList.Id, 3);
        Product2 prodObj = new product2();
        prodObj = DCTestData.createProduct('Network Services 1.0', '05', true);
        Product2 prod2Obj = new product2();
        prod2Obj = DCTestData.createProduct('Network Services 2.0', '21', false);
        Product2 prod3Obj = new Product2();
        prod3Obj = DCTestData.createProduct('Network Services 2.0', '21', false);


        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_QPConfig__ProposalId__c = proposal.id;
        insert ali;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Incremental_Revenue_Required__c = 2;
        insert bundlePageSettings;

        //Apttus_Proposal__Proposal__c proposal=new Apttus_Proposal__Proposal__c ();
        //proposal = prepareCommonTestData(); 
        //insert proposal;    
        List < String > str = new List < String > ();
        str.add(proposal.id);
        DCBundleSynchronizeController.DynamicBundleRequest req1 = new DCBundleSynchronizeController.DynamicBundleRequest();
        req1.quoteIds = str;

        String msgbody = JSON.serializePretty(req1);
        Test.startTest();
        try {

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/digitalconfigurator/bundleSynchronize/'; //Request URL
            req.httpMethod = 'POST'; //HTTP Request Type
            req.requestBody = Blob.valueof(msgbody);
            RestContext.request = req;
            RestContext.response = res;
            DCBundleSynchronizeController.DynamicBundleResponse resp = new DCBundleSynchronizeController.DynamicBundleResponse();
            resp = DCBundleSynchronizeController.bundleAndSynchronize();
            //For Assersion 
            system.assertEquals(resp.responseCode, 200);
            List < Apttus_Config2__ProductConfiguration__c > configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,
                Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                Apttus_Config2__AccountId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c
                WHERE Apttus_QPConfig__Proposald__c =: proposal.id AND Apttus_Config2__Status__c = 'Finalized'
                AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Straight Renewal'
            ];
            system.assertEquals(configList[0].Apttus_Config2__Status__c, 'Finalized');
            //Assersion ends here
        }
        Catch(Exception ex) {
            DCBundleFinalizeService.doLogException(ex);
        }
        Test.stopTest();

    }


    private static testMethod void finalizeCartTest() {

        //Apttus_Proposal__Proposal__c proposal=new Apttus_Proposal__Proposal__c ();
        //proposal = prepareCommonTestData();
        //insert proposal;
        Apttus_Proposal__Proposal__c proposal = [select id, Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Bundle Test'
            limit 1
        ];

        Apttus_Config2__ProductConfiguration__c prodConfig = DCTestData.createProductConfiguration(proposal.id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = proposal.Apttus_Proposal__Account__c;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;

        List < String > str = new List < String > ();
        str.add(proposal.id);

        Test.startTest();
        try {
            DCBundleFinalizeService.FinalizeBundleRequest req2 = new DCBundleFinalizeService.FinalizeBundleRequest();
            req2.quoteIds = str;
            String msgbody1 = JSON.serializePretty(req2);
            RestRequest req3 = new RestRequest();
            RestResponse res1 = new RestResponse();
            req3.requestURI = '/services/apexrest/digitalconfigurator/finalizeCart/'; //Request URL
            req3.httpMethod = 'POST'; //HTTP Request Type
            req3.requestBody = Blob.valueof(msgbody1);
            RestContext.request = req3;
            RestContext.response = res1;
            DCBundleFinalizeService.FinalizeBundleResponse resp = new DCBundleFinalizeService.FinalizeBundleResponse();
            resp = DCBundleFinalizeService.finalizeBundleCart();
            system.debug('**Response' + resp);
            //For Assersion
            List < Apttus_Config2__ProductConfiguration__c > configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name,
                Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,
                Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, Apttus_Config2__AccountId__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c
                WHERE Apttus_QPConfig__Proposald__c =: proposal.id AND Apttus_Config2__Status__c = 'New'
            ];

            //System.assertEquals(reponse.responseCode,200);
            system.assertEquals(configList[0].Apttus_Config2__Status__c, 'New');
        } catch (Exception ex) {
            DCBundleFinalizeService.doLogException(ex);
        }
        Test.stopTest();

    }

    private static testMethod void finalizeCart1Test() {

        //Apttus_Proposal__Proposal__c proposal=new Apttus_Proposal__Proposal__c ();
        //proposal = prepareCommonTestData();
        //insert proposal;
        Apttus_Proposal__Proposal__c proposal = [select id, Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Bundle Test'
            limit 1
        ];

        Apttus_Config2__ProductConfiguration__c prodConfig = DCTestData.createProductConfiguration(proposal.id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = proposal.Apttus_Proposal__Account__c;
        prodConfig.Apttus_Config2__Status__c = 'Superseded';
        insert prodConfig;

        Test.startTest();
        try {
            List < String > str;
            str.add(proposal.id);
            DCBundleFinalizeService.FinalizeBundleRequest req2 = new DCBundleFinalizeService.FinalizeBundleRequest();
            req2.quoteIds = str;
            String msgbody1 = JSON.serializePretty(req2);
            RestRequest req3 = new RestRequest();
            RestResponse res1 = new RestResponse();

            req3.requestURI = '/services/apexrest/digitalconfigurator/finalizeCart/'; //Request URL
            req3.httpMethod = 'POST'; //HTTP Request Type
            req3.requestBody = Blob.valueof(msgbody1);
            RestContext.request = req3;
            RestContext.response = res1;
            DCBundleFinalizeService.finalizeBundleCart();
            System.assertNotEquals(res1, null);
        } catch (Exception ex) {
            DCBundleFinalizeService.doLogException(ex);
        }
        Test.stopTest();
    }

    private static testMethod void finalizeCart1TestNegative() {
        Test.startTest();
        DCBundleFinalizeService.FinalizeBundleRequest req2 = new DCBundleFinalizeService.FinalizeBundleRequest();
        req2.quoteIds = null;
        String msgbody1 = JSON.serializePretty(req2);
        RestRequest req3 = new RestRequest();
        RestResponse res1 = new RestResponse();
        req3.requestURI = '/services/apexrest/digitalconfigurator/finalizeCart/'; //Request URL
        req3.httpMethod = 'POST'; //HTTP Request Type
        req3.requestBody = Blob.valueof(msgbody1);
        RestContext.request = req3;
        RestContext.response = res1;
        DCBundleFinalizeService.FinalizeBundleResponse resp = new DCBundleFinalizeService.FinalizeBundleResponse();
        resp = DCBundleFinalizeService.finalizeBundleCart();
        system.assertEquals(resp.responseCode, 400);
        DCBundleFinalizeService.finalizeBundleCart();

        Test.stopTest();
    }


    private static testMethod void doBundle1TestNegative() {
        Test.startTest();
        DCBundleFinalizeService.FinalizeBundleRequest req2 = new DCBundleFinalizeService.FinalizeBundleRequest();
        req2.quoteIds = null;
        String msgbody1 = JSON.serializePretty(req2);
        RestRequest req3 = new RestRequest();
        RestResponse res1 = new RestResponse();
        req3.requestURI = '/services/apexrest/digitalconfigurator/finalizeCart/'; //Request URL
        req3.httpMethod = 'POST'; //HTTP Request Type
        req3.requestBody = Blob.valueof(msgbody1);
        RestContext.request = req3;
        RestContext.response = res1;
        DCBundleSynchronizeController.DynamicBundleResponse resp = new DCBundleSynchronizeController.DynamicBundleResponse();
        resp = DCBundleSynchronizeController.bundleAndSynchronize();
        system.assertEquals(resp.responseCode, 400);
        Test.stopTest();
    }


    private static testMethod void doTestBundleException() {

        Apttus_Proposal__Proposal__c proposal = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Bundle Test'
            limit 1
        ];

        system.debug('doTestBundle - Proposal ID: ' + proposal.id);
        List < Apttus_Config2__ProductConfiguration__c > prodConfigList = [select id, Apttus_QPConfig__Proposald__c, Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c];
        Apttus_Config2__ProductConfiguration__c prodConfig = prodConfigList[0];
        prodConfig.Apttus_QPConfig__Proposald__c = proposal.id;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;

        List < Apttus_Config2__LineItem__c > listOfLineItems = New List < Apttus_Config2__LineItem__c > ();
        priceList = [select id from Apttus_Config2__PriceList__c limit 1];
        List < Apttus_Config2__PriceListItem__c > listOfPriceListItems = new List < Apttus_Config2__PriceListItem__c > ();
        listOfPriceListItems = DCTestData.createPriceListItems(priceList.Id, 3);
        Product2 prodObj = new product2();
        prodObj = DCTestData.createProduct('Network Services 1.0', '05', true);
        Product2 prod2Obj = new product2();
        prod2Obj = DCTestData.createProduct('Network Services 2.0', '21', false);
        Product2 prod3Obj = new Product2();
        prod3Obj = DCTestData.createProduct('Network Services 2.0', '21', false);


        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_QPConfig__ProposalId__c = proposal.id;
        insert ali;
        /*        
                APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
                bundlePageSettings.Name = 'Bundle Page Properties';
                bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
                bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
                bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
                bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
                bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
                bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
                bundlePageSettings.Incremental_Revenue_Required__c=2;
                insert bundlePageSettings;
        */
        //Apttus_Proposal__Proposal__c proposal=new Apttus_Proposal__Proposal__c ();
        //proposal = prepareCommonTestData(); 
        //insert proposal;    
        List < String > str = new List < String > ();
        str.add(proposal.id);
        DCBundleSynchronizeController.DynamicBundleRequest req1 = new DCBundleSynchronizeController.DynamicBundleRequest();
        req1.quoteIds = str;

        String msgbody = JSON.serializePretty(req1);
        Test.startTest();
        try {

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();

            req.requestURI = '/services/apexrest/digitalconfigurator/bundleSynchronize/'; //Request URL
            req.httpMethod = 'POST'; //HTTP Request Type
            req.requestBody = Blob.valueof(msgbody);
            RestContext.request = req;
            RestContext.response = res;
            DCBundleSynchronizeController.DynamicBundleResponse resp = new DCBundleSynchronizeController.DynamicBundleResponse();
            resp = DCBundleSynchronizeController.bundleAndSynchronize();
            //For Assersion 
            system.assertEquals(resp.responseCode, null);
            List < Apttus_Config2__ProductConfiguration__c > configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,
                Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                Apttus_Config2__AccountId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c
                WHERE Apttus_QPConfig__Proposald__c =: proposal.id AND Apttus_Config2__Status__c = 'Finalized'
                AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Straight Renewal'
            ];
            system.assertEquals(configList[0].Apttus_Config2__Status__c, 'Finalized');
            //Assersion ends here
        }
        Catch(Exception ex) {
            DCBundleFinalizeService.doLogException(ex);
        }
        Test.stopTest();

    }


    //Used for preparing data for Config Line Item.
    private static Apttus_Config2__LineItem__c createAptsConfigLineItem(Id prodObjId, Id prodConfigId, Id aliId, Id summaryGrpId, Id pliId) {

        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c();
        linObj.Apttus_Config2__Quantity__c = 1;
        linObj.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        linObj.Apttus_Config2__ProductId__c = prodObjId;
        linObj.Apttus_Config2__ConfigurationId__c = prodConfigId;
        linObj.Apttus_Config2__AssetLineItemId__c = aliId;
        linObj.Apttus_Config2__LineType__c = 'Product/Service';
        linObj.Apttus_Config2__LineNumber__c = 2;
        linObj.Apttus_Config2__ItemSequence__c = 2;
        linObj.Apttus_Config2__SummaryGroupId__c = summaryGrpId;
        linObj.Apttus_Config2__NetPrice__c = 10.0;
        linObj.Apttus_Config2__BasePrice__c = 10.0;
        linObj.Apttus_Config2__BaseExtendedPrice__c = 10.0;
        linObj.Apttus_Config2__AdjustedPrice__c = 10.0;
        linObj.Apttus_Config2__OptionPrice__c = 5.0;
        linObj.Apttus_Config2__Frequency__c = 'Monthly';
        linObj.Apttus_Config2__PriceType__c = 'Recurring';
        linObj.Apttus_Config2__PriceAdjustment__c = 0;
        linObj.APTS_Contract_Term__c = '3 Years';
        linObj.APTS_Proposal_Group__c = null;
        //linObj.Apttus_QPConfig__ProposalId__c = cQuoteID;
        linObj.Apttus_Config2__PriceListItemId__c = pliId;

        return linObj;
    }

    //Method is used to create Summary group.
    private static Apttus_Config2__SummaryGroup__c createSummaryGroup(string prodConfigId, string name) {
        Apttus_Config2__SummaryGroup__c summaryGroup = new Apttus_Config2__SummaryGroup__c();
        summaryGroup.Apttus_Config2__ConfigurationId__c = prodConfigid;
        summaryGroup.Name = 'WEST PROFLEX Bundle A - Test group';
        summaryGroup.Apttus_Config2__LineType__c = 'Total';
        summaryGroup.Apttus_Config2__ItemSequence__c = 2;
        summaryGroup.Apttus_Config2__LineNumber__c = 1;
        insert summaryGroup;
        return summaryGroup;
    }

    //Method is used to prepare common test data for all test methods
    private static Apttus_Proposal__Proposal__c prepareCommonTestData() {
        priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();

        //Commented as part of DLT-20035
        a = APTS_TestDataFactory.createAccount('Test Account');
        //    a.FrozenMarketSegment__c = valueMarket;
        insert a;

        accountSSD = APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.BU_Segment_Level_2__c = 'Small Law';
        insert accountSSD;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(null, accountSSD.Id);
        proposal.Apttus_Proposal__Proposal_Name__c = 'Bundle Test';
        proposal.Digital_Quote_Type__c = 'Best Value';
        proposal.APTS_Approval_Segment__c = 'Small Law';
        proposal.Apttus_Proposal__Account__c = a.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.id;
        proposal.APTS_SSD_bill_to__c = accountSSD.id;
        proposal.APTS_SSD_ship_to__c = accountSSD.id;
        return proposal;
    }

}