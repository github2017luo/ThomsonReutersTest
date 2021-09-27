@isTest
private class APTS_PricingCallbackTest 
{
    private static void priceCartLines(ID cartID) 
    {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
    }
    /*private static List<Decimal> createLI(ID cartID, Integer sequence, ID priceListItemId, ID priceListId, ID prodID) 
    {
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
        return bundleRespDO.LineNumbers;
        //return null;
    }*/
    private static List<Decimal> createLI(Map<String,ID> idMap, Integer sequence) 
    {
        ID cartID = idMap.get('cartID');
        ID priceListItemId = idMap.get('priceListItemId');
        ID priceListId = idMap.get('priceListId');
        ID prodID = idMap.get('prodID');
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
        return bundleRespDO.LineNumbers;
        //return null;
    }
    
    private static Apttus_Config2__ProductConfiguration__c createCart(Id accountSSD, Id proposalId, Id priceListId)
    {   
     
        Apttus_Config2__ProductConfiguration__c cartSO = new Apttus_Config2__ProductConfiguration__c();
        cartSO.Name = 'Product Confiuguration - 1';
        cartSO.Apttus_Config2__VersionNumber__c = 1;
        cartSO.Apttus_Config2__BusinessObjectId__c = proposalId;
        cartSO.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        cartSO.Apttus_Config2__Status__c = 'New';
        cartSO.APTS_SSD_bill_to__c= accountSSD;
        cartSO.APTS_SSD_ship_to__c= accountSSD;        
        cartSO.Apttus_Config2__PriceListId__c = priceListId;
        cartSO.Apttus_Config2__IsTransient__c = true;
        return cartSO;
    }
    
    private static void createCustomSettingsData(){
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
          new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
        };
        insert keyValueList;
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
        WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'Payment AutoCharge'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wslist = new List<WebServiceSettings__c>{webserviceList,oWebServiceSettings,aWebServiceSettings};
        
