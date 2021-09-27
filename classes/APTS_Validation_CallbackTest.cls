@isTest(seealldata=false)
private with sharing class APTS_Validation_CallbackTest {
    public static List<Apttus_Config2__LineItem__c> oLItemList;
    private static final string USL_RECORDTPYE='USL_Source_Systems';
    private static string prodFamily=null;  
    static void insertStaticValues(){
    
          LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        
        insert staticCSList ;
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
    
    }
@isTest static void testMethodNonHighQ4(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        List<APTS_Product_Rules__c > lsrules=new List<APTS_Product_Rules__c >();
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary',APTS_Max_no_of_Points__c = 10, 
        APTS_Max_no_of_Users__c = 5,APTS_Error_message_for_no_of_users__c='The maximum number of users has been exceeded',
        APTS_Error_message_for_no_of_points__c='The maximum number of points has been exceeded');
        APTS_Product_Rules__c productRule2 = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c='13AB');
        lsrules.add(productRule1 );
        lsrules.add(productRule2 );
        insert lsrules;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
        prodObj.Name = 'nonBGB';
        prodObj.APTS_Media_High_Level_Code__c = '13';
        prodObj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prodObj.Family = 'CLEAR';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        //prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';
        prodObj.APTS_Corporate_Select__c = 'Primary';
        prodObj.ProductCode = '4353545';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '13';
        prod2Obj.APTS_Media_Lower_Level_Code__c = 'AB';
        prod2Obj.ProductCode = '42686641';
        insert prod2Obj;

       /*Product2 prod3Obj = new Product2();
        prod3Obj.Name = 'Network Services 2.0';
        prod3Obj.APTS_Media_High_Level_Code__c = '13';
        prod3Obj.APTS_Product_Pricing_Model__c='Per Seat';
        prod3Obj.APTS_Media_Lower_Level_Code__c = '';
        prod3Obj.Family = 'CLEAR';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        prod3Obj.ProductCode = '41618485';
        insert prod3Obj;*/
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=3,
          Apttus_Config2__ProductId__c=prodObj.id,
          //Apttus_Config2__AttributeValueId__c= propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,          
          APTS_New_Bridge_Discount__c=50,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
         Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
      APTS_Product_Family__c='CLEAR',
            APTS_Group_Primary_Material_Name__c='PROFLEX Bundle',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
        insert oLItemList;
        Apttus_Config2__ProductAttributeValue__c a1 = new Apttus_Config2__ProductAttributeValue__c(APTS_Total_Number_of_Points__c =15,Apttus_Config2__LineItemId__c=linObj.id);
        insert a1;
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c, APTS_Product_Family__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode 
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id ];      
        System.assert(lineItemsList.size()>0);                
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();           
        Apttus_Config2__LineItem__c lin2Obj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=3,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,          
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          APTS_Product_Family__c='CLEAR',
          APTS_Group_Primary_Material_Name__c='PROFLEX Bundle',
          APTS_New_Bridge_Discount__c =100,
          Apttus_Config2__IsPrimaryLine__c =True,
          Apttus_Config2__PriceListItemId__c = pliSO.id);   
           oLItemList = new List<Apttus_Config2__LineItem__c>{lin2Obj};
           insert oLItemList;
           lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c, APTS_Product_Family__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode 
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :lin2Obj.Id ];      
                        
        Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());                                     
    }
    @isTest static void testMethodHighQ4(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        List<APTS_Product_Rules__c > lsrules=new List<APTS_Product_Rules__c >();
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary',APTS_Max_no_of_Points__c = 10, 
        APTS_Max_no_of_Users__c = 5,APTS_Error_message_for_no_of_users__c='The maximum number of users has been exceeded',
        APTS_Error_message_for_no_of_points__c='The maximum number of points has been exceeded');
        APTS_Product_Rules__c productRule2 = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c='13AB');
        lsrules.add(productRule1 );
        lsrules.add(productRule2 );
        insert lsrules;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
        prodObj.Name = 'highQ';
        prodObj.APTS_Media_High_Level_Code__c = '13';
        prodObj.APTS_Media_Lower_Level_Code__c = '';
        prodObj.Family = 'HIGHQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        prodObj.ProductCode = '4353545';
        insert prodObj; 
        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Proflex Product';
        prodObj.Family = 'HIGHQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP';
        prod2Obj.APTS_Media_High_Level_Code__c = '13';
        prod2Obj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prod2Obj.ProductCode = '41972767';
        insert prod2Obj;        

        
        /*Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;*/
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=3,
          Apttus_Config2__ProductId__c=prodObj.id,
          //Apttus_Config2__AttributeValueId__c= propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,          
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
         Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          APTS_Group_Primary_Material_Name__c='PROFLEX Bundle',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
          Apttus_Config2__LineItem__c lin2Obj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=3,
          Apttus_Config2__ProductId__c=prod2Obj.id,
          //Apttus_Config2__AttributeValueId__c= propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,          
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
         Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
         APTS_Group_Primary_Material_Name__c='PROFLEX Bundle',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
        insert oLItemList;
        Apttus_Config2__ProductAttributeValue__c a1 = new Apttus_Config2__ProductAttributeValue__c(APTS_Total_Number_of_Points__c =15,Apttus_Config2__LineItemId__c=linObj.id);
        insert a1;
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        
        
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c, APTS_Product_Family__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode 
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id or Id = :lin2Obj.Id ];      
        System.assert(lineItemsList.size()>0);                
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();  
        }         
        @isTest static void testMethodCanada(){  
        Map<String, Decimal> productsQuantity = new Map<String, Decimal>();     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');       
        insert priceList;       
                
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();       
        bundlePageSettings.Name = 'Bundle Page Properties';     
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';        
        insert bundlePageSettings;      
                
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');      
        insert productRule;     
                
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);       
        insert productRule1;        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();        
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';        
        oWebServiceSettings.Name = 'PaymentCreditIncrease';         
        oWebServiceSettings.Timeout__c = 120;       
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';       
        oWebServiceSettings.Active__c = true;       
        insert oWebServiceSettings;     
        Account a = APTS_TestDataFactory.createAccount('Test Account');     
        insert a;       
        System.AssertEquals(a.Name, 'Test Account');        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
                
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();       
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);     
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
                
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);       
       // insert ssd;       
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);       
        proposal.APTS_Proposal_Business_Unit__c = 'Canada';         
        insert proposal;        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);      
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;       
        insert prodConfig;      
        ID cartID = prodConfig.Id;      
        Product2 prodObj = new Product2();      
          prodObj.Name = 'Network Services 1.0'; 
         // prodObj.ProductCode='30913488';      
          prodObj.APTS_Media_High_Level_Code__c = '08';     
         prodObj.APTS_Media_Lower_Level_Code__c = 'BB';     
          prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';       
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';      
          insert prodObj;       
          Product2 prod2Obj = new Product2();       
          prod2Obj.Name = 'Network Services 2.0';       
          prod2Obj.APTS_Media_High_Level_Code__c = '07';        
          prod2Obj.APTS_Product_Pricing_Model__c='BENEFITGRP';      
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';       
           insert prod2Obj;     
          
          
        prodFamily='BENEFITGRP';        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();      
                
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=12,      
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,       
          APTS_Corporate_Select__c = 'Primary', 
          Apttus_Proposal__Proposal__c=proposal.id);        
          Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=1,       
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,
         
          APTS_Corporate_Select__c = 'Primary Essentials',      
          Apttus_Proposal__Proposal__c=proposal.id);        
        lstPLIs.add(pl1);       
        lstPLIs.add(pl2);       
        insert lstPLIs;     
         System.debug('Proposallineitemlist...'+lstPLIs);       
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();     
        System.debug('ProposalAttrrList...'+lstPropAttr);       
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',      
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));      
        insert asset;       
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
         
        APTS_Group__c proposalGroup =new APTS_Group__c();       
       proposalGroup.APTS_GrossAmount__c = 0;       
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';     
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';      
       proposalGroup.APTS_NetAmount__c=0;       
       insert proposalGroup;        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group',        
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 1,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup1;      
                    
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(       
          APTS_Deal_Number__c=124578945,        
          Apttus_Config2__Quantity__c=13,       
          Apttus_Config2__ProductId__c=prod2Obj.id,     
           // Apttus_Config2__AttributeValueId__c = propattr.id,        
          Apttus_Config2__ConfigurationId__c = prodConfig.id,       
          Apttus_Config2__LineType__c = 'Product/Service',      
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,     
          Apttus_Config2__LineNumber__c = 1,        
          Apttus_Config2__ItemSequence__c = 1,      
          Apttus_Config2__NetPrice__c=10.0,     
          Apttus_Config2__BasePrice__c=10.0,        
          Apttus_Config2__BaseExtendedPrice__c = 10.0,      
          Apttus_Config2__AdjustedPrice__c = 10.0,      
          Apttus_Config2__OptionPrice__c = 5.0,     
          Apttus_Config2__Frequency__c = 'Monthly',     
          Apttus_Config2__PriceType__c = 'Recurring',       
          Apttus_Config2__PriceAdjustment__c=0,     
          APTS_Contract_Term__c ='3 Years',     
          APTS_Years_2_Plus_Adjustment__c='1',      
          APTS_Proposal_Group__c = proposalGroup.Id,        
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,     
          Apttus_Config2__ChargeType__c = 'Subscription Fee',               
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage   
          Apttus_Config2__PriceListItemId__c = pliSO.id);       
                
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group 2',      
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 2,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup2;      
                
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(      
            APTS_Deal_Number__c=124578945,      
            Apttus_Config2__Quantity__c=4,      
            Apttus_Config2__ProductId__c=prodObj.id,        
            Apttus_Config2__ConfigurationId__c = prodConfig.id,         
            Apttus_Config2__LineNumber__c = 2,      
            Apttus_Config2__ItemSequence__c = 2,        
            Apttus_Config2__NetPrice__c=10.0,       
            Apttus_Config2__BasePrice__c=10.0,      
            Apttus_Config2__BaseExtendedPrice__c = 10.0,        
            Apttus_Config2__AdjustedPrice__c = 10.0,        
            Apttus_Config2__LineStatus__c = 'New',      
            Apttus_Config2__Frequency__c = 'Monthly',       
            Apttus_Config2__PriceType__c = 'Recurring',         
            Apttus_Config2__PriceAdjustment__c=0,       
            APTS_Contract_Term__c ='3 Years',       
            APTS_Proposal_Group__c = proposalGroup.Id,      
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,       
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee', 
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;      
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,        
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c, APTS_Bundle__c,    
                                     APTS_Years_2_Plus_Default__c,Apttus_Config2__BillingFrequency__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode                 
                                     FROM Apttus_Config2__LineItem__c       
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);             
                                
        Test.startTest();       
         Apttus_Config2.CallbackTester.testValidationCallback       
                                              ( cartID      
                                              , lineItemsList       
                                              , null        
                                              , new APTS_Validation_Callback ());           
         /*linObj2.Apttus_Config2__Quantity__c=5;
         update  linObj2;
         Apttus_Config2.CallbackTester.testValidationCallback       
                                              ( cartID      
                                              , lineItemsList       
                                              , null        
                                              , new APTS_Validation_Callback ()); */
         prodObj.apts_cat_l2__c=Label.APTS_HighQ_Product_Family;
         update prodObj;   
         Apttus_Config2.CallbackTester.testValidationCallback       
                                              ( cartID      
                                              , lineItemsList       
                                              , null        
                                              , new APTS_Validation_Callback ());                                        
        Test.stopTest();                                                    
    }
     @isTest static void testMethodCanada1(){
        //For DOC-3725
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Canada'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'BGB';
          prodObj.APTS_Media_High_Level_Code__c = '06';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          //prodObj.APTS_Cat_L2__c='L2_L045_FP';
          //prodObj.Family='PRINT LEGAL SOLUTIONS';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Product_Pricing_Model__c='Banded';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
           insert prod2Obj;
        
          Product2 prod3Obj = new Product2();
          prod3Obj.Name = 'Network Services 2.0';
          prod3Obj.APTS_Media_High_Level_Code__c = '07';
          prod3Obj.APTS_Product_Pricing_Model__c='Per Seat';
          prod3Obj.APTS_Media_Lower_Level_Code__c = 'BB';
           insert prod3Obj;
        prodFamily='BENEFITGRP';
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
                  
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prod3Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,APTS_Cat_L2__c,APTS_Cat_L3__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id ];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodOne(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS';        
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';

          insert prod2Obj;    

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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=7,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

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
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prod2Obj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert oLItemList;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodTwo(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
        
       // Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
        insert prod2Obj;

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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


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
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
        //Added by Sakshi for test coverage
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          APTS_Group_Primary_Material_Name__c = 'PROFLEX',
          Apttus_Config2__PriceListItemId__c = pliSO.id);

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
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1,linObj2};
            
        insert oLItemList;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());  
        Test.stopTest();
        
        
    }
    
    
    
    @isTest static void testMethodThree(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
         prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
        insert prod2Obj;
        Test.startTest();
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essential',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;
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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
     @isTest static void testMethodFour(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
       insertStaticValues();
       
       WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        //Inserting SSd Object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        //Inserting Opportunity Object
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        
        ID cartID = prodConfig.Id;
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          insert prodObj;  
          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
        insert prod2Obj;
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essential',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id, APTS_Info_PlanType__c='S00', Apttus_Config2__AssetStatus__c='Activated', APTS_Deal_Type__c='WCMP', APTS_Subscription_Number__c ='40666561',APTS_Deal_Number__c= 1234);  //Added by Sakshi for code coverage
        insert asset;
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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

        
         Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=7,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          APTS_Group_Primary_Material_Name__c = 'PROFLEX',   //test Coverage - Pratheeksha        
          Apttus_Config2__PriceListItemId__c = pliSO.id);
         
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
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c ,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodFive(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        //Inserting SSd Object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        //Inserting Opportunity Object
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id; 
        insert prodConfig;
        ID cartID = prodConfig.Id;
         Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          insert prodObj;  
          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
        insert prod2Obj;
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
         Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

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
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert oLItemList;
         List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c ,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];  
         System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest(); 
    }
    @isTest static void testMethodSix(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        //Inserting SSd Object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        //Inserting Opportunity Object
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '072Q');      
        insert productRule; 
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.ProductCode = '30790796';
          insert prodObj;  
          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';
          insert prod2Obj;    
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
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
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',
          Apttus_Config2__IsPrimaryLine__c = TRUE,         
          Apttus_Config2__PriceListItemId__c = pliSO.id); 
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
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prod2Obj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        /*
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prod2Obj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            APTS_New_Bridge_Discount__c = 123.123,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceType__c = 'One Time',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
        insert linObj3;
*/
       APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ()); 
        
        Test.stopTest();                                              
    }
    
   //Added by Sakshi for ValidationCallbackHelperclass SOC-4570 and SOC-6515
