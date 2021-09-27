/* Class: DCPQuoteSyncUpHelper
* Purpose: This class contains business logic for DCPQuoteSyncUpController
* Created: 6/10/2021
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-06-10   Avudaiappan A   DCP-1695,2136   Insert Quote, Cart & Contact 26,28,30
* =============================================================================
*/
/** 
* @description : business logic used to sync the fields in Quote/Proposal to make it order readiness
*/

public with sharing class DCPQuoteSyncUpHelper {
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member

/********************************************************************************************************
* @description doDMLOverQuote: Method to map the fields which need to be updated on Product Configuration/Cart Record
*  @param proposalList - Quote details
*  @param configList -  cart Details 
*********************************************************************************************************/    

public static void doDMLOverQuote(LIST<Apttus_proposal__proposal__c> proposalList, LIST<Apttus_config2__productconfiguration__c> configList){
        
    LIST<Apttus_config2__productconfiguration__c> srConfig = new LIST<Apttus_config2__productconfiguration__c>();
        List< Database.SaveResult> srProposal = new LIST<Database.SaveResult>();
        
        Map<String,String> errorHandlerMap;
        try{
            
            if(!proposalList.isEmpty()){
                srProposal = database.update(proposalList);
            }
            for(Database.SaveResult sr : srProposal){
                if(sr.isSuccess()){
                    System.debug(LoggingLevel.Info,'proposal updated successfully');
                    if(!configList.isEmpty()){
                        srConfig.addAll(configList);
                    }
                    
                }else{
                    
                    for(Database.Error err : sr.getErrors()){
                        errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>err.getMessage(),'webServiceName'=>'UEUSL Quote Insert/Update','requestType'=>'UEUSL QuoteSync from Class DCPQuoteSyncUpHelper','reqMsg'=>err.getMessage(),'module'=>'UEStore','recId'=>sr.getId(),'supportEmail'=>supportEmail,'toSupport'=>'false'};
                        DCPQuoteSyncUpHelper.logExceptions(errorHandlerMap);                    
                    }
                }
            }
            doDMLonCart(srConfig);
            
        
        }
        
        catch(exception ex){
            errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>String.valueof(ex.getLineNumber())+','+ex.getMessage(),'webServiceName'=>'UEUSL Product Configuration Insert/Update','requestType'=>'UEUSL QuoteSync from Class DCPQuoteSyncUpHelper','reqMsg'=>ex.getStackTraceString(),'module'=>'UEStore','recId'=>'','supportEmail'=>supportEmail,'toSupport'=>'false'};
            DCPQuoteSyncUpHelper.logExceptions(errorHandlerMap);         
        }
    }
    
       /********************************************************************************************************
* @description logException: Upsert Exception
*  @param logMap
*********************************************************************************************************/ 
    public static void logExceptions(Map<String,String> logMap){
        if(logMap!=null){
            DCPNewSaleUtilityCls.logException(logMap);
        }
    }
   /********************************************************************************************************
* @description doDMLonCart: Upsert Quote/Cart
*  @param srConfig
*********************************************************************************************************/ 
    public static void doDMLonCart(LIST<Apttus_config2__productconfiguration__c> srConfig){
        
            if(!srConfig.isEmpty()){
                database.upsert(srConfig);
                System.debug(LoggingLevel.Info,'cart updated successfully');
            }/*else{
                for(Database.Error err : srCon.getErrors()){
                    System.debug(LoggingLevel.Info,'cart update error..........'+err.getStatusCode() + ': ' + err.getMessage());
                    //TRStoreLeadprocess.logTRSException('cart update error', err.getMessage(), 'Cart Update', cartID, 'Product Configuration', 'Order Confirmation', supportEmail, true);
                }
            }*/
        
    }
    
    /**
    *  mapMasterContact : this method is use to map the master contact
    *  @description  mapMasterContact - Map online master contact details  
    *  @param lId - Lead Id
    *  @param quoteId - Proposal Id
    **/
    public static void mapMasterContact(String lId, String quoteId){
            Lead l = [select id,FirstName,LastName,Email,Phone from Lead where Id =:lId WITH SECURITY_ENFORCED limit 1];
        	Customer_Master_Contacts__c cmc = new Customer_Master_Contacts__c();              
            cmc.First_Name__c = l.firstName;//olc.pFirstName;
            cmc.Last_Name__c = l.lastName;//olc.pLastName;
            cmc.Email_Address__c = l.Email; //olc.pEmail;
            cmc.Phone__c = l.Phone;
            cmc.Quote__c = (String.isNotBlank(quoteId))?quoteId:'';
            cmc.Lead__c = l.Id;
            cmc.Customer_Type_Description__c = 'AUTO PAYMENT PROCESS';
            database.insert(cmc);
        
    }

    /**
    *  configOnlineContactsToQuote : this method is use to map the online contact
    *  @description  configOnlineContactsToQuote - Map online contact details  
    *  @param onlineContacts - List of OnlineContacts
    *  @param qId - Proposal Id
    *  @return LIST<Online_Contacts__c> - List of onlineContacts
    **/
    public static list<Online_Contacts__c> configOnlineContactsToQuote(list<Online_Contacts__c> onlineContacts, String qId){
        for(Online_Contacts__c oc: onlineContacts){
            oc.QuoteId__c = qId;
        }
      return onlineContacts;
         
    }
    
    
    /**
    *  configMasterContactsToQuote : this method is use to map the master contact
    *  @description  configMasterContactsToQuote - Map master contact details  
    *  @param masterContacts - List of MasterContacts
    *  @param qId - Proposal Id
    *  @return LIST<Customer_Master_Contacts__c> - List of masterContacts
    **/

    public static list<Customer_Master_Contacts__c> configMasterContactsToQuote(list<Customer_Master_Contacts__c> masterContacts, String qId){
        
        for(Customer_Master_Contacts__c oc: masterContacts){
            oc.Quote__c = qId;
        }
        
      return masterContacts;
         
    } 
    
    


}