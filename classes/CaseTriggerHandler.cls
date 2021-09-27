/**
 * Class for populating Manager field in Case Object when Case is created/updated
 *
 * @author  Bhaskar Srinivas
 * @version 2013-07-23
 */

/**
 * CHANGE HISTORY
 * =================================================================================================================================================================
 * Date         Name                   Description
 * 2013-07-23   Bhaskar Srinivas       Created        
 * 2014-04-15   Nandita Shet           MCL-306 UpdateCaseOwner method added 
 * 2015-05-06   Sreenu D               Changed the "updateManager" method to get the Regional Manager based on the Sales person. 
 * 2016-03-11   Asha Aramani           Updated updateManager method to include following functionaliy as part of ICP Project requirement
                                       1. For SCS-Inquiry Cases, When case is created/modified check for salesperson field and assign Regional Manager Inquiry field
                                          on the case to LM Regional Manager/L2 Manager/L3 Manager/ L4 Manager based on their availabilty on the User record of Salesperson.
                                       2. Assign Regional manager Inquiry field to Case Owner,  as part of Case routing.
 *  2017-01-23   Saloni Sukhija         Added updateCaseOwner,sendEmailtoSalesRep,insertCaseTeamMember,sendQuoteRequestCancellationEmail for CPQ                                           
 * 2017-02-21   Nitesh Choudhary       Added "populateAccountonCase" method as part ANZ Stabilization Phase2 (JIRA Story STB-9)
 * 2017-05-29    Saloni Sukhija        Added initialiseTrainingEventCaseValues for CRM-3230
   2017-07-27    Shovon Bera           Changes in  method updateCaseTeamManager w.r.t. CRM-4742                                        
 * ===================================================================================================================================================================
 */



