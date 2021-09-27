public without sharing class ESC_UserTriggerHandler{
 
    public static void associateFederationId(List<User> u){
        List<Contact> conLst = new List<Contact>();
        map<Id,Id> userContactMap = new map<Id,Id>();
        List<Id> uLstToUpdate = new List<Id>();
        set<Id> contactIdSet = new Set<Id>();
            for(User uObj:u){
                contactIdSet.add(uObj.contactId);
                userContactMap.put(uObj.contactId,uObj.Id);                        
            }
            if((Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable())){
                conLst = [SELECT Id,ESC_Contact_Number__c from Contact WHERE Id in:contactIdSet ];
            }
            if(conLst!=null && conLst.size() >0){
            
                for(contact c:conLst){
                    if(c.ESC_Contact_Number__c !=null){                
                        uLstToUpdate.add(userContactmap.get(c.Id));                       
                    }
                
                } 
                updateFederationId(uLstToUpdate);
                
            }
            
            
    }
      
        @future(callout = true)
        public static void updateFederationId(List<Id> userLst){
            List<User> uLst = new List<User>();
            List<User> uLstToUpdate = new List<User>();
            if((Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable())){
                uLst =  [SELECT id,FederationIdentifier,contactid,contact.ESC_Contact_Number__c from User where id in:UserLst];
            }
            for(User uObj:uLst){
                if(uObj.contactid!=null && uObj.FederationIdentifier==null){
                    uObj.FederationIdentifier = uObj.contact.ESC_Contact_Number__c;
                    uLstToUpdate.add(uObj);
                }
                
            }
            if((Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isUpdateable())){
                update uLstToUpdate;
            }
        }
    }