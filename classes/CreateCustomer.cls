/**
 * Contains methods for createcustomer button on 
 * pipeline opportunity page.
 *
 * @author  Anshita Sharma
 * @version  2013-03-14 
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-03-14   Anshita Sharma          Created
 * 2013-04-01   Sripriya Kongot         Split into request methods
 * 2013-04-04   Sripriya Kongot         Added log entries to Integration Logger
 * 2013-04-15   Shawn Gray              changes for parameters partnerfunctionid, name2, name3, street2, street3, and street4
 * 2013-04-16   Sripriya Kongot         Included District,Street_Address_2__c(not used for legal) in request, logged custom setting values sent as part of request msg to Logger(for troubleshooting)
 * 2013-04-16   Shawn Gray              Added check to make sure state is not null.
 * 2014-04-29   Nandita Shet            MCL-370 Billing Street is populated with PO Box in 
 *                                      request for CreateCustomer if Billing Street is empty.
 * 2015-06-25   Shawn Gray              Made changes for the on demand trial project
 *                                        added new SAPExternalAccountID
   2016-01-15 Nagendra                  Made changes to include the version number SFD 96
   2017-02-25                            Changes done for MCL-1576. Check implemented before sending Region code to SAP to avoid BigRule failures.
                                        Exception created only for LATAM countries: AR,CL,CO,EC,PY,UY. If more countries to be includes add those
                                        countries in custom settings Country_BigRule_Exception__c.
     
 * =============================================================================
 */
 
