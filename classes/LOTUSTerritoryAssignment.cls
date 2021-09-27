/********************************************
@Class Name : LOTUSTerritoryAssignment

@Purpose : The below class receives sobject records from 
LOTUSTerritoryAssignmentHandler apex class.
Also this class assigns Territory2Id value to the respetive opportunity.

*********************************************/
public without sharing class LOTUSTerritoryAssignment {
    List<ObjectTerritory2Association> objTerrList = new List<ObjectTerritory2Association>();
    
    Map<Id,Id> ownerIdMap = new Map<Id,Id>();
    Map<Id,Id> userTerrMap = new Map<Id,Id>();
    List<Id> userIdList = new List<Id>();
    List<Id> territory2IdList = new List<Id>();
    List<Id> objTerritiryIds = new List<Id>();
    Map<Id,String> objTerr2Map = new Map<Id,String>(); 
    List<AccountTeamMember> accountteammemberownerlist = new  List<AccountTeamMember>();
    Map<id,string> temaroleAccId = new Map<id,string>();
    Map<id,string> temaroleuserid= new Map<id,string>();    
    //Set of lead status 
    set<String> setOfleadStatus = new set<String>{'Converted','Discarded','Disqualified'};        
        /**
@Method Name : populateTerritoryId 

@purpose : populateTerritoryId method is used to populate 'Territory2Id' value on 
opportunity during before inert/before update of opportunity trigger
*/
        public void populateTerritoryId(List<sObject> sobjectList, String objectName){
            if(String.isNotBlank(objectName) &&  objectName == 'Opportunity' && sobjectList.size() > 0){
                System.debug('INSIDE OPPORTUNITY');
                set<String> opptyStatus = new set<String>();
                opptyStatus = LOTUSTerritoryAssignmentHandler.getOpptyStatus();
                if(opptyStatus.size() > 0){                    
                    for(sobject sobjRec :sobjectList){
                        system.debug('@@sobjRec'+sobjRec);
                        Opportunity opptyRec = (Opportunity)sobjRec;
                        //GLI condition
                        if(!opptyStatus.contains(opptyRec.StageName) && opptyRec.is_gli__c == true){                           
                            ownerIdMap.put(opptyRec.AccountId,opptyRec.OwnerId);                            
                        }                     
                        
                    }
                    
                    if(ownerIdMap.size() > 0){
                        //Query UserTerritory2 - Get all the territories of the owner   
                        userTerrMap = getTerrIdOwnerIdMap(ownerIdMap,objectName);                     
                    } 
                    System.debug('@@userTerrMap'+userTerrMap);
                    //Query ObjectTerritory2Association                    
                    if(userTerrMap.size() > 0 ){
                        System.debug('@@userTerrMap'+userTerrMap);                        
                        userIdList.addAll(userTerrMap.values());
                        territory2IdList.addAll(userTerrMap.Keyset());
                        System.debug('@@userTerrMap'+userIdList);
                        System.debug('@@userTerrMap'+territory2IdList);                        
                        System.debug('@@userIdList'+userIdList);
                        System.debug('@@objectName@@'+objectName);
                        if(userIdList.size() > 0){
                            objTerr2Map = getTerritory2IdMap(objectName,userTerrMap);
                        }
                        System.debug('@@objTerr2Map'+objTerr2Map);
                        objTerritiryIds.addAll(objTerr2Map.Keyset());
                    } 
                    //Territory value assigns here.
                    for(sobject sobjRec :sobjectList){
                        Opportunity opptyRec = (Opportunity)sobjRec;
                        System.debug('@@objTerr2Map'+objTerr2Map);
                        if(objTerr2Map.size() > 0){
                            System.debug('@@objTerr2Map'+objTerr2Map);
                            System.debug('@@objTerritiryIds[0]'+objTerritiryIds[0]);
                            opptyRec.Territory2Id = objTerritiryIds[0];
                        }
                        else{
                            System.debug('@@Assigning Null');
                            //System.debug('@@objTerr2Map'+objTerr2Map);
                            //System.debug('@@objTerritiryIds[0]'+objTerritiryIds[0]);
                            opptyRec.Territory2Id = null;
                        }
                        
                    }
                    
                }
                else{  System.debug('Oppty Status - Not populated in custom settings');
                    }              
            }            
        }
    /**
@Method Name : getTerrIdOwnerIdMap 

@purpose : method is used to get map of territory2Id and 
userId from userterritory Object
*/
    private Map<Id,Id> getTerrIdOwnerIdMap(Map<Id,Id> ownerIdMap, String objectName){
        Map<Id,Id> ownersTerrIdMap = new Map<Id,Id>();
        if(ownerIdMap.size() > 0 && String.isNotBlank(objectName)){
            System.debug('@@INSIDE getTerrIdOwnerIdMap Method');
            for(UserTerritory2Association userTerrRec : [SELECT Id,IsActive,LastModifiedById,LastModifiedDate,RoleInTerritory2,Territory2Id,UserId FROM UserTerritory2Association
                                                         WHERE UserId IN : ownerIdMap.values()] ){
                                                             System.debug('@@Territory2Id'+userTerrRec.Territory2Id);
                                                             System.debug('@@UserTerritory2Id'+userTerrRec.UserId);
                                                             if(userTerrRec.Territory2Id != null && userTerrRec.UserId != null){
                                                                 System.debug('@@Territory2Id'+userTerrRec.Territory2Id);
                                                                 System.debug('@@UserTerritory2Id'+userTerrRec.UserId);
                                                                 // ownersTerrIdMap.put(userTerrRec.UserId,userTerrRec.Territory2Id);
                                                                 ownersTerrIdMap.put(userTerrRec.Territory2Id,userTerrRec.UserId);
                                                             }
                                                             
                                                         }
            System.debug('@@ownersTerrIdMap'+ownersTerrIdMap);  
        }
        
        if(ownersTerrIdMap.size() > 0){
            return ownersTerrIdMap;
        }
        else{
            return ownersTerrIdMap;
        }        
    }
    
    /**
@Method Name : getTerritory2IdMap 

@purpose : Method is used to check the below two functionalities.

1] To check whether the account is shared with territory or vice versa.
2] If shared then query the appropriate account in ObjectTerritory2Association object 
and get the appropriate territory2 value. 
*/
    private Map<Id,String> getTerritory2IdMap(String objectName,Map<Id,Id>territory2IdMap){
        Map<Id,String> objTerr2IdMap = new Map<Id,String>();
        Map<Id,Id> ownersTerrNumMap = new Map<Id,Id>();
        
        /********Account Share Logic********/
        Set<id> accountIdSet = new Set<id>();
        Map<id,id> sharegrpid = new  Map<id,id>();
        Map<id,id> groupRelatedId = new map<id,id>();
        Map<id,id> sharegrpRelatedid = new map<id,id>();
        Map<id,list<id>> shareaccountid = new  Map<id,list<id>>();
        List<accountshare> accshareList = new List<accountshare>();
        if(ownerIdMap.size() > 0){
            accountIdSet.addall(ownerIdMap.Keyset());
            System.debug('accountIdSet'+accountIdSet);
            if(accountIdSet.size() > 0){
                //Logic                
                
                if(Schema.sObjectType.Accountshare.isAccessible()){
                    accshareList =[select AccountId,UserorGroupId from Accountshare where AccountId in:accountIdSet AND
                                   (RowCause IN ('Territory2AssociationManual') OR Rowcause IN ('Manual'))];
                }
                System.debug('@@accshareList@@'+accshareList);
                if(accshareList.size() > 0){
                    for(AccountShare accshare: accshareList){
                        if(accshare.UserorGroupId != null){
                            sharegrpid.put(accshare.id,accshare.UserorGroupId);
                        }
                    }
                }
                
                if(sharegrpid != null && sharegrpid.size() > 0){
                    System.debug('@@sharegrpid@@'+sharegrpid);
                    for(Group grp:[select id,relatedid,type from group where id in:sharegrpid.values() AND Type = 'Territory']){
                        if(grp.relatedid != null){
                            groupRelatedId.put(grp.id,grp.relatedid);   
                        }
                            
                    }
                    system.debug('***groupRelatedId'+groupRelatedId);
                    for (id accshareid:sharegrpid.keyset()){
                        if(groupRelatedId.containsKey(sharegrpid.get(accshareid))){
                            sharegrpRelatedid.put(accshareid,groupRelatedId.get(sharegrpid.get(accshareid)));
                        }
                            
                    }
                    system.debug('***sharegrpRelatedid'+sharegrpRelatedid);
                    for(AccountShare accshare:accshareList){
                        if(!shareaccountid.containskey(accshare.accountid)){
                            shareaccountid.put(accshare.accountid,new id[]{});
                        }
                        if(sharegrpRelatedid.containsKey(accshare.id)){
                            shareaccountid.get(accshare.accountid).add(sharegrpRelatedid.get(accshare.id));
                        }
                            
                    }
                }                    
                
            }
        } 
        /********End of Account Share Logic**********/
        
        
        
        System.debug('@@sharegrpid@@'+sharegrpid);
        system.debug('***groupRelatedId'+groupRelatedId);
        system.debug('***sharegrpRelatedid'+sharegrpRelatedid);
        System.debug('@@@@shareaccountid.keyset()@@'+shareaccountid.keyset());
        System.debug('@@@@ userTerrMap.Keyset()@@'+userTerrMap.Keyset());
        
        
        
        if(String.isNotBlank(objectName)){
            
            System.debug('INSIDE getTerritory2Id method');
            if(ObjectTerritory2Association.sObjectType.getDescribe().isAccessible()){
                objTerrList = [SELECT AssociationCause,Id,LastModifiedById,LastModifiedDate,ObjectId,SobjectType,
                               Territory2Id,Territory2.TMS_Terr_Num__c FROM ObjectTerritory2Association 
                               WHERE Territory2Id IN :userTerrMap.Keyset()  AND ObjectId IN:shareaccountid.keyset()
                               ORDER BY Territory2.TMS_Terr_Num__c DESC NULLS LAST Limit 1 ];
                
            }
            System.debug('@@objTerrList'+objTerrList);
            
            if(objTerrList.size() > 0){
                for(ObjectTerritory2Association objterrIns : objTerrList){
                    System.debug('INSIDE objterrIns Loop');
                    objTerr2IdMap.put(objterrIns.Territory2Id,objterrIns.Territory2.TMS_Terr_Num__c);
                }
            }
            
            
        }
        
        return objTerr2IdMap;
    }
    public class Territory2OpptyException extends Exception {}
    
}