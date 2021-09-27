@isTest(seeAllData=TRUE)
public class OpptyStageChangeRestricted_Test
{
 //   Public static Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
    public static testMethod void TestOpptyStage()
    {
        Profile pList = [Select Id from Profile where name='LatAm User' ];
        User TestUser = new User(alias = 'newUser1', email='user1@mydomain.com', emailencodingkey='UTF-8', lastname='Testing',
                                 languagelocalekey='en_US', localesidkey='en_US',profileid = pList.Id, employeenumber='0143564',
                                  timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'LRA');
        
        Insert TestUser;
        
        Account testAcc = unitTest.getAccountInstance();        
        testAcc.OwnerId = TestUser.Id;
        testAcc.Sales_Org__c = 'LRA'; //Changing Sales_Org__c
        insert testAcc;
         system.assertequals('LRA',testAcc.Sales_Org__c);
         
        Contact testContact = unitTest.getContactInstance(testAcc.id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
                
        Id OpptyRecordTypeId = [Select Id From RecordType Where sObjectType = 'Opportunity'and Name = 'Pre-Pipeline Opportunity'].Id;
        
        list<Opportunity> TestListOppty = new list<Opportunity>();
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.id);
        testOpp1.name = 'Test1';
        testOpp1.StageName = '50%';
        testOpp1.Status__c = 'Contacting';
        testOpp1.CloseDate = system.Today();
        testOpp1.ForecastCategoryName = 'Closed';
        
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.id);
        testOpp2.name = 'Test2';
        testOpp2.StageName = '75%';
        testOpp2.Status__c = 'Contacting';
        testOpp2.CloseDate = system.Today();
        testOpp2.ForecastCategoryName = 'Closed'; 
        
         TestListOppty.add(testOpp1);
         TestListOppty.add(testOpp2);                  
        
        Test.StartTest();
        System.RunAs(TestUser)
        {
            System.assertEquals('LRA', testAcc.Sales_Org__c);
              insert testOpp1;
     //       insert testOpp2;
               
            Quote Q1 = New Quote ();
            Q1.OpportunityId = testOpp1.id;
            Q1.Pricebook2Id = Test.getStandardPricebookId();
            Q1.Name = 'Test Quote';
            Q1.Pricing_Approval_Required__c = TRUE;
            insert Q1;
            try{
            
               testOpp1.StageName = '90%'; 
               Update testOpp1;
            }catch(Exception e){}
            
            
         
        }
  
       Test.StopTest(); 
        
    }

}