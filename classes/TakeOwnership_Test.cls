@isTest(seealldata=true)

public with sharing class TakeOwnership_Test
{
    public static testMethod void testTakeOwnership()
    {
            Account testAcc1 = UnitTest.getAccountInstance();
            insert testAcc1;
            
            opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
            insert testOpty;
            
            Training_Event__c testTrainingEvent = new Training_Event__c(Training_Name__c='test');
            insert testTrainingEvent;
            
            Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
            User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com');        
            insert u1;
            
            
            TakeOwnership.addOpportunityOwner(testOpty.id,u1.id);
            
            TakeOwnership.addTrainingEventOwner(testTrainingEvent.id,u1.id);
    
    
    }
    
     private static testMethod void testCallAddToSalesTeam() 
        {    
           
           user u = new user();
           u = [select id from user where id !=:userinfo.getuserid() and isActive=true limit 1];
           
           Account oAccount = UnitTest.getAccountInstance();
           insert oAccount;
           
           Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
           
           insert oOpportunity;
           oOpportunity = [Select Id,OwnerId from Opportunity where Id =:oOpportunity.Id];
           TakeOwnership.AddToSalesTeam(oOpportunity.Id,u.Id);
           
           Test.StartTest();                                     
           for(Opportunityteammember oteamMember : [Select UserId,OpportunityId from Opportunityteammember
                                                where OpportunityId =: oOpportunity.Id]){
               if(oteamMember.UserId != oOpportunity.OwnerId){                                                
                   System.assertEquals(oteamMember.UserId,u.Id,'Error');        
               }

           }                                        
        
           Test.stopTest();
        } 
}