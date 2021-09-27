@istest
public class Digital_PasswordHoldersBatch_Test {

    //Data Setup method
    @testSetup
    static void olcSettupdata() {

        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.stopTest();

        Apttus_Config2__PriceList__c priceList = [select id, name from Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal'
            limit 1
        ];

        List < WebServiceSettings__c > webserviceList = new List < WebServiceSettings__c > ();

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = '  Smart matching Service is unavailable';
        oWebServiceSettings.Name = 'smartmatching';
        //oWebServiceSettings.Name ='PaymentCreditIncrease';  
        oWebServiceSettings.Timeout__c = 120;
        oWebServiceSettings.Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/subscription/qa/getEntAndSubsByAccount';
        oWebServiceSettings.Active__c = true;
        webserviceList.add(oWebServiceSettings);

        WebServiceSettings__c poWebServiceSettings = new WebServiceSettings__c();
        poWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';
        poWebServiceSettings.Name = 'PaymentCreditIncrease';
        poWebServiceSettings.Timeout__c = 120;
        poWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
        poWebServiceSettings.Active__c = true;
        webserviceList.add(poWebServiceSettings);

        insert webserviceList;



        Contact oContact = [Select id, Email, SAP_Role__c, SAP_Contact_ID__c, AccountId from Contact where id =: DCTestData.contactId];
        Source_System_Detail__c oSSD = [Select id, Source_System_Account_Number__c from Source_System_Detail__c where id =: DCTestData.accssdid];
        oSSD.Source_System_Account_Number__c = '1000034394';
        update oSSD;
        LCRM_Contact_SSD__c oSSDContact = DCTestData.createContactSSD(oContact, oSSD);

        list < contact > clist = [select id, SAP_Role__c from contact where SAP_Role__c = 'EML ORDER CONFIRM'];
        for (Contact c: clist) {
            c.SAP_Role__c = 'WL PSWD ACTIVE';
            c.Job_Function__c = 'Other';
        }
        update clist;

        list < product2 > prod = [select id, APTS_Media_Lower_Level_Code__c, APTS_Media_High_Level_Code__c, Apttus_Filter_Brand_Code__c, Productcode, APTS_Product_Pricing_Model__c from product2 where Productcode IN('42009567', '42009567', '41713884', '41713886')];

        Customer_Master_Contacts__c mc = new Customer_Master_Contacts__c();
        mc.quote__C = DCTestData.bQuoteId;
        mc.First_Name__c = 'testMCfirstname';
        mc.Last_Name__c = 'tesMclastname';
        mc.Email_Address__c = 'test.test@gmail.com';
        mc.Material__c = prod[0].Productcode;
        insert mc;

        APTS_Quote_Agreement_Locations__c aloc = new APTS_Quote_Agreement_Locations__c(Name = 'Best Value', APTS_Quote_Proposal__c = DCTestData.bQuoteId, APTS_Status__c = 'New', APTS_Subscriber_Location__c = DCTestData.accountId, APTS_Subscriber_Location_SSD__c = oSSD.id);
        insert aloc;

        system.assertEquals(DCTestData.OppList1[0].Source_System_Detail__c, oSSD.id);

        // this below lines to cover helper class Digital_AddPasswordHolderProcess
        Apttus_Proposal__Proposal__c oldProposal = new Apttus_Proposal__Proposal__c();
        oldProposal.id = DCTestData.cQuoteId;
        oldProposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        oldProposal.Apttus_Proposal__Primary__c = True;
        update oldProposal;

        //add olc to old Proposal
        DCTestData.createOnline(oldProposal.id, oldProposal.Apttus_Proposal__Account__c);

    }

    public static testmethod void getBandedOnlineContactsTest() {

        Digital_OnlineContactsController controller = new Digital_OnlineContactsController();
        controller.totalbandedList = new List < Digital_OnlineContactsController.APLIWrapper > ();
        Digital_OnlineContactsController.APLIWrapper wrapper = new Digital_OnlineContactsController.APLIWrapper();
        wrapper.onlineContact = new Online_Contacts__c();
        controller.totalbandedList.add(wrapper);
        List < Apttus_Proposal__Proposal__c > proposal = [SELECT id, name, Digital_Ready_Online_Export__c, APTS_SSD_Sold_To__c,
            Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c,
            APTS_MLA_Quote__c,
            (SELECT First_Name__c, Last_Name__c, Email_Address__c,
                Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c, Quote__r.APTS_SSD_Sold_To__c FROM Customer_Master_Contacts__r)
            FROM Apttus_Proposal__Proposal__c
        ];

        Test.startTest();
        Digital_PasswordHoldersBatch.getBandedOnlineContacts(proposal[0], controller);
        Test.stopTest();
    }

    public static testmethod void getPerSeatOnlineContactsTest() {

        Digital_OnlineContactsController controller = new Digital_OnlineContactsController();
        controller.perSheetAPLIList = new List < Digital_OnlineContactsController.APLIWrapper > ();
        Digital_OnlineContactsController.APLIWrapper wrapper = new Digital_OnlineContactsController.APLIWrapper();
        wrapper.onlineContact = new Online_Contacts__c(Material__c = '42009567');
        controller.perSheetAPLIList.add(wrapper);

        List < Apttus_Proposal__Proposal__c > proposal = [SELECT id, name, Digital_Ready_Online_Export__c, APTS_SSD_Sold_To__c,
            Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c,
            APTS_MLA_Quote__c,
            (SELECT First_Name__c, Last_Name__c, Email_Address__c,
                Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c, Quote__r.APTS_SSD_Sold_To__c FROM Customer_Master_Contacts__r)
            FROM Apttus_Proposal__Proposal__c
        ];

        Map < string, Map < string, Decimal >> proplineQuantMap = new Map < string, Map < string, Decimal >> ();
        proplineQuantMap.putAll(Digital_PasswordHoldersBatch.upSellobjct(proposal));

        Test.startTest();
        Digital_PasswordHoldersBatch.getPerSeatOnlineContacts(proposal[0], controller, proplineQuantMap);
        Test.stopTest();
    }

