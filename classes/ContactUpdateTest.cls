@isTest
public class ContactUpdateTest {

  public static String accountId;
    public static String oppId;
    public static String bQuoteId;
    public static String cQuoteID;
    public static String productId;
    public static String pBookId;
    public static String bCartId;
    
    public static List<Opportunity> createTestData() {
         
        Profile p1 = [SELECT Id FROM Profile WHERE Name='ANZ Users' LIMIT 1];
        Profile p2 = [SELECT Id,name FROM Profile WHERE Name='Partner Portal User' LIMIT 1];
        
        List<KeyValueListStore__C> keyCSList = [Select Name From KeyValueListStore__C Where Name='ANZUsersProfileId'];
        
        If((keyCSList != null) && (keyCSList.size() > 0)) {
        } else {
            KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name= 'ANZUsersProfileId',TextValue__c= p1.id);
            insert keyCustomSetting;
        }
        
        Map<String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId(); 
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();  
        
       
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = optyPipeRecTypeId != null? optyPreRecTypeID : '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = optyPipeRecTypeId != null? optyPipeRecTypeId : '012a0000001ZJxn';
        insert recT1; 
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'Standard Price Book';
        insert pbook;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        pBookId = priceList.Id;
        
        Account acc = APTS_TestDataFactory.createAccount('Test Account');
        acc.FrozenMarketSegment__c = valueMarket;
        acc.SAPAccountNumber__c = '1004284494';
        acc.Customer_Group__c = 'FIRM';
        insert acc;
        accountId = acc.Id;
        
        list<Opportunity> oppList = new list<Opportunity>();         
        Opportunity opp1 = new Opportunity();
        opp1 = UnitTest.getOpportunityInstance(acc.id);
        opp1.isdigitalSpearhead__c = TRUE;
        opp1.CloseDate = System.Today() + 30;
        opp1.StageName = '10%';
        opp1.Renewal_Date__c = System.Today();
        opp1.Status__c = 'Unworked';
        opp1.RecordTypeId = optyPreRecTypeID; 
        opp1.Pricebook2 = pBook;
        opp1.AccountId = acc.id;
        oppList.add(opp1);        
        insert oppList;       
        oppId = oppList[0].id;
        
        Contact testcontact= UnitTest.getContactInstance(Acc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = acc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact; 
        
        createQuote();
               
        return oppList;
    }
    
    public static void createQuote() {
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Apttus_Proposal__Opportunity__c = oppId;
        q1.Apttus_Proposal__Account__c = accountId;
        q1.Apttus_QPConfig__BillToAccountId__c = accountId;
        q1.Apttus_QPConfig__ShipToAccountId__c = accountId;
        q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q1.Digital_Quote_Type__c = 'Best Value'; 
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = false;
        quoteList.add(q1);
        
        Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
        q2.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q2.Apttus_Proposal__Opportunity__c = oppId;
        q2.Apttus_Proposal__Account__c = accountId;
        q2.Apttus_QPConfig__BillToAccountId__c = accountId;
        q2.Apttus_QPConfig__ShipToAccountId__c = accountId;
        q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q2.Digital_Quote_Type__c = 'Best Value+Config'; 
        q2.Digital_Batch_Processed__c = TRUE;
        q2.Apttus_Proposal__Primary__c = false;
        quoteList.add(q2);
        
        insert quoteList;
                
        list<Apttus_Config2__ProductConfiguration__c> cartList = new list<Apttus_Config2__ProductConfiguration__c>();
        Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c(Id=createCart(quoteList[0].Id),
                                                                            Apttus_Config2__Status__c = 'Finalized');
        cartList.add(newCart1); 
        
        Apttus_Config2__ProductConfiguration__c newCart2 = new Apttus_Config2__ProductConfiguration__c(Id=createCart(quoteList[1].Id),
                                                                            Apttus_Config2__Status__c = 'Finalized');
        cartList.add(newCart2); 
        update cartList;
        
        
        Product2 prod2 = createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
        
        list<Apttus_Config2__LineItem__c> listLines = new list<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c line1 = createLineItem(cartList[0].Id, 1, 1, true, 'Product/Service', prod2.id, null, 2, pBookId, null, false);
        listLines.add(line1);
        
        Apttus_Config2__LineItem__c line2 = createLineItem(cartList[1].Id, 1, 1, true, 'Product/Service', prod2.id, null, 2, pBookId, null, false);
        listLines.add(line2);
        Insert listLines;
        
        productId = prod2.Id;
        bCartId = cartList[0].Id;
        bQuoteId = quoteList[0].Id;
        cQuoteId = quoteList[1].Id; 
    }
    
