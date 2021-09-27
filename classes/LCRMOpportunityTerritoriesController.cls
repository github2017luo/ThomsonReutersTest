/*
@purpose : JIRA Story- CRM-13107
GLI Users (all tenants) must be able to see the Account Territory information on the Opportunity Page Layout with the following fields visible:
1.Territory #
2.Chanel
3.Region
4.Market Segment Desc
5.Rep Function Desc
6.SalesForce Description
======================================================================================================================
DATE(DD/MM/YY)           Developer NAME                       DESC
05/02/2018               Navjyoti Mohanta (Developed by)     
08/02/2018               Radhika Pawar (Modified by)         Added the channel field in listOfTMSTerritories SOQL
======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components
public without sharing class LCRMOpportunityTerritoriesController {
public LCRMOpportunityTerritoriesController ()
{}
    /*public ApexPages.StandardController oStandardController;
    public Opportunity oOpportunity;
    public Id idAccountId ;
    public list<TMS_Territory__c> listOfTMSTerritories {get; set;}
    public boolean flagTerritoryPresent {get; set;}
             
list<Opportunity> listOfOpportunity = new list<Opportunity>(); 
    public LCRMOpportunityTerritoriesController(ApexPages.StandardController oController) {
        oStandardController = oController;
         oOpportunity= (Opportunity) oController.getRecord();

if(Schema.sObjectType.opportunity.isAccessible())
         listOfOpportunity = [Select AccountId from opportunity where id =:oOpportunity.Id limit 1];
         idAccountId = listOfOpportunity[0].AccountId;
         
         system.debug('@@idAccountId -->' +idAccountId );
         if(Schema.sObjectType.TMS_Territory__c.isAccessible())
         if(idAccountId != null){
             listOfTMSTerritories =[Select Id ,Name ,Account__c,TMS_Territory_Number__c,Region__c,Channel__c,TMS_Market_Segment_Desc__c,TMS_Rep_Function_Desc__c,
             TMS_Sales_Force_Desc__c from TMS_Territory__c where Account__c =:idAccountId ];          }
         
         system.debug('@@@listOfTMSTerritories --> '+listOfTMSTerritories );
         
         if(listOfTMSTerritories.size() > 0){
             flagTerritoryPresent = true ;
         }else{
             flagTerritoryPresent = false ;
         }
         system.debug('@@flagTerritoryPresent-->'+flagTerritoryPresent);
         
         Apexpages.addMessage(new Apexpages.message(Apexpages.severity.Info ,System.Label.Opportunity_does_not_have_any_related_TMS_Territories));
    }
*/
}