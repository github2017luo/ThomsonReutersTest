/*
 * This class provides the Digital Support team with a button on the Digital Settings page layout
 * so they can 'Unmark' Opportunities as Digital if they have failed the Digital Automation Process
 *
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2020-10-07   Brenda Shields          DLT-20728 - Class creation  
 * ==================================================================================================================================   
 */

public with sharing class Digital_Cohort_Cust_Controller {

    private Id digitalSettingId;
    private list<Digital_Customer__c> customerList = new list<Digital_Customer__c>();
    private list<Opportunity> oppList = new list<Opportunity>();
    private set<Id> setOppIds = new set<Id>();
    
    public boolean bInitialStatus {get;set;}
    public boolean bContinue {get;set;}
    public string strErrorMessage {get;set;}

    
    public Digital_Cohort_Cust_Controller(ApexPages.StandardSetController controller) {

        // If the rights are correct and there are attathments to create, insert attachments 
        if (!Schema.sObjectType.Digital_Customer__c.isAccessible() ||
        	!Schema.sObjectType.Opportunity.isUpdateable()) {
        	throw new DCCustomException(UserInfo.getName() + ' does not have the correct access to complete this process.');
        } 
        
        // get parameters
        digitalSettingId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
    
    	// get all customers that we need to unmark as Digital
		customerList = [Select Id, Fatal_Error__c, Bypass_Unmarking_Opportunity__c, Unmarked_Digital_Channel__c, Opportunity__c
				from Digital_Customer__c where Digital_Settings__c = : digitalSettingId
				and Fatal_Error__c = true and Bypass_Unmarking_Opportunity__c = false 
				and Unmarked_Digital_Channel__c = false];    
		for (Digital_Customer__c oCustomer : customerList) {
			setOppIds.add(oCustomer.Opportunity__c);
			Opportunity oppRecord = new Opportunity();
			oppRecord.Id = oCustomer.Opportunity__c;
			oppRecord.Unmarked_Digital_Channel__c = true;
			oppRecord.IsDigitalSpearhead__c = false;
			oppList.add(OppRecord);
		} 
    }


    // Display message and prompt to continue
    public void updateOpps() {
    	
    	bInitialStatus = true;
    	if (customerList.size() > 0) {
    		bContinue = true;
			strErrorMessage = 'This process will Unmark ' + customerList.size() + ' Opportunities as Digital.  ' +
				'Press Continue to begin the update.  If you need to bypass any of the Opportunities from being updated, ' +
				'update the Bypass Unmarking Opportunity flag on the appropriate Digital Validation Customer record.';
    	} else {
    		bContinue = false;
    		strErrorMessage = 'There are no Opportunities to process.';
    		
    	}
    }
    
  
	// Controller class
    public PageReference continueUpdate() {
    	bInitialStatus = false;
    	try {
    		if (oppList.size() > 0) {
    			update oppList;
    		}
    	} catch (Exception e) {
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Update Error'));
    	}
        Pagereference currentRecUrl = new PageReference('/' + digitalSettingId);
        return currentRecUrl;    
    }  
    
    
    // Return to the Quote    
    public PageReference returnToSettings() {
        Pagereference currentRecUrl = new PageReference('/' + digitalSettingId);
        return currentRecUrl;       
    } 
    
}