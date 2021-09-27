@isTest
public class APTS_TaxProf_PricingCallbackMethods_Test{

private static void priceCartLines(ID cartID) 
    {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
    }
    @isTest static void testMethodtwo() {
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
        
        Profile_List__c profileInfo=new Profile_List__c(ProfileId__c='00ea00000024JzKAAU',Profile_Name__c='LatAm User',name='LatAm User');
        insert profileInfo;
        
        /*KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;*/
         List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
        
        };
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
        obj1.Apttus_Config2__CustomFieldNames5__c ='Apttus_product_variant__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__ProductId__r.ProductCode,';
        
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        insert customFieldsList;
             
        List<IXOSCodeMap__c> IXocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA78',Company_Code__c='1078',Dist_Chan_Code__c='T',Division_Code__c='T',Sales_Org_Code__c='TA78')};
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
        WebServiceSettings__c WebserviceList= APTS_TestDataFactory.createWebServiceSetting('GetPriceFromSAP');
        WebserviceList.Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/account/qa/createAccount';
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
         accountSSD.LCRM_Sales_Org__c='S100';
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
         proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        insert proposal;
        
        Map<String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId(); //Archana - start
        
        Product2 prodObj = new Product2();
          prodObj.Name = '1SRC ITC Essentials';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.ProductCode='42533744';
          prodObj.WLEC_Product_Category__c='PS';
          prodObj.APTS_Item_Category_Group__c='ZXPS';
          prodObj.APTS_Auto_Renew__c =2;
          prodObj.APTS_Auto_Renew_Rate_Eligible__c=true;
          insert prodObj; 
          APTS_Product_Variant__c pv = new APTS_Product_Variant__c ();
          
          pv.APTS_Product_ID__c =prodObj.id;
          pv.APTS_Auto_Renew_Price_Basis__c ='abc';
          pv.APTS_Auto_Renew_Price_Percentage__c =20;
          
          insert pv;
         
            List<Apttus_Config2__PriceListItem__c> priceListItems =new List<Apttus_Config2__PriceListItem__c>();
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
           priceListItems.add(pliSO); 
        
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
            pliSO2.Apttus_Config2__Active__c = true;
            pliSO2.Apttus_Config2__PriceListId__c = plSO.Id;
            pliSO2.APTS_Max_Fill_Up_Price__c = 5;        
            priceListItems.add(pliSO2);   
            //insert  priceListItems;
       
        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
          pliSO3.Apttus_Config2__Active__c = true;
          pliSO3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
          pliSO3.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO3.Apttus_Config2__ProductId__c=prodObj.id;
          pliSO3.Apttus_Config2__PriceType__c='One Time';
          pliSO3.APTS_Max_Fill_Up_Price__c = 5;
          pliSO3.Apttus_Config2__Frequency__c='Yearly';
          pliSO3.Apttus_Config2__PriceUom__c='Each';
          pliSO3.Apttus_Config2__PriceMethod__c='Per Unit';
           priceListItems.add(pliSO3);
           insert  priceListItems;
        
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
        
        
        
       
          List<Apttus_Config2__LineItem__c> ListOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           
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
            linObj1.Apttus_Config2__BillingFrequency__c=null;
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            
            ListOfLineItems1.add(linObj1);
            
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
          
