/**
 * Class for the Opportunity Team Member trigger methods
 *
 *
 * @author  Nandita Shet
 * @version 2013-02-28
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2013-02-28   Nandita Shet        Created
 * 2014-09-04   Nandita Shet        MCL-647 Sales Percentage cannot exceed 100%
                                    for Latam (method SalesPercentageValidation)
 * 2016-02-01   Rajesh              Added 'syncOppTeamToOppTeamClone' method                                               
 * =============================================================================
 */




public without sharing class OptyTeamMemberTriggerHandler {
  public static boolean bflag = false;
  public static boolean checkRecursyncOppTeamToOppTeamClone = false;//CRM-81 check recursive flag syncOppTeamToOppTeamClone method
 
  public static void syncUserQuota(List<OpportunityTeamMember> listOpptyTeamMember,Boolean bIsInsert){
    
    List<Id> listTeamMemberId = new List<Id>();
    Map<Id,Id> mapManagerRole = new Map<Id,Id>();
    Map<Id,Id> mapManagerUser = new Map<Id,Id>();
    Map<string, Id> mapUserQuota = new Map<string, Id>();
    List<OpportunityTeamMember> listOpportunityTeamMembertoupd = new List<OpportunityTeamMember>();
    
    List<OpportunityTeamMember> listOpportunityTeamMember  = [Select UserId,User.UserRole.ParentRoleId,OpportunityId,Opportunity.Closedate from OpportunityTeamMember  where Id IN : listOpptyTeamMember];
   
    Map<Id,String> mapOptyCloseDate  = new map<Id,String> ();
    bflag = true;
    for(OpportunityTeamMember  oOpportunityTeamMember : listOpportunityTeamMember){
       listTeamMemberId.add(oOpportunityTeamMember.UserId);
       
       if(!mapOptyCloseDate.containskey(oOpportunityTeamMember.OpportunityId)){
        mapOptyCloseDate.put(oOpportunityTeamMember.OpportunityId,AppUtil.formatDate(oOpportunityTeamMember.Opportunity.Closedate, 'MMM yyyy', null));
       }
       
       if(oOpportunityTeamMember.User.UserRole.ParentRoleId!=null){
          if(!mapManagerRole.containskey(oOpportunityTeamMember.UserId)){
            mapManagerRole.put(oOpportunityTeamMember.UserId,oOpportunityTeamMember.User.UserRole.ParentRoleId);
          }
        }
    }
    if(!mapManagerRole.IsEmpty()){
        for(User oUser : [Select Id,UserRoleId from User where UserRoleId IN : mapManagerRole.values()]){
            listTeamMemberId.add(oUser.Id);
            if(!mapManagerRole.containskey(oUser.UserRoleId)){
                mapManagerRole.put(oUser.UserRoleId,oUser.Id);
            }
        }
    }
    for(OpportunityTeamMember  oOpportunityTeamMember : listOpportunityTeamMember){
        if(!mapManagerUser.containskey(oOpportunityTeamMember.UserId)){
            mapManagerUser.put(oOpportunityTeamMember.UserId,mapManagerRole.get(oOpportunityTeamMember.User.UserRole.ParentRoleId));
        }

    }

   

     for (UserQuota__c oUserQuota : [SELECT Name,Id, External_Id__c, User__c, Fiscal_Month__c FROM UserQuota__c WHERE Fiscal_Month__c IN :mapOptyCloseDate.values() and User__c IN :listTeamMemberId]) {
        mapUserQuota.put(oUserQuota.External_Id__c,oUserQuota.Id);
    }
    
   if(bIsInsert){
       for(OpportunityTeamMember oOpportunityTeamMember : listOpportunityTeamMember){
           if(mapUserQuota.containsKey(oOpportunityTeamMember.UserId + mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId))){
                oOpportunityTeamMember.User_Quota__c = mapUserQuota.get(oOpportunityTeamMember.UserId + mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId));
            }  
            if(mapUserQuota.containsKey(mapManagerUser.get(oOpportunityTeamMember.UserId) + mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId))){
                 oOpportunityTeamMember.Manager_Quota__c = mapUserQuota.get(mapManagerUser.get(oOpportunityTeamMember.UserId)+ mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId));
            }    
             listOpportunityTeamMembertoupd.add(oOpportunityTeamMember);      
        }
       if(listOpportunityTeamMembertoupd!=null && listOpportunityTeamMembertoupd.size()>0){
           update listOpportunityTeamMembertoupd;
       }
   }
   else{
   
       for(OpportunityTeamMember  oOpportunityTeamMember : listOpptyTeamMember){
            if(mapUserQuota.containsKey(oOpportunityTeamMember.UserId + mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId))){
                oOpportunityTeamMember.User_Quota__c = mapUserQuota.get(oOpportunityTeamMember.UserId + mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId));
            }else{
                oOpportunityTeamMember.User_Quota__c = null;
            }     
            if(mapUserQuota.containsKey(mapManagerUser.get(oOpportunityTeamMember.UserId) + mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId))){
                 oOpportunityTeamMember.Manager_Quota__c = mapUserQuota.get(mapManagerUser.get(oOpportunityTeamMember.UserId)+ mapOptyCloseDate.get(oOpportunityTeamMember.OpportunityId));
            }else{
                oOpportunityTeamMember.Manager_Quota__c = null;
            }     
               
        }
       
      }
    }
    
    
    /**********************MCL-647******************************/
    
    public static void salesPercentageValidation(List<OpportunityTeamMember> listOptySalesTeam){
        Set<Id> setOppIds = new Set<Id>();
        Set<Id> setOptyTeamMemberId = new Set<Id>();
         
        for(OpportunityTeamMember oOptySalesTeam : listOptySalesTeam){
          setOppIds.add(oOptySalesTeam.OpportunityId);  
          setOptyTeamMemberId.add(oOptySalesTeam.Id);
        }
         
        Map<Id,Decimal> mapOptySalesTeam = new map<Id,Decimal>();
         
        for(AggregateResult oResult :[Select sum(Sales_Percentage__c),OpportunityId from OpportunityTeamMember where OpportunityId IN : setOppIds 
                                      and Id Not IN : setOptyTeamMemberId and Sales_Percentage__c!=null group by OpportunityId]){
           mapOptySalesTeam.put((Id)oResult.get('OpportunityId'),(Decimal)oResult.get('expr0')); 
        }
        System.debug(mapOptySalesTeam+'==='+setOptyTeamMemberId );         
        for(OpportunityTeamMember oOptySalesTeam : listOptySalesTeam){
          if(mapOptySalesTeam.containskey(oOptySalesTeam.OpportunityId)){
            if(oOptySalesTeam.Sales_Percentage__c!=null && mapOptySalesTeam.get(oOptySalesTeam.OpportunityId)!=null){
             Decimal dSum = mapOptySalesTeam.get(oOptySalesTeam.OpportunityId)+ oOptySalesTeam.Sales_Percentage__c;
             if(dSum > 100){
               oOptySalesTeam.addError('Sales Percentage must equal 100%.');
             }
            }
           }else if(oOptySalesTeam.Sales_Percentage__c > 100){
              oOptySalesTeam.addError('Sales Percentage must equal 100%.');
           }
        }
    }   
    
    
    //CRM-81 method to sync records from Opportunity Team Member to Opportunity Team Member Clone object 
    public static void syncOppTeamToOppTeamClone(String action, Set<ID> oppTeamIDSet){
    //public static void syncOppTeamToOppTeamClone(String action, Set<ID> oppTeamIDSet, List<OpportunityTeamMember> oppTeamList){
        try{
            System.debug('action : syncOppTeamToOppTeamClone :'+action);
            System.debug('oppTeamIDSet : '+oppTeamIDSet);
            //check if no ID's are passed for processing
            if(oppTeamIDSet !=null && oppTeamIDSet.size()>0){
            //if(oppTeamIDSet !=null && oppTeamIDSet.size()>0 && oppTeamList!=null && oppTeamList.size()>0){
                if(action == 'delete'){
                    List<LCRM_Opportunity_Team_Clone__c> oppTCloneList;
                    try{
                        oppTCloneList = [SELECT ID FROM LCRM_Opportunity_Team_Clone__c
                                WHERE LCRM_Opp_Team_ID__c IN :oppTeamIDSet];
                    }catch(Exception e){
                        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                        excepObj.LCRM_Exception_Message__c = e.getMessage();
                        excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
                        excepObj.LCRM_Exception_Type__c = 'OpportunityTeamMember delete query';
                        excepObj.LCRM_Record_Ids__c = String.valueOf(oppTeamIDSet);
                        excepObj.LCRM_User_ID__c = userinfo.getUserId();
                        insert excepObj;
                    }
                    //delete clone records 
                    if(oppTCloneList!=null && oppTCloneList.size()>0){
                        Delete oppTCloneList;
                    }
                    return;// return for delete action
                }
                
                /*Set<ID> oppIds = new Set<ID>();
                for(OpportunityTeamMember otm : oppTeamList){
                    oppIds.add(otm.OpportunityId);
                }*/
                
                Map<ID,OpportunityTeamMember> oppTFilteredMap = new Map<ID,OpportunityTeamMember>();
                /*System.debug('temp : '+[SELECT ID FROM Opportunity WHERE ID IN :oppIds AND LCRM_Split_On__c =TRUE AND Is_GLI__c = TRUE]);
                System.debug('temp : '+[SELECT ID, OpportunityID, TeamMemberRole, UserID, Opportunity.LCRM_Split_On__c, Opportunity.Is_GLI__c 
                                                   FROM OpportunityTeamMember 
                                                   where ID IN :oppTeamIDSet]);
                */
                
                // start for CRM-13416
                List<String> excludedUsersNames = new List<String>();
                if(! (KeyValueListStore__c.getValues('LCRMSplit_ExcludeUsers') == null || KeyValueListStore__c.getValues('LCRMSplit_ExcludeUsers').TextValue__c == null || KeyValueListStore__c.getValues('LCRMSplit_ExcludeUsers').TextValue__c == '')){
                    excludedUsersNames =  KeyValueListStore__c.getValues('LCRMSplit_ExcludeUsers').TextValue__c.split(',');   
                }
                Map<ID, User> excludedUsers = new Map<Id, User>([SELECT ID FROM User WHERE Name IN :excludedUsersNames]);
                //end for CRM-13416
                
                try{
                    //query Opp Team record with filter conditions
                    oppTFilteredMap = new Map<ID,OpportunityTeamMember>([SELECT ID, OpportunityID, TeamMemberRole, UserID 
                                                   FROM OpportunityTeamMember 
                                                   where ID IN :oppTeamIDSet AND 
                                                   Opportunity.LCRM_Split_On__c =TRUE AND Opportunity.Is_GLI__c = TRUE  AND UserID NOT IN :excludedUsers.keySet()]); // modified for CRM-13416
                    /*oppTFilteredMap = new Map<ID,OpportunityTeamMember>([SELECT ID, OpportunityID, TeamMemberRole, UserID 
                                                   FROM OpportunityTeamMember 
                                                   where ID IN :oppTeamIDSet AND 
                                                   OpportunityID IN 
                                                   (SELECT ID FROM Opportunity WHERE ID IN :oppIds AND LCRM_Split_On__c =TRUE AND Is_GLI__c = TRUE)]);*/
                }catch(Exception e){
                    System.debug('Exception : '+e.getStackTraceString());
                    return;
                }
                System.debug('oppTFilteredMap : '+oppTFilteredMap);
                //if no Opp Team records satisfy filter conditions then return as no records to process
                if((oppTFilteredMap == null || oppTFilteredMap.size()<=0)){
                    return;
                }
                //Query existing Opp Team clone records
                Map<String,LCRM_Opportunity_Team_Clone__c> oppTCloneMap = new Map<String,LCRM_Opportunity_Team_Clone__c>();
                for(LCRM_Opportunity_Team_Clone__c oppTCloneTemp : [SELECT ID, LCRM_Opportunity__c, LCRM_Opp_Team_ID__c, 
                                LCRM_Rep_Function__c, LCRM_User__c FROM LCRM_Opportunity_Team_Clone__c
                                WHERE LCRM_Opp_Team_ID__c  IN :oppTFilteredMap.keySet()]){
                    oppTCloneMap.put(oppTCloneTemp.LCRM_Opp_Team_ID__c, oppTCloneTemp);
                }
                System.debug('oppTCloneMap : '+oppTCloneMap);
                if(action == 'insert' || action == 'update'){
                    Set<ID> oppIdSet = new Set<ID>();
                    List<LCRM_Opportunity_Team_Clone__c> oTeamCloneList = new List<LCRM_Opportunity_Team_Clone__c>();
                    //loop to insert/update Opp Team clone records
                    for(OpportunityTeamMember oTeam : oppTFilteredMap .Values()){
                        LCRM_Opportunity_Team_Clone__c oTTemp = new LCRM_Opportunity_Team_Clone__c();
                        //if Opp Team Clone exist then use it for update
                        if(oppTCloneMap != null &&oppTCloneMap.get(oTeam.ID) !=null){
                            oTTemp = oppTCloneMap.get(oTeam.ID);
                        }else{
                            oTTemp.LCRM_Opportunity__c = oTeam.OpportunityID;
                            oTTemp.LCRM_Rep_Function__c = oTeam.TeamMemberRole;
                        }
                        oTTemp.LCRM_Opp_Team_ID__c = oTeam.ID;
                        oTTemp.LCRM_User__c = oTeam.UserID;
                        oTeamCloneList.add(oTTemp);
                        oppIdSet.add(oTeam.OpportunityID);
                    }
                    System.debug('oTeamCloneList : '+oTeamCloneList);
                    if(oTeamCloneList.size()>0){
                        upsert oTeamCloneList;
                    }
                    List<LCRM_Opportunity_Product_Clone__c> oProdCloneList;
                    Set<String> oSplitSet = new Set<String>();
                    try{
                        oProdCloneList = [SELECT ID, LCRM_Opportunity__c, CurrencyIsoCode FROM LCRM_Opportunity_Product_Clone__c where LCRM_Opportunity__c IN :oppIdSet];
                        //create set of String-"OLICloneID:OTeamID" to have info about already present split records
                        for(LCRM_Opportunity_Split__c osplit : [SELECT ID, LCRM_Opportunity_Product_Clone__c, LCRM_Opportunity_Team_Clone__c, 
                                                                LCRM_Opportunity__c, LCRM_Percent__c, CurrencyIsoCode FROM LCRM_Opportunity_Split__c 
                                                                WHERE LCRM_Opportunity__c IN :oppIdSet]){
                            oSplitSet.add(osplit.LCRM_Opportunity_Product_Clone__c+':'+osplit.LCRM_Opportunity_Team_Clone__c);
                        }
                    }catch(Exception e){
                        System.debug('Exception : '+e.getMessage()+' : '+e.getStackTraceString());
                    }
                    System.debug('oProdCloneList : '+oProdCloneList);
                    List<LCRM_Opportunity_Split__c> oSplitInsList = new List<LCRM_Opportunity_Split__c>();
                    if(oTeamCloneList != null && oTeamCloneList.size()>0){
                        //loop to insert new split records
                        for(LCRM_Opportunity_Team_Clone__c oTeam : oTeamCloneList){
                            for(LCRM_Opportunity_Product_Clone__c oProd : oProdCloneList){
                                if(oTeam.LCRM_Opportunity__c == oProd.LCRM_Opportunity__c && !oSplitSet.contains(oProd.ID+':'+oTeam.ID)){
                                    LCRM_Opportunity_Split__c oSplit = new LCRM_Opportunity_Split__c();
                                    oSplit.LCRM_Opportunity_Team_Clone__c = oTeam.ID;
                                    oSplit.LCRM_Opportunity_Product_Clone__c = oProd.ID;
                                    oSplit.LCRM_Opportunity__c = oTeam.LCRM_Opportunity__c;
                                    oSplit.LCRM_Percent__c = 0;
                                    oSplit.CurrencyIsoCode = oProd.CurrencyIsoCode;
                                    oSplitInsList.add(oSplit);
                                }
                            }
                        }
                    }
                    System.debug('oSplitInsList : '+oSplitInsList);
                    insert oSplitInsList;
                }/*else if(action == 'update'){
                    List<LCRM_Opportunity_Team_Clone__c> oTeamCloneList = new List<LCRM_Opportunity_Team_Clone__c>();
                    for(OpportunityTeamMember oTeam : oppTFilteredMap .Values()){
                        LCRM_Opportunity_Team_Clone__c oTTemp = new LCRM_Opportunity_Team_Clone__c();
                        if(oppTCloneMap != null &&oppTCloneMap.get(oTeam.ID) !=null){
                            oTTemp = oppTCloneMap.get(oTeam.ID);
                        }else{
                            oTTemp.LCRM_Opportunity__c = oTeam.OpportunityID;
                        }
                        oTTemp.LCRM_Opp_Team_ID__c = oTeam.ID;
                        oTTemp.LCRM_Rep_Function__c = oTeam.TeamMemberRole;
                        oTTemp.LCRM_User__c = oTeam.UserID;
                        oTeamCloneList.add(oTTemp);
                    }
                    System.debug('oTeamCloneList : '+oTeamCloneList);
                    if(oTeamCloneList.size()>0){
                        upsert oTeamCloneList;
                    }
                }*/
            }
        }catch(Exception e){
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = e.getMessage();
            excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'OpportunityTeamMember error';
            excepObj.LCRM_Record_Ids__c = String.valueOf(oppTeamIDSet);
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            insert excepObj; 
            throw e;
        }
    } 
    
    public static Map<String,Boolean> syncOppTeamHistoryFlags = new Map<String,Boolean>{'Partner_Role__c'=>false,'Sales_Percentage__c'=>false,'OpportunityAccessLevel'=>false,'TeamMemberRole'=>false};
    public static void syncOppTeamHistory(List<OpportunityTeamMember> newOppList, Map<Id, OpportunityTeamMember> oldOppMap, String operation){
        System.debug('inside syncOppTeamHistory : '+syncOppTeamHistoryFlags+' : '+operation);
        //if(operation != 'Created' && syncOppTeamHistoryFlag == true){
        //    return;
        //}
        //syncOppTeamHistoryFlag = true;
        List<LatAm_Opportunity_Team_History__c> histList = new List<LatAm_Opportunity_Team_History__c>();
        if(operation == 'Updated'){
            for(OpportunityTeamMember otm : newOppList){
                //Map<String,String> histRecValues = new Map<String, String>{};
                histList.addAll(createOTMHistory(operation, oldOppMap.get(otm.Id), otm));
            }
        }else if(operation == 'Created'){
            for(OpportunityTeamMember otm : newOppList){
                histList.addAll(createOTMHistory(operation, null, otm));
            }
            //syncOppTeamHistoryFlag = false;
        }else if(operation == 'Deleted'){
            for(OpportunityTeamMember otm : oldOppMap.values()){
                histList.addAll(createOTMHistory(operation, otm, null));
            }
        }
        if(LatAm_Opportunity_Team_History__c.SObjectType.getDescribe().isCreateable() && histList.size()>0){
            insert histList;
        }
    }

    private static List<LatAm_Opportunity_Team_History__c> createOTMHistory(String operation, OpportunityTeamMember oldRec, OpportunityTeamMember newRec){
        System.debug('operation : '+operation);
        System.debug('oldRec : '+oldRec);
        System.debug('newRec : '+newRec);
        List<LatAm_Opportunity_Team_History__c> otmHistList= new List<LatAm_Opportunity_Team_History__c>();
        String oldValue = null, newValue = null, oppId = null, otmId = null, otmUserId = null;
        Map<String,String> fieldMap = getOTMFieldMap();//new Map<String,String>{'Partner_Role__c'=>'Partner Role','Sales_Percentage__c'=>'Sales Percentage','OpportunityAccessLevel'=>'Opportunity Access','TeamMemberRole'=>'Team Role'};
        //Map<String, Object> oldfieldValues = oldRec.getPopulatedFieldsAsMap();
        //Map<String, Object> newfieldValues = newRec.getPopulatedFieldsAsMap();
        for(String field : fieldMap.keyset()){
            //System.debug('field : '+field);
            if(operation == 'Created'){
                System.debug('Created : '+field+' : '+newRec.get(field));
                //if(newRec.get(field)==null){
                //    continue;
                //}
                //newValue = String.valueOf(newfieldValues.get('Partner_Role__c'));
                //newValue = String.valueOf(newRec.get(field));
                newValue = getFieldVal(newRec, field);
                oppId = newRec.OpportunityID;
                otmId = newRec.Id;
                otmUserId = newRec.UserId;
            }else if(operation == 'Deleted'){
                System.debug('Deleted : '+field+' : '+oldRec.get(field));
                //if(oldRec.get(field)==null){
                //    continue;
                //}
                //oldValue = String.valueOf(oldfieldValues.get('Partner_Role__c'));
                //oldValue = String.valueOf(oldRec.get(field));
                oldValue = getFieldVal(oldRec, field);
                oppId = oldRec.OpportunityID;
                otmId = oldRec.Id;
                otmUserId = oldRec.UserId;
            }else{
                System.debug('Updated : '+field+' : '+newRec.get(field));
                System.debug('Updated : '+field+' : '+oldRec.get(field));
                oppId = newRec.OpportunityID;
                otmId = newRec.Id;
                otmUserId = newRec.UserId;
                newValue = '';
                oldValue = '';
                //if(newRec.get(field)!=null){
                //    newValue = String.valueOf(newRec.get(field));
                //}
                newValue = getFieldVal(newRec, field);
                //if(oldRec.get(field)!=null){
                //    oldValue = String.valueOf(oldRec.get(field));
                //}
                oldValue = getFieldVal(oldRec, field);
                if(newValue == oldValue || syncOppTeamHistoryFlags.get(field)==true){
                    continue;
                }
            }
            if(newValue==null && oldValue==null){
                continue;
            }
            LatAm_Opportunity_Team_History__c otmHist = new LatAm_Opportunity_Team_History__c(OpportunityId__c=oppId, OpportunityTeamMemberId__c=otmId, 
                                                                    OpportunityTeamMember__c=otmUserId, Operation__c=operation, 
                                                                    Field__c=fieldMap.get(field), New_Value__c=newValue, 
                                                                    Old_Value__c=oldValue);
            otmHistList.add(otmHist);
            syncOppTeamHistoryFlags.put(field,true);
        }
        system.debug('otmHistList : '+otmHistList);
        return otmHistList;
    } 
    
    private static String getFieldVal(OpportunityTeamMember otmRec, String field){
        String fieldValue = null;
        if(otmRec.get(field)!=null){
            fieldValue = String.valueOf(otmRec.get(field));
        }
        return fieldValue;
    }
    
    private static Map<String,String> getOTMFieldMap(){
        Map<String,String> fieldMap = new Map<String,String>();//{'Partner_Role__c'=>'Partner Role','Sales_Percentage__c'=>'Sales Percentage','OpportunityAccessLevel'=>'Opportunity Access','TeamMemberRole'=>'Team Role'};
        String apiStr = System.Label.LatAm_OTMHistoryFieldsAPI;
        String labelStr = System.Label.LatAm_OTMHistoryFieldsLabel;
        List<String> apiMap =(apiStr!=null && apiStr!='')?apiStr.split(','):new List<String>();
        List<String> labelMap =(labelStr!=null && labelStr!='')?labelStr.split(','):new List<String>();
        for(Integer i=0; i<apiMap.size(); i++){
            fieldMap.put(apiMap[i],labelMap[i]);
        }
        return fieldMap;
    }
    
    //DPS-19249 - Store Team Member Ids which are being updated (trigger.New) and used in SOQL to exclude Team Meber as it will covered in optyTeamMemberToBeProcess List
    static List<Id> OptyTeamMbrIdExisting = new List<Id>();
    
    //DPS-19249 - Store Sobject Team Members which are being process as it will not be covered into SOQL
    static List<OpportunityTeamMember> optyTeamMemberToBeProcess = new List<OpportunityTeamMember> ();
    
    //DPS-19249 Opportunity Team - Users Cannot Assign Multiple Partner Users to the same Partner Role.
    public static void validateDuplicatePartnerRoles(Boolean isUpdate,   List<OpportunityTeamMember> optyTeamMemberNew, Map<Id, OpportunityTeamMember> optyTeamMemberOldMap){
        
        optyTeamMemberToBeProcess = new List<OpportunityTeamMember> ();
        OptyTeamMbrIdExisting = new List<Id>();
        System.debug('optyTeamMemberNew: '+optyTeamMemberNew);
        
        //Get Opportunity Id from OpportunityTeamMember
        Set<Id> optyIdList = getOptyIdsFromTeamMember(isUpdate, optyTeamMemberNew, optyTeamMemberOldMap);
        
        //get existing OptyTeamMembers and exclude current TeamMember records
        List<OpportunityTeamMember> optyTeamMemberList = new List<OpportunityTeamMember>();
        
        if(!optyIdList.isEmpty() && Schema.sObjectType.OpportunityTeamMember.isAccessible()){
            optyTeamMemberList = [SELECT Id, Partner_Role__c, OpportunityId from OpportunityTeamMember where OpportunityId IN :optyIdList  AND Id NOT IN : OptyTeamMbrIdExisting AND Partner_Role__c != null ];
        }
        if(optyTeamMemberList != null){
            //combine SOQL Team Members which are existing on Opty and records which are being processed and part of Trigger.new 
            optyTeamMemberToBeProcess.addAll(optyTeamMemberList);
        }
        System.debug('optyTeamMemberToBeProcess: '+optyTeamMemberToBeProcess);
        //store Opportunity ID and related Team Member Partner Roles int Map
        Map<Id, List<String>> OptyIdPartnerRolesMap = getOptyIdPartnerListMap(optyTeamMemberToBeProcess);
        
        for(OpportunityTeamMember optyTeamMbr : optyTeamMemberNew){
            
            //fetch Partner Role values which are present on Opportunity and being updated or inserted
            List<String> partnerRolesOpty = new List<String> ();
            partnerRolesOpty = OptyIdPartnerRolesMap.get(optyTeamMbr.OpportunityId);
            Map<String,Integer> partnerRoleCountMap = new Map<String,Integer>();
            
            System.debug('partnerRolesOpty: '+partnerRolesOpty);
            
            if(partnerRolesOpty != null){
                //Count by Partner Role in Map
                partnerRoleCountMap = getPartnerRoleCount(partnerRolesOpty);
            }
            System.debug('partnerRoleCountMap : '+partnerRoleCountMap );
            //show error msg if Partner Role count is more than one on Opportunity
            showDuplicatePartnerRoleMsg(partnerRoleCountMap, optyTeamMbr);
        }
    }
    
    //Show error message based on count of Partner Role values
    @testvisible
    private static void showDuplicatePartnerRoleMsg(Map<String,Integer> partnerRoleCountMap, OpportunityTeamMember teamMbr){
        
        String partnerRoleNew = teamMbr.Partner_Role__c;
        
        List<String> partnerRoleNewValues = splitPartnerRole(partnerRoleNew);
    
        for(String partnerRole : partnerRoleNewValues){
            
            Integer count = partnerRoleCountMap.get(partnerRole); 
            if(count >1){
                teamMbr.addError(System.Label.LatAmPartnerRoleDuplicateMsg);        
            } 
        }
    }
     
    //store Opportunity ID and related Team Member Partner Roles int Map
    @testVisible
    private static Map<Id, List<String>> getOptyIdPartnerListMap(List<OpportunityTeamMember> optyTeamMemberList){
        
        Map<Id, List<String>> OptyIdPartnerRolesMap = New Map<Id, List<String>>();
        
        for(OpportunityTeamMember optyTeam : optyTeamMemberList){
        
            String partnerRole = optyTeam.Partner_Role__c;
            
            List<String> PartnerRoleSpitList = splitPartnerRole(partnerRole);
            
            if(OptyIdPartnerRolesMap.containsKey(optyTeam.OpportunityId)){
                
                List<String> partnerRoleList = OptyIdPartnerRolesMap.get(optyTeam.OpportunityId);
                partnerRoleList.addAll(PartnerRoleSpitList);
                                
                OptyIdPartnerRolesMap.put(optyTeam.OpportunityId, partnerRoleList);
             } 
             else{
                List<String> newPartnerList = new List<String>();
                newPartnerList.addAll(PartnerRoleSpitList);
                OptyIdPartnerRolesMap.put(optyTeam.OpportunityId, newPartnerList);
            }
        }
        
        return OptyIdPartnerRolesMap;   
    }
    
    @testVisible
    private static List<String> splitPartnerRole(String partnerRole){
        
        List<String> partnerRoleList = New List<String>();
        
        if(partnerRole != null && partnerRole.contains(';')){
            partnerRoleList = partnerRole.split(';');
        }
        else if(partnerRole != null){
            partnerRoleList.add(partnerRole);
        }
        return partnerRoleList;
    }
    
    //Get Opportunity Id from OpportunityTeamMember
    @testVisible
    private static set<Id> getOptyIdsFromTeamMember(Boolean isUpdate, List<OpportunityTeamMember> optyTeamMemberNew, Map<Id, OpportunityTeamMember> optyTeamMemberOldMap){
        
        Set<Id> optyIdList = new set<Id>();
        
        for(OpportunityTeamMember teamMemberNew : optyTeamMemberNew){
            
            OpportunityTeamMember teamMbrOld = null;
            if(isUpdate){
                teamMbrOld = optyTeamMemberOldMap.get(teamMemberNew.Id);
            }
            
            if(teamMemberNew.Partner_Role__c != null && teamMemberNew.Id == null){
                optyIdList.add(teamMemberNew.OpportunityId);
                optyTeamMemberToBeProcess.add(teamMemberNew);
            }
            else if(isUpdate && teamMemberNew.Partner_Role__c != null && teamMemberNew.Partner_Role__c != teamMbrOld.Partner_Role__c){
                optyIdList.add(teamMemberNew.OpportunityId);
                OptyTeamMbrIdExisting.add(teamMemberNew.Id);
                
                optyTeamMemberToBeProcess.add(teamMemberNew);
            }
        }
        return optyIdList;
    }
    
    //Count by Partner Role in Map
    @testVisible
    private static Map<String,Integer> getPartnerRoleCount(List<String> nameArray){
        
        Map<String,Integer> elCount = new Map<String,Integer>();

        for(String key : nameArray)
        {
            if(!elCount.containsKey(key)){
            elCount.put(key,0);
            }
            Integer currentInt=elCount.get(key)+1;
            elCount.put(key,currentInt);
        }
        return elcount;    
    }
}