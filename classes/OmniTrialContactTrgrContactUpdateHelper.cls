/**
* Test class : OmniTrialContactTriggerHandler_Test
* JIRA Details: 
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JULY 2021     TCS DevTeam             Created as Part of DPS-20398
*                                       to update the Trial Status Based on the Trail contact status
*                                                                 
* =====================================================================================================================
*/
/**
* @description OmnitTrialContactTrgrContactUpdateHelper
* 
*/

public without sharing class OmniTrialContactTrgrContactUpdateHelper {
    
    /**
* @description processContacts
* @param trialcontacts
* @param oldTrialcontactMap
* 
*/  
    public static void processContacts(List<Trial_Contact__c> trialcontacts,Map<id,Trial_Contact__c> oldTrialcontactMap){
        set<id> contactids= new set<id>();
        for(Trial_Contact__c c: trialcontacts){                
            if(c.Contact__c !=null && c.Status__c != oldTrialcontactMap.get(c.Id).Status__c){
                contactids.add(c.Contact__c);
            }                
        }
        
        if(contactids != null && contactids.size()>0){
            updateContactRecord(contactids);
        }
    }
    
    /**
* @description updateContactRecord
* @param contactids
* 
*/  
    
    
    public static void updateContactRecord(set<id> contactids){
        List<Contact> contactList = fetchContactRecords(contactids);
        
        List<Trial_Contact__c> trialContSobjList = fetchTrialContactRecords(contactids);
        
        //create Map for Contact and related Trial contact
        Map<Id, List<Trial_Contact__c>> mapContactWithTrialContacts = getMapOfContactWIthTrialContacts(trialContSobjList);
        
        if(contactList !=null && contactList.size()>0  && mapContactWithTrialContacts != null && mapContactWithTrialContacts.size()>0){
            for(Contact contact : contactList ){
                set<String> trailConStatus = OmniTrialContactTriggerHandlerHelper.fetchTrialContactStatus(mapContactWithTrialContacts.get(contact.Id));
                if(trailConStatus.contains('Active') ){
                    contact.Has_Active_Trial__c = true;
                    
                }else{
                    contact.Has_Active_Trial__c = false;
                }
            }
            
            updateContact(contactList);
        }
    }
    
    
    
    
    /**
* @description fetchContactRecords
* @param contactids
* @return contactList
* 
*/    
    
    public static List<Contact> fetchContactRecords(set<id> contactids){
        List<Contact> contactList = new List<Contact>();
        if(Schema.sObjectType.Contact.isAccessible() ){
            contactList = [Select id, Has_Active_Trial__c from Contact where id IN: contactids];
        }
        return contactList;
    }
    
    
    /**
* @description fetchTrialContactRecords
* @param contactids
* @return trialContList 
* 
*/    
    
    public static List<Trial_Contact__c> fetchTrialContactRecords(set<id> contactids){
        List<Trial_Contact__c> trialContList = new List<Trial_Contact__c>();
        if( Schema.sObjectType.Trial_Contact__c.isAccessible()){
            trialContList = [Select id, Status__c,Contact__c from Trial_Contact__c where Contact__c IN: contactids];
        }
        return trialContList;
    }
    
    /**
* @description getMapOfContactWIthTrialContacts
* @param trialContSobjList
* @return mapContactWithTrialContacts
*/
    @testVisible
    private static Map<Id, List<Trial_Contact__c>> getMapOfContactWIthTrialContacts(List<Trial_Contact__c> trialContSobjList){
        Map<Id, List<Trial_Contact__c>>  mapContactWithTrialContacts = new Map<Id, List<Trial_Contact__c>> ();
        if(trialContSobjList !=null && trialContSobjList.size()>0){
            for(Trial_Contact__c trialCont : trialContSobjList){
                if(mapContactWithTrialContacts.containsKey(trialCont.Contact__c)) {
                    List<Trial_Contact__c> trialContList= mapContactWithTrialContacts.get(trialCont.Contact__c);
                    trialContList.add(trialCont);
                    mapContactWithTrialContacts.put(trialCont.Contact__c, trialContList);
                } 
                else 
                {
                    mapContactWithTrialContacts.put(trialCont.Contact__c, new List<Trial_Contact__c> { trialCont });
                }
                
            }
        }
        
        return mapContactWithTrialContacts;
    }  
    
    /**
* @description updateContact
* @param contactList
* 
*/
    @testVisible
    private static void updateContact(List<Contact> contactList){
        if(Contact.SobjectType.getDescribe().isCreateable() && 
           Contact.SobjectType.getDescribe().isUpdateable() && 
           contactList.size()>0){
               Database.update(contactList, false);
           }
    } 
    
    
}