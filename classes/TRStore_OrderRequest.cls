/* Class: TRStore_OrderRequest
* Purpose: To expose wrapper REST service which will process customer information and create/update Lead, Account, Contact, Opty.
* Created: 4/23/2019
* Author: Mallikarjuna Rao
* 
 CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2019-05-13   Rohit Sharma     DLT-15907   Lead creation 
* 2019-05-30   Rohit Sharma     DLT-15909   Lead Conversion
* 2019-06-14   Mallikarjuna     DLT-15904   Retrieve Lead Information
* 2019-07-19   Mallikarjuna     DLT-17031   New parameter to differenciate US Legal and Canada services
* 2019-11-15   Mallikarjuna     DLT-18131   Added Microsite related changes 
* 2019-12-30   Ameeta Antonio   DLT-19047   Added Proview Online Contact related changes
* 2020-03-19   Ameeta Antonio   DLT-19592   Added Shipping First&Last Name related changes
* 2020-04-20   Avudaiappan A    DUE-1607    Added an additional parameter 'LeadOriginSite' in request
* =============================================================================
*/

@RestResource(urlMapping='/TRStoreLeadAction/*')
global class TRStore_OrderRequest{
    
    
    global class TRStoreResponse{
        
        
        public String responseStatus;
        public String responseCode;
        public String LeadId;
        public string statusDetail;
        public String convertedAccID;
        public String convertedConID;
        public String convertedOppID;
        public string emailId;
        public List<OLCResponse> onlineContactsResponse;
    }
    
    global class OLCResponse{
        public string olcEmailId;
        public String olcStatus;
        public String olcStatusDetail;
        public String olcID;
        public string productCode;
    }
    
    global TRstoreOrders TRstoreOrderDetails;
    
    global class leadrequestById{
            public TRstoreOrders trStoreOrder;
    }

    global class TRstoreOrders {
        
        public TRstoreOrder OrderDetails;
        public References referencesDetails;
        public ActionParams actionParamsDetails;
        public TRStoreResponse resp;
    }
    
    
    global class TRstoreOrder {
        
        public string totalPrice;
        public boolean isAbandonedLead;
        public boolean isExistingCustomer;
        public string LeadsourceCountryCode;
        public string LeadOriginSite;               
        public TRStorecustomerDetails customerDetails;
        public micrositeFieldsClass micrositeFields;
        public List<OnlineContactsFieldsClass> proviewContacts;
    }
   
    global class TRStorecustomerDetails {
        
        public String firstName;
        public String lastName; 
        public String businessEmail;    
        public Boolean isPhysicalSameAsBillingAddress = true;
        public Boolean isOLCAvailalble;
        public string businessPhoneNumber;
        public string shippingPhoneNumber;
        public string shippingFirstName;
        public string shippingLastName;
        public TRStoreAccountDetails organizationDetails;       
        public customerAddress shippingAddress;                
        
    }
    
    global class TRStoreAccountDetails{
        public string organizationName;
        public string AccountANumber;
         public string organizationType;
        public customerAddress billingAddress; // will treat as company address 
        
    }
    
    public class customerAddress {
        public String street1; //610 Opperman Dr
        public string street2; // optional 
        public String city; //Eagan
        public String state;    //MN
        public String zipCode;  //55123
        public String country;  //US
        public string accNumber;
    }

    
    global class References {
        public String leadId;
        public String cartId;
        public String westLawAccount;
        
    } 
     
    global class ActionParams {
        public String leadAction;                 
    }
    
    global class micrositeFieldsClass{
    
        public string leadOriginCode;
        public string chargeCode;
        public boolean orderCompleted;
        public string paymentMethod;
    
    
    }
    
    global class OnlineContactsFieldsClass{
    
        public string pFirstName;
        public string pLastName;
        public string pEmail;
        public string pTitle;
        public string pType;
        public string jurisdiction;
        public string proviewId;
        public LIST<proviewIds> proviewProducts;
    }
    
    global class proviewIds{
        public string pCode;
        public string id;
    }
    
    
    
/********************************************************************************************************
*  processLead: Method to process the request and perform action .
*  @input Customer info/details, @returns TRStoreResponse
*********************************************************************************************************/
    
    @httppost
    global static TRStoreResponse processLead(TRStore_OrderRequest.TRstoreOrders trStoreOrder){
        
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;    
        TRStore_OrderRequest.ActionParams ac = trStoreOrder.actionParamsDetails;
        TRStoreResponse leadResponse = new TRStoreResponse();
        system.debug(LoggingLevel.Info,'object '+trStoreOrder);
        try{
            if(ac.leadAction.equalsIgnoreCase('Create') || ac.leadAction.equalsIgnoreCase('Update')){
                leadResponse = TRStoreLeadprocess.createLead(trStoreOrder); 
            }                     
            else if(ac.leadAction.equalsIgnoreCase('AccountCheck')){
                string accountNumber;
                string zipcode;
                
                if(trStoreOrder.OrderDetails != null){
                    if(trStoreOrder.OrderDetails.customerDetails != null){
                        if(trStoreOrder.OrderDetails.customerDetails.organizationDetails != null){
                            accountNumber = trStoreOrder.OrderDetails.customerDetails.organizationDetails.AccountANumber;
                            
                            if(trStoreOrder.OrderDetails.customerDetails.organizationDetails.billingAddress != null)
                                zipcode = trStoreOrder.OrderDetails.customerDetails.organizationDetails.billingAddress.ZipCode;
                        }
                    }
                }
                
                leadResponse = TRStoreLeadprocess.checkAccountStatus(accountNumber , zipcode, trStoreOrder.referencesDetails.leadId );
                
            }
        }catch(exception e){
            system.debug(LoggingLevel.INFO, 'Exception FetchDetails......'+e);
        }
        
        
         
        
        res.responseBody = Blob.valueOf(JSON.serializePretty(leadResponse));
        
        
        
        return leadResponse;
    }

/********************************************************************************************************
* getLeadDetails: Method to process the get request and retrieve the lead details from SFDC.
* @returns TRStoreResponse
* As Part of  DLT-15904 
*********************************************************************************************************/   
     @HttpGet
    global static TRStore_OrderRequest.leadrequestById getLeadDetails(){
        RestRequest req = RestContext.request;
        Id leadId = req.params.get('leadId');
        string emailId = req.params.get('EmailAddress');
        Id cartId = req.params.get('CartId');
        system.debug(LoggingLevel.Info,'Lead ID.....'+leadId);
        TRStore_OrderRequest.leadrequestById trstoreOrderDetails = new TRStore_OrderRequest.leadrequestById();
         
         try{
            TRstoreOrderDetails = TRStoreLeadprocess.fetchLeadDetails(leadId, emailId, cartId); 
         }catch(Exception e){
             system.debug(LoggingLevel.INFO, 'Exception FetchDetails......'+e);
         } 
             
          
        
        return TRstoreOrderDetails;
     
    }


}