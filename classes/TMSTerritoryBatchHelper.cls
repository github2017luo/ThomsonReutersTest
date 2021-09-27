/*
======================================================================================================================
CLASS NAME:  TMSTerritoryBatchHelper
======================================================================================================================
PURPOSE:  A new batch needs to be written to load TMS Territory and Account Territory from Territory. Refresh periodically after the informatica job runs.
Technical Details:  A new batch class needs to be created in SFDC to populate TMS Territory and Account Territory Objects
JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
CHANGE HISTORY:

======================================================================================================================
DATE           Developer NAME              DESC
24/07/2018      Radhika Pawar     
======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components
public class TMSTerritoryBatchHelper{
    
    public TMSTerritoryBatchHelper()
    {}
    /*Public Static void CreateTMSTerritory(List<AccountTeamMember > AccTeamMemberlst){
    
    try{
        Map<id,id> AccountTeamwithUserids = new Map<id,id>();
        Map<Id,Set<Id>>  Mapofuserterritory = new Map<Id,Set<Id>>();
        Map<id,set<id>> sharegrpRelatedid = new map<id,set<id>>();
        Set<Id> Territoryvalues = new Set<Id>();
        Map<id,Set<String>> AccountgroupRelatedId = new  Map<id,Set<String>>();
        Map < Id, Territory > mapOfTerritories = new Map < Id, Territory>();
        Map <String, TMS_Territory__c > mapOfTMSTerritories = new Map <String, TMS_Territory__c>();
        List<TMS_Territory__c> CreateTMSTerritories = new List<TMS_Territory__c>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        Map<Id,Id> MapofaccountteamIds =new Map<Id,Id>();
        Map<String,Id> mapofTerrAccUserId=new Map<String,Id>();
        Map<Id,AccountTeamMember> mapofAccountTeammembers= new Map<Id,AccountTeamMember>(); 
        Map < Id, Territory > mapOfTerritoryRole = new Map < Id, Territory>();
        set<Id> territoryIdsforRole = new set<Id>();
        //Based on Query on AccountTeam member..
        if(!AccTeamMemberlst.isEmpty()){ 
            System.debug('accountTeamMemberlist**'+AccTeamMemberlst);                                
            for(AccountTeamMember accTeamMember:AccTeamMemberlst){
                if(accTeamMember.UserId!=null && String.IsNotBlank(accTeamMember.TeamMemberRole)){
                    AccountTeamwithUserids.put(accTeamMember.id,accTeamMember.UserId);
                    mapofAccountTeammembers.put(accTeamMember.id,accTeamMember);
                }
                MapofaccountteamIds.put(accTeamMember.Id,accTeamMember.accountId); 
                System.debug('MapofaccountteamIds key'+MapofaccountteamIds.keyset());
                System.debug('MapofaccountteamIds key'+MapofaccountteamIds.values());                   
            }               
            System.debug('AccountTeamwithUserids keyset:-'+AccountTeamwithUserids.keyset());
            System.debug('AccountTeamwithUserids values:-'+AccountTeamwithUserids.values());
            System.debug('AccountTeamwithUserids size():-'+AccountTeamwithUserids.size());     

            if(!AccountTeamwithUserids.isEmpty()){                    
                for(UserTerritory  userterrRec:[select ID,userid,TerritoryId from UserTerritory where userid in: AccountTeamwithUserids.values() and IsActive=true] ){
                    if(!Mapofuserterritory.containsKey(userterrRec.userid)){
                    Mapofuserterritory.put(userterrRec.userid,new Set<Id>{userterrRec.TerritoryId});
                    }else{
                    Mapofuserterritory.get(userterrRec.userid).add(userterrRec.TerritoryId);
                    }
                    If(String.isnotblank(userterrRec.TerritoryId)){
                        territoryIdsforRole.add(userterrRec.TerritoryId);
                    }                   
                }//End userterritory if
                System.debug('Mapofuserterritory keyset:-'+Mapofuserterritory.keyset());
                System.debug('Mapofuserterritory values:-'+Mapofuserterritory.values());
                System.debug('Mapofuserterritory size:-'+Mapofuserterritory.size());    
                System.debug('territoryIdsforRole***'+territoryIdsforRole);
                //
                 //Territory SOQL
                 if(!territoryIdsforRole.isEmpty()){
                for (Territory Territories: [SELECT Id,Name,District__c,TMS_Territory_Team_Role__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c ,Channel__c FROM Territory where ID IN :territoryIdsforRole ]){
                    if(String.isnotblank(Territories.TMS_Territory_Team_Role__c)){
                        mapOfTerritoryRole.put(Territories.ID, Territories);            
                    }
                    
                }
              }
                //
                
                for (id accTeamid : AccountTeamwithUserids.keyset()){
                System.debug('AccountTeamwithUserids.get(accTeamid):-'+AccountTeamwithUserids.get(accTeamid));
                    if(Mapofuserterritory.containsKey(AccountTeamwithUserids.get(accTeamid))){
                    System.debug('Check the value of Map of userterritory:-'+Mapofuserterritory.get(AccountTeamwithUserids.get(accTeamid)));
                        //sharegrpRelatedid.put(accTeamid,Mapofuserterritory.get(AccountTeamwithUserids.get(accTeamid)));
                        
                        for( Id TerrId : Mapofuserterritory.get(AccountTeamwithUserids.get(accTeamid))){
                            System.debug('Mapof territory Roles:**'+mapOfTerritoryRole.get(TerrId).TMS_Territory_Team_Role__c);
                            System.debug('AccountTeammember Role:****'+mapofAccountTeammembers.get(accTeamid).TeamMemberRole);
                           System.debug('TerrId**'+TerrId);
                           System.debug('MapOfaccountTeammember**'+mapofAccountTeammembers.get(accTeamid));
                            if(mapOfTerritoryRole.get(TerrId).TMS_Territory_Team_Role__c == mapofAccountTeammembers.get(accTeamid).TeamMemberRole){
                            String terr = TerrId;
                            String Acc = MapofaccountteamIds.get(accTeamid);
                            String UserId = AccountTeamwithUserids.get(accTeamid);
                            mapofTerrAccUserId.put(terr+Acc,UserId);
                            if(!sharegrpRelatedid.containsKey(accTeamid)){
                            sharegrpRelatedid.put(accTeamid,new Set<Id>{TerrId});
                            }else{
                            sharegrpRelatedid.get(accTeamid).add(TerrId);
                            }
                            Territoryvalues.add(TerrId);
                            }
                            
                        }
                        
                    }
                }//end for
                
                System.debug('sharegrpRelatedid keyset:-'+sharegrpRelatedid.Keyset());
                System.debug('sharegrpRelatedid:-'+sharegrpRelatedid.values());
                System.debug('sharegrpRelatedid:-'+sharegrpRelatedid.Size());               
                System.debug('mapofTerrAccUserId keyset**'+mapofTerrAccUserId.keyset());
                System.debug('mapofTerrAccUserId values**'+mapofTerrAccUserId.values());
                System.debug('mapofTerrAccUserId**'+mapofTerrAccUserId);
                for(AccountTeamMember AccTeamMember:AccTeamMemberlst){
                System.debug('AccTeamMember:-'+AccTeamMember);
                if(!AccountgroupRelatedId.containskey(AccTeamMember.accountid)){
                System.debug('**Not AccountgroupRelatedId.containskey**');
                if(sharegrpRelatedid.get(AccTeamMember.id)!=null && sharegrpRelatedid.get(AccTeamMember.id).size()>0 && sharegrpRelatedid.containskey(AccTeamMember.id)){
                set<String> TerrwithAccID= new set<String>();
                for(String RelatedID_Terr : sharegrpRelatedid.get(AccTeamMember.id)){
                
                String AccshareID = AccTeamMember.accountId;
                System.debug('Paased the values in AccountGroupRelated ID'+RelatedID_Terr  + AccshareID);
                TerrwithAccID.add(RelatedID_Terr  + AccshareID);
                System.debug('TerrwithAccID:-'+TerrwithAccID);
                AccountgroupRelatedId.put(AccTeamMember.accountId,TerrwithAccID);
                System.debug('AccountgroupRelatedId:**'+AccountgroupRelatedId.values());
                }
                }
                }else{
                if(sharegrpRelatedid.get(AccTeamMember.id)!=null && sharegrpRelatedid.get(AccTeamMember.id).size()>0 && sharegrpRelatedid.containskey(AccTeamMember.id)){
                System.debug('**AccountgroupRelatedId.containskey**');
                for(String RelatedID_Terr : sharegrpRelatedid.get(AccTeamMember.id)){
                // String RelatedID_Terr = sharegrpRelatedid.get(AccTeamMember.id);
                System.debug('RelatedID_Terr:-'+RelatedID_Terr);                
                String AccshareID = AccTeamMember.accountid;
                System.debug('RelatedID_Terr + AccshareID:'+RelatedID_Terr + AccshareID);
                AccountgroupRelatedId.get(AccTeamMember.accountid).add(RelatedID_Terr + AccshareID);
                System.debug('AccountgroupRelatedId:**'+AccountgroupRelatedId.values());
                }
                }
                }//End else
                }//End Loop Accountteammember
                System.debug('***AccountgroupRelatedId Keyset:-'+AccountgroupRelatedId.keyset());
                system.debug('***AccountgroupRelatedId Values:-'+AccountgroupRelatedId.values());
                system.debug('***AccountgroupRelatedId Size:-'+AccountgroupRelatedId.size());
               
                
            }//End IF condition of UserId   
            //
             System.debug('**Territoryvalues**:-'+Territoryvalues);  
            if(!Territoryvalues.isEmpty()){
            for (Territory Territories: [SELECT Id,Name,District__c,TMS_Territory_Team_Role__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName,TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c ,Channel__c FROM Territory where Id IN :Territoryvalues ]){
                mapOfTerritories.put(Territories.ID, Territories);          
            }
            System.debug('=== all Territories keys in the map: ' + mapOfTerritories.keySet());
            System.debug('=== all Territories values in the map (as a List): ' + mapOfTerritories.values());
            System.debug('=== size of MapOfTerritories: ' + mapOfTerritories.size());
            }//End of sharegrpRelatedid           
            //
            //Created Map for Territory ID is Key and TMS_Territory Record
            if(!mapOfTerritories.isEmpty()){
            for(TMS_Territory__c TMSTerr:[SELECT Id, Name, RestrictOpportunityTransfer__c, ParentTerritory__c, DeveloperName__c, ForecastUser__c, MayForecastManagerShare__c, Region__c, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Parent_Territory_ID__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Territory_ID__c, TMS_Territory_Number__c, Account__c, Territory_ID__c, District__c, AccountAccessLevel__c, CaseAccessLevel__c, ContactAccessLevel__c, Description__c, OpportunityAccessLevel__c, TMS_Sales_Force_Code__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c,Channel__c,LCRM_AccountTeamMemberUserId__c FROM TMS_Territory__c where Territory_ID__c IN :mapOfTerritories.keySet() and Account__c IN: MapofaccountteamIds.values() ]){
                mapOfTMSTerritories.put(TMSTerr.Territory_ID__c+TMSTerr.Account__c,TMSTerr);                
            }
            System.debug('mapOfTMSTerritories :-'+mapOfTMSTerritories );
            System.debug('mapOfTMSTerritories :-'+mapOfTMSTerritories.keyset() );
            System.debug('mapOfTMSTerritories :-'+mapOfTMSTerritories.values() );
            }//end of mapOfTerritories


            if(!AccountgroupRelatedId.keyset().isempty()){
                for(Id accId: AccountgroupRelatedId.keyset()){
                System.debug('accId:-'+accId);
                if(AccountgroupRelatedId.containsKey(accId)) {
                    System.debug('AccountgroupRelatedId.get(accId):-'+AccountgroupRelatedId.get(accId));
                    for(String territoryid: AccountgroupRelatedId.get(accId)){
                        if(String.isnotblank(territoryid)){
                            System.debug('territoryid:-'+territoryid);
                        System.debug('size: ' + territoryid.length() );
                        System.debug('Test**'+mapOfTerritories.get(territoryid.substring(0,18)));
                        //System.debug('territoryid***'+mapOfTerritories.get(territoryid));
                        System.debug('mapOfTMSTerritories.get(territoryid):-'+mapOfTMSTerritories.get(territoryid));
                        if(mapOfTMSTerritories.containsKey(territoryid)) {
                            System.debug('****called***');
                            Territory trr = mapOfTerritories.get(territoryid.substring(0,18));
                            System.debug('trr:_'+trr);
                            String terraccIds=String.valueof(trr.id)+String.valueof(accId);
                            String accountTeamuserId = mapofTerrAccUserId.get(terraccIds);
                           CreateTMSTerritories.add(MappingParameterwithTerritoryupdated(trr,accId, mapOfTMSTerritories.get(territoryid),accountTeamuserId));                    
                        }else{
                            System.debug('TerrLinked ***'+territoryid );
                            //System.debug('TerrLinked ID ***'+mapOfTerritories.get(territoryid) );
                            TMS_Territory__c TMSterritory= new TMS_Territory__c();
                            Territory trr = mapOfTerritories.get(territoryid.substring(0,18));
                            System.debug('trr:_'+trr);
                            String terraccIds=String.valueof(trr.id)+String.valueof(accId);
                            String accountTeamuserId = mapofTerrAccUserId.get(terraccIds);
                            System.debug('accountTeamuserId**'+accountTeamuserId);
                            CreateTMSTerritories.add(MappingParameterwithTerritoryupdated(trr,accId,TMSterritory,accountTeamuserId));    
                        }
                        }
                        
                        }//For Loop for Territory

                    }//IF Check
                }//End For loop

            }//End If Check


            System.debug('***CreateTMSTerritories***:-'+CreateTMSTerritories);
            if(CreateTMSTerritories !=null && CreateTMSTerritories.size()>0){
            //upsert CreateTMSTerritories;
            Database.UpsertResult[] results = Database.upsert(CreateTMSTerritories, false);
             if(!results.isEmpty()){
                    for(integer i=0;i<results.size();i++){
                        if(results.get(i).isSuccess()){
                            System.debug(results.get(i).getId());
                            //successNoteList.add(results.get(i).getId());
                        } else if(!results.get(i).isSuccess()){
                            System.debug('results.get(i).getErrors().get(0):'+results.get(i).getErrors().get(0));
                            Database.Error err = results.get(i).getErrors().get(0);
                            String strException = err.getMessage();
                            String strStackTrace = String.valueof(err.getFields());
                            String Batchclassname= 'TMSTerritory_AccountTeamBatch';
                            exceptionList.add(createExceptionLog(strException,strStackTrace,Batchclassname));
                        }
                    }
                }
            System.debug('***CreateTMSTerritoriesAfter Upsert***:-'+CreateTMSTerritories);
            }

        }//End If AccountTeammemberlist
        
        if(Test.isRunningTest()){
            String strException = 'Test Exception';
            String strStackTrace = 'Test Exception';
            String Batchclassname= 'TMSTerritory_TerritoryBatch';
            exceptionList.add(createExceptionLog(strException,strStackTrace,Batchclassname));
        }
        if(!exceptionList.isEmpty()){
         insert exceptionList;
        } 
        
    }catch(Exception err){
        System.debug('Excep***'+err);
        List<LCRM_Exception_Log__c> excepList = new List<LCRM_Exception_Log__c>();
        String strException = err.getMessage();
        String strStackTrace = err.getStackTraceString();
        String Batchclassname= 'TMSTerritory_AccountTeamBatch';
        excepList.add(createExceptionLog(strException,strStackTrace,Batchclassname));

        if(excepList.size()>0){
        insert excepList;
        }
    }
        
         
    
    }// CreateTMSTerritory method end

    
   Public Static void UpdateTMSTerritory(List<TMS_Territory__c > territorylist){        
    try{
      System.debug('**UpdateTMSTerritory**');
        List<TMS_Territory__c> CreateTMSTerritories = new List<TMS_Territory__c>();
        Map<Id,Territory> Mapofterritory = new Map<Id,Territory>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
               
        set<Id> TerrIds= new set<Id>(); 
         if( !territorylist.isEmpty()){
            for(TMS_Territory__c TmsTerrRec:territorylist){
                TerrIds.add(TmsTerrRec.Territory_ID__c);
            }
        }
        System.debug('TerrIds**'+TerrIds);
        if( !TerrIds.isEmpty()){        
            for(Territory territoryRec: [SELECT Id, Name,TMS_Territory_Team_Role__c,ParentTerritoryId, Description, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, ForecastUserId, MayForecastManagerShare, CurrencyIsoCode, RestrictOpportunityTransfer, DeveloperName, LastModifiedDate, LastModifiedById, SystemModstamp, TMS_Market_Segment_Desc__c, TMS_Market_Segment_ID__c, TMS_Parent_Territory_ID__c, TMS_Rep_Function_Desc__c, TMS_Rep_Function_ID__c, TMS_Sales_Force_Desc__c, TMS_Sales_Force_ID__c, TMS_Terr_Num__c, TMS_Territory_ID__c, TMS_New_Sales_Quota_Curr_Yr__c, TMS_Renewal_Sales_Quota_Curr_Yr__c, Region__c, TMS_Market_Segment_Code__c, TMS_Ref_Function_Code__c, TMS_Sales_Force_Code__c, District__c, Channel__c FROM Territory where Id IN:TerrIds]){
                Mapofterritory.put(territoryRec.Id,territoryRec);
            }
        }        
        System.debug('Mapofterritory.values***'+Mapofterritory.values());
        System.debug('Mapofterritory.values***'+Mapofterritory.keyset());
        System.debug('Mapofterritory.values***'+Mapofterritory.size());
        
         if( !Mapofterritory.isEmpty()){
            for(TMS_Territory__c TmsTerrRec:territorylist){
             CreateTMSTerritories.add(MappingParameterwithTerritoryupdated(Mapofterritory.get(TmsTerrRec.Territory_ID__c),TmsTerrRec.Account__c,TmsTerrRec,TmsTerrRec.LCRM_AccountTeamMemberUserId__c));  
            }
        }
        
        //Need to change 
        if(CreateTMSTerritories !=null && CreateTMSTerritories.size()>0){
               Database.SaveResult[] results = Database.update(CreateTMSTerritories, false); 
               System.debug('results '+results.size());
                if(!results.isEmpty()){
                    for(integer i=0;i<results.size();i++){
                        if(results.get(i).isSuccess()){
                            System.debug(results.get(i).getId());
                        } else if(!results.get(i).isSuccess()){
                            System.debug('results.get(i).getErrors().get(0):'+results.get(i).getErrors().get(0));
                            Database.Error err = results.get(i).getErrors().get(0);
                            String strException = err.getMessage();
                            String strStackTrace = String.valueof(err.getFields());
                            String Batchclassname= 'TMSTerritory_TerritoryBatch';
                            exceptionList.add(createExceptionLog(strException,strStackTrace,Batchclassname));
                        }
                    }
                }
                System.debug('***CreateTMSTerritoriesAfter update***:-'+CreateTMSTerritories);
         }
         
        if(Test.isRunningTest()){
            String strException = 'Test Exception';
            String strStackTrace = 'Test Exception';
            String Batchclassname= 'TMSTerritory_TerritoryBatch';
            exceptionList.add(createExceptionLog(strException,strStackTrace,Batchclassname));
        }
        if(!exceptionList.isEmpty()){
         insert exceptionList;
        } 
         
        }catch(Exception err){
        System.debug('Excep***'+err);
        List<LCRM_Exception_Log__c> excepList = new List<LCRM_Exception_Log__c>();
        String strException = err.getMessage();
        String strStackTrace = err.getStackTraceString();
        String Batchclassname= 'TMSTerritory_TerritoryBatch';
        excepList.add(createExceptionLog(strException,strStackTrace,Batchclassname));

        if(excepList.size()>0){
            insert excepList;
        }
        }

    }//Method End


    
    public static LCRM_Exception_Log__c createExceptionLog( String Excep,String strStackTrace,String Batchclassname ){
        System.debug('**createExceptionLog**');
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c = Excep;
        excepObj.LCRM_Exception_Trace__c = Batchclassname+' '+strStackTrace;
        excepObj.LCRM_Exception_Type__c = 'Error found in TMS Territories Creation/updation';       
        excepObj.LCRM_User_ID__c = userinfo.getUserId();
        return excepObj;
        
    }

    
     public static TMS_Territory__c MappingParameterwithTerritoryupdated(Territory terr,Id accId,TMS_Territory__c TMSTerr,string accountTeamuserId ){
        System.debug('***MappingParameterwithTerritory***'+accId);
        System.debug('***MappingParameterwithTerritory***'+terr);
        System.debug('***MappingParameterwithTerritory***'+TMSTerr);
        System.debug('***MappingParameterwithTerritory***'+accountTeamuserId);
        TMSTerr.name = terr.name;
        TMSTerr.Account__c =accId;
        TMSTerr.AccountAccessLevel__c=terr.AccountAccessLevel;
        TMSTerr.RestrictOpportunityTransfer__c = terr.RestrictOpportunityTransfer;
        TMSTerr.DeveloperName__c=terr.DeveloperName;
        TMSTerr.ForecastUser__c = terr.ForecastUserId;
        TMSTerr.MayForecastManagerShare__c = terr.MayForecastManagerShare;
        TMSTerr.Region__c = terr.Region__c;
        TMSTerr.TMS_Market_Segment_Desc__c = terr.TMS_Market_Segment_Desc__c;
        TMSTerr.TMS_Market_Segment_ID__c = terr.TMS_Market_Segment_ID__c;
        TMSTerr.TMS_New_Sales_Quota_Curr_Yr__c= terr.TMS_New_Sales_Quota_Curr_Yr__c;
        TMSTerr.TMS_Parent_Territory_ID__c= terr.TMS_Parent_Territory_ID__c;
        TMSTerr.TMS_Renewal_Sales_Quota_Curr_Yr__c = terr.TMS_Renewal_Sales_Quota_Curr_Yr__c;
        TMSTerr.TMS_Rep_Function_Desc__c= terr.TMS_Rep_Function_Desc__c;
        TMSTerr.TMS_Rep_Function_ID__c = terr.TMS_Rep_Function_ID__c;
        TMSTerr.TMS_Sales_Force_Desc__c = terr.TMS_Sales_Force_Desc__c;
        TMSTerr.TMS_Sales_Force_ID__c = terr.TMS_Sales_Force_ID__c;
        TMSTerr.TMS_Territory_ID__c = terr.TMS_Territory_ID__c;
        TMSTerr.TMS_Territory_Number__c = terr.TMS_Terr_Num__c;
        TMSTerr.CaseAccessLevel__c= terr.CaseAccessLevel;
        TMSTerr.ContactAccessLevel__c= terr.ContactAccessLevel;
        TMSTerr.Description__c= terr.Description;
        TMSTerr.OpportunityAccessLevel__c= terr.OpportunityAccessLevel;
        TMSTerr.TMS_Sales_Force_Code__c= terr.TMS_Sales_Force_Code__c;
        TMSTerr.TMS_Market_Segment_Code__c= terr.TMS_Market_Segment_Code__c;
        TMSTerr.TMS_Ref_Function_Code__c= terr.TMS_Ref_Function_Code__c;
        TMSTerr.ParentTerritory__c = terr.ParentTerritoryId;
        TMSTerr.Territory_ID__c = terr.id;
        TMSTerr.District__c=terr.District__c;
        TMSTerr.Channel__c = terr.Channel__c;
        TMSTerr.LCRM_AccountTeamMemberUserId__c=accountTeamuserId;
        return TMSTerr;
    }*/
    
}