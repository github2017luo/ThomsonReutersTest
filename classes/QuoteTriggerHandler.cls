/**
 * This class will contain the helper methods for quote evenListeners.
 *
 * @author  Srikanth Kuruva
 * @version  2013-09-01
 */
 /**
 * CHANGE HISTORY 
 * =============================================================================
 * Date         Name                    Description
 * 2013-09-01   Srikanth Kuruva          Created
 * 2015-12-11    Pratik Prusty            Quote Syncronization automation
 * 2016-20-07    Rajashree                Added 'updateSynCQuoteList_Renewals'
 * 2016-07-20    Satyaki                  Added RenewalQuoteSync 
 * 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
  * 2017-Oct-06    Dibya/Vignesh            Added ValidateCreateToken
 * =============================================================================
 */
 public without sharing class QuoteTriggerHandler{
    // public static boolean isQuote = true;
     public static boolean callOnce=true;
     public static boolean checkRecursion = false;
     public static string strProfileName = ContactUtil.getProfileName();
      public static void updateSAPIDOCNumber(list<Quote> listQuotes){
    //     if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
         Id CurrentUserId = UserInfo.getUserId();
         //User CurrentUser = [Select Sales_Org__c from User where Id = :CurrentUserId];
         User CurrentUser = AppUtil.loggedInUserDetail;
         list<Opportunity> listUpdateOpportunities = new List<Opportunity>();
         for(Quote oQuote :[Select id, QuoteNumber, OpportunityId, SAP_IDOC_Number__c,Quote_Error_Counter__c, Opportunity.Account.SAPAccountNumber__c, Opportunity.Account.Sales_Org__c,Opportunity.Account.recordtype.name from Quote where Id in :listQuotes]){
/*system.debug('Limits.getFutureCalls():'+Limits.getFutureCalls());-- commented to reduce character for s2e optimization */
             if(oQuote.Opportunity.Account.recordtype.name == 'Customer'){
                 if(Limits.getFutureCalls()<Limits.getLimitFutureCalls()){// SF allows only 10 callouts per transaction
/*system.debug('Creations=== Limits.getFutureCalls ');-- commented to reduce character for s2e optimization */
                    //createQuote.createSAPQuote(oQuote.QuoteNumber,createQuote.determineSalesOrg(oQuote.Opportunity.Account.Sales_Org__c),oQuote.Opportunity.Account.SAPAccountNumber__c);
                    createQuote.createSAPQuote(oQuote.QuoteNumber,createQuote.determineSalesOrgNew(CurrentUser,oQuote.Opportunity.Account.Sales_Org__c),oQuote.Opportunity.Account.SAPAccountNumber__c);
                     checkrecursive.runQuoteTrigger();
                 }
                 else{
                     Opportunity oOpportunity = new Opportunity(Id = oQuote.OpportunityId);
                     oOpportunity.Require_Manual_Trigger_for_Quote__c = true;
                     listUpdateOpportunities.add(oOpportunity);
                 }
             }
         }
         if(!listUpdateOpportunities.isEmpty()){
             update listUpdateOpportunities;
         } //  }
     }

@future
    public static void updateSynCQuoteList(MAP<ID,ID> QuoteOpptymap, Boolean syncBoolean){
    callOnce= false;
/*System.debug('updateSynCQuote**'+QuoteOpptymap);-- commented to reduce character for s2e optimization */
        //SFD-458
        map<Id,List<opportunitylineitem>> getOpplineitemMap = new map<Id,List<opportunitylineitem>>();
        map<Id,List<QuoteLineItem>> getQlineitemMap = new map<Id,List<QuoteLineItem>>();        
        list <QuoteLineItem> insertQuoteLineItemList = new list <QuoteLineItem>();//SFD-458
        //Ends
        try{
            List<opportunity> optyListtobeupdated = new List<opportunity>();
            //SFD-458
                getOpplineitemMap = createQuote.getOppLineItem(QuoteOpptymap.Keyset());
                SET<Id> quoteIdSet= new SET<Id>();
                quoteIdSet.addAll(QuoteOpptymap.Values());
                getQlineitemMap = createQuote.getQuoteLineItem(quoteIdSet);
/*system.debug('*** OpplineitemMap::' + getOpplineitemMap);
system.debug('*** getQlineitemMap::' + getQlineitemMap);-- commented to reduce character limit for s2e optimization */
            //Ends
            List<Quote> QuoteListtobeupdated = new List<Quote>();
            list<opportunity> optyList = new list<opportunity>([select id, SyncedQuoteId,(select id,opportunityid,Primary_Quote__c,RecordTypeId from quotes) from opportunity where id IN:QuoteOpptymap.Keyset()]);
            for(opportunity oOpty:optyList){
/*system.debug('QuoteSize'+oOpty.quotes.size());-- commented to reduce character for s2e optimization */
                if(oOpty.quotes.size() ==1)
                {
                    quote oquote = oOpty.quotes[0];
                    oOpty.SyncedQuoteId = oQuote.id;
                    if(syncBoolean == true){
                        oOpty.Quote_Creation_Complete__c = true; // MCL-2126
                    }
                    oQuote.Primary_Quote__c = true;
                    optyListtobeupdated.add(oOpty);
                    QuoteListtobeupdated.add(oQuote);
                    //SFD-458
                    if(oquote.Id != null && getOpplineitemMap.containsKey(oOpty.id) && !getQlineitemMap.containsKey(oquote.Id)){
                        List<QuoteLineItem> qliLst= new List<QuoteLineItem>();
                        qliLst= createQuote.getQuoteLineItems(getOpplineitemMap.get(oOpty.id),oquote.Id);
                        insertQuoteLineItemList.addAll(qliLst);  
                    }
                    //Ends               
                }          
            }
            //SFD-458
/*system.debug('***insertQuoteLineItemList' + insertQuoteLineItemList.size());-- commented to reduce character for s2e optimization */ 
            if(insertQuoteLineItemList!= null && !insertQuoteLineItemList.isEmpty())
                insert insertQuoteLineItemList;
            //Ends
            if(!optyListtobeupdated.isEmpty())
/*system.debug('optyListtobeupdated**'+optyListtobeupdated);-- commented to reduce character for s2e optimization */
            {
                update optyListtobeupdated;
                update QuoteListtobeupdated;
            }
        }
        catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
        }
    }
/*
********************************************************************************************************************
        Purpose : Update SyncedQuoteId field on Opportunity when a primary quote is inserted into that opportunity
        Method Name : updateSynCQuoteList_Renewals
        Author : Rajashree
        Date : 2016-07-20  
********************************************************************************************************************
*/
 
