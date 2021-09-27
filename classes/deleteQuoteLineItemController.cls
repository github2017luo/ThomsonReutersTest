public class deleteQuoteLineItemController {

    public QuoteLineItem objQLIcurrent;
    public QuoteLineItem objQLI;
    public Quote objQuote;
    public String strPageId;
    //public String strCurrentPageId;
    public String strProfileName;
    
    public deleteQuoteLineItemController(ApexPages.StandardController stdController) {
        objQLIcurrent = (QuoteLineItem)stdController.getRecord();
        //strCurrentPageId = apexpages.currentpage().getparameters().get('id');
        strPageId = objQLIcurrent.id;
        System.Debug('*****strPageId:'+strPageId);
        //System.Debug('*****strCurrentPageId:'+strCurrentPageId);
        System.Debug('*****objQLIcurrent:'+objQLIcurrent);
        objQLI = [SELECT id, QuoteId, Item_Activity_Type__c, RenewalCheckQLI__c FROM QuoteLineItem WHERE id =: strPageId LIMIT 1];
        objQuote = [SELECT id FROM Quote WHERE id =: objQLI.QuoteId LIMIT 1];
        System.Debug('*****objQuote:'+objQuote);
    }
    
    public PageReference restrictDelete() {
        PageReference pr;
        if((userinfo.getProfileid() == Profile_List__c.getInstance('LatAm User').ProfileId__c ||
            userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c)
            && (objQLI.Item_Activity_Type__c == 'Renewed' || objQLI.Item_Activity_Type__c == 'Cancelled' 
            || objQLI.Item_Activity_Type__c == 'Uplift' || objQLI.Item_Activity_Type__c == 'Downgrade' || objQLI.Item_Activity_Type__c == 'Removed') && objQLI.RenewalCheckQLI__c == true){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label.Delete_Permission_Revoke + objQLI.Item_Activity_Type__c);
            ApexPages.addMessage(errorMsg);
            //return NULL;
        }
        else {
            if(objQLI != null){
                DELETE objQLI;
                pr = new PageReference('/'+objQuote.id);
                pr.setRedirect(true);
            }
        } 
        return pr;
    }
    
    public PageReference returntoQuote() {
        PageReference pr;
        pr = new PageReference('/'+objQuote.id);
        /*if(strCurrentPageId == objQuote.id){
            pr = new PageReference('/'+objQuote.id);
        }
        else{
            pr = new PageReference('/'+objQLIcurrent.id);
        }*/
        pr.setRedirect(true);
        return pr;
    }

}