//User Trigger Handler to handle User object Triggers.

public without sharing class UserTriggerHandler{
    public static boolean isExecuted = true;
    
    
    public static void executeTriggerEvents
            (List<User> newUsers,Map<id,User> newMap, Map<id,User> oldMap,boolean isInsert, boolean isUpdate,boolean isBefore, boolean isAfter){
        
           
           if(isAfter && (isInsert || isUpdate)){
               if(isExecuted ){
                    isExecuted = false;
                    updateSalesRegionalManager(newUsers,newMap,oldMap,isInsert,isUpdate);
               }
                
            }
            if(isAfter && isUpdate){ 
                Map<string,string> userManagerIdMap=new Map<string,string>();
                for(User u: newUsers){
                 //if condition added to check LM_Regional_Manager is getting changed (VAC-512)
                 if(u.LM_Regional_Manager__c!=null){
                 if(oldMap.get(u.id).LM_Regional_Manager__c!=newMap.get(u.id).LM_Regional_Manager__c && newMap.get(u.id).LM_Regional_Manager__c!=null && u.isActive==true){
                        userManagerIdMap.put(u.id,u.LM_Regional_Manager__c);
                    }
                   }                
                } 
                //VAC-512 start
                //DateTime batchStartTime= System.now();
                UpdateLeadsSalesRegionalManagerBatch updlead = new UpdateLeadsSalesRegionalManagerBatch(userManagerIdMap);
                if(!System.isFuture()){
                    Database.executeBatch(updlead);
                }
                
               // VAC-512 ends                
               // updateLeadsSalesRegionalManager(userManagerIdMap,isInsert,isUpdate);
              
            }
            if(isAfter && isUpdate){ // Added by Shovon as per SFD-497
                List<ID> userIds = new List<Id>();
                List<Id> userRecordId = new List<Id>();
                for(User u: newUsers){
                    if(u.ManagerId != oldMap.get(u.Id).ManagerId){
                        userIds.add(u.Id);
                        //Changes for renewals cancellation to change the manager's email on Opportunity.
                        if(u.Sales_Org__c == 'GLI' && u.Sub_Bu__c == 'UKI'){
                            userRecordId.add(u.Id);
                        }
                        
                        //Renewal cancellation chan
                    }
                }
                //Start - commenting as part of DPS-17684
                /* if(userIds.size() > 0){
                    mngOfReservationMngUpdateOnQuote(userIds);
                } */
                //End - commenting as part of DPS-17684
                
                if(userRecordId.size() >0){
                    emailUpdateOnOpportunity(userRecordId);
                }
            }
            
            //MCL-1522
            if(isBefore && isUpdate){
                UpdateLevelMgr(newUsers,oldMap);
            
            }
            
            //DPS-2818 starts
            //Global User for Region and Segment
            if(isAfter && isInsert )
            {
                Set<ID> idRegSegAdd = new Set<ID>();
                if(newUsers.size() > 0)
                {
                    for(User u: newUsers)
                    {
                        if((u.Sub_Bu__c != Null && u.Sub_Bu__c != '') && (u.Segment__c != Null && u.Segment__c != ''))
                        {
                            System.debug('@@@Inside isInsert for addition');
                            idRegSegAdd.add(u.id);
                        }
                    }
                 }
                 UserRegionSegmentGroupMapping.UserRegSegGrpAssignment(idRegSegAdd);         
            }
            if(isAfter && isUpdate )
            {
                Set<ID> idRegSegDel = new Set<ID>();
                if(newUsers.size() > 0)
                {
                    for(User u: newUsers)
                    {
                        if((oldMap.get(u.Id).Sub_Bu__c != u.Sub_Bu__c) || (oldMap.get(u.Id).Segment__c != u.Segment__c) )
                        {
                            System.debug('@@@Inside isUpdate for deletion');
                            idRegSegDel.add(u.id);
                        }
                    }
                 }
                UserRegionSegmentGroupMapping.UserRegSegGrpDeletion(idRegSegDel);   
                UserRegionSegmentGroupMapping.UserRegSegGrpAssignment(idRegSegDel);
            }
            //DPS-2818 ends
   } 
    // This method updates LM REgional Manager field to User Id by matchingn the Regional Manager Name free text field.
   /* @future
    static void  updateLeadsSalesRegionalManager(Map<string,string> userManagerIdMap,boolean isInsert, boolean isUpdate){

        List<Lead> leadsToUpd= new List<Lead>();   
        List<Lead> leadsToUpdate= [SELECT Id,OwnerId FROM LEAD WHERE OwnerId IN : userManagerIdMap.keySet() and isConverted = false];
        system.debug('***leadsToUpdate' +leadsToUpdate);
        if(leadsToUpdate!= null && leadsToUpdate.size() >0){
            for(Lead l: leadsToUpdate){        
                //if(isInsert || (isUpdate && oldMap.get(l.Regional_Mgr__c) != newMap.get(U.Regional_Mgr__c))){
                
                // }
                if(userManagerIdMap.get(l.ownerId) != null){
                    l.Regional_Manager__c = userManagerIdMap.get(l.ownerId);
                    leadsToUpd.add(l);    
                }       
            }
        }
        
        if(leadsToUpd!= null && leadsToUpd.size() >0){
            //try{
                system.debug('***leadsToUpd' +leadsToUpd);
                UPDATE leadsToUpd;
            //}
            //Catch(DMLException dmlEx){
                
            
            //}
        }
    }*/
    
     public  static void  updateSalesRegionalManager(List<User> newUsers,Map<id,User> newMap, Map<id,User> oldMap,boolean isInsert, boolean isUpdate){
    
         
         SET<String> MGRNamesSet= new SET<String>();
         
         Map<String,User> ManagerNAmeToIdMap= new Map<String,User>();
         List<User> userManagerList = new List<User>();
         system.debug('***newUsers'+newUsers);
         for(User u:newUsers){
            MGRNamesSet.add(u.Regional_Mgr__c);  
            
         }
         system.debug('***MGRNamesSet' +MGRNamesSet);
         if((Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable())){
             userManagerList= [SELECT Id,Name,Regional_Mgr__c FROM USER WHERE NAME IN : MGRNamesSet];
         
         }
         system.debug('***userList' +userManagerList);
         if(userManagerList!= null && userManagerList.size() >0){
             for(User u:userManagerList){
                 ManagerNAmeToIdMap.put(u.Name,u);                      
             }   
             system.debug('***ManagerNAmeToIdMap' +ManagerNAmeToIdMap);
         }
         List<User> UsersToUpdate = new List<User>();
         List<User> userList= new List<User>();
         if((Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable())){
            userList =  [SELECT Id,Name,Regional_Mgr__c,LM_Regional_Manager__c FROM USER WHERE Id IN :newMAp.keySet()];
         
         }
         for(User u: userList){
             system.debug('***inside' +u.Regional_Mgr__c);
             if(ManagerNAmeToIdMap!= null && ManagerNAmeToIdMap.get(u.Regional_Mgr__c) != null){
                 u.LM_Regional_Manager__c = ManagerNAmeToIdMap.get(u.Regional_Mgr__c).Id ;
                 UsersToUpdate.add(u);
                
                 system.debug('***LM_Regional_Manager__c' +u.LM_Regional_Manager__c);
             }         
         }
         
         if(UsersToUpdate!= null && UsersToUpdate .size() >0){
         
         if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isUpdateable()){
             Update UsersToUpdate;
         }
         
         }
         
         
     }
     
     //Start - commenting as part of DPS-17684
     // This method update manager of reservation manager on quote when there is manager update on user.
    /* @future
    public static void mngOfReservationMngUpdateOnQuote(List<ID> userIds){
        Map<ID, User> usrMngMap = new Map<ID, User>([SELECT Id, ManagerID FROM USER Where Id IN: userIds]);
        List<Quote> quoteList = new List<Quote>([SELECT Id, Reservation_Manager__r.Id, Manager_of_Reservation_Manager__r.Id FROM Quote WHERE Reservation_Manager__c != NULL AND Reservation_Manager__r.Id IN: usrMngMap.keyset() AND Opportunity.IsClosed = FALSE]);
        for(Quote q: quoteList){
            q.Manager_of_Reservation_Manager__c = usrMngMap.get(q.Reservation_Manager__r.Id).ManagerID;
        }
        
        Database.update(quoteList, false);
    } */
    //End - commenting as part of DPS-17684
    
    //MCL-1522  Update Level Manager field when deactivating a user
    public static void UpdateLevelMgr(List<User> newUsers,Map<id,User> oldMap)
    {
        
        Map<Id,Id> levelMgrMap = new Map<Id,Id>();
        for(User u: newUsers){
         
            if(oldMap.get(u.Id).isActive != u.isActive && !u.isActive){
            levelMgrMap.put(u.Id,u.Id);
            
            }
        }
        
        
        List<User> users =  new List<User>();
        if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
            users = [Select Id,LM_Regional_Manager__c,Level_2_Manager__c,Level_3_Manager__c, Level_4_Manager__c, Level_5_Manager__c, 
                                  Level_6_Manager__c,Level_7_Manager__c from User where
                                                    LM_Regional_Manager__c in :levelMgrMap.keySet() or
                                                    Level_2_Manager__c in :levelMgrMap.keySet() or
                                                    Level_3_Manager__c in :levelMgrMap.keySet() or
                                                    Level_4_Manager__c in :levelMgrMap.keySet() or
                                                    Level_5_Manager__c in :levelMgrMap.keySet() or
                                                    Level_6_Manager__c in :levelMgrMap.keySet() or
                                                    Level_7_Manager__c in :levelMgrMap.keySet() ];
        }                                           
            for(User u: users){
                
                if(!levelMgrMap.isEmpty()){
                
                    if(levelMgrMap.containskey(u.LM_Regional_Manager__c))u.LM_Regional_Manager__c=null;
                    if(levelMgrMap.containskey(u.Level_2_Manager__c))u.Level_2_Manager__c =null;
                    if(levelMgrMap.containskey(u.Level_3_Manager__c ))u.Level_3_Manager__c =null;
                    if(levelMgrMap.containskey(u.Level_4_Manager__c ))u.Level_4_Manager__c =null;
                    if(levelMgrMap.containskey(u.Level_5_Manager__c ))u.Level_5_Manager__c =null;
                    if(levelMgrMap.containskey(u.Level_6_Manager__c ))u.Level_6_Manager__c =null;
                    if(levelMgrMap.containskey(u.Level_7_Manager__c ))u.Level_7_Manager__c =null;
                }
            
            }
            
            if(!users.isEmpty()){
                if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isUpdateable()){
                    update users;
                }
            }
    
    }
    
    //Renewals Cancellation - Update the Manager email on all Open Opportunity
    @future
    public static void emailUpdateOnOpportunity(List<ID> userIds){
        Map<ID, User> usrMngMap = new Map<ID, User>([SELECT Id, Manager.Email FROM USER Where Id IN: userIds]);
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, OwnerId FROM Opportunity WHERE OwnerId =: userIds AND Opportunity.IsClosed = FALSE AND Opportunity.is_Gli__c = TRUE AND Opportunity.LCRM_Sub_BU__c ='UKI' ]);
        for(Opportunity oppRec: oppList){
            oppRec.LCRM_Owners_Manager_Email__c = usrMngMap.get(oppRec.OwnerId).Manager.Email;
        }
        Database.update(oppList, false);
    }


}