public without sharing class CaseTriggerHandler {
// public static boolean bflag = true;
 public static boolean chkRecursion = false;
 public static boolean updateManagerCalled = false;
 public static void updateManager(map<Id, Case> mapOldCases, list<Case> listNewCases, boolean isInsert){
     updateManagerCalled = true;
     list<Id> listUserId = new list<Id>();
     list<User> salesUsers = new list<User>();
     list<User> salesUsersRM = new list<User>();
     map<string, User> userRmMap = new map<string, User>();
        
    //Id caseRecordTypeSCSInquiry = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
    Id caseRecordTypeSCSInquiry  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCS_Inquiry').getRecordTypeId();
    //Id caseRecordTypeFindlawInquiry = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Findlaw Inquiry').getRecordTypeId();
    Id caseRecordTypeFindlawInquiry = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Findlaw_Inquiry').getRecordTypeId();
     for(Case oCase:listNewCases) {
            if(String.valueOf(oCase.RecordTypeId)==caseRecordTypeSCSInquiry || String.valueOf(oCase.RecordTypeId)==caseRecordTypeFindlawInquiry){
             if(oCase.Salesperson__c==null){
                 oCase.Salesperson__c=UserInfo.getUserId();
             }
            listUserId.add(oCase.Salesperson__c);
        }
      }
      
     if(listUserId.size()>0){ 
     // Inquiry_Manager Queue
     string InqryMgrQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Inquiry_Manager' LIMIT 1].Id;
     string InqryMgrFindlawQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Inquiry_Manager_Findlaw' LIMIT 1].Id;
        
     for(User SalesRep : [SELECT Id, LM_Regional_Manager__c, Level_2_Manager__c, Level_3_Manager__c, Level_4_Manager__c FROM User where Id in :listUserId]){
                      
            if(SalesRep!= Null){                        
                userRmMap.put(SalesRep.id, SalesRep);             
             }  
     }     
     
    if(isInsert){
         
       for(Case oCase:listNewCases) {    
            if (userRmMap.isEmpty()) {
                 oCase.Regional_Manager_lkp__c = null;       
            }
                                 
        }
                    
     }
       else{
        for(Case oCase: listNewCases) {
        
           // if(mapOldCases.get(oCase.Id).Salesperson__c != oCase.Salesperson__c || oCase.OwnerId == InqryMgrQueueId || oCase.OwnerId == InqryMgrFindlawQueueId || ocase.OwnerId == ocase.CreatedById || mapOldCases.get(oCase.Id).Regional_Manager_lkp__c != oCase.Regional_Manager_lkp__c){
                if (userRmMap.isEmpty()) {
                 oCase.Regional_Manager_lkp__c = null;       
                }
                else if(!userRmMap.isEmpty()){
                    if(userRmMap.get(oCase.Salesperson__c).LM_Regional_Manager__c == null) {
                    
                        if(userRmMap.get(oCase.Salesperson__c).Level_2_Manager__c == null){
                        
                            if(userRmMap.get(oCase.Salesperson__c).Level_3_Manager__c == null){
                            
                                if(userRmMap.get(oCase.Salesperson__c).Level_4_Manager__c == null){
                                
                                    oCase.Regional_Manager_lkp__c = null;                           
                                }else{
                                     oCase.Regional_Manager_lkp__c = userRmMap.get(oCase.Salesperson__c).Level_4_Manager__c; 
                                }                                                   
                            }else{                        
                                oCase.Regional_Manager_lkp__c = userRmMap.get(oCase.Salesperson__c).Level_3_Manager__c;
                            }
                        
                         }else{                     
                             oCase.Regional_Manager_lkp__c = userRmMap.get(oCase.Salesperson__c).Level_2_Manager__c;                     
                        }             
                        
                    } else {
                         oCase.Regional_Manager_lkp__c = userRmMap.get(oCase.Salesperson__c).LM_Regional_Manager__c;
                         
                    }
                }
                
            //}
            
            // Change the owner of case to the LM Regional Manager/L2 Manager/L3 Manager/L4 Manager if available on Salesperson User record
            // else to case creator.
            if(oCase.OwnerId == InqryMgrQueueId || oCase.OwnerId == InqryMgrFindlawQueueId){
            
                 if(oCase.Regional_Manager_lkp__c != null) {                
                ocase.OwnerId = ocase.Regional_Manager_lkp__c;
                //skg to set status to assigned
                ocase.status = 'Assigned';
                
                 } else {
                 ocase.OwnerId = UserInfo.getUserId();
                 }
             }            
          
           }
        }
    
   }
   
    listUserId = new List<Id>();
    for(Case oCase:listNewCases) {
        listUserId.add(oCase.OwnerId);
    }
    Map<Id, User> userMap = new Map<Id, User>([SELECT Id, ManagerID FROM User where Id in :listUserId]);
    if(isInsert){
        for(Case oCase:listNewCases) {    
            if ( userMap.get(oCase.OwnerId)!= NULL) {
                    oCase.Manager__c = userMap.get(oCase.OwnerId).ManagerID; 
            }
            else{
                oCase.Manager__c = null;
            }
        }
 
    }
    else{
        for(Case oCase: listNewCases) {
            if(mapOldCases.get(oCase.Id).OwnerId != oCase.OwnerId){
                if ( userMap.get(oCase.OwnerId) != NULL){
                    oCase.Manager__c = userMap.get(oCase.OwnerId).ManagerID;
                }
                else{
                    oCase.Manager__c = null;
                }
            }
        }
    } 
   
 }
 
 
 public static void updateCaseTeamManager(map<Id, Case> mapOldCases, list<Case> listNewCases, boolean isInsert){
    list<Id> listCaseId = new List<Id>();
    list<Id> CaseId = new list<Id>();
    map<Id, Case> caseMap = new map<Id, Case>();
    map<string, CaseTeamRole> ctRoleMap = new map<string, CaseTeamRole>();
    list<CaseTeamMember> ctm = new List<CaseTeamMember>();
    list<Id> ctmParentId = new List<Id>();
    list<CaseTeamMember> ctmUpdate = new List<CaseTeamMember>();
    Id caseTeamSalesRoleId;
    Id caseTeamSalesGLIRoleId;
    // get the Sales Case Team Role Id
    /* Commented below query w.r.t. CRM-4742
    Id caseTeamSalesRoleId = [SELECT Id,Name FROM CaseTeamRole WHERE Name ='Sales'].Id;
    */
    // START changes w.r.t. CRM-4742 by Shovon
    List<CaseTeamRole> caseTeamRoleList = new List<CaseTeamRole>([SELECT Id, Name FROM CaseTeamRole WHERE Name IN ('Sales', 'Sales-GLI')]);
    for(CaseTeamRole ctr: caseTeamRoleList){
        if(ctr.Name == 'Sales'){
            caseTeamSalesRoleId = ctr.Id;
        }
        else if(ctr.Name == 'Sales-GLI'){
            caseTeamSalesGLIRoleId = ctr.Id;
        }
    }
    // END changes w.r.t. CRM-4742
    
    system.debug('Sales role Id..'+ caseTeamSalesRoleId);
    // Getting the Case team roles to map
   /* for(CaseTeamRole ctr : [SELECT Id,Name FROM CaseTeamRole WHERE Name IN ('Sales Rep', 'Manager/Resolver')]) {
        ctRoleMap.put(ctr.Name, ctr);
       } */
    
    //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
    Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId(); 
    //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
    Id caseRecordTypeEliteClosedCPQ =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId();  
    for(Case oCase:listNewCases) {
        if(((oCase.Salesperson__c != NULL) || (oCase.Regional_Manager_lkp__c != NULL)) && (String.valueOf(oCase.RecordTypeId)!=caseRecordTypeEliteCPQ) && (String.valueOf(oCase.RecordTypeId)!=caseRecordTypeEliteClosedCPQ)){
            CaseId .add(oCase.Id);
            
         }
    }
    
    system.debug('Case Id List...' + caseId);
    if(CaseId.size() > 0) {
        for(Case caseRec : [SELECT Id, Salesperson__c,Salesperson__r.name, Regional_Manager_lkp__c,Regional_Manager_lkp__r.name FROM Case where Id in :CaseId]){
    
            caseMap.put(caseRec.Id, caseRec);
        }
    }
    
    system.debug('Case Map..'+caseMap);
    if(isInsert){
        for(Case oCase:listNewCases) {
        system.debug('Case Map Id..'+caseMap.containsKey(oCase.Id));
            if(caseMap.containsKey(oCase.Id)) {
                CaseTeamMember ctmadd = new CaseTeamMember();
                CaseTeamMember ctmadd1 = new CaseTeamMember();
                system.debug('Case Map Sales..'+caseMap.get(oCase.Id).Salesperson__c != NULL);
                system.debug('Case Map Sales..'+caseMap.get(oCase.Id).Regional_Manager_lkp__c  != NULL);
                
                if(caseMap.get(oCase.Id).Salesperson__c != NULL && oCase.Salesperson__c != oCase.OwnerID){
                    ctmadd.ParentId = oCase.Id;
                    system.debug('Case Id..'+oCase.Id);
                    //ctmadd.ParentId = caseMap.get(oCase.Id).Id;                
                    ctmadd.MemberId = caseMap.get(oCase.Id).Salesperson__c;
                    //ctmadd.TeamRoleId = ctRoleMap.get(System.Label.Case_Team_Role_Sales_Rep).Id;
                    ctmadd.TeamRoleId = caseTeamSalesRoleId;
                    ctm.add(ctmadd);
                }
                
                if(caseMap.get(oCase.Id).Regional_Manager_lkp__c != NULL && oCase.Regional_Manager_lkp__c != oCase.OwnerID) {
                    ctmadd1.ParentId = oCase.Id;
                    system.debug('Case Id..'+oCase.Id);
                    //ctmadd.ParentId = caseMap.get(oCase.Id).Id;  
                    ctmadd1.MemberId = caseMap.get(oCase.Id).Regional_Manager_lkp__c;
                    //ctmadd1.TeamRoleId = ctRoleMap.get(System.Label.Case_Team_Role_Manager_Resolver).Id;
                    ctmadd1.TeamRoleId = caseTeamSalesRoleId;
                    ctm.add(ctmadd1);
                }
              }
              // add the created user as a Team member if sales person and owner not same
              if((oCase.Salesperson__c != oCase.CreatedByID) && (oCase.Salesperson__c != oCase.OwnerID)) {
                  CaseTeamMember addCtm = new CaseTeamMember();
                  addCtm.ParentId = oCase.Id;
                    system.debug('Case Id..'+oCase.Id);
                    //ctmadd.ParentId = caseMap.get(oCase.Id).Id;                
                     if(oCase.CreatedBy.name!=null){
                     system.debug('ins1Case Id creator..'+oCase.CreatedByID);
                        addCtm.MemberId = oCase.CreatedByID;
                     }
                    else{
                    system.debug('ins2Case Id creator..'+oCase.Salesperson__c);
                        addCtm.MemberId = oCase.Salesperson__c;
                    }
                    //ctmadd.TeamRoleId = ctRoleMap.get(System.Label.Case_Team_Role_Sales_Rep).Id;
                    /* Commented w.r.t. CRM-4742
                    addCtm.TeamRoleId = caseTeamSalesRoleId;
                    */
                    // START changes w.r.t. CRM-4742 by Shovon
                    if(FieldId__c.getOrgDefaults().DQA_Request_Case__c != null && oCase.RecordTypeId!=null && String.valueOf(oCase.RecordTypeId).contains(FieldId__c.getOrgDefaults().DQA_Request_Case__c)){
                        addCtm.TeamRoleId = caseTeamSalesGLIRoleId;
                        
                    }
                    else{
                        addCtm.TeamRoleId = caseTeamSalesRoleId;
                    }
                    // END changes w.r.t. CRM-4742

                    ctm.add(addCtm);
              }
          }
      }   
      else {
                       
           for(Case oCase: listNewCases) {
               system.debug('Sales..'+ oCase.Salesperson__c);
               system.debug('Salesold..'+ mapOldCases.get(oCase.Id).Salesperson__c);
               system.debug('SalesRM..'+ oCase.Regional_Manager_lkp__c);
               system.debug('Salesold..'+ mapOldCases.get(oCase.Id).Regional_Manager_lkp__c);
               
            if(mapOldCases.get(oCase.Id).Salesperson__c != oCase.Salesperson__c ||(caseMap.containsKey(oCase.Id) &&  oCase.Salesperson__c != NULL && oCase.Salesperson__c != oCase.OwnerID )||mapOldCases.get(oCase.Id).Regional_Manager_lkp__c!= oCase.Regional_Manager_lkp__c){
            system.debug('Salesold..'+ mapOldCases.get(oCase.Id).Salesperson__c);
                if(caseMap.containsKey(oCase.Id) &&  oCase.Salesperson__c != NULL && oCase.Salesperson__c != oCase.OwnerID ) {
                    CaseTeamMember ctmadd2 =  new CaseTeamMember();
                    ctmParentId.add(oCase.Id); 
                    ctmadd2.ParentId = oCase.Id;                                                  
                    ctmadd2.MemberId = caseMap.get(oCase.Id).Salesperson__c;
                    //ctmadd2.TeamRoleId = ctRoleMap.get(System.Label.Case_Team_Role_Sales_Rep).Id;
                    ctmadd2.TeamRoleId = caseTeamSalesRoleId;
                    if(caseMap.get(oCase.Id).Salesperson__r.name !=null){
                    ctmUpdate.add(ctmadd2);
                    }
                    }
                    
                
                else if(caseMap.containsKey(oCase.Id) &&  oCase.Salesperson__c == NULL) {
                                              
                    ctmParentId.add(oCase.Id);
                }
            }
            
            if(mapOldCases.get(oCase.Id).Regional_Manager_lkp__c!= oCase.Regional_Manager_lkp__c ||(caseMap.containsKey(oCase.Id) &&  oCase.Regional_Manager_lkp__c!= NULL && oCase.Regional_Manager_lkp__c != oCase.OwnerID)){
            //system.debug('SalesRM..'+ oCase.Regional_Manager_lkp__c);
                if(caseMap.containsKey(oCase.Id) &&  oCase.Regional_Manager_lkp__c!= NULL && oCase.Regional_Manager_lkp__c != oCase.OwnerID) {
                    CaseTeamMember ctmadd2 =  new CaseTeamMember();
                    ctmParentId.add(oCase.Id); 
                    ctmadd2.ParentId = oCase.Id;               
                    ctmadd2.MemberId = caseMap.get(oCase.Id).Regional_Manager_lkp__c;
                    //ctmadd2.TeamRoleId = ctRoleMap.get(System.Label.Case_Team_Role_Manager_Resolver).Id;
                    ctmadd2.TeamRoleId = caseTeamSalesRoleId;
                    if(caseMap.get(oCase.Id).Regional_Manager_lkp__r.name !=null){
                    ctmUpdate.add(ctmadd2);
                    }
                    }
                
                else if(caseMap.containsKey(oCase.Id) &&  oCase.Regional_Manager_lkp__c== NULL) {
                    ctmParentId.add(oCase.Id);
                }
              } 
                      
            }
          }
         
       system.debug('@@@@ctm List..'+ctm); 
       if(ctm.size() >0) {
           try{
               if(Schema.sObjectType.CaseTeamMember.isCreateable()){
                insert ctm;
               }
               } 
           catch(DMLException ex) {
               system.debug('exception occured');
           }
          }
                   
       system.debug('ctm Parent..'+ ctmParentId);  
       if(ctmParentId.size() > 0){
           try{
               if(Schema.sObjectType.CaseTeamMember.isDeletable()){
                   Delete [SELECT Id FROM CaseTeamMember WHERE ParentId IN :ctmParentId];}
           } 
           catch(DMLException ex) {
               system.debug('exception occured');
           }
           }
       system.debug('ctm update..'+ ctmUpdate);      
       if(ctmUpdate.size() > 0) {
           try{
               if(Schema.sObjectType.CaseTeamMember.isCreateable()){
                   insert ctmUpdate;}
           } 
           catch(DMLException ex) {
               system.debug('exception occured');
           }
        }  
   }     


// Check the Case share object after Case is re Open after close with Case Team and If Member is not found in Case Share, Insert.              
    public static void updateCaseShareRec(map<Id, Case> mapOldCases, list<Case> listNewCases, boolean isInsert) {
    
    //Id caseRecordTypeSCSInquiry = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
    //Id caseRecordTypeFindlawInquiry = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Findlaw Inquiry').getRecordTypeId();  
    Id caseRecordTypeSCSInquiry = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCS_Inquiry').getRecordTypeId();    
    Id caseRecordTypeFindlawInquiry  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Findlaw_Inquiry').getRecordTypeId();
        map<Id, CaseShare> caseShareMap = new map<Id, CaseShare>();
        map<Id, CaseTeamMember> CaseTeamMemberMap = new map<Id, CaseTeamMember>();
        list<CaseShare> caseShareInsertList = new list<CaseShare>();
        list<Id> CaseList = new list<Id>();
        
        if(!isInsert) {
        for(Case oCase: listNewCases) {
        //system.debug('Owner Change..'+ (mapOldCases.get(oCase.Id).OwnerId != OCase.OwnerId));
          if(String.valueOf(oCase.RecordTypeId)==caseRecordTypeSCSInquiry || String.valueOf(oCase.RecordTypeId)==caseRecordTypeFindlawInquiry){
            if(mapOldCases.get(oCase.Id).OwnerId != OCase.OwnerId) {
                caseList.add(oCase.Id);      
            
              }
          }     
        }
        
        if(caseList.size()>0){
        
        for(CaseShare oCaseShare :[SELECT CaseAccessLevel,CaseId,UserOrGroupId FROM CaseShare WHERE CaseId IN :caseList]) {
            caseShareMap.put(oCaseShare.UserOrGroupId, oCaseShare);
         }  
        
        for(CaseTeamMember oCaseTeamMember  :[SELECT MemberId,ParentId,TeamRoleId FROM CaseTeamMember WHERE ParentId IN :caseList]) {
            CaseTeamMemberMap.put(oCaseTeamMember.ParentId, oCaseTeamMember);
         }
                    
       for(Case oCase: listNewCases) {
           if(mapOldCases.get(oCase.Id).OwnerId != OCase.OwnerId) {
               for(CaseTeamMember caseTeamLoop :CaseTeamMemberMap.values()) {
                   
                   //system.debug('Case Share find..'+ (!caseShareMap.containsKey(CaseTeamMemberMap.get(oCase.Id).MemberId)));  
                   if(!caseShareMap.containsKey(CaseTeamMemberMap.get(oCase.Id).MemberId)){
                       CaseShare caseShareRec = new CaseShare();
                       caseShareRec.CaseId = oCase.Id;
                       caseShareRec.UserOrGroupId = CaseTeamMemberMap.get(oCase.Id).MemberId;
                       //caseShareRec.RowCause ='ImplicitChild';  
                      // if(CaseTeamMemberMap.get(oCase.Id).MemberId == oCase.Salesperson__c) 
                      //this condition is commented because of Sales person and manager both should have read access 
                           caseShareRec.CaseAccessLevel = 'Read';
                     /*  else 
                       caseShareRec.CaseAccessLevel = 'Edit'; */
                       
                       caseShareInsertList.add(caseShareRec);   
                   
                        
                   }
               }
                       CaseShare caseShareRec = new CaseShare();
                       caseShareRec.CaseId = oCase.Id;
                       if(String.valueof(mapOldCases.get(oCase.Id).OwnerId).startswith('005')){
                       caseShareRec.UserOrGroupId = mapOldCases.get(oCase.Id).OwnerId;
                       }else{
                       caseShareRec.UserOrGroupId = Userinfo.getUserId();
                       }
                       caseShareRec.CaseAccessLevel = 'Read';
                       caseShareInsertList.add(caseShareRec);  
            }
         }
        } 
     }
     //system.debug('caseShareInsertList..'+caseShareInsertList);
     if(caseShareInsertList.size() > 0){
         try {
             if(Schema.sObjectType.CaseShare.isCreateable()){
                 insert caseShareInsertList;}
             }
         catch(DMLException ex){
             system.debug('exception occured');
             } 
      }
       
       /* if(oCase.Salesperson__c == caseMap.get(oCase.Id).Salesperson__c){
                        
                        
                    }
                    else if(oCase.Regional_Manager_lkp__c == caseMap.get(oCase.Id).Regional_Manager_lkp__c){
                            
                    } */
   /* Map<Id, User> userMap = new Map<Id, User>([SELECT Id, ManagerID FROM User where Id in :listUserId]);
    system.debug('testisinsert' + isInsert);
    if(isInsert){
        for(Case oCase:listNewCases) {    
            if ( userMap.get(oCase.OwnerId)!= NULL) {
                       CaseTeamMember ctmadd = new CaseTeamMember();
            ctmadd.ParentId = oCase.id;
            //ctmadd.MemberId = userMap.get(oCase.OwnerId).ManagerID;
            ctmadd.MemberId = oCase.Regional_Manager_lkp__c; 
            //ctmadd.TeamRoleId = '0B7A0000000PFuq';
            ctmadd.TeamRoleId = '0B719000000003j';
system.debug('skg first ctmadd...' + ctmadd);
                ctm.add(ctmadd);
            CaseTeamMember ctmadd1 = new CaseTeamMember();    
            ctmadd1.ParentId = oCase.id;
            //ctmadd1.MemberId = oCase.OwnerId;
            ctmadd1.memberId = oCase.Sales_Rep__C;
            //ctmadd1.MemberId = '00530000004cQEU';
            //ctmadd.TeamRoleId = '0B7A0000000PFuq';
            ctmadd1.TeamRoleId = '0B719000000003e';
system.debug('skg second ctmadd...' + ctmadd1);
                ctm.add(ctmadd1);
                



                //insert ctm;
                   
            }
          else{
               // oCase.Manager__c = null;
            }

            }
 
    }
    else{
        for(Case oCase: listNewCases) {
            if(mapOldCases.get(oCase.Id).OwnerId != oCase.OwnerId){
                if ( userMap.get(oCase.OwnerId) != NULL){
                    oCase.Manager__c = userMap.get(oCase.OwnerId).ManagerID;
                }
                else{
                    oCase.Manager__c = null;
                }
            }
        }
    }
    system.debug('testing insert... ' + ctm);
     insert ctm; */
 } 
 
 
     /****************MCL-306*******************************/
  /*   public static void UpdateCaseOwner(List<Case> listcases){
       List<Id> listAccountId = new List<Id>();
       Map<Id,Id> mapAccountManager = new Map<Id,Id>();
       bflag = false;
       for(Case oCase : listcases){
         listAccountId.add(oCase.AccountId);
       }
     
       for(AccountTeamMember oAccMember : [Select AccountId,UserId from AccountTeamMember where AccountId IN : listAccountId]){
           mapAccountManager.put(oAccMember.AccountId,oAccMember.UserId);
       }
       Database.DMLOptions dmlOpts = new Database.DMLOptions();
       dmlOpts.assignmentRuleHeader.assignmentRuleId=null;
       dmlOpts.assignmentRuleHeader.useDefaultRule = false;

       
       for(Case oCase : listcases){
         if(mapAccountManager.containsKey(oCase.AccountId)){
          if((oCase.Created_By_Trigger__c == true && oCase.CreatedDate != oCase.LastModifiedDate) || oCase.Created_By_Trigger__c == false)
           oCase.OwnerId = mapAccountManager.get(oCase.AccountId);
           oCase.Has_Account_Manager__c = false;
           oCase.setOptions(dmlOpts);
       }
     }
     }*/
    
    //Added as part ANZ stabilization phase2 for populating Account in Case record on the basis of account number entered in web-to-case webform
    public static void populateAccountonCase(List<Case> listcases){
        
        List<String> anzAccountNumber = new List<String>(); //stores Account Number entered in webform
        List<Case> casesToUpdate = new List<Case>(); //Contains cases which should be updated by the trigger
    
        try{        
            for (Case caseObj : listcases) {
                if ((caseObj.Origin == 'Email ANZ Contact' || caseObj.Origin == 'Email ANZ TechCare') &&  
                    (caseObj.Sales_Org__c == 'BKRS' || caseObj.Sales_Org__c == 'LRA') && 
                    caseObj.ANZ_Account_Number__c != '' && 
                    caseObj.ANZ_Account_Number__c != null &&
                    caseObj.ContactId == null)
                {
                    anzAccountNumber.add(caseObj.ANZ_Account_Number__c);
                    casesToUpdate.add(caseObj);
                }
            }
            
            Map<String,Account> mapSAPNumberAccount = new Map<String,Account>(); //Map of SAP Account Number and Account record
            
            if(anzAccountNumber!=null && !anzAccountNumber.isEmpty()){
                for(Account acc : [Select Id,SAPAccountNumber__c From Account Where SAPAccountNumber__c in :anzAccountNumber]){
                    mapSAPNumberAccount.put(acc.SAPAccountNumber__c, acc);
                }
            }
            
            for(Case cas : casesToUpdate){
                if(mapSAPNumberAccount.containsKey(cas.ANZ_Account_Number__c)){
                    cas.AccountId = mapSAPNumberAccount.get(cas.ANZ_Account_Number__c).Id;
                }
            }
        }
        catch(Exception e){
            System.debug('Error : '+e);
        }
    }
    //End of ANZ stabilization phase2 code
    
    // CRM-784 - updating Case Owner for CPQ quote request on changing the status to sales
     public static void updateCaseOwner(Map<Id,Case> oldcasesMap, List<Case> newcasesList){
         if(checkrecursive.runupdatecaseowner == true){
            checkrecursive.runupdatecaseowner = false;
            
        List<Id> oppIdList = new List<Id>();
        List<Id> recordtypesIdList = new List<Id>();
        
         for(Case c: newcasesList){
             oppIdList.add(c.Opportunity__c);
         }
         Map<Id,Opportunity> opptys = new Map<Id,Opportunity>([SELECT Id,OwnerId FROM Opportunity WHERE id IN :oppIdList]);
    
        
         for(Case c:newcasesList){
             system.debug('@@@'+c.RecordTypeId+c.casenumber+c);
             if(c.RecordTypeId!=null){
             recordtypesIdList.add(c.RecordTypeId);
             }
         }
         Map<Id,RecordType> recordtypes = new Map<Id,RecordType>([Select Id,DeveloperName from RecordType where id in :recordtypesIdList]);
         
         
        for(Case newcase:newcasesList){
            if(newcase.RecordTypeId!=null && recordtypes.get(newcase.RecordTypeId).DeveloperName == 'Elite_CPQ_Requests' && (newcase.Status == 'Sales' && oldcasesMap.get(newcase.id).Status != 'Sales')){
                if(newcase.Opportunity__c!=null){
                    newcase.OwnerId = opptys.get(newcase.Opportunity__c).OwnerId;
                }
            }
        }
    }
}
    
    // CRM-785 - sending Email to Sales Rep for CPQ quote request on changing the status to sales
    public static void sendEmailtoSalesRep(Map<Id,Case> oldCases,Map<Id,Case> newCases){
         if(checkrecursive.runsendEmailtoSalesRep == true){
            checkrecursive.runsendEmailtoSalesRep = false;
    
         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
         List<Id> ownersIdList = new List<Id>();
         List<Id> recordtypesIdList = new List<Id>();
         List<Id> oppIdList = new List<Id>();
         List<Id> accIdList = new List<Id>();
         
         for(Case c:newCases.values())
         {
             ownersIdList.add(c.OwnerId);
         }
         Map<Id,User> owners = new Map<Id,User>([Select Id,Email from User where id in :ownersIdList]);
         
         for(Case c:newCases.values())
         {
         if(c.RecordTypeId!=null){
             recordtypesIdList.add(c.RecordTypeId);
             }
         }
         Map<Id,RecordType> recordtypes = new Map<Id,RecordType>([Select Id,DeveloperName from RecordType where id in :recordtypesIdList]);
         
         for(Case c:newCases.values())
         {
             oppIdList.add(c.Opportunity__c);
         }
         Map<Id,Opportunity> opptys = new Map<Id,Opportunity>([Select Id,Name from Opportunity where id in :oppIdList]);
         
         for(Case c:newCases.values())
         {
             accIdList.add(c.AccountId);
         }
         Map<Id,Account> accts = new Map<Id,Account>([Select Id,Name from Account where id in :accIdList]);
         
         for(Case newcase : newCases.values()){
            Case oldcase = oldCases.get(newcase.id);
            
            if( newcase.RecordTypeId!=null && recordtypes.get(newcase.RecordTypeId).DeveloperName == 'Elite_CPQ_Requests' && (newcase.Status == 'Sales' && oldcase.Status != 'Sales') && owners.get(newcase.OwnerId) != null){
                
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                
                String[] toAddresses = new String[] {owners.get(newcase.OwnerId).Email};
                singleMail.setToAddresses(toAddresses);
                
                singleMail.setSubject('The quote '+ newcase.CaseNumber + ' is ready');
                
                String body = 'Hi,<br><br> You have a quote request which requires attention.<br><br>The request is for the opportunity: <b>'+opptys.get(newcase.Opportunity__c).Name+'</b> and the customer is <b>'+accts.get(newcase.AccountId).Name+'</b>.<br>This quote request has come from the <b>'+oldcase.Status+'</b> queue.<br><br> Please review and update as appropriate.<br><br>'+ FieldId__c.getInstance().Instance_URL__c + newcase.id + '<br><br> Thanks!';
               
                singleMail.setHtmlBody(body);
                
                emails.add(singleMail);
            }
        }
           
           Messaging.sendEmail(emails);
   }
}
    
    // CRM-781 - inserting Case Team member when a user accepts a CPQ quote request
    public static void insertCaseTeamMember(Map<Id,case>oldcase,Map<Id,case>newcase){
        if(checkrecursive.runinsertcaseteammember == true){
        checkrecursive.runinsertcaseteammember = false;
        
        List<CaseTeamRole> CaseRoleList = new List<CaseTeamRole>([select id, Name from CaseTeamRole]);
        Map<String, CaseTeamRole> CaseRoleMap = new Map<String, CaseTeamRole>();
        for(CaseTeamRole ctr: CaseRoleList){
            CaseRoleMap.put(string.valueOf(ctr.Name), ctr);
        }
        
        List<CaseTeamMember> caseTeamMemberList = new List<CaseTeamMember>();
        
        for(Case obj: newcase.values()){
            Map<String, MetaStormQueues__c> Queuemap = MetaStormQueues__c.getAll();
            if(oldcase.get(obj.id).OwnerId != null){
                 if(Queuemap.containsKey(String.valueOf((oldcase.get(obj.id).OwnerId)).substring(0,15)) || Queuemap.containsKey(String.valueOf((oldcase.get(obj.id).OwnerId)))){
                    if(obj.OwnerId != oldcase.get(obj.id).OwnerId && string.valueOf(obj.OwnerId).startsWith('005') ){
                        String role;
                        if(!Test.isRunningTest()){
                            role = MetaStormQueues__c.getInstance((string.valueOf(oldcase.get(obj.id).OwnerId)).substring(0,15)).QueueId__c;
                        }else{
                            role = MetaStormQueues__c.getInstance((string.valueOf(oldcase.get(obj.id).OwnerId))).QueueId__c;}
                        if(role!=null && CaseRoleMap.get(role)!=null){
                           CaseTeamMember ctmobj = new CaseTeamMember();
                           ctmobj.ParentId=obj.id;
                           ctmobj.MemberId=obj.OwnerId;
                           ctmobj.TeamRoleId=CaseRoleMap.get(role).id;
                           caseTeamMemberList.add(ctmobj); 
                        }
                    }
            }
            }//end of null check
        }
            if(caseTeamMemberList.size()>0){
                database.insert(caseTeamMemberList, false);}
    
    }
    }
    
    //CRM - 1350 - sending an email when a quote request is cancelled
    public static void sendQuoteRequestCancellationEmail(Map<Id,Case> oldCases,Map<Id,Case> newCases){
        if(checkrecursive.runQuoteRequestCancellationEmail == true){
            checkrecursive.runQuoteRequestCancellationEmail = false;
         
         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
         
         List<Id> recordtypesIdList = new List<Id>();
         for(Case c:newCases.values())
         {
             if(c.RecordTypeId!=null){
             recordtypesIdList.add(c.RecordTypeId);
             }
         }
         Map<Id,RecordType> recordtypes = new Map<Id,RecordType>([Select Id,DeveloperName from RecordType where id in :recordtypesIdList]);
    
         for(Case newcase : newCases.values()){
            
            if( newcase.RecordTypeId!=null && recordtypes.get(newcase.RecordTypeId).DeveloperName == 'Elite_CPQ_Requests' && newcase.LCRM_Cancel_Request__c == TRUE){
                
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                
                String[] toAddresses = new List<String>();
                toAddresses.add(Label.Email_for_quote_request_cancellation_to_CPQ_Analysts_and_Manager);
                toAddresses.add(Label.Email_for_quote_request_cancellation_to_Contract_Admins_and_Manager);
                toAddresses.add(Label.Email_for_quote_request_cancellation_to_Sales_Ops_and_Manager);
                singleMail.setToAddresses(toAddresses);
                
                singleMail.setSubject('Sales cancelled quote request '+newcase.CaseNumber);
                
                String body = 'Quote Request ID <b>' + newcase.CaseNumber + '</b> has been cancelled by a Sales Rep/CPQ User. Please do not work on this quote request any further.<br><br>' + FieldId__c.getInstance().Instance_URL__c + newcase.id + '<br><br>Thanks!';
                singleMail.setHtmlBody(body);
                
                emails.add(singleMail);
            }
        }
           
           if(! Test.isRunningTest()){
             Messaging.sendEmail(emails);
           }
   }
  }
  
  //CRM-3230 - to populate Sub-Bu and Is GLI on Training Event Case
  public static void initialiseTrainingEventCaseValues(List<Case> newCases){

    Map<Id,RecordType> recordtypes = new Map<Id,RecordType>([Select Id,DeveloperName from RecordType where SobjectType = 'Case']);
    
    for(Case c:newCases){
        if(c.RecordTypeId!=null && recordtypes.get(c.RecordTypeId).DeveloperName == 'GLI_Training_Event_Request' ){
             List<sobject> sObjectList = new List<sobject>();
             sObjectList.add(c);
             LCRMGenericComponent.populateSubbu(sObjectList);
             c.Is_GLI__c = LCRMGenericComponent.validateUserBU(c.LCRM_Sub_BU__c);
        }
    }
 }
 
 //CRM-3229 - to associate a web traing event case with existing contact and account
   public static void associateContactandAccountwithTrainingEventCase(List<Case> newCases){
 
    Map<Id,RecordType> recordtypes = new Map<Id,RecordType>([Select Id,DeveloperName from RecordType where SobjectType = 'Case']);
    
    List<String> customerEmails = new List<String>();
    List<Contact> contactsList = new List<Contact>();
    Map<String,Contact> contactsMap = new Map<String,Contact>();
    
    for(Case c:newCases){
        if(c.RecordTypeId!=null && recordtypes.get(c.RecordTypeId).DeveloperName == 'GLI_Training_Event_Request' && c.Origin!=null && c.Origin == 'Web' && c.LCRM_Email_Address__c!=null){
            customerEmails.add(c.LCRM_Email_Address__c); }
    }  
    if(Schema.sObjectType.Contact.isQueryable()){
        contactsList = [SELECT Id,AccountId,Email FROM Contact WHERE Email in :customerEmails AND Contact_Inactive__c=false];}
       for(Contact c:contactsList){
           contactsMap.put(c.Email,c);} 
          
    for(Case c:newCases){
        if(c.RecordTypeId!=null && recordtypes.get(c.RecordTypeId).DeveloperName == 'GLI_Training_Event_Request' && c.Origin!=null && c.Origin == 'Web' && c.LCRM_Email_Address__c!=null){
             Contact existingCon = contactsMap.get(c.LCRM_Email_Address__c);
             if(existingCon!=null){
                 c.ContactId = existingCon.Id;
                 c.AccountId = existingCon.AccountId;
             }
        }
    }
 }
 
 
 //CRM-17773- added by Harika to set isGLI flag,Sub Bu and Sales Org for Case which are  not Originated via Email, Web, Chat
 public static void populateSubbu(List<Case> lstcases)
 {
     List<Case> LstCaseUpdate = new List<Case>();
     for(Case c:lstcases)
     {
            if(c.Origin != 'Chat' && c.Origin !='Web' && c.Origin!='Email')
             {
                 LstCaseUpdate.add(c);
             }
        
     }
     
     if(!LstCaseUpdate.isEmpty())
     {
         LCRMGenericComponent.populateSubbu(LstCaseUpdate);
     }
 
 }
         Public static Boolean caseRTCheck(List<case> CaseLst)
    {
    //Id RecordtypeId1 =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Findlaw Inquiry').getRecordTypeId();
    //Id RecordtypeId2 =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
    Id RecordtypeId2  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCS_Inquiry').getRecordTypeId();    
    Id RecordtypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Findlaw_Inquiry').getRecordTypeId();
    for(Case Case1 : CaseLst)
    {
    if(Case1.RecordTypeID == RecordtypeId1 || Case1.RecordTypeID == RecordtypeId2)
      {
      return true;
      }
    }
    return false;
    }
 
      //Method added as part of DPS-18602
    public static void addCaseTeamEntry(List<Case> lstcases){
        
        chkRecursion = true;
       if((userInfo.getProfileId() == [SELECT Id FROM Profile WHERE Name = 'Partner Portal User' limit 1].Id) ){
                List<CaseTeamRole> role;
                Map<String,Id> mapOfTeamRole = new Map<String,Id>();
                Profile p;
                string salesRole;
                string CollabRole;
                list<CaseTeamMember> membersToAdd = new list<CaseTeamMember>(); 
                List<Case> cases = new List<case>();
                List<string> teamRoleLst = System.Label.LatamPartnerCaseTeamRole.split(',');
                if(teamRoleLst.size() >1){
                    salesRole = teamRoleLst[0];
                    CollabRole = teamRoleLst[1];
                }else{
                    salesRole = teamRoleLst[0];
                }
                cases = Schema.sObjectType.Case.isQueryable() ? [Select Id,OwnerId,CreatedById,ContactId,RecordTypeId,RecordType.Name   
                             from Case where id IN :lstcases] : new List<case>() ;
                role = Schema.sObjectType.CaseTeamRole.isQueryable() ? [select Name from CaseTeamRole where Name in :(teamRoleLst) LIMIT 2] : new List<caseTeamRole>();
                
                for(CaseTeamRole csTeam:role){
                
                    mapOfTeamRole.put(csTeam.Name,csTeam.id);
                }
                for (Case c : cases) {  
                    if ( c.RecordType.Name == 'ANZ' || c.RecordType.Name == 'Partner Service Case'){    
                        
                        membersToAdd.add( new CaseTeamMember(                       
                            TeamRoleId = c.RecordType.Name =='ANZ'? mapOfTeamRole.get(salesRole): mapOfTeamRole.get(CollabRole),
                            ParentId = c.Id,                            
                            MemberId = c.CreatedById)); 
                    }
                }
                if (!membersToAdd.isEmpty() && Schema.sObjectType.CaseTeamMember.isCreateable()) {
                        insert membersToAdd;
                        
                } 
            }
        }
       
    
}