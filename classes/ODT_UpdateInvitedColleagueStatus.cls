/*============================================================================================
    Name                : ODT_UpdateInvitedColleagueStatus
    Description         : This class is developed as part of CXD-ODT project :DLT-12091
                          This class is a webservice written to update Invited colleague record
    Created Date        : 09/07/2018
    Author              : Harshitha KN
    Modification History:
    Date           Name                    Description
    08/16/2018     Harshitha KN            Created
==============================================================================================*/

@RestResource(urlMapping='/ODTUpdateInvitedColleagueStatus/*')
global with sharing class ODT_UpdateInvitedColleagueStatus{
    
    @HttpPost
    global static responseWrapper updateInvitedColleague(String globalTrialID, String customerGUID, String incEmail, String status, String SAPContactNumber, date trialStartDate, date trialEndDate){
        responseWrapper resWrap;
        Database.SaveResult invitedColl;
        boolean checkIcUpdate=false;
        try{
            
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
          
            if(String.isBlank(incEmail)){
                resWrap=new responseWrapper('400', 'Email is blank');
                return resWrap;
            }
            else{
                Invite_Colleagues__c ic=[SELECT id, Email__c, Global_Trial_ID__c, GUID__c, SapContactId__c, Trial_End_Date__c, 
                                     Trial_Start_Date__c, Trial_Status__c from Invite_Colleagues__c WHERE Email__c=:incEmail AND Trial__r.Trial_Status__c ='Accepted' AND Trial_Status__c !=: status   ORDER BY LastModifiedDate DESC LIMIT 1];                                         
           
                if(ic.Id!=null){ 
                    system.debug('ic ID' +ic.Id);
                   if(globalTrialID != null && globalTrialID != '')
                       ic.Global_Trial_ID__c = globalTrialID;
            
                   if(customerGUID != null && customerGUID != '') 
                       ic.GUID__c = customerGUID;
                   
                   if(status != null && status != ''){
                       if(status.equalsIgnoreCase('Accepted'))    
                           ic.Trial_Status__c = status;
                   } 
                   
                   if(SAPContactNumber != null && SAPContactNumber != '')    
                       ic.SapContactId__c = SAPContactNumber;
               
                   if(trialStartDate != null ) 
                       ic.Trial_Start_Date__c = Date.valueof(trialStartDate);
               
                   if(trialEndDate != null )    
                       ic.Trial_End_Date__c = Date.valueof(trialEndDate);
             
                   invitedColl = Database.update(ic, false);
                    system.debug('invi' +invitedColl);
                    if(invitedColl.isSuccess()){
                        checkIcUpdate=true;
                    }
                }
        }
      }catch(exception e){
          system.debug('log' +e.getStackTraceString());
      }
        
      if(checkIcUpdate) {
           resWrap=new responseWrapper('200', 'Invited Colleague updated successfully');
           return resWrap;
      }else{
            resWrap=new responseWrapper('400', 'Update failed with no such Email');
            return resWrap;
      }
    }
    
    global class responseWrapper{
        global string statusCode;
        global string statusMessage;
        
        responseWrapper(String statusCode, String statusMessage){
            this.statusCode=statusCode;
            this.statusMessage=statusMessage;
        }
    }
}