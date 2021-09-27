/* -----------------------------------------------------------------------------------------------------
CLASS NAME: LCRMOptyStatusChangeCtrl

PURPOSE : LCRMOptyStatusChangeCtrl class is used to handle/extend the functionality of 
		  'remove pending cancel' button of opportunity object.

Created By : TCS

Date : 29/08/2017
-------------------------------------------------------------------------------------------------------*/
public class LCRMOptyStatusChangeCtrl {
    
    public boolean errors {get;set;}
    public Opportunity opp {get;set;}
    public Id oppId {get;set;}
    
    public LCRMOptyStatusChangeCtrl(ApexPages.StandardController controller){
        errors = false;
        oppID = ((Opportunity)controller.getRecord()).ID;
        opp = [SELECT ID, Name, LCRM_Sub_BU__c,  Is_GLI__c, Renewal_Flag__c, LCRM_Status__c FROM OPPORTUNITY WHERE ID = :oppID];
        //if(opp.LCRM_Sub_BU__c != 'UKI' || !opp.Renewal_Flag__c || opp.LCRM_Status__c != 'Pending Cancel'){
		if(opp.LCRM_Status__c != 'Pending Cancel'){
            errors = true;
            /*Error if record is either 'Sub BU' not 'UKI' or 'Renewal flag' is false or 'Status' is not 'Pending cancel'*/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.LCRMCheckTheOpportunity));
            return;
        }
        
    }
/* -------------------------------------------------------------------------------

Method Name:updateStatus

Purpose : updateStatus method is used to update the opportunity status value to open and 
		  return back to opportunity page

Created by : TCS

Date : 29/08/2017
--------------------------------------------------------------------------------*/
    
    public Pagereference updateStatus(){
        Pagereference pg = new Pagereference('/'+opp.Id);
        pg.setRedirect(true);
        
        if(Approval.isLocked(opp.Id)){
            errors = true;
            /*Error if record is locked in approval process*/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.LCRMRecordIsLocked));
            return null;
        }else{
            Opportunity opty = new Opportunity(Id=opp.Id);
            opty.LCRM_Status__c = 'Open';
            update opty;
            return pg;
        }
        return null;
    }
    /*Go back to opportunity page*/
    public Pagereference gotoOpty(){
        Pagereference pg = new Pagereference('/'+opp.Id);
        pg.setRedirect(true);
        return pg;
    }

}