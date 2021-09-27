/*
======================================================================================================================
TEST CLASS NAME: CreateProposal_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the CreateProposal class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2018-03-14            Priyanka                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest
Public with sharing class APTS_CloneExpiredQuoteTest{
public static testMethod void testCloneExpiredController(){
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
    
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='LMS');        
        insert u1;
        insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c='00e30000001ZUki');
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c='01230000001MA4h');
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c='01230000001MA4g');
      System.Runas(u1){  
    Account testAcc1 = UnitTest.getAccountInstance();
    insert testAcc1;
     Source_System_Detail__c ssd = new Source_System_Detail__c (name='testssd',Source_System_Name__c='test',LCRM_Sales_Org__c ='West',Account_Name__c=testAcc1.id);
    insert ssd;
    Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
    insert opp;
   opp.Source_System_Detail__c =ssd.Id;
   update opp;
    Business_Partner_Function__c bp = new Business_Partner_Function__c(Related_Account__c=testAcc1.id,Sold_To_Account_GLI__c=ssd.id,Relationship_Type__c  ='Payer');
    insert bp;
    Apttus_Proposal__Proposal__c  proposal = new Apttus_Proposal__Proposal__c (Apttus_Proposal__Account__c=testAcc1.id,Apttus_Proposal__Opportunity__c=opp.id,APTS_SSD_Sold_To__c =ssd.id);
    insert proposal;
      KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='ApttusProposalRecordtypeId';
        keyvaluestore1.TextValue__c='01213000000AXKM';
        insert keyvaluestore1;
    Test.StartTest();
    PageReference pageRef = Page.APTS_CloneExpiredQuote;
    
    pageRef.getParameters().put('id', String.valueOf(proposal.Id));
    system.Test.setCurrentPage(pageRef);
      ApexPages.StandardController sc = new ApexPages.StandardController(proposal);
    APTS_CloneExpiredQuote expquote = new APTS_CloneExpiredQuote(sc);
    
    Pagereference pg = expquote.redirect();
    
  
    Test.StopTest();
    }
     }
     
     }