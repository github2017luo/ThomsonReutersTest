/* Created By - Dinesh Kumar Voonna/RaviTeja
   Purpose - Digital Quote Automation for Best Value
   Jira Story - DLT-1702
   Batch Job - Runs once in a day 
   
   --------------------------------
   History 
   --------------------------------
   28/9/2017 - Updated the finalize cart logic in Digital_FinalizeCart class
   

   @modifiedBy : Bishnu Prasad
   Jira Story  : DLT-7642
   02/21/2018  : In Finish Method calling the DigitalBundleBatch to Perfom Bundling.
      
   Modified by Divija on Feb 21,2018
   DLT-7565 - When Quantity is not equal to Band Number, expire the proposal
   
   Modified by Brenda Shields 03/19/2018
   DLT-8414 - Do not Expire the Proposal if an Automation Error/Failure occurs
   
   Modified by Srikanth Kota 04/02/2018
   DLT-8188- Premium proposal should not be created if straight renewal and Plus is not created.
   
   Modified by Srikanth Kota 05/03/2018
   DLT-9400- No Renewal Date comparison when Plus/Premium is created.//Remove 185 days and only future date which is equal and greater than today.
   
   Modified by Brenda Shields on May 04 2018
   DLT-9536 - Add dymanic coding for Digital Firm updates and set the owners of the Opp/Proposal/cart accordingly.
   
   Modified by Srikanth Kota 05/08/2018
   DLT-8692- Generate up-sell offers for Corporate up-sell offers.// Use Custmer Segment Add dymanic YOY by DC_Contract_Term_V2__md
   
   Modified by Rajan on May 9 2018
   DLT-8973 - Added Hard Bounce & SAP Contact ID fields on Digital subscription object and SAP Contact ID should be used as Order Confirmation Contact and Ebill contact.

   Modified by Divija S on May 17, 2018
   DLT-9827 - Quote Automation to take into account of hard bounce email flag while selecting OCC and Optimized Proposal Creation method to OCClogic Class

   Modified by Harika Sai on Jun 7 2018
   DLT-9750 - Update Account / Contact object references in Renewal Automation classes

   Modified by DivijaS on July 9 2018
   DLT-10763 - Customer Specific YoY values access from Digital Subscriptions
   
   Modified by Divija S on 18th Sep 2018
   DLT-12358 - Optimized Queries and code to avoid heap size limit error
   
   Modified by Brenda Shields 09/24/2018 
   DLT-12190 - Fix code scan issues

   Modified By Divija S on 26th Sep 2018
   DLT 12139 - Create a re-usable components from Proposal Automation classes(Premium)
               Created a common method in a seperate class for all three proposal classes for cartcreation.   
               
   Modified By Harika Sai P on 9th Jan 2019
   DLT-14286 - Exception logs being incorrectly created

   Modified By Navleen Kaur on 14 Feb 2019
   DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
   
   Modified By Navleen Kaur on 20 Mar 2019
   DLT-15672 - [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
   
   Modified By ^Harikasai P  on 16 JUL 2019
   DLT-16851 - [Tech Story] [ALL] Quote Automation is failing when there are more than 10 asset line items on an Account 
   
   Modified by Navleen 2019-08-20
   DLT-17360 - [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been set 

*/  

