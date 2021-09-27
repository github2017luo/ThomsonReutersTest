@istest
public class ODT_LT_ExtendTest {
    static testmethod void checkuser(){
        Profile p = [SELECT Id FROM profile WHERE name='GLI Sales USer'];   
        UserRole userrole = [SELECT Id FROM UserRole WHERE Name = 'SLF'];
        user u=new User(email='abc.xyz2gmail.com', lastname='Test', UserRoleId = userrole.Id, profileid = p.Id, username='user343413@mydomain123.com');
        ODT_LT_Extend.UserProfileName();
    }
        

}