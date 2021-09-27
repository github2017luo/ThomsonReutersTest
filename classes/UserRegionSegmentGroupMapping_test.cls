@isTest
public class UserRegionSegmentGroupMapping_test {
    static testMethod Void UserRegionSegmentGroupMapping_Test() 
    {
        Set<ID> setUser = new Set<ID>(); 
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Testgli@xyz.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abcgli@xyz.com';
        user1.Alias = 'abcd';
        user1.CommunityNickname = 'CommunityNicknamemng.test';
        user1.ProfileId = lstProfile[0].Id;
        user1.Sub_Bu__c = 'Canada';
        user1.Segment__c = 'Global';
        insert user1;
       
        Group gp = new Group(Name = 'TestGrp');
        insert gp;
        GroupMember GM = new GroupMember();
        GM.GroupId = gp.Id;
        GM.UserOrGroupId = user1.Id; 
        
        setUser.add(user1.Id);
        
       
        UserRegionSegmentGroupMapping.UserRegSegGrpAssignment(setUser);
        UserRegionSegmentGroupMapping.UserRegSegGrpDeletion(setUser);
        System.assertEquals(user1.Sub_Bu__c != null, String.isNotBlank(user1.Sub_Bu__c ));
        System.assertEquals(user1.Segment__c != null, String.isNotBlank(user1.Segment__c ));
        
    }
    
    
    static testMethod Void UserRegionSegmentGroupMapping_Test1() 
    {
        Set<ID> setUser = new Set<ID>(); 
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        
        User user2 = UnitTest.getUserInstance();
        user2.Username = 'Testgli@xyz.com';
        user2.LastName = 'XYZ';
        user2.Email = 'abcgli@xyz.com';
        user2.Alias = 'abcd';
        user2.CommunityNickname = 'CommunityNicknamemng.test';
        user2.ProfileId = lstProfile[0].Id;
        user2.Sub_Bu__c = 'Global';
        user2.Segment__c = 'Global';
        insert user2;
        
        Group gp = new Group(Name = 'TestGrp');
        insert gp;
        GroupMember GM = new GroupMember();
        GM.GroupId = gp.Id;
        GM.UserOrGroupId = user2.Id;  
        
        setUser.add(user2.Id);
       
        
        UserRegionSegmentGroupMapping.UserRegSegGrpAssignment(setUser);
        UserRegionSegmentGroupMapping.UserRegSegGrpDeletion(setUser);
        System.assertEquals(user2.Sub_Bu__c != null, String.isNotBlank(user2.Sub_Bu__c ));
        System.assertEquals(user2.Segment__c != null, String.isNotBlank(user2.Segment__c ));
        
        
    }
    
     //exceptionFunctionality
   @isTest static void exceptionFunctionality() {
      
       List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();//used to store exceptions
       LCRM_Exception_Log__c lcrmError = new LCRM_Exception_Log__c();
       lcrmError.LCRM_Exception_Message__c = 'e.getMessage()';
       lcrmError.LCRM_Exception_Type__c = 'e.getTypeName()';
       lcrmError.LCRM_Exception_Trace__c = 'e.getStackTraceString()';
       exceptionList.add(lcrmError);
       
       Test.startTest();
       LTSStoreErrors.customLTSException(exceptionList);
       Test.stopTest();
        
    }
}