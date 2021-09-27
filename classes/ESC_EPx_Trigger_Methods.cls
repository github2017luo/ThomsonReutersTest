/******************
Author: Matthew Main
Version 0.1
Email:Matthew.Main@thomsonreuters.com
Date:May 9th, 2018
******************/

public without sharing class ESC_EPx_Trigger_Methods{
    
    Id recTypeFeedback = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId();
    Id recTypeEPsComplete = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Complete').getRecordTypeId(); 
    Id recTypeEscalation = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
    Id recordTypeIdComplete = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Complete').getRecordTypeId();
    //Id recordTypeIdSent = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_EPs_Sent').getRecordTypeId();
    
    List<AuthSession> authSessions;
    //UserID, AuthSession
    Map<Id, AuthSession> mapAuthSessions;
    Integer authTimeoutInMinutes = 15;
    
    
    List<Case> cases = new List<Case>();
    List<ESC_Case_Collaborator__c> escalations = new List<ESC_Case_Collaborator__c>();
    
    List<Case> casesToReopen = new List<Case>();
    List<ESC_EPs_Re_openValues__c> custSetReopen = ESC_EPs_Re_openValues__c.getall().values();
    
    List<ESC_EPx_Template_Selector__c> templateSelectors;                                     
    Map<Id, ESC_EPx_Template_Selector__c> mapTemplateSelector;
    
    List<Id> caseIds = new List<Id>();
    
    
    List<Case> relatedCases;
    Map<id, Case> mapCases; 
    
    
    
    List<ESC_EPX__c> newEPsList;
    Map<id,ESC_EPX__c> newEPsMap;
    Map<id,ESC_EPX__c> oldEPsMap;
    
    public ESC_EPx_Trigger_Methods(List<ESC_EPX__c> newEPsList,
                                   Map<id,ESC_EPX__c> newEPsMap,
                                   Map<id,ESC_EPX__c> oldEPsMap){     
                                       this.newEPsList = newEPsList;
                                       this.newEPsMap = newEPsMap;
                                       this.oldEPsMap = oldEPsMap;
                                       
                                       for(ESC_EPx__c s : newEPsList){
                                           caseIds.add(s.ESC_Case__c);
                                       }
                                       if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
                                           relatedCases = [SELECT id, ContactId, caseNumber, status, recordTypeId,
                                                           OwnerId, Owner.Name, Owner.UserRole.Name,
                                                           ESC_UPD__c, ESC_LastQueueOwner__c, closedDate, 
                                                           ProductId, ESC_Product_Version__c, ESC_ProductCapability__c,ESC_Case_Owner_Team__c,
                                                           ESC_Case_Owner_Role_Static__c,USL_Case_Created_By_Role__c
                                                           FROM Case 
                                                           WHERE id IN :caseIds];
                                       }                                                
                                   }
    
    public case getRelatedCase(ESC_EPX__c s){
        if(mapCases == null){
            mapCases = new Map<id, Case>(relatedCases);
            
        }
        return mapCases.get(s.ESC_Case__c);
    }
    
    public List<ESC_EPx_Template_Selector__c> getListTemplateSelectors(){
        if(templateSelectors == null){
            templateSelectors = [SELECT id, ESC_EPs_Make_EscalationScore__c, ESC_EPs_Make_FeedbackScore__c, ESC_Expiration_In_Days__c, ESC_EPs_Reopen_Auto__c 
                                 FROM ESC_EPx_Template_Selector__c];
        }
        
        return templateSelectors;
    }
    
    public Map<Id, ESC_EPx_Template_Selector__c> getMapTemplateSelectors(){
        if(mapTemplateSelector == null){
            
            mapTemplateSelector = new Map<Id, ESC_EPx_Template_Selector__c>();
            
            for(ESC_EPx_Template_Selector__c ts : getListTemplateSelectors()){
                mapTemplateSelector.put(ts.id, ts);
            } 
        }
        
        return mapTemplateSelector;
    }
    
    public ESC_EPx_Template_Selector__c getTemplateSelector(ESC_EPx__c s){
        return getMapTemplateSelectors().get(s.ESC_EPx_Template_Selector__c);
    }
    
    public Map<Id, AuthSession> getAuthSessionMap(){
        if(mapAuthSessions == null){
            
            mapAuthSessions = new Map<Id, Authsession>();
            
            if(authSessions == null){
                authSessions = [Select UsersId, UserType, SourceIp, SessionType, SessionSecurityLevel, ParentId, NumSecondsValid, LoginType, LastModifiedDate, Id, CreatedDate 
                                From AuthSession];
            }
            
            
            
            for(AuthSession auth : authSessions){
                
                if(mapAuthSessions.containsKey(auth.usersId)){
                    AuthSession storedAuth = mapAuthSessions.get(auth.usersId);
                    if(storedAuth.LastModifiedDate < auth.LastModifiedDate){
                        mapAuthSessions.put(auth.usersId, Auth);
                    }
                }
                else{
                    mapAuthSessions.put(auth.usersId, auth);
                }    
            }
        }
        
        return mapAuthSessions;
    }
    
    public void expirationCheck(){
        
        for(ESC_EPx__c s : newEPSList){ 
            
            if(s.ESC_EPx_Expired_Response__c == false){
                ESC_EPx_Template_Selector__c templateSelector = new ESC_EPx_Template_Selector__c();
                
                templateSelector = getMapTemplateSelectors().get(s.ESC_EPx_Template_Selector__c);
                
                if(templateSelector != null){
                    
                    Integer expirationInDays = Integer.valueOf(templateSelector.ESC_Expiration_In_Days__c);
                    DateTime caseClosedDate = getRelatedCase(s).closedDate;
                    
                    if(caseClosedDate != null){
                        
                        System.debug('###############################################caseClosedDate:' + caseClosedDate);
                        Date expirationDate = Date.newinstance(caseClosedDate.year(), caseClosedDate.month(), caseClosedDate.day());
                        expirationDate = expirationDate.addDays(expirationInDays);
                        
                        if(expirationInDays != -1 && Date.today() >= expirationDate){
                            s.ESC_EPx_Expired_Response__c = true;
                        }
                    }
                    else{
                        s.ESC_EPx_Expired_Response__c = false;
                    }
                }
                
            }//END IF S.IsExpired
            
        }//END FOR 
    }//End Expiration Check
    
    public void setSurveyType(){
        
        //List<ESC_EPx__c> relatedEP = [SELECT id from ESC_EPx__c where ESC_EPx_Type__c = 'EPs - Initial Feedback' AND ID in : newEPsList];
        Map<ID, ESC_EPx__c> relatedEPMap = new Map<ID, ESC_EPx__c>([SELECT id from ESC_EPx__c where ESC_EPx_Type__c = 'EPs - Initial Feedback' AND ESC_Case__c in : caseIds]);
        
        System.debug('testEPs : ' +relatedEPMap);
        for(ESC_EPx__c s : newEPsList){
            if(String.isBlank(s.ESC_EPx_Type__c)){
                System.debug('s.ESC_EPx_Type__c : ' +s.ESC_EPx_Type__c);
                System.debug('s.Id : ' +s.Id);
                ESC_Epx__c relatedEp = relatedEPMap.get(s.id);
                System.debug('relatedEp : ' +relatedEp);
                s.recordTypeId = recTypeEPsComplete;
                
                if(relatedEPMap.size() == 0){                         
                    s.ESC_EPx_Type__c = 'EPs - Initial Feedback';
                }
                else{
                    s.ESC_EPx_Type__c = 'EPs - Subsequent Feedback';    
                }             
            }//End if isblank Type 
            
        }//End For   
    }
    
    public void setCaseOwnerAndTeam(){
        for(ESC_EPx__c s : newEPsList){
            Case c = getRelatedCase(s);
            s.ESC_EPX_Case_Owner__c = c.OwnerId;
            s.ESC_Case_Team__c = c.Owner.UserRole.Name;
        }//End For   
    }
    
    public void setLanguage(){
        
        ESC_EPX_Language_List_Wrapper instanceLanguageList = ESC_EPX_Language_List_Wrapper.getInstance();
        String clicktoolsISOCode; 
        
        for(ESC_EPx__c s : newEPsList){
            clicktoolsISOCode = s.ESC_EPX_Clicktools_Language__c;
            if(clickToolsISOCode != null){
                s.ESC_EPx_Language__c  = instanceLanguageList.getLanguageByClicktoolsISOCode(clicktoolsISOCode).id; 
            }    
        }
    }
    
    
    
    
    public void reopenCases(){
        
        for(ESC_EPx__c s : newEPsList){    
            
            Case relatedCase = getRelatedCase(s);
            Map<Id, ESC_EPx_Template_Selector__c> mapTemplateSelector = getMapTemplateSelectors();
            
            ESC_EPx_Template_Selector__c templateSelector = mapTemplateSelector.get(s.ESC_EPx_Template_Selector__c);
            if(templateSelector != null){
                if(!s.ESC_EPx_Expired_Response__c && (s.ESC_EPs_Is_Solved_Answer__c=='Issue was not resolved' || s.ESC_EPs_Is_Solved_Answer__c=='Le problème n’a pas été résolu') && templateSelector.ESC_EPs_Reopen_Auto__c == True) 
                    
                {
                    
                    for(ESC_EPs_Re_openValues__c reopen : custSetReopen){
                        
                        //relatedCase.get('reopen.Field__c')
                        Map<String, Schema.SObjectField> c;
                        c = Schema.SObjectType.Case.fields.getMap();
                        
                        Schema.SObjectField field = c.get(reopen.Field__c);
                        
                        try{
                            Schema.DisplayType fldType = field.getDescribe().getType();
                            if(fldType == Schema.DisplayType.Boolean){
                                relatedCase.put(reopen.Field__c, boolean.valueOf(reopen.value__c));
                            }
                            else if(fldType == Schema.DisplayType.String){
                                relatedCase.put(reopen.Field__c, String.valueOf(reopen.value__c));
                            }
                            else if(fldType == Schema.DisplayType.Integer){
                                relatedCase.put(reopen.Field__c, Integer.valueOf(reopen.value__c));
                            }
                            else{
                                relatedCase.put(reopen.Field__c, reopen.value__c);
                            }
                        }
                        catch(exception e){
                            System.debug('The user has entered a bad value for in ESC_EPx_ReopenValues custome setting, field:' + reopen.Field__c);
                        }
                        
                    }//End For(CustSetReopen)
                    
                    
                    
                    
                    String recordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(relatedCase.recordTypeId).getName();
                    String openRecordType = recordTypeName.substringBefore(' (');
                    
                    Id recTypeOpen =  Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(openRecordType).getRecordTypeId();
                    relatedCase.RecordTypeId = recTypeOpen;
                    
                    relatedCase.ESC_Case_Type__c = openRecordType;
                    System.debug('Case Number:' + relatedCase.caseNumber + ', Last Queue Owner:' + relatedCase.ESC_LastQueueOwner__c);
                    
                    relatedCase.ownerId = getOwnerId(s, relatedCase);
                    
                    
                    
                    casesToReopen.add(relatedCase); 
                    
                    
                }//End If Reopen Request Check.
                
            }//End If Template Selector != null
            
        }//End For EPsList
        if (Schema.sObjectType.Case.isUpdateable()) {
            update casesToReopen;
        }
        
    }
    
    public ID getOwnerId(ESC_EPx__c s, Case relatedCase){
        List<User> usrlst = new List<User>();
        
        if(string.valueOf(relatedCase.ownerId).startsWith('005')==true && (Schema.sObjectType.user.isAccessible() || Schema.sObjectType.user.isQueryable())){
            usrlst = [select id,isactive,Division,userrole.name from user where id=:relatedCase.ownerId];
        }
         system.debug('@@@@@@@!!'+usrlst[0].userrole.name);
        if(usrlst.size()>0){
            if(!usrlst[0].isactive){
                system.debug('@@@@@@@!');
             return getlastqueueId(relatedCase);
            }       
            else{
                system.debug('@@@@@@@!2'+s.ESC_EPX_Case_Owner__c);
                if(!userIsActive(Id.valueOf(s.ESC_EPX_Case_Owner__c))){
                    //Try to Assign to the user's queue since they are not online.
                    try{
                        if(Schema.sObjectType.GroupMember.isAccessible() || Schema.sObjectType.GroupMember.isQueryable()){
                            List<GroupMember> userQueue = [Select id, GroupId, Group.Name from GroupMember where UserOrGroupId =: relatedCase.OwnerId and Group.Type = 'Queue'];
                            
                            if(userQueue.size() == 1){
                                return ID.valueOf(userQueue[0].Groupid);
                            }
                            else {
                            system.debug('@@@@@@@!4');
                              return  getlastqueueId(relatedCase);
                            }
                        }
                    }
                    catch(exception e){
                        System.debug('User is not a member of a queue, Trying to see last queue case was a member of. If null assigning back to user anyways becuase what else to do :|');
                        if(!String.isBlank(relatedCase.ESC_LastQueueOwner__c)){
                            return ID.valueOf(relatedCase.ESC_LastQueueOwner__c);
                        }
                    }
                }else{
                    system.debug('test1232'+relatedCase.USL_Case_Created_By_Role__c+usrlst[0].userrole.name);
                    //Add Mike's logic of DSS-3783 here for user isactive in user record and loggedinto system at time of submitting eps,then check for Users division is not same as Case Owner Role (Static) then assign to Last Queue Owner provided its not blank.else assign to Case Owner Primary Queue else to remain as is with case owner. 
                    if(relatedCase.USL_Case_Created_By_Role__c != usrlst[0].userrole.name){
                        return ID.valueOf(getlastqueueId(relatedCase));
                    }
                }
            }
        }
        
        return relatedCase.OwnerId;
    }
    public ID getlastqueueId(Case relatedCase){
        if(!String.isBlank(relatedCase.ESC_LastQueueOwner__c)){
        system.debug('@@@@@@@!5'+relatedCase.ESC_LastQueueOwner__c);
            return ID.valueOf(relatedCase.ESC_LastQueueOwner__c);
        }
        
        if(!String.isBlank(relatedCase.ESC_Case_Owner_Team__c)){
            List<Group> userQueues = new List<Group>();
            if(Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable()){
            userQueues = [Select id, name from Group where name=:relatedCase.ESC_Case_Owner_Team__c and type='Queue' limit 1];
            }
            if(userQueues.size()>0){
                system.debug('@@@@@@@!1'+userQueues[0]);
                return ID.valueOf(userQueues[0].Id);
            }
        }
        return relatedCase.OwnerId;
    }
    public void createFeedbackCases(){
        
        
        Map<Id, User> ownerid = getOwnerIdMap();
        
        List<Case> casesToCreate = new List<case>();
        
        for(ESC_EPx__c s : newEPsList){
            
            ESC_Epx_Template_Selector__c templateSelector = getTemplateSelector(s);
            
            if(templateSelector != null){
                
                if(!s.ESC_EPx_Expired_Response__c && s.ESC_EPx_Decimal_Score__c < templateSelector.ESC_EPs_Make_FeedbackScore__c){
                    
                    
                    Case relatedCase = getRelatedCase(s);
                    
                    Case newCase = relatedCase.clone();
                    
                    Id uId = Id.valueOf(s.ESC_Case_Owner__c);
                    try{
                        //get owner
                        //user owner = [SELECT id, ManagerId FROM user where id =: uId];
                        newCase.OwnerId =ownerId.get(s.ESC_EPX_Case_Owner__c).managerId; //owner.ManagerId;
                    }
                    catch(Exception e){
                        System.debug('Unable to retrieve manager Id, Id will be set to the original case owner');
                    }  
                    
                    //newCase.ownerId = relatedCase.Owner.Manager;
                    //newCase.contactId = relatedCase.ContactId;
                    newCase.ParentId = s.ESC_Case__c;
                    newCase.Subject = 'Experience Pulse Survey Feedback |' + s.ESC_Case__c + ' | Follow Up';
                    newCase.description =  'Experience Pulse Feedback:\n\n' +
                        
                        'Is Query Resolved:' + s.ESC_EPs_Is_Solved_Answer__c + '\n' +
                        'Reopen Case:' + s.ESC_EPs_Reopen_Req_Answer__c + '\n' +
                        'Overall Rating:' + s.ESC_Answer_1__c + '\n' +
                        //'Effort Rating:' + <Agree, Disagree, etc.> + '\n' +
                        'Time Feedback was received:\n' + DateTime.now() + '\n' +
                        'Comment:\n'+ 
                        s.ESC_Survey_Comments_Text__c
                        ;
                    newCase.Origin = 'EPs';
                    newCase.status = 'New';
                    newCase.ESC_Disposition__c = 'Negative';
                    //Need to set based on custom settings
                    newCase.RecordTypeId = recTypeFeedback;
                    newCase.ESC_Case_Type__c = 'Feedback';  
                    newCase.ESC_Case_Sub_Type__c = 'Survey';
                    //newCase.ProductId = relatedCase.ProductId;
                    //newCase.ESC_Product_Version__c = relatedCase.ESC_Product_Version__c;
                    //newCase.ESC_ProductCapability__c = relatedCase.ESC_ProductCapability__c;
                    casesToCreate.add(newCase); 
                    
                }//End if Expired and feedbackScore below threshold  
                
            }//End IF template Selector != null                      
            
        }//End For newEPsList
        if(casesToCreate.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isCreateable())){
        insert casesToCreate;
        }
    }
    
    
    
    public void createEscalations(){
        list<ESC_Case_Collaborator__c> listCreateEscalation = new List<ESC_Case_Collaborator__c>();
        
        
        
        Map<Id, User> ownerid = getOwnerIdMap();
        
        
        
        for(ESC_EPx__c s : newEPsList){
            
            ESC_Epx_Template_Selector__c templateSelector = getTemplateSelector(s);
            
            if(templateSelector != null){
                //below last condition added for DSS-6812
                if((!s.ESC_EPx_Expired_Response__c && s.ESC_EPx_Decimal_Score__c < templateSelector.ESC_EPs_Make_EscalationScore__c) || (s.ESC_Text_Answer_1__c=='Yes')){
                    ESC_Case_Collaborator__c escalation = new ESC_Case_Collaborator__c();
                    escalation.ESC_Case__c = s.ESC_Case__c;
                    
                    //TODO Need to figure out how to move this query outside of the for loop
                    Id uId = Id.valueOf(s.ESC_Case_Owner__c);
                    try{
                        //user owner = [SELECT id, ManagerId FROM user where id =: uId];
                        escalation.ESC_Assign_To__c = ownerId.get(s.ESC_EPX_Case_Owner__c).managerId;//owner.ManagerId;
                    }
                    catch(Exception e){
                        system.debug('exception'+e);
                    }  
                    
                    //Need to set based on custom settings  
                    escalation.RecordTypeid = recTypeEscalation;
                    escalation.ESC_Role__c = 'Escalation';
                    escalation.ESC_Referral_Status__c = 'New';
                    escalation.ESC_EPX_Created__c = TRUE;
                    escalation.ESC_REFType__c = 'EPs Scoring';
                    listCreateEscalation.add(escalation);
                    
                }//End If Score below threshold
                
            }//End if Template Selector != null
            
            
        }//end For
        if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
            insert listCreateEscalation;
        }
    }
    
    public boolean userIsActive(Id userId){
        Map<Id, AuthSession> mapAuthSessions = getAuthSessionMap();
        
        if(mapAuthSessions.containsKey(userId)){
            return true;
        }
        //The user does not have an authSession
        System.debug('The user with id, ' + userId + 'does not have an authsession record');
        return false;
        
    }
    
    
    public static void removeScheduledSurveysOnCaseReopen(List<Case> caseList){
        
        String scheduledTaskName = 'Send Survey:%'; 
        List<CronTrigger> cronTriggerList = new List<CronTrigger>();
        if(Schema.sObjectType.CronTrigger.isAccessible() || Schema.sObjectType.CronTrigger.isQueryable()){
        cronTriggerList = [SELECT Id, CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name like : scheduledTaskName];
        }
        Id epsSuppressed = Schema.SObjectType.ESC_EPx__c.getRecordTypeInfosByName().get('ESC_Eps_Surpressed').getRecordTypeId();
        
        
        //Case.ID, CronTrigger
        Map<Id,List<CronTrigger>> mapCronTriggers = new Map<Id, List<CronTrigger>>();
        
        for(CronTrigger cron : cronTriggerList){
            
            System.debug('Cron:' + cron);
            //get Case Id from cron Name
            String cronNameString = cron.CronJobDetail.Name;
            String cidString = cronNameString.subString(12,27);
            ID cId = Id.ValueOf(cidString);
            System.debug('%%%%%%%%%%%%%%%%%%%CaseID:' + cId);
            
            
            if(!mapCronTriggers.containsKey(cId)){
                List<CronTrigger> cronList = new List<CronTrigger>();
                cronList.add(cron);
                mapCronTriggers.put(cId, cronList);
            }
            else{
                List<CronTrigger> cronList = mapCronTriggers.get(cId);
                cronList.add(cron);
                mapCronTriggers.put(cId, cronList);
            }
            
        }
        
        List<id> related1 = new List<id>();
        for(Case c : caseList){
            
            if(!mapCronTriggers.containsKey(c.id)){
                System.debug('There are no scheduled surveys to remove');
            }
            else{
                List<CronTrigger> relatedCronTriggerList =  mapCronTriggers.get(c.id);
                
                for(CronTrigger cron : relatedCronTriggerList){
                    System.debug('Deleting Cron Job ID ... Job Name:' + cron.id + ' ... ' + cron.CronJobDetail.Name);
                    System.abortJob(cron.id);
                }
                
            }
            related1.add(c.id); 
        }
        List<ESC_EPx__c> relatedEP = new List<ESC_EPx__c>();
        if(Schema.sObjectType.ESC_EPx__c.isAccessible() || Schema.sObjectType.ESC_EPx__c.isQueryable()){
        relatedEP = [Select id, Name, ESC_EPx_Type__c, Date_Time_Sent__c from ESC_EPx__c where ESC_Case__c IN: related1];
        }
        ESC_EPx__c lastCreatedEP;
        
        for(ESC_Epx__c epx : relatedEP){
            if(lastCreatedEP == null){
                lastCreatedEP = epx;
                
            }
            else if(lastCreatedEP.Name < epx.Name){
                lastCreatedEP = epx;
            }
        }
        
        
        if(lastCreatedEP != null && lastCreatedEP.Date_Time_Sent__c > DateTime.now()){
            lastCreatedEp.recordTypeId = epsSuppressed;
            lastCreatedEP.ESC_EPx_Type__c = 'EPs - Supressed';
            lastCreatedEP.ESC_Other_Suppresions__c = 'Case reopened before EPx was sent';
            if(Schema.sObjectType.ESC_EPx__c.isAccessible() || Schema.sObjectType.ESC_EPx__c.isUpdateable()){
            update lastCreatedEP; 
            }
        }               
        
    }
    
    
    
    public Map<Id,User> getOwnerIdMap(){
        
        List<Id> userIds = new List<Id>();
        
        
        for(ESC_EPx__c s : newEPsList){
            userIds.add((Id) s.ESC_EPX_Case_Owner__c);
        }
        
        Map<Id, User> ownerid = new Map<id,User>();
        
        for(user u :[SELECT id, ManagerId FROM user where id In: userIds]){
            ownerid.put(u.id, u);
            
        }
        
        return ownerId;
        
        
    }
}