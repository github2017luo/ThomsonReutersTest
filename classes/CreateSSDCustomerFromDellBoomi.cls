/* 
*   @description     : Class to call SAP through BOOMI and submit the ZPND request to update the SSD record with SAP account number 
Date             :25/01/2020 
Author           : Roma  
*/

global with sharing class CreateSSDCustomerFromDellBoomi{     
    
/**
* Main method which prepares the request JSON & call the create customer webservice exposed by BOOMI.
* if the response is a success, SSD is updated with the SAP customer number received and any business partner functions received are also updated. 
* Otherwise, boolean false is returned. Integration logger is updated.
*/
    //Variable to hold the integration message id for logging purposes
    public static String integrationMsgId; 
    public static String requestMsg;  
    public static String oppID;
    public static String QuoteID;
    public static boolean ServiceNowSync=false;
    
    @Future(callout=true)
    public static void triggerCustomerCreationFuture(Id ssdId,Id OrderId,Id QuoId){
        QuoteID = QuoId;
        triggerCustomerCreation(ssdId, QuoteID );
    }
    
    public static boolean triggerCustomerCreation(Id ssdId,Id QuoteID)
    {
        APTS_CreateSSDJSON2ApexBOOMI oRequest;  
        source_system_detail__c oUpdatessd = new source_system_detail__c (Id=ssdId);
        Apttus_Proposal__Proposal__c updateQuote = new Apttus_Proposal__Proposal__c(Id=QuoteID);
        List<Integration_Logger__c> intLogList;
        String ObjID = '';
        String ObjName = 'Quote/Proposal';
        String serviceName = 'OrderSubmission';
        
        try{
            if(QuoteID != null){
                ObjID = QuoteID;
                ObjName = 'Quote/Proposal';
                serviceName = 'Create Tax Account SSD';
                
                if(Schema.sObjectType.Integration_Logger__c.isAccessible())
                    intLogList=[Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssdId and Service_Name__c = :serviceName];
                System.debug('intLogListQuo-->'+intLogList);
            }
            
            if(ssdId != null){
                oRequest = prepareCustomerContextRequest(ssdId);           
                oRequest = prepareCustomerInfoRequest(oRequest,ssdId);
                requestMsg =  'distributionChannel='+oRequest.customer.distributionChannel+'**division='+oRequest.customer.division+'**companyCode='+oRequest.customer.CompanyId+'**industryCode='+oRequest.customer.industryCode+'**customerGroup='+oRequest.customer.accountGroup;
                System.Debug('requestMsg>>'+requestMsg);
                System.Debug('requestMsg1>>>'+ oRequest );
            }
            //check request fields
            String validateStr = validateRequest(oRequest);
            //Roma Starts
            System.Debug('requestMsg1>>>'+ oRequest + oRequest.customer.address_x.get(0).street1 + 'First Name >>>' 
                         + oRequest.customer.address_x.get(0).firstname + 'Last Name>>>' + oRequest.customer.address_x.get(0).lastName
                         +'CITY >> '+ oRequest.customer.address_x.get(0).city + 'DiSTRICT >>' + oRequest.customer.address_x.get(0).district
                         +'REGION >> '+ oRequest.customer.address_x.get(0).district);
            String jsonString = JSON.serialize(oRequest);
            //String requestBodyStringSafe = JSON.parse(JSON.stringify(jsonString ));
            String requestBodyStringSafe = jsonString.replaceAll('\"currency_x\":', '\"currency\":');
            requestBodyStringSafe = requestBodyStringSafe.replaceAll('\"address_x\":', '\"address\":');
            requestMsg = requestBodyStringSafe;
            
            if(validateStr!=null && validateStr!=''){
                if(intLogList!=null && intLogList.size()>=1)
                    IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,'Required Information missing : '+validateStr,requestBodyStringSafe ); 
                else
                    IntegrationLogger.TaxprofOCAddMessage('Required Information missing : '+validateStr,ObjID ,'Quote/Proposal',requestBodyStringSafe , 'Outbound',serviceName,false,QuoteID,ssdId);
                system.debug('***intLogList123::'+intLogList);
                return false;
            }
            else{
                
                /*Roma Starts
                Description: Calling DellBoomiTokenGeneration Class for token Generation and later hitting Dell Boomi for request
                */
                WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('CreateCustomerBOOMI');
                System.debug('jsonString  : '+jsonString);
                System.debug('requestBodyStringSafe : '+requestBodyStringSafe );
                Http http;
                HttpRequest request;
                String grantType = 'client_credentials';
                String contentType= 'application/x-www-form-urlencoded';
                String accessToken;
                if(!Test.isRunningTest()){   
                    accessToken=DellBoomiTokenGeneration.getAuthToken();
                    //System.debug('oAUTH responseBody**** : '+accessToken);
                }
                else{
                    accessToken= 'DtOdJzb5sjdWBpqcvWyGTmGdRYTR';
                }
                
                if(accessToken!=null){
                    http = new Http();
                    request = new HttpRequest();
                }
                request.setEndpoint(oWebServiceSettings.Endpoint__c);
                request.setMethod('POST');
                request.setTimeout(120000);    
                request.setHeader('Authorization','Bearer '+accessToken);
                request.setHeader('Content-Type', contentType);
                request.setHeader('grant_type', grantType);
                request.setBody(requestBodyStringSafe );
                System.debug('Http request'+request); 
                
                /* Roma Ends */
                
                HttpResponse response1;
                if(Test.isRunningTest())
                {
                    response1 = TaxCreateSSDMockHttpResponseGenerator.respond(request);
                }
                else
                {
                    System.debug('Performance1'+System.now());
                    response1 = http.send(request);
                    System.debug('Performance2'+System.now());
                }
                System.debug('response : '+response1.getBody());
                
                // Parse the JSON response
                if (response1.getStatusCode() != 200){
                    System.debug('The status code returned was not expected: ' +
                                 response1.getStatusCode() + ' ' + response1.getStatus());
                    //IntegrationLogger.TaxaddMessage('',ssdId, 'Source System Detail', response1.getStatus(), 'Outbound','Create SAP Customer',false);
                    system.debug('intLogList123::'+intLogList);
                    if(intLogList!=null && intLogList.size()>=1)
                        IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Request Not Sent Successfuly.\nResponse Status Code : '+response1.getStatusCode()+'.\nResponse Status : '+response1.getStatus()+'. \nResponse Body : '+response1.getBody(),requestMsg); 
                    else
                        IntegrationLogger.TaxprofOCAddMessage('Request Not Sent Successfuly.\nResponse Status Code : '+response1.getStatusCode()+'.\nResponse Status : '+response1.getStatus()+'. \nResponse Body : '+response1.getBody(),ObjID, ObjName, requestMsg, 'Outbound',serviceName,false,QuoteID,ssdId);
                    
                    return false; 
                } else{
                    System.debug('response : '+response1.getBody());
                    APTS_CreateSSDJSON2ApexResponseBOOMI responseObject =(APTS_CreateSSDJSON2ApexResponseBOOMI)JSON.deserialize(response1.getBody(),APTS_CreateSSDJSON2ApexResponseBOOMI.class);
                    
                    //from the response get the customer number and update it on the account 
                    if(intLogList!=null && intLogList.size()>=1)
                    {
                        //IntegrationLogger.TaxupdateMessage(intLogList[0].Id, true,'SAP account number on SSD updated successfully');
                        IntegrationLogger.TaxupdateMessage(intLogList[0].Id, true, 'Account Creation Request Sent Succesfully.\nResponse Status Code : '+response1.getStatusCode()+'.\nResponse Status : '+response1.getStatus()+'. \nResponse Body : '+response1.getBody(), requestMsg);
                        //Commented by Kruti Shah(DOC-10571)
                        //oUpdatessd.APTS_ZPEND_Flag__c = true;                        
                        //updateQuote.APTS_ZPEND_Check__c = True;
                        //System.debug('*** ZPEND ** -->'+updateQuote.APTS_ZPEND_Check__c);
                        System.debug('response$$$$$$$$$$$$$enteredsuccessmsg1111111');
                    }
                    else{
                        IntegrationLogger.TaxprofOCAddMessage('Account Creation Request Sent Succesfully.\nResponse Status Code : '+response1.getStatusCode()+'.\nResponse Status : '+response1.getStatus()+'. \nResponse Body : '+response1.getBody(),ObjID, ObjName, requestMsg, 'Outbound',serviceName,true,QuoteID,ssdId);
                        //Commented by Kruti Shah(DOC-10571)
                        //oUpdatessd.APTS_ZPEND_Flag__c = true;                        
                        //updateQuote.APTS_ZPEND_Check__c = True;
                        //System.debug('*** ZPEND ** -->'+updateQuote.APTS_ZPEND_Check__c);
                    }
                    //update updateQuote;
                    oUpdatessd.APTS_ZPEND_Flag__c = true;                        
                    update oUpdatessd;
                    System.debug('response$$$$$$$$$$$$$enteredsuccessmsg333333333333333');
                    return true;
                }
            }   
        }
        catch(Exception ex){
            system.debug('Error in Create Customer'+ex.getMessage());
            system.debug('Error LineNumber: '+ex.getLineNumber());
            system.debug('Error Message: '+ex.getStackTraceString());
            system.debug('intLogList345 :: '+intLogList);
            if(intLogList!=null && intLogList.size()>=1)
                IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,'Exception Message : '+ex.getMessage()+' \nException Trace : '+ex.getStackTraceString(),requestMsg ); 
            else
                IntegrationLogger.TaxprofOCAddMessage('Exception Message : '+ex.getMessage()+' \nException Trace : '+ex.getStackTraceString(),ObjID, ObjName, 'Error While creating SAP Number for SSD record:'+requestMsg , 'Outbound',serviceName,false,QuoteID,ssdId);
            //return 'The prospect failed to convert, please review your account information and make any necessary corrections or contact your administrator.';
            return false;
        }
    }
    
    /**
*  This method is responsible for preparing the context request for CreateCustomer service call
*/
    
    public static APTS_CreateSSDJSON2ApexBOOMI prepareCustomerContextRequest (Id SsdId){
        
        APTS_CreateSSDJSON2ApexBOOMI oRequest = new APTS_CreateSSDJSON2ApexBOOMI();
        
        //build the parameters for sending the request - context_element
        oRequest.context = new APTS_CreateSSDJSON2ApexBOOMI.context();
        oRequest.BOOMIHeader = new APTS_CreateSSDJSON2ApexBOOMI.BOOMIHeader();
        oRequest.BOOMIHeader.applicationId = KeyValueListStore__c.getInstance('BOOMIProductId').TextValue__c;
        list<Apttus_Proposal__Proposal__c> propRec = [Select Id,Name,APTS_SSD_bill_to__c,Digital_Quote_Type__c,APTS_Proposal_Business_Unit__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_bill_to__c =: SsdId];
        if(!propRec.isEmpty() )
        {
            List<SAP_Originating_System_Mapping__mdt> sapMapQuery = [SELECT Id,QuoteType__c,SAP_Originating_System__c,BusinessUnit__c,ZPEND_ApplicationId__c from SAP_Originating_System_Mapping__mdt WHERE QuoteType__c =: propRec[0].Digital_Quote_Type__c AND BusinessUnit__c =: propRec[0].APTS_Proposal_Business_Unit__c];
            if( !sapMapQuery.isEmpty() )
            {        
                for(SAP_Originating_System_Mapping__mdt queryResult : sapMapQuery)
                {
                    oRequest.BOOMIHeader.applicationId = queryResult.ZPEND_ApplicationId__c;
                }
            }
            else{
                oRequest.BOOMIHeader.applicationId = KeyValueListStore__c.getInstance('BOOMIProductId').TextValue__c;
            }
        } 
        else
        {
            oRequest.BOOMIHeader.applicationId = KeyValueListStore__c.getInstance('BOOMIProductId').TextValue__c;
        }
        
        //build the parameters for sending the request - externalAccountId
        oRequest.externalAccountId = ssdId;
        oRequest.extSapAcct = '';
        
        //build the parameters for sending the request - confirmUrl            
        oRequest.confirmUrl = KeyValueListStore__c.getInstance('CustomerReviewPostbackURL').TextValue__c;
        return oRequest;
    }
    /**
*  This method is responsible for preparing the customer information request for CreateCustomer service call
*/
    
    public static APTS_CreateSSDJSON2ApexBOOMI prepareCustomerInfoRequest (APTS_CreateSSDJSON2ApexBOOMI oRequest, Id SsdId){ 
        
        oRequest.customer = new APTS_CreateSSDJSON2ApexBOOMI.Customer();      
        List<APTS_CreateSSDJSON2ApexBOOMI.address> addressList = new List<APTS_CreateSSDJSON2ApexBOOMI.address>();
        APTS_CreateSSDJSON2ApexBOOMI.address addressObject = new APTS_CreateSSDJSON2ApexBOOMI.address();
        
        //build the parameters for sending the request - customer
        if(Schema.sObjectType.source_system_detail__c.isAccessible()){
            source_system_detail__c oSsdDetails = [Select LCRM_Sales_Org__c,LCRM_Sub_BU__c, LCRM_Distribution_Channel__c, LCRM_Division_Code_Description__c, 
                                                   LCRM_Industry__c, LCRM_Customer_Group__c, Name, Number_Street__c, City__c,
                                                   State__c, LCRM_Country_Code__c,Country__c, Postal_Code__c, LCRM_PO_Box__c, LCRM_Phone__c, LCRM_Fax__c, CurrencyIsoCode,
                                                   LCRM_Street3__c, LCRM_Street4__c,OLC_Account_Number__c, RecordType.DeveloperName, LCRM_Name_2__c, LCRM_Name_3__c,LCRM_Street_2__c,
                                                   County__c,LCRM_External_Trail_Acount_ID__c,LCRM_Tax_3__c,LCRM_Tax_4__c,LCRM_Tax_Number__c,LatAm_Tax_Number_Type__c,
                                                   Account_Name__c,Account_Name__r.ECM_Address_Row_Id__c,Account_Name__r.Bu_Segment__c,Account_Name__r.ECC_Segment_Level_2__c,
                                                   Account_Name__r.ECC_Segment_Level_3__c,Account_Name__r.ECM_Party_ID__c,
                                                   Account_Name__r.Name, Account_Name__r.nameTwo__c, Account_Name__r.Namethree__c
                                                   from source_system_detail__c  where Id = :ssdId];
            
            List<String> RectypeList= new List<String>();
            KeyValueListStore__c Lotusservicenowsync= KeyValueListStore__c.getValues('Lotusservicenowsync');
            if(Lotusservicenowsync!=null && Lotusservicenowsync.TextValue__c !=null && Lotusservicenowsync.TextValue__c !=''){
                RectypeList = Lotusservicenowsync.TextValue__c.split(',');
            }
            
            if(RectypeList.contains(oSsdDetails.RecordType.DeveloperName)){
                ServiceNowSync=true;
            }
            
            
            if(oSsdDetails.OLC_Account_Number__c!=null)                         
                oRequest.extSapAcct = oSsdDetails.OLC_Account_Number__c;
            oRequest.customer.action= KeyValueListStore__c.getInstance('BOOMIProductId').TextValue__c;
            oRequest.customer.accountClassification='2';
            oRequest.customer.language='E';
            
            if(oSsdDetails.LCRM_Sales_Org__c!=null) {
                oRequest.customer.salesOrg = oSsdDetails.LCRM_Sales_Org__c;
            }
            if(oRequest.customer.salesOrg!=null){          
                oRequest.customer.distributionChannel = IXOSCodeMap__c.getInstance(oRequest.customer.salesOrg).Dist_Chan_Code__c;
                oRequest.customer.division = IXOSCodeMap__c.getInstance(oRequest.customer.salesOrg).Division_Code__c;
                oRequest.customer.CompanyId = IXOSCodeMap__c.getInstance(oRequest.customer.salesOrg).Company_Code__c;  
                oRequest.customer.Companyname = IXOSCodeMap__c.getInstance(oRequest.customer.salesOrg).Company_Code__c; 
            }
            //Added for DOC-9331
            if(oSsdDetails.Account_Name__c != null) {
                if(oSsdDetails.Account_Name__r.ECM_Party_ID__c != NULL){
                    oRequest.customer.externalPartyId = oSsdDetails.Account_Name__r.ECM_Party_ID__c;
                }
                if(oSsdDetails.Account_Name__r.ECM_Address_Row_Id__c != NULL){
                    oRequest.customer.externalAddressId = oSsdDetails.Account_Name__r.ECM_Address_Row_Id__c;
                }
                if(oSsdDetails.Account_Name__r.Bu_Segment__c != NULL){
                    for(GLI_Segment_L1__c l1 : GLI_Segment_L1__c.getall().values()){
                        if(l1.Name.contains(oSsdDetails.Account_Name__r.Bu_Segment__c)){
                            oRequest.customer.segment1 = l1.Text_Value__c;
                        }
                    }
                }
                if(oSsdDetails.Account_Name__r.ECC_Segment_Level_2__c != NULL){
                    for(GLI_Segment_L2__c l2 : GLI_Segment_L2__c.getall().values()){
                        if(l2.Name.contains(oSsdDetails.Account_Name__r.ECC_Segment_Level_2__c)){
                            oRequest.customer.segment2 = l2.Text_Value__c;
                        }
                    }
                }
                
            }
            oRequest.customer.jurisdictionCode=null;
            oRequest.customer.taxCode1 = oSsdDetails.LCRM_Tax_3__c;
            oRequest.customer.taxCode2 = oSsdDetails.LCRM_Tax_4__c;
            if(oSsdDetails.LCRM_Industry__c!=null)                 
                oRequest.customer.industryCode = BigRuleGenericSettings__c.getInstance('IND:'+oSsdDetails.LCRM_Industry__c).Value__c;
            if(oSsdDetails.LCRM_Customer_Group__c!=null)
                //oRequest.customer.accountGroup = BigRuleGenericSettings__c.getInstance('CG:'+oSsdDetails.LCRM_Customer_Group__c).Value__c;
                oRequest.customer.accountGroup='YN02';
            //if(oSsdDetails.Name!=null)
            //    oRequest.context.firstName= oSsdDetails.Name;
            //oRequest.context.middleName= oSsdDetails.LCRM_Name_2__c;
            //oRequest.context.lastName= oSsdDetails.LCRM_Name_3__c;
            if(oSsdDetails.Account_Name__r.Name!=null)
                oRequest.context.firstName= oSsdDetails.Account_Name__r.Name;
            oRequest.context.middleName= oSsdDetails.Account_Name__r.nameTwo__c;
            oRequest.context.lastName= oSsdDetails.Account_Name__r.Namethree__c;
            APTS_CreateSSDJSON2ApexBOOMI.partnerdetails partnerdetails1= new APTS_CreateSSDJSON2ApexBOOMI.partnerdetails();
            partnerdetails1.partnerrole='MKK';
            APTS_CreateSSDJSON2ApexBOOMI.partnerdetails partnerdetails2= new APTS_CreateSSDJSON2ApexBOOMI.partnerdetails();
            partnerdetails2.partnerrole='FLCU01';
            oRequest.partnerdetails.add(partnerdetails1);
            oRequest.partnerdetails.add(partnerdetails2);
            
            // oRequest.customer.street1 = oAccountDetails.BillingStreet;
            if(oSsdDetails.Number_Street__c!=null)
                addressObject.street1 = AppUtil.IsEmpty(oSsdDetails.Number_Street__c)?oSsdDetails.LCRM_PO_Box__c:oSsdDetails.Number_Street__c;  
            If(!String.isEmpty(addressObject.street1) && addressObject.street1 != null && addressObject.street1.length() >60)
                addressObject.street1= addressObject.street1.substring(0, 60);
            If(!String.isEmpty(oSsdDetails.LCRM_Street_2__c) && oSsdDetails.LCRM_Street_2__c != null && oSsdDetails.LCRM_Street_2__c.length() >60)
                addressObject.street2 = oSsdDetails.LCRM_Street_2__c.substring(0, 60);
            else
                addressObject.street2 = oSsdDetails.LCRM_Street_2__c;
            If(!String.isEmpty(oSsdDetails.LCRM_Street3__c) && oSsdDetails.LCRM_Street3__c!= null && oSsdDetails.LCRM_Street3__c.length() >60)
                addressObject.street3 = oSsdDetails.LCRM_Street3__c.substring(0, 60);
            else
                addressObject.street3 = oSsdDetails.LCRM_Street3__c;
            //oRequest.customer.address.get(0).street4 = oSsdDetails.LCRM_Street4__c;
            If(oSsdDetails.City__c!=null && oSsdDetails.City__c.length() >40)
                addressObject.city = oSsdDetails.City__c.substring(0, 40);
            else
                addressObject.city = oSsdDetails.City__c; 
            Country_Region__c oCountryRegion = new Country_Region__c();
            String strBillState = oSsdDetails.State__c;
            String strBillCountry = (Country_BigRule_Exception__c.getInstance(oSsdDetails.Country__c) == null)?null:Country_BigRule_Exception__c.getInstance(oSsdDetails.Country__c).Name;
            String strCountry = (Country__c.getInstance(oSsdDetails.Country__c) == null)?null:Country__c.getInstance(oSsdDetails.Country__c).Country_Code__c;
            
            if(strBillCountry != null){
                if(Schema.sObjectType.Country_Region__c.isAccessible())
                    try{
                        oCountryRegion = [SELECT Country_Code__c,Region_Code__c,Region_Name__c from Country_Region__c where (Country_Code__c = :strCountry AND Region_Code__c = :strBillState) OR (Country_Code__c = :strCountry AND Region_Name__c = :strBillState)];
                    }
                catch(Exception ex){
                    system.debug('Region or Region code value not correct : '+ex.getMessage());
                }
            }
            
            if(oCountryRegion != null && oCountryRegion.Region_Code__c != null && oCountryRegion.Region_Code__c != ''){
                If(oCountryRegion.Region_Code__c.length() >3)
                    addressObject.region = oCountryRegion.Region_Code__c.substring(0, 3);
                else
                    addressObject.region = oCountryRegion.Region_Code__c;
                
            }
            else{
                If(oSsdDetails.State__c!=null && oSsdDetails.State__c.length() >3)
                    addressObject.region = oSsdDetails.State__c.substring(0, 3);
                else
                    addressObject.region = oSsdDetails.State__c;
            }
            //addressObject.region = oSsdDetails.LCRM_Sub_BU__c;    
            //Roma entered below code to send country code in Country request rather than country field value of SSD
            
            if(strCountry != null && strCountry != ''){
                If(strCountry.length() >3)
                    addressObject.country = strCountry.substring(0, 3);
                else
                    addressObject.country = strCountry;
            }
            else
                addressObject.country = oSsdDetails.Country__c;
            
            System.debug('Region : '+addressObject.region + 'Country>> ' + addressObject.country + 'SSD Country **** ' + oSsdDetails.Country__c);
            //commenting as it sending entire value of country
            //addressObject.country = oSsdDetails.Country__c;
            if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c == Label.SALESORGS100){
                If(oSsdDetails.name.length() >40){
                    addressObject.firstName= oSsdDetails.name.substring(0, 40);
                }else{
                    addressObject.firstName= oSsdDetails.name;
                }
            }else{
                If(oSsdDetails.name.length() >35){
                    addressObject.firstName= oSsdDetails.name.substring(0, 35);
                }else{
                    addressObject.firstName= oSsdDetails.name;
                }
            }
            /*If(oSsdDetails.name.length() >35){
                //Added by Kruti Shah (DOC-10475)
                if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c == Label.SALESORGS100 && oSsdDetails.name.length() >40){
                    addressObject.firstName= oSsdDetails.name.substring(0, 40);
                }else if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c != Label.SALESORGS100 && oSsdDetails.name.length() >35){
                    addressObject.firstName= oSsdDetails.name.substring(0, 35);
                }                
            }else
                addressObject.firstName= oSsdDetails.name;*/
            If(!String.isEmpty(oSsdDetails.Postal_Code__c) && oSsdDetails.Postal_Code__c!= null && oSsdDetails.Postal_Code__c.length() >10)
                addressObject.postalCode = oSsdDetails.Postal_Code__c.substring(0, 10);
            else
                addressObject.postalCode = oSsdDetails.Postal_Code__c;
            addressObject.poBox = oSsdDetails.LCRM_PO_Box__c;
            If(!String.isEmpty(oSsdDetails.County__c) && oSsdDetails.County__c!= null && oSsdDetails.County__c.length() >40)
                addressObject.district = oSsdDetails.County__c.substring(0, 40);
            else 
                addressObject.district = oSsdDetails.County__c;           
            addressObject.phone = oSsdDetails.LCRM_Phone__c;           
            addressObject.fax = oSsdDetails.LCRM_Fax__c;
            if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c == Label.SALESORGS100){
                If(!String.isEmpty(oSsdDetails.LCRM_Name_2__c) && oSsdDetails.LCRM_Name_2__c.length() >40){
                    addressObject.middleName = oSsdDetails.LCRM_Name_2__c.substring(0, 40);
                }else{
                    addressObject.middleName = oSsdDetails.LCRM_Name_2__c;
                }
            }else{
                If(!String.isEmpty(oSsdDetails.LCRM_Name_2__c) && oSsdDetails.LCRM_Name_2__c.length() >35){
                    addressObject.middleName = oSsdDetails.LCRM_Name_2__c.substring(0, 35);
                }else{
                    addressObject.middleName = oSsdDetails.LCRM_Name_2__c;
                }
            }
            /*If(!String.isEmpty(oSsdDetails.LCRM_Name_2__c) && oSsdDetails.LCRM_Name_2__c!= null && oSsdDetails.LCRM_Name_2__c.length() >35){
                //Added by Kruti Shah (DOC-10475)
                if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c == Label.SALESORGS100 && oSsdDetails.LCRM_Name_2__c.length() >40){
                    addressObject.middleName = oSsdDetails.LCRM_Name_2__c.substring(0, 40);
                    system.debug('inside : 40:'+oSsdDetails.LCRM_Sales_Org__c+':'+Label.SALESORGS100+':'+oSsdDetails.LCRM_Name_2__c);
                }else if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c != Label.SALESORGS100 && oSsdDetails.LCRM_Name_2__c.length() >35){
                    addressObject.middleName = oSsdDetails.LCRM_Name_2__c.substring(0, 35);
                    system.debug('inside : 35:'+oSsdDetails.LCRM_Sales_Org__c+':'+Label.SALESORGS100+':'+oSsdDetails.LCRM_Name_2__c);
                }
            }else
                addressObject.middleName = oSsdDetails.LCRM_Name_2__c;*/
            if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c == Label.SALESORGS100){
                If(!String.isEmpty(oSsdDetails.LCRM_Name_3__c) && oSsdDetails.LCRM_Name_3__c.length() >40){
                    addressObject.lastName= oSsdDetails.LCRM_Name_3__c.substring(0, 40);
                }else{
                    addressObject.lastName= oSsdDetails.LCRM_Name_3__c;
                }
            }else{
                If(!String.isEmpty(oSsdDetails.LCRM_Name_3__c) && oSsdDetails.LCRM_Name_3__c.length() >35){
                    addressObject.lastName= oSsdDetails.LCRM_Name_3__c.substring(0, 35);
                }else{
                    addressObject.lastName= oSsdDetails.LCRM_Name_3__c;
                }
            }
            /*If(!String.isEmpty(oSsdDetails.LCRM_Name_3__c) && oSsdDetails.LCRM_Name_3__c!= null && oSsdDetails.LCRM_Name_3__c.length() >35){
                 //Added by Kruti Shah (DOC-10475)
                if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c == Label.SALESORGS100 && oSsdDetails.LCRM_Name_3__c.length() >40){
                    addressObject.lastName= oSsdDetails.LCRM_Name_3__c.substring(0, 40);
                }else if(oSsdDetails.LCRM_Sales_Org__c!=null && oSsdDetails.LCRM_Sales_Org__c != Label.SALESORGS100 && oSsdDetails.LCRM_Name_3__c.length() >35){
                    addressObject.lastName= oSsdDetails.LCRM_Name_3__c.substring(0, 35);
                }             
            }else 
                addressObject.lastName= oSsdDetails.LCRM_Name_3__c;*/         
            oRequest.customer.currency_x = oSsdDetails.CurrencyIsoCode; 
            addressObject.street3 = oSsdDetails.LCRM_Street3__c;
            //oRequest.customer.address.get(0).street4 = oSsdDetails.LCRM_Street4__c;
            oRequest.customer.legalStatus = 'O';
            oRequest.customer.altkn = oSsdDetails.LCRM_External_Trail_Acount_ID__c;
            addressList.add(addressObject);
            oRequest.customer.address_x=addressList;
            system.debug(' REquest ' + oRequest);
        } 
        return oRequest;
    }
    
    public static String validateRequest(APTS_CreateSSDJSON2ApexBOOMI oRequest){
        String tempStr = '';
        if(oRequest.customer.address_x.get(0).street1 == null){
            tempStr = (tempStr==null || tempStr=='')?'Street': ', Street';
        }
        if(oRequest.customer.address_x.get(0).firstname == null){
            tempStr = (tempStr==null || tempStr=='')?'Source System Account Name': ', Source System Account Name';
        }
        /*if(oRequest.customer.address_x.get(0).lastName == null){
        tempStr = (tempStr==null || tempStr=='')?'Name 3': ', Name 3';
        }*/
        if(oRequest.customer.address_x.get(0).city== null){
            tempStr = (tempStr==null || tempStr=='')?'city': ', city';
        }
        if(oRequest.customer.address_x.get(0).country == null){
            tempStr = (tempStr==null || tempStr=='')?'Country': ', Country';
        }
        if(oRequest.customer.address_x.get(0).postalCode == null){
            tempStr = (tempStr==null || tempStr=='')?'Postal Code': ', Postal Code';
        }
        if(oRequest.customer.address_x.get(0).region == null){
            tempStr = (tempStr==null || tempStr=='')?'State': ', State';
        }
        /*if(oRequest.customer.address_x.get(0).district == null){
            tempStr = (tempStr==null || tempStr=='')?'County': ', County';
        }*/
        if(oRequest.customer.salesOrg ==null){
            tempStr = (tempStr==null || tempStr=='')?'Sales Org': ', Sales Org';
        }
        /*if(oRequest.customer.industryCode ==null){
        tempStr = (tempStr==null || tempStr=='')?'Industry': ', Industry';
        }*/
        if(oRequest.customer.distributionChannel ==null){
            tempStr = (tempStr==null || tempStr=='')?'IXOSCodeMap value for '+oRequest.customer.salesOrg: ' IXOSCodeMap value for '+oRequest.customer.salesOrg;
        }
        if(oRequest.customer.division ==null){
            tempStr = (tempStr==null || tempStr=='')?'IXOSCodeMap value for '+oRequest.customer.salesOrg: ', IXOSCodeMap value for '+oRequest.customer.salesOrg;
        }
        /*if(oRequest.customer.Companyname==null){
        tempStr = (tempStr==null || tempStr=='')?'IXOSCodeMap value for '+oRequest.customer.salesOrg: ', IXOSCodeMap value for '+oRequest.customer.salesOrg;
        }*/
        //  if(oRequest.customer.address_x.get(0).region == null){
        //       tempStr = (tempStr==null || tempStr=='')?'Country_BigRule_Exception__c or Country_Region__c record': ', Country_BigRule_Exception__c or Country_Region__c record';
        //  }
        if(tempStr!=null && tempStr!='')
            tempStr = 'Required Information missing : ' + tempStr;
        return tempStr;
    }
    
    
}