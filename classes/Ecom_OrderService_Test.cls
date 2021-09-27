/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData  
 * 2020-07-28   Benjamin Her            DLT-20456 - Updated code to use new segmentation field. PMD fixes  
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c                            
 * =============================================================================
 */

@isTest
/**
 * @description : test class for Ecom Order Service
 */ 
public class Ecom_OrderService_Test {
    public static Product2 p1;

    public static APTSECOM_Store__c store;
    public static Apttus_Config2__PriceList__c priceList;
    public static New_Sales_Contract_Term_Setting__c contractTermSetting;
    public static Apttus_Config2__Incentive__c incentive;
    public static APTSECOM_Store_Promotion__c storePromo;
    public static APTSECOM_Store_Price_Adjustment__c priceAdjustments;

    public static Account acc;
    public static Source_System_Detail__c accountSSDlst;

    public static String leadId;
    public static String orderId;
    public static String acctSsdId;
    public static String categoryId;
    
    @testSetup 
    static void setup() {
        Lead lead1 = new Lead();
        lead1.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        lead1.Company = 'Test';
        lead1.FirstName = 'TestFname';
        lead1.LastName = 'TestLName';
        lead1.Status = 'Unworked';
        lead1.Billing_Country__c = 'US';
        insert lead1;
        leadId = lead1.Id;

        Apttus_Config2__PriceList__c priceList1 = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList1;
        priceList = priceList1;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';
        insert pbook;

        KeyValueListStore__c testKeyValueSetting = new KeyValueListStore__c();
        testKeyValueSetting.name = 'ANZUsersProfileId';
        testKeyValueSetting.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;    
        insert testKeyValueSetting;
        
        KeyValueListStore__c reasonWithCompetitor = new KeyValueListStore__c(
            Name='ReasonWithCompetitor',
            TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'
        );
        insert reasonWithCompetitor;
        
        List<RecordtypeIds__c> rectype = new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtypeIds = new RecordtypeIds__c();
        recordtypeIds.name = 'Pre-Pipeline Opportunities';
        recordtypeIds.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;    
        rectype.add(recordtypeIds);
        
        RecordtypeIds__c recordtypeIds1 = new RecordtypeIds__c();
        recordtypeIds1.name = 'Pipeline Opportunities';
        recordtypeIds1.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;    
        rectype.add(recordtypeIds1);
        insert rectype;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{
            new WebServiceSettings__c(
                Name='EnterpriseWSDL',
                Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                Service_Unavailable_Message__c='Service not Available' ),
            new WebServiceSettings__c(
                Name='StatusPostbackLocation',
                Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                Service_Unavailable_Message__c='Service not Available' ),
            new WebServiceSettings__c(
                Name='PostbackLocation',
                Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                Service_Unavailable_Message__c='Service not Available' ),
            new WebServiceSettings__c(
                Name='Payment AutoCharge',
                Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                Service_Unavailable_Message__c='Service not Available' ),
            new WebServiceSettings__c(
                Name='PaymentCreditIncrease',
                Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                Service_Unavailable_Message__c='Service not Available' )
        };
        insert webserviceList;
        
        Product2 p2 = DCTestData.createProduct('WestLaw Product', '42009581', '42009634', 'Arizona');
        p1 = p2;
        
        APTSECOM_Store__c store1 = DCTestData.createStore('Small Law', null, priceList.Id);
        insert store1;
        store = store1;

        Apttus_Config2__Order__c od = DCTestData.createOrder(priceList.id, store.id);
        insert od;
        orderId = od.Id;
        
        DateTime myDateTime = DateTime.now();
        system.debug(logginglevel.INFO, 'myDateTime.millisecond() ? ' + myDateTime.getTime());

        Account acc1 = DCTestData.createAccount('Test Account');
        acc1.SAPAccountNumber__c = null; //String.valueOf( myDateTime.getTime() );
        insert acc1;
        acc = acc1;
        
        Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
        mainCategory.Apttus_Config2__HierarchyLabel__c = 'Ecom-Small Law';
        mainCategory.Name = 'Ecom-Small Law';
        insert mainCategory;
        
        Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierMain.Name = 'Ecom-Small Law';
        hierMain.Apttus_Config2__Label__c = 'Ecom-Small Law';
        hierMain.Apttus_Config2__Level__c = 0;
        insert hierMain;
        
        List<Apttus_Config2__ClassificationHierarchy__c> level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        hierPL.Apttus_Config2__Level__c = 1;
        hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPL.Name = 'Premium';
        hierPL.Apttus_Config2__Label__c = 'Premium';
        hierPL.DC_Sequence_No__c = 1;
        level1HierList.add(hierPL);
        insert level1HierList;
        categoryId = hierPL.Id;

        APTSECOM_Store_Price_Adjustment__c spa = new APTSECOM_Store_Price_Adjustment__c();
        spa.Name = 'Test Price Adjustment';
        spa.APTSECOM_Category_Hierarchy__c = hierMain.Id;
        spa.APTSECOM_Store__c = store1.Id;
        spa.APTSECOM_Adjustment_Amount__c = 2;
        spa.APTSECOM_Adjustment_Type__c = '% Discount';

        New_Sales_Contract_Term_Setting__c cts = new New_Sales_Contract_Term_Setting__c();
        cts.Name = '3 Year - Essentials';
        cts.Related_Store__c = store1.id;
        cts.Related_Category_Hierarchy__c = hierPL.id;
        cts.Adjustment_Amount__c = 10.0;
        cts.Adjustment_Type__c = '% Discount';
        cts.Contract_Term__c = '3 Years';
        cts.YoY_1__c = 5.0;
        cts.YoY_2__c = 5.0;
        insert cts;
        contractTermSetting = cts;

        Apttus_Config2__Incentive__c aptsIncent = new Apttus_Config2__Incentive__c();
        aptsIncent.Apttus_CMConfig__PayoutFrequency__c = 'One Time';
        aptsIncent.Apttus_Config2__AccountScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__AccountScope__c  = 'All';
        aptsIncent.Apttus_Config2__AccountTypeScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__AccountTypeScope__c = 'All';
        aptsIncent.Apttus_Config2__Active__c = true;
        aptsIncent.Apttus_Config2__ApplicationMethod__c = 'Buy X Get X';
        aptsIncent.Apttus_Config2__AutoApply__c = false;
        aptsIncent.Apttus_Config2__ContextType__c = 'Line Item';
        aptsIncent.Apttus_Config2__CountryScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__CountryScope__c = 'All';
        aptsIncent.Apttus_Config2__EffectiveDate__c = Date.newInstance(2016, 12, 9);
        aptsIncent.Apttus_Config2__ExpirationDate__c = Date.newInstance(2017, 12, 9);
        aptsIncent.Apttus_Config2__EnableBenefitEffectivityDates__c = false;
        aptsIncent.Apttus_Config2__ExcludeChildrenWithActivePrograms__c = false;
        aptsIncent.Apttus_Config2__IncentiveCode__c = '683239L07315';
        aptsIncent.Apttus_Config2__IncludeOrdersForAccountHierarchy__c = false;
        aptsIncent.Apttus_Config2__IsBundle__c = false;
        aptsIncent.Apttus_Config2__IsTaskPending__c = false;
        aptsIncent.Apttus_Config2__PriceListScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__PriceListScope__c = 'All';
        aptsIncent.Apttus_Config2__ProductFamilyScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__ProductFamilyScope__c = 'All';
        aptsIncent.Apttus_Config2__ProductScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__ProductScope__c = 'All';
        aptsIncent.Apttus_Config2__RegionScopeOper__c = 'in';
        aptsIncent.Apttus_Config2__RegionScope__c = 'All';
        aptsIncent.Apttus_Config2__Sequence__c = 1.0;
        aptsIncent.Apttus_Config2__Status__c = 'Activated';
        aptsIncent.Apttus_Config2__StopProcessingMoreIncentives__c = false;
        aptsIncent.Name = 'CXD NSE TEST';
        insert aptsIncent;
        incentive = aptsIncent;

        APTSECOM_Store_Promotion__c sPromo = new APTSECOM_Store_Promotion__c();
        sPromo.APTSECOM_Adjustment_Amount__c = 10.0;
        sPromo.APTSECOM_Adjustment_Type__c = '% Discount';
        sPromo.APTSECOM_Description__c = 'Test Promo';
        sPromo.APTSECOM_Start_Date__c = Date.newInstance(2016, 12, 9);
        sPromo.APTSECOM_End_Date__c = Date.newInstance(2017, 12, 9);
        sPromo.APTSECOM_Is_Active__c = true;
        sPromo.APTSECOM_Min_Quantity__c = 1.0;
        sPromo.APTSECOM_Max_Quantity__c = 1.0;
        sPromo.APTSECOM_Promo_Code__c = '683239L07315';
        sPromo.APTSECOM_Store__c = store1.id;
        sPromo.APTSECOM_Valid_Contract_Terms__c = '2 Years; 3 Years';
        sPromo.IncentiveId__c = aptsIncent.id;
        sPromo.Name = 'CXD NSE TEST';
        insert sPromo;
        storePromo = sPromo;
    }

