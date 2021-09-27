/*	CHANGE HISTORY
 * ==================================================================================================================================
 * Date       	Name                            Description
 * 2018-04-20   Shiva Sri Arun Koralla          DLT-7920 	[NEW CUSTOMER - Buy Plan SL] Create Prospect Account
 * 2018-06-28   Shiva Sri Arun Koralla          DLT-9978 	[GLI] Update object field references for class "Ecom_Account"
 * 2018-07-20   Shiva Sri Arun Koralla          DLT-11173 	[Code Scan] "Ecom_Account"
 * 2018-08-20   Shiva Sri Arun Koralla          DLT-10835 	[NEW CUSTOMER - Buy Plan SL/CP] Convert Lead to Account, Contact, Opportunity
 * 2018-08-28   Shiva/Ramesh					DLT-11546 	[TECH STORY- SFDC] Update calls as per new UI for checkout
 * 2018-08-28   Shiva Sri Arun Koralla          DLT-11729 	[Tech story] [Code Scan] Fix Ecom_account
 * 2018-10-12   Shiva Sri Arun Koralla          DLT-12343 	[NSE] Update GLI Salesforce Mappings
 * 2018-11-19   Ramesh Reddy					DLT-13117 	[NSE ALL] Create a 2nd SSD Account for Guest Users with different physical address
 * 2019-08-23	David Hoel						DLT-17481	Fix SSD Order Service Mapping query. Added quantity to method calls.
 * 2020-05-08	Rahul Natarajan					DLT-20038	INC3335286 | [NSE] | Post state and country value to SFDC create lead in FL cob page
 * ==================================================================================================================================*/
