/**
 * Provides helper methods for working with Territories
 *
 * @author  John De Santiago
 * @version 2011-01-31
 */
public without sharing class TerritoryUtil {
    //Private Variables
    Map<Id, Group> mapGroups;
    Map<Id, User> mapActiveUsers;
    Map<Id, Territory2> mapTerritories;
    Map<Id, List<User>> mapTerritoryMembers;
    public static id accId;
    //Properties 
    public Map<Id, Group> groups {
        get { 
            if (mapGroups == null) {
                mapGroups = mapGroups(accId);
            }
            
            return mapGroups;
        }
    }
    
    public Map<Id, User> activeUsers {
        get { 
            if (mapActiveUsers == null) {
                mapActiveUsers = mapActiveUsers();
            }
            
            return mapActiveUsers;
        }
    }
    
    public Map<Id, Territory2> territories {
        get { 
            if (mapTerritories == null) {
                mapTerritories = mapTerritories();
            }
            
            return mapTerritories;
        }
    }
    
    public Map<Id, List<User>> territoryMembers {
        get { 
            if (mapTerritoryMembers == null) {
                mapTerritoryMembers = mapTerritoryMembers();
            }
            
            return mapTerritoryMembers;
        }
    }
    
    //Constructor
    
    /**
     * Default Constructor
     */
    public TerritoryUtil() {
        system.debug('Default Constructor'); // Added to avoid empty statement block. 
    }
    
    //Public Methods
    
    /**
     * Identifies and returns a list of territory users for the specified account
     *
     * @param   accountId   an account id
     * @return  a list of User objects by account id
     */
    public List<User> listAccountTerritoryMembers(Id accountId) {
        List<User> listTerritoryMembers = new List<User>();
        
        Map<Id, List<User>> mapAccountTerritoryMembers = mapAccountTerritoryMembers(new Set<Id>{ accountId });
        if (mapAccountTerritoryMembers.containsKey(accountId)) {
            listTerritoryMembers = mapAccountTerritoryMembers.get(accountId);
        }   
        
        return listTerritoryMembers;
    }
    
    /**
     * Identifies and returns a map of a list of territory users for the specified set of accounts
     *
     * @param   accountIds  a set of account ids
     * @return  a map of a list of User objects by account id
     */
    public Map<Id, List<User>> mapAccountTerritoryMembers(Set<Id> accountIds) {
        Map<Id, List<User>> mapAccountTerritoryMembers = new Map<Id, List<User>>();
        
        //Map Account Shares
        Map<Id, List<AccountShare>> mapAccountShares = mapAccountShares(accountIds);
        
        //Map Account Team Members
        for (Id accountId : accountIds) {
            if (mapAccountShares.containsKey(accountId)) {
                for (AccountShare oAccountShare : mapAccountShares.get(accountId)) {
                    Group oGroup = groups.get(oAccountShare.UserOrGroupId);
                    
                    if (oGroup != null && territoryMembers.containsKey(oGroup.relatedId)) {
                        //if(territoryMembers.containsKey(oGroup.relatedId)){
                            List<User> oTerritoryMembers = territoryMembers.get(oGroup.relatedId);           
                            //system.debug('test****'+oGroup.relatedId+'**'+oAccountShare.UserOrGroupId+'***'+oAccountShare.id+'***'+oTerritoryMembers+'***'+TerritoryMembers.containskey(oGroup.relatedId));                        
                            if (oTerritoryMembers.isEmpty() == false) {
                                if (mapAccountTerritoryMembers.containsKey(accountId)) {
                                    List<User> listAccountTerritoryMembers = mapAccountTerritoryMembers.get(accountId);
                                    listAccountTerritoryMembers.addAll(oTerritoryMembers);
                                }
                                else {
                                    mapAccountTerritoryMembers.put(accountId, oTerritoryMembers);
                                }
                            }
                        //}   
                    }
                }
            }
        }
        
        return mapAccountTerritoryMembers;
    }
    
    //Private Methods
    
    /**
     * Loads map of AccountShares by account id
     *
     * @param   accountIds  a set of account ids
     * @return  a map of a list of AccountShare objects by account id
     */
    @TestVisible
    private Map<Id, List<AccountShare>> mapAccountShares(Set<Id> accountIds) {
        Map<Id, List<AccountShare>> mapShares = new Map<Id, List<AccountShare>>();
        
        //for(AccountShare oShare : [SELECT Id, AccountId, UserOrGroupId FROM AccountShare WHERE AccountId IN :accountIds AND UserOrGroupId != null AND RowCause='TerritoryManual']) {
        for(AccountShare oShare : [SELECT Id, AccountId, RowCause,UserOrGroupId FROM AccountShare WHERE AccountId IN :accountIds AND UserOrGroupId != null ]) {
        system.debug('-------'+oShare.RowCause);
            if (mapShares.containsKey(oShare.AccountId)) {
                List<AccountShare> listShares = mapShares.get(oShare.AccountId);
                listShares.add(oShare);
            }
            else {
                List<AccountShare> listShares = new List<AccountShare>();
                listShares.add(oShare);
                
                mapShares.put(oShare.AccountId, listShares);
            }
        }
        
        return mapShares;
    }
    
    /**
     * Loads map of Groups by group id
     *
     * @return  a map of Group objects by group id
     */
    private Map<Id, Group> mapGroups(Id accId) {
       	 List<AccountShare> accshareList = new List<AccountShare>();
        Map<Id,Id> sharegrpid = new Map<Id,Id>();
        if(Schema.sObjectType.Accountshare.isAccessible()){
                    accshareList =[select AccountId,UserorGroupId from Accountshare where AccountId = :accId AND
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
		system.debug('sharegrpId.values()-->'+ sharegrpId.values());
        return new Map<Id, Group>([SELECT Id, RelatedId FROM Group WHERE Id IN: sharegrpId.values() AND Type = 'Territory']);
    }
    
    /**
     * Loads map of active users by group id
     *
     * @return  a map of User objects by user id
     */
    @TestVisible
    private Map<Id, User> mapActiveUsers() {
        return new Map<Id, User>([SELECT Id, Name, Phone, Email, Rep_Employee_Number__c, Rep_Type_Description__c, Profile.Name  FROM User WHERE IsActive=true and Rep_Type_Description__c!= null]);
    }
    
    /**
     * Loads map of Territories by territory id
     *
     * @return  a map of Territory objects by territory id
     */
    @TestVisible
    private Map<Id, Territory2> mapTerritories() {
        return new Map<Id, Territory2>([SELECT Id, Name FROM Territory2]);
    }
    
    /**
     * Identifies and returns a map of TerritoryMembers objects by territory id
     *
     * @return  a map of User objects by territory id
     */
    @TestVisible
    private Map<Id, List<User>> mapTerritoryMembers() {
        Map<Id, List<User>> mapTerritoryMembers = new Map<Id, List<User>>();
        
        //Map Territory and Users
        for(UserTerritory2Association  oUserTerritory : [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association  WHERE IsActive=true]) {
            Territory2 oTerritory = this.territories.get(oUserTerritory.Territory2Id);
            User oUser = this.activeUsers.get(oUserTerritory.UserId);
            
            if (oTerritory != null && oUser != null) {
                if (mapTerritoryMembers.containsKey(oTerritory.Id)) {
                    List<User> oTerritoryMembers = mapTerritoryMembers.get(oTerritory.Id);
                    oTerritoryMembers.add(oUser);
                }
                else {
                    mapTerritoryMembers.put(oTerritory.Id, new List<User>{ oUser });
                }
            }
        }
        
        return mapTerritoryMembers;
    }
}