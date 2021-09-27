public class deleteOpportunityProdController {

    public OpportunityLineItem objOLIcurrent;
    public OpportunityLineItem objOLI;
    public Opportunity objOpp;
    public String strPageId;
    //public String strCurrentPageId;
    public String strProfileName;
    
    public deleteOpportunityProdController(ApexPages.StandardController stdController) {
        objOLIcurrent = (OpportunityLineItem)stdController.getRecord();
        //strCurrentPageId = apexpages.currentpage().getparameters().get('id');
        strPageId = objOLIcurrent.id;
        System.Debug('*****strPageId:'+strPageId);
        //System.Debug('*****strCurrentPageId:'+strCurrentPageId);
        System.Debug('*****objOLIcurrent:'+objOLIcurrent);
        objOLI = [SELECT id, OpportunityId, Activity_Type__c, RenewalCheck__c FROM OpportunityLineItem WHERE id =: strPageId LIMIT 1];
        objOpp = [SELECT id FROM Opportunity WHERE id =: objOLI.OpportunityId LIMIT 1];
        System.Debug('*****objOpp:'+objOpp);
    }
    
    public PageReference restrictDelete() {
        PageReference pr;
        if((userinfo.getProfileid() == Profile_List__c.getInstance('LatAm User').ProfileId__c ||
            userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c)
            && (objOLI.Activity_Type__c == 'Renewed' || objOLI.Activity_Type__c == 'Cancelled' 
            || objOLI.Activity_Type__c == 'Uplift' || objOLI.Activity_Type__c == 'Downgrade' || objOLI.Activity_Type__c == 'Removed') && objOLI.RenewalCheck__c == true){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label.Delete_Permission_Revoke + objOLI.Activity_Type__c);
            ApexPages.addMessage(errorMsg);
            //return NULL;
        }
        else {
            if(objOLI != null){
                DELETE objOLI;
                pr = new PageReference('/'+objOpp.id);
                pr.setRedirect(true);
            }
        } return pr;
    }
    
    public PageReference returntoOppty() {
        PageReference pr;
        pr = new PageReference('/'+objOpp.id);
        /*if(strCurrentPageId == objOpp.id){
            pr = new PageReference('/'+objOpp.id);
        }
        else{
            pr = new PageReference('/'+objOLIcurrent.id);
        }*/
        pr.setRedirect(true);
        return pr;
    }

}