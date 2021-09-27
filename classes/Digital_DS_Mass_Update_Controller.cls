/*
 * This class provides the ability to mass update the bypass field on the Digital Subscription records
 * Create a view of display all records needing to be updated.  Press the button to update 
 * the bypass flag as needed.
 *
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2020-07-31   Brenda Shields          Class creation  
 * ==================================================================================================================================   
 */
 
public with sharing class Digital_DS_Mass_Update_Controller {
    //Instantiate a StandardSetController
    public ApexPages.StandardSetController setCon;    
  
    public Boolean isNull {get;set;}
    public Boolean isReturn {get;set;}
    public Boolean isContinue {get;set;}
    public boolean isOverLimit {get;set;}
    public string strDSCounts {get;set;}
    
    //Maps
    map<Id,Product_Account_Detail__c> mapDSRecords = new map<Id,Product_Account_Detail__c>();  
    list<Product_Account_Detail__c> listDSRecords = new list<Product_Account_Detail__c>();
    list<Product_Account_Detail__c> listCheckBypassRecords = new list<Product_Account_Detail__c>();
    list<Product_Account_Detail__c> listUnCheckBypassRecords = new list<Product_Account_Detail__c>();
    integer intRecordsToBypass;
    integer intRecordsToUnBypass;
    
    // Controller class    
    public Digital_DS_Mass_Update_Controller(ApexPages.StandardSetController controller) {
    	setCon = controller;
    	isOverLimit = false;
    	strDSCounts = '';
    	        
    	// get all Digital Subscription records that are displayed in the list view
        getDSRecords();
        // Get Digital Subcription bypass flags to continue processing
        if (mapDSRecords.size() > 0) {
         	prepareDSRecords();
        }               

        // set default values
        isReturn = false;
        isContinue = false;
        isNull = false;
    }
    

    // Assigning selected opportunity id into map.
    private void getDSRecords() {   
    	system.debug('Result Size: '+ setCon.getResultSize()); 
    	system.debug('Has Next: '+ setCon.getHasNext()); 
    	system.debug('Over 10000 limit: '+ setCon.getCompleteResult()); 
    	// too many records to process
    	if (setCon.getResultSize() >= 10000) {
    		isOverLimit = true;
    		return;
    	}
    	// get all pages - each page has 20 records
    	while (setCon.getHasNext()) {
            for (Product_Account_Detail__c oDSRecord : (List<Product_Account_Detail__c>) setCon.getRecords()) {
				mapDSRecords.put(oDSRecord.id, oDSRecord);
            }
            setCon.next();
        }
        // process the last page
        if (mapDSRecords.size() < setCon.getResultSize()) {
            for (Product_Account_Detail__c oDSRecord : (List<Product_Account_Detail__c>) setCon.getRecords()) {
				mapDSRecords.put(oDSRecord.id, oDSRecord);
            }	
        }
    }
    
    
    // Prepare Opporutnities and Proposals for validate and processing
    private void prepareDSRecords() {
   		integer intTotalCount; 
   
    	//check field accessibility on Opportunity, User and Apttus_Proposal__Proposal__c objects
        if (Schema.sObjectType.Product_Account_Detail__c.isAccessible() &&
        	Schema.sObjectType.Product_Account_Detail__c.isUpdateable()) {
            listDSRecords = [SELECT Id, Bypass_Automation__c
            				from Product_Account_Detail__c 
                           	where id IN: mapDSRecords.KeySet()]; 
        }   
        system.debug(listDSRecords); 
        // build lists for DS records to update
        // if the bypass flag is on we will need to turn it off
        // if the bypass flag in off we will need to turn it on   
        for (Product_Account_Detail__c oDSRecord : listDSRecords) {
			if (oDSRecord.Bypass_Automation__c) {  
				oDSRecord.Bypass_Automation__c = false;                  
                listUnCheckBypassRecords.add(oDSRecord);
			} else {
				oDSRecord.Bypass_Automation__c = true; 
				listCheckBypassRecords.add(oDSRecord);
			}
        }
        intRecordsToBypass = listCheckBypassRecords.size();
        intRecordsToUnBypass = listUnCheckBypassRecords.size();
        intTotalCount = intRecordsToBypass + intRecordsToUnBypass;
        strDSCounts = 'Out of the ' + intTotalCount + ' records in this view, ' +
        	intRecordsToUnBypass + ' are marked as Bypass Automation and ' +
        	intRecordsToBypass + ' are not marked as Bypass Automation.';
    }    


    // Update DS Records based on user input.
    public PageReference updateDSRecords() {
        
        // At least one DS record needs to be in the list view to proceed further
        if (mapDSRecords.size() == 0 || mapDSRecords.isEmpty()) {
            isNull = true;
            isReturn = true;
            system.debug('There are no records in your view : ' + isNull);
            return Page.Digital_DS_Mass_Update_Messages;
        }

        // We can't process over 10000 records - so advoid large views
        if (isOverLimit) {
            isReturn = true;
            system.debug('Too many records to process : ' + isOverLimit);
            return Page.Digital_DS_Mass_Update_Messages;
        }
                      
        // Check to see if they really want to upate DS records
        isContinue = true;
        system.debug('Continue : ' + isContinue);
        return Page.Digital_DS_Mass_Update_Messages;
    }
    

    // Update DS Records to Bypass
    public PageReference updateToBypass() {
    	if (schema.sObjectType.Product_Account_Detail__c.isUpdateable()) {
    		update listCheckBypassRecords;
    	}
    	// return
        PageReference listPage = new PageReference('/aA5?fcf');
        listPage.setredirect(true);
        return listPage;
    }
    

    // Update DS Records to Bypass
    public PageReference updateToUnBypass() {
    	if (schema.sObjectType.Product_Account_Detail__c.isUpdateable()) {
    		update listUnCheckBypassRecords;
    	}
    	// return
        PageReference listPage = new PageReference('/aA5?fcf');
        listPage.setredirect(true);
        return listPage;
    }
    
    
    public PageReference returnToDSView() {
        PageReference listPage= new PageReference('/aA5?fcf');
        listPage.setredirect(true);
        return listPage;     
    }    

}