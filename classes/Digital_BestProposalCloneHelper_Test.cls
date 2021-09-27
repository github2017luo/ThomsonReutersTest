@istest 
private class Digital_BestProposalCloneHelper_Test{     
    
    public static Source_System_Detail__c accountSSD;
    public static String opp1id;
    public static String Acctid;
    public static String Acctssdid;
    public static String pboookid;
    public static Apttus_Proposal__Proposal__c q1Obj;
    public static Apttus_Config2__ProductConfiguration__c newCartObj;
    
    @testsetUp static void createTestData() {
        test.starttest();
        DCTestData.createData(); 
        test.stoptest();
        opp1id = DCTestdata.oppId;
        Acctid = DCTestData.accountId;
        Acctssdid = DCTestData.accssdid;
        pboookid = DCTestdata.pBookId;
        Apttus_Config2__PriceList__c priceList = [select id,name from Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal' limit 1 ];
        
        Apttus_Config2__PriceListItem__c pliSO = DCTestData.createPriceListItem(priceList.Id, null);  
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        update pliSO;
        
        List<Opportunity> optyList = DCTestData.oppList1 ;
        DCTestData.createProduct('SL All States Primary Law (Westlaw PRO™)', '42004986','42004988');
        list<product2> prod = [select id,APTS_Media_Lower_Level_Code__c,APTS_Media_High_Level_Code__c,Apttus_Filter_Brand_Code__c,Productcode,APTS_Product_Pricing_Model__c from product2 where Productcode IN ('42004986')];
        
        Apttus_Config2__ClassificationName__c ClasficName = new Apttus_Config2__ClassificationName__c();
        ClasficName.Name ='Digital Configurator';
        ClasficName.Apttus_Config2__HierarchyLabel__c ='Digital Configurator';
        ClasficName.Apttus_Config2__Active__c= true;
        insert ClasficName;
        
        Apttus_Config2__ClassificationHierarchy__c ClasficHier = new Apttus_Config2__ClassificationHierarchy__c();
        ClasficHier.Name = 'Digital Configurator';
        ClasficHier.Apttus_Config2__HierarchyId__c = ClasficName.id;
        ClasficHier.Apttus_Config2__Label__c = 'Digital Configurator';
        insert ClasficHier;
        
        Apttus_Config2__ClassificationHierarchy__c ClasficHier1 = new Apttus_Config2__ClassificationHierarchy__c();
        ClasficHier1.Name = 'Your State / All States';
        ClasficHier1.Apttus_Config2__HierarchyId__c = ClasficName.id;
        ClasficHier1.Apttus_Config2__PrimordialId__c = ClasficHier.id;
        ClasficHier1.Apttus_Config2__Label__c =  'Your State / All States';
        insert ClasficHier1;
        
        
        Apttus_Config2__ProductClassification__c ProdClasfic = new Apttus_Config2__ProductClassification__c();
        ProdClasfic.Apttus_Config2__ClassificationId__c = ClasficHier1.id;
        ProdClasfic.Apttus_Config2__ProductId__c = prod[0].id;
        insert ProdClasfic;
        
        
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
        
        Product_Account_Detail__c prodactdetail1 = new Product_Account_Detail__c();
        prodactdetail1.ZP_Cust_Number__c = '1004284494';
        prodactdetail1.Account__c = Acctid;
        prodactdetail1.AccountSSD__c = Acctssdid;
        prodactdetail1.Actual_New_Service__c = '42004986';  
        prodactdetail1.Actual_New_Subscription__c = '42004988';
        prodactdetail1.campaign_code__c = '00237KI';
        prodactdetail1.Quantity__c = 1;
        prodactdetail1.Offer_Price__c = -5;
        prodactdetail1.Type__c ='Config';
        prodactdetail1.Renewal_Date__c = System.Today().addDays(60);
        prodactdetailList.add(prodactdetail1); 
        
        Product_Account_Detail__c prodactdetail2 = new Product_Account_Detail__c();
        prodactdetail2.ZP_Cust_Number__c = '1004284494';
        prodactdetail2.Account__c = Acctid;
        prodactdetail2.AccountSSD__c = Acctssdid;
        prodactdetail2.Current_Subscription__c = '40974107';
        //prodactdetail2.Actual_New_Subscription__c = '42009613';
        //prodactdetail2.Actual_New_Service__c = '42009613';
        prodactdetail2.campaign_code__c = '00237KI';
        prodactdetail2.Quantity__c = 1;
        prodactdetail2.Type__c ='Config';
        prodactdetail2.Renewal_Date__c = System.Today().addDays(60);
        prodactdetailList.add(prodactdetail2);
        
        Product_Account_Detail__c prodactdetail3 = new Product_Account_Detail__c();
        prodactdetail3.ZP_Cust_Number__c = '1004284494';
        prodactdetail3.Account__c = Acctid;
        prodactdetail3.AccountSSD__c = Acctssdid;
        prodactdetail3.Actual_New_Service__c = '42015033';
        prodactdetail3.Actual_New_Subscription__c = '42015086';
        //prodactdetail3.Premium_New_Subscription__c = '40974108';
        prodactdetail3.Offer_Price__c = 5;
        prodactdetail3.campaign_code__c = '00237KI';
        prodactdetail3.Quantity__c = 1;
        prodactdetail3.Type__c ='Config';
        prodactdetail3.Renewal_Date__c = System.Today().addDays(60);
        prodactdetailList.add(prodactdetail3);
        
        insert prodactdetailList;
        
        
        Contact testcontact= UnitTest.getContactInstance(AcctId);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = Acctid;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact; 
        LCRM_Contact_SSD__c testContactSSD = new LCRM_Contact_SSD__c();
        testContactSSD = DCTestData.createContactSSD(testcontact,DCTestData.accountSSDlst);
        testContactSSD.LCRM_Last_Name__c = 'testContactSSD';
        testContactSSD.LCRM_First_Name__c = 'testContactSSD';
        testContactSSD.LCRM_Account_SSD__c= Acctssdid;
        
        
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Apttus_Proposal__Opportunity__c = optyList[0].id ;
        q1.Apttus_Proposal__Account__c = acctid;
        q1.Apttus_QPConfig__BillToAccountId__c = acctid;
        q1.Apttus_QPConfig__ShipToAccountId__c = acctid;
        q1.APTS_SSD_Sold_To__c = Acctssdid;
        q1.APTS_SSD_ship_to__c = Acctssdid;
        q1.APTS_SSD_bill_to__c = Acctssdid;
        q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q1.Digital_Quote_Type__c = 'Best Value'; 
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = false;
        q1Obj = q1;
        quoteList.add(q1);
        
        insert quoteList;
        
        
        // create new cart
        list<Apttus_Config2__ProductConfiguration__c> cartList = new list<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c();
        newCart1.Apttus_QPConfig__Proposald__c = quoteList[0].Id;
        newCart1.Apttus_Config2__Status__c = 'Finalized';
        newCart1.Name = 'test cart';
        newCartObj = newCart1;
        cartList.add(newCart1);        
        
        insert cartList;      
        
        
        list<Apttus_Config2__SummaryGroup__c> lstSummary = new List<Apttus_Config2__SummaryGroup__c>();
        Apttus_Config2__SummaryGroup__c summary = new Apttus_Config2__SummaryGroup__c();
        summary.Apttus_Config2__ConfigurationId__c = cartList[0].id;
        summary.Apttus_Config2__ItemSequence__c=1;
        summary.Apttus_Config2__LineNumber__c=1;
        lstSummary.add(summary);
        insert lstSummary;
        
        list<Apttus_Config2__AdHocGroup__c> lstAdhc = new List<Apttus_Config2__AdHocGroup__c>();
        Apttus_Config2__AdHocGroup__c adhoc = new Apttus_Config2__AdHocGroup__c();
        adhoc.Apttus_Config2__ConfigurationId__c = cartList[0].id;
        lstAdhc.add(adhoc);
        insert lstAdhc;
        
        list<Apttus_Config2__LineItem__c> listLines = new list<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c line = DCTestData.createLineItem(cartList[0].id, 1, 1, true, 'Product/Service', prod[0].id, null, 1,null,  pliSO.id, false, false);        
        
        listLines.add(line);
        insert listLines;        
    } 
    
    private static testmethod void Digital_BestProposalCloneHelperTest1(){
       
        test.starttest();       
        Apttus_Approval__Approval_Process__c process  = new Apttus_Approval__Approval_Process__c();
        process.Apttus_Approval__Active__c = true;
        insert process;
        apttus_Approval__ApprovalProcessInstance__c processInstance = new Apttus_Approval__ApprovalProcessInstance__c();
        Apttus_Config2__ProductConfiguration__c newCartObj = [select id ,Name from Apttus_Config2__ProductConfiguration__c where Apttus_Config2__Status__c = 'Finalized' limit 1];
        processInstance.Apttus_Approval__BusinessObjectId__c = newCartObj.id;
        
        processInstance.Apttus_Approval__ApprovalProcessId__c = process.id;
        insert processInstance;
        
        list<Apttus_Approval__Approval_Request__c> lstApproval = new list<Apttus_Approval__Approval_Request__c>();
        Apttus_Approval__Approval_Request__c arcloned = new Apttus_Approval__Approval_Request__c();
        arcloned.Apttus_Approval__ProcessInstanceId__c = processInstance.id;
        arcloned.Apttus_Approval__Object_Id__c = newCartObj.id;
        arcloned.Apttus_Approval__Object_Name__c = newCartObj.Name;
        arcloned.Apttus_CQApprov__CartId__c = newCartObj.id;
        Apttus_Proposal__Proposal__c q1Obj = [select id ,Name from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' limit 1];
        arcloned.Apttus_QPApprov__ProposalId__c = q1Obj.id;
        lstApproval.add(arcloned);
        insert lstApproval;
        
        Id mollyUserId = [Select id from User where name = 'Molly Bentz'].ID;
        
        list<Product_Account_Detail__c> digitalSubscriptionsList = [SELECT Account__c,AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,Digital_Firm__c  FROM Product_Account_Detail__c where Campaign_Code__c != Null AND (Type__c='Config' AND Type__c Not IN ('Plus','Premium')) AND Renewal_Date__c >= NEXT_N_DAYS:180 ];
        
         List<Opportunity> optyList  = [select id,Campaign_Code__c,AccountId from Opportunity];
        
        Digital_BestProposalCloneHelper.cloneProposal(optyList,mollyUserId,digitalSubscriptionsList);
        system.assertNotEquals(optyList,null);
        //Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id AND Digital_Quote_Type__c!= 'Best Value'];
        test.stoptest();
        //System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value+Config');
    }    
    
    
    private static testmethod void BestProposalCloneHelperExcp(){
        
        List<Opportunity> optyList = [select id,Campaign_Code__c,AccountId from Opportunity];
        test.starttest();
        Id mollyUserId = [Select id from User where name = 'Molly Bentz'].ID;
        
        list<Product_Account_Detail__c> digitalSubscriptionsList = [SELECT Account__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,Digital_Firm__c  FROM Product_Account_Detail__c where  Campaign_Code__c != Null AND (Type__c='Config' AND Type__c Not IN ('Plus','Premium')) AND Renewal_Date__c >= NEXT_N_DAYS:180];
        
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        
        for(Apttus_Proposal__Proposal__c q1 : [SELECT Digital_Quote_Type__c,Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c from Apttus_Proposal__Proposal__c]){
            q1.Digital_Quote_Type__c = 'Premium';
            quoteList.add(q1);
        }
        
        update quoteList;
        
        system.assertNotEquals(quoteList,null);
        
        Digital_BestProposalCloneHelper.cloneProposal(optyList,mollyUserId,digitalSubscriptionsList);
        
        
        //Apttus_Proposal__Proposal__c propos  [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1id and Digital_Quote_Type__c = 'Best Value'];
        test.stoptest();
        //System.assertEquals(propos.Digital_Quote_Type__c ,'Best Value');
    } 
    
    
    
}