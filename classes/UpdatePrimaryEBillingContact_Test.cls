/*
======================================================================================================================
TEST CLASS NAME: UpdatePrimaryEBillingContact_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the UpdatePrimaryEBillingContact class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest

public class UpdatePrimaryEBillingContact_Test{
   public static testmethod void relatedSalesteammethod(){
     // Account testAcc = UnitTest.getAccountInstance();
     // insert testAcc;
      //Opportunity TestOpp = UnitTest.getOpportunityInstance(testAcc.Id);
       //insert TestOpp;
       
        Profile p = [SELECT Id FROM profile WHERE name='LatAm User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user@mydomain.com');        
        insert u1;
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        LatamGeneral__c lg= new LatamGeneral__c();
        lg.Name= 'Opp Stage 0';
        lg.Value__C = '0%';
        insert lg;
        
        try{
            Account testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            Contact testCon= UnitTest.getContactInstance(testAcc.id);            
            insert testCon;
            
            Opportunity TestOpp = UnitTest.getOpportunityInstance(testAcc.Id);
            TestOpp.Is_Master_Opportunity__c = true;
            insert TestOpp; 
            
            Opportunity TestOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            TestOpp1.Master_Opportunity__c = TestOpp.id;
            TestOpp1.Is_Master_Opportunity__c = false;
            insert TestOpp1;            
            
            Quote Q1 = New Quote ();
            Q1.OpportunityId = Testopp.id;
            Q1.Pricebook2Id = Test.getStandardPricebookId();
            Q1.Name = 'Test Quote';
            Q1.Status = 'draft';
            Q1.primary_Quote__c= true;
            Q1.Is_Master_Quote__c= true;
            insert Q1;
            
            
            OpportunityContactRole oConRole= new OpportunityContactRole(Role = 'E-Billing Contact',
                                            opportunityId=TestOpp.id,ContactId= testCon.Id);
            insert oConRole;
            
            OpportunityContactRole oConRole1= new OpportunityContactRole(Role = 'E-Billing Contact',
                                            opportunityId=TestOpp1.id,ContactId= testCon.Id);        
            insert oConRole1;
            
            OpportunityContactRole oConRole2= new OpportunityContactRole(Role = 'Boleto Contact',
                                            opportunityId=TestOpp.id,ContactId= testCon.Id);
            insert oConRole2;
            
            OpportunityContactRole oConRole3= new OpportunityContactRole(Role = 'Boleto Contact',
                                            opportunityId=TestOpp1.id,ContactId= testCon.Id);        
            insert oConRole3;
            
            system.runAs(u1){        
           
                ApexPages.standardController sc = new ApexPages.standardController(TestOpp);        
                //Test.setCurrentPageReference(Page.OpportunityRelatedListView);              
                UpdatePrimaryEBillingContact upCon= new UpdatePrimaryEBillingContact(sc);
                upCon.CheckNewEBillingContact();
        
            }
        }
        catch(DMLException dmlEx){
            System.debug('Test Class:: Exception occured' + dmlEx.getLineNumber());
            
        }
        
        
       
       /*OpportunityTeamMember testoppteammember = new OpportunityTeamMember(OpportunityId=TestOpp.Id,UserId=u1.Id);
       insert testoppteammember;
       
         ApexPages.standardController sc = new ApexPages.standardController(TestOpp);
        
         Test.setCurrentPageReference(Page.OpportunityRelatedListView);  
         
         OpportunityRelatedListView  testcntrller = new OpportunityRelatedListView(sc); 
         testcntrller.getGoToListSalesTeam();
         testcntrller.sortField ='id'; 
         testcntrller.doSort();*/
   }

}