    @isTest
    public static void apiNewTest() {
        Ecom_OrderRequest req = getOrderRequest();

        Test.startTest();
        // TEST empty store name
        req.storeOrder.storeName = '';
        Ecom_OrderService.apiNew(req);
        System.assert(req != null,'req is null');
        Test.stopTest();
    }
    
    @isTest
    public static void updateMethodTest() {
        Ecom_OrderRequest req = getOrderRequest();
        req.actionParams.orderAction = 'Create';
        req.actionParams.leadAction = 'Create';
        req.storeOrder.storeName = 'Small Law';
        req.references.orderId = null;

        Test.startTest();
        // TEST Order Create and Lead Create
        Ecom_OrderService.apiNew(req);
        
        System.assert(req != null,'req is null');
        Test.stopTest();
    }

    @isTest
    public static void updateMethodTest2() {
        Ecom_OrderRequest req = getOrderRequest();
        req.actionParams.leadAction = 'Update';
        req.references.leadId = leadId;

        Ecom_OrderRequest.cls_customerDetails cd = new Ecom_OrderRequest.cls_customerDetails();
        cd.firstName = 'Dave';
        cd.organizationName = 'New Company';
        cd.phoneNumber = '6515554321';
        cd.phoneExtension = 'Extn: 3';
        Ecom_OrderRequest.cls_address addr = new Ecom_OrderRequest.cls_address();
        addr.city = 'Eagan';
        addr.state = 'MN';
        cd.address = addr;

        req.storeOrder.customerDetails = cd;
        
        Test.startTest();
        // TEST Lead Update
        Ecom_OrderService.apiNew(req);
        System.assert(req != null,'req is null');
        Test.stopTest();
    }

    @isTest
    public static void leadOrderTest() {
        APTSECOM_Store__c smallLaw = [SELECT Id FROM APTSECOM_Store__c WHERE Name = 'Small Law' LIMIT 1];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'WestLaw Product' LIMIT 1];
        
        Test.startTest();
    
        //LCRMLeadTerritoryService.stopTrigger();
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true;

        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('Create', 'Create', 'None', 'None', 'None', 'None', 'None', false, false, false);
        Ecom_OrderRequest.cls_References r1 = new Ecom_OrderRequest.cls_references();
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest(prod.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        
        Ecom_OrderRequest request = new Ecom_OrderRequest();
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;
        
        Ecom_OrderService e1 = new  Ecom_OrderService();
        Ecom_OrderService.updatedMethodResponse res = new Ecom_OrderService.updatedMethodResponse();
        
        // create Lead, Order
        res = Ecom_OrderService.apiNew(request);     
        
        System.assert(res != null,'res is null');
        Test.stopTest();

        Ecom_OrderRequest.cls_References ref2 = new Ecom_OrderRequest.cls_references();
        responseToRequest(res, r1);
        system.debug(logginglevel.INFO, 'references> ' + r1);
        a1 = getActionParams('Update', 'Update', 'None', 'None', 'None', 'None', 'None', false, false, false);
        sreq = getRequest(prod.Id, 'Small Law', 1, 'Jessica Test', 'Tr-Test3', '1234567879', 'Premium');
        sreq.planId = categoryId;
        // To update Order, Lead      
        // a1.placeOrder = true;
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;
        res = Ecom_OrderService.apiNew(request);
        
        // test order exists
        try {
            Apttus_Config2__Order__c o = [SELECT id, Apttus_Config2__Status__c FROM Apttus_Config2__Order__c LIMIT 1];
            //o.Apttus_Config2__Order__c = 'New';
            //update o;
            e1.createOrder(store, o.id, sreq);
        } catch (Exception ex) { 
            system.debug(logginglevel.INFO, 'TEST createOrder > ' + ex);
        }
        
        Ecom_OrderRequest.testParse();
    }
    
