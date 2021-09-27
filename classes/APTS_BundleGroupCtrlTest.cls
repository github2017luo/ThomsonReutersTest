@isTest
private class APTS_BundleGroupCtrlTest {
   
     @isTest static void testMethodThree() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList(label.CanadaPriceList);
        insert priceList;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
         List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,21';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Main_Bundle_Name__c='Eligible For Bundle';
        bundlePageSettings.Eligibility_codes_for_online_Canada__c='0649,0665,06AA,06AB,06AZ,06BA,06EE,06I9,06IA,06JA,06K1,06LB,06MC,06P7,13E3,13IQ,13LG,13PE,13SW,13SX,06Q6';
        bundlePageSettings.APTS_WestPack_Discount__c=50;
        bundlePageSettings.APTS_Max_Discount__c =20;
        bundlePageSettings.Incremental_Revenue_Required__c=50;
        insert bundlePageSettings;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        System.runAs(u1){
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        system.assertEquals(a.Name, 'Test Account');
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;
     
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> listOfLineItemsgp = New List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   
        
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO3;   
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Canada Proflex';
        prodObj.ProductCode= '41972767';
        prodObj.APTS_Media_High_Level_Code__c = '21';
        prodObj.APTS_Media_Lower_Level_Code__c = 'CQ';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c ='USL';
        prodObj.Service_Number__c='0';
        insert prodObj;  
        
       
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.APTS_Deal_Type__c   ='RB50';
        insert ali;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Quote_Proposal__c = proposal.Id;
        proposalGroup.APTS_MLA__c = true;
        proposalGroup.APTS_Decentralized__c = true;
        insert proposalGroup;       
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__ExtendedPrice__c=50, 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO.id,
            APTS_Group__c = proposalGroup.Id); 
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
             
        insert listOfLineItems;
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__ExtendedPrice__c=50,
            APTS_Product_Family__c='',
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        listOfLineItemsgp.add(linObj5);
        