    public static String createCart(String quoteId){
        Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO(); 
        request.QuoteId = quoteId;
        Apttus_CPQApi.CPQ.CreateCartResponseDO response = Apttus_CPQApi.CPQWebService.createCart(request);
        String cartId = response.CartId;
        
        return cartId;
    }
    
    public static Product2 createProduct(String prodName, String serviceNum, String subNum) {
        Product2 prodObj = new Product2(); //current sub
        prodObj.Name = prodName;
        prodObj.List_Price__c = 0;
        prodObj.Format__c = 'Online';
        prodObj.Is_Orderable__c = TRUE;
        prodObj.IS_WP_Eligible__c = TRUE;
        prodObj.Media_High_Level__c = 'Online';
        prodObj.Service_Number__c = serviceNum;
        prodObj.Subscription_Number__c = subNum;
        prodObj.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj.Family = 'WESTLAW';
        prodObj.Apttus_Filter_Media__c = 'Online';
        prodObj.APTS_Media_High_Level_Code__c = '05';
        prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj.Productcode = serviceNum;
        prodObj.isActive = true;
        Insert prodObj;
        
        return prodObj;
    }
    
    public static Apttus_Config2__LineItem__c createLineItem(String configId, Integer lineNumber, Integer itemSequence, Boolean isPrimaryLine,
                                                              String lineType, Id productId, Id optionId, Integer quantity,
                                                              Id priceListId, Id plItemId, Boolean isBundle){
                                                             Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configId);
        lineItem.Apttus_Config2__LineNumber__c = lineNumber;
        lineItem.Apttus_Config2__ItemSequence__c = itemSequence;
        lineItem.Apttus_Config2__IsPrimaryLine__c = isPrimaryLine;
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__LineType__c = lineType;
        lineItem.Apttus_Config2__ProductId__c = productId;
        lineItem.Apttus_Config2__OptionId__c = optionId;
        lineItem.Apttus_Config2__Quantity__c = quantity;
        lineItem.Apttus_Config2__PriceListId__c = priceListId;
        lineItem.Apttus_Config2__PriceListItemId__c = plItemId;
        lineItem.Apttus_Config2__ListPrice__c = 500;
        lineItem.Apttus_Config2__BasePrice__c = 200;
        lineItem.Apttus_Config2__AdjustedPrice__c = 0;
        lineItem.Apttus_Config2__NetPrice__c = 600;
        lineItem.Apttus_Config2__ExtendedPrice__c = 600;
        lineItem.Apttus_Config2__HasOptions__c = isBundle;
        lineItem.Apttus_Config2__StartDate__c = system.today();
        lineItem.Apttus_Config2__EndDate__c=system.today().addDays(30);
        lineItem.Apttus_Config2__AdjustmentAmount__c = 5.0;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__Term__c = 12;
        return lineItem;
    }
    
    @isTest static void testQuoteOrderConfirmationContactChange(){
        createTestData();
        Test.startTest();
        Apttus_Proposal__Proposal__c quote =  [Select Id,Apttus_Proposal__Account__c,APTS_Order_Confirmation_Contact__c FROM Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' limit 1 ]; 
        // Confirmation Contact
        Contact newContact2 = new Contact();
        newContact2.FirstName = 'Test2';
        newContact2.LastName = 'User2';
        newContact2.Email = 'test.user1@email.xxx';
        newContact2.AccountId = quote.Apttus_Proposal__Account__c;
        insert newContact2;
        
        quote.APTS_Order_Confirmation_Contact__c = newContact2.id;
        update quote;
        
        Test.stopTest();
         
    }

}