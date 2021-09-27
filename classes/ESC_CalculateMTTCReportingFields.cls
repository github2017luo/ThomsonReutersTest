/**
* CHANGE HISTORY
* ============================================================================================================================
* Date         Name             JIRA          Description
* ============================================================================================================================
* 
* 2017-11-08   Ramesh T N       EES-36        1. Calculating MTTC Reporting Fields 
* 
* ============================================================================================================================
*/

public class ESC_CalculateMTTCReportingFields{
    @InvocableMethod(label = 'Calculate MTTC Fields' description='Calculating MTTC Reporting Fields for Case')
    public static void calculatMTTCFields(List<Case> caseList){
        
        List<Case> caseRecordList = new List<Case>();
        for(Case caseRecord:caseList){
            Case caseRec = new Case();
            caseRec.id = caseRecord.id;
           
            
           Double timeInMilliSec=(caseRecord.ClosedDate.getTime() - caseRecord.CreatedDate.getTime());
           caseRec.ESC_MTTC_in_hours__c = timeInMilliSec/(1000*60*60);
           caseRec.ESC_MTTC_in_days__c = timeInMilliSec/(1000*60*60*24);
           
           Double timeInMillis = BusinessHours.diff(caseRecord.BusinessHoursId, caseRecord.CreatedDate, caseRecord.ClosedDate);
           caseRec.ESC_MTTC_in_hoursBH__c = timeInMillis/(1000*60*60);
           caseRec.ESC_MTTC_in_daysBH__c = timeInMillis/(1000*60*60*24); 
          
           DateTime excludeCHTime;
           if(caseRecord.ESC_CustomerHoldTime__c != null){
               excludeCHTime = caseRecord.CreatedDate + caseRecord.ESC_CustomerHoldTime__c;    
           }else{
               excludeCHTime = caseRecord.CreatedDate;
           }
           
           
           Double exCHTimeInMilliSec=(caseRecord.ClosedDate.getTime()-excludeCHTime.getTime());
           caseRec.ESC_MTTC_in_hours_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60); 
           caseRec.ESC_MTTC_in_days_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60*24);
           
           Double exCHTimeInMillis = BusinessHours.diff(caseRecord.BusinessHoursId, excludeCHTime, caseRecord.ClosedDate);
           caseRec.ESC_MTTC_in_hours_excl_CHBH__c = exCHTimeInMillis/(1000*60*60); 
           caseRec.ESC_MTTC_in_days_excl_CHBH__c = exCHTimeInMillis/(1000*60*60*24); 

           caseRecordList.add(caseRec); 
        }
        
        update caseRecordList;
    }
}