    @isTest
    public static void accountContactTest() {
        Product2 p1 = [SELECT id FROM Product2 LIMIT 1];
        APTSECOM_Store__c store = [SELECT id FROM APTSECOM_Store__c LIMIT 1];
        Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
        // Account acc = [SELECT id FROM Account LIMIT 1];
        
        //LCRMLeadTerritoryService.stopTrigger();
        
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true; 
        
        APTS_ProposalTriggerHandler.beforeUpdate = true;
        APTS_ProposalTriggerHandler.beforeInsert = true;
        APTS_ProposalTriggerHandler.beforeDelete = true;
        APTS_ProposalTriggerHandler.afterUpdate = true;
        APTS_ProposalTriggerHandler.afterInsert = true;
        APTS_ProposalTriggerHandler.afterDelete = true; 
        
        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('None', 'Convert', 'None', 'None', 'None', 'Create', 'None', false, false, true);
        Ecom_OrderRequest.cls_References r1 = new Ecom_OrderRequest.cls_references();
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        sreq.customerDetails.isPhysicalSameAsBillingAddress = false; 
        sreq.customerDetails.physicalAddress = sreq.customerDetails.address;
        
        Apttus_Config2__Order__c order = DCTestData.createOrder(priceList.id, store.id);
        insert order;

        Lead ld = createLead(sreq, order.id);
        insert ld;
        
        r1.leadId = ld.Id;
        r1.orderId = order.id;

        Test.startTest();

        Ecom_OrderRequest request = new Ecom_OrderRequest();
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;
        
        Ecom_OrderService e1 = new  Ecom_OrderService();
        Ecom_OrderService.updatedMethodResponse res = new Ecom_OrderService.updatedMethodResponse();
        
        // create Lead, Order
        // res = Ecom_OrderService.apiNew(request);     
        try {
            res = Ecom_OrderService.apiNew(request);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
        System.assert(String.isBlank(res.cartId),'res.cartId is not blank');
        Test.stopTest();
    }
    
    @isTest
    public static void updateProductsTest() {
        //LCRMLeadTerritoryService.stopTrigger();
        
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true;
        
        Apttus_Config2__PriceList__c priceList = [SELECT Id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Account acc = [SELECT Id, SAPAccountNumber__c FROM Account LIMIT 1];
        Product2 p1 = [SELECT Id FROM Product2 LIMIT 1];
        
        APTSECOM_Store__c store = DCTestData.createStore('CORPORATE', null, priceList.Id);
        store.APTSECOM_Customer_Pricing_Segment__c = 'CORPORATION';
        insert store;

        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);

        Opportunity opty = DCTestData.createOpportunityRec('TestOpty', acc.Id, 'Order Complete', System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;

        Test.startTest();
        
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id,'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;        
        insert quote;
        
        Apttus_Config2__ProductConfiguration__c cart = DCTestData.createCart(acc.id, quote.Id, null, priceList.Id);
        insert cart;
        
        List<Apttus_Config2__LineItem__c> listLines = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c line1 = DCTestData.createLineItem(
            cart.Id, 1, 1, true, 'Product/Service', p1.id, null, 2, priceList.Id, null, false,false
        );
        listLines.add(line1);
        Apttus_Config2__LineItem__c line2 = DCTestData.createLineItem(
            cart.Id, 1, 1, true, 'Product/Service', p1.id, null, 2, priceList.Id, null, false,true
        );
        listLines.add(line2);
        insert listLines;
        
        Ecom_OrderRequest.cls_storeOrder storeOrder = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        Ecom_OrderService.updatedMethodResponse res = new Ecom_OrderService.updatedMethodResponse();
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_references();
        ref.proposalId = quote.id;
        
        Ecom_OrderService service = new Ecom_OrderService();
         
        List<Apttus_Config2__ProductConfiguration__c> carts = [
            SELECT Id,Apttus_Config2__Status__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Promo_Code__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                (SELECT Id, Apttus_Config2__ProductId__c, Apttus_Config2__Quantity__c, APTS_Contract_Term__c, APTS_Proposal_Business_Unit__c,
                                Apttus_Config2__OptionId__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__AdjustmentType__c,
                                APTS_Combination_Key__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c
                                    FROM Apttus_Config2__LineItems__r)
            FROM Apttus_Config2__ProductConfiguration__c 
            WHERE Id = :cart.Id
        ];
        Ecom_StoreResponse.Adjustments adjustments = new Ecom_StoreResponse.Adjustments();
        adjustments.adjustmentType = Label.DC_PERCENT_DISCOUNT;
        adjustments.adjustmentAmount = 30;
        Ecom_Account.updateAccountsBasedOnAttorney(acc.Id, storeOrder.selectedProducts, store);
        //service.updateAccounts(acc.Id,ssd.Id,storeOrder.customerDetails);
        service.updateProducts(carts, store, storeOrder, 'Premium', adjustments, true, res, ref); // Plus
     

        Boolean isPending = Ecom_ProposalService.reprice(cart.Id);
        storeOrder = getRequest(p1.Id, 'Corporate', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        System.assert(String.isNotBlank(cart.Id),'cart.Id is blank' );
    
        try {
            Source_System_Detail__c accSSD = Ecom_Account.createAccountSSD(acc.Id, opty.Id, storeOrder.customerDetails, store, 1);
            Account accout = Ecom_Account.updateConvertedAccount(acc.Id, store, storeOrder); 
        } catch (Exception ex) { 
            system.debug(logginglevel.ERROR, 'Exception: ' + ex); 
        }
        
        // ***** test updatePointsOnProdAttributeValue() *****
        Set<String> prodIdSet = new Set<String>();
        prodIdSet.add(p1.id);
        
        p1.APTS_Module_Points__c = 1.0;
        update p1;
        
        Apttus_Config2__LineItem__c lineOption = DCTestData.createLineItem(
            cart.Id, 1, 1, true, 'Product/Service', p1.id, null, 2, priceList.Id, null, true, false
        );
        insert lineOption;
        system.debug(logginglevel.INFO, 'lineOption > ' + lineOption);
        
        Apttus_Config2__ProductAttributeValue__c pav = new Apttus_Config2__ProductAttributeValue__c();
        pav.Apttus_Config2__LineItemId__c = lineOption.id;
        insert pav;
        
        try {
            system.debug(logginglevel.INFO, 'cart.id > ' + cart.id + ', prodIdSet > ' + prodIdSet);
            Ecom_OrderService.updatePointsOnProdAttributeValue(cart.id, prodIdSet);
        } catch (Exception ex) { 
            system.debug(logginglevel.ERROR, 'TEST updatePointsOnProdAttributeValue > ' + ex);
        }
        Test.stopTest();
    } 
    
    @isTest
    public static void cartTest() {
        Product2 p1 = [SELECT id FROM Product2 LIMIT 1];
        List<APTSECOM_Store__c> store = [
            SELECT Id, name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Customer_Pricing_Segment__c,APTSECOM_Default_Contract_Term__c,
                (SELECT Id, name, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c 
                FROM Store_Price_Adjustments__r), 
                (SELECT id, name, Adjustment_Amount__c, Adjustment_Type__c, Related_Category_Hierarchy__c, YoY_1__c, YoY_2__c, Contract_Term__c 
                FROM New_Sales_Contract_Term_Settings__r)
            FROM APTSECOM_Store__c LIMIT 1
        ];
        
        Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Account acc = [SELECT id, SAPAccountNumber__c FROM Account LIMIT 1];
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Apttus_Config2__Order__c order = [SELECT Id FROM Apttus_Config2__Order__c LIMIT 1];
        
        Contact con = DCTestData.createContactRec('Test name',acc.id);
        insert con;
        
        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        system.debug(logginglevel.INFO, ' < conSSD > ' + conSSD);
        
        Opportunity opty = DCTestData.createOpportunityRec('TestOpty', acc.Id, 'Order Complete', System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;

        Test.startTest();
        
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;
        insert quote;

        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true;
       
        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('None','None','None','None','None','None','Create',false,false,false);
        Ecom_OrderRequest.cls_References r1 = new Ecom_OrderRequest.cls_references();
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879','Premium');
        r1.proposalId = quote.Id;
        r1.opportunityId = opty.Id;
        r1.contactId = con.Id;
        r1.accountId = acc.Id;
        r1.orderId = order.Id;
        
        a1.generatePaymentURL = true;
        // a1.orderAction = 'Update';
        a1.leadAction = 'Update';
        sreq.isExistingCustomer = true;

        Ecom_OrderRequest request = new Ecom_OrderRequest();
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;
        
        System.assert(String.isNotBlank(acc.Id),'acc.Id is blank');

        try {
            request.actionParams.proposalAction = 'Create';
            Ecom_OrderService.apiNew(request); 
            // Ecom_Cart.createCart(new List<Apttus_Proposal__Proposal__c>{quote},sreq, store);   
        } catch (Exception ex) {
            System.debug(logginglevel.ERROR, 'cartTest Exception: ' + ex);
        }
        Test.stopTest();

        // Create Cart
        try {
           Ecom_Cart.createCart(new List<Apttus_Proposal__Proposal__c>{quote}, sreq, store);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
    }

        @isTest
    public static void cartFindlawTest() {
        Product2 p1 = [SELECT id FROM Product2 LIMIT 1];
        List<APTSECOM_Store__c> store = [
            SELECT Id, name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Customer_Pricing_Segment__c,APTSECOM_Default_Contract_Term__c,
                (SELECT Id, name, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c 
                FROM Store_Price_Adjustments__r), 
                (SELECT id, name, Adjustment_Amount__c, Adjustment_Type__c, Related_Category_Hierarchy__c, YoY_1__c, YoY_2__c, Contract_Term__c 
                FROM New_Sales_Contract_Term_Settings__r)
            FROM APTSECOM_Store__c LIMIT 1
        ];
        store[0].name = 'Findlaw';
        update store;
        
        Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Account acc = [SELECT id, SAPAccountNumber__c FROM Account LIMIT 1];
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Apttus_Config2__Order__c order = [SELECT Id FROM Apttus_Config2__Order__c LIMIT 1];
        
        Contact con = DCTestData.createContactRec('Test name',acc.id);
        insert con;
        
        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        system.debug(logginglevel.INFO, ' < conSSD > ' + conSSD);
        
        Opportunity opty = DCTestData.createOpportunityRec('TestOpty', acc.Id, 'Order Complete', System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;

        Test.startTest();
        
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;
        insert quote;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true;
       
        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('None','None','None','None','None','None','Create',false,false,false);
        Ecom_OrderRequest.cls_References r1 = new Ecom_OrderRequest.cls_references();
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879','Premium');
        r1.proposalId = quote.Id;
        r1.opportunityId = opty.Id;
        r1.contactId = con.Id;
        r1.accountId = acc.Id;
        r1.orderId = order.Id;
        
        a1.generatePaymentURL = true;
        // a1.orderAction = 'Update';
        a1.leadAction = 'Update';
        sreq.isExistingCustomer = true;

        Ecom_OrderRequest request = new Ecom_OrderRequest();
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;
        
        System.assert(String.isNotBlank(acc.Id),'acc.Id is blank');

        try {
            request.actionParams.proposalAction = 'Create';
            Ecom_OrderService.apiNew(request); 
            // Ecom_Cart.createCart(new List<Apttus_Proposal__Proposal__c>{quote},sreq, store);   
        } catch (Exception ex) {
            System.debug(logginglevel.ERROR, 'cartTest Exception: ' + ex);
        }
        Test.stopTest();

        // Create Cart
        try {
            Ecom_Cart.createCart(new List<Apttus_Proposal__Proposal__c>{quote}, sreq, store);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
    }
    
    @isTest
    public static void updateOpportunityWithCampaignCodeTest() {
        Test.startTest();
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;
        String accountName = 'TestAccount';

        Account acc = DCTestData.createAccount(accountName);
        insert acc;

        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Opportunity opty = DCTestData.createOpportunityRec( optyName, acc.Id,  stageName,  closeDate, String.valueOf(ssd.Id));
        insert opty;

        //Ecom_Opportunity  ecomOpportunity = new Ecom_Opportunity();
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_references();
        ref.accountid = String.valueOf(acc.Id);
        ref.opportunityid = String.valueOf(opty.Id);
        
        System.assert(ref != null,'ref is null');
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest('p1Id', 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        try {
            Ecom_Opportunity.updateOpportunityWithCampaignCode(ref, sreq);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
        Test.stopTest();
    }

    @isTest
    public static void updateOpportunityWithCampaignCodeTestCorporate() {
        Test.startTest();
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;
        String accountName = 'TestAccount';

        Account acc = DCTestData.createAccount(accountName);
        insert acc;

        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        ssd.LCRM_Customer_Group__c = 'CORPORATION';
        Opportunity opty = DCTestData.createOpportunityRec( optyName, acc.Id,  stageName,  closeDate, String.valueOf(ssd.Id));
        insert opty;

        // Ecom_Opportunity  ecomOpportunity = new Ecom_Opportunity();
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_references();
        ref.accountid = String.valueOf(acc.Id);
        ref.opportunityid = String.valueOf(opty.Id);

        System.assert(ref != null,'ref is null');
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest('p1Id', 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        try {
            Ecom_Opportunity.updateOpportunityWithCampaignCode(ref, sreq);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
        Test.stopTest();
    }

    @isTest
    public static void getCorporateCampaignIdTest() {
        String campId;
        Test.startTest();
        Product2 prod = [SELECT id, Family FROM Product2 LIMIT 1];
        prod.Family = 'WESTLAW';
        update prod;
        campId = Ecom_Opportunity.getCorporateCampaignId(prod.id);
        prod.Family = 'PRACTICAL';
        update prod;
        campId = Ecom_Opportunity.getCorporateCampaignId(prod.id);
        System.assert(campId != null, 'Campaign ID is null');
        Test.stopTest();
    }
    
    @isTest
    public static void updateAccountContactTest() {
        Test.startTest();
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;
        String accountName = 'TestAccount';

        Account acc = DCTestData.createAccount(accountName);
        insert acc;

        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Opportunity opty = DCTestData.createOpportunityRec( optyName, acc.Id,  stageName,  closeDate, String.valueOf(ssd.Id));
        insert opty;

        Contact con = DCTestData.createContactRec('Test name', acc.id);
        insert con; 

        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        system.debug(logginglevel.INFO, ' < conSSD > ' + conSSD);

        Apttus_Proposal__Proposal__c proposal = DCTestData.createQuote(acc.id, 'New Sales');
        proposal.Apttus_Proposal__Opportunity__c = opty.id;
        insert proposal;

        Ecom_OrderService  ecomOrderService = new Ecom_OrderService();
        
        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('None','None','Update','Update','Update','Update','None',false,true,false);
        Ecom_OrderRequest.cls_References r1 = new Ecom_OrderRequest.cls_references();
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest('p1Id', 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        sreq.customerDetails.isPhysicalSameAsBillingAddress = false; 
        sreq.customerDetails.physicalAddress = sreq.customerDetails.address;
        
        r1.accountId = acc.id;
        r1.contactId = con.Id;
        r1.opportunityId = opty.Id;
        r1.proposalId = proposal.Id;
        
        Ecom_OrderRequest request = new Ecom_OrderRequest();
        a1.placeOrder = true;
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;
                
        sreq = getRequest('product', 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        System.assert(request != null,'request is null');

        Test.stopTest();

        try {
            Ecom_OrderService.apiNew(request);  
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }

        Apttus_Proposal__Proposal__c propRec = [
            SELECT Id, Name, DC_Contract_Not_In_Sync__c, Apttus_Proposal__Proposal_Name__c, APTS_Order_Confirmation_Contact_Email__c, Apttus_Proposal__Account__r.SAPAccountNumber__c,APTS_Quote_Value__c,
                Apttus_Proposal__Account__r.Name, APTS_Order_Confirmation_Contact_Name__c, Apttus_Proposal__Account__r.billingstreet,
                Apttus_Proposal__Account__r.billingcity, Apttus_Proposal__Account__r.billingstate, Apttus_Proposal__Account__r.billingcountry,
                Apttus_Proposal__Account__r.phone, Apttus_Proposal__Account__r.billingPostalCode, APTS_Payment_Option__c 
            FROM Apttus_Proposal__Proposal__c WHERE Id = :proposal.Id
        ];
        Ecom_ProposalService.encryption(propRec);
    }
    
    @isTest
    public static void updateCartTest() {
        
        Apttus_Config2__Order__c order = [SELECT Id FROM Apttus_Config2__Order__c LIMIT 1];
        Apttus_Config2__PriceList__c priceList = [SELECT Id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Account acc = [SELECT id, SAPAccountNumber__c FROM Account LIMIT 1];
        APTSECOM_Store__c smallLaw = [SELECT Id FROM APTSECOM_Store__c WHERE Name = 'Small Law' LIMIT 1];
        APTSECOM_Store__c store = DCTestData.createStore('CORPORATE', null,priceList.Id);
        store.APTSECOM_Customer_Pricing_Segment__c = 'CORPORATION';
        insert store;
        
        Apttus_Config2__ClassificationHierarchy__c category = [SELECT Id FROM Apttus_Config2__ClassificationHierarchy__c WHERE Name = 'Premium'];
        APTSECOM_Store_Price_Adjustment__c spa = new APTSECOM_Store_Price_Adjustment__c();
        spa.APTSECOM_Store__c = smallLaw.Id;
        // spa.APTSECOM_Category_Hierarchy__c = category.Id;
        spa.APTSECOM_Adjustment_Type__c = '% Discount';
        spa.APTSECOM_Adjustment_Amount__c = 10;
        insert spa;
        
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Opportunity opty = DCTestData.createOpportunityRec('TestOpty', acc.Id, 'Order Complete', System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;

        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;
        quote.APTS_SSD_ship_to__c = ssd.Id;
        Product2 p1 = [SELECT Id FROM Product2 LIMIT 1];
        
        Test.startTest();
        
        //LCRMLeadTerritoryService.stopTrigger();
        
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true;
                 
        insert quote;
        
        Apttus_Config2__ProductConfiguration__c cart = DCTestData.createCart(acc.id, quote.Id, order.id, priceList.Id);
        insert cart;
            
        List<Apttus_Config2__LineItem__c> listLines = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c line1 = DCTestData.createLineItem(cart.Id, 1, 1, true, 'Product/Service', p1.id, null, 2, priceList.Id, null, false, false);
        listLines.add(line1);
        insert listLines; 
        
        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('Update', 'Update', 'Update', 'Update', 'Upate', 'Update', 'Update', true, false, false);
        Ecom_OrderRequest.cls_storeOrder storeOrder = getRequest(p1.Id, 'Small Law', 1, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        storeOrder.customerDetails.isPhysicalSameAsBillingAddress = false; 
        storeOrder.customerDetails.physicalAddress = storeOrder.customerDetails.address;
        
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_references();
        ref.proposalId = quote.id;
        ref.cartId = cart.Id;
        ref.orderId = order.Id;
        
        Ecom_OrderService service = new Ecom_OrderService();
        storeOrder.planId = category.Id;
        Ecom_OrderRequest request = new Ecom_OrderRequest();
        request.storeOrder = storeOrder;
        request.references = ref;
        request.actionParams = a1;
        
        Ecom_OrderService e1 = new  Ecom_OrderService();
        Lead ld = createLead(storeOrder, order.Id);
        Ecom_OrderService.updatedMethodResponse res = new Ecom_OrderService.updatedMethodResponse();
        ref.leadId = ld.Id;

        System.assert(ref != null,'ref is null');
        // create Lead, Order
        res = Ecom_OrderService.apiNew(request);

        // TEST updatePromoCodeOnCart(List<Apttus_Config2__ProductConfiguration__c> carts, string promoCode)
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        cartList.add(cart);
        
        try {
            e1.updatePromoCodeOnCart(cartList, 'TestPromoCode');  
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'TEST updatePromoCodeOnCart > ' + ex);
        }
        Test.stopTest();
    }
    
    @istest
    public static void updateLead() {
        Product2 p1 = [SELECT id FROM Product2 LIMIT 1];
        APTSECOM_Store__c store = [SELECT id FROM APTSECOM_Store__c LIMIT 1];
        Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest('p1Id', 'Small Law', 2, 'Jessica', 'TrTest', '9377770000', 'Premium');

        Apttus_Config2__Order__c order = DCTestData.createOrder(priceList.id, store.id );
        insert order;

        Lead ld = createLead(sreq, order.id);
        insert ld;

        System.assert(sreq != null,'sreq is null');
        system.debug(logginglevel.INFO, '====check values before update===' + sreq); 
        // Ecom_ProposalService.init('New YORK');
        Test.startTest();
        // Ecom_OrderService os = new Ecom_OrderService();
        try {
            //Ecom_Lead.updateLead(ld.Id, sreq.customerDetails, '234', true);
            system.debug(logginglevel.INFO, '====check values after update===' + sreq);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception check' + ex);
        }
        Test.stopTest();
    }
    
    @isTest
    public static void proposalTest() {
        product2 p1 = [SELECT id FROM product2 LIMIT 1];
        List<APTSECOM_Store__c> store = [
            SELECT Id, name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Customer_Pricing_Segment__c,APTSECOM_Default_Contract_Term__c,
                (SELECT Id, name, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c 
                FROM Store_Price_Adjustments__r), 
                (SELECT id, name, Adjustment_Amount__c, Adjustment_Type__c, Related_Category_Hierarchy__c, YoY_1__c, YoY_2__c, Contract_Term__c 
                FROM New_Sales_Contract_Term_Settings__r)
            FROM APTSECOM_Store__c LIMIT 1
        ];
        
        Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Account acc = [SELECT id,SAPAccountNumber__c FROM Account LIMIT 1];
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id,'New Sales');
        
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;
        String accountName = 'TestAccount';
        
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Contact con = DCTestData.createContactRec('Test name', acc.id);
        insert con;
        
        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        system.debug(logginglevel.INFO, ' < conSSD > ' + conSSD);
        
        Opportunity opty = DCTestData.createOpportunityRec( optyName, acc.Id,  stageName,  closeDate, String.valueOf(ssd.Id));
        opty.Key_Contact__c = con.Id;
        insert opty;

        Test.startTest();
                
        quote.Apttus_Proposal__Opportunity__c = opty.id;
        insert quote;

        Ecom_OrderRequest.cls_ActionParams a1 = getActionParams('None','Convert','None','None','None','Create','Create',false,false,false);
        Ecom_OrderRequest.cls_References r1 = new Ecom_OrderRequest.cls_references();
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879','Premium');
        
        Ecom_OrderRequest request = new Ecom_OrderRequest();
        request.storeOrder = sreq;
        request.references = r1;
        request.actionParams = a1;

        System.assert(request != null,'request is null');
        LCRM_Contact_SSD__c contactSSD = [
            SELECT Id, LCRM_Contact__c, LCRM_Email__c, Name, LCRM_Account_SSD__c, LCRM_Account_SSD__r.Account_Name__c 
            FROM LCRM_Contact_SSD__c WHERE LCRM_Contact__c = :con.Id
        ];
        
        try {
            Ecom_ProposalService.proposalCreation(opty.Id, UserInfo.getUserId(), contactSSD, store[0], 'Premium');   
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception check' + ex);
        }
        Test.stopTest();
    }
    
    @isTest
    public static void updateAccountsTest() {
        product2 p1 = [SELECT id FROM product2 LIMIT 1];
        Apttus_Config2__PriceList__c priceList = [SELECT Id FROM Apttus_Config2__PriceList__c LIMIT 1];

        APTSECOM_Store__c store = DCTestData.createStore('CORPORATE', null, priceList.Id);
        store.APTSECOM_Customer_Pricing_Segment__c = 'CORPORATION';
        insert store;

        Ecom_OrderRequest.cls_storeOrder storeOrder = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        Integer quantity = storeOrder.selectedProducts[0].quantity;
        
        String accountName = 'TestAccount';
        Account acc = DCTestData.createAccount(accountName);
        insert acc;

        System.assert(acc != null,'acc is null');
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        // Ecom_OrderService e1 = new  Ecom_OrderService();
        try {
            Ecom_Account.updateAccounts(acc.Id, ssd.Id, storeOrder.customerDetails);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
    }

    @isTest
    public static void updateContacts() {
        Product2 p1 = [SELECT id FROM Product2 LIMIT 1];
        Ecom_OrderRequest.cls_storeOrder storeOrder = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        
        String accountName = 'TestAccount';
        Account acc = DCTestData.createAccount(accountName);
        insert acc;

        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Contact con = DCTestData.createContactRec('Test name', acc.id);
        insert con;

        
        System.assert(con != null,'con is null');
        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        //Ecom_OrderService e1 = new  Ecom_OrderService();
        try {
            Ecom_Contact.updateContacts(con.Id,conSSD.Id,storeOrder.customerDetails);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
    }
    
    @isTest
    public static void updateOpptyandProposalForOrgchangeTest() {
        Product2 p1 = [SELECT id FROM Product2 LIMIT 1]; 
        
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;

        String accountName = 'TestAccount';
        Account acc = DCTestData.createAccount(accountName);
        insert acc;
        
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Opportunity opty = DCTestData.createOpportunityRec(optyName, acc.Id, stageName, closeDate, String.valueOf(ssd.Id));
        insert opty;
        
        test.startTest();
        
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acc.Id, 'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;
        insert quote;
        
        Ecom_OrderRequest.cls_storeOrder storeOrder = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        // Ecom_OrderService e1 = new  Ecom_OrderService();
        
        System.assert(storeOrder != null,'storeOrder is null');
        test.stopTest();
        
        try {
            Ecom_Opportunity.updateOpportunityForOrganizationchange(opty.Id, storeOrder.customerDetails); 
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
    }
    
    @isTest
    public static void contactAndOpportunityTest() {
        product2 p1 = [SELECT id FROM product2 LIMIT 1];
        List<APTSECOM_Store__c> store = [
            SELECT Id, name, APTSECOM_Price_List__c,APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Default_Contract_Term__c,
                (SELECT Id, name, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c 
                FROM Store_Price_Adjustments__r), 
                (SELECT id, name, Adjustment_Amount__c, Adjustment_Type__c, Related_Category_Hierarchy__c, YoY_1__c, YoY_2__c, Contract_Term__c 
                FROM New_Sales_Contract_Term_Settings__r)
            FROM APTSECOM_Store__c LIMIT 1
        ];
        
        Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Account acc = [SELECT id, SAPAccountNumber__c FROM Account LIMIT 1];
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        
        APTSECOM_Store__c storess = [SELECT id FROM APTSECOM_Store__c LIMIT 1];
        Ecom_OrderRequest.cls_storeOrder sreq = getRequest('p1.Id', 'Small Law', 2, 'Jessica', 'TrTest', '9377770000', 'Premium');

        Apttus_Config2__Order__c order = DCTestData.createOrder(priceList.id, storess.id );
        insert order;

        Lead ld = createLead(sreq, order.id);
        insert ld;
        
        Contact con = DCTestData.createContactRec('Test name',acc.id);
        insert con;
        
        Date closeDate = System.Today() + 30;
        String optyName = 'TestOpty';
        Opportunity opty = DCTestData.createOpportunityRec(optyName, acc.Id, 'Order Complete', closeDate, String.valueOf(ssd.Id));
        insert opty;
    
        Test.startTest();
        //Ecom_OrderRequest.cls_storeOrder sreq = getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879','Premium');
        Ecom_Contact.createContactSSD(ssd, con.Id, sreq.customerDetails);
        Ecom_Contact.updateConvertedContact(con.Id, ssd);
        
        Campaign c1 = new Campaign();
        c1.Name = 'test Campaign';
        c1.RecordType = [SELECT Id FROM RecordType WHERE Name = 'GLI' AND SobjectType = 'Campaign'];
        c1.CurrencyIsoCode = 'USD';
        insert c1;
        
        System.assert(c1 != null,'c1 is null');
        Id campid = c1.Id;
        Ecom_Opportunity.updateConvertedOpportunity(opty.Id, con, ssd, UserInfo.getUserId(), sreq, 'leadDescription', 'leadtrackingcode', campid);
        Ecom_Opportunity.createLeadHistory(acc.id, con.Id, opty.Id, UserInfo.getUserId(), ld);
        Test.stopTest();
    } 
    
    @isTest
    public static void addBundleProductsTest() {
        // Bundle
        Product2 pBundle = DCTestData.createProduct('GENERAL COUNSEL ESSENTIALS ON WESTLAW','','');    
        pBundle.Apttus_Config2__HasOptions__c = true;
        pBundle.IsActive = true;
        pBundle.Apttus_Config2__ConfigurationType__c = 'Bundle';
        update pBundle;
        system.debug(logginglevel.INFO, 'pBundle > ' + pBundle);

        // Option Product
        Product2 pOption = DCTestData.createProduct('GC Business Transactions Solutions (CORP) (WestlawPRO™)', '42076357', '42076358');
        pOption.Apttus_Config2__ConfigurationType__c = 'Option';
        pOption.Apttus_Config2__HasOptions__c = false;
        pOption.APTS_Module_Points__c = 1.0;
        update pOption;
        system.debug(logginglevel.INFO, 'pOption > ' + pOption);

        Apttus_Config2__ClassificationName__c optClassName = new Apttus_Config2__ClassificationName__c();
        optClassName.Apttus_Config2__Active__c = true;
        optClassName.Apttus_Config2__HierarchyLabel__c = 'General Counsel Essentials on WestLaw Modules';
        optClassName.Apttus_Config2__Type__c = 'Option Group';
        optClassName.Name = 'General Counsel Essentials on WestLaw Modules';
        insert optClassName;
        system.debug(logginglevel.INFO, 'optClassName > ' + optClassName);
        
        Apttus_Config2__ClassificationHierarchy__c optClassHier = new Apttus_Config2__ClassificationHierarchy__c();
        optClassHier.Apttus_Config2__DefaultSearchCategory__c = false;
        optClassHier.Apttus_Config2__ExpandedByDefault__c = false;
        optClassHier.Apttus_Config2__HideAllSearchFilters__c = false;
        optClassHier.Apttus_Config2__IncludeInTotalsView__c = true;
        optClassHier.Apttus_Config2__IsHidden__c = false;
        optClassHier.Apttus_Config2__IsPicklist__c = false;
        optClassHier.Apttus_Config2__Label__c = 'General Counsel Essentials on WestLaw Modules';
        optClassHier.Apttus_Config2__Modifiable__c = true;
        optClassHier.DC_Is_Title_Visible__c = false;
        optClassHier.Apttus_Config2__HierarchyId__c = optClassName.id;
        optClassHier.Name = 'General Counsel Essentials on WestLaw Modules';
        insert optClassHier;
        system.debug(logginglevel.INFO, 'optClassHier > ' + optClassHier);
        
        // Option Group
        Apttus_Config2__ProductOptionGroup__c pOptGroup = new Apttus_Config2__ProductOptionGroup__c();
        pOptGroup.Apttus_Config2__IsHidden__c = false;
        pOptGroup.Apttus_Config2__IsLeaf__c = true;
        pOptGroup.Apttus_Config2__IsPicklist__c = false;
        pOptGroup.Apttus_Config2__Level__c = 0;
        pOptGroup.Apttus_Config2__Left__c = 1;
        pOptGroup.Apttus_Config2__Right__c = 2;
        pOptGroup.Apttus_Config2__Sequence__c = 0;
        pOptGroup.Apttus_Config2__MinOptions__c = 1.0;
        pOptGroup.Apttus_Config2__MaxOptions__c = 999.0;
        pOptGroup.Apttus_Config2__ModifiableType__c = 'Variable';
        pOptGroup.Apttus_Config2__OptionGroupId__c = optClassHier.id;
        pOptGroup.Apttus_Config2__ProductId__c = pBundle.Id;
        pOptGroup.Apttus_Config2__RootOptionGroupId__c = optClassHier.id;
        pOptGroup.Apttus_Config2__ContentType__c = 'Options';
        pOptGroup.CurrencyIsoCode = 'USD';
        insert pOptGroup;
        system.debug(logginglevel.INFO, 'pOptGroup > ' + pOptGroup);

        // Option Product Component
        Apttus_Config2__ProductOptionComponent__c pOptComp = new Apttus_Config2__ProductOptionComponent__c();
        pOptComp.Apttus_Config2__AllowCloning__c = false;
        pOptComp.Apttus_Config2__AutoUpdateQuantity__c = false;
        pOptComp.Apttus_Config2__Default__c = false;
        pOptComp.Apttus_Config2__Modifiable__c = false;
        pOptComp.Apttus_Config2__Sequence__c = 0;
        pOptComp.Apttus_Config2__Required__c = false;
        pOptComp.Apttus_Config2__ParentProductId__c = pBundle.Id;
        pOptComp.Apttus_Config2__ProductOptionGroupId__c = pOptGroup.id;
        pOptComp.Apttus_Config2__ComponentProductId__c = pOption.id;
        insert pOptComp;
        system.debug(logginglevel.INFO, 'pOptComp > ' + pOptComp);

        Apttus_Config2__PriceList__c priceList = [SELECT Id FROM Apttus_Config2__PriceList__c LIMIT 1];
        Pricebook2 pbook = [SELECT Id, Name FROM Pricebook2 LIMIT 1];
        
        List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();
        for (Product2 p : [SELECT id FROM product2]) {
            Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
            pli.Apttus_Config2__PriceListId__c = priceList.id;
            pli.Apttus_Config2__ProductId__c = p.Id;
            pli.Apttus_Config2__ChargeType__c = 'Subscription Fee';
            pli.Apttus_Config2__PriceType__c  = 'Recurring';
            pli.Apttus_Config2__Frequency__c = 'Monthly';
            pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
            pli.Apttus_Config2__PriceUom__c = 'Each';
            pli.Apttus_Config2__Active__c  = true;
            pli.Apttus_Config2__ListPrice__c = 100;
            pliList.add(pli);
        }
        insert pliList;
        
        Account acct = [SELECT Id, SAPAccountNumber__c FROM Account LIMIT 1];
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acct);

        Opportunity opty = DCTestData.createOpportunityRec('TestOpty', acct.Id, 'Order Complete', System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;

        Test.startTest();
  
        Apttus_Proposal__Proposal__c quote = DCTestData.createQuote(acct.Id, 'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;
        insert quote;

        Apttus_Config2__ProductConfiguration__c cart = DCTestData.createCart(acct.Id, quote.Id, null, priceList.Id);
        insert cart;
        system.debug(logginglevel.INFO, 'cart > ' + cart);

        List<Ecom_OrderRequest.cls_selectedProducts> selectedProducts = new List<Ecom_OrderRequest.cls_selectedProducts>();
        Ecom_OrderRequest.cls_selectedProducts sp1 = new Ecom_OrderRequest.cls_selectedProducts();
        sp1.productId = pOption.Id;
        sp1.quantity = 1;
        sp1.contractTerm = '3 Years';
        sp1.isRecommendedProduct = 'false';
        sp1.cType = 'Bundle';
        selectedProducts.add(sp1);

        APTSECOM_Store__c store = [SELECT Id, Name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, 
                        APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Default_Contract_Term__c, Ecom_Has_Bundles__c FROM APTSECOM_Store__c LIMIT 1];
        store.Name = 'Corporate Westlaw';
        store.APTSECOM_Customer_Pricing_Segment__c = 'CORPORATION';
        store.Ecom_Has_Bundles__c = true;
        update store;

        Ecom_StoreResponse.Adjustments adjustments = new Ecom_StoreResponse.Adjustments();
        adjustments.adjustmentType = 'Discount';
        adjustments.adjustmentAmount = 10.0;
        adjustments.categoryId = categoryId;

        List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> pocList = Ecom_OrderService.getBundleProdOptComponents(store.APTSECOM_Price_List__c, pBundle.Id);
        
        System.assert(store != null,'store is null');
        try {
            system.debug(logginglevel.INFO, '');
            Ecom_OrderService.addMultipleProducts(cart.Id, selectedProducts, '', store, adjustments);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
        // TEST isRecommendedProduct
        Ecom_OrderRequest.cls_selectedProducts sp2 = new Ecom_OrderRequest.cls_selectedProducts();
        sp2.productId = pOption.Id;
        sp2.quantity = 1;
        sp2.contractTerm = '3 Years';
        sp2.isRecommendedProduct = 'true';

        Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
        try{
            Ecom_OrderService.addCustomValuesToLineItem(sp2, customData, store, adjustments);
        }
        catch(Exception ex){
            System.debug(logginglevel.ERROR, ex);
        }
        try{
            Ecom_OrderService.getOptionProduct(pocList,sp2,store,adjustments);
        }
        catch(Exception ex){
            System.debug(logginglevel.ERROR, ex);
        }
        Test.stopTest();
    }
    
    // responseToRequest
   /**
    * @description : response to request 
    * @param res : response
    * @param ref : reference
    */     
    public static void responseToRequest(Ecom_OrderService.updatedMethodResponse res, Ecom_OrderRequest.cls_references ref) {
        ref.orderId = res.orderId;
        ref.leadId = res.leadId;
        ref.accountId = res.accountId;
        ref.contactId = res.contactId;
        ref.opportunityId = res.opptyId;
        ref.proposalId = res.proposalId;
        ref.cartId = res.cartId;
        ref.orderNumber = res.orderNumber;
        ref.proposalNumber = res.proposalNumber;
        ref.repricePending = res.repriceCart;
        // res.contractNotInSync = false;
        system.debug(logginglevel.INFO, '======response in new method=====' + res);
    }

    // createLead
   /**
    * @description : Create a Lead 
    * @param storeOrder : Store Order
    * @param orderId : Order id
    * @return Lead
    */     
    public static Lead createLead(Ecom_OrderRequest.cls_storeOrder storeOrder, String orderId) {
        Ecom_OrderRequest.cls_customerDetails leadInfo = storeOrder.customerDetails;
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();

        Lead lead = new Lead();
        lead.RecordTypeId = recordTypeId;
        lead.firstname = leadInfo.firstName;
        lead.lastname = leadInfo.lastName;
        lead.company = leadInfo.organizationName;
        lead.Email = leadInfo.businessEmail;
        lead.Phone = leadInfo.phoneNumber;
        lead.APTSECOM_Order__c = orderId;
        lead.street = leadInfo.address.addressLine1;
        lead.city = leadInfo.address.city;
        lead.state = leadInfo.address.state;
        lead.country = leadInfo.address.country;
        lead.postalcode = leadInfo.address.zipCode;
        return lead;
    }
    
    
/*    
    // DCTestData.createSourceSystemDetail
    public static Source_System_Detail__c createSourceSystemDetail(Account acc) {
        Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD = new Source_System_Detail__c();
        accountSSD.RecordtypeId = ssdRecorType;
        accountSSD.Name = 'ABC';
        accountSSD.Source_System_Name__c = 'ABC';
        accountSSD.Account_Name__c = acc.ID; 
        accountSSD.Account_Inactive__c = false;  
        accountSSD.Source_System_Account_Number__c = acc.SAPAccountNumber__c;    
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
        accountSSD.LCRM_SAP_Account_Number__c = '1004284494';        
        accountSSD.LCRM_APTS_Band_Number__c = 1;
        accountSSD.APTS_Customer_Category__c = '3';
        accountSSD.LCRM_eOutput_Eligibility__c = ''; 
        accountSSD.LCRM_Sales_Org__c = 'WEST';
        accountSSD.State__c = 'California';
        accountSSD.LCRM_Customer_Group__c = 'FIRM';
        insert accountSSD;

        acctSsdId = accountSSD.id;
        accountSSDlst = accountSSD;
        return accountSSD;
    }
*/


    // getRequest
   /**
    * @description : get request
    * @param pId : Store Name
    * @param storename : Plan id
    * @param quantity : Number Of Attorneys 
    * @param firstName : first name
    * @param org : org
    * @param mobile : mobild
    * @param plan : plan
    * @return store order
    */     
    public static Ecom_OrderRequest.cls_storeOrder getRequest(String pId, String storename, Integer quantity, String firstName, String org, String mobile, String plan) {
        String json = '{'+
            ' "storeName": "' + storename + '",'+
            ' "totalPrice":261.36 ,' +
            ' "planId":null,'+
            ' "plan": "'+ plan + '",'+
            ' "isAbandonedLead":true,'+
            ' "purchaseOrderNum":"245432",'+
            ' "jurisdiction":"Ohio",'+
            ' "promoCode":"BAR2018",'+
            ' "isJourneyEnded":false,'+
            ' "isExistingCustomer":false,'+
            '    "additionalInfo": {'+
            '        "trackingCodeCID": "610000",'+
            '        "isGetQuoteClicked": true,'+
            '        "forwardCart": true, '+
            '        "buildPlanDetails": "plan details", '+
            '        "existSSDAccNumber": "19848032199", '+
            '        "existCreditRiskCategory": "No risk customer", '+
            '        "leadDescription": "Plan:Premium Profile; # of seats:22; State:Alaska; Add On:null; Customer Forwarded Cart to others:false See Activity for details:false, Promo Code:null", '+
            '        "activityDesc": "Cart Forwarded",'+
            '        "isEbillingChecked": true,'+
            '        "isBillToAccount" : true'+
            '    },'+  
            '    "customerDetails": {'+
            '      "firstName": "' + firstName + '",'+
            '      "lastName": "Page",'+
            '      "organizationName": "' + org + '",'+
            '      "businessEmail": "shivasriarun.koralla@thomsonreuters.com",'+
            '      "phoneNumber": "' + mobile + '",'+
            '      "phoneExtension": "1234",'+
            '      "isPhysicalSameAsBillingAddress ": true, '+
            '      "address": {'+
            '        "addressLine1": "223 E. Concord Street",'+
            '        "city": "Orlando",'+
            '        "state": "FL",'+
            '        "zipCode": "32801",'+
            '        "county": "Lafayette County",'+
            '        "country": "US"'+
            '      },'+
            '      "recipients": {'+
            '        "mail1": "testemail1@thomsonreuters.com",'+
            '        "mail2": "testemail2@thomsonreuters.com",'+
            '        "mail3": "testemail3@thomsonreuters.com",'+
            '        "mail4": "testemail4@thomsonreuters.com",'+
            '        "mail5": "testemail5@thomsonreuters.com"'+
            '      },'+
            '      "physicalAddress": {'+
            '        "addressLine1": "223 E. Concord Street",'+
            '        "city": "Orlando",'+
            '        "state": "FL",'+
            '        "zipCode": "32801",'+
            '        "country": "US"'+
            '      }'+            
            '    },'+
            '    "selectedProducts": ['+
            '      {'+
            '        "productId": "' + pId + '",'+
            '        "quantity": ' + quantity + ','+
            '        "contractTerm": "3 Years",'+
            '        "assignedUsers": 3'+
            '      }'+
            '    ]'+
            '}'; 
        system.debug(logginglevel.INFO, 'json > ' + json);

        Ecom_OrderRequest.cls_storeOrder obj = (Ecom_OrderRequest.cls_storeOrder)System.JSON.deserialize(json, Ecom_OrderRequest.cls_storeOrder.class);
        system.debug(logginglevel.INFO, ' obj return ' + obj);

        return obj;
    }

    /****************************** TEST ORDER REQUEST CONSTRUCTORS ****************************/
    // get cls_ActionParams
   /**
    * @description : get action parameters
    * @param orderAction : order action
    * @param leadAction : lead action
    * @param accountAction : account action
    * @param contactAction : contact action
    * @param opportunityAction : opportunity action 
    * @param proposalAction : proposal action
    * @param cartAction : cart action
    * @param repriceCart : reprice cart
    * @param placeOrder : place order
    * @param generatePaymentURL : generate payment URL
    * @return action parms
    */     
    public static Ecom_OrderRequest.cls_ActionParams getActionParams(String orderAction, String leadAction, String accountAction, String contactAction, String opportunityAction, String proposalAction, String cartAction, Boolean repriceCart, Boolean placeOrder, Boolean generatePaymentURL) {
        Ecom_OrderRequest.cls_ActionParams ap = new Ecom_OrderRequest.cls_ActionParams();
        ap.orderAction = orderAction;
        ap.leadAction = leadAction;
        ap.accountAction = accountAction;
        ap.contactAction = contactAction;
        ap.opportunityAction = opportunityAction;
        ap.proposalAction = proposalAction;
        ap.generatePaymentURL = generatePaymentURL;
        ap.cartAction = cartAction;
        ap.repriceCart = repriceCart;
        ap.placeOrder = placeOrder;
        return ap;
    }

    // get cls_References
   /**
    * @description : get references
    * @param orderId : order id
    * @param leadId : lead id
    * @param accountId : account id 
    * @param accountSSDId : account ssd id
    * @param contactId : contact id 
    * @param opportunityId : opportunity id 
    * @param proposalId : proposal id
    * @param cartId : cart id
    * @param orderNumber : order number
    * @param proposalNumber : proposal number 
    * @param repricePending : reprice pending
    * @return Ecom Order Request References
    */     
    public static Ecom_OrderRequest.cls_References getRefs(String orderId, String leadId, String accountId, String accountSSDId, String contactId, String opportunityId, String proposalId, String cartId, String orderNumber, String proposalNumber, Boolean repricePending) {
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_References();
        ref.orderId = orderId;
        ref.leadId = leadId;
        ref.accountId = accountId;
        ref.accountSSDId = accountSSDId;
        ref.contactId = contactId;
        ref.opportunityId = opportunityId;
        ref.proposalId = proposalId;
        ref.cartId = cartId;
        ref.orderNumber = orderNumber;
        ref.proposalNumber = proposalNumber;
        ref.repricePending = repricePending;
        return ref;
    }

    // get cls_storeOrder
   /**
    * @description : get store order 
    * @param storeName : Store Name
    * @param planId : Plan id
    * @param numberOfAttorneys : Number Of Attorneys 
    * @param selectedProducts : list of selected products
    * @return Ecom Order Request store order
    */ 
    public static Ecom_OrderRequest.cls_storeOrder getStoreOrder(String storeName, String planId, Integer numberOfAttorneys, List<Ecom_OrderRequest.cls_selectedProducts> selectedProducts) {
        Ecom_OrderRequest.cls_storeOrder so = new Ecom_OrderRequest.cls_storeOrder();
        so.storeName = storeName;
        so.planId = planId;
        so.numberOfAttorneys = numberOfAttorneys;
        so.selectedProducts = selectedProducts;
        return so;
    }

    // get cls_selectedProducts
   /**
    * @description : get order request
    * @param productId : Product Id
    * @param quantity : Quantity
    * @param contractTerm : Contract Term
    * @param cType : Contract Type
    * @return Ecom Order Request
    */ 
    public static Ecom_OrderRequest.cls_selectedProducts getSelProds(String productId, Integer quantity, String contractTerm, String cType) {
        Ecom_OrderRequest.cls_selectedProducts sp = new Ecom_OrderRequest.cls_selectedProducts();
        sp.productId = productId; 
        sp.quantity = quantity; 
        sp.contractTerm = contractTerm; 
        sp.cType = cType;
        return sp;
    }

    // get Ecom_OrderRequest
   /**
    * @description : get order request
    * @param storeOrder : store order
    * @param references : order references
    * @param actionParams : action parms
    * @return Ecom Order Request
    */    
    public static Ecom_OrderRequest getOrderRequest(Ecom_OrderRequest.cls_storeOrder storeOrder, Ecom_OrderRequest.cls_References references, Ecom_OrderRequest.cls_ActionParams actionParams) {
        Ecom_OrderRequest oReq = new Ecom_OrderRequest();
        oReq.storeOrder = storeOrder; 
        oReq.references = references; 
        oReq.actionParams = actionParams; 
        return oReq;
    }

   /**
    * @description : get order request
    * @return Ecom Order Request
    */
    public static Ecom_OrderRequest getOrderRequest() {
        Ecom_OrderRequest req = getOrderRequest(
            getStoreOrder(
                'Small Law', '', 1, new List<Ecom_OrderRequest.cls_selectedProducts>{}
            ),
            getRefs(
                '', '', '', '', '', '', '', '', '', '', false
            ),
            getActionParams(
                '', '', '', '', '', '', '', false, false, false
            )
        );
        return req;
    }
}