public without sharing Class Digital_PremiumProposalAutomation implements Database.AllowsCallouts,Database.Stateful, Database.Batchable<opportunity> {

    
    public Static String priceListName = 'Thomson Reuters Master - US Legal';
    private static Final String OLDMIDCONTRACT='Old Mid Contract';
    
    //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
    public Static list<Product_Account_Detail__c> digitalSubscriptionsList = [SELECT AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,
                                                                             ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c,Renewal_Date__c FROM Product_Account_Detail__c 
                                                                             WHERE (Premium_New_Service__c != Null AND Premium_New_Subscription__c != Null) AND
                                                                             Campaign_Code__c != Null AND Type__c='Premium' AND Type__c !='Config' AND Renewal_Date__c >=Today AND Bypass_Automation__c = false];
    //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
    public Static list<Apttus_Proposal__Proposal__c> prop;
   
    public static string quoteName = 'Premium';
    Set<Id> opset = new Set<Id>();
    public Iterable<opportunity> start(database.batchablecontext bC){
        Set<String> campCodeNameSet = new Set<String>(); 
        list<Opportunity> optyList = new list<Opportunity>();
        list<Digital_Campaigns__c> dcList = Digital_Campaigns__c.getall().values();
        Set<Id> accIdSet = new Set<Id>();
     
        System.debug('digitalSubscriptionsList==>'+digitalSubscriptionsList);
        for(Product_Account_Detail__c camp : digitalSubscriptionsList ) {
            if(camp.Type__c == 'Premium' && camp.Type__c != 'Config') {
              campCodeNameSet.add(camp.Campaign_Code__c);  
            }
        
        }
        
        if(campCodeNameSet != NULL && campCodeNameSet.size() > 0) {
            for(Product_Account_Detail__c accountId : digitalSubscriptionsList) {                
                if(accountId.Type__c == 'Premium' && accountId.Type__c != 'Config') {
                accIdSet.add(accountId.AccountSSD__c);    
            
                }
            }
            if(accIdSet != Null && accIdSet.size() > 0) {
                //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Opportunity.isAccessible()){
                    optyList = [Select id,name,Ownerid,owner.name,owner.id,AccountId,Source_System_Detail__c,Source_System_Detail__r.LCRM_APTS_Band_Number__c,
                            Source_System_Detail__r.LCRM_eOutput_Eligibility__c,StageName,Renewal_Date__c,RecordTypeId,Campaign_Code__c, 
                            SAP_Account_Number__c,Digital_MidContract_Status__c FROM Opportunity where ID NOT IN (select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c 
                            WHERE Digital_Quote_Type__c = 'Premium' AND  Apttus_Proposal__Primary__c != true
                             //DLT-12193 && DLT-15672
                             AND  ((Contract_Type__c !=:OLDMIDCONTRACT and Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c IN ('Denied'))
                             OR(Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c NOT IN ('Denied'))))  //DLT-12193 Ends
                            AND StageName in ('Appointment Scheduled', 'Needs Analysis', 'Solution Recommended','Generate Contract','Negotiate Contract')
                            AND ID IN (select Apttus_Proposal__Opportunity__c FROM Apttus_Proposal__Proposal__c where Digital_Quote_Type__c IN ('Straight Renewal','Best Value') 
                                        AND Digital_Quote_Type__c NOT IN ('Best Value+Config')) 
                            AND isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND  Campaign_Code__c IN : campCodeNameSet AND Source_System_Detail__c IN : accIdSet];               
                //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
               }
            }                 
        }
        return optyList;
        
    } 
    
    public void execute(Database.BatchableContext bC, List<Opportunity> scope) {
      List<Opportunity> optyList;
        
        
        for (Opportunity opp : Scope) {
            optyList = new list<Opportunity>();
            optylist.add(opp);
        }
        List<Apttus_Config2__AssetLineItem__c> asstln = new List<Apttus_Config2__AssetLineItem__c>();
        
         try{ 
            Digital_ProposalCreationCommoncode.ProposalCreation(optylist, asstln, quoteName);
        }
        //DLT-14286 
        catch(Exception ex){
             Digital_Exception_Log__c ex1 = createExceptionLog( 'Proposal Creation Error for the Opportunity:'+ optylist,ex.getMessage(),'Quote Creation - Opty Id - '+optylist[0].Id,'Digital_BestProposalAutomation > ProposalCreation');
             if(Schema.sObjectType.Digital_Exception_Log__c .isCreateable()){
                 insert ex1;
             }
        }        
    }   

 
    public static void createCartForProposal(list<Id> quoteProposalIdList) {
        try{ 
            Digital_CartCreationCommoncode.ContractTerms(quoteProposalIdList, quoteName);
        }
        //DLT-14286 
        catch(Exception ex){
             Digital_Exception_Log__c ex1 = createExceptionLog( 'Cart Creation Error for the proposal:'+ quoteProposalIdList,ex.getMessage(),'Cart Creation - proposalId - '+quoteProposalIdList[0],'Digital_BestProposalAutomation > cartCreation');
             if(Schema.sObjectType.Digital_Exception_Log__c .isCreateable()){
                 insert ex1;
              }
        
        }
    }
    
    //Harika
    Public static Digital_Exception_Log__c createExceptionLog(String exMessage, String additionalInfo, String userMessage, String classRef) {
     Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;        
        ex.Additional_Information__c = additionalInfo;            
        ex.User_Message__c = userMessage;
        ex.Class_Reference__c = classRef ;
        
        return ex;
    }
    
  

    public void finish(Database.BatchableContext info) {        
        
       if(!Test.isRunningTest()){
           //DLT-16851 Starts
           DigitalBundleBatch dbc = new DigitalBundleBatch();
            Database.executeBatch(dbc,1);
           //DLT-16851 Ends
       }
    }

}