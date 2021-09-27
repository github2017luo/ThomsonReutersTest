/* APTS_SendMailToCVMTest
 * Test class for APTS_Send_Email_To_CVM page.
 *
 * Developer: Bibas Bose, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
   ***************************************************************************************************
   Modification Log:
   *
   *    Akshay Mewada, 10/16/2016 - Created.
   ***************************************************************************************************
   Modified by:Surya, APTTUS on-15/2/2018-  Rewritten APTS_SendMailToCVMTest Class as a part of GLI OC
*/
@isTest 
private class APTS_SendMailToCVMTest {    
     @testSetUp static void testAPTS_Send_Email_To_CVMWithProposal() {
        PageReference ref = Page.APTS_Send_Email_To_CVM;
        Test.setCurrentPage(ref);

             
        
        //Inserting pricelist 
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
     //Inserting Keyvaluestore  
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
      //Inserting recordtype
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
      //Inserting account
        Account a = APTS_TestDataFactory.createAccount('test-sg');
         a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        a.billingCity = 'Test billing city';
        a.billingState = 'Test billing state';
        a.billingPostalCode = 'PO 123456';
        insert a;
      //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Source_System_Name__c='ABC';
        insert accountSSD;

     //Inserting oppty  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        
        insert oppty;
     //Inserting proposal
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.Apttus_Proposal__Proposal_Name__c='TST-10'; 
        proposal.Apttus_Proposal__Approval_Stage__c='Draft'; 
        proposal.Apttus_Proposal__Proposal_Category__c='Quote'; 
        proposal.Apttus_Proposal__ReadyToGenerate__c = true; 
        proposal.Apttus_Proposal__ReadyToPresent__c= true;
        //proposal.Apttus_QPConfig__PriceListId__c=pl.id;
        proposal.Apttus_Proposal__Account__c = a.ID;
        proposal.APTS_CVM_Email_Address__c = 'test@test.com';
        proposal.APTS_CVM_Email_Sent__c =False;
        insert proposal;
        
        
          
        
    }
      
      @isTest static void testSendMailToCVM() {
      //Fetching Account,SSd,Opportunity,Proposal
        Account a=[SELECT id,name from Account WHERE name='test-sg' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc' LIMIT 1];
        Apttus_Proposal__Proposal__c p=[SELECT id from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='abc' LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('id', p.ID);        
        Test.startTest();
        APTS_SendMailToCVM  controller = new APTS_SendMailToCVM ();  
        controller.sendMail();
        Test.stopTest();
    }  
    
    
    @isTest static void testAPTS_Send_Email_To_CVMWithoutProposal() {
           
        PageReference ref = Page.APTS_Send_Email_To_CVM;
        Test.setCurrentPage(ref);       
        Test.startTest();
        APTS_SendMailToCVM  controller = new APTS_SendMailToCVM ();        
        
        controller.sendMail();
        Test.stopTest();
    }
}