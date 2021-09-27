/*
 * CHANGE HISTORY
 * 
 *==================================================================================================================================
 * Date         Name                  Description
 * 2018-07-02   Brenda Shields        DLT-10717 - Remove obsolete items - removing call to update Product Xref records - DCConfiguratorUtil.updateDBCategories
 * 2018-12-19   Navleen Kaur          DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
 *==================================================================================================================================   
 */
@RestResource(urlMapping='/DigitalConfigurator/*')
global without sharing class DCConfiguratorUtil {

    Public Static Final String HTTP_MOTHOD_POST = 'POST';
    Public static Final String CONTENT_TYPE = 'Content-Type';
    Public static Final String SOAP_ACTION = 'SOAPAction';
    Public static Final String SOAP_ACTION_LOGIN = 'login';
    Public static Final String ENDPOINT_SUFFIX = '/services/Soap/u/40.0';
    Public static Final String CONTENT_TYPE_XML = 'text/xml;charset=UTF-8';
    Public static Final String CONTENT_TYPE_JSON = 'application/json';
    Public static Final String SERVER_URL = 'serverUrl';
    Public static Final String SESSION_ID = 'sessionId'; 
    Public static Final String URN_PARTNER_SOAP = 'urn:partner.soap.sforce.com';
    Public static Final String AUTHORIZATION = 'Authorization';
    
    @HttpPost 
    global static Boolean synchronizeCart(String quoteId) {
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
        cartList = [select id,name,Apttus_Config2__Status__c ,Apttus_QPConfig__Proposald__c
                                                               from Apttus_Config2__ProductConfiguration__c 
                                                               where Apttus_Config2__Status__c = :Label.DC_CONFIG_STATUS_FINALIZED and Apttus_QPConfig__Proposald__c =: quoteId ];
        
        }
        if((cartList != null) & (cartList.size() > 0)) {
            Apttus_CPQApi.CPQ.SynchronizeCartRequestDO request = new Apttus_CPQApi.CPQ.SynchronizeCartRequestDO();
            request.CartId = cartList[0].Id;
            Apttus_CPQApi.CPQ.SynchronizeCartResponseDO response = Apttus_CPQApi.CPQWebService.synchronizeCart(request);
            if(response != null) {
                return response.IsSuccess;
            }
        }
        
        return true;
    }
    
    public static String synchronizeCartAsAPIUser(String quoteId, DC_Global_Settings__mdt globalSetting) {
        
        String securityToken = globalSetting.Security_Token__c != null ? globalSetting.Security_Token__c : '';
        List<String> args = new String[]{globalSetting.Username__c, globalSetting.Password__c + securityToken};
        String requestBody = String.format(Label.DC_LOGIN_REQUEST_BODY, args);
         System.debug('requestBody '+requestBody);
        //----------------------------------------------------------------------
        // Login via SOAP/XML web service api to establish session
        //----------------------------------------------------------------------
        HttpRequest request = new HttpRequest();
        request.setEndpoint(globalSetting.Login_Domain__c + ENDPOINT_SUFFIX);
        request.setMethod(HTTP_MOTHOD_POST);
        request.setHeader(CONTENT_TYPE, CONTENT_TYPE_XML);
        request.setHeader(SOAP_ACTION, SOAP_ACTION_LOGIN);
        request.setBody(requestBody);
        request.setTimeout(50000);
        HttpResponse response = (new Http()).send(request);
        System.debug('<Response> '+response.getBody());
        Dom.XmlNode resultElmt = response.getBodyDocument().getRootElement()
          .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
          .getChildElement('loginResponse', URN_PARTNER_SOAP)
          .getChildElement('result', URN_PARTNER_SOAP);
        
        //----------------------------------------------------------------------
        // Grab session id and server url (ie the session)
        //----------------------------------------------------------------------
        String serverURL = resultElmt.getChildElement(SERVER_URL, URN_PARTNER_SOAP).getText().split('/services')[0];
        String sessionId = resultElmt.getChildElement(SESSION_ID, URN_PARTNER_SOAP).getText();
        
        return performSync(quoteId, sessionId, serverURL);
        
    }
    
    private static String performSync(String quoteId, String sessionId, String serverURL){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL + '/services/apexrest/DigitalConfigurator/synchronizeCart');
        request.setMethod(HTTP_MOTHOD_POST);
        request.setHeader(CONTENT_TYPE, CONTENT_TYPE_JSON);
        request.setHeader(AUTHORIZATION, 'OAuth ' + sessionId);
        request.setBody('{"quoteId":"' + quoteId + '"}');
        request.setTimeout(50000);
        Http http = new Http();
        HTTPResponse res = http.send(request);
        return res.getBody();
    }
    
    // Digital Product Xref is now obsolete
