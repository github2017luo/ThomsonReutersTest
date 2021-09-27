/**
 * Provides helper methods for working with the territory hierarchy
 *
 * @author  John De Santiago
 * @version 2012-07-19
 *
 * CHANGE HISTORY
 * ==========================================================================================================================
 * Date         Name                    Description
 * 2012-10-10   Glenda Ninan            Defect 3498: Display Active Territories only
 * 2012-10-12   Glenda Ninan            Defect 3425: Fix Too many scripts error 
 * 2013-05-28   Glenda Ninan            IM4408224 - Fix 'Too many code statements: 200001' error
 * 2019-03-20   Ramesh T N              Advanced Search Fix for attempt to de-reference Null Pointer Exception (MCL-2189)
 * =========================================================================================================================
 */
public with sharing class TerritoryHierarchy {
    //Protected members
    private Map<Id, User> mapUsers;
    private Map<Id, List<Group>> mapTerritoryGroups;
    private Map<Id, TerritoryNode> mapTerritoryNodes;
    private Map<Id, Set<Id>> mapParentTerritoryIndex;
    //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
    //private Map<Id, List<UserTerritory>> mapTerritoryUserTerritories;
    private Map<Id, List<UserTerritory2Association>> mapTerritoryUserTerritories;
    private Map<string, string> mapFunctions = new Map<string, string> {
         'Account Director' => 'Director'
        ,'Dir Natl Acct Prog' => 'Director'
        ,'Dir of Customer Dev' => 'Director'
        ,'Director' => 'Director'
        ,'Director BAM' => 'Director'
        ,'Director Field Mgmt' => 'Director'
        ,'Director Key Accts' => 'Director'
        ,'Director of Acct Mg' => 'Director'
        ,'Director of Sales' => 'Director'
        ,'Global Acct Director' => 'Director'
        ,'GM/VP' => 'GM/VP'
        ,'Manager' => 'Manager'
        ,'Reg Mgr of Acct Mgm' => 'Manager'
        ,'Reg Mgr of Sales' => 'Manager'
        ,'Regional Field Mgr' => 'Manager'
        ,'Sales Manager' => 'Manager'
        ,'Solution Svcs Mgr' => 'Manager'
        ,'Sr Dir Field Mgmt' => 'Director'
        ,'Sr Dir of Acct Mgmt' => 'Director'
        ,'Sr Dir of Sales' => 'Director'
    };
    
    //Constants
    public static final string DIRECTORROLE = 'Director';
    public static final string MANAGERROLE = 'Manager';
    public Map<Id, Set<String>> mapParentTerritoryNumberString;
    //(INC3812267)
    private Set<String> useridset;
    
    //Constructor
    
    /**
     * Default Constructor
     */
    public TerritoryHierarchy() {
        //loadUsers(); commented for FSC-146
        loadTerritoryGroups();
        loadUserTerritories();
        loadTerritoryNodesAndParentTerritoryMap();
    }
    
    //Public Methods    
    
    /**
     * Determines if the specified TMS Rep Function is considered
     * a Director role
     *
     * @param   sTerritoryFunction  a TMS Rep Function
     * @return  true if the the specified territory function is a director role, otherwise false
     */
    public boolean isDirector(string sTerritoryFunction) {
        boolean bIsDirector = false;
        
        if (AppUtil.isEmpty(sTerritoryFunction) == false) {
            string sRoleType = mapFunctions.get(sTerritoryFunction);
            bIsDirector = (sRoleType == DIRECTORROLE);
        }
        
        return bIsDirector;
    }
    
    /**
     * Determines if the specified TMS Rep Function is considered
     * a Manager role
     *
     * @param   sTerritoryFunction  a TMS Rep Function
     * @return  true if the the specified territory function is a manager role, otherwise false
     */
    public boolean isManager(string sTerritoryFunction) {
        boolean bIsManager = false;
        
        if (AppUtil.isEmpty(sTerritoryFunction) == false) {
            string sRoleType = mapFunctions.get(sTerritoryFunction);
            bIsManager = (sRoleType == MANAGERROLE);
        }
        
        return bIsManager;
    }
    
    /**
     * Retrieves all TMS territory numbers 
     * is associated with
     *
     * @param   userId  a User object id
     * @return  a set of TMS territory numbers
     */
     public Set<string> getTMSTerritoryNumbers() {
        List<string> listTerritoryNumbers = new List<string>();
        
        for (TerritoryNode oNode : mapTerritoryNodes.values()) {
            //Replacing Territory with Territory2  as a part of removing TM1.0 references
            if (AppUtil.isEmpty(oNode.Territory2.TMS_Terr_Num__c) == false) {
                listTerritoryNumbers.add(oNode.Territory2.TMS_Terr_Num__c);
            }
        }
        listTerritoryNumbers.sort();
        
        return new Set<string>(listTerritoryNumbers);
     }
    
    /**
     * Retrieves the TMS territory numbers for the specified user id 
     *
     * @param   userId  a User object id
     * @return  a set of TMS territory numbers
     */ 
    public Set<string> getTMSTerritoryNumbersByUserId(Id userId) {
        List<string> listTerritoryNumbers = new List<string>();
        
        //Replacing Territory with Territory2  as a part of removing TM1.0 references
        //for (Territory oTerritory : queryTerritoriesByUserId(userId)) {
        for (Territory2  oTerritory : queryTerritoriesByUserId(userId)) {   
            if (AppUtil.isEmpty(oTerritory.TMS_Terr_Num__c) == false) {
                listTerritoryNumbers.add(oTerritory.TMS_Terr_Num__c);
            }
        }
        listTerritoryNumbers.sort();
        
        return new Set<string>(listTerritoryNumbers);
    }
    
    /**
     * Retrieves the TMS territory numbers for the specified territory node
     * hierarchy 
     *
     * @param   oTerritoryNode  a TerritoryNode object
     * @return  a set of TMS territory numbers
     */ 
    public Set<string> getTMSTerritoryNumbers(TerritoryNode oTerritoryNode) {
        Set<string> setTMSTerritoryNumbers = new Set<string>();
        
        //Get Territory Number
        //Replacing Territory with Territory2  as a part of removing TM1.0 references
        //string sTerritoryNumber = oTerritoryNode.Territory.TMS_Terr_Num__c;
        string sTerritoryNumber = oTerritoryNode.Territory2.TMS_Terr_Num__c;
        if (AppUtil.isEmpty(sTerritoryNumber) == false) {
            setTMSTerritoryNumbers.add(sTerritoryNumber);
        }
        
        //Get Child Territory Numbers
        for (TerritoryNode oChildNode : oTerritoryNode.children) {
            setTMSTerritoryNumbers.addAll(getTMSTerritoryNumbers(oChildNode));  
        }
        
        return setTMSTerritoryNumbers;  
    }
    
    /**
     * Retrieves the Team TMS territory numbers by identifying the manager 
     * related to the specified user id and then retrieving all TMS territory
     * numbers related to that manager territory
     *
     * @param   userId  a User object id
     * @return  a set of TMS territory numbers
     */ 
    public Set<string> getTeamTMSTerritoryNumbersByUserId(Id userId) {
        Set<string> setTerritoryNumbers = new Set<string>();
        
        //Replacing Territory with Territory2  as a part of removing TM1.0 references
        //for (Territory oTerritory : queryTerritoriesByUserId(userId)) {
        for (Territory2 oTerritory : queryTerritoriesByUserId(userId)) {    
            Id territory2Id = oTerritory.Id;
            
            boolean bManagerFound = false;
            while (!bManagerFound) {
                TerritoryNode oParentTerritoryNode = getParentTerritoryNode(territory2Id);
                
                if (oParentTerritoryNode == null) {
                    setTerritoryNumbers.addAll(getTMSTerritoryNumbers(getTerritoryNode(territory2Id)));
                    bManagerFound = true;
                }
                else if (oParentTerritoryNode.IsDirector || oParentTerritoryNode.IsManager) {
                    setTerritoryNumbers.addAll(getTMSTerritoryNumbers(oParentTerritoryNode));
                    bManagerFound = true;
                }
                else {
                    //Replacing Territory with Territory2  as a part of removing TM1.0 references
                    territory2Id = oParentTerritoryNode.Territory2.Id;
                }
            }
        }
        
        return setTerritoryNumbers;
    }
    
    /**
     * Locates the territory node for the specified territory and then locates
     * and returns the parent territory node
     * <p>
     * This method does not utilize the getTerritoryNode() method for efficiency
     * rather it accesses the territory node map directly.
     *
     * @param   Territory2Id a Territory object id
     * @return  a TerritoryNode object representing the parent territory of the specified Territory2Id, otherwise returns null
     */
    public TerritoryNode getParentTerritoryNode(Id territory2Id) {
        TerritoryNode oParentTerritoryNode = null;
        
        if (territory2Id != null && mapTerritoryNodes.containsKey(territory2Id)) {
            TerritoryNode oTerritoryNode = mapTerritoryNodes.get(territory2Id);
            //Replacing Territory with Territory2  as a part of removing TM1.0 references
            Territory2 oTerritory = oTerritoryNode.Territory2;
            
            if (oTerritory != null && oTerritory.ParentTerritory2Id != null && mapTerritoryNodes.containsKey(oTerritory.ParentTerritory2Id)) {
                oParentTerritoryNode = mapTerritoryNodes.get(oTerritory.ParentTerritory2Id);
            }
        }
        
        return oParentTerritoryNode;
    }
    
    /**
     * Created By : Glenda Ninan
     * Locates the territory for the specified territory and then locates
     * and returns the parent territory (and not the parent territory node).
     * 
     * In order to fix the Too Many Statements error in Advanced Search and at the same time
     * not break the current functionality, this method has been created to return the parent territory.
     * This method is called in AdvancedSearchController.getActiveTeamTMSTerritoryNumbersByUserIdNew
     *
     * @param   Territory2Id a Territory object id
     * @return  a Territory object representing the parent territory of the specified Territory2Id, otherwise returns null
     */
     
    //Replacing Territory with Territory2  as a part of removing TM1.0 references
    //public Territory getParentTerritory(Id Territory2Id) {
     public Territory2 getParentTerritory(Id territory2Id) {    
        TerritoryNode oParentTerritoryNode = null;
        Territory2 oParentTerritory = null;
        if (territory2Id != null && mapTerritoryNodes.containsKey(territory2Id)) {
            TerritoryNode oTerritoryNode = mapTerritoryNodes.get(territory2Id);
            Territory2 oTerritory = oTerritoryNode.Territory2;
            
            if (oTerritory != null && oTerritory.ParentTerritory2Id != null && mapTerritoryNodes.containsKey(oTerritory.ParentTerritory2Id)) {
                oParentTerritoryNode = mapTerritoryNodes.get(oTerritory.ParentTerritory2Id);
                oParentTerritory = oParentTerritoryNode.Territory2;
            }
        }
    

        return oParentTerritory;
    }
    
    /**
     * Retrieves the territory hiearchy for the specified territory id as a top
     * level TerritoryNode object.
     * <p>
     * Only retrieves the territory and children for the specified territory. It
     * does not return parent territories for the specified territory id.
     * <p>
     * Uses recursion to retrieve each node and child node in the hierarchy
     *
     * @param   Territory2Id     a Territory object id to retrieve
     * @return  a TerritoryNode object
     */
    public TerritoryNode getTerritoryNode(Id territory2Id) {
        TerritoryNode oParentTerritoryNode = new TerritoryNode();
        
        if (territory2Id != null && mapTerritoryNodes.containsKey(territory2Id)) {
            oParentTerritoryNode = mapTerritoryNodes.get(territory2Id);
            
            if (mapParentTerritoryIndex.containsKey(territory2Id)) {
                Set<Id> childTerritory2Ids = mapParentTerritoryIndex.get(territory2Id);
                
                for (Id childTerritory2Id : childTerritory2Ids) {
                    TerritoryNode oChildTerritoryNode = getTerritoryNode(childTerritory2Id);
                    oParentTerritoryNode.children.Add(oChildTerritoryNode);
                }
            }
        }
        
        return oParentTerritoryNode;
    }
    
    //Private Methods
    
    /**
     * Maps User objects into a map by user id
     */
    /*private void loadUsers() {
        this.mapUsers = new Map<Id, User>(queryUsers());
    }*/
    
    /**
     * Maps territory based Group objects by territory id
     */
    private void loadTerritoryGroups() {
        this.mapTerritoryGroups = new Map<Id, List<Group>>();
        
        for (Group oGroup : queryGroups()) {
            if (mapTerritoryGroups.containsKey(oGroup.RelatedId)) {
                mapTerritoryGroups.get(oGroup.RelatedId).add(oGroup);
            }
            else {
                mapTerritoryGroups.put(oGroup.RelatedId, new List<Group>{ oGroup });
            }
        }
    }
    
    /**
     * Maps UserTerritory objects as a list by territory id
     */
    private void loadUserTerritories() {
        //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
        //this.mapTerritoryUserTerritories = new Map<Id, List<UserTerritory>>();
        this.mapTerritoryUserTerritories = new Map<Id, List<UserTerritory2Association>>();
        
        //for(UserTerritory oUserTerritory : queryActiveUserTerritory()) {
        for(UserTerritory2Association oUserTerritory : queryActiveUserTerritory()) {    
            if (mapTerritoryUserTerritories.containsKey(oUserTerritory.Territory2Id)) {
                mapTerritoryUserTerritories.get(oUserTerritory.Territory2Id).add(oUserTerritory);
            }
            else {
                //mapTerritoryUserTerritories.put(oUserTerritory.Territory2Id, new List<UserTerritory>{ oUserTerritory });
                mapTerritoryUserTerritories.put(oUserTerritory.Territory2Id, new List<UserTerritory2Association>{ oUserTerritory });
            }
        }
    }
    
    /**
     * Maps Territory objects as TerritoryNode objects by territory id
     */
    private void loadTerritoryNodesAndParentTerritoryMap() {
        this.mapTerritoryNodes = new Map<Id, TerritoryNode>();
        this.mapParentTerritoryIndex = new Map<Id, Set<Id>>();
        this.mapParentTerritoryNumberString = new Map<Id, Set<String>>();
        
        //Replacing Territory with Territory2  as a part of removing TM1.0 references
        //for(Territory oTerritory : queryTerritories()) {
        for(Territory2 oTerritory : queryTerritories()) {
            TerritoryNode oTerritoryNode = new TerritoryNode();
            oTerritoryNode.Territory2 = oTerritory;
            oTerritoryNode.isDirector = isDirector(oTerritory.TMS_Rep_Function_Desc__c);
            oTerritoryNode.isManager = isManager(oTerritory.TMS_Rep_Function_Desc__c);
            
            //Set Territory Groups
            if (mapTerritoryGroups.containsKey(oTerritory.Id)) {
                List<Group> listGroups = mapTerritoryGroups.get(oTerritory.Id);
                for (Group oGroup : listGroups) {
                    if (oGroup.Type == 'Territory') {
                        oTerritoryNode.territoryGroupId = oGroup.Id;
                    }
                    else if (oGroup.Type == 'TerritoryAndSubordinates') {
                        oTerritoryNode.territoryAndSubordinatesGroupId = oGroup.Id;
                    }
                }
            }
            
            //Set Territory Users
            if (mapTerritoryUserTerritories.containsKey(oTerritory.Id)) {
                //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
                //List<UserTerritory> listUserTerritories = mapTerritoryUserTerritories.get(oTerritory.Id);
                List<UserTerritory2Association> listUserTerritories = mapTerritoryUserTerritories.get(oTerritory.Id);
                //for (UserTerritory oUserTerritory : listUserTerritories) {
                for (UserTerritory2Association oUserTerritory : listUserTerritories) {  
                    TerritoryMember oTerritoryMember = new TerritoryMember();
                    //oTerritoryMember.UserTerritory = oUserTerritory;
                    oTerritoryMember.UserTerritory2Association = oUserTerritory;
                    oTerritoryMember.user = mapUsers.get(oUserTerritory.UserId);
                    
                    oTerritoryNode.members.add(oTerritoryMember);
                }
            }
            
            //Map Parent Territory
            if (oTerritory.ParentTerritory2Id != null) {
                if (mapParentTerritoryIndex.containsKey(oTerritory.ParentTerritory2Id)) {
                    mapParentTerritoryIndex.get(oTerritory.ParentTerritory2Id).add(oTerritory.Id);
                    mapParentTerritoryNumberString.get(oTerritory.ParentTerritory2Id).add(oTerritory.TMS_Terr_Num__c);
                }
                else {
                    mapParentTerritoryIndex.put(oTerritory.ParentTerritory2Id, new Set<Id>{ oTerritory.Id });
                    mapParentTerritoryNumberString.put(oTerritory.ParentTerritory2Id, new Set<String>{ oTerritory.TMS_Terr_Num__c });
                }
            }
            
            //Map Territory Node
            mapTerritoryNodes.put(oTerritory.Id, oTerritoryNode);
        }
    }
    
    /**
     * Queries the database for User records
     *
     * @return a list of User objects
     */
    /*private List<User> queryUsers() {
      List<User> listUser;
      if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable()){
        listUser = [SELECT Id,Name,Email FROM User WHERE IsPortalEnabled = false];
      }
        return listUser;
    }*/
    
      //INC3812267//FSC-146
    private List<User> queryUsers(Set<String> useridset) {
      List<User> listUser;
      if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable()){
        listUser = [SELECT 
                    Id
                    , Name
                    , Email
                FROM 
                    User 
                    where IsPortalEnabled = false and Id IN : useridset];
      }
        return listUser;
    }
    
    /**
     * Queries the database for Group records
     *
     * @return a list of Group objects
     */
    private List<Group> queryGroups() {
      List<Group> listGroup;
      if(Schema.sObjectType.Group.isAccessible() && Schema.sObjectType.Group.isQueryable()){
        listGroup = [SELECT 
                    Id
                    , Type 
                    , RelatedId
                FROM 
                    Group 
                WHERE 
                    Type IN ('Territory', 'TerritoryAndSubordinates') 
                ORDER BY 
                    RelatedId];
      }
        return listGroup;
    }
    
    /**
     * Queries the database for Territory records
     *
     * @return a list of Territory objects
     */
    //Replacing Territory with Territory2  as a part of removing TM1.0 references
    //private List<Territory> queryTerritories() {
    private List<Territory2> queryTerritories() {
      List<Territory2> listTerritory;
        if(Schema.sObjectType.Territory2.isAccessible() && Schema.sObjectType.Territory2.isQueryable()){
          listTerritory =  [SELECT 
                    Id
                    , Name 
                    , ParentTerritory2Id
                    , TMS_Market_Segment_Desc__c
                    , TMS_Market_Segment_ID__c
                    , TMS_Parent_Territory_ID__c
                    , TMS_Rep_Function_Desc__c
                    , TMS_Rep_Function_ID__c
                    , TMS_Sales_Force_Desc__c
                    , TMS_Sales_Force_ID__c
                    , TMS_Terr_Num__c
                    , TMS_Territory_ID__c
                FROM 
                    Territory2
                ORDER BY
                    ParentTerritory2Id];
        }
        return listTerritory;
    }
    
    /**
     * Queries the database for active UserTerritory records
     *
     * @return a list of UserTerritory objects
     */
    //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
    //private List<UserTerritory> queryActiveUserTerritory() {
    private List<UserTerritory2Association> queryActiveUserTerritory() {    
      //List<UserTerritory> listUserTerritory;
      useridset = new Set<String>();//INC3812267
      List<UserTerritory2Association> listUserTerritory;
      //if(Schema.sObjectType.UserTerritory.isAccessible() && Schema.sObjectType.UserTerritory.isQueryable()){
      if(Schema.sObjectType.UserTerritory2Association.isAccessible() && Schema.sObjectType.UserTerritory2Association.isQueryable()){
      
        listUserTerritory = [SELECT 
                    Id
                    , Territory2Id
                    , UserId 
                FROM 
                    UserTerritory2Association 
                WHERE 
                    IsActive=true];  
      }
      
      //INC3812267//FSC-146
      for(UserTerritory2Association useridrec : listUserTerritory){ 
      useridset.add(useridrec.UserId);
      
      } 
      
      this.mapUsers = new Map<Id, User>(queryUsers(useridset));
        return listUserTerritory;
    }
    //Replacing Territory with Territory2 as a part of removing TM1.0 references
    //private List<Territory> queryTerritoriesByUserId(Id userId) {/
    private List<Territory2> queryTerritoriesByUserId(Id userId) {
        List<Territory2> listTerritory;
        //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
        //if(Schema.sObjectType.Territory.isAccessible() && Schema.sObjectType.Territory.isQueryable() && Schema.sObjectType.UserTerritory.isAccessible() && Schema.sObjectType.UserTerritory.isQueryable()){
        if(Schema.sObjectType.Territory2.isAccessible() && Schema.sObjectType.Territory2.isQueryable() 
          && Schema.sObjectType.UserTerritory2Association.isAccessible() && Schema.sObjectType.UserTerritory2Association.isQueryable()){
          listTerritory = [SELECT 
                      Id 
                      , Name
                      , ParentTerritory2Id
                      , TMS_Market_Segment_Desc__c
                      , TMS_Market_Segment_ID__c
                      , TMS_Parent_Territory_ID__c
                      , TMS_Rep_Function_Desc__c
                      , TMS_Rep_Function_ID__c
                      , TMS_Sales_Force_Desc__c
                      , TMS_Sales_Force_ID__c
                      , TMS_Terr_Num__c
                      , TMS_Territory_ID__c
                  FROM 
                      Territory2 
                  WHERE 
                      Id IN (SELECT Territory2Id FROM UserTerritory2Association WHERE UserId = :userId)];  
          }
          
          return listTerritory;
    }
    
    /**
     * Retrieves the ACTIVE Team TMS territory numbers by identifying the manager 
     * related to the specified user id and then retrieving all TMS territory
     * numbers related to that manager territory
     * Defect 3498
     *
     * @param   userId  a User object id
     * @return  a set of TMS territory numbers
     */ 
    public Set<string> getActiveTeamTMSTerritoryNumbersByUserId(Id userId) {
        Set<string> setTerritoryNumbers = new Set<string>();
        Set<Id> setParentTerritory2Ids = new Set<Id>();
        Set<Id> setUserTerritory2Ids = new Set<Id>();
        //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
        //Replacing Territory with Territory2 as a part of removing TM1.0 references
        //Locate Manager Territory
        for (Territory2 oTerritory : [SELECT 
                    Id 
                    , Name
                    , ParentTerritory2Id
                    , TMS_Market_Segment_Desc__c
                    , TMS_Market_Segment_ID__c
                    , TMS_Parent_Territory_ID__c
                    , TMS_Rep_Function_Desc__c
                    , TMS_Rep_Function_ID__c
                    , TMS_Sales_Force_Desc__c
                    , TMS_Sales_Force_ID__c
                    , TMS_Terr_Num__c
                    , TMS_Territory_ID__c
                FROM 
                    Territory2 
                WHERE 
                    Id IN (SELECT Territory2Id FROM UserTerritory2Association 
                    WHERE UserId = :userId and IsActive = true)]) {
            if (AppUtil.isEmpty(oTerritory.TMS_Terr_Num__c) == false) {
                Territory2 oParentTerritory = getParentTerritory(oTerritory.Id);
               //MCL-2189 Changes Starts
                Territory2 oGrandParentTerritory;
               
               if(oParentTerritory != null){
                oGrandParentTerritory = getParentTerritory(oParentTerritory.Id);   
               } 

                if (oTerritory.ParentTerritory2Id != null) {
                    setParentTerritory2Ids.add(oTerritory.ParentTerritory2Id);
                }

                if(oGrandParentTerritory == null) {
                    if (oParentTerritory != null && !mapParentTerritoryNumberString.isEmpty() && mapParentTerritoryNumberString.containsKey(oParentTerritory.Id)){
                        setTerritoryNumbers.addAll(mapParentTerritoryNumberString.get(oParentTerritory.Id));
                    }
                }
                else {
                    
                    if(!mapParentTerritoryNumberString.isEmpty() && mapParentTerritoryNumberString.containsKey(oGrandParentTerritory.Id)){
                        setTerritoryNumbers.addAll(mapParentTerritoryNumberString.get(oGrandParentTerritory.Id));
                    }
                    setParentTerritory2Ids.add(oGrandParentTerritory.Id);
                }
                
                if (oParentTerritory == null) {
                    if(!mapParentTerritoryNumberString.isEmpty() && mapParentTerritoryNumberString.containsKey(oTerritory.Id)){
                        setTerritoryNumbers.addAll(mapParentTerritoryNumberString.get(oTerritory.Id));
                    }
                }
                else if (isDirector(oParentTerritory.TMS_Rep_Function_Desc__c) || isManager(oParentTerritory.TMS_Rep_Function_Desc__c)) {
                        if(!mapParentTerritoryNumberString.isEmpty() && mapParentTerritoryNumberString.containsKey(oParentTerritory.Id)){
                            setTerritoryNumbers.addAll(mapParentTerritoryNumberString.get(oParentTerritory.Id));
                        }
                    setParentTerritory2Ids.add(oParentTerritory.Id);
                }
            }
        }
        
        //MCL-2189 Changes End
        //Replacing Territory with Territory2 as a part of removing TM1.0 references
        for (Territory2 oTerritory : [SELECT 
                    Id 
                    , Name
                    , ParentTerritory2Id
                    , TMS_Market_Segment_Desc__c
                    , TMS_Market_Segment_ID__c
                    , TMS_Parent_Territory_ID__c
                    , TMS_Rep_Function_Desc__c
                    , TMS_Rep_Function_ID__c
                    , TMS_Sales_Force_Desc__c
                    , TMS_Sales_Force_ID__c
                    , TMS_Terr_Num__c
                    , TMS_Territory_ID__c
                FROM 
                    Territory2 
                WHERE 
                    ParentTerritory2Id IN :setParentTerritory2Ids ]) {
                        
            if (AppUtil.isEmpty(oTerritory.TMS_Terr_Num__c) == false) {
                Territory2 oParentTerritory = getParentTerritory(oTerritory.Id);
                
                if(mapParentTerritoryNumberString.containsKey(oTerritory.Id)) {
                    setTerritoryNumbers.addAll(mapParentTerritoryNumberString.get(oTerritory.Id));
                }
                if(oParentTerritory != null) {
                    if (isDirector(oParentTerritory.TMS_Rep_Function_Desc__c) || isManager(oParentTerritory.TMS_Rep_Function_Desc__c)) {
                        setTerritoryNumbers.addAll(mapParentTerritoryNumberString.get(oParentTerritory.Id));
                    }
                }
            }
        }

        return setTerritoryNumbers;
    }
