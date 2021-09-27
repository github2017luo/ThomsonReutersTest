/* Class: TRStore_LeadRequest
* Purpose: To expose wrapper REST service which will process customer information and create/update Lead.
* Created: 11/12/2020
* Author:  Ameeta Antonio
* 
 CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2019-11-11   Ameeta A       DUE-5173   Lead creation/Updation for Transact
* =============================================================================
*/
@RestResource(urlMapping='/TRStoreLeadAPI/*')
global class TRStore_LeadRequest {
    
    global class TRStoreResponse{
                
        global String responseStatus;
        global String responseCode;
        global String leadId;
        global string statusDetail;
        global String convertedAccID;
        global String convertedConID;
        global String convertedOppID;
        global string emailId;
        global List<OLCResponse> onlineContactsResponse;
    }
    
    global class OLCResponse{
        global string olcEmailId;
        global String olcStatus;
        global String olcStatusDetail;
        global String olcID;
        global string productCode;
    }
    
    global TRstoreOrders trstoreOrderDetails;
    
    global class LeadrequestById{
        global TRstoreOrders trStoreOrder;
    }

    global class TRstoreOrders {
        
        global TRstoreOrder orderDetails;
        global References referencesDetails;
        global ActionParams actionParamsDetails;
        global TRStoreResponse resp;
    }
       
    global class TRstoreOrder {
        
       
        global boolean isExistingCustomer;
        global string leadsourceCountryCode;
        global string leadOriginSite;   
        global string siteLanguageCode;             
        global TRStorecustomerDetails customerDetails;
        global MicrositeFieldsClass micrositeFields;
        global List<OnlineContactsFieldsClass> proviewContacts;
    }
   
    global class TRStorecustomerDetails {
        
        global String firstName;
        global String lastName; 
        global String businessEmail;    
        global Boolean isPhysicalSameAsBillingAddress = true;
        global Boolean isOLCAvailalble;
        global string businessPhoneNumber;
        global string shippingPhoneNumber;
        global string shippingFirstName;
        global string shippingLastName;
        global TRStoreAccountDetails organizationDetails;       
        global CustomerAddress shippingAddress;                        
    }
    
    global class TRStoreAccountDetails{
        global string organizationName;
        global string accountANumber;
        global string organizationType;
        global CustomerAddress billingAddress; // will treat as company address         
    }
    
    global class CustomerAddress {
        global String street1; //610 Opperman Dr
        global string street2; // optional 
        global String city; //Eagan
        global String state;    //MN
        global String zipCode;  //55123
        global String country;  //US
        global string accNumber;
    }
    
    global class References {
        global String leadId;
        global String cartId;
        global String westLawAccount;        
    } 
     
    global class ActionParams {
        global String leadAction;                 
    }
    
    global class MicrositeFieldsClass{
    
        global string leadOriginCode;
        global string chargeCode;
        global boolean orderCompleted;
        global string paymentMethod;    
    }
    
    global class OnlineContactsFieldsClass{
    
        global string pFirstName;
        global string pLastName;
        global string pEmail;
        global string pTitle;
        global string pType;
        global string jurisdiction;
        global string proviewId;
        
        global LIST<ProviewIds> proviewProducts;
    }
    
    global class ProviewIds{
        global string pCode;
        global string id;
    }
    
    
/********************************************************************************************************
*  processLead: Method to process the request and perform action .
*  @input Customer info/details, @returns TRStoreResponse
*********************************************************************************************************/
  @httppost
    global static TRStoreResponse processLead(TRStore_LeadRequest.TRstoreOrders trStoreOrder){
        
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;    
        TRStore_LeadRequest.ActionParams ac = trStoreOrder.actionParamsDetails;
        TRStoreResponse leadResponse = new TRStoreResponse();
        TRStoreLeadProcess_Createlead processCreate = new TRStoreLeadProcess_Createlead();
        system.debug(LoggingLevel.Info,'object '+trStoreOrder);
        try{
            if(ac.leadAction.equalsIgnoreCase('Create') || ac.leadAction.equalsIgnoreCase('Update')){
                
                leadResponse = processCreate.createLead(trStoreOrder);
            }                     
            
        }catch(exception e){
            system.debug(LoggingLevel.INFO, 'Exception FetchDetails......'+e);
        }
               
        res.responseBody = Blob.valueOf(JSON.serializePretty(leadResponse));
        return leadResponse;
    }
}