/********************************************************************************
Class Name : DCPOnlineContactManager 
@description : This code is used in online contacts manage
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
14-07-2021                      Dinesh            DCP-2598 | Initial Creation
*********************************************************************************/ 
@RestResource(urlMapping='/digital/onlinecontacts/*')
@suppresswarnings('pmd.apexCRUDViolation')
Global without sharing class DCPOnlineContactManager {
    
    private static Final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static Final String CART_STATUS_FINALIZED = 'Finalized';
    private static Final String PRODUCT_PRICING_MODEL_BANDED = 'Banded';
    private static final string PRODUCT_BUNDLE_CONFIG_TYPE = 'Bundle';    
    
    @HttpGet
    /**
    @description for addOnlineContacts
    @param RestContext.request 
    @return returns for response
    */
    global static OLCResponse getOnlinecontacts(){
        RestRequest req = RestContext.request;
        OLCResponse response = new OLCResponse();
        try{
            //Calls main logic to get response data.
            response.data = DCPOnlineContactsController.retrieveOnlineContacts(req.params);
            response.status = 'Success';
            response.code = 200;
        }
        catch(Exception ex){    
            //If any exceptions are thrown, fail the request and provide exception message.
            response.status = 'Failed';
            response.code = 400;
            response.message = ex.getMessage();
        }

        //Return response to the request.
        System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(response));
        return response;
    }
    
    
    
    @HttpPost
    /**
    @description for addOnlineContacts
    @param updateDetails 
    @return returns for response
    */
    global static DCPServiceResponse addOnlineContacts(OLCRequest updateDetails){
        DCPServiceResponse response = new DCPServiceResponse();
        System.debug(LoggingLevel.WARN,'----Inside addRemoveOnlineContacts----updateDetails -----------'+ updateDetails);
        if(updateDetails == null){
            response.code = 400;
            response.response = 'Invalid Parameters';
            response.status = 'Error';
            return response;
        }
        try{
            if(String.isNotBlank(updateDetails.operationType)){
                if(updateDetails.operationType == 'create'){
                    response = createOnlineContacts(updateDetails);
                }
                else if(updateDetails.operationType == 'delete'){
                    response = deleteOnlineContacts(updateDetails);
                }
               
            }
            else{
                response.code = 400;
                response.response = 'Invalid operation type';
                response.status = 'Error';
                return response;
            }
            
            return response;
            
        }catch(Exception ex){
            response.code = 400;
            response.response = ex.getMessage();
            response.status = 'Error';
            DCUtils.trackLog(ex,'DCPOnlineContactManager','addOnlineContacts');
            return response;
        }
    }
    
    private static DCPServiceResponse createOnlineContacts(OLCRequest updateDetails){
        set<string> setProdIDs = new set<string>();
        //set<string> setBundleProds = new set<string>();
        map<id, string> mapProdServ = new map<id, string>();
        list<Product2> lstProducts = new list<Product2>();
        list<Apttus_Proposal__Proposal_Line_Item__c> lstQuoteLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        DCPServiceResponse response = new DCPServiceResponse();
        
            System.debug(LoggingLevel.WARN,'----Inside updateOnlineContacts----updateDetails -----------'+ updateDetails);
            if (String.isNotBlank(updateDetails.quoteId) && updateDetails.productDetails != null) { //String.isNotBlank(updateDetails.materialNumber)){
                
                List<Online_Contacts__c> onlineContactInsert = new List<Online_Contacts__c>();
                List<OnlineContacts> wrapList = new List<OnlineContacts>();
                
                wrapList.addAll(updateDetails.onlineContacts);
                System.debug(LoggingLevel.WARN,'wrapList------------  '+ wrapList);
                
                  
                // get a list of Product ids to select all products - updated per
                           setProdIDs=  getProdIDs(updateDetails);
             
                System.debug(LoggingLevel.WARN,'prodIds: ' + setProdIDs);
                // Add Configuration Type to query - updated per 
                lstProducts = [Select Id, ProductCode, APTS_Product_Pricing_Model__c, Apttus_Config2__ConfigurationType__c 
                               FROM Product2 
                               WHERE Id in : setProdIDs WITH SECURITY_ENFORCED];  //ProductCode =: updateDetails.materialNumber 
                System.debug(LoggingLevel.WARN,'lstProducts: ' + lstProducts);
               
               
                
                        lstQuoteLineItems = [Select Id, Apttus_Proposal__Product__c, APTS_Service_Number_Override__c 
                                             FROM Apttus_Proposal__Proposal_Line_Item__c 
                                             WHERE Apttus_Proposal__Proposal__c =:updateDetails.quoteId and
                                             APTS_Service_Number_Override__c != null WITH SECURITY_ENFORCED];
                
               mapProdServ= getMapProdServ(lstQuoteLineItems);
            

                Apttus_Proposal__Proposal__c proposal = [Select Id, APTS_SSD_Sold_To__c FROM Apttus_Proposal__Proposal__c WHERE Id =:updateDetails.quoteId WITH SECURITY_ENFORCED  LIMIT 1];
                               
                // for each product, create oline contacts
                ProposalDetails proposalDetails = new ProposalDetails();
                proposalDetails.mapProdServ=mapProdServ;
                proposalDetails.proposal=proposal;
               onlineContactInsert = getListProducts(lstProducts,wrapList,proposalDetails);
              
                
                System.debug(LoggingLevel.WARN,'onlineContactInsert ----'+ onlineContactInsert);
                if(!onlineContactInsert.isEmpty() && Schema.SObjectType.Online_Contacts__c.isCreateable()) {
                   
                        insert onlineContactInsert;
                        response.code = 200;
                        response.response = 'Success';
                        response.status = 'Ok';
                   
                }
            }else{
                response.code = 400;
                response.response = 'No Online Contacts to create.';
                response.status = 'Error';
            }
            return response;
    }
    
    
    private static DCPServiceResponse deleteOnlineContacts(OLCRequest updateDetails){
  		DCPServiceResponse response = new DCPServiceResponse();
        System.debug(LoggingLevel.WARN,'----Inside updateOnlineContacts----updateDetails -----------'+ updateDetails);
        if (String.isNotBlank(updateDetails.quoteId)) {
            
            
            if(!updateDetails.onlineContacts.isEmpty()){
                Set<String> extContactIdSet = new Set<String>();
                extContactIdSet= getExtContactIdSet(updateDetails);
                
                
                List<Online_Contacts__c> onlineContactList = [SELECT Id, Name, Account__c, Email__c, ContactID__c, First_Name__c, Is_Banded_Product__c, Last_Name__c, Material__c, ProductId__c, Middle_Name__c, QuoteId__c, QuoteLineItem__c, SAP_Account_Number__c, Account_Address__c, WLEc_Juris__c, Type__c, Sftwr_Admin__c, Product_Attribute__c 
                                                              FROM Online_Contacts__c 
                                                              WHERE QuoteId__c =: updateDetails.quoteId AND ContactId__c IN : extContactIdSet WITH SECURITY_ENFORCED];
                
                System.debug(LoggingLevel.WARN,'Existing onlineContactList to be deleted -----------'+ onlineContactList);
                response =deleteContacts(onlineContactList);
                
            }else{
                response.code = 400;
                response.response = 'No Online Contacts to delete.';
                response.status = 'Error';
            }
        }
        return response;
    }
    
    /**
* @description OLCRequest
*/
    
    global class OLCRequest{
        global String quoteId;
        global String materialNumber;
        global List<OnlineContacts> onlineContacts;
        global List<ProductDetails> productDetails;
        global String operationType;
    }
    /**
* @description OnlineContacts
*/
    global class OnlineContacts {
        private String contactId;
        public String firstName;
        public String lastName;
        private String email;
        private String onlineContactTypeDescription;
    }
    
    /**
* @description ProductDetails
*/
    global class ProductDetails {
        public String productId;
        public Integer productQuantity;
    }
    
    /**
* @description ProposalDetails
*/
    global class ProposalDetails{
        global map<id, string> mapProdServ;
        global Apttus_Proposal__Proposal__c proposal;
    }
     /**
* @description ProposalDetails
*/
    global class OLCResponse{
        global String status;
        global Integer code;
        global String message;
        global DCPOnlineContactsController.OLCResponseWrapper data;
    }
    
    
    private static List<Online_Contacts__c> getListProducts(list<Product2> lstProducts,List<OnlineContacts> wrapList, ProposalDetails proposalDetails){

        List<Online_Contacts__c> onlineContactInsert = new List<Online_Contacts__c>();
        for (Product2 prod : lstProducts) {
            if (prod.Apttus_Config2__ConfigurationType__c != PRODUCT_BUNDLE_CONFIG_TYPE || 
                (prod.Apttus_Config2__ConfigurationType__c == PRODUCT_BUNDLE_CONFIG_TYPE && proposalDetails.mapProdServ.get(prod.Id) != null)) {
                    for (OnlineContacts obj: wrapList) {
                        Online_Contacts__c  onc = new Online_Contacts__c();
                        onc.Email__c = obj.email;
                        onc.ContactID__c = obj.contactId;
                        onc.First_Name__c = obj.firstName;
                        onc.Last_Name__c = obj.lastName; 
                        onc = checkProdConfigType(prod,proposalDetails.mapProdServ,onc);
                        onc.ProductId__c = Prod.id;
                        onc.Is_Banded_Product__c  =  prod.APTS_Product_Pricing_Model__c == PRODUCT_PRICING_MODEL_BANDED ? true : false ;
                        onc.QuoteId__c = proposalDetails.proposal.Id;
                        onc.APTS_Source_System_Detail__c = proposalDetails.proposal.APTS_SSD_Sold_To__c;
                        onc.Position__c = obj.onlineContactTypeDescription;
                        onlineContactInsert.add(onc);
                    }
                } 
        }
        return onlineContactInsert;
    }
    private static Online_Contacts__c checkProdConfigType(Product2 product,map<id, string> mapProdServ,Online_Contacts__c onc){
    
        Product2 prodct2 = new Product2();
        Online_Contacts__c  onct = new Online_Contacts__c();
        onct = onc;
        prodct2 = product;
        if (prodct2.Apttus_Config2__ConfigurationType__c == PRODUCT_BUNDLE_CONFIG_TYPE) {
            onct.Material__c = mapProdServ.get(prodct2.Id);
        } else {
            onct.Material__c = prodct2.ProductCode;
        }
    	return onct;
    }
    
    private static map<id,string> getMapProdServ(list<Apttus_Proposal__Proposal_Line_Item__c> lstQuoteLineItems ){
      map<id, string> mapProdServ = new map<id, string>();
        if (lstQuoteLineItems != Null && lstQuoteLineItems.size() > 0) {
                    for (Apttus_Proposal__Proposal_Line_Item__c quoteLineItemRec : lstQuoteLineItems) {
                        mapProdServ.put(quoteLineItemRec.Apttus_Proposal__Product__c, quoteLineItemRec.APTS_Service_Number_Override__c);
                    }
                }
        return mapProdServ;
    }
    private static set<string> getProdIDs(OLCRequest updateDetails ){
      set<string> setProdIds = new set<string>();
       for(ProductDetails prod : updateDetails.productDetails) {
       setProdIds.add(prod.productId); 
        }
        return setProdIds;
    }
    
    
    private static set<string> getExtContactIdSet(OLCRequest updateDetails ){
       Set<String> extContactIdSet = new Set<String>();
                    for(OnlineContacts onlineCon: updateDetails.onlineContacts){
                        extContactIdSet.add(onlineCon.contactId);
                    } 
    return extContactIdSet;
    }
    
    private static DCPServiceResponse  deleteContacts(List<Online_Contacts__c> onlineContactList ){
        DCPServiceResponse response = new DCPServiceResponse();
                        if(!Schema.SObjectType.Online_Contacts__c.isDeletable()){
               throw new DCCustomException(UserInfo.getName()+' does not have access to: Online_Contacts__c');
                        }
                            delete onlineContactList;
                            response.code = 200;
                        	response.response = 'Success';
                            response.status = 'Ok';
      return response;
    }

        
    }