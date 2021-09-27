/**
 * Contains methods for triggering create quote
 *
 * @author  Srikanth Kuruva
 * @version  2013-03-14
 */
 /**
 * CHANGE HISTORY
 * ================================================================================================================
 * Date         Name                    Description
 * 2013-03-14   Srikanth Kuruva          Created
 * 2013-03-14   Anshita Sharma           Added logic for quote creation and callout
 * 2013-05-03   Sripriya Kongot          Mreged try/catch section & added logic to update Manual Quote trigger flag for failure of single quote       
 * 2013-08-08   Sripriya Kongot          Fixed issue related to create quote not firing, if SAP IDOC is blank at quote level
 * 2013-09-01   Srikanth Kuruva          added determine Sales Org method and made the newly created quote as primary.
   2016-07-20   Rajashree                Made some changes in 'createSAPQuote' method as part of Renewals.
 * ==============================================================================================================
 */
 
global with sharing class createQuote{ 
   //Id RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM New Quote').getRecordTypeId();
   /*public static string determineSalesOrg(string sAccountSalesOrg){
       string sLATAMSalesOrgs = 'ABEP,BEJE,FSCO,LJUU,LLEY,LLPA,LPCL,LPTC,RV01,TSL';
       Id CurrentUserId = UserInfo.getUserId();
       User CurrentUser = [Select Sales_Org__c from User where Id = :CurrentUserId];
       if(!AppUtil.isEmpty(CurrentUser.Sales_Org__c)){
           if(sLATAMSalesOrgs.contains(CurrentUser.Sales_Org__c)){
               return CurrentUser.Sales_Org__c;
           }
           else{
               return sAccountSalesOrg;
           }
       }
       else{
           return sAccountSalesOrg;
       }
   }*/
   public static String determineSalesOrgNew(User CurrentUser,string sAccountSalesOrg){
       //string sLATAMSalesOrgs = 'ABEP,BEJE,FSCO,LJUU,LLEY,LLPA,LPCL,LPTC,RV01,TSL';
       //string sLATAMSalesOrgs = 'BEJE,FSCO,LJUU,LLEY,LLPA,LPCL,LPTC,RV01,TSL'; // removed ABEP for Hercules implementation.
       //string sLATAMSalesOrgs = 'BEJE,LJUU,LLEY,LLPA,LPCL,LPTC,RV01,TSL'; // removed FSCO for Hercules implementation.
       /*string sLATAMSalesOrgs = '';
       LaTam_Mexico_Static_Values__mdt sLATAM = LaTam_Mexico_Static_Values__mdt.getInstance('createQuote');
       if(sLATAM != null)
       sLATAMSalesOrgs = sLATAM.Sales_Org__c; */
       Map<String,String> salesorgMap = new Map<String,String>();
       salesorgMap = MexicoUtility.classBasedOrgValues('createQuote','Sales_Org__c');
       
       //Id CurrentUserId = UserInfo.getUserId();
       //User CurrentUser = [Select Sales_Org__c from User where Id = :CurrentUserId];
       if(!AppUtil.isEmpty(CurrentUser.Sales_Org__c)){
           if(salesorgMap.get(CurrentUser.Sales_Org__c) != null){
               return CurrentUser.Sales_Org__c;
           }
           else{
               return sAccountSalesOrg;
           }
       }
       else{
           return sAccountSalesOrg;
       }
   }
   
   
   webservice static String triggerQuoteCreationFrmOpp(Id oppId)
   {
   system.debug('$$$ triggerQuoteCreationFrmOpp'+oppId);
       Id CurrentUserId = UserInfo.getUserId();
       User CurrentUser = [Select Sales_Org__c from User where Id = :CurrentUserId];
       map<Id,List<opportunitylineitem>> getOpplineitemMap = new map<Id,List<opportunitylineitem>>();
       set<Id> opportunitySet = new set<Id>();
       list <QuoteLineItem> insertQuoteLineItemList = new list <QuoteLineItem>();
       List<Quote> exQuoteList = new List<Quote>();
       Opportunity oppUpdate = new Opportunity(Id=oppId);
       Id RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM New Quote').getRecordTypeId();
       //String sQuoteStage = QuoteStages__c.getInstance('Default').StageName__c; 
       List<Quote> qList = new List<Quote>();
       try{
            qList = [Select id, QuoteNumber, OpportunityId, SAP_IDOC_Number__c,Quote_Error_Counter__c, Opportunity.Account.SAPAccountNumber__c, Opportunity.Account.Sales_Org__c from Quote where OpportunityId=:oppId];
       }catch(Exception e){System.debug('Exception : '+e.getMessage());}
       for(Quote existingQuote :qList)
       {
           exQuoteList.add(existingQuote);
       }
       try{
           if(!exQuoteList.isEmpty()){
               //check if there are quotes with blank IDOC number 
               for(Quote quote:exQuoteList){
                   
                       if(AppUtil.IsEmpty(quote.SAP_IDOC_Number__c)){
                           system.debug('Creations=== sapquote quote.SAP_IDOC_Number__c' + quote.SAP_IDOC_Number__c);
                           createSAPQuote(quote.QuoteNumber,determineSalesOrgNew(CurrentUser,quote.Opportunity.Account.Sales_Org__c),quote.Opportunity.Account.SAPAccountNumber__c);
                       }
                 
               }
               return 'Create Quote service is succesfully called.';
           }
           else{
                 //create quotes
                  // Id RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM New Quote').getRecordTypeId();
                   Opportunity Opp = [select id, name, Short_Term_Sub__c,Account.Sales_Org__c,Owner.Profile.Name, Account.SAPAccountNumber__c ,pricebook2Id,Win_Loss__c,Reason__c,Was_There_A_Competitor__c,Competitor_Name__c from opportunity where id=:oppId];
                   opportunitySet.add(Opp.id);
                   getOpplineitemMap = getOppLineItem(opportunitySet);
                   Quote oQuote = new Quote();
                   System.debug('Opp.Owner.Profile.Name **'+Opp.Owner.Profile.Name);
                   if ((Opp.Owner.Profile.Name == 'Latam User') || (Opp.Owner.Profile.Name == 'Partner Portal User'))
                    {
                     oQuote.RecordTypeId = RecordTypeId;
                    }
                   oQuote.Name = 'Quote_'+Opp.Name;
                   oQuote.OpportunityId = Opp.id;
                   oQuote.Primary_Quote__c = true;
                   oQuote.pricebook2Id = Opp.pricebook2Id;
                   oQuote.Short_Term_Sub__c = Opp.Short_Term_Sub__c;
                   oQuote.Win_Loss__c = Opp.Win_Loss__c;
                   oQuote.Reason__c = Opp.Reason__c;
                   oQuote.Was_There_A_Competitor__c = Opp.Was_There_A_Competitor__c;
                   oQuote.Competitor_Name__c = Opp.Competitor_Name__c;
                   insert oQuote;
                   oQuote = [select QuoteNumber, OpportunityId, Name from Quote where id = :oQuote.Id];
                   if(oQuote.Id != null && getOpplineitemMap.containsKey(Opp.id)){
                       insertQuoteLineItemList = getQuoteLineItems(getOpplineitemMap.get(Opp.id),oQuote.Id);
                       insert insertQuoteLineItemList;
                   }
                    
                   system.debug('QuoteNumber:'+oQuote.QuoteNumber);
                   //createSAPQuote(oQuote.QuoteNumber,determineSalesOrg(Opp.Account.Sales_Org__c),Opp.Account.SAPAccountNumber__c); 
                   return 'Create Quote service is succesfully called.';             
              }
       }
          catch(Exception e){
              oppUpdate.Require_Manual_Trigger_for_Quote__c = true;   
              update  oppUpdate;             
              return 'The quote ID failed to generate automatically. Please try again by manually initiating the quote ID creation process using the link provided within the Order Processing section below or contact your administrator.';
          }
          
       }
   
   
   
   webservice static void triggerQuoteCreationFrmAcc(Id accId)
   {
   system.debug('$$$ triggerQuoteCreationFrmAcc ' + accId);
       Id CurrentUserId = UserInfo.getUserId();
       User CurrentUser = [Select Sales_Org__c from User where Id = :CurrentUserId];
       map<Id,List<opportunitylineitem>> getOpplineitemMap = new map<Id,List<opportunitylineitem>>();
       list <QuoteLineItem> insertQuoteLineItemList = new list <QuoteLineItem>();
       Map<Id, Opportunity> opptyIdMap = new Map<Id, Opportunity>();
       Map<Id, Quote> oppQuoteMap = new Map<Id, Quote>();
       List<Opportunity> oppUpdateList = new List<Opportunity>();
       List<Opportunity> listOpportunities = new List<Opportunity>();
       List<String> sOppStages = new List<String>();
       Id RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM New Quote').getRecordTypeId();
       List<Quote> lstQuote= new List<Quote>();
       
       listOpportunities = [Select id, Name, Account.Recordtype.Name, StageName,  Account.Sales_Org__c,  Account.SAPAccountNumber__c ,pricebook2Id,Owner.Profile.Name from opportunity where AccountId =:accId];
       
       if(!listOpportunities.isEmpty()){
           String sQuoteStage = BigRuleGenericSettings__c.getInstance('QS:'+listOpportunities[0].Account.Sales_Org__c).Value__c;
           Set<String> setQuoteStages = new set<String>();
           setQuoteStages.addAll(sQuoteStage.split(',',0));
           
           for(Opportunity opp :listOpportunities)
           {              
                   if(setQuoteStages.contains(opp.StageName))
                       opptyIdMap.put(opp.id,opp);
                   
           }
           if(!opptyIdMap.isEmpty())
           {
               for(Quote existingQuote :[Select id, OpportunityId, SAP_IDOC_Number__c,Quote_Error_Counter__c, QuoteNumber from Quote where OpportunityId In :opptyIdMap.keySet()])
               {
                   //create a set of OppIds to see which all opps already have quotes 
                   oppQuoteMap.put(existingQuote.OpportunityId,existingQuote);
               }
               getOpplineitemMap = getOppLineItem(opptyIdMap.keySet());
           }
           
           for (Opportunity opp : opptyIdMap.values()){
               try{
                   if(Limits.getFutureCalls()<Limits.getLimitFutureCalls()){// SF allows only 10 callouts per transaction
                       if(!oppQuoteMap.containsKey(opp.id)){
                       
                               //logic to create salesforce quote.
                               Quote oQuote = new Quote();
                               System.debug('Opp.Owner.Profile.Name **'+Opp.Owner.Profile.Name);
                               if ((Opp.Owner.Profile.Name == 'Latam User') || (Opp.Owner.Profile.Name == 'Partner Portal User'))
                                    {
                                     oQuote.RecordTypeId = RecordTypeId;
                                    }
                               oQuote.Name = 'Quote_'+opp.Name;
                               oQuote.OpportunityId = opp.id;
                               oQuote.Primary_Quote__c = true;
                               oQuote.pricebook2Id = opp.pricebook2Id;
                               lstQuote.add(oQuote);
                               /*
                               insert oQuote;
                               oQuote = [select QuoteNumber, OpportunityId, Name from Quote where id = :oQuote.Id];
                               if(oQuote.Id != null && getOpplineitemMap.containsKey(Opp.id)){
                                 insertQuoteLineItemList = getQuoteLineItems(getOpplineitemMap.get(Opp.id),oQuote.Id);
                                
                                }
                                */
                               //createSAPQuote(oQuote.QuoteNumber,determineSalesOrg(opp.Account.Sales_Org__c),opp.Account.SAPAccountNumber__c);
                       }
                       else{
                           //check if IDOC number is blank on existing quote
                           Quote exQuote = oppQuoteMap.get(opp.id);
                           if(AppUtil.IsEmpty(exQuote.SAP_IDOC_Number__c) && opp.Account.Recordtype.Name =='Customer'){
                               system.debug('Creations=== SAPquote exQuote.SAP_IDOC_Number__c' + exQuote.SAP_IDOC_Number__c);
                               createSAPQuote(exQuote.QuoteNumber,determineSalesOrgNew(CurrentUser,opp.Account.Sales_Org__c),opp.Account.SAPAccountNumber__c);
                           }                    
                       }
                   }    
                   else{
                       opp.Require_Manual_Trigger_for_Quote__c = true;
                       oppUpdateList.add(opp);
                   } 
               }           
               catch(Exception e){
                   opp.Require_Manual_Trigger_for_Quote__c = true;
                   oppUpdateList.add(opp);
               } 
           }
           insert lstQuote;
           for(Opportunity opp : opptyIdMap.values()){
               for(Quote quo:lstQuote){
                    if(quo.Id != null && quo.OpportunityId==opp.Id && getOpplineitemMap.containsKey(Opp.id)){
                     insertQuoteLineItemList.addAll(getQuoteLineItems(getOpplineitemMap.get(Opp.id),quo.Id));
                    
                    }   
               }               
           }           
           if(!insertQuoteLineItemList.isEmpty()){
               insert insertQuoteLineItemList;
           }
           if(!oppUpdateList.isEmpty())
               update oppUpdateList;
       }
   }
   
 @future(callout=true)
   global static void createSAPQuote(string sQuoteNumber, string sSalesOrg, string sSAPAccountNumber){
   
   QuoteTriggerHandler.callOnce=false;
       //Variable to hold the integration message id for logging purposes
       String integrationMsgId; 
       try{
           String accessToken=DellBoomiTokenGeneration.getAuthToken();
           //logic to initialize callout parameters
           ecomTocServicesThomsonCom20Orders.OrderAddress oSoldTo = new ecomTocServicesThomsonCom20Orders.OrderAddress();
           oSoldTo.account = new ecomTocServicesThomsonCom10Core.Account();
           oSoldTo.account.AccountNumber = sSAPAccountNumber;//SAP Account number of Opportunity's account
           oSoldTo.account.CompanyId = sSalesOrg;//this should be the sales org of account - please check
           
           ecomTocServicesThomsonCom20Orders.OrderAddress oBillTo = new ecomTocServicesThomsonCom20Orders.OrderAddress();
           oBillTo = oSoldTo;
           
           ecomTocServicesThomsonCom20Orders.context_element oContext = new ecomTocServicesThomsonCom20Orders.context_element();
           oContext.productId = KeyValueListStore__c.getInstance('BigRuleProductId').TextValue__c;
           oContext.configGroup = KeyValueListStore__c.getInstance('BigRuleCconfigGroup').TextValue__c;
           
           ecomTocServicesThomsonCom20Orders.Account oAccountElement = new ecomTocServicesThomsonCom20Orders.Account();
           oAccountElement.accountNumber = sSAPAccountNumber;
           oAccountElement.companyId = sSalesOrg;           
           oContext.account = oAccountElement;
           
           string sSFDCQuoteId = sQuoteNumber;//salesforce quote id created above for this opp id
           ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element oSAPQuoteResponse = new ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element();
           ecomOrdersServiceV02.OrdersServiceV02 oSAPsrvc= new ecomOrdersServiceV02.OrdersServiceV02();//creating the stub
           WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('BigRuleCreateQuote');                
           oSAPsrvc.endpoint_x = oWebServiceSettings.Endpoint__c;
           oSAPsrvc.inputHttpHeaders_x = new Map<String, String>();
           oSAPsrvc.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
           //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
           //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
           string sAuthorizationHeader = 'Bearer ' + accessToken;
           oSAPsrvc.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
           oSAPsrvc.outputHttpHeaders_x = new Map<String,String>();
           if(Test.isRunningTest())
           {
                oSAPQuoteResponse = MockWebserviceResponses.getQuoteResponse();
           }
           else
           {
                oSAPQuoteResponse = oSAPsrvc.createQuote(oContext, sSFDCQuoteId, oSoldTo, oBillTo, System.datetime.now());
           }
           system.debug('oSAPQuoteResponse.iDocNumber:'+oSAPQuoteResponse.iDocNumber);
           //[Rajashree] Added some fields to the query
           Quote oQuote = [select id, Renewal_Flag_Formula__c , RecordTypeId, SAP_IDOC_Number__c, OpportunityId from Quote where QuoteNumber = :sQuoteNumber];
        //    String strRecordType = RecordtypeIds__c.getInstance('LATAM Renewal Quote').Record_Type_Label__c;
           if(oSAPQuoteResponse.iDocNumber != null && oSAPQuoteResponse.iDocNumber !=''){
               oQuote.SAP_IDOC_Number__c = oSAPQuoteResponse.iDocNumber;
               oQuote.Quote_Error_Counter__c = 0;
         //   [Rajashree] Added the below check, shouldnot update for renewals   
               if(oquote.Renewal_Flag_Formula__c != TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oquote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c){
                   update oQuote;
               }
               //update opportunity Quote Creation Complete Flag
               Opportunity oOpportunity = new Opportunity();
               oOpportunity.Id = oQuote.OpportunityId;
               oOpportunity.Quote_Creation_Complete__c = true;
               oOpportunity.Require_Manual_Trigger_for_Quote__c = false;
         //   [Rajashree] Added the below check,  shouldnot update for renewals
               if(oquote.Renewal_Flag_Formula__c != TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oquote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c){
                update oOpportunity;
               }
               //Create a log entry   
               integrationMsgId =IntegrationLogger.addMessage('', oQuote.id, 'Quote', '', 'Outbound','Create Quote',false);
               //Log  entry for success
               IntegrationLogger.updateMessage(integrationMsgId, true,'' );
              
           }
       }
       catch(Exception ex){
          system.debug('Error in Create Customer'+ex.getMessage());
          //update Quote_Error_Counter__c 
      //[Rajashree] Added some fields to the query 
          Quote oQuote = [select Quote_Error_Counter__c,Renewal_Flag_Formula__c ,OpportunityId from Quote where QuoteNumber = :sQuoteNumber];
      //    String strRecordType = RecordtypeIds__c.getInstance('LATAM Renewal Quote').Record_Type_Label__c;
          if(oQuote.Quote_Error_Counter__c == null)
              oQuote.Quote_Error_Counter__c = 1;
          else
              oQuote.Quote_Error_Counter__c = oQuote.Quote_Error_Counter__c+1 ;
     //   [Rajashree] Added the below check, ,  shouldnot update for renewals
          if(oquote.Renewal_Flag_Formula__c != TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL &&  oquote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c){
               update oQuote;
           }      
          if(integrationMsgId != null && integrationMsgId != ''){
            IntegrationLogger.updateMessage(integrationMsgId, false,'Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage() );
          }
          else{
            integrationMsgId =IntegrationLogger.addMessage(ex.getMessage(), oQuote.id, 'Quote', '', 'Outbound','Create Quote',false);           
          }
           //update opportunity Require Manual Quote Creation  Flag to true 
               Opportunity oOpportunity = new Opportunity();
               oOpportunity.Id = oQuote.OpportunityId;               
               oOpportunity.Require_Manual_Trigger_for_Quote__c = true;
        //   [Rajashree] Added the below check, ,  shouldnot update for renewals
               if(oquote.Renewal_Flag_Formula__c != TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != NULL && oquote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c){
                   update oOpportunity;
               }
       }       
   }
   //Defect 121
   public static map<Id,List<opportunitylineitem>> getOppLineItem (set<Id>opportunityIdset){
    System.debug(' $$$getOppLineItem -->' +opportunityIdset );
    map<Id,List<opportunitylineitem>> opplineitemMap = new map<Id,List<opportunitylineitem>>();
    for (opportunitylineitem olineItem : [select id, Activity_Type__c, Active_Status__c, Revenue_Type__c,MOLI_id__c, opportunityId,pricebookentryId,Quantity,List_Price__c,Unitprice,Discount,Monthly_Charge__c,Incremental_Amount__c,Renewal_Amount__c,Number_of_Contacts__c,Description,Surcharge_Prct__c from opportunitylineitem where opportunityId in :opportunityIdset ]){
        if(olineItem !=null){
            if(!opplineitemMap.containsKey(olineItem.opportunityId)){
                opplineitemMap.put(olineItem.opportunityId, new List<opportunitylineitem>());
            }
            opplineitemMap.get(olineItem.opportunityId).add(olineItem);
        }
    }
    return opplineitemMap;
   }
   
   //Defect SFD-458
   public static map<Id,List<QuoteLineItem>> getQuoteLineItem (set<Id>QuoteIdset){
    System.debug(' $$$getOppLineItem -->' +QuoteIdset );
    map<Id,List<Quotelineitem>> qlineitemMap = new map<Id,List<Quotelineitem>>();
    for (Quotelineitem olineItem : [select id,Revenue_Type__c, Item_Activity_Type__c,Status__c,MOLI_id__c, QuoteId,pricebookentryId,Quantity,Unitprice,Discount,Monthly_Charge__c,Incremental_Amount__c,Renewal_Amount__c,Number_of_Contacts__c,Description,Surcharge_Prct__c from QuoteLineItem where QuoteId in :QuoteIdset]){
        if(olineItem !=null){
            if(!qlineitemMap.containsKey(olineItem.QuoteId)){
                qlineitemMap.put(olineItem.QuoteId, new List<QuoteLineItem>());
            }
            qlineitemMap.get(olineItem.QuoteId).add(olineItem);
        }
    }
    return qlineitemMap;
   }
   //Ends here SFD-458
   public static list <QuoteLineItem> getQuoteLineItems(list<Opportunitylineitem> existingLineItem, String quoteId ){
        System.debug(' createOpptyLineItems -->' + existingLineItem +' '+ quoteId );
        list <QuoteLineItem> quoteLineItemList = new list <QuoteLineItem>();
        try{
            for(Opportunitylineitem oLineItem : existingLineItem){
                QuoteLineItem oQuoteLineItem = new QuoteLineItem();
                System.debug(' oQuoteLineItem -->' + oQuoteLineItem);
                oQuoteLineItem.Quantity = oLineItem.Quantity;
                oQuoteLineItem.quoteId = quoteId;
                oQuoteLineItem.UnitPrice = oLineItem.UnitPrice;
                //oQuoteLineItem.list_price__c = oLineItem.List_Price__c;
                oQuoteLineItem.pricebookentryid = oLineItem.pricebookentryid;
                oQuoteLineItem.Surcharge_Prct__c = oLineItem.Surcharge_Prct__c;
                oQuoteLineItem.Monthly_Charge__c = oLineItem.Monthly_Charge__c;
                oQuoteLineItem.Revenue_Type__c = oLineItem.Revenue_Type__c;
                oQuoteLineItem.Number_of_Contacts__c = oLineItem.Number_of_Contacts__c;
                oQuoteLineItem.Incremental_Amount__c = oLineItem.Incremental_Amount__c;
                oQuoteLineItem.Renewal_Amount__c = oLineItem.Renewal_Amount__c;
                oQuoteLineItem.Description = oLineItem.Description;
                System.debug('@@@@@@oLineItem.Active_Status__c'+oLineItem.Active_Status__c);
                oQuoteLineItem.Status__c= oLineItem.Active_Status__c;
                System.debug('@@@@@@oQuoteLineItem.Status__c'+oQuoteLineItem.Status__c);
                oQuoteLineItem.Item_Activity_Type__c= oLineItem.Activity_Type__c;
                oQuoteLineItem.Discount = oLineItem.Discount;
                System.debug('$$$$oLineItem.MOLI_id__c'+oLineItem.MOLI_id__c);
                oQuoteLineItem.MOLI_id__c= oLineItem.MOLI_id__c;
                System.debug('$$$$oQuoteLineItem.MOLI_id__c'+oQuoteLineItem.MOLI_id__c);
                quoteLineItemList.add(oQuoteLineItem);
            }
        }
        catch(Exception e){
            return quoteLineItemList;
        }
        System.debug('$$$quoteLineItemList'+quoteLineItemList);
        return quoteLineItemList;
    }
   
}