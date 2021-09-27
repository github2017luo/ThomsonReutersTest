public without sharing class LCRMContactFromTE {
    
    @AuraEnabled
    public static void createContact(Id contactId,Id teId){
        
        if(Schema.sObjectType.contact.fields.LCRM_Created_from_Training_Event__c.isAccessible() && 
           Schema.sObjectType.contact.fields.Do_not_Mail__c.isAccessible() &&
           Schema.sObjectType.contact.fields.DoNotCall.isAccessible() &&
           Schema.sObjectType.contact.fields.Contact_Type__c.isAccessible() ){
              Contact oContact = [select LCRM_Created_from_Training_Event__c,Do_not_Mail__c,DoNotCall,
                           Contact_Type__c from contact where id = :contactId];
               
               
               
               oContact.LCRM_Created_from_Training_Event__c = true;
               oContact.Do_not_Mail__c = true;
               oContact.DoNotCall = true;
               If(LCRMGenericComponent.getUserBU() == 'UKI')
               {
                   oContact.Contact_Type__c = 'UKI - Training Event';
               }
               if(Schema.sObjectType.Contact.isUpdateable()){
                   update oContact;
               }
               
               
               Training_Event_Contact__c teContact = new Training_Event_Contact__c();
               teContact.Contact_Name__c = oContact.Id;
               teContact.Training_Event__c=teId; 
               if(Schema.sObjectType.Training_Event_Contact__c.iscreateable()){
                   insert teContact;
               }
           }
    }
}