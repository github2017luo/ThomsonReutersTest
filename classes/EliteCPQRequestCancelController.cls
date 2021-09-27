global without sharing class EliteCPQRequestCancelController {
   webservice static String cancelCPQRequest(String caseID) {

      Case c = [SELECT ID, LCRM_Cancel_Request__c FROM Case WHERE ID = : caseID LIMIT 1];
      String errorMsg = '';

      if(c.LCRM_Cancel_Request__c == false) 
        { 
            c.LCRM_Cancel_Request__c = true;
            errorMsg = 'The quote request has been cancelled.';
        }
        else{
            c.LCRM_Cancel_Request__c = false;
            errorMsg = 'The quote request has been uncancelled.';
        }
      
      Database.update(c);
      
      return errorMsg;
   }
}