            ListOfLineItems1.add(linObj2);
            
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
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__LineStatus__c='New';
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c ='3 Years';
            linObj4.APTS_Years_2_Plus_Adjustment__c = '4';
            linObj4.Apttus_Config2__BillingFrequency__c='Monthly';
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            
            ListOfLineItems1.add(linObj4);
            
            Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c();
            linObj5.Apttus_Config2__Quantity__c=1;
            linObj5.Apttus_Config2__ProductId__c=prodObj.id;
            linObj5.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj5.Apttus_Config2__LineType__c = 'Product/Service';
            linObj5.Apttus_Config2__LineNumber__c = 1;
            linObj5.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj5.Apttus_Config2__ItemSequence__c = 3;
            linObj5.Apttus_Config2__NetPrice__c=10.0;            
            linObj5.Apttus_Config2__OptionPrice__c = 15.0;
            linObj5.Apttus_Config2__Frequency__c = 'Monthly';
            linObj5.Apttus_Config2__PriceType__c = 'Recurring';
            linObj5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj5.Apttus_Config2__PriceAdjustment__c=0;
            linObj5.Apttus_Config2__LineStatus__c='New';
            linObj5.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj5.APTS_Years_2_Plus_Adjustment__c ='';
            linObj5.APTS_Contract_Term__c =null;
            linObj5.Apttus_Config2__BillingFrequency__c=null;
            linObj5.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            
            ListOfLineItems1.add(linObj5);
            
             Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c();
            linObj6.Apttus_Config2__Quantity__c=1;
            linObj6.Apttus_Config2__ProductId__c=prodObj.id;
            linObj6.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj6.Apttus_Config2__LineType__c = 'Product/Service';
            linObj6.Apttus_Config2__LineNumber__c = 1;
            linObj6.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj6.Apttus_Config2__ItemSequence__c = 3;
            linObj6.Apttus_Config2__NetPrice__c=10.0;            
            linObj6.Apttus_Config2__OptionPrice__c = 15.0;
            linObj6.Apttus_Config2__Frequency__c = 'Monthly';
            linObj6.Apttus_Config2__PriceType__c = 'Recurring';
            linObj6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj6.Apttus_Config2__PriceAdjustment__c=0;
            linObj6.Apttus_Config2__LineStatus__c='Renewed';
            linObj6.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj6.APTS_Years_2_Plus_Adjustment__c ='';
            linObj6.APTS_Contract_Term__c =null;
            linObj6.Apttus_Config2__BillingFrequency__c=null;
            linObj6.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            
            ListOfLineItems1.add(linObj6);
             
        Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c();
            linObj7.Apttus_Config2__Quantity__c=1;
            linObj7.Apttus_Config2__ProductId__c=prodObj.id;
            linObj7.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj7.Apttus_Config2__LineType__c = 'Product/Service';
            linObj7.Apttus_Config2__LineNumber__c = 1;
            linObj7.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj7.Apttus_Config2__ItemSequence__c = 3;
            linObj7.Apttus_Config2__NetPrice__c=10.0;            
            linObj7.Apttus_Config2__OptionPrice__c = 15.0;
            linObj7.Apttus_Config2__Frequency__c = 'Monthly';
            linObj7.Apttus_Config2__PriceType__c = 'Recurring';
            linObj7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj7.Apttus_Config2__PriceAdjustment__c=0;
            linObj7.Apttus_Config2__LineStatus__c='New';
            linObj7.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj7.APTS_Years_2_Plus_Adjustment__c ='';
            linObj7.APTS_Contract_Term__c ='2 Years';
            linObj7.Apttus_Config2__BillingFrequency__c=null;
            linObj7.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj7.APTS_Term_Type__c= 'Co-Term';
            linObj7.Apttus_Config2__SellingFrequency__c = 'Monthly';
            linObj7.Apttus_Config2__StartDate__c = System.Today();
            linObj7.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj7.Apttus_Config2__NetUnitPrice__c =200;                     
            linObj7.Apttus_Config2__NetPrice__c = 1200;
            linObj7.Apttus_Config2__SellingTerm__c = 6.00;
            ListOfLineItems1.add(linObj7);
            
            Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c();
            linObj8.Apttus_Config2__Quantity__c=1;
            linObj8.Apttus_Config2__ProductId__c=prodObj.id;
            linObj8.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj8.Apttus_Config2__LineType__c = 'Product/Service';
            linObj8.Apttus_Config2__LineNumber__c = 1;
            linObj8.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj8.Apttus_Config2__ItemSequence__c = 3;
            linObj8.Apttus_Config2__NetPrice__c=10.0;            
            linObj8.Apttus_Config2__OptionPrice__c = 15.0;
            linObj8.Apttus_Config2__Frequency__c = 'Monthly';
            linObj8.Apttus_Config2__PriceType__c = 'Recurring';
            linObj8.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj8.Apttus_Config2__PriceAdjustment__c=0;
            linObj8.Apttus_Config2__LineStatus__c='New';
            linObj8.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj8.APTS_Years_2_Plus_Adjustment__c ='';
            linObj8.APTS_Contract_Term__c ='3 Years';
            linObj8.Apttus_Config2__BillingFrequency__c=null;
            linObj8.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj8.APTS_Term_Type__c= 'Co-Term';
            linObj8.APTS_Partial_Year_Charge_Eligible__c  = 'yes';
            linObj8.Apttus_Config2__SellingFrequency__c = 'Yearly';
            linObj8.Apttus_Config2__StartDate__c = System.Today();
            linObj8.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj8.Apttus_Config2__NetUnitPrice__c =200;            
            linObj8.Apttus_Config2__NetPrice__c = 2400;
            linObj8.Apttus_Config2__SellingTerm__c = 0.8;
            ListOfLineItems1.add(linObj8);
            
            Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c();
            linObj9.Apttus_Config2__Quantity__c=1;
            linObj9.Apttus_Config2__ProductId__c=prodObj.id;
            linObj9.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj9.Apttus_Config2__LineType__c = 'Product/Service';
            linObj9.Apttus_Config2__LineNumber__c = 1;
            linObj9.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj9.Apttus_Config2__ItemSequence__c = 3;
            linObj9.Apttus_Config2__NetPrice__c=10.0;            
            linObj9.Apttus_Config2__OptionPrice__c = 15.0;
            linObj9.Apttus_Config2__Frequency__c = 'Monthly';
            linObj9.Apttus_Config2__PriceType__c = 'Recurring';
            linObj9.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj9.Apttus_Config2__PriceAdjustment__c=0;
            linObj9.Apttus_Config2__LineStatus__c='Renewed';
            linObj9.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj9.APTS_Years_2_Plus_Adjustment__c ='';
            linObj9.APTS_Contract_Term__c ='1 Year';
            linObj9.Apttus_Config2__BillingFrequency__c=null;
            linObj9.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj9.APTS_Term_Type__c= 'Co-Term';
            linObj9.Apttus_Config2__SellingFrequency__c = 'Monthly';
            linObj9.Apttus_Config2__AdjustmentType__c = 'Price Override';
            linObj9.Apttus_Config2__StartDate__c = System.Today();
            linObj9.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj9.Apttus_Config2__NetUnitPrice__c = 200;
            linObj9.Apttus_Config2__NetPrice__c = 1200;
            linObj9.Apttus_Config2__SellingTerm__c = 6.00;
            ListOfLineItems1.add(linObj9);
            
            Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c();
            linObj10.Apttus_Config2__Quantity__c=1;
            linObj10.Apttus_Config2__ProductId__c=prodObj.id;
            linObj10.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj10.Apttus_Config2__LineType__c = 'Product/Service';
            linObj10.Apttus_Config2__LineNumber__c = 1;
            linObj10.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj10.Apttus_Config2__ItemSequence__c = 3;
            linObj10.Apttus_Config2__NetPrice__c=10.0;            
            linObj10.Apttus_Config2__OptionPrice__c = 15.0;
            linObj10.Apttus_Config2__Frequency__c = 'Monthly';
            linObj10.Apttus_Config2__PriceType__c = 'Recurring';
            linObj10.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj10.Apttus_Config2__PriceAdjustment__c=0;
            linObj10.Apttus_Config2__LineStatus__c='New';
            linObj10.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj10.APTS_Years_2_Plus_Adjustment__c ='';
            linObj10.APTS_Contract_Term__c ='2 Years';
            linObj10.Apttus_Config2__BillingFrequency__c=null;
            linObj10.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj10.APTS_Term_Type__c= 'Co-Term';
            linObj10.Apttus_Config2__SellingFrequency__c = 'Monthly';
            linObj10.Apttus_Config2__StartDate__c = System.Today();
            linObj10.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj10.Apttus_Config2__NetUnitPrice__c =200;                     
            linObj10.Apttus_Config2__NetPrice__c = 1200;
            linObj10.Apttus_Config2__SellingTerm__c = 6.00;
            linObj10.APTS_Yr_2_Amount__c =10;
            linObj10.APTS_Calculated_Year_3__c=100;
            ListOfLineItems1.add(linObj10);
            
            Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c();
            linObj11.Apttus_Config2__Quantity__c=1;
            linObj11.Apttus_Config2__ProductId__c=prodObj.id;
            linObj11.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj11.Apttus_Config2__LineType__c = 'Product/Service';
            linObj11.Apttus_Config2__LineNumber__c = 1;
            linObj11.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj11.Apttus_Config2__ItemSequence__c = 3;
            linObj11.Apttus_Config2__NetPrice__c=10.0;            
            linObj11.Apttus_Config2__OptionPrice__c = 15.0;
            linObj11.Apttus_Config2__Frequency__c = 'Monthly';
            linObj11.Apttus_Config2__PriceType__c = 'Recurring';
            linObj11.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj11.Apttus_Config2__PriceAdjustment__c=0;
            linObj11.Apttus_Config2__LineStatus__c='New';
            linObj11.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj11.APTS_Years_2_Plus_Adjustment__c ='';
            linObj11.APTS_Contract_Term__c ='3 Years';
            linObj11.Apttus_Config2__BillingFrequency__c=null;
            linObj11.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj11.APTS_Term_Type__c= 'Co-Term';
            linObj11.APTS_Partial_Year_Charge_Eligible__c  = 'yes';
            linObj11.Apttus_Config2__SellingFrequency__c = 'Yearly';
            linObj11.Apttus_Config2__StartDate__c = System.Today();
            linObj11.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj11.Apttus_Config2__NetUnitPrice__c =200;            
            linObj11.Apttus_Config2__NetPrice__c = 2400;
            linObj11.Apttus_Config2__SellingTerm__c = 0.8;
            linObj11.APTS_Yr_3_Amount__c= 10;
            linObj11.APTS_Yr_2_Amount__c= 10;
            linObj11.APTS_Calculated_Year_4__c=200;
            ListOfLineItems1.add(linObj11);
            
            Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c();
            linObj12.Apttus_Config2__Quantity__c=1;
            linObj12.Apttus_Config2__ProductId__c=prodObj.id;
            linObj12.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj12.Apttus_Config2__LineType__c = 'Product/Service';
            linObj12.Apttus_Config2__LineNumber__c = 1;
            linObj12.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj12.Apttus_Config2__ItemSequence__c = 3;
            linObj12.Apttus_Config2__NetPrice__c=10.0;            
            linObj12.Apttus_Config2__OptionPrice__c = 15.0;
            linObj12.Apttus_Config2__Frequency__c = 'Monthly';
            linObj12.Apttus_Config2__PriceType__c = 'Recurring';
            linObj12.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj12.Apttus_Config2__PriceAdjustment__c=0;
            linObj12.Apttus_Config2__LineStatus__c='Renewed';
            linObj12.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj12.APTS_Years_2_Plus_Adjustment__c ='';
            linObj12.APTS_Contract_Term__c ='1 Year';
            linObj12.Apttus_Config2__BillingFrequency__c=null;
            linObj12.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj12.APTS_Term_Type__c= 'Co-Term';
            linObj12.Apttus_Config2__SellingFrequency__c = 'Monthly';
            linObj12.Apttus_Config2__AdjustmentType__c = 'Price Override';
            linObj12.Apttus_Config2__StartDate__c = System.Today();
            linObj12.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj12.Apttus_Config2__NetUnitPrice__c = 200;
            linObj12.Apttus_Config2__NetPrice__c = 1200;
            linObj12.Apttus_Config2__SellingTerm__c = 6.00;
            //linObj12.APTS_Yr_3_Amount__c= 10;
            linObj12.APTS_Calculated_Year_3__c=10;
            ListOfLineItems1.add(linObj12);
            
            Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c();
            linObj13.Apttus_Config2__Quantity__c=1;
            linObj13.Apttus_Config2__ProductId__c=prodObj.id;
            linObj13.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj13.Apttus_Config2__LineType__c = 'Product/Service';
            linObj13.Apttus_Config2__LineNumber__c = 1;
            linObj13.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj13.Apttus_Config2__ItemSequence__c = 3;
            linObj13.Apttus_Config2__NetPrice__c=10.0;            
            linObj13.Apttus_Config2__OptionPrice__c = 15.0;
            linObj13.Apttus_Config2__Frequency__c = 'Monthly';
            linObj13.Apttus_Config2__PriceType__c = 'Recurring';
            linObj13.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj13.Apttus_Config2__PriceAdjustment__c=0;
            linObj13.Apttus_Config2__LineStatus__c='New';
            linObj13.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj13.APTS_Years_2_Plus_Adjustment__c ='';
            linObj13.APTS_Contract_Term__c ='4 Years';
            linObj13.Apttus_Config2__BillingFrequency__c=null;
            linObj13.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj13.APTS_Term_Type__c= 'Co-Term';
            linObj13.Apttus_Config2__SellingFrequency__c = 'Monthly';
            linObj13.Apttus_Config2__StartDate__c = System.Today();
            linObj13.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj13.Apttus_Config2__NetUnitPrice__c =200;                     
            linObj13.Apttus_Config2__NetPrice__c = 1200;
            linObj13.Apttus_Config2__SellingTerm__c = 6.00;
            ListOfLineItems1.add(linObj13);
            
