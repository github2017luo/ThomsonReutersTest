/* Class: TRStoreLeadProcess_Createlead
* Purpose: to process the request from TRStore_LeadRequest and perform action like lead create/update.
* Created: 5/13/2019
* Author: Rohit Sharma
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2019-05-13   Rohit Sharma     DLT-15907   Lead creation 
* 2019-09-05   Mallikarjuna Rao DLT-17544   updated code for billing and shipping address are different 
* 2019-11-18   Mallikarjuna Rao DLT-18131   MicrositeLead changes...update Lead origin and charge codes 
* 2019-12-30   Ameeta Antonio   DLT-19047   Creation of Proview Online Contact 
* 2020-02-18   Mallik           DLT-19262   Proview entitlements 
* 2020-02-27   Kanishk Singhvi  DLT-19615   Shipping phone number, Street line two
* 2020-03-19   Ameeta Antonio   DLT-19592   Added Shipping First&Last Name related changes
* 2020-04-20   Avudaiappan A    DUE-1607    Added an additional parameter 'LeadOriginSite' in request
* 2020-10-16   Ameeta Antonio   DLT-20979   Refactored Code to fix PMD.
* =============================================================================
*/
/** 
 * @description : This is the main class to create a lead 
 */ 
global with sharing class TRStoreLeadProcess_Createlead {
    
    public LIST<String> emailIds = new LIST<String>();
    public LIST<String> cartIds = new LIST<String>();
    public MAP<string, id> existingLeads = new MAP<string, id>();
    public Lead lead = new Lead();
    public LIST<Lead> leads = new LIST<Lead>();
    public LIST<User> aemConnectUsers = new List<User>();
    public string leadOrigin='';
    public List<TRStore_LeadRequest.OLCResponse> olcResult;
    public String supportEmail='';
    public TRStore_LeadRequest.OLCResponse olcResp;
    public List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();
    public LIST<Customer_Master_Contacts__c> masterContacts = new LIST<Customer_Master_Contacts__c>();
    public String leadOrigon ='';
    
    
/********************************************************************************************************
* CreateLead: Method to create & update lead information.
*  @input Customer info/details, @returns TRStoreResponse
*  @description  this is the main mrthod to create Lead from queueable 
*  @param trStoreOrder : it contaisn the request from APIGEE or UI
*  @return : TRStore_LeadRequest.TRStoreResponse and contains lead response 
*********************************************************************************************************/  
    public TRStore_LeadRequest.TRStoreResponse createLead(TRStore_LeadRequest.TRstoreOrders trStoreOrder)
    {
        
        TRStore_LeadRequest.TRStoreResponse  resp = new TRStore_LeadRequest.TRStoreResponse();
        
        supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        
        string emailId='';
        string cartId='';
        
        emailId = '';
        cartId = '';
        
        if(trStoreOrder.OrderDetails != null){
            
            TRStore_LeadRequest.MicrositeFieldsClass leadMicrositeInfo = trStoreOrder.OrderDetails.micrositeFields;     
                 
            system.debug(loggingLevel.INFO,'Hello microsite Fields............'+leadMicrositeInfo);
            this.mapLeadOriginValue(leadMicrositeInfo); 
            this.mapListOfEmailIdsAndCartIds(trStoreOrder);
            
        }         
      
        system.debug(loggingLevel.INFO,'Lead Origin'+leadOrigin);
      /*   // if condition for origion
        if(leadOrigin.equals('TR Store'))
        {  
            this.mapExistingLeadList();
        }
        system.debug(loggingLevel.INFO,'Existing LEads'+existingLeads.keySet());
        
        
       //DLT-17900 adding owner id and record type for creating lead. 
        if(Static_Values__c.getAll().get('LeadOwnerGroupId') != null && Schema.sObjectType.user.isAccessible()){
            string aemUserName = Static_Values__c.getAll().get('LeadOwnerGroupId').Value__c;
            aemConnectUsers = [select id, userName from user where userName =: aemUserName ];
        } */
        
        
        if(trStoreOrder.OrderDetails != null){
            if(trStoreOrder.OrderDetails.customerDetails != null){
                
                TRStore_LeadRequest.TRStorecustomerDetails leadInfo = trStoreOrder.OrderDetails.customerDetails;     
                mapCustomerDetails(trStoreOrder.OrderDetails.customerDetails);
               mapLeadOwnerId(trStoreOrder);
                
                lead.TRStore_Existing_Customer__c = (trStoreOrder.OrderDetails.isExistingCustomer != null)?trStoreOrder.OrderDetails.isExistingCustomer:false;
                
                mapLeadFieldsBasedOnCountry(trStoreOrder);
                mapLanguageonLead(trStoreOrder);  
                TRStore_LeadRequest.MicrositeFieldsClass leadMicrositeInfo = trStoreOrder.OrderDetails.micrositeFields;                      
                system.debug(loggingLevel.INFO,'Hello microsite Fields............'+leadMicrositeInfo);
                mapMicrositeFields(trStoreOrder.OrderDetails.micrositeFields);
                
                mapOrganizationDetails(leadInfo);
                
  
                TRStore_LeadRequest.References refInfo = trStoreOrder.referencesDetails;  
                mapReferenceDetails(refInfo);
                
                
                 //check leadid from request and update only for microsites 
                leads.add(lead); 
                
                //DLT-19047-get the proview contact details from request and cretae online contacts
                mapOnlineContacts(trStoreOrder,leadInfo,refInfo); 
                
            }               
        }
        system.debug(LoggingLevel.Info,'List of Leads'+leads);
        
        resp = createTRStoreLead();      
        
        resp.onlineContactsResponse = olcResult;
        System.debug(LoggingLevel.INFO,'resp '+resp);
        return resp; 
    }
    
/********************************************************************************************************
*  mapLeadOriginValue : retrieves lead origin value from AEM lead request.
*  @input PlatForm TRStore_LeadRequest.MicrositeFieldsClass   
*  @description  mapLeadOriginValue - this will map the lead origin  
*  @param leadMicrositeInfo : it contaisn the lead request from APIGEE or UI
*********************************************************************************************************/
    private void mapLeadOriginValue(TRStore_LeadRequest.MicrositeFieldsClass leadMicrositeInfo){
        if(leadMicrositeInfo != null && leadMicrositeInfo.leadOriginCode != null){
                    
            system.debug(loggingLevel.INFO,'static values'+Static_Values__c.getAll().containsKey(leadMicrositeInfo.leadOriginCode));
            system.debug(loggingLevel.INFO,'static values'+Static_Values__c.getAll().values());
                    
            leadOrigin = (Static_Values__c.getAll().containsKey(leadMicrositeInfo.leadOriginCode))?Static_Values__c.getAll().get(leadMicrositeInfo.leadOriginCode).value__c:'';
                      
        }
    }

/********************************************************************************************************
*  createTRStoreLead : creates or updates the lead by performing an upsert operation.
*  @returns TRStoreResponse 
*  @description  mapLeadOriginValue - this will map the lead origin  
*  @return TRStore_LeadRequest.TRStoreResponse  : this is return main lead create 
*********************************************************************************************************/
    private TRStore_LeadRequest.TRStoreResponse createTRStoreLead(){
        TRStore_LeadRequest.TRStoreResponse  resp = new TRStore_LeadRequest.TRStoreResponse();
        List< Database.UpsertResult> ipr = new LIST<Database.UpsertResult>();
        try{
            if(!leads.isEmpty()){
            ipr = database.upsert(leads);
            }
        }catch(exception e){
            system.debug(LoggingLevel.INFO,'Exception came...........'+e);
            resp.leadId ='';
            resp.responseStatus= TRStoreConstants.FAILURESTATUS;
            resp.responseCode= TRStoreConstants.ERROR_CODE;
            
            if(e != null){
                resp.statusDetail = string.valueOf(e);
                //TRStoreLeadprocess.logTRSException('Lead create process', 'Errors While Creation of Lead'+string.valueOf(e), 'createNewLead', resp.leadId, 'Lead', 'Lead Creation', supportEmail, true);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of Lead'+string.valueOf(e)+': '+e.getLineNumber(),'webServiceName'=>'createNewLead','requestType'=>'Lead Creation','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Createlead','module'=>'TRStore','recId'=>resp.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        }
        system.debug(LoggingLevel.Info,'Leads upsert Result..........'+ipr);
        system.debug(LoggingLevel.Info,'Lead..........'+leads);
        
        for(Database.UpsertResult up : ipr){
            if(up.isSuccess()){
                resp.leadId =up.getId();
                resp.responseStatus= 'Success';
                resp.responseCode= TRStoreConstants.SUCCESS_CODE;
            }
            else{
                resp.leadId =null;
                resp.responseStatus= TRStoreConstants.FAILURESTATUS;
                resp.responseCode= TRStoreConstants.ERROR_CODE;   
            }
        }
        return resp;
    }

/********************************************************************************************************
*  mapOnlineContacts : maps the online cart details on lead.
*  @input PlatForm TRStore_LeadRequest   
*  @description  mapOnlineContacts- this is the online contacts processing method  
*  @param trStoreOrder : it contaisn the lead request from APIGEE or UI
*  @param leadInfo : Existing lead details 
*  @param refInfo : reference variables for olc
*   
*********************************************************************************************************/
    private void mapOnlineContacts(TRStore_LeadRequest.TRstoreOrders trStoreOrder,TRStore_LeadRequest.TRStorecustomerDetails leadInfo,TRStore_LeadRequest.References refInfo){
        List<TRStore_LeadRequest.OnlineContactsFieldsClass> olcInfo = trStoreOrder.OrderDetails.proviewContacts;
                
        olcResult = new List<TRStore_LeadRequest.OLCResponse>();
                
        try{
            system.debug(LoggingLevel.INFO,'olcInfo...............'+leadInfo.isOLCAvailalble+'     '+olcInfo);  
            if(leadInfo.isOLCAvailalble ){              
                if(!olcInfo.isEmpty() ){
                    olcResult = createOnlineContacts(olcInfo, refInfo, leadInfo); 
                }
            }    
        //End DLT-19047-get the proview contact details from request and create online contacts 
        }catch(exception e){
            system.debug(LoggingLevel.INFO,'Error in processing onlinecontacts'+e.getLineNumber()+'     '+e);
            //TRStoreLeadprocess.logTRSException('Lead create process', 'Error in processing onlinecontacts'+string.valueOf(e), 'createNewLead', refInfo.leadId, 'Lead', 'Lead Creation', supportEmail, true);
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Error in processing onlinecontacts'+string.valueOf(e)+': '+e.getLineNumber(),'webServiceName'=>'createNewLead','requestType'=>'Lead Creation','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Createlead','module'=>'UEStore','recId'=>refInfo.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);
        }  
    }     

/********************************************************************************************************
*  mapReferenceDetails : maps the cart details on lead as well as updates existing lead id if present.
*  @input PlatForm TRStore_LeadRequest 
*  @description  mapReferenceDetails - This will be map the lookup fields - cartId, leadId other fields   
*  @param refInfo : reference variables for olc
*   
*********************************************************************************************************/
    private void mapReferenceDetails(TRStore_LeadRequest.References refInfo){
        if(refInfo != null){
                    if(refInfo.cartId != null)
                    {
                        lead.Product_Configuration__c = refInfo.cartId ;
                    }                    
                }
                
                if(refInfo.leadId !='' && leadOrigin !='TR Store'){
                    lead.id = refInfo.leadId ;
                }
                else {
                    system.debug(loggingLevel.info,'inside elase if');
                    try{
                        mapLeadrecId();
                    }catch(Exception e){
                         system.debug(LoggingLevel.INFO,'Exception came...........'+e);
            
                    }
                    
                    /*if(existingLeads.containsKey(lead.Product_Configuration__c) ){
                        lead.id = existingLeads.get(lead.Product_Configuration__c);
                    }else if(existingLeads.containsKey(lead.email)){
                        lead.id = existingLeads.get(lead.email);
                    }*/
                       
                }
    }
    
/********************************************************************************************************
*  mapReferenceDetails : maps the Lead id based on email and cart id, if both matches we need to get that lead id.
*  @input PlatForm TRStore_LeadRequest   
*  @description  mapLeadrecId - this is the method map the existing lead  
*    
*********************************************************************************************************/
    private void mapLeadrecId(){
        id leadIdP1;
        id leadIdP2;
        id leadIdP3;
        
         
        string serviceEmail =  firstString(emailIds);
        string serviceCartId = firstString(cartIds);
         
        
        for(Lead l: queryLeadDetails(emailIds, cartIds,true)){
            if(l.email == serviceEmail  && l.Product_Configuration__c == serviceCartId && leadIdP1 == null){
                leadIdP1 = l.id;
                break;
            }else if(l.Product_Configuration__c == serviceCartId && leadIdP2  == null) {
                leadIdP2 = l.id;
            }else if(leadIdP3 == null){
                leadIdP3 = l.id;
            }
        }
         
         mapFinalLeadId(leadIdP1 , leadIdP2, leadIdP3);
         
    }
/***************************************************************************************    
*  @description  firstString - From list of values it will return first value
*  @param anyStringList : this will holds list of string 
*  @return string from that list of values - first value  
****************************************************************************************/    
    private String firstString(LIST<string> anyStringList){
        
         if(!anyStringList.isEmpty()){
            return anyStringList[0];
        }
        
        return null;
    }


/***************************************************************************************    
*  @description  mapFinalLeadId - here we are mapping Lead ids from above 3 lead ids
*  @param leadIdP1 : first Lead id
*  @param leadIdP2 : Second Lead id
*  @param leadIdP3 : Third Lead id
*  
*    
****************************************************************************************/ 
    
    private void mapFinalLeadId(id leadIdP1, id leadIdP2, id leadIdP3){
        
        if(leadIdP1 != null || leadIdP2 != null || leadIdP3 != null){
            Lead.id = ((leadIdP1 != null)? leadIdP1 :((leadIdP2 != null)? leadIdP2 : leadIdP3));
        }
        
    }
    
/********************************************************************************************************
*  mapOrganizationDetails : map organization details and shipping details on the lead fields.
*  @input PlatForm TRStore_LeadRequest.TRStorecustomerDetails   
*  @description  mapOrganizationDetails - Map the lead organization details 
*  @param leadInfo : Parameter to have main lead json 
*    
*********************************************************************************************************/
    private void mapOrganizationDetails(TRStore_LeadRequest.TRStorecustomerDetails leadInfo){
        
        if(leadInfo.organizationDetails != null ) {
            TRStore_LeadRequest.TRStoreAccountDetails accountdetails = leadInfo.organizationDetails;       
                    lead.SAPAccountNumber__c = accountdetails.AccountANumber;
                    lead.company = accountdetails.organizationName;
                    
                    if(accountdetails.organizationType != null){
                        lead.Market_Segment__c = accountdetails.organizationType;
                    }
                    
                    if(accountdetails.billingAddress != null){                       
                        TRStore_LeadRequest.CustomerAddress billingaddress = accountdetails.billingAddress;     
                        
                        lead.Billing_Street__c = billingaddress.street1;
                        lead.Billing_Street_2__c = billingaddress.street2;
                        lead.Billing_City__c = billingaddress.city;
                        lead.Billing_State__c = billingaddress.state;
                        lead.Billing_Country__c = billingaddress.country;
                        lead.Billing_Zip__c = billingaddress.zipCode;
                        
                    }     
        }
        if(leadInfo.shippingAddress != null){                       
                    TRStore_LeadRequest.CustomerAddress shippingAddress = leadInfo.shippingAddress;     
                    
                    lead.street = shippingAddress.street1;
                    lead.Shipping_Street_2__c = shippingAddress.street2;
                    lead.city = shippingAddress.city;
                    lead.state = shippingAddress.state;
                    lead.country = shippingAddress.country;
                    lead.postalcode = shippingAddress.zipCode;
                    if(shippingAddress.accNumber != null){
                        lead.ShipToSSD_TRStore__c = shippingAddress.accNumber;
                    }
                    
        }
    }

/********************************************************************************************************
*  mapMicrositeFields : map microsite details on the lead fields.
*  @input PlatForm TRStore_LeadRequest  
*  @description  mapMicrositeFields - Map the lead microsite details 
*  @param leadMicrositeInfo : Parameter to have main lead json 
*   
*********************************************************************************************************/
    private void mapMicrositeFields(TRStore_LeadRequest.MicrositeFieldsClass leadMicrositeInfo){
        if(leadMicrositeInfo != null){                
            if(leadMicrositeInfo.leadOriginCode != null){
                        
                lead.Lead_Microsite__c = (Static_Values__c.getAll().containsKey(leadMicrositeInfo.leadOriginCode) )?Static_Values__c.getAll().get(leadMicrositeInfo.leadOriginCode).value__c:'';
                        
            }                   
        }
                
        if(leadMicrositeInfo.chargeCode != null){
            system.debug(loggingLevel.INFO,'Hello............ leadMicrositeInfo.chargeCode    '+leadMicrositeInfo.chargeCode);
            lead.TRStore_ChargeCode__c = leadMicrositeInfo.chargeCode;
        }
        if(leadMicrositeInfo.paymentMethod != null && leadMicrositeInfo.paymentMethod != ''){
            system.debug(loggingLevel.INFO,'Hello............ leadMicrositeInfo.paymentMethod   '+leadMicrositeInfo.paymentMethod);
            lead.TRstore_Payment_Method__c = leadMicrositeInfo.paymentMethod;
        }
                   
        if(leadMicrositeInfo.orderCompleted != null){
            lead.TRstore_Microsite_Order_Completed__c = leadMicrositeInfo.orderCompleted;
        }
    }

/********************************************************************************************************
*  mapLeadFieldsBasedOnCountry : map lead fields based on country code.
*  @input PlatForm TRStore_LeadRequest   
*  @description  mapLeadFieldsBasedOnCountry - Map the lead fields based on country 
*  @param trStoreOrder : Parameter to have main lead json 
*   
*********************************************************************************************************/
    private void mapLeadFieldsBasedOnCountry(TRStore_LeadRequest.TRstoreOrders trStoreOrder){
        if(trStoreOrder.OrderDetails.leadsourceCountryCode != null){
            if(trStoreOrder.OrderDetails.leadsourceCountryCode == 'US'){
                lead.Lead_Region__c = (String.isNotBlank(trStoreOrder.OrderDetails.leadOriginSite) && trStoreOrder.OrderDetails.leadOriginSite.equalsIgnoreCase('TPRO'))?'TR Store Tax Professional':'TR Store US Print';
                lead.Primary_Campaign_Source__c = Static_Values__c.getAll().get('TransactSFDCCampaignIdUS').value__c;  
                lead.Tracking_Code__c = Static_Values__c.getAll().get('TransactHive9CodeUS').Value__c;   
            }else if(trStoreOrder.OrderDetails.leadsourceCountryCode == 'CA' && trStoreOrder.OrderDetails.leadOriginSite.equalsIgnoreCase('UECAPR')){
                lead.Lead_Region__c = Static_Values__c.getAll().get('UECAPR').Value__c;
                lead.Primary_Campaign_Source__c = Static_Values__c.getAll().get('TransactSFDCCampaignIdCA').value__c;  
                lead.Tracking_Code__c = Static_Values__c.getAll().get('TransactHive9CodeCA').Value__c;   
            }    
                    
        }
    }
    
/********************************************************************************************************
*  map store Langueage : map lead field - Langueage  based on lang code.    *  @input PlatForm TRStore_LeadRequest   
* For English site    "siteLanguageCode" will be "EN"    * For French Site     "siteLanguageCode" will be "FR"
*  @description  mapLanguageOnLead - Map the lead Language Fields 
*  @param trStoreOrder : Parameter to have main lead json 
*  
*********************************************************************************************************/    
    private void mapLanguageOnLead(TRStore_LeadRequest.TRstoreOrders trStoreOrder){
        lead.Language_Preference__c = (trStoreOrder.OrderDetails.siteLanguageCode != null)? fetchLangParams(trStoreOrder.OrderDetails.siteLanguageCode) : 'English' ;
     }
/*******************************************
*  @description  fetchLangParams - main method to get Lang Main param 
*  @param lang : param to get the lang 
*  @return string 
**********************************************/
    private string fetchLangParams(string lang){        
        return (Static_Values__c.getAll().containsKey(lang))? Static_Values__c.getAll().get(lang).Value__c : 'English';                        
    }
   
/************************************************************************************************************
*
*  @description  mapLeadOwnerId - map the lead owner ID  
*  @param trStoreOrder : Main paramters to store owner ID 
*   
*************************************************************************************************************/

//DLT-17900 adding owner id and record type for creating lead. 
    private void mapLeadOwnerId(TRStore_LeadRequest.TRstoreOrders trStoreOrder){
    
        String userEmail = '';
        
        if(trStoreOrder.OrderDetails.leadsourceCountryCode != null ){
            if(trStoreOrder.OrderDetails.leadsourceCountryCode == 'US'){
                userEmail = getValuesFromStaticValuesCs('TransactLeadOwnerGroupUS'); // Static_Values__c.getAll().get('TransactLeadOwnerGroupUS').Value__c;
            }else if(trStoreOrder.OrderDetails.leadsourceCountryCode == 'CA'){
                userEmail = getValuesFromStaticValuesCs('TransactLeadOwnerGroupCA'); //Static_Values__c.getAll().get('TransactLeadOwnerGroupCA').Value__c;
            }
        }    
        if(userEmail != '' && Schema.sObjectType.User.isQueryable()){
            try{
            aemConnectUsers = [select id, userName from User where userName =: userEmail];
            }catch(Exception e){
                 system.debug(LoggingLevel.INFO,'Exception came...........'+e);
            
            }
        }
        if( !aemConnectUsers.isEmpty()){
            lead.ownerId = aemConnectUsers[0].id; 
        }    
    }
    
/********************************************************************
*  @description  getValuesFromStaticValuesCs - get values from custom settings  
*  @param csName : string for custom settings name 
*  @return string return type 
**************************************************************************/    
    
    private string getValuesFromStaticValuesCs(string csName){
        
        if(Static_Values__c.getAll().containsKey(csName)){
           return  Static_Values__c.getAll().get(csName).Value__c;
        }
        
        return null;
        
    }
    
    
    
//************************************************************************************************************
/********************************************************************************************************
*  mapCustomerDetails : map customer details on the lead fields.
*  @input PlatForm TRStore_LeadRequest   
*  @description  mapCustomerDetails - map customer details  
*  @param leadInfo : main json 
*   
*********************************************************************************************************/
    private void mapCustomerDetails(TRStore_LeadRequest.TRStorecustomerDetails leadInfo){ 
        if(leadInfo != null){     
       
                    lead.Is_GLI__c = true; 
                    lead.firstname = leadInfo.firstName;
                    lead.lastname = leadInfo.lastName;
                    lead.Email = leadInfo.businessEmail;   
                    lead.leadSource='Website';     
                    lead.sales_org__c='GLI';  
                    lead.Shipping_Phone__c = leadInfo.shippingPhoneNumber;
                    lead.Operating_Unit__c = 'Print';
                    
                    system.debug(LoggingLevel.Info,'leadInfo.businessPhoneNumber..........'+leadInfo.businessPhoneNumber);
                    if( leadInfo.businessPhoneNumber != null && leadInfo.businessPhoneNumber != ''){
                        lead.MobilePhone = leadInfo.businessPhoneNumber;
                        lead.phone = leadInfo.businessPhoneNumber;
                    }
                    
                    if(leadInfo.shippingFirstName != null){
                      lead.Shipping_FirstName__c = leadInfo.shippingFirstName;  
                    }
                    if(leadInfo.shippingLastName != null){
                      lead.Shipping_LastName__c = leadInfo.shippingLastName;  
                    }
                    if(leadInfo.isPhysicalSameAsBillingAddress != null){
                        lead.TRstore_Billadd_differenceto_shipping__c = !(leadInfo.isPhysicalSameAsBillingAddress);  
                    }
                    //DLT-17900
                    if(Static_Values__c.getAll().get('LeadRecordTypeName') != null){
                        string rtName= Static_Values__c.getAll().get('LeadRecordTypeName').value__c;
                        lead.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
                    }    
                  /*  if(!aemConnectUsers.isEmpty()){
                        lead.ownerId = aemConnectUsers[0].id; 
                    }*/
                    
        }
    }
    
/********************************************************************************************************
*  mapExistingLeadList : retrieve the existing leads into a list. 
*  @description  mapCustomerDetails - map customer details  
*  @param leadInfo : main json 
*  
*********************************************************************************************************/
  /*      private void mapExistingLeadList(){
            for(Lead l: queryLeadDetails(emailIds, cartIds,true)){
                if(!l.isconverted){
                    existingLeads.put(l.email, l.id);
                    if(l.Product_Configuration__c != null){
                        existingLeads.put(l.Product_Configuration__c , l.id);
                    }    
                }
            } 
        }
*/
/********************************************************************************************************
*  mapListOfEmailIdsAndCartIds : map emails id's entered in a list as well as the cart id created in 
*  another list for further processing.
*  @input PlatForm TRStore_OrderService   
*  @description  mapListOfEmailIdsAndCartIds - map emaail and carrt field details  
*  @param trStoreOrder : main json 
*   
*********************************************************************************************************/
        private void mapListOfEmailIdsAndCartIds(TRStore_LeadRequest.TRstoreOrders trStoreOrder){
            if(trStoreOrder.OrderDetails.customerDetails != null){
                TRStore_LeadRequest.TRStorecustomerDetails leadInfo = trStoreOrder.OrderDetails.customerDetails;     
                if(leadInfo != null){  
                    emailIds.add(leadInfo.businessEmail);
                }
                
                TRStore_LeadRequest.References refInfo = trStoreOrder.referencesDetails;  
                if(refInfo != null && refInfo.cartId != null){
                    
                        cartIds.add(refInfo.cartId);
                    
                }
                
            }
        }
    
/********************************************************************************************************
*  MicrositeLeadUpdate : micrositte order complete update throough webservice .
*  @input PlatForm TRStore_OrderService , @returns TRStoreResponse
*  As Part of  DLT-18248 
*  @description  updateMicrositeLeadOrder - map lead id and boolean value  
*  @param lid : Lead Id 
*  @param oc : boolean Value 
*  @return database.saveresult
*********************************************************************************************************/  

        public static database.saveresult updateMicrositeLeadOrder(id lid,  boolean oc){
            
           return database.update(new Lead(id=lid, TRstore_Microsite_Order_Completed__c = oc), false);
        
        }
    
/********************************************************************************************************
*  createOnlineContacts : creates online contacts for Proview products and update the same on cart(product configuration).
*  @input PlatForm TRStore_OrderService , @returns TRStoreResponse
*  As Part of  DLT-19047
*  @description  createOnlineContacts - Map online contact details  
*  @param olcList : main json to get online contacts 
*  @param refInfo : reference info 
*  @param custDetails : customer info 
*  @return list of TRStore_LeadRequest.OLCResponse 
*********************************************************************************************************/  

        public List<TRStore_LeadRequest.OLCResponse> createOnlineContacts(List<TRStore_LeadRequest.OnlineContactsFieldsClass> olcList, TRStore_LeadRequest.References refInfo, TRStore_LeadRequest.TRStorecustomerDetails custDetails){
            
            //String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;           
            List<TRStore_LeadRequest.OLCResponse> olcResponseList = new List<TRStore_LeadRequest.OLCResponse>();
                      
            system.debug(LoggingLevel.Info,'olcList json '+olcList);
            system.debug(LoggingLevel.Info,'refInfo.leadId '+refInfo.leadId);
            
            system.debug(LoggingLevel.Info,'After Id '+olcList);
              
            string customerType = 'EML PSWD CONTACT';
            if(Static_Values__c.getAll().containsKey('OlcCustomerType')){
                customerType = Static_Values__c.getValues('OlcCustomerType').value__c;
            }
            for(TRStore_LeadRequest.OnlineContactsFieldsClass olc : olcList){
                 
                 for(TRStore_LeadRequest.ProviewIds prids : olc.proviewProducts){
                      
                     Online_Contacts__c onlineContact = new Online_Contacts__c();
                     Customer_Master_Contacts__c ms = new Customer_Master_Contacts__c();
                        
                        onlineContact.First_Name__c = olc.pFirstName;
                        onlineContact.Last_Name__c = olc.pLastName;
                        onlineContact.Email__c = olc.pEmail;
                        onlineContact.WLEc_Juris__c = olc.jurisdiction;
                        onlineContact.Position__c = olc.pTitle;                        
                        onlineContact.Type__c = olc.pType;
                        onlineContact.Lead__c = refInfo.leadId;
                        onlineContact.Product_Configuration__c = refInfo.cartId;
                        onlineContact.Material__c = prids.pCode;
                        onlineContact.ProductId__c = prids.id;
                        
                        if((olc.proviewId == null || olc.proviewId == '') &&  olc.pEmail != null ){
                            onlineContactList.add(onlineContact);
                        }else{
                            onlineContact.id = olc.proviewId;
                            onlineContactList.add(onlineContact);
                        }
                        
                        ms.First_Name__c = olc.pFirstName;
                        ms.Last_Name__c = olc.pLastName;
                        ms.Email_Address__c = olc.pEmail;
                        ms.Lead__c = refInfo.leadId;
                        ms.Material__c = prids.pCode;
                        ms.Customer_Type_Description__c = customerType;
                        ms.Lead__c = refInfo.leadId;
                        
                        if(olc.pEmail != null){
                            masterContacts.add(ms);
                        }    
 
                 }
                     
            }
            system.debug(LoggingLevel.Info,'List of OLCs'+onlineContactList);
            olcResponseList = insertOnlineContactsAndMasterContacts(custDetails,refInfo);
            
           
         return olcResponseList;
        }   
    
/********************************************************************************************************
*  insertOnlineContactsAndMasterContacts : Method to insert the OLC amd Master contacts in SFDC .
*  @input TRStore_LeadRequest.TRStorecustomerDetails
*  As Part of  DLT-19626
*  @description  insertOnlineContactsAndMasterContacts - insert online contacts and master contacts  
*  @param custDetails : main json to get online contacts 
*  @param refInfo : reference info 
*  @return list of TRStore_LeadRequest.OLCResponse 
*********************************************************************************************************/
    private List<TRStore_LeadRequest.OLCResponse> insertOnlineContactsAndMasterContacts(TRStore_LeadRequest.TRStorecustomerDetails custDetails,TRStore_LeadRequest.References refInfo){
        List<TRStore_LeadRequest.OLCResponse> olcRespList = new List<TRStore_LeadRequest.OLCResponse>();
        if(!onlineContactList.isEmpty() && custDetails.isOLCAvailalble){               
             List< Database.UpsertResult> insertolc = new LIST<Database.UpsertResult>();
             List< Database.saveResult> insertmasterres = new LIST<Database.saveResult>();
            
                try{
                   
                   if(refInfo.leadId != null  && !masterContacts.isEmpty()){
                        deleteRecords(refInfo.leadId);
                   }
                   
                   
                   insertolc = database.upsert(onlineContactList, false); 
                   insertmasterres = database.insert(masterContacts, false); 
                }catch(exception e){
                    system.debug(LoggingLevel.INFO,'Exception came...........'+e);
                    //TRStoreLeadprocess.logTRSException('creation of OLC', 'Errors While Creation of OLC'+string.valueOf(e), 'OLC Create', refInfo.leadId, 'Lead', 'Lead Creation', supportEmail, true);
                    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of OLC'+string.valueOf(e),'webServiceName'=>'OLC Create','requestType'=>'Lead Creation','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Createlead','module'=>'TRStore','recId'=>refInfo.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                    TRStore_ErrorHandler.logException(errorHandlerMap);
                }
                system.debug(LoggingLevel.Info,'Create OLC Result..........'+insertolc);

                olcRespList = mapOLCResponse(insertolc,onlineContactList);
                
            }
        return olcRespList;
    }

/********************************************************************************************************
*  mapOLCResponse : Methodto map the OLC response in service .
*  @input list of OLC's
*  As Part of  DLT-19626
*  @description  mapOLCResponse  -  map olc response  
*  @param insertolc : upsert results 
*  @param onlineContactList : online contacts list
*  @return list of TRStore_LeadRequest.OLCResponse resp
*********************************************************************************************************/
    private List<TRStore_LeadRequest.OLCResponse> mapOLCResponse(List< Database.UpsertResult> insertolc,List<Online_Contacts__c> onlineContactList){
        List<TRStore_LeadRequest.OLCResponse> olcResList = new List<TRStore_LeadRequest.OLCResponse>();
        integer recNum = 0; 
                for(Database.UpsertResult upResult : insertolc){
                        olcResp = new TRStore_LeadRequest.OLCResponse();                 
                        if(upResult.isSuccess()){
                            olcResp.olcID = upResult.getId();
                            olcResp.olcStatus= TRStoreConstants.SUCCESS_STATUS;
                            if(onlineContactList.size() >= (recNum + 1)){
                               olcResp.olcEmailId = onlineContactList[recNum].Email__c ;   
                               olcResp.productCode = onlineContactList[recNum].Material__c;
                            }   
                        }
                        else{
                            olcResp.olcID =null;
                            olcResp.olcStatus= TRStoreConstants.FAILURESTATUS;
                            olcResp.olcStatusDetail = string.valueOf(upResult.getErrors());
                            for(Database.Error de: upResult.getErrors()){
                               if( de.getStatusCode() != null){
                                  
                                 olcResp.olcStatusDetail = string.valueOf(de.getStatusCode()) +' '+de.getMessage();
                               }  
                            }
                            
                            if(onlineContactList.size() >= (recNum + 1)){
                               olcResp.olcEmailId= onlineContactList[recNum].Email__c ; 
                            }     
                        }
                    ++recNum;
                    olcResList.add(olcResp);
                } 
        return olcResList;
    }
    
/********************************************************************************************************
*  DeleteMasterContacts : Method to delete master contacts .
*  @input lead record with master contacts
*  As Part of  DLT-19626
*  @description  deleteRecords  -  delete the existing master contacts 
*  @param lids  : lead ids 
*   
*********************************************************************************************************/  
    public static void deleteRecords(id lids){
        LIST<Customer_Master_Contacts__c > masterContacts = new LIST<Customer_Master_Contacts__c >();
        
        if(Schema.sObjectType.Customer_Master_Contacts__c.isAccessible()){
            masterContacts = [ Select id, name FROM Customer_Master_Contacts__c WHERE  Lead__c =: lids AND  Lead__c != null];
         
         
             Database.delete(masterContacts , false);
         }
    }
    
/********************************************************************************************************
*  queryLeadDetails: Common Method to query lead details based on email ID and cart ID
*  @input email ID, cart ID, boolean:isCreated, @returns List of Lead
*  As Part of  DLT-15904 
*  @description  queryLeadDetails  -  query lead details 
*  @param emailIdList : lead string  
*  @param cartList : Cart details 
*  @param isCreated : cart created Boolean 
*  @return : LIST<Lead> all leads 
*********************************************************************************************************/     
    public static List<Lead> queryLeadDetails(List<string> emailIdList, List<string> cartList,boolean isCreated){
        List<Lead> leadInfo= new List<Lead>();
        Set<String> microSitesSet = new set<String>();
      
        Schema.DescribeFieldResult fieldResult = lead.Lead_Microsite__c.getDescribe();
              
        for(Schema.PicklistEntry s:fieldResult.getPicklistValues()){
            if(s.getValue()!='TR Store')
            {
                microSitesSet.add(s.getValue());
                System.debug(loggingLevel.INFO,'value: '+s.getValue());
            }
          
        }
         
        system.debug(loggingLevel.INFO,'TRStore cart List....'+cartList);
         
        if(isCreated){
            if (Schema.sObjectType.Lead.isAccessible()){
                leadInfo = [SELECT Id, Name,firstname,city,street,state ,country, postalcode, Lead_Region__c, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c,Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c from
                           Lead WHERE ( Email In: emailIdList OR Product_Configuration__c IN: cartList) and Lead_Microsite__c Not IN : microSitesSet AND Status != 'Disqualified' AND isConverted = false];
            
            }
        }else{
            if (Schema.sObjectType.Lead.isAccessible()){  
                system.debug(loggingLevel.INFO,'lead id from PE'+emailIdList);
                leadInfo = [SELECT Id, Name,firstname,city,street,state ,Lead_Region__c,country,postalcode, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c, Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c from Lead WHERE Id In: emailIdList AND Product_Configuration__c IN: cartList] ;
            }
        }
        
        system.debug(LoggingLevel.Info,'leadInfo'+leadInfo);
        return leadInfo;
        
    }
}