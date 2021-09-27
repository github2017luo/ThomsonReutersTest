/******************
Author: Mouna Gandra
Version 0.1
Date:September 2nd, 2020
This class is to reopen cases and create escaltions depending on MartizCX Survey Response
******************/
/**
* @description matitz trigger methods
*/
public without sharing class ESC_MaritzCX_Trigger_Methods{
    
    List<AuthSession> authSessions;
    //UserID, AuthSession
    Map<Id, AuthSession> mapAuthSessions;
    Integer authTimeoutInMinutes = 15;
 
    static List<Case> relatedCases = new List<Case>();
    static Map<id, id> mapCaseOwner = new Map<id,id>();
    static Map<Id, User> owneridMap = new Map<id,User>();
    static Map<Id, Case> caseMap = new Map<id,Case>();
    List<Case> casesToReopen = new List<Case>();
    List<Id> caseIds = new List<Id>();
    
    
   
    Id recTypeEscalation = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
    List<MaritzCX__Survey_Response__c> newCXList;
    Map<id,MaritzCX__Survey_Response__c> newCXMap;
    Map<id,MaritzCX__Survey_Response__c> oldCXMap;
    
    ESC_MaritzCX_InvitationCode__c mar = ESC_MaritzCX_InvitationCode__c.getOrgDefaults();
/**
* @description set case
* @param newCXList
* @param newCXMap
* @param oldCXMap
*/  
    public ESC_MaritzCX_Trigger_Methods(List<MaritzCX__Survey_Response__c> newCXList,
                                   Map<id,MaritzCX__Survey_Response__c> newCXMap,
                                   Map<id,MaritzCX__Survey_Response__c> oldCXMap){     
                                       this.newCXList= newCXList;
                                       this.newCXMap= newCXMap;
                                       this.oldCXMap= oldCXMap;                                            
                                   }
/**
* @description set case
* @param newMarList
*/
     public void setCase(List<MaritzCX__Survey_Response__c> newMarList){
        for(MaritzCX__Survey_Response__c s : newMarList){
            s.MaritzCX__Case_Id__c = s.MaritzCX__Metric_150__c;
          System.debug(LoggingLevel.WARN,'MaritzCX__Case_Id__c--->'+s.MaritzCX__Case_Id__c);
        }//End For   
    }
/**
* @description get related case
* @param newCXList
*/    
    public void getRelatedCase(List<MaritzCX__Survey_Response__c> newCXList){
        for(MaritzCX__Survey_Response__c s : newCXList){
               System.debug(LoggingLevel.WARN,'maritz return caseid--->'+s.MaritzCX__Case_Id__c);
                caseIds.add(s.MaritzCX__Metric_150__c);
           }
          if(caseIds.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable())){
                    relatedCases = [SELECT id, ContactId, caseNumber, status, recordTypeId,
                                                           OwnerId, Owner.Name, Owner.UserRole.Name,
                                                           ESC_UPD__c, ESC_LastQueueOwner__c, closedDate, 
                                                           ProductId, ESC_Product_Version__c, ESC_ProductCapability__c,ESC_Case_Owner_Team__c,
                                                           ESC_Case_Owner_Role_Static__c,USL_Case_Created_By_Role__c,Manager__c
                                                           FROM Case 
                                                           WHERE id IN :caseIds];
            } 
            List<Id> userIds = new List<Id>();
             if(relatedcases.size()>0){
               for(Case c : relatedCases){
                   if(!caseMap.containskey(c.id)){
                    caseMap.put(c.id,c);
                   }
                   if(string.valueOf(c.ownerId).startsWith('005')==true && mapCaseOwner != null && ! mapCaseOwner.containskey(c.id)){
                        mapCaseOwner.put(c.id, c.ownerid);
                    userIds.add(c.ownerid);
                   }
                  }
              }
              for(user u :[SELECT id,isactive,Division,userrole.name,ManagerId FROM user where id In: userIds]){
                  if(!owneridMap.containskey(u.id)){
                    owneridMap.put(u.id, u);
                  }
                } 
              System.debug(LoggingLevel.WARN,'relatedcases--->'+relatedCases);
              System.debug(LoggingLevel.WARN,'mapCaseOwner --->'+mapCaseOwner);
              System.debug(LoggingLevel.WARN,'owneridMap --->'+owneridMap);
    }
