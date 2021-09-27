/**
     * @description ESC_Customer360Controller
     * 
     */
public without sharing class ESC_Customer360Controller{
/**
     * @description Justdesc
     * @return jusdesc
     */
public PageReference newPage(){
System.debug(LoggingLevel.WARN,'testcaseId3^^'+ApexPages.currentPage().getParameters().get('id'));
Case c= new Case();
if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isQueryable()){
c=[select id,accountid,LCRM_Account_SSD__c,USL_SAP_Account_Number__c,casenumber from case where id =:ApexPages.currentPage().getParameters().get('id')];}
List<Source_System_Detail__c> ssd= New List<Source_System_Detail__c>();
if(Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){
 ssd = [select id,LCRM_SAP_Account_Number__c,Source_System_Account_Number__c from Source_System_Detail__c where Source_System_Account_Number__c=:c.USL_SAP_Account_Number__c limit 1];}
if(ssd.size()>0){
System.debug(LoggingLevel.WARN,'testcaseId4^^'+c+ssd);
    PageReference newPage = new PageReference('/apex/USLSubscription');     
    newPage.getParameters().put('id', ssd[0].id); 
    newPage.getParameters().put('flag', 'true'); 
    newPage.setRedirect(true); 
    return newPage;

    }else {
        return null;
    }
}
}