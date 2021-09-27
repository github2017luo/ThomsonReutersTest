/**============================================================================================
Name              : ODT_StartImmediateTrialHandler
Description       : This class is developed as part of CXD-ODT project : DLT-16452
                    The class serves as a controller for the VF page 'ODT_StartImmediateTrial' in order to fetch invited colleague details along with product details.
                    And changes the Trial Status of Trial and related Invited Colleague.

Author            : Sneha Wali

Changes:
        DLT-19237 : [SFDC] Add Trail End date function to check according ODT bundle data
==============================================================================================**/
public without sharing class ODT_StartImmediateTrialHandler {

    public Trial__c trialList {get; set;}
    public String trialId {get; set;}
    public String firstName{get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String checkboxText{get; set;}
    public boolean trialStartImmediate{get;set;}
    public Integer  Trailexpiryduration;
    
    public ODT_StartImmediateTrialHandler(ApexPages.StandardController controller) {
        trialStartImmediate = false;
    }
    
    // Method to fetch Invited Colleagues and product related to Trial
    public void getInvitedColleagueTrial() {  
        checkboxText=label.ODT_CheckBox_Text;
        trialId = ApexPages.currentPage().getparameters().get('id');             
        
        if(!String.isBlank(trialId)) {           
            trialList = [SELECT ID,Name,Trial_Status__c,ODT_Product_Bundle__r.Trial_Expiry_Days__c,Trial_Id__c,ODT_Product_Bundle__r.Bundle_ID__c,ODT_Product_Bundle__r.Product_Category__c,(SELECT Id,Trial_Status__c,First_Name__c,Last_Name__c,Email__c FROM Invite_Colleagues__r WHERE Primary_User__c = true)
                FROM Trial__c 
                WHERE ID = :trialId];    
            Trailexpiryduration=Integer.valueof(trialList.ODT_Product_Bundle__r.Trial_Expiry_Days__c);  // Added  as part of DLT-19237
                
        }
              
    }
    
    public Trial__c getTrial() {
        return trialList;
    }

    
    public PageReference updateStatus() {
        trialList.Trial_Start_Date__c = date.today();
        // DLT-19237 Starts here
        if(Trailexpiryduration!=null)
        {
            trialList.Trial_End_Date__c = date.today()+Trailexpiryduration;
        }
        // DLT-19237 ends here
        trialList.Trial_Initiated_Mode__c='Started Immediately';
        
        IF(trialList.Trial_Status__c == 'Invited'){
            trialList.Trial_Status__c = 'Rep Initiated'; 
        }        
        update trialList;
        if(!Test.isRunningTest()){
            ODT_TrialReInitiate_AddUser_Callout callout = new ODT_TrialReInitiate_AddUser_Callout(trialList.ID, true, true);
            Id jobID=System.enqueueJob(callout);
        }
        trialStartImmediate = true;
        return null;
    }
    
    public PageReference back(){
       PageReference myVFPage = new PageReference('/'+trialId);
       myVFPage.setRedirect(true);
       return myVFPage;
    }

}