/*
 * Created as part of DPS-17666
 * This is a controller class for VF page LOTUS_FlipS2ELeadsToGSI
 * Test Class : LOTUS_FlipS2ELeadsToGSI_Controller_Test
 */
public without sharing class LOTUS_FlipS2ELeadsToGSI_Controller {

   // public static Lead oLead{get;set;}
    public Lead oLead{get;set;}
    public static boolean checkRecursive = true;
    public LOTUS_FlipS2ELeadsToGSI_Controller(){
        oLead = new Lead();
    }

    public LOTUS_FlipS2ELeadsToGSI_Controller(ApexPages.StandardController controller) {
         oLead = (Lead)controller.getRecord();
    }
    
    //public static PageReference flipLead(){
    public PageReference flipLead(){
        PageReference pg;
        system.debug('lead id' + olead.id);
        Boolean hasCustomPermission = FeatureManagement.checkPermission('LOTUS_Lead_Flip_to_GSI');
        if (hasCustomPermission && checkRecursive) {
            Lead s2ELeadFields = getLead(oLead.Id);
            oLead.Language_Preference__c = 'English';
            /* oLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
            oLead.Sales_Org__c = 'GLI';
            oLead.Is_GLI__c = true;*/
            
                string descr = s2ELeadFields.Description!=NUll ? s2ELeadFields.Description : '';
            
                if(s2ELeadFields != Null){
                    descr += s2ELeadFields.Account__c!=NUll ? '\nAccount Name: '+s2ELeadFields.Account__r.Name :'\nAccount Name: '  ;
                    descr += s2ELeadFields.contact__c!=NUll ? '\nContact Name: '+s2ELeadFields.contact__r.Name : '\nContact Name: '  ;
                    descr += s2ELeadFields.sales_org__c!=NUll ?'\nSales Org: '+s2ELeadFields.sales_org__c : '\nSales Org: ' ;
                    descr += s2ELeadFields.SAPAccountNumber__c!=NUll ?'\nSAP Account Number: '+ s2ELeadFields.SAPAccountNumber__c : '\nSAP Account Number: ';
                }
                
            oLead.Description = descr;
            oLead.SAPAccountNumber__c = '';
            oLead.Account__c = NULL;
            oLead.Contact__c = NULL;
            
            oLead.ownerId = [select Id from Group where Name = 'AEM Risk Queue' and Type = 'Queue'].Id;
            
            if (Schema.sObjectType.Lead.isUpdateable()) {
                update oLead;
            }
            
            // Updating second time to avoid "Account Name missing" unhandled existing error in GLI, after Account is nullified
            oLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
            oLead.Sales_Org__c = 'GLI';
            oLead.Is_GLI__c = true;
            
            if (Schema.sObjectType.Lead.isUpdateable()) {
                update oLead;
            }
            checkRecursive = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.Lotus_Flip_Lead_success));
        }else{
            system.debug(oLead.Id);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, System.Label.Lotus_Flip_Lead_Failure));
        }
        
        //NullifyAccount(new list<id>{olead.id});
        return pg;
    }
    
    /*
    @Future    
    public static void NullifyAccount(List<Id> LeadId){
        Lead Lead_Id = getLead(leadID[0]);
        Lead_Id.Account__c = NULL;
        if (Schema.sObjectType.Lead.isUpdateable()) {
            update Lead_Id;
        }      
    }
    */
    
    //private static Lead getLead(Id ids){
    private Lead getLead(Id ids){
        Lead s2ELeadFields; 
        if (Schema.sObjectType.lead.fields.Id.isAccessible() && 
           Schema.sObjectType.lead.fields.name.isAccessible() &&
           Schema.sObjectType.lead.fields.account__c.isAccessible() &&
           Schema.sObjectType.lead.fields.contact__c.isAccessible() &&
            Schema.sObjectType.lead.fields.sales_org__c.isAccessible() &&
            Schema.sObjectType.lead.fields.SAPAccountNumber__c.isAccessible() &&
            Schema.sObjectType.lead.fields.Description.isAccessible() &&
            Schema.sObjectType.lead.fields.OwnerId.isAccessible() ) {
              s2ELeadFields = [select Id, name, account__c, account__r.name,contact__c, Contact__r.name, sales_org__c,
                               SAPAccountNumber__c,Description, ownerId from lead where Id =: ids];
          
        }else{
            s2ELeadFields = new Lead();
        }
           return s2ELeadFields;
    }
}