public with sharing class Ecom_Account {
    
    /**
     * 	Updating Bussiness Values on GLI Account
     */
    public static Account updateConvertedAccount(String accountid, APTSECOM_Store__c store, Ecom_OrderRequest.cls_storeOrder storeOrder) {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId(); 
        Integer quantity = storeOrder.selectedProducts[0].quantity;
        
        Account accountObj = new Account();
        accountObj.Id = accountId;
        accountObj.RecordTypeId = RecordTypeId;
        accountObj.Is_GLI__c = true;
        accountObj.Email__c = storeOrder.customerDetails.businessEmail;  
        accountObj.BillingStreet = storeOrder.customerDetails.address.addressLine1;
        accountObj.BillingCity = storeOrder.customerDetails.address.city;
		// DLT-20038 - Added Null Check
		if(storeOrder.customerDetails.address.state!='' && storeOrder.customerDetails.address.state!=null){
        accountObj.BillingState =  storeOrder.customerDetails.address.state;
		}
        accountObj.BillingCountry = storeOrder.customerDetails.address.country;
        accountObj.BillingPostalCode = storeOrder.customerDetails.address.zipCode;
        accountObj.Phone = storeOrder.customerDetails.phoneNumber;
        
        if(store.Name == 'FindLaw') {
            accountObj.County__c = storeOrder.customerDetails.address.county; 
        }
        
        // Splitting into multiple queries because custom metadata have limitation -- SOQL(Disjunctions not supported)
        List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;
        if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible()) {            
            lstOrderServiceMapping = [
                SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c,Ecom_Object__c, Ecom_MinAttorney__c, 
                	Ecom_MaxAttorney__c,Ecom_Field_API__c,Ecom_Field_Value__c 
                FROM Ecom_OrderService_Mappings__mdt 
                WHERE Ecom_Object__c = 'Account' 
                AND Ecom_StoreName__c =: store.Name 
                AND Ecom_MaxAttorney__c >=: quantity 
                AND Ecom_MinAttorney__c <=: quantity
            ];
        }
        
        lstOrderServiceMapping.addAll([
            SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
            	Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
            FROM Ecom_OrderService_Mappings__mdt 
            WHERE Ecom_Object__c = 'Account' 
            AND Ecom_StoreName__c =: store.Name 
            AND Ecom_MaxAttorney__c = NULL 
            AND Ecom_MinAttorney__c = NULL
        ]);
        
        lstOrderServiceMapping.addAll([
            SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
            	Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
            FROM Ecom_OrderService_Mappings__mdt 
            WHERE Ecom_Object__c = 'Account' 
            AND Ecom_StoreName__c = NULL 
            AND Ecom_MaxAttorney__c = NULL 
            AND Ecom_MinAttorney__c = NULL
        ]);
        
        for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping) {
            accountObj.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
        }
        
        if(Schema.sObjectType.Account.isUpdateable()) { update accountObj; }
        
        System.debug('=======Account Details======' + accountObj);
        
        return accountObj;
    } 

    /**
     * Update Source System Detail Account
     */
    public static Source_System_Detail__c createAccountSSD(String accountId, String oppId, Ecom_OrderRequest.cls_customerDetails info, 
                                                           APTSECOM_Store__c store, Integer quantity) {
                                                               
        List<Source_System_Detail__c> ssdAccounts = new List<Source_System_Detail__c>();
        Source_System_Detail__c ssdAcc = createSSDInstance(accountId, oppId, false, info, store, quantity);		// DLT-17481
        ssdAccounts.add(ssdAcc);
        
        if((info.isPhysicalSameAsBillingAddress != null) && (!info.isPhysicalSameAsBillingAddress)) {
            Source_System_Detail__c shipSSDAccount = ssdAcc.clone();
            shipSSDAccount.Number_Street__c = info.physicalAddress.addressLine1;
            shipSSDAccount.City__c = info.physicalAddress.city;
            shipSSDAccount.State__c = info.physicalAddress.state;
            shipSSDAccount.Country__c = info.physicalAddress.country;
            shipSSDAccount.Postal_Code__c = info.physicalAddress.zipCode;
            ssdAccounts.add(shipSSDAccount);      
        }
        
        insert ssdAccounts;
        
        return ssdAcc; 
    } 
    
    /**
     * 	createSSDInstance()
     */
    public static Source_System_Detail__c createSSDInstance(String accountId, String oppId, Ecom_OrderRequest.cls_customerDetails info, 
                                                            APTSECOM_Store__c store, Integer quantity) {
                                                                
        Source_System_Detail__c ssdAcc = SourceSystemDetailController.createSSDInstance(oppId, accountId); 
         
        // Splitting into multiple queries because custom metadata have limitation -- SOQL(Disjunctions not supported)              
        ssdAcc.name = info.organizationName;
        List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;
        
        if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible()) {
            // DLT-17481
            lstOrderServiceMapping = [
                SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
                	Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
                FROM Ecom_OrderService_Mappings__mdt 
                WHERE Ecom_Object__c = 'Source_System_Detail__c' 
                AND Ecom_StoreName__c =: store.Name
                AND Ecom_MaxAttorney__c >=: quantity 
                AND Ecom_MinAttorney__c <=: quantity
            ];        
        }
        
        lstOrderServiceMapping.addAll([
            SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
            	Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
            FROM Ecom_OrderService_Mappings__mdt 
            WHERE Ecom_Object__c = 'Source_System_Detail__c' 
            AND Ecom_StoreName__c =: store.Name
            AND Ecom_MaxAttorney__c >=: NULL 
            AND Ecom_MinAttorney__c <=: NULL
        ]);
                                                                
        lstOrderServiceMapping.addAll([
            SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
            	Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
            FROM Ecom_OrderService_Mappings__mdt 
            WHERE Ecom_Object__c = 'Source_System_Detail__c' 
            AND Ecom_StoreName__c =: NULL
            AND Ecom_MaxAttorney__c >=: NULL 
            AND Ecom_MinAttorney__c <=: NULL
        ]);
        
        for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping) {
            ssdAcc.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
        }
        
        return ssdAcc;  
    } 
    
    /**
     * 	createSSDInstance()
     */
    public static Source_System_Detail__c createSSDInstance(String accountId, String oppId, Boolean isShipSSD, 
                                                            Ecom_OrderRequest.cls_customerDetails info, APTSECOM_Store__c store, 
                                                            Integer quantity) {

        Source_System_Detail__c ssdAccount = createSSDInstance(accountId, oppId, info, store, quantity);
        ssdAccount.Account_Name__c = accountId;
        ssdAccount.name = info.organizationName;
        ssdAccount.LCRM_Phone__c = info.phoneNumber;
        ssdAccount.LCRM_Email__c = info.businessEmail;
        ssdAccount.Number_Street__c = info.address.addressLine1;
        ssdAccount.City__c = info.address.city;
        ssdAccount.State__c = info.address.state;
        ssdAccount.Country__c = info.address.country;
        ssdAccount.Postal_Code__c = info.address.zipCode;
        
        if(isShipSSD) {
            ssdAccount.Number_Street__c = info.physicalAddress.addressLine1;
            ssdAccount.City__c = info.physicalAddress.city;
            ssdAccount.State__c = info.physicalAddress.state;
            ssdAccount.Country__c = info.physicalAddress.country;
            ssdAccount.Postal_Code__c = info.physicalAddress.zipCode;
        }
        
        return ssdAccount; 
    } 
    
    /**
     * 	updateShipToSSDAccountAddress()
     */
    public static Source_System_Detail__c updateShipToSSDAccountAddress(Source_System_Detail__c shipSSDAccount, 
                                                                        Ecom_OrderRequest.cls_customerDetails customerDetails) {

        Source_System_Detail__c cloneShipSSDAccount = shipSSDAccount.clone();
        cloneShipSSDAccount.Id = shipSSDAccount.Id;
        cloneShipSSDAccount.Number_Street__c = customerDetails.physicalAddress.addressLine1;
        cloneShipSSDAccount.City__c = customerDetails.physicalAddress.city;
        cloneShipSSDAccount.State__c = customerDetails.physicalAddress.state;
        cloneShipSSDAccount.Country__c = customerDetails.physicalAddress.country;
        cloneShipSSDAccount.Postal_Code__c = customerDetails.physicalAddress.zipCode;
        
        if(shipSSDAccount != cloneShipSSDAccount) { update cloneShipSSDAccount; }
        
        return cloneShipSSDAccount;
    }
    
    /**
     * 	Update Account if Attorney's has changed ----Ecom_order service call
     */
    public static void updateAccountsBasedOnAttorney(String accountId, List<Ecom_OrderRequest.cls_selectedProducts> products, 
                                                     APTSECOM_Store__c store) {

        Account gliAcc = new Account();   
        gliAcc.Id = accountId;
        
        List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;
        if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible()) {              
            lstOrderServiceMapping = [
                SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
                Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
                FROM Ecom_OrderService_Mappings__mdt 
                WHERE Ecom_Object__c = 'Account' 
                AND Ecom_StoreName__c = :store.Name 
                AND Ecom_MaxAttorney__c >= :products[0].quantity 
                AND Ecom_MinAttorney__c <= :products[0].quantity
            ];
        }
        
        lstOrderServiceMapping.addAll([
            SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
            Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c  
            FROM Ecom_OrderService_Mappings__mdt 
            WHERE Ecom_Object__c = 'Account' 
            AND Ecom_StoreName__c = :store.Name 
            AND Ecom_MaxAttorney__c = NULL 
            AND Ecom_MinAttorney__c = NULL
        ]);
        
        for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping) {
            gliAcc.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
        }
        
        if(Schema.sObjectType.Account.isUpdateable()) { update gliAcc; }  
    }
    
    /**
     * 	Update Accounts only if there is change in Orgname, Address,phone number - Ecom_orderService Call
     */ 
    public static void updateAccounts(String accountId, String accountSSD, Ecom_OrderRequest.cls_customerDetails customerDetails) {
        
        Account gliAcc = new Account(); 
        gliAcc.Id = accountId;
        gliAcc.name = customerDetails.organizationName;
        gliAcc.BillingStreet = customerDetails.address.addressLine1;
        gliAcc.BillingCity = customerDetails.address.city;
		// DLT-20038 - Added Null Check
		if(customerDetails.address.state!='' && customerDetails.address.state!=null){
        gliAcc.BillingState = customerDetails.address.state;
		}
        gliAcc.BillingCountry = customerDetails.address.country;
        gliAcc.BillingPostalCode = customerDetails.address.zipCode; 
        gliAcc.Work_Direct__c =  customerDetails.phoneNumber;
        gliAcc.Email__c = customerDetails.businessEmail;
        gliAcc.phone =  customerDetails.phoneNumber;
        gliAcc.Extension__c = customerDetails.phoneExtension;
        
        if(Schema.sObjectType.Account.isUpdateable()) { update gliAcc; }
        
        Source_System_Detail__c ssdAcc = new Source_System_Detail__c();
        ssdAcc.Id = accountSSD;
        ssdAcc.Account_Name__c = accountId;
        ssdAcc.name = customerDetails.organizationName;
        ssdAcc.Number_Street__c = customerDetails.address.addressLine1;
        ssdAcc.City__c =   customerDetails.address.city;
		// DLT-20038 - Added Null Check
		if(customerDetails.address.state!='' && customerDetails.address.state!=null){
        ssdAcc.State__c = customerDetails.address.state;
		}
        ssdAcc.Country__c = customerDetails.address.country;
        ssdAcc.Postal_Code__c = customerDetails.address.zipCode;
        ssdAcc.LCRM_Phone__c =  customerDetails.phoneNumber;
        ssdAcc.LCRM_Email__c =  customerDetails.businessEmail;
        
        update ssdAcc;
    }
    
    /**
     * 	Method to update fields on order when AccountSSD is created- Ecom_orderService Call
     */
    public static void updateOrder(String accountSSDId, String orderId) {
        
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Id = orderId;                            
        order.APTS_SSD_bill_to__c = accountSSDId;
        order.APTS_SSD_Sold_To__c = accountSSDId;
        order.APTS_SSD_Ship_To__c = accountSSDId;
        
        update order;
    }
    
    /**
     * 	Method to Convert State to State Code in request to generate Source Account Number- Ecom_orderService Call
     */
    public static String stateUpdate(String state) {
        
        String separator = ' ';
        if(String.isBlank(state)) { return state; }
        
        state = state.trim();
        // if the State length is 2 then it would be a StateCode.
        if(state.length() == 2 ) { return state.toUpperCase(); }
        
        // create the return string 
        String result = '';
        Integer count = 0;
        // Convert input String- State Name to Camel Case
        for(String word : state.toLowerCase().split(separator)) {
            if(count != 0) {
                result += separator;
            }
            result += word.left(1).toUpperCase() + word.mid(1, word.length());
            count++;
        }
        
        // get the state code by state name
        List<DC_State_Circuit_Mapping__mdt> stateValues = [ SELECT Id, State_Code__c, State__c FROM DC_State_Circuit_Mapping__mdt WHERE State__c =: result ];
        
        if(stateValues.isEmpty()) { return state; }
        
        // Map State Name with State Code
        return stateValues[0].State_Code__c;    
    }
    
    /**
     * 	Future call to update Business fields on Converted Account, Contact And Opportunity
     */
    @future
    public static void updateAccountContactAndOpportunity(String accountId, String contactId, String oppId, String ownerId, 
                                                          String storeId, String accountSSDId, String jsonString, 
                                                          String leadHistoryDetails, Integer quantity) {
       
		try {
            Ecom_OrderRequest.cls_storeOrder strOrder = (Ecom_OrderRequest.cls_storeOrder)JSON.deserializeStrict(jsonString, Ecom_OrderRequest.cls_storeOrder.class);
            List<APTSECOM_Store__c> stores = [
                SELECT Id, Name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, 
                	APTSECOM_Customer_Pricing_Segment__c, APTSECOM_Default_Contract_Term__c
                FROM APTSECOM_Store__c 
                WHERE Id =: storeId 
            ];
            List<Source_System_Detail__c> ssd = [
                SELECT Id, LCRM_Email__c, Source_System_Account_Number__c, LCRM_Phone__c, Source_System_Name__c, Number_Street__c, 
                	City__c, State__c, Country__c, Postal_Code__c 
                FROM Source_System_Detail__c 
                WHERE Id =: accountSSDId
            ]; 
                                                 
            Lead leadDetails = (Lead)JSON.deserializeStrict(leadHistoryDetails, Lead.class);
            System.debug('===lead his in futute ==' + leadDetails);
            
            if(strOrder.isExistingCustomer == false) {
                //Update Business Fields on Account Object
                Ecom_Account.updateConvertedAccount(accountId, stores[0],strOrder);
            }
            
            // Update Business Fields on Contact
            Contact con = Ecom_Contact.updateConvertedContact(contactId, ssd[0]); 
            if(strOrder.isExistingCustomer == false) {
                // Create AccountSSD instance
                Source_System_Detail__c accountSSD = SourceSystemDetailController.createSSDInstance(oppId, accountId); 
                accountSSD.Id = ssd[0].id; 
                
                List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;   
                if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible()) {
                    // DLT-17481
                    lstOrderServiceMapping = [
                        SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
                            Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
                        FROM Ecom_OrderService_Mappings__mdt 
                        WHERE Ecom_Object__c = 'Source_System_Detail__c' 
                        AND Ecom_StoreName__c =: stores[0].Name
                        AND Ecom_MaxAttorney__c >=: quantity 
                        AND Ecom_MinAttorney__c <=: quantity
                    ];        
                }
                
                lstOrderServiceMapping.addAll([
                    SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
                        Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
                    FROM Ecom_OrderService_Mappings__mdt 
                    WHERE Ecom_Object__c = 'Source_System_Detail__c' 
                    AND Ecom_StoreName__c =: stores[0].Name
                    AND Ecom_MaxAttorney__c >=: NULL 
                    AND Ecom_MinAttorney__c <=: NULL
                ]);
                                                                        
                lstOrderServiceMapping.addAll([
                    SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c, Ecom_Object__c, Ecom_MinAttorney__c, 
                        Ecom_MaxAttorney__c, Ecom_Field_API__c, Ecom_Field_Value__c 
                    FROM Ecom_OrderService_Mappings__mdt 
                    WHERE Ecom_Object__c = 'Source_System_Detail__c' 
                    AND Ecom_StoreName__c =: NULL
                    AND Ecom_MaxAttorney__c >=: NULL 
                    AND Ecom_MinAttorney__c <=: NULL
                ]);
                
                for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping) {
                    accountSSD.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
                }
                
                if(Schema.sObjectType.Source_System_Detail__c.isUpdateable()) { update accountSSD; } 
            }
            
            //Update Business Fields on Opportunity
            Ecom_Opportunity.updateConvertedOpportunity(oppId, con, ssd[0], ownerId, strOrder,leadDetails.Description,leadDetails.Tracking_Code__c,leadDetails.Primary_Campaign_Source__c);
            Ecom_Opportunity.createLeadHistory(accountId,contactId,oppId,ownerId, leadDetails);
            
        } catch(Exception ex) {
            DCUtils.trackLog(ex, 'Ecom_OrderService', 'updateAccountContactAndOpportunity');
        }
    }
    
}