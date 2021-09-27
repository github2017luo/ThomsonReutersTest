/**
* Controller for the EliteCaseRedirectPage to create a new quote request for CPQ
*
* @author  Tejas Naik
* @version 2016-12-09
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date                 Name                    Description
* 2016-12-09       Tejas Naik              Created    
* 2017-01-02       Saloni Sukhija          Added the code to update Opportunity stage and initialise certain fields for case.   
* =============================================================================

*/
public class EliteCaseRedirectController {

    public List<Case> caseList;
    public Id opportunityId;
    public Opportunity oppty;
    public Case newcase{get;set;}
    
    public EliteCaseRedirectController(){
         opportunityId = ApexPages.CurrentPage().GetParameters().Get('id');
         caseList = new List<case>();
         caseList= [Select Opportunity__c,Status from Case where Opportunity__c=:opportunityId]; 
    }
    
    public PageReference redirectPage(){
        Pagereference pgref;
        Boolean redirect = false;
        Id caseid;
        if(caseList!=null && caseList.size()>0){
            for(Case obj: caseList){
                if(obj.Status != 'Closed'){
                    redirect = true;
                    caseid = obj.id;
                }
            }
        }
        if(redirect){
            pgref= new PageReference('/'+caseid);
            pgref.setRedirect(true);
            return pgref ;  
        }else{
            oppty = [select id,Name,OwnerId,Is_GLI__c,LCRM_Sub_BU__c, AccountID from opportunity where id=:opportunityId];
            newcase= new Case(Subject='CPQ - '+oppty.Name,Status='Draft',OwnerId=oppty.OwnerId,Is_GLI__c=oppty.Is_GLI__c,LCRM_Sub_BU__c=oppty.LCRM_Sub_BU__c,Opportunity__c=opportunityId, AccountID=oppty.AccountID);
            return null;
        }
    }
    
    public PageReference save() {
        insert newcase;
		/*if(newcase.Status == 'CPQ Pricing'){
            oppty.StageName = 'Generate Contract';
            update oppty;
        }*/
        Pagereference pg= new Pagereference('/'+newcase.id);
        pg.setRedirect(true);
        return pg;
        
    }
    
    public PageReference cancel(){
        Pagereference backtoopty = new Pagereference('/'+opportunityId);
        backtoopty.setRedirect(true);
        return backtoopty;
    }
}