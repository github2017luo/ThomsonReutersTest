/**
 * @description
 * Apex class : OmniEndTrialsController
* JIRA Details: DPS-21106
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JULY 2021     TCS DevTeam             Created as Part of DPS-21106
*                                                                 
* =====================================================================================================================
*/
public without sharing class OmniEndTrialsController {
    
    /**
     * @description checkTRAdministratorAssigned
     * @return isTrialAdminAssigned
     */
    @AuraEnabled
    public static Boolean checkTRAdministratorAssigned(){
        Boolean isTrialAdminAssigned = false;
        try {
            List<PermissionSetAssignment> assignmentList = new List<PermissionSetAssignment>();
            //fetch logged In User
            if(Schema.sObjectType.PermissionSetAssignment.isAccessible()){

                assignmentList = [SELECT Id,AssigneeId FROM PermissionSetAssignment 
                                    WHERE PermissionSet.Name = 'TR_Trial_Administrator' AND 
                                    AssigneeId =: UserInfo.getUserId()]; 
   
            }
            if(assignmentList.size() > 0){
                isTrialAdminAssigned = true;
            }
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isTrialAdminAssigned;
    }

    /**
     * @description getPicklistValues
     * @param objectName
     * @param fieldName
     * @return picklistValues
     */
    @AuraEnabled
    public static List<string> getPicklistValues(String objectName, String fieldName){
        List<String> picklistValues = new List<String>();
        try 
        {
            Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
            Schema.DescribeSObjectResult r = s.getDescribe() ;
            Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
            Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                picklistValues.add(pickListVal.getValue());
            }    
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return picklistValues;
    }

    /**
     * @description updateEntTrialContAfterEndTrial
     * @param trialId
     * @param trialContIds
     * @param endReason
     * @return isSuccess
     */
    public static boolean updateEntTrialContAfterEndTrial(Id trialId, Set<Id> trialContIds, string endReason)
    {
        boolean isSuccess = false;
        try{

              
            Ent_Trial__c entTrial =new Ent_Trial__c();
            entTrial.Trial_End_Date__c = system.today();
            entTrial.End_Reason__c = endReason;
            entTrial.id = trialId;
            if(Ent_Trial__c.SObjectType.getDescribe().isUpdateable())
            { 
                update entTrial;
            }

            List<Trial_Contact__c> trialContsToUpdate = new List<Trial_Contact__c>();
            
            for(Id trialContId : trialContIds){
                Trial_Contact__c tc= new Trial_Contact__c();
                tc.End_Date__c = system.today();
                tc.id = trialContId;
                trialContsToUpdate.add(tc);
            }
            
            if(Trial_Contact__c.SObjectType.getDescribe().isUpdateable() && trialContsToUpdate.size()>0 )
            {
                update trialContsToUpdate;
            }

             isSuccess = true;
        }
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccess;

    }
     /**
     * @description updateEntTrialContAfterEndTrial   Method for Extend Trial Operation
     * @param trialId
     * @param trialContIds
     * @param noOfDaysToExtend
     * @return isSuccess
     */
    public static boolean updateEntTrialContAfterExtTrial(Id trialId, Set<Id> trialContIds,string noOfDaysToExtend)
    {
        boolean isSuccess = false;
        try{
  
              Ent_Trial__c trialRecord = OmniEndTrialRequestJSON.getTrailRecodDetails(trialId);
              Date endDate = trialRecord.Trial_End_Date__c;
              Integer noOfDays = Integer.valueOf(noOfDaysToExtend);
            Ent_Trial__c entTrial =new Ent_Trial__c();
            entTrial.Trial_End_Date__c = endDate.addDays(noOfDays);
            entTrial.Trial_Extend_Date__c = system.today();
            entTrial.Number_of_Days_to_Extend__c=noOfDays ;
            if(trialRecord.Number_of_Days__c != NULL){
               entTrial.Number_of_Days__c = trialRecord.Number_of_Days__c + noOfDays;
            }
            entTrial.Number_of_Times_Extended__c= trialRecord.Number_of_Times_Extended__c + 1;
            entTrial.id = trialId;
            if(Ent_Trial__c.SObjectType.getDescribe().isUpdateable())
            { 
                update entTrial;
            }
             
            List<Trial_Contact__c> trialContsToUpdate = new List<Trial_Contact__c>();
            
            for(Id trialContId : trialContIds){
                Trial_Contact__c tc= new Trial_Contact__c();
                tc.End_Date__c = endDate.addDays(noOfDays);
                tc.id = trialContId;
                trialContsToUpdate.add(tc);
            }
            
            if(Trial_Contact__c.SObjectType.getDescribe().isUpdateable() && trialContsToUpdate.size()>0 )
            {
                update trialContsToUpdate;
            }

             isSuccess = true;
        }
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccess;

    }
}