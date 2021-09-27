/***********************************************
    Name : UserUtilityClass
    Description : Has Utility Methods Related to user
    Author : Sumit Mishra
    Company : TCS
***********************************************/
public without sharing class ESC_UserUtilityClass {
    
    /***********************************************
    Name : getobjectVisibiltyMap
    Description : Will return a map of objects and their read access for logged in user
    return Type : void
    ***********************************************/
    public static  Map<string, Boolean> getobjectVisibiltyMap(){
        Map<string, Boolean> objectVisibiltyMap = new Map<string, Boolean>();
        string currentUserProfile = [select Name from profile where id = :userinfo.getProfileId()][0].name;
        
        currentUserProfile ='\'%'+currentUserProfile+'%\'';
        //string objectVisibilityQuery = 'SELECT PermissionsRead,SobjectType FROM ObjectPermissions WHERE (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.ID= \''+string.escapeSingleQuotes(userinfo.getUserId())+'\')) AND (PermissionsRead = true)';
        for(ObjectPermissions op: [SELECT PermissionsRead,SobjectType FROM ObjectPermissions WHERE (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.ID =: userinfo.getUserId())) AND (PermissionsRead = true)]){
            objectVisibiltyMap.put( op.SobjectType , op.PermissionsRead);
        }
        system.debug('objectVisibiltyMap= '+objectVisibiltyMap);
        return objectVisibiltyMap;
    }
    
    
    
    /***********************************************
    Name : getobjectCreateAccessMap
    Description : Will return a map of objects and their create access for logged in user
    return Type : void
    ***********************************************/
    public static  Map<string, Boolean> getobjectCreateAccessMap(){
        Map<string, Boolean> objectVisibiltyMap = new Map<string, Boolean>();
        string currentUserProfile = [select Name from profile where id = :userinfo.getProfileId()][0].name;
        
        currentUserProfile ='\'%'+currentUserProfile+'%\'';
        //string objectVisibilityQuery = 'SELECT PermissionsCreate ,SobjectType FROM ObjectPermissions WHERE (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.ID= \''+userinfo.getUserId()+'\')) AND (PermissionsCreate = true)';
        for(ObjectPermissions op: [SELECT PermissionsCreate ,SobjectType FROM ObjectPermissions WHERE (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.ID =: userinfo.getUserId())) AND (PermissionsCreate = true)]){
            objectVisibiltyMap.put( op.SobjectType , op.PermissionsCreate);
        }
       // system.debug('objectVisibiltyMap= '+objectVisibilityQuery);
        return objectVisibiltyMap;
    }
    
    /***********************************************
    Name : getobjectFieldAccessMap
    Description : Will return a map of objects and their isAccessible() access for logged in user
    return Type : void
    ***********************************************/
   public static Map<string,Boolean> getobjectFieldAccessMap(string selectedObj){
        system.debug('getInfoField called with' + selectedObj );
        Map<string,Boolean> apiFieldInfo =new Map<string,Boolean>();
       
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObj).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            string key= dfield.getLocalName();
            Boolean value = dfield.isAccessible();
            apiFieldInfo.put(key.toLowerCase(), value);
        
        }
      
        return apiFieldInfo;
}
    
    
}