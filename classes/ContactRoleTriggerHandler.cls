public without sharing class ContactRoleTriggerHandler {
    /*
        Contact” Records that are “Contact Roles” of an “Opportunity” Record will have its “Contact Group” Field with the “Sales Contact” Picklist Value.
        DPS-6437
        Developed By: TCS Developer
        Date: 05-11-2019
    */
     public static void updateContactGroup(LIST<OpportunityContactRole> newOppCRList) {
        if(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
          {return;}

        //Variable Declaration
        List<Contact> updateContactList = new List<Contact>();         
        List<ID> contactIds = new List<ID>(); 
        system.debug('Testing'); 
         if(!newOppCRList.isEmpty())
            {
             for (OpportunityContactRole ocr: newOppCRList)
                {
                    if(ocr.ContactId != null )
                    {
                        contactIds.add(ocr.ContactId );
                        system.debug('Testing2');
                    }      
                }
                if(!contactids.isEmpty()){
                    updateContactList = [SELECT id,Contact_Group__c from Contact where id in:contactIds and LCRM_Is_GLI__c = true];
                    for(contact con:updateContactList)
                    {
                          con.Contact_Group__c ='Sales Contact';
                          system.debug('Testing3');
                    }
                    system.debug('updateContactList'+updateContactList);
                    if (!updateContactList.isEmpty())
                        update updateContactList;
                }               
                
              }
         }

}