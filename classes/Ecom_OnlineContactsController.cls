/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date          Name                           Description
 * 2018-05-20   Ramesh Reddy/Raviteja          DLT-9777 [NEW CUSTOMER - Buy Plan SL] Create Online Contacts
 * ==================================================================================================================================   
 */

@RestResource(urlMapping='/ecom/onlineContacts/*')
global class Ecom_OnlineContactsController {

    @HttpPost
    global static OLCResponse onlineContacts(String proposalId, Boolean contractNotInsync, String jurisdiction){
        OLCResponse response = new OLCResponse();
        System.debug('----Inside onlineContacts--- -----------'+ proposalId + '<>'+contractNotInsync);
        if(String.isBlank(proposalId) || contractNotInsync == null || jurisdiction == null){
            response.responseCode = 4004;
            response.responseMessage = 'Invalid Parameters';
            return response;
        }
        try{
            Ecom_OnlineContactsService svc = new Ecom_OnlineContactsService();
            svc.checkContacts(proposalId, contractNotInsync, jurisdiction);
            response.responseMessage = 'Success';
            response.responseCode = 200;
        }catch(Exception ex){
            DCUtils.trackLog(ex,'Ecom_OnlineContactsController','onlineContacts');
            response.responseMessage = ex.getMessage();
            response.responseCode = 4004;
        }
        
        
        return response; 
    }

    global class OLCResponse{
        global Integer responseCode;
        global String responseMessage;
    }
}