        insert listOfLineItemsgp;
        listOfLineItemsgp[0].Apttus_Config2__ProductId__r=[Select id,LCRM_Sub_Bu__c   from Product2 where id=:prodObj.id];
        listOfLineItemsgp[0]=[Select id, APTS_Product_Group_Primary_Material__c,Apttus_Config2__NetPrice__c,Apttus_Config2__LineStatus__c,APTS_SAP_Deal_Number__c ,APTS_SAP_Deal_Type__c,Apttus_Config2__ExtendedPrice__c  from Apttus_Config2__LineItem__c where id=:listOfLineItemsgp[0].id];
        System.debug('Test Poonam'+listOfLineItemsgp[0].APTS_Product_Group_Primary_Material__c);
        System.debug('Test Poonam'+listOfLineItemsgp);
        
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        List<Apttus_Config2__ProductAttributeValue__c> pavobjlist = new List<Apttus_Config2__ProductAttributeValue__c>();
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj = new Apttus_Config2__ProductAttributeValue__c(
                eBook_Purchase_Options__c = 'APP',
                APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );
            pavobjlist.add(pavObj);                 
        }
        insert pavobjlist;
        
        
        //SOC-9796 PMD fix
        /* Apttus_Config2__TempObject__c   temp = new Apttus_Config2__TempObject__c();
        temp.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        insert temp;*/
        
        //string jsonData = '[{"dataList": [], "name": "Print", "notShownDataList":[] }]';
        string jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CANADA PROFLEX:41972767","APTS_Proposal_Business_Unit__c":"CANADA","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"AA","APTS_Media_High_Level_Code__c":"06","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"CANADA"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CANADA PROFLEX:41972767","APTS_Proposal_Business_Unit__c":"CANADA","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"06","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"CANADA"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":false,"APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":true}]}]';
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',prodConfig.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        ApexPages.currentPage().getParameters().put('isMLA', 'true');
        ApexPages.currentPage().getParameters().put('decentralized', 'true');
        
        system.debug('==========>prodConfig'+prodConfig);
        APTS_BundleGroupCtrl bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
       
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        bundleController.openCartPage();
        
        APTS_BundleGroupCtrl.createGroup('Print Group A', '{}');
        
        APTS_BundleGroupCtrl bundleController2 = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        ApexPages.currentPage().getParameters().put('ActionType', 'goToMultiLocation');
        bundleController2.saveAdjustmentData();
        set<String> optoinList1 = new set<String>();
        optoinList1.add('tetsing');
        List<Apttus_Config2__LineItem__c> liLists = new List<Apttus_Config2__LineItem__c>();
        bundleController2.calculateNets(listOfLineItemsgp, optoinList1, liLists );
        
        set<String> optoinList = new set<String>();
        optoinList.add('tetsing');
        //  bundleController.calculateNets(listOfLineItems1, optoinList, Lists1);
        
        Test.stopTest();
        }
    }
    @isTest static void testMethodTwo() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList(label.CanadaPriceList);
        insert priceList;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
         List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,21';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Main_Bundle_Name__c='Eligible For Bundle';
        bundlePageSettings.Eligibility_codes_for_online_Canada__c='0649,0665,06AA,06AB,06AZ,06BA,06EE,06I9,06IA,06JA,06K1,06LB,06MC,06P7,13E3,13IQ,13LG,13PE,13SW,13SX,06Q6';
        bundlePageSettings.APTS_WestPack_Discount__c=50;
        bundlePageSettings.APTS_Max_Discount__c =20;
        bundlePageSettings.Incremental_Revenue_Required__c=50;
        insert bundlePageSettings;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        System.runAs(u1){
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        system.assertEquals(a.Name, 'Test Account');
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Canada';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;
     
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> listOfLineItemsgp = New List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   
        
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO3;   
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Canada Proflex';
        prodObj.ProductCode= '41972767';
        prodObj.APTS_Media_High_Level_Code__c = '06';
        prodObj.APTS_Media_Lower_Level_Code__c = 'AZ';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c ='WEST';
        prodObj.Service_Number__c='0';
        insert prodObj;  
        
       
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.APTS_Deal_Type__c   ='RB50';
        insert ali;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Quote_Proposal__c = proposal.Id;
        proposalGroup.APTS_MLA__c = true;
        proposalGroup.APTS_Decentralized__c = true;
        insert proposalGroup;       
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__ExtendedPrice__c=50, 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
             
        insert listOfLineItems;
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__ExtendedPrice__c=50,
            APTS_Product_Family__c='',
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO3.id);
            
            Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__ExtendedPrice__c=50,
            APTS_Product_Family__c='',
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        listOfLineItemsgp.add(linObj5);
        listOfLineItemsgp.add(linObj6);
        insert listOfLineItemsgp;
        listOfLineItemsgp[0].Apttus_Config2__ProductId__r=[Select id,LCRM_Sub_Bu__c   from Product2 where id=:prodObj.id];
        listOfLineItemsgp[0]=[Select id, APTS_Product_Group_Primary_Material__c,Apttus_Config2__NetPrice__c,Apttus_Config2__LineStatus__c,APTS_SAP_Deal_Number__c ,APTS_SAP_Deal_Type__c,Apttus_Config2__ExtendedPrice__c  from Apttus_Config2__LineItem__c where id=:listOfLineItemsgp[0].id];
        System.debug('Test Poonam'+listOfLineItemsgp[0].APTS_Product_Group_Primary_Material__c);
        System.debug('Test Poonam'+listOfLineItemsgp);
        
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        List<Apttus_Config2__ProductAttributeValue__c> pavobjlist = new List<Apttus_Config2__ProductAttributeValue__c>();
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj = new Apttus_Config2__ProductAttributeValue__c(
                eBook_Purchase_Options__c = 'APP',
                APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );
            pavobjlist.add(pavObj);                 
        }
        insert pavobjlist;
        
 
        //string jsonData = '[{"dataList": [], "name": "Print", "notShownDataList":[] }]';
        string jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CANADA PROFLEX:41972767","APTS_Proposal_Business_Unit__c":"Canada","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"AA","APTS_Media_High_Level_Code__c":"06","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"CANADA"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CANADA PROFLEX:41972767","APTS_Proposal_Business_Unit__c":"CANADA","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"06","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"CANADA"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":false,"APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":true}]}]';
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',prodConfig.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        ApexPages.currentPage().getParameters().put('isMLA', 'true');
        ApexPages.currentPage().getParameters().put('decentralized', 'true');
        
        system.debug('==========>prodConfig'+prodConfig);
        APTS_BundleGroupCtrl bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
       
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        bundleController.checknondiscoutproducts();
        APTS_BundleGroupCtrl.createGroup('Print Group A', '{}');
        
        APTS_BundleGroupCtrl bundleController2 = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        ApexPages.currentPage().getParameters().put('ActionType', 'goToMultiLocation');
        bundleController2.saveAdjustmentData();
        set<String> optoinList1 = new set<String>();
        optoinList1.add('tetsing');
        List<Apttus_Config2__LineItem__c> liLists = new List<Apttus_Config2__LineItem__c>();
        bundleController2.calculateNets(listOfLineItemsgp, optoinList1, liLists );
        
        set<String> optoinList = new set<String>();
        optoinList.add('tetsing');
        //  bundleController.calculateNets(listOfLineItems1, optoinList, Lists1);
        
        Test.stopTest();
        }
    }
    
    @isTest static void testMethodOne() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,21';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Main_Bundle_Name__c='Eligible For Bundle';
        bundlePageSettings.Eligibility_codes_for_online_Canada__c='0649,0665,06AA,06AB,06AZ,06BA,06EE,06I9,06IA,06JA,06K1,06LB,06MC,06P7,13E3,13IQ,13LG,13PE,13SW,13SX,06Q6';
        bundlePageSettings.APTS_WestPack_Discount__c=50;
        bundlePageSettings.APTS_Max_Discount__c =20;
        bundlePageSettings.Incremental_Revenue_Required__c=50;
        insert bundlePageSettings;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        system.assertEquals(a.Name, 'Test Account');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c='SCS';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'West Proflex';
        prodObj.ProductCode= '41972767';
        prodObj.APTS_Media_High_Level_Code__c = '49';
        prodObj.APTS_Media_Lower_Level_Code__c = 'NX';
        prodObj.IsActive=true;
        insert prodObj;
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        
        insert ali;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Quote_Proposal__c = proposal.Id;
        proposalGroup.APTS_MLA__c = true;
        proposalGroup.APTS_Decentralized__c = true;
        insert proposalGroup;       
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.000,
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
    
        insert listOfLineItems;
        
        
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        List<Apttus_Config2__ProductAttributeValue__c> pavobjlist = new List<Apttus_Config2__ProductAttributeValue__c>();
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj = new Apttus_Config2__ProductAttributeValue__c(
                eBook_Purchase_Options__c = 'APP',
                APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );
            pavobjlist.add(pavObj);                 
        }
        insert pavobjlist;
       
        //SOC-9796 PMD fix
        Apttus_Config2__TempObject__c   temp = new Apttus_Config2__TempObject__c();
        temp.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        insert temp;
        
        //string jsonData = '[{"dataList": [], "name": "Print", "notShownDataList":[] }]';
        string jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CLEAR PROFLEX:41308780","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":false,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"PS","APTS_Media_High_Level_Code__c":"06","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"WEST PROFLEX:40757482","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":false,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"06","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":false,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":false},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":false,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":false,"APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":false}]}]';
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',temp.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        system.debug('==========>prodConfig'+prodConfig);
        APTS_BundleGroupCtrl bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));

        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        
        APTS_BundleGroupCtrl.createGroup('Print Group A', '{}');
        
        APTS_BundleGroupCtrl bundleController2 = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        ApexPages.currentPage().getParameters().put('ActionType', 'goToMultiLocation');
        bundleController2.saveAdjustmentData();
        set<String> optoinList1 = new set<String>();
        optoinList1.add('tetsing');
      
        jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"West Complete Library Sub:40666420","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"PS","APTS_Media_High_Level_Code__c":"07","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"West Complete Library Sub:40666420","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"07","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":false,"APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":true}]}]';
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',temp.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        system.debug('==========>prodConfig'+prodConfig);
        bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        
        jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_Product_Family__c":"CLEAR","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CLEAR PROFLEX:41308780","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"PS","APTS_Media_High_Level_Code__c":"07","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CLEAR PROFLEX:41308780","APTS_Proposal_Business_Unit__c":"SCS","APTS_Product_Family__c":"CLEAR","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"07","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":false,"APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":true}]}]';
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',temp.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        ApexPages.currentPage().getParameters().put('isMLA', 'true');
        ApexPages.currentPage().getParameters().put('decentralized', 'true');
        system.debug('==========>prodConfig'+prodConfig);
        bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        
        jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_Product_Family__c":"EDISCOVERY POINT","APTS_Service_Number__c":"42129930","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"eDiscovery Point Trans Hosting ProFlex:42129928","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"PS","APTS_Media_High_Level_Code__c":"07","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"0.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":0,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CLEAR PROFLEX:41308780","APTS_Proposal_Business_Unit__c":"SCS","APTS_Product_Family__c":"CLEAR","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"07","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":false,"APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":true}]}]';
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',temp.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        system.debug('==========>prodConfig'+prodConfig);
        bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        Test.stopTest();
    }
    
    @isTest static void testMethodFour() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList(label.CanadaPriceList);
        insert priceList;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
         List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,21';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Main_Bundle_Name__c='Eligible For Bundle';
        bundlePageSettings.Eligibility_codes_for_online_Canada__c='0649,0665,06AA,06AB,06AZ,06BA,06EE,06I9,06IA,06JA,06K1,06LB,06MC,06P7,13E3,13IQ,13LG,13PE,13SW,13SX,06Q6';
        bundlePageSettings.APTS_WestPack_Discount__c=50;
        bundlePageSettings.APTS_Max_Discount__c =20;
        bundlePageSettings.Incremental_Revenue_Required__c=50;
        insert bundlePageSettings;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        System.runAs(u1){
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        system.assertEquals(a.Name, 'Test Account');
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;
     
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> listOfLineItemsgp = New List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   
        
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO3;   
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Canada Proflex';
        prodObj.ProductCode= '41972767';
        prodObj.APTS_Media_High_Level_Code__c = '21';
        prodObj.APTS_Media_Lower_Level_Code__c = 'CQ';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c ='USL';
        prodObj.Service_Number__c='0';
        insert prodObj;  
        
       
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.APTS_Deal_Type__c   ='RB50';
        insert ali;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Quote_Proposal__c = proposal.Id;
        proposalGroup.APTS_MLA__c = true;
        proposalGroup.APTS_Decentralized__c = true;
        insert proposalGroup;       
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__ExtendedPrice__c=50, 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO.id,
            APTS_Group__c = proposalGroup.Id); 
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
             
        insert listOfLineItems;
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__ExtendedPrice__c=50,
            APTS_Product_Family__c='',
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        listOfLineItemsgp.add(linObj5);
        
        insert listOfLineItemsgp;
        listOfLineItemsgp[0].Apttus_Config2__ProductId__r=[Select id,LCRM_Sub_Bu__c   from Product2 where id=:prodObj.id];
        listOfLineItemsgp[0]=[Select id, APTS_Product_Group_Primary_Material__c,Apttus_Config2__NetPrice__c,Apttus_Config2__LineStatus__c,APTS_SAP_Deal_Number__c ,APTS_SAP_Deal_Type__c,Apttus_Config2__ExtendedPrice__c  from Apttus_Config2__LineItem__c where id=:listOfLineItemsgp[0].id];
        System.debug('Test Poonam'+listOfLineItemsgp[0].APTS_Product_Group_Primary_Material__c);
        System.debug('Test Poonam'+listOfLineItemsgp);
        
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        List<Apttus_Config2__ProductAttributeValue__c> pavobjlist = new List<Apttus_Config2__ProductAttributeValue__c>();
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj = new Apttus_Config2__ProductAttributeValue__c(
                eBook_Purchase_Options__c = 'APP',
                APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );
            pavobjlist.add(pavObj);                 
        }
        insert pavobjlist;
            
        APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Test', APTS_Quote_Proposal__c = proposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location_SSD__c = accountSSD.Id);
        insert al;
        
        //SOC-9796 PMD fix
        /* Apttus_Config2__TempObject__c   temp = new Apttus_Config2__TempObject__c();
        temp.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        insert temp;*/
        
        //string jsonData = '[{"dataList": [], "name": "Print", "notShownDataList":[] }]';
        string jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CANADA PROFLEX:41972767","APTS_Proposal_Business_Unit__c":"CANADA","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"41913614","APTS_Media_Lower_Level_Code__c":"AA","APTS_Media_High_Level_Code__c":"06","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"CANADA"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"CANADA PROFLEX:41972767","APTS_Proposal_Business_Unit__c":"CANADA","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"06","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"CANADA"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Eligible For Bundle","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"test","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true},{"showMessage":false,"optionList":[],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c"},"APTS_Deal_Not_Complete__c":false}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDnEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Bundle A","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_MLA__c":true,"APTS_SAP_MLA_Agreement_Number__c":"1234567","APTS_Decentralized__c":false,"APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDnEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":0,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":false,"allowKeepTerms":true}]}]';
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',prodConfig.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        ApexPages.currentPage().getParameters().put('isMLA', 'true');
        ApexPages.currentPage().getParameters().put('decentralized', 'true');
        
        system.debug('==========>prodConfig'+prodConfig);
        APTS_BundleGroupCtrl bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
       
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        
        APTS_BundleGroupCtrl.createGroup('Print Group A', '{}');
        
        APTS_BundleGroupCtrl bundleController2 = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        ApexPages.currentPage().getParameters().put('ActionType', 'goToMultiLocation');
        bundleController2.saveAdjustmentData();
        set<String> optoinList1 = new set<String>();
        optoinList1.add('tetsing');
        List<Apttus_Config2__LineItem__c> liLists = new List<Apttus_Config2__LineItem__c>();
        bundleController2.calculateNets(listOfLineItemsgp, optoinList1, liLists );
        
        set<String> optoinList = new set<String>();
        optoinList.add('tetsing');
        //  bundleController.calculateNets(listOfLineItems1, optoinList, Lists1);
        
        Test.stopTest();
        }
    }
    @isTest static void testMethodfive() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
         List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,21';
        bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
        bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
        bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
        bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
        bundlePageSettings.Main_Bundle_Name__c='Eligible For Bundle';
        bundlePageSettings.Eligibility_codes_for_online_Canada__c='0649,0665,06AA,06AB,06AZ,06BA,06EE,06I9,06IA,06JA,06K1,06LB,06MC,06P7,13E3,13IQ,13LG,13PE,13SW,13SX,06Q6';
        bundlePageSettings.APTS_WestPack_Discount__c=50;
        bundlePageSettings.APTS_Max_Discount__c =20;
        bundlePageSettings.Incremental_Revenue_Required__c=50;
        insert bundlePageSettings;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
         User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        System.runAs(u1){
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        system.assertEquals(a.Name, 'Test Account');
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;
     
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> listOfLineItemsgp = New List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   
        
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO3;   
        Product2 prodObj = new Product2();
        prodObj.Name = 'West Complete Proflex';
        prodObj.ProductCode= '40666420';
        prodObj.APTS_Media_High_Level_Code__c = '21';
        prodObj.APTS_Media_Lower_Level_Code__c = 'CQ';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c ='USL';
        prodObj.Service_Number__c='0';
        insert prodObj;  
        Apttus_Config2__PriceListItem__c pliSO4 = new Apttus_Config2__PriceListItem__c();
        pliSO4.Apttus_Config2__Active__c = true;
        pliSO4.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO4.APTS_Max_Fill_Up_Price__c = 5;
        pliSO4.Apttus_Config2__ProductId__c=prodObj.id;
        pliSO4.Apttus_Config2__ChargeType__c='Subscription Fee';
        pliSO4.Apttus_Config2__Frequency__c='Monthly';
        pliSO4.Apttus_Config2__PriceType__c ='Recurring';
        pliSO4.Apttus_Config2__PriceMethod__c='Flat Price';
        insert pliSO4; 
        
        
        
       
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.APTS_Deal_Type__c   ='RB50';
        insert ali;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
        proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        proposalGroup.APTS_Quote_Proposal__c = proposal.Id;
        proposalGroup.APTS_MLA__c = true;
        proposalGroup.APTS_Decentralized__c = true;
        insert proposalGroup;       
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__ExtendedPrice__c=50, 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO.id,
            APTS_Group__c = proposalGroup.Id); 
        listOfLineItems.add(linObj);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup2;
        
             
        insert listOfLineItems;
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ChargeType__c='Subscription Fee',
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__ExtendedPrice__c=50,
            APTS_Product_Family__c='',
            currencyIsoCOde='USD',
            APTS_Keep_Terms__c=true,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__AllowManualAdjustment__c=false,
            Apttus_Config2__AdjustmentAmount__c=10.00,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        listOfLineItemsgp.add(linObj5);
        
        insert listOfLineItemsgp;
        listOfLineItemsgp[0].Apttus_Config2__ProductId__r=[Select id,LCRM_Sub_Bu__c   from Product2 where id=:prodObj.id];
        listOfLineItemsgp[0]=[Select id, APTS_Product_Group_Primary_Material__c,Apttus_Config2__NetPrice__c,Apttus_Config2__LineStatus__c,APTS_SAP_Deal_Number__c ,APTS_SAP_Deal_Type__c,Apttus_Config2__ExtendedPrice__c  from Apttus_Config2__LineItem__c where id=:listOfLineItemsgp[0].id];
        //System.debug('Test -->');
        System.debug('Test Poonam'+listOfLineItemsgp[0].APTS_Product_Group_Primary_Material__c);
        System.debug('Test Poonam'+listOfLineItemsgp);
        
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        List<Apttus_Config2__ProductAttributeValue__c> pavobjlist = new List<Apttus_Config2__ProductAttributeValue__c>();
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj = new Apttus_Config2__ProductAttributeValue__c(
                eBook_Purchase_Options__c = 'APP',
                APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );
            pavobjlist.add(pavObj);                 
        }
        insert pavobjlist;
        
        
        //SOC-9796 PMD fix
        /* Apttus_Config2__TempObject__c   temp = new Apttus_Config2__TempObject__c();
        temp.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        insert temp;*/
        
        
                string jsonData ='[{"notShownDataList":[],"name":"Online/Software","dataList":[{"showMessage":false,"optionList":["CLEAR PROFLEX","WEST PROFLEX"],"lnItems":[{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAB","Name":"LI-0001906246","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"West Complete PROFLEX","APTS_GROUP__c":"Bundle A","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":1,"Apttus_Config2__ItemSequence__c":1,"Apttus_Config2__IsPrimaryLine__c":true,"Apttus_Config2__PrimaryLineNumber__c":1,"Apttus_Config2__LineSequence__c":1,"Apttus_Config2__IsQuantityModifiable__c":false,"Apttus_Config2__IsUsageTierModifiable__c":false,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__BasePriceMethod__c":"Flat Price","Currencyisocode":"USD","Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DpAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"West Complete Library Sub:40666420","APTS_Product_Code__c":"40666420","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__BasePriceMethod__c":"Flat Price","CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DpAAI"},"Service_Number__c":"40666420","ProductCode":"40666420","APTS_Media_Lower_Level_Code__c":"AA","APTS_Media_High_Level_Code__c":"06","Id":"01t13000005p8DpAAI","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"USL"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null}             ,{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009diyAAA"},"Id":"a680m0000009diyAAA","Name":"LI-0001906245","APTS_DefaultNetPrice__c":95,"Apttus_Config2__BaseExtendedPrice__c":95,"APTS_Product_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","APTS_Product_Or_Option_Name__c":"CLEAR Corporate Arrest Gateway Pro Addon","Apttus_Config2__LineNumber__c":2,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":95,"Apttus_Config2__ItemSequence__c":2,"Apttus_Config2__IsPrimaryLine__c":false,"Apttus_Config2__PrimaryLineNumber__c":2,"Apttus_Config2__LineSequence__c":2,"Apttus_Config2__IsQuantityModifiable__c":false,"Apttus_Config2__IsUsageTierModifiable__c":false,"Currencyisocode":"USD","Apttus_Config2__ListPrice__c":95,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t13000005p8DqAAI","Apttus_Config2__Uom__c":"Seats","Apttus_Config2__BasePrice__c":95,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":95,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"West Complete Library Sub:40666420","APTS_Product_Code__c":"40666425","Apttus_Config2__LineType__c":"Product/Service","Apttus_Config2__BasePriceMethod__c":"Flat Price","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":false,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t13000005p8DqAAI"},"Service_Number__c":"41913614","ProductCode":"41913614","APTS_Media_Lower_Level_Code__c":"AA","APTS_Media_High_Level_Code__c":"06","Id":"01t13000005p8DqAAI","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"USL"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null},{"attributes":{"type":"Apttus_Config2__LineItem__c","url":"/services/data/v44.0/sobjects/Apttus_Config2__LineItem__c/a680m0000009dj8AAA"},"Id":"a680m0000009dj8AAA","Name":"LI-0001906248","APTS_DefaultNetPrice__c":557.76,"Apttus_Config2__AllowManualAdjustment__c":false,"Apttus_Config2__AdjustmentAmount__c":"8.000","Apttus_Config2__BaseExtendedPrice__c":581,"APTS_Product_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__AdjustmentAmount__c":4,"Apttus_Config2__AdjustmentType__c":"% Discount","APTS_Product_Or_Option_Name__c":"All Westlaw Journal Library with Court Documents (Westlaw PRO™)","Apttus_Config2__LineNumber__c":3,"Apttus_Config2__ChargeType__c":"Subscription Fee","Apttus_Config2__ExtendedCost__c":0,"Apttus_Config2__Quantity__c":1,"Apttus_Config2__ExtendedPrice__c":581,"Apttus_Config2__ItemSequence__c":3,"Apttus_Config2__IsPrimaryLine__c":false,"Apttus_Config2__PrimaryLineNumber__c":3,"Apttus_Config2__LineSequence__c":3,"Apttus_Config2__IsQuantityModifiable__c":false,"Apttus_Config2__IsUsageTierModifiable__c":false,"Currencyisocode":"USD","Apttus_Config2__ListPrice__c":581,"Apttus_Config2__LineStatus__c":"New","Apttus_Config2__PricingStatus__c":"Complete","Apttus_Config2__ProductId__c":"01t30000003ihzPAAQ","Apttus_Config2__Uom__c":"Attorneys","Apttus_Config2__BasePrice__c":581,"Apttus_Config2__SellingTerm__c":1,"Apttus_Config2__NetPrice__c":557.76,"APTS_Contract_Term__c":"3 Years","APTS_Years_2_Plus_Adjustment__c":"5","APTS_YoY_Adjustment_Type__c":"Increase","APTS_Year_2_Adj_Default__c":0,"APTS_Years_3_5_Adj_Default__c":0,"APTS_Years_6_10_Adj_Default__c":0,"APTS_Product_Group_Primary_Material__c":"West Complete Library Sub:40666420","APTS_Product_Code__c":"40666427","APTS_Proposal_Business_Unit__c":"SCS","APTS_Contract_Term_Default__c":"3 Years","APTS_Keep_Terms__c":true,"APTS_Max_Discount__c":20,"APTS_WestPack_Discount__c":50,"APTS_Years_2_Plus_Default__c":5,"APTS_Yr_1_Renewal_Default__c":7,"Apttus_Config2__AllowManualAdjustment__c":true,"CurrencyIsoCode":"USD","Apttus_Config2__ProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v44.0/sobjects/Product2/01t30000003ihzPAAQ"},"Service_Number__c":"40966146","ProductCode":"40966146","APTS_Media_Lower_Level_Code__c":"49","APTS_Media_High_Level_Code__c":"06","Id":"01t30000003ihzPAAQ","CurrencyIsoCode":"USD","LCRM_Sub_Bu__c":"USL"},"APTS_Group_Primary_Material_Name__c":null,"APTS_Deal_Not_Complete__c":false,"Apttus_Config2__StartDate__c":null,"Apttus_Config2__EndDate__c":null}],"keepTerms":true,"grpLn":{"attributes":{"type":"APTS_Group__c","url":"/services/data/v44.0/sobjects/APTS_Group__c/a8K0m0000008UDmEAM"},"APTS_Group_Name__c":"Online/Software Bundle A","APTS_Group_Name_Original__c":"Online/Software Eligible For Bundle","APTS_ProductConfiguration__c":"a6p0m000000ypjmAAA","APTS_Discount_Amount__c":null,"APTS_Quantity__c":null,"APTS_Quote_Proposal__c":"a4N0m000000PZX0EAO","APTS_Primary_Material__c":"West Complete Library Sub","APTS_Adjustment_Type__c":"Select Adjustment","Id":"a8K0m0000008UDmEAM","APTS_Existing_Agreement_Product_Code__c":null,"APTS_Max_Blended_Discount__c":0,"APTS_NetAmount__c":652.76,"APTS_WCMP_Current_Monthly_Spend__c":0,"APTS_WCMP_Modified_Monthly_Spend__c":0,"APTS_Existing_ship_and_charge_Total__c":0,"APTS_Terminated_Lines_Total__c":0,"APTS_Incremental_Revenue__c":0,"APTS_Incremental_Revenue_Required__c":0,"APTS_Incremental_Revenue_Above_Threshold__c":0,"APTS_Existing_Agreement_Total__c":0,"APTS_Online_Incremental__c":0,"Group_Approval_Required__c":false},"blendDiscountRed":true,"allowKeepTerms":true}]}]';
        
        


        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('conId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('cId', prodConfig.id);
        ApexPages.currentPage().getParameters().put('businessObjectId', proposal.Id);
        ApexPages.currentPage().getParameters().put('configRequestId',prodConfig.id );
        ApexPages.currentPage().getParameters().put('ActionType', 'backToCart');
        ApexPages.currentPage().getParameters().put('groupId', 'TestId');
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        ApexPages.currentPage().getParameters().put('isMLA', 'true');
        ApexPages.currentPage().getParameters().put('decentralized', 'true');
        
        system.debug('==========>prodConfig'+prodConfig);
        APTS_BundleGroupCtrl bundleController = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
       
        bundleController.doinit();
        bundleController.getConfigLineItems();
        bundleController.saveAdjustmentData();
        
        APTS_BundleGroupCtrl.createGroup('Print Group A', '{}');
        
        APTS_BundleGroupCtrl bundleController2 = new APTS_BundleGroupCtrl(new ApexPages.StandardController(prodConfig));
        ApexPages.currentPage().getParameters().put('ActionType', 'goToMultiLocation');
        bundleController2.saveAdjustmentData();
        set<String> optoinList1 = new set<String>();
        optoinList1.add('tetsing');
        List<Apttus_Config2__LineItem__c> liLists = new List<Apttus_Config2__LineItem__c>();
        bundleController2.calculateNets(listOfLineItemsgp, optoinList1, liLists );
        
        set<String> optoinList = new set<String>();
        optoinList.add('tetsing');
        //  bundleController.calculateNets(listOfLineItems1, optoinList, Lists1);
        
        Test.stopTest();
        }
    }
  
}