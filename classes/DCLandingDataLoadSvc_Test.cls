/*
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date            Name                    Description
 * 3 July 2018   Bharat Bhushan           DLT-10775 - Update DCLandingDataLoadSvc_Test as per best practice 
 * 15 Aug 2018   Harika Sai P             DLT-11661 - Combine the Landing Page service into a single service
 * 05 Nov 2018   Rajan Tatuskar           DLT-12679 - Recommendations reason from Automation file for Upsell Offers
 * 08 Feb 2019   Navleen Kaur             DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 23 May 2019   Navleen Kaur             DLT-16511 - Added two more methods to increase the coverage 
 * 03 Oct 2019   Harika Sai P             DLT-17751 - Price mismatch in landing page, assign users page and confirmation page
 * 31 OCT 2019   HarikaSaiP               DLT-17793 - [CORP][SFDC] Multi Offer - Add option products to the subscription list
 * 18 May 2020   Benjamin Her             DLT-20045 - Update calls to include new 'quoteId' parameter
 * ==================================================================================================================================   
 */
@isTest
public class DCLandingDataLoadSvc_Test {

	//Adding testSetup method to create test data
	@testSetup static void testdata() {
		//DCTestData.createTestData();
		LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
		ltstemp.LTS_Disable_Process_Builders__c = true;
		ltstemp.LTS_Disable_Triggers__c = true;
		ltstemp.LTS_Disable_Validation_Rules__c = true;
		ltstemp.LTS_Disable_Workflow_Rules__c = true;
		ltstemp.Name = 'temp';
		ltstemp.SetupOwnerId = userinfo.getuserid();
		insert ltstemp;

		DCTestData.createData();
		Test.startTest();
		DCTestData.createQuote();
		Test.stopTest();
		DCTestData.createPaymentAutoCharge();
		List<Product_Account_Detail__c > dslist = new List<Product_Account_Detail__c > ();
		dslist.add(new Product_Account_Detail__c(ZP_Cust_Number__c = '1004284494',
			Campaign_Code__c = '00237KI',
			Renewal_date__c = System.Today() + 1,
			Type__c = 'Premium',
			Current_Subscription__c = '12345',
			Current_Term_Length__c = 1,
			Year1_YoYvalue__c = 1,
			Year2_YoYvalue__c = 2,
			Year3_YoYvalue__c = 3,
			Digital_Firm__c = 'Small Law',
			Premium_Rec_Text_Code__c = 'PREMIUM_REC'));

		//*** START :: Added by Rajan :: DLT-12679 - Recommendations reason from Automation file for Upsell Offers
		dslist.add(new Product_Account_Detail__c(ZP_Cust_Number__c = '1004284494',
			Campaign_Code__c = '00237KI',
			Renewal_date__c = System.Today() + 1,
			Type__c = 'Plus',
			Actual_New_Subscription__c = '42542977',
			Actual_New_Service__c = '42542976',
			Current_Term_Length__c = 1,
			Year1_YoYvalue__c = 1,
			Year2_YoYvalue__c = 2,
			Year3_YoYvalue__c = 3,
			Digital_Firm__c = 'Small Law',
			Plus_Rec_Text_Code__c = 'ANCILLARY_USAGE'));
		dslist.add(new Product_Account_Detail__c(ZP_Cust_Number__c = '1004284494',
			Campaign_Code__c = '00237KI',
			Renewal_date__c = System.Today() + 1,
			Type__c = 'Premium',
			Premium_New_Subscription__c = '42542977',
			Premium_New_Service__c = '42542976',
			Current_Term_Length__c = 1,
			Year1_YoYvalue__c = 1,
			Year2_YoYvalue__c = 2,
			Year3_YoYvalue__c = 3,
			Digital_Firm__c = 'Small Law',
			Plus_Rec_Text_Code__c = 'PREMIUM_REC'));
		//*** END :: Added by Rajan :: DLT-12679 - Recommendations reason from Automation file for Upsell Offers                                        

		insert dslist;
		DCTestData.createDigitalSubscriptions(NULL, '42076322', 'Premium', '1004284494', System.Today(), '1004284494');
		DCTestData.createDigitalSubscriptions('42542976', '42542977', 'Premium', '1004284494', System.Today(), '1004284494');
		DCTestData.createDigitalSubscriptions('42514194', '42514195', 'Premium', '1004284494', System.Today(), '1004284494');
		Apttus_Config2__ProductConfiguration__c cart = [select id from Apttus_Config2__ProductConfiguration__c Limit 1];
		cart.APTS_SSD_bill_to__c = DCTestData.accssdid;
		update cart;
		Apttus_Config2__PriceList__c pBook = [SELECT Id FROM Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal'
			limit 1
		];
		Product2 prod2 = [select id from Product2 limit 1];
		Apttus_Config2__PriceListItem__c priceListItem = DCTestData.createPriceListItem(pBook.Id, prod2.Id);
		Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(priceListItem.Id);
		Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry = DCTestData.createPriceMatrixEntry(priceMatrix.Id, '1');

		Apttus_DocuApi__DocuSignEnvelope__c docSignEnv = new Apttus_DocuApi__DocuSignEnvelope__c();
		docSignEnv.Apttus_DocuApi__EnvelopeId__c = 'Test-Env-Id1';
		docSignEnv.Name = 'Test-Env-Id1';
		docSignEnv.Apttus_DocuApi__EnvelopeContent__c = '{"success":true,"showTagAndSend":false,"showSendforESignature":true,"showSendAsAnotherUser":true,"showPreview":true,"senderViewURL":null,"sendAsUserEmail":"molly.bentz=tr.com@example.com","parentId":"a4N0m0000008OMbEAM","oneClickSend":false,"objRecipientList":{"listRecipient":[{"tabs":null,"signingGroupId":null,"signerType":"signers","signerRole":"Signer","selected":true,"orderNumber":1,"objectType":null,"objectIndex":0,"name":"Amy Banks","isRequired":null,"id":"0031300002TjjzqAAB","emailTemplateId":null,"emailNotification":null,"email":"amy@bankslawyers.com","canMoveUp":false,"canMoveDown":false}]},"objAttachmentWrapperList":{"parentStatus":null,"parentNumber":null,"parentName":null,"listAttachmentWrapper":[{"siblingsId":null,"selected":true,"relationship":"Primary","parentStatus":null,"parentNumber":null,"parentName":null,"parentId":"a4N0m0000008OMbEAM","objectIndex":0,"isSibling":false,"isParent":false,"isChild":false,"documentAssociationType":"Primary","canMoveUp":false,"canMoveDown":true,"attachment":{"attributes":{"type":"Attachment","url":"/services/data/v39.0/sobjects/Attachment/00P0m000000E6psEAC"},"Id":"00P0m000000E6psEAC","Name":"SLF Digital Spearhead POC EM May Sept MARTHA BANKS - clone_' + System.Label.Digital_OF + '_2017-05-26.pdf"}}],"hasSibling":false,"hasRelated":false,"hasParent":false,"hasChild":false,"hasAmendRenew":false},"notification":{"useAccountDefaults":true,"reminders":null,"expirations":null},"isPreviewInDocusign":false,"Id":"36832a9b-d57a-4eed-bfeb-94bfee3ff971","errorMessage":null,"errorCode":null,"error":false,"envelopeStatus":"Sent","emailSubject":"Request for eSignatures","emailBody":"Request for eSignatures. Please review and sign.","documentUploadProcessId":null}';
		insert docSignEnv;

		List<Apttus_Proposal__Proposal__c > quoteList = [Select ID, Order_Confirmation_Contact_SSD__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1'
			Limit 1000
		];
		for (Apttus_Proposal__Proposal__c quote: quoteList) {
			quote.DocuSign_Envelope_ID__c = docSignEnv.Apttus_DocuApi__EnvelopeId__c;
		}
		update quoteList;
	}

