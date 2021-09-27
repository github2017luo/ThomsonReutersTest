/* Class: TRStore_OrderSubmission
* Purpose: This class will update the proposal following which the cart will be finalized and an order will be placed
* Created: 6/24/2019
* Author: Ameeta Antonio
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2019-06-24   Ameeta Antonio   DLT-16334   Order Creation 
* 2020-01-16   Kanishk Singhvi  DLT-19076  Quote Validations. Update integration logger
* =============================================================================
*/
public with sharing class TRStore_OrderSubmission {
    
    public Static String priceListNameUS = Static_Values__c.getValues('PriceListName').Value__c;//Fetch the name of PL :'Thomson Reuters Master - US Legal'
    public Static String priceListNameCA = Static_Values__c.getValues('TRStorePricelistCA').Value__c;//Fetch the name of Canada price List
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    public Static String quoteID = ''; 
        
    
/********************************************************************************************************
* mapProposalDetails: Method to map the fields which need to be updated on Proposal Record
*  @input billTo,ShipTo,soldTo,Lead Details,Quote Details @returns proposal list
*********************************************************************************************************/    
    public static List<Apttus_Proposal__Proposal__c> mapProposalDetails(String billTo, String shipTo, String soldTo, List<Lead> leadInfo, List<Apttus_Proposal__Proposal__c> quoteInfo, String oneTime){
        LIST<Apttus_Proposal__Proposal__c> proposalList = new LIST<Apttus_Proposal__Proposal__c>();
        String priceListName;
        if(!leadInfo.isEmpty() && !quoteInfo.isEmpty()){
        priceListName = (leadInfo[0].Lead_Region__c=='TR Store Canada Print')? priceListNameCA : priceListNameUS ;
        List<Apttus_Config2__PriceList__c> priceListDetails = [SELECT id,Name FROM Apttus_Config2__PriceList__c WHERE name =: priceListName LIMIT 1];
            for(Lead lead : leadInfo){
                
                    quoteID = quoteInfo[0].id;
                    quoteInfo[0].Apttus_Proposal__Opportunity__c = lead.ConvertedOpportunityId;
                    quoteInfo[0].Apttus_Proposal__Account__c = lead.convertedAccountid;
                    quoteInfo[0].APTS_Order_Confirmation_Contact__c = lead.ConvertedContactId;
                    quoteInfo[0].Apttus_Proposal__Primary_Contact__c = lead.ConvertedContactId;
                    quoteInfo[0].APTS_Ebilling_exempt__c = true;
                    quoteInfo[0].TR_Store_Source__c = lead.Lead_Region__c;
                    if(priceListDetails != null && priceListDetails.size() > 0){
                        for(Apttus_Config2__PriceList__c pl : priceListDetails){
                            quoteInfo[0].Apttus_QPConfig__PriceListId__c = pl.id;
                        }
                    }
                    
                    quoteInfo[0].APTS_SSD_bill_to__c = billTo;
                    quoteInfo[0].APTS_SSD_ship_to__c = shipTo;
                    if(billTo!=shipTo && String.isNotBlank(oneTime)){
                        quoteInfo[0].APTS_One_Time_Ship_To__c = oneTime;
                    }
                    quoteInfo[0].APTS_SSD_Sold_To__c = soldTo;
                    if(String.isEmpty(quoteInfo[0].APTS_Payment_Option__c)){
                      quoteInfo[0].APTS_Payment_Option__c = 'Bill to Account';  
                    }
                    
                    //proposalList.add(quoteInfo);
                
            }                
        }
        
        return quoteInfo;
    }


/********************************************************************************************************
* mapConfigDetails: Method to map the fields which need to be updated on Product Configuration/Cart Record
*  @input billTo,ShipTo,soldTo,Configuration Details @returns Product Configuration list
*********************************************************************************************************/  
    public static List<Apttus_config2__productconfiguration__c> mapConfigDetails(String billTo, String shipTo, String soldTo, List<Apttus_config2__productconfiguration__c> configInfo){
        LIST<Apttus_config2__productconfiguration__c> configList = new LIST<Apttus_config2__productconfiguration__c>();
        if(!configInfo.isEmpty()){
            
                configInfo[0].APTS_SSD_bill_to__c = billTo;
                configInfo[0].APTS_SSD_ship_to__c = shipTo;
                //config.APTS_SSD_Sold_To__c = soldTo;
                //configList.add(configInfo);
                            
        }
        return configInfo;
    }

/********************************************************************************************************
* finalizeCart: This method will finalize the Product Configuration/Cart Record
*  @input cart ID,quote ID
*********************************************************************************************************/ 
    public static void finalizeCart(Id cartId, Id quoteId){
        system.debug(LoggingLevel.INFO,'cart id..'+cartId);
        if(cartId != null){
            try{
                Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
                system.debug(LoggingLevel.INFO,'Requestcart..'+request);
                request.CartId = cartId;
                Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
                system.debug(LoggingLevel.INFO,'Response..'+response);
                if(response.IsSuccess){
                    system.debug(LoggingLevel.INFO,'Finalize success');
                    //submitTRStoreOrder(quoteId);
                }
                
            }
            catch(Exception ex){
                system.debug(LoggingLevel.INFO,'Exception came : Finalize ...........'+ex);
                TRStoreLeadprocess.logTRSException('Finalize Cart Error', string.valueof(ex), 'Finalize Cart', cartID,'Product Configuration', 'Order Confirmation', supportEmail, true);
            }
            
        }
        
    }
    
/********************************************************************************************************
* submitTRStoreOrder: This method will submit the order with the proposal ID
*  @input proposal ID
*********************************************************************************************************/     
    public static void submitTRStoreOrder(Id proposalId){
        system.debug(LoggingLevel.INFO,'Submit order'+proposalId);
        if(proposalId != null){
            try{
            String orderResults =  APTS_ProposalUtilities.submitOrder(proposalId);  
            system.debug('order results'+orderResults);
            }catch(Exception ex){
                system.debug(LoggingLevel.INFO,'Exception came : Submit Order ...........'+ex);
                TRStoreLeadprocess.logTRSException('Submit Order Error', string.valueof(ex), 'Submit Order', proposalId, 'Quote/Proposal', 'Order Confirmation', supportEmail, true);
            }
        }
        
    }
    
    
/********************************************************************************************************
* ProcessTRStoreOrder: Method to update the converted opportunity ID on proposal/quote along with other 
* fields. It also updates the cart/product configuration record as well with the billTo and shipTo fields.
*  @input quoteId,CartId, leadId
*********************************************************************************************************/ 
    public static void ProcessTRStoreOrder(string quoteId, string CartId, string leadId){
        LIST<Lead> leadDetails = new LIST<Lead>();
        LIST<Opportunity> oppList = new LIST<Opportunity>();
        LIST<Apttus_Proposal__Proposal__c> quoteDetails = new LIST<Apttus_Proposal__Proposal__c>();
        LIST<Source_System_detail__c> shipTODetail = new LIST<Source_System_detail__c>();
        LIST<Apttus_Proposal__Proposal__c> proposalList = new LIST<Apttus_Proposal__Proposal__c>();
        LIST<Apttus_config2__productconfiguration__c> configDetails = new LIST<Apttus_config2__productconfiguration__c>();
        LIST<Apttus_config2__productconfiguration__c> configList = new LIST<Apttus_config2__productconfiguration__c>();
        Address__c oneTime = new Address__c();
        Boolean isConvert = false;
        String opptyID = '';
        ID billTo;
        ID shipTo;
        ID soldTo;
       // String cartID = '';

        System.debug(LoggingLevel.Info, 'Inside Process TRS Order');            
        
        if(LeadId != null && String.isNotBlank(LeadId) && cartId != null && String.isNotBlank(cartId) && QuoteId != null && String.isNotBlank(QuoteId)){
            if (Schema.sObjectType.Lead.isAccessible()){
              leadDetails = [SELECT Id, Name,firstname, lastname, Email, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId, convertedopportunity.name, convertedopportunity.Source_System_Detail__c,convertedopportunity.ShipTo_Source_System_Detail__c,TRstore_Billadd_differenceto_shipping__c,Lead_Region__c,
                  (select id, name, Email__c, Last_Name__c FROM Online_Contacts__r), (Select id, name FROM Customer_Master_Contacts__r ) from Lead WHERE Id =: LeadId AND Product_Configuration__c =: cartId AND isConverted=true] ;  
            }
            if (Schema.sObjectType.Apttus_config2__productconfiguration__c.isAccessible()){
               configDetails = [SELECT Id, Name, Apttus_QPConfig__Proposald__c,APTS_SSD_bill_to__c,APTS_SSD_ship_to__c, 
                                  (select id, name, Email__c, Last_Name__c FROM Online_Contacts__r) FROM Apttus_config2__productconfiguration__c where id =: cartId]; 
            }
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
               quoteDetails = [SELECT Id, Name, APTS_One_Time_Ship_To__c,Apttus_Proposal__Opportunity__c, APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Primary_Contact__c,Apttus_Proposal__Account__c,APTS_SSD_bill_to__c, APTS_SSD_ship_to__c,APTS_SSD_Sold_To__c,APTS_Payment_Option__c,APTS_Ebilling_exempt__c,TR_Store_Source__c FROM Apttus_Proposal__Proposal__c WHERE Id =: QuoteId];
            }
            
            
        }
        
        System.debug(LoggingLevel.Info,'List of Leads..........'+leadDetails);
        system.debug(LoggingLevel.Info,'List of Quotes.........'+quoteDetails);
        system.debug(LoggingLevel.Info,'List of Cart.........'+configDetails);
        
        //Following code should execute only if the above lead has converted 
        Boolean isLeadConverted = false;
        
        if(!leadDetails.isEmpty()){
            for(Lead l : leadDetails){
                 isLeadConverted = l.isconverted;
                 opptyID = l.ConvertedOpportunityId;
                 if(String.isNotBlank(l.convertedopportunity.Source_System_Detail__c)){
        
                     billTo = l.convertedopportunity.Source_System_Detail__c; 
                     soldTo = l.convertedopportunity.Source_System_Detail__c; 
                     
                 }
                if(l.TRstore_Billadd_differenceto_shipping__c || String.isNotBlank(l.convertedopportunity.ShipTo_Source_System_Detail__c)){
                     shipTo = l.convertedopportunity.ShipTo_Source_System_Detail__c; 
                    
                } else{
                     shipTo = l.convertedopportunity.Source_System_Detail__c;  
                }
                
                
            //Map online contacts with related quote DLT-19074 & DLT-19147
            if(!l.Online_Contacts__r.isEmpty()){
                lIST<Online_Contacts__c> onlineContactsToUpdate = new lIST<Online_Contacts__c>();
                
                if(!l.Online_Contacts__r.isempty()){
                   onlineContactsToUpdate.addAll(configOnlineContactsToQuote(l.Online_Contacts__r, quoteId));
                }
                 
                if(!onlineContactsToUpdate.isempty()){
                    database.update(onlineContactsToUpdate, false);
                }    
            }
            // End of Map online contacts with related quote DLT-19074 & DLT-19147
            
            //Map Master contacts with related quote DLT-19626
            
            if(!l.Customer_Master_Contacts__r.isEmpty()){
                lIST<Customer_Master_Contacts__c> masterContactsToUpdate = new lIST<Customer_Master_Contacts__c>();
                
                if(!l.Customer_Master_Contacts__r.isempty()){
                   masterContactsToUpdate.addAll(configMasterContactsToQuote(l.Customer_Master_Contacts__r, quoteId));
                }
                 
                if(!masterContactsToUpdate.isempty()){
                    database.update(masterContactsToUpdate, false);
                }    
            }
            // End of Map online contacts with related quote DLT-19074 & DLT-19147
             
                
                
            } 
        if(isLeadConverted){ 
            if(!quoteDetails.isEmpty() && !configDetails.isEmpty()){
               if (Schema.sObjectType.Source_system_detail__c.isAccessible() && String.isNotBlank(shipTo) && BillTo != ShipTo){
                    shipTODetail = [SELECT Id,Name, Account_Name__c,Account__c,City__c,Number_Street__c,LCRM_Street_2__c,State__c,Country__c,Postal_Code__c,LCRM_Phone__c FROM source_system_detail__c where Id = :shipTo];
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
                        insert oneTime;
                    }
               }
                proposalList = mapProposalDetails(billTo, shipTo, soldTo, leadDetails, quoteDetails,oneTime.Id);
                configList = mapConfigDetails(billTo, shipTo, soldTo, configDetails);   
               
            }
        
          System.debug(LoggingLevel.Info,'Updated proposal..........'+proposalList);
          system.debug(LoggingLevel.Info,'Updated cart.........'+configList); 
        }
        }else{
            if(!quoteDetails.isEmpty())
            TRStoreLeadprocess.logTRSException('proposal update error', 'lead is not converted', 'Quote Update', quoteDetails[0].id,'Quote/Proposal', 'Order Confirmation', supportEmail, true);
        }
        
        List< Database.SaveResult> srConfig = new LIST<Database.SaveResult>();
        List< Database.SaveResult> srProposal = new LIST<Database.SaveResult>();
        LIST<Database.saveResult> srOnlineContacts = new LIST<Database.saveResult>();
        
        
        try{
             /*   
            //Map online contacts with related quote DLT-19074 & DLT-19147
            if(!configList.isEmpty()){
                lIST<Online_Contacts__c> onlineContactsToUpdate = new lIST<Online_Contacts__c>();
                
                for(Apttus_config2__productconfiguration__c  cf: configList){
                    if(!cf.Online_Contacts__r.isempty()){
                       onlineContactsToUpdate.addAll(configOnlineContactsToQuote(cf.Online_Contacts__r, quoteId));
                    }
                }
                
                if(!onlineContactsToUpdate.isempty()){
                    database.update(onlineContactsToUpdate, false);
                }    
            }
            // End of Map online contacts with related quote DLT-19074 & DLT-19147
          */   
            
            if(!proposalList.isEmpty()){
                srProposal = database.update(proposalList);
            }
            for(Database.SaveResult sr : srProposal){
                if(sr.isSuccess()){
                    System.debug(LoggingLevel.Info,'proposal updated successfully');
                    if(!configList.isEmpty())
                        srConfig = database.update(configList);
                    
                }else{
                    
                    for(Database.Error err : sr.getErrors()){
                        System.debug(LoggingLevel.Info,'proposal update error..........'+err.getStatusCode() + ': ' + err.getMessage());
                        TRStoreLeadprocess.logTRSException('proposal update error', err.getMessage(), 'Quote Update', quoteID, 'Quote/Proposal', 'Order Confirmation', supportEmail, true);
                    }
                }
            }
            for(Database.SaveResult srCon : srConfig){
                if(srCon.isSuccess()){
                    System.debug(LoggingLevel.Info,'cart updated successfully');
                    if(!configDetails.isEmpty()){
                        for(Apttus_config2__productconfiguration__c cart : configDetails){
                           // cartID = cart.id; commented by Mallik
                        }                       
                    }
                    
                }else{
                    for(Database.Error err : srCon.getErrors()){
                        System.debug(LoggingLevel.Info,'cart update error..........'+err.getStatusCode() + ': ' + err.getMessage());
                        TRStoreLeadprocess.logTRSException('cart update error', err.getMessage(), 'Cart Update', cartID, 'Product Configuration', 'Order Confirmation', supportEmail, true);
                    }
                }
            }
            finalizeCart(cartID, quoteID);
        
        }
        
        catch(exception e){
            system.debug(LoggingLevel.INFO,'Exception came : Config ...........'+e);
            TRStoreLeadprocess.logTRSException('Finalize Cart Error', string.valueof(e), 'Cart Finalization', cartID,'Product Configuration', 'Order Confirmation', supportEmail, true);
        }
    }
    
    //Map online contacts with related quote DLT-19074 & DLT-19147
    public static LIST<Online_Contacts__c> configOnlineContactsToQuote(lIST<Online_Contacts__c> onlineContacts, id qId){
        
        for(Online_Contacts__c oc: onlineContacts){
            oc.QuoteId__c = qId;
        }
        
      return onlineContacts;
         
    }
    
    
    //Map online contacts with related quote DLT-19626

    public static LIST<Customer_Master_Contacts__c> configMasterContactsToQuote(lIST<Customer_Master_Contacts__c> masterContacts, id qId){
        
        for(Customer_Master_Contacts__c oc: masterContacts){
            oc.Quote__c = qId;
        }
        
      return masterContacts;
         
    }

}