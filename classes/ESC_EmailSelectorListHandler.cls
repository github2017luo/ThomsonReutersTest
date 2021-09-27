/**
 * CHANGE HISTORY
 * ============================================================================================================================
 * Date           Name             JIRA          Description
 * ============================================================================================================================
 * 
 * 2017-05-31   Karthi G            EBB        Trigger Handler to check duplicates in the ESC_LKP__c field
 * ============================================================================================================================
 */
public class ESC_EmailSelectorListHandler {
    
    public static void populateConcatenatedField(List<ESC_EmailSelectorList__c> lstEmailSelector){
        List<String> lkpList = new List<String>();
        for(ESC_EmailSelectorList__c es1:lstEmailSelector){
            lkpList.add(ES1.ESC_LKP__c);
        }
        List<ESC_EmailSelectorList__c> esList = [select ESC_LKP__c,name from ESC_EmailSelectorList__c where ESC_LKP__c IN :lkpList];
        Map<String,String> lkpMap = new Map<String,String>();
        for(ESC_EmailSelectorList__c es:esList){
            lkpMap.put(ES.ESC_LKP__c,ES.name);
        }
        for(ESC_EmailSelectorList__c esl:lstEmailSelector){
            if(lkpMap.containsKey(esl.ESC_LKP__c)){
                esl.addError(Label.ESC_EmailSelectorTriggerError+' '+lkpMap.get(esl.ESC_LKP__c));  
            }
        }
    }
    public static void updatelkpfield(Map<ID,ESC_EmailSelectorList__c>oldmap,List<ESC_EmailSelectorList__c> lstEmailSelector){
        List<String> lkpList1 = new List<String>();
        for(ESC_EmailSelectorList__c es2:lstEmailSelector){
            lkpList1.add(ES2.ESC_LKP__c);
        }
        List<ESC_EmailSelectorList__c> esList1 = [select ESC_LKP__c,name from ESC_EmailSelectorList__c where ESC_LKP__c in :lkpList1];
        Map<String,String> lkpMap1 = new Map<String,String>();
        for(ESC_EmailSelectorList__c es3:esList1){
            lkpMap1.put(ES3.ESC_LKP__c,ES3.name);
        }
        for(ESC_EmailSelectorList__c esl1:lstEmailSelector){
          if(esl1.ESC_LKP__c != oldmap.get(esl1.id).ESC_LKP__c){
            if(lkpMap1.containsKey(esl1.ESC_LKP__c)){
                esl1.addError(Label.ESC_EmailSelectorTriggerError+' '+lkpMap1.get(esl1.ESC_LKP__c));  
            }
            }
        }
    }
    
}