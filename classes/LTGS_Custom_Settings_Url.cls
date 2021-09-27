/**
 */
 /**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 
* 2/28/2019   Ankit Raj       Controller class for the below lightning components
                                            LTGS_Create_Quote
                                            LTGS_Create_Trial
                                            LTGS_New_Competitive_Info
                                            LTGS_Request_Extension
                                            LTGS_Service_Request_Report

* =============================================================================
*/ 

public without sharing class LTGS_Custom_Settings_Url {

    /****************************************************************************************************************************
                getCustomSettings() fetches the KeyValueListStore__c custom setting text_value__c field value
    *****************************************************************************************************************************/ 
     
    @AuraEnabled
    public static String getCustomSettings(String recordName){
        String url;
       
        KeyValueListStore__c keyValue= KeyValueListStore__c.getValues(recordName);
        if(keyValue != null){
        url= keyValue.TextValue__c;
        }
        return url;
    }
    
    
    /****************************************************************************************************************************
            optyDetails() returns the current opportunity record details
    *****************************************************************************************************************************/ 
    
    @AuraEnabled
    public static Opportunity optyDetails(Id recordId)
    {
        Opportunity opp;
        if (Schema.sObjectType.Opportunity.isQueryable()){
         opp = [select id,Name,OpportunityID18__c,LCRM_Product_Count__c,StageName,LCRM_Transaction_Type__c,LCRM_Status__c from Opportunity where id =: recordId];
        }
        return opp;
        
        
    }
}