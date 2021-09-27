/**
 * This class was developed as a schedulable job which is expected to run daily once.
 * This job will monitor payment errors and send out emails if more than two are received withing 24 hours.
 */
/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date         Name                    Description
 * 2021-06-14   Brenda Shields          DLT-21895 - [INC4022734][SFDC][Monitoring][NSE] - Implement monitoring for NSE payment failures
 * =================================================================================================================
 */
 /** 
 * @description : Checks Digital Exceptions for payment failues
 */ 
public without sharing class Digital_PaymentMonitor implements Database.Batchable<Digital_Exception_Log__c>, Database.Stateful {
    private static final integer REPORTDAYS = Integer.valueof(system.Label.Digital_PaymentMonitor_Days.trim());
    // Recipient list of email address who should get the Payment Monitor Report
    private static list<String> lstEmailRecipients = new list<String>(Label.Digital_PaymentMonitor_Report_Recipients.split(';'));   
    private static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    
    private static map<string, string> mapOppPaymentErrors = new map<string, string>(); 
    private static map<string, string> mapLeadPaymentErrors = new map<string, string>(); 
    // map to get names to display in the email
    private static map<id, string> mapLeadNames = new map<id, string>();
    private static map<id, string> mapOppNames = new map<id, string>();
    private static map<id, string> mapAcctNames = new map<id, string>();
    // sets to get Lead, Opportunity and Account names to present in the email
    private static set<string> setLeads = new set<string>();
    private static set<string> setOpps = new set<string>();

    /** 
     * @description : Start method
     * @param bC : batchableContext
     * @return : list of Digital Subscription records
     */ 
    public Iterable<Digital_Exception_Log__c> start(database.batchablecontext bC) {
        list<Digital_Exception_Log__c> digitalExList = new list<Digital_Exception_Log__c>();
        date reportDate = system.today() - REPORTDAYS;
        
    	// Select Digital Exception records for payment failures
    	// narrow search by Class Reference = null,  We can't query on Exception Message or Additional Information fields 
    	// because they are large text fields
        if (schema.sObjectType.Digital_Exception_Log__c.isAccessible()) {
            // Get Exception records within the reportDate range
    		list<Digital_Exception_Log__c> batchExceptionsList = [select id, Class_Reference__c, CreatedDate, Additional_Information__c, Exception_Message__c, Exception_Type__c, Object__c, Record_Id__c, User_Message__c
								from Digital_Exception_Log__c 
								where CreatedDate > :reportDate and Class_Reference__c = null];
            for (Digital_Exception_Log__c  digitalException : batchExceptionsList) {
                
                // weed out non payment failures  
                if (digitalException.Additional_Information__c.contains('Payment') &&
                	!digitalException.Exception_Message__c.contains('Success')) {
                    digitalExList.add(digitalException);              
                }
            }
        }
        system.debug(LoggingLevel.INFO, 'Digital Payment Exceptions Count: ' + digitalExList.size());
        // only return a list if there are 2 or more payment failures
        // If none or only 1 exception is found, return null list
        if (digitalExList.size() == 1) {
        	digitalExList.clear();
        }
        return digitalExList;
    }
    
    
    /** 
     * @description : Execute method
     * @param bC : Batch of Digital Subscription Record
     * @param scope : Digital Exception Records in scope 
     */ 
    public void execute(Database.BatchableContext bC, list<Digital_Exception_Log__c> scope) {
    	//list<Task> lstTasksToInsert = new list<Task>();
        // Create variables
        string emailText = 'Please find a list of payment failures which have occured during the past ' + REPORTDAYS + ' days.<br><br>'; //''\r\n';
        string errorMessageText;
        string strExceptionMessage;
        string strDetails;
        string accountId;
        string oppId;
        string leadId;
		integer intIndex;

		// get a list of lead, opp and account names so they can be included in the email
		getNames(Scope);
    
        // Build the details to be included in the email
        // the format of the Digital Exception Log field should not be changed
        for (sObject oScope : Scope) {          
       
            Digital_Exception_Log__c exceptionDetail = (Digital_Exception_Log__c)oScope;
            // remove formatting so finding IDs will work consistently
			strExceptionMessage = removeFormatting(exceptionDetail.Exception_Message__c);
			system.debug(LoggingLevel.INFO, 'Digital exception record to process ==> ' + exceptionDetail);
            
            // create string values - text example
            // Payment Response Message - Please enter your card number
			// AccountId - 0016w00000O7AVyAAN
			// OpportunityId - 0066w000004A9g5AAC
			// LeadId - 00Q6w000002WWvNEAW
			
			// get the failure message
			intIndex = strExceptionMessage.indexOf('AccountId');
            errorMessageText = strExceptionMessage.mid(0, intIndex);
            system.debug(logginglevel.INFO, 'Message Index/Text: ' + intIndex + ' ' + errorMessageText);

			// search for Account by 3 char prefix, include a space in case any other 001 appears in the message
            intIndex = strExceptionMessage.indexOf(' 001');
            accountId = strExceptionMessage.mid(intIndex + 1, 18);            
            // search for Opps by 3 char prefix, include a space in case any other 001 appears in the message
            intIndex = strExceptionMessage.indexOf(' 006');
            oppId = strExceptionMessage.mid(intIndex + 1, 18);
            // search for Leads by 3 char prefix, include a space in case any other 00Q appears in the message
            intIndex = strExceptionMessage.indexOf(' 00Q');
            leadId = strExceptionMessage.mid(intIndex + 1, 18);
            
            // format email text for this payment failure
            strDetails = buildEmailText(oppId, leadId, accountId); 
            emailText += errorMessageText + '<br>Payment Date:  ' + exceptionDetail.CreatedDate +
                strDetails;     
            
            // setup maps to find the correct errors when building Task activities     
            mapOppPaymentErrors.put(oppId, errorMessageText);
            mapLeadPaymentErrors.put(leadId, errorMessageText);

        } // end of for loop
              
        system.debug(logginglevel.INFO, 'Opp Map: ' + intIndex + ' ' + mapOppPaymentErrors);
        system.debug(logginglevel.INFO, 'Lead Map: ' + intIndex + ' ' + mapLeadPaymentErrors);
              
        // Build/send Email to include all payment failure details
        sendEmail(emailText);
        
        // not needed for initial release
        // build all tasks for opportunity and lead activities
        //lstTasksToInsert = addActivities(mapOppPaymentErrors, mapLeadPaymentErrors);  
	    // insert task
        //if (Schema.sObjectType.Task.isCreateable() && !lstTasksToInsert.isEmpty()) {
        // 	insert lstTasksToInsert;
        //}
        
    }
    
    
    // method to find the record names to add to the email.  The error message only contains ids so 
    // that is not user friendly in an email
    private static void getNames(list<Digital_Exception_Log__c> scope) {
    	integer intIndex;
		string oppId;
		string leadId;
		string exceptionMessage;
		
    	// Build sets to query Leads and Opportunities
        for (sObject oScope : scope) {          
            Digital_Exception_Log__c digitalException = (Digital_Exception_Log__c)oScope;
            // remove formatting characters from the exception message
            exceptionMessage = removeFormatting(digitalException.Exception_Message__c);
            // search for Opp by 3 char prefix, include a space in case any other 006 appears in the message
			intIndex = exceptionMessage.indexOf(' 006');
    		oppId = exceptionMessage.mid(intIndex + 1, 18);
    		// search for Leads by 3 char prefix, include a space in case any other 00Q appears in the message
            intIndex = exceptionMessage.indexOf(' 00Q');
		    leadId = exceptionMessage.mid(intIndex + 1, 18); 
		    setOpps.add(oppId);
		    setLeads.add(leadId);  
        }
    	
    	// find the name of all the leads to display in the email
    	for (Lead oLead : [select id, name from Lead where id in: setLeads]) {
    		mapLeadNames.put(oLead.Id, oLead.name);
    	}
    	// find the name of all the opps and accounts so they will display in the email 
    	for (Opportunity oOpp : [select id, name, AccountId, Account.Name from Opportunity where id in: setOpps]) {
    		mapOppNames.put(oOpp.id, oOpp.name);
    		mapAcctNames.put(oOpp.AccountId, oOpp.Account.Name);
    	}
    	system.debug(logginglevel.INFO, 'Lead ID: ' + setLeads + 'Lead map Names: ' + mapLeadNames);
    	system.debug(logginglevel.INFO, 'Opp ID: ' + setOpps + 'Opp map Names: ' + mapOppNames);
    	system.debug(logginglevel.INFO, 'Acct map Names: ' + mapAcctNames);
    }
    
    
    // method to remove formatting characters in the exception message
    private static string removeFormatting(string strExceptionMessage) {
    	string strNewMessage;
    	// remove formatting so searching for IDs will be consistant, i.e., if there is a tab char before the id 
    	// so when checking for the 3 char id prefix, the search fails
    	strNewMessage = strExceptionMessage;
    	strNewMessage = strNewMessage.replace('\n', ' ');
		strNewMessage = strNewMessage.replace('\r', ' ');
		strNewMessage = strNewMessage.replace('\t', ' '); 
    	return strNewMessage;
    }
    
    
    // method to build the failure detail information text that will display in the eamil
    private static string buildEmailText(string oppId, string leadId, string acctId) {
    	string strLeadName = 'Unknown';
        string strOppName = 'Unknown';
        string strAcctName = 'Unknown';
		string strDetails;
		
        if (mapLeadNames.containskey(leadId)) {
        	strLeadName = mapLeadNames.get(leadId);
        }    
        if (mapOppNames.containskey(oppId)) {
        	strOppName = mapOppNames.get(oppId);
        } 
        if (mapAcctNames.containskey(acctId)) {
        	strAcctName = mapAcctNames.get(acctId);
        }         
        strDetails = '<br>Account:  <a href=' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + acctId + '>' + strAcctName + '</a>' + 
            '<br>Opportunity:  <a href=' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppId + '>' + strOppName + '</a>' + 
            '<br>Lead:  <a href=' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + leadId + '>' + strLeadName + '</a>' + 
            '<br><br>'; 
                
		return strDetails;        	
    }
    
    
    /** 
	 * @description : method to send out the payment failure email
	 * @param emailText : the failure information to include in the email
	 */ 
     public static void sendEmail(string emailText) { 
     	string strOrgName = null;
        if (UserInfo.getUserName().substringAfterLast('.com') != null) {
            strOrgName = UserInfo.getUserName().substringAfterLast('.') + ' : ';
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(lstEmailRecipients); 
        mail.setSubject(strOrgName + 'Notification of NSE Payment Failures');
        mail.setHtmlBody('<html>' + emailText + '</html>');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 	
 	}
 
    
	/** 
	 * @description : method to create activities/tasks on Opps
	 * @param mapOppPaymentErrors : map of Opp ids and payment failure messages
	 * @param mapLeadPaymentErrors : map of Lead ids and payment failure messages
	 * @return list of Tasks to create
	 */ 
    public static list<Task> addActivities(map<string, string> mapOppPaymentErrors, map<string, string> mapLeadPaymentErrors) {
    	list<Task> lstTasksToInsert = new list<Task>();
    		                   	                    
		for (string oppId : mapOppPaymentErrors.keySet()) {	                    
	        Task task = new Task();
	        task.Subject = 'Payment Error';    
	        task.Status= 'Completed';
	        task.Status__c= 'Completed';
	        task.Description = mapOppPaymentErrors.get(oppId);     
	        task.whatid = oppId;
	        task.ActivityDate=System.today();
	        lstTasksToInsert.add(task);  
		}
/*		
       	for (string leadId : mapLeadPaymentErrors.keySet()) {	                    
	        Task task = new Task();
	        task.Subject = 'Payment Error';    
	        task.Status= 'Completed';
	        task.Status__c= 'Completed';
	        task.Description = mapOppPaymentErrors.get(leadId);     
	        task.whatid = leadId;
	        task.ActivityDate=System.today();
	        lstTasksToInsert.add(task);  
		}
*/		
        return lstTasksToInsert;
    }
     
     
    /** 
     * @description : Internal Class
     */     
    public class Digital_OpportunityDigitalFlagSyncException extends Exception {}
    

    /** 
     * @description : Finish method - submit automation job
     * @param info : BatchableContext
     */     
    public void finish(Database.BatchableContext info) {
        //log errors, if any
        try {
            if (exList.size() > 0) {
                insert exList;
            }
        } catch(Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Exception' + ex);
        }
    }
     
}