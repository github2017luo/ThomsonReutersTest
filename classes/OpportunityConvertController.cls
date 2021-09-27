/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-22   Sudhir Kumar            Modified (As partof QC 4024, changed the Stage default value for Converted Pipeline Opportunity to 10%)
 * 2013-07-22   Srikanth Kuruva         Updated the entire class so that it works for both SF1 and SFDC
 * =============================================================================                                                   
*/


global with sharing class OpportunityConvertController {
    global static opportunity oOpty{get;set;} 
    //public boolean bPrivilegeFlag{get;set;} 
    global OpportunityConvertController (ApexPages.StandardController controller) {
        oOpty = (opportunity)controller.getRecord();
    }
    @RemoteAction
    global static void Convert(Id OppId) {
    oOpty = new Opportunity(Id=OppId);
    oOpty.recordtypeid=[select id from RecordType where DeveloperName='Pipeline_Opportunity' and SobjectType = 'Opportunity' limit 1].id;

    oOpty.stageName='10%'; 
    oOpty.Status__c='Converted';
    update oOpty;
        
    //return 'updated successfully'+oOpty;
  }
}