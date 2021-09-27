/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-08-07   Bharat Bhushan          DLT-11509- [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID
 * 2019-02-07   Navleen Kaur          DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-03-07   Benjamin Her            Source System Detail Record type changed from USL Source Systems to LOTUS Source Systems
 * 2019-6-13    Benjamin Her            DLT-16788 Code Scan fix
 * 2019-09-04   Srikanth kota           DLT-17452 - [CORP][SFDC] Straight renew Option products alongwith the core product
 * 2020-03-23   Brenda Shields          DLT-19804 - Updates for State/Country picklist enablement
 * 23-07-2020   Rahul Natarajan         DLT-20035 - Remove Segmentation Field References from CX Digital components.
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c 
 * ==================================================================================================================================   
 */
/**
 * @description : Test class used to create common test data for all Digital test classes
 */  
@isTest
public with sharing class DCTestData {

	public static String accountId;
	public static String oppId;
	public static String oppId2;
	public static String bQuoteId;
	public static String cQuoteID;
	public static String productId;
	public static String pBookId;
	public static String bCartId;
	public static String cCartId;
	public static String accssdid;
	public static String conssdid;
	public static String priceListItemid;
	public static String priceMatrixid;
	public static string contactId;
	public static String mainCategoryId;
	public static string attachmentId;
	public static string templateId;
	public static string userId;
	public static string assetLineItemId;
	public static Account acct;
	public static Source_System_Detail__c accountSSDlst;
	public static list<opportunity> oppList1 = new list<opportunity> ();
	public static string cartName;
	public static Id preRecType;

	// used to turn off and on the isRunningTest flag for code coverage   
	public static Boolean enableisRunningTest = true;
	public static Boolean isRunningTest() {
		return Test.isRunningTest() && enableIsRunningTest;
	}

	public static void createTestData() {
		createData();
		createQuote();
	}

	public static void createData() {

		Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'
			LIMIT 1
		];
		Profile p2 = [SELECT Id, name FROM Profile WHERE Name = 'System Administrator'
			LIMIT 1
		];

		List<KeyValueListStore__C > keyCSList = [Select Name From KeyValueListStore__C Where Name = 'ANZUsersProfileId'];

		If((keyCSList == null) || (keyCSList.isEmpty())) {
			KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
			insert keyCustomSetting;
		}

		User u1 = [Select id, name from User where ProfileId =: p2.id limit 1];
		Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
		Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
		Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
		Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
		//Id optyNONSAPLatamRecTypeID = recordTypes.get('NON SAP Opportunity Latam').getRecordTypeId();

		preRecType = optyPreRecTypeID;

		RecordtypeIds__c recT = new RecordtypeIds__c();
		recT.name = 'Pre-Pipeline Opportunities';
		recT.recTypeId__C = optyPipeRecTypeId;
		insert recT;

		RecordtypeIds__c recT1 = new RecordtypeIds__c();
		recT1.Name = 'Pipeline Opportunities';
		recT1.recTypeId__C = optyPipeRecTypeId;
		insert recT1;

		RecordtypeIds__c recT2 = new RecordtypeIds__c();
		recT2.Name = 'GLI Pipeline Opportunity';
		recT2.recTypeId__C = optyGLIRecTypeID;
		insert recT2;

		/*RecordtypeIds__c recT3= new RecordtypeIds__c();
		recT3.Name= 'NON SAP Opportunity Latam';
		recT3.recTypeId__C = optyNONSAPLatamRecTypeID;
		insert recT3;*/

		Pricebook2 pbook = new Pricebook2();
		pbook.name = 'GLI Price Book - US Legal/LMS';
		insert pbook;

		LatAm_GLI_Settings__c latamGLISetting = new LatAm_GLI_Settings__c();
		latamGLISetting.GLI_Partner_Profiles_List__c = 'Partner Portal User';
		latamGLISetting.GLI_Sales_Int_Profiles_List__c = 'LatAm User;LatAm GLI User';
		latamGLISetting.S2E_Partner_Profiles_List__c = 'Partner Portal User';
		latamGLISetting.S2E_Sales_Int_Profiles_List__c = 'LatAm User';
		latamGLISetting.SubBU__c = 'LatAm';
		insert latamGLISetting;

		//Create custom setting entry for panorama stage changes
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

		Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
		String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();

		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.name = 'Thomson Reuters Master - US Legal';
		insert priceList;
		pBookId = priceList.Id;

		Account acc = new Account();
		acc.Name = 'Test Account';
		// Commented Segmentation Fields - DLT-20035
		//acc.FrozenMarketSegment__c = 'Solo Law Firm';
		acc.SAPAccountNumber__c = '1004284494';
		// acc.Customer_Group__c = 'FIRM';
		acc.APTS_Band_Number__c = 1;
		acc.APTS_Customer_Category__c = '3';
		acc.APTS_eOutput_Eligibilty__c = '';
		acc.BillingCountry = 'US';
		acc.BillingState = 'IL';
		acc.BillingPostalCode = '60603-3801';
		insert acc;
		acct = acc;
		system.debug(logginglevel.INFO, 'Acct -->' + acct);
		accountId = acc.Id;
		createSourceSystemDetail(acc);

		Contact testcontact = UnitTest.getContactInstance(Acc.Id);
		testcontact.LastName = 'testContact';
		testcontact.FirstName = 'testContact';
		testcontact.AccountId = acc.Id;
		testcontact.email = 'testfirst.testlast@test.com';
		testcontact.SAP_Role__c = 'EML ORDER CONFIRM';
		insert testcontact;
		contactId = testcontact.Id;

		list<Opportunity> oppList = new list<Opportunity> ();
		Opportunity opp1 = new Opportunity();
		opp1 = UnitTest.getOpportunityInstance(acc.id);
		opp1.isdigitalSpearhead__c = TRUE;
		opp1.CloseDate = System.Today() + 30;
		opp1.StageName = 'Appointment Scheduled';
		opp1.Renewal_Date__c = System.Today() + 1;
		opp1.Status__c = 'Unworked';
		opp1.RecordTypeId = optyGLIRecTypeID;
		opp1.Pricebook2id = pbook.id;
		opp1.AccountId = acc.id;
		opp1.Campaign_Code__c = '00237KI';
		opp1.Owner = u1;
		opp1.Source_System_Detail__c = accssdid;
		opp1.Key_Contact__c = contactId;
		opp1.LCRM_Sub_BU__c = 'SubBU';
		opp1.LATAM_Business_Unit__c = 'Not Latam';
		oppList.add(opp1);

		Opportunity opp2 = new Opportunity();
		opp2 = UnitTest.getOpportunityInstance(acc.id);
		opp2.isdigitalSpearhead__c = FALSE;
		opp2.CloseDate = System.Today() + 30;
		opp2.StageName = 'Appointment Scheduled';
		opp2.Renewal_Date__c = System.Today() + 1;
		opp2.Status__c = 'Unworked';
		opp2.RecordTypeId = optyGLIRecTypeID;
		opp2.Pricebook2id = pbook.id;
		opp2.AccountId = acc.id;
		opp2.Campaign_Code__c = '00237KI';
		opp2.Owner = u1;
		opp2.Source_System_Detail__c = accssdid;
		opp2.Key_Contact__c = contactId;
		opp2.LCRM_Sub_BU__c = 'SubBU';
		opp2.LATAM_Business_Unit__c = 'Not Latam';
		oppList.add(opp2);
		insert oppList;
		oppId = oppList[0].id;
		oppList1 = oppList;
		system.debug(logginglevel.INFO, 'ssdopp-->' + oppId);
		oppId2 = oppList[1].id;
		//return oppList;
		createPaymentAutoCharge();
	}

	public static void createQuote() {
		List<Apttus_Proposal__Proposal__c > quoteList = new list<Apttus_Proposal__Proposal__c > ();

		Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
		q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
		q1.Apttus_Proposal__Opportunity__c = oppId;
		q1.Apttus_Proposal__Account__c = accountId;
		q1.APTS_SSD_Sold_To__c = accssdid;
		q1.APTS_SSD_bill_to__c = accssdid;
		q1.APTS_SSD_ship_to__c = accssdid;
		q1.Apttus_QPConfig__BillToAccountId__c = accountId;
		q1.Apttus_QPConfig__ShipToAccountId__c = accountId;
		q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q1.Digital_Quote_Type__c = 'Best Value';
		q1.Digital_Batch_Processed__c = TRUE;
		q1.Apttus_Proposal__Primary__c = FALSE;
		q1.DC_Updated_On_Configurator__c = TRUE;
		q1.APTS_Order_Confirmation_Contact__c = contactId;
		q1.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
		q1.Apttus_QPConfig__PriceListId__c = pBookId;
		q1.APTS_Proposal_Business_Unit__c = 'SCS';
		q1.APTS_Payment_Option__c = 'Bill to Account';
		quoteList.add(q1);

		Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
		q2.Apttus_Proposal__Proposal_Name__c = 'Non Renewal Quote 1';
		q2.Apttus_Proposal__Opportunity__c = oppId2;
		q2.Apttus_Proposal__Account__c = accountId;
		q2.APTS_SSD_Sold_To__c = accssdid;
		q2.APTS_SSD_bill_to__c = accssdid;
		q2.APTS_SSD_ship_to__c = accssdid;
		q2.Apttus_QPConfig__BillToAccountId__c = accountId;
		q2.Apttus_QPConfig__ShipToAccountId__c = accountId;
		q2.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q2.Digital_Quote_Type__c = 'Best Value+Config';
		q2.Digital_Batch_Processed__c = TRUE;
		q2.Apttus_Proposal__Primary__c = FALSE;
		q2.DC_Updated_On_Configurator__c = TRUE;
		q2.APTS_Order_Confirmation_Contact__c = contactId;
		q2.Apttus_QPConfig__PriceListId__c = pBookId;
		q2.APTS_Proposal_Business_Unit__c = 'FindLaw';
		q2.APTS_Approval_Segment__c = 'Small Law';
		q2.APTS_Payment_Option__c = 'Bill to Account';
		quoteList.add(q2);

		insert quoteList;
		system.debug(logginglevel.INFO, 'test' + quoteList);
		list<Apttus_Config2__ProductConfiguration__c > cartList = new list<Apttus_Config2__ProductConfiguration__c > ();
		Apttus_Config2__ProductConfiguration__c newCart1 = new Apttus_Config2__ProductConfiguration__c(Id = createCart(quoteList[1].Id),
			Apttus_Config2__Status__c = 'Finalized', Name = 'test cart');
		cartList.add(newCart1);

		Apttus_Config2__ProductConfiguration__c newCart2 = new Apttus_Config2__ProductConfiguration__c(Id = createCart(quoteList[0].Id),
			Apttus_Config2__Status__c = 'Finalized');
		cartList.add(newCart2);
		update cartList;
		system.debug(logginglevel.INFO, 'test1' + cartList);

		Product2 prod2 = createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
		Product2 prodopt1 = createProduct('Westlaw™ Corporate Select Essentials Core (CORP)', '42067254', '42067255'); //DLT-17452

		list<Apttus_Config2__LineItem__c > listLines = new list<Apttus_Config2__LineItem__c > ();

		Apttus_Config2__LineItem__c line1 = createLineItem(cartList[0].Id, 1, 1, true, 'Product/Service', prod2.id, null, 2, pBookId, null, false, false);
		listLines.add(line1);

		Apttus_Config2__LineItem__c line2 = createLineItem(cartList[1].Id, 1, 1, true, 'Product/Service', prod2.id, null, 2, pBookId, null, false, true);
		listLines.add(line2);
		Apttus_Config2__LineItem__c lineOpt = createLineItem(cartList[1].Id, 1, 1, true, 'Option', prod2.id, prodopt1.id, 2, pBookId, null, false, true);
		listLines.add(lineOpt); //DLT-17452

		Insert listLines;
		system.debug(logginglevel.INFO, 'test' + listLines);

		productId = prod2.Id;
		bCartId = cartList[0].Id;
		cCartId = cartList[1].Id;
		bQuoteId = quoteList[0].Id;
		cQuoteId = quoteList[1].Id;
		cartName = cartList[0].Name;

		List<Apttus_Proposal__Proposal_Line_Item__c > proposalLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c > ();
		Apttus_Proposal__Proposal_Line_Item__c newLineItem = createProposalLineItem('40974999', prod2.id, q1.id);
		proposalLineItemList.add(newLineItem);
		Apttus_Proposal__Proposal_Line_Item__c newLineItem2 = createProposalLineItem('40974999', prod2.id, q2.id);
		proposalLineItemList.add(newLineItem2);
		insert proposalLineItemList;
	}

	public static APTSECOM_Store__c createStore(String name, String hierarchy) {
		APTSECOM_Store__c store = new APTSECOM_Store__c();
		store.name = name;
		store.APTSECOM_Store_Title__c = name;
		store.APTSECOM_Max_No_Of_PerSeatUsers__c = 10;
		store.APTSECOM_Adjustment_Amount__c = 1;
		store.APTSECOM_Adjustment_Type__c = '% Discount';
		store.APTSECOM_Max_No_Of_Attorneys__c = 5;
		store.APTSECOM_Category_Hierarchy__c = hierarchy;
		store.APTSECOM_Customer_Pricing_Segment__c = 'Law Firm';
		insert store;
		return store;
	}

	public static String createCart(String quoteId) {
		Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		request.QuoteId = quoteId;
		Apttus_CPQApi.CPQ.CreateCartResponseDO response = Apttus_CPQApi.CPQWebService.createCart(request);
		String cartId = response.CartId;

		return cartId;
	}

	public static Apttus_Config2__PriceList__c createPriceList(String name) {
		if (name == null) {
			name = 'Thomson Reuters Master - US Legal';
		}
		return new Apttus_Config2__PriceList__c(Name = name);
	}

	public static Product2 createProduct(String prodName, String serviceNum, String subNum) {

		return createProduct(prodName, serviceNum, subNum, null);
	}

	public static Product2 createProduct(String prodName, String serviceNum, String subNum, String jurisdiction) {
		Set<String> subnumerSet = new Set<String> {
			'41409998',
			'41091348'
		}; // this list have only Banded subnumber 
		Product2 prodObj = new Product2(); //current sub
		prodObj.Name = prodName;
		prodObj.List_Price__c = 0;
		prodObj.Format__c = 'Online';
		prodObj.Is_Orderable__c = TRUE;
		prodObj.IS_WP_Eligible__c = TRUE;
		prodObj.Media_High_Level__c = 'Online';
		prodObj.Service_Number__c = serviceNum;
		prodObj.Subscription_Number__c = subNum;
		if (subnumerSet.contains(subNum)) {
			prodObj.APTS_Product_Pricing_Model__c = 'Banded';
			prodObj.APTS_Media_High_Level_Code__c = '06';
			prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
		} else {
			prodObj.APTS_Product_Pricing_Model__c = 'Per Seat';
			prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
			prodObj.APTS_Media_High_Level_Code__c = '21';
		}
		prodObj.Family = 'WESTLAW';
		prodObj.Apttus_Filter_Media__c = 'Online';
		prodObj.Apttus_Filter_Brand_Code__c = '064';
		prodObj.Productcode = serviceNum;
		prodObj.isActive = true;
		prodObj.CurrencyIsoCode = 'USD';
		if (String.isNotBlank(jurisdiction)) {
			prodObj.DC_Jurisdiction__c = jurisdiction;
		}
		Insert prodObj;

		return prodObj;
	}

	// Customer_Pricing_Segment__c  Apttus_Config2__Quantity__c
	public static Apttus_Config2__PriceDimension__c createPriceDimension(String dataSource, String name) {
		Apttus_Config2__PriceDimension__c pd = new Apttus_Config2__PriceDimension__c();
		pd.Apttus_Config2__ContextType__c = 'Line Item';
		pd.name = name;
		pd.Apttus_Config2__Type__c = 'Standard';
		pd.Apttus_Config2__BusinessObject__c = 'Apttus_Config2__LineItem__c';
		pd.Apttus_Config2__Datasource__c = dataSource;
		insert pd;
		return pd;
	}

	public static Apttus_Config2__PriceMatrix__c createPriceMatix(String priceListItem) {
		Apttus_Config2__PriceMatrix__c priceMatrix = new Apttus_Config2__PriceMatrix__c();
		priceMatrix.Apttus_Config2__MatrixType__c = 'Dimension';
		priceMatrix.Apttus_Config2__PriceListItemId__c = priceListItem;
		priceMatrix.Apttus_Config2__Sequence__c = 0;
		priceMatrix.Apttus_Config2__Dimension1Id__c = createPriceDimension('Apttus_Config2__Quantity__c', 'Quantity').id;
		priceMatrix.Apttus_Config2__Dimension1ValueType__c = 'Range';
		priceMatrix.Apttus_Config2__Dimension2Id__c = createPriceDimension('Customer_Pricing_Segment__c', 'Customer_Pricing_Segment').id;
		priceMatrix.Apttus_Config2__Dimension2ValueType__c = 'Discrete';
		insert priceMatrix;
		priceMatrixid = priceMatrix.id;
		return priceMatrix;
	}

	public static Apttus_Config2__PriceMatrixEntry__c createPriceMatrixEntry(String priceMatrix, String dimension1) {
		Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry = new Apttus_Config2__PriceMatrixEntry__c();
		priceMatrixEntry.Apttus_Config2__PriceMatrixId__c = priceMatrix;
		priceMatrixEntry.Apttus_Config2__EntryKey__c = 'Law Firm';
		priceMatrixEntry.Apttus_Config2__AdjustmentAmount__c = 10.00;
		priceMatrixEntry.Apttus_Config2__AdjustmentType__c = 'List Price Override';
		priceMatrixEntry.Apttus_Config2__Sequence__c = 1;
		priceMatrixEntry.Apttus_Config2__Dimension1Value__c = dimension1;
		priceMatrixEntry.Apttus_Config2__Dimension2Value__c = 'Law Firm';
		insert priceMatrixEntry;
		return priceMatrixEntry;
	}

	public static Apttus_Config2__PriceListItem__c createPriceListItem(String priceList, String product) {
		Apttus_Config2__PriceListItem__c priceListItem = new Apttus_Config2__PriceListItem__c();
		priceListItem.Apttus_Config2__PriceListId__c = priceList;
		priceListItem.Apttus_Config2__ProductId__c = product;
		priceListItem.Apttus_Config2__Active__c = true;
		insert priceListItem;
		priceListItemid = priceListItem.id;
		return priceListItem;
	}

	public static Apttus_Config2__LineItem__c createLineItem(String configId, Integer lineNumber, Integer itemSequence,
		Boolean isPrimaryLine, String lineType, Id productId, Id optionId, Integer quantity,
		Id priceListId, Id plItemId, Boolean isBundle, Boolean isAddOn) {

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
		lineItem.Apttus_Config2__ExtendedPrice__c = 700;
		lineItem.Apttus_Config2__HasOptions__c = isBundle;
		lineItem.Apttus_Config2__StartDate__c = system.today();
		lineItem.Apttus_Config2__EndDate__c = system.today().addDays(30);
		lineItem.Apttus_Config2__AdjustmentAmount__c = 5.0;
		lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
		lineItem.Apttus_Config2__Term__c = 12;
		lineItem.APTS_Contract_Term__c = '2 Years';
		lineItem.DC_Is_Add_On__c = isAddOn;
		lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
		lineItem.Apttus_Config2__BaseExtendedPrice__c = 10.0;
		lineItem.Apttus_Config2__OptionPrice__c = 5.0;
		lineItem.Apttus_Config2__Frequency__c = 'Monthly';
		lineItem.Apttus_Config2__PriceType__c = 'Recurring';
		lineItem.Apttus_Config2__PriceAdjustment__c = 0;
		return lineItem;
	}

	public static List<Online_Contacts__c > createOnline(String cQuoteID, String accountId) {

		List<Online_Contacts__c > ocList = new List<Online_Contacts__c > ();
		Online_Contacts__c oc = new Online_Contacts__c();
		oc.Material__c = '42009567';
		oc.QuoteId__c = cQuoteID;
		oc.Is_Banded_Product__c = TRUE;
		oc.ContactID__c = '0012409071';
		oc.Account__c = accountId;
		oc.APTS_Source_System_Detail__c = accssdid;
		oc.First_Name__c = 'OneChck';
		oc.Middle_Name__c = 'test1';
		oc.Last_Name__c = 'LastOne';
		oc.Email__c = 'myname@tr.com';
		//oc.Type__c = 'Admin';
		oc.Sftwr_Admin__c = TRUE;
		oc.WLEc_Juris__c = 'Indiana';

		ocList.add(oc);

		Online_Contacts__c oc1 = new Online_Contacts__c();
		oc1.Material__c = '42009567';
		oc1.QuoteId__c = cQuoteID;
		oc1.Is_Banded_Product__c = TRUE;
		oc1.ContactID__c = '0012409076';
		oc1.Account__c = accountId;
		oc.APTS_Source_System_Detail__c = accssdid;
		oc1.First_Name__c = 'OneChck1';
		oc.Middle_Name__c = 'test2';
		oc1.Last_Name__c = 'LastOne2';
		oc1.Email__c = 'myname1@tr.com';
		//oc.Type__c = 'Admin';
		oc1.Sftwr_Admin__c = TRUE;
		oc1.WLEc_Juris__c = 'Indiana';
		ocList.add(oc1);

		Online_Contacts__c oc2 = new Online_Contacts__c();
		oc2.Material__c = '420098967';
		oc2.QuoteId__c = cQuoteID;
		oc2.Is_Banded_Product__c = FALSE;
		oc2.ContactID__c = '0012409076';
		oc2.Account__c = accountId;
		oc2.APTS_Source_System_Detail__c = accssdid;
		oc2.First_Name__c = 'OneChck2';
		oc2.Middle_Name__c = 'test3';
		oc2.Last_Name__c = 'LastOne2';
		oc2.Email__c = 'myname31@tr.com';
		//oc.Type__c = 'Admin';
		oc2.Sftwr_Admin__c = TRUE;
		oc2.WLEc_Juris__c = 'Indiana';
		ocList.add(oc2);

		insert ocList;
		return ocList;
		//End onlnee Contacts
	}

	//Added by Harika DLT-9765 Start
	public static List<Apttus_Config2__PriceListItem__c > createPriceListItems(String priceList, integer n) {
		List<Apttus_Config2__PriceListItem__c > listOfLineItems = New List<Apttus_Config2__PriceListItem__c > ();
		for (integer i = 0; i<n; i++) {
			Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
			pliSO.Apttus_Config2__Active__c = true;
			pliSO.Apttus_Config2__PriceListId__c = priceList;
			pliSO.APTS_Max_Fill_Up_Price__c = 5;
			listOfLineItems.add(pliSO);
		}
		insert listOfLineItems;
		return listOfLineItems;
	}

	public static Product2 createProduct(String prodName, String mHLCode, boolean hasMLLCode) {
		Product2 prodObj = new Product2();
		prodObj.Name = prodName;
		prodObj.APTS_Media_High_Level_Code__c = mHLCode;
		if (hasMLLCode) {
			prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
		} else {
			prodObj.APTS_Media_Lower_Level_Code__c = '';
		}

		insert prodObj;
		return prodObj;

	}

	//Created by Harika to utilize common method for test classes for Account SSD creation.
	public static Source_System_Detail__c createSourceSystemDetail(Account acc) {

		Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
		Source_System_Detail__c accountSSD = new Source_System_Detail__c();
		accountSSD.RecordtypeId = ssdRecorType;
		accountSSD.Name = 'ABC';
		accountSSD.Source_System_Name__c = 'ABC';
		accountSSD.Account_Name__c = acc.ID;
		accountSSD.Account_Inactive__c = false;
		accountSSD.Source_System_Account_Number__c = acc.SAPAccountNumber__c;
		//accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
		accountSSD.LCRM_SAP_Account_Number__c = '1004284494';
		accountSSD.BU_Segment_Level_2__c = 'Small Law';
		accountSSD.LCRM_APTS_Band_Number__c = 1;
		accountSSD.APTS_Customer_Category__c = '3';
		accountSSD.LCRM_eOutput_Eligibility__c = '';
		accountSSD.LCRM_Sales_Org__c = 'WEST';
		accountSSD.State__c = 'CA';
		accountSSD.LCRM_Customer_Group__c = 'FIRM';
		insert accountSSD;
		accssdid = accountSSD.id;
		accountSSDlst = accountSSD;
		return accountSSD;

	}
	// Commented "conSSD.LCRM_Contact_ID__c" as SAP_Contact_ID__c need to be assigned to LCRM_Source_Contact_Id__c as per DLT-11509
	public static LCRM_Contact_SSD__c createContactSSD(Contact con, Source_System_Detail__C accSSD) {

		LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c();
		conSSD.LCRM_Contact__c = con.Id;
		conSSD.LCRM_SAP_Role__c = con.SAP_Role__c;
		conSSD.LCRM_Source_Contact_Id__c = con.SAP_Contact_ID__c;
		conSSD.LCRM_Account_SSD__c = accSSD.Id;
		conSSD.LCRM_Email__c = con.Email;
		insert conSSD;
		conssdid = conSSD.id;
		return conSSD;

	}

	public static APTS_Group__c createProposalGroup(Apttus_Proposal__Proposal__c proposal, Apttus_Config2__ProductConfiguration__c prodConfig) {
		APTS_Group__c proposalGroup = new APTS_Group__c();
		proposalGroup.APTS_GrossAmount__c = 0;
		proposalGroup.APTS_Group_Name_Original__c = 'Online/Software Bundle A';
		proposalGroup.APTS_Group_Name__c = 'Online/Software Bundle A';
		proposalGroup.APTS_NetAmount__c = 0;
		proposalGroup.APTS_Quote_Proposal__c = proposal.Id;
		proposalGroup.APTS_MLA__c = false;
		proposalGroup.APTS_Decentralized__c = true;
		proposalGroup.APTS_ProductConfiguration__c = prodConfig.id;
		insert proposalGroup;
		return proposalGroup;
	}

	public static product2 createBandedProduct(string name, string serviceNumber, string family, string mhlCode, string mllCode, string subscrpNum, string prodCode) {
		Product2 prodObj = new Product2(); //current sub
		prodObj.Name = name;
		prodObj.List_Price__c = 0;
		prodObj.Format__c = 'Online';
		prodObj.Is_Orderable__c = TRUE;
		prodObj.IS_WP_Eligible__c = TRUE;
		prodObj.Media_High_Level__c = 'Online';
		prodObj.Service_Number__c = serviceNumber;
		prodObj.Subscription_Number__c = subscrpNum;
		prodObj.APTS_Product_Pricing_Model__c = 'Banded';
		prodObj.Family = family;
		prodObj.Apttus_Filter_Media__c = 'Online';
		prodObj.APTS_Media_High_Level_Code__c = mhlCode;
		prodObj.APTS_Media_Lower_Level_Code__c = mllCode;
		prodObj.Productcode = prodCode;
		prodObj.isActive = true;

		return prodObj;
	}

	//Ends
	public static void createKeyValueListStoreSetting() {
		List<KeyValueListStore__c > keyvalueList = new List<KeyValueListStore__c > ();
		KeyValueListStore__c testKeyValueSetting = new KeyValueListStore__c();
		testKeyValueSetting.name = 'ANZUsersProfileId';
		testKeyValueSetting.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;
		keyvalueList.add(testKeyValueSetting);
		insert keyvalueList;
	}

	public static void createRecordTypeIds() {
		List<RecordtypeIds__c > recTypeIdList = new List<RecordtypeIds__c > ();
		RecordtypeIds__c testRecordtypeSetting = new RecordtypeIds__c();
		testRecordtypeSetting.name = 'Pipeline Opportunities';
		testRecordtypeSetting.recTypeId__c = System.Label.Digital_Pipeline_Record_Type_ID;
		recTypeIdList.add(testRecordtypeSetting);
		testRecordtypeSetting = new RecordtypeIds__c();
		testRecordtypeSetting.name = 'Pre-Pipeline Opportunities';
		testRecordtypeSetting.recTypeId__c = System.Label.Digital_Pre_Pipeline_Record_Type_Id;
		recTypeIdList.add(testRecordtypeSetting);
		testRecordtypeSetting = new RecordtypeIds__c();
		testRecordtypeSetting.name = 'GLI Pipeline Opportunity';
		testRecordtypeSetting.recTypeId__c = System.Label.Digital_Pre_Pipeline_Record_Type_Id;
		recTypeIdList.add(testRecordtypeSetting);
		insert recTypeIdList;
	}

	public static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(String subscNumber, String productId, String propId) {
		Apttus_Proposal__Proposal_Line_Item__c newLineItem2 = new Apttus_Proposal__Proposal_Line_Item__c();
		newLineItem2.APTS_Subscription_Number__c = subscNumber;
		newLineItem2.Apttus_Proposal__Product__c = productId;
		newLineItem2.Apttus_Proposal__Proposal__c = propId;
		newLineItem2.Apttus_QPConfig__IsOptionRollupLine__c = true;
		newLineItem2.APTS_Yearly_Total__c = 300.00;
		return newLineItem2;
	}

	public static void createDocuSignWebService() {
		// create web service setting for DocuSign Connection
		WebServiceSettings__c web = new WebServiceSettings__c();
		web.Endpoint__c = 'test.endpoint';
		web.Name = 'Digital DocuSign Connection';
		web.Username__c = 'test.user';
		web.Password__c = 'test:123';
		web.Service_Unavailable_Message__c = 'testservice';
		insert web;
	}

	public static void createMarketAutomationWebsvc() {
		WebServiceSettings__c webMkt = new WebServiceSettings__c();
		webMkt.Endpoint__c = 'test.endpoint';
		webMkt.Name = 'MarketingAutomationService';
		webMkt.Username__c = 'test.user';
		webMkt.Password__c = 'test:123';
		webMkt.Service_Unavailable_Message__c = 'test no service';
		insert webMkt;
	}

	public static void createPaymentCreditWebService() {
		WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
		oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable';
		oWebServiceSettings.Name = 'PaymentCreditIncrease';
		oWebServiceSettings.Timeout__c = 120;
		oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
		oWebServiceSettings.Active__c = true;
		insert oWebServiceSettings;
	}

	public static void createPaymentAutoCharge() {
		WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
		oWebServiceSettings.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable';
		oWebServiceSettings.Name = 'Payment AutoCharge';
		oWebServiceSettings.Timeout__c = 120;
		oWebServiceSettings.Endpoint__c = 'https://thomsonreutersglis2e--stream15.cs30.my.salesforce.com/servlet/servlet.ExternalRedirect?url=https%3A%2F%2Fsecurepayment.thomsonreuters.com%2FTRPaymentGateway%2FBilling%2FInvoiceSummary%2FTRPaymentAutoCharge';
		oWebServiceSettings.Active__c = true;
		insert oWebServiceSettings;
	}

	//Below need update as your need when useed addon and Straight
	public static Product_Account_Detail__c createDigitalSubscriptions(String svc, String sub, String typ, String zp, Date tday, String campaignCode) {
		Product_Account_Detail__c ds = new Product_Account_Detail__c();
		ds.Add_On_Sub__c = sub;
		ds.Add_On_Svc__c = svc;
		ds.Add_on_Type__c = typ;
		ds.ZP_Cust_Number__c = zp;
		ds.Campaign_Code__c = campaignCode;
		ds.Digital_Firm__c = 'Small Law';
		ds.Renewal_Date__c = tday;
		if (typ == 'Premium') {
			ds.Premium_New_Service__c = svc;
			ds.Premium_New_Subscription__c = sub;
		}
		if (typ == 'Best Value') {
			ds.Actual_New_Subscription__c = sub;
			ds.Actual_New_Service__c = svc;
		}
		insert ds;
		return ds;
	}

	public static Digital_Product_Plans__c createProductPlan(String producTID, String sNumber, String mNumber) {
		Digital_Product_Plans__c plan = new Digital_Product_Plans__c();
		plan.Material_Number__c = mNumber;
		plan.Material_Description__c = 'test';
		plan.Subscription_Number__c = sNumber;
		plan.SLF_Jurisdiction__c = 'test';
		plan.DB_Group__c = 'test';
		plan.DB_Group_Sort_Order__c = 1;
		plan.DB_Category__c = 'test';
		plan.DB_Category_Sort_Order__c = 1;
		plan.SLF_Help_Text__c = 'test';
		plan.Additional_Help_Text__c = 'test';
		plan.Product__c = producTID;
		insert plan;
		return plan;
	}

	public static APTSECOM_Store_Price_Adjustment__c createStorePriceAdjustments(String store, String category, String adjustmentType, Decimal adjustmentAmount) {
		APTSECOM_Store_Price_Adjustment__c storePrice = new APTSECOM_Store_Price_Adjustment__c();
		storePrice.APTSECOM_Store__c = store;
		storePrice.APTSECOM_Category_Hierarchy__c = category;
		storePrice.APTSECOM_Adjustment_Amount__c = adjustmentAmount;
		storePrice.APTSECOM_Adjustment_Type__c = adjustmentType;
		insert storePrice;
		return storePrice;
	}

	public static void createCategories(String productId) {

		Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
		mainCategory.Apttus_Config2__HierarchyLabel__c = 'Digital Configurator';
		mainCategory.Name = 'Digital Configurator';
		Insert mainCategory;

		Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();

		hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierMain.Name = 'Digital Configurator';
		hierMain.Apttus_Config2__Label__c = 'Digital Configurator';
		hierMain.Apttus_Config2__Level__c = 0;
		Insert hierMain;

		mainCategoryId = hierMain.id;
		List<Apttus_Config2__ClassificationHierarchy__c > level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c > ();
		Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
		hierPL.Apttus_Config2__Level__c = 1;
		hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
		hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierPL.Name = 'Primary Law';
		hierPL.Apttus_Config2__Label__c = 'Primary Law';
		hierPL.DC_Sequence_No__c = 1;

		level1HierList.add(hierPL);

		Apttus_Config2__ClassificationHierarchy__c hierAN = new Apttus_Config2__ClassificationHierarchy__c();

		hierAN.Apttus_Config2__AncestorId__c = hierMain.Id;
		hierAN.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierAN.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierAN.Name = 'Primary Law';
		hierAN.Apttus_Config2__Label__c = 'Analytical';
		hierAN.DC_Sequence_No__c = 2;
		hierPL.Apttus_Config2__Level__c = 1;
		level1HierList.add(hierAN);

		Apttus_Config2__ClassificationHierarchy__c hierLI = new Apttus_Config2__ClassificationHierarchy__c();

		hierLI.Apttus_Config2__AncestorId__c = hierMain.Id;
		hierLI.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierLI.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierLI.Name = 'Primary Law';
		hierLI.Apttus_Config2__Label__c = 'Litigation';
		hierLI.DC_Sequence_No__c = 3;
		hierLI.Apttus_Config2__Level__c = 1;
		level1HierList.add(hierLI);
		Insert level1HierList;

		List<Apttus_Config2__ClassificationHierarchy__c > level2HierList = new List<Apttus_Config2__ClassificationHierarchy__c > ();
		Apttus_Config2__ClassificationHierarchy__c hierPLYourState = new Apttus_Config2__ClassificationHierarchy__c();

		hierPLYourState.Apttus_Config2__AncestorId__c = level1HierList[0].Id;
		hierPLYourState.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierPLYourState.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierPLYourState.Name = 'Your State / All States';
		hierPLYourState.Apttus_Config2__Label__c = 'Your State / All States';
		hierPLYourState.DC_Sequence_No__c = 1;
		hierPLYourState.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierPLYourState);

		Apttus_Config2__ClassificationHierarchy__c hierPLYourCircuit = new Apttus_Config2__ClassificationHierarchy__c();

		hierPLYourCircuit.Apttus_Config2__AncestorId__c = level1HierList[0].Id;
		hierPLYourCircuit.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierPLYourCircuit.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierPLYourCircuit.Name = 'Your Circuit / All Federal';
		hierPLYourCircuit.Apttus_Config2__Label__c = 'Your Circuit / All Federal';
		hierPLYourCircuit.DC_Sequence_No__c = 2;
		hierPLYourCircuit.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierPLYourCircuit);

		Apttus_Config2__ClassificationHierarchy__c hierANYourAllNational = new Apttus_Config2__ClassificationHierarchy__c();

		hierANYourAllNational.Apttus_Config2__AncestorId__c = level1HierList[1].Id;
		hierANYourAllNational.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierANYourAllNational.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierANYourAllNational.Name = 'Your State / All States / National';
		hierANYourAllNational.Apttus_Config2__Label__c = 'Your State / All States / National';
		hierANYourAllNational.DC_Sequence_No__c = 1;
		hierANYourAllNational.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierANYourAllNational);

		Apttus_Config2__ClassificationHierarchy__c hierLIJuryV = new Apttus_Config2__ClassificationHierarchy__c();

		hierLIJuryV.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
		hierLIJuryV.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierLIJuryV.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierLIJuryV.Name = 'Jury verdicts';
		hierLIJuryV.Apttus_Config2__Label__c = 'Jury verdicts';
		hierLIJuryV.DC_Sequence_No__c = 1;
		hierLIJuryV.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierLIJuryV);

		Apttus_Config2__ClassificationHierarchy__c hierLITrialCourtOrders = new Apttus_Config2__ClassificationHierarchy__c();

		hierLITrialCourtOrders.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
		hierLITrialCourtOrders.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierLITrialCourtOrders.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierLITrialCourtOrders.Name = 'Trial court orders';
		hierLITrialCourtOrders.Apttus_Config2__Label__c = 'Trial court orders';
		hierLITrialCourtOrders.DC_Sequence_No__c = 2;
		hierLITrialCourtOrders.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierLITrialCourtOrders);

		Apttus_Config2__ClassificationHierarchy__c hierLITrialCourtFilings = new Apttus_Config2__ClassificationHierarchy__c();

		hierLITrialCourtFilings.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
		hierLITrialCourtFilings.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierLITrialCourtFilings.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierLITrialCourtFilings.Name = 'Trial Court filings';
		hierLITrialCourtFilings.Apttus_Config2__Label__c = 'Trial Court filings';
		hierLITrialCourtFilings.DC_Sequence_No__c = 3;
		hierLITrialCourtFilings.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierLITrialCourtFilings);

		Apttus_Config2__ClassificationHierarchy__c hierLIAppellate = new Apttus_Config2__ClassificationHierarchy__c();

		hierLIAppellate.Apttus_Config2__AncestorId__c = level1HierList[2].Id;
		hierLIAppellate.Apttus_Config2__HierarchyId__c = mainCategory.Id;
		hierLIAppellate.Apttus_Config2__PrimordialId__c = hierMain.Id;
		hierLIAppellate.Name = 'Appellate briefs';
		hierLIAppellate.Apttus_Config2__Label__c = 'Appellate briefs';
		hierLIAppellate.DC_Sequence_No__c = 4;
		hierLIAppellate.Apttus_Config2__Level__c = 2;
		level2HierList.add(hierLIAppellate);

		Insert level2HierList;

		Apttus_Config2__ProductClassification__c prodClass = new Apttus_Config2__ProductClassification__c();
		prodClass.Apttus_Config2__ProductId__c = productId;
		prodClass.Apttus_Config2__ClassificationId__c = level2HierList[0].Id;
		prodClass.DC_Product_Title__c = 'Test';
		prodClass.DC_Product_Jurisdiction__c = 'California';
		prodClass.DC_Product_Description__c = 'test';
		prodClass.Apttus_Config2__Sequence__c = 1;
		Insert prodClass;

		Apttus_Config2__ProductClassification__c prodClass1 = new Apttus_Config2__ProductClassification__c();
		prodClass1.Apttus_Config2__ProductId__c = productId;
		prodClass1.Apttus_Config2__ClassificationId__c = level2HierList[1].Id;
		prodClass1.DC_Product_Title__c = 'Test';
		prodClass1.DC_Product_Jurisdiction__c = 'Your State / All States / National';
		prodClass1.DC_Product_Description__c = 'test';
		prodClass.Apttus_Config2__Sequence__c = 1;
		Insert prodClass1;
	}

	public static void createDocuSignUser() {
		// default DocuSign user record        
		Apttus_DocuApi__DocuSignUser__c oDocuSign = new Apttus_DocuApi__DocuSignUser__c();
		oDocuSign.Apttus_DocuApi__DocuSignAccountId__c = '1970775';
		oDocuSign.Apttus_DocuApi__Default__c = TRUE;
		insert oDocuSign;
	}

	public static Apttus_DocuApi__DocuSignEnvelope__c createDocuSignEnvelope(String status, Id quoteId) {
		Apttus_DocuApi__DocuSignEnvelope__c newEnv = new Apttus_DocuApi__DocuSignEnvelope__c();
		newEnv.APTTUS_DOCUAPI__STATUS__C = status;
		newEnv.Apttus_QPDSign__QuoteProposal__c = quoteId;
		newEnv.Apttus_DocuApi__ParentId__c = quoteId;
		return newEnv;
	}

	public static void createAttachment(string quoteId) {
		// create attachment for a Quote/Proposal
		Attachment oAtt = new Attachment();
		oAtt.Body = Blob.valueOf('test file attachment');
		oAtt.Name = String.valueOf('test.txt');
		oAtt.ContentType = 'txt';
		oAtt.ParentId = quoteId;
		insert oAtt;
		attachmentId = oAtt.Id;
	}

	public static void createTemplate() {
		// create template for Order generation
		Apttus__APTS_Template__c newTemplate = new Apttus__APTS_Template__c();
		newTemplate.Name = System.Label.Digital_OF;
		newTemplate.Apttus__IsActive__c = true;
		newTemplate.Apttus__Type__c = 'Proposal';
		newTemplate.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
		newTemplate.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
		newTemplate.Apttus__FrameworkFormat__c = 'FX2';
		insert newTemplate;
		templateId = newTemplate.Id;
	}

	public static void createUser() {
		Profile p1 = [SELECT Id FROM Profile WHERE Name = 'ANZ Users'
			LIMIT 1
		];

		User oUser = new User();
		oUser.FirstName = 'Test';
		oUser.LastName = 'User';
		oUser.Email = 'test.user@email.xxx';
		oUser.Alias = 'tuser';
		oUser.EmailEncodingKey = 'UTF-8';
		oUser.LanguageLocaleKey = 'en_US';
		oUser.LocaleSidKey = 'en_US';
		oUser.ProfileId = p1.Id;
		oUser.TimeZoneSidKey = 'America/Los_Angeles';
		oUser.UserName = 'Test.User@testorg.com';
		oUser.Sub_Bu__c = 'FindLaw';
		insert oUser;
		userId = oUser.Id;
	}

	public static Apttus_Config2__PriceList__c createPriceListRec(String name) {
		if (name == null) {
			name = 'Thomson Reuters Master - US Legal';
		}
		return new Apttus_Config2__PriceList__c(Name = name);
	}

	public static Account createAccount(String name) {
		// Commented Segmentation Fields - DLT-20035
		Account acc = new Account(Name = name);
		//acc.FrozenMarketSegment__c = 'Solo Law Firm';
		acc.SAPAccountNumber__c = '1004284494';
		//  acc.Customer_Group__c = 'FIRM';
		acc.APTS_Band_Number__c = 1;
		acc.APTS_Customer_Category__c = '3';
		acc.APTS_eOutput_Eligibilty__c = '';
		acc.Customer_Type__c = 'FIRM';
		//  acc.Industry = 'Firm-Law Small'; 
		//   acc.BU_Marketing_Segment__c = 'Solo Law Firm'; 
		//  acc.GLI_Segment__c = 'Law Firm';
		//   acc.GLI_Sub_Segment__c = 'Solo Law Firm';
		acc.BillingCity = 'Eagan';
		acc.BillingState = 'MN';
		acc.BillingCountry = 'US';
		acc.BillingPostalCode = '55123';
		acc.BillingStreet = '610 Opperman Dr';
		acc.Phone = '16462235555';
		//   acc.Sales_Org__c = 'WEST';      
		return acc;
	}

	public static Account createAccountRec(String name) {
		Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
		String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
		Account a = new Account(Name = name);
		//  a.FrozenMarketSegment__c = valueMarket;
		a.BillingCity = 'Eagan';
		a.BillingState = 'MN';
		a.BillingCountry = 'US';
		a.BillingPostalCode = '55123';
		a.BillingStreet = '610 Opperman Dr';
		a.Phone = '16462235555';
		return a;
	}

	public static Contact createContactRec(String lastname, id accId) {
		Contact c = new Contact(lastName = lastname, accountId = accId);
		c.FirstName = 'Test';
		c.Email = 'test.user@email.com';
		return c;
	}

	public static Opportunity createOpportunityRec(String name, Id accountId, String stageName, Date closeDate, String acctssdId) {
		Contact c = createContactRec('test lastname', accountId);
		Opportunity o = new Opportunity(Name = name, AccountId = accountId, stageName = stageName, CloseDate = closeDate, key_contact__c = c.Id);
		o.Campaign_Code__c = System.Label.Digital_Campaign_Code;
		o.Source_System_Detail__c = acctssdId;
		o.isDigitalSpearHead__c = TRUE;
		o.LCRM_Sub_BU__c = 'SubBU';
		o.LATAM_Business_Unit__c = 'Not Latam';
		return o;
	}

	public static Apttus_Proposal__Proposal__c createProposalRec(Id oppId, Id ssdId, Id accid, id newCon, string conEmail) {
		Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Opportunity__c = oppId, APTS_SSD_Sold_To__c = ssdId, APTS_SSD_bill_to__c = ssdId);
		p.Apttus_Proposal__Approval_Stage__c = 'Generated';
		p.Apttus_Proposal__Primary__c = true;
		p.Digital_Batch_Processed__c = true;
		p.Apttus_Proposal__Account__c = accid;
		p.APTS_Order_Confirmation_Contact__c = newCon;
		p.APTS_Order_Confirmation_Contact_Email__c = conEmail;
		p.APTS_Proposal_Business_Unit__c = 'SCS';
		p.APTS_Payment_Option__c = 'Bill to Account';
		return p;
	}

	public static Product2 createProductForPricingRec(String productName, String pfamily, String highLevelCode, String lowLevelCode) {
		Product2 productSO = createProductRec(productName, pfamily);
		productSO.APTS_Media_High_Level_Code__c = highLevelCode;
		productSO.APTS_Media_Lower_Level_Code__c = lowLevelCode;
		productSO.List_Price__c = 100;
		productSO.Format__c = 'Online';
		productSO.Is_Orderable__c = TRUE;
		productSO.IS_WP_Eligible__c = TRUE;
		productSO.Media_High_Level__c = 'Online';
		productSO.Service_Number__c = '40982845';
		productSO.Subscription_Number__c = '40974107';
		productSO.APTS_Product_Pricing_Model__c = 'Banded';
		productSO.Apttus_Filter_Media__c = 'Online';
		return productSO;
	}

	public static Product2 createProductRec(String productName, String pfamily) {
		Product2 productSO = new Product2();
		productSO.Name = productName;
		productSO.Family = pfamily;
		productSO.IsActive = true;
		productSO.CurrencyIsoCode = 'USD';
		return productSO;
	}

	public static Apttus_Config2__ProductConfiguration__c createProductConfiguration(Id proposalId) {
		Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposalId);
		return prodConfig;
	}

	public static Apttus_Config2__SummaryGroup__c createSummaryGroup(string prodConfigId, string name) {
		Apttus_Config2__SummaryGroup__c summaryGroup = new Apttus_Config2__SummaryGroup__c();
		summaryGroup.Apttus_Config2__ConfigurationId__c = prodConfigid;
		summaryGroup.Name = 'WEST PROFLEX Bundle A - Test group';
		summaryGroup.Apttus_Config2__LineType__c = 'Total';
		summaryGroup.Apttus_Config2__ItemSequence__c = 2;
		summaryGroup.Apttus_Config2__LineNumber__c = 1;
		insert summaryGroup;
		return summaryGroup;
	}

	public static APTSECOM_Product_Recommendation__c createRecommendation(Id productId, Id storeId) {
		//Create Recommendation record
		APTSECOM_Product_Recommendation__c oProdRec = new APTSECOM_Product_Recommendation__c();
		oProdRec.APTSECOM_Source_Product__c = productId;
		oProdRec.APTSECOM_Product__c = productId;
		oProdRec.APTSECOM_Store__c = storeId;
		insert oProdRec;
		return oProdRec;
	}

	public static Apttus_Proposal__Proposal__c createQuote(String accountId, String type1) {

		Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
		q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
		q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
		q1.Digital_Quote_Type__c = type1;
		q1.Digital_Batch_Processed__c = TRUE;
		q1.Apttus_Proposal__Primary__c = false;
		q1.Apttus_Proposal__Account__c = accountId;
		q1.Apttus_QPConfig__BillToAccountId__c = accountId;
		q1.Apttus_QPConfig__ShipToAccountId__c = accountId;
		q1.APTS_Proposal_Business_Unit__c = 'SCS';
		q1.APTS_Payment_Option__c = 'Bill to Account';
		return q1;
	}

	public static Apttus_Config2__ProductConfiguration__c createCart(String accountId, String proposalId, String orderId, String priceListId) {
		Apttus_Config2__ProductConfiguration__c cartSO = new Apttus_Config2__ProductConfiguration__c();
		cartSO.Name = 'Product Confiuguration - 1';
		cartSO.Apttus_Config2__VersionNumber__c = 1;
		if (orderId != null) {
			cartSO.Apttus_Config2__BusinessObjectId__c = orderId;
			cartSO.Apttus_Config2__BusinessObjectType__c = 'Order';
			cartSO.Apttus_Config2__OrderId__c = orderId;
		} else {
			cartSO.Apttus_Config2__BusinessObjectId__c = proposalId;
			cartSO.Apttus_Config2__BusinessObjectType__c = 'Proposal'; // 'Order'
			cartSO.Apttus_QPConfig__Proposald__c = proposalId;
		}

		cartSO.Apttus_Config2__Status__c = 'New';
		//Changed new ssd lookup fields instead of account lookup
		//cartSO.APTS_SSD_bill_to__c= ssdid;
		cartSO.Apttus_Config2__BillToAccountId__c = accountId;
		//cartSO.APTS_SSD_Ship_To__c= ssdid;
		cartSO.Apttus_Config2__ShipToAccountId__c = accountId;
		cartSO.Apttus_Config2__AccountId__c = accountId;
		cartSO.Apttus_Config2__PriceListId__c = priceListId;
		cartSO.Apttus_Config2__IsTransient__c = true;

		return cartSO;
	}

	public static Lead createLead(Ecom_OrderRequest.cls_storeOrder storeOrder, String orderId) {
		Ecom_OrderRequest.cls_customerDetails leadInfo = storeOrder.customerDetails;
		Lead lead = new Lead();
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

	public static Apttus_Config2__Order__c createOrder(String priceList, String store) {
		Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
		order.Apttus_Config2__Status__c = 'New';
		order.Apttus_Config2__PricingDate__c = System.today();
		order.APTSECOM_Store__c = store;
		order.APTSECOM_Total_Price__c = 1111;
		order.APTSECOM_Plan_Name__c = 'Test plan';
		order.Apttus_Config2__PriceListId__c = priceList;
		order.Apttus_Config2__OrderDate__c = System.today();

		return order;
	}

	public static APTSECOM_Store__c createStore(String name, String hierarchy, String priceListId) {
		APTSECOM_Store__c store = new APTSECOM_Store__c();
		store.name = name;
		store.APTSECOM_Store_Title__c = name;
		store.APTSECOM_Max_No_Of_PerSeatUsers__c = 10;
		store.APTSECOM_Adjustment_Amount__c = 1;
		store.APTSECOM_Adjustment_Type__c = '% Discount';
		store.APTSECOM_Max_No_Of_Attorneys__c = 5;
		store.APTSECOM_Price_List__c = priceListId;
		store.APTSECOM_Category_Hierarchy__c = hierarchy;
		store.APTSECOM_Customer_Pricing_Segment__c = 'Law Firm';

		return store;
	}

	public static void createConfigBundle() {
		APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
		bundlePageSettings.Name = 'Bundle Page Properties';
		bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
		bundlePageSettings.Eligibility_codes_for_print__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
		bundlePageSettings.Eligibility_codes_for_online_software__c = '05E5,05SN,062P,062Q,0649,0651,0672,06AB,06AO,06AP,06AR,06BA,06DA,06E5,06I9,06IA,06J9,06L2,06LB,06M4,06OA,06OR,06P7,06PC, 06PN,06PR,06PS,06Q3,06WA,13AB,13AR,13CF,13CM,13CR,13E2,13E9,13I9,13IQ,13LB,13LG,13LO,13LQ,13LR,13LX,13PE,13PS,13PX,13SB,13SN,13ST,13SX';
		bundlePageSettings.WestPack_valid_codes__c = 'L-F1,L-F1SG,L-F4,L-G1,L-G1SG,L-T1,NA00,NA30,NA31,RB50,RB75,SO30,SPEC,SPEC2,ST00,ST30,ST31,TO00,TO30,WP00,WPK3,EPAK';
		bundlePageSettings.Adjustment_Picklist_Values__c = '% Discount,% Markup';
		bundlePageSettings.Ineligible_Existing_Deals__c = 'EPAK,LSP,LMA,WCMP';
		bundlePageSettings.Incremental_Revenue_Required__c = 2;
		bundlePageSettings.APTS_Max_Discount__c = 20;
		insert bundlePageSettings;
	}

	public static void createAssetLineItem(String proposalId) {
		Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
		ali.Apttus_Config2__Quantity__c = 1;
		ali.Apttus_Config2__Description__c = '';
		ali.Apttus_Config2__AssetStatus__c = 'New';
		ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
		ali.Apttus_QPConfig__ProposalId__c = proposalId;
		//ali.APTS_SAP_Deal_Type__c = 'TO00';
		insert ali;
		assetLineItemId = ali.Id;
	}
	//Existing create Product Method gives an error, So crated new specifically to this DCDynamicBundleTest class.
	public static Product2 createProductforDCDyn(String pName, String hLCdoe, String lLCode) {
		Product2 prodObj = new Product2();
		prodObj.Name = pName;
		prodObj.APTS_Media_High_Level_Code__c = hLCdoe;
		prodObj.APTS_Media_Lower_Level_Code__c = lLCode;
		return prodObj;

	}

	@IsTest
	static void testMainFunction() {

		test.startTest();
		DCTestData.createData();
		List<Opportunity> listOpp = [SELECT id FROM Opportunity];
		List<Account> listAcc = [SELECT id FROM Account];
		system.assert(!(listOpp.isEmpty()), 'Opportunity failed to be created');
		system.assert(!(listAcc.isEmpty()), 'Accoutn failed to be created');
		test.stopTest();
	}

}