/*
    public Set<string> getActiveTeamTMSTerritoryNumbersByUserId(Id userId) {
        Set<string> setTerritoryNumbers = new Set<string>();
        
        //Get User Territory Ids
        Set<Id> setUserTerritory2Ids = new Set<Id>();
        //Locate Manager Territory
        List<TerritoryNode> listManagerTerritoryNodes = new List<TerritoryNode>();
        for (Territory oTerritory : queryActiveTerritoriesByUserId(userId)) {
            if (AppUtil.isEmpty(oTerritory.TMS_Terr_Num__c) == false) {
                TerritoryNode oParentTerritoryNode = getParentTerritoryNode(oTerritory.Id);
                
                if (oParentTerritoryNode == null) {
                    setTerritoryNumbers.addAll(getTMSTerritoryNumbers(getTerritoryNode(oTerritory.Id)));
                }
                else if (oParentTerritoryNode.IsDirector || oParentTerritoryNode.IsManager) {
                    setTerritoryNumbers.addAll(getTMSTerritoryNumbers(getTerritoryNode(oParentTerritoryNode.Territory.Id)));
                }
                setUserTerritory2Ids.add(oTerritory.Id);
            }
        }

        //Get TMS Territory Numbers
        for (TerritoryNode oTerritoryNode : listManagerTerritoryNodes) {
            setTerritoryNumbers.addAll(getTMSTerritoryNumbers(oTerritoryNode));
        }
        
        return setTerritoryNumbers;
    }
*/  
    /**
     * Retrieves the ACTIVE TMS territory numbers for the specified user id 
     * Defect 3498
     *
     * @param   userId  a User object id
     * @return  a set of TMS territory numbers
     */ 
    public Set<string> getActiveTMSTerritoryNumbersByUserId(Id userId) {
        List<string> listTerritoryNumbers = new List<string>();
        
        //Replacing Territory with Territory2 as a part of removing TM1.0 references
        for (Territory2 oTerritory : queryActiveTerritoriesByUserId(userId)) {
            if (AppUtil.isEmpty(oTerritory.TMS_Terr_Num__c) == false) {
                listTerritoryNumbers.add(oTerritory.TMS_Terr_Num__c);
            }
        }
        listTerritoryNumbers.sort();
        
        return new Set<string>(listTerritoryNumbers);
    }
    
    //Replacing Territory with Territory2 as a part of removing TM1.0 references
    private List<Territory2> queryActiveTerritoriesByUserId(Id userId) {
        List<Territory2> listTerritory;
        //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
        if(Schema.sObjectType.Territory2.isAccessible() && Schema.sObjectType.Territory2.isQueryable() 
          && Schema.sObjectType.UserTerritory2Association.isAccessible() && Schema.sObjectType.UserTerritory2Association.isQueryable()){
          listTerritory = [SELECT 
                    Id 
                    , Name
                    , ParentTerritory2Id
                    , TMS_Market_Segment_Desc__c
                    , TMS_Market_Segment_ID__c
                    , TMS_Parent_Territory_ID__c
                    , TMS_Rep_Function_Desc__c
                    , TMS_Rep_Function_ID__c
                    , TMS_Sales_Force_Desc__c
                    , TMS_Sales_Force_ID__c
                    , TMS_Terr_Num__c
                    , TMS_Territory_ID__c
                FROM 
                    Territory2 
                WHERE 
                    Id IN (SELECT Territory2Id FROM UserTerritory2Association 
                    WHERE UserId = :userId and IsActive = true)];
        }
        return  listTerritory;
    }

    //Internal Classes
    
    /**
     * Datastructure representing a Territory with key related information
     */
    public class TerritoryNode {
        //Properties
        //Replacing Territory with Territory2 as a part of removing TM1.0 references
        public Territory2 territory2 {get;set;}
        public boolean isDirector {get;set;}
        public boolean isManager {get;set;}
        public Id territoryGroupId {get;set;}
        public Id territoryAndSubordinatesGroupId {get;set;}
        public List<TerritoryMember> members {get;set;}
        public List<TerritoryNode> children {get;set;}
        
        //Constructors
        public TerritoryNode() {
            this.isDirector = false;
            this.isManager = false;
            this.members = new List<TerritoryMember>();
            this.children = new List<TerritoryNode>();
        }
    }
    
    /**
     * Data structure representing a user member of a Territory
     */
    public class TerritoryMember {
        //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
        //public UserTerritory UserTerritory {get;set;}
        public UserTerritory2Association userTerritory2Association {get;set;}
        public User user {get;set;}
    }
}