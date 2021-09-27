/* Class: TRStoreLeadprocess
* Purpose: to process the request from TRStore_OrderRequest and proform action like create update convert and account check
* Created: 5/13/2019
* Author: Rohit Sharma
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2019-05-13   Rohit Sharma     DLT-15907   Lead creation 
* 2019-05-30   Rohit Sharma     DLT-15909   Lead Conversion 
* 2019-06-14   Mallikarjuna     DLT-15904   Retrieve Lead Information
* 2019-06-25   Rohit Sharma     DLT-16334   Create Opp and Map AccSSd for Order Creation
* 2019-09-05   Mallikarjuna Rao DLT-17544   updated code for billing and shipping address are different and 
*                                           while converting lead create multiple SSDs
* 2019-09-07   Ameeta Antonio   DLT-17674   Lead Conversion for Existing User with Different shipping SSD
* 2019-11-18   Mallikarjuna Rao DLT-18131   MicrositeLead changes...update Lead origin and charge codes 
* 2019-12-19   Kanishk Singhvi  DLT-18765   Conditions added for mapping data on SSD fields for US Legal
* 2019-12-30   Ameeta Antonio   DLT-19047   Creation of Proview Online Contact 
* 2020-01-16   Kanishk Singhvi  DLT-19076   Lead convert Validations. Update integration logger
* 2020-02-18   Mallik           DLT-19262   Proview entitlements 
* 2020-02-27   Kanishk Singhvi  DLT-19615   Shipping phone number, Street line two
* 2020-03-19   Ameeta Antonio   DLT-19592   Added Shipping First&Last Name related changes
* 2020-04-20   Avudaiappan A    DUE-1607    Added an additional parameter 'LeadOriginSite' in request
* 2020-07-17   Mallik           DLT-20359   Getting error while creating opportunity for existing users on currencyISO code. Making changes on populating currency ISO code while opty create
* 2020-08-26   Kanishk          DLT-20541   Opportunity record type GLI fix, null pricebook after conversion fixed
* =============================================================================
*/

