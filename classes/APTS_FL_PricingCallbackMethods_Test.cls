@isTest
public class APTS_FL_PricingCallbackMethods_Test {
     /*  private static void priceCartLines(ID cartID) 
    {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
    }*/
        
       @isTest static void testmethod1() {
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
       
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();

        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
                
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(null, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
        insert proposal;
        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
        update proposal;
        System.assertEquals(proposal.APTS_Proposal_Business_Unit__c, 'FindLaw');

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_QPConfig__Proposald__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;


        List<Apttus_Config2__LineItem__c> ListOfLineItems = new List<Apttus_Config2__LineItem__c>();
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

        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.IsActive = true;
        prodObj.CurrencyIsoCode = 'USD';
        prodObj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        insert prodObj; 
        
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Network Services 1.0';
        prodObj1.IsActive = true;
        prodObj1.CurrencyIsoCode = 'USD';
       
        prodObj1.APTS_Item_Category_Group__c='ZPMT';
        
        insert prodObj1;
        
        APTS_Attribute_Value_Combination__c attr1= new APTS_Attribute_Value_Combination__c();
        attr1.Name='Los Angeles-Long Beach, CA-Insurance Law';
        attr1.APTS_Inventory_Available__c=10.0;
        attr1.APTS_Exposure_Pack_Disc__c = 1.5;
        attr1.APTS_Price__c = 100;
        attr1.APTS_Product__c = prodObj.id;
        insert attr1;

        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        pliSO3.Apttus_Config2__Sequence__c = 3;
        pliSO3.Apttus_Config2__ProductId__c = prodObj.Id;
        priceListItems.add(pliSO3);
     
        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.IsActive = true;
        prod2Obj.CurrencyIsoCode = 'USD';
        prod2Obj.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
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
                Apttus_Config2__PriceListItemId__c = pliSO.id,
                Apttus_Config2__PrimaryLineNumber__c = 1,
                Apttus_Config2__ParentBundleNumber__c = null,
                Apttus_Config2__OptionId__c = null,
                APTS_Combination_Key__c = attr1.Id);
       ListOfLineItems.add(linObj);
  
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
                Apttus_Config2__ChargeType__c='Standard Price',
                Apttus_Config2__Frequency__c = 'Monthly',
                Apttus_Config2__PriceType__c = 'One Time', 
                Apttus_Config2__PriceAdjustment__c=0,
                APTS_Contract_Term__c ='3 Years',
                Apttus_Config2__PrimaryLineNumber__c = 2,
                Apttus_Config2__ParentBundleNumber__c = 1,
                Apttus_Config2__OptionId__c = null,
                APTS_Product_Family__c = 'PPC MANAGEMENT',
                Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        ListOfLineItems.add(linObj2);

        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prod2Obj.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Option',
                Apttus_Config2__ChargeType__c='Subscription Fee',
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
                Apttus_Config2__ParentBundleNumber__c = 1,
                APTS_Year_2_3_Price__c = 30,
                APTS_Product_Family__c = 'PPC MANAGEMENT',
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        ListOfLineItems.add(linObj3);

        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
                Apttus_Config2__Quantity__c=1,
                Apttus_Config2__ProductId__c=prod2Obj.id,
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Apttus_Config2__LineType__c = 'Option',
                Apttus_Config2__LineNumber__c = 2, 
                Apttus_Config2__ChargeType__c='Subscription Fee',
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
                APTS_Contract_Term__c =null,
                Apttus_Config2__ParentBundleNumber__c = 1,
                APTS_Year_2_3_Price__c = 30,
                APTS_Product_Family__c = 'PPC MANAGEMENT',
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        ListOfLineItems.add(linObj4);

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
                Apttus_Config2__ChargeType__c='Subscription Fee',
                APTS_Contract_Term__c =null,
                Apttus_Config2__ParentBundleNumber__c = 1,
                APTS_Year_2_3_Price__c = 30,
                APTS_Product_Family__c = 'PPC MANAGEMENT',
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
                

        ListOfLineItems.add(linObj5);
           
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
            linObj1.APTS_Contract_Term__c ='Existing';
            linObj1.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            
            ListOfLineItems1.add(linObj1);
            
            Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c();
            linObj12.Apttus_Config2__Quantity__c=1;
            linObj12.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj12.Apttus_Config2__LineType__c = 'Option';
            linObj12.Apttus_Config2__LineNumber__c = 1;
            linObj12.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj12.Apttus_Config2__ItemSequence__c = 3;
            linObj12.Apttus_Config2__NetPrice__c=10.0;            
            linObj12.Apttus_Config2__OptionPrice__c = 15.0;
            linObj12.Apttus_Config2__Frequency__c = 'Monthly';
            linObj12.Apttus_Config2__PriceType__c = 'Recurring';
            linObj12.Apttus_Config2__PriceAdjustment__c=0;
            linObj12.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj12.APTS_Contract_Term__c =null;
            linObj12.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj12.Apttus_Config2__PriceListItemId__c = pliSO3.id; 
            
            ListOfLineItems1.add(linObj12);
        
            Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c();
            linObj13.Apttus_Config2__Quantity__c=1;
            linObj13.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj13.Apttus_Config2__LineType__c = 'Option';
            linObj13.Apttus_Config2__ChargeType__c='Standard Price';
            linObj13.Apttus_Config2__LineNumber__c = 1;
            linObj13.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj13.Apttus_Config2__ItemSequence__c = 3;
            linObj13.Apttus_Config2__NetPrice__c=10.0;            
            linObj13.Apttus_Config2__OptionPrice__c = 15.0;
            linObj13.Apttus_Config2__Frequency__c = 'Monthly';
            linObj13.Apttus_Config2__PriceType__c = 'Recurring';
            linObj13.Apttus_Config2__PriceAdjustment__c=0;
            linObj13.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj13.APTS_Contract_Term__c =null;            
            linObj13.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            linObj13.Apttus_Config2__PriceListItemId__c = pliSO5.id; 
            
            ListOfLineItems.add(linObj13);
        
            
            insert ListOfLineItems1;
            
            Apttus_Config2__PriceDimension__c pricedimension = new Apttus_Config2__PriceDimension__c();
            pricedimension.Name='Priced Number of Attorneys';
            pricedimension.Apttus_Config2__Datasource__c='test';
            insert pricedimension;
            
            Apttus_Config2__PriceMatrix__c pricematrix= new Apttus_Config2__PriceMatrix__c();            
            pricematrix.Apttus_Config2__Dimension2Id__c=pricedimension.id;
            pricematrix.Apttus_Config2__PriceListItemId__c=pliSO3.id;
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
            insert ListOfLineItems;

           List<Apttus_Config2__ProductAttributeValue__c> prodattr =new List<Apttus_Config2__ProductAttributeValue__c>();
        
            Apttus_Config2__ProductAttributeValue__c pavObj; 
            for (Apttus_Config2__LineItem__c lineItem : ListOfLineItems ){
                pavObj = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
                );
         
                prodattr.add(pavObj);
            }
        
