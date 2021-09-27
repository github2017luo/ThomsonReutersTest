@isTest
private class APTS_PricingCallbackMethodsTest {
        //Added By Poonam Garg to add custom setting data
@testSetup private static void setUp(){
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
        Static_Values__c stvalues=new Static_Values__c (name='skiptoNullifyCreditCardDetails',value__c='Guest');
        insert stvalues;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC; 
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj.name='Custom Field Names';
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c,APTS_Cat_L2__c,APTS_Cat_L3__c';
        obj1.Apttus_Config2__CustomFieldNames4__c = 'APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c';
        obj1.name='Custom Field Names1';
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c';      
        obj2.name='Custom Field Names2';
        insert obj2; 
        customFieldsList.add(obj1);
        insert customFieldsList;
         List<IXOSCodeMap__c> ixocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA78',Company_Code__c='1078',Dist_Chan_Code__c='T',Division_Code__c='T',Sales_Org_Code__c='TA78')};
        insert ixocodeList;
        List<WebServiceSettings__c> webserviceSettingsList=new List<WebServiceSettings__c>();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings.Name = 'Payment AutoCharge'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(oWebServiceSettings);
        WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        webserviceSettingsList.add(webserviceList);
        insert webserviceSettingsList;
        
     }
    private static List<Decimal> createLI(ID cartID, Integer sequence, ID priceListItemId, ID priceListId, ID prodID) {
        List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
        Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
        selProdDO.ProductID = prodID;
        selProdDO.Quantity = 10;
        selProdDO.SellingTerm = 1;
        selProdDO.StartDate = null;
        selProdDO.EndDate = null;
        selProdDO.Comments = 'Custom'; 
        selectedProdDOList.add(selProdDO);
        
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        bundleReqDO.cartID = cartID;
        bundleReqDO.SelectedProducts = selectedProdDOList;
        Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
        system.debug('bundleRespDO...'+bundleRespDO);
        return bundleRespDO.LineNumbers;        
    }
      private static void priceCartLines(ID cartID) 
    {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
    }
    
    
    @isTest static void testdefaultContractTermDiscounts() {
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();        
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(null, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;        
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__PriceListItem__c> priceListItems =new List<Apttus_Config2__PriceListItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;        
        priceListItems.add(pliSO);
        
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;        
        priceListItems.add(pliSO2);   
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.IsActive        = true;
        prodObj.CurrencyIsoCode = 'USD';
        //prodObj.SCS_Print_Activation_Date__c = date.today();
        prodObj.Apttus_Config2__ConfigurationType__c = 'Standalone';
        prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        insert prodObj; 
        
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 1.0';
        prodObj1.IsActive        = true;
        prodObj1.CurrencyIsoCode = 'USD';
        prodObj1.Apttus_Config2__ConfigurationType__c = 'Bundle';
        prodObj1.APTS_Item_Category_Group__c='ZPMT';        
        prodObj.SCS_Print_Activation_Date__c = date.today();
        insert prodObj1; 
        
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        pliSO3.Apttus_Config2__Sequence__c = 3;
        pliSO3.Apttus_Config2__ProductId__c = prodObj.Id;        
        priceListItems.add(pliSO3);  
        
        
        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.IsActive        = true;
        prod2Obj.CurrencyIsoCode = 'USD';
        prod2Obj.SCS_Print_Activation_Date__c = date.today();
        prod2Obj.Apttus_Config2__ConfigurationType__c = 'Option';
        insert prod2Obj;    
        
        Apttus_Config2__PriceListItem__c pliSO4 = new Apttus_Config2__PriceListItem__c();
        pliSO4.Apttus_Config2__Active__c = true;
        pliSO4.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO4.APTS_Max_Fill_Up_Price__c = 5;
        pliSO4.Apttus_Config2__Sequence__c = 3;
        pliSO4.Apttus_Config2__ProductId__c = prod2Obj.Id;       
        priceListItems.add(pliSO4);
        
        Apttus_Config2__PriceListItem__c pliSO5 = new Apttus_Config2__PriceListItem__c();
        pliSO5.Apttus_Config2__Active__c = true;
        pliSO5.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO5.APTS_Max_Fill_Up_Price__c = 5;
        pliSO5.Apttus_Config2__Sequence__c = 3;
        pliSO5.Apttus_Config2__ProductId__c = prodObj1.Id;       
        priceListItems.add(pliSO5);
        
        insert  priceListItems;
        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert summaryGroup1;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__ExtendedPrice__c = 15.0,
            Apttus_Config2__OptionPrice__c = 15.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c =null,
            Apttus_Config2__OptionId__c=null,
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
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__ExtendedPrice__c = 3.0,
            APTS_Price_Cap_Adjustment_Percentage__c = 1,
            Apttus_Config2__OptionPrice__c = 15.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'One Time', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__OptionId__c=null,
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        listOfLineItems.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj1.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__ExtendedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 15.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Price_Cap_Adjustment_Percentage__c = 1,
            APTS_Contract_Term__c ='Existing',     
            Apttus_Config2__OptionId__c=null,       
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        listOfLineItems.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__ExtendedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 15.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Price_Cap_Adjustment_Percentage__c = 1,
            APTS_Contract_Term__c ='1 Year',
            Apttus_Config2__OptionId__c=null,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        listOfLineItems.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__PrimaryLineNumber__c = 1,
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__ExtendedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 15.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Price_Cap_Adjustment_Percentage__c = 1,
            APTS_Contract_Term__c ='1 Year',
            Apttus_Config2__OptionId__c=null,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        
        listOfLineItems.add(linObj5);
        
        List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj51 = new Apttus_Config2__LineItem__c();
        linObj51.Apttus_Config2__Quantity__c=1;
        linObj51.Apttus_Config2__ProductId__c=prodObj.id;
        linObj51.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        linObj51.Apttus_Config2__LineType__c = 'Product/Service';        
        linObj51.Apttus_Config2__LineNumber__c = 1;
        linObj51.Apttus_Config2__PrimaryLineNumber__c = 1;
        linObj51.Apttus_Config2__ItemSequence__c = 3;
        linObj51.Apttus_Config2__NetPrice__c=10.0;            
        linObj51.Apttus_Config2__OptionPrice__c = 15.0;
        linObj51.Apttus_Config2__Frequency__c = 'Monthly';
        linObj51.Apttus_Config2__PriceType__c = 'Recurring';
        linObj51.Apttus_Config2__PriceAdjustment__c=0;
        linObj51.Apttus_Config2__LineStatus__c='New';
        linObj51.APTS_Price_Cap_Adjustment_Percentage__c = 1;
        linObj51.APTS_Contract_Term__c ='Existing';
        linObj51.APTS_Product_Family__c = 'PPC MANAGEMENT';            
        //linObj6.APTS_PAGEO_Price__c=attributecombination.APTS_Price__c;
        linObj51.Apttus_Config2__PriceListItemId__c = pliSO3.id;  
        linObj51.Apttus_Config2__OptionId__c=null;     
        listOfLineItems1.add(linObj51);
        
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c();
        linObj6.Apttus_Config2__Quantity__c=1;
        //linObj6.Apttus_Config2__ProductId__c=prodObj.id;
        linObj6.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        linObj6.Apttus_Config2__LineType__c = 'Option';
        linObj6.Apttus_Config2__LineNumber__c = 1;
        linObj6.Apttus_Config2__PrimaryLineNumber__c = 1;
        linObj6.Apttus_Config2__ItemSequence__c = 3;
        linObj6.Apttus_Config2__NetPrice__c=10.0;            
        linObj6.Apttus_Config2__OptionPrice__c = 15.0;
        linObj6.Apttus_Config2__Frequency__c = 'Monthly';
        linObj6.Apttus_Config2__PriceType__c = 'Recurring';
        linObj6.Apttus_Config2__PriceAdjustment__c=0;
        linObj6.APTS_Price_Cap_Adjustment_Percentage__c = 1;
        linObj6.APTS_Contract_Term__c =null;
        linObj6.APTS_Product_Family__c = 'PPC MANAGEMENT';   
        linObj6.Apttus_Config2__OptionId__c=null;         
        //linObj6.APTS_PAGEO_Price__c=attributecombination.APTS_Price__c;
        linObj6.Apttus_Config2__PriceListItemId__c = pliSO3.id;         
        listOfLineItems1.add(linObj6);
        
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c();
        linObj7.Apttus_Config2__Quantity__c=1;
        //linObj7.Apttus_Config2__ProductId__c=prodObj1.id;
        linObj7.Apttus_Config2__ConfigurationId__c = prodConfig.id;
        linObj7.Apttus_Config2__LineType__c = 'Option';        
        linObj7.Apttus_Config2__LineNumber__c = 1;
        linObj7.Apttus_Config2__PrimaryLineNumber__c = 1;
        linObj7.Apttus_Config2__ItemSequence__c = 3;
        linObj7.Apttus_Config2__NetPrice__c=10.0;            
        linObj7.Apttus_Config2__OptionPrice__c = 15.0;
        linObj7.Apttus_Config2__Frequency__c = 'Monthly';
        linObj7.Apttus_Config2__PriceType__c = 'Recurring';
        linObj7.Apttus_Config2__PriceAdjustment__c=0;
        linObj7.APTS_Price_Cap_Adjustment_Percentage__c = 1;
        linObj7.APTS_Contract_Term__c ='1 Year';
        linObj7.APTS_Product_Family__c = 'PPC MANAGEMENT';    
        linObj7.APTS_Years_2_Plus_Adjustment__c = null;                
        linObj7.Apttus_Config2__PriceListItemId__c = pliSO5.id;   
        linObj7.Apttus_Config2__OptionId__c=null;     
        listOfLineItems.add(linObj7);        
        
        insert listOfLineItems1;
        
        Apttus_Config2__PriceDimension__c pricedimension = new Apttus_Config2__PriceDimension__c();
        pricedimension.Name='Priced Number of Attorneys';
        pricedimension.Apttus_Config2__Datasource__c='test';
        Insert pricedimension;
        
        Apttus_Config2__PriceMatrix__c pricematrix= new Apttus_Config2__PriceMatrix__c();            
        pricematrix.Apttus_Config2__Dimension2Id__c=pricedimension.id;
        pricematrix.Apttus_Config2__PriceListItemId__c=pliSO3.id;
        pricematrix.Apttus_Config2__Sequence__c=111;
        insert pricematrix;
        
        Apttus_Config2__PriceMatrixEntry__c pricematricentry= new Apttus_Config2__PriceMatrixEntry__c();            
        pricematricentry.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
        pricematricentry.Apttus_Config2__Sequence__c=111;
        pricematricentry.Apttus_Config2__Dimension1Value__c='Renewed';
        pricematricentry.Apttus_Config2__Dimension2Value__c='11.00';
        Insert pricematricentry;
                       
        insert listOfLineItems;        
               
        List<Apttus_Config2__ProductAttributeValue__c> prodattr =new List<Apttus_Config2__ProductAttributeValue__c>();
        
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems ) {
            pavObj = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );            
            prodattr.add(pavObj);
        }
        
