/**
* CHANGE HISTORY
* ============================================================================================================================
* Date         Name             JIRA          Description
* ============================================================================================================================
* 
* 2017-11-08   Ramesh T N       EES-36        1. Calculating MTTR Reporting Fields 
* 
* ============================================================================================================================
*/

public class ESC_CalculateMTTRReportingFields{
    @InvocableMethod(label = 'Calculate MTTR Fields' description='Calculating MTTR Reporting Fields for Case')
    public static void calculatMTTRFields(List<Case> caseList){
        
        List<Case> caseRecordList = new List<Case>();
        for(Case caseRecord: caseList){
            Case caseRec = new Case();
            caseRec.id = caseRecord.id;
            // The Service Restored field calculation is moved from Process to here to avoid order of sequence
            caseRec.ESC_Service_Restored__c = DateTime.now();
            
            
            Double timeInMilliSec=(caseRec.ESC_Service_Restored__c.getTime() - caseRecord.CreatedDate.getTime());
            
            caseRec.ESC_MTTR_in_hours__c = timeInMilliSec/(1000*60*60);
            caseRec.ESC_MTTR_in_days__c = timeInMilliSec/(1000*60*60*24); 
            
           Double timeInMillis = BusinessHours.diff(caseRecord.BusinessHoursId, caseRecord.CreatedDate, caseRec.ESC_Service_Restored__c);
           caseRec.ESC_MTTR_in_hoursBH__c = timeInMillis/(1000*60*60);
           caseRec.ESC_MTTR_in_daysBH__c = timeInMillis/(1000*60*60*24); 
          
           DateTime excludeCHTime;
           if(caseRecord.ESC_CustomerHoldTime__c != null){
               excludeCHTime = caseRecord.CreatedDate + caseRecord.ESC_CustomerHoldTime__c;    
           }else{
               excludeCHTime = caseRecord.CreatedDate;
           }
           
           
           Double exCHTimeInMilliSec=(caseRec.ESC_Service_Restored__c.getTime()-excludeCHTime.getTime());
           caseRec.ESC_MTTR_in_hours_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60); 
           caseRec.ESC_MTTR_in_days_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60*24);
           
           
           Double exCHTimeInMillis = BusinessHours.diff(caseRecord.BusinessHoursId, excludeCHTime, caseRec.ESC_Service_Restored__c);
           caseRec.ESC_MTTR_in_hours_excl_CHBH__c = exCHTimeInMillis/(1000*60*60); 
           caseRec.ESC_MTTR_in_days_excl_CHBH__c = exCHTimeInMillis/(1000*60*60*24); 

           caseRecordList.add(caseRec); 
        }
        
        update caseRecordList;

    }
}