           Apttus_Config2__ProductAttributeValue__c pavObj1; 
           for (Apttus_Config2__LineItem__c lineItem : ListOfLineItems1 ){
                pavObj1 = new Apttus_Config2__ProductAttributeValue__c(
                SCS_Print_Purchase_Options__c = 'Fill-Up & Enter Sub',
                APTS_FillUp_Start_Date__c = date.valueOf('1999-01-01'),
                Apttus_Config2__LineItemId__c = lineItem.id
                );
         
               prodattr.add(pavObj1);
           }
           insert prodattr;
        
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

        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c,APTS_Corporate_Select__c,APTS_Corporate_Select_Option__c,Apttus_Config2__ConfigurationId__c,APTS_CAT_L5__c,
        
                                     Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ChargeType__c, Apttus_Config2__PrimaryLineNumber__c, 
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c, Apttus_Config2__PriceType__c, 
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Keep_Terms__c, Apttus_Config2__ExtendedPrice__c, Apttus_Config2__OptionPrice__c, APTS_Price_Cap_Adjustment_Percentage__c, 
                                     APTS_Proposal_Business_Unit__c, APTS_PAGEO_Price__c, Apttus_Config2__ParentBundleNumber__c, Apttus_Config2__OptionId__c, Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,
                                     Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c, APTS_Contract_Term_Default__c, Apttus_Config2__AdjustmentType__c,Apttus_Config2__ProductId__r.Media_High_Level__c, APTS_Product_Family__c, APTS_Year_2_3_Price__c
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id OR Id = :linObj3.Id OR Id = :linObj4.Id OR Id = :linObj5.Id];      
                                    
        List<Apttus_Config2__LineItem__c> bundleItems = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
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
                Apttus_Config2__ChargeType__c='Subscription Fee',
                APTS_Contract_Term__c =null,
                Apttus_Config2__PriceListItemId__c = pliSO3.id); 
                bundleItems.add(linObj6);
                
        Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = APTS_PricingCallbackMethods.buildLineNumberToOptionsMap(lineItemsList, bundleItems);
        set<Id> lineitemId = new set<Id>();        
        for(Apttus_Config2__LineItem__c lineitem : ListOfLineItems1){
          lineitemId.add(lineitem.id);
        }
        
        List<Apttus_Config2__PriceMatrixEntry__c> listPriceEntries = new List<Apttus_Config2__PriceMatrixEntry__c>();
        listPriceEntries = [Select Name, Apttus_Config2__Sequence__c, Apttus_Config2__Dimension1Value__c, Apttus_Config2__Dimension2Value__c, 
                            Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,
                            Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__r.Name, Apttus_Config2__Dimension3Value__c,
                            Apttus_Config2__Dimension4Value__c from Apttus_Config2__PriceMatrixEntry__c where ID in :pricematricentryList];
        
        Test.startTest();
        /*List<Decimal> lineNumList = new List<Decimal>{linObj1.Apttus_Config2__LineNumber__c};
        List<Decimal> lineNumList2 = new List<Decimal>{linObj12.Apttus_Config2__LineNumber__c};
        
         List<Apttus_Config2__LineItem__c> liSOList = [select id, Apttus_Config2__MaxPrice__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c,Apttus_Config2__NetPrice__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList];
        List<Apttus_Config2__LineItem__c> liSOList2 = [select id, Apttus_Config2__MaxPrice__c, Apttus_Config2__NetPrice__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c from Apttus_Config2__LineItem__c where Apttus_Config2__LineNumber__c IN :lineNumList2];
        update liSOList;
        update liSOList2;
         priceCartLines(prodConfig.ID);*/

         system.debug('########### Line Item OBJECT >>>'+linObj);
         system.debug('Line__Item Business Unit >>>'+linObj.APTS_Proposal_Business_Unit__c);
         system.debug('Line__Item PAGEO Price >>>'+linObj.APTS_PAGEO_Price__c);
         APTS_FL_PricingCallbackMethods.setYear2_3Price(ListOfLineItems1);  
         APTS_FL_PricingCallbackMethods.setDirectoriesBasePrice(lineItemsList);
         APTS_FL_PricingCallbackMethods.yoypriceUpdate(lineItemsList,listPriceEntries);
         APTS_FL_PricingCallbackMethods.findlawdefaultContractTerm(bundleItems, lineNumberToOptionsMap,prodConfig);
         APTS_FL_PricingCallbackMethods samplerPricing=new APTS_FL_PricingCallbackMethods();
         new APTS_PricingCallback();
        Test.stopTest();
    }

    
    }