    // this cover batch class and few support methods
    public static testmethod void onlineContacttest() {

        test.starttest();

        Digital_PasswordHoldersBatch olc = new Digital_PasswordHoldersBatch();
        Database.executeBatch(olc, 1);

        //covers after Digital_OnlineContactsController created on helper class  
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.id = DCTestData.bQuoteId;
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_OnlineContactsController contr = new Digital_OnlineContactsController(sc);
        system.assertEquals(contr.proposalId, oProposal.id);
        test.stoptest();

    }


    // this cover batch class and few support methods with Banded
    public static testmethod void oldOLCHelpertest() {

        list < product2 > prodlist = new list < product2 > ();
        for (product2 prod: [select id, APTS_Media_Lower_Level_Code__c, APTS_Media_High_Level_Code__c, Apttus_Filter_Brand_Code__c, Productcode, APTS_Product_Pricing_Model__c from product2 where Productcode IN('42009561', '42009567', '41713884', '41713886')]) {
            prod.APTS_Product_Pricing_Model__c = 'Banded';
            if (prod.Productcode == '41713884') {
                prod.APTS_Product_Pricing_Model__c = 'Per Seat';
            }
            prodlist.add(prod);
        }
        update prodlist;

        List < Apttus_Proposal__Proposal__c > proposalList = [SELECT id, name, Digital_Ready_Online_Export__c,
            APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
            Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c,
            APTS_MLA_Quote__c,
            (SELECT First_Name__c, Last_Name__c, Email_Address__c, Quote__c,
                Material__c, Quote__r.Apttus_Proposal__Account__c FROM Customer_Master_Contacts__r)
            FROM Apttus_Proposal__Proposal__c
        ];
        test.starttest();
        Digital_PasswordHoldersBatch.passwordHolderHelper(proposalList);

        //covers after Digital_OnlineContactsController created on helper class  
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.id = DCTestData.bQuoteId;
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_OnlineContactsController contr = new Digital_OnlineContactsController(sc);
        system.assertEquals(contr.proposalId, oProposal.id);
        test.stoptest();

    }


    // this cover batch class and Digital_SmartMatching
    public static testmethod void smartMatchingtest() {

        test.starttest();
        list < Apttus_Proposal__Proposal__c > proposalList = new list < Apttus_Proposal__Proposal__c > ();
        proposalList = [select id, name, Digital_Ready_Online_Export__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_MLA_Quote__c, (select First_Name__c, Last_Name__c, Email_Address__c, Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c from Customer_Master_Contacts__r) from Apttus_Proposal__Proposal__c where is_Digital_Channel__c = TRUE AND Digital_Batch_Processed__c = TRUE AND APTS_Validation_Messages__c != Null AND Digital_Quote_Type__c IN('Best Value', 'Best Value+Config', 'Premium') AND APTS_Order_Confirmation_Contact_Email__c != Null AND Apttus_Proposal__Approval_Stage__c IN('Draft', 'Approved') AND ID IN(select Quote__C from Customer_Master_Contacts__c) AND APTS_SSD_Sold_To__c != NULL];

        list < Apttus_Config2__ProductConfiguration__c > cart = new list < Apttus_Config2__ProductConfiguration__c > ();
        cart = [select id, name, Apttus_Config2__Status__c, Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_Config2__Status__c = 'Finalized'
            and Apttus_QPConfig__Proposald__c =: proposalList[0].id
        ];

        list < Apttus_Config2__LineItem__c > cartlinelist = new list < Apttus_Config2__LineItem__c > ();
        cartlinelist = [select id, name, Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__LineStatus__c, Apttus_Config2__Quantity__c, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.Service_Number__c, Apttus_Config2__ProductId__r.Subscription_Number__c from Apttus_Config2__LineItem__c limit 10];


        list < Apttus_Proposal__Proposal_Line_Item__c > pLineItemlist = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
        pLineItemlist = [select id, name, Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__LineStatus__c, Apttus_QPConfig__Quantity2__c, Apttus_Proposal__Product__c, Apttus_QPConfig__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c, Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.Service_Number__c, Apttus_Proposal__Product__r.Subscription_Number__c, APTS_Service_Number_Override__c, APTS_Subscription_Number_Override__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_QPConfig__Quantity2__c != null limit 10];

        DCTestData.createProduct('WN PRO ANCILLARY', '41409998', '41409998');
        //test.stoptest();

        //test.starttest();
        Digital_SmartMatching.getEntitlements(proposalList);
        Digital_PasswordHoldersBatch olc = new Digital_PasswordHoldersBatch();
        Database.executeBatch(olc, 1);

        //covers after Digital_OnlineContactsController created on helper class  
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.id = DCTestData.bQuoteId;
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_OnlineContactsController contr = new Digital_OnlineContactsController(sc);
        system.assertEquals(contr.proposalId, oProposal.id);
        test.stoptest();

    }

}