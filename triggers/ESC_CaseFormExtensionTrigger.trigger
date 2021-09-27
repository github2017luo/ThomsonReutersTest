Trigger ESC_CaseFormExtensionTrigger on ESC_Case_Form_Extension__c (After insert,before update,after update) {
    
    ESC_CaseFormExtensionTriggerHandler.callCaseFormExtensionHandler(); 
    
}