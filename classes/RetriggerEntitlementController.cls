/**
 * This class is VF controller for Retrigger Entitlement functionality.
 *
 * @author:  Snehajit
 * @version:  2017-10-05
 */
 /**
 * CHANGE HISTORY
 * ===============================================================================================
 * Date         Name                        Description
 * 2017-10-05   Snehajit                    Created (User Story: PTL-37)
 *
 * ===============================================================================================
 */

public with sharing class RetriggerEntitlementController {
    
    public id QuoteId {get;set;} //Store the Quote Id from VF page 
    public String strOppId {get; set;} //Store the Opportunity Id from VF page
    public Quote objQuote { get; set; } //Retrieve the record details from VF page
    public boolean blnShowpage {get;set;} //Switch between standard Quote detail page and error page
    
    /*------Constructor Method-------START--------*/
    public RetriggerEntitlementController(ApexPages.StandardController controller) {
        objQuote =  (Quote) controller.getRecord();
        QuoteId = objQuote.Id;
        System.debug('The Quote record: ' + QuoteId);
        strOppId = objQuote.OpportunityId;
    }
    /*------Constructor Method-------END--------*/
    
    //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    //User u2 = [SELECT Id FROM User WHERE ProfileId=:p.id]; 

     // System.runAs(u2) {
    
    /***************************************************************************************************************
    Method Name: setProviewEntitlementCallOut
    Created By: Snehajit
    Purpose: Make callout to ESI for Entitlement manually when it has failed. Also show conditional erros to users. 
    Defects:
    ***************************************************************************************************************/
    public Pagereference setProviewEntitlementCallOut() {
        try{
        
            //String strStatus = 'Failure';
            System.debug('The Quote record: ' + strOppId);
            blnShowpage = false;
            //ProviewEntitlementCallOut.SendRequest(QuoteId);
            /*--------Fetching Opportunity Details--------*/
           /* Opportunity opp = [SELECT id, Entitlement_Path__c, 
                                    Entitlement_Ready__c 
                                FROM Opportunity 
                                WHERE Id =: strOppId]; */
            
            /*--------Fetching Quote Details--------*/
            Quote quo = [SELECT id, Status, Entitlement_Generated__c,Entitlement_Path__c, 
                            Entitlement_Status__c, Entitlement_Complete__c 
                        FROM Quote 
                        WHERE Id =: QuoteId];
     
            /*----Fetching Current LoggedIn User------*/
            System.debug('Current User');
            Id CurrentUserId = UserInfo.getUserId();
            System.debug('Current User'+CurrentUserId);
            
            /*----Fetching Group Member Information, who has access to Retrigger Entitlement------*/
           /* List<GroupMember> groMem=[SELECT GroupId,Id,UserOrGroupId 
                                        FROM GroupMember 
                                        WHERE Group.Name='Proview Users']; */
                                        
          //  Boolean blnMemberPresent=false; //Boolean to switch conditions, whether logged in user is a Group Member
            
            /*-----------Check if Current logged in user belongs to Group Member-----------*/
          /*  if(!groMem.isEmpty()){
                for(GroupMember gr: groMem ){
                    if(gr.UserOrGroupId == CurrentUserId){
                         blnMemberPresent=true;
                    }
                }
            } */
            
            ProviewUser__c lstProviewUsr = ProviewUser__c.getInstance(CurrentUserId);
            Boolean blnRetrigger = lstProviewUsr.Retrigger_Entitlement__c;
            
            blnShowpage = false;
           /*-----------Check if Current logged in user belongs to Custom setting Member-----------*/
            //if(blnMemberPresent){
              if(blnRetrigger){
                System.debug('Group Member check ' );
                /*----------Retrigger Entitlement for Pre Order-------------*/
                if(quo.Entitlement_Path__c=='Pre Order' && (quo.Entitlement_Complete__c== false && quo.Entitlement_Status__c!=null  && quo.Entitlement_Status__c.toUpperCase()=='FAILURE' ) ){  
                   System.debug('#############');
                   ProviewEntitlementCallOut.SendRequest(QuoteId);    
                }
                /*----------Retrigger Entitlement for Post Order-------------*/
                else if(quo.Entitlement_Path__c=='Post Order' && (quo.Entitlement_Complete__c== false && quo.Entitlement_Status__c!=null && quo.Entitlement_Status__c.toUpperCase()=='FAILURE') && (quo.Entitlement_Status__c!=null) && quo.Status == 'Order Completed'){
                   System.debug('@@@@@@@');
                   ProviewEntitlementCallOut.SendRequest(QuoteId);     
                }
                /*----------Show error to users clicking Retrigger Entitlement button without Failure-------------*/
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.Do_Not_Click_Retrigger_Entitlement_First_Time)); 
                    blnShowpage = true;
                }
                //showQuoteDetail();
            }
            /*-----------Show error to logged in user, if do not have access to Retrigger Entitlement---------*/
            else{
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.Restrict_User_not_belonging_to_Public_Group)); 
                 blnShowpage = true;
            }   
            PageReference pageRef = new PageReference('/'+ QuoteId);
            pageRef.setRedirect(true);
            
            /*-------Show error page for unsuccessful retrigger---------*/
            if(blnShowpage){
                return null;
            }
            /*-------Return to current page for successful retrigger-------*/
            else{
                return pageRef;
            }
            
            //PageReference pageRef = new PageReference();
            //system.debug('******URL' +pageRef );
            //pageRef = null;
            //return null;
        }
        catch(System.DmlException oException){
            System.debug('****oException.getDmlMessage(0)'+oException.getDmlMessage(0));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,oException.getDmlMessage(0)));
            blnShowpage = true;
            return null;
        }
    }
    
    /***************************************************************************************************************
    Method Name: showQuoteDetail
    Created By: Snehajit
    Purpose: Return to Standard Quote Detail page from the error page 
    Defects:
    ***************************************************************************************************************/
    public Pagereference showQuoteDetail(){
        blnShowpage = false;
        PageReference pageRef = new PageReference('/'+ QuoteId);
        pageRef.setRedirect(true);
        return pageRef;
    }    
}