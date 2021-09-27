/**
 * @description       :
 * @ JIRA             : DPS-21463
 * @ TestClass        : OmniEntitlementOLCPostback_Test 
 * @author            : TCS Devteam
 * @group             : 
 * @last modified on  : 06-18-2021
 * @last modified by  : TCS Devteam
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   06-18-2021   TCS Devteam   Initial Version
**/

@RestResource(urlMapping='/OmniEntitlementOLCPostback/*')
/**
* @description OmniEntitlementOLCPostback
* 
*/
global without sharing class OmniEntitlementOLCPostback{
    
    /**
* @description OmniEntitlementOLCPostback
* @return
*/
    
    @HttpPost
    global static responseWrapper doPost(){ 
        
        String requestBody= RestContext.request.requestBody.tostring().replaceAll('\n','').replaceAll('\r','');
        OmniEntitlOLCPostbackWrapper entilReq= (OmniEntitlOLCPostbackWrapper)System.JSON.deserialize
            (requestBody,OmniEntitlOLCPostbackWrapper.class);  
        
        responseWrapper returnMsg ;        
        responseWrapper resp = validateJSONResponse(entilReq);
        if(resp.messagecode != '4001' ){
            returnMsg=   processJSONResponse(entilReq);
        }
        else{
            returnMsg= resp;
        }
        
        return returnMsg ;
    }
    
    /**
* @description updateTrailRecord
* @param entilReq
* @return exceptionMsg
*/
    private static responseWrapper validateJSONResponse(OmniEntitlOLCPostbackWrapper entilReq){
        
        responseWrapper resp = new responseWrapper();
        
        if(entilReq.trialId==null || !doesRecordExist(entilReq.trialId)){
            resp.message = 'Trial ID not valid';
            resp.messagecode = '4001';
            resp.status = 'Error'; 
        }
        
        return resp;
    }    
    /**
* @description updateTrailRecord
* @param entilReq  
* @return respnse
*/
    private static ResponseWrapper processJSONResponse(OmniEntitlOLCPostbackWrapper entilReq){
        
        responseWrapper respnse;
        
        Map<id,Trial_Product_Contact__c>  trailProductContactsMap = new Map<id,Trial_Product_Contact__c> ();
        
        
        
        //To get The Trail Product Contact Records
        ProductContactWrap productContactsresp = getProductContactRecords(entilReq);
        
        if(productContactsresp.hasError){
            return productContactsresp.respnse;
        }
        
        //For updating Trial Record
        respnse = updateTrailRecord(entilReq.trialId, string.valueOf(entilReq.customerNumber) );
        
         if(respnse.messagecode == '2000' ){
            //To get the Product Trail Contact Map
            Map<string,list<Trial_Product_Contact__c>> productContactIDsMap = getProductContactMap(productContactsresp.productContacts);            
            Map<id,Trial_Contact__c> trailContactsMap = new Map<Id,Trial_Contact__c>();     
            for(OmniEntitlOLCPostbackWrapper.Products prod :entilReq.products){         
                trailContactsMap.putAll(OmniEntitlementOLCPostbackHelper.getNeedtoUpdateContactsList(prod, productContactIDsMap)); 
                trailProductContactsMap.putAll(OmniEntitlementOLCPostbackHelper.getNeedtoUpdateProductContactsList(prod, productContactIDsMap));      
            } 
            
            //Updating Contacts and Getting  Response
            respnse = updateContacts(trailContactsMap.values());
        }   
        
        if(respnse.messagecode == '2000' ){
            //Updating Product Contacts and Getting  Response
            respnse = updateProductContacts(trailProductContactsMap.values());
        }
        
        
        
        return respnse;
    }
    
    private static responseWrapper updateContacts(list<Trial_Contact__c> trailContacts){
        responseWrapper respnse;
        if(Schema.sObjectType.Trial_Contact__c.fields.External_Contact_Number__c.isUpdateable()){
            list<database.saveResult> desList = database.update(trailContacts,false);
            respnse = generateResponse(desList);
        }
        return respnse;
    }
    
    
    private static responseWrapper updateProductContacts(list<Trial_Product_Contact__c> trailProductContacts){
        responseWrapper respnse;
        if(Schema.sObjectType.Trial_Product_Contact__c.fields.Entitlement_Status__c.isUpdateable()){
            list<database.saveResult> desList = database.update(trailProductContacts,false);
            respnse = generateResponse(desList);
        }
        return respnse;
    }
    /**
* @description updateTrailRecord
* @param trialID
* @param customerNumber
* @return respnse
*/
    private static responseWrapper  updateTrailRecord(string trialID, String customerNumber){
        Ent_Trial__c trial = new Ent_Trial__c();        
        trial.Id = trialId;
        
        trial.External_Account_Number__c = customerNumber;
        if(customerNumber != null && customerNumber.startsWith('100')){
             trial.External_Account_Number_Source__c = 'SAP';
        }
        else
        {
            trial.External_Account_Number_Source__c = 'OLC';
        }
       
        //trial.Trial_Status__c = 'Active';
        database.SaveResult des;
        if(Schema.sObjectType.Ent_Trial__c.fields.External_Account_Number__c.isUpdateable()){
            des= database.Update(trial,false);
        }
        list<database.SaveResult> desList = new list<database.SaveResult>();
        desList.add(des);
        responseWrapper respnse = generateResponse(desList);
        return respnse;
    }
    
    /**
* @description getProductContactRecords
* @return productContacts
* @param entilReq
*/
    private static ProductContactWrap   getProductContactRecords(OmniEntitlOLCPostbackWrapper entilReq){
        
        ProductContactWrap resp = new ProductContactWrap();
        Set<Id> contactIDsSet = new Set<Id>();
        Set<Id> productIDsSet = new Set<Id>();
        boolean hasProdcutIdError=false;
        boolean hasContactIdError=false;
        
        list<OmniEntitlOLCPostbackWrapper.Contact> contactsFromJSON = new list<OmniEntitlOLCPostbackWrapper.Contact>();
        
        for(OmniEntitlOLCPostbackWrapper.Products prods :entilReq.products){
            if(doesRecordExist(prods.referenceId)){
                productIDsSet.add(prods.referenceId);
            }
            else{
                hasProdcutIdError = true;
                break;
            }
            contactsFromJSON.addAll(prods.contact);                
        }
        
        for(OmniEntitlOLCPostbackWrapper.Contact cont : contactsFromJSON){
            if(doesRecordExist(cont.extContactId)){
                contactIDsSet.add(cont.extContactId);
            }
            else{
                hasContactIdError = true;
                break;
            }
            
        }
        
        contactsFromJSON.clear(); 
        list<Trial_Product_Contact__c> productContacts;
        if(Schema.sObjectType.Trial_Product_Contact__c.isAccessible()){
            productContacts =[SELECT Id, Trials__c, Entitlement_Status__c, Entitlement_Status_Description__c, Trial_Contact__c, Trial_Product__c 
                              FROM Trial_Product_Contact__c 
                              where Trial_Contact__c in :contactIDsSet and Trial_Product__c  in :productIDsSet];
            
        }
        
        resp = genarateRespForProdCont(hasProdcutIdError,hasContactIdError,productContacts);
        return resp;
        
    }
    
      /**
     * @description doesRecordExist
     * @param hasProdcutIdError
     * @param hasContactIdError
     * @param productContacts
     * @return resp
     * */
    @testvisible
    private static ProductContactWrap genarateRespForProdCont(boolean hasProdcutIdError,boolean hasContactIdError,list<Trial_Product_Contact__c> productContacts){
        ProductContactWrap resp = new ProductContactWrap();
        responseWrapper  respnse= new responseWrapper();
        resp.hasError = false;
        if(hasProdcutIdError){   
            resp.hasError = true;
            respnse.message = 'Trial Product ID not valid';
            respnse.messagecode = '4002';
            respnse.status = 'Error';  
        }
        else if(hasContactIdError){
            resp.hasError = true;
            respnse.message = 'Trial Contact ID not valid';
            respnse.messagecode = '4003';
            respnse.status = 'Error'; 
        } 
        
        resp.respnse = respnse;
        resp.productContacts = new list<Trial_Product_Contact__c>();
        resp.productContacts.addAll(productContacts);
        return resp;
    }
    
    /**
* @description getProductContactMap
* @return productContactIDsMap
* @param productContacts
*/
    private static Map<string,list<Trial_Product_Contact__c>> getProductContactMap(list<Trial_Product_Contact__c> productContacts){
        Map<string,list<Trial_Product_Contact__c>> productContactIDsMap = new Map<string,list<Trial_Product_Contact__c>>();
        for(Trial_Product_Contact__c prodContact : productContacts){
            list<Trial_Product_Contact__c> prodContacts = new list<Trial_Product_Contact__c>();
            
            if(productContactIDsMap.containskey(prodContact.Trial_Product__c +'-'+prodContact.Trial_Contact__c)){
                prodContacts.addAll(productContactIDsMap.get(prodContact.Trial_Product__c +'-'+prodContact.Trial_Contact__c));
            }
            
            prodContacts.add(prodContact);
            productContactIDsMap.put(prodContact.Trial_Product__c +'-'+prodContact.Trial_Contact__c,prodContacts);
        }
        return productContactIDsMap;
    }
    
    
  
    /**
     * @description doesRecordExist
     * @param value
     * @return
     * */
    
    private static Boolean doesRecordExist(String value)
    {
        Id recordId;
        try { recordId = Id.valueOf(value); }
        catch (StringException e) { return false; }
        String soql = 'SELECT count() FROM ' +
            recordId.getSObjectType() +
            ' WHERE Id = :recordId';
        return Database.countQuery(soql) == 1;
    }
   
    /**
     * @description generateResponse
     * @param results
     * @return respnse
     * 
     * */
    
    private static responseWrapper generateResponse(list<database.saveResult> results){
        responseWrapper respnse = new responseWrapper(); 
        boolean hasError =false;
        for(database.saveResult des : results){
            if(!des.isSuccess()){ 
                hasError = true;
                respnse.message = 'Error updating Trial records';
                respnse.messagecode = '4000';
                respnse.status = 'Error';   
                break;
            }
        }
        if(!hasError){
            respnse.message = 'Trial records updated successfully';
            respnse.messagecode = '2000';
            respnse.status = 'Success';  
        }
        return respnse;
    }
    
    
    /**
* @description errorMsgWrapper
*/
    global class ResponseWrapper{
        /**
* @description message
*/ 
        global string message;
        /**
* @description messagecode
*/
        global string messagecode;
        /**
* @description status
*/
        global string status;
    }
    
     
    /**
* @description ProductContactWrap
*/
    public class ProductContactWrap{
         
    /**
* @description productContacts
*/
        public list<Trial_Product_Contact__c> productContacts; 
        /**
    * @description respnse
    */
        public responseWrapper respnse; 
        /**
    * @description hasError
    */
        public boolean hasError;
    }
}