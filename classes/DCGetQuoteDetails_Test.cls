/* CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 23-07-2020   Rahul Natarajan         DLT-20035 - Remove Segmentation Field References from CX Digital components.
 * 24-08-2020   Benjamin Her            DLT-20634 - Critical/Blocker PMD fix
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 *=============================================================================
 */
@isTest
public class DCGetQuoteDetails_Test {
    @testSetup static void createData() {
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.stopTest();
        List<Product_Account_Detail__c > listOfPad = new List<Product_Account_Detail__c > ();
        Product_Account_Detail__c pad = new Product_Account_Detail__c(
            ZP_Cust_Number__c = '1004284494',
            Campaign_Code__c = 'ABCDEF',
            Renewal_Date__c = Date.today().addDays(90),
            Type__c = 'Straight',
            Current_Subscription__c = '42009617',
            Actual_New_Service__c = '40974107',
            Digital_Firm__c = 'Small Law',
            Current_Term_Length__c = 1);
        Product_Account_Detail__c pad1 = new Product_Account_Detail__c(
            ZP_Cust_Number__c = '1004284494',
            Campaign_Code__c = 'ABCDEF',
            Renewal_Date__c = Date.today().addDays(90),
            Type__c = 'Plus',
            Add_on_Type__c = 'Plus',
            Contract_Type__c = 'New Mid Contract',
            Add_On_Sub__c = '42005016',
            Add_On_Svc__c = '42005003',
            Current_Subscription__c = '42009617',
            Actual_New_Service__c = '40974107',
            Digital_Firm__c = 'Small Law',
            Current_Term_Length__c = 1);
        listOfPad.add(pad);
        listOfPad.add(pad1);
        insert listOfPad;
        Contact cont = [SELECT id, SAP_Role__c, SAP_Contact_ID__c, Email FROM Contact WHERE FirstName = 'testContact'];
        Source_System_Detail__C accountSSD = [SELECT id, Source_System_Account_Number__c FROM Source_System_Detail__C WHERE Name = 'ABC'];

        // Commented out segmentation fields - DLT-20035
        Account s2eAcc = new Account();
        s2eAcc.Name = 'S2E Account';
        //  s2eAcc.FrozenMarketSegment__c = 'Solo Law Firm';
        s2eAcc.SAPAccountNumber__c = '1004284495';
        //  s2eAcc.Customer_Group__c = 'FIRM';
        s2eAcc.APTS_Band_Number__c = 1;
        s2eAcc.APTS_Customer_Category__c = '3';
        s2eAcc.APTS_eOutput_Eligibilty__c = '';
        insert s2eAcc;

        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(cont, accountSSD);
        conSSD.LCRM_Last_Name__c = 'Last Name';
        conSSD.LCRM_Phone__c = '123456789';
        conSSD.LCRM_Hard_Bounce__c = false;
        update conSSD;
        Apttus_DocuApi__DocuSignEnvelope__c docSignEnv = new Apttus_DocuApi__DocuSignEnvelope__c();
        docSignEnv.Apttus_DocuApi__EnvelopeId__c = 'Test-Env-Id1';
        docSignEnv.Name = 'Test-Env-Id1';
        docSignEnv.Apttus_DocuApi__EnvelopeContent__c = '{"success":true,"showTagAndSend":false,"showSendforESignature":true,"showSendAsAnotherUser":true,"showPreview":true,"senderViewURL":null,"sendAsUserEmail":"molly.bentz=tr.com@example.com","parentId":"a4N0m0000008OMbEAM","oneClickSend":false,"objRecipientList":{"listRecipient":[{"tabs":null,"signingGroupId":null,"signerType":"signers","signerRole":"Signer","selected":true,"orderNumber":1,"objectType":null,"objectIndex":0,"name":"Amy Banks","isRequired":null,"id":"0031300002TjjzqAAB","emailTemplateId":null,"emailNotification":null,"email":"amy@bankslawyers.com","canMoveUp":false,"canMoveDown":false}]},"objAttachmentWrapperList":{"parentStatus":null,"parentNumber":null,"parentName":null,"listAttachmentWrapper":[{"siblingsId":null,"selected":true,"relationship":"Primary","parentStatus":null,"parentNumber":null,"parentName":null,"parentId":"a4N0m0000008OMbEAM","objectIndex":0,"isSibling":false,"isParent":false,"isChild":false,"documentAssociationType":"Primary","canMoveUp":false,"canMoveDown":true,"attachment":{"attributes":{"type":"Attachment","url":"/services/data/v39.0/sobjects/Attachment/00P0m000000E6psEAC"},"Id":"00P0m000000E6psEAC","Name":"SLF Digital Spearhead POC EM May Sept MARTHA BANKS - clone_' + System.Label.Digital_OF + '_2017-05-26.pdf"}}],"hasSibling":false,"hasRelated":false,"hasParent":false,"hasChild":false,"hasAmendRenew":false},"notification":{"useAccountDefaults":true,"reminders":null,"expirations":null},"isPreviewInDocusign":false,"Id":"36832a9b-d57a-4eed-bfeb-94bfee3ff971","errorMessage":null,"errorCode":null,"error":false,"envelopeStatus":"Sent","emailSubject":"Request for eSignatures","emailBody":"Request for eSignatures. Please review and sign.","documentUploadProcessId":null}';
        insert docSignEnv;

        Apttus_Proposal__Proposal__c quote = [Select ID, Order_Confirmation_Contact_SSD__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1'
            Limit 1
        ];
        quote.DocuSign_Envelope_ID__c = docSignEnv.Apttus_DocuApi__EnvelopeId__c;
        quote.Order_Confirmation_Contact_SSD__c = conSSD.id;
        update quote;

        Product2 prod = [SELECT id, Service_Number__c, Subscription_Number__c FROM Product2 WHERE Name = 'SL California Analytical (Westlaw PRO™)'];
        DCTestData.createProductPlan(prod.id, prod.Service_Number__c, prod.Subscription_Number__c);
        Source_System_Detail__C acc = [SELECT Id, Account_Name__c FROM Source_System_Detail__C WHERE Name = 'ABC'
            LIMIT 1
        ];
        Opportunity opp = [SELECT Id, Campaign_Code__c FROM Opportunity WHERE AccountId =: acc.Account_Name__c LIMIT 1];
        opp.Campaign_Code__c = 'ABCDEF';
        update opp;

    }

