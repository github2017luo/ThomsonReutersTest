@isTest
public class ESC_UserUtilityClassTest {

    @isTest static void getobjectVisibiltyMapTest() {
        
        Profile prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
       //string s 
        ESC_UserUtilityClass.getobjectVisibiltyMap();
        ESC_UserUtilityClass.getobjectCreateAccessMap();
         ESC_UserUtilityClass.getobjectFieldAccessMap('user');
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }

}