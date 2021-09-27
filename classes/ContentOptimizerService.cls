/**
 * Provides helper methods for interacting with the Content Optimizer web service
 *
 * @author  		John De Santiago
 * @version 		2011-12-05
 * @dependencies	AppUtil, WebServiceSettings__c, ContentOptimizerWS
 */
 
/**
 * CHANGE HISTORY
 * -------------------------------------------------------------------------------------------------------------------
 *	Date			Name				Description
 *	2011-12-05		John De Santiago	Created
 * -------------------------------------------------------------------------------------------------------------------
 */
public with sharing class ContentOptimizerService {
	//Constants
	public static final string WebServiceName = 'ContentOptimizerService';
	public static final string MockCalloutGetCustomer = 'GetCustomer';
	public static final string MockCalloutCalculateMatch = 'CalculateMatch';
	public static final string MockCalloutCalculatePlan = 'CalculatePlan';
	public static final string MockCalloutgetDatabases = 'getDatabases';
	public static final string SystemId = 'TEST';
 
	
	/**
	 * Retrieves customer info utilizing the content optimizer web service.
	 *
	 * @param	dSAPCustomerNumber	the SAP unique customer number
	 * @param	bIncludeNameAddress	indicates true to retrieve the address information
	 * @return	an instance of a ContentOptimizerService.CustomerInfo object
	 */
	public static CustomerInfo getCustomerInfo(decimal dSAPCustomerNumber, boolean bIncludeNameAddress) {
		CustomerInfo oCustomerInfo = new CustomerInfo();
		
		if (dSAPCustomerNumber != null) {
			WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

			ContentOptimizerServiceWS.ContentOptimizer_v1_0Port oService = new ContentOptimizerServiceWS.ContentOptimizer_v1_0Port();
			oService.inputHttpHeaders_x = new Map<String, String>();
			// oService.inputHttpHeaders_x<'Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='>;
			// oService.inputHttpHeaders_x['Authorization:'] = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='; 
			oService.endpoint_x = oWebServiceSettings.Endpoint__c;
			oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
			
			
			//  oService.inputHttpHeaders_x.put('Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
			Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
			string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
			oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
			oService.outputHttpHeaders_x = new Map<String,String>();
			
			
			ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
			if (Test.isRunningTest()) {
				//Get Mock Response
				object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetCustomer);
  
				if (oMockResponse instanceof ContentOptimizerServiceWS.Customer) {
					outputCustomer = (ContentOptimizerServiceWS.Customer) oMockResponse;
				}
			}
			else { 
				//Execute Web Service Callout
				outputCustomer = oService.getCustomer(SystemId, dSAPCustomerNumber, bIncludeNameAddress);
			}
			
			oCustomerInfo.parse(outputCustomer); 
		}
		else {
			throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
		}
		 
		return oCustomerInfo;
	}
	
		/**
	 * Retrieves match info utilizing the content optimizer web service. 
	 */

	public static MaterialPlanInfo getMaterialPlanInfo(ContentOptimizerService.CalculateMatchRequest oCalculateMatchRequest) {
		MaterialPlanInfo oMaterialPlanInfo = new MaterialPlanInfo();
		
		if (oCalculateMatchRequest.AcctSapId != null) {
			WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

			ContentOptimizerServiceWS.ContentOptimizer_v1_0Port oService = new ContentOptimizerServiceWS.ContentOptimizer_v1_0Port();
			oService.inputHttpHeaders_x = new Map<String, String>();
			// oService.inputHttpHeaders_x<'Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='>;
			// oService.inputHttpHeaders_x['Authorization:'] = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='; 
			oService.endpoint_x = oWebServiceSettings.Endpoint__c;
			oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
			
			
			//  oService.inputHttpHeaders_x.put('Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
			Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
			string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
			oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
			oService.outputHttpHeaders_x = new Map<String,String>();
			
			
			ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
			if (Test.isRunningTest()) {
				//Get Mock Response
				object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutCalculateMatch);
				
				if (oMockResponse instanceof ContentOptimizerServiceWS.MaterialContent) {
					outputMaterialContent = (ContentOptimizerServiceWS.MaterialContent) oMockResponse;
				}
			}
			else {
				//Execute Web Service Callout
				outputMaterialContent = oService.calculateMatch(SystemId, oCalculateMatchRequest.MatchType, oCalculateMatchRequest.AcctSapId, oCalculateMatchRequest.State, oCalculateMatchRequest.NumberOfMonths, oCalculateMatchRequest.IncludeAncillary, OcalculateMatchRequest.IncludeWsd);
			}
			
			oMaterialPlanInfo.parse(outputMaterialContent); 
			


	oMaterialPlanInfo.PrimaryMaterials = new List<ContentOptimizerService.MaterialItem>();
	if (outputMaterialContent.PrimaryMaterials == null) {
		
	}
	else {
		
	
	for (ContentOptimizerServiceWS.MaterialItem oMaterialPlanList : outputMaterialContent.PrimaryMaterials) {
		ContentOptimizerService.MaterialItem oMaterialItem = new ContentOptimizerService.MaterialItem();
		omaterialitem.MaterialDesc = '2';
			
			         omaterialitem.Rank = omaterialplanlist.Rank;
        omaterialitem.MaterialKey = omaterialplanlist.MaterialKey;
        omaterialitem.MaterialNumber = omaterialplanlist.MaterialNumber;
        omaterialitem.ListPrice = omaterialplanlist.ListPrice;
        omaterialitem.MatchCount = omaterialplanlist.MatchCount;
        omaterialitem.MatchPercent = omaterialplanlist.MatchPercent;
        omaterialitem.ExcessCount = omaterialplanlist.ExcessCount;
        omaterialitem.TotalNewDbs = omaterialplanlist.TotalNewDbs;
        omaterialitem.ExcessPercent = omaterialplanlist.ExcessPercent;
			 omaterialitem.materialDesc = omaterialplanlist.MaterialDesc;

			 oMaterialPlanInfo.PrimaryMaterials.add(oMaterialItem);
			
	}
		}
		oMaterialPlanInfo.PublicMaterials = new List<ContentOptimizerService.MaterialItem>();
			if (outputMaterialContent.PublicMaterials == null) {
		
	}
	else {
		
	for (ContentOptimizerServiceWS.MaterialItem oMaterialPlanList : outputMaterialContent.PublicMaterials) {
		ContentOptimizerService.MaterialItem oMaterialItem = new ContentOptimizerService.MaterialItem();
		
			
		omaterialitem.Rank = omaterialplanlist.Rank;
        omaterialitem.MaterialKey = omaterialplanlist.MaterialKey;
        omaterialitem.MaterialNumber = omaterialplanlist.MaterialNumber;
        omaterialitem.ListPrice = omaterialplanlist.ListPrice;
        omaterialitem.MatchCount = omaterialplanlist.MatchCount;
        omaterialitem.MatchPercent = omaterialplanlist.MatchPercent;
        omaterialitem.ExcessCount = omaterialplanlist.ExcessCount;
        omaterialitem.TotalNewDbs = omaterialplanlist.TotalNewDbs;
        omaterialitem.ExcessPercent = omaterialplanlist.ExcessPercent;
	 	omaterialitem.materialDesc = omaterialplanlist.MaterialDesc;


			 oMaterialPlanInfo.PublicMaterials.add(oMaterialItem);
	}		
	}
	oMaterialPlanInfo.OtherMaterials = new List<ContentOptimizerService.MaterialItem>();
	
			if (outputMaterialContent.OtherMaterials == null) {
		
	}
	else {
		for (ContentOptimizerServiceWS.MaterialItem oMaterialPlanList : outputMaterialContent.OtherMaterials) {
		ContentOptimizerService.MaterialItem oMaterialItem = new ContentOptimizerService.MaterialItem();
		
			
		omaterialitem.Rank = omaterialplanlist.Rank;
        omaterialitem.MaterialKey = omaterialplanlist.MaterialKey;
        omaterialitem.MaterialNumber = omaterialplanlist.MaterialNumber;
        omaterialitem.ListPrice = omaterialplanlist.ListPrice;
        omaterialitem.MatchCount = omaterialplanlist.MatchCount;
        omaterialitem.MatchPercent = omaterialplanlist.MatchPercent;
        omaterialitem.ExcessCount = omaterialplanlist.ExcessCount;
        omaterialitem.TotalNewDbs = omaterialplanlist.TotalNewDbs;
        omaterialitem.ExcessPercent = omaterialplanlist.ExcessPercent;
	 	omaterialitem.materialDesc = omaterialplanlist.MaterialDesc;


			 oMaterialPlanInfo.OtherMaterials.add(oMaterialItem);
			
	}
	}
				
		}
		else {
			throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
		}
	
		return oMaterialPlanInfo;
	}
	
	
	
	public static CalculatePlanInfo getCalculatePlanInfo(ContentOptimizerService.CalculatePlanRequest oCalculatePlanRequest) {
		CalculatePlanInfo oCalculatePlanInfo = new CalculatePlanInfo();
		
		
		if (oCalculatePlanRequest.AcctSapId != null) {
			WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

			ContentOptimizerServiceWS.ContentOptimizer_v1_0Port oService = new ContentOptimizerServiceWS.ContentOptimizer_v1_0Port();
			oService.inputHttpHeaders_x = new Map<String, String>();
			// oService.inputHttpHeaders_x<'Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='>;
			// oService.inputHttpHeaders_x['Authorization:'] = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='; 
			oService.endpoint_x = oWebServiceSettings.Endpoint__c;
			oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
			
			
			//  oService.inputHttpHeaders_x.put('Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
			Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
			string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
			oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
			oService.outputHttpHeaders_x = new Map<String,String>();
			
			
			ContentOptimizerServiceWS.PlanContent outputPlanContent = new ContentOptimizerServiceWS.PlanContent();
			if (Test.isRunningTest()) {
				//Get Mock Response
				object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutCalculatePlan);
				
				if (oMockResponse instanceof ContentOptimizerServiceWS.PlanContent) {
					outputPlanContent = (ContentOptimizerServiceWS.PlanContent) oMockResponse;
				}
			}
			else {
				//Execute Web Service Callout
	
				outputPlanContent = oService.calculatePlan(SystemId, oCalculatePlanRequest.MatchType, oCalculatePlanRequest.AcctSapId, oCalculatePlanRequest.NumberOfMonths, oCalculatePlanRequest.IncludeAncillary, OcalculatePlanRequest.IncludeWsd, OcalculatePlanRequest.MaterialKey);
			}
	
			oCalculatePlanInfo.parse(outputPlanContent); 
						
 
				
		}
		else {
			throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
		}
		
		return oCalculatePlanInfo;
	}	
	