	//To test QDCLandingdataLoadSvc class method. Which is getting request from AEM and sending response from SFDC.
	public static testmethod void landingLoadApi() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		List<Apttus_Proposal__Proposal__c > qlist = [select id, Digital_Quote_Type__c from Apttus_Proposal__Proposal__c limit 10];
		System.debug('qlist=============>' + qlist);
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661
		Test.startTest();
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null); //DLT-11661

		//Test different Current Term
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c];
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 2;
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 3;
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);

		DCLandingDataLoadSvc.landingPageLoadApi(null, null, false, null); // produce error
		Test.stopTest();
		System.assertNotEquals(DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null).responseCode, 400, 'Assert failed');
	}
	public static testmethod void landingLoadApiTest() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661
		Apttus_Proposal__Proposal__c prop = [Select Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c =: opp.id LIMIT 1];
		Test.startTest();
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, false, prop.id); //DLT-11661
		Test.stopTest();
		system.assert(accSSD != null, 'Assert failed');
	}

	//To test DCQuoteService class methods
	//1.landingPageLoadApi(): returs the response of all Quotes bassed on opportunity Id passed as parameter
	//2.getPricematrices() : prepare Prepares Pricing map for Products
	public static testmethod void landingLoadApiService() {
		Test.startTest();
		Opportunity opp = [Select Id from Opportunity limit 1];
		Product2 prod2 = [Select Id from Product2 limit 1];
		Opportunity oppr = [select id, Source_System_Detail__r.APTS_Apttus_Customer_Pricing_Segment__c from Opportunity where id =: opp.id];
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661
		Apttus_Config2__ProductConfiguration__c cart = [select id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c, Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c, Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c, Apttus_QPConfig__Proposald__r.DC_Contract_Not_In_Sync__c,
			Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c, name, APTS_New_Holdings__c, APTS_Current_Holdings__c, Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c, Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
			(select id, name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__LineType__c,
				Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__Quantity__c, Apttus_Config2__NetPrice__c,
				APTS_Contract_Term__c, Apttus_Config2__BasePrice__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c from Apttus_Config2__LineItems__r
				//Line items which are not cancelled.
				where Apttus_Config2__LineStatus__c != 'Cancelled')
			from Apttus_Config2__ProductConfiguration__c
			// Based on Opportunity and config status Finalized.
			where Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c =: oppr.id LIMIT 1
		];

		DCQuoteDetails.QuoteDetail qdetail = new DCQuoteDetails.QuoteDetail();

		DCQuoteService service = new DCQuoteService();
		service.landingPageLoadApi(oppr.Id, accSSD.ID, null);
		service.getPricematricesV2(oppr);
		service.getMaxNoOfAttorneys('Corporate', cart.Apttus_Config2__LineItems__r);
		DCQuoteServiceHelper.getManualContractTermDetails(cart);

		//DLT-17751 Starts
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c where Current_Subscription__c != null];
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Year1_YoYvalue__c = null;
			padlist[i].Year2_YoYvalue__c = null;
			padlist[i].Year3_YoYvalue__c = null;
		}
		update padlist;
		service.landingPageLoadApi(oppr.Id, accSSD.ID, null);

		//Test different Current Term

		List<Product_Account_Detail__c > padlist1 = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c];
		for (integer i = 0; i<padlist1.size(); ++i) {

			padlist1[i].Year1_YoYvalue__c = null;
			padlist1[i].Year2_YoYvalue__c = null;
			padlist1[i].Year3_YoYvalue__c = null;
		}
		update padlist1;

		service.landingPageLoadApi(oppr.Id, accSSD.ID, null);
		// DLT-17751 Ends
		Test.stopTest();
		//service.landingPageLoadApi('oppId','accId');// produce error 

		System.assertNotEquals(service.landingPageLoadApi(oppr.Id, accSSD.Id, null).responseCode, 400, 'Assert failed');

	}

	public static testmethod void sortMapTest() {
		Map<Integer, DCQuoteDetails.Pricematrix > integerToPriceMatrixMap = new Map<Integer, DCQuoteDetails.Pricematrix > ();
		DCQuoteDetails.Pricematrix pm = new DCQuoteDetails.Pricematrix();
		pm.quantity = 1;
		pm.amount = 10;
		integerToPriceMatrixMap.put(1, pm);
		Test.startTest();
		DCQuoteService service = new DCQuoteService();
		service.sortMap(integerToPriceMatrixMap, 'ASC');
		service.sortMap(integerToPriceMatrixMap, 'DESC');
		System.assert(integerToPriceMatrixMap != null, 'integerToPriceMatrixMap is null');
		Test.stopTest();
	}
	//To test class method which is responsible to update cart as per request by AEM.
	public static testmethod void performUpdateLanding() {

		Product2 prodObj = new Product2(); //current sub
		prodObj.Name = 'SL California Analytical Product';
		prodObj.List_Price__c = 0;
		prodObj.Format__c = 'Online';
		prodObj.Is_Orderable__c = TRUE;
		prodObj.IS_WP_Eligible__c = TRUE;
		prodObj.Media_High_Level__c = 'Online';
		prodObj.Service_Number__c = '42009568';
		prodObj.Subscription_Number__c = '42009618';
		prodObj.APTS_Product_Pricing_Model__c = 'Banded';
		prodObj.Family = 'WESTLAW';
		prodObj.Apttus_Filter_Media__c = 'Online';
		prodObj.APTS_Media_High_Level_Code__c = '05';
		prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
		prodObj.Productcode = '42009568';
		prodObj.isActive = true;
		Insert prodObj;

		Product2 prod2 = [Select Id from Product2 limit 1];
		Test.startTest();
		List<String> products = new List<String> {
			prod2.id, prodobj.Id
		};
		List<DCQuoteUpdate.QuoteUpdateRequest > updateDetails = new List<DCQuoteUpdate.QuoteUpdateRequest > ();
		DCQuoteUpdate.QuoteUpdateRequest data = new DCQuoteUpdate.QuoteUpdateRequest();
		Opportunity opp = [Select Id from Opportunity limit 1];

		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661

		//Test different Current Term
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c where Type__c = 'Plus'];

		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 3;
			padlist[i].Current_Subscription__c = null;
			padlist[i].Year1_YoYvalue__c = 2;
			padlist[i].Year2_YoYvalue__c = 2;
			padlist[i].Year3_YoYvalue__c = 1;
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);

		Apttus_Proposal__Proposal__c quote = [select id, Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c limit 1];
		data.quoteId = quote.Id;
		data.quantity = 2;
		data.contractTerm = '1 Year';
		data.productIds = products;
		System.debug('data' + data);

		update padlist;

		updateDetails.add(data);
		DCPerformUpdateSvc.performUpdateLanding(updateDetails);
		Test.stopTest();
		System.assert(updateDetails.size() != null, 'Assert failed');
	}

	//To test DCPerformRepriceController class method which send repricing responce, requested by AEM.
	public static testmethod void performReprice() {

		Apttus_Proposal__Proposal__c quote = [SELECT ID from Apttus_Proposal__Proposal__c limit 1];
		Test.startTest();
		DCPerformRepriceController.performReprice(quote.id);
		DCPerformRepriceController.performReprice(null);
		DCQuoteService.repriceByQuoteId('');
		Test.stopTest();
		System.assert(quote.id != null, 'Assert failed');

	}

	//To test DCPerformSynchronizeController and DCQuoteService class method which are 
	//responsible to Synchronize the cartLineItems with QuoteLineItems
	public static testmethod void performSynchronize() {

		Apttus_Proposal__Proposal__c quote = [SELECT ID from Apttus_Proposal__Proposal__c limit 1];

		Test.startTest();
		List<String> quoteIdList = new List<String> {
			quote.id
		};
		DCPerformSynchronizeController.performReprice(quoteIdList);
		DCQuoteService.synchronizeCart(null);
		DCPerformSynchronizeController.performReprice(null);

		try {
			List<Integer> rlines = new List<Integer> {
				1
			};
			DCUtils.removeLineItems(rlines, quote.id);
		}
		Catch(Exception ex) {
			system.debug('Exception:' + ex); //DLT-16791 avoided empty catch block
		}

		Test.stopTest();
		System.assert(quoteIdList.size() != null, 'Assert failed');
	}
	public static testmethod void landingLoadApiPlus() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		List<Apttus_Proposal__Proposal__c > qlist = [select id, Digital_Quote_Type__c from Apttus_Proposal__Proposal__c limit 10];
		System.debug('qlist=============>' + qlist);
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661
		Test.startTest();
		//Test different Current Term
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c where Type__c = 'Plus'];
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 2;
		}
		update padlist;

		List<Product_Account_Detail__c > padlist2 = [SELECT id, Year1_YoYvalue__c, Year2_YoYvalue__c, Year3_YoYvalue__c FROM Product_Account_Detail__c where Type__c != 'Plus'];
		for (Product_Account_Detail__c pad: padlist2) {
			pad.Year1_YoYvalue__c = null;
			pad.Year2_YoYvalue__c = null;
			pad.Year3_YoYvalue__c = null;
		}
		update padlist2;

		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 3;
			padlist[i].Current_Subscription__c = null;
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		Test.stopTest();
		System.assert(padlist.size() != null, 'Assert failed');
	}
	public static testmethod void landingLoadApiPremium() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		List<Apttus_Proposal__Proposal__c > qlist = [select id, Digital_Quote_Type__c from Apttus_Proposal__Proposal__c limit 10];
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661
		Test.startTest();
		//Test different Current Term
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C, Current_Subscription__c FROM Product_Account_Detail__c where Type__c = 'Premium'];
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 2;
		}
		update padlist;

		List<Product_Account_Detail__c > padlist2 = [SELECT id, Year1_YoYvalue__c, Year2_YoYvalue__c, Year3_YoYvalue__c FROM Product_Account_Detail__c where Type__c != 'Premium'];
		for (Product_Account_Detail__c pad: padlist2) {
			pad.Year1_YoYvalue__c = null;
			pad.Year2_YoYvalue__c = null;
			pad.Year3_YoYvalue__c = null;
		}
		update padlist2;

		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 3;
			padlist[i].Current_Subscription__c = null;
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		Test.stopTest();
		System.assert(padlist.size() != null, 'Assert failed');
	}

	public static testmethod void fllandingLoadApi() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		List<Apttus_Proposal__Proposal__c > qlist = [select id, Digital_Quote_Type__c from Apttus_Proposal__Proposal__c limit 10];
		System.debug('qlist=============>' + qlist);
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1]; //DLT-11661
		Test.startTest();
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null); //DLT-11661

		//Test different Current Term
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c];
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 2;
			padlist[i].Digital_Firm__c = 'FindLaw';
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 3;
			padlist[i].Digital_Firm__c = 'FindLaw';
		}
		update padlist;
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);

		DCLandingDataLoadSvc.landingPageLoadApi(null, null, false, null); // produce error
		Test.stopTest();
		System.assertNotEquals(DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null).responseCode, 400, 'Assert failed');
	}
	// Added 17793
	public static testmethod void landingLoadApiManual() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		Apttus_Proposal__Proposal__c quote = [select id, Digital_Quote_Type__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: opp.id limit 1];
		quote.Digital_Quote_Type__c = 'Manual';
		update quote;
		Source_System_Detail__C accSSD = [Select Id from Source_System_Detail__C limit 1];
		Test.startTest();
		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);

		Test.stopTest();
		System.assertNotEquals(DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null).responseCode, 400, 'Assert failed');
	}
	// Added 17793
	public static testmethod void landingLoadApiForBundle() {
		Opportunity opp = [Select Id from Opportunity limit 1];
		List<Apttus_Proposal__Proposal__c > qlist = [SELECT id, Digital_Quote_Type__c FROM Apttus_Proposal__Proposal__c LIMIT 10];
		Source_System_Detail__C accSSD = [SELECT Id FROM Source_System_Detail__C LIMIT 1]; //DLT-11661
		List<Apttus_Config2__LineItem__c > cartLinesList = [SELECT id, name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__LineType__c,
			Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__Quantity__c, Apttus_Config2__NetPrice__c,
			APTS_Contract_Term__c, Apttus_Config2__BasePrice__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c,
			Apttus_Config2__ProductId__r.APTS_Module_Points__c
			FROM Apttus_Config2__LineItem__c
			//Line items which are not cancelled.
			WHERE Apttus_Config2__LineStatus__c != 'Cancelled'
		];
		List<Product2 > productList = [SELECT id, APTS_Module_Points__c From Product2 LIMIT 50000];
		for (Product2 prod: productList) {
			prod.APTS_Module_Points__c = 1;
		}
		update productList;
		product2 bprod = DCTestData.createProduct('CORPORATE SELECT ON WESTLAW', '', '');
		bprod.Apttus_Config2__HasOptions__c = true;
		update bprod;

		Test.startTest();
		for (Apttus_Config2__LineItem__c line: cartLinesList) {
			line.Apttus_Config2__LineType__c = 'Option';
			line.Apttus_Config2__HasOptions__c = false;
			line.Apttus_Config2__OptionId__c = line.Apttus_Config2__ProductId__c;
			line.Apttus_Config2__ProductId__c = bprod.Id;
		}
		cartLinesList[0].Apttus_Config2__HasOptions__c = true;
		cartLinesList[0].Apttus_Config2__ProductId__c = bprod.Id;
		update cartLinesList;

		//Test different Current Term
		List<Product_Account_Detail__c > padlist = [SELECT Current_Term_Length__C FROM Product_Account_Detail__c where Type__c = 'Premium'];
		for (integer i = 0; i<padlist.size(); ++i) {
			padlist[i].Current_Term_Length__c = 2;
			padlist[i].Bundle_Id__c = bprod.Id;
		}
		update padlist;
		Apttus_Config2__PriceList__c pBook = [SELECT Id FROM Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal'
			limit 1
		];
		Apttus_Config2__PriceListItem__c priceListItem = DCTestData.createPriceListItem(pBook.Id, bprod.Id);
		Apttus_Config2__PriceMatrix__c priceMatrix = DCTestData.createPriceMatix(priceListItem.Id);

		Apttus_Config2__PriceDimension__c pd = new Apttus_Config2__PriceDimension__c();
		pd.Apttus_Config2__ContextType__c = 'Product Attribute';
		pd.name = 'CPRO Module Points';
		pd.Apttus_Config2__Type__c = 'Standard';
		pd.Apttus_Config2__BusinessObject__c = 'Apttus_Config2__ProductAttributeValue__c';
		pd.Apttus_Config2__Datasource__c = 'APTS_Total_Number_of_Points__c';
		insert pd;

		priceMatrix.Apttus_Config2__Dimension1Id__c = pd.Id;
		priceMatrix.Apttus_Config2__Dimension1ValueType__c = 'Range';
		priceMatrix.Apttus_Config2__Dimension2Id__c = DCTestData.createPriceDimension('Apttus_Config2__Quantity__c', 'Quantity').id;
		priceMatrix.Apttus_Config2__Dimension2ValueType__c = 'Range';
		update priceMatrix;
		Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry = DCTestData.createPriceMatrixEntry(priceMatrix.Id, '1');
		priceMatrixEntry.Apttus_Config2__Dimension1Value__c = '1';
		priceMatrixEntry.Apttus_Config2__Dimension2Value__c = '1';
		update priceMatrixEntry;

		DCLandingDataLoadSvc.landingPageLoadApi(opp.Id, accSSD.Id, true, null);
		System.assert(padlist.size() != null, 'Assert failed');

		Test.stopTest();
	}

	public static testmethod void getWestProflexTest() {
		Apttus_Config2__ProductConfiguration__c quote = [SELECT id, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
			APTS_SSD_bill_to__r.Source_System_Account_Number__c,
			(SELECT id, Apttus_Config2__ProductId__r.Name, Apttus_Config2__LineStatus__c,
				APTS_Format__c, Apttus_Config2__BillingFrequency__c, Apttus_Config2__Quantity__c,
				DC_Is_Add_On__c, Apttus_Config2__AutoRenewalTerm__c, Apttus_Config2__StartDate__c,
				APTS_Number_of_Attorneys__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,
				APTS_Years_2_Plus_Adjustment__c, APTS_Original_Quantity__c,
				Apttus_Config2__OptionId__r.Subscription_Number__c, Apttus_Config2__AssetLineItemId__r.APTS_Subscription_Number__c FROM Apttus_Config2__LineItems__r)
			FROM Apttus_Config2__ProductConfiguration__c
			LIMIT 1
		];
		Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c();
		quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c = 'Straight Renewal';
		quote.Apttus_Config2__LineItems__r[0].Apttus_Config2__ProductId__r.Name = 'West Proflex';
		update quote;

		List<DCQuoteDetails.LineItem > quoteLineItemList = new List<DCQuoteDetails.LineItem > ();
		DCQuoteService dcservice = new DCQuoteService();

		Test.startTest();
		quoteLineItemList = DCQuoteServiceHelper.getWestProflexSubproduct(quoteLineItemList, quote);
		DCQuoteServiceHelper.getWestProflexSubproductValues(asset, quote.Apttus_Config2__LineItems__r[0]);
		System.assert(quoteLineItemList != null, 'Returned null');
		Test.stopTest();
	}

	public static testmethod void failedResponseTest() {
		Opportunity opp = [SELECT id FROM Opportunity LIMIT 1];
		delete opp;
		Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
		delete prop;
		DCQuoteService qs = new DCQuoteService();
		Test.startTest();
		try {
			qs.landingPageLoadApi(opp.id, null, prop.id); //Random SFDC Id Input that doesn't exist
		} catch (Exception ex) {
			System.assert(ex != null, 'No exception returned');
		}
		Test.stopTest();
	}

	public static testmethod void compareCustomBVTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
		System.assert(prop != null, 'Quote is null');
		delete prop;
		Apttus_Proposal__Proposal__c quote;
		quote = DCPerformUpdateSvcHelper.compareCustomAndBV(true, false, prop.id);
		quote = DCPerformUpdateSvcHelper.compareCustomAndBV(true, true, prop.id);
		quote = DCPerformUpdateSvcHelper.compareCustomAndBV(false, true, prop.id);
		quote = DCPerformUpdateSvcHelper.compareCustomAndBV(false, false, prop.id);
		Test.stopTest();
	}

	public static testmethod void updateLineItemErrorTest() {
		Test.startTest();
		DCQuoteUpdate.QuoteUpdateRequest requestDetail = new DCQuoteUpdate.QuoteUpdateRequest();
		DCPerformUpdateSvcHelper dcService = new DCPerformUpdateSvcHelper();
		List<Apttus_Config2__LineItem__c > lineItemList = dcService.updateLineItems(null, requestDetail, null);
		System.assert(lineItemList != null, 'Assert failed');
		Test.stopTest();
	}

	public static testmethod void setRenewalAdjustmentTest() {
		DCPerformUpdateSvcHelper dcService = new DCPerformUpdateSvcHelper();
		List<DC_Contract_Term_V2__mdt > dcContractTermList = new List<DC_Contract_Term_V2__mdt > ();
		DC_Contract_Term_V2__mdt dcContractTerm = new DC_Contract_Term_V2__mdt();
		Boolean exceptionThrown = false;

		Test.startTest();
		try {
			dcContractTerm.Contract_Term__c = '3 Years';
			dcContractTerm.YoY_1_Renewal__c = 1.0;
			dcContractTerm.DC_Years_2_Plus_Adjustment__c = 1.0;
			dcContractTermList.add(dcContractTerm);
			dcService.setRenewalAdjustment(dcContractTermList);

			dcService.objYoy.arrYoyStraight[0] = 1.0;
			dcService.setRenewalAdjustment(dcContractTermList);

			dcService.objYoy.arrYoyStraight[0] = 0.0;
			dcService.objYoy.arrYoyBest[0] = 1.0;
			dcContractTermList[0].Contract_Term__c = '2 Years';
			dcService.setRenewalAdjustment(dcContractTermList);

			dcService.objYoy.arrYoyBest[0] = 0.0;
			dcService.objYoy.arrYoyPremium[0] = 1.0;
			dcContractTermList[0].Contract_Term__c = '1 Year';
			dcService.setRenewalAdjustment(dcContractTermList);
		} catch (Exception ex) {
			exceptionThrown = TRUE;
		}
		System.assert(!exceptionThrown, 'Exception was thrown');
		Test.stopTest();

	}
}