// @future
    public static void updateSynCQuoteList_Renewals(MAP<ID,ID> QuoteOpptymap){
   // callOnce= false;
        try{
            List<opportunity> optyListtobeupdated = new List<opportunity>();
            List<Quote> QuoteListtobeupdated = new List<Quote>();
            list<opportunity> optyList = new list<opportunity>([select id, SyncedQuoteId,(select id,opportunityid,Primary_Quote__c,RecordTypeId ,Renewal_Flag_Formula__c from quotes WHERE Primary_Quote__c = TRUE) from opportunity where id IN:QuoteOpptymap.Keyset()]);
         //  list<opportunity> optyList =new list<opportunity>([select id, SyncedQuoteId from opportunity where id IN:QuoteOpptymap.Keyset()]);
            for(opportunity oOpty:optyList){
/*system.debug('QuoteSize'+oOpty.quotes.size());-- commented to reduce character for s2e optimization */
                if(oOpty.quotes.size() ==1)
                {
                    quote oquote = oOpty.quotes[0];
                    oOpty.SyncedQuoteId = QuoteOpptymap.get(oOpty.id);
                    optyListtobeupdated.add(oOpty);            
                }            
            }
            if(!optyListtobeupdated.isEmpty()){
/*system.debug('##### optyListtobeupdated**'+optyListtobeupdated);-- commented to reduce character for s2e optimization */
                database.update(optyListtobeupdated);
            }
        }
        catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
        }
    } 
    
    
 public static void updateOppStageForLatAm(set<string> QuoteIdSet){
         if(strProfileName == Label.Partner_Portal_Profile || strProfileName  == Label.Latam_Profile ){
             List<Opportunity> updateOPPLst=new List<Opportunity>();
             Boolean boolOppUpdate = false;
             try{ /*system.debug('****Point2');-- commented to reduce character for s2e optimization */
      //string strOrdCmpltd; /*All string variables declared and assigned together --- to reduce character for s2e optimization */
                 string strsubmtdProcsing = LatamGeneral__c.getInstance('Submitted for Processing').Value__c;
                 string strSaleAdminPendngRvw= LatamGeneral__c.getInstance('Sales Admin Pending Review').Value__c;
                 string strOPRejctd = LatamGeneral__c.getInstance('OP Rejected').Value__c;
                 //strOrdCmpltd = LatamGeneral__c.getInstance('Order Completed').Value__c;
/*system.debug('**in Quote Trigger');--commented to reduce character for s2e optimization */
                 for(Quote oQuote :[Select id,status,OpportunityId , Approval_Status__c from Quote where Id in :QuoteIdSet]){
                     Opportunity opp=new Opportunity(Id = oQuote.OpportunityId);
/*system.debug('***Quotestatus::' +oQuote.status); --commented to reduce character for s2e optimization */
                     if(oQuote.status ==  strsubmtdProcsing && oQuote.Approval_Status__c != 'Cancellation Approved'){
/*system.debug('***SP');--commented to reduce character for s2e optimization */
                         opp.stageName = LatamGeneral__c.getInstance('Opp Stage 95').Value__c;
                         boolOppUpdate = true;
                     }
                     else if(oQuote.status ==  strSaleAdminPendngRvw){
/*system.debug('***pr');--commented to reduce character for s2e optimization */
                         opp.stageName = LatamGeneral__c.getInstance('Opp Stage 90').Value__c;
                         boolOppUpdate = true;
                     }
                     else if(oQuote.status ==  strOPRejctd){
/*system.debug('***OR');--commented to reduce character for s2e optimization */
                         opp.stageName = LatamGeneral__c.getInstance('Opp Stage 90').Value__c;
                         boolOppUpdate = true;
                     }
                     else if(oQuote.status ==  'Prevalidate for Final Approval' && opp.stageName != LatamGeneral__c.getInstance('Opp Stage 90').Value__c){
/*system.debug('***PFA');-- commented to reduce character for s2e optimization */
                         opp.stageName = LatamGeneral__c.getInstance('Opp Stage 90').Value__c;
                         boolOppUpdate = true;
                     }
                     /*else if(oQuote.status == strOrdCmpltd){
                         system.debug('***OpC');
                         opp.stageName = LatamGeneral__c.getInstance('Opp Stage 100').Value__c;
                     }*/
                     if(boolOppUpdate == true){
                     updateOPPLst.add(opp);
                     }
                 }
                 if(updateOPPLst != null && updateOPPLst.size() >0 && boolOppUpdate == true){
/*system.debug('**updateOPPLst'+updateOPPLst);--commented to reduce character for s2e optimization */
                     Update updateOPPLst;
                 }
             }
             catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());--commented to reduce character for s2e optimization */
             }
         }
     }

     /* Method Name: MapOpportunityfieldsonQuote
        Created Date: 18 Dec 2015
        Purpose: Map fields in Quote records from related Opportunity whenever quote
                 is created and required criterias are true
     */
     public static void MapOpportunityfieldsonQuote(List<Quote> QuoteList){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
             List<Id> QuoteIdList = new List<id>();
             List<Quote> UpdateQuoteList = new List<Quote>();
             List<id> opportunityIdList = new List<id>();
             id EBillContact, BoletoContact; /*Declared together---to reduce character in s2e optimization*/
             //Id GiroEmpCon;
             try{
                 for(Quote Qu: QuoteList){
                     QuoteIdList.add(Qu.id);
                     opportunityIdList.add(Qu.OpportunityId); 
                 }
                //12/23/2016 :Included Opportunity_Sales_Org__c and Opportunity.Sales_Org__c  Mrinmoy included in query for MCL-1560
                 List<Quote> QuoteInfoList = [Select id,Name,QuoteNumber,E_Billing_Contact__c,Primary_Quote__c,Opportunity_Notes__c,Opportunity_Sales_Org__c,Opportunity.Name,Opportunity.Description,Opportunity.Sales_Org__c,Opportunity.All_Quote_Count__c,Opportunity.LatAm_Standardization_Quotes__c,Opportunity.AccountId from Quote where Id IN: QuoteIdList];
                 List<OpportunityContactRole> OppContactRoleList = [Select id,role,Opportunityid,ContactId from OpportunityContactRole where Opportunityid IN: opportunityIdList AND (Role =: 'E-Billing Contact'  OR Role =: 'Boleto Contact') ORDER BY lastmodifieddate DESC];
/*system.debug('EBillContact1 ::'+EBillContact );---- commented to reduce character for s2e optimization*/
                 for(OpportunityContactRole ConRole: OppContactRoleList ){
                     if(ConRole.Role == 'E-Billing Contact' && EBillContact == null)
                         EBillContact = ConRole.ContactId;
                    // if(ConRole.Role == 'Giro Empresarial' && GiroEmpCon == null)
                        // GiroEmpCon = ConRole.ContactId;
                     if(ConRole.Role == 'Boleto Contact' && BoletoContact == null)
                         BoletoContact = ConRole.ContactId;
/*system.debug('EBillContact ::'+EBillContact );
                     system.debug('BoletoContact ::'+BoletoContact);-- commented to reduce character for s2e optimization*/
                 }
    
                 for(Quote NewQu : QuoteInfoList){
/*system.debug('Account frmo Quote::'+NewQu.Opportunity.AccountId);--commented to reduce character for s2e optimization */
                     NewQu.Account_LookUp__c = NewQu.Opportunity.AccountId;
                     if(NewQu.Opportunity.LatAm_Standardization_Quotes__c >0 || NewQu.Opportunity.All_Quote_Count__c == 0){
                         NewQu.Name = NewQu.Opportunity.Name + '_' + NewQu.QuoteNumber;
                         NewQu.Opportunity_Notes__c = NewQu.Opportunity.Description;
                         NewQu.Opportunity_Sales_Org__c = NewQu.Opportunity.Sales_Org__c;//12/23/2016 : Mrinmoy Added for MCL-1560
 /*system.debug('EBillContact ::'+EBillContact );--commented to reduce character for s2e optimization */
                         if(NewQu.Opportunity.All_Quote_Count__c == 0){
                             NewQu.Primary_Quote__c = True;
                             if(EBillContact != null) NewQu.E_Billing_Contact__c = EBillContact;
                             //if(GiroEmpCon != null) NewQu.Giro_Empresarial__c= GiroEmpCon;
                             if(BoletoContact != null) NewQu.Boleto_Contact__c= BoletoContact;
                         }
                     }
                  UpdateQuoteList.add(NewQu);
                 }
                 If(UpdateQuoteList.size()>0)
                     Update UpdateQuoteList;
             }catch(Exception e){
 /*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());--commented to reduce character for s2e optimization */
             }
       //  }
     }
     /* Method Name: SyncQLIOnQuoteCreateForOpp75
        Created Date: 22 JAN 2016
        Purpose: On Quote create under Oppty when stage is 75%, Need to copy Opp products to Quote Line Items
        as Oppty products are deleted by standard salesforce behaviour,

     public static void SyncQLIOnQuotetoOLICreateForOpp75(List<Quote> newQuoteLst){

         Map<Id,Id> quoteOpptyMap= new Map<id,Id>();
         for(Quote q:newQuoteLst){
             quoteOpptyMap.put(q.id,q.OpportunityId);
         }

         Map<Id, Opportunity> mapOpportunityWithProducts = new Map<Id, Opportunity>([SELECT Id,All_Quote_Count__c, (SELECT Incremental_Amount__c, Quantity, UnitPrice FROM OpportunityLineItems LIMIT 1) FROM Opportunity WHERE Id IN :quoteOpptyMap.Values() AND All_Quote_Count__c = 0 AND StageName='75%']);


     } */

    // 03.22.2016 - JIRA 440
    // When a Quote switches to Primary Quote the Opportunity Notes need to be in Sync
    public static void UpdateQuoteFieldsFromOppotunity(Map<Id, Quote> mapOld, Map<Id, Quote> mapNew){
     //   if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            Set<Id> setOpportunityIds = new Set<Id>();
            List<Quote> listQuotesRefined = new List<Quote>();
            List<Quote> listQuoteForUpdate = new List<Quote>();
            try {
                for(Quote q : mapNew.Values()){
                    //Was there a CHANGE to the field we care about???
                    if (q.Primary_Quote__c != mapOld.Get(q.Id).Primary_Quote__c) {
                        if (q.Primary_Quote__c == true) {
                            listQuotesRefined.add(q);
                            setOpportunityIds.add(q.OpportunityId);
                        }
                    }
                }
                if (listQuotesRefined.size() == 0) return;
                Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>([Select id, Description
                         From Opportunity where Id IN :setOpportunityIds]);
                for (Quote q : listQuotesRefined){
                    q.Opportunity_Notes__c = mapOpportunity.get(q.OpportunityId).Description;
                }
            } Catch (Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());--commented to reduce character for s2e optimization */
            } //  }
    }
    
    /******************************************************************************************
    Method Name: MasterQuoteChildQuoteSync 
    Created By: TCS 
    Purpose: Sync Child Quote with Master Quote's Values 
                [BRS_MS7.1.18] [BRS_MS7.1.26] [BRS_MS7.1.14] [BRS_MS7.1.17] 
    Defects:
    *******************************************************************************************/
    public static void MasterQuoteChildQuoteSync ( Map<Id, Quote> mapQuote, Map<Id, Quote> mapOldQuote){
    //    if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
        Set<Id> setQuoteId = new Set<Id>();             
                Set<Id> setOppId = new Set<Id>();
                for(Quote quo : mapQuote.values()){               
                    if(quo.Primary_Quote__c == true && quo.Is_Master_Quote__c == true && ( 
                        mapOldQuote.get(quo.id).Approval_Status__c != mapQuote.get(quo.id).Approval_Status__c || 
                        mapOldQuote.get(quo.id).Status != mapQuote.get(quo.id).Status || 
                        mapOldQuote.get(quo.id).Name != mapQuote.get(quo.id).Name || 
                        mapOldQuote.get(quo.id).OP_Rejection_Count__c != mapQuote.get(quo.id).OP_Rejection_Count__c || 
                        mapOldQuote.get(quo.id).OP_Rejection_Date__c != mapQuote.get(quo.id).OP_Rejection_Date__c || 
                        mapOldQuote.get(quo.id).Primary_Quote__c != mapQuote.get(quo.id).Primary_Quote__c || 
                        mapOldQuote.get(quo.id).OP_Owner__c != mapQuote.get(quo.id).OP_Owner__c || 
                        mapOldQuote.get(quo.id).Order_Source__c != mapQuote.get(quo.id).Order_Source__c || 
                        mapOldQuote.get(quo.id).Purchase_Order_Date__c != mapQuote.get(quo.id).Purchase_Order_Date__c || 
                        mapOldQuote.get(quo.id).Revenue_Channel__c != mapQuote.get(quo.id).Revenue_Channel__c || 
                        mapOldQuote.get(quo.id).Payer_Customer_Name__c != mapQuote.get(quo.id).Payer_Customer_Name__c || 
                        mapOldQuote.get(quo.id).Bill_To_Customer_Name__c != mapQuote.get(quo.id).Bill_To_Customer_Name__c || 
                        mapOldQuote.get(quo.id).Ship_To_Customer_Name__c != mapQuote.get(quo.id).Ship_To_Customer_Name__c || 
                        mapOldQuote.get(quo.id).Gross_Income_Tax_Number__c != mapQuote.get(quo.id).Gross_Income_Tax_Number__c || 
                        mapOldQuote.get(quo.id).Payment_Terms__c != mapQuote.get(quo.id).Payment_Terms__c || 
                        mapOldQuote.get(quo.id).Payment_Method__c != mapQuote.get(quo.id).Payment_Method__c || 
                        mapOldQuote.get(quo.id).Bank_Account_Num__c != mapQuote.get(quo.id).Bank_Account_Num__c || 
                        mapOldQuote.get(quo.id).Bank__c != mapQuote.get(quo.id).Bank__c ||  
                        mapOldQuote.get(quo.id).Shipping_Notes__c != mapQuote.get(quo.id).Shipping_Notes__c || 
                        mapOldQuote.get(quo.id).Revenue_Type__c != mapQuote.get(quo.id).Revenue_Type__c || 
                        mapOldQuote.get(quo.id).Bill_To_Contact__c != mapQuote.get(quo.id).Bill_To_Contact__c ||
                        mapOldQuote.get(quo.id).Renewal_Options__c != mapQuote.get(quo.id).Renewal_Options__c||
                        mapOldQuote.get(quo.id).Billing_Type__c != mapQuote.get(quo.id).Billing_Type__c||
                        mapOldQuote.get(quo.id).LATAM_Renewal_Division__c != mapQuote.get(quo.id).LATAM_Renewal_Division__c  ||
                        
                        mapOldQuote.get(quo.id).Sold_To_Contact__c != mapQuote.get(quo.id).Sold_To_Contact__c ||
                        mapOldQuote.get(quo.id).Additional_E_Billing_contact_emails__c != mapQuote.get(quo.id).Additional_E_Billing_contact_emails__c ||
                        mapOldQuote.get(quo.id).TID_Number__c != mapQuote.get(quo.id).TID_Number__c ||
                        mapOldQuote.get(quo.id).Reason__c != mapQuote.get(quo.id).Reason__c ||
                        mapOldQuote.get(quo.id).Was_There_A_Competitor__c != mapQuote.get(quo.id).Was_There_A_Competitor__c ||
                        mapOldQuote.get(quo.id).Competitor_Name__c != mapQuote.get(quo.id).Competitor_Name__c
                        )){
                        setQuoteId.add(quo.id);                
                    }
                }                
/*system.debug('>>>>>>>>setQuoteId'+setQuoteId);-- commented to reduce character for s2e optimization*/
                if(setQuoteId != null && !setQuoteId.isEmpty()){ 
                    List<Quote> lstChildQuote = [SELECT Id, Approval_Status__c, Master_Quote__c, Status, Quote_Number__c, Primary_Quote__c, 
                        Quote_Name__c, Pricing_Approval_Required__c, OP_Owner__c, Submitting_Rep__c, 
                         Order_Source__c, Division__c, Purchase_Order__c, Purchase_Order_Date__c,Renewal_Flag_Formula__c,
                         LatAm_Department__c, Revenue_Channel__c, Sold_To_SAP_Account_ID__c, Sold_To_Tax_ID__c, 
                         Payer_Customer_Name__c, Payer_SAP_Account_ID__c, Bill_To_Customer_Name__c, 
                         Bill_To_SAP_Account_ID__c, Ship_To_Customer_Name__c, Ship_To_SAP_Account_ID__c, 
                         Legacy_Number__c, Gross_Income_Tax_Number__c, Payment_Terms__c, Payment_Method__c, 
                         Card_Type__c, Credit_Card_Token__c, CC_Expiration_Date__c, CC_Authorization_Num__c, 
                         Bank_Account_Num__c, Bank__c, Invoice_Notes__c, Shipping_Notes__c, TotalPrice,LATAM_Renewal_Division__c, 
                         Distributor_ZD__c, Revenue_Type__c, Renewal_Options__c, Grace_Period_Indicator__c, 
                         Discount_Threshold__c, SAP_Order_Number__c, Order_Processed_by__c,Bill_To_Contact__c,Billing_Type__c,
                         Sold_To_Contact__c, Additional_E_Billing_contact_emails__c, TID_Number__c, Reason__c, Was_There_A_Competitor__c, Competitor_Name__c 
                         FROM Quote WHERE Master_Quote__c != NULL AND Master_Quote__c IN: setQuoteId 
                          AND Opportunity.Master_Opportunity__r.Oppty_Mgmt_Type__c =: 'Split Billing'];
                    List<Quote> lstUpdateQuote = new List<Quote>();
                    boolean boolChckChldQuoUpdate = false;
                    for(Quote quo : lstChildQuote){
                         if(mapOldQuote.get(quo.Master_Quote__c).Approval_Status__c != mapQuote.get(quo.Master_Quote__c).Approval_Status__c){
                           quo.Approval_Status__c = mapQuote.get(quo.Master_Quote__c).Approval_Status__c;
                           boolChckChldQuoUpdate = true;
                         }
                         if(mapOldQuote.get(quo.Master_Quote__c).Bill_To_Contact__c != mapQuote.get(quo.Master_Quote__c).Bill_To_Contact__c){
                           quo.Bill_To_Contact__c = mapQuote.get(quo.Master_Quote__c).Bill_To_Contact__c;
                           boolChckChldQuoUpdate = true;
                         }
                         if(mapOldQuote.get(quo.Master_Quote__c).Billing_Type__c != mapQuote.get(quo.Master_Quote__c).Billing_Type__c){
                           quo.Billing_Type__c = mapQuote.get(quo.Master_Quote__c).Billing_Type__c;
                           boolChckChldQuoUpdate = true;
                         }                     
                         if(mapOldQuote.get(quo.Master_Quote__c).Status !=  mapQuote.get(quo.Master_Quote__c).Status){
                           quo.Status = mapQuote.get(quo.Master_Quote__c).Status;
                           boolChckChldQuoUpdate = true;
                         }                      
                         if(mapOldQuote.get(quo.Master_Quote__c).Name !=  mapQuote.get(quo.Master_Quote__c).Name){
                           quo.Name = mapQuote.get(quo.Master_Quote__c).Name;
                           boolChckChldQuoUpdate = true;
                         }
                         if(mapQuote.get(quo.Master_Quote__c).OP_Rejection_Count__c != mapOldQuote.get(quo.Master_Quote__c).OP_Rejection_Count__c 
                            || mapQuote.get(quo.Master_Quote__c).OP_Rejection_Date__c != mapOldQuote.get(quo.Master_Quote__c).OP_Rejection_Date__c){
                             if(mapQuote.get(quo.Master_Quote__c).Status == 'OP Rejected') {
                                quo.OP_Rejection_Count__c = mapQuote.get(quo.Master_Quote__c).OP_Rejection_Count__c;
                                quo.OP_Rejection_Date__c = mapQuote.get(quo.Master_Quote__c).OP_Rejection_Date__c;
                                boolChckChldQuoUpdate = true;
                             }
                         } 
                         if(mapOldQuote.get(quo.Master_Quote__c).Primary_Quote__c != mapQuote.get(quo.Master_Quote__c).Primary_Quote__c){
                            quo.Primary_Quote__c = mapQuote.get(quo.Master_Quote__c).Primary_Quote__c;
                            boolChckChldQuoUpdate = true;
                         }
                         if(mapOldQuote.get(quo.Master_Quote__c).OP_Owner__c != mapQuote.get(quo.Master_Quote__c).OP_Owner__c){
                          quo.OP_Owner__c = mapQuote.get(quo.Master_Quote__c).OP_Owner__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Order_Source__c != mapQuote.get(quo.Master_Quote__c).Order_Source__c){
                          quo.Order_Source__c = mapQuote.get(quo.Master_Quote__c).Order_Source__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Purchase_Order_Date__c != mapQuote.get(quo.Master_Quote__c).Purchase_Order_Date__c){
                          quo.Purchase_Order_Date__c = mapQuote.get(quo.Master_Quote__c).Purchase_Order_Date__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Revenue_Channel__c != mapQuote.get(quo.Master_Quote__c).Revenue_Channel__c){
                          quo.Revenue_Channel__c = mapQuote.get(quo.Master_Quote__c).Revenue_Channel__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Payer_Customer_Name__c != mapQuote.get(quo.Master_Quote__c).Payer_Customer_Name__c){
                        quo.Payer_Customer_Name__c = mapQuote.get(quo.Master_Quote__c).Payer_Customer_Name__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Bill_To_Customer_Name__c != mapQuote.get(quo.Master_Quote__c).Bill_To_Customer_Name__c){
                          quo.Bill_To_Customer_Name__c = mapQuote.get(quo.Master_Quote__c).Bill_To_Customer_Name__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Ship_To_Customer_Name__c != mapQuote.get(quo.Master_Quote__c).Ship_To_Customer_Name__c){
                        quo.Ship_To_Customer_Name__c = mapQuote.get(quo.Master_Quote__c).Ship_To_Customer_Name__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Gross_Income_Tax_Number__c != mapQuote.get(quo.Master_Quote__c).Gross_Income_Tax_Number__c){
                        quo.Gross_Income_Tax_Number__c = mapQuote.get(quo.Master_Quote__c).Gross_Income_Tax_Number__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Payment_Terms__c != mapQuote.get(quo.Master_Quote__c).Payment_Terms__c){
                          quo.Payment_Terms__c = mapQuote.get(quo.Master_Quote__c).Payment_Terms__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Payment_Method__c != mapQuote.get(quo.Master_Quote__c).Payment_Method__c){
                          quo.Payment_Method__c = mapQuote.get(quo.Master_Quote__c).Payment_Method__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Bank_Account_Num__c != mapQuote.get(quo.Master_Quote__c).Bank_Account_Num__c){
                          quo.Bank_Account_Num__c = mapQuote.get(quo.Master_Quote__c).Bank_Account_Num__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Bank__c != mapQuote.get(quo.Master_Quote__c).Bank__c){
                        quo.Bank__c = mapQuote.get(quo.Master_Quote__c).Bank__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Shipping_Notes__c != mapQuote.get(quo.Master_Quote__c).Shipping_Notes__c){
                          quo.Shipping_Notes__c = mapQuote.get(quo.Master_Quote__c).Shipping_Notes__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Revenue_Type__c != mapQuote.get(quo.Master_Quote__c).Revenue_Type__c){
                          quo.Revenue_Type__c = mapQuote.get(quo.Master_Quote__c).Revenue_Type__c;
                          boolChckChldQuoUpdate = true;
                        }
                        
                        //Start - DPS-16068
                        if(mapOldQuote.get(quo.Master_Quote__c).Sold_To_Contact__c != mapQuote.get(quo.Master_Quote__c).Sold_To_Contact__c){
                          quo.Sold_To_Contact__c = mapQuote.get(quo.Master_Quote__c).Sold_To_Contact__c;
                          boolChckChldQuoUpdate = true;
                        }
                        
                        if(mapOldQuote.get(quo.Master_Quote__c).Additional_E_Billing_contact_emails__c != mapQuote.get(quo.Master_Quote__c).Additional_E_Billing_contact_emails__c){
                          quo.Additional_E_Billing_contact_emails__c = mapQuote.get(quo.Master_Quote__c).Additional_E_Billing_contact_emails__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).TID_Number__c != mapQuote.get(quo.Master_Quote__c).TID_Number__c){
                          quo.TID_Number__c = mapQuote.get(quo.Master_Quote__c).TID_Number__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Reason__c != mapQuote.get(quo.Master_Quote__c).Reason__c){
                          quo.Reason__c = mapQuote.get(quo.Master_Quote__c).Reason__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Was_There_A_Competitor__c != mapQuote.get(quo.Master_Quote__c).Was_There_A_Competitor__c){
                          quo.Was_There_A_Competitor__c = mapQuote.get(quo.Master_Quote__c).Was_There_A_Competitor__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(mapOldQuote.get(quo.Master_Quote__c).Competitor_Name__c != mapQuote.get(quo.Master_Quote__c).Competitor_Name__c){
                          quo.Competitor_Name__c = mapQuote.get(quo.Master_Quote__c).Competitor_Name__c;
                          boolChckChldQuoUpdate = true;
                        }
                        //End - DPS-16068
                        
                        if(mapOldQuote.get(quo.Master_Quote__c).Renewal_Options__c != mapQuote.get(quo.Master_Quote__c).Renewal_Options__c){
                          quo.Renewal_Options__c = mapQuote.get(quo.Master_Quote__c).Renewal_Options__c;
                          boolChckChldQuoUpdate = true;
                        }
                        if(quo.Renewal_Flag_Formula__c == TRUE && (mapOldQuote.get(quo.Master_Quote__c).LATAM_Renewal_Division__c  != mapQuote.get(quo.Master_Quote__c).LATAM_Renewal_Division__c )){
                          quo.LATAM_Renewal_Division__c = mapQuote.get(quo.Master_Quote__c).LATAM_Renewal_Division__c;  
                          boolChckChldQuoUpdate = true;                     
                        }
/*system.debug('****boolChckChldQuoUpdate:: ' +boolChckChldQuoUpdate );-- commented to reduce character for s2e optimization*/    
                        if(boolChckChldQuoUpdate  == true){            
                            lstUpdateQuote.add(quo);
                        }
                    }
                    if(lstUpdateQuote != null && !lstUpdateQuote.isEmpty()){
                        DATABASE.UPDATE(lstUpdateQuote);                   
                    }
                }  //  }
    } 
 
 /*public static void validateChangesOnChildQuote (map<Id, Quote> mapQuoteNew){
        checkRecursive.isOpptyUpdate = false;
        Map<Id,Id> mapMasterQuo = new Map<Id,Id>();
        User u = [Select Id, Profile.Name, UserRole.DeveloperName
                        From User
                        Where Id = :userinfo.getUserId()];
       // if(checkRecursive.isQuote == true) {
            for(Quote quo : mapQuoteNew.values()){
                mapMasterQuo.put(quo.Id, quo.Master_Quote__c); 
                }
            List<Quote> lstMasterQuote = [SELECT Id, Approval_Status__c, Master_Quote__c, Status, Quote_Number__c, Primary_Quote__c, 
                                                        Quote_Name__c, Pricing_Approval_Required__c, OP_Owner__c, Submitting_Rep__c, 
                                                        Order_Source__c, Division__c, Purchase_Order__c, Purchase_Order_Date__c, 
                                                        LatAm_Department__c, Revenue_Channel__c, Sold_To_SAP_Account_ID__c, Sold_To_Tax_ID__c, 
                                                        Payer_Customer_Name__c, Payer_SAP_Account_ID__c, Bill_To_Customer_Name__c, 
                                                        Bill_To_SAP_Account_ID__c, Ship_To_Customer_Name__c, Ship_To_SAP_Account_ID__c, 
                                                        Legacy_Number__c, Gross_Income_Tax_Number__c, Payment_Terms__c, Payment_Method__c, 
                                                        Card_Type__c, Credit_Card_Token__c, CC_Expiration_Date__c, CC_Authorization_Num__c, 
                                                        Bank_Account_Num__c, Bank__c, Invoice_Notes__c, Shipping_Notes__c, TotalPrice, 
                                                        Distributor_ZD__c, Revenue_Type__c, Renewal_Options__c, Grace_Period_Indicator__c, 
                                                        Discount_Threshold__c, SAP_Order_Number__c, Order_Processed_by__c 
                                                 FROM Quote
                                                 WHERE Is_Master_Quote__c = true AND Id IN: mapMasterQuo.values()]; 
        
                for(Quote quo : mapQuoteNew.values()){
                    for(Quote masQuo : lstMasterQuote){
                        if(quo.Is_Child_Quote_MSaf__c == true && quo.Is_Master_Quote__c == false && (u.Profile.Name == 'LatAm User' ||  u.Profile.Name == 'Partner Portal User') && u.UserRole.DeveloperName != 'LatAm_Order_Fulfillment') {
                            if(quo.Approval_Status__c != masQuo.Approval_Status__c || 
                                quo.Status != masQuo.Status ||
                                quo.Primary_Quote__c != masQuo.Primary_Quote__c ||
                                quo.OP_Owner__c != masQuo.OP_Owner__c ||
                                quo.Order_Source__c != masQuo.Order_Source__c ||
                                quo.Purchase_Order__c != masQuo.Purchase_Order__c ||
                                quo.Revenue_Channel__c != masQuo.Revenue_Channel__c ||
                                quo.Payer_Customer_Name__c != masQuo.Payer_Customer_Name__c ||
                                quo.Bill_To_Customer_Name__c != masQuo.Bill_To_Customer_Name__c ||
                                quo.Ship_To_Customer_Name__c != masQuo.Ship_To_Customer_Name__c ||
                                quo.Payment_Terms__c != masQuo.Payment_Terms__c ||
                                quo.Payment_Method__c != masQuo.Payment_Method__c ||
                                quo.CC_Authorization_Num__c != masQuo.CC_Authorization_Num__c ||
                                quo.Bank_Account_Num__c != masQuo.Bank_Account_Num__c ||
                                quo.Bank__c != masQuo.Bank__c ||
                                quo.Invoice_Notes__c != masQuo.Invoice_Notes__c ||
                                quo.Shipping_Notes__c != masQuo.Shipping_Notes__c ||
                                quo.Revenue_Type__c != masQuo.Revenue_Type__c ||
                                quo.Renewal_Options__c != masQuo.Renewal_Options__c ||
                                quo.Grace_Period_Indicator__c != masQuo.Grace_Period_Indicator__c){
                                    quo.addError(System.label.LatAm_Mastersaf_Lock_Child_Quote);
                            }
                        }   
                    }   
                }
          //  }   
       checkRecursive.isOpptyUpdate = true;
       
    }*/
    
   /******************************************************************************************
    Method Name: RenewalQuoteSync 
    Created By: Satyaki 
    Purpose: Sync Quote to Opportunity and Quote to QLI for Renewals 
    Defects:
    *******************************************************************************************/ 
    
  public static void RenewalQuoteSync ( Map<Id, Quote> mapNewQuote, Map<Id, Quote> mapOldQuote){
        if(userinfo.getProfileid() == Profile_List__c.getInstance('LatAm User').ProfileId__c ||
       userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c||
       userinfo.getProfileid() == Profile_List__c.getInstance('System Administrator').ProfileId__c){
            checkRecursive.isRenewalOpp = false;
            checkRecursive.isRenewalOLI = false;
            checkRecursive.isRenewalQLI = false;
            Boolean boolChck = false;
            Boolean boolChk = false;
            if(checkRecursive.isRenewalQuote == true){
/*system.debug('Step1:inside Renewal Quote');-- commented to reduce character for s2e optimization*/
                Set<Id> setQuoteId = new Set<Id>();
                Set<Id> setOppId = new Set<Id>();
                Map<Id,Id> mapOppQuote = new Map<Id,Id>();
                for(Quote quo : mapNewQuote.values()){
                    if(quo.Primary_Quote__c == true && quo.Renewal_Flag_Formula__c == true && quo.RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c
                        && quo.Master_Quote__c == NULL) {
                        if(mapNewQuote.get(quo.id).Competitor_Name__c != mapOldQuote.get(quo.id).Competitor_Name__c || 
                        mapNewQuote.get(quo.id).Opportunity_Notes__c != mapOldQuote.get(quo.id).Opportunity_Notes__c || 
                     //   mapNewQuote.get(quo.id).Payment_Terms__c != mapOldQuote.get(quo.id).Payment_Terms__c || 
                     //   mapNewQuote.get(quo.id).Payment_Method__c != mapOldQuote.get(quo.id).Payment_Method__c || 
                      //  mapNewQuote.get(quo.id).Projected_Renewal_Price__c != mapOldQuote.get(quo.id).Projected_Renewal_Price__c || 
                     // mapNewQuote.get(quo.id).Approval_Status__c != mapOldQuote.get(quo.id).Approval_Status__c || 
                        mapNewQuote.get(quo.id).Reason__c != mapOldQuote.get(quo.id).Reason__c || 
                        mapNewQuote.get(quo.id).Was_There_A_Competitor__c != mapOldQuote.get(quo.id).Was_There_A_Competitor__c || 
                        mapNewQuote.get(quo.id).Win_Loss__c != mapOldQuote.get(quo.id).Win_Loss__c||
                        mapNewQuote.get(quo.id).Account_Contact_Change_Indicator__c!= mapOldQuote.get(quo.id).Account_Contact_Change_Indicator__c) {  
                            setOppId.add(quo.OpportunityId);
                            mapOppQuote.put(quo.OpportunityId,quo.id);
                        }
                       /* if(mapNewQuote.get(quo.id).Projected_Renewal_Price__c != mapOldQuote.get(quo.id).Projected_Renewal_Price__c) {
                            setQuoteId.add(quo.id);
                        } */
                    }
                }
/*system.debug('Step2:setQuoteId='+setQuoteId);-- commented to reduce character for s2e optimization*/
                if(setOppId != NULL && !setOppId.isEmpty()){
                    List<Opportunity> lstOppty = [SELECT Id, Renewal_Flag__c, Competitor_Name__c, Description, Payment_Condition__c, Payment_Method__c, 
                         Reason__c, Was_There_A_Competitor__c, Win_Loss__c, Approval_Status__c , Account_Contact_Change_Indicator__c
                         FROM Opportunity WHERE Id IN: setOppId AND Renewal_Flag__c =: true AND RecordTypeId =: RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c
                         AND Master_Opportunity__c = NULL];
                    List<Opportunity> lstUpdtOpp = new List<Opportunity>();
                    if(lstOppty != NULL && !lstOppty.isEmpty()){
                        for(Opportunity opp : lstOppty) {
                            if(mapOldQuote.get(mapOppQuote.get(opp.id)).Competitor_Name__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Competitor_Name__c) {
                                opp.Competitor_Name__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Competitor_Name__c;
                                 boolChck = true;
                            }
                            if(mapOldQuote.get(mapOppQuote.get(opp.id)).Opportunity_Notes__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Opportunity_Notes__c) {
                                opp.Description = mapNewQuote.get(mapOppQuote.get(opp.id)).Opportunity_Notes__c;
                                boolChck = true;
                            }
                             if(mapOldQuote.get(mapOppQuote.get(opp.id)).Account_Contact_Change_Indicator__c!= mapNewQuote.get(mapOppQuote.get(opp.id)).Account_Contact_Change_Indicator__c) {
                                opp.Account_Contact_Change_Indicator__c= mapNewQuote.get(mapOppQuote.get(opp.id)).Account_Contact_Change_Indicator__c;
                                boolChck = true;
                            }// SFD-790
                          /* Indu has asked to comment it as a validation is getting fired if we dont include Bank and CBU in sync
                           if(mapOldQuote.get(mapOppQuote.get(opp.id)).Payment_Terms__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Payment_Terms__c) {
                                opp.Payment_Condition__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Payment_Terms__c;
                                boolChck = true;
                            }
                            if(mapOldQuote.get(mapOppQuote.get(opp.id)).Payment_Method__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Payment_Method__c) {
                                opp.Payment_Method__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Payment_Method__c;
                                boolChck = true;
                            } */
                            /*if(mapOldQuote.get(mapOppQuote.get(opp.id)).Projected_Renewal_Price__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Projected_Renewal_Price__c) {
                                opp.Projected_Renewal_Price__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Projected_Renewal_Price__c;
                                boolChck = true;
                            }*/
                            if(mapOldQuote.get(mapOppQuote.get(opp.id)).Reason__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Reason__c) {
                                opp.Reason__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Reason__c;
                                boolChck = true;
                            }
                            if(mapOldQuote.get(mapOppQuote.get(opp.id)).Was_There_A_Competitor__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Was_There_A_Competitor__c) {
                                opp.Was_There_A_Competitor__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Was_There_A_Competitor__c;
                                boolChck = true;
                            }
                           
                            if(mapOldQuote.get(mapOppQuote.get(opp.id)).Win_Loss__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Win_Loss__c) {
                                opp.Win_Loss__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Win_Loss__c; 
                                boolChck = true;
                            }
                          /*  System.debug('mapOldQuote - Approval_Status__c'+ mapOldQuote.get(mapOppQuote.get(opp.id)).Approval_Status__c);
                            System.debug('mapNewQuote- Approval_Status__c'+mapNewQuote.get(mapOppQuote.get(opp.id)).Approval_Status__c);
                             if(mapOldQuote.get(mapOppQuote.get(opp.id)).Approval_Status__c != mapNewQuote.get(mapOppQuote.get(opp.id)).Approval_Status__c 
                             && mapNewQuote.get(mapOppQuote.get(opp.id)).Approval_Status__c == 'Pending Cancellation Approval' ) {
                                opp.Approval_Status__c = mapNewQuote.get(mapOppQuote.get(opp.id)).Approval_Status__c;
                                boolChck = true;
                            } 
                            System.debug('opp.Approval_Status__c'+ opp.Approval_Status__c); */  // Sushen is including this explicitly in his code
                            if(boolChck == true){
                               lstUpdtOpp.add(opp);
                            }
                        }
                    }
/*system.debug('Step3:lstUpdtOpp='+lstUpdtOpp);-- commented to reduce character for s2e optimization*/
                    if(lstUpdtOpp != NULL && !lstUpdtOpp.isEmpty() ) {
                        DATABASE.UPDATE(lstUpdtOpp);
                    }
                }
                if(setQuoteId != NULL && !setQuoteId.isEmpty()) {
                    List<QuoteLineItem> lstQLI = [SELECT Id, QuoteId FROM QuoteLineItem WHERE QuoteId IN: setQuoteId];
                    List<QuoteLineItem> lstUpdtQLI = new List<QuoteLineItem>();
                    for(QuoteLineItem qli : lstQLI) {
                     /*   if(mapOldQuote.get(qli.QuoteId).Projected_Renewal_Price__c != mapNewQuote.get(qli.QuoteId).Projected_Renewal_Price__c) {
                            qli.Projected_Renewal_Price__c = mapNewQuote.get(qli.QuoteId).Projected_Renewal_Price__c;
                            boolChk = true;
                        } */
                        if(boolChk){ /*boolChk == true has been changed for S2E Optimization*/
                            lstUpdtQLI.add(qli);
                        }
                    }
/*system.debug('Step4:lstUpdtQLI='+lstUpdtQLI);-- commented to reduce character for s2e optimization*/
                    if(lstUpdtQLI != NULL && !lstUpdtQLI.isEmpty() ) {
                        DATABASE.UPDATE(lstUpdtQLI);
                    }
                }
            }
            checkRecursive.isRenewalOpp = true;
            checkRecursive.isRenewalOLI = true;
            checkRecursive.isRenewalQLI = true;
        }
    }
    
    
    /********************************************************************************************
    MethodName: createCaseOnManagerAcceptance
    Description: Method is called from the trigger "QuoteAfterEventListener".
                 Method creates a new case when manager approve the Quote for Cancellation request.
    DevelopedBy: Sushen Adhikary
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public static void createCaseOnManagerAcceptance(Map<Id, Quote> mapNewQuote, Map<Id, Quote> mapOldQuote)
    {
/*System.Debug('In method "createCaseOnManagerAcceptance", mapNewQuote='+ mapNewQuote);
        System.Debug('In method "createCaseOnManagerAcceptance", mapOldQuote='+ mapOldQuote);-- commented to reduce character for s2e optimization*/
        List<Quote> lstQuote = new List<Quote>();
        for(Id objId : mapNewQuote.keySet()){
            if(RecordtypeIds__c.getInstance('LATAM Renewal Quote') != null && mapNewQuote.get(objId).RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c && mapNewQuote.get(objId).Renewal_Flag_Formula__c && (mapOldQuote.get(objId).Approval_Status__c == 'Pending Cancellation Approval') && (mapNewQuote.get(objId).Approval_Status__c == 'Cancellation Approved')){
                lstQuote.add(mapNewQuote.get(objId));
            }
            else if(RecordtypeIds__c.getInstance('LATAM Renewal Quote') != null && mapNewQuote.get(objId).RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c && mapNewQuote.get(objId).Renewal_Flag_Formula__c && (mapOldQuote.get(objId).Approval_Status__c == 'Pending Cancellation Approval') && (mapNewQuote.get(objId).Approval_Status__c == 'Cancellation Rejected')){
                lstQuote.add(mapNewQuote.get(objId));
            }
        }
