@isTest
public class Credit_IncreaseTriggerHelperTest {
    private static void priceCartLines(ID cartID) 
    {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
    }
    private static List<Decimal> createLI(ID cartID, Integer sequence, ID priceListItemId, ID priceListId, ID prodID) 
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
    
    @isTest static void testMethodForTax()
    { 
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')                                                                         
            };        
                insert staticCSList ;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        keyValueList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
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
        obj1.Apttus_Config2__CustomFieldNames2__c = 'APTS_Term_Type__c,Apttus_Config2__ProductId__r.APTS_Auto_Renew__c,Apttus_Config2__ProductId__r.APTS_Auto_Renew_Rate_Eligible__c';
        obj1.Apttus_Config2__CustomFieldNames3__c = 'APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_Yr_2_Amount__c,APTS_Is_Multi_Tiered_Pricing__c,APTS_Calculated_Min_YOY__c,APTS_Calculated_Auto_Renewal__c,';
        obj1.Apttus_Config2__CustomFieldNames4__c = 'APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,APTS_Contract_Term__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Contract_Term_Whole_Years__c,APTS_Partial_Year_Charge_Eligible__c,Apttus_Config2__NetUnitPrice__c,';
        obj1.Apttus_Config2__CustomFieldNames5__c ='Apttus_product_variant__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceIncludedInBundle__c,';
        
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
        WebServiceSettings__c WebserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        WebserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount';
        WebserviceList.Service_Unavailable_Message__c='Service not Available';
        webserviceSettingsList.add(WebserviceList);
        insert webserviceSettingsList;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        
        //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.APTS_Is_Customer__c = true;
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Win_Loss__c = 'Won';
        oppty.Reason__c = 'Price';
        insert oppty;
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        proposal.APTS_Payment_Option__c = 'Auto EFT/Auto Charge';
        proposal.Latam_APTS_Win_Loss__c = 'Won';
        proposal.Latam_APTS_Reason__c = 'Price';
        proposal.Apttus_Proposal__Approval_Stage__c='Accepted';
        proposal.Payment_Status__c = 'Completed';
        insert proposal;       
                     
        Test.startTest();
              
        proposal.Apttus_Proposal__Approval_Stage__c='Accepted';
        proposal.Payment_Status__c = 'Completed';
        Test.stopTest();
    }
}