            Apttus_Config2__LineItem__c linObj14 = new Apttus_Config2__LineItem__c();
            linObj14.Apttus_Config2__Quantity__c=1;
            linObj14.Apttus_Config2__ProductId__c=prodObj.id;
            linObj14.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj14.Apttus_Config2__LineType__c = 'Product/Service';
            linObj14.Apttus_Config2__LineNumber__c = 1;
            linObj14.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj14.Apttus_Config2__ItemSequence__c = 3;
            linObj14.Apttus_Config2__NetPrice__c=10.0;            
            linObj14.Apttus_Config2__OptionPrice__c = 15.0;
            linObj14.Apttus_Config2__Frequency__c = 'Monthly';
            linObj14.Apttus_Config2__PriceType__c = 'Recurring';
            linObj14.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj14.Apttus_Config2__PriceAdjustment__c=0;
            linObj14.Apttus_Config2__LineStatus__c='New';
            linObj14.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj14.APTS_Years_2_Plus_Adjustment__c ='';
            linObj14.APTS_Contract_Term__c ='4 Years';
            linObj14.Apttus_Config2__BillingFrequency__c=null;
            linObj14.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj14.APTS_Term_Type__c= 'Co-Term';
            linObj14.APTS_Partial_Year_Charge_Eligible__c  = 'yes';
            linObj14.Apttus_Config2__SellingFrequency__c = 'Yearly';
            linObj14.Apttus_Config2__StartDate__c = System.Today();
            linObj14.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj14.Apttus_Config2__NetUnitPrice__c =200;            
            linObj14.Apttus_Config2__NetPrice__c = 2400;
            linObj14.Apttus_Config2__SellingTerm__c = 0.8;
            ListOfLineItems1.add(linObj14);

Apttus_Config2__LineItem__c linObj15 = new Apttus_Config2__LineItem__c();
            linObj15.Apttus_Config2__Quantity__c=1;
            linObj15.Apttus_Config2__ProductId__c=prodObj.id;
            linObj15.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj15.Apttus_Config2__LineType__c = 'Product/Service';
            linObj15.Apttus_Config2__LineNumber__c = 1;
            linObj15.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj15.Apttus_Config2__ItemSequence__c = 3;
            linObj15.Apttus_Config2__NetPrice__c=10.0;            
            linObj15.Apttus_Config2__OptionPrice__c = 15.0;
            linObj15.Apttus_Config2__Frequency__c = 'Monthly';
            linObj15.Apttus_Config2__PriceType__c = 'Recurring';
            linObj15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj15.Apttus_Config2__PriceAdjustment__c=0;
            linObj15.Apttus_Config2__LineStatus__c='New';
            linObj15.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj15.APTS_Years_2_Plus_Adjustment__c ='';
            linObj15.APTS_Contract_Term__c ='4 Years';
            linObj15.Apttus_Config2__BillingFrequency__c=null;
            linObj15.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj15.APTS_Term_Type__c= 'Co-Term';
            linObj15.Apttus_Config2__SellingFrequency__c = 'Monthly';
            linObj15.Apttus_Config2__StartDate__c = System.Today();
            linObj15.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj15.Apttus_Config2__NetUnitPrice__c =200;                     
            linObj15.Apttus_Config2__NetPrice__c = 1200;
            linObj15.Apttus_Config2__SellingTerm__c = 6.00;
            linObj15.APTS_Yr_2_Amount__c =10;
            linObj15.APTS_Yr_3_Amount__c =10;
            linObj15.APTS_Yr_4_Amount__c =10;
            linObj15.APTS_Calculated_Year_5__c =100;
            ListOfLineItems1.add(linObj15);
            
