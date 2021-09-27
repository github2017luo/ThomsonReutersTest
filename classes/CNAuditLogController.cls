/**
* {Purpose} - Controller class used to manage the Email Audit Log
*
* @author	David Sarbello
* @version	2014-09-10
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2014-09-10	David Sarbello			Created
* 2014-12-09	Mike Eaton				Commented out SendSummaryAuditReport
* =============================================================================
*/
public with sharing class CNAuditLogController {
	/* PUBLIC VARIABLES */
	public List<CN_Audit_Log__c> oauditLogs {get; set;}
	public String reportURL {get; set;}
	list<Report> listReports = new list<Report>();
	
	public CNAuditLogController() {
		oauditLogs = [SELECT Id, Name, Account__c, Account__r.Name, Action_Type__c,
                            Component_Source__c, Contact__c, Contact__r.Name, CreatedDate
                            FROM CN_Audit_Log__c
                            ORDER BY CreatedDate DESC LIMIT 20];

        fetchReportURL();
	}

	public String getSupportNotificationEmail() {
		
		try {
            return CNAppUtils.getAppCustomSetting().Support_Notification_Email__c;
        } catch (Exception e) {
            return '';
        }
	}

	 public void initialLoad() {
	 	/* Disable outbound audit report per G.Hill
		CNAppUtils.SendSummaryAuditReport();
		*/
	 }

 
	 public void fetchReportURL() {
	 	Report oReport = new Report();
	 	reportURL = '';
	 	Boolean handleSensitive = true;

        try {
            //handleSensitive = CNAppUtils.getAppCustomSetting().Exclude_Sensitive_Audit_Log_Data__c;
            List<CN_App_Settings__c> sett = [Select Id,Exclude_Sensitive_Audit_Log_Data__c from CN_App_Settings__c order by createddate desc limit 1];
			handleSensitive = sett[0].Exclude_Sensitive_Audit_Log_Data__c;
        } catch (Exception e) {
            handleSensitive = true;
        }

        if (handleSensitive)
			listReports = [Select r.Name, r.Id, r.DeveloperName From Report r 
								Where  DeveloperName = :CNConstants.AUDIT_LOG_REPORT_SANITIZED];//NamespacePrefix = 'ContactNet' and
		else
			listReports = [Select r.Name, r.Id, r.DeveloperName From Report r 
								Where  DeveloperName = :CNConstants.AUDIT_LOG_REPORT_NON_SANITIZED];//NamespacePrefix = 'ContactNet' and
		
		if (listReports.size()>0)
	 		reportURL = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + listReports[0].Id + '?export=1&enc=UTF-8&xf=csv';
	 		
	 }

	       
}