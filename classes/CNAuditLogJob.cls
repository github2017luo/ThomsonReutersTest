/**
* {Purpose} – This job runs on demand and is used to generate an Audit Log CSV of up to 10MB. It emails this CSV once complete.
*
* @author	David Sarbello
* @version	2014-09-11
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2014-09-11	David Sarbello		Created 
* =============================================================================
*/
global class CNAuditLogJob implements Database.Batchable<sObject>, Database.Stateful {
	
	//String query;
	String contents='';
	Integer ageInDays=14;
	DateTime age = Date.today();
	Boolean stopProcessing = false;

	private static final String sClassName = 'CNAuditLogJob';

	public CNAuditLogJob() {
		System.debug('invoking Audit Log job constructor');
	}

	global CNAuditLogJob(Integer ageInDays) {
		System.debug('invoking cleanup job constructor');
		this.ageInDays = ageInDays;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('start');
        
	    age = age.addDays(-ageInDays);

    	/*String sQuery = 'SELECT Id, Name, ContactNet__Account__c, ContactNet__Account__r.Name, ContactNet__Action_Type__c, ' +
   					'ContactNet__Component_Source__c, ContactNet__Contact__c, ContactNet__Contact__r.Name, CreatedDate ' +
   					'FROM ContactNet__CN_Audit_Log__c ' +
   					'WHERE CreatedDate >= :age ORDER BY CreatedDate DESC LIMIT 30000';*/
		String sQuery = 'SELECT Id, Name, Account__c, Account__r.Name, Action_Type__c, ' +
   					'Component_Source__c, Contact__c, Contact__r.Name, CreatedDate ' +
   					'FROM CN_Audit_Log__c ' +
   					'WHERE CreatedDate >= :age ORDER BY CreatedDate DESC LIMIT 30000';
        System.debug('sQuery: ' + sQuery);
        
        return Database.getQueryLocator(sQuery); 		
	}

   	global void execute(Database.BatchableContext BC, List<sObject> rows) {
	
		if (stopProcessing) return;

		String subContents = '';
   		//subContents += CNAppUtils.GenerateCSVRows(rows);

   		IF( (contents.length() + subContents.length() ) > 10000000 )
   			stopProcessing = true;
   		else
   			contents += subContents;

	}
	
	global void finish(Database.BatchableContext BC) {
        String sMessage = 'Attached is your BDP Premier Audit Log for the past 30 days.';
        String sEmailSubject = ' BDP Premier Audit Report. Generated on ' + System.Now();
        String sToEmail = CNAppUtils.getAppCustomSetting().Support_Notification_Email__c; //single email
        Blob attachmentBlob = Blob.valueOf(contents);

		CNAppUtils.sendEmail(new String[]{sToEmail}, sEmailSubject, sMessage, attachmentBlob, 'test.csv');
	}
	
}