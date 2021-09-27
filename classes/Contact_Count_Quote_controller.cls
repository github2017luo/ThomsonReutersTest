/*
======================================================================================================================
CLASS NAME:    Contact_Count_Quote_controller
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-15       Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class Contact_Count_Quote_controller{
    public Integer intContactCount {get;set;}
    Quote objQuote;
    Public String strPageId;
    public String xReplace {get;set;}
    String strLabel;

    public Contact_Count_Quote_controller(ApexPages.StandardController controller){
    }
    
    public void Contact_Count(){
        strPageId = apexpages.currentpage().getparameters().get('id');
/*System.Debug('@@@Page ID:'+strPageId);-- commented to reduce character for s2e optimization */
        objQuote = [SELECT AccountId, id FROM Quote WHERE id =: strPageId ];
        AggregateResult[] lstCont = [SELECT AccountId, Count(Id) count1 FROM Contact WHERE AccountId =: objQuote.AccountId 
                                     AND Role_s__c INCLUDES('SAP_Z6_E-Bill Email Contact') GROUP BY AccountId];
/*System.Debug('@@@Contact List:'+lstCont);-- commented to reduce character for s2e optimization */
        if(lstCont!=null && !lstCont.isEmpty()){
            for(AggregateResult ar : lstCont){
                intContactCount = (Integer)ar.get('count1');
/*System.Debug('@@@intContactCount:'+intContactCount);-- commented to reduce character for s2e optimization */
            }
            if(intContactCount>1){
                strLabel = Label.EBillContactCountMsg;
/*System.Debug('@@@strLabel more than 1:'+strLabel);-- commented to reduce character for s2e optimization */
                xReplace = strLabel.replace('X',(String.ValueOf(intContactCount)));
            } else if(intContactCount == 1){
                xReplace = Label.EBillContactCountMsg1;
/*System.Debug('@@@strLabel equal to 1:'+xReplace);-- commented to reduce character for s2e optimization */
            } else{
            xReplace = Label.EBillContactCountMsg0;
/*System.Debug('@@@strLabel no contact:'+xReplace);-- commented to reduce character for s2e optimization */
            }
/*System.Debug('@@@Warning message :'+xReplace);-- commented to reduce character for s2e optimization */
        }
        else{
            xReplace = Label.EBillContactCountMsg0;
/*System.Debug('@@@strLabel no contact:'+xReplace);-- commented to reduce character for s2e optimization */
        }
    }
}