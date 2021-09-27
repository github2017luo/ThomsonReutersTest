/**
     * @description USL_DeleteCaseRecord 
     
     */
public class USL_DeleteCaseRecord implements Database.Batchable<sObject>{
        
     /**
     * @description Acritas_Web2CaseFormControllermain
     * @param execute
     * @return openedItems
     */ 
    public Database.QueryLocator start(Database.BatchableContext bC){
        String sub='\'%' + String.escapeSingleQuotes('Automatic Reply') + '%\'';
        String sub1='\'%' + String.escapeSingleQuotes('OOO') + '%\'';
        String sub2='\'%' + String.escapeSingleQuotes('Returned mail') + '%\'';
        String sub3='\'%' + String.escapeSingleQuotes('Undeliverable') + '%\'';

    //String Query ='Select Id,Origin,Subject,RecordType.Name,LCRM_Sub_BU__c From Case Where Origin = \'Email\' AND (LCRM_Sub_BU__c =\'USL\' OR LCRM_Sub_BU__c =\'\' ) AND (Subject LIKE '+Sub+ ' OR Subject LIKE '+Sub1+' OR Subject LIKE '+Sub2+' OR Subject LIKE '+Sub3+') AND (RecordType.DeveloperName = \'ESC_Incident\' OR RecordType.DeveloperName = \'ESC_Request_for_Action\' or RecordType.DeveloperName = \'ESC_RequestForService\')';     
    String query ='Select Id,Origin,Subject,RecordType.Name,LCRM_Sub_BU__c From Case Where Origin = \'Email\' AND (LCRM_Sub_BU__c =\'USL\' OR LCRM_Sub_BU__c =\'Canada\' OR LCRM_Sub_BU__c =\'\' ) AND (Subject LIKE '+sub+ ' OR Subject LIKE '+sub1+' OR Subject LIKE '+sub2+' OR Subject LIKE '+sub3+') AND (RecordType.DeveloperName = \'ESC_Incident\' OR RecordType.DeveloperName = \'ESC_Tech_Support\' OR RecordType.DeveloperName = \'ESC_Legal_Content\' OR RecordType.DeveloperName = \'ESC_Request_for_Action\' or RecordType.DeveloperName = \'ESC_RequestForService\')';
      System.debug(LoggingLevel.WARN,'Query' + query);
        return Database.getQueryLocator(query);
    }
/**
     * @description execute
     * @param execute
     */
    public void execute(Database.BatchableContext bC,List<Case> scope){
        Database.delete(scope,false);
       // Database.emptyRecycleBin(scope);
    }
/**
     * @description finish
     * @param finish
     */
   public void finish(Database.BatchableContext bC){
    
    AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:bC.getJobId()];
      
        String[] email= new string[]{'harsha.naik@tr.com'};
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.email};
        mail.toAddresses=email;
        mail.setToAddresses(mail.toAddresses);
        mail.setSubject('Match Merge Batch ' + a.Status);
        mail.setPlainTextBody('records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}