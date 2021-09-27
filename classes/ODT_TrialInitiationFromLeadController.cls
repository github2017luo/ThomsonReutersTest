/*============================================================================================
Name        :       ODT_TrialInitiationFromLeadController
Description :       This class is developed as part of CXD-ODT: DLT-12949
                    This class serves as controller class to the VF page 'ODT_TrialInitiationFromLead'.

Modification History:
Date            Name                    Description
10/10/2018      Harshitha KN            Created
6/20/2019       Sneha W.                DLT-16849: Added utilization for ODT_TrialInitiationHelper class.
10/16/2020      Srinivasulu             DLT-20857: Added Additional Fields to display (Total Hours, Total Previous hours and Transactions)
==============================================================================================*/
public without sharing class ODT_TrialInitiationFromLeadController {
    public String leadId {get; set;} 
    public static Boolean checkVisibility {get; set;}
    public List<Lead_Trials__c> trialList {get; set;}
    
    
    public ODT_TrialInitiationFromLeadController(ApexPages.StandardController controller) {
        trialList = new List<Lead_Trials__c>();
    }
    
    // Method to fetch Trials related to the Lead
    public void fetchTrialDetails() {
        leadId = ApexPages.currentPage().getParameters().get('id');
        
        if (!String.isBlank(leadId)) {
            trialList = new List<Lead_Trials__c>([
                SELECT Id, Trial__c, Trial__r.Trial_Id__c, Trial__r.Name, Trial__r.Trial_Start_Date__c, 
                    Trial__r.Trial_End_Date__c, Trial__r.Trial_Status__c, Trial__r.ODT_Email__c,
                    Trial__r.ODT_SAP_Account_Number__c, Trial__r.Source_System_Detail__c ,Trial__r.Total_Hours__c, 
                    Trial__r.Total_Hours_Previous_Day__c,Trial__r.Transactions_Views__c 
                FROM Lead_Trials__c 
                WHERE Lead__c = :leadId 
                AND Trial__r.InvitedDateTime__c >= :(System.today() - 1095) 
                ORDER BY Trial__r.Trial_Status__c, CreatedDate DESC
            ]);
        }
        System.debug('TrialList: ' + trialList);
       
       //CRUD Validation
        if(!Schema.sObjectType.User.isAccessible()) {

            return;
        }
        // DLT-16849
        User user = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        checkVisibility = ODT_TrialInitiationHelper.isValidUserRole(user);
        System.debug('CheckVisibility: ' + checkVisibility + ' | UserRoleId: ' + user.UserRoleId);
    }
    
    /* 
    public PageReference callToContactsListConPage() {
        //leadID=ApexPages.currentPage().getParameters().get('id');
        System.debug('lead' + leadID);
        Lead l = [SELECT Id, PartnerAccount.Name, Account__c FROM Lead WHERE id = :leadID];
        PageReference pf = new PageReference('/apex/contactslist?id=' + l.Account__c);
        System.debug('lead' + l);
        pf.setRedirect(true);
        return pf;
    }
    */
    
    // Method to check whether loggedin user is Trial Manager role
    /*
    public static Boolean checkUserRole() {
        User userDetails;
        Id userId = UserInfo.getUserId();
        
        if (Schema.sObjectType.User.isAccessible()) {
            userDetails = [
                SELECT Id, UserRole.Name 
                FROM User 
                WHERE Id = :userId
            ];
            System.debug('Role Name:' + userDetails.UserRole.Name);
        }
        
        if ((Label.ODT_Trial_Manager_Role != null) && (userDetails.UserRole != null)) {        
            if (Label.ODT_Trial_Manager_Role.containsIgnoreCase(userDetails.UserRole.Name)) {
                checkVisibility = true;
            }
        } else {
            checkVisibility = false;
        }
        
        System.debug('checkVisibility:' + checkVisibility);
        return checkVisibility;
    } 
    */        
    
}