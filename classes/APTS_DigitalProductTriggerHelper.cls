/* Created By - Raviteja Murukutla
   Purpose - Digital Quote Automation for Best offer
   Jira Story - DLT-1070
   
   Change History:
                Benjamin Her    DLT-9758        Update S2E object/field references to GLI object/field references
   06-24-2019   Brenda Shields  DLT-16903       Update or Create Opportunities for DS records.  Add Account id to DS for easier processing
   10-21-2019   HarikaSaiP      DLT-17793/18107 [CORP][SFDC] Multi Offer - Add option products to the subscription list
   08-06-2020   Brenda Shields  DLT-20508       If no SSD Account is found, set the ds record to Bypass 
   2021-04-01   Brenda shields  DLT-21575 - Update logic to correctly set OCC and associated fields - set new contact fields
*/  
/**
 * @description : Helper class to the Digital Product Account Detail trigger
 */ 
public with sharing class APTS_DigitalProductTriggerHelper {  
    // build Contact maps to determine Order Confirmation Contact/email
    // Contact maps from Contact SSD
    public static map<string, id> mapSSDContactSAP = new map<string, id>();
    public static map<string, id> mapSSDContact = new map<string, id>();
    // Contact map from Contact
    public static map<string, id> mapContactSAP = new map<string, id>();
    public static map<string, id> mapContact = new map<string, id>();
    // map SSD Contact to Contact
    public static map<id, id> mapContactToContact = new map<id, id>();    
    // map from account id to zp customer number
    public static map<string, string> mapAccounZPCust = new map<string, string>();
    // build sets to query Contacts
    public static set<string> setSSDAccountIDs = new set<string>();
    public static set<string> setAccountIDs = new set<string>();
    public static set<string> setDSWithContacts = new set<string>();
    public static set<string> setDSSAPContacts = new set<string>();
    // maps for selecting and processing products and ssds
   	public static map<string, string> mapZPSAPAccountsIds = New map<string, string>();
    public static map<string, string> mapAccountsIds = New map<string, string>();
    public static map<string, string> mapActualSubProductIds = New map<string, string>();
    public static map<string, string> mapProdNameProdIds = New map<string, string>();
        
    /**
     * @description : Get values and update Product Account Detail records
     * @param prdAcctList : list of Product Account Detail records to update
     */ 
    public static void updatePrdAccountDetails(list<Product_Account_Detail__c> prdAcctList) {
        set<string> setSAPAccountIds = new set<string>();
        set<string> setActNewSvcIds = new set<string>();
        set<string> setProdNames = new set<string>();
  
        for (Product_Account_Detail__c pad : prdAcctList) {
            setSAPAccountIds.add(pad.ZP_Cust_Number__c);            
            if (pad.Actual_New_Service__c != null ) {
              setActNewSvcIds.add(pad.Actual_New_Service__c);
            }
            if (pad.Premium_New_Service__c != Null) {
              setActNewSvcIds.add(pad.Premium_New_Service__c);
            } 
            if (pad.Bundle_Product_Name__c != null) {//17793
              setProdNames.add(pad.Bundle_Product_Name__c);
            } 
            // build sets to find correct Contact
            setSAPContacts(pad);
        }

    	list<Source_System_Detail__c> actList = new list<Source_System_Detail__c>();
    	list<Product2> prodList = new list<Product2>();
    	
        // get SSD records and build associated sets/maps
        actList = getSSDAccounts(setSAPAccountIds);
        
        // get Products
        prodList = getProducts(setActNewSvcIds, setProdNames);
      
        // create map for Product code to update DS record
        if (!prodList.isEmpty()) {
            for (Product2 p: prodList) {
                mapActualSubProductIds.put(p.ProductCode,p.id);
                mapProdNameProdIds.put(p.Name,p.Id);
            }
        }
        
        // build Contact maps
        // due to the number of contacts, if we are updating a large batch we get 50001 and 101 limit exceptions
        // limit setting contacts when there is a large number of records to update
		system.debug(logginglevel.INFO, 'Batch size: ' + prdAcctList.size());
        if (prdAcctList.size() < 200) {
        	queryContacts();
        }
        
        // Set the appropriate values into the DS reccord
        for (Product_Account_Detail__c digitalPAD : prdAcctList) {
        	// update DS records for account information
        	updateDSAccountInfo(digitalPAD, mapZPSAPAccountsIds, mapAccountsIds);
          	// update DS records for subscription and product informtion
          	updateDSSubInfo(digitalPAD, mapActualSubProductIds, mapProdNameProdIds);
        }         
    }
    
    // update DS records
    private static void updateDSAccountInfo(Product_Account_Detail__c digitalPAD, map<string, string> mapZPSAPAccountsIds, map<string, string> mapAccountsIds) {
        
        if (digitalPAD.ZP_Cust_Number__c != null) {
            digitalPAD.AccountSSD__c = mapZPSAPAccountsIds.get(DigitalPAD.ZP_Cust_Number__c);
            digitalPAD.Account__c = mapAccountsIds.get(DigitalPAD.ZP_Cust_Number__c);
            // set Contact information
            setContacts(digitalPAD);
        }
        // Set the Bypass flag on DS records with no SSD Account 
        if (digitalPAD.AccountSSD__c == null) {
        	digitalPAD.Bypass_Automation__c = true;
        }
    }
    
   // update DS records for subscription and product information
   private static void updateDSSubInfo(Product_Account_Detail__c digitalPAD, map<string, string> mapActualSubProductIds, map<string, string> mapProdNameProdIds) {
          	
        if (digitalPAD.Actual_New_Service__c != null) {
            digitalPAD.Actual_New_Subscription_Product__c = mapActualSubProductIds.get(DigitalPAD.Actual_New_Service__c);
        }
        
        if (digitalPAD.Premium_New_Service__c != null) {
            digitalPAD.Actual_New_Subscription_Product__c = mapActualSubProductIds.get(DigitalPAD.Premium_New_Service__c);
        }
        if(digitalPAD.Bundle_Product_Name__c!= null ){
            system.debug(logginglevel.INFO, 'mapProdNameProdIds::'+mapProdNameProdIds);
            digitalPAD.Bundle_Id__c = mapProdNameProdIds.get(DigitalPAD.Bundle_Product_Name__c);
        }
	}    
    
    // get SSD records
    private static list<Source_System_Detail__c> getSSDAccounts(set<string> setSAPAccountIds) {
        list<Source_System_Detail__c> actList = new list<Source_System_Detail__c>();
        
        if (Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
            actList = [Select id, Source_System_Account_Number__c, Account_Name__c
                       from Source_System_Detail__c Where Source_System_Account_Number__c in : setSAPAccountIds];
        }
        
        // Create map for SSD Account number and Account number to update DS record
        for (Source_System_Detail__c a: actList) {
            mapZPSAPAccountsIds.put(a.Source_System_Account_Number__c,a.ID);
            mapAccountsIds.put(a.Source_System_Account_Number__c, a.Account_Name__c);
            // build sets of IDs to query Contacts
            mapAccounZPCust.put(a.Account_Name__c, a.Source_System_Account_Number__c);
            if (setDSWithContacts.contains(a.Source_System_Account_Number__c)) {
            	setSSDAccountIds.add(a.ID);
            	setAccountIds.add(a.Account_Name__c);
            }
        }
        return actList;
    }
    
    // create sets to build Contacts
    private static void setSAPContacts(Product_Account_Detail__c pad) {
        if (pad.SAP_Contact_ID__c != null) {
         	setDSWithContacts.add(pad.ZP_Cust_Number__c);
          	setDSSAPContacts.add(pad.SAP_Contact_ID__c.leftPad(10, '0'));
        }     
    }        
            
    // get Products
    private static list<Product2> getProducts(set<string> setActNewSvcIds, set<string> setProdNames) {
        list<Product2> prodList = new list<Product2>();
        
        if (Schema.sObjectType.Product2.isAccessible()) {
            prodList = [Select Id, ProductCode, Name from Product2 Where ProductCode in : setActNewSvcIds OR Name IN : setProdNames];  //17793      
        }
        return prodList;
    }
    
    private static void queryContacts() {
    	list<LCRM_Contact_SSD__c> lstSSDContacts = new list<LCRM_Contact_SSD__c>();
    	list<Contact> lstContacts = new list<Contact>();
    	
    	// build maps for SSD Contacts
    	if (Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()) {
    		lstSSDContacts = [Select id, name, LCRM_Email__c, LCRM_Contact__c, LCRM_Contact_ID__c, LCRM_Job_Function__c, LCRM_SAP_Role__c, LCRM_Source_Contact_Id__c,
							LastModifiedDate, LCRM_Hard_Bounce__c, Contact_Inactive__c, LCRM_Account_SSD__c, LCRM_Account_SSD__r.id, LCRM_Account_SSD__r.Source_System_Account_Number__c, 
							LCRM_Contact__r.AccountId, LCRM_Contact__r.SAP_Contact_ID__c, LCRM_Contact__r.Contact_Inactive__c, LCRM_Contact__r.IsEmailBounced, LCRM_Contact__r.Email
						from LCRM_Contact_SSD__c 
						where LCRM_Account_SSD__c in : setSSDAccountIds and LCRM_Source_Contact_Id__c in : setDSSAPContacts];
    	}
    	for (LCRM_Contact_SSD__c oSSDContact : lstSSDContacts) {
    		// map SSD Contact to Contact
    		mapContactToContact.put(oSSDContact.id, oSSDContact.LCRM_Contact__c);
    		if (oSSDContact.LCRM_Source_Contact_Id__c != null) {
    			// set the key to the zp customer number + sap contact number
    			mapSSDContactSAP.put(oSSDContact.LCRM_Account_SSD__r.Source_System_Account_Number__c + oSSDContact.LCRM_Source_Contact_Id__c, oSSDContact.id);
    		} else {
    			// set the key to the zp customer number
    			mapSSDContact.put(oSSDContact.LCRM_Account_SSD__r.Source_System_Account_Number__c, oSSDContact.id);
    		}
    	}
/* removed due to getting 5001 limit errors  	
    	// build maps for Contacts
    	if (Schema.sObjectType.Contact.isAccessible()) {
    		lstContacts = [Select id, name, AccountId, SAP_Contact_ID__c, Contact_Inactive__c, IsEmailBounced, Email
							from Contact
							where AccountId in : setAccountIds];
    	}
    	for (Contact oContact : lstContacts) {
    		if (oContact.SAP_Contact_ID__c != null) {
    			// set the key to the zp customer number + sap contact number
    			// contacts don't have a sap contact number
    			mapContactSAP.put(mapAccounZPCust.get(oContact.AccountId) + oContact.SAP_Contact_ID__c, oContact.id);
    		} else {
    			// set the key to the zp customer number
    			mapContact.put(mapAccounZPCust.get(oContact.AccountId), oContact.id);
    		}
    	}
*/    	
    	system.debug(logginglevel.INFO, 'SSD Contacts SAP map: ' + mapSSDContactSAP);
    	system.debug(logginglevel.INFO, 'SSD Contacts map: ' + mapSSDContact);
    	system.debug(logginglevel.INFO, 'Contacts SAP map: ' + mapContactSAP);
    	system.debug(logginglevel.INFO, 'Contacts map: ' + mapContact);
    }
    
    
    private static void setContacts(Product_Account_Detail__c digitalPAD) {
    	string strSAPKey;
    	string strSAPContactID;
    	
    	digitalPAD.Status_Message__c = '';
    	// set the Contact based on the SAP Contact id
    	if (digitalPAD.SAP_Contact_ID__c != null) {
    		// the values in DS looses it's leading zeros - make sure they match
    		strSAPContactId = digitalPAD.SAP_Contact_ID__c.leftPad(10, '0');
    		strSAPKey = digitalPAD.ZP_Cust_Number__c + strSAPContactId;
    		system.debug(logginglevel.INFO, ' Searching for SSD contact key: ' + strSAPKey);
	    	if (mapSSDContactSAP.get(strSAPKey) != null) {
	    		digitalPAD.Contact_SSD__c = mapSSDContactSAP.get(strSAPKey);
	    		digitalPAD.Contact__c = mapContactToContact.get(mapSSDContactSAP.get(strSAPKey));
	    		digitalPAD.Status_Message__c = 'SAP Contact found for Account SSD';	
	    	}	    		
// bypass looking at just contacts to avoid soql limit	    			
//	    	} else {
//	    		if (mapContactSAP.get(digitalPAD.ZP_Cust_Number__c) != null) {
//	    			digitalPAD.Contact__c = mapSSDContactSAP.get(digitalPAD.ZP_Cust_Number__c);
//	    			digitalPAD.Status_Message__c = 'SAP Contact found for Account';	
//	    		}
//	    	}
    	}
    	// only look for SAP Contacts - logic for automation contact selection  it to complex
    	// to be called from this class
    	/*
    	if (digitalPAD.Status_Message__c ==  '') {
    		// set the Contact 
    		strSAPKey = digitalPAD.ZP_Cust_Number__c;
    		system.debug(logginglevel.INFO, ' Searching for contact key: ' + strSAPKey);
	    	if (mapSSDContact.get(strSAPKey) != null) {
	    		digitalPAD.Contact_SSD__c = mapSSDContact.get(strSAPKey);
	    		digitalPAD.Status_Message__c = 'Contact found for Account SSD';			
	    	} else {
	    		if (mapContact.get(digitalPAD.ZP_Cust_Number__c) != null) {
	    			digitalPAD.Contact__c = mapSSDContact.get(digitalPAD.ZP_Cust_Number__c);
	    			digitalPAD.Status_Message__c = 'Contact found for Account';	
	    		}
	    	}
    	} 
    	*/
    	if (digitalPAD.SAP_Contact_ID__c != null && digitalPAD.Status_Message__c ==  '') { 
    		// if old contact was there, delete it
    		digitalPAD.Contact_SSD__c = null;
	    	digitalPAD.Contact__c = null;
    		digitalPAD.Status_Message__c = 'No SAP Contact Found';
    	}	
    	system.debug(logginglevel.INFO, 'DS Contact: Contact SSD: ' + digitalPAD.Contact_SSD__c);  
    	system.debug(logginglevel.INFO, 'DS Contact: Contact: ' + digitalPAD.Contact__c);	
    }
   
}