/********************************************************************************
Class Name : DCPRenewalContact
@description : This class is used by DCPGetRenewal class to populate Contact JSON data.
***************************************************************************************

Modification Details
Date         Description                         Owner
15/04/2021   Class Created | DCP-1157            By Herin Acharya
09/08/2021   Added ID and Email | DCP-4671       Benjamin Her

*********************************************************************************/
public without sharing class DCPRenewalContact{
    
    /**
        @description Populate the Contact Wrapper Details
        @param con Contact instance containing details to be populated in the response.
        @return Returns the populated contact wrapper object.
     */
    public static DCPRenewalContactWrapper populateContactDetails(Contact con){
        
       //Contact objContact = DCPRenewalUtilityClass.getContact(contactId);
       DCPRenewalContactWrapper objContactWrapper = new DCPRenewalContactWrapper();
       
       objContactWrapper.firstName = DCPUtility.formatName(con.FirstName,true);
       objContactWrapper.lastName = DCPUtility.formatName(con.LastName,true);   
       objContactWrapper.contactId = con.Id;   
       objContactWrapper.email = con.Email;     
       return objContactWrapper;
    }
}