@isTest static void testMethodSevenFL(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';

          insert prod2Obj;    

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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=3,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 
        
    //  FirmSiteVSPPC__c fsp = new FirmSiteVSPPC__c();
    
        List<FirmSiteVSPPC__c> fsp = new List<FirmSiteVSPPC__c>();
        FirmSiteVSPPC__c firmsiteProdFamily1 = new FirmSiteVSPPC__c();
        firmsiteProdFamily1.name = 'Number1';
        firmsiteProdFamily1.Product_Family__c = 'Firmsite';
        fsp.add(firmsiteProdFamily1);
        
        FirmSiteVSPPC__c firmsiteProdFamily2 = new FirmSiteVSPPC__c();
        firmsiteProdFamily2.name = 'Number2';
        firmsiteProdFamily2.Product_Family__c = 'PPC';
        fsp.add(firmsiteProdFamily2);
        
        insert fsp;
            
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;


        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__OptionId__c = prod2Obj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert oLItemList;
        
        Apttus_Config2__ProductAttributeValue__c prodAttrVal = new Apttus_Config2__ProductAttributeValue__c(
            APTS_PPC_Type__c = 'New PPC',
            APTS_PPC_Language_Selection__c = 'English',
            APTS_PPC_Website_Selection__c = 'FirmSite or FindLaw Landing Page Hosting',
            Apttus_Config2__LineItemId__c = linObj.ID,
            APTS_Total_Number_of_Points__c=12
        );
            insert prodAttrVal;
        
        Apttus_Config2__ProductAttributeValue__c prodAttrVal1 = new Apttus_Config2__ProductAttributeValue__c(
            APTS_PPC_Type__c = 'New PPC',
            APTS_PPC_Language_Selection__c = 'Español',
            APTS_PPC_Website_Selection__c = 'FirmSite or FindLaw Landing Page Hosting',
            Apttus_Config2__LineItemId__c = linObj2.ID,
            APTS_Total_Number_of_Points__c = 13
        );
            insert prodAttrVal1;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c ,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethod3825(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          //prodObj.APTS_Media_High_Level_Code__c = '06';
          //prodObj.Family = 'PRINT';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '13';
          prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';

          insert prod2Obj;    

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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;        
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          //APTS_New_Bridge_Discount__c = 3.3,
          //Apttus_Config2__LineStatus__c = 'Renewed',
          
          //APTS_Media_Lower_Level_Code__c = 'SS',
          //APTS_Keep_Terms__c = True,
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          //Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;

        
 
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            //APTS_Group_Primary_Material_Name__c='PROFLEX',
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert oLItemList;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
@isTest static void testMethod38251(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          //prodObj.APTS_Media_High_Level_Code__c = '06';
          //prodObj.Family = 'PRINT';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          //prod2Obj.APTS_Media_High_Level_Code__c = '13';
         prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';

          insert prod2Obj; 
          Product2 prod3Obj = new Product2();
          prod3Obj.Name = 'Network Services 3.0';
          //prod2Obj.APTS_Media_High_Level_Code__c = '13';
          prod3Obj.APTS_Media_Lower_Level_Code__c = '2Q';

          insert prod3Obj;   

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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;        
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod3Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656552',
        APTS_Deal_Type__c='WCMP',APTS_Deal_Number__c=124578945, Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset1;  
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          //APTS_New_Bridge_Discount__c = 3.3,
          //Apttus_Config2__LineStatus__c = 'Renewed',
          
          //APTS_Media_Lower_Level_Code__c = 'SS',
          //APTS_Keep_Terms__c = True,
          //APTS_Group_Primary_Material_Name__c = 'PROFLEX',
          //APTS_Is_Special_Offer_Lapsed__c = True,
          Apttus_Config2__AssetLineItemId__c = asset.Id,
         // APTS_Group__c = 'Bundle',
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = NULL,
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;

        
 
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            //APTS_Group_Primary_Material_Name__c='PROFLEX',
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = NULL,
            Apttus_Config2__OptionId__c = prod2Obj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
             
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            APTS_Group_Primary_Material_Name__c='PROFLEX',
            Apttus_Config2__AssetLineItemId__c = asset.Id,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = NULL,
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            //APTS_Proposal_Group__c = proposalGroup.Id,
            //APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            //APTS_Group_Primary_Material_Name__c='PROFLEX',
            Apttus_Config2__AssetLineItemId__c = asset1.Id,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod3Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = NULL,
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Amended',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2,linObj3,linObj4};
            
        insert oLItemList;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodCORP(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
       List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User corpUser1=new User(username='testuser23@acme1.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser@tcs.com',
        Sub_Bu__c='US',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='USL');
        insert corpUser1;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(corpUser1) {
        insert proposal;
            }    

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'Yes';                                              
        insert prodObj;  

        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       
        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
        proposalGroup.APTS_Group_Name__c ='Print Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        insert proposalGroup;

        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=7,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',   
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

        insert linObj;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                      APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Bundle__c,
                                      Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c,
                                      APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode 
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodCORPEvergreen(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User corpUser=new User(username='testuser123@acme1.com',
        lastname='tstuser',
        Alias='tstuser',
        Email='testuser1@tcs.com',
        Sub_Bu__c='US',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Default_Catalog__c ='USL');
        insert corpUser;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';    
        System.runAs(corpUser) {
        insert proposal;
            }    

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
        prodObj.APTS_Availability_Date__c= Date.newInstance(2018, 1, 1);   
        prodObj.APTS_FL_Renewal_Only_Clone__c = 'No';                                              
        insert prodObj; 

        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;

        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
        proposalGroup.APTS_Group_Name__c ='Print Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        insert proposalGroup;

        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=7,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',   
          APTS_Renewal_Type__c = 'Evergreen',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

          insert linObj;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                                      APTS_Proposal_Group__c,APTS_Renewal_Type__c,APTS_Bundle__c,
                                      Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term__c,APTS_Contract_Term_Number__c,
                                      APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }

    @isTest static void testMethod6397(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'SUPER LAWYERS TOPSPOT';
          prodObj.APTS_Media_Lower_Level_Code__c = 'F8';
          //prodObj.APTS_Media_High_Level_Code__c = '06';
          //prodObj.Family = 'PRINT';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'SUPER LAWYERS ROTATING TOPSPOT';
          //prod2Obj.APTS_Media_High_Level_Code__c = '13';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'F8';

          insert prod2Obj;    

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

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


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
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          //Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;

        
 
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            //APTS_Group_Primary_Material_Name__c='PROFLEX',
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert oLItemList;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
 
 @isTest static void testCanada2(){
         Map<String, Decimal> productsQuantity = new Map<String, Decimal>();     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');       
        insert priceList;       
                
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();       
        bundlePageSettings.Name = 'Bundle Page Properties';     
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';        
        insert bundlePageSettings;      
                
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');      
        insert productRule;  
        
        APTS_Product_Rules__c productRule2 = new APTS_Product_Rules__c(name='2',APTS_Same_Material_on_Account__c = '07BB');      
        insert productRule2;   
                
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5, APTS_Same_Material_on_Account__c = '07BB');       
        insert productRule1;        
        
        insertStaticValues();
       
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();        
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';        
        oWebServiceSettings.Name = 'PaymentCreditIncrease';         
        oWebServiceSettings.Timeout__c = 120;       
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';       
        oWebServiceSettings.Active__c = true;       
        insert oWebServiceSettings;     
        Account a = APTS_TestDataFactory.createAccount('Test Account');     
        insert a;       
        System.AssertEquals(a.Name, 'Test Account');         
       List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
                
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();       
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);     
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;       
        insert prodConfig;      
        ID cartID = prodConfig.Id;      
        Product2 prodObj = new Product2();      
          prodObj.Name = 'Network Services 1.0';       
          prodObj.productCode = '40757482';
          prodObj.APTS_Media_High_Level_Code__c = '08';     
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';     
          prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';       
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';      
          insert prodObj;       
          Product2 prod2Obj = new Product2();       
          prod2Obj.Name = 'Network Services 2.0';
         prod2Obj.productCode = '41972767';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';        
          prod2Obj.APTS_Product_Pricing_Model__c='Banded';      
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';       
           insert prod2Obj;     
          
          
        prodFamily='BENEFITGRP';        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();      
                
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=12,      
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,       
          APTS_Corporate_Select__c = 'Primary', 
          Apttus_Proposal__Proposal__c=proposal.id);        
          Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=1,       
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,
         
          APTS_Corporate_Select__c = 'Primary Essentials',      
          Apttus_Proposal__Proposal__c=proposal.id);        
        lstPLIs.add(pl1);       
        lstPLIs.add(pl2);       
        insert lstPLIs;     
         System.debug('Proposallineitemlist...'+lstPLIs);       
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();     
        System.debug('ProposalAttrrList...'+lstPropAttr);       
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',      
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));      
        insert asset;       
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

         
        APTS_Group__c proposalGroup =new APTS_Group__c();       
       proposalGroup.APTS_GrossAmount__c = 0;       
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';     
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';      
       proposalGroup.APTS_NetAmount__c=0;       
       insert proposalGroup;        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group',        
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 1,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup1;      
                    
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(       
          APTS_Deal_Number__c=124578945,        
          Apttus_Config2__Quantity__c=13,       
          Apttus_Config2__ProductId__c=prod2Obj.id,     
           // Apttus_Config2__AttributeValueId__c = propattr.id,        
          Apttus_Config2__ConfigurationId__c = prodConfig.id,       
          Apttus_Config2__LineType__c = 'Product/Service',      
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,     
          Apttus_Config2__LineNumber__c = 1,        
          Apttus_Config2__ItemSequence__c = 1,      
          Apttus_Config2__NetPrice__c=10.0,     
          Apttus_Config2__BasePrice__c=10.0,        
          Apttus_Config2__BaseExtendedPrice__c = 10.0,      
          Apttus_Config2__AdjustedPrice__c = 10.0,      
          Apttus_Config2__OptionPrice__c = 5.0,     
          Apttus_Config2__Frequency__c = 'Monthly',     
          Apttus_Config2__PriceType__c = 'Recurring',       
          Apttus_Config2__PriceAdjustment__c=0,     
          APTS_Contract_Term__c ='3 Years',     
          APTS_Years_2_Plus_Adjustment__c='1',      
          APTS_Proposal_Group__c = proposalGroup.Id,        
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,     
          Apttus_Config2__ChargeType__c = 'Subscription Fee',               
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage   
          Apttus_Config2__PriceListItemId__c = pliSO.id);       
                
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group 2',      
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 2,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup2;      
                
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(      
            APTS_Deal_Number__c=124578945,      
            Apttus_Config2__Quantity__c=4,      
            Apttus_Config2__ProductId__c=prodObj.id,        
            Apttus_Config2__ConfigurationId__c = prodConfig.id,         
            Apttus_Config2__LineType__c = 'Option',     
            Apttus_Config2__OptionId__c = prodObj.Id,       
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,       
            Apttus_Config2__LineNumber__c = 2,      
            Apttus_Config2__ItemSequence__c = 2,        
            Apttus_Config2__NetPrice__c=10.0,       
            Apttus_Config2__BasePrice__c=10.0,      
            Apttus_Config2__BaseExtendedPrice__c = 10.0,        
            Apttus_Config2__AdjustedPrice__c = 10.0,        
            Apttus_Config2__LineStatus__c = 'New',      
            Apttus_Config2__OptionPrice__c = 5.0,       
            Apttus_Config2__Frequency__c = 'Monthly',       
            Apttus_Config2__PriceType__c = 'Recurring',         
            Apttus_Config2__PriceAdjustment__c=0,       
            APTS_Contract_Term__c ='3 Years',       
            APTS_Proposal_Group__c = proposalGroup.Id,      
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,       
            APTS_Bridge__c = '1 Month',     
            Apttus_Config2__ChargeType__c = 'Subscription Fee', 
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
          
           
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};     
        insert oLItemList;      
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,        
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,  APTS_Bundle__c,   
                                     APTS_Years_2_Plus_Default__c,Apttus_Config2__BillingFrequency__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c ,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode               
                                     FROM Apttus_Config2__LineItem__c       
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];            
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);             
                                
        Test.startTest();       
         Apttus_Config2.CallbackTester.testValidationCallback       
                                              ( cartID      
                                              , lineItemsList       
                                              , null        
                                              , new APTS_Validation_Callback ());           
        Test.stopTest();                        
}
@isTest static void testMethodCanada3(){  
        Map<String, Decimal> productsQuantity = new Map<String, Decimal>();     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');       
        insert priceList;       
                
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();       
        bundlePageSettings.Name = 'Bundle Page Properties';     
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';        
        insert bundlePageSettings;      
                
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');      
        insert productRule;     
                
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);       
        insert productRule1;        
        insertStaticValues();
       
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();        
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';        
        oWebServiceSettings.Name = 'PaymentCreditIncrease';         
        oWebServiceSettings.Timeout__c = 120;       
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';       
        oWebServiceSettings.Active__c = true;       
        insert oWebServiceSettings;     
        Account a = APTS_TestDataFactory.createAccount('Test Account');     
        insert a;       
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
                
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();       
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);     
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
                
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);       
       // insert ssd;       
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);       
        proposal.APTS_Proposal_Business_Unit__c = 'Canada';         
        insert proposal;        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);      
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;       
        insert prodConfig;      
        ID cartID = prodConfig.Id;      
        Product2 prodObj = new Product2();      
          prodObj.Name = 'SMALL FIRM PACKAGE Network Services 1.0'; 
          prodObj.ProductCode='30913488';      
          prodObj.APTS_Media_High_Level_Code__c = '06';     
         prodObj.APTS_Media_Lower_Level_Code__c = 'BB';     
          prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';       
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';      
          insert prodObj;       
          Product2 prod2Obj = new Product2();       
          prod2Obj.Name = 'SMALL FIRM PACKAGE Network Services 2.0'; 
          prodObj.ProductCode='30913500';      
          prod2Obj.APTS_Media_High_Level_Code__c = '06';        
          prod2Obj.APTS_Product_Pricing_Model__c='BENEFITGRP';      
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';       
           insert prod2Obj;     
          
          
        prodFamily='BENEFITGRP';        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();      
                
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=12,      
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,       
          APTS_Corporate_Select__c = 'Primary', 
          Apttus_Proposal__Proposal__c=proposal.id);        
          Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=1,       
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,
         
          APTS_Corporate_Select__c = 'Primary Essentials',      
          Apttus_Proposal__Proposal__c=proposal.id);        
        lstPLIs.add(pl1);       
        lstPLIs.add(pl2);       
        insert lstPLIs;     
         System.debug('Proposallineitemlist...'+lstPLIs);       
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();     
        System.debug('ProposalAttrrList...'+lstPropAttr);       
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',      
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));      
        insert asset;       
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
         
        APTS_Group__c proposalGroup =new APTS_Group__c();       
       proposalGroup.APTS_GrossAmount__c = 0;       
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';     
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';      
       proposalGroup.APTS_NetAmount__c=0;       
       insert proposalGroup;        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group',        
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 1,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup1;      
                    
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(       
          APTS_Deal_Number__c=124578945,        
          Apttus_Config2__Quantity__c=13,       
          Apttus_Config2__ProductId__c=prod2Obj.id,     
           // Apttus_Config2__AttributeValueId__c = propattr.id,        
          Apttus_Config2__ConfigurationId__c = prodConfig.id,       
          Apttus_Config2__LineType__c = 'Product/Service',      
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,     
          Apttus_Config2__LineNumber__c = 1,        
          Apttus_Config2__ItemSequence__c = 1,      
          Apttus_Config2__NetPrice__c=10.0,     
          Apttus_Config2__BasePrice__c=10.0,        
          Apttus_Config2__BaseExtendedPrice__c = 10.0,      
          Apttus_Config2__AdjustedPrice__c = 10.0,      
          Apttus_Config2__OptionPrice__c = 5.0,     
          Apttus_Config2__Frequency__c = 'Monthly',     
          Apttus_Config2__PriceType__c = 'Recurring',       
          Apttus_Config2__PriceAdjustment__c=0,     
          APTS_Contract_Term__c ='3 Years',     
          APTS_Years_2_Plus_Adjustment__c='1',      
          APTS_Proposal_Group__c = proposalGroup.Id,        
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,     
          Apttus_Config2__ChargeType__c = 'Subscription Fee',               
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage   
          Apttus_Config2__PriceListItemId__c = pliSO.id);       
                
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group 2',      
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 2,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup2;      
                
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(      
            APTS_Deal_Number__c=124578945,      
            Apttus_Config2__Quantity__c=4,      
            Apttus_Config2__ProductId__c=prodObj.id,        
            Apttus_Config2__ConfigurationId__c = prodConfig.id,         
            Apttus_Config2__LineNumber__c = 2,      
            Apttus_Config2__ItemSequence__c = 2,        
            Apttus_Config2__NetPrice__c=10.0,       
            Apttus_Config2__BasePrice__c=10.0,      
            Apttus_Config2__BaseExtendedPrice__c = 10.0,        
            Apttus_Config2__AdjustedPrice__c = 10.0,        
            Apttus_Config2__LineStatus__c = 'New',      
            Apttus_Config2__Frequency__c = 'Monthly',       
            Apttus_Config2__PriceType__c = 'Recurring',         
            Apttus_Config2__PriceAdjustment__c=0,       
            APTS_Contract_Term__c ='3 Years',       
            APTS_Proposal_Group__c = proposalGroup.Id,      
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,       
            APTS_Bridge__c = '1 Month',     
            Apttus_Config2__ChargeType__c = 'Subscription Fee', 
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
          
           
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;      
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,        
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,     
                                     APTS_Years_2_Plus_Default__c,Apttus_Config2__BillingFrequency__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode                
                                     FROM Apttus_Config2__LineItem__c       
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];            
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);             
                                
        Test.startTest();       
         Apttus_Config2.CallbackTester.testValidationCallback       
                                              ( cartID      
                                              , lineItemsList       
                                              , null        
                                              , new APTS_Validation_Callback ());           
        Test.stopTest();                                                    
    }
    
    @isTest static void testMethodHighQ(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
        prodObj.Name = 'BGB';
        prodObj.APTS_Media_High_Level_Code__c = '13';
        prodObj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        prodObj.APTS_Product_Pricing_Model__c='HighQ Charge Only';
        //prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '13';
        prod2Obj.APTS_Product_Pricing_Model__c='HighQ Charge Only';
        prod2Obj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        //prod2Obj.APTS_Corporate_Select__c = 'Primary Essentials';
      insert prod2Obj;

       Product2 prod3Obj = new Product2();
        prod3Obj.Name = 'Network Services 2.0';
        prod3Obj.APTS_Media_High_Level_Code__c = '13';
        prod3Obj.APTS_Product_Pricing_Model__c='Per Seat';
        prod3Obj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        insert prod3Obj;
        
        prodFamily='BENEFITGRP';
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
        
        System.debug('Proposallineitemlist...'+lstPLIs);
           
        List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;

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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          APTS_Product_Family__c='HighQ',
            APTS_Keep_Terms__c = false,
            APTS_Group_Primary_Material_Name__c='PROFLEX Bundle',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prod3Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
           // Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c, APTS_Product_Family__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodHighQ2(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
      prodObj.Name = 'BGB';
        prodObj.APTS_Media_High_Level_Code__c = '13';
        //prodObj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prodObj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        //prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';
        //prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '13';
        //prod2Obj.APTS_Product_Pricing_Model__c='Banded';
        //prod2Obj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prod2Obj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        insert prod2Obj;

       Product2 prod3Obj = new Product2();
        prod3Obj.Name = 'Network Services 2.0';
        prod3Obj.APTS_Media_High_Level_Code__c = '13';
        //prod3Obj.APTS_Product_Pricing_Model__c='Per Seat';
        prod3Obj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        insert prod3Obj;
        
        prodFamily='BENEFITGRP';
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
        
        System.debug('Proposallineitemlist...'+lstPLIs);
           
        List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2019, 10, 10));
        insert asset;

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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prod2Obj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
      APTS_Product_Family__c='HighQ',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prod3Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c, APTS_Product_Family__c,
                                     APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    //Added by Chintan
    @isTest static void testMethod0414(){
        Map<String, Decimal> productsQuantity = new Map<String, Decimal>();     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');       
        insert priceList;       
                
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();       
        bundlePageSettings.Name = 'Bundle Page Properties';     
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';        
        insert bundlePageSettings;      
                
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');      
        insert productRule;     
                
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);       
        insert productRule1;        
        insertStaticValues();
       
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();        
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';        
        oWebServiceSettings.Name = 'PaymentCreditIncrease';         
        oWebServiceSettings.Timeout__c = 120;       
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';       
        oWebServiceSettings.Active__c = true;       
        insert oWebServiceSettings;     
        Account a = APTS_TestDataFactory.createAccount('Test Account');     
        insert a;       
        System.AssertEquals(a.Name, 'Test Account');         
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
                
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();       
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);     
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
                
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);       
       // insert ssd;       
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);       
        proposal.APTS_Proposal_Business_Unit__c = 'Canada';         
        insert proposal;        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);      
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;       
        insert prodConfig;      
        ID cartID = prodConfig.Id;      
        Product2 prodObj = new Product2();      
          prodObj.Name = 'Network Services 1.0'; 
         // prodObj.ProductCode='30913488';      
          prodObj.APTS_Media_High_Level_Code__c = '08';     
         prodObj.APTS_Media_Lower_Level_Code__c = 'BB';     
          prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';       
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';      
          insert prodObj;       
          Product2 prod2Obj = new Product2();       
          prod2Obj.Name = 'Network Services 2.0';       
          prod2Obj.APTS_Media_High_Level_Code__c = '07';        
          prod2Obj.APTS_Product_Pricing_Model__c='BENEFITGRP';      
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';       
           insert prod2Obj;     
          
          
        prodFamily='BENEFITGRP';        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();      
                
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=12,      
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,       
          APTS_Corporate_Select__c = 'Primary', 
          Apttus_Proposal__Proposal__c=proposal.id);        
          Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(                
          Apttus_Proposal__Quantity__c=1,       
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id,      
          Apttus_QPConfig__LineType__c = 'Product/Service',     
          Apttus_QPConfig__LineNumber__c = 1,       
          Apttus_QPConfig__ItemSequence__c = 1,     
          Apttus_QPConfig__NetPrice__c=1,
         
          APTS_Corporate_Select__c = 'Primary Essentials',      
          Apttus_Proposal__Proposal__c=proposal.id);        
        lstPLIs.add(pl1);       
        lstPLIs.add(pl2);       
        insert lstPLIs;     
         System.debug('Proposallineitemlist...'+lstPLIs);       
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();     
        System.debug('ProposalAttrrList...'+lstPropAttr);       
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',      
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));      
        insert asset;       
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
         
        APTS_Group__c proposalGroup =new APTS_Group__c();       
       proposalGroup.APTS_GrossAmount__c = 0;       
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';     
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';      
       proposalGroup.APTS_NetAmount__c=0;       
       insert proposalGroup;        
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group',        
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 1,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup1;      
                    
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(       
          APTS_Deal_Number__c=124578945,        
          Apttus_Config2__Quantity__c=13,       
          Apttus_Config2__ProductId__c=prod2Obj.id,     
           // Apttus_Config2__AttributeValueId__c = propattr.id,        
          Apttus_Config2__ConfigurationId__c = prodConfig.id,       
          Apttus_Config2__LineType__c = 'Product/Service',      
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,     
          Apttus_Config2__LineNumber__c = 1,        
          Apttus_Config2__ItemSequence__c = 1,      
          Apttus_Config2__NetPrice__c=10.0,     
          Apttus_Config2__BasePrice__c=10.0,        
          Apttus_Config2__BaseExtendedPrice__c = 10.0,      
          Apttus_Config2__AdjustedPrice__c = 10.0,      
          Apttus_Config2__OptionPrice__c = 5.0,     
          Apttus_Config2__Frequency__c = 'Monthly',     
          Apttus_Config2__PriceType__c = 'Recurring',       
          Apttus_Config2__PriceAdjustment__c=0,     
          APTS_Contract_Term__c ='3 Years',     
          APTS_Years_2_Plus_Adjustment__c='1',      
          APTS_Proposal_Group__c = proposalGroup.Id,        
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,     
          Apttus_Config2__ChargeType__c = 'Subscription Fee',               
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage   
          Apttus_Config2__PriceListItemId__c = pliSO.id);       
                
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(        
                Apttus_Config2__ConfigurationId__c = prodConfig.id,         
                Name = 'WEST PROFLEX Bundle A - Test group 2',      
                Apttus_Config2__LineType__c = 'Group Total',        
                Apttus_Config2__ItemSequence__c = 2,        
                Apttus_Config2__LineNumber__c = 1       
            );      
             insert summaryGroup2;      
                
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(      
            APTS_Deal_Number__c=124578945,      
            Apttus_Config2__Quantity__c=4,      
            Apttus_Config2__ProductId__c=prodObj.id,        
            Apttus_Config2__ConfigurationId__c = prodConfig.id,         
            Apttus_Config2__LineNumber__c = 2,      
            Apttus_Config2__ItemSequence__c = 2,        
            Apttus_Config2__NetPrice__c=10.0,       
            Apttus_Config2__BasePrice__c=10.0,      
            Apttus_Config2__BaseExtendedPrice__c = 10.0,        
            Apttus_Config2__AdjustedPrice__c = 10.0,        
            Apttus_Config2__LineStatus__c = 'New',      
            Apttus_Config2__Frequency__c = 'Monthly',       
            Apttus_Config2__PriceType__c = 'Recurring',         
            Apttus_Config2__PriceAdjustment__c=0,       
            APTS_Contract_Term__c ='3 Years',       
            APTS_Proposal_Group__c = proposalGroup.Id,      
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,       
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee', 
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;      
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,        
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,     
                                     APTS_Years_2_Plus_Default__c,Apttus_Config2__BillingFrequency__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c ,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode               
                                     FROM Apttus_Config2__LineItem__c       
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);             
                                
        Test.startTest();       
         Apttus_Config2.CallbackTester.testValidationCallback       
                                              ( cartID      
                                              , lineItemsList       
                                              , null        
                                              , new APTS_Validation_Callback ());           
        Test.stopTest();                                                    
    }
    
    @isTest static void testMethodHighQ3(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw'; 
        insert proposal;
        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
        update Proposal;
        

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
      prodObj.Name = 'BGB';
        prodObj.APTS_Media_High_Level_Code__c = '13';
        //prodObj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prodObj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        //prodObj.APTS_Product_Pricing_Model__c='BENEFITGRP';
        //prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        prodObj.ProductCode = '41618485';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '13';
        //prod2Obj.APTS_Product_Pricing_Model__c='Banded';
        //prod2Obj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prod2Obj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        prod2Obj.ProductCode = '42686641';
        insert prod2Obj;

       Product2 prod3Obj = new Product2();
        prod3Obj.Name = 'Network Services 2.0';
        prod3Obj.APTS_Media_High_Level_Code__c = '13';
        //prod3Obj.APTS_Product_Pricing_Model__c='Per Seat';
        //prod3Obj.APTS_Media_Lower_Level_Code__c = 'PQ';
        prod3Obj.Family = 'HighQ';
        prodObj.APTS_Cat_L2__c='L2_L070_FP'; // Added By Poonam Garg for DOC 12648
        prod3Obj.ProductCode = '41618485';
        insert prod3Obj;
        
        prodFamily='BENEFITGRP';
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
        
        System.debug('Proposallineitemlist...'+lstPLIs);
           
        List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;

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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
      APTS_Product_Family__c='HighQ',
            APTS_Group_Primary_Material_Name__c='PROFLEX Bundle',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prod3Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
           // Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c, APTS_Product_Family__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }

    
    @isTest static void testMethodGLP(){
      Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
      insert priceList;
      
      APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
      bundlePageSettings.Name = 'Bundle Page Properties';
      bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
      insert bundlePageSettings;
      
      APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
      insert productRule;
      
      APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
      insert productRule1;

      
      insertStaticValues();
      
      WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
      oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
      oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
      oWebServiceSettings.Timeout__c = 120; 
      oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
      oWebServiceSettings.Active__c = true;
      insert oWebServiceSettings;

      Account a = APTS_TestDataFactory.createAccount('Test Account');
      insert a;
      System.AssertEquals(a.Name, 'Test Account'); 
      List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
      
      Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
      Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
      
      //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
     // insert ssd;

      Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
      proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
      insert proposal;

      Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
      //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
      insert prodConfig;
      ID cartID = prodConfig.Id;

      Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_High_Level_Code__c = '21';
       prodObj.APTS_Media_Lower_Level_Code__c = 'CQ';
        prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '21';
        prod2Obj.APTS_Media_Lower_Level_Code__c = 'CQ';
      insert prod2Obj;
      Test.startTest();
      List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
      
      Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
        Apttus_Proposal__Quantity__c=12,
        Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
        Apttus_QPConfig__LineType__c = 'Product/Service',
        Apttus_QPConfig__LineNumber__c = 1, 
        Apttus_QPConfig__ItemSequence__c = 1,
        Apttus_QPConfig__NetPrice__c=1,
        APTS_Corporate_Select__c = 'Primary',
        Apttus_Proposal__Proposal__c=proposal.id);
      Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
        Apttus_Proposal__Quantity__c=1,
        Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
        Apttus_QPConfig__LineType__c = 'Product/Service',
        Apttus_QPConfig__LineNumber__c = 1, 
        Apttus_QPConfig__ItemSequence__c = 1,
        Apttus_QPConfig__NetPrice__c=1,
        APTS_Corporate_Select__c = 'Primary Essential',
        Apttus_Proposal__Proposal__c=proposal.id);
      lstPLIs.add(pl1);
      lstPLIs.add(pl2);  
      insert lstPLIs;
       System.debug('Proposallineitemlist...'+lstPLIs);
         List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
      System.debug('ProposalAttrrList...'+lstPropAttr);
      Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
      APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
      insert asset;
      
       Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
      APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1),Apttus_Config2__Quantity__c=5);
      insert asset1;
      
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

      APTS_Group__c proposalGroup =new APTS_Group__c();
     proposalGroup.APTS_GrossAmount__c = 0;
     proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
     proposalGroup.APTS_Group_Name__c ='Print Bundle A';
     proposalGroup.APTS_NetAmount__c=0;
     insert proposalGroup;
      Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
              Apttus_Config2__ConfigurationId__c = prodConfig.id, 
              Name = 'WEST PROFLEX Bundle A - Test group',
              Apttus_Config2__LineType__c = 'Group Total',
              Apttus_Config2__ItemSequence__c = 1,
              Apttus_Config2__LineNumber__c = 1
          );
           insert summaryGroup1;
      Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
        APTS_Deal_Number__c=5,  
        Apttus_Config2__Quantity__c=13,
        Apttus_Config2__ProductId__c=prod2Obj.id,
         // Apttus_Config2__AttributeValueId__c = propattr.id,
        Apttus_Config2__ConfigurationId__c = prodConfig.id, 
        Apttus_Config2__LineType__c = 'Product/Service',
        Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
        Apttus_Config2__LineNumber__c = 1, 
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__NetPrice__c=10.0,
        Apttus_Config2__BasePrice__c=10.0,
        Apttus_Config2__BaseExtendedPrice__c = 10.0,
        Apttus_Config2__AdjustedPrice__c = 10.0,
        Apttus_Config2__OptionPrice__c = 5.0,
        Apttus_Config2__Frequency__c = 'Monthly',
        Apttus_Config2__PriceType__c = 'Recurring', 
        Apttus_Config2__PriceAdjustment__c=0,
        APTS_Contract_Term__c ='3 Years',
        APTS_Proposal_Group__c = proposalGroup.Id,
        APTS_Group__c = proposalGroup.APTS_Group_Name__c,
        Apttus_Config2__ChargeType__c = 'Subscription Fee',          
        Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
        Apttus_Config2__PriceListItemId__c = pliSO.id,
        Apttus_Config2__AssetLineItemId__c = asset1.Id);
      
      Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
              Apttus_Config2__ConfigurationId__c = prodConfig.id, 
              Name = 'WEST PROFLEX Bundle A - Test group 2',
              Apttus_Config2__LineType__c = 'Group Total',
              Apttus_Config2__ItemSequence__c = 2,
              Apttus_Config2__LineNumber__c = 1
          );
           insert summaryGroup2;
      
      Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,
          Apttus_Config2__Quantity__c=4,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Option',
          Apttus_Config2__OptionId__c = prodObj.Id,
          Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
          Apttus_Config2__LineNumber__c = 2, 
          Apttus_Config2__ItemSequence__c = 2,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__LineStatus__c = 'New',
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          APTS_Bridge__c = '1 Month',
          Apttus_Config2__ChargeType__c = 'Subscription Fee',
          Apttus_Config2__PriceListItemId__c = pliSO2.id); 
      oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
      insert oLItemList;
      List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                   Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                   APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                   FROM Apttus_Config2__LineItem__c 
                                   WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
      System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
      
       Apttus_Config2.CallbackTester.testValidationCallback
                                            ( cartID
                                            , lineItemsList
                                            , null
                                            , new APTS_Validation_Callback ());   
      Test.stopTest();                                              
  }


  @isTest static void testMethodGLP1(){
      Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
      insert priceList;
      
      APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
      bundlePageSettings.Name = 'Bundle Page Properties';
      bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
      insert bundlePageSettings;
      
      APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
      insert productRule;
      
      APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
      insert productRule1;

      
      insertStaticValues();
      
      WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
      oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
      oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
      oWebServiceSettings.Timeout__c = 120; 
      oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
      oWebServiceSettings.Active__c = true;
      insert oWebServiceSettings;

      Account a = APTS_TestDataFactory.createAccount('Test Account');
      insert a;
      System.AssertEquals(a.Name, 'Test Account'); 
      List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
      
      Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
      Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
      
      //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
     // insert ssd;

      Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
      proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
      insert proposal;

      Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
      //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
      insert prodConfig;
      ID cartID = prodConfig.Id;

      Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_High_Level_Code__c = '21';
       prodObj.APTS_Media_Lower_Level_Code__c = 'CQ';
        prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '21';
        prod2Obj.APTS_Media_Lower_Level_Code__c = 'CQ';
      insert prod2Obj;
      Test.startTest();
      List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
      
      Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
        Apttus_Proposal__Quantity__c=12,
        Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
        Apttus_QPConfig__LineType__c = 'Product/Service',
        Apttus_QPConfig__LineNumber__c = 1, 
        Apttus_QPConfig__ItemSequence__c = 1,
        Apttus_QPConfig__NetPrice__c=1,
        APTS_Corporate_Select__c = 'Primary',
        Apttus_Proposal__Proposal__c=proposal.id);
      Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
        Apttus_Proposal__Quantity__c=1,
        Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
        Apttus_QPConfig__LineType__c = 'Product/Service',
        Apttus_QPConfig__LineNumber__c = 1, 
        Apttus_QPConfig__ItemSequence__c = 1,
        Apttus_QPConfig__NetPrice__c=1,
        APTS_Corporate_Select__c = 'Primary Essential',
        Apttus_Proposal__Proposal__c=proposal.id);
      lstPLIs.add(pl1);
      lstPLIs.add(pl2);  
      insert lstPLIs;
       System.debug('Proposallineitemlist...'+lstPLIs);
         List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
      System.debug('ProposalAttrrList...'+lstPropAttr);
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

      APTS_Group__c proposalGroup =new APTS_Group__c();
     proposalGroup.APTS_GrossAmount__c = 0;
     proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
     proposalGroup.APTS_Group_Name__c ='Print Bundle A';
     proposalGroup.APTS_NetAmount__c=0;
     insert proposalGroup;
      Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
              Apttus_Config2__ConfigurationId__c = prodConfig.id, 
              Name = 'WEST PROFLEX Bundle A - Test group',
              Apttus_Config2__LineType__c = 'Group Total',
              Apttus_Config2__ItemSequence__c = 1,
              Apttus_Config2__LineNumber__c = 1
          );
           insert summaryGroup1;
      Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
        APTS_Deal_Number__c=5,  
        Apttus_Config2__Quantity__c=13,
        Apttus_Config2__ProductId__c=prod2Obj.id,
         // Apttus_Config2__AttributeValueId__c = propattr.id,
        Apttus_Config2__ConfigurationId__c = prodConfig.id, 
        Apttus_Config2__LineType__c = 'Product/Service',
        Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
        Apttus_Config2__LineNumber__c = 1, 
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__NetPrice__c=10.0,
        Apttus_Config2__BasePrice__c=10.0,
        Apttus_Config2__BaseExtendedPrice__c = 10.0,
        Apttus_Config2__AdjustedPrice__c = 10.0,
        Apttus_Config2__OptionPrice__c = 5.0,
        Apttus_Config2__Frequency__c = 'Monthly',
        Apttus_Config2__PriceType__c = 'Recurring', 
        Apttus_Config2__PriceAdjustment__c=0,
        APTS_Contract_Term__c ='3 Years',
        APTS_Proposal_Group__c = proposalGroup.Id,
        APTS_Group__c = proposalGroup.APTS_Group_Name__c,
        Apttus_Config2__ChargeType__c = 'Subscription Fee',          
        Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
        Apttus_Config2__PriceListItemId__c = pliSO.id);
      
      Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
              Apttus_Config2__ConfigurationId__c = prodConfig.id, 
              Name = 'WEST PROFLEX Bundle A - Test group 2',
              Apttus_Config2__LineType__c = 'Group Total',
              Apttus_Config2__ItemSequence__c = 2,
              Apttus_Config2__LineNumber__c = 1
          );
           insert summaryGroup2;
      
      Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,
          Apttus_Config2__Quantity__c=4,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Option',
          Apttus_Config2__OptionId__c = prodObj.Id,
          Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
          Apttus_Config2__LineNumber__c = 2, 
          Apttus_Config2__ItemSequence__c = 2,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__LineStatus__c = 'New',
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          APTS_Bridge__c = '1 Month',
          Apttus_Config2__ChargeType__c = 'Subscription Fee',
          Apttus_Config2__PriceListItemId__c = pliSO2.id); 
      oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
      insert oLItemList;
      List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                   Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                   APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                   FROM Apttus_Config2__LineItem__c 
                                   WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
      System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
      
       Apttus_Config2.CallbackTester.testValidationCallback
                                            ( cartID
                                            , lineItemsList
                                            , null
                                            , new APTS_Validation_Callback ());   
      Test.stopTest();                                              
  }
  
  @isTest static void testMethodCanadaGPP(){
        //For DOC-3725
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Canada'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'BGB';
          prodObj.APTS_Media_High_Level_Code__c = '21';
          prodObj.APTS_Media_Lower_Level_Code__c = 'F4';
          prodObj.APTS_Item_Category_Group__c='ZVSU';
          prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Product_Pricing_Model__c='Banded';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
           insert prod2Obj;
        
          
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='APP',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
                  
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          Apttus_Config2__PriceListItemId__c = pliSO.id);


        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,APTS_Cat_L2__c,APTS_Cat_L3__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id ];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodSCS(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;


        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS';        
        insert proposal;
        system.debug('######## proposal.APTS_Proposal_Business_Unit__c'+proposal.APTS_Proposal_Business_Unit__c);
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'BGB';
          prodObj.APTS_Media_High_Level_Code__c = '21';
          prodObj.APTS_Media_Lower_Level_Code__c = 'F4';
          prodObj.APTS_Item_Category_Group__c='ZPR2';
          prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Product_Pricing_Model__c='Banded';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
           insert prod2Obj;
        
          
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='APP',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
                  
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly', 
          Apttus_Config2__PriceAdjustment__c=0,
          Apttus_Config2__PriceType__c = 'One Time',
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'One Time',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,APTS_Cat_L2__c,APTS_Cat_L3__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id ];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }

    @isTest static void testMethodSCSGPP(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        System.AssertEquals(a.Name, 'Test Account'); 
        //Inserting SSd Object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        //Inserting Opportunity Object
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
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id; 
        insert prodConfig;
        ID cartID = prodConfig.Id;
         Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '21';
          prodObj.APTS_Media_Lower_Level_Code__c = 'F4';
          prodObj.APTS_Item_Category_Group__c = 'ZPR2';
          insert prodObj;  
          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Cat_L2__c=System.Label.APTS_Print_Product_Family;
          //prod2Obj.APTS_Media_High_Level_Code__c = '07';
          //prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
        insert prod2Obj;
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
         Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'One Time', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

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
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert oLItemList;
         List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c ,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];  
         System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());  
        Test.stopTest(); 
    }
    
    @isTest static void testMethodCanadaGPP_BN(){
        //For DOC-3725
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        System.AssertEquals(a.Name, 'Test Account'); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Canada'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'BGB';
          prodObj.APTS_Media_High_Level_Code__c = '81';
          prodObj.APTS_Media_Lower_Level_Code__c = 'F4';
          prodObj.APTS_Item_Category_Group__c='ZVSU';
          prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';
          prod2Obj.APTS_Product_Pricing_Model__c='Banded';
          prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
           insert prod2Obj;
        
          
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=12,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essentials',
          Apttus_Proposal__Proposal__c=proposal.id);
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        insert lstPLIs;
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='APP',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
        insert asset;
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
        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
          
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
             
                  
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=124578945,  
          Apttus_Config2__Quantity__c=13,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Years_2_Plus_Adjustment__c='1',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__BillingFrequency__c='Monthly',
          Apttus_Config2__PriceListItemId__c = pliSO.id);


        

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=124578945,
            Apttus_Config2__Quantity__c=4,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__BillingFrequency__c='Yearly',
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
        insert oLItemList;
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,APTS_Cat_L2__c,APTS_Cat_L3__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id ];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                        
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodSixA(){
    Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
    insert priceList;
    
    insertStaticValues();
    
    WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
    oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
    oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
    oWebServiceSettings.Timeout__c = 120; 
    oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
    oWebServiceSettings.Active__c = true;
    insert oWebServiceSettings;
    
    List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
    System.AssertEquals(a.Name, 'Test Account'); 
    //Inserting SSd Object
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
    Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
    accountSSD.RecordtypeId=ssdRecorType;
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    insert accountSSD;
    
    //Inserting Opportunity Object
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=accountSSD.id;
    oppty.Account=a;
    insert oppty;
    
    
    Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
    proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
    insert proposal;
    APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '072Q');      
    insert productRule; 
    
    Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
    insert prodConfig;

    ID cartID = prodConfig.Id;

    Product2 prodObj = new Product2();
      prodObj.Name = 'Network Services 1.0';
      prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
      prodObj.ProductCode = '30790796';
      insert prodObj;  

      Product2 prod2Obj = new Product2();
      prod2Obj.Name = 'Network Services 2.0';
      prod2Obj.APTS_Media_High_Level_Code__c = '13';
      prod2Obj.APTS_Media_Lower_Level_Code__c = 'PQ';
      insert prod2Obj;    

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
    APTS_Group__c proposalGroup =new APTS_Group__c();
   proposalGroup.APTS_GrossAmount__c = 0;
   proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
   proposalGroup.APTS_Group_Name__c ='Print Bundle A';
   proposalGroup.APTS_NetAmount__c=0;
   insert proposalGroup;
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
      Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
      Apttus_Config2__LineNumber__c = 1, 
      Apttus_Config2__ItemSequence__c = 1,
      Apttus_Config2__NetPrice__c=10.0,
      Apttus_Config2__BasePrice__c=10.0,
      Apttus_Config2__BaseExtendedPrice__c = 10.0,
      Apttus_Config2__AdjustedPrice__c = 10.0,
      Apttus_Config2__OptionPrice__c = 5.0,
      Apttus_Config2__Frequency__c = 'Monthly',
      Apttus_Config2__PriceType__c = 'Recurring', 
      Apttus_Config2__PriceAdjustment__c=0,
      APTS_Contract_Term__c ='3 Years',
      APTS_Proposal_Group__c = proposalGroup.Id,
      APTS_Group__c = proposalGroup.APTS_Group_Name__c,
      Apttus_Config2__ChargeType__c = 'Subscription Fee',          
      Apttus_Config2__LineStatus__c = 'New',
      Apttus_Config2__IsPrimaryLine__c = TRUE,         
      Apttus_Config2__PriceListItemId__c = pliSO.id); 

    Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
         insert summaryGroup2;

        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
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
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Product_Family__c= System.Label.Caseline_Product_Family,
            APTS_Term_Type__c= 'Future Start Date',
            APTS_Bridge__c = '1 Month');

    oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj3};
    insert oLItemList;
    
   APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
    bundlePageSettings.Name = 'Bundle Page Properties';
    bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
    insert bundlePageSettings;
        
    List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                 Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                 APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                 FROM Apttus_Config2__LineItem__c 
                                 WHERE Id = :linObj.Id OR Id = :linObj3.Id];      

    System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

    Test.startTest();
     Apttus_Config2.CallbackTester.testValidationCallback
                                          ( cartID
                                          , lineItemsList
                                          , null
                                          , new APTS_Validation_Callback ()); 
    
    Test.stopTest();                                              
}
@isTest static void testMethodCanadaGPPP(){
    //For DOC-3725
    Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
    insert priceList;
    
    APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
    bundlePageSettings.Name = 'Bundle Page Properties';
    bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
    insert bundlePageSettings;
    
    APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
    insert productRule;
    
    APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
    insert productRule1;

    insertStaticValues();
    
    WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
    oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
    oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
    oWebServiceSettings.Timeout__c = 120; 
    oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
    oWebServiceSettings.Active__c = true;
    insert oWebServiceSettings;

    Account a = APTS_TestDataFactory.createAccount('Test Account');
    insert a;
    System.AssertEquals(a.Name, 'Test Account'); 
    List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
    Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
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
    
    //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
   // insert ssd;

    Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
    proposal.APTS_Proposal_Business_Unit__c = 'Canada'; 
    insert proposal;

    Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
    //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
    insert prodConfig;
    ID cartID = prodConfig.Id;

    Product2 prodObj = new Product2();
      prodObj.Name = 'BGB';
      prodObj.APTS_Media_High_Level_Code__c = '21';
      prodObj.APTS_Media_Lower_Level_Code__c = 'EC';
      prodObj.APTS_Item_Category_Group__c='ZVSU';
      prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
      insert prodObj;  

      Product2 prod2Obj = new Product2();
      prod2Obj.Name = 'Network Services 2.0';
      prod2Obj.APTS_Media_High_Level_Code__c = '07';
      prod2Obj.APTS_Product_Pricing_Model__c='Banded';
      prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
      prodObj.APTS_Cat_L2__c = 'L2_L045_FP';
       insert prod2Obj;
    
      
    List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    
    Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
      Apttus_Proposal__Quantity__c=12,
      Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
      Apttus_QPConfig__LineType__c = 'Product/Service',
      Apttus_QPConfig__LineNumber__c = 1, 
      Apttus_QPConfig__ItemSequence__c = 1,
      Apttus_QPConfig__NetPrice__c=1,
      APTS_Corporate_Select__c = 'Primary',
      Apttus_Proposal__Proposal__c=proposal.id);
    Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
      Apttus_Proposal__Quantity__c=1,
      Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
      Apttus_QPConfig__LineType__c = 'Product/Service',
      Apttus_QPConfig__LineNumber__c = 1, 
      Apttus_QPConfig__ItemSequence__c = 1,
      Apttus_QPConfig__NetPrice__c=1,
      APTS_Corporate_Select__c = 'Primary Essentials',
      Apttus_Proposal__Proposal__c=proposal.id);
    lstPLIs.add(pl1);
    lstPLIs.add(pl2);  
    insert lstPLIs;
     System.debug('Proposallineitemlist...'+lstPLIs);
       List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
    System.debug('ProposalAttrrList...'+lstPropAttr);
    Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod2Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
    APTS_Deal_Type__c='APP',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
    insert asset;
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
    APTS_Group__c proposalGroup =new APTS_Group__c();
   proposalGroup.APTS_GrossAmount__c = 0;
   proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
   proposalGroup.APTS_Group_Name__c ='Print Bundle A';
   proposalGroup.APTS_NetAmount__c=0;
   insert proposalGroup;
      
    Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
         insert summaryGroup1;
         
              
      Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
      APTS_Deal_Number__c=124578945,  
      Apttus_Config2__Quantity__c=13,
      Apttus_Config2__ProductId__c=prodObj.id,
       // Apttus_Config2__AttributeValueId__c = propattr.id,
      Apttus_Config2__ConfigurationId__c = prodConfig.id, 
      Apttus_Config2__LineType__c = 'Product/Service',
      Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
      Apttus_Config2__LineNumber__c = 1, 
      Apttus_Config2__ItemSequence__c = 1,
      Apttus_Config2__NetPrice__c=10.0,
      Apttus_Config2__BasePrice__c=10.0,
      Apttus_Config2__BaseExtendedPrice__c = 10.0,
      Apttus_Config2__AdjustedPrice__c = 10.0,
      Apttus_Config2__OptionPrice__c = 5.0,
      Apttus_Config2__Frequency__c = 'Monthly',
      Apttus_Config2__PriceType__c = 'Recurring', 
      Apttus_Config2__PriceAdjustment__c=0,
      APTS_Contract_Term__c ='3 Years',
      APTS_Years_2_Plus_Adjustment__c='1',
      APTS_Proposal_Group__c = proposalGroup.Id,
      APTS_Group__c = proposalGroup.APTS_Group_Name__c,
      Apttus_Config2__ChargeType__c = 'Subscription Fee',          
      Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
      Apttus_Config2__BillingFrequency__c='Monthly',
      Apttus_Config2__PriceListItemId__c = pliSO.id);


    

    Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Name = 'WEST PROFLEX Bundle A - Test group 2',
            Apttus_Config2__LineType__c = 'Group Total',
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__LineNumber__c = 1
        );
         insert summaryGroup2;
    
    Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
        APTS_Deal_Number__c=124578945,
        Apttus_Config2__Quantity__c=4,
        Apttus_Config2__ProductId__c=prodObj.id,
        Apttus_Config2__ConfigurationId__c = prodConfig.id, 
        Apttus_Config2__LineType__c = 'Option',
        Apttus_Config2__OptionId__c = prodObj.Id,
        Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
        Apttus_Config2__LineNumber__c = 2, 
        Apttus_Config2__ItemSequence__c = 2,
        Apttus_Config2__NetPrice__c=10.0,
        Apttus_Config2__BasePrice__c=10.0,
        Apttus_Config2__BaseExtendedPrice__c = 10.0,
        Apttus_Config2__AdjustedPrice__c = 10.0,
        Apttus_Config2__LineStatus__c = 'Cancelled',
        Apttus_Config2__OptionPrice__c = 5.0,
        Apttus_Config2__Frequency__c = 'Monthly',
        Apttus_Config2__PriceType__c = 'Recurring', 
        Apttus_Config2__PriceAdjustment__c=0,
        APTS_Contract_Term__c ='3 Years',
        APTS_Proposal_Group__c = proposalGroup.Id,
        APTS_Group__c = proposalGroup.APTS_Group_Name__c,
        APTS_Bridge__c = '1 Month',
        Apttus_Config2__ChargeType__c = 'Subscription Fee',
        Apttus_Config2__BillingFrequency__c='Yearly',
        Apttus_Config2__PriceListItemId__c = pliSO3.id); 
    oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
    insert oLItemList;
    List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,APTS_Cat_L2__c,APTS_Cat_L3__c,
                                 Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                                 APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                                 FROM Apttus_Config2__LineItem__c 
                                 WHERE Id = :linObj.Id OR Id = :linObj2.Id ];      
    System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);     
                    
    Test.startTest();
     Apttus_Config2.CallbackTester.testValidationCallback
                                          ( cartID
                                          , lineItemsList
                                          , null
                                          , new APTS_Validation_Callback ());   
    Test.stopTest();                                              
}
    @isTest static void testMethod382511(){
  Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
  insert priceList;

  insertStaticValues();
  
  WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
  oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
  oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
  oWebServiceSettings.Timeout__c = 120; 
  oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
  oWebServiceSettings.Active__c = true;
  insert oWebServiceSettings;
  
  
  List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
  System.AssertEquals(a.Name, 'Test Account'); 
  Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
  Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
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
  
  //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
 // insert ssd;

  Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
  proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
  insert proposal;

  Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
  insert prodConfig;
  ID cartID = prodConfig.Id;

  Product2 prodObj = new Product2();
    prodObj.Name = 'Network Services 1.0';
    prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
    //prodObj.APTS_Media_High_Level_Code__c = '06';
    //prodObj.Family = 'PRINT';
    insert prodObj;  

    Product2 prod2Obj = new Product2();
    prod2Obj.Name = 'Network Services 2.0';
    //prod2Obj.APTS_Media_High_Level_Code__c = '13';
   prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';

    insert prod2Obj;

    Product2 prod3Obj = new Product2();
    prod3Obj.Name = 'Network Services 3.0';
    //prod2Obj.APTS_Media_High_Level_Code__c = '13';
    prod3Obj.APTS_Media_Lower_Level_Code__c = '2Q';

    insert prod3Obj;   

    Product2 prod4Obj = new Product2();
    prod4Obj.Name = 'Network Services 2.0';
    prod4Obj.APTS_Media_High_Level_Code__c = '13';
   prod4Obj.APTS_Media_Lower_Level_Code__c = 'PQ';
    insert prod4Obj;

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

  APTS_Group__c proposalGroup =new APTS_Group__c();
 proposalGroup.APTS_GrossAmount__c = 0;
 proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
 proposalGroup.APTS_Group_Name__c ='Print Bundle A';
 proposalGroup.APTS_NetAmount__c=0;
 insert proposalGroup;


  Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Name = 'WEST PROFLEX Bundle A - Test group',
          Apttus_Config2__LineType__c = 'Group Total',
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__LineNumber__c = 1
      );
       insert summaryGroup1;
  Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
  APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
  insert asset;        
  Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod3Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656552',
  APTS_Deal_Type__c='WCMP',APTS_Deal_Number__c=124578945, Apttus_Config2__StartDate__c= Date.newInstance(2020, 1, 1));
  insert asset1;  
  Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
    //APTS_New_Bridge_Discount__c = 3.3,
    //Apttus_Config2__LineStatus__c = 'Renewed',
    
    //APTS_Media_Lower_Level_Code__c = 'SS',
    //APTS_Keep_Terms__c = True,
    //APTS_Group_Primary_Material_Name__c = 'PROFLEX',
    //APTS_Is_Special_Offer_Lapsed__c = True,
    Apttus_Config2__AssetLineItemId__c = asset.Id,
   // APTS_Group__c = 'Bundle',
    Apttus_Config2__Quantity__c=1,
    Apttus_Config2__ProductId__c=prodObj.id,
    Apttus_Config2__ConfigurationId__c = prodConfig.id, 
    Apttus_Config2__LineType__c = NULL,
    Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
    Apttus_Config2__LineNumber__c = 1, 
    Apttus_Config2__ItemSequence__c = 1,
    Apttus_Config2__NetPrice__c=10.0,
    Apttus_Config2__BasePrice__c=10.0,
    Apttus_Config2__BaseExtendedPrice__c = 10.0,
    Apttus_Config2__AdjustedPrice__c = 10.0,
    Apttus_Config2__OptionPrice__c = 5.0,
    Apttus_Config2__Frequency__c = 'Monthly',
    Apttus_Config2__PriceType__c = 'Recurring', 
    Apttus_Config2__PriceAdjustment__c=0,
    APTS_Contract_Term__c ='3 Years',
    APTS_Proposal_Group__c = proposalGroup.Id,
    APTS_Group__c = proposalGroup.APTS_Group_Name__c,
    Apttus_Config2__ChargeType__c = 'Subscription Fee',          
    Apttus_Config2__LineStatus__c = 'Cancelled',
    Apttus_Config2__PriceListItemId__c = pliSO.id); 

  Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Name = 'WEST PROFLEX Bundle A - Test group 2',
          Apttus_Config2__LineType__c = 'Group Total',
          Apttus_Config2__ItemSequence__c = 2,
          Apttus_Config2__LineNumber__c = 1
      );
       insert summaryGroup2;

  

  Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
      //APTS_Group_Primary_Material_Name__c='PROFLEX',
      Apttus_Config2__Quantity__c=1,
      Apttus_Config2__ProductId__c=prodObj.id,
      Apttus_Config2__ConfigurationId__c = prodConfig.id, 
      Apttus_Config2__LineType__c = NULL,
      Apttus_Config2__OptionId__c = prod2Obj.Id,
      Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
      APTS_Proposal_Group__c = proposalGroup.Id,
      APTS_Group__c = proposalGroup.APTS_Group_Name__c,
      Apttus_Config2__AdjustmentAmount__c = 1,
      Apttus_Config2__ChargeType__c = 'Subscription Fee',
      Apttus_Config2__LineStatus__c = 'Cancelled',
      Apttus_Config2__PriceListItemId__c = pliSO2.id);
       
      Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
        APTS_Group_Primary_Material_Name__c='PROFLEX',
        Apttus_Config2__AssetLineItemId__c = asset.Id,
        Apttus_Config2__Quantity__c=1,
        Apttus_Config2__ProductId__c=prod2Obj.id,
        Apttus_Config2__ConfigurationId__c = prodConfig.id, 
        Apttus_Config2__LineType__c = NULL,
        Apttus_Config2__OptionId__c = prodObj.Id,
        Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
        //APTS_Proposal_Group__c = proposalGroup.Id,
        //APTS_Group__c = proposalGroup.APTS_Group_Name__c,
        Apttus_Config2__AdjustmentAmount__c = 1,
        Apttus_Config2__ChargeType__c = 'Subscription Fee',
        Apttus_Config2__LineStatus__c = 'Cancelled',
        Apttus_Config2__PriceListItemId__c = pliSO2.id);

  Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
      //APTS_Group_Primary_Material_Name__c='PROFLEX',
      Apttus_Config2__AssetLineItemId__c = asset1.Id,
      Apttus_Config2__Quantity__c=1,
      Apttus_Config2__ProductId__c=prod3Obj.id,
      Apttus_Config2__ConfigurationId__c = prodConfig.id, 
      Apttus_Config2__LineType__c = NULL,
      Apttus_Config2__OptionId__c = prodObj.Id,
      Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
      APTS_Proposal_Group__c = proposalGroup.Id,
      APTS_Group__c = proposalGroup.APTS_Group_Name__c,
      Apttus_Config2__AdjustmentAmount__c = 1,
      Apttus_Config2__ChargeType__c = 'Subscription Fee',
      Apttus_Config2__LineStatus__c = 'Amended',
      Apttus_Config2__PriceListItemId__c = pliSO2.id); 

      Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
        APTS_Group_Primary_Material_Name__c= Null ,
        Apttus_Config2__AssetLineItemId__c = asset.Id,
        Apttus_Config2__Quantity__c=1,
        Apttus_Config2__ProductId__c=prod4Obj.id,
        Apttus_Config2__ConfigurationId__c = prodConfig.id, 
        Apttus_Config2__LineType__c = 'Product/Service',
        Apttus_Config2__OptionId__c = prodObj.Id,
        Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
        //APTS_Proposal_Group__c = proposalGroup.Id,
        //APTS_Group__c = proposalGroup.APTS_Group_Name__c,
        Apttus_Config2__AdjustmentAmount__c = 1,
        Apttus_Config2__ChargeType__c = 'Subscription Fee',
        Apttus_Config2__LineStatus__c = 'New',
        Apttus_Config2__PriceListItemId__c = pliSO2.id,
        APTS_Product_Family__c=System.Label.Caseline_Product_Family);
  
  
  oLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2,linObj3,linObj4,linObj5};
      
  insert oLItemList;

  APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
  bundlePageSettings.Name = 'Bundle Page Properties';
  bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
  insert bundlePageSettings;
      
  List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                               Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,APTS_Bundle__c,
                               APTS_Years_2_Plus_Default__c,APTS_Product_Family__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c,APTS_Cat_L2__c,APTS_Cat_L3__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.productcode         
                               FROM Apttus_Config2__LineItem__c 
                               WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

  System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

  Test.startTest();
   Apttus_Config2.CallbackTester.testValidationCallback
                                        ( cartID
                                        , lineItemsList
                                        , null
                                        , new APTS_Validation_Callback ());   
  Test.stopTest();                                              
}
}