            Apttus_Config2__LineItem__c linObj16 = new Apttus_Config2__LineItem__c();
            linObj16.Apttus_Config2__Quantity__c=1;
            linObj16.Apttus_Config2__ProductId__c=prodObj.id;
            linObj16.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj16.Apttus_Config2__LineType__c = 'Product/Service';
            linObj16.Apttus_Config2__LineNumber__c = 1;
            linObj16.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj16.Apttus_Config2__ItemSequence__c = 3;
            linObj16.Apttus_Config2__NetPrice__c=10.0;            
            linObj16.Apttus_Config2__OptionPrice__c = 15.0;
            linObj16.Apttus_Config2__Frequency__c = 'Monthly';
            linObj16.Apttus_Config2__PriceType__c = 'Recurring';
            linObj16.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj16.Apttus_Config2__PriceAdjustment__c=0;
            linObj16.Apttus_Config2__LineStatus__c='New';
            linObj16.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj16.APTS_Years_2_Plus_Adjustment__c ='';
            linObj16.APTS_Contract_Term__c ='5 Years';
            linObj16.Apttus_Config2__BillingFrequency__c=null;
            linObj16.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj16.APTS_Term_Type__c= 'Co-Term';
            linObj16.APTS_Partial_Year_Charge_Eligible__c  = 'yes';
            linObj16.Apttus_Config2__SellingFrequency__c = 'Yearly';
            linObj16.Apttus_Config2__StartDate__c = System.Today();
            linObj16.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj16.Apttus_Config2__NetUnitPrice__c =200;            
            linObj16.Apttus_Config2__NetPrice__c = 2400;
            linObj16.Apttus_Config2__SellingTerm__c = 0.8;
            linObj16.APTS_Yr_2_Amount__c =10;
            linObj16.APTS_Yr_3_Amount__c =10;
            linObj16.APTS_Yr_4_Amount__c =10;
            linObj16.APTS_Yr_5_Amount__c= 10;
            ListOfLineItems1.add(linObj16);
            
