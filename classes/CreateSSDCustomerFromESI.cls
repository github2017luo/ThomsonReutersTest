/**
 *@author Original : Priyanka Pawar (UX007471)
 *@date Original   : 15th May 2018
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description
* 2018-26-12   Shiva Sri Arun Koralla          DLT - 13623 
* =============================================================================
*  DLT - 13623 :: [IE] SFDC - Send new Originating system SF08 instead of SF03 for the ZPEND requests Orginated from Digital Portal
*  DLT-20538    :    Making chnges on Phone number field to remove special characters 
*/

/**
 *@description     : (CRM-14646) Class to call SAP through ESI and submit the ZPND request to update the SSD record with SAP account number 
*/
public with sharing class CreateSSDCustomerFromESI{     

    //Variable to hold the integration message id for logging purposes
    //public static String integrationMsgId; 
    //public static String requestMsg;  
    
    /**
     * @description Main method which prepares the request JSON & call the create customer webservice exposed by ESI.If the response is a success, SSD is updated with the SAP customer number received and any business partner functions received are also upodated.Otherwise, boolean false is returned. Integration logger is updated.
     * @param ssdId of type Id
     * @param orderId of type Id
     * @return Boolean
     */
    public static Boolean triggerCustomerCreation(Id ssdId,Id orderId){ 
    APTS_CreateSSDJSON2Apex oRequest;   
    //Source_system_detail__c oUpdatessd = new Source_system_detail__c (Id=ssdId);
    List<Integration_Logger__c> intLogList;   
        try{
            //Set the initial request context           
            oRequest = prepareCustomerContextRequest(ssdId);           
            //Set the initial request customer information          
            oRequest = prepareCustomerInfoRequest(oRequest,ssdId);
            /*requestMsg =  'distributionChannel='+oRequest.customer.distributionChannel+'**division='+oRequest.customer.division+'**companyCode='+oRequest.customer.CompanyId+'**industryCode='+oRequest.customer.industryCode+'**customerGroup='+oRequest.customer.accountGroup;
            System.Debug('requestMsg>>'+requestMsg);*/
            System.Debug(LoggingLevel.DEBUG,'requestMsg1>>>'+ oRequest );
            if(Schema.sObjectType.Integration_Logger__c.isAccessible()){
                //if(System.Label.Risk_ZPEND_Sales_Orgs.contains(oRequest.customer.salesOrg)){
                intLogList=[Select Id from Integration_Logger__c where Source_System_Detail__c=:ssdId];
                /*}else{
                   intLogList=[Select Id from Integration_Logger__c where Order__c=:orderId];
                }*/
            }
            //check request fields //DOC-6893 removed state condition from here and merge it in below if condition
            /*if (oRequest.customer.address_x.get(0).region == null){
               
                return false;
                }*/
             //return false if mandatory fields are null
             //start: DOC-6893 Made change for TA61
            String validatepayload = CreateSSDCustomerFromESIHelper1.validaterequestpayload(oRequest);
            if(validatepayload != null && validatepayload != ''){
                CreateSSDCustomerFromESIHelper2.loggerrecord1(intLogList,validatepayload,oRequest);
                return false;
            }
            /*if(oRequest.customer.salesOrg != 'TA61'){
                if(oRequest.customer.address_x.get(0).street1 == null ||  oRequest.customer.address_x.get(0).firstname == null || oRequest.customer.address_x.get(0).city== null || oRequest.customer.address_x.get(0).country == null || oRequest.customer.salesOrg ==null || oRequest.customer.industryCode ==null || oRequest.customer.distributionChannel  ==null || oRequest.customer.division ==null || oRequest.customer.Companyname==null || (oRequest.customer.address_x.get(0).region == null && !countrystate1.contains(oRequest.customer.address_x.get(0).country)) || (oRequest.customer.jurisdictionCode == null && latamsalesorgs.contains(oRequest.customer.salesOrg)) || (oRequest.customer.taxCodeType == null && latamsalesorgs.contains(oRequest.customer.salesOrg))){ //DOC-6893 (Added region condition) 
                    system.debug('intLogList :: '+oRequest.customer.address_x.get(0).country);
                    //if(System.Label.Risk_ZPEND_Sales_Orgs.contains(oRequest.customer.salesOrg)){
                    if(intLogList!=null && intLogList.size()>=1){
                        IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Required Information missing : '+oRequest,'Required Information missing for Account creation in SAP'); 
                    }else{
                        IntegrationLogger.TaxprofOCAddMessage('Required Information missing : '+oRequest,'', 'Source System Detail', 'Required Information missing for Account creation in SAP', 'Outbound','OrderSubmission',false,'',ssdId);
                    }
                    }else{
                    if(intLogList!=null && intLogList.size()==1){
                        IntegrationLogger.updateMessage(intLogList[0].Id, false,'Required Information missing'); 
                    } else {
                    IntegrationLogger.OCAddMessage('','', 'Quote/Proposal', 'Error While creating SAP Number for SSD record', 'Outbound','OrderSubmission',false,orderId);
                    }
                    }
                    return false;
                }
            }else{
                if(oRequest.customer.address_x.get(0).country == 'US' || oRequest.customer.address_x.get(0).country == 'AR' || oRequest.customer.address_x.get(0).country == 'PY' || oRequest.customer.address_x.get(0).country == 'CL' || oRequest.customer.address_x.get(0).country == 'UY'){
                    if(oRequest.customer.address_x.get(0).street1 == null ||  oRequest.customer.address_x.get(0).firstname == null || oRequest.customer.address_x.get(0).city== null || oRequest.customer.address_x.get(0).country == null || oRequest.customer.salesOrg ==null || oRequest.customer.industryCode ==null || oRequest.customer.distributionChannel  ==null || oRequest.customer.division ==null || oRequest.customer.Companyname==null || oRequest.customer.address_x.get(0).region == null){
                        system.debug('intLogList :: '+oRequest.customer.address_x.get(0).country);
                            if(intLogList!=null && intLogList.size()==1){
                                IntegrationLogger.updateMessage(intLogList[0].Id, false,'Required Information missing'); 
                            }else {
                            IntegrationLogger.OCAddMessage('','', 'Quote/Proposal', 'Error While creating SAP Number for SSD record', 'Outbound','OrderSubmission',false,orderId);
                            }
                        if(intLogList!=null && intLogList.size()>=1){
                            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Required Information missing : '+oRequest,'Required Information missing for Account creation in SAP'); 
                        }else{
                            IntegrationLogger.TaxprofOCAddMessage('Required Information missing : '+oRequest,'', 'Source System Detail', 'Required Information missing for Account creation in SAP', 'Outbound','OrderSubmission',false,'',ssdId);
                        }
                        return false;
                    }
                }else{
                    if(oRequest.customer.address_x.get(0).street1 == null ||  oRequest.customer.address_x.get(0).firstname == null || oRequest.customer.address_x.get(0).city== null || oRequest.customer.address_x.get(0).country == null || oRequest.customer.salesOrg ==null || oRequest.customer.industryCode ==null || oRequest.customer.distributionChannel  ==null || oRequest.customer.division ==null || oRequest.customer.Companyname==null){
                        system.debug('intLogList ::  '+oRequest.customer.address_x.get(0).country);
                            if(intLogList!=null && intLogList.size()==1) {
                                IntegrationLogger.updateMessage(intLogList[0].Id, false,'Required Information missing'); 
                            } else{
                                IntegrationLogger.OCAddMessage('','', 'Quote/Proposal', 'Error While creating SAP Number for SSD record', 'Outbound','OrderSubmission',false,orderId);
                            }
                        if(intLogList!=null && intLogList.size()>=1){
                            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Required Information missing : '+oRequest,'Required Information missing for Account creation in SAP'); 
                        }else{
                            IntegrationLogger.TaxprofOCAddMessage('Required Information missing : '+oRequest,'', 'Source System Detail', 'Required Information missing for Account creation in SAP', 'Outbound','OrderSubmission',false,'',ssdId);
                        }
                        return false;
                    }
                }
            }*/
            //End DOC-6893
            HttpResponse response = CreateSSDCustomerFromESIHelper3.sendhttprequest(oRequest);
            //System.debug(LoggingLevel.DEBUG,'response'+response.getBody());
            // Parse the JSON response
            if(response.getStatusCode() != 200){
                System.debug(LoggingLevel.DEBUG,'The status code returned was not expected: ' +response.getStatusCode() + ' ' + response.getStatus());
                //if(System.Label.Risk_ZPEND_Sales_Orgs.contains(oRequest.customer.salesOrg)){
                CreateSSDCustomerFromESIHelper2.loggerrecord2(intLogList,response,oRequest);
                       /*}else{
                    IntegrationLogger.addMessage('',ssdId, 'Source System Detail', response.getStatus(), 'Outbound','Create SAP Customer',false);
                    system.debug('intLogList123::'+intLogList);
                    
                    if(intLogList!=null && intLogList.size()==1){
                        IntegrationLogger.updateMessage(intLogList[0].Id, false,response.getStatus()); 
                   } else {
                        IntegrationLogger.OCAddMessage('','', 'Quote/Proposal', 'Error While creating SAP Number for SSD record', 'Outbound','OrderSubmission',false,orderId);
                    }
                    }*/
                return false;
            }else{
                System.debug(LoggingLevel.DEBUG,'response'+response.getBody());
                APTS_CreateSSDJSON2ApexResponse responseObject =(APTS_CreateSSDJSON2ApexResponse ) JSON.deserialize(response.getBody(),APTS_CreateSSDJSON2ApexResponse.class);
                if(responseObject.customerNumber == null || String.valueOf(responseObject.customerNumber)==''){
                    //if(System.Label.Risk_ZPEND_Sales_Orgs.contains(oRequest.customer.salesOrg)){
                    CreateSSDCustomerFromESIHelper2.loggerrecord3(intLogList,response,oRequest);
                    /*}else{
                        IntegrationLogger.addMessage('',ssdId, 'Source System Detail', response.getStatus(), 'Outbound','Create SAP Customer',false);
                    system.debug('intLogList234 :: '+intLogList);
                    if(intLogList!=null && intLogList.size()==1){
                        IntegrationLogger.updateMessage(intLogList[0].Id, false,response.getStatus()); 
                    } else {
                        IntegrationLogger.OCAddMessage('','', 'Quote/Proposal', 'Error While creating SAP Number for SSD record', 'Outbound','OrderSubmission',false,orderId);
                    }
                    }*/
                    return false;
                }
                //from the response get the customer number and update it on the account           
                CreateSSDCustomerFromESIHelper3.updatessd(responseObject,ssdId);
                CreateSSDCustomerFromESIHelper3.updatebpf(responseObject,ssdId);
                //IntegrationLogger.addMessage('', ssdId, 'Source System Detail', requestMsg, 'Outbound','Create SAP Customer',true,'');
                //if(intLogList!=null && intLogList.size()==1)
                // IntegrationLogger.updateMessage(intLogList[0].Id, true,'SAP account numebron SSD updated successfully'); 
                //  else
                //if(System.Label.Risk_ZPEND_Sales_Orgs.contains(oRequest.customer.salesOrg)){
                IntegrationLogger.TaxprofOCAddMessage('SAP Account Number created successfully : '+response.getStatusCode()+'.\nResponse Status : '+response.getStatus()+'. \nResponse Body : '+response.getBody(),'', 'Source System Detail', 'Requested details : '+oRequest, 'Outbound','ZPEND Customer Creation',true,'',ssdId);
                   /*}else{
                    IntegrationLogger.addMessage('',ssdId, 'Source System Detail', 'SAP account number on SSD updated successfully', 'Outbound','Create SAP Customer',true);
                   }*/
                return true;
            }
        }
        catch(Exception ex){
            system.debug(LoggingLevel.DEBUG,'Error in Create Customer'+ex.getMessage()+'Error LineNumber: '+ex.getLineNumber()+'Error Message: '+ex.getStackTraceString());
            // if(integrationMsgId != null && integrationMsgId != ''){
            //  IntegrationLogger.updateMessage(integrationMsgId, false,'Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage() );
          
            // }
            // else{
            //  integrationMsgId =IntegrationLogger.addMessage('Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage(), ssdId, 'Source System Detail', requestMsg, 'Outbound','Create SAP Customer',false,'');           
            // }
            //system.debug(LoggingLevel.DEBUG,'intLogList345 :: '+intLogList);
            //if(System.Label.Risk_ZPEND_Sales_Orgs.contains(oRequest.customer.salesOrg)){
            CreateSSDCustomerFromESIHelper2.loggerrecord4(intLogList,ex,oRequest);
            /*}else{
            if(intLogList!=null && intLogList.size()==1)
            IntegrationLogger.updateMessage(intLogList[0].Id, false,ex.getMessage()); 
            else
            IntegrationLogger.OCAddMessage(ex.getStackTraceString(),'', 'Quote/Proposal', 'Error While creating SAP Number for SSD record', 'Outbound','OrderSubmission',false,orderId);
                
            }*/
            //return 'The prospect failed to convert, please review your account information and make any necessary corrections or contact your administrator.';
            return false;
        }
    }
   
    /**
     * @description This method is responsible for preparing the context request for CreateCustomer service call
     * @param ssdId of type Id
     * @return APTS_CreateSSDJSON2Apex
     */
    public static APTS_CreateSSDJSON2Apex prepareCustomerContextRequest(Id ssdId){
        APTS_CreateSSDJSON2Apex  oRequest = new APTS_CreateSSDJSON2Apex ();
        //build the parameters for sending the request - context_element
        oRequest.context = new APTS_CreateSSDJSON2Apex.context();
        oRequest.ESIHeader = new APTS_CreateSSDJSON2Apex.ESIHeader();
        oRequest.ESIHeader.applicationId = KeyValueListStore__c.getInstance('ESIProductId').TextValue__c;
        //DLT-13623
        list<Apttus_Proposal__Proposal__c> propRec;
        Boolean custMDCheck = false;
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
            propRec = [Select Id,Name,APTS_SSD_bill_to__c,Digital_Quote_Type__c,APTS_Proposal_Business_Unit__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_bill_to__c =: SsdId];
        }
        if(!propRec.isEmpty()){
            /*List<SAP_Originating_System_Mapping__mdt> sapMapQuery;
            //if(Schema.sObjectType.SAP_Originating_System_Mapping__mdt.isAccessible()) 
            //sapMapQuery = [SELECT Id,QuoteType__c,SAP_Originating_System__c,BusinessUnit__c,ZPEND_ApplicationId__c from SAP_Originating_System_Mapping__mdt WHERE QuoteType__c =: propRec[0].Digital_Quote_Type__c AND BusinessUnit__c =: propRec[0].APTS_Proposal_Business_Unit__c];
            //if( !sapMapQuery.isEmpty() )
            {      */  
            for(SAP_Originating_System_Mapping__mdt queryResult : [SELECT Id,QuoteType__c,SAP_Originating_System__c,BusinessUnit__c,ZPEND_ApplicationId__c from SAP_Originating_System_Mapping__mdt WHERE QuoteType__c =: propRec[0].Digital_Quote_Type__c AND BusinessUnit__c =: propRec[0].APTS_Proposal_Business_Unit__c]){
                oRequest.ESIHeader.applicationId = queryResult.ZPEND_ApplicationId__c;
                custMDCheck = true;
            }
             //}
            if(custMDCheck == false){
                oRequest.ESIHeader.applicationId = KeyValueListStore__c.getInstance('ESIProductId').TextValue__c;
            }
        }else{
            oRequest.ESIHeader.applicationId = KeyValueListStore__c.getInstance('ESIProductId').TextValue__c;
        }
        //build the parameters for sending the request - externalAccountId
        oRequest.externalAccountId = ssdId;
        oRequest.extSapAcct = '';
        //build the parameters for sending the request - confirmUrl            
        oRequest.confirmUrl = KeyValueListStore__c.getInstance('CustomerReviewPostbackURL').TextValue__c;
        return oRequest;
    }
     
    /**
     * @description This method is responsible for preparing the customer information request for CreateCustomer service call
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @param ssdId of type Id
     * @return APTS_CreateSSDJSON2Apex
     */
    public static APTS_CreateSSDJSON2Apex prepareCustomerInfoRequest(APTS_CreateSSDJSON2Apex oRequest,Id ssdId){
        oRequest.customer = new APTS_CreateSSDJSON2Apex.Customer();      
        List<APTS_CreateSSDJSON2Apex.address> addressList = new List<APTS_CreateSSDJSON2Apex.address>();
        APTS_CreateSSDJSON2Apex.address addressObject = new APTS_CreateSSDJSON2Apex.address();     
        //build the parameters for sending the request - customer
        if(Schema.sObjectType.Source_system_detail__c.isAccessible()){
            Source_system_detail__c oSsdDetails = [Select LCRM_Sales_Org__c, LCRM_Distribution_Channel__c, LCRM_Division_Code_Description__c,LCRM_Industry__c, LCRM_Customer_Group__c, Name, Number_Street__c, City__c,State__c, LCRM_Country_Code__c,Country__c, Postal_Code__c, LCRM_PO_Box__c, LCRM_Phone__c, LCRM_Fax__c, CurrencyIsoCode,LCRM_Street3__c, LCRM_Street4__c,OLC_Account_Number__c, LCRM_Name_2__c, LCRM_Name_3__c,LCRM_Street_2__c,County__c,LCRM_External_Trail_Acount_ID__c,LCRM_Tax_3__c,LCRM_Tax_4__c,LCRM_Tax_Number__c,LatAm_Tax_Number_Type__c from Source_system_detail__c  where Id = :ssdId];
            oRequest = CreateSSDCustomerFromESIHelper3.preparecustomerinfo1(oRequest,oSsdDetails);
            oRequest = CreateSSDCustomerFromESIHelper3.preparecustomerinfo2(oRequest,oSsdDetails);
            if(oSsdDetails.Name!=null){
                oRequest.context.firstName= oSsdDetails.Name;
            }
            oRequest.context.middleName= oSsdDetails.LCRM_Name_2__c;
            oRequest.context.lastName= oSsdDetails.LCRM_Name_3__c;
            // oRequest.customer.street1 = oAccountDetails.BillingStreet;
            addressObject = CreateSSDCustomerFromESIHelper3.preparecustomerinfo3(addressObject,oSsdDetails);
            addressObject = CreateSSDCustomerFromESIHelper3.preparecustomerinfo4(addressObject,oSsdDetails);
            addressObject = CreateSSDCustomerFromESIHelper4.preparecustomerinfo5(addressObject,oSsdDetails);
            addressObject = CreateSSDCustomerFromESIHelper4.preparecustomerinfo6(addressObject,oSsdDetails);
            //making the changes as part of DLT-20538, SAP need to receive upto 16 digits on phone field, making the changes as per that.
            addressObject = CreateSSDCustomerFromESIHelper4.preparecustomerinfo7(addressObject,oSsdDetails);        
            addressObject.fax = oSsdDetails.LCRM_Fax__c;
            if(!String.isEmpty(oSsdDetails.LCRM_Name_2__c) && oSsdDetails.LCRM_Name_2__c!= null && oSsdDetails.LCRM_Name_2__c.length() >35){
                addressObject.middleName = oSsdDetails.LCRM_Name_2__c.substring(0, 35);
            }else{
                addressObject.middleName = oSsdDetails.LCRM_Name_2__c;
            }
            if(!String.isEmpty(oSsdDetails.LCRM_Name_3__c) && oSsdDetails.LCRM_Name_3__c!= null && oSsdDetails.LCRM_Name_3__c.length() >35){
                addressObject.lastName= oSsdDetails.LCRM_Name_3__c.substring(0, 35);
            }else{
                addressObject.lastName= oSsdDetails.LCRM_Name_3__c;         
            }
            oRequest.customer.currency_x = oSsdDetails.CurrencyIsoCode; 
            addressObject.street3 = oSsdDetails.LCRM_Street3__c;
            //oRequest.customer.address.get(0).street4 = oSsdDetails.LCRM_Street4__c;
            oRequest.customer.legalStatus = 'O';
            oRequest.customer.altkn = oSsdDetails.LCRM_External_Trail_Acount_ID__c;
            addressList.add(addressObject);
            oRequest.customer.address_x=addressList;
            system.debug(LoggingLevel.DEBUG,' REquest ' + oRequest);
        }
        return oRequest;
    }
}