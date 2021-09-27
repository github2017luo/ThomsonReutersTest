/**
* @file name          : DCPLeadRequestHandler
* @description        : This class is for holding the request params for Lead Services
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 05/20/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 05/20/2021   Servendra Kumar    DCP-1678     Created 
* 06/03/2021   Servendra Kumar    DCP-1946     Updated
* 08/24/2021   Priyanka Mondal    DCP-3397     Updated
* =============================================================================
**/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPLeadRequestHandler {

    global DCPOrders dCPOrderDetails;

    /**
     * @description
     */
    global class DCPResponse{
                
        global String responseStatus;
        global String responseCode;
        global String leadId;
        global string statusDetail;
        global String convertedAccID;
        global String convertedConID;
        global String convertedOppID;
        global string emailId;
        global List<OLCResponse> onlineContactsResponse;
        global string trialID;
        global string trialStatus;
        global Boolean reviewRequired;
        global string reviewRequiredNotes;
    }
    
    /**
     * @description
     */
    global class OLCResponse{
        global string olcEmailId;
        global String olcStatus;
        global String olcStatusDetail;
        global String olcID;
        global string productCode;
    }
    
       
    /**
     * @description
     */
    global class LeadrequestById{
        global DCPOrders trStoreOrder;
    }
    /**
     * @description
     */
    global class DCPOrders {
        
        global DCPOrder orderDetails;
        global References referencesDetails;
        global ActionParams actionParamsDetails;
        global DCPResponse resp;
    }
    /**
     * @description
     */ 
    global class DCPOrder {
        
       
        global boolean isExistingCustomer;
        global string leadsourceCountryCode;
        global string leadOriginSite; 
        global string productFamily; // adding as part of CI changes 
        global string siteLanguageCode;        
        global DCPcustomerDetails customerDetails;
        global List<OnlineContactsFieldsClass> entitlementContacts;
        //global List<OnlineContactsFieldsClass> proviewContacts;
    }
    /**
     * @description
     */
    global class DCPCustomerDetails {
        
        global String firstName;
        global String lastName; 
        global String businessEmail;    
        global Boolean isPhysicalSameAsBillingAddress = true;
        global Boolean isOLCAvailalble;
        global Boolean reviewRequired;
        global string businessPhoneNumber;
        global string shippingPhoneNumber;
        global string shippingFirstName;
        global string shippingLastName;
        global DCPLAccountDetails organizationDetails;       
        global CustomerAddress shippingAddress;                        
    }
    /**
     * @description
     */
    global class DCPLAccountDetails{
        global string organizationName;
        global string accountANumber;
        global string onePassGUID;
        global string organizationType;
        global CustomerAddress billingAddress; // will treat as company address         
    }
    /**
     * @description
     */
    global class CustomerAddress {
        global String street1; //610 Opperman Dr
        global string street2; // optional 
        global String city; //Eagan
        global String state;    //MN
        global String zipCode;  //55123
        global String country;  //US
        global string accNumber;
    }
    /**
     * @description
     */
    global class References {
        global String leadId;
        global String cartId;
        global String westLawAccount;
        global string trialID;         
    } 
     /**
     * @description
     */
    global class ActionParams {
        global String leadAction;                 
    }
    /**
     * @description
     */
    global class OnlineContactsFieldsClass{    
        global string pFirstName;
        global string pLastName;
        global string pEmail;
        global string pPosition;
        global string pType;
        global string jurisdiction;
        global string entitlementId;
        global boolean isAdmin;
        /*global string quoteId;
        global string contactId;    */    
        //global LIST<ProviewIds> proviewProducts;
        global LIST<ProviewIds> entitlementProducts;
    }    
    /**
     * @description
     */
    global class ProviewIds{
        global string productCode;
        global string productId;        
    }
    
     //Lead conversion code
    /**
     * @description
     */
    global class ConvertLeadWrapperDetails{
    
        global id leadId;
        global id cartId;
        global string emailId;
        global string westAccNumber;    
        global id quoteId ; 
        /**
        * @description
        */
        global ConvertLeadWrapperDetails(){
            string avoidNull;
            avoidNull = '';
        }    
     }
     /**
     * @description
     */
     global class ContactUpdateToRespWrap{
    
        global id conIdw ;
        global LIST<Lead> leadsListw ;
        global ReferenceDetails refDetw ; 
        global DCPLeadRequestHandler.DCPResponse respw;
       /**
        * @description
        */
        global ContactUpdateToRespWrap(){
           
           leadsListw = new LIST<Lead>();
           refDetw = new ReferenceDetails();
           respw = new DCPLeadRequestHandler.DCPResponse();
           
       }
       
   }
   /**
    * @description 
    */
   global class ConvertLeadWrapper{    
        global Source_System_Detail__C ssdRecw;
        global id conIdw;
        global List<Lead> leadsw;
        global ReferenceDetails refDetailsw;
        /**
        * @description
        */       
        global ConvertLeadWrapper(){
            ssdRecw = new Source_System_Detail__C();
            leadsw = new List<Lead>();            
        }    
    }
    /**
    * @description 
    */
    global class CreateOpptyWrap{        
        global string accNamew ;
        global id accIDw ;
        global id conIDw ;
        global id accSsdw;
        global List<Lead> leads;
        global ReferenceDetails rdw ;
        global Source_System_Detail__C ssdRecw;
        global decimal contractTerm;
        /**
        * @description
        */
        global CreateOpptyWrap(){
                ssdRecw = new Source_System_Detail__C ();
                accNamew = '';
        }   
    }
    /**
    * @description 
    */
    global class CreateNewSsdWrap{
        global lead lwr ;
        global Id oAccountw; 
        global string oAccountNamew;  
        global boolean shippingOnlyw;
        /**
        * @description
        */
        global CreateNewSsdWrap(){
           lwr = new Lead();
       }
   }
   /**
    * @description 
    */
   global class ReferenceDetails{            
        global id convertedAccId;
        global Integer contractTerm;
        global id convertedConId;
        global id convertedOppId;
        global id accountSSDId;    //Billing Address SSD Id
        global id contactSSDId;
        global string refDesc;
        global Source_system_Detail__c ssdRec;
        global id accountShippingSSDId;    //Shippig Address SSD Id
        global Source_system_Detail__c shippingSSDRec;
        global database.saveResult recordResult;
        global String errorObject;     
        /**
        * @description
        */
        global ReferenceDetails(){
            errorObject = '';
        }          
    }

    /**
     * @description leadConversionWrapper
     */
    global class LeadConversionWrapper{
        global id accID;
        global id conId;
        global id oppId;
        global List<Lead> leads;
    }
}