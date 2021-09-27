/* Created By - Bishanka Dassarma
   Purpose - Test Class for DigitalOpportunityCreationAutomation
   Jira Story - DLT-14704

 Modified by Navleen    25 April   DLT-16176 - [FindLaw] [TECH STORY] Opportunity Creation is failing for Findlaw and throwing 201 SOQL issue.
 Modified by HArika     27 May     DLT-16561 - [TECH STORY] [FindLaw] Create Opportunities when automation does not find any opportunities associated with them
 23-07-2020   Rahul Natarajan         DLT-20035 - Remove Segmentation Field References from CX Digital components.
*/

@isTest
public class DigitalOpportunityCreation_Test {
    public static Source_System_Detail__c accountSSD1;
    public static String opp2id;
    public static String Acct1id;
    public static String Acctssd1id;

    @testsetup
    public static void testdata() {
        Test.startTest();
        Id mollyUserId = [Select id from User where name = 'Molly Bentz'].ID;
        DCTestData.createData();
        test.stoptest();

        // Commented Segmentation Fields - DLT-20035
        opp2id = DCTestdata.oppId;
        Acct1id = DCTestData.accountId;
        Acctssd1id = DCTestData.accssdid;
        Account acc = new Account();
        acc.Name = 'Test Account';
        // acc.FrozenMarketSegment__c = 'Solo Law Firm';
        acc.SAPAccountNumber__c = '1004284495';
        //  acc.Customer_Group__c = 'FIRM';
        acc.APTS_Band_Number__c = 1;
        acc.APTS_Customer_Category__c = '3';
        acc.APTS_eOutput_Eligibilty__c = '';
        insert acc;

        Contact oContact = new Contact();
        oContact.AccountId = acc.ID;
        oContact.FirstName = 'Unit';
        oContact.LastName = 'Test';
        oContact.MailingStreet = '123 Unit Test';
        oContact.MailingCity = 'Dallas';
        oContact.MailingState = 'TX';
        oContact.MailingCountry = 'US';
        oContact.MailingPostalCode = '75019';
        oContact.SAP_Role__c = 'EML ORDER CONFIRM';
        insert oContact;

        Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD = new Source_System_Detail__c();
        accountSSD.RecordtypeId = ssdRecorType;
        accountSSD.Name = 'ABC';
        accountSSD.Source_System_Name__c = 'ABC';
        accountSSD.Account_Name__c = acc.ID;
        accountSSD.Account_Inactive__c = false;
        accountSSD.Source_System_Account_Number__c = acc.SAPAccountNumber__c;
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
        accountSSD.LCRM_SAP_Account_Number__c = '1004284495';
        accountSSD.LCRM_APTS_Band_Number__c = 1;
        accountSSD.APTS_Customer_Category__c = '3';
        accountSSD.LCRM_eOutput_Eligibility__c = '';
        accountSSD.LCRM_Sales_Org__c = 'WEST';
        accountSSD.State__c = 'California';
        accountSSD.LCRM_Customer_Group__c = 'FIRM';
        insert accountSSD;
        list < LCRM_Contact_SSD__c > csd = new list < LCRM_Contact_SSD__c > ();
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c();
        conSSD.LCRM_Contact__c = oContact.Id;
        conSSD.LCRM_SAP_Role__c = oContact.SAP_Role__c;
        //conSSD.LCRM_Source_Contact_Id__c=con.SAP_Contact_ID__c;
        conSSD.LCRM_Account_SSD__c = accountSSD.Id;
        conSSD.LCRM_Email__c = oContact.Email;
        csd.add(conSSD);
        LCRM_Contact_SSD__c conSSD1 = new LCRM_Contact_SSD__c();
        conSSD1.LCRM_Contact__c = oContact.Id;
        conSSD.LCRM_SAP_Role__c = oContact.SAP_Role__c;
        //conSSD.LCRM_Source_Contact_Id__c=con.SAP_Contact_ID__c;
        conSSD1.LCRM_Account_SSD__c = Acctssd1id;
        conSSD1.LCRM_Email__c = oContact.Email;
        csd.add(conSSD1);
        insert csd;

        List < Opportunity > oppList = new List < Opportunity > ();
        list < Product_Account_Detail__c > prodactdetailList = new list < Product_Account_Detail__c > ();

        Product_Account_Detail__c prodactdetail1 = DCTestData.createDigitalSubscriptions('42072689', '42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        prodactdetail1.Account__c = Acct1id;
        prodactdetail1.AccountSSD__c = Acctssd1id;
        prodactdetail1.Actual_New_Subscription__c = '42009613';
        prodactdetail1.Premium_New_Service__c = '42009613';
        prodactdetail1.Offer_Price__c = -5;
        prodactdetail1.Digital_Firm__c = 'SmallLaw';
        prodactdetail1.Type__c = 'Config';
        prodactdetailList.add(prodactdetail1);

        Product_Account_Detail__c prodactdetail2 = DCTestData.createDigitalSubscriptions('41935308', '41935309', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');

        prodactdetail2.Account__c = Acct1id;
        prodactdetail2.AccountSSD__c = Acctssd1id;
        prodactdetail2.Current_Subscription__c = '40974107';
        prodactdetail2.Actual_New_Subscription__c = '42009613';
        prodactdetail2.Actual_New_Service__c = '42009613';
        prodactdetail2.Type__c = 'Config';
        prodactdetailList.add(prodactdetail2);

        Product_Account_Detail__c prodactdetail3 = DCTestData.createDigitalSubscriptions('42072689', '42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');

        prodactdetail3.Account__c = Acct1id;
        prodactdetail3.AccountSSD__c = Acctssd1id;
        prodactdetail3.Premium_New_Service__c = '42009614';
        prodactdetail3.Actual_New_Subscription__c = '42009613';
        prodactdetail3.Premium_New_Subscription__c = '40974108';
        prodactdetail3.Offer_Price__c = 5;
        prodactdetail3.Type__c = 'Config';
        prodactdetailList.add(prodactdetail3);

        upsert prodactdetailList;
    }
    private static testmethod void opportunityCreation_Test1() {

        Date date1 = Date.newInstance(2019, 6, 30);
        Set < Date > dateSet = new Set < Date > ();
        dateSet.add(date1);
        Map < String, Set < Date >> lsrdMap = new Map < String, Set < Date >> ();
        Source_System_Detail__c ssd = [Select id, name, Account_Name__c, Digital_Firm__c, (Select id from Opportunities__r where isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND Campaign_Code__c != Null),
            Source_System_Account_Number__c from Source_System_Detail__c limit 1
        ];
        list < Product_Account_Detail__c > prodactdetailList = [SELECT AccountSSD__c, Renewal_Date__c, sub_Campaign_Code__c, Campaign_Code__c, Digital_Firm__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription_Product__c, Current_Subscription__c, Premium_New_Subscription__c, ZP_Cust_Number__c, SAP_Contact_Id__c, Hard_Bounce__c FROM Product_Account_Detail__c where Current_Subscription__c != Null AND Campaign_Code__c != Null AND Renewal_Date__c > Today AND Digital_Firm__c != Null limit 1];
        lsrdMap.put(ssd.ID, dateSet);
        DigitalOpportunityCreationAutomation dbp = new DigitalOpportunityCreationAutomation();
        test.starttest();
        DigitalOpportunityCreationAutomation.getOpportunlist(prodactdetailList, lsrdMap, ssd);

        test.stoptest();
    }

    private static testmethod void opportunityCreation_Test2() {


        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        insert pbook;
        Account acc = [select id from Account where Name = 'Test Account'
            limit 1
        ];
        Source_System_Detail__c accountSSD = [Select id, name, Account_Name__c, Digital_Firm__c, (Select id from Opportunities__r where isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND Campaign_Code__c != Null),
            Source_System_Account_Number__c from Source_System_Detail__c where Name = 'ABC'
            Limit 1
        ];

        list < Product_Account_Detail__c > digiSubList = new list < Product_Account_Detail__c > ();
        Product_Account_Detail__c digiSub = DCTestData.createDigitalSubscriptions('42072689', '42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        digiSub.Account__c = acc.ID;
        digiSub.AccountSSD__c = accountSSD.ID;
        digiSub.Premium_New_Service__c = '42009614';
        digiSub.Actual_New_Subscription__c = '42009613';
        digiSub.Premium_New_Subscription__c = '40974108';
        digiSub.Offer_Price__c = 5;
        digiSub.Type__c = 'Config';
        digiSubList.add(digiSub);

        upsert digiSubList;

        Date date2 = Date.newInstance(2019, 6, 30);
        Set < Date > dateSet2 = new Set < Date > ();
        dateSet2.add(date2);
        Map < String, Set < Date >> lsrdMap2 = new Map < String, Set < Date >> ();
        lsrdMap2.put(accountSSD.ID, dateSet2);

        List < Opportunity > oppList2 = new List < Opportunity > ();
        Test.startTest();
        DigitalOpportunityCreationAutomation dbp = new DigitalOpportunityCreationAutomation();
        DigitalOpportunityCreationAutomation.getOpportunlist(digiSubList, lsrdMap2, accountSSD);
        test.stoptest();


    }

    public static testmethod void exceptionLog_Test() {
        Test.startTest();
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex = DigitalOpportunityCreationAutomation.createExceptionLog('abc', 'abc', 'abc', 'abc', 'abc', 'abc', 'abc');
        test.stoptest();
    }

    public static testmethod void findLawTest() {
        list < Product_Account_Detail__c > digiSubList = new list < Product_Account_Detail__c > ();
        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        insert pbook;
        Account acc = [select id from Account where Name = 'Test Account'
            limit 1
        ];
        Source_System_Detail__c accountSSD = [Select id, name, Account_Name__c, Digital_Firm__c, (Select id from Opportunities__r where isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND Campaign_Code__c != Null),
            Source_System_Account_Number__c from Source_System_Detail__c where Name = 'ABC'
            Limit 1
        ];

        Product_Account_Detail__c digiSub = DCTestData.createDigitalSubscriptions('42072689', '42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        digiSub.Account__c = acc.ID;
        digiSub.AccountSSD__c = accountSSD.ID;
        digiSub.current_subscription__c = '42009614';
        digiSub.Offer_Price__c = 5;
        digiSub.Type__c = 'Config';
        digiSub.Digital_Firm__c = 'FindLaw';
        digiSubList.add(digiSub);

        upsert digiSubList;
        Date date2 = Date.newInstance(2019, 6, 30);
        Set < Date > dateSet2 = new Set < Date > ();
        dateSet2.add(date2);
        Map < String, Set < Date >> lsrdMap2 = new Map < String, Set < Date >> ();
        lsrdMap2.put(accountSSD.ID, dateSet2);

        Test.startTest();
        DigitalOpportunityCreationAutomation dbp = new DigitalOpportunityCreationAutomation();
        DigitalOpportunityCreationAutomation.getOpportunlist(digiSubList, lsrdMap2, accountSSD);
        test.stoptest();

    }

}