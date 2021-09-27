/*============================================================================================
    Name                : Digital_RecommendationsController
    Description         : This class is developed as part of CXD-Renewal project. This class acts as extension for the VF page 'Digital_RecommendationsDetails'
    Created Date        : 02/28/2019
    Created by          : Navleen Kaur
    History: 
    Date           Name                    Description   
    02/28/2019     Navleen Kaur            DLT-14147 : SLF][SFDC] Expose Small Law Recommendations to Sales Channel
    03/26/2019     Navleen Kaur            DLT-15710 : Expose Small Law Recommendations to Sales Channel - Integrate ESI Service 
    05/06/2019     Navleen Kaur            DLT-16425 : Analytics Product Recommendation Ancillary Amount Data Type Change at SFDC
    05/29/2019     Navleen Kaur            DLT-16590 : Added ApexPages.SEVERITY.Info
    09/24/2019     Harika Sai P            DLT-17687 : INC2521439_No results on the recommendation link for the account   
    12/16/2019     Srikanth Kota           DLT-18845 : [Ren] Replace frozen market segment with market segment level1 and level 2 values
    18/12/2020      Rahul Natarajan        DLT-20992 :  PI - Recommendation Link is not working properly When SAP account number is null //
======================================================================================
=========*/

// declared as global because implementing comparable class
public with sharing class Digital_RecommendationsController {
	public Source_System_Detail__c sourceSysDetail {
		get;
		set;
	}
	public String accId {
		get;
		set;
	}

	public Integer customerNumber {
		get;
		set;
	}
	public Integer renewalDate {
		get;
		set;
	}
	public String customerName {
		get;
		set;
	}
	public String marketSegment {
		get;
		set;
	}
	public String currContractTerm {
		get;
		set;
	}
	public String alreadySimplified {
		get;
		set;
	}
	public Decimal currentMCV {
		get;
		set;
	}
	public Decimal estimatedDiscount {
		get;
		set;
	}
	public String customerCategory {
		get;
		set;
	}
	public Decimal creditLimitUsed {
		get;
		set;
	}
	public Decimal creditExposure {
		get;
		set;
	}
	public String upsellLevel {
		get;
		set;
	}
	public Integer attorneyCount {
		get;
		set;
	}
	public String recommendationCreatedDate {
		get;
		set;
	}
	public String usageProfile {
		get;
		set;
	}
	public List<ExistingMaterials> existingMaterials {
		get;
		set;
	}
	public List<RecommandedMaterials> recommandedMaterials {
		get;
		set;
	}
	DCRecommendationDetailsResponse.CustomerDetails custDetails {
		get;
		set;
	}
	DCRecommendationDetailsResponse esiResp {
		get;
		set;
	}
	public Account listOfAccounts {
		get;
		set;
	}
	public String selectedSSDId {
		get;
		set;
	}
	public String selectedSSDId1 {
		get;
		set;
	}
	public List<SelectOption> ssdNames {
		get;
		set;
	}
	public Boolean displayComponent {
		get;
		set;
	}
	public boolean errormsg {
		get;
		set;
	}
    private List<Source_System_Detail__c> ssdList {
		get;
		set;
    }
    
    //DLT-20992 
    private void digitalrecommendationsControllerConstructorHelper(){
        displayComponent = False;
        errormsg = false;
        selectedSSDId=null;
        esiResp=new DCRecommendationDetailsResponse();
        accId = ApexPages.currentPage().getParameters().get('Id');
        listOfAccounts = [Select Id, ParentId, SAPAccountNumber__c, (Select id, name, Source_System_Account_Number__c, APTS_Customer_Category__c, LCRM_Credit_Limit_Used__c, LCRM_Credit_Exposure__c, LCRM_Frozen_Market_Segment__c, BU_Segment__c, BU_Segment_Level_2__c FROM Source_System_Details__r where Source_System_Account_Number__c!=null) FROM Account WHERE Id =: accId WITH SECURITY_ENFORCED];
        //DLT-20992
        if(!listOfAccounts.Source_System_Details__r.isEmpty()){
            selectedSSDId = listOfAccounts.Source_System_Details__r[0].id;
        }
		
		if (listOfAccounts.Source_System_Details__r.size() > 1) {
			displayComponent = True;
        }
        if (Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
			//DLT-18845
			ssdList= [Select id, Source_System_Account_Number__c, APTS_Customer_Category__c, LCRM_Credit_Limit_Used__c, LCRM_Credit_Exposure__c, LCRM_Frozen_Market_Segment__c, BU_Segment__c, BU_Segment_Level_2__c FROM Source_System_Detail__c WHERE Id =: selectedSSDId and Source_System_Account_Number__c!=null];
        }
        //DLT-20992
        if(!ssdList.isEmpty()){
            sourceSysDetail=ssdList[0];
        }
        try {
			system.debug('check2-->');
			existingMaterials = new List<ExistingMaterials> ();
            recommandedMaterials = new List<recommandedMaterials> ();
            //DLT-20992
            if(!ssdList.isEmpty()){
                esiResp = DC_CallToFetchRecommendations.invokeESIDetails(sourceSysDetail.Source_System_Account_Number__c);
            }
			system.debug('ESI Response:' + esiResp);
			if (esiResp.customerDetails == null&&!ssdList.isEmpty()) {
				errormsg = true;
				Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, +System.Label.Digital_noMaterials));
			}else if(ssdList.isEmpty()){
                errormsg = true;
				Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, +System.Label.Digital_noCustomer));
            }else {
				assigningValues(esiResp);
				existingMaterials = getExistingMaterials();
				recommandedMaterials = getRecommandedMaterials();
			}
			ssdNames = getSSDNames();
		} catch (exception e) {
			errormsg = true;
			system.debug('@@@ inside contr');
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
		}
    }
	// Constructor for the class 
	public Digital_RecommendationsController(ApexPages.StandardController controller) {
        digitalrecommendationsControllerConstructorHelper();
	}

	//calling this method on Click of show button which will come when there is more tham one SSD associated with account
	public void updatePage() {
		errormsg = false; //DLT-17687
		string selectedSSDId = apexpages.currentpage().getparameters().get('selectedVal').escapeHtml4();
		if (Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
			sourceSysDetail = [Select id, Source_System_Account_Number__c, APTS_Customer_Category__c, LCRM_Credit_Limit_Used__c, LCRM_Credit_Exposure__c, LCRM_Frozen_Market_Segment__c, BU_Segment__c, BU_Segment_Level_2__c FROM Source_System_Detail__c WHERE Id =: selectedSSDId];
		}
		// calling method of DC_CallToFetchRecommendations for details from ESI

		try {
			esiResp = DC_CallToFetchRecommendations.invokeESIDetails(sourceSysDetail.Source_System_Account_Number__c);
			system.debug('ESI Response::' + esiResp.customerDetails);
			if (esiResp.customerDetails == null) {
				errormsg = true;
				Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, +'There are no materials for the corresponding Customer'));
			} else {
				assigningValues(esiResp);
				existingMaterials = getExistingMaterials();
				recommandedMaterials = getRecommandedMaterials();
			}
		} catch (exception e) {
			system.debug('@@@ inside update');
			errormsg = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
		}

	}

	//assigning values from ESI response to fields
	public void assigningValues(DCRecommendationDetailsResponse esiResp) {
		try {
			custDetails = esiResp.customerDetails;
			customerNumber = custDetails.customerNumber;
			renewalDate = custDetails.renewalDate;
			customerName = custDetails.name;
			//from SFDC one
			//marketSegment = sourceSysDetail.LCRM_Frozen_Market_Segment__c;
			//DLT-18845 Updated 
			marketSegment = sourceSysDetail.BU_Segment__c + '-' + sourceSysDetail.BU_Segment_Level_2__c;
			currContractTerm = custDetails.currContractTerm;
			alreadySimplified = custDetails.alreadySimplified;
			currentMCV = custDetails.currentMCV;
			estimatedDiscount = calEstimatedDiscount(selectedSSDId);
			customerCategory = sourceSysDetail.APTS_Customer_Category__c;
			creditLimitUsed = sourceSysDetail.LCRM_Credit_Limit_Used__c;
			creditExposure = sourceSysDetail.LCRM_Credit_Exposure__c;
			upsellLevel = custDetails.upsellLevel;
			attorneyCount = custDetails.attorneyCount;
			recommendationCreatedDate = custDetails.lastUpdatedDate.substring(0, 10);
			usageProfile = custDetails.usageProfile;
		} catch (exception e) {
			system.debug('@@@ inside assign');
			errormsg = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
		}
	}

	// Used for showing customer number for particular account in dropdown list
	Public List<SelectOption> getSSDNames() {
        List<SelectOption> accOptions = new List<SelectOption> ();
        Boolean checkSapNumber=false;
        //DLT-20992
		for (Source_System_Detail__c ssd: listOfAccounts.Source_System_Details__r) {
            if(ssd.Source_System_Account_Number__c!=null){
                accOptions.add(new SelectOption(ssd.Id, ssd.Source_System_Account_Number__c));
                checkSapNumber=true;
            }
        }
        displayComponent=checkSapNumber;
		return accOptions;
	}

	// calculating discount by taking net price and list price from asset line items
	public Decimal calEstimatedDiscount(String ssdId) {
		Decimal listprice = 0.0;
		Decimal netprice = 0.0;
		Decimal discount = 0.0;
		list<Apttus_Config2__AssetLineItem__c > listOfAssets = new list<Apttus_Config2__AssetLineItem__c > ();
		if (Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
			listOfAssets = [Select id, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c from Apttus_Config2__AssetLineItem__c where APTS_SSD_Sold_To__c =: ssdId AND APTS_Info_RenewalDate__c != Null and Apttus_Config2__AssetStatus__c = 'Activated'
				AND APTS_Group_Primary_Material__c = Null
			];
		}
		system.debug('listOfAssets ' + listOfAssets);

		try {
			For(Apttus_Config2__AssetLineItem__c res: listOfAssets) {
				if (res.Apttus_Config2__ListPrice__c != null) {
					listprice = listprice + res.Apttus_Config2__ListPrice__c;
				}
				if (res.Apttus_Config2__NetPrice__c != null) {
					netprice = netprice + res.Apttus_Config2__NetPrice__c;
				}
			}
			//DLT-17687 added If condition to handle Divide by 0 error
			if (netprice != 0.0 && listprice != 0.0) {
				discount = (1 - (netprice / listprice)) * 100;
			}
			system.debug('discount netprice listprice:' + discount + ' ' + netprice + '' + listprice);

		} catch (exception e) {
			system.debug('@@@ inside discount');
			errormsg = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
		}
		return discount.round();
	}

	// Getting list for existing materials from ESI 
	public List<ExistingMaterials> getExistingMaterials() {
		List<ExistingMaterials> extMat = new List<ExistingMaterials> ();
		for (DCRecommendationDetailsResponse.ExistingMaterials ext: custDetails.existingMaterials) {
			extMat.add(new ExistingMaterials(ext.productTitle, ext.targetQty, ext.currentMaterialNum, ext.currentServiceNum, ext.bandPrice, ext.aggRectxt, ext.netTransactionCount));
		}
		extMat.sort();
		return extMat;
	}

	//Getting list for RecommandedMaterials from ESI
	public List<RecommandedMaterials> getRecommandedMaterials() {
		List<RecommandedMaterials> extMat = new List<RecommandedMaterials> ();
		for (DCRecommendationDetailsResponse.RecommandedMaterials ext: custDetails.recommandedMaterials) {
			extMat.add(new RecommandedMaterials(ext.productTitle, ext.targetQty, ext.rcmdSubsMaterialNumber, ext.rcmdServiceNumber, ext.bandPrice, ext.aggRectxt, ext.ancillaryAmount, ext.declinesCNT, ext.cmtFlag, ext.finalRank));
		}
		extMat.sort();
		return extMat;
	}

	//Wrapper class for existing materials
	public class ExistingMaterials implements Comparable {
		public String productTitle {
			get;
			set;
		}
		public Integer targetQty {
			get;
			set;
		}
		public Integer currentMaterialNum {
			get;
			set;
		}
		public String currentServiceNum {
			get;
			set;
		}
		public Decimal bandPrice {
			get;
			set;
		}
		public String aggRectxt {
			get;
			set;
		}
		public Integer netTransactionCount {
			get;
			set;
		}

		public ExistingMaterials(String prodTitle, Integer tarQty, Integer currMatNum, String currSerNum, Decimal bndPrice, String aggRctxt, Integer netTransacCount) {
			productTitle = prodTitle;
			targetQty = tarQty;
			currentMaterialNum = currMatNum;
			currentServiceNum = currSerNum;
			bandPrice = bndPrice;
			aggRectxt = aggRctxt;
			netTransactionCount = netTransacCount;
		}

		//method for sorting the existing materials by band price or retail price in descending order.
		public Integer compareTo(Object compareTo) {
			ExistingMaterials compareToEM = (ExistingMaterials) compareTo;
			// The return value of 0 indicates that both elements are equal.
			Integer returnValue = 0;
			if (bandPrice<compareToEM.bandPrice) {
				returnValue = 1;
			} else if (bandPrice > compareToEM.bandPrice) {
				returnValue = -1;
			}
			return returnValue;
		}

	}

	//Wrapper class for RecommandedMaterials 
	public class RecommandedMaterials implements Comparable {
		public String productTitle {
			get;
			set;
		}
		public Integer targetQty {
			get;
			set;
		}
		public String rcmdSubsMaterialNumber {
			get;
			set;
		}
		public String rcmdServiceNumber {
			get;
			set;
		}
		public Decimal bandPrice {
			get;
			set;
		}
		public String aggRectxt {
			get;
			set;
		}
		public Decimal ancillaryAmount {
			get;
			set;
		}
		public Integer declinesCNT {
			get;
			set;
		}
		public String cmtFlag {
			get;
			set;
		}
		public Integer rank {
			get;
			set;
		}

		public RecommandedMaterials(String prodTitle, Integer tarQty, String rcmdSubsMatNum, String rcmdServNum, Decimal bndPrice, String aggRctxt, Decimal ancilAmount, Integer declCNT, String cmtFlg, Integer rnk) {
			productTitle = prodTitle;
			targetQty = tarQty;
			rcmdSubsMaterialNumber = rcmdSubsMatNum;
			rcmdServiceNumber = rcmdServNum;
			bandPrice = bndPrice;
			aggRectxt = aggRctxt;
			ancillaryAmount = ancilAmount;
			declinesCNT = declCNT;
			cmtFlag = cmtFlg;
			rank = rnk;
		}

		//method for sorting the recommmanded materials by rank in ascending order.
		public Integer compareTo(Object compareTo) {
			RecommandedMaterials compareToRM = (RecommandedMaterials) compareTo;
			// The return value of 0 indicates that both elements are equal.
			Integer returnValue = 0;
			if (rank > compareToRM.rank) {
				returnValue = 1;
			} else if (rank<compareToRM.rank) {
				returnValue = -1;
			}
			return returnValue;
		}
	}
}