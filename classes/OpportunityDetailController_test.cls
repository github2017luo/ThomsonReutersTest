/*
======================================================================================================================
TEST CLASS NAME: OpportunityDetailController_test
======================================================================================================================
=
PURPOSE: Validates the functionality provided by the OpportunityDetailController class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/

@istest (SeeAllData=false) // As part of  s2e Optimisation project making seeAllData as false [Rajashree]
public class OpportunityDetailController_test{
    public static testMethod void testController(){
        UnitTest.createTestData();  //  As part of  s2e Optimisation project adding test data [Rajashree]   
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Account_Error_Counter__c=2;
        insert testAcc1; 
        Contact con1= new contact(lastname='test',AccountId=testAcc1.Id,Firstname='test',email='te@te.com');
        Insert con1;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        insert testOpty;
        
        test.starttest(); //MCL-1926
        Quote q1=new Quote();
        q1.Quote_Error_Counter__c=2;
        q1.OpportunityId= testOpty.Id;
        q1.name='testqo';
        Insert q1;
        
        List<OpportunityTeamMember> listSalesTeamMember1 = new List<OpportunityTeamMember>();
        
        
        Profile p = [SELECT Id FROM profile WHERE name='Partner Portal User'];   
        User u1 = new User(alias = 'newUser1', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user11@mydomain.com',contactId=con1.Id,LatAm_Department__c='Mastersaf - Canal');        
        insert u1;
        for(integer i=0;i<250;i++)
        {
        OpportunityTeamMember testMember= new OpportunityTeamMember(OpportunityId=testOpty.id,UserId=u1.id);
        listSalesTeamMember1.add(testMember);
        }
        insert listSalesTeamMember1;
        test.stoptest(); //MCL-1926
        
        OpportunityUtil oOpptyUtil = new OpportunityUtil();
        System.Runas(u1){
        ApexPages.standardController sc = new ApexPages.standardController(testOpty);
        Test.setCurrentPageReference(Page.OpportunityDetail);        
        OpportunityDetailController controller = new OpportunityDetailController(sc);
       
        //controller.recId.recTypeId__c = testOpty.RecordTypeId ;
        //controller.showMore();
        controller.goToList();
        controller.addSalesTeam();
        ApexPages.standardController sc3 = new ApexPages.standardController(testopty);
        Test.setCurrentPageReference(Page.OpportunityDetail);        
        OpportunityDetailController controller3 = new OpportunityDetailController(sc3);
        controller3.listSalesTeamMember= listSalesTeamMember1;
        controller3.delRowId=listSalesTeamMember1[0].id;
        controller3.deleteRow();
        controller3.deleteAllRow();     
        
        controller.InConsoleView  = true;
        controller.OnPageLoad(); 
        
        PageReference pageRef = Page.AddtoSalesTeam;
        pageRef.getParameters().put('Id',testOpty.Id);
        Test.setCurrentPage(pageRef);
        OpportunityDetailController controller2 = new OpportunityDetailController(sc);
        controller2.addToSalesTeam(); 
       
    }
        
    }
}