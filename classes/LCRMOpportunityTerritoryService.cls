/*
Class name   : LCRMOpportunityTerritoryService

Purpose      : For CRM-13436 & CRM-13626 
To assign value to territoryid(Opportunity Field) of GLI opportunities from Trigger/Batch

Developed By : TCS

Date         : 09-03-2017
*/


//Commenting out as a part of removal of TM1.0 components
public without sharing class LCRMOpportunityTerritoryService {
    public LCRMOpportunityTerritoryService()
    {}
    
    /*public static Boolean loggedinUserFlag = false;//static value to check loggedin user
    
    
    Purpose : Method to populate territoryid field on opportunity insert 
    Public static void updateOppTerritoryId(Boolean checkTrigger,List<opportunity> Listopty){
     List<AccountTeamMember> accountteammemberownerlist = new  List<AccountTeamMember>();
     List<TMS_Territory__c> tmsList = new List<TMS_Territory__c>();
      List<UserTerritory> userterritoryList = new  List<UserTerritory>();
        try{
            System.debug('INSIDE GLI updateOppTerritoryId');
            List<opportunity> processedOpptyList = new List<Opportunity>();
            
            
            
            Map<id,id> ownermap = new Map<id,id>();
            Map<id,string> temaroleAccId = new Map<id,string>();
            Map<id,string> temaroleuserid= new Map<id,string>();
            Map<id,String>usertmsterrmap = new Map<id,String>();
            Map<id,id>userTerritoryMap = new Map<id,id>();
            
            
            List<opportunity> processedBatchOpptyList = new List<Opportunity>();
            
            Final String oppStatus = 'Open';
            
            LIST<String> userList= new LIST<String>();         
            SET<String> userSet= new SET<String>();
            
            
            List<String> stageList = new List<String>();
            Set<String> stageSet = new Set<String>();
            
            
            
            //custom setting to store user names which will be used to run batch class
            KeyValueListStore__c tempValueStore = KeyValueListStore__c.getValues('LCRMCheckInformaticaUser');
            if(tempValueStore !=null && tempValueStore.TextValue__c !=null && tempValueStore.TextValue__c !=''){
                userList = tempValueStore.TextValue__c.split(',');
            }
            
            if(!userList.isEmpty()){
                for(String s : userList){
                    userSet.add(s.trim().toLowerCase());
                }
            }
            
            
            //custom setting to store opportunity stage(stagename) values
            KeyValueListStore__c tempStageValueStore = KeyValueListStore__c.getValues('LCRMOpptyTerritoryStageValues');
            
            if(tempStageValueStore !=null && tempStageValueStore.TextValue__c !=null && tempStageValueStore.TextValue__c !=''){
                stageList = tempStageValueStore.TextValue__c.split(',');
            }
            
            if(!stageList.isEmpty()){
                for(String stageins : stageList){
                    
                    stageSet.add(stageins);
                }
                
            }
            
            
            System.debug('userSet'+userSet);
            System.debug('UserInfo.getName().toLowerCase()'+UserInfo.getName().toLowerCase());            
            //flag is true when logged in user is informatia user that matches name stored in custom setting
            loggedinUserFlag = userSet.contains(UserInfo.getName().toLowerCase());
            System.debug('loggedinUserFlag@@@'+loggedinUserFlag);
            
            
            
            if(!Listopty.isEmpty()){
                
                for(Opportunity opty : Listopty){ 
                    
                    if(opty.Is_GLI__c && !stageSet.contains(opty.StageName)){   
                        System.debug('opty.StageName'+opty.StageName);
                        ownermap.put(opty.Ownerid,opty.accountid); 
                        
                        processedOpptyList.add(opty);
                    }
                    else{
                        throw new TerritoryServiceException(System.Label.Opportunity_is_not_GLI_Not_valid_stages);
                    }
                }
            }
            else{
                throw new TerritoryServiceException(System.Label.Opportunity_List_Is_Empty);
            }
            ********Account Share Logic********
            Set<id> account_IdSet = new Set<id>();
            Map<id,id> sharegrpid = new  Map<id,id>();
            Map<id,id> groupRelatedId = new map<id,id>();
            Map<id,id> sharegrpRelatedid = new map<id,id>();
            Map<id,list<id>> shareaccountid = new  Map<id,list<id>>();
             List<accountshare> accshareList = new List<accountshare>();
            if(ownermap.size() > 0){
                account_IdSet.addall(ownermap.values());
                System.debug('account_IdSet'+account_IdSet);
                if(account_IdSet.size() > 0){
                    
                    //Logic
                    

if(Schema.sObjectType.Accountshare.isAccessible())
                 accshareList =[select AccountId,UserorGroupId from Accountshare where AccountId in:account_IdSet AND
                               RowCause IN ('TerritoryManual')];
                    for(AccountShare accshare: accshareList){
                        if(accshare.UserorGroupId != null){
                            sharegrpid.put(accshare.id,accshare.UserorGroupId);
                        }
                    }
                    if(sharegrpid != null){
                        for(Group Grp:[select id,relatedid,type from group where id in:sharegrpid.values() AND Type = 'Territory']){
                            if(Grp.relatedid != null)
                                groupRelatedId.put(grp.id,grp.relatedid);
                        }
                        system.debug('***groupRelatedId'+groupRelatedId);
                        for (id accshareid:sharegrpid.keyset()){
                            if(groupRelatedId.containsKey(sharegrpid.get(accshareid)))
                                sharegrpRelatedid.put(accshareid,groupRelatedId.get(sharegrpid.get(accshareid)));
                        }
                        system.debug('***sharegrpRelatedid'+sharegrpRelatedid);
                        for(AccountShare accshare:accshareList){
                            if(!shareaccountid.containskey(accshare.accountid)){
                                shareaccountid.put(accshare.accountid,new id[]{});
                            }
                            if(sharegrpRelatedid.containsKey(accshare.id))
                                shareaccountid.get(accshare.accountid).add(sharegrpRelatedid.get(accshare.id));
                        }
                    }                    
                    
                }
            } 
            ********End of Account Share Logic**********
            
            ***Account Team Member Logic***
            //Query to get details of TeamMemberRole and userId from AccountTeam member //
            if(ownermap.size() > 0){
            

if(Schema.sObjectType.AccountTeamMember.isAccessible())
                accountteammemberownerlist = [SELECT Id, AccountId, UserId, TeamMemberRole FROM AccountTeamMember WHERE
                                                                      (AccountId IN : ownermap.values()                                                                     
                                                                      AND AccountId IN : shareaccountid.keyset())
                                                                      AND UserId IN : ownermap.keyset()
                                                                     ];
                if(!accountteammemberownerlist.isEmpty()){
                    for(AccountTeamMember acctmem :accountteammemberownerlist){
                        
                        temaroleAccId.put(acctmem.AccountId,acctmem.TeamMemberRole);
                        temaroleuserid.put(acctmem.UserId,acctmem.TeamMemberRole);
                    }
                }
                else{
                    throw new TerritoryServiceException(System.Label.User_is_not_included_in_acocunt_team_Account_is_not_shared);
                }
                
            }
            
            
            if( (sharegrpRelatedid != null && temaroleAccId != null ) && (temaroleAccId.size() > 0 && sharegrpRelatedid.size() > 0)){
                //Query to get the territoryid from TMS Territory 
                

if(Schema.sObjectType.TMS_Territory__c.isAccessible())
                tmsList = [SELECT id,Account__c,TMS_Market_Segment_Desc__c,TMS_Rep_Function_Desc__c,
                                                  TMS_Sales_Force_Desc__c,Territory_ID__c ,LCRM_AccountTeamMemberUserId__c,LCRM_Account_team_role__c
                                                  FROM TMS_Territory__c
                                                  WHERE 
                                                  Account__c IN :temaroleAccId.keyset() 
                                                  AND LCRM_Account_team_role__c IN : temaroleAccId.values() 
                                                  AND Territory_ID__c IN : sharegrpRelatedid.values()];    
                
                
                *List<TMS_Territory__c> tmsList = [SELECT id,Account__c,TMS_Market_Segment_Desc__c,  TMS_Rep_Function_Desc__c,
TMS_Sales_Force_Desc__c,Territory_ID__c ,LCRM_AccountTeamMemberUserId__c,LCRM_Account_team_role__c
FROM TMS_Territory__c
WHERE Account__c IN :temaroleAccId.keyset() AND LCRM_AccountTeamMemberUserId__c IN : temaroleuserid.keyset()];*
                
                if(!tmsList.isEmpty()){
                    for(TMS_Territory__c tmsrec : tmsList){
                        usertmsterrmap.put(tmsrec.Territory_ID__c,tmsrec.LCRM_Account_team_role__c);          
                    }
                }
                else{
                    throw new TerritoryServiceException(System.Label.No_records_in_TMS);
                }
            }
            
            
            
            if(usertmsterrmap.size() > 0 && ownermap.size() > 0){
                
                //Query to get create map of userId and TerritoryId from Userterritory
                

if(Schema.sObjectType.UserTerritory.isAccessible())
               userterritoryList = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE TerritoryId IN : 
                                                         usertmsterrmap.keyset() AND UserId IN : ownermap.keyset()];
                
                
                if(!userterritoryList.isEmpty()){
                    for(UserTerritory userterrIns : userterritoryList){
                        userTerritoryMap.put(userterrIns.UserId, userterrIns.TerritoryId);
                    }
                }   
                else{
                    throw new TerritoryServiceException(System.Label.TerritoryId_UserId_not_populated_in_userterritory);
                }
                
            }
            
            //'checkTrigger' boolean check to verify the if the code is executed from trigger or batch
            if(checkTrigger && !loggedinUserFlag){              
                
                
                for(Opportunity updateOptyIns : processedOpptyList){
                    
                    if(!userTerritoryMap.isEmpty() && !stageSet.contains(updateOptyIns.StageName)){         
                        System.debug('CORRECT STAGE');
                        updateOptyIns.TerritoryId = userTerritoryMap.get(updateOptyIns.ownerId);
                        System.debug('updateOptyIns.TerritoryId@@'+updateOptyIns.TerritoryId);
                        //break;                
                    }
                    else{
                        System.debug('INCORRECT STAGE');
                        updateOptyIns.TerritoryId = null;
                        System.debug('updateOptyIns.TerritoryId@@'+updateOptyIns.TerritoryId);
                        //break;
                    }
                    
                    
                    
                }
                
                
            }
            
            //if-else loop CRM-13626 - For Batch
            System.debug('loggedinUserFlag '+loggedinUserFlag );
            System.debug('checkTrigger'+checkTrigger);
            if(loggedinUserFlag && !checkTrigger){
                System.debug('INSIDE BATCH');
                
                for(Opportunity updateOptyIns : processedOpptyList){
                    
                    if(!userTerritoryMap.isEmpty()){               
                        updateOptyIns.TerritoryId = userTerritoryMap.get(updateOptyIns.ownerId);
                        updateOptyIns.LCRM_Territory_Update_Timestamp__c = DateTime.now();
                        processedBatchOpptyList.add(updateOptyIns);
                        
                    }
                    else{
                        updateOptyIns.TerritoryId = null;
                        updateOptyIns.LCRM_Territory_Update_Timestamp__c = DateTime.now();
                        processedBatchOpptyList.add(updateOptyIns);
                        
                    }
                    
                    
                    
                }
                
                
                if(!processedBatchOpptyList.isEmpty()){
                    
                    // DML statement
                    Database.UpsertResult[] srList = Database.upsert(processedBatchOpptyList,false);
                    system.debug('srList '+srList );
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully inserted Oppportunity. Opportunity ID: ' + sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Opportunity fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                    
                }
            }
            // }
        }
        Catch(Exception e){
            System.debug('e'+e.getMessage());
        }
        
    }
    
    //Purpose : Method to assign the value to 'territoryid' field on before update scenario.CRM-13436
    public static void updateOppTerritoryId(Boolean checkTrigger,List<opportunity> Listopp, Map<Id,Opportunity> MapOldOpty){
        // Boolean loggedinUserFlag = checkLoggedInuser();
        
        List<opportunity> newOptyList = new list<opportunity>();
        
        
        List<String> stageList = new List<String>();
        Set<String> stageSet = new Set<String>();
        
        //custom setting to store opportunity stage(stagename) values
        KeyValueListStore__c tempStageValueStore = KeyValueListStore__c.getValues('LCRMOpptyTerritoryStageValues');
        
        if(tempStageValueStore !=null && tempStageValueStore.TextValue__c !=null && tempStageValueStore.TextValue__c !=''){
            stageList = tempStageValueStore.TextValue__c.split(',');
        }
        if(!stageList.isEmpty()){
            for(String stageins : stageList){
                
                stageSet.add(stageins);
            }      
        }
        
        
        
        
        if( !loggedinUserFlag && checkTrigger) {
            
            
            if(!Listopp.isEmpty()){
                for(opportunity oppIns:Listopp){
                    
                    if(oppIns.ownerId!=MapOldOpty.get(oppIns.id).ownerId && oppIns.is_GLI__c == true){
                        System.debug('**OLD OWNERID ** ');
                        oppIns.TerritoryId=null;
                        
                        newOptyList.add(oppIns);
                        
                    } 
                    else if((oppIns.ownerId==MapOldOpty.get(oppIns.id).ownerId) && stageSet.contains(oppIns.StageName)
                            && oppIns.is_GLI__c == true){
                                System.debug('***SAME OWNERID AND RESTRICTTED STAGE****');
                                oppIns.TerritoryId=null;                  
                                
                                
                            }
                    else if((oppIns.ownerId==MapOldOpty.get(oppIns.id).ownerId) && !stageSet.contains(oppIns.StageName)
                            && oppIns.is_GLI__c == true){
                                System.debug('***SAME OWNERID AND NOT RESTRICTED STAGE****');
                                oppIns.TerritoryId=null;                   
                                newOptyList.add(oppIns);
                                
                            }
                }
            }
            
            if(!newOptyList.isEmpty()){
                
                updateOppTerritoryId(checkTrigger,newOptyList);
                
                
            }
            
            
        }
        
    }
    
    public class TerritoryServiceException extends Exception {}
    
    */
}