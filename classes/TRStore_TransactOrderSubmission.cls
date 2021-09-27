/* Class: TRStore_TransactOrderSubmission
* Purpose: This class will update the proposal following which the cart will be finalized and an order will be placed
* Created: 27-Nov-2020
* Author: Kanishk Singhvi
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 27-Nov-2020   Kanishk Singhvi DUE-6660  Quote Syncronization/Update
* =============================================================================
*/
/********************************************************************************************************
    *  @description TRStore_TransactOrderSubmission : Class to update the quote
    *********************************************************************************************************/ 
    
    public with sharing class TRStore_TransactOrderSubmission {
    
        public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
        public Static String quoteID = ''; 
        /********************************************************************************************************
        *  @description mapProposalDetails : Method for mapping fields in Quote
        *  @return List<Apttus_Proposal__Proposal__c>  : this is a return statement contains list 
        *  @param billingIds - input param (SSD Id)
        *  @param leadInfo - input param (list of leads)
        *  @param quoteInfo - input param (list of quotes)
        *********************************************************************************************************/ 
        public static List<Apttus_Proposal__Proposal__c> mapProposalDetails(Map<string,Id> billingIds, List<Lead> leadInfo, List<Apttus_Proposal__Proposal__c> quoteInfo){
            
            if(!leadInfo.isEmpty() && !quoteInfo.isEmpty()){
                for(Lead lead : leadInfo){
                    
                    quoteInfo[0].Apttus_Proposal__Opportunity__c = lead.ConvertedOpportunityId;
                    quoteInfo[0].Apttus_Proposal__Account__c = lead.convertedAccountid;
                    quoteInfo[0].APTS_Order_Confirmation_Contact__c = lead.ConvertedContactId;
                    quoteInfo[0].Apttus_Proposal__Primary_Contact__c = lead.ConvertedContactId;
                    quoteInfo[0].APTS_Ebilling_exempt__c = true;
                    quoteInfo[0].TR_Store_Source__c = lead.Lead_Region__c;
                    quoteInfo[0].Latam_APTS_Reason__c = 'Digital';
                    quoteInfo[0].APTS_SSD_bill_to__c = billingIds.get('billTo');
                    quoteInfo[0].APTS_SSD_ship_to__c = billingIds.get('shipTo');
                    if(billingIds.get('billTo')!=billingIds.get('shipTo') && String.isNotBlank(billingIds.get('oneTime'))){
                        quoteInfo[0].APTS_One_Time_Ship_To__c = billingIds.get('oneTime');
                    }
                    quoteInfo[0].APTS_SSD_Sold_To__c = billingIds.get('soldTo');
                    
                    quoteInfo[0].Language__c = (lead.Language_Preference__c != null) ?  mapLanguageFromLead(lead.Language_Preference__c) : 'English' ;
                    
                }                
            }
            
            return quoteInfo;
        }
        
    /********************************************************************************************************
        *  @description mapLanguageFromLead : Method for updating language
        *  @return String  : this is a return statement contains language String 
        *  @param lang - input param (string)
        *********************************************************************************************************/ 
         private static string mapLanguageFromLead(string lang){
            return (lang == 'French-Canadian') ? 'French' : 'English';
           
         }
        
        
    /********************************************************************************************************
        *  @description mapConfigDetails : Method for mapping fields in Prod config
        *  @return List<Apttus_config2__productconfiguration__c>  : this is a return statement contains list 
        *  @param billTo - input param (SSD Id)
        *  @param shipTo - input param (SSD Id)
        *  @param configInfo - input param (list of prod config)
        *********************************************************************************************************/ 
        public static List<Apttus_config2__productconfiguration__c> mapConfigDetails(String billTo, String shipTo, List<Apttus_config2__productconfiguration__c> configInfo){
            
            if(!configInfo.isEmpty()){
                
                configInfo[0].APTS_SSD_bill_to__c = billTo;
                configInfo[0].APTS_SSD_ship_to__c = shipTo;
                
            }
            return configInfo;
        }
        
    /********************************************************************************************************
        *  @description finalizeCart : Method for cart finalization
        *  @param cartId - input param (cart Id)
        *  @param quoteId - input param (quote Id)
        *********************************************************************************************************/ 
        public static void finalizeCart(Id cartId, Id quoteId){
            system.debug(LoggingLevel.INFO,'cart id..'+cartId);
            List<Apttus_Config2__LineItem__c> linestoDel = new List<Apttus_Config2__LineItem__c>();
            String pricePending ='false';
            if(cartId != null){
                Map<String, Apttus_Config2__LineItem__c> alllineitems = TRStore_CartPriceRequestHelperOne.getLineItems(cartId,null);
                        for(Apttus_Config2__LineItem__c li: alllineitems.values()){
                            if(li.mark_removed__c) {
                                linestoDel.add(li);
                            }
                        }
                if(linestoDel!=null && linestoDel.size()>0){
                    Database.delete(linestoDel,true);
                }
                
            try{            
                pricePending = repriceCart(cartId);
            }catch(Exception e){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: TRStore_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
                pricePending = 'Reprice Exception';
            }
            
                try{
                    Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
                    system.debug(LoggingLevel.INFO,'Requestcart..'+request);
                    request.CartId = cartId;
                    Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
                    system.debug(LoggingLevel.INFO,'Response..'+response);
                    if(response.IsSuccess){
                        system.debug(LoggingLevel.INFO,'Finalize success');
                    }
                }
                catch(Exception ex){
                    system.debug(LoggingLevel.INFO,'Exception came : Finalize ...........'+ex);
                    //TRStoreLeadprocess.logTRSException('Finalize Cart Error', string.valueof(ex), 'Finalize Cart', cartID,'Product Configuration', 'Order Confirmation', supportEmail, true);
                    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'Finalize Cart Error'+string.valueof(ex),'webServiceName'=>'Quote Update','requestType'=>'Finalize Cart','reqMsg'=>'Exception Class Name: TRStore_TransactOrderSubmission','module'=>'UEStore','recId'=>cartID,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                    TRStore_ErrorHandler.logException(errorHandlerMap);
                }
                
            }
            
        }
    
        private Static map<String,Id> masterContact(Lead l,TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq){
            map<string,Id> billingIds = new Map<String,Id>();
            Id billTo;
            Id shipTo;
            Id soldTo;
            if(String.isNotBlank(l.convertedopportunity.Source_System_Detail__c)) {
                        
                billTo = l.convertedopportunity.Source_System_Detail__c; 
                soldTo = l.convertedopportunity.Source_System_Detail__c; 
                
            }
            if(l.TRstore_Billadd_differenceto_shipping__c || String.isNotBlank(l.convertedopportunity.ShipTo_Source_System_Detail__c)){
                shipTo = l.convertedopportunity.ShipTo_Source_System_Detail__c; 
                
            } else{
                shipTo = l.convertedopportunity.Source_System_Detail__c;  
            }
            billingIds.put('billTo',billTo);
            billingIds.put('shipTo',shipTo);
            billingIds.put('soldTo',soldTo);
            
            //Map online contacts with related quote 
            if(!l.Online_Contacts__r.isEmpty()){
                List<Online_Contacts__c> onlineContactsToUpdate = new List<Online_Contacts__c>();
                onlineContactsToUpdate.addAll(configOnlineContactsToQuote(l.Online_Contacts__r, orderReq.quoteId));
                
                
                if(!onlineContactsToUpdate.isempty()){
                    database.update(onlineContactsToUpdate, false);
                }    
            }
            // End of Map online contacts with related quote 
            
            //Map Master contacts with related quote            
            if(!l.Customer_Master_Contacts__r.isEmpty()){
                List<Customer_Master_Contacts__c> masterContactsToUpdate = new List<Customer_Master_Contacts__c>();
                masterContactsToUpdate.addAll(configMasterContactsToQuote(l.Customer_Master_Contacts__r, orderReq.quoteId));
                
                if(!masterContactsToUpdate.isempty()){
                    database.update(masterContactsToUpdate, false);
                }    
            } 
            return billingIds;
        }
        
        @testVisible
        private static Id oneTimeAddress(map<string,Id> billingIds){
            Address__c oneTime = new Address__c();
            List<Source_System_detail__c> shipTODetail = new List<Source_System_detail__c>();
            if (Schema.sObjectType.Source_system_detail__c.isAccessible() && String.isNotBlank(billingIds.get('shipTo')) && billingIds.get('billTo') != billingIds.get('shipTo')){
                shipTODetail = [SELECT Id,Name, Account_Name__c,Account__c,City__c,Number_Street__c,LCRM_Street_2__c,State__c,Country__c,Postal_Code__c,LCRM_Phone__c FROM Source_system_detail__c where Id = :billingIds.get('shipTo')];
                if(!shipToDetail.isEmpty()){
                    oneTime.Address_Type__c = 'One Time Ship To';
                    oneTime.Name = shipToDetail[0].Name;
                    oneTime.City__c = shipToDetail[0].city__c;
                    oneTime.State__c = shipToDetail[0].State__c;
                    oneTime.Street__c = shipToDetail[0].Number_Street__c;
                    oneTime.Street_Address_3__c = shipToDetail[0].LCRM_Street_2__c;
                    oneTime.Country__c = shipToDetail[0].Country__c;
                    oneTime.Zipcode__c = shipToDetail[0].Postal_code__c;
                    oneTime.AccountId__c = shipToDetail[0].Account_Name__c;
                    oneTime.Phone__c = shipToDetail[0].LCRM_Phone__c;
                    oneTime.Parent_Type__c = 'Account';
                    Database.insert(oneTime, false);
                }
            }
                return oneTime.Id;
        }
    
        private static map<string,string> checkNull(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq){
            map<string,String> idsMap = new map<String,String>();
            if(orderReq.leadId != null && String.isNotBlank(orderReq.leadId) && orderReq.cartId != null && String.isNotBlank(orderReq.cartId) && orderReq.quoteId != null && String.isNotBlank(orderReq.quoteId)){
                
                idsMap.put('leadId',orderReq.leadId);
                idsMap.put('cartId',orderReq.cartId);
                idsMap.put('quoteId',orderReq.quoteId);
            }
            return idsMap;
        }
        
    /********************************************************************************************************
        *  @description processTransactOrder : Method for mapping fields in Quote
        *  @param orderReq - input param (Order Request)
        *********************************************************************************************************/ 
         public static void processTransactOrder(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq) {
            
            List<Lead> leadDetails = new List<Lead>();
            List<Apttus_Proposal__Proposal__c> quoteDetails = new List<Apttus_Proposal__Proposal__c>();
            List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
            List<Apttus_config2__productconfiguration__c> configDetails = new List<Apttus_config2__productconfiguration__c>();
            List<Apttus_config2__productconfiguration__c> configList = new List<Apttus_config2__productconfiguration__c>();
    
            String opptyID = '';
            map<string,Id> billingIds = new Map<String,Id>(); 
            ID billTo;
            ID shipTo;
            ID oneTimeAddressId;
            String cartId = '';
            String quoteId = '';
            
            System.debug(LoggingLevel.Info, 'Inside Process Transact Order');
            
                Map<String,String> idsMap = checkNull(orderReq);
                if(!idsMap.isEmpty()){
                    String leadId;
                    leadId = idsMap.get('leadId');
                    cartId = idsMap.get('cartId');
                    quoteId = idsMap.get('quoteId');
                    String leadQuery = 'SELECT Id, Name,firstname, lastname, Email, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, Language_Preference__c, convertedopportunityId, convertedopportunity.name, convertedopportunity.Source_System_Detail__c,convertedopportunity.ShipTo_Source_System_Detail__c,TRstore_Billadd_differenceto_shipping__c,Lead_Region__c,(select id, name, Email__c, Last_Name__c FROM Online_Contacts__r), (Select id, name FROM Customer_Master_Contacts__r ) from Lead WHERE Id =:leadId AND Product_Configuration__c =:cartId AND isConverted=true' ;  
                    leadDetails = Database.Query(leadQuery);
                    String cartQuery = 'SELECT Id, Name, Apttus_QPConfig__Proposald__c,APTS_SSD_bill_to__c,APTS_SSD_ship_to__c,(select id, name, Email__c, Last_Name__c FROM Online_Contacts__r) FROM Apttus_config2__productconfiguration__c where id =: cartId';
                    configDetails = Database.Query(cartQuery);
                    String quoteQuery = 'SELECT Id, Name, APTS_One_Time_Ship_To__c,Apttus_Proposal__Opportunity__c, APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Primary_Contact__c,Apttus_Proposal__Account__c,APTS_SSD_bill_to__c, APTS_SSD_ship_to__c,APTS_SSD_Sold_To__c,APTS_Payment_Option__c,APTS_Ebilling_exempt__c,TR_Store_Source__c,APTS_Card_Type__c,APTS_Authorization_Number__c,APTS_Card_Expiration_Date__c,APTS_Credit_Card_Token__c,APTS_Authorization_Transaction__c,APTS_Ground_Shipping__c FROM Apttus_Proposal__Proposal__c WHERE Id =: quoteId';
                    quoteDetails = Database.Query(quoteQuery);
                }
                
            Boolean isLeadConverted = false;
            
            if(!leadDetails.isEmpty()) {
                for(Lead l : leadDetails){
                    isLeadConverted = l.isconverted;
                    opptyID = l.ConvertedOpportunityId;
                    billingIds = masterContact(l,orderReq);              
                    
                } 
                if(isLeadConverted && quoteDetails!=null && !configDetails.isEmpty()){ 
                    
                    oneTimeAddressId = oneTimeAddress(billingIds);
                        billTo = billingIds.get('billTo');
                        shipTo = billingIds.get('shipTo');
                        billingIds.put('oneTime',oneTimeAddressId);
                        proposalList = mapProposalDetails(billingIds,leadDetails, quoteDetails);
                        configList = mapConfigDetails(billTo, shipTo, configDetails);   
                        
                       
                        proposalList[0] = updateCardInfo(orderReq,proposalList[0]);
                    
                    System.debug(LoggingLevel.Info,'Updated proposal..........'+proposalList);
                    system.debug(LoggingLevel.Info,'Updated cart.........'+configList); 
                }
            }else{
                if(quoteDetails!=null) {
                    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>'lead is not converted','webServiceName'=>'Quote Update','requestType'=>'Quote Update','reqMsg'=>'Exception Class Name: TRStore_TransactOrderSubmission','module'=>'UEStore','recId'=>orderReq.quoteId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                    TRStore_ErrorHandler.logException(errorHandlerMap);
                }
            }
            
            updateProposal(proposalList,configList,quoteID);
            finalizeCart(cartID, quoteID);
        }
        
    /********************************************************************************************************
        *  @description submitTransactOrder : Method for calling submit Order
        *  @param proposalId - input param (quote Id)
        *********************************************************************************************************/ 
         public static void submitTransactOrder(Id proposalId){
            system.debug(LoggingLevel.INFO,'Submit order'+proposalId);
            if(proposalId != null){
                try{
                String orderResults =  APTS_ProposalUtilities.submitOrder(proposalId);  
                system.debug(LoggingLevel.INFO,'order results'+orderResults);
                }catch(Exception ex){
                    system.debug(LoggingLevel.INFO,'Exception came : Submit Order ...........'+ex);
                    //TRStoreLeadprocess.logTRSException('Submit Order Error', string.valueof(ex), 'Submit Order', proposalId, 'Quote/Proposal', 'Order Confirmation', supportEmail, true);
                    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>'Submit Order Error'+string.valueof(ex),'webServiceName'=>'Quote Update','requestType'=>'Finalize Cart','reqMsg'=>'Exception Class Name: TRStore_TransactOrderSubmission','module'=>'UEStore','recId'=>proposalId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                    TRStore_ErrorHandler.logException(errorHandlerMap);
                }
            }
            
        }
    
        private static Apttus_Proposal__Proposal__c updateCardInfo(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq,Apttus_Proposal__Proposal__c proposalList){
            if(orderReq.paymentOption == 'Credit Card') {
                proposalList = mapCardDetailsOnQuote(orderReq,proposalList);
            }
            else{
                //update 'Bill To Account' in payment option field on Quote
                proposalList.APTS_Payment_Option__c = 'Bill To Account';
            }
            return proposalList;
        }
    
        private static void updateProposal(List<Apttus_Proposal__Proposal__c> proposalList,List<Apttus_config2__productconfiguration__c> configList,String quoteID){
            List<Database.SaveResult> srConfig = new List<Database.SaveResult>();
            List<Database.SaveResult> srProposal = new List<Database.SaveResult>();
            if(!proposalList.isEmpty()){
                srProposal = database.update(proposalList);
            }
            for(Database.SaveResult sr : srProposal){
                if(sr.isSuccess()){
                    System.debug(LoggingLevel.Info,'proposal updated successfully');
                    if(!configList.isEmpty()) {
                        srConfig = database.update(configList);
                    }
                }else{
                    
                    for(Database.Error err : sr.getErrors()){
                        System.debug(LoggingLevel.Info,'proposal update error..........'+err.getStatusCode() + ': ' + err.getMessage());
                        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>'lead is not converted'+err.getMessage(),'webServiceName'=>'Quote Update','requestType'=>'Quote Update','reqMsg'=>'Exception Class Name: TRStore_TransactOrderSubmission','module'=>'UEStore','recId'=>quoteId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                        TRStore_ErrorHandler.logException(errorHandlerMap);
                    }
                }
            }
        }
        
        //Map online contacts with related quote
        /********************************************************************************************************
        *  @description configOnlineContactsToQuote : Method for online Contact
        *  @return List<Online_Contacts__c> - List of Online Contacts
        *  @param onlineContacts - input param (list of online Contacts)
        *  @param qId - input param (quote Id)
        *********************************************************************************************************/ 
        public static List<Online_Contacts__c> configOnlineContactsToQuote(List<Online_Contacts__c> onlineContacts, id qId){
            for(Online_Contacts__c oc: onlineContacts){
                oc.QuoteId__c = qId;
            }
            return onlineContacts;
        }
        
        
        //Map online contacts with related quote  
        /********************************************************************************************************
        *  @description configMasterContactsToQuote : Method for master online Contact
        *  @return List<Customer_Master_Contacts__c> - List of master Online Contacts
        *  @param masterContacts - input param (list of master online Contacts)
        *  @param qId - input param (quote Id)
        *********************************************************************************************************/   
        public static List<Customer_Master_Contacts__c> configMasterContactsToQuote(List<Customer_Master_Contacts__c> masterContacts, id qId){
            for(Customer_Master_Contacts__c oc: masterContacts){
                oc.Quote__c = qId;
            }
            return masterContacts;
         }
        
        private static Apttus_Proposal__Proposal__c mapCardDetailsOnQuote(TRStore_TransactOrderService.TRStore_TransactOrderRequestClass orderReq, Apttus_Proposal__Proposal__c quoteDetails) {
            system.debug(LoggingLevel.INFO,'inside map card');
            quoteDetails.APTS_Payment_Option__c = 'Credit Card';
            quoteDetails.APTS_Card_Type__c = orderReq.cardType;
            //quoteDetails.APTS_Authorization_Number__c = orderReq.authNumber;
            Integer month = integer.valueof(orderReq.cardExpiry.substring(0,2));
            Integer year = integer.valueof('20' + orderReq.cardExpiry.substring(2,4));
            Integer dayOfMonth = date.daysInMonth(year, month);
            quoteDetails.APTS_Card_Expiration_Date__c = Date.newInstance(year, month, dayOfMonth);
            quoteDetails.APTS_Credit_Card_Token__c = orderReq.cardToken;
            quoteDetails.APTS_Ground_Shipping__c = (String.isNotBlank(orderReq.shippingMethod) && (orderReq.shippingMethod=='06'))? 'International best Rate' : (String.isNotBlank(orderReq.shippingMethod) && (orderReq.shippingMethod=='07'))? 'International Expedited Rate' : 'International best Rate';
            //quoteDetails.APTS_Authorization_Transaction__c = orderReq.pnRefNum;
            return quoteDetails;
            
        }
     
     /********************************************************************************************************
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  repriceCart - This is a main method to reprice cart 
*  @return string   : this is a return statement after maniplate line items 
*  @param cartId - expected cart id for reprice cart 
*********************************************************************************************************/   
  private static String repriceCart(String cartId) {

    String isPending;
    Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
    objUpdatePriceRequestDO.CartId = cartId;
    Apttus_CpqApi.CPQ.UpdatePriceResponseDO result;
    try {
      result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
      isPending = string.valueOf(result.IsPricePending);
    } catch (Exception e) {
        if(cartId!=null){
              Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: TRStore_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        isPending = 'Reprice Exception';
    }
     
   return isPending;
  }   
    }