/* CHANGE HISTORY
 ==================================================================================================================================
Date         Name                  Description
2020-08-27   Rahul Natarajan       DLT-20631 - [SFDC] [REN] Critical Code scan issue`   
==================================================================================================================================   */
@isTest
public class Digital_FinalizeCart_test {
	
	/** 
 	 * @description : Test Class for Digital_FinalizeCart classs
 	 */
    public static testmethod void testcart1() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'
            LIMIT 1
        ];
        Profile p2 = [SELECT Id, name FROM Profile WHERE Name = 'Partner Portal User'
            LIMIT 1
        ];
        system.debug(logginglevel.INFO, 'Profile selected: ' + p2);
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;

        Map < String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        system.debug(logginglevel.INFO, 'Opportunity Record Type: ' + optyPipeRecTypeId);
        Digital_Campaigns__c dcCamp = new Digital_Campaigns__c(Name = '00237KI', YoY_1_Renewal__c = 2, YoY_2__c = 2, Best_Value__c = true);

        insert dcCamp;

        // DLT-20631  - Removed Hardcoded ID
        List < RecordtypeIds__c > recTList = new List < RecordtypeIds__c > ();
        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        recTList.add(recT);

        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        recTList.add(recT1);
        insert recTList;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'Standard Price Book';
        insert pbook;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();

        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        Account acc = APTS_TestDataFactory.createAccount('Test Account');
        acc.FrozenMarketSegment__c = valueMarket;
        acc.SAPAccountNumber__c = '1004284494';
        insert acc;

        list < Opportunity > oppList = new list < Opportunity > ();
        Opportunity opp1 = new Opportunity();
        opp1 = UnitTest.getOpportunityInstance(acc.id);
        opp1.isdigitalSpearhead__c = TRUE;
        opp1.CloseDate = System.Today() + 30;
        opp1.StageName = '10%';
        opp1.Renewal_Date__c = System.Today();
        opp1.Status__c = 'Converted';
        opp1.RecordTypeId = optyPreRecTypeID;
        opp1.Pricebook2 = pBook;
        opp1.Campaign_Code__c = dcCamp.Name;
        // Added by Ravi
        opp1.AccountId = acc.id;
        oppList.add(opp1);
        insert oppList;


        list < Contact > contactList = new list < Contact > ();
        system.debug(logginglevel.INFO, 'Contact List: ' + contactList);
        Contact testcontact = UnitTest.getContactInstance(Acc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = acc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.Job_Function__c = 'Other';
        testcontact.SAP_Role__c = 'WL PSWD ACTIVE';
        insert testcontact;

        list < Product2 > prodList = new list < Product2 > ();

        Product2 prodObj = new Product2(); //current sub
        prodObj.Name = 'Essentials Library — Florida (Westlaw PRO™)';
        prodObj.List_Price__c = 0;
        prodObj.Format__c = 'Online';
        prodObj.Is_Orderable__c = TRUE;
        prodObj.IS_WP_Eligible__c = TRUE;
        prodObj.Media_High_Level__c = 'Online';
        prodObj.Service_Number__c = '40982845';
        prodObj.Subscription_Number__c = '40974107';
        prodObj.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj.Family = 'WESTLAW';
        prodObj.Apttus_Filter_Media__c = 'Online';
        prodObj.APTS_Media_High_Level_Code__c = '05';
        prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj.Productcode = '42009613';
        prodObj.isActive = true;
        prodList.add(prodObj);

        Product2 prodObj2 = new Product2(); //new sub
        prodObj2.Name = 'Essentials Library — US (Westlaw PRO™)';
        prodObj2.List_Price__c = 0;
        prodObj2.Format__c = 'Online';
        prodObj2.Is_Orderable__c = TRUE;
        prodObj2.IS_WP_Eligible__c = TRUE;
        prodObj2.Media_High_Level__c = 'Online';
        prodObj2.Service_Number__c = '40982846';
        prodObj2.Subscription_Number__c = '40974108';
        prodObj2.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj2.Family = 'WESTLAW';
        prodObj2.Apttus_Filter_Media__c = 'Online';
        prodObj2.APTS_Media_High_Level_Code__c = '05';
        prodObj2.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj2.Productcode = '42009614';
        prodObj.isActive = true;
        prodList.add(prodObj2);
        insert prodList;

        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
        prop.Apttus_Proposal__Proposal_Name__c = 'test proposal';
        prop.Apttus_Proposal__Opportunity__c = oppList[0].id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
        prop.APTS_Proposal_Business_Unit__c = 'SCS';
        prop.APTS_Order_Confirmation_Contact__c = testcontact.id;
        insert prop;

        Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.id;
        cart.Apttus_Config2__AccountId__c = acc.id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.id;
        cart.Digital_Pending_Cart__c = TRUE;
        cart.Apttus_Config2__Status__c = 'Finalized';
        insert cart;
        System.assert(cart != null,'Cart is null');

        Apttus_Config2__LineItem__c line = new Apttus_Config2__LineItem__c();
        line.Apttus_Config2__ConfigurationId__c = cart.id;
        line.Apttus_Config2__LineNumber__c = 1;
        line.Apttus_Config2__ItemSequence__c = 1;
        line.Apttus_Config2__LineType__c = 'Product/Service';
        line.Apttus_Config2__BillToAccountId__c = acc.id;
        line.Apttus_Config2__ShipToAccountId__c = acc.id;
        insert line;

        test.starttest();
        Digital_FinalizeCart dfc = new Digital_FinalizeCart();
        Database.executeBatch(dfc, 1);
        test.stoptest();
    }

	/** 
 	 * @description : Test method for second test scenario
 	 */
    public static testmethod void testcart2() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'
            LIMIT 1
        ];
        Profile p2 = [SELECT Id, name FROM Profile WHERE Name = 'Partner Portal User'
            LIMIT 1
        ];
        system.debug(logginglevel.INFO, 'Profile selected: ' + p2);
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;

        Map < String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        system.debug(logginglevel.INFO, 'Opportunity Record Type: ' + optyPipeRecTypeId);
        Digital_Campaigns__c dcCamp = new Digital_Campaigns__c(Name = '00237KI', YoY_1_Renewal__c = 2, YoY_2__c = 2, Best_Value__c = true);

        insert dcCamp;

        // DLT-20631  - Removed Hardcoded ID
        List < RecordtypeIds__c > recTList = new List < RecordtypeIds__c > ();
        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        recTList.add(recT);

        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        recTList.add(recT1);
        insert recTList;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'Standard Price Book';
        insert pbook;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();

        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        Account acc = APTS_TestDataFactory.createAccount('Test Account');
        acc.FrozenMarketSegment__c = valueMarket;
        acc.SAPAccountNumber__c = '1004284494';
        insert acc;

        list < Opportunity > oppList = new list < Opportunity > ();
        Opportunity opp1 = new Opportunity();
        opp1 = UnitTest.getOpportunityInstance(acc.id);
        opp1.isdigitalSpearhead__c = TRUE;
        opp1.CloseDate = System.Today() + 30;
        opp1.StageName = '10%';
        opp1.Renewal_Date__c = System.Today();
        opp1.Status__c = 'Converted';
        opp1.RecordTypeId = optyPreRecTypeID;
        opp1.Pricebook2 = pBook;
        opp1.Campaign_Code__c = dcCamp.Name;
        // Added by Ravi
        opp1.AccountId = acc.id;
        oppList.add(opp1);
        insert oppList;


        list < Contact > contactList = new list < Contact > ();
        system.debug(logginglevel.INFO, 'Contact List: ' + contactList);
        Contact testcontact = UnitTest.getContactInstance(Acc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = acc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.Job_Function__c = 'Other';
        testcontact.SAP_Role__c = 'WL PSWD ACTIVE';
        insert testcontact;

        list < Product2 > prodList = new list < Product2 > ();

        Product2 prodObj = new Product2(); //current sub
        prodObj.Name = 'Essentials Library — Florida (Westlaw PRO™)';
        prodObj.List_Price__c = 0;
        prodObj.Format__c = 'Online';
        prodObj.Is_Orderable__c = TRUE;
        prodObj.IS_WP_Eligible__c = TRUE;
        prodObj.Media_High_Level__c = 'Online';
        prodObj.Service_Number__c = '40982845';
        prodObj.Subscription_Number__c = '40974107';
        prodObj.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj.Family = 'WESTLAW';
        prodObj.Apttus_Filter_Media__c = 'Online';
        prodObj.APTS_Media_High_Level_Code__c = '05';
        prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj.Productcode = '42009613';
        prodObj.isActive = true;
        prodList.add(prodObj);

        Product2 prodObj2 = new Product2(); //new sub
        prodObj2.Name = 'Essentials Library — US (Westlaw PRO™)';
        prodObj2.List_Price__c = 0;
        prodObj2.Format__c = 'Online';
        prodObj2.Is_Orderable__c = TRUE;
        prodObj2.IS_WP_Eligible__c = TRUE;
        prodObj2.Media_High_Level__c = 'Online';
        prodObj2.Service_Number__c = '40982846';
        prodObj2.Subscription_Number__c = '40974108';
        prodObj2.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj2.Family = 'WESTLAW';
        prodObj2.Apttus_Filter_Media__c = 'Online';
        prodObj2.APTS_Media_High_Level_Code__c = '05';
        prodObj2.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj2.Productcode = '42009614';
        prodObj.isActive = true;
        prodList.add(prodObj2);
        insert prodList;

        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
        prop.Apttus_Proposal__Proposal_Name__c = 'test proposal';
        prop.Apttus_Proposal__Opportunity__c = oppList[0].id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
        prop.APTS_Proposal_Business_Unit__c = 'SCS';
        prop.APTS_Order_Confirmation_Contact__c = testcontact.id;
        insert prop;

        Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.id;
        cart.Apttus_Config2__AccountId__c = acc.id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.id;
        cart.Digital_Pending_Cart__c = TRUE;
        //cart.Apttus_Config2__Status__c = 'Finalized';
        insert cart;
        System.assert(cart != null,'Cart is null');

        Apttus_Config2__LineItem__c line = new Apttus_Config2__LineItem__c();
        line.Apttus_Config2__ConfigurationId__c = cart.id;
        line.Apttus_Config2__LineNumber__c = 1;
        line.Apttus_Config2__ItemSequence__c = 1;
        line.Apttus_Config2__LineType__c = 'Product/Service';
        line.Apttus_Config2__BillToAccountId__c = acc.id;
        line.Apttus_Config2__ShipToAccountId__c = acc.id;
        insert line;

        test.starttest();
        Digital_FinalizeCart dfc = new Digital_FinalizeCart();
        Database.executeBatch(dfc, 1);
        test.stoptest();
    }
}