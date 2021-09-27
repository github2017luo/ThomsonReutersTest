/**
 * Contains methods for ContactAttributePasswords VF Page
 * Depends on ContactPasswordsServices Class
 * Depends on ContactPasswordsWS and  ContactPasswordsWSObjects Class which are created using the wsdl file
 * Contains the method to build the request to get the list of ContactPasswords based on the contactSAPId entered on the VF page.
 *
 * @author  TCS
 * @version  2016-01-28
 */
 
public with sharing class ContactAttributePasswords
{
    //Properties
    Public Contact_Attribute__c oContact{get;set;}
    Public List<ContactPasswordsServices.OnlineContact> listOnlineUser{get;set;}
   

    
    //Constructor
    public ContactAttributePasswords(ApexPages.StandardController controller) {
        listOnlineUser = new List<ContactPasswordsServices.OnlineContact>();
                
        oContact = new Contact_Attribute__c();
        oContact = (Contact_Attribute__c) controller.getrecord();               
        oContact = [Select FirstName__c,LastName__c,Id,Name__c,SAP_Contact_ID__c,AccountID__r.Name,Email__c, SAP_Email_1__c from Contact_Attribute__c where Id =: oContact.Id];
    
       displayContactPasswords();
     }    
    
   
     public void displayContactPasswords(){
        try{
            ContactPasswordsServices.ContactPasswordRequest oRequest = new ContactPasswordsServices.ContactPasswordRequest();
           
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswords');       
            oRequest.endpoint= oWebServiceSettings.Endpoint__c;
            oRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            oRequest.username=oWebServiceSettings.Username__c;
            oRequest.password= oWebServiceSettings.Password__c;
            oRequest.ContactSAPID = decimal.valueof(oContact.SAP_Contact_ID__c);
           
            ContactPasswordsServices oContactPasswordsServices = new ContactPasswordsServices();
           
            listOnlineUser = oContactPasswordsServices.GetContactPasswords(oRequest);
           } 
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }  
           
       
    }
    
    
    public PageReference exportContactPswds(){
        PageReference oPageReference = Page.ContactPasswordExport;
        oPageReference.setRedirect(false);
    
        return oPageReference;  
    
    }

}