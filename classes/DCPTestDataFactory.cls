/**
 *  @description Test data factory for DCP project
 */

@isTest
public without sharing class DCPTestDataFactory{

    public static Map<String, SObject> objectToDataMap = new Map<String, SObject>();

    /**
        @description Declares and maps SObjects
        @return Returns a map of SObjects and its data
     */
    public static Map<String, SObject> declareSObjectData(){
        createAccount();
        createSSD();
        createContact();
        createOpportunity();
        createPriceBook();
        createApttusPriceList();
        createProposal();
        createCart();
        createProduct2();
        createPriceListItem();
        createPriceMatrix();
        createPriceMatrixEntry();
        createLineItem();
        createProposalLineItem();

        //Method call to insert default custom settings that is required by other classes
        insertCustomSettings();

        return objectToDataMap;
    }

    /**
        @description Inserts LTS_Disable_Application_Automation__c to disable triggers/workflows/validations/process builders
     */
    public static void disableApplicationAutomation(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
    }

    //Inserts custom settings needed by other classes/packages/etc
    private static void insertCustomSettings(){

        //Create custom settings and data for TRWaysSales managed package
        List<TRWaySales__Opp_Stage_Ack_Field_Config__c > oppAckList = new List<TRWaySales__Opp_Stage_Ack_Field_Config__c > ();
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Appointment Scheduled', TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c'));
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Contract Signed', TRWaySales__Opp_Ack_Field_API_Name__c = 'Contract_Signed_Ack__c'));
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Generate Contract', TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c'));
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Needs Analysis', TRWaySales__Opp_Ack_Field_API_Name__c = 'Needs_Analysis_Ack__c'));
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Negotiate Contract', TRWaySales__Opp_Ack_Field_API_Name__c = 'Negotiate_Contract_Ack__c'));
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Order Complete', TRWaySales__Opp_Ack_Field_API_Name__c = 'Order_Complete_Ack__c'));
        oppAckList.add(new TRWaySales__Opp_Stage_Ack_Field_Config__c(Name = 'Trial/Demo/ Solution Recommended', TRWaySales__Opp_Ack_Field_API_Name__c = 'Trial_Demo_Solution_Recommended_Ack__c'));

        insert oppAckList;

        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitObj = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(Name = 'Criteria and I Ack Settings', TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true, TRWaySales__I_acknowledge_required__c = true, TRWaySales__I_acknowledge_exception__c = 'TR Legal Sales Rep');

        insert exitObj;
    }
    
    private static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.SAPAccountNumber__c = '1004284494';
        acc.APTS_Band_Number__c = 1;
        acc.APTS_Customer_Category__c = '3';
        acc.APTS_eOutput_Eligibilty__c = '';
        acc.BillingCountry = 'US';
        acc.BillingState = 'IL';
        acc.BillingPostalCode = '60603-3801';
        objectToDataMap.put('Account',acc);
        return acc;
    }
    
    private static Source_System_Detail__c createSSD(){
        Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.RecordtypeId = ssdRecorType;
        ssd.Name = 'ABC';
        ssd.Source_System_Name__c = 'ABC';
        ssd.Account_Inactive__c = false;
        ssd.LCRM_SAP_Account_Number__c = '1004284494';
        ssd.BU_Segment_Level_2__c = 'Small Law';
        ssd.LCRM_APTS_Band_Number__c = 1;
        ssd.APTS_Customer_Category__c = '3';
        ssd.LCRM_eOutput_Eligibility__c = '';
        ssd.LCRM_Sales_Org__c = 'WEST';
        ssd.State__c = 'CA';
        ssd.LCRM_Customer_Group__c = 'FIRM';
        
        objectToDataMap.put('Source_System_Detail__c',ssd);
        return ssd;
        
        //Variable fields to be populated with desired value
        //ssd.Account_Name__c = acc.ID;
    }
    
    private static Contact createContact(){
        Contact con = new Contact();
        con.LastName = 'testContact';
        con.FirstName = 'testContact';
        con.email = 'testfirst.testlast@test.com';
        con.SAP_Role__c = 'EML ORDER CONFIRM';
        objectToDataMap.put('Contact',con);
        return con;

        //Variable fields to be populated with desired value
        //con.AccountId = acc.Id;
    
    }
    
    private static Opportunity createOpportunity(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.isdigitalSpearhead__c = TRUE;
        opp.CloseDate = System.Today() + 30;
        opp.StageName = 'Appointment Scheduled';
        opp.Renewal_Date__c = System.Today() + 1;
        opp.Status__c = 'Unworked';
        opp.Campaign_Code__c = '00237KI';
        opp.LCRM_Sub_BU__c = 'SubBU';
        opp.LATAM_Business_Unit__c = 'Not Latam';
        opp.Owner = getUser();
        objectToDataMap.put('Opportunity',opp);
        return opp;

        //Variable fields to be populated with desired value
        /*
        opp.Pricebook2id = pbook.id;
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = accssdid;
        opp.Key_Contact__c = contactId;
        */
    }
    
    private static PriceBook2 createPriceBook(){
        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        objectToDataMap.put('PriceBook2',pbook);
        return pbook;
    }

    private static Apttus_Config2__PriceList__c createApttusPriceList(){
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.name = 'Thomson Reuters Master - US Legal';
        objectToDataMap.put('Apttus_Config2__PriceList__c',priceList);
        return priceList;
    }

    private static User getUser(){
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        return [SELECT id, name FROM User WHERE ProfileId =: p1.id limit 1];
    }
    private static Apttus_Proposal__Proposal__c createProposal(){
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
        prop.Apttus_Proposal__Proposal_Name__c = 'Test Proposal';
        prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
        prop.Digital_Quote_Type__c = 'Best Value';
        prop.Digital_Batch_Processed__c = TRUE;
        prop.Apttus_Proposal__Primary__c = FALSE;
        prop.DC_Updated_On_Configurator__c = TRUE;
        prop.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        prop.APTS_Proposal_Business_Unit__c = 'SCS';
        prop.APTS_Payment_Option__c = 'Bill to Account';
        objectToDataMap.put('Apttus_Proposal__Proposal__c',prop);

        return prop;        
        
        //Variable fields to be populated with desired value
        /*
        prop.Apttus_Proposal__Opportunity__c = oppId;
        prop.Apttus_Proposal__Account__c = accountId;
        prop.APTS_SSD_Sold_To__c = accssdid;
        prop.APTS_SSD_bill_to__c = accssdid;
        prop.APTS_SSD_ship_to__c = accssdid;
        prop.Apttus_QPConfig__BillToAccountId__c = accountId;
        prop.Apttus_QPConfig__ShipToAccountId__c = accountId;
        prop.APTS_Order_Confirmation_Contact__c = contactId;
        prop.Apttus_QPConfig__PriceListId__c = pBookId;
        */
    }
    
    /**
    @description Creating test data for Cart.
    @return The Test cart with populated fields
    */
    public static Apttus_Config2__ProductConfiguration__c createCart() {
        Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
        cart.Name = 'Test Cart';
        cart.Apttus_Config2__VersionNumber__c = 1;
        cart.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        cart.Apttus_Config2__Status__c = 'New';
        cart.Apttus_Config2__IsTransient__c = true;
        objectToDataMap.put('Apttus_Config2__ProductConfiguration__c',cart);
        
        /*
            Variable fields to be populated with desired value
            cart.Apttus_QPConfig__Proposald__c = proposalId;
            cart.Apttus_Config2__BusinessObjectId__c = proposalId;
            cart.APTS_SSD_bill_to__c = ssdid;
            cart.APTS_SSD_Ship_To__c = ssdid;
            cart.Apttus_Config2__BillToAccountId__c = accountId;
            cart.Apttus_Config2__ShipToAccountId__c = accountId;
            cart.Apttus_Config2__AccountId__c = accountId;
            cart.Apttus_Config2__PriceListId__c = apttuspriceListId;
        */
        return cart;
    }
    
    private static Product2 createProduct2(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.List_Price__c = 0;
        prod.Format__c = 'Online';
        prod.Is_Orderable__c = TRUE;
        prod.IS_WP_Eligible__c = TRUE;
        prod.Media_High_Level__c = 'Online';
        prod.Service_Number__c = '1234567890';
        prod.Subscription_Number__c = '1234567890';
        prod.APTS_Product_Pricing_Model__c = 'Banded';
        prod.APTS_Media_High_Level_Code__c = '06';
        prod.APTS_Media_Lower_Level_Code__c = 'E5';
        prod.Family = 'WESTLAW';
        prod.Apttus_Filter_Media__c = 'Online';
        prod.Apttus_Filter_Brand_Code__c = '064';
        prod.Productcode = '1234567890';
        prod.isActive = true;
        prod.CurrencyIsoCode = 'USD';
        
        objectToDataMap.put('Product2',prod);
        return prod;
    }

    private static Apttus_Config2__PriceListItem__c createPriceListItem() {
        Apttus_Config2__PriceListItem__c priceListItem = new Apttus_Config2__PriceListItem__c();
        priceListItem.Apttus_Config2__Active__c = true;
        objectToDataMap.put('Apttus_Config2__PriceListItem__c',priceListItem);
        
        /*
        Variables to be populated with desired value
        priceListItem.Apttus_Config2__PriceListId__c = priceList;
        priceListItem.Apttus_Config2__ProductId__c = product;
        */
        return priceListItem;
    }

    
    private static Apttus_Config2__PriceMatrix__c createPriceMatrix() {

        Map<String,String> dimensionNameToSourceMap = new Map<String,String>();
        dimensionNameToSourceMap.put('Quantity','Apttus_Config2__Quantity__c');
        dimensionNameToSourceMap.put('Customer_Pricing_Segment','Customer_Pricing_Segment__c');
        Map<String,Apttus_Config2__PriceDimension__c> priceDimensionMap = createPriceDimension(dimensionNameToSourceMap);

        Apttus_Config2__PriceMatrix__c priceMatrix = new Apttus_Config2__PriceMatrix__c();
        priceMatrix.Apttus_Config2__MatrixType__c = 'Dimension';
        priceMatrix.Apttus_Config2__Sequence__c = 0;
        priceMatrix.Apttus_Config2__Dimension1Id__c = priceDimensionMap.get('Quantity').id;
        priceMatrix.Apttus_Config2__Dimension1ValueType__c = 'Range';
        priceMatrix.Apttus_Config2__Dimension2Id__c = priceDimensionMap.get('Customer_Pricing_Segment').id;
        priceMatrix.Apttus_Config2__Dimension2ValueType__c = 'Discrete';
        objectToDataMap.put('Apttus_Config2__PriceMatrix__c',priceMatrix);
        return priceMatrix;

        
        /*
        Variables to be populated with desired value
        priceMatrix.Apttus_Config2__PriceListItemId__c = priceListItem;
        */

    }
    // Customer_Pricing_Segment__c  Apttus_Config2__Quantity__c
    private static Map<String,Apttus_Config2__PriceDimension__c> createPriceDimension(Map<String,String> dimensionNameToSourceMap) {

        Map<String,Apttus_Config2__PriceDimension__c> priceDimensionMap = new Map<String,Apttus_Config2__PriceDimension__c>();

        for(String name : dimensionNameToSourceMap.keySet()){
            Apttus_Config2__PriceDimension__c pd = new Apttus_Config2__PriceDimension__c();
            pd.Apttus_Config2__ContextType__c = 'Line Item';
            pd.name = name;
            pd.Apttus_Config2__Type__c = 'Standard';
            pd.Apttus_Config2__BusinessObject__c = 'Apttus_Config2__LineItem__c';
            pd.Apttus_Config2__Datasource__c = dimensionNameToSourceMap.get(name);

            priceDimensionMap.put(name,pd);
        }

        List<Apttus_Config2__PriceDimension__c> priceDimensionList = priceDimensionMap.values();
        insert priceDimensionList;

        return priceDimensionMap;
    }

    private static Apttus_Config2__PriceMatrixEntry__c createPriceMatrixEntry() {
        Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry = new Apttus_Config2__PriceMatrixEntry__c();
        priceMatrixEntry.Apttus_Config2__EntryKey__c = 'Law Firm';
        priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c = 10.00;
        priceMatrixEntry.Apttus_Config2__AdjustmentType__c = 'List Price Override';
        priceMatrixEntry.Apttus_Config2__Sequence__c = 1;
        priceMatrixEntry.Apttus_Config2__Dimension1Value__c = '1'; //Quantity
        priceMatrixEntry.Apttus_Config2__Dimension2Value__c = 'Law Firm';
        objectToDataMap.put('Apttus_Config2__PriceMatrixEntry__c',priceMatrixEntry);

        return priceMatrixEntry;

        /*
        Variables to be populated with desired value
        priceMatrixEntry.Apttus_Config2__PriceMatrixId__c = priceMatrix;
        */
    }

    /**
    @description Creating test data for Cart Line Item.
    @return The Test cart line item with populated fields
    */
    public static Apttus_Config2__LineItem__c createLineItem(){        
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ListPrice__c = 500;
        lineItem.Apttus_Config2__BasePrice__c = 200;
        lineItem.Apttus_Config2__AdjustedPrice__c = 0;
        lineItem.Apttus_Config2__NetPrice__c = 600;
        lineItem.Apttus_Config2__ExtendedPrice__c = 700;
        lineItem.Apttus_Config2__StartDate__c = system.today();
        lineItem.Apttus_Config2__EndDate__c = system.today().addDays(30);
        lineItem.Apttus_Config2__AdjustmentAmount__c = 5.0;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__Term__c = 12;
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 10.0;
        lineItem.Apttus_Config2__OptionPrice__c = 5.0;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceAdjustment__c = 0;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c = '7';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '5';
        lineItem.Apttus_Config2__ItemSequence__c = 1; // added by Kavya G DCP-1693
        lineItem.Apttus_Config2__LineNumber__c = 1; //added by KavyaG DCP-1693


        objectToDataMap.put('Apttus_Config2__LineItem__c',lineItem);
        
        return lineItem;

        //Variable fields to be populated with desired value
        /*
        lineItem.Apttus_Config2__ConfigurationId__c = configId
        lineItem.Apttus_Config2__LineNumber__c = lineNumber;
        lineItem.Apttus_Config2__ItemSequence__c = itemSequence;
        lineItem.Apttus_Config2__IsPrimaryLine__c = isPrimaryLine;
        lineItem.Apttus_Config2__LineType__c = lineType;
        lineItem.Apttus_Config2__ProductId__c = productId;
        lineItem.Apttus_Config2__OptionId__c = optionId;
        lineItem.Apttus_Config2__Quantity__c = quantity;
        lineItem.Apttus_Config2__PriceListId__c = priceListId;
        lineItem.Apttus_Config2__PriceListItemId__c = plItemId;
        lineItem.Apttus_Config2__HasOptions__c = isBundle;
        lineItem.DC_Is_Add_On__c = isAddOn;
        */
    }
    private static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem() {
        Apttus_Proposal__Proposal_Line_Item__c newLineItem2 = new Apttus_Proposal__Proposal_Line_Item__c();
        newLineItem2.Apttus_QPConfig__IsOptionRollupLine__c = true;
        newLineItem2.APTS_Yearly_Total__c = 300.00;

        objectToDataMap.put('Apttus_Proposal__Proposal_Line_Item__c',newLineItem2);
        return newLineItem2;

        //Variable fields to be populated with desired value
        /*
        newLineItem2.APTS_Subscription_Number__c = subscNumber;
        newLineItem2.Apttus_Proposal__Product__c = productId;
        newLineItem2.Apttus_Proposal__Proposal__c = propId;
        */
    }


}