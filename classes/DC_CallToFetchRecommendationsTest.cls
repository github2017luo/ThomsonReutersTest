/*============================================================================================
    Name                : DC_CallToFetchRecommendationsTest
    Description         : This class is developed as part of CXD-Renewal project. This class acts as test class for both classes-Digital_RecommendationsController and DC_CallToFetchRecommendations.
    Created Date        : 03/06/2019
    Created by          : Navleen Kaur
    History: 
    Date           Name                    Description   
    03/06/2019     Navleen Kaur            DLT-14147 : SLF][SFDC] Expose Small Law Recommendations to Sales Channel
    03/26/2019     Navleen Kaur            DLT-15710 : Expose Small Law Recommendations to Sales Channel - Integrate ESI Service
    06/06/2019     Navleen Kaur            DLT-16785 : [Tech Story] [Code Scan] - Fix code scan CRITICAL and Major issues in this DC_CallToFetchRecommendations.cls
    12/16/2019     Srikanth Kota           DLT-18845 : [Ren] Replace frozen market segment with market segment level1 and level 2 values
    23-07-2020      Rahul Natarajan         DLT-20035        Remove Segmentation Field References from CX Digital components.
    18/12/2020      Rahul Natarajan        DLT-20992 :  PI - Recommendation Link is not working properly When SAP account number is null //
===============================================================================================*/
@isTest
public class DC_CallToFetchRecommendationsTest {
	@testsetup
	public static void testdata() {
		Test.startTest();
		WebServiceSettings__c web = new WebServiceSettings__c();
		web.Endpoint__c = 'test.endpoint';
		web.Name = 'CXDRecommendationService';
		web.Username__c = 'test.user';
		web.Password__c = 'test:123';
		web.Service_Unavailable_Message__c = 'testservice';

		insert web;

		List<WebServiceSettings__c > webserviceList = new List<WebServiceSettings__c > {
			new WebServiceSettings__c(Name = 'EnterpriseWSDL', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
			new WebServiceSettings__c(Name = 'StatusPostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
			new WebServiceSettings__c(Name = 'PostbackLocation', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available'),
			new WebServiceSettings__c(Name = 'Payment AutoCharge', Endpoint__c = 'https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c = 'Service not Available')
		};
		insert webserviceList;

		// Commented out Segmentation fields DLT-20035 
		Account acc = new Account();
		acc.Name = 'Test Account';
		//   acc.FrozenMarketSegment__c = 'Solo Law Firm';
		acc.SAPAccountNumber__c = '1004284494';
		//  acc.Customer_Group__c = 'FIRM';
		acc.APTS_Band_Number__c = 1;
		acc.APTS_Customer_Category__c = '3';
		acc.APTS_eOutput_Eligibilty__c = '';
		insert acc;
		Test.stopTest();

		Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
		Source_System_Detail__c accountSSD = new Source_System_Detail__c();
		accountSSD.RecordtypeId = ssdRecorType;
		accountSSD.Name = 'ABC';
		accountSSD.Source_System_Name__c = 'ABC';
		accountSSD.Account_Name__c = acc.ID;
		accountSSD.Account_Inactive__c = false;
		accountSSD.Source_System_Account_Number__c = acc.SAPAccountNumber__c;
		accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
		accountSSD.BU_Segment__c = 'Professional Legal'; //DLT-18845
		accountSSD.BU_Segment_Level_2__c = 'Small Law'; //DLT-18845
		accountSSD.LCRM_SAP_Account_Number__c = '1004284494';
		accountSSD.LCRM_APTS_Band_Number__c = 1;
		accountSSD.APTS_Customer_Category__c = '3';
		accountSSD.LCRM_Credit_Exposure__c = 162.30;
		accountSSD.LCRM_Credit_Limit_Used__c = 8.00;
		accountSSD.LCRM_eOutput_Eligibility__c = '';
		accountSSD.LCRM_Sales_Org__c = 'WEST';
		accountSSD.State__c = 'California';
		accountSSD.LCRM_Customer_Group__c = 'FIRM';
		insert accountSSD;

		list<Apttus_Config2__AssetLineItem__c > aliList = new list<Apttus_Config2__AssetLineItem__c > ();
		Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
		ali.Name = 'Essentials Library — Florida (Westlaw PRO™)1';
		ali.Apttus_Config2__Quantity__c = 1;
		ali.Apttus_Config2__Description__c = 'Test';
		ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
		ali.Apttus_Config2__PricingDate__c = System.Today();
		ali.Apttus_Config2__IsPrimaryLine__c = TRUE;
		ali.Apttus_Config2__AssetStatus__c = 'Activated';
		ali.Apttus_Config2__LineType__c = 'Product/Service';
		ali.Apttus_Config2__LineNumber__c = 1;
		ali.Apttus_Config2__ItemSequence__c = 1;
		//ali.Apttus_Config2__ProductId__c = prodObj.id;
		ali.Apttus_Config2__BillToAccountId__c = acc.id;
		ali.Apttus_Config2__AccountId__c = acc.id;
		ali.Apttus_Config2__ShipToAccountId__c = acc.id;
		ali.Apttus_Config2__ChargeType__c = 'Subscription Fee';
		ali.APTS_Contract_Term__c = '3 Years';
		ali.APTS_YoY_Adjustment_Type__c = 'Increase';
		// ali.Apttus_Config2__PriceListId__c = priceList.id;
		ali.APTS_Subscription_Number__c = '0974107';
		ali.APTS_Info_RenewalDate__c = System.Today();
		ali.Apttus_Config2__RenewalDate__c = System.Today();
		ali.APTS_Info_PlanType__c = 'R03';
		ali.Apttus_Config2__SellingFrequency__c = 'Monthly';
		ali.Apttus_Config2__SellingTerm__c = 1;
		ali.Apttus_Config2__NetPrice__c = 163;
		ali.Apttus_Config2__ListPrice__c = 207;
		// ali.Apttus_QPConfig__ProposalId__c = stproposal.id;
		ali.APTS_SSD_Bill_To__c = accountSSD.Id;
		ali.APTS_SSD_Ship_to__c = accountSSD.Id;
		ali.APTS_SSD_Sold_To__c = accountSSD.Id;
		aliList.add(ali);

		insert aliList;
	}

	public static testMethod void invokeESIDetailsTest() {
		Test.startTest();
		Source_System_Detail__c ssd = [select id, Source_System_Account_Number__c from Source_System_Detail__c limit 1];
		DCRecommendationDetailsResponse res = DC_CallToFetchRecommendations.invokeESIDetails(ssd.Source_System_Account_Number__c);
		system.assertNotEquals(res, null,'Expected Value');
		Test.stopTest();
	}
	public static testMethod void invokeESIDetailsNegativeTest() {
		WebServiceSettings__c web = [select id, name from WebServiceSettings__c limit 1];
		web.Name = 'Service';
		update web;
		Test.startTest();
		Source_System_Detail__c ssd = [select id, Source_System_Account_Number__c from Source_System_Detail__c limit 1];
		DCRecommendationDetailsResponse res = new DCRecommendationDetailsResponse();
		res = DC_CallToFetchRecommendations.invokeESIDetails(ssd.Source_System_Account_Number__c);
		system.assertNotEquals(res, null,'Expected Value');
		Test.stopTest();
	}

	public static testMethod void digitalrecommendationsControllerTest() {
		Account acc = [Select SAPAccountNumber__c, id from Account limit 1];
		//DLT-18845
		Source_System_Detail__c ssd = [Select id, Source_System_Account_Number__c, APTS_Customer_Category__c, LCRM_Credit_Limit_Used__c, LCRM_Credit_Exposure__c, LCRM_Frozen_Market_Segment__c, BU_Segment__c, BU_Segment_Level_2__c FROM Source_System_Detail__c limit 1];
		ApexPages.currentPage().getParameters().put('Id', acc.id);
		Apexpages.currentpage().getparameters().put('selectedVal', ssd.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(acc);
		Test.startTest();
		Digital_RecommendationsController test1 = new Digital_RecommendationsController(sc);
		List<Digital_RecommendationsController.ExistingMaterials > extMat = test1.getExistingMaterials();
		List<Digital_RecommendationsController.RecommandedMaterials > recMat = test1.getRecommandedMaterials();
		test1.updatePage();
        Test.stopTest();
        Boolean result=true;
        if(ssd==null){
            result=false;
        }
		system.assertNotEquals(result, false,'Expected Value');
	}
}