/*      
    public static void updateDBCategories(String quoteId) {
      // Create Prdouct Plan XREF records for each quote line item, as needed
        // Delete any pre-existing xref records
        
        list<Digital_Product_Xref__c> listXrefsToDel = [Select id from Digital_Product_Xref__c 
            where Proposal__c = :quoteId];
        if(listXrefsToDel != null && listXrefsToDel.size() > 0) {
            delete listXrefsToDel;
        }
        
        list<Id> listProductIds = new list<Id>();
        list<Digital_Product_Xref__c> listofXrefs = new list<Digital_Product_Xref__c>();
        // get all line items to process
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = [Select id, Apttus_Proposal__Proposal__c, 
            Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Subscription_Number__c
            from Apttus_Proposal__Proposal_Line_Item__c 
            where Apttus_Proposal__Proposal__r.is_Digital_Channel__c = TRUE and Apttus_Proposal__Proposal__c = :quoteId];
        
        // Check line items to see if they need to have xref cerate
        if(listLineItems != null && listLineItems.size() >0) {    
            // build a list of Product ids in order to get Product Plan records 
            for(Apttus_Proposal__Proposal_Line_Item__c oLineItem : listLineItems) {            
                listProductIds.add(oLineItem.Apttus_Proposal__Product__c);
            }   
        
            // get Product Plans
            list<Digital_Product_Plans__c> listPlans = [select id, Subscription_Number__c from Digital_Product_Plans__c where Product__c in : listProductIds];
        
            // Plans have been loaded, so check to see if any need to be created
            if(listPlans != null && listPlans.size() >0) {    
                // check each line item to see if there is a matching plan              
                for(Apttus_Proposal__Proposal_Line_Item__c oLineItem : listLineItems) {
                    for(Digital_Product_Plans__c oPlan : listPlans) {
                        // if this plan matches this line item product - create xerf                        
                        if(oLineItem.Apttus_Proposal__Product__r.Subscription_Number__c == oPlan.Subscription_Number__c) {  
                            // Create Xerf
                            Digital_Product_Xref__c CreateXref = new Digital_Product_Xref__c();
                            CreateXref.Digital_Product_Plans__c = oPlan.ID ;
                            CreateXref.Proposal_Line_Item__c = oLineItem.ID;
                            CreateXref.Proposal__c = oLineItem.Apttus_Proposal__Proposal__c;
                            listofXrefs.add(CreateXref);
                        }
                    }
                }
                    
                // Insert new Envelope records
                try { 
                    if(listofXrefs != null && listofXrefs.size() >0) {
                        insert listofXrefs;
                    }
                }
                catch(Exception exc) {
                    Digital_Exception_Log__c ex5 = new Digital_Exception_Log__c();
                    ex5.Exception_Type__c = 'Product Xref Insert';
                    ex5.Exception_Message__c = exc.getMessage();
                    ex5.Additional_Information__c = string.valueOf(exc.getLineNumber());
                    ex5.User_Message__c = 'Error inserting Digital_Product_Xref__c records';
                    ex5.Class_Reference__c = 'DCConfiguratorUtil > updateDBCategories';
                    Insert ex5;
                } 
            } // end of we have work to do for Digital Product Xref processing
        }
    }
*/

}