global with sharing class TRStoreLeadprocess{
    
    /********************************************************************************************************
* CreateLead: Method to create & update lead information.
*  @input Customer info/details, @returns TRStoreResponse
*********************************************************************************************************/  
    public static TRStore_OrderRequest.TRStoreResponse createLead(TRStore_OrderRequest.TRstoreOrders trStoreOrder)
    {
        
        TRStore_OrderRequest.TRStoreResponse  resp = new TRStore_OrderRequest.TRStoreResponse();
        List<TRStore_OrderRequest.OLCResponse> olcResult;
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        LIST<Lead> leads = new LIST<Lead>();
        LIST<String> emailIds = new LIST<String>();
        LIST<String> cartIds = new LIST<String>();
        
        
        string emailId='';
        string cartId='';
        string leadOrigin='';
        
        if(trStoreOrder.OrderDetails != null){
            
            TRStore_OrderRequest.micrositeFieldsClass leadMicrositeInfo = trStoreOrder.OrderDetails.micrositeFields;     
                 
                system.debug(loggingLevel.INFO,'Hello microsite Fields............'+leadMicrositeInfo);
                if(leadMicrositeInfo != null){
                    if(leadMicrositeInfo.leadOriginCode != null){
                    system.debug(loggingLevel.INFO,'static values'+Static_Values__c.getAll().containsKey(leadMicrositeInfo.leadOriginCode));
                    system.debug(loggingLevel.INFO,'static values'+Static_Values__c.getAll().values());
                        if(Static_Values__c.getAll().containsKey(leadMicrositeInfo.leadOriginCode) ){
                            leadOrigin = Static_Values__c.getAll().get(leadMicrositeInfo.leadOriginCode).value__c;
                        }
                    }   
                }
  
            if(trStoreOrder.OrderDetails.customerDetails != null){
                TRStore_OrderRequest.TRStorecustomerDetails leadInfo = trStoreOrder.OrderDetails.customerDetails;     
                if(leadInfo != null){  
                    emailIds.add(leadInfo.businessEmail);
                }
                
                TRStore_OrderRequest.References refInfo = trStoreOrder.referencesDetails;  
                if(refInfo != null){
                    if(refInfo.cartId != null){
                        cartIds.add(refInfo.cartId);
                    }
                }
                
            }
            
            
        }         
        
        MAP<string, id> existingLeads = new MAP<string, id>();
        
        system.debug(loggingLevel.INFO,'Lead Origin'+leadOrigin);
        // if condition for origion
        if(leadOrigin.equals('TR Store'))
        {
            
            for(Lead l: queryLeadDetails(emailIds, cartIds,true)){
                if(!l.isconverted){
                    existingLeads.put(l.email, l.id);
                    if(l.Product_Configuration__c != null){
                        existingLeads.put(l.Product_Configuration__c , l.id);
                    }    
                }
            } 
        }
        system.debug(loggingLevel.INFO,'Existing LEads'+existingLeads.keySet());
        lead lead = new Lead();
        
        //DLT-17900 adding owner id and record type for creating lead. 
        LIST<User> aemConnectUsers = new List<User>();
        if(Static_Values__c.getAll().get('LeadOwnerGroupId') != null && Schema.sObjectType.user.isAccessible()){
            string aemUserName = Static_Values__c.getAll().get('LeadOwnerGroupId').Value__c;
            aemConnectUsers = [select id, userName from user where userName =: aemUserName ];
        }
        
        if(trStoreOrder.OrderDetails != null){
            if(trStoreOrder.OrderDetails.customerDetails != null){
                TRStore_OrderRequest.TRStorecustomerDetails leadInfo = trStoreOrder.OrderDetails.customerDetails;     
                
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
                    if(!aemConnectUsers.isEmpty()){
                        lead.ownerId = aemConnectUsers[0].id; 
                    }
                }
                
                if(trStoreOrder.OrderDetails.isExistingCustomer != null){
                    lead.TRStore_Existing_Customer__c = trStoreOrder.OrderDetails.isExistingCustomer;
                }
                
                if(trStoreOrder.OrderDetails.LeadsourceCountryCode != null){
                    if(trStoreOrder.OrderDetails.LeadsourceCountryCode == 'US'){
                        lead.Lead_Region__c = (String.isNotBlank(trStoreOrder.OrderDetails.LeadOriginSite) && trStoreOrder.OrderDetails.LeadOriginSite.equalsIgnoreCase('TPRO'))?'TR Store Tax Professional':'TR Store US Print';
                        lead.Primary_Campaign_Source__c = Static_Values__c.getAll().get('SFDCCampaignIdUS').value__c;  
                        lead.Tracking_Code__c = Static_Values__c.getAll().get('Hive9CodeUS').Value__c;   
                    }else if(trStoreOrder.OrderDetails.LeadsourceCountryCode == 'CA' && trStoreOrder.OrderDetails.LeadOriginSite.equalsIgnoreCase('CAPR')){
                        lead.Lead_Region__c = 'TR Store Canada Print';
                        lead.Primary_Campaign_Source__c = Static_Values__c.getAll().get('SFDCCampaignIdCA').value__c;  
                        lead.Tracking_Code__c = Static_Values__c.getAll().get('Hive9CodeCA').Value__c;   
                    }    
                    
                }
                
                TRStore_OrderRequest.micrositeFieldsClass leadMicrositeInfo = trStoreOrder.OrderDetails.micrositeFields;                      
                system.debug(loggingLevel.INFO,'Hello microsite Fields............'+leadMicrositeInfo);
                if(leadMicrositeInfo != null){                
                    if(leadMicrositeInfo.leadOriginCode != null){
                        if(Static_Values__c.getAll().containsKey(leadMicrositeInfo.leadOriginCode) ){     
                            lead.Lead_Microsite__c = Static_Values__c.getAll().get(leadMicrositeInfo.leadOriginCode).value__c;
                        }
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
                
                if(leadInfo.organizationDetails != null ) {
                    TRStore_OrderRequest.TRStoreAccountDetails accountdetails = leadInfo.organizationDetails ;
                    lead.SAPAccountNumber__c = accountdetails.AccountANumber;
                    lead.company = accountdetails.organizationName;
                    
                    if(accountdetails.organizationType != null){
                        lead.Market_Segment__c = accountdetails.organizationType;
                    }
                    
                    if(accountdetails.billingAddress != null){                       
                        TRStore_OrderRequest.customerAddress billingaddress = accountdetails.billingAddress;     
                        
                        lead.Billing_Street__c = billingaddress.street1;
                        lead.Billing_Street_2__c = billingaddress.street2;
                        lead.Billing_City__c = billingaddress.city;
                        lead.Billing_State__c = billingaddress.state;
                        lead.Billing_Country__c = billingaddress.country;
                        lead.Billing_Zip__c = billingaddress.zipCode;
                        
                    }     
                }
                
                if(leadInfo.shippingAddress != null){                       
                    TRStore_OrderRequest.customerAddress shippingAddress = leadInfo.shippingAddress;     
                    
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
                
                TRStore_OrderRequest.References refInfo = trStoreOrder.referencesDetails;  
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
                    if(existingLeads.containsKey(lead.Product_Configuration__c) ){
                        lead.id = existingLeads.get(lead.Product_Configuration__c);
                    }else if(existingLeads.containsKey(lead.email)){
                         lead.id = existingLeads.get(lead.email);
                    }
                       
                }
                
                 //check leadid from request and update only for microsites 
                leads.add(lead); 
                
                //DLT-19047-get the proview contact details from request and cretae online contacts 
                List<TRStore_OrderRequest.OnlineContactsFieldsClass> olcInfo = trStoreOrder.OrderDetails.proviewContacts;
                
                olcResult = new List<TRStore_OrderRequest.OLCResponse>();
                
                try{
                    system.debug(LoggingLevel.INFO,'olcInfo...............'+leadInfo.isOLCAvailalble+'     '+olcInfo);                
                    if(!olcInfo.isEmpty() && leadInfo.isOLCAvailalble){
                        olcResult = createOnlineContacts(olcInfo, refInfo, leadInfo); 
                    }
                    //End DLT-19047-get the proview contact details from request and create online contacts 
                }catch(exception e){
                    system.debug(LoggingLevel.INFO,'Error in processing onlinecontacts'+e);
                    logTRSException('Lead create process', 'Error in processing onlinecontacts'+string.valueOf(e), 'createNewLead', refInfo.leadId, 'Lead', 'Lead Creation', supportEmail, true);
                }  
            }               
        }
        system.debug(LoggingLevel.Info,'List of Leads'+leads);
        List< Database.UpsertResult> ipr = new LIST<Database.UpsertResult>();
        try{
             
            ipr = database.upsert(leads);
            
        }catch(exception e){
            system.debug(LoggingLevel.INFO,'Exception came...........'+e);
            resp.leadId ='';
            resp.responseStatus= TRStoreConstants.FAILURESTATUS;
            resp.responseCode= TRStoreConstants.ERROR_CODE;
            
            if(e != null){
                resp.statusDetail = string.valueOf(e);
                logTRSException('Lead create process', 'Errors While Creation of Lead'+string.valueOf(e), 'createNewLead', resp.leadId, 'Lead', 'Lead Creation', supportEmail, true);
            }
        }
        system.debug(LoggingLevel.Info,'Leads upsert Result..........'+ipr);
         
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
        resp.onlineContactsResponse = olcResult;
        System.debug(LoggingLevel.INFO,'resp '+resp);
        return resp; 
    }      


/********************************************************************************************************
*  MicrositeLeadUpdate : micrositte order complete update throough webservice .
*  @input PlatForm TRStore_OrderService , @returns TRStoreResponse
*  As Part of  DLT-18248 
*********************************************************************************************************/  

        public static database.saveresult updateMicrositeLeadOrder(id lid,  boolean oc){
            
           return database.update(new Lead(id=lid, TRstore_Microsite_Order_Completed__c = oc), false);
        
        }
    
/********************************************************************************************************
*  createOnlineContacts : creates online contacts for Proview products and update the same on cart(product configuration).
*  @input PlatForm TRStore_OrderService , @returns TRStoreResponse
*  As Part of  DLT-19047
*********************************************************************************************************/  

        public static List<TRStore_OrderRequest.OLCResponse> createOnlineContacts(List<TRStore_OrderRequest.OnlineContactsFieldsClass> olcList, TRStore_OrderRequest.References refInfo, TRStore_OrderRequest.TRStorecustomerDetails custDetails){
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();
            LIST<Customer_Master_Contacts__c> masterContacts = new LIST<Customer_Master_Contacts__c>();
            String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;           
            List<TRStore_OrderRequest.OLCResponse> olcResponseList = new List<TRStore_OrderRequest.OLCResponse>();
                      
            system.debug(LoggingLevel.Info,'olcList json '+olcList);
            
            string customerType = 'EML PSWD CONTACT';
            if(Static_Values__c.getAll().containsKey('OlcCustomerType')){
                customerType = Static_Values__c.getValues('OlcCustomerType').value__c;
            }
            for(TRStore_OrderRequest.OnlineContactsFieldsClass olc : olcList){
                 
                 for(TRStore_OrderRequest.proviewIds  prids : olc.proviewProducts){
                      
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
                        /* onlineContact.Account__c
                           onlineContact.Product_Description__c
                           onlineContact.QuoteLineItem__c
                           onlineContact.APTS_Source_System_Detail__c
                        */
                        if(olc.proviewId == null || olc.proviewId == ''){
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
                       // ms.Phone__c
                        
                        masterContacts.add(ms);
                        
                     
                 }
                     
            }
            system.debug(LoggingLevel.Info,'List of OLCs'+onlineContactList);
            if(!onlineContactList.isEmpty() && custDetails.isOLCAvailalble){               
             List< Database.UpsertResult> insertolc = new LIST<Database.UpsertResult>();
             List< Database.saveResult> insertmasterres = new LIST<Database.saveResult>();
             
             TRStore_OrderRequest.OLCResponse olcResp;
                
                try{
                   
                   if(refInfo.leadId != null  && !masterContacts.isEmpty()){
                        deleteRecords(refInfo.leadId);
                   }
                   
                   
                   insertolc = database.upsert(onlineContactList, false); 
                   insertmasterres = database.insert(masterContacts, false); 
                }catch(exception e){
                    system.debug(LoggingLevel.INFO,'Exception came...........'+e);
                    logTRSException('creation of OLC', 'Errors While Creation of OLC'+string.valueOf(e), 'OLC Create', refInfo.leadId, 'Lead', 'Lead Creation', supportEmail, true);
                }
                system.debug(LoggingLevel.Info,'Create OLC Result..........'+insertolc);
                integer recNum = 0; 
                for(Database.UpsertResult upResult : insertolc){
                        olcResp = new TRStore_OrderRequest.OLCResponse();                 
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
                    olcResponseList.add(olcResp);
                }  
            }
           
         return olcResponseList;
        }   

/********************************************************************************************************
*  DeleteMasterContacts : Method to delete master contacts .
*  @input lead record with master contacts
*  As Part of  DLT-19626
*********************************************************************************************************/  
    public static void deleteRecords(id lids){
        LIST<Customer_Master_Contacts__c > masterContacts = new LIST<Customer_Master_Contacts__c >();
        
        if(Schema.sObjectType.Customer_Master_Contacts__c.isAccessible()){
            masterContacts = [ Select id, name FROM Customer_Master_Contacts__c WHERE  Lead__c =: lids AND  Lead__c != null];
         
         
             Database.delete(masterContacts , false);
         }
    }
    
    
/********************************************************************************************************
*  ConvertLead: Method to Convert lead through webservice .
*  @input PlatForm Event Record , @returns TRStoreResponse
*  As Part of  DLT-17328 
*********************************************************************************************************/  
    
    public static TRStore_OrderRequest.TRStoreResponse convertLead(id leadId, id cartId, string emailId, string westAccNumber){
               
        TRStore_OrderRequest.TRStoreResponse  resp = new TRStore_OrderRequest.TRStoreResponse();
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        System.debug(LoggingLevel.Info,'WESTACCNO:'+westAccNumber+'leadId:'+leadId+'cartId:'+cartId+'emailId:'+emailId);
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        if(leadId != null&& cartId!=null){
        System.debug(LoggingLevel.Info,'WESTACCNO:'+westAccNumber+'leadId:'+leadId+'cartId:'+cartId+'emailId:'+emailId);
            try{  
                system.debug(LoggingLevel.Info,'ConvertLead started');
                LIST<string> leadIds = new LIST<string>();
                LIST<string> cartIds = new LIST<string>();
                String leadOrigon ='';
                Lead leadToCheck = new lead();
                leadIds.add(leadId);
                cartIds.add(cartId);
                List<Lead> leadsList = new List<Lead>();
                List<Lead> allLeadsList = new List<Lead>();
                allLeadsList = queryLeadDetails(leadIds,cartIds, false);
                if(!allLeadsList.isEmpty()){
                    for(Lead lea:allLeadsList){
                        leadOrigon=lea.Lead_Microsite__c;
                        //enhanced as part of April elease DLT-19744
                        if(!lea.isconverted && (lea.Lead_Microsite__c=='TR Store' || lea.Lead_Microsite__c=='PWC' || lea.Lead_Microsite__c=='Deloitte')){ 
                            leadsList.add(lea); 
                        }
                    }
                }
                
                system.debug(loggingLevel.INFO,'List of lead '+leadsList);
                
                List<String> ssdListToQuery = new List<String>();
                
                if(!leadsList.isEmpty() || leadsList.size()>0){
                    for(Lead le : leadsList){
                        if(le.SAPAccountNumber__c != null){
                            ssdListToQuery.add(le.SAPAccountNumber__c);
                            WestAccNumber = String.isNotBlank(westAccNumber)?westAccNumber:le.SAPAccountNumber__c;
                        }
                        if(le.ShipToSSD_TRStore__c != null){
                            ssdListToQuery.add(le.ShipToSSD_TRStore__c);
                        }
                        leadToCheck = le;
                    }
                    system.debug(loggingLevel.INFO,'@@West Account Number:'+westAccNumber);
                    if(westAccNumber != null && String.isNotBlank(westAccNumber))
                    {
                        LIST<Lead> leads = new LIST<Lead>();
                        List<Source_System_Detail__C> ssdList = new  List<Source_System_Detail__C>();
                        List<LCRM_Contact_SSD__c> contactsSSDList =new List<LCRM_Contact_SSD__c>();  
                        ReferenceDetails refDet = new ReferenceDetails();
                        
                        id conID;                       
                        string accName='';
                        
                        Map<String,Source_System_Detail__C> SSDMap = new Map<String,Source_System_Detail__C> ();
                        Source_System_Detail__C  ssdrec = new Source_System_Detail__C();
                        String sapAccNo = westAccNumber;
                        system.debug(loggingLevel.INFO,'SAP Account Number:'+sapAccNo);
                        ssdList = querySSDDDetails(ssdListToQuery); 
                        system.debug(loggingLevel.INFO,'SSD List:'+ssdList);
                        if(ssdList!=null && ssdList.size()>0){
                            for(Source_System_Detail__C ssd : ssdList){
                                if(leadToCheck.SAPAccountNumber__c == ssd.Source_System_Account_Number__c){
                                    ssdrec = ssd; 
                                    refDet.accountSSDId = ssd.id;
                                }
                                if(leadToCheck.ShipToSSD_TRStore__c == ssd.Source_System_Account_Number__c){
                                    refDet.accountShippingSSDId = ssd.id;
                                }
                            }
                            
                            if(String.isBlank(leadToCheck.ShipToSSD_TRStore__c) && String.isNotBlank(WestAccNumber) && !ssdList.isEmpty()){
                                    SSDMap = createNewSSD(leadToCheck,ssdList[0].Account_Name__c,ssdList[0].Account_Name__r.Name,true);
                                    if(!SSDMap.isEmpty()){
                                         if(SSDMap.get('ShipTo') != null){
                                            refDet.accountShippingSSDId = SSDMap.get('ShipTo').Id;
                                            refDet.shippingSSDRec = SSDMap.get('ShipTo');  
                                        }
                                    }
                                }
                        }
                        
                        conID = queryContactSSDs(emailId,ssdrec,leadToCheck);  
                        if(conID != null){
                            system.debug(LoggingLevel.Info,'ssdList  '+ssdList+' conId  '+conID );
                            resp = commonConvertLead(ssdrec, conID, leadsList, refDet);
                        }
                        
                    }
                    else{
                        
                        //Call to create new account and new contact 
                        system.debug(loggingLevel.INFO,'creation of Account started ');
                        
                        for(lead l: leadsList){
                            system.debug(loggingLevel.INFO,'Lead Details.......'+l);

                            Savepoint sp1 = Database.setSavepoint();
                            ReferenceDetails accResult = createNewAccount(l);
                            system.debug(loggingLevel.INFO,'New Account Details->>'+accResult + 'ship ssd ID' +accResult.accountShippingSSDId);
                            if (accResult.convertedAccId != null){
                                system.debug(loggingLevel.INFO,'New Account Details->>'+accResult.convertedAccId);
                                ReferenceDetails conResult = createNewContact(l, accResult);
                                system.debug(loggingLevel.INFO,'New Contact Details->>'+conResult );
                                if (conResult.convertedConId == null){
                                    Database.rollback(sp1);
                                    if(conResult.recordResult != null){
                                        logTRSException('Lead convert process '+l.Id, 'Errors While Creation of Contact' + String.valueOf(conResult.recordResult.getErrors()), 'createNewContact', l.Id, 'Lead', 'Contact Creation', supportEmail, true);
                                    }    
                                }
                                system.debug(loggingLevel.INFO,'refrences '+accResult+' and '+conResult);
                                resp = commonConvertLead(accResult.ssdRec, conResult.convertedConId, leadsList, accResult);
                            }
                            
                            
                        }
                     
                    }
                    
                }
                else{
                    system.debug(loggingLevel.INFO,'convertion failed. lead list is null ');
                    logTRSException('Lead convert process '+cartId, 'convertion failed. lead list is null', 'Lead Convert', leadId, 'Lead', 'Lead Convert', supportEmail, true);
                }
                
            }catch(Exception e){
                system.debug(loggingLevel.INFO,'Error '+e);
                logTRSException('Lead convert process '+cartId, string.valueof(e), 'Lead Convert', leadId, 'Lead', 'Lead Conversion', supportEmail, true);
            }  
           
        }
        else{
            system.debug(loggingLevel.INFO,'convertion failed cartId or leadId is null ');
            logTRSException('Lead convert process '+cartId, 'convertion failed cartId or leadId is null', 'Lead Convert', leadId, 'Lead', 'Lead Conversion', supportEmail, true);
        }
        return resp;
    }    
    //End of Lead Convert from Custom Service 
    
    public static TRStore_OrderRequest.TRStoreResponse commonConvertLead(Source_System_Detail__C ssdRec, Id conId, List<Lead> leads, ReferenceDetails refDetails){
        TRStore_OrderRequest.TRStoreResponse  resp = new TRStore_OrderRequest.TRStoreResponse();    
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;            
        id accID;        
        id oppID;
        string accName='';
        
        if(ssdRec.id != null && conId != null ){
            
            accID = ssdRec.Account_Name__c;
            //accName=ssdRec.Account_Name__r.name;
            accName=ssdRec.name;
            system.debug(LoggingLevel.INFO,'accID'+accID+'accName'+accName);
            system.debug(LoggingLevel.INFO,'ssdrec'+ssdRec);
            
            oppID =  createOppty(accName,accID,conId,ssdrec.id, refDetails, ssdRec);
            system.debug(LoggingLevel.INFO,'oppID'+oppID);
            
            if(ssdRec.Source_System_Account_Number__c !=null){
                database.update(new Opportunity(id=oppId, Has_SSD_Currency__c= false), false);
            }
            
            if(oppID!=null){
                LeadStatus cs;
                if (Schema.sObjectType.LeadStatus.isAccessible())
                {
                    cs = [Select Id, MasterLabel from LeadStatus where IsConverted=true AND MasterLabel LIKE 'Sales%' limit 1];                         
                }    
                for(lead l : leads)
                {
                    system.debug(LoggingLevel.INFO,'is Lead converted '+l.isConverted );
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(l.id);
                    
                    
                    lc.setConvertedStatus(cs.MasterLabel);
                    if(accID !=null){
                        lc.setAccountId(accID);
                    }                                                                      
                    if(conId != null){
                        lc.setContactId(conID);
                    }
                    if(oppID != null){
                        lc.setOpportunityId(oppID);
                    }
                    
                    
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    system.debug(LoggingLevel.Info,'Converted Lead Details.........'+lcr);
                    
                    String priceBookName = Static_Values__c.getValues('PriceBookName').Value__c;    
                    
                    if(!Schema.sObjectType.pricebook2.fields.name.isAccessible()){  
                        return null;    
                    }   
                    List<pricebook2> priceBookList = new List<pricebook2>();
                    if(Schema.sObjectType.pricebook2.isAccessible()){
                        priceBookList  = [SELECT id FROM pricebook2 WHERE name =: priceBookName LIMIT 1];   
                    }
                    
                    List<Opportunity> oppty = new List<Opportunity>();
                    if(Schema.sObjectType.Opportunity.isAccessible()){
                        oppty = [select pricebook2id from Opportunity where Id =: oppID];
                    }
                    
                    if(priceBookList!=null && priceBookList.size() > 0 ) {   
                        for(pricebook2 pb : priceBookList){ 
                            oppty[0].Pricebook2Id=pb.id;  
                        }   
                    } 
                    database.update(new Opportunity(id=oppId, pricebook2id = oppty[0].pricebook2id), false);
                    
                    if(lcr.isSuccess()){
                        resp.convertedAccID=lcr.getAccountId();
                        resp.convertedOppID= lcr.getOpportunityId();
                        resp.convertedConID= lcr.getContactId();
                        resp.responseCode=TRStoreConstants.SUCCESS_CODE;
                        resp.responseStatus='converted successfully';
                        
                    }
                    else{ // conversion fail
                        resp.responseCode=TRStoreConstants.ERROR_CODE;
                        resp.responseStatus='convertion failed';
                        String dbErrors = null;
                        for(Database.Error de: lcr.getErrors()){
                           if( de != null){
                               dbErrors = dbErrors + de; 
                           }  
                        }
                        logTRSException('Lead convert process', dbErrors, 'Lead Convert', lcr.leadId, 'Lead', 'Lead Conversion', supportEmail, true);
                    }
                    
                }  
            }
            else  // no lead found or fail to create oppty
            {
                resp.responseCode=TRStoreConstants.ERROR_CODE;
                resp.responseStatus='No Lead found or fail to create oppty';
                logTRSException('Lead convert process', resp.responseStatus, 'Lead Convert', String.valueOf(leads), 'Lead', 'Lead Conversion', supportEmail, true);
            }
            
        }
        else{
            resp.responseCode=TRStoreConstants.ERROR_CODE;
            resp.responseStatus='convertion failed as your email or account is incorrect.';  
            logTRSException('Lead convert process', resp.responseStatus, 'Lead Convert', String.valueOf(leads), 'Lead', 'Lead Conversion', supportEmail, true);                      
        }
        return resp;
    }
    
    /********************************************************************************************************
*  CreateOppty: Method to create oppty and map AccSSd.
*  @input name , accID , ConID, SSDid , @returns Opportunity ID
*  As Part of  DLT-16334 
*********************************************************************************************************/  
   public static id createOppty(string accName , id accID , id conID , id accSsd, ReferenceDetails rd , Source_System_Detail__C ssdRec){    
        system.debug(loggingLevel.INFO,'opp details'+accName +' '+ accID+' '+conID+' '+accSsD); 
        String priceBookName = Static_Values__c.getValues('PriceBookName').Value__c;    
            
        string opportunityRecordTypeName = 'GLI_Pipeline_Opportunity';    
            
        if(Static_Values__c.getAll().containsKey('opportunityRecordTypeName')){ 
            opportunityRecordTypeName = Static_Values__c.getValues('opportunityRecordTypeName').Value__c ;  
        }   
     
            
        if(!Schema.sObjectType.pricebook2.fields.name.isAccessible()){  
            return null;    
        }   
        List<pricebook2> priceBookList = new List<pricebook2>();
        if(Schema.sObjectType.pricebook2.isAccessible()){
            priceBookList  = [SELECT id FROM pricebook2 WHERE name =: priceBookName LIMIT 1];   
        }
        Opportunity op = new Opportunity(); 
        op.name=accName;    
            
        op.AccountId=accID; 
        op.Key_Contact__c=conID;    
        op.Source_System_Detail__c=accSsd;  
        op.StageName='Appointment Scheduled';   
        op.CloseDate=System.Today() + 30;   
        op.Reason__c = 'Digital';   
        op.Was_There_a_Competitor__c = 'No';    
        op.Operating_Unit__c = 'Print';
       
        op.Is_GLI__c = True;  
            
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(opportunityRecordTypeName).getRecordTypeId() != null){    
            op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(opportunityRecordTypeName).getRecordTypeId();  
        }
       
        if(rd != null){ 
            if(rd.accountShippingSSDId !=null){ 
                op.ShipTo_Source_System_Detail__c = rd.accountShippingSSDId;    
            }   
        }   
            
        if(ssdRec.Source_System_Account_Number__c !=null){  
            try{    
                if(Schema.sObjectType.Account.isAccessible()){  
                    Account accrec = [Select id, Name, BU_Region__c, Bu_Segment__c From Account WHERE id =: accId ];    
                        
                    if(accrec.BU_Region__c != null){    
                        op.LCRM_Sub_BU__c = accrec.BU_Region__c ;   
                    }   
                    if(accrec.Bu_Segment__c != null){   
                        op.BU_Segment__c = accrec.Bu_Segment__c ;   
                    }   
                 }  
            }catch(exception e){ }      
        }   
        
            
      /*    
        if(ssdRec.Billing_Currency__c != null)  
             op.CurrencyIsoCode = ssdRec.Billing_Currency__c;   
     */                 
            
        //op.OwnerId=Static_Values__c.getAll().get('LeadConvertOwnerId').Value__c;  
        if(priceBookList!=null && priceBookList.size() > 0 ){   
            for(pricebook2 pb : priceBookList){ 
                op.Pricebook2Id=pb.id;  
            }   
                
        }   
        system.debug(LoggingLevel.Info,'Hello Opportunity insert at line 707.......'+op);   
            
        database.insert(op);    
            
        system.debug(LoggingLevel.Info,'Hello Opportunity insert at line 711.......'+op);   
            
        return op.id;   
    }
    
    /********************************************************************************************************
*  queryLeadDetails: Common Method to query lead details based on email ID and cart ID
*  @input email ID, cart ID, boolean:isCreated, @returns List of Lead
*  As Part of  DLT-15904 
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
         
        system.debug('TRStore cart List....'+cartList);
         
        if(isCreated){
            if (Schema.sObjectType.Lead.isAccessible()){
                leadInfo = [SELECT Id, Name,firstname,city,street,state ,country, postalcode, Lead_Region__c, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c,Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c from
                           Lead WHERE ( Email In: emailIdList OR Product_Configuration__c IN: cartList) and Lead_Microsite__c Not IN : microSitesSet ];
            
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
    
    /********************************************************************************************************
*  querySSDDDetails: Common Method to query Account SSD details
*  @input SAP Account Number, @returns List of SSD
*  As Part of  DLT-15904 
*********************************************************************************************************/   
    public static List<Source_System_Detail__C> querySSDDDetails(List<String> sapAcc) {
        
        List<Source_System_Detail__C> ssdList = new  List<Source_System_Detail__C>([Select id , name  ,Account_Name__c,Source_System_Account_Number__c ,Account_Name__r.name, Billing_Currency__c from Source_System_Detail__C where Source_System_Account_Number__c IN:sapAcc limit 1 ]);
        system.debug(LoggingLevel.Info,'ssdList'+ssdList);
        return  ssdList;
    }
    
    /********************************************************************************************************
*  queryContactSSDs: Method to query Contact SSD details
*  @input contact email, @returns contact Id
*  As Part of  DLT-15904 
*********************************************************************************************************/
    public static id queryContactSSDs(string conEmail, Source_System_Detail__c ssd, Lead leadrec){
        system.debug(LoggingLevel.Info,'conEmail...........'+ conEmail);

        List<Contact> contactList = new  List<Contact>([Select id , name, Email,AccountId FROM Contact WHERE Email =: conEmail AND AccountId =: ssd.Account_Name__c limit 1]);
        system.debug(LoggingLevel.Info,'ContactList...........'+ contactList);
        
        id conId;
        
        if(!contactList.isEmpty()){
            for(Contact cont : contactList){          
                conID = cont.id ;
                system.debug(LoggingLevel.Info,'conid'+conID);         
            }
        }else{
            
            ReferenceDetails accDetails = new ReferenceDetails();
            accDetails.convertedAccId = ssd.Account_Name__c;
            ReferenceDetails conDetails = createNewContact(leadrec, accDetails);
            conId = conDetails.convertedConId;
        }
        
        return conId;       
    }
    
    /********************************************************************************************************
*  checkAccountStatus: Method to Retrieve Source System Details for the West Account check
*  @input account number,postal code,Lead Id , @returns TRStoreResponse
*  As Part of  DLT-15904 
*********************************************************************************************************/ 
    public static TRStore_OrderRequest.TRStoreResponse  checkAccountStatus(string accNumber, string postalcode, string leadId){
        
        LIST<Source_System_Detail__c> ssdList = new LIST<Source_System_Detail__c>();
        string querystring = '';
        postalcode = '%'+postalCode +'%';
        
        if(postalcode != null){
            if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                ssdList = [Select Id, Name, Source_System_Account_Number__c, Postal_Code__c From Source_System_Detail__c WHERE Source_System_Account_Number__c =: accNumber OR Postal_Code__c LIKE: postalcode];
            }
        }else{
            if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                ssdList = [Select Id, Name, Source_System_Account_Number__c, Postal_Code__c From Source_System_Detail__c WHERE Source_System_Account_Number__c =: accNumber];            
            }
        }
        
        
        system.debug(LoggingLevel.Info,'Account Check List'+ssdList);
        TRStore_OrderRequest.TRStoreResponse resp= new TRStore_OrderRequest.TRStoreResponse();
        
        if(!ssdList.isEmpty()){
            //Success 
            resp.responseCode = TRStoreConstants.SUCCESS_CODE;
            resp.responseStatus = 'Success';
            resp.LeadId = leadId;
            resp.statusDetail = 'We found Account details in Salesforce.';
        }else{
            //No Account found
            resp.responseCode = TRStoreConstants.SUCCESS_CODE;
            resp.responseStatus = 'Data not found';
            resp.LeadId = leadId;
            resp.statusDetail = Static_Values__c.getValues('SSDNotFound').value__c;  
            
        }
        
        return resp;
    }
    
    public static ReferenceDetails createNewAccount(lead l){
        
        ReferenceDetails refDetails = new ReferenceDetails();
        Map<String, Source_System_Detail__c> sSDMap = new  Map<String, Source_System_Detail__c>();
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        try{
            Account oAccount = new Account();
            oAccount.Name = l.company; 
            oAccount.Email__c = l.Email;
            oAccount.Phone = l.Phone;
            oAccount.BillingCity = l.Billing_City__c; 
            oAccount.BillingStreet = l.Billing_Street__c;
            oAccount.BillingState = l.Billing_State__c;
            oAccount.BillingCountry = l.Billing_Country__c;
            oAccount.BillingPostalCode = l.Billing_Zip__c;
            oAccount.CurrencyIsoCode = (l.Lead_Region__c=='TR Store Canada Print')? 'CAD' : 'USD' ;
            database.saveresult accSaveRes = database.insert(oAccount, false);
            
            system.debug(loggingLevel.INFO, 'error in acc creation' +accSaveRes.errors + oAccount);
            if(accSaveRes.isSuccess()) {
                sSDMap = createNewSSD(l, oAccount.id,oAccount.Name, false);
            }else{
                System.debug(loggingLevel.INFO, 'Create New Account failed >>>'+String.valueOf(accSaveRes.getErrors()));
                logTRSException('Lead convert process '+l.Id, 'Errors While Creation of Account' + String.valueOf(accSaveRes.getErrors()), 'createNewAccount', l.Id, 'Lead', 'Account Creation', supportEmail, true);
            }
            
            refDetails.convertedAccId = oAccount.id;
            if(!sSDMap.isEmpty()){
                refDetails.accountSSDId = sSDMap.get('BillTo').Id;
                refDetails.ssdRec = sSDMap.get('BillTo');
                    if(l.TRstore_Billadd_differenceto_shipping__c){
                        if(sSDMap.get('ShipTo') != null){
                          refDetails.accountShippingSSDId = sSDMap.get('ShipTo').Id;
                          refDetails.shippingSSDRec = sSDMap.get('ShipTo');  
                        }
                }
            }
            
        }
        catch(Exception e){
            system.debug(LoggingLevel.INFO,'Errors While Creation of Account / SSD' +e.getMessage());
            logTRSException('Lead convert process '+l.Id, 'Errors While Creation of Account / SSD' +e.getMessage(), 'createNewAccount', l.Id, 'Lead', 'Account Creation', supportEmail, true);
        }
        
        return refDetails;
    }
    
    public static string validatePhoneNumber(string phno){
        
         if(phno != null) { 
                
                //checck the size of phone field 
                if(phno.length()<= 16){
                    return phno;
                }else{
                    // Replace all special characters with null and check the size, 
                    // if less than 16 assign the same otherwise get first 16 characters 
                    string newPhone = phno.replaceAll('[^a-zA-Z0-9\\s+]', '');
                    if(newPhone != null){
                        if(newPhone.length() <= 16 ){
                            return newPhone;
                        }else{
                            newPhone.subString(0,16);
                        }
                    } else{
                        return null;
                    } 
                }
          }
          return null;
      }
    
    
    public static Map<string,Source_System_Detail__c> createNewSSD(lead l, Id oAccount, String oAccountName, Boolean shippingOnly){
        string ssdRecordType = Static_Values__c.getValues('SSDRecordType').value__c;  
        Map<String, Source_System_Detail__c> sSDMap = new  Map<String, Source_System_Detail__c>();  
        Id ssdrectype= Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(ssdRecordType).getRecordTypeId();
            LIST<Source_System_Detail__c> ssdList = new LIST<Source_System_Detail__c>();
            
        if(!shippingOnly){
            // This is for billing address SSD details.......
            Source_System_Detail__c ssd = new Source_System_Detail__c();        
            ssd.Name= oAccountName;
            ssd.Number_Street__c = l.Billing_Street__c;
            ssd.LCRM_Street_2__c = l.Billing_Street_2__c;
            ssd.City__c = l.Billing_City__c; 
            ssd.State__c = l.Billing_State__c; 
            ssd.Country__c = l.Billing_Country__c; 
            ssd.Postal_Code__c =l.Billing_Zip__c; 
            ssd.Account_Name__c= oAccount;
            ssd.RecordtypeId=ssdrectype;
            ssd.Source_System_Name__c=oAccountName;
            ssd.LCRM_Email__c= l.Email;
            ssd.CurrencyIsoCode = (l.Lead_Region__c=='TR Store Canada Print')? 'CAD' : 'USD' ;
            ssd.LCRM_Sales_Org__c = (l.Lead_Region__c=='TR Store Canada Print')? 'CARS' : 'WEST';
            ssd.LCRM_Sub_BU__c =(l.Lead_Region__c=='TR Store US Print')? 'USL' : 'Canada';
            ssd.LCRM_Industry__c='NOT APPLICABLE';
            ssd.LCRM_Country_Code__c = (l.Lead_Region__c=='TR Store US Print') ? 'US' : 'CA';
            ssd.LCRM_Distribution_Channel__c = 'WEST GROUP';
            ssd.LCRM_Market_Segment__c = l.Market_Segment__c;
            
            // ssd.Operating_Unit__c = accleadmap.get(acc.id).Operating_Unit__c;
            //ssd.Source_System_Account_Number__c =accleadmap.get(acc.id).SAPAccountNumber__c;
             if(l.Phone != null){
                ssd.LCRM_Phone__c = validatePhoneNumber(l.Phone);
            }
            
            
            ssdList.add(ssd);
            
            SSDMap.put('BillTo',ssd);
        }
        
             
            // This is for shipping address SSD details.......
            if(shippingOnly || l.TRstore_Billadd_differenceto_shipping__c){
                Source_System_Detail__c ssdShipping = new Source_System_Detail__c();
                ssdShipping.Name= oAccountName;
                ssdShipping.Number_Street__c = l.Street;
                ssdShipping.LCRM_Street_2__c = l.Shipping_Street_2__c;
                ssdShipping.City__c = l.City; 
                ssdShipping.State__c = l.State; 
                ssdShipping.Country__c = l.Country; 
                ssdShipping.Postal_Code__c =l.PostalCode; 
                ssdShipping.Account_Name__c= oAccount;
                ssdShipping.RecordtypeId=ssdrectype;
                ssdShipping.Source_System_Name__c=oAccountName;
                ssdShipping.LCRM_Email__c= l.Email;
                ssdShipping.CurrencyIsoCode = (l.Lead_Region__c=='TR Store Canada Print')? 'CAD' : 'USD' ;
                ssdShipping.LCRM_Sales_Org__c = (l.Lead_Region__c=='TR Store Canada Print')? 'CARS' : 'WEST';
                ssdShipping.LCRM_Sub_BU__c = (l.Lead_Region__c=='TR Store US Print') ? 'USL' : 'Canada';
                ssdShipping.LCRM_Industry__c='NOT APPLICABLE';
                ssdShipping.LCRM_Country_Code__c= (l.Lead_Region__c=='TR Store US Print') ? 'US' : 'CA';
                ssdShipping.LCRM_Distribution_Channel__c = 'WEST GROUP'; 
                ssdShipping.LCRM_Market_Segment__c = l.Market_Segment__c;
                // ssd.Operating_Unit__c = accleadmap.get(acc.id).Operating_Unit__c;
                //ssd.Source_System_Account_Number__c =accleadmap.get(acc.id).SAPAccountNumber__c;
                
                if( l.Shipping_Phone__c != null ){
                    ssdShipping.LCRM_Phone__c = validatePhoneNumber(l.Shipping_Phone__c);
                }
                
                
                ssdList.add(ssdShipping);
                SSDMap.put('ShipTo',ssdShipping);
                
            }
            LIST<database.saveresult> ssdResult = database.insert(ssdList, false);
            system.debug(loggingLevel.INFO,'result of acc insert'+ssdResult);
            if(!ssdList.isEmpty()){  
                return SSDMap;
            }else {
                return null;
            }    
    }
    
    public static ReferenceDetails createNewContact(Lead l, ReferenceDetails refDetails){
        
        contact oContact = new Contact();
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        system.debug(loggingLevel.INFO,'+++ Within newContactDetails else check '+ refDetails.convertedAccId );
        
        if(l.Shipping_FirstName__c != null && l.Shipping_LastName__c != null){
            oContact.FirstName = l.Shipping_FirstName__c;
            oContact.LastName = l.Shipping_LastName__c;
        }else{
            oContact.FirstName = l.firstName;
            oContact.LastName = l.LastName;
        }
        
        
        oContact.Email = l.Email;
        
        if( l.Phone != null ){
          oContact.Work_Direct__c = validatePhoneNumber(l.Phone);
          oContact.Phone = oContact.Work_Direct__c;
                 
         }
        oContact.AccountId = refDetails.convertedAccId; //Set whatever Account Id that has been selected
        
        database.saveresult conSaveRes = database.insert(oContact, false);
        System.debug(loggingLevel.INFO, 'New contact creation '+conSaveRes);
        System.debug(loggingLevel.INFO, 'new contact'+ oContact.Phone );
        if(conSaveRes.isSuccess()){
           refDetails.convertedConId = oContact.id;
        }else{
           System.debug(loggingLevel.INFO, 'New contact creation failed');
           refDetails.recordResult = conSaveRes;
           refDetails.errorObject = 'Contact'; 
        }       
                
        return refDetails;
    }
    
    
    global class ReferenceDetails{
        
        public id convertedAccId;
        public id convertedConId;
        public id convertedOppId;
        public id   accountSSDId;    //Billing Address SSD Id
        public id   contactSSDId;
        public string refDesc;
        public Source_system_Detail__c ssdRec;
        public id accountShippingSSDId;    //Shippig Address SSD Id
        public Source_system_Detail__c shippingSSDRec;
        // Added as part of DLT-19076, following values will be populated in case of any issues
        public database.saveResult recordResult;
        public String errorObject;
        //public List<string> errorDesc;
        
        // public ReferenceDetails(){}
        
    }
    
    
    
    /********************************************************************************************************
*  fetchLeadDetails: Method to Retrieve Guest user information(lead details) during buying & abandon 
scenarios .
*  @input Lead ID , @returns TRStoreResponse
*  As Part of  DLT-15904 
*********************************************************************************************************/
    public static  TRStore_OrderRequest.leadrequestById fetchLeadDetails(id leadId, string emailId, id cartId){
        List<Lead> existingLeads = new List<Lead>();
        Lead existingLead = new Lead();
        system.debug(LoggingLevel.INFO,'Lead Search............'+leadId+'   '+emailId+'  '+cartId);
        
        if(leadId != null){
            if (Schema.sObjectType.Lead.isAccessible()){
                existingLeads = [Select Id, firstName,lastName, RecordTypeId, Is_GLI__c,email, Primary_Campaign_Source__c,mobilePhone, Tracking_Code__c, Billing_Zip__c, SAPAccountNumber__c, company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, street, city, state, country, postalcode, Product_Configuration__c,IsConverted,ConvertedAccountId,ConvertedContactId,ConvertedOpportunityId, Total_Price__c, Market_Segment__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c,Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c FROM Lead WHERE Id=: leadId ORDER BY isConverted DESC];
            }
        }else if (emailId != null) {
            if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                existingLeads = [Select Id, firstName,lastName, RecordTypeId, Is_GLI__c,email, Primary_Campaign_Source__c,mobilePhone, Tracking_Code__c, Billing_Zip__c, SAPAccountNumber__c, company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, street, city, state, country, postalcode, Product_Configuration__c,IsConverted,ConvertedAccountId,ConvertedContactId,ConvertedOpportunityId, Total_Price__c, Market_Segment__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c, Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c FROM Lead WHERE email=: emailId ORDER BY isConverted DESC];
            }
        }
        
        system.debug(LoggingLevel.INFO, 'existingLeads............'+existingLeads);
        if(!existingLeads.isEmpty()){
            for(Lead ld : existingLeads ){
                existingLead = ld;
            }
        }
        
        system.debug(LoggingLevel.INFO,'existing lead    '+existingLead);
        TRStore_OrderRequest.leadrequestById response = new TRStore_OrderRequest.leadrequestById();
        if(!existingLeads.isEmpty()){
            if(existingLead.IsConverted){
                response = fetchLeadDetailsAfterConversion(existingLead, cartId);
            }else{
                response = leadJson(existingLead, cartId);
            }
        }else{
            TRStore_OrderRequest.TRStoreResponse ErrResponse = new TRStore_OrderRequest.TRStoreResponse();
            TRStore_OrderRequest.TRstoreOrders errorRespOrder = new TRStore_OrderRequest.TRstoreOrders();
            
            ErrResponse.responseStatus = TRStoreConstants.ERROR_STATUS;
            ErrResponse.responseCode = TRStoreConstants.ERROR_CODE;
            ErrResponse.statusDetail = TRStoreConstants.ERROR_LEAD_FETCH_DETAILS;
            ErrResponse.leadId = Leadid;
            ErrResponse.emailId = emailId;
            errorRespOrder.resp = ErrResponse;
            response.trStoreOrder = errorRespOrder;
        }
        
        return response ;
        
    }
    
    
    
    /********************************************************************************************************
*  fetchLeadDetails: Method to Retrieve the cloned lead details if the lead is converted.
scenarios .
*  @input existing Lead ID , @returns TRStoreResponse
*  As Part of  DLT-15904 
*********************************************************************************************************/
    public static  TRStore_OrderRequest.leadrequestById fetchLeadDetailsAfterConversion(Lead existingLead, Id cartId){
        Lead clonedLead = new Lead();
        clonedLead = existingLead.clone();
        clonedLead.IsConverted = false;
        clonedLead.convertedAccountid = null;
        clonedLead.ConvertedContactId = null;
        clonedLead.convertedopportunityId = null;
        clonedLead.Account__c = existingLead.ConvertedAccountId;
        clonedLead.Contact__c = existingLead.convertedcontactId;
        clonedLead.ownerId = userinfo.getUserId();
        clonedLead.Product_Configuration__c=cartId;
        
        if(Schema.sObjectType.Lead.isCreateable()){
            insert clonedLead;
        }
        
        TRStore_OrderRequest.leadrequestById resp = leadJson(clonedLead, cartID);
        
        return resp;
    }
    
    
    /********************************************************************************************************
*  fetchLeadDetails: Method to Retrieve Guest user information(lead details) during buying & abandon 
scenarios .
*  @input Lead ID , @returns TRStoreResponse
*  As Part of  DLT-17031 
*********************************************************************************************************/
    public static  TRStore_OrderRequest.leadrequestById fetchLeadDetailsByEmail(string emailId, string westAccNum){
        List<Lead> existingLeads = new List<Lead>();
        Lead existingLead = new Lead();
        system.debug(LoggingLevel.INFO,'Lead Search............'+emailId+'  '+westAccNum);
        
        LIST<LCRM_Contact_SSD__c> contactssds = new LIST<LCRM_Contact_SSD__c>();
        LCRM_Contact_SSD__c cssd = new LCRM_Contact_SSD__c();
        
        LIST<Source_System_Detail__c> accountssds = new LIST<Source_System_Detail__c>();
        Source_System_Detail__c assd = new Source_System_Detail__c();
        
        if(emailId != null){
            if (Schema.sObjectType.Lead.isAccessible()){
                existingLeads = [Select Id, firstName,lastName, RecordTypeId, Is_GLI__c,email,mobilePhone, Primary_Campaign_Source__c, Tracking_Code__c, Billing_Zip__c, SAPAccountNumber__c, company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, street, city, state, country, postalcode, Product_Configuration__c,IsConverted,ConvertedAccountId,ConvertedContactId,ConvertedOpportunityId, Total_Price__c, Market_Segment__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c,Shipping_Phone__c,Shipping_FirstName__c,Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c FROM Lead WHERE email =: emailId ORDER BY isConverted ASC limit 1];
            }
        } 
        
        system.debug(LoggingLevel.INFO, 'existingLeads............'+existingLeads);
        if(!existingLeads.isEmpty()){
            for(Lead ld : existingLeads ){
                existingLead = ld;
            }
        }else{
            //Write the logic to fetch the details from Contact SSD and Account SSD details......................
        }
        
        system.debug(LoggingLevel.INFO,'existing lead    '+existingLead);
        TRStore_OrderRequest.leadrequestById response = new TRStore_OrderRequest.leadrequestById();
        if(!existingLeads.isEmpty()){
            if(existingLead.IsConverted){
                response = fetchLeadDetailsAfterConversion(existingLead, null);
            }else{
                response = leadJson(existingLead, null);
            }
        }/*else if(assd.id != null || cssd.id != null){
//  response = contactssdJson(cssd, assd);
}*/else{
    
    TRStore_OrderRequest.TRStoreResponse ErrResponse = new TRStore_OrderRequest.TRStoreResponse();
    TRStore_OrderRequest.TRstoreOrders errorRespOrder = new TRStore_OrderRequest.TRstoreOrders();
    
    ErrResponse.responseStatus = TRStoreConstants.ERROR_STATUS;
    ErrResponse.responseCode = TRStoreConstants.ERROR_CODE;
    ErrResponse.statusDetail = TRStoreConstants.ERROR_LEAD_FETCH_DETAILS;
    
    ErrResponse.emailId = emailId;
    errorRespOrder.resp = ErrResponse;
    response.trStoreOrder = errorRespOrder;
    
}
        
        return response ;
        
    }
    
    
    /********************************************************************************************************
*  leadJson: Common Method to map the existing lead/converted lead details as per the request structure
which needs to be sent to AEM.
*  @input existing Lead ID , @returns TRStoreResponse
*  As Part of  DLT-15904 
*********************************************************************************************************/
    public static  TRStore_OrderRequest.leadrequestById leadJson(lead existingLead, Id cartId){
        
        TRStore_OrderRequest.TRstoreOrders trStoreOrderSingle = new TRStore_OrderRequest.TRstoreOrders();
        TRStore_OrderRequest.leadrequestById trStoreOrderfinal = new TRStore_OrderRequest.leadrequestById();        
        
        TRStore_OrderRequest.TRstoreOrder od = new TRStore_OrderRequest.TRstoreOrder();
        TRStore_OrderRequest.TRStorecustomerDetails cd = new TRStore_OrderRequest.TRStorecustomerDetails();
        
        TRStore_OrderRequest.TRStoreAccountDetails ad= new TRStore_OrderRequest.TRStoreAccountDetails();
        TRStore_OrderRequest.customerAddress shipAdd = new  TRStore_OrderRequest.customerAddress();
        TRStore_OrderRequest.customerAddress billAdd = new  TRStore_OrderRequest.customerAddress();
        TRStore_OrderRequest.References ref = new TRStore_OrderRequest.References();
        TRStore_OrderRequest.ActionParams ap = new TRStore_OrderRequest.ActionParams();
        TRStore_OrderRequest.TRStoreResponse SuccessResponse = new TRStore_OrderRequest.TRStoreResponse();
        
        LIST<TRStore_OrderRequest.OnlineContactsFieldsClass> proviewContactsList  = new LIST<TRStore_OrderRequest.OnlineContactsFieldsClass>();
        
        // od.totalPrice='';   
        //  od.isExistingCustomer=false;
        //   od.isAbandonedLead =false; 
        
        
        cd.firstName=existingLead.FirstName;
        cd.lastName=existingLead.LastName;
        if(existingLead.Email != null){
            cd.businessEmail=existingLead.Email;
        //cd.isPhysicalSameAsBillingAddress=true;
        }
        if(existingLead.Street != null){  
            shipAdd.street1=existingLead.Street;  
        }     
        if(existingLead.city  != null){    
            shipAdd.city=existingLead.city;
        }    
        if(existingLead.Street != null){
            shipAdd.state=existingLead.state;
        }    
        if(existingLead.PostalCode != null){
            shipAdd.zipCode=existingLead.PostalCode;
        }    
        if(existingLead.Country != null){    
            shipAdd.country=existingLead.Country;
        }
        if(existingLead.Billing_Street__c != null){
            billAdd.street1=existingLead.Billing_Street__c;
        }    
        if(existingLead.Billing_City__c != null){    
            billAdd.city=existingLead.Billing_City__c;
        }    
        if(existingLead.Billing_State__c != null){    
            billAdd.state=existingLead.Billing_State__c;
        }    
        if(existingLead.Billing_Zip__c != null){    
            billAdd.zipCode=existingLead.Billing_Zip__c;
        }    
        if(existingLead.Billing_Country__c != null){    
            billAdd.country=existingLead.Billing_Country__c;
        }
        
        ad.organizationName=existingLead.Company;
        if(existingLead.SAPAccountNumber__c != null){
            ad.AccountANumber = existingLead.SAPAccountNumber__c;
        }    
        if(existingLead.Market_Segment__c != null){
            ad.organizationType = existingLead.Market_Segment__c ;     
        }    
        ad.billingAddress = billAdd;
        cd.organizationDetails=ad;
        cd.shippingAddress = shipAdd;
        
        if(existingLead.Total_Price__c != null){
            od.totalPrice = string.valueOf(existingLead.Total_Price__c);
        }    
        od.customerDetails = cd;
        
        ref.leadId=existingLead.id;
        if(cartId != null && existingLead.Product_Configuration__c != cartId){
            ref.cartId=cartId;
        }else if(existingLead.Product_Configuration__c != null){
            ref.cartId = existingLead.Product_Configuration__c;
        }    
        if(cartID != null){
            LIST<Apttus_Config2__ProductConfiguration__c> configurations = new LIST<Apttus_Config2__ProductConfiguration__c>();
            if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()) {
                configurations = [SELECT id, name, (Select id, name, First_Name__c, Last_Name__c, Email__c,  WLEc_Juris__c, Position__c ,Type__c , Product_Configuration__c    from Online_Contacts__r) FROM Apttus_Config2__ProductConfiguration__c WHERE ID =: cartId ];
            }        
            for(Apttus_Config2__ProductConfiguration__c pc: configurations ){
                
              for(Online_Contacts__c onlineContact: pc.Online_Contacts__r){  
                TRStore_OrderRequest.OnlineContactsFieldsClass olc = new TRStore_OrderRequest.OnlineContactsFieldsClass();
                 
                    olc.pFirstName = onlineContact.First_Name__c;
                    olc.pLastName = onlineContact.Last_Name__c;
                    olc.pEmail = onlineContact.Email__c;
                    olc.jurisdiction = onlineContact.WLEc_Juris__c;
                    olc.pTitle = onlineContact.Position__c ;                        
                    olc.pType = onlineContact.Type__c;
                    olc.proviewId = onlineContact.id ;
                        
                    proviewContactsList.add(olc);
                  
              
              }  
            }
            
           // TRStore_OrderRequest.OnlineContactsFieldsClass
            od.proviewContacts = proviewContactsList;
        
        }    
            
        
        ap.leadAction='RetrieveLeadDetails';//
        
        trStoreOrderSingle.OrderDetails=od;
        trStoreOrderSingle.actionParamsDetails=ap;
        trStoreOrderSingle.referencesDetails=ref;
        
        SuccessResponse.responseStatus = TRStoreConstants.SUCCESS_STATUS;
        SuccessResponse.responseCode = TRStoreConstants.SUCCESS_CODE;
        SuccessResponse.statusDetail = TRStoreConstants.SUCCESS_LEAD_FETCH_DETAILS;
        SuccessResponse.leadId = existingLead.id;
        SuccessResponse.emailId = existingLead.email;
        
        trStoreOrderSingle.resp = SuccessResponse;
        
        trStoreOrderFinal.trStoreOrder = trStoreOrderSingle;
           
        return trStoreOrderfinal;
    }
    
        
    /********************************************************************************************************
*  logTRStoreException: Method to log exception details
*  @input Request Message, error message, WebServiceName , record Id
*  As Part of  DLT-15904 
*********************************************************************************************************/
    public static void logTRStoreException(string strBody, string error, String WebServiceName, id recId) {
        try{
            System.debug(LoggingLevel.Info,'Inside logException-->');
            
            integration_Logger__c intLog = new Integration_Logger__c();
           // intLog.Object_Name__c = 'Lead';
            intLog.Exception_Message__c = error;
            intLog.Request_Message__c = strBody;
            intLog.Request_Type__c = 'Lead Conversion';
            intLog.Service_Name__c = WebServiceName;
            intLog.Exception_Module__c = 'TRStore';
            intLog.Object_Id__c = recId;
            database.insert(intLog,false); 
             
            System.debug(LoggingLevel.Info,'intLog'+intLog);
            
            if(strBody.contains('Lead convert process')){
                Database.update(new Lead(ID=recId, TRStore_Exception__c=intLog.id));
                
            }else if(strBody.contains('Submit Order Error') || strBody.contains('proposal update error')){
                
                Database.update(new Apttus_Proposal__Proposal__c(Id=recId, TRStore_Exception__c=intLog.id));
            }else if(strBody.contains('Finalize Cart Error') || strBody.contains('cart update error')){
                Database.update(new Apttus_Config2__ProductConfiguration__c(Id=recId, TRStore_Exception__c=intLog.id));
            }
        } catch(Exception e){
            system.debug(loggingLevel.INFO,'TRStore Exception >>'+e);
        }
    }  
     /********************************************************************************************************
*  logTRSException: Method to log exception details
*  @input Request Message, error message, WebServiceName , record Id, object Name, support email, isEscalatedToSupport/ toSupport
*  As Part of DLT-19076
*********************************************************************************************************/
    public static void logTRSException(String strBody, String error, String WebServiceName, String recId, String objectName, String requestType, String supportEmail, Boolean toSupport) {
        try{
            System.debug(LoggingLevel.Info,'Inside logTRSException-->>>>>>');
            
            integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = objectName;
            intLog.Exception_Message__c = error;
            intLog.Request_Message__c = strBody;
            intLog.Request_Type__c = requestType;
            intLog.Service_Name__c = WebServiceName;
            intLog.Exception_Module__c = 'TRStore';
            intLog.Object_Id__c = recId;
            intLog.Support_Email__c = String.valueOf(supportEmail);
            intLog.Is_Escalated_to_Support__c = toSupport;  
            
            database.saveResult intLoggerSave = database.insert(intLog,false); 
             
            System.debug(LoggingLevel.Info,'intLog'+intLog);
            System.debug(LoggingLevel.Info,'intLog'+intLog.Id + 'intLoggerSave >>'+ intLoggerSave.getErrors());
            
            if(strBody.contains('Lead convert process')){
            system.debug(loggingLevel.INFO,'TRS Exception >>> lead convert condition');
                Database.update(new Lead(ID=recId, TRStore_Exception__c=intLog.id));
                
            }else if(strBody.contains('Submit Order Error') || strBody.contains('proposal update error')){
                Database.update(new Apttus_Proposal__Proposal__c(Id=recId, TRStore_Exception__c=intLog.id));
                
            }else if(strBody.contains('Finalize Cart Error') || strBody.contains('cart update error')){
                Database.update(new Apttus_Config2__ProductConfiguration__c(Id=recId, TRStore_Exception__c=intLog.id));
            }
        } catch(Exception e){
            system.debug(loggingLevel.INFO,'TRS Exception >>'+e);
        }
    }  
    
}