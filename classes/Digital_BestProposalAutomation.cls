/* Created By - Dinesh Kumar Voonna/RaviTeja
   Purpose - Digital Quote Automation for Best Value
   Jira Story - DLT-1702
   Batch Job - Runs once in a day 
      
   Modified by Divija on Feb 21,2018
   DLT-7565 - When Quantity is not equal to Band Number, expire the proposal
   
   Modified by Brenda Shields 03/19/2018
   DLT-8184 - Do not Expire the Proposal if an Automation Error/Failure occurs
   
   Modified by Srikanth Kota 04/02/2018
   DLT-8188- BestProposal should not be created if straight renewal is not created.
   
   Modified by Srikanth Kota 05/03/2018
   DLT-9400- No Renewal Date comparison when Plus/Premium is created.//Remove 185 days and only future date which is equal and greater than today.

   Modified by Brenda Shields on May 04 2018
   DLT-9536 - Add dymanic coding for Digital Firm updates and set the owners of the Opp/Proposal/cart accordingly.
   
   Modified by Srikanth Kota 05/08/2018
   DLT-8692- Generate up-sell offers for Corporate up-sell offers.// Use Custmer Segment Add dymanic YOY by DC_Contract_Term_V2__mdt
   
   Modified by Rajan on May 9 2018
   DLT-8973 - Added Hard Bounce & SAP Contact ID fields on Digital subscription object and SAP Contact ID should be used as Order Confirmation Contact and Ebill contact.

   Modified by Divija S on May 17, 2018
   DLT-9827 - Quote Automation to take into account of hard bounce email flag while selecting OCC and Optimized Proposal Creation method to Digital_ProposalCreationCommoncode Class

   Modified by Divija S on June 11, 2018
   DLT-9755- Update Account / Contact object references for GLI Change

   Modified by Divija S on July 9 2018
   DLT-10763 - Customer Specific YoY values access from Digital Subscriptions

   Modified by Divija S on 18th Sep 2018
   DLT-12358 - Optimized Queries and code to avoid heap size limit error

   Modified By Divija S on 26th Sep 2018
   DLT 12136 - Create a re-usable components from Proposal Automation classes(Best and Config)
               Created a common method in a seperate class for all three proposal classes for cartcreation.
               
   Modified By Harika Sai P on 9th Jan 2019
   DLT-14286 - Exception logs being incorrectly created 
   
   Modified By Navleen Kaur on 14 Feb 2019
   DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
  
   Modified By Navleen Kaur on 19 Mar 2019
   DLT-15672 - [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
   
   Bishanka Dassarma      Apr 02 2019    DLT-15809        Finance load of opportunities done does not have Status value - Automation
   2019-07-27   Srikanth Kota   DLT-16958  [Tech Story] [SLF] Automation to create Plus and Premium proposal only based Ineligible sub flag on DS object
   2019-08-20   Navleen Kaur    DLT-17360 - [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been set
   2019-10-09   Brenda Shields  DLT-17732 - Fix Too many SOQL 5001 Error    
*/   