/*System.Debug('In method "createCaseOnManagerAcceptance", lstQuote='+ lstQuote);
        System.Debug('In method "createCaseOnManagerAcceptance", lstQuote Size='+ lstQuote.size()); -- commented to reduce character for s2e optimization*/
        if(lstQuote != null && lstQuote.size() > 0)
        {
            try {
                Quote objQuote = lstQuote[0];
/*System.Debug('Step1, objQuote='+ objQuote);-- commented to reduce character for s2e optimization*/
                if(objQuote.Master_Quote__c == NULL)
                {
                    if(checkRecursive.runOnce())
                    {         
                        if(objQuote.Approval_Status__c == 'Cancellation Approved'){
 /*System.Debug('After checkRecursive, Cancellation Approved');-- commented to reduce character for s2e optimization*/                                         
                            //Preparing Quote Line Item for update
                            List<QuoteLineItem> lstUpdateQLI = new List<QuoteLineItem>();
                            for(QuoteLineItem qll : [SELECT Id, Status__c, UnitPrice, Item_Activity_Type__c FROM QuoteLineItem WHERE QuoteId =: objQuote.Id]){
                                qll.Status__c = 'Cancelled';  
                                //qll.TotalPrice = 0; //It is not writeble field.
                                qll.UnitPrice = 0;
                                qll.Item_Activity_Type__c = 'Cancelled';
                                lstUpdateQLI.add(qll);
                            }
                            //Preparing Opportunity Line Item for update
                            List<OpportunityLineItem> lstUpdateOppLI = new List<OpportunityLineItem>();
                            for(OpportunityLineItem opli : [SELECT Id, Active_Status__c, TotalPrice, UnitPrice, Activity_Type__c FROM OpportunityLineItem WHERE OpportunityId =: objQuote.OpportunityId]){
                                opli.Active_Status__c = 'Cancelled';   
                                //opli.TotalPrice = 0;
                                opli.UnitPrice = 0;
                                opli.Activity_Type__c = 'Cancelled';
                                lstUpdateOppLI.add(opli);
                            }
/*System.Debug('**********lstUpdateQLI='+lstUpdateQLI);
                            System.Debug('**********lstUpdateOppLI='+lstUpdateOppLI);-- commented to reduce character for s2e optimization*/
                            Quote objCheckedQuote = new Quote();
                            objCheckedQuote.Id = objQuote.Id;
                            objCheckedQuote.IsSkipQtyLockingValidation__c = true;
                            UPDATE objCheckedQuote;
/*System.Debug('lstUpdateOppLI 1='+ lstUpdateOppLI);-- commented to reduce character for s2e optimization*/
                            //By pass Opp validation rule                 
                            Opportunity objUpdateOpp = new Opportunity();
                            objUpdateOpp.Id = objQuote.OpportunityId;
                            objUpdateOpp.Approval_Status__c = 'Cancellation Approved';
                            objUpdateOpp.IsSkipOppLockingValidation__c = true;
                            UPDATE objUpdateOpp;
                            if(lstUpdateQLI.size() > 0){
                                UPDATE lstUpdateQLI;
                            }
/*if(lstUpdateOppLI.size() > 0){//UPDATE lstUpdateOppLI;
                            } -- commented for s2e optimization */
                            
                            objUpdateOpp.IsSkipOppLockingValidation__c = false;
                            UPDATE objUpdateOpp;
/*System.Debug('lstUpdateOppLI 2='+ lstUpdateOppLI);-- commented to reduce character for s2e optimization*/
                            Quote objUncheckQuote = new Quote();
                            objUncheckQuote.Id = objQuote.Id;   
                            objUncheckQuote.IsSkipQtyLockingValidation__c = false;
                            UPDATE objUncheckQuote;
 /*System.Debug('Succesfully updated'); 
                            System.Debug('Step2, objQuote='+ objQuote);-- commented to reduce character for s2e optimization*/
                            //WebserviceResponseHandler.createNewCase(objQuote, 'Full Cancel');
                            //Method is called for create a new Case.
                        WebserviceResponseHandler.createNewCase(objQuote, 'Full Cancellation');
                        }
                        else if(objQuote.Approval_Status__c == 'Cancellation Rejected'){
 /* System.Debug('After checkRecursive, Cancellation Rejected');-- commented to reduce character for s2e optimization*/
                            try{
                                //Update Opp for bypassing the Opp validation rule.
                                Opportunity objUpdateOpp = new Opportunity();
                                objUpdateOpp.Id = objQuote.OpportunityId;
                                objUpdateOpp.Approval_Status__c = 'Cancellation Rejected';
                                objUpdateOpp.IsSkipOppLockingValidation__c = true;
                                UPDATE objUpdateOpp;
                                objUpdateOpp.IsSkipOppLockingValidation__c = false;
                                UPDATE objUpdateOpp;
                            }
                            catch(DmlException ex){
/*System.Debug('Exception occured on Opportunity update for Quote Cancellation, Method = createCaseOnManagerAcceptance, Class = QuoteTriggerHandler, ERROR='+ ex);-- commented to reduce character for s2e optimization*/                   
                            }
                        }
                    }
                }
            }
            catch(DmlException ex){
/*System.Debug('Exception occured on update Quote and other related objects, Method = createCaseOnManagerAcceptance, Class = QuoteTriggerHandler, ERROR='+ ex);-- commented to reduce character for s2e optimization*/                  
            }   
        }
    }
    /********************************************************************************************
    MethodName: updateQuotePaymentMethodTermsOpty
    Description: Method is called from the trigger "QuoteAfterEventListener".
                 Method Updates Quote_Payment_Method_Terms_Updated__c field in Opty when Payment terms/Payment Method field is not blank in Quote
    DevelopedBy: TCS Offshore
    Revision:
    Fixed Defect#: MCL-1560
    *********************************************************************************************/
    public static void updateQuotePaymentMethodTermsOpty(List<Quote> Listquote, Map<Id, Quote> mapOldQuote){
        Set<id> oppIdSet = new Set<Id>();
        List<Opportunity> rltdOpportunityList = new List<Opportunity>();
        List<Opportunity> updateOpportunityList = new List<Opportunity>();    
        Map<Id,Quote> quoteMap = new Map<Id,Quote>();
        Map<Id,Quote> quoteOldMap = new Map<Id,Quote>();
        for(Quote q:Listquote)
        {
            oppIdSet.add(q.OpportunityId);
            quoteMap.put(q.OpportunityId,q);
        }
        for(Id objId : mapOldQuote.keySet()){
            quoteOldMap.put(mapOldQuote.get(objId).OpportunityId,mapOldQuote.get(objId));
        }
        if(!oppIdSet.isEmpty()){
            rltdOpportunityList = [SELECT Id, Quote_Payment_Method_Terms_Updated__c, RecordtypeId FROM Opportunity WHERE Id IN: oppIdSet];
        }
        if(!rltdOpportunityList.isEmpty()){
            for(Opportunity opp: rltdOpportunityList){
/*System.debug('Pipeline Opportunities :'+RecordtypeIds__c.getInstance('Pipeline Opportunities').recTypeId__c);
            System.debug('opp.RecordTypeId : '+opp.RecordTypeId);
System.debug('LATAM Renewal Opportunity:'+RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c);-- commented to reduce character for s2e optimization*/
                    if((RecordtypeIds__c.getInstance('Pipeline Opportunities').recTypeId__c != NULL && opp.RecordTypeId ==  RecordtypeIds__c.getInstance('Pipeline Opportunities').recTypeId__c)||(RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c != NULL && opp.RecordTypeId ==  RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c))
                {
                    if((quoteMap.get(opp.Id).Payment_Terms__c != quoteOldMap.get(opp.Id).Payment_Terms__c) || (quoteMap.get(opp.Id).Payment_Method__c != quoteOldMap.get(opp.Id).Payment_Method__c))
                    {
                        if((quoteMap.get(opp.Id).Payment_Terms__c != null)||(quoteMap.get(opp.Id).Payment_Method__c!= null)){                    
                            opp.Quote_Payment_Method_Terms_Updated__c = TRUE;
                            updateOpportunityList.add(opp);
                        }
                        else
                        {
                            opp.Quote_Payment_Method_Terms_Updated__c = False;
                            updateOpportunityList.add(opp);
                        }
                    }
                }                
            }
/*System.debug('updateOpportunityList:'+updateOpportunityList);-- commented to reduce character for s2e optimization*/
            if(!updateOpportunityList.isEmpty()){
                update(updateOpportunityList);                
            }
        }
    }
    /********************************************************************************************
    MethodName: updateReservationMngAndHisMng
    Description: Method is called from the trigger "QuoteBeforeEventListener".
    Added code for Win_loss field sync from Opp : SFD-1099
    DevelopedBy: Shovon 
    Purpose: SFD-497
    *********************************************************************************************/
    //Commeting this method as part of DPS-17684
    /*
    public static void updateReservationMngAndHisMng(List<Quote> Listquote){
//System.debug('@@@@@ Listquote: '+Listquote);-- commented to reduce character for s2e optimization
    List<Id> oppIdList = new List<Id>();
    Map<Id, Opportunity> opportunityMap;
    for(Quote q: Listquote){
        oppIdList.add(q.OpportunityId);
    }
        if(!oppIdList.isEmpty()){
            opportunityMap = new Map<Id, Opportunity>([SELECT Id, Reservation_Number__c, Reservation_Number__r.Partner_Manager__c, Reservation_Number__r.Partner_Manager__r.ManagerId FROM Opportunity WHERE Id IN: oppIdList]);
        }
        if(!opportunityMap.isEmpty()){
            for(Quote q: Listquote){
                if(opportunityMap.get(q.OpportunityId).Reservation_Number__r.Partner_Manager__c != null){
                    q.Reservation_Manager__c = opportunityMap.get(q.OpportunityId).Reservation_Number__r.Partner_Manager__c;
                    if(opportunityMap.get(q.OpportunityId).Reservation_Number__r.Partner_Manager__r.ManagerId != null){
                        q.Manager_of_Reservation_Manager__c = opportunityMap.get(q.OpportunityId).Reservation_Number__r.Partner_Manager__r.ManagerId;
                    }
                }
                //Added for Win_Loss field sync for SFD-1099
                //q.Win_Loss__c = opportunityMap.get(q.OpportunityId).Win_Loss__c;
                //q.Reason__c = opportunityMap.get(q.OpportunityId).Reason__c;
                //q.Was_There_A_Competitor__c = opportunityMap.get(q.OpportunityId).Was_There_A_Competitor__c;
                //q.Competitor_Name__c = opportunityMap.get(q.OpportunityId).Competitor_Name__c;
            }
            if(System.isFuture()){
                Database.update(Listquote);
            }
        }
    }
    */
    //Commeting this method as part of DPS-17684
    /*@Future    
    public static void updateReservationMngAndHisMng_Future(List<Id> ListquoteId){
//System.debug('@@@@@Inside updateReservationMngAndHisMng_Future Method: '+ListquoteId);-- commented to reduce character for s2e optimization
        List<Quote> Listquote;
        if(!ListquoteId.isEmpty()){
            Listquote = new List<Quote>([SELECT Id, OpportunityId, Reservation_Manager__c, Manager_of_Reservation_Manager__c FROM Quote WHERE OpportunityId IN: ListquoteId]);
        }
        if(!Listquote.isEmpty()){
//System.debug('@@@@@ Before calling updateReservationMngAndHisMng '+Listquote);-- commented to reduce character for s2e optimization
            QuoteTriggerHandler.updateReservationMngAndHisMng(Listquote);  
        }     
    }
       */ 
    /******************************************************************************************
    Method Name: QuoteOpptySync
    Created By: Sujana 
    Purpose:  SFD-415
    *******************************************************************************************/ 
    public static void QuoteOpptySync(Map<Id, Quote> mapOld, Map<Id, Quote> mapNew) {
        Set<Id> setOpportunityIds = new Set<Id>();
        List<Quote> listQuotesRefined = new List<Quote>();
        List<Opportunity> listOppForUpdate = new List<Opportunity>();
        try {
          if(mapNew.Values().size() > 0){
           for(Quote q : mapNew.Values()){                  
            if (q.Primary_Quote__c == true && (q.Short_Term_Sub__c != mapOld.Get(q.Id).Short_Term_Sub__c 
                || q.Win_Loss__c != mapOld.Get(q.Id).Win_Loss__c || q.Reason__c != mapOld.Get(q.Id).Reason__c
                || q.Was_There_A_Competitor__c != mapOld.Get(q.Id).Was_There_A_Competitor__c
                || q.Competitor_Name__c != mapOld.Get(q.Id).Competitor_Name__c)){
                    listQuotesRefined.add(q);
                    setOpportunityIds.add(q.OpportunityId);
                 }                    
              }
            }
           if (listQuotesRefined.size() == 0) return;
             Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>([Select id, Description,Win_Loss__c,Reason__c,Was_There_A_Competitor__c,Competitor_Name__c,Short_Term_Sub__c
                                From Opportunity where Id IN :setOpportunityIds]);                
                if(mapOpportunity.size()>0){
                    for (Quote q : listQuotesRefined) {
                        Opportunity opp = new Opportunity(Id = mapOpportunity.get(q.OpportunityId).Id);
                        opp.Short_Term_Sub__c = mapNew.get(q.Id).Short_Term_Sub__c;
                        opp.Win_Loss__c = mapNew.get(q.Id).Win_Loss__c;
                        opp.Reason__c = mapNew.get(q.Id).Reason__c;
                        opp.Was_There_A_Competitor__c = mapNew.get(q.Id).Was_There_A_Competitor__c;
                        opp.Competitor_Name__c = mapNew.get(q.Id).Competitor_Name__c;
                        listOppForUpdate.add(opp);
                    }
                }
                if(listOppForUpdate.size()>0){
                    try{
                        update listOppForUpdate;
                    }catch(exception e){
                        for(Quote q:mapNew.Values()){
                            q.addError(e.getMessage());
                        }
                    }
                }
            }
            Catch (Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization*/
            }
    }  
    
    public static void BillingPreferencesSynch(list<Quote> QuoteList){
         checkRecursion = true;
         set<Id> opptyIds = new set<Id>();
           
         for(Quote q:QuoteList)
            opptyIds.add(q.OpportunityId);
            
         map<Id,Opportunity> mapOppty = new map<Id,Opportunity>([Select Id,Opportunity.Account.Billing_Preferences__c from Opportunity where Id=:opptyIds]);
         for(quote oQuote : QuoteList){
         //Opportunity op = mapOppty.get(oQuote.OpportunityId);
         oQuote.Billing_Preferences__c = mapOppty.get(oQuote.OpportunityId).Account.Billing_Preferences__c;  
        }
    } 

    /** error logic for consolidated options**/
    public static void ValidateCreateToken(List<Quote> quote)  {
    List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
    List<OpportunityLineItem> lstOLIcons = new List<OpportunityLineItem>();
    List<OpportunityLineItem> newlstOLI = new List<OpportunityLineItem>();
    Map<String,Decimal> mapProdCodeQuan = new Map<String,Decimal>();
    List<OpportunityProductDetail__c > lstOppProdDtl = new List<OpportunityProductDetail__c >();
    List<OpportunityProductDetail__c > newlstOppProdDtl = new List<OpportunityProductDetail__c >();
    List<Opportunity_Product_Detail_Contact__c> lstOppProdDtlCntct = new List<Opportunity_Product_Detail_Contact__c>();
    List<Opportunity_Product_Detail_Contact__c> lstOpdtcon = new List<Opportunity_Product_Detail_Contact__c>();
    Map<String,List<String>> mapPrDtlConPrDtl = new Map<String,List<String>>();
    Set<id> setOppProdId = new Set<id>();
    Set<id> OppID = new Set<id>();
    Map<ID,List<OpportunityLineItem>> mapOLI = new Map<ID,List<OpportunityLineItem>>();
    Map<ID,List<OpportunityProductDetail__c>> mapOppProdDtl = new Map<ID,List<OpportunityProductDetail__c>>();
    for(Quote quo : quote){
    OppID.add(quo.OpportunityId);
    }
    newlstOLI =[SELECT id, priceBookEntry.product2.ProductCode,OpportunityId,Quantity FROM OpportunityLineItem WHERE OpportunityId IN: OppID AND priceBookEntry.product2.Entitlement_Oneshot__c = true]; // [CR]
    
    newlstOppProdDtl = [SELECT id,Opportunity__r.id,Product__r.ProductCode FROM OpportunityProductDetail__c WHERE Opportunity__r.id IN: OppID AND Product__r.Entitlement_Oneshot__c = true]; // Querying the OpportunityProductDetails having one shot products.
    
    for(OpportunityLineItem oppLi: newlstOLI){
        if(mapOLI.get(oppLi.OpportunityId) !=null && mapOLI.ContainsKey(oppLi.OpportunityId))
        {
            List<OpportunityLineItem> lisOLI = mapOLI.get(oppLi.OpportunityId);
            lisOLI.add(oppLi);
            mapOLI.put(oppLi.OpportunityId,lisOLI);
        }
        else{
            mapOLI.put(oppLi.OpportunityId, new List<OpportunityLineItem>{oppLi});
        }
    }
    for(OpportunityProductDetail__c oppLisP: newlstOppProdDtl){
        if(mapOppProdDtl.get(oppLisP.Opportunity__r.id) !=null && mapOppProdDtl.ContainsKey(oppLisP.Opportunity__r.id))
        {
            List<OpportunityProductDetail__c> lisOPD = mapOppProdDtl.get(oppLisP.Opportunity__r.id);
            lisOPD.add(oppLisP);
            mapOppProdDtl.put(oppLisP.Opportunity__r.id,lisOPD);
        }
        else{
            mapOppProdDtl.put(oppLisP.Opportunity__r.id, new List<OpportunityProductDetail__c>{oppLisP});
        }
    }
    
    //added to remove SOQL inside loop
    
    //to add OpportunityId and relared Product Detail Contacts
    Map<ID,List<Opportunity_Product_Detail_Contact__c>> mapPrdDetailsConts = new Map<ID,List<Opportunity_Product_Detail_Contact__c>>();
    Set<Id> optyIds = mapOppProdDtl.keySet();
    List<Opportunity_Product_Detail_Contact__c> prdDetailsContsList =[SELECT id,Contact__r.SAP_Contact_ID__c,Contact__r.FirstName,Contact__r.LastName ,Email__c,Product_Detail__c, 
                        Product_Detail__r.Product__r.ProductCode,Product_Detail__r.Opportunity__c  FROM Opportunity_Product_Detail_Contact__c WHERE Product_Detail__r.Opportunity__c IN : optyIds];
    
    for(Opportunity_Product_Detail_Contact__c prdCon : prdDetailsContsList){
        if(mapPrdDetailsConts.get(prdCon.Product_Detail__r.Opportunity__c) !=null && mapPrdDetailsConts.ContainsKey(prdCon.Product_Detail__r.Opportunity__c))
        {
            List<Opportunity_Product_Detail_Contact__c> lisOPDCon = mapPrdDetailsConts.get(prdCon.Product_Detail__r.Opportunity__c);
            lisOPDCon.add(prdCon);
            mapPrdDetailsConts.put(prdCon.Product_Detail__r.Opportunity__c,lisOPDCon);
        }
        else{
            mapPrdDetailsConts.put(prdCon.Product_Detail__r.Opportunity__c, new List<Opportunity_Product_Detail_Contact__c>{prdCon});
        }
    }
    System.debug('@@mapPrdDetailsConts: '+mapPrdDetailsConts);
    // End - remove SOQL    
        
    for(Quote quo : quote){
        if(mapOLI.get(quo.OpportunityId) != null && !mapOLI.get(quo.OpportunityId).IsEmpty()){
            lstOLI = mapOLI.get(quo.OpportunityId);
        }
        if(mapOppProdDtl.get(quo.OpportunityId) != null && !mapOppProdDtl.get(quo.OpportunityId).IsEmpty()){
            lstOppProdDtl = mapOppProdDtl.get(quo.OpportunityId);
        }
                //[CR] Below for loop to create map of prod code and quantity
                
                for(OpportunityLineItem oli: lstOLI ){                  
                    mapProdCodeQuan.put(oli.PricebookEntry.Product2.ProductCode,oli.Quantity);      
                }
                
                
                if(lstOppProdDtl!= NULL && !lstOppProdDtl.isEmpty()){
                // Below logic is to create the map with OpportunityProductDetailContact as the key and list of all of the OpportunityProductDetails(Product code) it is associated with as the value .
                    for(OpportunityProductDetail__c oppProDtl : lstOppProdDtl){
                        setOppProdId.add(oppProDtl.id);    
                    }
                    //if(!setOppProdId.isEmpty()){
                    //   lstOppProdDtlCntct =[SELECT id,Contact__r.SAP_Contact_ID__c,Contact__r.FirstName,Contact__r.LastName ,Email__c,Product_Detail__c, Product_Detail__r.Product__r.ProductCode  FROM Opportunity_Product_Detail_Contact__c WHERE Product_Detail__c IN : setOppProdId];
                    //}
                    //added below lines to remove above SOQL from loop
                    if(mapPrdDetailsConts.get(quo.OpportunityId) != null && !mapPrdDetailsConts.get(quo.OpportunityId).IsEmpty()){  
                        lstOppProdDtlCntct = mapPrdDetailsConts.get(quo.OpportunityId);
                    }

                    if(!lstOppProdDtlCntct.isEmpty()){
                        for(Opportunity_Product_Detail_Contact__c opCntc : lstOppProdDtlCntct){
                       // Taking Email__c as key for Associated contacts
                                if(mapPrDtlConPrDtl.keySet().contains(opCntc.Email__c)){
                                    mapPrDtlConPrDtl.get(opCntc.Email__c).add(opCntc.Product_Detail__r.Product__r.ProductCode);
                                }
                                else{
                                    List<String> lstOpPrdDtl = new  List<String>();
                                    lstOpPrdDtl.add(opCntc.Product_Detail__r.Product__r.ProductCode);
                                    mapPrDtlConPrDtl.put(opCntc.Email__c,lstOpPrdDtl);
                                    lstOpdtcon.add(opCntc);
                                }
                        }
                    }
                }
                for(Opportunity_Product_Detail_Contact__c opProdDtlCntct: lstOpdtcon){
                if((opProdDtlCntct.Email__c != NULL)){
                            Decimal countProdtotal = 0;
                            for(String ProdCode : mapPrDtlConPrDtl.get(opProdDtlCntct.Email__c))
                            {  
                              // [CR]Below logic to reduce one quantity each time from the quantity value of the map, so that we get the left over quantity
                                if(mapProdCodeQuan.keySet().contains(ProdCode)){
                                 //put the logic here to finally have a map(mapProdCodeQuan) ready with prodcode as key and left over quanity of each prod as value. 
                                  countProdtotal  = mapProdCodeQuan.get(ProdCode) -1;
                                  mapProdCodeQuan.put(ProdCode,countProdtotal);
                                 }
                            }
                        }
                }  
        
         for(OpportunityLineItem oli: lstOLI ){  
                if(mapProdCodeQuan.containskey(oli.PricebookEntry.Product2.ProductCode) && mapProdCodeQuan.get(oli.PricebookEntry.Product2.ProductCode)>0){
                        lstOLIcons.add(oli);
                }
            }
            
        if((quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated' || quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated') && quo.Entitlement_Product_Count__c>0 ){
            List<decimal> DEC = new List<decimal>();
            for(OpportunityLineItem oli: lstOLIcons){
                if(lstOLIcons.size()>0){
                    Decimal a=mapProdCodeQuan.get(oli.priceBookEntry.product2.productcode);
                    DEC.add(a);
                }
            }
            Decimal d = 0;
            if(!DEC.isEmpty())                
              d = DEC[0];
            
            System.debug('Test Step DEC '+d);
           
            for(OpportunityLineItem oli: lstOLIcons) {
                if(lstOLIcons.size()>0) {
                    Decimal a=mapProdCodeQuan.get(oli.priceBookEntry.product2.productcode);
                    System.debug('Test Step a '+a);
                    if(a!=d) {
                    //    quo.addError('Leftover quantity of the product must be same to select consolidated');
                        String errMsg= Label.ProviewError;
                        quo.addError(errMsg);  
                        break;
                    }
                }
            }                
        }
    }   
}    
}