/* Class: DCPQuoteSyncUpController
* Purpose: This class will update the proposal following which the cart will be finalized 
* Created: 6/10/2021
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-06-10   Avudaiappan A   DCP-1695   Quote Sync up 
* =============================================================================
*/
/** 
* @description : used to sync the fields in Quote/Proposal to make it order readiness
*/
public with sharing class DCPQuoteSyncUpController {
    
    public Static String priceListNameUS = Static_Values__c.getValues('PriceListName').Value__c;//Fetch the name of PL :'Thomson Reuters Master - US Legal'
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    public Static String proposalId; 
        
    


/********************************************************************************************************
* @description mapConfigDetails: Method to map the fields which need to be updated on Product Configuration/Cart Record
*  @param billTo - SSD details
*  @param configInfo -  cart Details 
*  @return Product Configuration list
*********************************************************************************************************/  
    public static List<Apttus_config2__productconfiguration__c> mapConfigDetails(String billTo, List<Apttus_config2__productconfiguration__c> configInfo){
        if(!configInfo.isEmpty()){
            configInfo[0].APTS_SSD_bill_to__c = billTo;
        }
        return configInfo;
    }

    
/********************************************************************************************************
* @description processTRStoreOrder: Method to update the converted opportunity ID on proposal/quote along with other 
* fields. It also updates the cart/product configuration record as well with the billTo and shipTo fields.
* @param ptwd - DCPConvertLeadHelperTwo.ProcessTRStoreWrapperDetails
*********************************************************************************************************/ 
 
public static void processTRStoreOrder(DCPConvertLeadHelperTwo.ProcessTRStoreWrapperDetails ptwd){
    LIST<Lead> leadDetails = new LIST<Lead>();
    LIST<Apttus_Proposal__Proposal__c> quoteDetails = new LIST<Apttus_Proposal__Proposal__c>();
    LIST<Apttus_config2__productconfiguration__c> configDetails = new LIST<Apttus_config2__productconfiguration__c>();
    
    //Added by Kunal as part of DCP-4147
    ID quoteId = ID.valueOf(ptwd.quoteid);
    ID cartId = ID.valueOf(ptwd.cartid);
    ID leadId = ID.valueOf(ptwd.leadid);
    ID trialID;
    
    if(ptwd.trialid != ''){
    trialID = ID.valueOf(ptwd.trialid);}
    
    set<ID> setOFTrialId = new set<ID>();
    //Changes end here
    
    System.debug(LoggingLevel.Info, 'Inside Process TRS Order');            
    
    if(LeadId != null && String.isNotBlank(LeadId) && cartId != null && String.isNotBlank(cartId) && quoteId != null && String.isNotBlank(quoteId)){
        
        string leadQuery = 'SELECT Id, Name,firstname, lastname, Email, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId, convertedopportunity.name, convertedopportunity.Source_System_Detail__c,Lead_Region__c,phone,(select id, name, Email__c, Last_Name__c FROM Online_Contacts__r), (Select id, name FROM Customer_Master_Contacts__r ) from Lead WHERE Id =:leadId AND Product_Configuration__c =:cartId AND isConverted=true';  
        leadDetails = database.query(leadQuery);
        string configQuery = 'SELECT Id, Name, Apttus_QPConfig__Proposald__c,APTS_SSD_bill_to__c,(select id, name, Email__c, Last_Name__c FROM Online_Contacts__r) FROM Apttus_config2__productconfiguration__c where id =:cartId'; 
        configDetails = database.query(configQuery);
        string quoteQuery = 'SELECT Id, Name,Apttus_Proposal__Opportunity__c, APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Primary_Contact__c,Apttus_Proposal__Account__c,APTS_SSD_bill_to__c,APTS_SSD_Sold_To__c,APTS_SSD_Ship_to__c,APTS_Payment_Option__c,TR_Store_Source__c,APTS_Approval_Segment__c,Customer_Group__c,APTS_Customer_Pricing_Segment__c,Digital_Quote_Type__c,Apttus_QPConfig__BillToAccountId__c,Apttus_Proposal__Primary__c,Apttus_Proposal__ReadyToGenerate__c,APTS_Ebilling_exempt__c,DC_Contract_Not_In_Sync__c,Latam_APTS_Reason__c,APTS_Ebilling_contact__c,APTS_Count_of_NEW_Proposal_Line_Item__c,APTS_Boolean_Count_of_Online__c,APTS_Number_of_Bridged_ProFlex_BDL__c,APTS_Number_of_Non_Bridged_ProFlex_BDL__c,APTS_MasterContacts_Collected__c FROM Apttus_Proposal__Proposal__c WHERE Id =: quoteId';
        quoteDetails = database.query(quoteQuery);
        proposalId = quoteId;
        
        
        setOFTrialId.add(trialID);//Added by Kunal as part of DCP-4147
        
        
    }
    
    System.debug(LoggingLevel.Info,'List of Leads..........'+leadDetails);
    system.debug(LoggingLevel.Info,'List of Quotes.........'+quoteDetails);
    system.debug(LoggingLevel.Info,'List of Cart.........'+configDetails);
    
    //Following code should execute only if the above lead has converted 
    try{
        DCPQuoteSyncUpController.processQuote(leadDetails,quoteDetails,configDetails);
        DCPNewSaleUtilityCls.repriceCart(cartId);
        DCPNewSaleUtilityCls.finalizeCart(cartId);
        processTrialCoversion(setOFTrialId,leadDetails);//Added by Kunal as part of DCP-4147
        //DCPProcessDocusignController.dynamicBundle(proposalId);
        System.enqueueJob(new DCPDocusignDelayProcess(proposalId,'sendDoc'));

    }catch(Exception ex){
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>String.valueof(ex.getLineNumber())+','+ex.getMessage(),'webServiceName'=>'UEUSL QuoteSyncUp','requestType'=>'UEUSL QuoteSync from Class DCPQuoteSyncupController','reqMsg'=>ex.getStackTraceString(),'module'=>'UEStore','recId'=>quoteId,'supportEmail'=>supportEmail,'toSupport'=>'false'};
        DCPNewSaleUtilityCls.logException(errorHandlerMap);
    }
}
/********************************************************************************************************
* @description processQuote: Method to update the converted opportunity ID on proposal/quote along with other 
* fields. It also updates the cart/product configuration record as well with the billTo and shipTo fields.
*  @param leadDetails
*  @param quoteDetails
*  @param configDetails
*********************************************************************************************************/ 
    public static void processQuote(LIST<Lead> leadDetails,LIST<Apttus_Proposal__Proposal__c> quoteDetails,LIST<Apttus_config2__productconfiguration__c> configDetails){
        LIST<Apttus_config2__productconfiguration__c> configList = new LIST<Apttus_config2__productconfiguration__c>();
        LIST<Apttus_Proposal__Proposal__c> proposalList = new LIST<Apttus_Proposal__Proposal__c>();
        
        if(!leadDetails.isEmpty()){
            Map<String,String> stringArray = DCPQuoteSyncUpController.processLeadMap(leadDetails);
            if((!quoteDetails.isEmpty() && !configDetails.isEmpty())&&(stringArray.get('isConverted') == 'true')){
                proposalList = DCPProcessDocusignController.mapProposalDetails(stringArray.get('billTo'), leadDetails, quoteDetails);
                configList = mapConfigDetails(stringArray.get('billTo'), configDetails);   
                System.debug(LoggingLevel.Info,'Updated proposal..........'+proposalList);
                system.debug(LoggingLevel.Info,'Updated cart.........'+configList); 
            }
        DCPQuoteSyncUpHelper.doDMLOverQuote(proposalList,configList);
        }else{
            if(!quoteDetails.isEmpty()){
                TRStoreLeadprocess.logTRSException('proposal update error', 'lead is not converted', 'Quote Update', quoteDetails[0].id,'Quote/Proposal', 'Order Confirmation', supportEmail, true);
            }   
        }

        
        
    }
    /********************************************************************************************************
* @description processLeadMap: Method to update the online & Master COntact with Quote Info.
*  @param leadDetails
*  @return Map<String,String>
*********************************************************************************************************/ 
    public static Map<String,String> processLeadMap(List<Lead> leadDetails){
        Map<String,String> returnString = new Map<String,String>();
        Boolean isLeadConverted = false;
        ID billTo;
        //Map Master contacts with related quote
        lIST<Customer_Master_Contacts__c> masterContactsToUpdate = new lIST<Customer_Master_Contacts__c>();
        //Map online contacts with related quote
        lIST<Online_Contacts__c> onlineContactsToUpdate = new lIST<Online_Contacts__c>();
        String qId = proposalId;
        for(Lead l : leadDetails){
                 isLeadConverted = l.isconverted;
                 if(String.isNotBlank(l.convertedopportunity.Source_System_Detail__c)){
                    billTo = l.convertedopportunity.Source_System_Detail__c; 
                 }
               
            
            if(!l.Online_Contacts__r.isEmpty()){
                List<Online_Contacts__c> olcList = DCPQuoteSyncUpHelper.configOnlineContactsToQuote(l.Online_Contacts__r, qId);
                onlineContactsToUpdate.addAll(olcList);
            }
            
            // End of Map online contacts with related quote
            

            if(!l.Customer_Master_Contacts__r.isEmpty()){
                masterContactsToUpdate.addAll(DCPQuoteSyncUpHelper.configMasterContactsToQuote(l.Customer_Master_Contacts__r, qId));
            }
            
            // End of Map online contacts with related quote
             
                
                
            } 
            if(!masterContactsToUpdate.isempty()){
                database.update(masterContactsToUpdate, false);
            } 
            if(!onlineContactsToUpdate.isempty()){
                database.update(onlineContactsToUpdate, false);
            }
            returnString.put('isConverted',String.ValueOf(isLeadConverted));
            returnString.put('billTo',billTo);
            return returnString;
            
    }
    
        /********************************************************************************************************
        Added by Kunal as part of DCP-4147
* @description processTrialCoversion: Method to update the Enterprise Trial with convert adn opportunity ID.
* @param setOfTrialID
* @param leadDetails
*********************************************************************************************************/
    public static void processTrialCoversion(Set<ID> setOfTrialID,list<Lead> leadDetails){
        if(!setOfTrialID.isEmpty()){
        list<Ent_Trial__c> listOFTrialsToUpdate = new list<Ent_Trial__c>();
        for(Ent_Trial__c tempTrial : [SELECT ID,Lead__c ,Convert_to_Sale__c,Opportunity__c FROM Ent_Trial__c WHERE ID in  :setOfTrialID]){
            tempTrial.Convert_to_Sale__c = true;
            tempTrial.Opportunity__c = leadDetails[0].convertedopportunityId;
            listOFTrialsToUpdate.add(tempTrial);
        }
 
        if(!listOFTrialsToUpdate.isempty()){
           database.update(listOFTrialsToUpdate, false);
        }
      } 
    } 

   
}