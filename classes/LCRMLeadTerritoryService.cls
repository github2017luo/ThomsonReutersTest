/*
Class name   : LCRMLeadTerritoryService
Purpose      : For CRM-13435 
                To assign value to territory number Lead from Trigger/Batch
Developed By : Navjyoti
Date         : 09-03-2017
*/
public without sharing class LCRMLeadTerritoryService{
    public LCRMLeadTerritoryService()
    {}
    
    //Commenting out as a part of removal of TM1.0 components
    /*** Below functionality restrict to run before update trigger while processing the lead batch class ****/ 
    /*public static Boolean allowTriggerHandlerToRun = true ;// Value will be true if its running from trigger and false if its running from batch
    
    //Method will be called from batch to restrict invoking lead trigger on update 
    public static void stopTrigger(){
        allowTriggerHandlerToRun = false ;
    }
    
    //Method will be called in lead trigger before update to check whether to run Territory assignment functionality or not
    public static Boolean canIRun(){
        return allowTriggerHandlerToRun ;
    }
   
    This method updated the lead  Lead Owner TMS Territory field based on AccountTeamMember,TMS Territory and User Territory 
    
    Public static void updateLeadTerritoryNumber(List<Lead> listOfLeads){
        try{
        Map<id,id> mapOfLeadOwnerAndAccount = new Map<id,id>();
        //Map<id,string> MapOfAccountIdNTeamMemberRole = new Map<id,string>();
        set<Id> setOfAccountIds = new set<Id>();
        set<string> setOfAccountTeamMemberRoles = new set<string>();
        set<Id> setOfAccountTeamMemberUserIds = new set<Id>();
        Map<id,String>  mapOfTerritoryIdNTMSTerritoryNumber= new Map<id,String>();
        Map<id,String> mapOfUserTerritoryUserValueNTMSTerritoryNum = new Map<id,String>();
        List<lead> listOfLeadToBeProcessed = new List<lead>();
        Map<Id,User> mapOfIntegrationUsers = LCRMLeadTerritoryService.getIntegartionUsersDetails();
        set<String> setOfleadStatus = new set<String>{'Converted','Discarded','Disqualified'};
        system.debug('@@@mapOfIntegrationUsers'+mapOfIntegrationUsers.size()+'Whole List'+mapOfIntegrationUsers);
       system.debug('@@@@setOfleadStatus'+setOfleadStatus);
      
        // Getting lead owner and associated Account's Ids
        if(!listOfLeads.isEmpty()){
            for(Lead ld: listOfLeads){
                if(allowTriggerHandlerToRun){// When Request is coming from trigger
                System.debug('@@@@@@@ld.Is_GLI__c' +ld.Is_GLI__c);
                    if(ld.Account__c != Null && ld.Is_GLI__c && !ld.LCRM_Mass_Load_Indicator__c && 
                        !mapOfIntegrationUsers.keyset().contains((Id)UserInfo.getUserId()) && !setOfleadStatus.contains(ld.Status)){// Trigger will not work when Informatica/Eloqa integration user will load the lead
                        system.debug('@@@@Inside trigger block');
                        if(Trigger.isinsert){
                            mapOfLeadOwnerAndAccount.put(ld.Ownerid,ld.Account__c);
                            listOfLeadToBeProcessed.add(ld);
                            
                        }else if(Trigger.isUpdate){
                            Lead led = (Lead)Trigger.oldMap.get(ld.ID);
                           system.debug('++++olde owner :'+led.Ownerid);
                           system.debug('+++ updating owner :'+ld.Ownerid);
                           if(ld.Ownerid != led.Ownerid){// We will update the territory number when owner is updated
                                mapOfLeadOwnerAndAccount.put(ld.Ownerid,ld.Account__c);
                                listOfLeadToBeProcessed.add(ld);
                                
                           }
                        }
                        
                    }
                }
                if(!allowTriggerHandlerToRun){// When Request is coming from batch
                    system.debug('inside batch block');
                    if(ld.Account__c != Null && ld.Is_GLI__c){
                        mapOfLeadOwnerAndAccount.put(ld.Ownerid,ld.Account__c);
                        listOfLeadToBeProcessed.add(ld);
                    }
                }
            }
        }
        system.debug('@@mapOfLeadOwnerAndAccount'+mapOfLeadOwnerAndAccount);
        system.debug('@@listOfLeadToBeProcessed.size()'+listOfLeadToBeProcessed.size()+'List'+listOfLeadToBeProcessed);
        
        // Getting AccountTeamber detail on lead's associated Account for lead's Owner(User) value
        List<AccountTeamMember> listOfAccountTeammember = new List<AccountTeamMember>();
        if(Schema.sObjectType.AccountTeamMember.isAccessible())
        listOfAccountTeammember = [SELECT Id, AccountId, UserId, TeamMemberRole FROM AccountTeamMember WHERE 
                                                                AccountId IN : mapOfLeadOwnerAndAccount.values() AND 
                                                                UserId IN : mapOfLeadOwnerAndAccount.keyset() ];
        System.debug('listOfAccountTeammember'+listOfAccountTeammember.size()); 
        
        if(!listOfAccountTeammember.isEmpty()){
            for(AccountTeamMember acctmem :listOfAccountTeammember){
                //MapOfAccountIdNTeamMemberRole.put(acctmem.AccountId,acctmem.TeamMemberRole);
                setOfAccountIds.add(acctmem.AccountId);
                setOfAccountTeamMemberRoles.add(acctmem.TeamMemberRole);
                setOfAccountTeamMemberUserIds.add(acctmem.UserId);
            }
        }
        
        System.debug('@@@setOfAccountIds'+setOfAccountIds);
        System.debug('@@@setOfAccountTeamMemberRoles'+setOfAccountTeamMemberRoles);
       
       // Getting TMS Territory information using Account Team Member Role and Account Id
       List<TMS_Territory__c> listOfTMSTerritories = new List<TMS_Territory__c> ();
       if(Schema.sObjectType.TMS_Territory__c.isAccessible())
       listOfTMSTerritories = [SELECT Account__c,TMS_Territory_Number__c,TMS_Rep_Function_Desc__c,TMS_Sales_Force_Desc__c,Territory_ID__c ,LCRM_Account_team_role__c
                                        FROM TMS_Territory__c WHERE  LCRM_Account_team_role__c IN : setOfAccountTeamMemberRoles AND  Account__c IN :setOfAccountIds];
                                        
        List<TMS_Territory__c> listOfTMSTerritories = [SELECT Account__c,TMS_Territory_Number__c,TMS_Rep_Function_Desc__c,TMS_Sales_Force_Desc__c,Territory_ID__c ,LCRM_Account_team_role__c,LCRM_AccountTeamMemberUserId__c
                                        FROM TMS_Territory__c WHERE  LCRM_AccountTeamMemberUserId__c IN : setOfAccountTeamMemberUserIds AND  Account__c IN :setOfAccountIds];
                                        
       system.debug('@@@@listOfTMSTerritories-->'+listOfTMSTerritories); 
       
       if(!listOfTMSTerritories.isEmpty()){
            for(TMS_Territory__c tmsrec : listOfTMSTerritories){
                mapOfTerritoryIdNTMSTerritoryNumber.put(tmsrec.Territory_ID__c,tmsrec.TMS_Territory_Number__c);          
            }
        }
        
        //Getting User Territory Information based on TMS Territory Id and Lead Owner.
        List<UserTerritory> listOfUserTerritories = new List<UserTerritory> ();
        if(Schema.sObjectType.UserTerritory.isAccessible())
        listOfUserTerritories = [SELECT Id, TerritoryId, UserId FROM UserTerritory WHERE TerritoryId IN : 
                                                 mapOfTerritoryIdNTMSTerritoryNumber.keyset() AND UserId IN : mapOfLeadOwnerAndAccount.keyset()];
        
        System.debug('@@@listOfUserTerritories.size---->'+listOfUserTerritories.size());
        System.debug('@@@@listOfUserTerritories--->'+listOfUserTerritories);
        
        if(!listOfUserTerritories.isEmpty()){
            for(UserTerritory userterrIns : listOfUserTerritories){
                String strTMSTerritoryNum = mapOfTerritoryIdNTMSTerritoryNumber.get(userterrIns.TerritoryId);
                mapOfUserTerritoryUserValueNTMSTerritoryNum.put(userterrIns.UserId, strTMSTerritoryNum);
            }
        }
        
        // Logic for updating the TMS Territory Number in Lead
        for(Lead led :listOfLeadToBeProcessed){
            if(!mapOfUserTerritoryUserValueNTMSTerritoryNum.isEmpty() && mapOfUserTerritoryUserValueNTMSTerritoryNum.get(led.ownerId) != Null){
                led.LCRM_Lead_Owner_TMS_Territory__c = mapOfUserTerritoryUserValueNTMSTerritoryNum.get(led.ownerId);
            }else{
                led.LCRM_Lead_Owner_TMS_Territory__c ='';
            }
            if(!allowTriggerHandlerToRun){// When record is processing through the batch - these values are decision factor to get records for next batch
                led.LCRM_Mass_Load_Indicator__c = false ;
                led.LCRM_Territory_Update_Timestamp__c = datetime.now();
            }
        }
    }
    Catch(Exception e){
            System.debug('e'+e.getMessage());
    }
        //Logic end
    }
    Method will retun map of all Eloqa and Informatica Integration User's Id and Name
    
    public static Map<Id,User> getIntegartionUsersDetails(){
        
        Id eloquaProfileId =[SELECT Id FROM Profile WHERE name =: 'Eloqua Marketing'].Id;
        Map<Id,User> mapOfIntegrationUsersIdAndInfo = new Map<Id,User>([Select Id,Name,profileId from User 
                                                        where profileId =:eloquaProfileId OR Name =:'Informatica GLI Integration']);
        system.debug('@@@@mapOfIntegrationUsersIdAndInfo--->'+mapOfIntegrationUsersIdAndInfo);                                                
        return mapOfIntegrationUsersIdAndInfo ;
    }
    
    */
}