    private static testmethod void landingLoadApit() {
        Test.startTest();
        //Added by navleen
        DCGetQuoteDetails quoteDetails = new DCGetQuoteDetails();
        quoteDetails.getSendEmailOnBehalfOf('Test-Env-Id1');
        Source_System_Detail__C acc = [SELECT Id, Account_Name__c FROM Source_System_Detail__C WHERE Name = 'ABC'
            LIMIT 1
        ];

        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId =: acc.Account_Name__c LIMIT 1];
        List<Apttus_Config2__ProductConfiguration__c > cartsList = new List<Apttus_Config2__ProductConfiguration__c > ();
        for (Apttus_Config2__ProductConfiguration__c cart: [SELECT id, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                Apttus_QPConfig__Proposald__r.is_Digital_Channel__c,
                Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c,
                Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c,
                Apttus_Config2__Status__c,
                APTS_SSD_bill_to__c
                FROM Apttus_Config2__ProductConfiguration__c
                LIMIT 50000
            ]) {
            cart.APTS_SSD_bill_to__c = acc.id;
            cartslist.add(cart);
        }
        update cartslist;
        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(opp.Id, acc.Id, null);
        System.assert(response != null, 'Assert failed');
        Test.stopTest();

    }
    private static testmethod void landingLoadApiNegative() {
        Test.startTest();
        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(DCTestData.oppId, DCTestData.accountId, null);
        System.assert(response != null, 'Assert failed');
        Test.stopTest();
    }
    private static testmethod void landingLoadApiError() {
        Test.startTest();
        Source_System_Detail__C acc = [SELECT Id, Account_Name__c FROM Source_System_Detail__C WHERE Name = 'ABC'
            LIMIT 1
        ];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId =: acc.Account_Name__c LIMIT 1];
        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(acc.id, opp.id, null); //Incorrect Parameter, Parameters are reversed.
        System.assert(response != null, 'Assert failed');
        Test.stopTest();
    }
    private static testmethod void getOnlineContactsTest() {
        Test.startTest();
        DCTestData.createOnline(DCTestData.bQuoteId, DCTestData.accountId);

        DCGetQuoteDetails quoteDetails = new DCGetQuoteDetails();
        Map<String, List<QuoteDetailsResponse.OnlineContacts >> emptyMap = new Map<String, List<QuoteDetailsResponse.OnlineContacts >> ();
        Map<String, List<QuoteDetailsResponse.OnlineContacts >> mapOnlineContact = quoteDetails.getOnlineContacts(DCTestData.bQuoteId);
        System.assertNotEquals(emptyMap, mapOnlineContact, 'Assert failed');
        Test.stopTest();
    }

    private static testmethod void manualOfferReplacementTest() {

        Test.startTest();

        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__C WHERE Name = 'ABC'];
        Account acc = [SELECT id FROM Account WHERE Name = 'Test Account'];
        Opportunity opp = [SELECT id FROM Opportunity WHERE AccountId =: acc.id][0];
        Apttus_Config2__PriceList__c plist = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];

        List<Apttus_Proposal__Proposal__c > quoteList = new list<Apttus_Proposal__Proposal__c > ();

        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Apttus_Proposal__Opportunity__c = opp.id;
        q1.Apttus_Proposal__Account__c = acc.id;
        q1.APTS_SSD_Sold_To__c = ssd.id;
        q1.APTS_SSD_bill_to__c = ssd.id;
        q1.APTS_SSD_ship_to__c = ssd.id;
        q1.Apttus_QPConfig__BillToAccountId__c = acc.id;
        q1.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q1.Digital_Quote_Type__c = 'Straight Renewal';
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = TRUE;
        q1.DC_Updated_On_Configurator__c = TRUE;
        q1.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        q1.Apttus_QPConfig__PriceListId__c = plist.id;
        q1.APTS_Proposal_Business_Unit__c = 'SCS';
        q1.APTS_Payment_Option__c = 'Bill to Account';
        quoteList.add(q1);

        Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
        q2.Apttus_Proposal__Proposal_Name__c = 'Manual Proposal';
        q2.Apttus_Proposal__Opportunity__c = opp.id;
        q2.Apttus_Proposal__Account__c = acc.id;
        q2.APTS_SSD_Sold_To__c = ssd.id;
        q2.APTS_SSD_bill_to__c = ssd.id;
        q2.APTS_SSD_ship_to__c = ssd.id;
        q2.Apttus_QPConfig__BillToAccountId__c = acc.id;
        q2.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q2.Digital_Quote_Type__c = 'Manual';
        q2.Digital_Batch_Processed__c = TRUE;
        q2.Apttus_Proposal__Primary__c = FALSE;
        q2.DC_Updated_On_Configurator__c = TRUE;
        q2.Apttus_QPConfig__PriceListId__c = plist.id;
        q2.APTS_Proposal_Business_Unit__c = 'SCS';
        q2.APTS_Payment_Option__c = 'Bill to Account';
        quoteList.add(q2);

        insert quoteList;
        System.debug(LoggingLevel.DEBUG,'test' + quoteList);
        list<Apttus_Config2__ProductConfiguration__c > cartList = new list<Apttus_Config2__ProductConfiguration__c > ();
        Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c(Id = DCTestData.createCart(quoteList[1].Id),
            Apttus_Config2__Status__c = 'Finalized', Name = 'test cart');
        cartList.add(newCart1);

        Apttus_Config2__ProductConfiguration__c newCart2 = new Apttus_Config2__ProductConfiguration__c(Id = DCTestData.createCart(quoteList[0].Id),
            Apttus_Config2__Status__c = 'Finalized');

        cartList.add(newCart2);

        update cartList;

        List<Apttus_Config2__ProductConfiguration__c > cartsList = new List<Apttus_Config2__ProductConfiguration__c > ();
        for (Apttus_Config2__ProductConfiguration__c cart: [SELECT id, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                Apttus_QPConfig__Proposald__r.is_Digital_Channel__c,
                Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c,
                Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c,
                Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                Apttus_Config2__Status__c,
                APTS_SSD_bill_to__c,
                (Select Apttus_Config2__NetPrice__c from Apttus_Config2__LineItems__r)
                FROM Apttus_Config2__ProductConfiguration__c
                LIMIT 50000
            ]) {
            cart.APTS_SSD_bill_to__c = ssd.id;
            cartslist.add(cart);
        }
        update cartslist;

        DCGetQuoteDetails dcgetqdetail = new DCGetQuoteDetails();
        decimal dc;
        DCLandingServiceHelper.manualOfferReplacement(cartslist);
        decimal dc2 = dcgetqdetail.flCurrentHoldings(cartslist[0].id);
        System.debug(LoggingLevel.DEBUG,dc2);
        dc = dcgetqdetail.manualCurrentHoldings(cartslist[0]);

        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(opp.id, ssd.id, null);
        System.assert(response != null, 'Assert failed');

        Test.stopTest();

    }

    private static testmethod void contactValidationTest() {
        Test.startTest();
        //Added by navleen
        DCGetQuoteDetails quoteDetails = new DCGetQuoteDetails();
        quoteDetails.getSendEmailOnBehalfOf('Test-Env-Id1');
        Source_System_Detail__C acc = [SELECT Id, Account_Name__c FROM Source_System_Detail__C WHERE Name = 'ABC'
            LIMIT 1
        ];

        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId =: acc.Account_Name__c LIMIT 1];
        List<Apttus_Config2__ProductConfiguration__c > cartsList = new List<Apttus_Config2__ProductConfiguration__c > ();
        for (Apttus_Config2__ProductConfiguration__c cart: [SELECT id, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                Apttus_QPConfig__Proposald__r.is_Digital_Channel__c,
                Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c,
                Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c,
                Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c,
                Apttus_Config2__Status__c,
                APTS_SSD_bill_to__c
                FROM Apttus_Config2__ProductConfiguration__c
                LIMIT 50000
            ]) {
            cart.APTS_SSD_bill_to__c = acc.id;
            cartslist.add(cart);
        }
        update cartslist;
        List<Apttus_Proposal__Proposal__c > listProposals = new List<Apttus_Proposal__Proposal__c > ();
        for (Apttus_Proposal__Proposal__c prop: [SELECT id, APTS_Order_Confirmation_Contact_Email__c FROM Apttus_Proposal__Proposal__c LIMIT 50000]) {
            prop.APTS_Order_Confirmation_Contact_Email__c = null;
            listProposals.add(prop);
        }
        update listProposals;
        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(opp.Id, acc.Id, null);
        System.assert(response != null, 'Assert failed');
        Test.stopTest();

    }
    private static testmethod void bundleOnlineContactsAndMaterials() {
        Test.startTest();
        //Added by navleen
        DCGetQuoteDetails quoteDetails = new DCGetQuoteDetails();
        quoteDetails.getSendEmailOnBehalfOf('Test-Env-Id1');
        Source_System_Detail__C acc = [SELECT Id, Account_Name__c FROM Source_System_Detail__C WHERE Name = 'ABC'
            LIMIT 1
        ];

        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId =: acc.Account_Name__c LIMIT 1];
        List<Apttus_Proposal__Proposal_Line_Item__c > pliList = new List<Apttus_Proposal__Proposal_Line_Item__c > ();
        //Product2 prod = [SELECT id, Service_Number__c, Subscription_Number__c FROM Product2 WHERE Name = 'SL California Analytical (Westlaw PRO™)'];
        //List<Apttus_Proposal__Proposal_Line_Item__c > proposalLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c > ();

        for (Apttus_Proposal__Proposal_Line_Item__c pli: [SELECT id, APTS_Service_Number_Override__c
                FROM Apttus_Proposal__Proposal_Line_Item__c
                LIMIT 50000
            ]) {

            pli.APTS_Service_Number_Override__c = '42009567';
            pli.Apttus_QPConfig__HasOptions__c = true;
            pliList.add(pli);
        }
        update pliList;

        List<Apttus_Proposal__Proposal__c > listProposals = new List<Apttus_Proposal__Proposal__c > ();
        for (Apttus_Proposal__Proposal__c prop: [SELECT id, APTS_Order_Confirmation_Contact_Email__c FROM Apttus_Proposal__Proposal__c LIMIT 50000]) {
            prop.APTS_Order_Confirmation_Contact_Email__c = null;
            listProposals.add(prop);
        }
        update listProposals;
        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(opp.Id, acc.Id, null);
        System.assert(response != null, 'Assert failed');
        Test.stopTest();

    }
    private static testmethod void landingLoadApi2() {
        Test.startTest();
        //Added by navleen
        DCGetQuoteDetails quoteDetails = new DCGetQuoteDetails();
        quoteDetails.getSendEmailOnBehalfOf('Test-Env-Id1');
        Source_System_Detail__C acc = [SELECT Id, Account_Name__c FROM Source_System_Detail__C WHERE Name = 'ABC'
            LIMIT 1
        ];

        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId =: acc.Account_Name__c LIMIT 1];

        opp.Campaign_Code__c = 'ABCDEF';
        opp.Renewal_Date__c = Date.today().addDays(90);
        update opp;
        List<Apttus_Config2__ProductConfiguration__c > cartsList = new List<Apttus_Config2__ProductConfiguration__c > ();
        for (Apttus_Config2__ProductConfiguration__c cart: [SELECT id, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                Apttus_QPConfig__Proposald__r.is_Digital_Channel__c,
                Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c,
                Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c,
                Apttus_Config2__Status__c,
                APTS_SSD_bill_to__c
                FROM Apttus_Config2__ProductConfiguration__c
                LIMIT 50000
            ]) {
            cart.APTS_SSD_bill_to__c = acc.id;
            cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c = opp.Id;
            cartslist.add(cart);
        }
        update cartslist;
        DCQuoteDetails response = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(opp.Id, acc.Id, null);
        System.assert(response != null, 'Assert failed');
        Test.stopTest();

    }

    private static testmethod void getWestProflexTest() {
        Apttus_Config2__ProductConfiguration__c quote = [SELECT id, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
            APTS_SSD_bill_to__r.Source_System_Account_Number__c,
            (SELECT id, APTS_SSD_ship_to__r.LCRM_APTS_Band_Number__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, Apttus_Config2__ProductId__r.Name, Apttus_Config2__LineStatus__c,
                APTS_Format__c, Apttus_Config2__BillingFrequency__c, Apttus_Config2__Quantity__c,
                DC_Is_Add_On__c, Apttus_Config2__AutoRenewalTerm__c, Apttus_Config2__StartDate__c,
                APTS_Number_of_Attorneys__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,
                APTS_Years_2_Plus_Adjustment__c, APTS_Original_Quantity__c,
                Apttus_Config2__OptionId__r.Subscription_Number__c, Apttus_Config2__AssetLineItemId__r.APTS_Subscription_Number__c FROM Apttus_Config2__LineItems__r)
            FROM Apttus_Config2__ProductConfiguration__c
            LIMIT 1
        ];

        Product2 prod = [SELECT Id, ProductCode, Name,
            Digital_Description__c, DC_Short_Description__c,
            DC_Long_Description__c, APTS_Product_Pricing_Model__c,
            Subscription_Number__c, Family,
            Service_Number__c FROM Product2 LIMIT 1
        ];

        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c();
        asset.Apttus_Config2__ProductId__r = prod;

        quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c = 'Straight Renewal';
        quote.Apttus_Config2__LineItems__r[0].Apttus_Config2__ProductId__r.Name = 'West Proflex';

        List<QuoteDetailsResponse.QuoteLineItems > quoteLineItemList = new List<QuoteDetailsResponse.QuoteLineItems > ();
        //DCGetQuoteDetails dcGetQuoteDetails = new DCGetQuoteDetails();

        Test.startTest();

        update quote;
        quoteLineItemList = DCGetQuoteDetailsHelper.getWestProflexSubproduct(quoteLineItemList, quote);
        DCGetQuoteDetailsHelper.getWestProflexSubproductValues(asset, quote.Apttus_Config2__LineItems__r[0], null);
        System.assert(quoteLineItemList != null, 'Returned null');
        Test.stopTest();
    }

    private static testmethod void getDigitalProductPlanTest() {
        Product2 prod = [SELECT id FROM Product2 LIMIT 1];
        Digital_Product_Plans__c digitalProductPlan = new Digital_Product_Plans__c();
        digitalProductPlan.Material_Number__c = '123456789';
        digitalProductPlan.Material_Description__c = 'Description';
        digitalProductPlan.Product__c = prod.id;
        digitalProductPlan.Subscription_Number__c = '123456789';
        digitalProductPlan.SLF_Jurisdiction__c = 'Jurisdiction';
        digitalProductPlan.DB_Group__c = 'Group';
        digitalProductPlan.DB_Group_Sort_Order__c = 1;
        digitalProductPlan.DB_Category__c = '1';
        digitalProductPlan.DB_Category_Sort_Order__c = 1;
        digitalProductPlan.SLF_Help_Text__c = 'Text';
        digitalProductPlan.Additional_Help_Text__c = 'More Text';
        insert digitalProductPlan;

        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c();
        asset.Apttus_Config2__ProductId__c = prod.id;
        insert asset;

        digitalProductPlan = [SELECT id, Product__c FROM Digital_Product_Plans__c WHERE Product__c =: asset.Apttus_Config2__ProductId__c LIMIT 1];
        System.debug(LoggingLevel.DEBUG,digitalProductPlan);
        List<Apttus_Config2__AssetLineItem__c > assetList = [SELECT Apttus_Config2__ProductId__r.id FROM Apttus_Config2__AssetLineItem__c LIMIT 50000];
        assetList.add(asset);

        Test.startTest();
        //DCGetQuoteDetails dcGetQuoteDetails = new DCGetQuoteDetails();
        Map<String, List<QuoteDetailsResponse.Material >> materialMap = DCGetQuoteDetailsHelper.getDigitalProductPlan(assetList);
        System.assert(materialMap != null, 'Returned null');
        Test.stopTest();

    }

}