            Apttus_Config2__LineItem__c linObj17 = new Apttus_Config2__LineItem__c();
            linObj17.Apttus_Config2__Quantity__c=1;
            linObj17.Apttus_Config2__ProductId__c=prodObj.id;
            linObj17.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj17.Apttus_Config2__LineType__c = 'Product/Service';
            linObj17.Apttus_Config2__LineNumber__c = 1;
            linObj17.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj17.Apttus_Config2__ItemSequence__c = 3;
            linObj17.Apttus_Config2__NetPrice__c=10.0;            
            linObj17.Apttus_Config2__OptionPrice__c = 15.0;
            linObj17.Apttus_Config2__Frequency__c = 'Monthly';
            linObj17.Apttus_Config2__PriceType__c = 'Recurring';
            linObj17.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj17.Apttus_Config2__PriceAdjustment__c=0;
            linObj17.Apttus_Config2__LineStatus__c='New';
            linObj17.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj17.APTS_Years_2_Plus_Adjustment__c ='';
            linObj17.APTS_Contract_Term__c ='5 Years';
            linObj17.Apttus_Config2__BillingFrequency__c=null;
            linObj17.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj17.APTS_Term_Type__c= 'Co-Term';
            linObj17.APTS_Partial_Year_Charge_Eligible__c  = 'yes';
            linObj17.Apttus_Config2__SellingFrequency__c = 'Yearly';
            linObj17.Apttus_Config2__StartDate__c = System.Today();
            linObj17.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj17.Apttus_Config2__NetUnitPrice__c =200;            
            linObj17.Apttus_Config2__NetPrice__c = 2400;
            linObj17.Apttus_Config2__SellingTerm__c = 0.8;
            ListOfLineItems1.add(linObj17);
            
