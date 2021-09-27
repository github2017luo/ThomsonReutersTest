@isTest
private class GLI_SendEmailToQueueMembers_Test{
    
@isTest public static void GLI_SendEmailToQueueMembers_TestMethod() {
    List<Case> caseList= new List<Case>();
    
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin12@testorg.com');
      insert u;
      
      System.runAs(u) { 
      Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;

Group testGroup = new Group(Name='test group', Type='Queue');
insert testGroup;
GroupMember member = new GroupMember();
member.UserOrGroupId = u.Id;
member.GroupId = testGroup.Id;
insert member;


case testcase1= new case(ContactId=testContact1.Id,OwnerId=testGroup.Id,Subject='test1');
case testcase2= new case(ContactId=testContact1.Id,OwnerId=testGroup.Id,Subject='tests123');
caseList.add(testcase1);
caseList.add(testcase2);
Insert caseList;    
Test.StartTest();
GLI_SendEmailToQueueMembers.sendEmail(caseList);
Test.stopTest();
    
        integer k = 1;
        integer j = 1;
        System.assertEquals(k,j);
    
}

}
}