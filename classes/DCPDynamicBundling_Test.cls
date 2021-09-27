@isTest
private class DCPDynamicBundling_Test {
    @testSetup 
    static void setuptestDCDynamicBundle() {

        //Disables process builders/triggers/etc
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        //Create Account, Opporrunity, Contact, Source System Detail, Pricebook2 and Price List
        Test.startTest();
        DCTestData.createData(); 
        Test.stopTest();

        Apttus_Config2__PriceList__c priceList = [select id,name from Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal' limit 1 ];
        
        Account tAccount = new Account();
        tAccount.id = DCTestData.accountId;
        
        Contact tContact =new Contact();
        tContact.id = DCTestData.contactId;
        
         List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')
           };
        insert webserviceList;
        
        Source_System_Detail__c tSSDAccount = new Source_System_Detail__c();
        tSSDAccount.id = DCTestData.accssdid;
        tSSDAccount.APTS_Customer_Category__c = null;
        update tSSDAccount;
        
        Opportunity tOppty = new Opportunity();
        tOppty.id = DCTestData.oppId;
        tOppty.Campaign_Code__c ='00237KI';
        tOppty.Renewal_Date__c = system.today().addDays(50);
        tOppty.Key_Contact__c = tContact.id;
        update tOppty;      
        
        // create web services
        DCTestData.createPaymentCreditWebService();
        
        
        Apttus_Proposal__Proposal__c proposal = DCTestData.createQuote(tAccount.Id, 'Best Value');
        insert proposal;
        
        Apttus_Proposal__Proposal__c cproposal = DCTestData.createQuote(tAccount.Id, 'Best Value+Config');
        cproposal.APTS_SSD_Sold_To__c = tSSDAccount.id;
        cproposal.APTS_SSD_bill_to__c = tSSDAccount.id;
        insert cproposal;
        
        List<Apttus_Config2__ProductConfiguration__c> prodConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
                       
        Apttus_Config2__ProductConfiguration__c prodConfig = DCTestData.createCart(tAccount.id, proposal.Id, null, priceList.Id);
        insert prodConfig;
               
        prodConfigList.add(prodConfig);
                       
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__PriceListItem__c pliSO = DCTestData.createPriceListItem(priceList.Id, null);  
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        update pliSO;

        Product2 westproflex = DCTestData.createProduct('West Proflex','40757482','40757481');
        Apttus_Config2__PriceListItem__c pliSO2 = DCTestData.createPriceListItem(priceList.Id, null);  
        pliSO2.Apttus_Config2__ProductId__c = westproflex.id;
        pliSO2.Apttus_Config2__PriceType__c = 'Recurring';
        update pliSO2;
        /*
        [Select Id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductCode__c,Apttus_Config2__ProductName__c,
        Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c
        ,Apttus_Config2__ChargeType__c,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c 
        where Apttus_Config2__ProductCode__c IN: productCodes AND Apttus_Config2__PriceType__c != 'One Time'];
        */
        //created product given error when used existing DCTestData.createProduct Method,So crated new specific to this test class.
        Product2 prodObj = DCTestData.createProductforDCDyn('Network Services 1.0', '05', 'E5');
        insert prodObj;
        

        // crated AssetLineItem
        DCTestData.createAssetLineItem(cproposal.id);
        
        
        APTS_Group__c proposalGroup = DCTestData.createProposalGroup(proposal, prodConfig);
        system.debug(LoggingLevel.DEBUG,'proposalGroup----'+proposalGroup);
        Apttus_Config2__SummaryGroup__c summaryGroup1 = DCTestData.createSummaryGroup(prodConfig.id, null);
        
        Apttus_Config2__LineItem__c linObj = DCTestData.createLineItem(prodConfig.id, 1, 1, 
                                                                       true, 'Product/Service', prodObj.id, null, 1,
                                                                       null, pliSO.id, false, false);
        
        linObj.Apttus_Config2__AssetLineItemId__c = DCTestData.assetLineItemId;
        linObj.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
        listOfLineItems.add(linObj);
        
        Apttus_Config2__LineItem__c linObj2 = DCTestData.createLineItem(prodConfig.id, 2, 2, 
                                                                        true, 'Product/Service', prodObj.id, null, 1,
                                                                        null, pliSO.id, false, false);
        
        linObj2.Apttus_Config2__AssetLineItemId__c = DCTestData.assetLineItemId;
        linObj2.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
        
        listOfLineItems.add(linObj2);
        Apttus_Config2__LineItem__c linObj3 = DCTestData.createLineItem(prodConfig.id, 2, 2, 
                                                                        true, 'Product/Service', prodObj.id, null, 1,
                                                                        null, pliSO.id, false, false);
        
        linObj3.Apttus_Config2__AssetLineItemId__c = DCTestData.assetLineItemId;
        linObj3.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
        listOfLineItems.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = DCTestData.createLineItem(prodConfig.id, 2, 2, 
                                                                        true, 'Product/Service', prodObj.id, null, 1,
                                                                        null, pliSO.id, false, false);
        
        linObj4.Apttus_Config2__AssetLineItemId__c = DCTestData.assetLineItemId;
        linObj4.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
        listOfLineItems.add(linObj4);

        Apttus_Config2__LineItem__c linObj5 = DCTestData.createLineItem(prodConfig.id, 2, 2, 
                                                                        true, 'Product/Service', westproflex.id, null, 1,
                                                                        null, pliSO2.id, false, false);
        
        linObj5.Apttus_Config2__AssetLineItemId__c = DCTestData.assetLineItemId;
        linObj5.Apttus_Config2__SummaryGroupId__c = summaryGroup1.id;
        listOfLineItems.add(linObj5);
        
        insert listOfLineItems;
        
        List<Apttus_Config2__ProductAttributeValue__c> pavObj = new List<Apttus_Config2__ProductAttributeValue__c>();
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj.add(new Apttus_Config2__ProductAttributeValue__c(
                eBook_Purchase_Options__c = 'APP',
                APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id));
        }
        insert pavObj;
        
