/********************************************************************** 
Name: LTS_populateSegmentForPartnerUser
====================================================== 
Req: The purpose of this class is to assign segment and leadsource value to partner records. 
This class is also used to trigger 'Lead Assignemnt Rule' from LeadAfterEvent Listener
====================================================== 

====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL            JIRA STory Number
1.0        TCS Developer     25/10/2018     Initial Development  DPS-1865
***********************************************************************/
public without sharing class LTS_populateSegmentForPartnerUser {
    
    
    
    public static void populateSegmetForPartnerUser(List<lead> objectList){
        
        String customsettingProfileName;
        String customsettingLeadSourceValue;
        String customsettingBUSegmentValue;
        KeyValueListStore__c partneruserProfileName = KeyValueListStore__c.getValues('LTS_partnerUserProfileName');
        KeyValueListStore__c partnerUserLeadSourceValue = KeyValueListStore__c.getValues('LTS_partnerUserLeadSourceValue');
        KeyValueListStore__c partneruserBUSegmentValue = KeyValueListStore__c.getValues('LTS_partnerUserBUSegmentValue');
        System.debug(partneruserProfileName+'::::LTS_partnerUserProfileName');
        customsettingProfileName = partneruserProfileName.TextValue__c !=null ? partneruserProfileName.TextValue__c : 'TR Corp Partner Community User';
        customsettingLeadSourceValue = partnerUserLeadSourceValue.TextValue__c !=null ? partnerUserLeadSourceValue.TextValue__c : 'Partner';
        customsettingBUSegmentValue = partneruserBUSegmentValue.TextValue__c !=null ? partneruserBUSegmentValue.TextValue__c : 'Corporate';
        
        String partnerProfileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        
        for(Lead partnerLead : objectList){
            SYSTEM.debug('partnerLead@@@@@@ ' +partnerLead);
            SYSTEM.debug('customsettingProfileName@@@@@@ ' +customsettingProfileName);
            
            //partnerLead.Segment
            if(customsettingProfileName.containsIgnoreCase(partnerProfileName)){
                partnerLead.LeadSource = customsettingLeadSourceValue;
                partnerLead.BU_Segment__c = customsettingBUSegmentValue;
                partnerLead.Is_GLI__c = true;
                if(String.isnotblank(partnerLead.Billing_Street__c)){
                   partnerLead.Street = partnerLead.Billing_Street__c;//Billing_Street__c
                }
                if(String.isnotblank(partnerLead.Billing_City__c)){
                   partnerLead.City = partnerLead.Billing_City__c;//Billing_City__c
                }
                if(String.isnotblank(partnerLead.Billing_State__c)){
                   partnerLead.State = partnerLead.Billing_State__c;//Billing_State__c
                }
                if(String.isnotblank(partnerLead.Billing_Country__c)){
                   partnerLead.Country = partnerLead.Billing_Country__c;//Billing_Country__c
                }
                if(String.isnotblank(partnerLead.Billing_Zip__c)){
                   partnerLead.PostalCode = partnerLead.Billing_Zip__c;//Billing_Zip__c
                }
            }
            
        }
    }
    //Method is used to invoke Lead assignment rule when lead is inserted via communities 
    public static void LeadAssign(Set<Id> LeadIds)
    {
        // Database.DMLOptions dmo = new Database.DMLOptions();
        // dmo.assignmentRuleHeader.useDefaultRule= true; 
        if(LeadIds.size() > 0 && LCRMGenericcomponent.islotususer()){
            
            //Fetching the assignment rules on lead
            /* AssignmentRule AR = new AssignmentRule();
AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
//Creating the DMLOptions for "Assign using active assignment rules" checkbox
Database.DMLOptions dmlOpts = new Database.DMLOptions();
dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;

Lead Leads=[select id,LeadSource,BU_Segment__c,Is_GLI__c,OwnerID from lead where lead.id in :LeadIds];       
Leads.setOptions(dmlOpts);
update Leads;
SYSTEM.Debug('INVOCABLEMETHOD'+Leads);*/
            
            List<Lead> updateList = new List<Lead>();
            List<Lead> LeadList=[select id,leadsource  from lead where lead.id in :LeadIds];
            for(Lead newLead : LeadList){
               
               if(newLead.leadsource != null & newLead.leadsource != '' && newLead.leadsource == 'Partner'){
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;     
                newLead.setOptions(dmo);
                updateList.add(newLead);
               }
                   /* Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule= true;     
                    newLead.setOptions(dmo);
                    updateList.add(newLead);
                */
                
            }
            if(updateList.size() > 0){
                update updateList;
            }
            
            
            
        }
        
    }
 }