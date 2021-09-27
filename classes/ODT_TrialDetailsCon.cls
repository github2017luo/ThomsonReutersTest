/*============================================================================================
Name		:	ODT_TrialDetailsCon
Description	:	This class is developed as part of CXD ODT team . 
				This is the controller class for the ODT_TrialDetails.vfg to pass
					the trials details related to account.

Modification History:
Date				Name					Description
10/19/2018			Rohit Sharma			Created.
06/24/2019			David Hoel				DLT-16849: added utilization of ODT_TrialInitiationHelper class.
==============================================================================================*/
public without sharing class ODT_TrialDetailsCon {
    
    public List<Trial__c> trialsToDisplay {get; set;}
    public String currentRecordId {get; set;}
    public Id accId {get; set;}
    public Boolean checkVisibility {get; set;}
    
    public ODT_TrialDetailsCon(ApexPages.StandardController controller) {
         trialsToDisplay = new List<Trial__c>();
    }
    
    public void sendDetails(){
        accId = ApexPages.currentPage().getParameters().get('id');
        
        if (accId != null) {
            trialsToDisplay = new List<Trial__c>([
                SELECT Id, Trial_Id__c, Name, Trial_Start_Date__c, Trial_End_Date__c, Trial_Status__c, ODT_Email__c,
                	Source_System_Detail__c, ODT_SAP_Account_Number__c 
                FROM Trial__c 
                WHERE Source_System_Detail__r.Account_Name__c = :accId 
                AND InvitedDateTime__c >= :(System.today() - 1095)
                ORDER BY Trial_Status__c, createdDate DESC
            ]);
            
        }
        
        // DLT-16849
        User user = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        checkVisibility = ODT_TrialInitiationHelper.isValidUserRole(user);
        System.debug('CheckVisibility: ' + checkVisibility + ' | UserRoleId: ' + user.UserRoleId);
    }
    
    public PageReference callToContactListPage() {
        PageReference pf = new PageReference('/apex/contactslist?id=' + accId);
        pf.setRedirect(true);
        return pf;
    }
    
}