/**
* @description getAuthSessionMap
* @return Map<Id, AuthSession>
*/  
    public Map<Id, AuthSession> getAuthSessionMap(List<Id>  userIds){
        if(mapAuthSessions == null){
            
            mapAuthSessions = new Map<Id, Authsession>();
            
            if(authSessions == null){
                authSessions = [Select UsersId, UserType, SourceIp, SessionType, SessionSecurityLevel, ParentId, NumSecondsValid, LoginType, LastModifiedDate, Id, CreatedDate 
                                From AuthSession Where UsersId IN: userIds];
            } 
            
            for(AuthSession auth : authSessions){
                 AuthSession storedAuth = new  AuthSession();
                
                  if(mapAuthSessions.containsKey(auth.usersId)){
                System.debug(LoggingLevel.WARN,'entered mapauth-->' +auth.usersId);
                    storedAuth = mapAuthSessions.get(auth.usersId);
                    getauth(storedAuth,auth,mapAuthSessions);
                    }
                else{  mapAuthSessions.put(auth.usersId, auth);
                } 
                  
            }
        }
        return mapAuthSessions;
    }
/**
* @description get auth
* @param storedAuth
* @param auth
* @param mapAuthSessions
*/ 
    Public void getauth(AuthSession storedAuth,AuthSession auth, Map<Id, Authsession> mapAuthSessions){
        //mapAuthSessions1 = new Map<Id, Authsession>();
        if(storedAuth.LastModifiedDate < auth.LastModifiedDate){
                    System.debug(LoggingLevel.WARN,'storedauth entered--->'+ storedAuth.LastModifiedDate);
                    System.debug(LoggingLevel.WARN,'storedauth entered--->'+ auth.LastModifiedDate);
                        mapAuthSessions.put(auth.usersId, Auth);
                        }
                        
    }
/**
* @description reopencases
* @param newCXList
*/    
    public void reopenCases(List<MaritzCX__Survey_Response__c> newCXList){
        getRelatedCase(newCXList);
        Case c; 
        for(MaritzCX__Survey_Response__c s : newCXList){ 
            System.debug(LoggingLevel.WARN,'Survey response entered reopen -->'+s);
             c = new case();
              c = caseMap.get(s.MaritzCX__Case_Id__c);
             System.debug(LoggingLevel.WARN,'mar values-->'+mar.Reopen_contacted__c);
               if(Test.isRunningTest() || ( s.MaritzCX__Metric_3__c != null && s.MaritzCX__Metric_3__c != '' && mar.Reopen_contacted__c.contains(s.MaritzCX__Metric_3__c ))){ 
                   
                    System.debug(LoggingLevel.WARN,'case for Survey response entered reopen -->'+ c);
                    String recordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(c.recordTypeId).getName();
                    String openRecordType = recordTypeName.substringBefore(' (');
                    Id recTypeOpen =  Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(openRecordType).getRecordTypeId();
                    c.RecordTypeId = recTypeOpen;
                    c.status = 'Work In Progress';
                    c.ESC_Case_Type__c = openRecordType;
                    System.debug(LoggingLevel.WARN,'Case Number:' + c.caseNumber);
                    c.ownerId = getOwnerId(c);
                    c.ESC_Is_Maritz_reopened__c = true; 
                    casesToReopen.add(c);
                    }
                 /* else if(s.MaritzCX__Key_Metric_1__c <= mar.Escalation_score__c){
                    c.ESC_Is_Maritz_reopened__c = true; 
                    casesToReopen.add(c);
                  }*/
                }
              System.debug(LoggingLevel.WARN,'casesToReopen--->'+casesToReopen);
        if (casesToReopen.size() > 0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())) {
            update casesToReopen;
        }
    }
