/*
======================================================================================================================
CLASS NAME:    LCRM_BU_Marketing_Handler
======================================================================================================================
PURPOSE:   Update the hidden "LCRM_BU_Marketing_As_Text__c" field with the selected values inside the 
"BU_Marketing_Segment__c" picklist.

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2018-06-21        Santiago Sosa           Created the class.
2018-08-23        Seema                    CRM-17840 Added changes to filter out USL from BU_Marketing_Segment__c
======================================================================================================================
*/

public class LCRM_BU_Marketing_Handler {
        
    public static void UpdateLCRM_BU_Marketing_As_Text_update (List<Account> lstOldValues, List<Account> lstNewValues) {
        String oldValue;
        String newValue;
        String outcome = '';
        For (integer index = 0 ; index < lstOldValues.size() ; index++) {
            oldValue = lstOldValues[index].BU_Marketing_Segment__c;
            newValue = lstNewValues[index].BU_Marketing_Segment__c;
            System.debug('oldValue ### '+oldValue );
            System.debug('newValue ### '+newValue );
            
            if (newValue != oldValue && newValue != '' && newValue != null) {
                //If the old value is different to the new value, update it.
                outcome = checkUSLValues(newValue);
              //lstNewValues[index].LCRM_BU_Marketing_As_Text__c = newValue.replace(';', '; ');
                lstNewValues[index].LCRM_BU_Marketing_As_Text__c = outcome;
            }else if(newValue == '' || newValue == null){
                lstNewValues[index].LCRM_BU_Marketing_As_Text__c = outcome;
            }           
        }
    }
    
    public static void UpdateLCRM_BU_Marketing_As_Text_insert (List<Account> lstNewValues) {
        String newValue;        
        for (account acc : lstNewValues) {
            //Save the selected values of the picklist into the "LCRM_BU_Marketing_As_Text" field.
            if (acc.BU_Marketing_Segment__c != null && acc.BU_Marketing_Segment__c != '') {
                
                newValue = acc.BU_Marketing_Segment__c;         
                String outcome = checkUSLValues(newValue);
                //acc.LCRM_BU_Marketing_As_Text__c = newValue.replace(';', '; ');
                acc.LCRM_BU_Marketing_As_Text__c = outcome;
            }
        }
    }
  
      //Added for CRM-17840
    public static string checkUSLValues(String newValue){
        List<String> splittedString=new List<String>();
        String outcome;
        
        splittedString=newValue.split(';');
        outcome='';
        System.debug('splittedString:-'+splittedString);
        if(!splittedString.isEmpty()){
            for(String s:splittedString){
                if(!s.contains('USL')){
                    outcome+=s+'; ';
                }
            }
            if(outcome.endswith('; ')){
                outcome= outcome.substring(0, outcome.length() - 2 ); 
            }  
        }
        return outcome;    
    }
    
}