global with sharing class CreateCustomer{ 
    

 /**
 * Main method which prepares the request XML & call the create customer webservice exposed by Ecommerce middle Tier.
 * if the response is a success, account is updated with the SAP customer number received and any business partner functions received are also upodated. 
 * Otherwise, a failure message is displayed to the end user. Error counter is incremented at the Account level.
 */
 //Variable to hold the integration message id for logging purposes
public static String integrationMsgId; 
public static String requestMsg;  

   webservice static string triggerCustomerCreation(Id accId)
   {
    ecomCustomerServiceV02.CreateCustomerRequest oRequest;  
    Account oUpdateAccount = new Account(Id=accId);
    string serviceVersion = system.label.customerServiceVersion;
    /*string restrictSalesOrg = system.Label.Restrict_SalesOrg_CreateCustomer;
    set<string> salesorgList = new set <string>();
        for(string oSalesOrg:restrictSalesOrg.split(',')){
            salesorgList.add(oSalesOrg);
        }*/
   
        try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken();
            //Set the initial request context           
            oRequest = prepareCustomerContextRequest( accId);           
            //Set the initial request customer information          
            oRequest = prepareCustomerInfoRequest(  oRequest, accId);
            requestMsg =  'distributionChannel='+oRequest.customer.distributionChannel+'**division='+oRequest.customer.division+'**companyCode='+oRequest.customer.companyCode+'**industryCode='+oRequest.customer.industryCode+'**customerGroup='+oRequest.customer.customerGroup;
            System.Debug('requestMsg>>'+requestMsg);
            System.Debug('requestMsg1>>>'+ oRequest );
            
            //check request fields
            if (oRequest.customer.region == null){
                 //    ApexPages.Message oMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer does not a State valued');
                //  ApexPages.addMessage(oMessage);
                return 'Account State/Region cannot be blank. Please populate State/Region before placing a Create Customer call';
                }
            
           /* if(salesorgList.contains(oRequest.customer.salesOrg)){
                return 'Sales Org does not exists in SAP';
            }*/
            ecomCustomerServiceV02.CustomerServiceV02 oSAPsrvc = new ecomCustomerServiceV02.CustomerServiceV02();
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('BigRuleCreateCustomer');
            oSAPsrvc.endpoint_x = oWebServiceSettings.Endpoint__c;
            oSAPsrvc.inputHttpHeaders_x = new Map<String, String>();
            oSAPsrvc.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            //Blob blobCredentials = Blob.valueOf('C173881' + ':' + 'satya1');
            //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            string sAuthorizationHeader = 'Bearer ' + accessToken;
            oSAPsrvc.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            oSAPsrvc.outputHttpHeaders_x = new Map<String,String>();
            //SFD-96 changes
            tocSchemasThomsonComHeaders200602.X_element oElement = new tocSchemasThomsonComHeaders200602.X_element();
            oElement.ServiceVersion = serviceVersion;
            tocSchemasThomsonComHeaders200602.Message_element  oMessageElement = new tocSchemasThomsonComHeaders200602.Message_element();
            oMessageElement.X = oElement;
            tocSchemasThomsonComHeaders200602.TocHeader_element oheader = new tocSchemasThomsonComHeaders200602.TocHeader_element();
            oheader.Message = oMessageElement;
            oSAPsrvc.header = oheader;
            //SFD -96 changes end
            //instatiate the response
            ecomCustomerServiceV02.CreateCustomerResponse oResponse = new ecomCustomerServiceV02.CreateCustomerResponse();
            if(Test.isRunningTest())
            {
                oResponse = MockWebserviceResponses.getCustomerResponse();
            }
            else
            {
                oResponse = oSAPsrvc.createCustomer(oRequest);
                system.debug(' REsponse ' + oResponse );
            }
            //Create a log entry    
            integrationMsgId =IntegrationLogger.addMessage('', accId, 'Account', requestMsg, 'Outbound','Create SAP Customer',false);
                        
            //from the response get the customer number and update it on the account           
            oUpdateAccount.SAPAccountNumber__c = oResponse.customerNumber;
            if(!String.isEmpty(oResponse.prevAcct) && oResponse.prevAcct != null )
            {
               oUpdateAccount.External_Trial_Account_ID__c = oResponse.prevAcct;
            }
            oUpdateAccount.RecordTypeId = KeyValueListStore__c.getInstance('CustomerRecordTypeId').TextValue__c;
            oUpdateAccount.Account_Error_Counter__c = 0;
            update oUpdateAccount;
            
            //from the response get the partner functions and create them in salesforce
            List<Business_Partner_Function__c> listBusinessPartnerFunctions = new List<Business_Partner_Function__c>();
            
            for(ecomCustomerServiceV02.PartnerFunction oParnter : oResponse.partnerFunction){
                Business_Partner_Function__c oBusinessPartnerFunction = new Business_Partner_Function__c();
                oBusinessPartnerFunction.Related_Account__c = accId;
                oBusinessPartnerFunction.Sold_To_Account__c = accId;
                if(BigRuleGenericSettings__c.getInstance('PF:'+oParnter.partnerFunctionId) != null){
                    oBusinessPartnerFunction.Relationship_Type__c = BigRuleGenericSettings__c.getInstance('PF:'+oParnter.partnerFunctionId).Value__c;               
                    listBusinessPartnerFunctions.add(oBusinessPartnerFunction);
                }
            }
            if(!listBusinessPartnerFunctions.isEmpty()){
                insert listBusinessPartnerFunctions;
            }
            //Log  entry for success
            IntegrationLogger.updateMessage(integrationMsgId, true,'' );
            return 'Customer successfully created.';
        }
        catch(Exception ex){
           // system.debug('Error in Create Customer'+ex.getMessage()+'----Type---'+ex.getTypeName()+'-----line Number---'+ex.getLineNumber());
           oUpdateAccount = [select Account_Error_Counter__c from Account where Id = :accId];
          if(oUpdateAccount.Account_Error_Counter__c == null)
              oUpdateAccount.Account_Error_Counter__c = 1;
          else
              oUpdateAccount.Account_Error_Counter__c = oUpdateAccount.Account_Error_Counter__c+1 ;
          update oUpdateAccount;
          if(integrationMsgId != null && integrationMsgId != ''){
            IntegrationLogger.updateMessage(integrationMsgId, false,'Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage() );
          }
          else{
            integrationMsgId =IntegrationLogger.addMessage('Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage(), accId, 'Account', requestMsg, 'Outbound','Create SAP Customer',false);           
          }
         return 'The prospect failed to convert, please review your account information and make any necessary corrections or contact your administrator.';
        }
   }
   
     /**
     *  This method is responsible for preparing the context request for CreateCustomer service call
     */
  
   public static ecomCustomerServiceV02.CreateCustomerRequest prepareCustomerContextRequest (Id AccId){
    
    ecomCustomerServiceV02.CreateCustomerRequest oRequest = new ecomCustomerServiceV02.CreateCustomerRequest();
    
            //build the parameters for sending the request - context_element
            oRequest.context = new ecomCustomerServiceV02.context_element();
            oRequest.context.productId = KeyValueListStore__c.getInstance('BigRuleProductId').TextValue__c;
            oRequest.context.configGroup = KeyValueListStore__c.getInstance('BigRuleCconfigGroup').TextValue__c;
            
            //build the parameters for sending the request - externalAccountId
            oRequest.externalAccountId = accId;
            oRequest.extSapAcct = '';
            
            //build the parameters for sending the request - confirmUrl            
           oRequest.confirmUrl = KeyValueListStore__c.getInstance('CustomerReviewPostbackURL').TextValue__c;
            return oRequest;
   }
   /**
     *  This method is responsible for preparing the customer information request for CreateCustomer service call
     */
  
   public static ecomCustomerServiceV02.CreateCustomerRequest prepareCustomerInfoRequest (ecomCustomerServiceV02.CreateCustomerRequest oRequest, Id AccId){ 
    
    oRequest.customer = new ecomCustomerServiceV02.Customer();      
   
            //build the parameters for sending the request - customer
            Account oAccountDetails = [Select Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c, 
                                        CompanyCodeDescription__c, Industry, Customer_Group__c, Name, BillingStreet, BillingCity,
                                        BillingState, BillingCountry, BillingPostalCode, PO_Box__c, Phone, Fax, CurrencyIsoCode,
                                        Street_Address_3__c, Street_Address_4__c, NameTwo__c, NameThree__c,Street_Address_2__c,County__c,External_Trial_Account_ID__c,Tax_3__c,Tax_4__c,Tax_Number__c,Tax_Number_Type__c
                                        from Account where Id = :accId];
                                        
            oRequest.extSapAcct = oAccountDetails.External_Trial_Account_ID__c;
            oRequest.customer.salesOrg = oAccountDetails.Sales_Org__c;          
            oRequest.customer.distributionChannel = IXOSCodeMap__c.getInstance(oAccountDetails.Sales_Org__c).Dist_Chan_Code__c;
            oRequest.customer.division = IXOSCodeMap__c.getInstance(oAccountDetails.Sales_Org__c).Division_Code__c;
            oRequest.customer.companyCode = IXOSCodeMap__c.getInstance(oAccountDetails.Sales_Org__c).Company_Code__c;                   
            oRequest.customer.industryCode = BigRuleGenericSettings__c.getInstance('IND:'+oAccountDetails.Industry).Value__c;
            oRequest.customer.customerGroup = BigRuleGenericSettings__c.getInstance('CG:'+oAccountDetails.Customer_Group__c).Value__c;
            oRequest.customer.customerName1 = oAccountDetails.Name;
            oRequest.customer.customerName2 = oAccountDetails.NameTwo__c;
            oRequest.customer.customerName3 = oAccountDetails.NameThree__c;
            oRequest.customer.customerName4 = '';
             //******MCL-370********
           // oRequest.customer.street1 = oAccountDetails.BillingStreet;
            oRequest.customer.street1 = AppUtil.IsEmpty(oAccountDetails.BillingStreet)?oAccountDetails.PO_Box__c:oAccountDetails.BillingStreet ;                                   
            //oRequest.customer.street2 = '';
            oRequest.customer.street2 = oAccountDetails.Street_Address_2__c;
            oRequest.customer.street3 = oAccountDetails.Street_Address_3__c;
            oRequest.customer.street4 = oAccountDetails.Street_Address_4__c;
            oRequest.customer.city = oAccountDetails.BillingCity;
            
            
            //**************************************MCL-1576**************************************//
            
            Country_Region__c oCountryRegion = new Country_Region__c();
            String strBillState = oAccountDetails.BillingState;
            String strBillCountry = (Country_BigRule_Exception__c.getInstance(oAccountDetails.BillingCountry) == null)?null:Country_BigRule_Exception__c.getInstance(oAccountDetails.BillingCountry).Name;
            
            if(strBillCountry != null){
            
            try{
            oCountryRegion = [SELECT Country_Code__c,Region_Code__c,Region_Name__c from Country_Region__c where (Country_Code__c = :strBillCountry AND Region_Code__c = :strBillState) OR (Country_Code__c = :strBillCountry AND Region_Name__c = :strBillState)];
            
            }
            
            catch(Exception ex){
            system.debug('Region or Region code value not correct : '+ex.getMessage());
            }
            }
                
            if(oCountryRegion != null && oCountryRegion.Region_Code__c != null && oCountryRegion.Region_Code__c != ''){
            oRequest.customer.region = oCountryRegion.Region_Code__c;
            }
            else{
            oRequest.customer.region = oAccountDetails.BillingState;
            }
            System.debug('Region : '+oRequest.customer.region);
            
            //**************************************MCL-1576**************************************//
            oRequest.customer.country = oAccountDetails.BillingCountry;
            oRequest.customer.postalCode = oAccountDetails.BillingPostalCode;
            oRequest.customer.poBox = oAccountDetails.PO_Box__c;
            oRequest.customer.district = oAccountDetails.County__c;            
            oRequest.customer.phone = oAccountDetails.Phone;           
            oRequest.customer.fax = oAccountDetails.Fax;           
            oRequest.customer.currency_x = oAccountDetails.CurrencyIsoCode; 
            oRequest.customer.street3 = oAccountDetails.Street_Address_3__c;
            oRequest.customer.street4 = oAccountDetails.Street_Address_4__c;
            oRequest.customer.legalStatus = 'O';
            oRequest.customer.altkn = oAccountDetails.External_Trial_Account_ID__c;
            oRequest.customer.taxNumber1 = oAccountDetails.Tax_Number__c;
            if(oAccountDetails.Tax_Number_Type__c!=null){
                 oRequest.customer.taxType = KeyValueListStore__c.getInstance(oAccountDetails.Tax_Number_Type__c).TextValue__c;
            }
            system.debug('$$ taxNumberType'+oRequest.customer.taxType);
            oRequest.customer.tax3 = oAccountDetails.Tax_3__c;
            oRequest.customer.tax4 = oAccountDetails.Tax_4__c;
            system.debug(' REquest ' + oRequest);
            return oRequest;
   }
}