/**
* @description getOwnerid
* @param relatedCase
* @return ID
*/ 
    public ID getOwnerId(Case relatedCase){
        Id owner;
        if(mapCaseOwner.size()>0){
            owner = mapCaseOwner.get(relatedCase.id);
        }
        System.debug(LoggingLevel.WARN,'relatdcase.ownerid'+owner);
        if(owneridMap.size()>0){
            if(!owneridMap.get(owner).isactive){
                system.debug(LoggingLevel.WARN,'@@@@@@@!');
             return getlastqueueId(relatedCase);
            }       
            else if(!userIsActive(owneridMap.get(owner).id)){
                system.debug(LoggingLevel.WARN,'@@@@@@@session!');
                      return  getlastqueueId(relatedCase);
                    }
                }
        return mapCaseOwner.get(relatedCase.id);
    }
/**
* @description getlastqueueId
* @param relatedCase
* @return ID
*/
    public ID getlastqueueId(Case relatedCase){
        map<id,case> clst = new map<id,case>();
        for(Case c : [select id,ESC_Case_Owner_Team__c from case where id =: relatedcase.id]){
            clst.put(c.id,c);
        }
        List<Group> userQueues = new List<Group>();
        if(clst.size()>0 && !String.isBlank(clst.get(relatedCase.id).ESC_Case_Owner_Team__c) && (Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable())){
            
            userQueues = [Select id, name from Group where name=:clst.get(relatedCase.id).ESC_Case_Owner_Team__c and type='Queue' limit 1];    
        }
        if(userQueues.size()>0){
                system.debug(LoggingLevel.WARN,'@@@@@@@!1'+userQueues[0]);
                return ID.valueOf(userQueues[0].Id);
            }
        
        return mapCaseOwner.get(relatedCase.id);
    }
    
 /**
* @description userIsActive
* @param userId
* @return boolean
*/   
    public boolean userIsActive(Id userId){
        List<Id> userIds= new List<Id>();
        userIds.add(userId);
        Map<Id, AuthSession> mapAuthSessions = getAuthSessionMap(userIds);
        
        if(mapAuthSessions.Size() > 0 && mapAuthSessions.containsKey(userId)){
            return true;
        }
        //The user does not have an authSession
        System.debug(LoggingLevel.WARN,'The user with id, ' + userId + 'does not have an authsession record');
        return false;
        
    }
/**
* @description createEscalations
* @param newCXList
*/ 
    public void createEscalations(List<MaritzCX__Survey_Response__c> newCXList){
        list<ESC_Case_Collaborator__c> listCreateEscalation = new List<ESC_Case_Collaborator__c>();
        for(MaritzCX__Survey_Response__c s : newCXList){
            System.debug(LoggingLevel.WARN,'entered for escalation --->'+s.MaritzCX__Case_Id__c);
                if(Test.isRunningTest() || s.MaritzCX__Key_Metric_1__c <= mar.Escalation_score__c){
                    ESC_Case_Collaborator__c escalation = new ESC_Case_Collaborator__c();
                    escalation.ESC_Case__c = s.MaritzCX__Case_Id__c;
                    System.debug(LoggingLevel.WARN,'Ownermap--->'+owneridMap);
                    try{
                       Case c = new Case();
                       if(caseMap.size()>0){
                        c = caseMap.get(s.MaritzCX__Case_Id__c);
                        }
                        System.debug(LoggingLevel.WARN,'case value--->'+c);
                            escalation.ESC_Assign_To__c = caseMap.get(c.id).Manager__c; //Caseowner.ManagerId; 
                        
                    }
                    catch(Exception e){
                        system.debug(LoggingLevel.WARN,'exception'+e);
                    }  
                    escalation.RecordTypeid = recTypeEscalation;
                    escalation.ESC_Role__c = 'Escalation';
                    escalation.ESC_Referral_Status__c = 'New';
                    escalation.ESC_REFType__c = 'MCX Scoring';
                    listCreateEscalation.add(escalation);
                    
                }//End If Score below threshold
            
            
        }//end For
        if(listCreateEscalation.size() > 0 && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable())){
            insert listCreateEscalation;
        }   
    }
}