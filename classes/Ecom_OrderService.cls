/** CHANGE HISTORY
* ==================================================================================================================================
* Date          Name                Jira        Description
* 2018-02-28    Ramesh Reddy        DLT-7875    [New Customer] Create Lead for Sales Rep after "Place Order"
* 2018-02-28    Ramesh Reddy        DLT-8272    Enhance Order creation with Total Price & Accepted Plan Name
* 2018-04-04    Ramesh Reddy        DLT-7744    Send Email to Customer with Order Summary and Next Steps
* 2018-04-27    Shiva Sri Arun                  [NEW CUSTOMER - Buy Plan SL] Update fields on order, to relate account and order 
* 2018-05-22    Ramesh Reddy        DLT-9358    [NEW CUSTOMER - Buy Plan SL/CP] Generate Lead for Abandoned Customers
* 2018-06-28    Shiva Sri Arun      DLT-9978    [GLI] Update object field references for class "Ecom_Contact" "Ecom_Account"
* 2018-07-06    Prashob Anto        DLT -10316, 10317 Update Campaign ID on Opportunity once Order Placed (Small law and corporate) 
* 2018-07-07    Shiva Sri Arun      DLT-10939   Remove cart creation during Store Order being created   
* 2018-07-13    Ramesh Reddy        DLT-10257 & 10287 [NEW CUSTOMER - View Plans SL/CP] Apply Dynamic Discounts/Markups to Plans per Term & Category
* 2018-07-20    Shiva Sri Arun      DLT-10887   Newsales_SAP account number is not created in Sfdc
* 2018-08-02    Shiva Sri Arun      DLT-10835   [NEW CUSTOMER - Buy Plan SL/CP] Convert Lead to Opportunity
* 2018-08-28    Shiva/Ramesh        DLT-11546   [TECH STORY- SFDC] - Update calls as per new UI for checkout
* 2018-09-10    Ramesh Reddy        DLT-11467   [NSE - Promo SL] Reduce Quote Price by 10% for BAR2018 Promotion
* 2018-09-21    Shiva Sri Arun      DLT-11730   [Tech story] [Code Scan] Fix Ecom_OrderService, Ecom_OrderService_Test
* 2018-11-12    Samreen Ali         DLT-12813   Map Purchase Order field value FROM the UI to the proposal record
* 2018-11-19    Ramesh Reddy        DLT-13117   [NSE ALL] Create a 2nd SSD Account for Guest Users with different physical address
* 2019-01-18    Ramesh Reddy        DLT-14404   [NSE ALL] Update Proposal when Customer Bills to Account
* 2019-01-24    Samreen Ali         DLT-14308   [Tech story] [PMD Code Scan Fix] 
* 2019-02-06    Ramesh Reddy        DLT-14806   [NSE ALL][Tech Story] Salesforce service to get journey details
* 2019-03-26    Ramesh Reddy        DLT-14561   Tech Story[NSE SL/CP] Replace Promotion Codes to APPTUS
* 2019-04-20    Ramesh Reddy        DLT-16233   Tech Story[NSE SL/CP] Replace Promotion Codes to APPTUS and should support user friendly codes
* 2019-08-23    David Hoel          DLT-17481   Fix query for SSD Order Service Mappings. Added quantity to SSD creation method calls.
* 2019-01-02    David Hoel          DLT-19135   [NSE] CORP-WL Add option products in cartv
* 2020-04-02    Benjamin Her        DLT-19857   Workaround fix for Apttus Summer '19 Package Known Issues
* 2020-05-08    Rahul Natarajan     DLT-20038   INC3335286 | [NSE] | Post state and country value to SFDC create lead in FL cob page
* 2020-05-01    Rahul Natarajan     DLT-19938   Track Logs for unsuccesful response
* 2020-09-04    Benjamin Her        DLT-20682   Promo Code logic update to handle updation
* 2021-02-04    Brenda Shields      DLT-21293 - [SFDC]NSE-GOVT-Incorrect price is displaying in the OrderForm when Add-On is added in QA
* 2021-04-01    Brenda Shields      DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
*                                               Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
* ==================================================================================================================================*/
@RestResource(urlMapping='/digitalconfigurator/order/*')
global without sharing class Ecom_OrderService {

    /**
     *  Rest API will trigger this Method and return response
     */
    @HttpPost
    global static UpdatedMethodResponse apiNew(Ecom_OrderRequest req) {
        system.debug(logginglevel.INFO, 'Request >> ' + Json.serialize(req));
        
        UpdatedMethodResponse response = new UpdatedMethodResponse();
        if ((req.storeOrder.storeName == null) || String.isBlank(req.storeOrder.storeName)) {
            response.responseMessage = 'Store Name should be available';
            response.responseCode = 4000;
            return response;
        }
        
        try {
            Ecom_OrderService service = new Ecom_OrderService();            
            response = service.updatedMethod(req.actionParams, req.references, req.storeOrder);
            response.responseMessage = 'Success';
            response.responseCode = 200;
            system.debug(logginglevel.INFO, '====httppost response====' + response);
        } catch(Exception ex) {
            DCUtils.trackLog(ex, 'Ecom_OrderService', 'apiNew');
            response.responseMessage = ex.getMessage();
            response.responseCode = 4000;
        }
         // Track Logs -- DLT-19938
        if(response.responseCode!=200 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            Digital_Exception_Log__c dtl=new Digital_Exception_Log__c();
            dtl.Class_Reference__c='Ecom_OrderService';
            dtl.Exception_Message__c='{"req":'+Json.serialize(req)+'}';
            dtl.Exception_Type__c='Response->'+Json.serialize(response);
            insert dtl;
        }
        //Track Logs -- DLT-19938
        return response;  
    }
    
    /** 
    *   updatedMethod()
    */ 
    public UpdatedMethodResponse updatedMethod(Ecom_OrderRequest.cls_ActionParams inputParam, Ecom_OrderRequest.cls_References ref, Ecom_OrderRequest.cls_storeOrder storeOrder) {
        storeOrder = convertAddress(storeOrder);
        
        UpdatedMethodResponse res = new UpdatedMethodResponse();

        // missing input param in request
        if (inputParam != null) { requestToResponse(res, ref); }

        String promoCode = storeOrder.promoCode;
        Integer quantity = storeOrder.selectedProducts[0].quantity;

        Boolean isGetQuoteClicked = false;
        if (storeOrder.additionalInfo.isGetQuoteClicked != null) {
            isGetQuoteClicked = storeOrder.additionalInfo.isGetQuoteClicked;
        }

        Boolean isExistingCustomer = false;
        if (storeOrder.isExistingCustomer != null) {
            isExistingCustomer = storeOrder.isExistingCustomer;
        }
        
        List<APTSECOM_Store__c> stores = getStoreList(storeOrder);
        Apttus_Config2__Order__c order;
        Lead lead;
        String activityDescription;
        Boolean isCartForwarded = false;
        // Creating Order Depending on orderAction request 
        if (inputParam.orderAction == 'Create') {
            //String plan = storeOrder.plan;
            //String orderId = '';
            
            if (stores.isEmpty()) {
                throw new DCCustomException('Store Name does not exist anymore');
            }
            
            if (String.isBlank(stores[0].APTSECOM_Price_List__c)) {
                throw new DCCustomException('PriceList should not be Empty');
            }                                                                                         
            
            if (ref.orderId == null) {                      
                order = createOrder(stores[0], '', storeOrder);    // Create Order
                
                if ((inputParam.leadAction == 'Create') && (ref.orderId == null)) {
                    lead = Ecom_Lead.createLead(storeOrder, string.valueof(order.id), stores[0], ref);  // Create Lead
                    res.leadId = lead.id;
                    res.isLeadConverted = false;
                }   // end of leadAction = create 
                
                res.orderId = order.id;
                res.orderNumber = order.Name;
                
                system.debug(logginglevel.INFO, '=====response in create order and lead====' + res);
            }   // end of condition ref.orderId == null

        // end of order Action = create
        } else if (( (inputParam.orderAction == 'Update') && (ref.orderId != null) ) || (inputParam.leadAction == 'Update') ) {         
            Ecom_OrderRequest.cls_customerDetails customerDetails = storeOrder.customerDetails;
            if (storeOrder.additionalInfo.forwardCart != null) {
                isCartForwarded = storeOrder.additionalInfo.forwardCart;
                activityDescription = storeOrder.additionalInfo.activityDesc;
            }

            String adjustmentType = stores[0].APTSECOM_Adjustment_Type__c;
            Decimal adjustmentAmount = (stores[0].APTSECOM_Adjustment_Amount__c != null) ? stores[0].APTSECOM_Adjustment_Amount__c : 0.0 ;
            
            for (APTSECOM_Store_Price_Adjustment__c adjustment : stores[0].Store_Price_Adjustments__r) {
                if (String.isNotBlank(adjustment.APTSECOM_Adjustment_Type__c) && (adjustment.APTSECOM_Adjustment_Amount__c != null)) {
                    adjustmentType = adjustment.APTSECOM_Adjustment_Type__c;
                    adjustmentAmount = adjustment.APTSECOM_Adjustment_Amount__c;
                }
            }
            
            // if customer update plan name or products if cartId already in session, then we update products on Proposal Cart 
            if ((ref.cartId != null) && Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()) {                
                Apttus_Config2__Order__c oder = [SELECT Id, Name, APTSECOM_Plan_Name__c FROM Apttus_Config2__Order__c WHERE Id = :ref.orderId]; 
                
                List<Apttus_Config2__ProductConfiguration__c> carts =
                            [SELECT Id, Apttus_Config2__Status__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Promo_Code__c, 
                                Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c, 
                                (SELECT Id, Apttus_Config2__ProductId__c, Apttus_Config2__Quantity__c, APTS_Contract_Term__c, APTS_Proposal_Business_Unit__c,
                                Apttus_Config2__OptionId__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__AdjustmentType__c,
                                APTS_Combination_Key__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c
                                    FROM Apttus_Config2__LineItems__r)
                            FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :ref.cartId
                            WITH SECURITY_ENFORCED
                        ]; 
                
                system.debug(logginglevel.INFO, '===check====' + carts);
                
                Ecom_StoreResponse.Adjustments adjustments = getAggregatedAdjustments(stores[0]);
                String planName = oder.APTSECOM_Plan_Name__c;  
                
                // Update Products and Quote's cart
                updateProducts(carts, stores[0], storeOrder, planName, adjustments, true, res, ref);    
            
            // end of check for cartId in session
            } else if ((ref.proposalId != null) && (isExistingCustomer == false)) {
                Ecom_Account.updateAccountsBasedOnAttorney(ref.accountId, storeOrder.selectedProducts, stores[0]);
            } else if ((ref.proposalId != null) && (storeOrder.plan != null)) {   
                Apttus_Proposal__Proposal__c propUpd = new Apttus_Proposal__Proposal__c();
                propUpd.Id = ref.proposalId;
                propUpd.Apttus_Proposal__Proposal_Name__c = customerDetails.organizationName + '-' + stores[0].name + '-' + storeOrder.plan;                                 
                
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) { update propUpd; }
                
                Boolean result = false; 
                Opportunity oppUpdate = new Opportunity();
                oppUpdate.Id = ref.opportunityId;
                
                if (oppUpdate.description != null) {
                    result = oppUpdate.description.contains(storeOrder.plan); 
                }
                
                if ( (result == false) && (oppUpdate.Description != null) && (oppUpdate.Description.indexOf(';') != -1) ) {
                    oppUpdate.Description = oppUpdate.description.replace(
                        oppUpdate.description.substring(0, oppUpdate.description.indexOf(';')), storeOrder.plan
                    ); 
                }
                
                if (Schema.sObjectType.Opportunity.isUpdateable()) { update oppUpdate; }
            }
            
            // Update Order Object 
            Apttus_Config2__Order__c orderObj = new Apttus_Config2__Order__c();
            orderObj.Id = ref.orderId;
            orderObj.APTSECOM_Plan_Name__c = storeOrder.plan;
            orderObj.APTSECOM_Total_Price__c = storeOrder.totalPrice;
            
            if (storeOrder != null) {
                String data = Json.serialize(storeOrder);
                orderObj.APTSECOM_Customer_Details__c = data;
                
                if (Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable()) { update orderObj; } 
            }
            res.orderId = ref.orderId;
            
            // Update details on Lead Object           
            if ((inputParam.leadAction == 'Update') && (ref.leadId != null) && Schema.sObjectType.Lead.isAccessible()) {
                Lead leadRec = [
                    SELECT Name, Id, firstname, Description, lastname, company, Email, street, Phone, city, state, country, postalcode 
                    FROM Lead WHERE Id = :ref.leadId
                ];
                
                Boolean isPlanNameChanged = false;
                isPlanNameChanged = !(leadRec.description.contains(storeorder.plan));

                if ( (leadRec.Description != null) && (leadRec.Description.indexOf(';') != -1) ) {
                    leadRec.description = leadRec.description.replace(
                        leadRec.description.substring(0, leadRec.description.indexOf(';')), storeOrder.plan
                    );
                }
                
                String ext;
                if ((leadRec.Description != null) && (leadRec.Description.indexOf('Extn:') != -1)) {
                    ext = leadRec.Description.substring(0, leadRec.Description.indexOf('Extn:'));
                    if (String.isNotBlank(customerDetails.phoneExtension)) {
                        ext = ext + 'Extn: ' + customerDetails.phoneExtension;
                    }
                } else {
                    ext = (leadRec.Description != null) ? leadRec.Description : '';
                    if (String.isNotBlank(customerDetails.phoneExtension)) {
                        ext = ext + 'Extn: ' + customerDetails.phoneExtension;
                    }
                } 

                Boolean isBasicDataChange = false;
                if ( (leadRec.firstname != customerDetails.firstName) || (leadRec.lastname != customerDetails.lastname) 
                    || (leadRec.Email != customerDetails.businessEmail) ) {
                        isBasicDataChange = true; 
                }

                Boolean isOrgNameChange = false;
                //Check whether organization name is an exact match with existing lead record and UI
                if (leadRec.company != customerDetails.organizationName) {
                    isOrgNameChange = true; 
                }

                Boolean isConNumberChange = false;
                //Check whether phone number is an exact match with existing lead record and UI
                if ( leadRec.Phone != customerDetails.phoneNumber || ext != leadRec.Description) {
                    isConNumberChange = true;  
                }
                
                Boolean isAddressChange = false;
                if ( (leadRec.street != customerDetails.address.addressLine1) || (leadRec.city != customerDetails.address.city) 
                    || (leadRec.state != customerDetails.address.state) || (leadRec.country != customerDetails.address.country) 
                    || (leadRec.postalcode != customerDetails.address.zipCode) ) {
                        // Check whether address details are exact match with existing lead record and UI
                        isAddressChange = true; 
                }
                
                if (isConNumberChange || isAddressChange || isBasicDataChange || isOrgNameChange 
                    || isGetQuoteClicked == true || isCartForwarded == true || isPlanNameChanged == true ) {
                        // If any of fields are mismatch, new details are updated on lead record
                        Ecom_Lead.updateLead(ref.leadId, customerDetails, storeorder);    
                }
                res.leadId = ref.leadId;
            }   // end of condition leadAction = Update
        }   // end of else if condition     
        
        String jsonString = JSON.serializePretty(storeOrder);

        Source_System_Detail__c accSSD;
        LCRM_Contact_SSD__c conSSD;
        // Check to Convert Lead to Account, Contact, Opportunity
        if (inputParam.leadAction == 'Convert') {
            if ( (ref.proposalId == null) || (ref.proposalId == '') ) {
                //DLT-14641 
                //This flag will bypass update billing Address on lead record FROM Account trigger and It will 
                //avoid 101 exception during the convert lead call.
                AccountHandler.bypassLeadUpdateonOrderSubmission = true;
                
                Lead leadRec = [
                    SELECT Id, Name, company, owner.name, LeadSource, Source__c, Source_Desc__c, ownerid, Primary_Campaign_Source__c,
                        Tracking_Code__c, Campaign_Code__c, Campaign_Cell__c, LeadID18__c, Operating_Unit__c, Line_of_Business__c, Description 
                    FROM Lead WHERE Id = :ref.leadId LIMIT 1
                ];
                
                String leadHistoryDetails = JSON.serializePretty(leadRec);
                String ownerId = Ecom_lead.updateConvertLead(ref.leadId, stores[0]); 
                system.debug(logginglevel.INFO, '===leadwithOwnerdetails=ownerId===' + ownerId);
                
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(ref.leadId);      // Pass lead id to convert the lead
                leadConvert.setOwnerId(ownerId);
                
                if ( (isExistingCustomer == true) && (ref.accountId != null) ) {
                    leadConvert.setAccountId(ref.accountId);
                }
                system.debug(logginglevel.INFO, '===check leadId====' + leadConvert);
                
                LeadStatus convertStatus;
                if (Schema.sObjectType.LeadStatus.isAccessible()) {
                    convertStatus = [
                        SELECT Id, MasterLabel 
                        FROM LeadStatus WHERE IsConverted = true AND MasterLabel LIKE 'Sales%' LIMIT 1
                    ]; 
                }
                
                leadConvert.setConvertedStatus(convertStatus.MasterLabel);                              // Set Lead Status
                Database.LeadConvertResult leadconvertedResult = Database.convertLead(leadConvert);     // Lead Conversion
                
                res.isLeadConverted = true;
                system.debug(logginglevel.INFO, '===check leadconvertedResult1====' + leadconvertedResult);
                
                // Check lead Conversion is successful or not
                if (leadconvertedResult.isSuccess() == true) {
                    // Convert Lead to Account
                    Id accountId = leadconvertedResult.getAccountID();  
                    if (isExistingCustomer == false) {
                        // Create AccountSSD
                        accSSD = Ecom_Account.createAccountSSD(
                            accountId, leadconvertedResult.getOpportunityID(), storeOrder.customerDetails, stores[0], quantity
                        );
                    } else if (isExistingCustomer == true && ref.accountSSDId != null && Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
                        accSSD = [
                            SELECT Id, LCRM_Email__c, LCRM_Phone__c, Source_System_Name__c, Number_Street__c, City__c, State__c, Country__c, Postal_Code__c 
                            FROM Source_System_Detail__c WHERE Id = :ref.accountSSDId
                        ];   
                    }   
                    res.accountId = accountId;
                    
                    if (ref.OrderId != null) {
                        // Update BilltoSSD, ShiptoSSD, SoldtoSSD on Store Order Object
                        Ecom_Account.updateOrder(String.valueOf(accSSD.Id), ref.OrderId);     
                    }
                    // Convert Lead to Contact
                    Id contactId = leadconvertedResult.getContactID();
                    // Create ContactSSD
                    conSSD = Ecom_Contact.createContactSSD(accSSD, contactId, storeOrder.customerDetails);
                    res.contactId = contactId;
                    
                    Id opportunityId = leadconvertedResult.getOpportunityID();   
                    res.opptyId = opportunityId;
                    
                    Opportunity oppUpdate = new Opportunity();
                    oppUpdate.Id = opportunityId;
                    oppUpdate.Source_System_Detail__c = accSSD.Id; 
                    oppUpdate.Is_Digital_New_Sales__c=true;
                    if (Schema.sObjectType.Opportunity.isUpdateable()) { update oppUpdate; }
                    
                    // Future call to update Business fields on Converted Account, Contact And Opportunity
                    Ecom_Account.updateAccountContactAndOpportunity( 
                        accountId, contactId, opportunityId, ownerId, stores[0].Id, accSSD.Id, jsonString, leadHistoryDetails, quantity
                    );
                    
                    system.debug(logginglevel.INFO, '1. Number of Queries used after updating bussiness fields: ' + Limits.getQueries());
                }   // end of lead Conversion check

            }   // end of check for proposal Id
            
        // end of check to convert lead  
        } else if (inputParam.accountAction == 'Update' && inputParam.contactAction == 'Update' && inputParam.opportunityAction == 'Update' && inputParam.proposalAction == 'Update' && ref.proposalId != null) {
            Ecom_OrderRequest.cls_customerDetails customerDetails = storeOrder.customerDetails;
            List<Ecom_OrderRequest.cls_selectedProducts> selectedProducts = storeOrder.selectedProducts;
            
            LCRM_Contact_SSD__c ssdCon;
            if (Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()) {
                ssdCon = [
                    SELECT Id, LCRM_Account_SSD__c, LCRM_Extension__c, Name, LCRM_Contact__c, LCRM_First_Name__c, LCRM_Email__c, LCRM_Phone__c 
                    FROM LCRM_Contact_SSD__c WHERE LCRM_Contact__c = :ref.contactId
                ];
            }
            
            Contact conRec;                              
            if (Schema.sObjectType.Contact.isAccessible()) {
                conRec = [
                    SELECT Id, firstname, lastname, Email,Extension__c, accountId, Account.Name, Account.BillingStreet, 
                        Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, Account.Work_Direct__c  
                    FROM Contact WHERE Id = :ref.contactId  
                ];
            }
            
            Apttus_Proposal__Proposal__c propRec = [
                SELECT Id, Name, APTS_SSD_ship_to__c, APTS_SSD_bill_to__c, APTS_SSD_ship_to__r.Number_Street__c, 
                    APTS_SSD_ship_to__r.City__c, APTS_SSD_ship_to__r.State__c,APTS_SSD_ship_to__r.Country__c, 
                    APTS_SSD_ship_to__r.Postal_Code__c, DC_Contract_Not_In_Sync__c, Apttus_Proposal__Proposal_Name__c, 
                    APTS_Order_Confirmation_Contact_Email__c, Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_Quote_Value__c,
                    Apttus_Proposal__Account__r.Name, APTS_Order_Confirmation_Contact_Name__c, Apttus_Proposal__Account__r.billingstreet,
                    Apttus_Proposal__Account__r.billingcity, Apttus_Proposal__Account__r.billingstate, Apttus_Proposal__Account__r.billingcountry,
                    Apttus_Proposal__Account__r.phone, Apttus_Proposal__Account__r.billingPostalCode, APTS_Payment_Option__c 
                FROM Apttus_Proposal__Proposal__c WHERE Id = :ref.proposalId
            ]; 
            
            Boolean isProposalRecUpdated = false;
            if (propRec.APTS_SSD_ship_to__c == propRec.APTS_SSD_bill_to__c) {
                if (customerDetails.isPhysicalSameAsBillingAddress != null && !customerDetails.isPhysicalSameAsBillingAddress) {
                    // Unchecked PhysicalSameAsBillingAddress checkbox
                    // create a shipping address
                    // update same on Proposal record 
                    Source_System_Detail__c shipSSDAccount = Ecom_Account.createSSDInstance(
                        ref.accountId, ref.opportunityId, true, customerDetails, stores[0], quantity
                    );
                    
                    if (Schema.sObjectType.Source_System_Detail__c.isCreateable()) { insert shipSSDAccount; }
                    
                    updateProposal(propRec.Id, shipSSDAccount.Id, customerDetails);
                    isProposalRecUpdated = true;
                }
            } else if (propRec.APTS_SSD_ship_to__c != propRec.APTS_SSD_bill_to__c) {
                // Update shipping Address if Customer has modified
                if (customerDetails.isPhysicalSameAsBillingAddress != null && !customerDetails.isPhysicalSameAsBillingAddress) {
                    Ecom_Account.updateShipToSSDAccountAddress(propRec.APTS_SSD_ship_to__r, customerDetails);                  
                } else {
                    if (Schema.sObjectType.Source_System_Detail__c.isDeletable()) {
                        delete new Source_System_Detail__c(Id = propRec.APTS_SSD_ship_to__c); 
                    }
                    updateProposal(propRec.Id, propRec.APTS_SSD_bill_to__c, customerDetails);
                    isProposalRecUpdated = true;
                }
            }
            
            Boolean isBasicDataChange = false;
            if (conRec.firstname != customerDetails.firstName || conRec.lastname != customerDetails.lastname || conRec.Email != customerDetails.businessEmail) {
                isBasicDataChange = true;
            }
            
            Boolean isOrgNameChange = false;
            if (conRec.Account.Name != customerDetails.organizationName) {
                isOrgNameChange = true;
            }
            
            Boolean isExtChange = false;
            if (conRec.Extension__c != customerDetails.phoneExtension) {
                isExtChange = true;
            }
            
            Boolean isConNumberChange = false;
            if ( conRec.Account.Work_Direct__c !=  customerDetails.phoneNumber) {
                isConNumberChange = true;
            }
            
            Boolean isAddressChange = false;
            if (conRec.Account.BillingStreet != customerDetails.address.addressLine1 || conRec.Account.BillingCity != customerDetails.address.city 
                || conRec.Account.BillingState != customerDetails.address.state || conRec.Account.BillingCountry != customerDetails.address.country 
                || conRec.Account.BillingPostalCode != customerDetails.address.zipCode) {
                    isAddressChange = true;
            }   
            
            if ( isAddressChange || isConNumberChange || isBasicDataChange || isOrgNameChange || isExtChange) {
                // update contacts only if there is change in firstname, lastname, email, phone number
                if (isConNumberChange || isBasicDataChange || isOrgNameChange || isExtChange) { 
                    Ecom_Contact.updateContacts( ref.contactId, ssdCon.Id, customerDetails);                                               
                }

                //Update Accounts only if there is change in Orgname, Address,phone number 
                if ( (isConNumberChange || isAddressChange || isOrgNameChange || isBasicDataChange) && (isExistingCustomer == false) ) {
                    Ecom_Account.updateAccounts(ref.accountId, ssdCon.LCRM_Account_SSD__c,customerDetails);                                 
                }
                
                if (isOrgNameChange || isBasicDataChange) {
                    Ecom_Opportunity.updateOpportunityForOrganizationchange(ref.opportunityId,customerDetails);  
                    
                    Apttus_Proposal__Proposal__c  propUpdate = new Apttus_Proposal__Proposal__c ();
                    propUpdate.Id = ref.proposalId;  
                    propUpdate.Apttus_Proposal__Proposal_Name__c = customerDetails.organizationName + '-' + stores[0].name + '-' + storeOrder.plan;
                    propUpdate.APTS_Order_Confirmation_Contact_Email__c = customerDetails.businessEmail;  
                    
                    if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) { update propUpdate; }
                }
                
                // update order for customer details 
                Apttus_Config2__Order__c orderObj = new Apttus_Config2__Order__c();
                orderObj.Id = ref.orderId;
            } 
            
            res.orderId = ref.orderId;
            res.leadId = ref.leadId;
            res.accountId = ref.accountId;
            res.contactId = ref.contactId;
            res.opptyId = ref.opportunityId;
            res.proposalId = ref.proposalId;
            res.isLeadConverted = true;
            promoCode = storeOrder.promoCode;
            system.debug(logginglevel.INFO, '====response in update account, contact, opportunity, proposal=====' + res);
        }

        List<Apttus_Proposal__Proposal__c> propList;
        Apttus_Proposal__Proposal__c proposalQ;
        // Create Proposal
        if (inputParam.proposalAction == 'Create' && ref.opportunityId != null) {
            Opportunity opportunity;
            LCRM_Contact_SSD__c contactSSD;
            
            if (Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()) {
                opportunity = [SELECT Id, ownerId, description FROM Opportunity WHERE Id = :ref.opportunityId];
            }
            
            if (Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()) {
                contactSSD = [
                    SELECT Id, LCRM_Contact__c, LCRM_Email__c, Name, LCRM_Account_SSD__c, LCRM_Account_SSD__r.Account_Name__c, LCRM_Account_SSD__r.LCRM_Customer_Group__c 
                    FROM LCRM_Contact_SSD__c WHERE LCRM_Contact__c = :ref.contactId
                ];
            }

            propList = Ecom_ProposalService.proposalCreation(ref.opportunityId,opportunity.ownerId, contactSSD, stores[0],storeOrder.plan); 
            proposalQ = [
                SELECT Id, Name, DC_Contract_Not_In_Sync__c, Apttus_Proposal__Proposal_Name__c, APTS_Order_Confirmation_Contact_Email__c, 
                    Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_Quote_Value__c, Apttus_Proposal__Account__r.Name, 
                    APTS_Order_Confirmation_Contact_Name__c, Apttus_Proposal__Account__r.billingstreet,
                    Apttus_Proposal__Account__r.billingcity, Apttus_Proposal__Account__r.billingstate, Apttus_Proposal__Account__r.billingcountry,
                    Apttus_Proposal__Account__r.phone, Apttus_Proposal__Account__r.billingPostalCode, APTS_Payment_Option__c 
                FROM Apttus_Proposal__Proposal__c WHERE Id = :propList[0].Id
            ];

            res.proposalNumber = proposalQ.Name;    // Send Proposal Number in response to AEM
            res.proposalId = proposalQ.Id;       
        }   //end of proposal Creation   
        
        String encryptedData;
        //Send Encrpted Data to AEM, which is required for Payment Section
        if (res.proposalId != null && inputParam.generatePaymentURL == true) {
            String quoteId = (res.proposalId != null) ? res.proposalId : (ref.proposalId != null) ? ref.proposalId : null;
            
            if (quoteId != null && proposalQ == Null && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
                proposalQ = [
                    SELECT Id, Name, DC_Contract_Not_In_Sync__c, Apttus_Proposal__Proposal_Name__c, APTS_Order_Confirmation_Contact_Email__c, 
                        Apttus_Proposal__Account__r.SAPAccountNumber__c,APTS_Quote_Value__c, Apttus_Proposal__Account__r.Name, 
                        APTS_Order_Confirmation_Contact_Name__c, Apttus_Proposal__Account__r.billingstreet, Apttus_Proposal__Account__r.billingcity, 
                        Apttus_Proposal__Account__r.billingstate, Apttus_Proposal__Account__r.billingcountry, Apttus_Proposal__Account__r.phone, 
                        Apttus_Proposal__Account__r.billingPostalCode, APTS_Payment_Option__c 
                    FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteId
                ];
            }   // end of proposal query check

            encryptedData = Ecom_ProposalService.encryption(proposalQ);         // Create Encrypted Data
            res.b64Data = encryptedData;
        }   // end of check for proposal Id
        
        Apttus_Config2__ProductConfiguration__c prodConfig;
        // Create Cart  
        if (ref.proposalId != null && inputParam.cartAction == 'Create') {
            List<Apttus_Proposal__Proposal__c> propCart = [
                SELECT Id, OwnerId, APTS_SSD_ship_to__c, APTS_SSD_bill_to__c, APTS_SSD_Sold_To__c, Name, DC_Contract_Not_In_Sync__c, Apttus_Proposal__Account__c 
                FROM Apttus_Proposal__Proposal__c WHERE Id = :ref.proposalId
            ];
            
            res.proposalNumber = propCart[0].Name;
            res.contractNotInSync = propCart[0].DC_Contract_Not_In_Sync__c;
            prodConfig = Ecom_Cart.createCart(propCart,storeOrder, stores); 
            res.cartId = prodConfig.Id;
            res.isLeadConverted = true;
        }
        
        if (inputParam.opportunityAction == 'Update' && ref.opportunityId != null && isGetQuoteClicked == true) {
            Opportunity oppUp = new Opportunity();
            oppUp.Id = ref.opportunityId;

            Boolean result = false;
            if (oppUp.description != null) {
                result = oppUp.description.contains(Label.Ecom_GetQuote_Clicked);
            }
            
            if (result == false) {
                oppUp.Description =  oppUp.Description + ' ' + Label.Ecom_GetQuote_Clicked;
            }
            
            update oppUp;  
        }
        
        if (inputParam.opportunityAction == 'Update' && ref.opportunityId != null) {
            Opportunity oppUpd = new Opportunity();
            oppUpd.Id = ref.opportunityId;
            
            if (storeOrder.promocode != null) {
                oppUpd.Digital_Promo_Code__c = storeOrder.promocode;
            } else {
                oppUpd.Digital_Promo_Code__c = '';
            } 
            
            if (Schema.sObjectType.Opportunity.isUpdateable()) { update oppUpd; }  
        }
        
        if (inputParam.cartAction == 'Update' && ref.cartId != null && Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()) {
            Apttus_Config2__Order__c oder = [SELECT Id, name, APTSECOM_Plan_Name__c FROM Apttus_Config2__Order__c WHERE Id = :ref.orderId]; 
            
            List<Apttus_Config2__ProductConfiguration__c> carts;
            if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() && Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()) {
                carts = [
                    SELECT Id, Apttus_Config2__Status__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Promo_Code__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                        (SELECT Id, Apttus_Config2__ProductId__c, Apttus_Config2__Quantity__c, APTS_Contract_Term__c, APTS_Proposal_Business_Unit__c,
                                Apttus_Config2__OptionId__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__AdjustmentType__c,
                                APTS_Combination_Key__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c
                        FROM Apttus_Config2__LineItems__r)  
                    FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :ref.cartId
                    WITH SECURITY_ENFORCED
                ]; 
            }
            
            Ecom_StoreResponse.Adjustments adjustments = getAggregatedAdjustments(stores[0]);
            String planName = oder.APTSECOM_Plan_Name__c;  
            system.debug(logginglevel.INFO, '===check====' + carts);
            
            // Update Products and Quote's cart
            updateProducts(carts, stores[0], storeOrder, planName, adjustments, true, res, ref);
        }
        
        // DLT-10316, 10317
        system.debug(logginglevel.INFO, '===inputParam.placeOrder====' + inputParam.placeOrder);
        system.debug(logginglevel.INFO, '===ref.opportunityId====' + ref.opportunityId);
        system.debug(logginglevel.INFO, '===ref.accountId====' + ref.accountId);
        system.debug(logginglevel.INFO, '===ref.contactId====' + ref.contactId);
        if (inputParam.placeOrder != null && ref.opportunityId != null && ref.accountId != null && ref.contactId != null && inputParam.placeOrder) {
            Ecom_Opportunity.updateOpportunityWithCampaignCode(ref, storeOrder);    // update opp with promo code and campaign code
            Ecom_ProposalService.updateProposalOnPlaceOrder(ref, storeOrder);
            system.debug(logginglevel.INFO, '===cxd place order status bug====' + inputParam.placeOrder);
            
           /*  if ( ref.proposalId != null) {
                System.debug('===cxd proposalId bug====' + ref.proposalId);     // Commented this and made this change in NSE process builder
                Ecom_NonTrailPromoPassword.promotionCall(ref.proposalId);
            }    */
        }
        
        Boolean isRepricePending = false;
        // Reprice Cart  
        if (inputParam.repriceCart == true && res.cartId != null && ref.repricePending != false) {                    
            isRepricePending = Ecom_ProposalService.reprice(string.valueOf(res.cartId));
            res.repriceCart = isRepricePending;
            res.isLeadConverted = true;
        } else {            
            res.repriceCart = isRepricePending; 
        }
        system.debug(logginglevel.INFO, '====response====' + res);
                                                   
        return res;
    }   // end of else if update actions 
    
    // updateProposal()
    public void updateProposal(String proposalId, String shipToSSD, Ecom_OrderRequest.cls_customerDetails customerDetails) {
        Apttus_Proposal__Proposal__c propUpdate = new Apttus_Proposal__Proposal__c();
        propUpdate.Id = proposalId;  
        propUpdate.APTS_Order_Confirmation_Contact_Email__c = customerDetails.businessEmail;
        
        if (String.isNotBlank(shipToSSD)) { 
            propUpdate.APTS_SSD_ship_to__c = shipToSSD; 
        }
        
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) { update propUpdate; }
    }
    
    /**
     *  requestToResponse()
     */
    public void requestToResponse(UpdatedMethodResponse res, Ecom_OrderRequest.cls_references ref) {
        res.orderId = ref.orderId;
        res.leadId = ref.leadId;    
        res.accountId = ref.accountId;   
        res.contactId = ref.contactId;     
        res.opptyId = ref.opportunityId;   
        res.proposalId = ref.proposalId; 
        res.cartId = ref.cartId;
        res.orderNumber = ref.orderNumber;
        res.proposalNumber = ref.proposalNumber;
        res.repriceCart = ref.repricePending;
        res.contractNotInSync = false;
        res.isLeadConverted = false;
        
        system.debug(logginglevel.INFO, '======response in new method=====' + res);
    } 
    
    /**
     *  Order will return based on orderId passed as parameter. If record is not available,
     *  New record will be created based on Store passed as parameter.
     */ 
    public Apttus_Config2__Order__c createOrder(APTSECOM_Store__c store, String orderId, Ecom_OrderRequest.cls_storeOrder storeOrder) {
        if (String.isNotBlank(orderId)) {
            Apttus_Config2__Order__c o = [SELECT Id, Name FROM Apttus_Config2__Order__c WHERE Id = :orderId AND Apttus_Config2__Status__c = 'New'];
            
            if (o != null) { return o; }
        }
        
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Status__c = 'New';
        order.Apttus_Config2__PricingDate__c = System.today();
        order.APTSECOM_Store__c = store.Id;
        order.APTSECOM_Total_Price__c = storeOrder.totalPrice;
        order.APTSECOM_Plan_Name__c = storeOrder.plan;
        order.Apttus_Config2__PriceListId__c = store.APTSECOM_Price_List__c;
        order.Apttus_Config2__OrderDate__c = System.today();
        
        if (storeOrder != null) {
            String data = Json.serialize(storeOrder);
            order.APTSECOM_Customer_Details__c = data;
        }
        
        if (Schema.sObjectType.Apttus_Config2__Order__c.isCreateable()) { insert order; }
        
        return [SELECT Id, Name FROM Apttus_Config2__Order__c WHERE Id = :order.Id];
    }
    
    /**
     *  add multiple products to cart based on products passed as a parameter using Apttus API.
     *  Method is reused in Ecom_Cart 
     */ 
    public static void addMultipleProducts(String cartId, List<Ecom_OrderRequest.cls_selectedProducts> selProducts, String planId, APTSECOM_Store__c store, Ecom_StoreResponse.Adjustments adjustments) {
        
        // DLT-19135 START
        List<Ecom_OrderRequest.cls_selectedProducts> products = new List<Ecom_OrderRequest.cls_selectedProducts>();
        if (store.Ecom_Has_Bundles__c) {
            // adds bundle to cart and returns any products that dont belong in bundle
            products = addBundleProducts(cartId, selProducts, store, adjustments);
            if (products.isEmpty()) { return; }
        } else {
            products = selProducts.clone();
        }
        // DLT-19135 END
        
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO addMultiProdRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        addMultiProdRequest.cartId = cartId;
        addMultiProdRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        
        for(Ecom_OrderRequest.cls_selectedProducts data : products) {
            Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
            addCustomValuesToLineItem(data, customData, store, adjustments);

            Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            selectedProduct.productId = data.productId;
            selectedProduct.Quantity = data.quantity;
            selectedProduct.comments = 'Inserted via Ecommerce';
            
            Map<String, Object> line = customData.getPopulatedFieldsAsMap(); 
            system.debug(logginglevel.INFO, 'line >> ' + line);
            if(line.keySet() != null && line.keySet().size() > 0) {
                List<String> allFields = new List<String>(line.keySet());
                selectedProduct.CustomFields = allFields;
                selectedProduct.CustomData = customData; 
            }

            addMultiProdRequest.selectedProducts.add(selectedProduct);
        }  
        system.debug(logginglevel.INFO, 'addMultiProdRequest >> ' + addMultiProdRequest);

        try {
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultiProdResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(addMultiProdRequest); 
            //Added DLT-19857
            //Workaround for Apttus Summer '19 known issues with addMultiProducts() api
            //Method takes in cart id and List<Apttus_CPQApi.CPQ.SelectedProductDO>
            Digital_CartCreationCommonCode.updateLineItemFields(addMultiProdRequest.cartId,addMultiProdRequest.SelectedProducts);
        } catch (Exception e) {
            system.debug(logginglevel.INFO, 'try > addMultiProdResponse > ' + e);
        }
    } 
    
    /** DLT-19135
     *  adds bundle products to cart based on selProducts passed as a parameter using Apttus API.
     *  returns list of remaining selected products that were not included in bundle.
     *  Method is reused in Ecom_Cart 
     */ 
    public static List<Ecom_OrderRequest.cls_selectedProducts> addBundleProducts(String cartId, List<Ecom_OrderRequest.cls_selectedProducts> selProducts, APTSECOM_Store__c store, Ecom_StoreResponse.Adjustments adjustments) {
        // return list of non bundle products to be added to cart
        List<Ecom_OrderRequest.cls_selectedProducts> nonBundleProducts = selProducts.clone();

        // build bundle product details
        Ecom_OrderRequest.cls_selectedProducts bundleProd = getSelectedBundleProduct(selProducts);
        String bundleId = bundleProd.productId;
        //bundleId = System.Label.Ecom_CorpWL_StoreBundleId;   // 01t13000005xfiW : GC Essentials
        
        Integer i = nonBundleProducts.indexOf(bundleProd);
        nonBundleProducts.remove(i);
        
        // build bundle request
        Apttus_CPQApi.CPQ.AddBundleRequestDO addBundleRequest = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
        addBundleRequest.cartId = cartId;
        addBundleRequest.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
        addBundleRequest.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
        addBundleRequest.SelectedBundle.SelectedProduct.ProductId = bundleId;
        addBundleRequest.SelectedBundle.SelectedProduct.Quantity = selProducts[0].quantity;
        addBundleRequest.SelectedBundle.SelectedProduct.Comments = 'Inserted via Ecommerce';

        // add custom data
        Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
        addCustomValuesToLineItem(bundleProd, customData, store, adjustments);

        Map<String, Object> line = customData.getPopulatedFieldsAsMap(); 
        system.debug(logginglevel.INFO, 'line > ' + line);
        if ( (line.keySet() != null) && (line.keySet().size() > 0) ) {
            List<String> allFields = new List<String>(line.keySet());
            addBundleRequest.SelectedBundle.SelectedProduct.CustomFields = allFields;
            addBundleRequest.SelectedBundle.SelectedProduct.CustomData = customData;
        }
        
        // get product options form bundle group
        List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> pocList = getBundleProdOptComponents(store.APTSECOM_Price_List__c, bundleId);

        // add options products to bundle request
        for (Ecom_OrderRequest.cls_selectedProducts prod : selProducts) {
            Apttus_CPQApi.CPQ.SelectedOptionDO option = getOptionProduct(pocList, prod, store, adjustments);
            if (option != null) {
                // if product is in options group, add to bundle, remove from list
                addBundleRequest.SelectedBundle.SelectedOptions.add(option);
                
                i = nonBundleProducts.indexOf(prod);
                nonBundleProducts.remove(i);
            }
        }
    
        try {
            if (!Test.isRunningTest()) {
                Apttus_CPQApi.CPQ.AddBundleResponseDO addBundleResponse = Apttus_CPQApi.CPQWebService.addBundle(addBundleRequest);
            } else {
                Apttus_CPQApi.CPQ.AddBundleResponseDO addBundleResponse = null;
            }
        } catch (Exception e) {
            system.debug(logginglevel.INFO, ' try > addBundleResponse > ' + e);
        }
        
        // update points on attributes
        Set<String> prodIdSet = new Set<String>();
        for (Ecom_OrderRequest.cls_selectedProducts sp : selProducts) {
            prodIdSet.add(sp.productId);
        }
        updatePointsOnProdAttributeValue(cartId, prodIdSet);

        // update cart price
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO updatePriceRequest = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();                       
        updatePriceRequest.CartId = cartId;
        
        if (!Test.isRunningTest()) {
            try {
                Apttus_CpqApi.CPQ.UpdatePriceResponseDO updatePriceResponse = Apttus_CpqApi.CPQWebService.updatePriceForCart(updatePriceRequest);
                while (updatePriceResponse.IsPricePending) {
                    updatePriceResponse = Apttus_CpqApi.CPQWebService.updatePriceForCart(updatePriceRequest);
                }
            } catch (Exception e) {
                system.debug(logginglevel.ERROR, 'try > updatePriceResponse > ' + e);
            }
        }

        return nonBundleProducts;
    }

    /** DLT-19135
     *  getBundleProdOptComponents
     */ 
    public static List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> getBundleProdOptComponents(String priceListId, String bundleId) {
        // get apttus group options components list
        Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result;
        
        try {
            result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(priceListId, bundleId);
        } catch (Exception e) {
            system.debug(logginglevel.ERROR, 'try > getOptionGroupsForPriceListProduct > ' + e);
        }

        List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> productOptGroupList = result.OptionGroups;
        system.debug(logginglevel.INFO, 'productOptGroupList >> ' + productOptGroupList);

        List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> productOptCompList = new List<Apttus_CPQApi.CPQ.ProductOptionComponentDO>();
        for (Apttus_CPQApi.CPQ.ProductOptionGroupDO pog : productOptGroupList) {
            if (pog.HasOptionComponents) {
                productOptCompList = pog.OptionComponents;
                system.debug(logginglevel.INFO, 'productOptCompList >> ' + productOptCompList);
            }
        }

        return productOptCompList;
    }

    /** DLT-19135
     *  getSelectedBundleProduct
     */ 
    public static Ecom_OrderRequest.cls_selectedProducts getSelectedBundleProduct(List<Ecom_OrderRequest.cls_selectedProducts> products) {
        // find bundle product
        for (Ecom_OrderRequest.cls_selectedProducts prod : products) {
            if (prod.cType.equalsIgnoreCase('Bundle')) { return prod; }
        }

        // no bundle found
        system.debug(logginglevel.INFO, 'No Bundle Product found in selected products >> ' + products);
        return null;
    }

    /** DLT-19135
     *  getOptionProduct
     */
    public static Apttus_CPQApi.CPQ.SelectedOptionDO getOptionProduct(List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> productOptCompList, Ecom_OrderRequest.cls_selectedProducts product, APTSECOM_Store__c store, Ecom_StoreResponse.Adjustments adjustments) {
        Boolean optProdCodeMatchesPocProdCode = false;
        Product2 optProduct = [SELECT Id, ProductCode FROM Product2 WHERE Id = :product.productId WITH SECURITY_ENFORCED];

        // add options products to bundle request
        if (!productOptCompList.isEmpty()) {
            for (Apttus_CPQApi.CPQ.ProductOptionComponentDO poc : productOptCompList) {
                optProdCodeMatchesPocProdCode = (optProduct.ProductCode == poc.ProductCode);
    
                if (optProdCodeMatchesPocProdCode) { 
                    Apttus_CPQApi.CPQ.SelectedOptionDO selectedOption = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                    selectedOption.ComponentId = poc.ComponentId;
                    selectedOption.ComponentProductId = poc.ComponentProductId;
                    selectedOption.Quantity = product.quantity;
    
                    // add custom data
                    Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
                    addCustomValuesToLineItem(product, customData, store, adjustments);
    
                    Map<String,Object> line = customData.getPopulatedFieldsAsMap();
                    system.debug(logginglevel.INFO, 'line > ' + line);
                    
                    if ( (line.keySet() != null) && (line.keySet().size() > 0) ) {
                        List<String> allFields = new List<String>(line.keySet());
                        selectedOption.CustomFields = allFields;
                        selectedOption.CustomData = customData; 
                    }

                    system.debug(logginglevel.INFO, 'selectedOption > ' + selectedOption);
                    return selectedOption;
                }
            }
        }

        return null;
    }

    /** DLT-19135
     *  update total points under productAttributeValue of bundleProduct line item
     */
    public static void updatePointsOnProdAttributeValue(String cartId, Set<String> prodIdSet) {
        
        // sum points FROM selected options
        Decimal points = 0;
        for (Product2 prod : [
            SELECT Id, APTS_Module_Points__c
            FROM Product2 WHERE Id IN :prodIdSet ]) {
                
                if (prod.APTS_Module_Points__c != null) {
                    points += prod.APTS_Module_Points__c;
                }
        }
        system.debug(logginglevel.INFO, 'points > ' + points);

        // get line items FROM cart
        Set<String> lineItemIdSet = new Set<String>();
        if (Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()) {
            for (Apttus_Config2__LineItem__c line : [
                    SELECT Id, Apttus_Config2__ProductId__c FROM Apttus_Config2__LineItem__c 
                    WHERE Apttus_Config2__ConfigurationId__c = :cartId AND Apttus_Config2__HasOptions__c = true 
                    AND Apttus_Config2__ProductId__c IN :prodIdSet ]) {
                lineItemIdSet.add(line.Id);
            }
            system.debug(logginglevel.INFO, 'lineItemIdSet > ' + lineItemIdSet);
        }
        
        // get Apttus_Config2__ProductAttributeValue__c associated with line items
        List<Apttus_Config2__ProductAttributeValue__c> prodAttributeValList = [
            SELECT Id, APTS_Total_Number_of_Points__c, Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c
            FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c IN :lineItemIdSet
            WITH SECURITY_ENFORCED
        ];

        if (!prodAttributeValList.isEmpty() && Schema.sObjectType.Apttus_Config2__ProductAttributeValue__c.isUpdateable()) {
            for (Apttus_Config2__ProductAttributeValue__c attr : prodAttributeValList) {
                attr.APTS_Total_Number_of_Points__c = points;
            }
            update prodAttributeValList;
            system.debug(logginglevel.INFO, 'prodAttributeValList > ' + prodAttributeValList);
        }
    }
    
    // add custom Values to LineItem object   
    public static void addCustomValuesToLineItem(Ecom_OrderRequest.cls_selectedProducts data, Apttus_Config2__LineItem__c customData, APTSECOM_Store__c store, Ecom_StoreResponse.Adjustments adjustments) {
                                                     
        List<Product2> pdc = [
            SELECT id, name, (SELECT id FROM Attribute_Value_Combination__r LIMIT 1) 
            FROM Product2 
            WHERE id =: data.productId
            WITH SECURITY_ENFORCED
        ];
        DCUtils.addToLineItem(customData, 'Apttus_Config2__BillingFrequency__c', 'Monthly'); 
        customData.Apttus_Config2__AdjustmentAmount__c = adjustments.adjustmentAmount;
        DCUtils.addToLineItem(customData, 'Apttus_Config2__AdjustmentType__c', adjustments.adjustmentType);      
        DCUtils.addToLineItem(customData, 'APTS_Contract_Term__c', data.contractTerm);
        
        if (store.name == 'Findlaw') {
            if (data.isRecommendedProduct != 'true') {
                DCUtils.addToLineItem(customData, 'APTS_Combination_Key__c', data.combinationId);    
                customData.Apttus_Config2__IsCustomPricing__c = true;
            }
            customData.Apttus_Config2__ChargeType__c = 'Subscription Fee'; 
            customData.Apttus_Config2__Quantity__c = 1;
            customData.APTS_FL_Qty__c = data.quantity;
        }
        // DLT-21293 we do not need to apply these adjustments
        // if it is a addon product we should get adjustments FROM Store laevel
        /*
        if (String.isNotBlank(data.isRecommendedProduct) && 'true'.equalsIgnoreCase(data.isRecommendedProduct)) {
            Ecom_StoreResponse.Adjustments addOnAdjustments = new Ecom_StoreResponse.Adjustments();
            addOnAdjustments.adjustmentAmount = (store.APTSECOM_Adjustment_Amount__c == null) ? 
                0 : store.APTSECOM_Adjustment_Amount__c;
            addOnAdjustments.adjustmentType = String.isBlank(store.APTSECOM_Adjustment_Type__c) ? 
                Label.DC_PERCENT_DISCOUNT : store.APTSECOM_Adjustment_Type__c;
            // addOnAdjustments = getPromoCodeAdjustments( addOnAdjustments, store);
            customData.Apttus_Config2__AdjustmentAmount__c = addOnAdjustments.adjustmentAmount;
            customData.Apttus_Config2__AdjustmentType__c = addOnAdjustments.adjustmentType;
        }
        */
        if (store != null && store.New_Sales_Contract_Term_Settings__r.size() > 0) {
            String yoY1 = (store.New_Sales_Contract_Term_Settings__r[0].YoY_1__c == null) ? 
                '' : String.valueof(Integer.valueof(store.New_Sales_Contract_Term_Settings__r[0].YoY_1__c) );
            String yoY2 = (store.New_Sales_Contract_Term_Settings__r[0].YoY_2__c == null) ? 
                '' : String.valueof(Integer.valueof(store.New_Sales_Contract_Term_Settings__r[0].YoY_2__c) );
            system.debug(logginglevel.INFO, ' YoY2 > ' + yoY2 +'<> ' + yoY1);
            DCUtils.addToLineItem(customData, 'APTS_Yr_1_Renewal_Adjustment__c', yoY1);
            DCUtils.addToLineItem(customData, 'APTS_Years_2_Plus_Adjustment__c', yoY2);
        }     
    }
    
    // aggregate the adjustment of plan level adjustments and contract level adjustments 
    public static Ecom_StoreResponse.Adjustments getAggregatedAdjustments(APTSECOM_Store__c store) {
        Ecom_StoreResponse.Adjustments adjustments = new Ecom_StoreResponse.Adjustments();
        adjustments.adjustmentType = Label.DC_PERCENT_DISCOUNT;
        adjustments.adjustmentAmount = 0;
        
        if (store != null) {
            if (store.Store_Price_Adjustments__r.size() > 0 && String.isNotBlank(store.Store_Price_Adjustments__r[0].APTSECOM_Adjustment_Type__c) ){
                adjustments.adjustmentType = store.Store_Price_Adjustments__r[0].APTSECOM_Adjustment_Type__c;
                adjustments.adjustmentAmount = store.Store_Price_Adjustments__r[0].APTSECOM_Adjustment_Amount__c == null ? 
                    0 : store.Store_Price_Adjustments__r[0].APTSECOM_Adjustment_Amount__c;
            }
            
            if (store.New_Sales_Contract_Term_Settings__r.size() > 0) {
                adjustments = Ecom_StoreService.calculateAdjustment(
                    store.New_Sales_Contract_Term_Settings__r[0].Adjustment_Amount__c, 
                    store.New_Sales_Contract_Term_Settings__r[0].Adjustment_Type__c, 
                    adjustments.adjustmentAmount, 
                    adjustments.adjustmentType
                );
            }    
        }
        
        // adjustments = getPromoCodeAdjustments( adjustments, store);
        System.debug(LoggingLevel.ERROR, 'end getAggregatedAdjustments > ' + adjustments);
        return adjustments;                
    }
    
    // Updating the lineitem if we change the quantity,contract term and plan
    public void updateProducts(List<Apttus_Config2__ProductConfiguration__c> carts, APTSECOM_Store__c store, 
                               Ecom_OrderRequest.cls_storeOrder storeOrder, String plan, Ecom_StoreResponse.Adjustments adjustments, 
                               Boolean isProposalCart, UpdatedMethodResponse res, Ecom_OrderRequest.cls_references ref) {
        
        if (carts == null || carts.isEmpty()) { return; }
        
        String oldPromoCode = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Promo_Code__c;
        String newPromoCode = storeOrder.promoCode;
        Boolean ischanged = false;
        Boolean isAttorneyChanged = false;
        
        // if Digital PromoCode is null set to empty to avoid unnecessary lineItem updates                           
        if (oldPromoCode == null) {
            oldPromoCode = '';                           
        }
        
        if (newPromoCode != oldPromoCode) {
            // update opportunity               
            String promo;
            Opportunity opp = new Opportunity();
            opp.Id = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c ;
            
            if (store.Store_Promotions__r != null && store.Store_Promotions__r.size() > 0){
                promo = store.Store_Promotions__r[0].IncentiveId__r.Apttus_Config2__IncentiveCode__c;
                opp.Digital_Promo_Code__c = newPromoCode;
                update opp;
                updatePromoCodeOnCart(carts, promo);
                ischanged = true;
            }
            else if (String.isBlank(newPromoCode)){
                promo = '';
                opp.Digital_Promo_Code__c = newPromoCode;
                update opp;
                updatePromoCodeOnCart(carts, promo);
                ischanged = true;
            }
        }
        
        if (storeOrder.plan == plan) {
            if (carts[0].Apttus_Config2__LineItems__r != null && storeOrder.selectedProducts != null) {
                Map<String, Apttus_Config2__LineItem__c> productIdToLine = new Map<String, Apttus_Config2__LineItem__c>();
                
                for (Apttus_Config2__LineItem__c  line : carts[0].Apttus_Config2__LineItems__r) {
                    //If Option Product exists map it instead of the Product
                    if(line.Apttus_Config2__OptionId__c != null){
                        productIdToLine.put(line.Apttus_Config2__OptionId__c, line);
                    }
                    else{
                        productIdToLine.put(line.Apttus_Config2__ProductId__c, line);
                    }
                }
                
                List<Ecom_OrderRequest.cls_selectedProducts> addProducts = new List<Ecom_OrderRequest.cls_selectedProducts>();
                List<Apttus_Config2__LineItem__c> lineUpdates = new List<Apttus_Config2__LineItem__c>();
                
                for (Ecom_OrderRequest.cls_selectedProducts selectedProduct : storeOrder.selectedProducts) {
                    if (productIdToLine.containsKey(selectedProduct.productId)) {
                        Apttus_Config2__LineItem__c line = productIdToLine.get(selectedProduct.productId);
                        
                        if (line.APTS_Proposal_Business_Unit__c == 'Findlaw') {
                            line.APTS_Combination_Key__c = selectedProduct.combinationId;
                        }
                        // if any change is happened tp quantity, contractTerm need to update the line items
                        if ( (selectedProduct.quantity != null && selectedProduct.quantity != line.Apttus_Config2__Quantity__c) 
                           || (selectedProduct.contractTerm != null && selectedProduct.contractTerm != line.APTS_Contract_Term__c)) {
                               
                               line.Apttus_Config2__Quantity__c = selectedProduct.quantity;
                               line.Apttus_Config2__PricingStatus__c = 'Pending';
                               
                               addCustomValuesToLineItem(selectedProduct, line, store, adjustments);
                               line.APTS_Contract_Term__c = selectedProduct.contractTerm;
                               lineUpdates.add(line);
                               isAttorneyChanged = true;
                        }
                        productIdToLine.remove(selectedProduct.productId);
                    }else {
                        addProducts.add(selectedProduct); 
                    }
                }
                
                if (!lineUpdates.isEmpty() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()) {
                    ischanged = true;
                    update lineUpdates;
                }
                
                if (!addProducts.isEmpty()) {
                    ischanged = true;
                    addMultipleProducts(carts[0].Id, addProducts, storeOrder.planId, store, adjustments); 
                }
                
                if (productIdToLine != null && productIdToLine.size() > 0) {
                    ischanged = true;
                    delete productIdToLine.values();
                }
                
                if (ischanged) {
                    // To update Contract Not In sync Flag on proposal 
                    Boolean flag = updateContractNotInSyncFlag(ref.proposalId, isProposalCart, res);   
                    // if Quote Line items are deleted then update cart finalze date as empty
                    carts[0].Apttus_Config2__FinalizedDate__c = null;
                    
                    if ( storeOrder.plan != null && System.Label.Ecom_PlanNames.contains(storeOrder.plan) ) {
                        carts[0].Apttus_Config2__Status__c = 'New';     
                        flag = true;
                    }
                    
                    if (flag) { update carts[0]; }
                } 
            }
        } else {   
            delete carts[0].Apttus_Config2__LineItems__r;
            addMultipleProducts(carts[0].Id, storeOrder.selectedProducts, storeOrder.planId, store, adjustments); 
            
            if (carts[0].Apttus_Config2__LineItems__r != null && storeOrder.selectedProducts != null) {
                Map<String, Apttus_Config2__LineItem__c> productIdToLine = new Map<String, Apttus_Config2__LineItem__c>();
                
                for (Apttus_Config2__LineItem__c  line : carts[0].Apttus_Config2__LineItems__r) {
                    productIdToLine.put(line.Apttus_Config2__ProductId__c, line);
                }
                
                for (Ecom_OrderRequest.cls_selectedProducts selectedProduct : storeOrder.selectedProducts) {
                    if ( productIdToLine.containsKey(selectedProduct.productId) ) {
                        Apttus_Config2__LineItem__c line = productIdToLine.get(selectedProduct.productId);
                        if ( (selectedProduct.quantity != null && selectedProduct.quantity != line.Apttus_Config2__Quantity__c) 
                           || (selectedProduct.contractTerm != null && selectedProduct.contractTerm != line.APTS_Contract_Term__c) ) {
                               
                               isAttorneyChanged = true;
                        }
                    }
                }
            }
            
            if (isProposalCart) {
                // To update Contract Not In sync Flag on proposal 
                Boolean flag = updateContractNotInSyncFlag(ref.proposalId, isProposalCart, res);
                
                if ( storeOrder.plan != null && System.Label.Ecom_PlanNames.contains(storeOrder.plan) ) {
                    carts[0].Apttus_Config2__Status__c = 'New';
                    carts[0].Apttus_Config2__FinalizedDate__c = null;
                    update carts[0];
                } else if ( (carts[0].Apttus_Config2__Status__c != 'Finalized') || flag ) {
                    carts[0].Apttus_Config2__Status__c = 'Finalized';
                    carts[0].Apttus_Config2__FinalizedDate__c = null;
                    update carts[0];
                }   
            }
        }
    }
    
    // updatePromoCodeOnCart()
    public void updatePromoCodeOnCart(List<Apttus_Config2__ProductConfiguration__c> carts, string promoCode) {
        carts[0].Apttus_Config2__CouponCodes__c = promoCode;
        update carts[0];
    }
    
    // Contract Not Sync flag will be update here. if any change is there then we should set it as a True.  
    public Boolean updateContractNotInSyncFlag(String proposalId, Boolean isProposalCart, UpdatedMethodResponse res) {
        if (proposalId != null && isProposalCart) {
            Apttus_Proposal__Proposal__c propUpdateFlag = new Apttus_Proposal__Proposal__c ();
            propUpdateFlag.Id = proposalId;  
            propUpdateFlag.DC_Contract_Not_In_Sync__c = true;
            
            List<Apttus_Proposal__Proposal__c> proposals;
            if ( Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.APTS_Dynamic_Bundle__c.isAccessible() ) {
                proposals = [
                    SELECT Id, ( SELECT Id, Name FROM Dynamic_Bundles__r ), ( SELECT Id FROM Apttus_Proposal__R00N70000001yUfBEAU__r )
                    FROM Apttus_Proposal__Proposal__c 
                    WHERE Id =: proposalId
                    WITH SECURITY_ENFORCED
                ];
            }
            res.contractNotInSync = true;
            update propUpdateFlag;
            
            if (!proposals.isEmpty()) {
                if (proposals[0].Dynamic_Bundles__r != null && !proposals[0].Dynamic_Bundles__r.isEmpty() ) {
                    delete proposals[0].Dynamic_Bundles__r;
                }
                
                if (proposals[0].Apttus_Proposal__R00N70000001yUfBEAU__r != null && !proposals[0].Apttus_Proposal__R00N70000001yUfBEAU__r.isEmpty() ) {
                    delete proposals[0].Apttus_Proposal__R00N70000001yUfBEAU__r;
                    return true;
                }
            }
        }
        
        return false;
    }

    // getStoreList()
    public List<APTSECOM_Store__c> getStoreList(Ecom_OrderRequest.cls_storeOrder storeOrder) {
        List<APTSECOM_Store__c> stores;
        
        Date getToday = System.today();
        Integer quantity = storeOrder.selectedProducts[0].quantity;
        String contractTerm = storeOrder.selectedProducts[0].contractTerm;

        if (Schema.sObjectType.APTSECOM_Store__c.isQueryable() 
            && Schema.sObjectType.APTSECOM_Store_Price_Adjustment__c.isQueryable() 
            && Schema.sObjectType.New_Sales_Contract_Term_Setting__c.isQueryable() 
            && Schema.sObjectType.APTSECOM_Store_Promotion__c.isQueryable() ) {
                   
                stores = [
                    SELECT Id, Name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, 
                        APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Default_Contract_Term__c, Ecom_Has_Bundles__c,
                        (SELECT Id, Name, APTSECOM_Category_Hierarchy__c, APTSECOM_Adjustment_Type__c, APTSECOM_Adjustment_Amount__c 
                            FROM Store_Price_Adjustments__r WHERE APTSECOM_Category_Hierarchy__c = :storeOrder.planId),
                        (SELECT Id, Name, Adjustment_Amount__c, Adjustment_Type__c, Related_Category_Hierarchy__c, YoY_1__c, YoY_2__c, Contract_Term__c 
                            FROM New_Sales_Contract_Term_Settings__r
                            WHERE Related_Category_Hierarchy__c = :storeOrder.planId AND Contract_Term__c = :contractTerm),
                        (SELECT Id, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Promo_Code__c, IncentiveId__r.Apttus_Config2__IncentiveCode__c
                            FROM Store_Promotions__r  
                            WHERE APTSECOM_Is_Active__c = true AND APTSECOM_Promo_Code__c = :storeOrder.promoCode 
                            AND APTSECOM_Start_Date__c <= :getToday AND APTSECOM_End_Date__c >= :getToday 
                            AND APTSECOM_Min_Quantity__c <= :quantity AND APTSECOM_Max_Quantity__c >= :quantity 
                            AND APTSECOM_Valid_Contract_Terms__c INCLUDES (:contractTerm) )
                    FROM APTSECOM_Store__c WHERE Name = :storeOrder.storeName
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                ]; 
        }
        
        return stores;
    }

    //convertAddress
    public Ecom_OrderRequest.cls_storeOrder convertAddress(Ecom_OrderRequest.cls_storeOrder storeOrder) {
        Ecom_OrderRequest.cls_storeOrder sOrder = storeOrder;

        // Change Country to Country Code Default as 'US' in request to generate Source Account Number
        if (storeOrder.customerDetails.address.country.equalsIgnoreCase('United States')) {
            sOrder.customerDetails.address.country = 'US';  
        }
        
        // To convert State DISTRICTOFCOLUMBIA to state code
        // Added null check as part of DLT-20038
        if(storeOrder.customerDetails.address.state!='' && storeOrder.customerDetails.address.state!=null){
        if ( (storeOrder.customerDetails.address.state.equalsIgnoreCase('DISTRICTOFCOLUMBIA'))
            || (storeOrder.customerDetails.address.state.equalsIgnoreCase('District Of Columbia')) ) {
                sOrder.customerDetails.address.state = 'DC';
        }
        }
        
        if ((storeOrder.customerDetails.isPhysicalSameAsBillingAddress != null) && !storeOrder.customerDetails.isPhysicalSameAsBillingAddress) {
            if (storeOrder.customerDetails.physicalAddress.country.equalsIgnoreCase('United States')) {
                sOrder.customerDetails.physicalAddress.country = 'US';  
            }
            
            // To convert State DISTRICTOFCOLUMBIA to state code
            if ((storeOrder.customerDetails.physicalAddress.state.equalsIgnoreCase('DISTRICTOFCOLUMBIA')) 
                || (storeOrder.customerDetails.physicalAddress.state.equalsIgnoreCase('district of columbia')) ) {   
                    sOrder.customerDetails.physicalAddress.state = 'DC';
            }
            sOrder.customerDetails.physicalAddress.state = Ecom_Account.stateUpdate(storeOrder.customerDetails.physicalAddress.state);
        }
        
        //Convert State Name to State Code in request to generate Source Account Number
        // Added null check as part of DLT-20038
        if(storeOrder.customerDetails.address.state!='' && storeOrder.customerDetails.address.state!=null){
        sOrder.customerDetails.address.state = Ecom_Account.stateUpdate(storeOrder.customerDetails.address.state); 
        }
        return sOrder;
    }
    
    /** 
     *  GLOBAL INNER CLASSES
     */
    global class OrderResponse {
        public String responseMessage;
        public Integer responseCode; 
    }
    
    global class UpdatedMethodResponse {
        public String orderId;
        public String leadId;
        public String accountId; 
        public String contactId;
        public String opptyId;
        public String proposalId;
        public String cartId;
        public Boolean repriceCart;
        public String responseMessage;
        public Integer responseCode;
        public String b64Data;
        public String orderNumber;
        public String proposalNumber;
        public Boolean contractNotInSync;
        public Boolean isLeadConverted;
    }
    
}