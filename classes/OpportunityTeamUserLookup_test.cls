@istest
public class OpportunityTeamUserLookup_test {
      public static testMethod void testController(){
        UnitTest.createTestData(); 
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        opportunity testOpty1 = UnitTest.getOpportunityInstance(testAcc1.id);
        insert testOpty1;        
        Test.setCurrentPageReference(Page.OpportunityTeamUserLookup);        
        ApexPages.currentPage().getParameters().put('accountid',testAcc1.id); 
        ApexPages.currentPage().getParameters().put('opportunityid',testOpty1.id);
        OpportunityTeamUserLookup controller = new OpportunityTeamUserLookup();
        controller.search();        
        controller.bAcctTerritory = false;
        controller.search();  
        controller.getPageHeader();
        controller.searchstring='t';
        controller.search();
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
         User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8',firstname='test',lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
       insert u1;
       System.assertEquals(u1.email, 'user@mydomain.com');
        controller.searchstring='test';
        controller.LoggedInUser= false;
        controller.errorMessage='You are not authorized to perform this action';
        controller.search();
        if(!controller.TeamMemberResults.isempty()){
            controller.TeamMemberResults[0].isSelected=true;
        }
        controller.addSalesTeam();
        controller.getaccess();
        controller.bAcctTerritory = true;
        controller.search(); 
        controller.OnLoadUser();
      }  
}