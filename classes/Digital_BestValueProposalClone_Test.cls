/* CHANGE HISTORY
 ==================================================================================================================================
Date         Name                  Description
2020-08-27   Rahul Natarajan       DLT-20631 - [SFDC] [REN] Critical Code scan issue` and Fixed few PMD Violations
==================================================================================================================================   
 */
@istest
private class Digital_BestValueProposalClone_Test {

    public static Source_System_Detail__c accountSSD;
    public static String opp1id;
    public static String acctid;
    public static String acctssdid;

    @testSetup static void setup() {
         Id mollyUserId = [Select id from User where name = 'Molly Bentz'].ID;
        DcTestData.createData();
         test.starttest();
       
        List < Opportunity > optyList = createTestData();
        test.stoptest();
    }

    public static testmethod void Digital_BestValueProposalClone_Test1() {

        test.starttest();
        List < Opportunity > optyList=[Select Id from Opportunity];
        System.assert(optyList.size() != null);
        Digital_BestValueProposalCloneAutomation dbp = new Digital_BestValueProposalCloneAutomation();
        DataBase.executeBatch(dbp);

        test.stoptest();
    }

    public static List < Opportunity > createTestData() {

       
        opp1id = DCTestdata.oppId;
        acctid = DCTestData.accountId;
        acctssdid = DCTestData.accssdid;

        list < Product_Account_Detail__c > prodactdetailList = new list < Product_Account_Detail__c > ();

        Product_Account_Detail__c prodactdetail1 = DCTestData.createDigitalSubscriptions('42072689', '42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        prodactdetail1.Account__c = acctid;
        prodactdetail1.AccountSSD__c = acctssdid;
        prodactdetail1.Actual_New_Subscription__c = '42009613';
        prodactdetail1.Premium_New_Service__c = '42009613';
        prodactdetail1.Offer_Price__c = -5;
        prodactdetail1.Type__c = 'Config';
        prodactdetailList.add(prodactdetail1);

        Product_Account_Detail__c prodactdetail2 = DCTestData.createDigitalSubscriptions('41935308', '41935309', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');

        prodactdetail2.Account__c = acctid;
        prodactdetail2.AccountSSD__c = acctssdid;
        prodactdetail2.Current_Subscription__c = '40974107';
        prodactdetail2.Actual_New_Subscription__c = '42009613';
        prodactdetail2.Actual_New_Service__c = '42009613';
        prodactdetail2.Type__c = 'Config';
        prodactdetailList.add(prodactdetail2);

        Product_Account_Detail__c prodactdetail3 = DCTestData.createDigitalSubscriptions('42072689', '42072690', 'Plus', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');

        prodactdetail3.Account__c = acctid;
        prodactdetail3.AccountSSD__c = acctssdid;
        prodactdetail3.Premium_New_Service__c = '42009614';
        prodactdetail3.Actual_New_Subscription__c = '42009613';
        prodactdetail3.Premium_New_Subscription__c = '40974108';
        prodactdetail3.Offer_Price__c = 5;
        prodactdetail3.Type__c = 'Config';
        prodactdetailList.add(prodactdetail3);

        upsert prodactdetailList;

        List < Apttus_Proposal__Proposal__c > quoteList = new list < Apttus_Proposal__Proposal__c > ();

        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Apttus_Proposal__Opportunity__c = opp1id;
        q1.Apttus_Proposal__Account__c = acctid;
        q1.Apttus_QPConfig__BillToAccountId__c = acctid;
        q1.APTS_SSD_bill_to__c = acctssdid;
        q1.Apttus_QPConfig__ShipToAccountId__c = acctid;
        q1.APTS_SSD_ship_to__c = acctssdid;
        q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q1.Digital_Quote_Type__c = 'Straight Renewal';

        q1.Apttus_Proposal__Primary__c = false;

        quoteList.add(q1);

        Apttus_Proposal__Proposal__c qBest = new Apttus_Proposal__Proposal__c();
        qBest.Apttus_Proposal__Proposal_Name__c = 'Quote Best Value';
        qBest.Apttus_Proposal__Opportunity__c = opp1id;
        qBest.Apttus_Proposal__Account__c = acctid;
        qBest.Apttus_QPConfig__BillToAccountId__c = acctid;
        qBest.APTS_SSD_bill_to__c = acctssdid;
        qBest.Apttus_QPConfig__ShipToAccountId__c = acctid;
        qBest.APTS_SSD_ship_to__c = acctssdid;
        qBest.Apttus_Proposal__Approval_Stage__c = 'Draft';
        qBest.Digital_Quote_Type__c = 'Best Value';

        qBest.Apttus_Proposal__Primary__c = false;
        quoteList.add(qBest);

        insert quoteList;

        // create new cart
        list < Apttus_Config2__ProductConfiguration__c > cartList = new list < Apttus_Config2__ProductConfiguration__c > ();
        Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c();
        newCart1.Apttus_QPConfig__Proposald__c = quoteList[0].Id;
        newCart1.Apttus_Config2__Status__c = 'Finalized';
        newCart1.Name = 'test cart';
        cartList.add(newCart1);

        insert cartList;

        list < Apttus_Config2__SummaryGroup__c > lstSummary = new List < Apttus_Config2__SummaryGroup__c > ();
        Apttus_Config2__SummaryGroup__c summary = DCTestData.createSummaryGroup(cartList[0].Id, 'WEST PROFLEX Bundle A - Test group');
        summary.Apttus_Config2__ItemSequence__c = 1;
        lstSummary.add(summary);
        upsert lstSummary;

        list < Apttus_Config2__AdHocGroup__c > lstAdhc = new List < Apttus_Config2__AdHocGroup__c > ();
        Apttus_Config2__AdHocGroup__c adhoc = new Apttus_Config2__AdHocGroup__c();
        adhoc.Apttus_Config2__ConfigurationId__c = cartList[0].id;
        lstAdhc.add(adhoc);
        insert lstAdhc;

        Apttus_Approval__Approval_Process__c process = new Apttus_Approval__Approval_Process__c();
        process.Apttus_Approval__Active__c = true;
        insert process;
        apttus_Approval__ApprovalProcessInstance__c processInstance = new Apttus_Approval__ApprovalProcessInstance__c();
        processInstance.Apttus_Approval__BusinessObjectId__c = cartList[0].id;
        processInstance.Apttus_Approval__ApprovalProcessId__c = process.id;
        insert processInstance;

        list < Apttus_Approval__Approval_Request__c > lstApproval = new list < Apttus_Approval__Approval_Request__c > ();
        Apttus_Approval__Approval_Request__c arcloned = new Apttus_Approval__Approval_Request__c();
        arcloned.Apttus_Approval__ProcessInstanceId__c = processInstance.id;
        arcloned.Apttus_Approval__Object_Id__c = cartList[0].id;
        arcloned.Apttus_Approval__Object_Name__c = cartList[0].Name;
        arcloned.Apttus_CQApprov__CartId__c = cartList[0].id;
        arcloned.Apttus_QPApprov__ProposalId__c = quoteList[0].id;
        lstApproval.add(arcloned);
        insert lstApproval;

        return DCTestData.oppList1;

    }

}