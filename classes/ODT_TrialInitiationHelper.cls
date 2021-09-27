/*============================================================================================
Name        :   ODT_TrialInitiationHelper
Description :   This class is developed as part of CXD-ODT: DLT-16849.
                This class serves as a Helper Class for initiating new trials.

Modification History:
Date            Name                    Description
06/20/2019      David H.                DLT-16849: Created.
==============================================================================================*/

public without sharing class ODT_TrialInitiationHelper {
    public static Set<String> permissionNameSet = new Set<String>{
        'ODT_Sales_Rep_Permissions',
        'ODT_Trial_Manager_Permissions'
    };
        
    public static List<ODT_User_Roles__mdt> userRoleList = [ SELECT User_Role_Name__c FROM ODT_User_Roles__mdt ];
    
    public static List<ODT_Market_Segments__mdt> marketSegmentsList = [
        SELECT Id, Market_Segment__c, Business_Type__c 
        FROM ODT_Market_Segments__mdt ORDER BY Market_Segment__c ASC
    ];
    
    public static List<ODT_Product_Bundle__c> productBundleList = [
        SELECT Id, Name, Bundle_ID__c, Bundle_Order__c, Bundle_Type__c, Business_Type__c, Contacts_User_Type__c
        FROM ODT_Product_Bundle__c
    ];
    
    
    /** 
     *  Checks if user has valid role as defined in 'ODT_User_Roles__mdt'.
     */
    public static Boolean isValidUserRole(User user) {
        // check if 'ODT_User_Roles__mdt' contains user role names
        if(userRoleList.isEmpty()) {
            System.debug('>>>>> ODT_User_Roles__mdt isEmpty = true');
            return false;
        }
        
        // get user role id and name
        String myUserRoleId = user.UserRoleId;
        String myUserRoleName = [SELECT Name FROM UserRole WHERE Id = :myUserRoleId].Name;
        System.debug('myUserRoleId: ' + myUserRoleId + ', myUserRoleName: ' + myUserRoleName);
        
        // check if user's role is in 'ODT_User_Roles__mdt'
        for(ODT_User_Roles__mdt role : userRoleList) {
            String roleName = role.User_Role_Name__c;
            if(roleName.equals(myUserRoleName)) { return true; }
        }
        return false;
    }
    
    /**
     *  Check that user has a valid permission set.
     */
    public static Boolean hasValidUserPermissions(User user) {
        Id myUserId = user.Id;
        
        // get user permission set assignments
        List<PermissionSetAssignment> psaList = [
            SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :myUserId
        ];
        System.debug('PermissionSetAssignmentList:' + psaList);
        
        // check if permission set assignment is valid for ODT.
        for(PermissionSetAssignment psa : psaList) {
            String psName = psa.PermissionSet.Name;
            if(permissionNameSet.contains(psName)) { return true; }
        }
        return false;
    }
    
    // getter for ODT_Market_Segments__mdt
    public static List<ODT_Market_Segments__mdt> getMarketSegmentsList() { return marketSegmentsList; }
    
    // getter for ODT_User_Roles__mdt
    public static List<ODT_User_Roles__mdt> getUserRoleList() { return userRoleList; }
    
    // getter for ODT_Product_Bundle__c
    public static List<ODT_Product_Bundle__c> getProductBundleList() { return productBundleList; }
    
    // getter for ODT_Product_Bundle__c by Contacts_User_Type__c, Is_Active__c, Is_Enabled_For_Sales_Rep_Trial__c 
    public static List<ODT_Product_Bundle__c> getProductBundleList(String contactType, Boolean active, Boolean enabled) {
        return [
            SELECT Id, Name, Bundle_ID__c, Bundle_Order__c, Bundle_Type__c, Business_Type__c, Contacts_User_Type__c
            FROM ODT_Product_Bundle__c
            WHERE Is_Active__c =: active
            AND Is_Enabled_For_Sales_Rep_Trial__c =: enabled
            AND Contacts_User_Type__c =: contactType
        ];
    }

}