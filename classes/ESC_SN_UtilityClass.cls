/**********************************
Class Name: ESC_SN_UtilityClass
Purpose: Utility class for SC-SN Integration
Author:Mousumi Panda
Date Created:01/11/2018
Date Updated:V0:
**********************************/
public Class ESC_SN_UtilityClass{

    public static void RefDeletionPostCommentInStaging(List<ESC_Case_Collaborator__c> oldreferrallist){
     system.debug('oldreferrallist*****'+oldreferrallist);
        List<id> listRefDel = new List<id>();
          ESC_SN_AssignmentGroup__c SNgroup= ESC_SN_AssignmentGroup__c.getInstance(UserInfo.getUserId());
          Id Queueid= [select Id from Group where Name =:SNgroup.ESC_Assignment_Group__c  and Type = 'Queue'].Id;
        for(ESC_Case_Collaborator__c ref:oldreferrallist){
           system.debug('ref.OwnerId*****'+ref.OwnerId);
            system.debug('SNgroup.ESC_Assignment_Group__c*****'+SNgroup.ESC_Assignment_Group__c);
            if(ref.ESC_Role__c =='Accountable Resolver' && ref.OwnerId == Queueid){
              listRefDel.add(ref.id);
            }
        }
        system.debug('listRefDel'+listRefDel);
        if(listRefDel.size()>0){
        List<ESC_ServiceNow_Staging__c> listDelUpdateStaging= new List<ESC_ServiceNow_Staging__c>();
        List<ESC_ServiceNow_Staging__c> listforStagingDeletion= new List<ESC_ServiceNow_Staging__c>();
        for(ESC_ServiceNow_Staging__c servicenowStaging: [Select id,ESC_SNOW_ID__c,ESC_Feed_Comment__c,ESC_Description__c,ESC_ID__c,ESC_Transmit_Status__c,ESC_Staging_Status__c from ESC_ServiceNow_Staging__c where ESC_ID__c IN:listRefDel]){
           if(servicenowStaging.ESC_SNOW_ID__c != null){
              servicenowStaging.id= servicenowStaging.id;
              //servicenowStaging.ESC_ID__c= null;
              servicenowStaging.ESC_Staging_Status__c='Mark for Deletion';
              servicenowStaging.ESC_Feed_Comment__c=Label.ESC_Ref_Deletion_Message+' ' + UserInfo.getName();
              listDelUpdateStaging.add(servicenowStaging);
            }
            else{
              listforStagingDeletion.add(servicenowStaging);
            }
        }
        if(listDelUpdateStaging.size()>0 && Label.ESC_SNUpdateSwitch == 'ON')
        update listDelUpdateStaging;
        
        if(listforStagingDeletion.size()>0)
        delete listforStagingDeletion;

    } 
    }   
}