        insert wslist;
    }
    
    private static void createCustomFieldsList(){
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.Apttus_Config2__CustomFieldNames4__c = 'APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2); 
        Apttus_Config2__ConfigLineItemCustomFields__c obj5=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj5.Apttus_Config2__CustomFieldNames__c = 'APTS_Totaling_Summary_Group__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__BillingFrequency__c';
        obj5.Apttus_Config2__CustomFieldNames2__c = 'APTS_Module_Points__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__NetPrice__c,Apttus_Config2__IsCustomPricing__c';
        obj5.name='Custom Field Names4';
        customFieldsList.add(obj5);
        insert customFieldsList;
    }
    
    private static Account createAccount(){
        Id accountRecorType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.RecordTypeId=accountRecorType;
        insert a;
        return a;
    }
    
    private static Source_System_Detail__c createSSD(Account a, String salesOrg){
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();       
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Sales_Org__c=salesOrg;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
        return accountSSD;
    }
    
    private static Opportunity createOpportunity(Account a){
        Id oppRecorType=Schema.SObjectType.Opportunity .getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('Test opportunity',a.id,'Needs Analysis',System.today());
        opp.RecordtypeId=oppRecorType;  
        insert opp;
        return opp;
    }

   
    @isTest static void testMethodThree(){
        insertStaticValues();
        createCustomSettingsData(); 
        /* List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
         new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
         };
         insert keyValueList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;*/
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        createCustomFieldsList();
       /* 
       List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.Apttus_Config2__CustomFieldNames4__c = 'APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);        
        insert customFieldsList;
        */
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

       /* User usr = APTS_TestDataFactory.createUser('testcoverage123@asdf.com','test user');
        usr.Email='testcoverage123@asdf.com';
        usr.Alias = 'jliv';
        insert usr;*/
        
        /*WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'Payment AutoCharge'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wslist = new List<WebServiceSettings__c>{webserviceList,oWebServiceSettings,aWebServiceSettings};
        
        insert wslist;
        */
        /*Id accountRecorType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.RecordTypeId=accountRecorType;
        insert a;*/
        Account a = createAccount();
        System.assertequals('Test Account',a.Name,'Success');
        
        /*Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();       
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Sales_Org__c='TA78';
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;*/
        Source_System_Detail__c accountSSD = createSSD(a, 'TA78');
        
        /*Id oppRecorType=Schema.SObjectType.Opportunity .getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('Test opportunity',a.id,'Needs Analysis',System.today());
        opp.RecordtypeId=oppRecorType;  
        insert opp;*/
        Opportunity opp= createOpportunity(a);
        
        Id propRecordTypeId1 = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        proposal.RecordtypeId=propRecordTypeId1;  
        proposal.Apttus_Proposal__Proposal_Name__c ='test proposal';
        proposal.APTS_PaymentGateway_URL__c='www';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
         proposal.APTS_SSD_Ship_To__c=accountSSD.id;
         proposal.APTS_SSD_Bill_To__C=accountSSD.id;
         proposal.APTS_Payer__c=accountSSD.id;
        insert proposal;
        
        Test.startTest();
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
        
        Apttus_proposal__proposal__c proposal1 = APTS_TestDataFactory.createproposal(opp.id, accountSSD.Id);
        proposal1.RecordtypeId=propRecordTypeId1;  
        proposal1.Apttus_proposal__proposal_Name__c ='test proposal1';
        proposal1.APTS_PaymentGateway_URL__c='www';
        proposal1.Apttus_proposal__Account__c = a.Id;
        proposal1.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal1.APTS_SSD_Ship_To__c=accountSSD.id;
        proposal1.APTS_SSD_Bill_To__C=accountSSD.id;
        proposal1.APTS_Payer__c=accountSSD.id;
        proposal1.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal1;
        
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal1.Id);
        prodConfig1.Apttus_Config2__BusinessObjectId__c = proposal1.Id;
        prodConfig1.Apttus_Config2__BusinessObjectType__c = 'proposal1';
        prodConfig1.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig1.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig1.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig1.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig1.Apttus_Config2__AccountId__c = a.Id;
        prodConfig1.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig1.Apttus_Config2__Status__c = 'New';
        prodConfig1.Name = 'Test Config1';
        insert prodConfig1;
        
        Apttus_Proposal__Proposal__c proposal2= new Apttus_Proposal__Proposal__c();
        proposal2.APTS_Proposal_Business_Unit__c='Findlaw';
        proposal2.Apttus_Proposal__Account__c=a.id;
        proposal2.Apttus_Proposal__Opportunity__c=opp.id;
        insert proposal2;
        
        proposal2.APTS_Proposal_Business_Unit__c='Findlaw';
        update proposal2;
        
        Apttus_Config2__ProductConfiguration__c prodConfig2 = APTS_TestDataFactory.createProductConfiguration(proposal2.Id);
        prodConfig2.Apttus_Config2__BusinessObjectId__c = proposal2.Id;
        prodConfig2.Apttus_Config2__BusinessObjectType__c = 'proposal2';
        prodConfig2.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig2.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig2.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig2.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig2.Apttus_Config2__AccountId__c = a.Id;
        prodConfig2.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig2.Apttus_Config2__Status__c = 'New';
        prodConfig2.Name = 'Test Config1';
        insert prodConfig2;

        List<Apttus_Config2__PriceListItem__c> priceListItems =new List<Apttus_Config2__PriceListItem__c>();
       
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.IsActive = true;
        prodObj.CurrencyIsoCode = 'USD';
        prodObj.APTS_Price_Call__c=true;
        prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        insert prodObj; 
        
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 1.0';
        prodObj1.IsActive = true;
        prodObj1.CurrencyIsoCode = 'USD';
        prodObj1.APTS_Item_Category_Group__c='ZPMT';
        prodObj1.APTS_Price_Call__c=true;
        prodObj1.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];        
        insert prodObj1; 
        
        Product2 prodObj2 = new Product2();
        prodObj2.Name = 'Network Services 1.0';
        prodObj2.IsActive = true;
        prodObj2.CurrencyIsoCode = 'USD';
        prodObj2.APTS_Item_Category_Group__c='ZPMT';
        prodObj2.APTS_Price_Call__c=true;
        prodObj2.ProductCode = '41343504';
        insert prodObj2; 
        
        Product2 prodObj3 = new Product2();
        prodObj3.Name = 'Network Services 1.0';
        prodObj3.IsActive = true;
        prodObj3.CurrencyIsoCode = 'USD';
        prodObj3.APTS_Item_Category_Group__c='ZPMT';
        prodObj3.APTS_Price_Call__c=true;
        prodObj3.ProductCode = '40656701';
        insert prodObj3; 


        Apttus_Config2__PriceListItem__c pliSO1 = new Apttus_Config2__PriceListItem__c();
        pliSO1.Apttus_Config2__Active__c = true;
        pliSO1.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO1.APTS_Max_Fill_Up_Price__c = 5;
        pliSO1.Apttus_Config2__Sequence__c = 3;
        pliSO1.Apttus_Config2__ProductId__c = prodObj1.Id;
        priceListItems.add(pliSO1);  

        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        pliSO2.Apttus_Config2__Sequence__c = 3;
        pliSO2.Apttus_Config2__ProductId__c = prodObj1.Id;
        priceListItems.add(pliSO2);
      
        insert  priceListItems;
         Apttus_Config2__PriceDimension__c pricedimension = new Apttus_Config2__PriceDimension__c();
            pricedimension.Name='Priced Number of Attorneys';
            pricedimension.Apttus_Config2__Datasource__c='Apttus_Config2__LineStatus__c';
            insert pricedimension;
            
            Apttus_Config2__PriceMatrix__c pricematrix= new Apttus_Config2__PriceMatrix__c();            
            pricematrix.Apttus_Config2__Dimension2Id__c=pricedimension.id;
            pricematrix.Apttus_Config2__PriceListItemId__c=pliSO1.Id;
            pricematrix.Apttus_Config2__Dimension2ValueType__c = 'Range';
            pricematrix.Apttus_Config2__Sequence__c=111;
            insert pricematrix;
            system.debug('pricematrix--'+pricematrix);
            
            List<Apttus_Config2__PriceMatrixEntry__c> pricematricentryList= new list<Apttus_Config2__PriceMatrixEntry__c>();  
            Apttus_Config2__PriceMatrixEntry__c pricematricentry= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry.Apttus_Config2__Sequence__c=111;
            pricematricentry.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry.Apttus_Config2__Dimension2Value__c='11.00';
            pricematricentryList.add(pricematricentry);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry1= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry1.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry1.Apttus_Config2__Sequence__c=111;
            pricematricentry1.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry1.Apttus_Config2__Dimension2Value__c='10.00';
            pricematricentry1.Apttus_Config2__Dimension3Value__c='Option';
            pricematricentryList.add(pricematricentry1);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry2= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry2.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry2.Apttus_Config2__Sequence__c=111;
            pricematricentry2.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry2.Apttus_Config2__Dimension2Value__c='Option';
            pricematricentryList.add(pricematricentry2);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry3= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry3.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry3.Apttus_Config2__Sequence__c=111;
            pricematricentry3.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry3.Apttus_Config2__Dimension2Value__c='9.00';
            priceMatricEntry3.Apttus_Config2__AdjustmentAmount__c=100.00;
            pricematricentryList.add(pricematricentry3);
            insert pricematricentryList;
        APTS_Attribute_Value_Combination__c avc=new  APTS_Attribute_Value_Combination__c();
        avc.name='test';
         insert avc;
           List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.APTS_Combination_Key__c=avc.id;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='New';
            linObj1.Apttus_Config2__OptionId__c=null;            
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='Existing';
            linObj1.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO1.id; 
            
            listOfLineItems1.add(linObj1);
            
            Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__ProductId__c=prodObj1.id;           
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Option';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.APTS_Combination_Key__c=avc.id;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__LineStatus__c='New';
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c =null;
            linObj2.Apttus_Config2__OptionId__c=null;            
            linObj2.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO1.id; 
          
            listOfLineItems1.add(linObj2);
        
            Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Option';
            linObj3.Apttus_Config2__ChargeType__c='Standard Price';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.APTS_Combination_Key__c=avc.id;
            linObj3.Apttus_Config2__LineStatus__c='New';
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__OptionId__c=null;            
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c =null;            
            linObj3.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            listOfLineItems1.add(linObj3);
            
            Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__ChargeType__c='Standard Price';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.APTS_Combination_Key__c=avc.id;
            linObj4.Apttus_Config2__LineStatus__c='Renewed';
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__OptionId__c=null;            
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c =null;            
            linObj4.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            linObj4.Apttus_Config2__ProductId__c = prodObj2.Id;
            listOfLineItems1.add(linObj4);
            
            Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c();
            linObj5.Apttus_Config2__Quantity__c=1;
            linObj5.Apttus_Config2__ConfigurationId__c = prodConfig1.id;
            linObj5.Apttus_Config2__LineType__c = 'Product/Service';
            linObj5.Apttus_Config2__ChargeType__c='Standard Price';
            linObj5.Apttus_Config2__LineNumber__c = 1;
            linObj5.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj5.Apttus_Config2__ItemSequence__c = 3;
            linObj5.APTS_Combination_Key__c=avc.id;
            linObj5.Apttus_Config2__LineStatus__c='Renewed';
            linObj5.Apttus_Config2__NetPrice__c=10.0;            
            linObj5.Apttus_Config2__OptionPrice__c = 15.0;
            linObj5.Apttus_Config2__Frequency__c = 'Monthly';
            linObj5.Apttus_Config2__PriceType__c = 'Recurring';
            linObj5.Apttus_Config2__PriceAdjustment__c=0;
            linObj5.Apttus_Config2__OptionId__c=null;            
            linObj5.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj5.APTS_Contract_Term__c =null;            
            linObj5.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj5.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            linObj5.Apttus_Config2__ProductId__c = prodObj2.Id;
            listOfLineItems1.add(linObj5);
            
            Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c();
            linObj7.Apttus_Config2__Quantity__c=1;
            linObj7.Apttus_Config2__ConfigurationId__c = prodConfig1.id;
            linObj7.Apttus_Config2__LineType__c = 'Product/Service';
            linObj7.Apttus_Config2__ChargeType__c='Standard Price';
            linObj7.Apttus_Config2__LineNumber__c = 1;
            linObj7.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj7.Apttus_Config2__ItemSequence__c = 3;
            linObj7.APTS_Combination_Key__c=avc.id;
            linObj7.Apttus_Config2__LineStatus__c='Renewed';
            linObj7.Apttus_Config2__NetPrice__c=10.0;            
            linObj7.Apttus_Config2__OptionPrice__c = 15.0;
            linObj7.Apttus_Config2__Frequency__c = 'Monthly';
            linObj7.Apttus_Config2__PriceType__c = 'Recurring';
            linObj7.Apttus_Config2__PriceAdjustment__c=0;
            linObj7.Apttus_Config2__OptionId__c=null;            
            linObj7.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj7.APTS_Contract_Term__c =null;            
            linObj7.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj7.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            linObj7.Apttus_Config2__ProductId__c = prodObj2.Id;
            listOfLineItems1.add(linObj7);
            
            Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c();
            linObj6.Apttus_Config2__Quantity__c=1;
            linObj6.Apttus_Config2__ConfigurationId__c = prodConfig2.id;
            linObj6.Apttus_Config2__LineType__c = 'Product/Service';
            linObj6.Apttus_Config2__ChargeType__c='Standard Price';
            linObj6.Apttus_Config2__LineNumber__c = 1;
            linObj6.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj6.Apttus_Config2__ItemSequence__c = 3;
            linObj6.APTS_Combination_Key__c=avc.id;
            linObj6.Apttus_Config2__LineStatus__c='Renewed';
            linObj6.Apttus_Config2__NetPrice__c=10.0;            
            linObj6.Apttus_Config2__OptionPrice__c = 15.0;
            linObj6.Apttus_Config2__Frequency__c = 'Monthly';
            linObj6.Apttus_Config2__PriceType__c = 'Recurring';
            linObj6.Apttus_Config2__PriceAdjustment__c=0;
            linObj6.Apttus_Config2__OptionId__c=null;            
            linObj6.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj6.APTS_Contract_Term__c =null;            
            linObj6.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj6.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            linObj6.Apttus_Config2__ProductId__c = prodObj3.Id;
            linObj6.Apttus_Config2__AdjustmentAmount__c=null;
            listOfLineItems1.add(linObj6);
            insert listOfLineItems1;
            
        List<Decimal> lineNumList = createLI(new Map<String,ID>{'cartID'=>prodConfig.ID, 'priceListItemId'=>pliSO2.ID, 'priceListId'=>priceList.ID, 'prodID'=>prodObj.ID}, 1);
       
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
        List<Apttus_Config2__LineItem__c> liSOList1 = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c =1];

        /*for(Apttus_Config2__LineItem__c liSO : liSOList) {
            liSO.Deliverable_Type__c = 'Replacement';
        }*/
        update liSOList;
        update liSOList1;
        priceCartLines(prodConfig.ID);   
        Test.stopTest();
    }
    
    @isTest static void testMethodSCS(){
        insertStaticValues();
        createCustomSettingsData(); 
        /* List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
         new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
         };
         insert keyValueList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;*/
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
       List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c,APTS_Module_Points__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);        
        insert customFieldsList;
        
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

       /* User usr = APTS_TestDataFactory.createUser('testcoverage123@asdf.com','test user');
        usr.Email='testcoverage123@asdf.com';
        usr.Alias = 'jliv';
        insert usr;*/
        
        /*WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'Payment AutoCharge'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wslist = new List<WebServiceSettings__c>{webserviceList,oWebServiceSettings,aWebServiceSettings};
        
        insert wslist;*/
        
        Id accountRecorType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.RecordTypeId=accountRecorType;
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();       
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Sales_Org__c='TA78';
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
        
        Id oppRecorType=Schema.SObjectType.Opportunity .getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('Test opportunity',a.id,'Needs Analysis',System.today());
        opp.RecordtypeId=oppRecorType;  
        insert opp;
        
        Id propRecordTypeId1 = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        proposal.RecordtypeId=propRecordTypeId1;  
        proposal.Apttus_Proposal__Proposal_Name__c ='test proposal';
        proposal.APTS_PaymentGateway_URL__c='www';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
         proposal.APTS_SSD_Ship_To__c=accountSSD.id;
         proposal.APTS_SSD_Bill_To__C=accountSSD.id;
         proposal.APTS_Payer__c=accountSSD.id;
         proposal.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
        
        

        List<Apttus_Config2__PriceListItem__c> priceListItems =new List<Apttus_Config2__PriceListItem__c>();
       
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.IsActive = true;
        prodObj.CurrencyIsoCode = 'USD';
        prodObj.APTS_Price_Call__c=true;
        prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        insert prodObj; 
        
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 1.0';
        prodObj1.IsActive = true;
        prodObj1.CurrencyIsoCode = 'USD';
        prodObj1.APTS_Item_Category_Group__c='ZPMT';
        prodObj1.APTS_Price_Call__c=true;
        prodObj1.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];        
        insert prodObj1; 
        
        Product2 prodObj2 = new Product2();
        prodObj2.Name = 'Network Services 1.0';
        prodObj2.IsActive = true;
        prodObj2.CurrencyIsoCode = 'USD';
        prodObj2.APTS_Item_Category_Group__c='ZPMT';
        prodObj2.APTS_Price_Call__c=true;
        prodObj2.ProductCode = '41343504';
        insert prodObj2; 
        
        Product2 prodObj3 = new Product2();
        prodObj3.Name = 'Network Services 1.0';
        prodObj3.IsActive = true;
        prodObj3.CurrencyIsoCode = 'USD';
        prodObj3.APTS_Item_Category_Group__c='ZPMT';
        prodObj3.APTS_Price_Call__c=true;
        prodObj3.ProductCode = '40656701';
        insert prodObj3; 


        Apttus_Config2__PriceListItem__c pliSO1 = new Apttus_Config2__PriceListItem__c();
        pliSO1.Apttus_Config2__Active__c = true;
        pliSO1.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO1.APTS_Max_Fill_Up_Price__c = 5;
        pliSO1.Apttus_Config2__Sequence__c = 3;
        pliSO1.Apttus_Config2__ProductId__c = prodObj1.Id;
        priceListItems.add(pliSO1);  

        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        pliSO2.Apttus_Config2__Sequence__c = 3;
        pliSO2.Apttus_Config2__ProductId__c = prodObj1.Id;
        priceListItems.add(pliSO2);
      
        insert  priceListItems;
         Apttus_Config2__PriceDimension__c pricedimension = new Apttus_Config2__PriceDimension__c();
            pricedimension.Name='Priced Number of Attorneys';
            pricedimension.Apttus_Config2__Datasource__c='Apttus_Config2__LineStatus__c';
            insert pricedimension;
            
            Apttus_Config2__PriceMatrix__c pricematrix= new Apttus_Config2__PriceMatrix__c();            
            pricematrix.Apttus_Config2__Dimension2Id__c=pricedimension.id;
            pricematrix.Apttus_Config2__PriceListItemId__c=pliSO1.Id;
            pricematrix.Apttus_Config2__Dimension2ValueType__c = 'Range';
            pricematrix.Apttus_Config2__Sequence__c=111;
            insert pricematrix;
            system.debug('pricematrix--'+pricematrix);
            
            List<Apttus_Config2__PriceMatrixEntry__c> pricematricentryList= new list<Apttus_Config2__PriceMatrixEntry__c>();  
            Apttus_Config2__PriceMatrixEntry__c pricematricentry= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry.Apttus_Config2__Sequence__c=111;
            pricematricentry.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry.Apttus_Config2__Dimension2Value__c='11.00';
            pricematricentryList.add(pricematricentry);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry1= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry1.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry1.Apttus_Config2__Sequence__c=111;
            pricematricentry1.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry1.Apttus_Config2__Dimension2Value__c='10.00';
            pricematricentry1.Apttus_Config2__Dimension3Value__c='Option';
            pricematricentryList.add(pricematricentry1);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry2= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry2.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry2.Apttus_Config2__Sequence__c=111;
            pricematricentry2.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry2.Apttus_Config2__Dimension2Value__c='Option';
            pricematricentryList.add(pricematricentry2);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry3= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry3.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry3.Apttus_Config2__Sequence__c=111;
            pricematricentry3.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry3.Apttus_Config2__Dimension2Value__c='9.00';
            priceMatricEntry3.Apttus_Config2__AdjustmentAmount__c=100.00;
            pricematricentryList.add(pricematricentry3);
            insert pricematricentryList;
        APTS_Attribute_Value_Combination__c avc=new  APTS_Attribute_Value_Combination__c();
        avc.name='test';
         insert avc;
           List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.APTS_Combination_Key__c=avc.id;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='New';
            linObj1.Apttus_Config2__OptionId__c=null;            
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='Existing';
            linObj1.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO1.id; 
            
            listOfLineItems1.add(linObj1);
            
            Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__ProductId__c=prodObj1.id;           
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Option';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.APTS_Combination_Key__c=avc.id;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__LineStatus__c='New';
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c =null;
            linObj2.Apttus_Config2__OptionId__c=null;            
            linObj2.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO1.id; 
          
            listOfLineItems1.add(linObj2);
        
            Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Option';
            linObj3.Apttus_Config2__ChargeType__c='Standard Price';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.APTS_Combination_Key__c=avc.id;
            linObj3.Apttus_Config2__LineStatus__c='New';
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__OptionId__c=null;            
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c =null;            
            linObj3.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            listOfLineItems1.add(linObj3);
            
            Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__ChargeType__c='Standard Price';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.APTS_Combination_Key__c=avc.id;
            linObj4.Apttus_Config2__LineStatus__c='Renewed';
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__OptionId__c=null;            
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c =null;            
            linObj4.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            linObj4.Apttus_Config2__ProductId__c = prodObj2.Id;
            listOfLineItems1.add(linObj4);
            
          
            insert listOfLineItems1;
            
         Test.startTest();
        List<Decimal> lineNumList = createLI(new Map<String,ID>{'cartID'=>prodConfig.ID, 'priceListItemId'=>pliSO2.ID, 'priceListId'=>priceList.ID, 'prodID'=>prodObj.ID}, 1);
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
        List<Apttus_Config2__LineItem__c> liSOList1 = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c =1];

        /*for(Apttus_Config2__LineItem__c liSO : liSOList) {
            liSO.Deliverable_Type__c = 'Replacement';
        }*/
        update liSOList;
        update liSOList1;
        priceCartLines(prodConfig.ID);   
        Test.stopTest();
    }
    //Cover Tax Professional
    
     @isTest static void testMethodOne()
    { 
        insertStaticValues();
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
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c,APTS_Product_Family__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c,APTS_Module_Points__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);        
        insert customFieldsList;
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  

        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'Payment AutoCharge'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wslist = new List<WebServiceSettings__c>{oWebServiceSettings,aWebServiceSettings};
        insert wslist;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
      
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
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c='Findlaw';
        update proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_Call__c=true;
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
       // cartSOList.add(createCart(accountSSD.id, proposal.Id, plSO.Id));
        insert cartSOList;
        Apttus_Config2__ProductConfiguration__c productConfig=createCart(accountSSD.id, proposal.Id, plSO.Id);
        /*
        List<Apttus_Config2__LineItem__c> liSOList = new List<Apttus_Config2__LineItem__c>();
        liSOList.add(createLI(cartSOList[0].ID, 1, pliSOList[0].ID, plSO.ID, prodSOList[0].ID));
        liSOList[0].Deliverable_Type__c = 'Replacement';
        liSOList[0].Apttus_Config2__MaxPrice__c = 1;
        insert liSOList;*/
        
        
        Test.startTest();
        List<Decimal> lineNumList = createLI(new Map<String,ID>{'cartID'=>cartSOList[0].ID, 'priceListItemId'=>pliSO.ID, 'priceListId'=>plSO.ID, 'prodID'=>prodObj.ID}, 1);
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
        
        /*for(Apttus_Config2__LineItem__c liSO : liSOList) {
            liSO.Deliverable_Type__c = 'Replacement';
        }*/
        update liSOList;
        priceCartLines(cartSOList[0].ID);   
        Test.stopTest();
    }

    
