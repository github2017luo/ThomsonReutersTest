public without sharing class ESC_PushTopicHelperObj {

 static Map<string,string> emailParentMap = new Map<string,string>();
    static Map<string,string> parentOwnersMap = new Map<string,string>();
    static Map<string,string> parentCaseMap = new Map<string,string>();
   
    public static Map<string ,set<string>> fetchGuestUsers(set<string> recIDSet, string key){
       Map<string , set<string>> guestUsers = new Map<string , set<string>>();
        if(key.equalsIgnoreCase('Case')){
              system.debug('Case' + key);
            //fetch all accountableResolver and Owner ID
            set<string> allUsers;
            for(ESC_Case_Collaborator__c refRec :[SELECT Id,ownerid,ESC_Case__c FROM ESC_Case_Collaborator__c WHERE ESC_Case__c in :recIDSet and ESC_Role__c='Accountable Resolver' ]) {
                  system.debug('in for refRec' + refRec);
                if(guestUsers.containsKey(refRec.ESC_Case__c)){
                    allUsers = guestUsers.get(refRec.ESC_Case__c);
                }
                else{
                    allUsers = new set<string>();
                }
                allUsers.add(refRec.ownerid);
                guestUsers.put(refRec.ESC_Case__c ,allUsers );
            }
        }
        system.debug('guestUsers' + guestUsers);
        return guestUsers;
    }
    
   
    
    public static void updateMap(List<EmailMessage> emails){
        for(EmailMessage em :emails){
            emailParentMap.put(em.id,em.parentID);
        }
        
         for(EmailMessage em : [select Parent.OwnerID,Parent.CaseNumber from EmailMessage where id in :emailParentMap.keyset()]){
            parentOwnersMap.put(em.id,em.Parent.OwnerID);
            parentCaseMap.put(em.id,em.Parent.CaseNumber);
        }
    }
    
    public static List<ESC_PushTopicHelper__c> getRecordsToBeUpdated(List<EmailMessage> emails, string eventType){
                
          Map<string , set<string>> guestUsers = fetchGuestUsers(new Set<string>(emailParentMap.values()) , 'Case');
          List<ESC_PushTopicHelper__c> recordsToBeEntered = new List<ESC_PushTopicHelper__c>();
            for(EmailMessage em :emails){
                set<string> guestUsersIDS;
                if(!guestUsers.containsKey(em.ParentID)){
                    guestUsersIDS = new set<string>();
                }
                else{
                    guestUsersIDS = guestUsers.get(em.ParentID);
                }
                  guestUsersIDS.add(parentOwnersMap.get(em.id)); 
                   system.debug(JSON.serialize(guestUsers));
                  guestUsers.put(em.ParentID,guestUsersIDS);  
                system.debug(JSON.serialize(guestUsers));
                for(string key: guestUsers.keySet()){
                    for(string guestUserId: guestUsers.get(key)){
                          ESC_PushTopicHelper__c pth = new ESC_PushTopicHelper__c();
                        pth.ESC_ParentRecID__c = emailParentMap.get(em.id);
                        pth.ESC_ObjectType__c = 'EmailMessage';
                        pth.ESC_RecOwner__c = parentOwnersMap.get(em.id);
                        pth.ESC_CaseNumber__c = parentCaseMap.get(em.id);
                        system.debug('Casenumber--->'+pth.ESC_CaseNumber__c);
                        pth.ESC_RecGuestUser__c = guestUserId;
                        if (pth.ESC_RecOwner__c==pth.ESC_RecGuestUser__c){
                        pth.ESC_RecOwner__c = 'dummy';
                        }
                        if(eventType =='New Incoming Email'){
                            if(em.subject !='' && em.subject != null && em.TextBody != '' && em.TextBody != null){   
                                if(em.Subject.contains('ref:_00D') ||em.TextBody.contains('ref:_00D')){
                                 pth.ESC_EventType__c = 'Updated';
                                 }
                             }   
                             else{
                                 pth.ESC_EventType__c = 'Created';
                             }
                         }
                         recordsToBeEntered.add(pth);
                    
                    }
                }
            
        }
        return recordsToBeEntered;
        
    }
    
    @InvocableMethod(label='Add Push Topic Helper Records' description='Create Push Topic Helper Log')
    public static void populateLogs(List<EmailMessage> emails){
            updateMap(emails);
         List<ESC_PushTopicHelper__c> recordsToBeEntered = getRecordsToBeUpdated(emails, 'New Incoming Email');
        system.debug('recordsToBeEntered '+recordsToBeEntered);
        try{
            if(Schema.sObjectType.ESC_PushTopicHelper__c.isAccessible() || Schema.sObjectType.ESC_PushTopicHelper__c.isCreateable()){
                insert(recordsToBeEntered);
            }
        }
        catch(exception ex){
            system.debug(ex.getmessage());
        }
    }
    
    // to create records when readbyowner or readbyresolver
      public static void populateLogs(EmailMessage email, string eventType){
             updateMap(new List<EmailMessage>{email});
            boolean addENtry = false;
             string loggedinUser = userinfo.getUserId();
            ESC_PushTopicHelper__c pth = new ESC_PushTopicHelper__c();
            pth.ESC_ParentRecID__c = email.id;
            system.debug('ESC_ParentRecID__c='+ pth.ESC_ParentRecID__c );
            pth.ESC_ObjectType__c = 'EmailMessage';
            pth.ESC_CaseNumber__c = parentCaseMap.get(email.id);
            
            
            // ********** update email **************************//
            if( parentOwnersMap.get(email.id) == loggedinUser){
                email.ESC_ReadByOwner__c = true;
                pth.ESC_RecOwner__c = parentOwnersMap.get(email.id);
                update(email);
                addENtry = true;
            }
        List<ESC_Case_Collaborator__c> referralList = new List<ESC_Case_Collaborator__c>();
        if((Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isQueryable()) || (Schema.sObjectType.EmailMessage.isAccessible() || Schema.sObjectType.EmailMessage.isQueryable())){
        referralList = [Select ownerid from ESC_Case_Collaborator__c where ESC_Case__c In (Select Parentid from EmailMessage where id=:email.id) AND ESC_Role__c='Accountable Resolver' AND ESC_Referral_Status__c !='Closed' and ownerid =:loggedinUser];
        } 
            
             if(referralList.size()>0 && ! email.ESC_Read_By_Accountable_Resolver__c){
                email.ESC_Read_By_Accountable_Resolver__c = true;
                pth.ESC_RecOwner__c = loggedinUser;
                addENtry = true;
                update (email);
            }
            
            // ********** update email **************************//
            
            pth.ESC_RecGuestUser__c = loggedinUser;
             pth.ESC_EventType__c = eventType;
          
        
        system.debug('recordsToBeEntered '+pth);
        try{
            if(addENtry && (Schema.sObjectType.ESC_PushTopicHelper__c.isAccessible() || Schema.sObjectType.ESC_PushTopicHelper__c.isCreateable())){
             insert(pth);
            }
        }
        catch(exception ex){
            system.debug(ex.getmessage());
        }
    }
    
    
}