/**
 * OnlineContactsExport Page Controller for the to display page as CSV file with Online contacts of Quote/Proposal whic is calling from Online ContactsController
 *
 * @author  TCS
 * @version 2017-01-27
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-01-27   Sreenu D                     Created
 
 * =============================================================================
 */
global with sharing class OnlineContactsExportController {
    public Id proposalId {get; set;}
    public List<Online_Contacts__c> ocList {get; set;}    
    public OnlineContactsExportController() {
        proposalId = ApexPages.CurrentPage().getParameters().get('id');
        ocList = new List<Online_Contacts__c>();
         if(Schema.sObjectType.Online_Contacts__c .isAccessible()&&Schema.sObjectType.Online_Contacts__c.isQueryable()&& proposalId != null){
            ocList = [SELECT Account_Address__c,Account__c,Account__r.Name,ContactID__c,CreatedById,CreatedDate,Email__c,First_Name__c,Id,LastModifiedById,LastModifiedDate,Last_Name__c,Material__c,Name,OwnerId,Position__c,Product_Description__c,QuoteId__c,QuoteId__r.Name,SAP_Account_Number__c,Sftwr_Admin__c,Type__c,WLEc_Juris__c,Is_Banded_Product__c,NAIC_Name__c,NAIC_Number__c FROM Online_Contacts__c WHERE QuoteId__c = :proposalId ORDER BY SAP_Account_Number__c DESC Limit 50000 ];    
        }
        system.debug('ocList...'+ocList);
    }  
}