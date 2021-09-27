@isTest
public class APTS_CORP_PricingCallbackMethods_Test {

private static void priceCartLines(ID cartID) 
    {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
    }
    @isTest static void testMethodtwo() {
      
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
        
        /*Profile_List__c profileInfo=new Profile_List__c(ProfileId__c='00ea00000024JzKAAU',Profile_Name__c='LatAm User',name='LatAm User');
        insert profileInfo;*/
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
        obj1.Apttus_Config2__CustomFieldNames__c = 'APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        insert customFieldsList;
             
        List<IXOSCodeMap__c> IXocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA78',Company_Code__c='1078',Dist_Chan_Code__c='T',Division_Code__c='T',Sales_Org_Code__c='TA78')};
        insert IXocodeList;

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
    
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
      
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
          prodObj.ProductCode='42533744';
          prodObj.WLEC_Product_Category__c='PS';
          prodObj.APTS_Item_Category_Group__c='ZXPS';
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
          
            insert ListOfLineItems1;
             
        
        //Apttus_Proposal__Proposal__c proposal1=[Select id,name,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Opportunity__c,APTS_SSD_bill_to__r.Source_System_Account_Number__c,APTS_SSD_ship_to__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c from Apttus_Proposal__Proposal__c limit 1 ];
          
         Test.startTest();          
        priceCartLines(prodConfig.ID);  
                
        Test.stopTest();
    }
    @isTest static void testMethodRisk() {
      
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
        
        /*Profile_List__c profileInfo=new Profile_List__c(ProfileId__c='00ea00000024JzKAAU',Profile_Name__c='LatAm User',name='LatAm User');
        insert profileInfo;*/
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj.name='Custom Field Names';
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__ProductId__r.Media_High_Level__c';
        obj1.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__ProductId__r.ProductCode';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        insert customFieldsList;
             
        List<IXOSCodeMap__c> IXocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA78',Company_Code__c='1078',Dist_Chan_Code__c='T',Division_Code__c='T',Sales_Org_Code__c='TA78')};
        insert IXocodeList;

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
        WebserviceList.Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount';
        WebserviceList.Service_Unavailable_Message__c='Service not Available';
        webserviceSettingsList.add(WebserviceList);
        insert webserviceSettingsList;
    
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
      
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        //Added
        Source_System_Detail__c accountSSD1=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD1.RecordtypeId=ssdRecorType;
        accountSSD1.Account_Inactive__c=false;
         accountSSD1.LCRM_Sales_Org__c='SMGE';
        insert accountSSD1;

        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
         
         Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        
        //Added
        Opportunity oppty1=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.Source_System_Detail__c=accountSSD1.id;
        oppty1.isdigitalSpearhead__c = False;
        insert oppty1;
                
        //Added
        Apttus_Proposal__Proposal__c proposal1 = new Apttus_Proposal__Proposal__c();
        proposal1.Apttus_Proposal__Account__c=a.id;
         proposal1.Apttus_Proposal__Opportunity__c=oppty1.id;
         proposal1.APTS_SSD_Sold_To__c=accountSSD1.id;
         proposal1.APTS_SSD_Ship_To__c=accountSSD1.id;
         proposal1.APTS_SSD_Bill_To__C=accountSSD1.id;
         proposal1.APTS_Payer__c=accountSSD1.id;
        insert proposal1;
        
        Map<String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId(); //Archana - start
        
        Product2 prodObj = new Product2();
          prodObj.Name = '1SRC ITC Essentials';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.ProductCode='42533744';
          prodObj.WLEC_Product_Category__c='PS';
          prodObj.APTS_Item_Category_Group__c='ZXPS';
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
        
       
        
        List<Apttus_Config2__ProductConfiguration__c> cartSOList = new List<Apttus_Config2__ProductConfiguration__c>();
                
        //Added
        Apttus_Config2__ProductConfiguration__c prodConfig1 = APTS_TestDataFactory.createProductConfiguration(proposal1.Id);
        prodConfig1.Apttus_Config2__BusinessObjectId__c = proposal1.Id;
        prodConfig1.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig1.APTS_SSD_bill_to__c= accountSSD1.id;
        prodConfig1.APTS_SSD_ship_to__c= accountSSD1.id; 
        prodConfig1.Apttus_Config2__AccountId__c = a.Id;
        prodConfig1.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig1.Apttus_Config2__Status__c = 'New';
        cartSOList.add(prodConfig1);
        
        insert cartSOList;
        
       
          List<Apttus_Config2__LineItem__c> ListOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
                      
            //Added
            Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__ProductId__c=prodObj.id;           
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig1.id;
            linObj3.Apttus_Config2__LineType__c = 'Product/Service';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__LineStatus__c='Renewed';
            /*linObj3.Apttus_Config2__Frequency__c = 'Monthly';*/
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c =null;
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO.id;           
            ListOfLineItems1.add(linObj3);       
           
            insert ListOfLineItems1;
             
        
        //Apttus_Proposal__Proposal__c proposal1=[Select id,name,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Opportunity__c,APTS_SSD_bill_to__r.Source_System_Account_Number__c,APTS_SSD_ship_to__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c from Apttus_Proposal__Proposal__c limit 1 ];
          
         Test.startTest();          
        
        priceCartLines(prodConfig1.ID);   
        
        Test.stopTest();
    }

}