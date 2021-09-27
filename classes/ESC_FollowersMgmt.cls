public class ESC_FollowersMgmt {
    
    public static void manageCaseFollowers(list<case> newCases ,Map<id,Case> oldMap){
        try{
            List<Case> addCaseFollowersList = new List<case>();
            List<Case> removeCasefollowersList = new List<Case>();
            
            List<Case> removeCasefollowersListClosedCases = new List<Case>();
            if(oldMap == null){
                oldMap = new Map<id,Case>();
            }
            
            
            for(Case caseNew :newCases){
               if(caseNew.Is_ESC_Case__c )
                {
                    Case caseOld = null;
                    string oldOwnerID = '';
                    string oldRecordTypeName = '';
                    Boolean isclosedOld = false;
                    if(oldMap.containsKey(caseNew.id)){
                        caseOld = oldMap.get(caseNew.id);
                        oldOwnerID = caseOld.OwnerId;
                        oldRecordTypeName=Schema.SObjectType.Case.getRecordTypeInfosById().get(caseOld.RecordTypeId).getName(); 
                        isclosedOld = caseOld.isClosed;
                    }    
                    String newRecordTypeName=Schema.SObjectType.Case.getRecordTypeInfosById().get(caseNew.RecordTypeId).getName();
                    
                    //Added as part of EES-118 Story to add follower on reopening a case
                    if(caseNew.isclosed != isclosedOld  &&  !(caseNew.isclosed) && isclosedOld  ){
                        addCaseFollowersList.add(caseNew);
                    }  
                    
                    if(newRecordTypeName.contains('Read Only') && (String.isNotBlank(oldRecordTypeName) && !oldRecordTypeName.contains('Read Only'))){
                        system.debug('NC1&&&');
                        removeCasefollowersListClosedCases.add(caseNew);
                        
                    }
                    else if(string.isBlank(oldOwnerID) || (string.isNotBlank(oldOwnerID) && caseNew.OwnerId != oldOwnerID ) ){
                        system.debug('Inside else if:');
                        addCaseFollowersList.add(caseNew);
                        system.debug('oldOwnerBeforeisNotBlank'+oldOwnerID);
                        if(string.isNotBlank(oldOwnerID))
                            removeCasefollowersList.add(caseOld);
                    }
                }
                
            }
            if(removeCasefollowersList.size()>0){
                removeCasefollowers(removeCasefollowersList , false);
            }
            if(removeCasefollowersListClosedCases.size()>0){
            system.debug('NC2&&&'+removeCasefollowersListClosedCases);
                removeCasefollowers(removeCasefollowersListClosedCases , true);
            }
            
            if(addCaseFollowersList.size()>0){
                addCaseFollowers(addCaseFollowersList);
            }
        }
        catch(Exception ex){
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
    }
    
    
    @TestVisible private static void addCaseFollowers(List<Case> listCases){
        system.debug('$$$$$$Inside addCaseFollowers');
        List<EntitySubscription> listEntitySubscriptions = new List<EntitySubscription>();
        
        Map<id,Id> case_CaseOwnerMap = new Map<id,Id>();
        
        try{
            for(Case oCase : listCases){
                system.debug('$$$$$$Inside addCaseFollowers11111111');
                String StrOwnerId = oCase.OwnerId;
                if(StrOwnerId.substring(0,3)=='005'){
                    
                    listEntitySubscriptions.add(new EntitySubscription(ParentId=oCase.id,SubscriberId=oCase.OwnerId));
                    
                }
                
            }
            
            Database.SaveResult[] lsr = Database.insert(listEntitySubscriptions,false);
        }catch(Exception Ex){
            System.debug('The following exception has occurred: ' + Ex.getMessage());
        }
    }
    
    @TestVisible  private static void removeCasefollowers(List<Case> listCases, Boolean areClosedCases){
    system.debug('NC3&&&'+listCases+areClosedCases);
        set<id> OldCaseOwnerIds = new set<id>();
        set<id> caseIdSet = new set<id>();
        for(Case cse :listCases){
            caseIdSet.add(cse.id);
        }
        
        List<EntitySubscription> listEntitySubscriptions = new List<EntitySubscription>();
        try{
            if(areClosedCases){
                system.debug('NC4&&&'+listCases+areClosedCases);
                for(EntitySubscription oEntitySubs : [Select ParentId,SubscriberId from EntitySubscription where ParentId IN :caseIdSet LIMIT 1000]){
                    listEntitySubscriptions.add(oEntitySubs);
                    system.debug('NC5&&&'+listCases+areClosedCases);
                }  
            }
            else{
            system.debug('NC6&&&'+listCases+areClosedCases);
                for(Case cse :listCases){
                    OldCaseOwnerIds.add(cse.OwnerId);
                    system.debug('NC7&&&'+listCases+areClosedCases);
                }
                for(EntitySubscription oEntitySubs : [Select ParentId,SubscriberId from EntitySubscription where SubscriberId IN : OldCaseOwnerIds and ParentId IN :caseIdSet limit 1000]){
                    system.debug('NC8&&&'+listCases+areClosedCases);
                    listEntitySubscriptions.add(oEntitySubs);  
                    
                }
            }
            system.debug('NC9&&&'+listEntitySubscriptions);
            Database.delete(listEntitySubscriptions,false);
            
        }catch(Exception Ex){
            System.debug('The following exception has occurred: ' + Ex.getMessage());
        }
    }
    
    public static void manageCaseFollowersForReferral(list<ESC_Case_Collaborator__c> newReferral  ,Map<id,ESC_Case_Collaborator__c> oldMap){
        try{
            List<EntitySubscription> entitySubscriptionListAdd = new List<EntitySubscription>();
            List<EntitySubscription> entitySubscriptionListRemove = new List<EntitySubscription>();
            Map<id,id> case_ReferralOwnerRem = new Map<id,id>();
            Map<id,id> case_ReferralOwnerAdd = new Map<id,id>();
            oldMap = oldMap==null? new Map<id,ESC_Case_Collaborator__c>(): oldMap;
            
            for(ESC_Case_Collaborator__c escNew: newReferral){
                ESC_Case_Collaborator__c escOld = oldMap.get(escNew.id);
                string oldOwnerID = escOld ==null?'':escOld.OwnerId;
                string newOwnerID = escNew.OwnerId;
                System.debug('manageCaseFollowersForReferral: ' + escNew);
                if(escNew.ESC_Referral_Status__c.equalsignoreCase('Closed') ){
                    case_ReferralOwnerRem.put(escNew.ESC_Case__c , escNew.OwnerId);
                }
                 if(escNew.ESC_Referral_Status__c.equalsignoreCase('Completed') ){
                    case_ReferralOwnerRem.put(escNew.ESC_Case__c , escNew.OwnerId);
                }
                System.debug('oldOwnerID: ' + oldOwnerID +' escNewID: ' + escNew.OwnerId);
                if(!newOwnerID.equals(oldOwnerID) && newOwnerID.substring(0,3) =='005'){
                    entitySubscriptionListAdd.add(new EntitySubscription(ParentId=escNew.ESC_Case__c,SubscriberId=escNew.OwnerId));
                    if(string.isNotBlank(oldOwnerID))
                        case_ReferralOwnerRem.put(escNew.ESC_Case__c , oldOwnerID);
                }
                
            }
            
            entitySubscriptionListRemove= [Select ParentId,SubscriberId from EntitySubscription where SubscriberId IN : case_ReferralOwnerRem.values() and ParentId IN :case_ReferralOwnerRem.keySet()];
            System.debug('entitySubscriptionListRemove: ' + entitySubscriptionListRemove);
            System.debug('entitySubscriptionListAdd: ' + entitySubscriptionListAdd);
            Database.delete(entitySubscriptionListRemove,false);
            Database.insert(entitySubscriptionListAdd);   
        }catch(Exception Ex){
            System.debug('The following exception has occurred: ' + Ex.getMessage());
        }
        
    } 
}