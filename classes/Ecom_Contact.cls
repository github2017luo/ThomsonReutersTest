/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                   Name                                         Description
 * 2018-04-20   Shiva Sri Arun Koralla          DLT-8513 [NEW CUSTOMER - Buy Plan SL] Create Contact
 * 2018-06-28   Shiva Sri Arun Koralla          DLT-9978 [GLI] Update object field references for class "Ecom_Contact"
 * 2018-08-20   Shiva Sri Arun Koralla          DLT-10835 [NEW CUSTOMER - Buy Plan SL/CP] Convert Lead to Account,Contact,Opportunity
 * 2018-08-28   Shiva/Ramesh                    DLT-11546 [TECH STORY- SFDC] - Update calls as per new UI for checkout
 * 2018-08-28   Shiva Sri Arun Koralla          DLT-11729 [Tech story] [Code Scan] Fix Ecom_contact
 * ==================================================================================================================================   
 */
public with sharing class Ecom_Contact
{ 

    // GLI Contact
     public static Contact updateConvertedContact(String contactid,Source_System_Detail__c ssdAcc)
     {
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        
        Contact gliCon = [ Select id,RecordTypeId,accountId,firstname, lastname, Email, Work_Direct__c,
                            SAP_Role__c, Phone, LCRM_Phone_Verification__c, LCRM_Email_Verification__c
                          from Contact Where id =: contactid ];
        LCRM_Contact_SSD__c ssdCon = [Select Id,name,LCRM_Extension__c from LCRM_Contact_SSD__c where LCRM_Contact__c =: contactid ];
         
        gliCon.Id = contactid;
        gliCon.RecordTypeId = RecordTypeId;
        gliCon.SAP_Role__c = label.Ecom_SAPRole;
        gliCon.Phone = ssdAcc.LCRM_Phone__c;
        gliCon.LCRM_Phone_Verification__c = 'Valid Number';
        gliCon.LCRM_Email_Verification__c = 'Email Valid';
        gliCon.Extension__c = ssdCon.LCRM_Extension__c;
         
        if(Schema.sObjectType.Contact.isUpdateable())
        {
          update gliCon;
        }
        return gliCon;
                                 
     }
    
   //Contact Source Systems Object 
    public static LCRM_Contact_SSD__c createContactSSD(Source_System_Detail__c  ssdAcc, String contactId, Ecom_OrderRequest.cls_customerDetails info)
    {
        
        LCRM_Contact_SSD__c ssdCon = new LCRM_Contact_SSD__c ();
   
        ssdCon.LCRM_Account_SSD__c= ssdAcc.Id;
        ssdCon.Name = info.organizationName;
        ssdCon.LCRM_Contact__c = contactId;
        ssdCon.LCRM_First_Name__c = info.firstName; 
        ssdCon.LCRM_Email__c = info.businessEmail;
        ssdCon.LCRM_Phone__c = info.phoneNumber;
        ssdCon.LCRM_Extension__c = info.phoneExtension;
        ssdCon.LCRM_SAP_Role__c = label.Ecom_SAPRole;
        ssdCon.LCRM_City__c = info.address.city; 
        ssdCon.LCRM_Country__c = info.address.country;
        ssdCon.LCRM_Street__c = info.address.addressLine1;
        ssdCon.LCRM_Postal_Code__c = info.address.zipCode; 
        ssdCon.LCRM_State_Province__c = info.address.state;
        
        insert ssdCon;
        return ssdCon;
    
    }
    
    // update contacts only if there is change in firstname,lastname,email,phone number - Ecom_OrderService Call    
    public static void updateContacts(String contactId, String contactSSD, Ecom_OrderRequest.cls_customerDetails customerDetails)
    {
        Contact conObject = new Contact();
        conObject.Id = contactId; 
        conObject.lastname = customerDetails.lastname;
        conObject.firstname = customerDetails.firstname;
        conObject.Email = customerDetails.businessEmail;
        conObject.Phone = customerDetails.phoneNumber;
        conObject.Work_Direct__c= customerDetails.phoneNumber;
        conObject.Extension__c = customerDetails.phoneExtension;
        if(Schema.sObjectType.Contact.isUpdateable())
        {
           update conObject;
        }   
         
        LCRM_Contact_SSD__c ssdCon = new LCRM_Contact_SSD__c();
        ssdCon.id = contactSSD;
        ssdCon.LCRM_Contact__c = contactId;
        ssdCon.Name = customerDetails.organizationName;
        ssdCon.LCRM_First_Name__c = customerDetails.firstname;
        ssdCon.LCRM_Email__c = customerDetails.businessEmail;
        ssdCon.LCRM_Phone__c= customerDetails.phoneNumber;
        ssdCon.LCRM_Extension__c = customerDetails.phoneExtension;
        update ssdCon;    
    }
}