/**
* Description   : Create Record in Lead history Custom object for Lightning  
* JIRA Details  : DPS-7851
* Author        : Miriam Ghosh 
* Change History: 27-02-2020: Created
**/

public without sharing class LCRMConvertLeadMaptoLeadHistory 
{
    public static Boolean isFirstTime = true;    
    Map<String,LM_Lead_History__c> lHistoryMap{get;set;}
    @TestVisible public static Boolean isInSalesforceLightning = false;//for test class 
    public LCRMConvertLeadMaptoLeadHistory() 
    {
        lHistoryMap = new Map<String,LM_Lead_History__c>();
    }
    
    private String getLeadStatusIsConverted(String status) {
        LeadStatus oLeadStatus = new LeadStatus();
          //Added if condition to avoid APEX CRUD violation Rule 
        if(Schema.sObjectType.LeadStatus.isQueryable())
         {oLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true and MasterLabel = :status LIMIT 1];}
        
        return oLeadStatus.MasterLabel;
        
    }
    
    //public void createLeadHistory(String selectedLead)
    public void createLeadHistory(Sobject sobj)
    {
        LM_Lead_History__c lHistory = new LM_Lead_History__c();
        Lead leadDetails = (lead)sobj;
        system.debug('***Lead Details:'+leadDetails);
        /*Lead leadDetails = [SELECT Name,Contact__c,Campaign_Cell__c,Campaign_Code__c,Acceptance_SLA_Violation__c,
                       Accept_By_Date__c,Is_Trial_Lead__c,Convert_By_Date__c,Company, Business_Org__c, 
                       Contact_SAP_ID__c, Convert_SLA_violation__c, Discard_Reason__c,External_Contact_ID__c,
                       External_ID__c,LeadID18__c,LastModifiedBy.Name,owner.name,LeadSource,Type__c,
                       Primary_Campaign_Source__c,Priority__c,Source_Desc__c,Source__c,Tracking_Code__c,
                       Contact__r.AccountId,ID,Budget_Available__c,Decision_Maker_Champion__c,Need_Identified__c,
                       Qualified_Product_s__c,Qualifying_Notes__c,Telequalified_Appointment_Complete__c,
                       Timeline_Identified__c,Line_of_Business__c,Operating_Unit__c,Tele_Interaction__c 
                       FROM Lead
                       WHERE  Id =: selectedLead];*/
        
        if(lHistoryMap != null && lHistoryMap.size() > 0 && lHistoryMap.get(leadDetails.ID) != null) { lHistory = lHistoryMap.get(leadDetails.ID);
        }
        else
        {
            lHistory = new LM_Lead_History__c ();
        }
        //lHistory.name= leadDetails.name;
        lHistory.name= leadDetails.FirstName+ ' ' +leadDetails.LastName;
            system.debug('***Lead Name:'+leadDetails.name);
            system.debug('***Lead History Name:'+lHistory.name);
        String status = Label.LCRMLeadConvertStatus;
        lHistory.Status__c = getLeadStatusIsConverted(status);
        
        lHistory.Opportunity__c= leadDetails.convertedopportunityid;
        //lHistory.contact__c= leadDetails.Contact__c;   
        lHistory.contact__c= leadDetails.ConvertedContactId; 
        lHistory.Campaign_Cell__c = leadDetails.Campaign_Cell__c ;
        lHistory.Campaign_Code__c = leadDetails.Campaign_Code__c;
        lHistory.Acceptance_SLA_Violation__c = leadDetails.Acceptance_SLA_Violation__c;
        lHistory.Accept_By__c = leadDetails.Accept_By_Date__c;
        lHistory.Is_Trial_Lead__c = leadDetails.Is_Trial_Lead__c;
                 
        lHistory.Convert_By__c = leadDetails.Convert_By_Date__c;
        lHistory.Account_Name__c = leadDetails.Company;
        lHistory.Business_Org__c = leadDetails.Business_Org__c;
        //lHistory.Contact_ID__c = leadDetails.Contact__c;
        lHistory.Contact_SAP_ID__c = leadDetails.Contact_SAP_ID__c;
        lHistory.Convert_SLA_violation__c = leadDetails.Convert_SLA_violation__c;
        lHistory.Discard_Reason__c = leadDetails.Discard_Reason__c;
        lHistory.External_Contact_ID__c = leadDetails.External_Contact_ID__c;
        lHistory.External_ID__c = leadDetails.External_ID__c;
        //lHistory.Lead_ID__c = leadDetails.id;
        lHistory.Lead_ID__c = leadDetails.Lead_ID__c;
        lHistory.LeadID18__c = leadDetails.LeadID18__c;
        lHistory.Lead_Last_Modified_by__c = leadDetails.LastModifiedById;
        //lHistory.Lead_Last_Modified_by__c = leadDetails.LastModifiedBy.Name;
        //lHistory.Lead_Owner__c = leadDetails.owner.id;
        lHistory.Lead_Owner__c = leadDetails.OwnerId;
            system.debug('***Lead History lead Owner:'+lHistory.Lead_Owner__c);
        lHistory.Lead_Source__c= leadDetails.LeadSource;
        lHistory.Lead_Type__c = leadDetails.Type__c;
        //lHistory.Name__c = leadDetails.Name;
        lHistory.Name__c = leadDetails.FirstName+ ' ' +leadDetails.LastName;
        lHistory.Primary_Campaign_Source__c = leadDetails.Primary_Campaign_Source__c;
        lHistory.Priority__c = leadDetails.Priority__c;
        lHistory.Source_Desc__c = leadDetails.Source_Desc__c;
        lHistory.Source_Type__c = leadDetails.Source__c;
        lHistory.Tracking_Code__c = leadDetails.Tracking_Code__c;
        //lHistory.Account_ID__c= leadDetails.Contact__r.AccountId; 
        lHistory.Account_ID__c= leadDetails.ConvertedAccountId;
        //lHistory.Account_ID__c= '001S000000pexBg'; 
        lHistory.Lead__C = leadDetails.ID;        
        lHistory.Budget_Available__c = leadDetails.Budget_Available__c;
        lHistory.Decision_Maker_Champion__c = leadDetails.Decision_Maker_Champion__c;
        lHistory.Need_Identified__c = leadDetails.Need_Identified__c;
        lHistory.Qualified_Product_s__c = leadDetails.Qualified_Product_s__c;
        lHistory.Qualifying_Notes__c = leadDetails.Qualifying_Notes__c;
        lHistory.Telequalified_Appointment_Complete__c = leadDetails.Telequalified_Appointment_Complete__c;
        lHistory.Timeline_Identified__c = leadDetails.Timeline_Identified__c; 
        //Added for Jira Story CRM-18115
        lHistory.Line_of_Business__c = leadDetails.Line_of_Business__c;
        lHistory.Operating_Unit__c = leadDetails.Operating_Unit__c;
        lHistory.Tele_Interaction__c = leadDetails.Tele_Interaction__c;
        lHistory.Lead_Score__c = leadDetails.Lead_Scoring_Combined__c; //added as a part of DPS-18629
        lHistory.Is_Marketing__c = leadDetails.Is_Marketing__c; //added as a part of DPS-18629
            system.debug('***lead Score:'+leadDetails.Lead_Scoring_Combined__c);
            system.debug('***lead is marketing:'+leadDetails.Is_Marketing__c);
            system.debug('***Lead History lead Score:'+lHistory.Lead_Score__c);
            system.debug('***Lead History lead is marketing:'+lHistory.Is_Marketing__c);
        lHistoryMap.put(leadDetails.ID,lHistory);
        
        system.debug('***lHistory ***'+lHistory );
        
        try{
            upsert lHistoryMap.values();
            system.debug('*** LOG STATUS:: LM Lead History created');
        }catch(Exception Ex){
            system.debug('*** create LM Lead History error:: '+ Ex.getMEssage());  
        }
    }
    
    
}