public without sharing Class ESC_CaseFormExtInsertTriggerHandler{    
    public static void onInsert(List<ESC_Case_Form_Extension__c > newFormExList){
         ESC_CaseFormExtension.escFromExtension(newFormExList);
    }
}