public without sharing class Digital_BestProposalAutomation implements Database.AllowsCallouts, Database.Batchable<Opportunity> {
    
	//public Static String priceListName = 'Thomson Reuters Master - US Legal'; 
	private static Final String OLDMIDCONTRACT='Old Mid Contract'; 
	private static Final String INELIGIBLE='Ineligible'; 
    // map to set opportunity owner based on Digital Firm value
    //private static Id priceBookId = [select id from pricebook2 where name = 'GLI Price Book - US Legal/LMS' limit 1].id;
    public static String quoteName = 'Best Value';
   	        
    //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
    /*
    public Static list<Product_Account_Detail__c> digitalSubscriptionsList = [SELECT AccountSSD__c,Type__c,Renewal_Date__c,Campaign_Code__c,
                                                                              Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,
                                                                              Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,
                                                                              SAP_Contact_Id__c,Hard_Bounce__c,Add_On_Sub__c,Add_On_Svc__c FROM Product_Account_Detail__c 
                                                                              where (Actual_New_Service__c != Null AND Actual_New_Subscription__c != Null) 
                                                                              AND Campaign_Code__c != Null 
                                                                              AND Type__c IN ('Plus','Config','Premium') AND Renewal_Date__c != Null AND Renewal_Date__c >=Today AND Bypass_Automation__c = false];
    */
    //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
    // DLT-17732 get list of distinct Opportunities to build Best Value Renewals
    // setting the Opportunity in the DS records is new and that relationship needs to be setup before the Best Values renewals can be created
    public static list<AggregateResult> dsOpps = [select Opportunity__c, count(Id) 
												from Product_Account_Detail__c 
												where Actual_New_Service__c != Null AND Actual_New_Subscription__c != Null
												AND Campaign_Code__c != Null and Opportunity__c != null
												AND Type__c IN ('Plus','Config','Premium') AND Renewal_Date__c != Null AND Renewal_Date__c >= Today 
												AND Bypass_Automation__c = false
												group by Opportunity__c];
			
    public Iterable<Opportunity> start(database.batchablecontext bC) {
        list<Opportunity> optyList = new list<Opportunity>();
    	Set<id> setOppIds = new Set<id>();	

		// build a list of Opportunity IDs to select specific Opps to build Best Valuse Proposals
		for(AggregateResult dsOppRec : dsOpps) {	
	        setOppIds.add((id)dsOppRec.get('Opportunity__c') );   
        }
        system.debug('New Opp IDs: ' + setOppIds);

        if(setOppIds != Null && setOppIds.size() > 0){
            //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
            // get Opportunities based on Opportunities already set in DS records
            optyList = [Select id,name,Ownerid,owner.name,owner.id,accountid,Source_System_Detail__r.id,
                            Source_System_Detail__r.LCRM_APTS_Band_Number__c,Source_System_Detail__r.LCRM_eOutput_Eligibility__c,
                            StageName,Renewal_Date__c,RecordTypeId,Campaign_Code__c,
                            SAP_Account_Number__c,Digital_MidContract_Status__c  from Opportunity 
                            where ID NOT IN (select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' AND  (Apttus_Proposal__Primary__c != true  OR Contract_Type__c =: INELIGIBLE) //DLT-16958
                            //DLT-12193 and  DLT-15672
                            AND ((Contract_Type__c !=:OLDMIDCONTRACT and Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c IN ('Denied'))
                            OR(Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c NOT IN ('Denied'))))  //DLT-12193 Ends 
                            AND StageName in ('Appointment Scheduled', 'Needs Analysis', 'Solution Recommended','Generate Contract','Negotiate Contract') 
                            AND ID IN (select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Straight Renewal') 
                            AND isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND  id IN : setOppIds];
            //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
            //optyList = [Select id,name,Ownerid,owner.name,owner.id,AccountId,Account.APTS_Band_Number__c,Account.APTS_eOutput_Eligibilty__c,Status__c,StageName,Renewal_Date__c,RecordTypeId,Campaign_Code__c from Opportunity where ID NOT IN (select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' AND  Apttus_Proposal__Primary__c != true) AND StageName in ('5%', '10%','75%','90%') AND isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND  Campaign_Code__c IN : campCodeNameSet AND AccountID IN : accIdSet];
    	}
        system.debug('Opp Selection Count: ' + optyList.size());
        system.debug('Opp List: ' + optyList);
        
        return optyList;
       
    } 
    
    public void execute(Database.BatchableContext bC, List<Opportunity> scope) {
       
        system.debug('Scope: ' + scope);
        
        List<Apttus_Config2__AssetLineItem__c> asstln = new List<Apttus_Config2__AssetLineItem__c>();
        try { 
            Digital_ProposalCreationCommoncode.ProposalCreation(scope, asstln, quoteName);
        }
        //DLT-14286
        catch (Exception ex) {
             Digital_Exception_Log__c ex1 = createExceptionLog( 'Proposal Creation Error for the Opportunity:' + scope, ex.getMessage(), 'Quote Creation - Opty Id - ' + scope[0].Id);
             if (Schema.sObjectType.Digital_Exception_Log__c .isCreateable()) { 
                 insert ex1;
             }
        }
    }

    //cart creation
    public static void createCartForProposal(list<Id> quoteProposalIdList){
         try{ 
            Digital_CartCreationCommoncode.ContractTerms(quoteProposalIdList, Quotename);
        }
        //DLT-14286
        catch(Exception ex){
             Digital_Exception_Log__c ex1 = createExceptionLog( 'Cart Creation Error for the proposal:' + quoteProposalIdList, ex.getMessage(), 'Cart Creation - proposalId - ' + quoteProposalIdList[0]);
             if(Schema.sObjectType.Digital_Exception_Log__c .isCreateable()){
                 insert ex1;
             }
        }
         
     }   
 
    //DLT-14286
    public static Digital_Exception_Log__c createExceptionLog(String exMessage, String additionalInfo, String userMessage) {
     Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;        
        ex.Additional_Information__c = additionalInfo;            
        ex.User_Message__c = userMessage;
        ex.Class_Reference__c = 'Digital_BestProposalAutomation';
        
        return ex;
    }
    
    public void finish(Database.BatchableContext info){ 
      
        //if(!Test.isRunningTest()){
            Digital_BestValueProposalCloneAutomation dppa1 = new Digital_BestValueProposalCloneAutomation();
            Database.executeBatch(dppa1,1);
        //}        
    }

}