        /*
        APTS_Quote_Agreement_Locations__c location = new APTS_Quote_Agreement_Locations__c(APTS_Quote_Proposal__c = proposal.id);
        insert location;
        APTS_Additional_Subscription_Actions__c actions = new APTS_Additional_Subscription_Actions__c(APTS_Quote_Proposal__c = proposal.id);
        insert actions;
        */   
        // crated APTS ConfigBundlePageSettings 
        DCTestData.createConfigBundle(); 
    }
    
    private static testmethod void testDCDynamicBundleTest(){

        test.starttest();
        List<Apttus_Config2__ProductConfiguration__c> prodConfigsList = 
                        [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,(select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1)
                        FROM Apttus_Config2__ProductConfiguration__c limit 1];
        
        //DCDynamicBundle.performBundling('Bundle A', prodConfigsList);
        Map<String,String> requestBody = new map<string,string>();
        requestBody.put('cartId', prodConfigsList[0].id);
        DCPRenewalRestHandler.serviceHandler('bundle',requestBody);
        //DCPDynamicBundling.executeDynamicBundling(requestBody);       
        system.AssertEquals(prodConfigsList[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 'Best Value','Best Value');
        
        test.stoptest(); 
    }
    
    private static testmethod void testImproperRequest(){

        test.starttest();
        List<Apttus_Config2__ProductConfiguration__c> prodConfigsList = 
                        [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,(select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1)
                        FROM Apttus_Config2__ProductConfiguration__c limit 1];
        
        //DCDynamicBundle.performBundling('Bundle A', prodConfigsList);
        Map<String,String> requestBody = new map<string,string>();
        requestBody.put('cartId1', prodConfigsList[0].id);
        DCPRenewalRestHandler.serviceHandler('bundle',requestBody);
        //DCPDynamicBundling.executeDynamicBundling(requestBody);       
        system.AssertEquals(prodConfigsList[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 'Best Value','Best Value');
        
        test.stoptest(); 
    }
    
    private static testmethod void testDCDynamicBundleTest2(){

        test.starttest();
        List<Apttus_Config2__ProductConfiguration__c> prodConfigsList = 
                        [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,(select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1)
                        FROM Apttus_Config2__ProductConfiguration__c limit 1];
     
        DCPDynamicBundlingHelper.callApttusPriceUpdateAPI(prodConfigsList[0].id);
        
        system.AssertEquals(prodConfigsList[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 'Best Value','Best Value');
        
        test.stoptest(); 
    }
    
    private static testmethod void testgetFromAssetPreGroupMap(){

        test.starttest();
        List<Apttus_Config2__ProductConfiguration__c> prodConfigsList = 
                        [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,(select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1)
                        FROM Apttus_Config2__ProductConfiguration__c limit 1];
        
        List<Apttus_Config2__LineItem__c> lineItems = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> lineItems1 = new List<Apttus_Config2__LineItem__c>();
        lineItems = [Select Id from Apttus_Config2__LineItem__c limit 1];
        
        Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
        assetPreGroupMap.put('Print',lineItems);
        
        DCPDBCreateGroup.getFromAssetPreGroupMap(assetPreGroupMap,lineItems1,'Print');
        system.AssertEquals(prodConfigsList[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 'Best Value','Best Value');
        
        test.stoptest(); 
    }
    
    private static testmethod void testDBLocation(){

        test.starttest();
        List<Apttus_Config2__ProductConfiguration__c> prodConfigsList = 
                        [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, 
                         Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, 
                         Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,
                         Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,
                         Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                         (select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,
                          Apttus_Config2__Quantity__c,APTS_Contract_Term__c 
                          from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1)
                        FROM Apttus_Config2__ProductConfiguration__c limit 1];
        
        DCPDynamicBundling.objectCart = prodConfigsList[0];
        
        DCPDBInitializeData.BundleWrapper bundleWrapper1 = new DCPDBInitializeData.BundleWrapper();
        //bundleWrapper1 = DCPDBInitializeData.initializeData();
        
        DCPDynamicBundling.bundlewrapper = bundleWrapper1;
        DCPDynamicBundling.bundlewrapper.mlaAgreementNumber = '1';
            
        APTS_Quote_Agreement_Locations__c location = new APTS_Quote_Agreement_Locations__c(APTS_Quote_Proposal__c = prodConfigsList[0].Apttus_QPConfig__Proposald__c);
        insert location;
        APTS_Additional_Subscription_Actions__c actions = new APTS_Additional_Subscription_Actions__c(APTS_Quote_Proposal__c = prodConfigsList[0].Apttus_QPConfig__Proposald__c);
        insert actions;
        
        DCPDBLocation.updateExistingLocation();
        system.AssertEquals(prodConfigsList[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 'Best Value','Best Value');        
        
        test.stoptest(); 
    } 
}