@isTest static void testMethodtwo() {
      insertStaticValues();
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
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        Profile_List__c profileInfo=new Profile_List__c(ProfileId__c=System.Label.APTS_OC_Test_Id,Profile_Name__c='LatAm User',name='LatAm User');
        insert profileInfo;
        
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c,APTS_Product_Family__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c,APTS_Module_Points__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);        
        insert customFieldsList;     
        List<IXOSCodeMap__c> ixocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA78',Company_Code__c='1078',Dist_Chan_Code__c='T',Division_Code__c='T',Sales_Org_Code__c='TA78')};
        insert IXocodeList;

       Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;
        
        /*WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'Payment Credit Increase'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;*/
        
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
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(aWebServiceSettings);
        insert webserviceSettingsList;
    
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
      
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
         accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;

        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
         
         Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.isdigitalSpearhead__c = False;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.Apttus_Proposal__Account__c=a.id;
         proposal.Apttus_Proposal__Opportunity__c=oppty.id;
         proposal.APTS_SSD_Sold_To__c=accountSSD.id;
         proposal.APTS_SSD_Ship_To__c=accountSSD.id;
         proposal.APTS_SSD_Bill_To__C=accountSSD.id;
         proposal.APTS_Payer__c=accountSSD.id;
        insert proposal;
        
        Map<String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId(); //Archana - start
        
        Product2 prodObj = new Product2();
          prodObj.Name = '1SRC ITC Essentials';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_call__c=true;
          prodObj.ProductCode='42533744';
          insert prodObj; 
         

        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'Subscription Fee';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.Apttus_Config2__ProductId__c=prodObj.id;
          pliSO.Apttus_Config2__PriceType__c='Recurring';
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
          pliSO.Apttus_Config2__Frequency__c='Yearly';
          pliSO.Apttus_Config2__PriceUom__c='Each';
          pliSO.Apttus_Config2__PriceMethod__c='Per Unit';
        insert pliSO;
        
        /*
        List<Apttus_Config2__ProductConfiguration__c> cartSOList = new List<Apttus_Config2__ProductConfiguration__c>();
        cartSOList.add(createCart(accountSSD.id, proposal.Id, plSO.Id));
        cartSOList.add(createCart(accountSSD.id, proposal.Id, plSO.Id)); //Archana
        insert cartSOList;
        */
        /*List<Apttus_Config2__LineItem__c> liSOList = new List<Apttus_Config2__LineItem__c>();
        liSOList.add(createLI(cartSOList[0].ID, 1, pliSOList[0].ID, plSO.ID, prodSOList[0].ID));
        liSOList[0].Deliverable_Type__c = 'Replacement';
        liSOList[0].Apttus_Config2__MaxPrice__c = 1;
        insert liSOList;
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
        
       
        //List<Decimal> lineNumList = createLI(cartSOList[0].ID, 1, pliSO.ID, plSO.ID, prodObj.ID);
        //List<Decimal> lineNumList2 = createLI(cartSOList[1].ID, 1, pliSO.ID, plSO.ID, prodObj.ID);
        
        // Added by Rajan
        
        /*list<Apttus_Config2__LineItem__c> listLines = new list<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c line1 = DCTestData.createLineItem(cartSOList[0].Id, 1, 1, true, 'Product/Service', prodObj.id, null, 2, plSO.Id, null, false,false);
        listLines.add(line1);
        
        Apttus_Config2__LineItem__c line2 = DCTestData.createLineItem(cartSOList[0].Id, 1, 1, true, 'Product/Service', prodObj.id, null, 2, plSO.Id, null, false,true);
        listLines.add(line2);  
        Insert listLines;*/
     
          List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='New';
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c =null;
            linObj1.Apttus_Config2__OptionId__c=null;
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            
            listOfLineItems1.add(linObj1);
            
            Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__ProductId__c=prodObj.id;           
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Option';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__LineStatus__c='Renewed';
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c =null;
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linObj2.Apttus_Config2__OptionId__c=null;
            
            listOfLineItems1.add(linObj2);
        
           
            insert listOfLineItems1;
             
        
        //Apttus_Proposal__Proposal__c proposal1=[Select id,name,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Opportunity__c,APTS_SSD_bill_to__r.Source_System_Account_Number__c,APTS_SSD_ship_to__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c from Apttus_Proposal__Proposal__c limit 1 ];
          
         Test.startTest();
         Apttus_Config2__LineItem__c lineRec=[select APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where id=:linObj1.id];
        system.debug('pbu'+lineRec.APTS_Proposal_Business_Unit__c);
        //Test.setMock(WebServiceMock.class, new APTS_PricingMocKCallout());
        priceCartLines(prodConfig.ID);   
        Test.stopTest();
    }
        
        
         @isTest static void testMethodFour()
    { 
       LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')                                                                         
                                                                         };        
        insert staticCSList ;
        
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
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
         List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        
        obj.name='Custom Field Names';
        
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c = 'APTS_Term_Type__c,Apttus_Config2__ProductId__r.APTS_Auto_Renew__c,Apttus_Config2__ProductId__r.APTS_Auto_Renew_Rate_Eligible__c,APTS_Product_Family__c,APTS_Module_Points__c';
        obj1.Apttus_Config2__CustomFieldNames3__c = 'APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_Yr_2_Amount__c,APTS_Is_Multi_Tiered_Pricing__c,APTS_Calculated_Min_YOY__c,APTS_Calculated_Auto_Renewal__c,';
        obj1.Apttus_Config2__CustomFieldNames4__c = 'APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,APTS_Contract_Term__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Contract_Term_Whole_Years__c,APTS_Partial_Year_Charge_Eligible__c,Apttus_Config2__NetUnitPrice__c,';
        obj1.Apttus_Config2__CustomFieldNames5__c ='Apttus_product_variant__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__ProductId__r.Media_High_Level__c,';
        
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        insert customFieldsList; 
        
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  

        
        List<WebServiceSettings__c> webserviceSettingsList=new List<WebServiceSettings__c>();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings.Name = 'Payment AutoCharge'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(oWebServiceSettings);
        WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        webserviceSettingsList.add(webserviceList);
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(aWebServiceSettings);
        
        insert webserviceSettingsList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
      
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;   
        accountSSD.LCRM_Sales_Org__c='S100';
        insert accountSSD;
         
          Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_Call__c=true;
         // prodObj.APTS_Corporate_Select__c=' Primary';
          insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       
        
        List<Apttus_Config2__ProductConfiguration__c> cartSOList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        cartSOList.add(prodConfig);
       
        insert cartSOList;
        Apttus_Config2__ProductConfiguration__c productConfig=createCart(accountSSD.id, proposal.Id, plSO.Id);
        
        Test.startTest();
        List<Decimal> lineNumList = createLI(new Map<String,ID>{'cartID'=>cartSOList[0].ID, 'priceListItemId'=>pliSO.ID, 'priceListId'=>plSO.ID, 'prodID'=>prodObj.ID}, 1);
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
       
        update liSOList;
        priceCartLines(cartSOList[0].ID);  
        Test.stopTest();
    }
    
    @isTest static void testMethodSix()
    { 
       LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')                                                                         
                                                                         };        
        insert staticCSList ;
        
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
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c,APTS_Exposure_Pack_Disc__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c,APTS_Module_Points__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);        
        insert customFieldsList;
        
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  

        
        List<WebServiceSettings__c> webserviceSettingsList=new List<WebServiceSettings__c>();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings.Name = 'Payment AutoCharge'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(oWebServiceSettings);
        WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        webserviceSettingsList.add(webserviceList);
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(aWebServiceSettings);
        insert webserviceSettingsList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
      
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;     
        insert accountSSD;
         
          Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c='Findlaw';
        update proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_Call__c=true;
          prodObj.ProductCode  = '40656701';
          prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
         // prodObj.APTS_Corporate_Select__c=' Primary';
          insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       
        
        List<Apttus_Config2__ProductConfiguration__c> cartSOList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        prodConfig.Name = 'Test 123';
        cartSOList.add(prodConfig);
       
        insert cartSOList;
        Apttus_Config2__ProductConfiguration__c productConfig=createCart(accountSSD.id, proposal.Id, plSO.Id);
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Name = 'test1';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        insert ali;
        
        APTS_Attribute_Value_Combination__c avc=new  APTS_Attribute_Value_Combination__c();
        avc.name='test';
        avc.APTS_Price__c = 10;
        insert avc;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='Renewed';
            linObj1.Apttus_Config2__OptionId__c=null;            
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='Existing';
            linObj1.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id;
            linObj1.Apttus_Config2__AssetLineItemId__c = ali.Id;
            linObj1.APTS_Combination_Key__c = avc.Id;
            linObj1.Apttus_Config2__AdjustmentAmount__c  = null;
            listOfLineItems1.add(linObj1); 
            
            Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__Quantity__c=1;
            linObj2.Apttus_Config2__ProductId__c=prodObj.id;
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Product/Service';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.Apttus_Config2__LineStatus__c='Renewed';
            linObj2.Apttus_Config2__OptionId__c=null;            
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c =  null;
            linObj2.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO.id;
            linObj2.Apttus_Config2__AssetLineItemId__c = ali.Id;
            linObj2.APTS_Combination_Key__c = avc.Id;
            linObj2.Apttus_Config2__AdjustmentAmount__c  = null;
            linObj2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            listOfLineItems1.add(linObj2);  
            
            Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ProductId__c=prodObj.id;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Product/Service';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__LineStatus__c='Renewed';
            linObj3.Apttus_Config2__OptionId__c=null;            
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c ='Existing';
            linObj3.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO.id;
            linObj3.Apttus_Config2__AssetLineItemId__c = ali.Id;
            linObj3.APTS_Combination_Key__c = avc.Id;
            linObj3.Apttus_Config2__AdjustmentAmount__c  = null;
            linObj2.Apttus_Config2__ChargeType__c = 'Standard Price';
            listOfLineItems1.add(linObj3); 
            
            Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ProductId__c=prodObj.id;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'One Time';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__LineStatus__c='Renewed';
            linObj4.Apttus_Config2__OptionId__c=null;            
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c ='Existing';
            linObj4.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO.id;
            linObj4.Apttus_Config2__AssetLineItemId__c = ali.Id;
            linObj4.APTS_Combination_Key__c = avc.Id;
            linObj4.Apttus_Config2__AdjustmentAmount__c  = null;
            linObj2.Apttus_Config2__ChargeType__c = 'Standard Price';
            listOfLineItems1.add(linObj4); 
            
            insert listOfLineItems1;
        
        Test.startTest();
        List<Decimal> lineNumList = createLI(new Map<String,ID>{'cartID'=>cartSOList[0].ID, 'priceListItemId'=>pliSO.ID, 'priceListId'=>plSO.ID, 'prodID'=>prodObj.ID}, 1);
        
        
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where ID IN: listOfLineItems1];
       
        update liSOList;
        priceCartLines(cartSOList[0].ID);  
        Test.stopTest();
    }
    
    @isTest static void testMethodFive()
    { 
       LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')                                                                         
                                                                         };        
        insert staticCSList ;
        
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
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        keyValueList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c,APTS_Exposure_Pack_Disc__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c,APTS_Module_Points__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);        
        insert customFieldsList;
        
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  

        
        List<WebServiceSettings__c> webserviceSettingsList=new List<WebServiceSettings__c>();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable'; 
        oWebServiceSettings.Name = 'Payment AutoCharge'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge'; 
        oWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(oWebServiceSettings);
        WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        webserviceSettingsList.add(webserviceList);
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        webserviceSettingsList.add(aWebServiceSettings);
        insert webserviceSettingsList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
      
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;     
        insert accountSSD;
         
          Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='SCS';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_Call__c=true;
          prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
         // prodObj.APTS_Corporate_Select__c=' Primary';
          insert prodObj; 
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       
        
        List<Apttus_Config2__ProductConfiguration__c> cartSOList = new List<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        prodConfig.Name = 'Test 123';
        cartSOList.add(prodConfig);
       
        insert cartSOList;
        Apttus_Config2__ProductConfiguration__c productConfig=createCart(accountSSD.id, proposal.Id, plSO.Id);
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Name = 'test1';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        insert ali;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='Renewed';
            linObj1.Apttus_Config2__OptionId__c=null;            
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='Existing';
            linObj1.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id;
            linObj1.Apttus_Config2__AssetLineItemId__c = ali.Id;
            listOfLineItems1.add(linObj1); 
            insert listOfLineItems1;
        
        Test.startTest();
        List<Decimal> lineNumList = createLI(new Map<String,ID>{'cartID'=>cartSOList[0].ID, 'priceListItemId'=>pliSO.ID, 'priceListId'=>plSO.ID, 'prodID'=>prodObj.ID}, 1);
        
        
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where ID IN: listOfLineItems1];
       
        update liSOList;
        priceCartLines(cartSOList[0].ID);  
        Test.stopTest();
    }
 
   @isTest static void testMethodSCSTieredPricing(){
        insertStaticValues();
        createCustomSettingsData();  
        /* List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
         new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
         };
         insert keyValueList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;*/
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        createCustomFieldsList();
      /* List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c,APTS_Renewal_Type__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,APTS_Product_Name__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_PAGEO_Price__c';      
        obj.name='Custom Field Names';
        //insert obj; 
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj3=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj3.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj3.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj3.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj3.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj3.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj3.name='Custom Field Names3';
        customFieldsList.add(obj3);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c ='Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c= 'Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.Apttus_Config2__CustomFieldNames4__c = 'APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2); 
        Apttus_Config2__ConfigLineItemCustomFields__c obj5=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj5.Apttus_Config2__CustomFieldNames__c = 'APTS_Totaling_Summary_Group__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__BillingFrequency__c';
        obj5.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__NetPrice__c,Apttus_Config2__IsCustomPricing__c';
        obj5.name='Custom Field Names4';
        customFieldsList.add(obj5);
        insert customFieldsList;*/
        
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_PricingCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;  
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

       /* User usr = APTS_TestDataFactory.createUser('testcoverage123@asdf.com','test user');
        usr.Email='testcoverage123@asdf.com';
        usr.Alias = 'jliv';
        insert usr;*/
        
        /*WebServiceSettings__c webserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        webserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount';
        webserviceList.Service_Unavailable_Message__c='Service not Available';
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c aWebServiceSettings = new WebServiceSettings__c();
        aWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        aWebServiceSettings.Name = 'Payment AutoCharge'; 
        aWebServiceSettings.Timeout__c = 120; 
        aWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        aWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wslist = new List<WebServiceSettings__c>{webserviceList,oWebServiceSettings,aWebServiceSettings};
        
        insert wslist;*/
        
        Id accountRecorType=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.RecordTypeId=accountRecorType;
        insert a;
        System.assertequals('Test Account',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();       
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
   
        Id oppRecorType=Schema.SObjectType.Opportunity .getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('Test opportunity',a.id,'Needs Analysis',System.today());
        opp.RecordtypeId=oppRecorType;  
        insert opp;
        
        Id propRecordTypeId1 = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        proposal.RecordtypeId=propRecordTypeId1;  
        proposal.Apttus_Proposal__Proposal_Name__c ='test proposal';
        proposal.APTS_PaymentGateway_URL__c='www';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
         proposal.APTS_SSD_Ship_To__c=accountSSD.id;
         proposal.APTS_SSD_Bill_To__C=accountSSD.id;
         proposal.APTS_Payer__c=accountSSD.id;
         proposal.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
        
        

        List<Apttus_Config2__PriceListItem__c> priceListItems =new List<Apttus_Config2__PriceListItem__c>();
       
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.IsActive = true;
        prodObj.CurrencyIsoCode = 'USD';
        prodObj.APTS_Price_Call__c=true;
        prodObj.ProductCode = '40757482';
        prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        insert prodObj; 
        
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 1.0';
        prodObj1.IsActive = true;
        prodObj1.CurrencyIsoCode = 'USD';
        prodObj1.APTS_Item_Category_Group__c='ZPMT';
        prodObj1.APTS_Price_Call__c=true;
        prodObj1.ProductCode = '41343504';
        prodObj1.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];        
        insert prodObj1; 
        
        Product2 prodObj2 = new Product2();
        prodObj2.Name = 'Network Services 1.0';
        prodObj2.IsActive = true;
        prodObj2.CurrencyIsoCode = 'USD';
        prodObj2.APTS_Item_Category_Group__c='ZPMT';
        prodObj2.APTS_Price_Call__c=true;
        prodObj2.ProductCode = '41343504';
        insert prodObj2; 
        
        Product2 prodObj3 = new Product2();
        prodObj3.Name = 'Network Services 1.0';
        prodObj3.IsActive = true;
        prodObj3.CurrencyIsoCode = 'USD';
        prodObj3.APTS_Item_Category_Group__c='ZPMT';
        prodObj3.APTS_Price_Call__c=true;
        prodObj3.ProductCode = '40656701';
        insert prodObj3; 


        Apttus_Config2__PriceListItem__c pliSO1 = new Apttus_Config2__PriceListItem__c();
        pliSO1.Apttus_Config2__Active__c = true;
        pliSO1.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO1.APTS_Max_Fill_Up_Price__c = 5;
        pliSO1.Apttus_Config2__Sequence__c = 3;
        pliSO1.Apttus_Config2__ProductId__c = prodObj1.Id;
        priceListItems.add(pliSO1);  

        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        pliSO2.Apttus_Config2__Sequence__c = 3;
        pliSO2.Apttus_Config2__ProductId__c = prodObj1.Id;
        priceListItems.add(pliSO2);
      
        insert  priceListItems;
         Apttus_Config2__PriceDimension__c pricedimension = new Apttus_Config2__PriceDimension__c();
            pricedimension.Name='Priced Number of Attorneys';
            pricedimension.Apttus_Config2__Datasource__c='Apttus_Config2__LineStatus__c';
            insert pricedimension;
            
            Apttus_Config2__PriceMatrix__c pricematrix= new Apttus_Config2__PriceMatrix__c();            
            pricematrix.Apttus_Config2__Dimension2Id__c=pricedimension.id;
            pricematrix.Apttus_Config2__PriceListItemId__c=pliSO1.Id;
            pricematrix.Apttus_Config2__Dimension2ValueType__c = 'Range';
            pricematrix.Apttus_Config2__Sequence__c=111;
            insert pricematrix;
            system.debug('pricematrix--'+pricematrix);
            
            List<Apttus_Config2__PriceMatrixEntry__c> pricematricentryList= new list<Apttus_Config2__PriceMatrixEntry__c>();  
            Apttus_Config2__PriceMatrixEntry__c pricematricentry= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry.Apttus_Config2__Sequence__c=111;
            pricematricentry.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry.Apttus_Config2__Dimension2Value__c='11.00';
            pricematricentryList.add(pricematricentry);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry1= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry1.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry1.Apttus_Config2__Sequence__c=111;
            pricematricentry1.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry1.Apttus_Config2__Dimension2Value__c='10.00';
            pricematricentry1.Apttus_Config2__Dimension3Value__c='Option';
            pricematricentryList.add(pricematricentry1);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry2= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry2.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry2.Apttus_Config2__Sequence__c=111;
            pricematricentry2.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry2.Apttus_Config2__Dimension2Value__c='Option';
            pricematricentryList.add(pricematricentry2);
            
            Apttus_Config2__PriceMatrixEntry__c pricematricentry3= new Apttus_Config2__PriceMatrixEntry__c();          
            pricematricentry3.Apttus_Config2__PriceMatrixId__c=pricematrix.id;
            pricematricentry3.Apttus_Config2__Sequence__c=111;
            pricematricentry3.Apttus_Config2__Dimension1Value__c='Renewed';
            pricematricentry3.Apttus_Config2__Dimension2Value__c='9.00';
            priceMatricEntry3.Apttus_Config2__AdjustmentAmount__c=100.00;
            pricematricentryList.add(pricematricentry3);
            insert pricematricentryList;
        APTS_Attribute_Value_Combination__c avc=new  APTS_Attribute_Value_Combination__c();
        avc.name='test';
         insert avc;
           List<Apttus_Config2__LineItem__c> listOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
            Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.APTS_Combination_Key__c=avc.id;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__ListPrice__c = 5.0;
            linObj1.Apttus_Config2__BasePrice__c = 5.0;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='New';
            linObj1.Apttus_Config2__OptionId__c=null;            
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='Existing';
            linObj1.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO1.id; 
            linObj1.APTS_Group__c = 'Bundle A';
            linObj1.APTS_Group_Primary_Material_Name__c = 'WEST PROFLEX';
            linObj1.Apttus_Config2__AdjustedPrice__c=50;
            
            listOfLineItems1.add(linObj1);
            
            Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__ProductId__c=prodObj1.id;           
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Option';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.APTS_Combination_Key__c=avc.id;
            linObj2.Apttus_Config2__ListPrice__c = 5.0;
            linObj2.Apttus_Config2__BasePrice__c = 5.0;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__LineStatus__c='New';
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c =null;
            linObj2.Apttus_Config2__OptionId__c=null;            
            linObj2.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO1.id; 
            linObj2.APTS_Group__c = 'Bundle A';
            linObj2.APTS_Group_Primary_Material_Name__c = 'WEST PROFLEX';
            linObj2.Apttus_Config2__AdjustedPrice__c=50;
            listOfLineItems1.add(linObj2);
        
            Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Option';
            linObj3.Apttus_Config2__ChargeType__c='Standard Price';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.APTS_Combination_Key__c=avc.id;
            linObj3.Apttus_Config2__LineStatus__c='New';
            linObj3.Apttus_Config2__ListPrice__c = 5.0;
            linObj3.Apttus_Config2__BasePrice__c = 5.0;
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__OptionId__c=null;            
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c =null;            
            linObj3.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO2.id;
            linObj3.Apttus_Config2__AdjustedPrice__c=50; 
            listOfLineItems1.add(linObj3);
            
            Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__ChargeType__c='Standard Price';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.APTS_Combination_Key__c=avc.id;
            linObj4.Apttus_Config2__LineStatus__c='New';        
            linObj4.Apttus_Config2__ListPrice__c = 5.0;
            linObj4.Apttus_Config2__BasePrice__c = 5.0;
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__OptionId__c=null;            
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c =null;            
            linObj4.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO2.id; 
            linObj4.Apttus_Config2__ProductId__c = prodObj2.Id;
            linObj4.APTS_Group__c = 'BundleA';
            linObj4.APTS_Group_Primary_Material_Name__c = 'WEST PROFLEX';
            linObj4.Apttus_Config2__AdjustedPrice__c=50;
            listOfLineItems1.add(linObj4);
            
          
            insert listOfLineItems1;
            
         Test.startTest();
        List<Decimal> lineNumList = createLI(new Map<String, ID>{'cartID'=>prodConfig.ID, 'priceListItemId'=>pliSO2.ID, 'priceListId'=>priceList.ID, 'prodID'=>prodObj.ID}, 1);
        List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
        List<Apttus_Config2__LineItem__c> liSOList1 = [select id, Apttus_Config2__PriceType__c, Apttus_Config2__LineType__c,Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c, APTS_Corporate_Select__c,APTS_Combination_Key__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c =1];

        /*for(Apttus_Config2__LineItem__c liSO : liSOList) {
            liSO.Deliverable_Type__c = 'Replacement';
        }*/
        update liSOList;
        update liSOList1;
        priceCartLines(prodConfig.ID);  
        APTS_PricingCallback pcObj = new APTS_PricingCallback();
        pcObj.countNumberOfAttorneys(linObj4,0); 
        Test.stopTest();
    }
    
    private static void insertStaticValues(){
    
          LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                           };
        
        insert staticCSList ;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
    }
    
}