/**============================================================================================
Name:           ODTTrialInitiateOpportunity
Description:    This class is developed as part of CXD-ODT project : DLT-12947
                The class serves as a controller for the VF page 'ODT_TrialInitiateFromOpportunity' 
                in order to display the related trials.

Modification History:
Date            Name                    Description
10/19/2018      Ameeta Antonio          Created.
06/24/2019      David Hoel              DLT-16849: added utilization of ODT_TrialInitationHelper class.
07/12/2019      David Hoel              DLT-17089: added New Customer Trial redirect.
10/16/2020      Srinivasulu             DLT-20857: Added Additional Fields to display (Total Hours, Total Previous hours and Transactions)
==============================================================================================**/ 
public without sharing class ODTTrialInitiateOpportunity {
    public String oppId {get; set;}
    public String ssdId {get; set;}
    public String accId {get; set;}
    public List<Trial__c> trialsTodisplay {get; set;}
    public List<Opportunity_Trial__c> listOppTrial {get; set;}
    public Boolean checkVisibility {get; set;}
    
    // Constructor
    public ODTTrialInitiateOpportunity(ApexPages.StandardController controller) {
        if(!Schema.sObjectType.User.isAccessible()) {
            throw new DCCustomException('ODTTrialInitiateOpportunity - User is not accessible');
        }
        User user = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        checkVisibility = ODT_TrialInitiationHelper.isValidUserRole(user);
        System.debug('checkVisibility: ' + checkVisibility + ' | UserRoleId: ' + user.UserRoleId);  
        
        oppId = ApexPages.currentPage().getparameters().get('id').escapeHtml4();
        ssdId = '';
        accId = '';
    }
    
    /**
     *  Method to fetch trials related to Opportunity
     */
    public void getTrialOpportunity() {
        System.debug('>>>>> getTrialOpportunity');            
        System.debug('oppId: ' + oppId);
        
        if(!String.isBlank(oppId)) {
            Opportunity opp;
            
            if (Schema.sObjectType.Opportunity.isAccessible()) {
                opp = [SELECT Id, Source_System_Detail__c, AccountId FROM Opportunity WHERE Id = :oppID];
            }
            accId = opp.AccountId;
            ssdId = opp.Source_System_Detail__c;
            
            listOppTrial = new List<Opportunity_Trial__c>([
                SELECT Id, Opportunity__c, Trial__c, Trial__r.Name, Trial__r.Trial_Id__c, Trial__r.Trial_Start_Date__c, 
                    Trial__r.Trial_End_Date__c, Trial__r.Trial_Status__c,Trial__r.ODT_Email__c, Trial__r.Source_System_Detail__c, 
                    Trial__r.ODT_SAP_Account_Number__c,Trial__r.Source_System_Detail__r.Name,Trial__r.Total_Hours__c, 
                    Trial__r.Total_Hours_Previous_Day__c,Trial__r.Transactions_Views__c 
                From Opportunity_Trial__c 
                WHERE Opportunity__c = :oppID 
                AND Trial__r.InvitedDateTime__c >= :(system.today() - 1095) 
                ORDER BY Trial__r.Trial_Status__c, Trial__r.LastModifiedDate DESC
            ]);      
            System.debug('listOppTrial: ' + listOppTrial);
              
        }
    }
    
    // New Trial-button redirect call to vfp
    public PageReference callToContactList() {
        String pageRef = accId + '&oppID=' + oppId;
        System.debug('oppID' + oppId);
        
        if(ssdId != null && ssdId != '') {
            pageRef += '&ssdID=' + ssdId; 
        }
        PageReference pf = new PageReference('/apex/contactslist?id=' + pageRef);
        
        pf.setRedirect(true);
        return pf;
    }
    
    // New Customer Trial-button redirect call to vfp.
    public PageReference newCustomerRedirect() {
        String pfParams = 'Id=' + oppId;
        PageReference pf = new PageReference('/apex/ODTStartNCJ?' + pfParams);
        System.debug('PageRef: ' + pf);
        
        pf.setRedirect(true);
        return pf;
    }
    
}