            Apttus_Config2__LineItem__c linObj18 = new Apttus_Config2__LineItem__c();
            linObj18.Apttus_Config2__Quantity__c=1;
            linObj18.Apttus_Config2__ProductId__c=prodObj.id;
            linObj18.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj18.Apttus_Config2__LineType__c = 'Product/Service';
            linObj18.Apttus_Config2__LineNumber__c = 1;
            linObj18.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj18.Apttus_Config2__ItemSequence__c = 3;
            linObj18.Apttus_Config2__NetPrice__c=10.0;            
            linObj18.Apttus_Config2__OptionPrice__c = 15.0;
            linObj18.Apttus_Config2__Frequency__c = 'Monthly';
            linObj18.Apttus_Config2__PriceType__c = 'Recurring';
            linObj18.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            linObj18.Apttus_Config2__PriceAdjustment__c=0;
            linObj18.Apttus_Config2__LineStatus__c='Renewed';
            linObj18.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj18.APTS_Years_2_Plus_Adjustment__c ='';
            linObj18.APTS_Contract_Term__c ='5 Years';
            linObj18.Apttus_Config2__BillingFrequency__c=null;
            linObj18.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            linObj18.Apttus_Config2__SellingFrequency__c = 'Yearly';
            linObj18.Apttus_Config2__StartDate__c = System.Today();
            linObj18.Apttus_Config2__EndDate__c = System.Today() + 365;
            linObj18.Apttus_Config2__NetUnitPrice__c =200;            
            linObj18.Apttus_Config2__NetPrice__c = 2400;
            linObj18.Apttus_Config2__SellingTerm__c = 0.8;
            linObj18.Apttus_Config2__AdjustmentType__c = 'Price Override';
            ListOfLineItems1.add(linObj18);
 
            
             /*Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
               linObj3.Apttus_Config2__Quantity__c=1;
                linObj3.Apttus_Config2__ProductId__c=prodObj.id;
                linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id; 
                linObj3.Apttus_Config2__LineType__c = 'Product/Service';
                linObj3.Apttus_Config2__LineStatus__c='New';
                linObj3.Apttus_Config2__LineNumber__c = 1; 
                linObj3.Apttus_Config2__ItemSequence__c = 3;
               // Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
                linObj3.Apttus_Config2__NetPrice__c=10.0;
                linObj3.Apttus_Config2__BasePrice__c=10.0;
                linObj3.Apttus_Config2__BaseExtendedPrice__c = 10.0;
                linObj3.Apttus_Config2__AdjustedPrice__c = 10.0;
                linObj3.Apttus_Config2__ExtendedPrice__c = 3.0;
                linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
                linObj3.Apttus_Config2__OptionPrice__c = 15.0;
                linObj3.Apttus_Config2__Frequency__c = 'Monthly';
                linObj3.Apttus_Config2__PriceType__c = 'Recurring'; 
                linObj3.Apttus_Config2__PriceAdjustment__c=0;
                linObj3.APTS_Contract_Term__c ='3 Years';
                linObj3.APTS_Years_2_Plus_Adjustment__c = '4';
                linObj3.APTS_Keep_Terms__c =false;
                linObj3.Apttus_Config2__BillingFrequency__c = 'Monthly';
                linObj3.Apttus_Config2__PriceListItemId__c = pliSO.id; 
                ListOfLineItems1.add(linObj3);*/
        
           
            insert ListOfLineItems1;
            
            
           
        
        //Apttus_Proposal__Proposal__c proposal1=[Select id,name,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Opportunity__c,APTS_SSD_bill_to__r.Source_System_Account_Number__c,APTS_SSD_ship_to__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c from Apttus_Proposal__Proposal__c limit 1 ];
          
         Test.startTest();          
        priceCartLines(prodConfig.ID);   
        APTS_TaxProf_PricingCallbackMethods.contractTermMapping('5 Years');
        APTS_TaxProf_PricingCallbackMethods.contractTermMapping('3 Years');
        APTS_TaxProf_PricingCallbackMethods.contractTermMapping('2 Years');
        Test.stopTest();
    }

}