/**
* @file name          : DCPLeadServiceProviewContactsHelper
* @description        : This class helper class for DCPLeadService class to handel the ProviewContacts
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 05/26/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 05/20/2021   Servendra Kumar    DCP-1631     Created 
* =============================================================================
**/
public with sharing class DCPLeadServiceProviewContactsHelper {
    
    public List<DCPLeadRequestHandler.OLCResponse> olcResult;
    public String supportEmail='';
    public string customerType = 'EML PSWD CONTACT';
    public DCPLeadRequestHandler.OLCResponse olcResp;
    public List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();
    public LIST<Customer_Master_Contacts__c> masterContacts = new LIST<Customer_Master_Contacts__c>();

    /**
    *  mapOnlineContacts : maps the online contacts and master contact.
    *  @description  mapOnlineContacts- this is the online contacts processing method  
    *  @param dcpOrder : it contaisn the lead request
    *  @param leadInfo : Existing lead details 
    *  @param refInfo : reference variables for olc
    * @return   List<DCPLeadRequestHandler.OLCResponse>
    *   
    **/
    public List<DCPLeadRequestHandler.OLCResponse> mapOnlineContacts(DCPLeadRequestHandler.DCPOrders dcpOrder,DCPLeadRequestHandler.DCPCustomerDetails leadInfo,DCPLeadRequestHandler.References refInfo){
        
        List<DCPLeadRequestHandler.OnlineContactsFieldsClass> olcInfo = dcpOrder.OrderDetails.entitlementContacts;
                
        olcResult = new List<DCPLeadRequestHandler.OLCResponse>();
                
        try{
            system.debug(LoggingLevel.INFO,'olcInfo: '+leadInfo.isOLCAvailalble+'     '+olcInfo);  
            if(leadInfo.isOLCAvailalble ){              
                if(!olcInfo.isEmpty() &&  String.isNotBlank(refInfo.leadId)){
                    olcResult = createOnlineContacts(olcInfo, refInfo, leadInfo); 
                }else{
                    olcResp = new DCPLeadRequestHandler.OLCResponse();  
                    olcResp.olcID =null;
                    olcResp.olcStatus= DCPNewSaleUtilityCls.failureStatus;
                    olcResp.olcStatusDetail = 'Error in processing onlinecontacts: Lead Id or Entitlement  contact is null';  
                    olcResp.olcEmailId=null ;
                    olcResult.add(olcResp);
                }
            }  
        }catch(exception e){
            system.debug(LoggingLevel.INFO,'Error in processing onlinecontacts'+e.getLineNumber()+'     '+e);
            
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Error in processing onlinecontacts'+string.valueOf(e)+': '+e.getLineNumber(),'webServiceName'=>'createNewLead','requestType'=>'Lead Creation','reqMsg'=>'Exception Class Name: DCPLeadServiceProviewContactsHelper','module'=>'UEStore','recId'=>refInfo.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            DCPNewSaleUtilityCls.logException(errorHandlerMap);
        }  
        return olcResult;
    }

    /**
    *  createOnlineContacts : creates online contacts for Proview products and update the same on cart(product configuration).
    *  @description  createOnlineContacts - Map online contact details  
    *  @param olcList : json to get online contacts 
    *  @param refInfo : reference info 
    *  @param custDetails : customer info 
    *  @return list of DCPLeadRequestHandler.OLCResponse 
    **/  

    public List<DCPLeadRequestHandler.OLCResponse> createOnlineContacts(List<DCPLeadRequestHandler.OnlineContactsFieldsClass> olcList, DCPLeadRequestHandler.References refInfo, DCPLeadRequestHandler.DCPCustomerDetails custDetails){
                
        List<DCPLeadRequestHandler.OLCResponse> olcResponseList = new List<DCPLeadRequestHandler.OLCResponse>();
                
        system.debug(LoggingLevel.Info,'olcList json data '+olcList);
        system.debug(LoggingLevel.Info,'refInfo.leadId '+refInfo.leadId); 
        
        
        if(Static_Values__c.getAll().containsKey('OlcCustomerType')){
            customerType = Static_Values__c.getValues('OlcCustomerType').value__c;
            system.debug(LoggingLevel.Info,'customerType '+customerType);
        }
        for(DCPLeadRequestHandler.OnlineContactsFieldsClass olc : olcList){
            mapOnlineContact(refInfo, olc);
            mapMasterContact(refInfo, olc, custDetails);
        }
        system.debug(LoggingLevel.Info,'List of OLCs'+onlineContactList);
        olcResponseList = insertOnlineContactsAndMasterContacts(custDetails,refInfo);
        
    
    return olcResponseList;
    } 

    /**
    *  mapOnlineContact : this method is use to map the online contact
    *  @description  mapOnlineContact - Map online contact details  
    *  @param refInfo : reference info 
    *  @param olc : customer info 
    **/  
    private void mapOnlineContact(DCPLeadRequestHandler.References refInfo, DCPLeadRequestHandler.OnlineContactsFieldsClass olc){
        
        for(DCPLeadRequestHandler.ProviewIds prids : olc.entitlementProducts){                
            Online_Contacts__c onlineContact = new Online_Contacts__c();         
            onlineContact.First_Name__c = olc.pFirstName;
            onlineContact.Last_Name__c = olc.pLastName;
            onlineContact.Email__c = olc.pEmail;
            onlineContact.WLEc_Juris__c = olc.jurisdiction;
            onlineContact.Position__c = olc.pPosition;                        
            onlineContact.Type__c = olc.pType;    
            onlineContact.Is_Banded_Product__c = True;//olc.isBandedProduct;
            onlineContact.Lead__c = refInfo.leadId;
            onlineContact.Product_Configuration__c = refInfo.cartId;
            onlineContact.Material__c = prids.productCode;
            if(String.isNotBlank(prids.productId)){
                onlineContact.ProductId__c = prids.productId;  
            }
            onlineContact.Sftwr_Admin__c = olc.isAdmin;
            /*  code for quote id and contact id
            if(String.isNotBlank(olc.quoteId)){
                onlineContact.QuoteId__c = olc.quoteId;  
            }
            if(String.isNotBlank(olc.contactId)){
                onlineContact.Contact_Name__c = olc.contactId;  
            }     */ 
            if((olc.entitlementId == null || olc.entitlementId == '') &&  olc.pEmail != null ){
                onlineContactList.add(onlineContact);
            }else{
                onlineContact.id = olc.entitlementId;
                onlineContactList.add(onlineContact);
            }        
        }
    }

    /**
    *  mapMasterContact : this method is use to map the master contact
    *  @description  mapMasterContact - Map online master contact details  
    *  @param refInfo : reference info 
    *  @param olc : customer info 
    *  @param leadInfo
    **/
    private void mapMasterContact(DCPLeadRequestHandler.References refInfo, DCPLeadRequestHandler.OnlineContactsFieldsClass olc, DCPLeadRequestHandler.DCPCustomerDetails leadInfo){
        for(DCPLeadRequestHandler.ProviewIds prids : olc.entitlementProducts){             
            Customer_Master_Contacts__c cmc = new Customer_Master_Contacts__c();    
            if(olc.isAdmin){
                cmc.First_Name__c = olc.pFirstName;
                cmc.Last_Name__c = olc.pLastName;
                cmc.Email_Address__c = olc.pEmail;
                cmc.Lead__c = refInfo.leadId;
                cmc.Material__c = prids.productCode;
                cmc.Customer_Type_Description__c = customerType;
            }else{
                cmc.First_Name__c = leadInfo.firstName;
                cmc.Last_Name__c = leadInfo.lastName;
                cmc.Email_Address__c = leadInfo.businessEmail;
                cmc.Lead__c = refInfo.leadId;
                cmc.Material__c = prids.productCode;
                cmc.Customer_Type_Description__c = customerType;
            }       
            
            /*  code for quote id and contact id
            if(String.isNotBlank(olc.quoteId)){
                cmc.Quote__c = olc.quoteId;  
            }
            if(String.isNotBlank(olc.contactId)){
                cmc.Contact__c = olc.contactId;  
            }*/ 
            
            if(olc.pEmail != null){
                masterContacts.add(cmc);
            } 
        }
    }

    /**
    *  insertOnlineContactsAndMasterContacts : Method to insert the OLC amd Master contacts in SFDC .
    *  @description  insertOnlineContactsAndMasterContacts - insert online contacts and master contacts  
    *  @param custDetails : json to get online contacts 
    *  @param refInfo : reference info 
    *  @return list of DCPLeadRequestHandler.OLCResponse 
    **/
    private List<DCPLeadRequestHandler.OLCResponse> insertOnlineContactsAndMasterContacts(DCPLeadRequestHandler.DCPCustomerDetails custDetails,DCPLeadRequestHandler.References refInfo){
        List<DCPLeadRequestHandler.OLCResponse> olcRespList = new List<DCPLeadRequestHandler.OLCResponse>();
        if(!onlineContactList.isEmpty() && custDetails.isOLCAvailalble){               
            List< Database.UpsertResult> insertolc = new LIST<Database.UpsertResult>();
            List< Database.saveResult> insertmasterres = new LIST<Database.saveResult>();
            
            try{            
                if(refInfo.leadId != null  && !masterContacts.isEmpty()){
                    deleteRecords(refInfo.leadId);
                }                
                
                insertolc = database.upsert(onlineContactList, false); 
                insertmasterres = database.insert(masterContacts, false); 
            }catch(exception e){
                system.debug(LoggingLevel.INFO,'Exception came...........'+e);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of OLC'+string.valueOf(e),'webServiceName'=>'OLC Create','requestType'=>'Lead Creation','reqMsg'=>'Exception Class Name: DCPLeadServiceProviewContactsHelper','module'=>'TRStore','recId'=>refInfo.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                DCPNewSaleUtilityCls.logException(errorHandlerMap);
            }
            system.debug(LoggingLevel.Info,'Create OLC Result..........'+insertolc);

            olcRespList = mapOLCResponse(insertolc,onlineContactList);
                
        }
        return olcRespList;
    }

    /**
    *  mapOLCResponse : Methodto map the OLC response in service .
    *  @description  mapOLCResponse  -  map olc response  
    *  @param insertolc : upsert results 
    *  @param onlineContactList : online contacts list
    *  @return list of DCPLeadRequestHandler.OLCResponse resp
    **/
    private List<DCPLeadRequestHandler.OLCResponse> mapOLCResponse(List< Database.UpsertResult> insertolc,List<Online_Contacts__c> onlineContactList){
        List<DCPLeadRequestHandler.OLCResponse> olcResList = new List<DCPLeadRequestHandler.OLCResponse>();
        integer recNum = 0; 
        for(Database.UpsertResult upResult : insertolc){
            olcResp = new DCPLeadRequestHandler.OLCResponse();                 
            if(upResult.isSuccess()){
                olcResp.olcID = upResult.getId();
                olcResp.olcStatus= DCPNewSaleUtilityCls.successStatus;
                if(onlineContactList.size() >= (recNum + 1)){
                    olcResp.olcEmailId = onlineContactList[recNum].Email__c ;   
                    olcResp.productCode = onlineContactList[recNum].Material__c;
                }   
            }
            else{
                olcResp.olcID =null;
                olcResp.olcStatus= DCPNewSaleUtilityCls.failureStatus;
                olcResp.olcStatusDetail = string.valueOf(upResult.getErrors());
                olcResp.olcStatusDetail = handleDatabaseError(upResult.getErrors());                     
                if(onlineContactList.size() >= (recNum + 1)){
                    olcResp.olcEmailId= onlineContactList[recNum].Email__c ; 
                }     
            }
            ++recNum;
            olcResList.add(olcResp);
        } 
        return olcResList;
    }

    /**
    *  handleDatabaseError : Method to handle the error codes
    *  @description  handleDatabaseError  -  handle error codes  
    *  @param upResult : Database Error
    *  @return string
    **/
    private string handleDatabaseError(list<Database.Error> upResult){
        string statusDetails;
        for(Database.Error de: upResult){
            if( de.getStatusCode() != null){                                
                statusDetails = string.valueOf(de.getStatusCode()) +' '+de.getMessage();
            }  
        } 
        return statusDetails;
    }

    /**
    *  DeleteMasterContacts : Method to delete master contacts .
    *  @description  deleteRecords  -  delete the existing master contacts 
    *  @param lids  : lead ids 
    *   
    **/  
    public static void deleteRecords(id lids){
        LIST<Customer_Master_Contacts__c > masterContactsDel = new LIST<Customer_Master_Contacts__c >();
        
        if(Schema.sObjectType.Customer_Master_Contacts__c.isAccessible()){
            masterContactsDel = [ Select id, name FROM Customer_Master_Contacts__c WHERE  Lead__c =: lids AND  Lead__c != null];       
        
            Database.delete(masterContactsDel , false);
        }
    }
}