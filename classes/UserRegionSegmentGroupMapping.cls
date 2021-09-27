/********************************************************************** 
Name: UserRegionSegmentGroupMapping
====================================================== 
Req:  Class will add and delete the user to LOTUS public groups depending upon user's BU Region and BU Segment value.
====================================================== 
Purpose: To add or delete the user to LOTUS public groups depending upon user's BU Region and BU Segment value.
====================================================== 
* CHANGE HISTORY
* =============================================================================
* Date         Name              Project          Description
* 2019-03-18   Miriam Ghosh      LCRM             Created
* =============================================================================
***********************************************************************/


public without sharing class UserRegionSegmentGroupMapping {
    //Public Group Name and Id mapping
    public static Map<String, ID> grpNameIdMap = new Map<String, ID>();
    //ID and custom metadata value mapping
    public static Map<ID, User_Region_Segment_Group_Mapping__mdt> userRegSegmdt;
     //custom metadata label and custom metadata group name mapping
    public static MAP<String, String> userRegSegmdtMap = new MAP<String, String>();
    
    public UserRegionSegmentGroupMapping()
    {
      system.debug('@@inside contructor');
      //Fetching all values from custom metadata
      userRegSegmdt = new Map<ID, User_Region_Segment_Group_Mapping__mdt>
            ([SELECT Id, Label, Bu_Region__c, BU_Segment__c, Public_Group__c FROM User_Region_Segment_Group_Mapping__mdt]);
        
        //Assigning label and group name to a new map    
        if(userRegSegmdt.size() > 0)
        {
            for(User_Region_Segment_Group_Mapping__mdt regseg: userRegSegmdt.values())
            {
                System.debug('@@printing regseg'+regseg);
                userRegSegmdtMap.put(regseg.Label, regseg.Public_Group__c);
            }
        }
        
        //fetching and assigning group name and id to a map for all the groups existed in custom metadata
        for(Group grp: [Select Id, Name from Group where Name in :userRegSegmdtMap.values()])
        {
            grpNameIdMap.put(grp.Name, grp.ID);
            System.debug('@@printing grpNameIdMap'+grpNameIdMap);
        }
    }
    //@future
    public static void UserRegSegGrpAssignment(Set<ID> userIds)
    {
        UserRegionSegmentGroupMapping segregassgn = new UserRegionSegmentGroupMapping();
       
        List<User> usr = [Select Id, Name,Sub_Bu__c,Segment__c from user Where Id IN :userIds]; //Fetching user
        System.debug('@@printing list of user'+usr);
        //String regsegVal = u.Sub_Bu__c + '&' + u.Segment__c;
        
        List<GroupMember> listGroupMember =new List<GroupMember>();//Group member instance
        
        List<LCRM_Exception_Log__c> exceptionListforInsert = new List<LCRM_Exception_Log__c>();
        
        if(usr.size() > 0)
        {       
            for(User user: usr)
            {
                //concatinating region & segment value of user to match records with custom metadata type label
                String regsegVal = user.Sub_Bu__c + ' & ' + user.Segment__c;
                System.debug('@@printing concatinated value'+regsegVal);
                
                //checking for region and segment value along with checking of whether custom metadata is holding same region & segment concatinated value as user is having 
                if(( (user.Sub_Bu__c=='Global' && user.Segment__c != 'Global') || 
                     (user.Sub_Bu__c!='Global' && user.Segment__c == 'Global')) && userRegSegmdtMap.keySet().contains(regsegVal))
                {
                    //Adding the user to a particular group depending upon stored region, segment v/s group mapping
                    system.debug('@@inside first if condition');
                    GroupMember GM = new GroupMember();
                    GM.GroupId = grpNameIdMap.get(userRegSegmdtMap.get(regsegVal));
                    GM.UserOrGroupId = user.Id;
                    listGroupMember.add(GM);
                    System.debug('@@printing listGroupMember'+listGroupMember);

                } 
                else if(user.Sub_Bu__c=='Global' && user.Segment__c == 'Global' )
                {
                    if(grpNameIdMap.size() > 0)
                    {
                        //performing job to add user to 8 corresponding groups
                        for(String grpName : grpNameIdMap.keySet())
                        {
                            //Adding the user to 8 corresponding groups depending upon stored region, segment v/s group mapping
                            system.debug('@@inside else if condition');
                            GroupMember GM = new GroupMember();
                            GM.GroupId = grpNameIdMap.get(grpName);
                            GM.UserOrGroupId = user.Id;
                            listGroupMember.add(GM);
                            System.debug('@@printing listGroupMember in else'+listGroupMember);
                        }
                    }   
                    
                }
            }
        }
        
        //adding all the group members
        if(!listGroupMember.isEmpty()) 
                {
                    System.debug('Group Member List is ' + listGroupMember);
                    //Database.insert(listGroupMember,false);
                    
                    Database.SaveResult[] results = Database.insert(listGroupMember,false);
                    for(Integer i=0;i<results.size();i++)
                    {
                        if(!results.get(i).isSuccess())
                        {
                            Database.Error error = results.get(i).getErrors().get(0);
                            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c(LCRM_Exception_Message__c= error.getMessage(), LCRM_Record_Ids__c= listGroupMember.get(i).Id, LCRM_Exception_Type__c = 'There are no group member to insert into group');
                            exceptionListforInsert .add(excepObj);
                            system.debug('Exception: '+ excepObj);
                        }
                    }
                    if(exceptionListforInsert.size() > 0){
                    insert exceptionListforInsert;
                    }
                    System.debug('@@printing listGroupMember inside insert'+listGroupMember);
                    //delete GMlst;
                }
        
        
    }
    
    //method to delete users from 8 newly created public groups
    public static void UserRegSegGrpDeletion(Set<ID> userIds)
    {
        UserRegionSegmentGroupMapping segregdel = new UserRegionSegmentGroupMapping();
        List<LCRM_Exception_Log__c> exceptionListforDel = new List<LCRM_Exception_Log__c>();
        
        List<GroupMember> GMem = new List<GroupMember>([select Id from GroupMember 
                                                        where UserOrGroupId in: userIds 
                                                        AND GroupId in : grpNameIdMap.values()]);
        if(GMem.size() > 0)
        {
            //Database.delete(GMem,false);
            
            Database.DeleteResult[] delResults = Database.delete(GMem,false);
            for(Integer i=0;i<delResults.size();i++)
            {
                if(!delResults.get(i).isSuccess())
                {
                    Database.Error error = delResults.get(i).getErrors().get(0);
                    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c(LCRM_Exception_Message__c= error.getMessage(), LCRM_Record_Ids__c= GMem.get(i).Id, LCRM_Exception_Type__c = 'There are no group member to delete from group');
                    exceptionListforDel .add(excepObj);
                    system.debug('Exception: '+ excepObj);
                }
             }
            if (exceptionListforDel.size() > 0){
            insert exceptionListforDel;
            }
            System.debug('@@printing GMem'+GMem);
        }
        
    }

}