//public static ContentOptimizerService.DatabaseItem GetDatabaseInfo(ContentOptimizerService.GetDatabaseRequest oGetDatabaseRequest) {
public static GetDatabaseInfo GetDatabaseInfo(ContentOptimizerService.GetDatabaseRequest oGetDatabaseRequest) {
		GetDatabaseInfo oGetDatabaseInfo = new GetDatabaseInfo();
		//ContentOptimizerService.DatabaseItem oGetDatabaseInfo = new ContentOptimizerService.DatabaseItem();
		
		// skg change here
		
		
		
		if (oGetDatabaseRequest.AcctSapId != null) {
			WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

			ContentOptimizerServiceWS.ContentOptimizer_v1_0Port oService = new ContentOptimizerServiceWS.ContentOptimizer_v1_0Port();
			oService.inputHttpHeaders_x = new Map<String, String>();
			// oService.inputHttpHeaders_x<'Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='>;
			// oService.inputHttpHeaders_x['Authorization:'] = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='; 
			oService.endpoint_x = oWebServiceSettings.Endpoint__c;
			oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
			
			
			//  oService.inputHttpHeaders_x.put('Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
			Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
			string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
			oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
			oService.outputHttpHeaders_x = new Map<String,String>();
			
			
			ContentOptimizerServiceWS.DatabaseContent outputDatabaseContent = new ContentOptimizerServiceWS.DatabaseContent();
			if (Test.isRunningTest()) {
				//Get Mock Response
				object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutgetDatabases);
				
				if (oMockResponse instanceof ContentOptimizerServiceWS.DatabaseContent) {
					outputDatabaseContent = (ContentOptimizerServiceWS.DatabaseContent) oMockResponse;
				}
			}
			else {
				//Execute Web Service Callout
					outputDatabaseContent = oService.getDatabases(SystemId, oGetDatabaseRequest.MatchType, oGetDatabaseRequest.DatabaseType, oGetDatabaseRequest.AcctSapId, oGetDatabaseRequest.NumberOfMonths, oGetDatabaseRequest.IncludeAncillary, oGetDatabaseRequest.IncludeWsd, oGetDatabaseRequest.MaterialKey);
			}
	
		oGetDatabaseInfo.parse(outputDatabaseContent); 
						
 	 ogetdatabaseInfo.DatabaseItem = new List<ContentOptimizerService.DatabaseItem>();
 	 
 	 if (outputDatabaseContent.databaseitem == null) {
 	 
 	 }
 	 else{
 	 	
 	 	// Skg outputDatabaseContent.databaseitem
 	 	//oDatabaseitem = new ContentOptimizerService.DatabaseItem();
 	 //	oGetDatabaseInfo.databaseitem = outputDatabaseContent.databaseitem; 
		for (ContentOptimizerServiceWS.DatabaseItem oDatabaseInfoList : outputDatabaseContent.databaseitem) {
		ContentOptimizerService.DatabaseItem oDatabaseItem = new ContentOptimizerService.DatabaseItem();
		
			
		oDatabaseItem.dbs = oDatabaseInfoList.dbs;
        oDatabaseItem.dbsdesc = oDatabaseInfoList.dbsdesc;
        oDatabaseItem.IsInPlan = oDatabaseInfoList.IsInPlan;
        oDatabaseItem.InPlanDBSTrans = oDatabaseInfoList.InPlanDBSTrans;
        oDatabaseItem.AncillaryDbsTrans = oDatabaseInfoList.AncillaryDbsTrans;
        oDatabaseItem.WsdDbsTrans = oDatabaseInfoList.WsdDbsTrans;


		ogetDatabaseInfo.DatabaseItem.add(oDatabaseItem);
		
		ogetDatabaseinfo.materialkey = outputdatabasecontent.materialkey;
		} 		 
	}
				
		}
		else {
			throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
		}
		
		return oGetDatabaseInfo;
	}	


	
	
		
	//Internal Classes
	
	/**
	 * Custom Exception thrown a web service callout fails
	 */
	public class ContentOptimizerServiceException extends Exception {}
	
	/**
	 * Data structure representing customer information
	 */
	public class CustomerInfo {
		//Properties
		public Decimal SAPCustomerNumber {get;set;}
		public Decimal ZwAcctSapId {get;set;}
        public String StreetName1 {get;set;}
        public String StreetName2 {get;set;}
        public String StreetName3 {get;set;}
        public String AddrLineDesc {get;set;}
        public String City {get;set;}
        public String State {get;set;}
        public String PostalCode {get;set;}
        public String POBox {get;set;}
        public String CountryCode {get;set;}
		
		//Static Methods
		public void parse(ContentOptimizerServiceWS.Customer oCustomer) {
			this.SAPCustomerNumber = oCustomer.AcctSapId;
			this.ZwAcctSapId = oCustomer.ZwAcctSapId;
			this.StreetName1 = oCustomer.NameLineDesc_1;
			this.StreetName2 = oCustomer.NameLineDesc_2;
			this.StreetName3 = oCustomer.NameLineDesc_3;
			this.AddrLineDesc = oCustomer.AddrLineDesc;
			this.City = oCustomer.AddrCity;
			this.State = oCustomer.AddrStateCode;
			this.PostalCode = oCustomer.AddrZip;
			this.POBox = oCustomer.AddrPoBox;
			this.CountryCode = oCustomer.AddrCountryCode;
		}
	}
		public class CustomerRequest  
	{
        //public string SystemId {get;set;}
        public decimal AcctSapId {get;set;}
        public boolean IncludeNameAddress {get;set;}
	}
	
			public class CalculateMatchRequest  
	{
     	//public string MaterialSystemId {get;set;}
     	public string MatchType {get;set;}
     	public decimal AcctSapId {get;set;}
     	public string State {get;set;}
     	public integer NumberOfMonths {get;set;}
     	public Integer ExcessThresholdPercent {get;set;}
        public boolean IncludeAncillary {get;set;}
        public boolean IncludeWsd {get;set;}    
	}
	
	
	public class CalculatePlanRequest  
	{
     	//public string MaterialSystemId {get;set;}
     	public string MatchType {get;set;}
     	public decimal AcctSapId {get;set;}
     	public integer NumberOfMonths {get;set;}
     	//public Integer ExcessThresholdPercent {get;set;}
        public boolean IncludeAncillary {get;set;}
        public boolean IncludeWsd {get;set;}
        public list<long> MaterialKey {get;set;} 
           
	}
	
		public class GetDatabaseRequest  
	{
     	//public string MaterialSystemId {get;set;}
     	public string MatchType {get;set;}
     	public string DatabaseType {get;set;}
     	public decimal AcctSapId {get;set;}
     	public integer NumberOfMonths {get;set;}
        public boolean IncludeAncillary {get;set;}
        public boolean IncludeWsd {get;set;}
        public list<long> MaterialKey {get;set;} 
           
	}
	
	
	    public class MaterialItem {
        public Integer Rank;
        public Long MaterialKey;
        public Long MaterialNumber;
        public String MaterialDesc;
        public Decimal ListPrice;
        public Long MatchCount;
        public Decimal MatchPercent;
        public Long ExcessCount;
        public Long TotalNewDbs;
        public Decimal ExcessPercent;
	
	    }
	
		 /** Data structure representing Material Plan information
		 		 	  
	 */
	public class MaterialPlanInfo {
		//Properties
		public Decimal SAPCustomerNumber {get;set;}
		public Decimal NumberOfAttorneys {get;set;}
        public long InPlanDbsCount {get;set;}
        public long InPlanDbsTrans {get;set;}
        public long AncillaryDbsCount {get;set;}
        public long AncillaryDbsTrans {get;set;}
        public long WsdDbsCount {get;set;}
        public long WsdDbsTrans {get;set;}
        public MaterialItem[] PrimaryMaterials {get;set;}
        public MaterialItem[] PublicMaterials {get;set;}
        public MaterialItem[] OtherMaterials {get;set;}
        
          
        		
		//Static Methods
		public void parse(ContentOptimizerServiceWS.MaterialContent oMaterialPlan) {
			this.SAPCustomerNumber = oMaterialPlan.AcctSapId;
			this.NumberOfAttorneys = oMaterialPlan.NumberOfAttorneys;
			this.InPlanDbsCount = oMaterialPlan.InPlanDbsCount;
			this.InPlanDbsTrans = oMaterialPlan.InPlanDbsTrans;
			this.AncillaryDbsCount = oMaterialPlan.AncillaryDbsCount;
			this.AncillaryDbsTrans = oMaterialPlan.AncillaryDbsTrans;
			this.WsdDbsCount = oMaterialPlan.WsdDbsCount;
			// oMaterialPlanInfo.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
	//		this.PrimaryMaterials = New MaterialItem[oMatrialPlan.Primarymaterials.size()];
		/**	for each (MaterialItem Item in oMaterialPlan.PrimaryMaterials){
				} */
		
		
		
		
/*		for (ContentOptimizerServiceWS.MaterialItem oMaterialPlanList : oMaterialPlan.PrimaryMaterials.values) {
			
			ContentOptimizerServiceWS.MaterialItem oMaterialItem = new ContentOptimizerServiceWS.MaterialItem();
			
			oMaterialItem.Rank = oMaterialPlanList.Rank;
			omaterialitem.MaterialDesc = '2';
			oMaterialItem.rank = 5;
			oMaterialPlanInfo.PrimaryMaterials.add(oMaterialItem);
			
		//	this.primaryMaterials.Rank = oMaterialPlanList.Rank;
		} */
	//}
				
	//		this.PrimaryMaterials = oMaterialPlan.Primarymaterials;
		}
	}
	
	public class CalculatePlanInfo {
		//Properties
	    public String MatchType;
        public Decimal AcctSapId;
        public Integer NumberOfMonths;
        public Boolean IncludeAncillary;
        public Boolean IncludeWsd;
        public Long[] MaterialKey;
        public Long MatchCount;
        public Long TotalExistingDBS;
        public Decimal MatchPercent;
        public Long ExcessCount;
        public Long TotalNewDbs;
        public Decimal ExcessPercent;
        
        
        		//Static Methods
		public void parse(ContentOptimizerServiceWS.PlanContent oCalculatePlanInfo) {
			this.MatchType = oCalculatePlanInfo.MatchType;
			this.AcctSapId = oCalculatePlanInfo.AcctSapId;
			this.NumberOfMonths = oCalculatePlanInfo.NumberOfMonths;
			this.IncludeAncillary = oCalculatePlanInfo.IncludeAncillary;
			this.IncludeWsd = oCalculatePlanInfo.IncludeWsd;
			this.MatchCount = oCalculatePlanInfo.MatchCount;
			this.TotalExistingDBS = oCalculatePlanInfo.TotalExistingDBS;
			this.MatchPercent = oCalculatePlanInfo.MatchPercent;
			this.ExcessCount = oCalculatePlanInfo.ExcessCount;
			this.TotalNewDbs = oCalculatePlanInfo.TotalNewDbs;
			this.ExcessPercent = oCalculatePlanInfo.ExcessPercent;
        
		}
        
	}   
	
	
	    public class DatabaseItem {
        public String Dbs {get;set;}
        public String DbsDesc{get;set;}
        public Boolean IsInPlan{get;set;}
        public Long InPlanDbsTrans{get;set;}
        public Long AncillaryDbsTrans{get;set;}
        public Long WsdDbsTrans{get;set;}
	    }
	
		public class GetDatabaseInfo {
		//Properties
	// change here skg	
		public String DatabaseType;
        public Decimal AcctSapId;
        public Integer NumberOfMonths;
        public Boolean IncludeAncillary;
        public Boolean IncludeWsd;
        public Long[] MaterialKey;
        public DatabaseItem[] DatabaseItem;
        
        
        

        
        
        		//Static Methods
		public void parse(ContentOptimizerServiceWS.DatabaseContent oGetDatabaseInfo) {
			this.DatabaseType = oGetDatabaseInfo.DatabaseType;
			this.AcctSapId = oGetDatabaseInfo.AcctSapId;
			this.NumberOfMonths = oGetDatabaseInfo.NumberOfMonths;
			this.IncludeAncillary = oGetDatabaseInfo.IncludeAncillary;
			this.IncludeWsd = oGetDatabaseInfo.IncludeWsd;

        
		}
        
	}   
	
	
	       
	
	
	
}