        Apttus_Config2__ProductAttributeValue__c pavObj1; 
        for (Apttus_Config2__LineItem__c lineItem : listOfLineItems1 ) {
            pavObj1 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up & Enter Sub',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
            );            
            prodattr.add(pavObj1);
        }
        insert prodattr;
                
        
        //====================================================================
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__Active__c = true;
        className.Apttus_Config2__GuidePage__c = 'APTPSGuidedSelling';
        className.Apttus_Config2__HierarchyLabel__c = 'Thomson Products';
        className.Apttus_Config2__Type__c = 'Offering';
        className.Name = 'Thomson Products';
        insert className;
        
        Apttus_Config2__ClassificationHierarchy__c classHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
        classHierarchy.Apttus_Config2__GuidePage__c = 'APTPSGuidedSelling';
        classHierarchy.Apttus_Config2__HierarchyId__c = className.Id;
        classHierarchy.Apttus_Config2__Label__c = 'Thomson Products';
        classHierarchy.Apttus_Config2__Left__c = 1.0;
        classHierarchy.Apttus_Config2__Level__c = 0.0;
        classHierarchy.Apttus_Config2__MaxOptions__c = 1.0;
        classHierarchy.Apttus_Config2__MinOptions__c = 1.0;
        classHierarchy.Apttus_Config2__Left__c = 2.0;
        insert classHierarchy;
        
        Apttus_Config2__ProductClassification__c prodClassification = new Apttus_Config2__ProductClassification__c();       
        prodClassification.Apttus_Config2__ProductId__c = prod2Obj.Id;
        prodClassification.Apttus_Config2__MaxQuantity__c =2.0;
        prodClassification.Apttus_Config2__MinQuantity__c = 1.0;
        prodClassification.Apttus_Config2__ClassificationId__c = classHierarchy.Id;
        
        insert prodClassification;
        
        Apttus_Config2__ProductOptionGroup__c optGroupSO = new Apttus_Config2__ProductOptionGroup__c();
        optGroupSO.Apttus_Config2__RootOptionGroupId__c = classHierarchy.Id;
        optGroupSO.Apttus_Config2__OptionGroupId__c = classHierarchy.Id;
        optGroupSO.Apttus_Config2__ProductId__c = prodObj.Id;
        optGroupSO.Apttus_Config2__Sequence__c = 1;
        optGroupSO.Apttus_Config2__MaxOptions__c = 1.0;
        optGroupSO.Apttus_Config2__MinOptions__c = 0.0;
        optGroupSO.Apttus_Config2__IsLeaf__c = true;
        optGroupSO.Apttus_Config2__Left__c = 1.0;
        optGroupSO.Apttus_Config2__Right__c = 2.0;
        optGroupSO.Apttus_Config2__ModifiableType__c = 'Variable';
        optGroupSO.Apttus_Config2__RootSequence__c = 7.0;
        insert optGroupSO;
        
        Apttus_Config2__ProductOptionComponent__c optionSO = new Apttus_Config2__ProductOptionComponent__c();
        optionSO.Apttus_Config2__ParentProductId__c = prodObj.Id;
        optionSO.Apttus_Config2__ProductOptionGroupId__c = optGroupSO.Id;
        optionSO.Apttus_Config2__ComponentProductId__c = prod2Obj.Id;
        optionSO.Apttus_Config2__Sequence__c = 1;
        optionSO.Apttus_Config2__RelationshipType__c = 'Option';
        optionSO.Apttus_Config2__MinQuantity__c = 0.0;
        optionSO.Apttus_Config2__MaxQuantity__c = 1.0;
        optionSO.Apttus_Config2__DefaultQuantity__c = 1.0;        
        insert optionSO;
        //====================================================================              
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,APTS_Corporate_Select__c,APTS_Corporate_Select_Option__c,Apttus_Config2__ConfigurationId__c,
                                                           Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ChargeType__c, Apttus_Config2__AttributeValueId__c,APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,
                                                           Apttus_Config2__PrimaryLineNumber__c, APTS_Proposal_Business_Unit__c, Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,Apttus_Config2__AttributeValueId__r.APTS_FillUp_Start_Date__c,
                                                           Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c, Apttus_Config2__PriceType__c,Apttus_Config2__ProductId__r.Media_High_Level__c, 
                                                           APTS_Years_2_Plus_Default__c,APTS_Product_Name__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Keep_Terms__c, Apttus_Config2__ExtendedPrice__c, Apttus_Config2__OptionPrice__c, APTS_Price_Cap_Adjustment_Percentage__c         
                                                           FROM Apttus_Config2__LineItem__c 
                                                           WHERE Id = :linObj.Id OR Id = :linObj2.Id OR Id = :linObj3.Id OR Id = :linObj4.Id OR Id = :linObj5.Id];      
        
                        
        List<Apttus_Config2__LineItem__c> bundleItems1 = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> bundleItems = new List<Apttus_Config2__LineItem__c>();
        Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = APTS_PricingCallbackMethods.buildLineNumberToOptionsMap(lineItemsList, bundleItems);
        set<Id> lineitemId = new set<Id>();        
        for(Apttus_Config2__LineItem__c lineitem : listOfLineItems1){
            lineitemId.add(lineitem.id);
        }
        //System.assert(bundleItems!= null && bundleItems.size()>0);     
        
        //SOC-7338 Added by Chirag 4/19/18
        Test.startTest();         

    //    APTS_PricingCallBackMethods.setBasePrice(bundleItems);
        APTS_PricingCallBackMethods.defaultContractTermDiscounts(bundleItems, lineNumberToOptionsMap,prodConfig);
        APTS_PricingCallBackMethods.discountToMax(bundleItems, lineNumberToOptionsMap);
        APTS_PricingCallBackMethods.discountToMax(bundleItems1, lineNumberToOptionsMap);
        APTS_PricingCallBackMethods.setPricedAttrorneysForCanada(lineItemsList, 100); // added by Chintan - to cover Canada method.
        
        if(lineItemsList.size() > 0){
            APTS_PricingCallBackMethods.addOptionsToLineItemSO(lineItemsList.get(0), prodConfig.Id);
        }
        APTS_PricingCallBackMethods.totallingGroupForDynamicBundle(lineItemsList);        
        new APTS_PricingCallBackMethods();
        System.assertEquals(5,lineItemsList.size());
        Test.stopTest();
    }

 @isTest static void testfindLaw() {
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        User findLawUser=APTS_TestDataFactory.createUser('testuser23FL@acme.com','testuser');
        findLawUser.Alias='testuser';
        findLawUser.Email='testuser23FL@tcs.com';
        findLawUser.Sub_Bu__c='FindLaw';
        findLawUser.Default_Catalog__c ='FindLaw';
        findLawUser.Sales_Org__c = 'LRA';
        insert findLawUser;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        //Id opptyRecordType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        
            Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
            accountSSD.RecordtypeId=ssdRecorType;
            accountSSD.Account_Inactive__c=false;
            insert accountSSD;

            Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
            oppty.RecordtypeId=opptyRecorType;
            oppty.Source_System_Detail__c=accountSSD.id;
            oppty.isdigitalSpearhead__c = False;
            //oppty.APTS_Proposal_Business_Unit__c = 'FindLaw'; 
            System.runAs(findLawUser) {
              insert oppty;
            }

            Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(null, accountSSD.Id);
            proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';  
            proposal.Apttus_Proposal__Opportunity__c = oppty.ID;     
              System.runAs(findLawUser) {
                insert proposal;
            }
            
            Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
            prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
            prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
            prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
            prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;            
            prodConfig.Apttus_Config2__AccountId__c = a.Id;
            prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
            prodConfig.Apttus_Config2__Status__c = 'New';
            insert prodConfig;        
            
            List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
            List<Apttus_Config2__PriceListItem__c> priceListItems =new List<Apttus_Config2__PriceListItem__c>();
            Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
            pliSO.Apttus_Config2__Active__c = true;
            pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
            pliSO.APTS_Max_Fill_Up_Price__c = 5;        
            priceListItems.add(pliSO);
            
            Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
            pliSO2.Apttus_Config2__Active__c = true;
            pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
            pliSO2.APTS_Max_Fill_Up_Price__c = 5;        
            priceListItems.add(pliSO2);   
            APTS_TestDataFactory.createFLTrephCodes();
            Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
            List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
            for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
                flcodeMap.put(pb.name,pb.value__c.split(','));
            }
            List<Product2> listofProducts = new List<Product2>();
            Product2 prodObj = new Product2();
            prodObj.Name = 'Network Services 1.0';
            prodObj.IsActive        = true;
            prodObj.CurrencyIsoCode = 'USD';
            prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
            //prodObj.SCS_Print_Activation_Date__c = date.today();
            prodObj.Apttus_Config2__ConfigurationType__c = 'Standalone';
            //insert prodObj; 
            listofProducts.add(prodObj);
            
            Product2 prodObj1 = new Product2();
            prodObj1.Name = 'Network Services 1.0';
            prodObj1.IsActive        = true;
            prodObj1.CurrencyIsoCode = 'USD';
            prodObj1.Apttus_Config2__ConfigurationType__c = 'Bundle';
            prodObj1.APTS_Item_Category_Group__c='ZPMT';        
            //prodObj.SCS_Print_Activation_Date__c = date.today();
            //insert prodObj1; 
            listofProducts.add(prodObj1);
            
            Product2 prod2Obj = new Product2();
            prod2Obj.Name = 'Network Services 2.0';
            prod2Obj.IsActive        = true;
            prod2Obj.CurrencyIsoCode = 'USD';
            //prod2Obj.SCS_Print_Activation_Date__c = date.today();
            prod2Obj.Apttus_Config2__ConfigurationType__c = 'Option';
            //insert prod2Obj; 
            listofProducts.add(prod2Obj);
            insert listofProducts;
        
            Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
            pliSO3.Apttus_Config2__Active__c = true;
            pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
            pliSO3.APTS_Max_Fill_Up_Price__c = 5;
            pliSO3.Apttus_Config2__Sequence__c = 3;
            pliSO3.Apttus_Config2__ProductId__c = prodObj.Id;
            priceListItems.add(pliSO3);  
            
            
            
            Apttus_Config2__PriceListItem__c pliSO4 = new Apttus_Config2__PriceListItem__c();
            pliSO4.Apttus_Config2__Active__c = true;
            pliSO4.Apttus_Config2__PriceListId__c = priceList.Id;
            pliSO4.APTS_Max_Fill_Up_Price__c = 5;
            pliSO4.Apttus_Config2__Sequence__c = 3;
            pliSO4.Apttus_Config2__ProductId__c = prod2Obj.Id;       
            priceListItems.add(pliSO4);
            
            Apttus_Config2__PriceListItem__c pliSO5 = new Apttus_Config2__PriceListItem__c();
            pliSO5.Apttus_Config2__Active__c = true;
            pliSO5.Apttus_Config2__PriceListId__c = priceList.Id;
            pliSO5.APTS_Max_Fill_Up_Price__c = 5;
            pliSO5.Apttus_Config2__Sequence__c = 3;
            pliSO5.Apttus_Config2__ProductId__c = prodObj1.Id;       
            priceListItems.add(pliSO5);
            
            insert  priceListItems;
            
            List<Apttus_Config2__SummaryGroup__c> listofSummaryGroups = new List<Apttus_Config2__SummaryGroup__c>();
            Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
            //insert summaryGroup1;
            listofSummaryGroups.add(summaryGroup1);
            
            Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
            //insert summaryGroup2;
            listofSummaryGroups.add(summaryGroup2);
            insert listofSummaryGroups;
            
            Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prodObj.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Product/Service',
                Apttus_Config2__LineNumber__c = 1, 
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
                Apttus_Config2__NetPrice__c=10.0,
                Apttus_Config2__BasePrice__c=10.0,
                Apttus_Config2__BaseExtendedPrice__c = 10.0,
                Apttus_Config2__AdjustedPrice__c = 10.0,
                Apttus_Config2__ExtendedPrice__c = 15.0,
                Apttus_Config2__OptionPrice__c = 15.0,
                Apttus_Config2__Frequency__c = 'Monthly',
                Apttus_Config2__OptionId__c=null,
                Apttus_Config2__PriceType__c = 'Recurring', 
                Apttus_Config2__PriceAdjustment__c=0,
                APTS_Contract_Term__c =null,
                APTS_Years_2_Plus_Adjustment__c = '4',
                Apttus_Config2__ChargeType__c='Subscription Fee',
                Apttus_Config2__PriceListItemId__c = pliSO.id); 
            listOfLineItems.add(linObj);
            
            
            Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prodObj.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Product/Service',
                Apttus_Config2__LineNumber__c = 2, 
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
                Apttus_Config2__NetPrice__c=10.0,
                Apttus_Config2__BasePrice__c=10.0,
                Apttus_Config2__BaseExtendedPrice__c = 10.0,
                Apttus_Config2__AdjustedPrice__c = 10.0,
                Apttus_Config2__ExtendedPrice__c = 3.0,
                APTS_Price_Cap_Adjustment_Percentage__c = 1,
                Apttus_Config2__OptionId__c=null,
                Apttus_Config2__OptionPrice__c = 15.0,
                Apttus_Config2__Frequency__c = 'Monthly',
                Apttus_Config2__PriceType__c = 'One Time', 
                Apttus_Config2__PriceAdjustment__c=0,
                APTS_Contract_Term__c ='3 Years',
                APTS_Years_2_Plus_Adjustment__c = '4',
                APTS_Keep_Terms__c =false,
                Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            listOfLineItems.add(linObj2);
            
            Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prodObj1.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Option',
                Apttus_Config2__LineNumber__c = 2, 
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__NetPrice__c=10.0,
                Apttus_Config2__BasePrice__c=10.0,
                Apttus_Config2__BaseExtendedPrice__c = 10.0,
                Apttus_Config2__AdjustedPrice__c = 10.0,
                Apttus_Config2__ExtendedPrice__c = 10.0,
                Apttus_Config2__OptionId__c=null,
                Apttus_Config2__OptionPrice__c = 15.0,
                Apttus_Config2__Frequency__c = 'Monthly',
                Apttus_Config2__PriceType__c = 'Recurring', 
                Apttus_Config2__PriceAdjustment__c=0,
                APTS_Price_Cap_Adjustment_Percentage__c = 1,
                APTS_Contract_Term__c ='Existing',
                APTS_Years_2_Plus_Adjustment__c = '4',
                APTS_Keep_Terms__c =True,
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
            listOfLineItems.add(linObj3);
            
            Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prod2Obj.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Option',
                Apttus_Config2__LineNumber__c = 2, 
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__NetPrice__c=10.0,
                Apttus_Config2__BasePrice__c=10.0,
                Apttus_Config2__BaseExtendedPrice__c = 10.0,
                Apttus_Config2__AdjustedPrice__c = 10.0,
                Apttus_Config2__ExtendedPrice__c = 10.0,
                Apttus_Config2__OptionPrice__c = 15.0,
                Apttus_Config2__Frequency__c = 'Monthly',
                Apttus_Config2__PriceType__c = 'Recurring', 
                Apttus_Config2__PriceAdjustment__c=0,
                Apttus_Config2__OptionId__c=null,
                APTS_Price_Cap_Adjustment_Percentage__c = 1,
                APTS_Contract_Term__c ='1 Year',
                APTS_Years_2_Plus_Adjustment__c = '4',
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
            listOfLineItems.add(linObj4);
            
            Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prod2Obj.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Option',
                Apttus_Config2__LineNumber__c = 1, 
                Apttus_Config2__PrimaryLineNumber__c = 1,
                Apttus_Config2__ItemSequence__c = 3,
                Apttus_Config2__NetPrice__c=10.0,
                Apttus_Config2__BasePrice__c=10.0,
                Apttus_Config2__BaseExtendedPrice__c = 10.0,
                Apttus_Config2__AdjustedPrice__c = 10.0,
                Apttus_Config2__ExtendedPrice__c = 10.0,
                Apttus_Config2__OptionPrice__c = 15.0,
                Apttus_Config2__Frequency__c = 'Monthly',
                Apttus_Config2__PriceType__c = 'Recurring', 
                Apttus_Config2__PriceAdjustment__c=0,
                Apttus_Config2__OptionId__c=null,
                APTS_Price_Cap_Adjustment_Percentage__c = 1,
                APTS_Contract_Term__c ='1 Year',
                APTS_Years_2_Plus_Adjustment__c = '4',
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
            
            listOfLineItems.add(linObj5);
            
            //List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
            
            Apttus_Config2__LineItem__c linObj51 = new Apttus_Config2__LineItem__c();
            linObj51.Apttus_Config2__Quantity__c=1;
            linObj51.Apttus_Config2__ProductId__c=prodObj.id;
            linObj51.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj51.Apttus_Config2__LineType__c = 'Product/Service';        
            linObj51.Apttus_Config2__LineNumber__c = 1;
            linObj51.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj51.Apttus_Config2__ItemSequence__c = 3;
            linObj51.Apttus_Config2__NetPrice__c=10.0;            
            linObj51.Apttus_Config2__OptionPrice__c = 15.0;
            linObj51.Apttus_Config2__Frequency__c = 'Monthly';
            linObj51.Apttus_Config2__PriceType__c = 'Recurring';
            linObj51.Apttus_Config2__PriceAdjustment__c=0;
            linObj51.Apttus_Config2__LineStatus__c='New';
            linObj51.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj51.APTS_Contract_Term__c ='Existing';
            linObj51.APTS_Years_2_Plus_Adjustment__c = '4';
            linObj51.Apttus_Config2__OptionId__c=null;
            linObj51.APTS_Product_Family__c = 'PPC MANAGEMENT';                        
            linObj51.Apttus_Config2__PriceListItemId__c = pliSO3.id;             
            //ListOfLineItems1.add(linObj51);
            listOfLineItems.add(linObj51);
            
            Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c();
            linObj6.Apttus_Config2__Quantity__c=1;
            //linObj6.Apttus_Config2__ProductId__c=prodObj.id;
            linObj6.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj6.Apttus_Config2__LineType__c = 'Option';
            linObj6.Apttus_Config2__LineNumber__c = 1;
            linObj6.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj6.Apttus_Config2__ItemSequence__c = 3;
            linObj6.Apttus_Config2__NetPrice__c=10.0;            
            linObj6.Apttus_Config2__OptionPrice__c = 15.0;            
            linObj6.Apttus_Config2__Frequency__c = 'Monthly';
            linObj6.Apttus_Config2__PriceType__c = 'Recurring';
            linObj6.Apttus_Config2__PriceAdjustment__c=0;
            linObj6.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj6.APTS_Contract_Term__c ='1 Year';
            linObj6.APTS_Product_Family__c = 'PPC MANAGEMENT';        
            linObj6.APTS_Years_2_Plus_Adjustment__c = '4';
            linObj6.Apttus_Config2__OptionId__c=null;
            //linObj6.APTS_PAGEO_Price__c=attributecombination.APTS_Price__c;
            linObj6.Apttus_Config2__PriceListItemId__c = pliSO3.id;             
           // ListOfLineItems1.add(linObj6);
           listOfLineItems.add(linObj6);
            
            Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c();
            linObj7.Apttus_Config2__Quantity__c=1;
            //linObj7.Apttus_Config2__ProductId__c=prodObj1.id;
            linObj7.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj7.Apttus_Config2__LineType__c = 'Option';            
            linObj7.Apttus_Config2__LineNumber__c = 1;
            linObj7.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj7.Apttus_Config2__ItemSequence__c = 3;
            linObj7.Apttus_Config2__NetPrice__c=10.0;            
            linObj7.Apttus_Config2__OptionPrice__c = 15.0;
            linObj7.Apttus_Config2__Frequency__c = 'Monthly';
            linObj7.Apttus_Config2__PriceType__c = 'Recurring';
            linObj7.Apttus_Config2__PriceAdjustment__c=0;
            linObj7.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj7.APTS_Contract_Term__c ='1 Year';
            linObj7.APTS_Product_Family__c = 'PPC MANAGEMENT';    
            linObj7.APTS_Years_2_Plus_Adjustment__c = '4';     
            linObj7.Apttus_Config2__OptionId__c=null;           
            linObj7.Apttus_Config2__PriceListItemId__c = pliSO5.id;            
            listOfLineItems.add(linObj7);            
            
           // insert ListOfLineItems1;
            
            Apttus_Config2__PriceDimension__c pricedimension = new Apttus_Config2__PriceDimension__c();
            pricedimension.Name='Priced Number of Attorneys';
            pricedimension.Apttus_Config2__Datasource__c='test';
            Insert pricedimension;
            
            Apttus_Config2__PriceMatrix__c pricematrix= new Apttus_Config2__PriceMatrix__c();            
            pricematrix.Apttus_Config2__Dimension2Id__c=pricedimension.id;
            pricematrix.Apttus_Config2__PriceListItemId__c=pliSO3.id;
            pricematrix.Apttus_Config2__Sequence__c=111;
            insert pricematrix;
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry= new Apttus_Config2__PriceMatrixEntry__c();            
            pricematricentry.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry.Apttus_Config2__Sequence__c=111;
            pricematricentry.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry.Apttus_Config2__Dimension2Value__c='11.00';
            Insert pricematricentry;
            
            insert listOfLineItems;        
            
            List<Apttus_Config2__ProductAttributeValue__c> prodattr =new List<Apttus_Config2__ProductAttributeValue__c>();            
            Apttus_Config2__ProductAttributeValue__c pavObj = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj2 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj2.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj3 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj3.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj4 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj4.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj5 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj5.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj6 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up & Enter Sub',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj51.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj7 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up & Enter Sub',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj6.id
            );
            Apttus_Config2__ProductAttributeValue__c pavObj8 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = linObj7.id
            );
            prodattr.add(pavObj);   
           // prodattr.add(pavObj1);
            prodattr.add(pavObj2);
            prodattr.add(pavObj3);
            prodattr.add(pavObj4);
            prodattr.add(pavObj5);
            prodattr.add(pavObj6);
            prodattr.add(pavObj7);
            prodattr.add(pavObj8);
            insert prodattr;
            
            
            //====================================================================
            Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
            className.Apttus_Config2__Active__c = true;
            className.Apttus_Config2__GuidePage__c = 'APTPSGuidedSelling';
            className.Apttus_Config2__HierarchyLabel__c = 'Thomson Products';
            className.Apttus_Config2__Type__c = 'Offering';
            className.Name = 'Thomson Products';
            insert className;
            
            Apttus_Config2__ClassificationHierarchy__c classHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
            classHierarchy.Apttus_Config2__GuidePage__c = 'APTPSGuidedSelling';
            classHierarchy.Apttus_Config2__HierarchyId__c = className.Id;
            classHierarchy.Apttus_Config2__Label__c = 'Thomson Products';
            classHierarchy.Apttus_Config2__Left__c = 1.0;
            classHierarchy.Apttus_Config2__Level__c = 0.0;
            classHierarchy.Apttus_Config2__MaxOptions__c = 1.0;
            classHierarchy.Apttus_Config2__MinOptions__c = 1.0;
            classHierarchy.Apttus_Config2__Left__c = 2.0;
            insert classHierarchy;
            
            Apttus_Config2__ProductClassification__c prodClassification = new Apttus_Config2__ProductClassification__c();
            prodClassification.Apttus_Config2__ProductId__c = prod2Obj.Id;
            prodClassification.Apttus_Config2__MaxQuantity__c =2.0;
            prodClassification.Apttus_Config2__MinQuantity__c = 1.0;
            prodClassification.Apttus_Config2__ClassificationId__c = classHierarchy.Id;            
            insert prodClassification;
            
            Apttus_Config2__ProductOptionGroup__c optGroupSO = new Apttus_Config2__ProductOptionGroup__c();
            optGroupSO.Apttus_Config2__RootOptionGroupId__c = classHierarchy.Id;
            optGroupSO.Apttus_Config2__OptionGroupId__c = classHierarchy.Id;
            optGroupSO.Apttus_Config2__ProductId__c = prodObj.Id;
            optGroupSO.Apttus_Config2__Sequence__c = 1;
            optGroupSO.Apttus_Config2__MaxOptions__c = 1.0;
            optGroupSO.Apttus_Config2__MinOptions__c = 0.0;
            optGroupSO.Apttus_Config2__IsLeaf__c = true;
            optGroupSO.Apttus_Config2__Left__c = 1.0;
            optGroupSO.Apttus_Config2__Right__c = 2.0;
            optGroupSO.Apttus_Config2__ModifiableType__c = 'Variable';
            optGroupSO.Apttus_Config2__RootSequence__c = 7.0;
            insert optGroupSO;
            
            Apttus_Config2__ProductOptionComponent__c optionSO = new Apttus_Config2__ProductOptionComponent__c();
            optionSO.Apttus_Config2__ParentProductId__c = prodObj.Id;
            optionSO.Apttus_Config2__ProductOptionGroupId__c = optGroupSO.Id;
            optionSO.Apttus_Config2__ComponentProductId__c = prod2Obj.Id;
            optionSO.Apttus_Config2__Sequence__c = 1;
            optionSO.Apttus_Config2__RelationshipType__c = 'Option';
            optionSO.Apttus_Config2__MinQuantity__c = 0.0;
            optionSO.Apttus_Config2__MaxQuantity__c = 1.0;
            optionSO.Apttus_Config2__DefaultQuantity__c = 1.0;        
            insert optionSO;
            //====================================================================
                           
            List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,APTS_Corporate_Select__c,APTS_Corporate_Select_Option__c,Apttus_Config2__ConfigurationId__c,
                                                               Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ChargeType__c, 
                                                               Apttus_Config2__PrimaryLineNumber__c, APTS_Proposal_Business_Unit__c,APTS_Contract_Term_Default__c,APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,
                                                               Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Product_Name__c, Apttus_Config2__PriceType__c, 
                                                               APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Keep_Terms__c, Apttus_Config2__ExtendedPrice__c, Apttus_Config2__OptionPrice__c, APTS_Price_Cap_Adjustment_Percentage__c         
                                                               FROM Apttus_Config2__LineItem__c 
                                                               WHERE Id = :linObj.Id OR Id = :linObj2.Id OR Id = :linObj3.Id OR Id = :linObj4.Id OR Id = :linObj5.Id];      
           
            List<Apttus_Config2__LineItem__c> bundleItems1 = new List<Apttus_Config2__LineItem__c>();
            List<Apttus_Config2__LineItem__c> bundleItems = new List<Apttus_Config2__LineItem__c>();
            Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = APTS_PricingCallbackMethods.buildLineNumberToOptionsMap(lineItemsList, bundleItems);
            set<Id> lineitemId = new set<Id>();        
            //for(Apttus_Config2__LineItem__c lineitem : ListOfLineItems1){
                lineitemId.add(linObj51.id);
                lineitemId.add(linObj6.id);
            //}                
            
            //SOC-7338 Added by Chirag 4/19/18
            Test.startTest();         
     //       APTS_PricingCallBackMethods.setBasePrice(bundleItems);
            APTS_PricingCallBackMethods.defaultContractTermDiscounts(bundleItems, lineNumberToOptionsMap,prodConfig);
            APTS_PricingCallBackMethods.discountToMax(bundleItems, lineNumberToOptionsMap);
            APTS_PricingCallBackMethods.discountToMax(bundleItems1, lineNumberToOptionsMap);
            
            if(lineItemsList.size() > 0){
                APTS_PricingCallBackMethods.addOptionsToLineItemSO(lineItemsList.get(0), prodConfig.Id);
            }
            APTS_PricingCallBackMethods.totallingGroupForDynamicBundle(lineItemsList);
            
            new APTS_PricingCallBackMethods();
            System.assertEquals(5,lineItemsList.size());
            Test.stopTest();
        }   
 @isTest static void testMethodPI()
    { 
         

        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        Test.startTest();  
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
         
          Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters - Argentina to USD');
        insert plSO;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
         // prodObj.APTS_Corporate_Select__c=' Primary';
          insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        /*
       List<Apttus_Config2__PriceListItem__c> pliSOList = new  List<Apttus_Config2__PriceListItem__c>();
        pliSOList.add(pliSO);
        insert pliSOList;
        */
        
        List<Apttus_Config2__ProductConfiguration__c> cartSOList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        //prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        //prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        cartSOList.add(prodConfig);
        //cartSOList.add(createCart(accountSSD.id, proposal.Id, plSO.Id));
        insert cartSOList;
        /*
        List<Apttus_Config2__LineItem__c> liSOList = new List<Apttus_Config2__LineItem__c>();
        liSOList.add(createLI(cartSOList[0].ID, 1, pliSOList[0].ID, plSO.ID, prodSOList[0].ID));
        liSOList[0].Deliverable_Type__c = 'Replacement';
        liSOList[0].Apttus_Config2__MaxPrice__c = 1;
        insert liSOList;*/
         list<Apttus_Config2__LineItem__c> listLines = new list<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c line1 = DCTestData.createLineItem(cartSOList[0].Id, 1, 1, true, 'Product/Service', prodObj.id, null, 2, plSO.Id, null, false,false);
        line1.Apttus_Config2__LineStatus__c='Renewed';
        listLines.add(line1);
        
        Apttus_Config2__LineItem__c line2 = DCTestData.createLineItem(cartSOList[0].Id, 1, 1, true, 'Product/Service', prodObj.id, null, 2, plSO.Id, null, false,true);
        line2.Apttus_Config2__LineStatus__c='Renewed';
        listLines.add(line2);
        Insert listLines;
        List<Decimal> lineNumList2 = new List<Decimal>{line2.Apttus_Config2__LineNumber__c};
        
        List<Decimal> lineNumList = createLI(cartSOList[0].ID, 1, pliSO.ID, plSO.ID, prodObj.ID);
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
        List<Apttus_Config2__LineItem__c> liSOList2 = [select id, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList2];

        /*for(Apttus_Config2__LineItem__c liSO : liSOList) {
            liSO.Deliverable_Type__c = 'Replacement';
        }*/
        update liSOList;
        update liSOList2;
        priceCartLines(cartSOList[0].ID);   
        System.assertEquals(2,listLines.size());
        Test.stopTest();
    }
}