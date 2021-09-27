@isTest
public class QuoteWithOptySyncWSTest {
	testMethod static void testOptyQuoteSync() {
        
    List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
       
       KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
       keyvaluestore.Name='ANZUsersProfileId';
       keyvaluestore.TextValue__c='00e30000001ZUki';
       insert keyvaluestore;
       
       
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
  
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
       Account testAccount = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       insert testAccount;
       
       Source_system_detail__c testSource = new Source_system_detail__c (Account_Name__c = testAccount.id,Name=testAccount.name,Source_System_Name__c=testAccount.name,LCRM_Sales_Org__c='West');
       insert testSource;
       
       Pricebook2 gliPriceBook = new Pricebook2(Name='GLI Pricebook', isActive=true);
       insert gliPriceBook;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity testOpportunity = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs analysis',closedate=todaysDate,pricebook2Id=gliPriceBook.id,forecastcategoryname='pipeline',accountId=testAccount.id,Source_System_Detail__c=testSource.id);
       insert testOpportunity;
        
        Opportunity testOpportunity1 = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs analysis',closedate=todaysDate,pricebook2Id=gliPriceBook.id,forecastcategoryname='pipeline',accountId=testAccount.id,Source_System_Detail__c=testSource.id);
       insert testOpportunity1;
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', CurrencyIsoCode='USD', Apttus_Proposal__Opportunity__c=testOpportunity.id,Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=testSource.id);
       proposalList.add(testProposal1);
       
       Apttus_Proposal__Proposal__c testProposal2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c=false, Apttus_Proposal__Proposal_Name__c='TST-11', CurrencyIsoCode='USD', Apttus_Proposal__Opportunity__c=testOpportunity1.id,Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=testSource.id);
       proposalList.add(testProposal2);
       insert proposalList;
       
       Apttus_Proposal__Proposal__c insertedProposal=[select id,Apttus_Proposal__Primary__c from Apttus_Proposal__Proposal__c where id=:testProposal2.id];
       system.debug('insertedProposal is'+insertedProposal);
       Apttus_Proposal__Proposal_Line_Item__c testProposalLineItem1= new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=testProposal1.id);
       insert testProposalLineItem1;
       
       Apttus_Proposal__Proposal_Line_Item__c testProposalLineItem2= new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c=testProposal2.id);
       insert testProposalLineItem2;
       
       test.startTest();
       
         testProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
         update testProposal2;
         list<ID> testList = new List<Id>();
         testList.add(testProposal2.id);
        String quoteIdStr = testProposal1.Id + ';' + testProposal2.Id;
       QuoteWithOptySyncWS.syncQuoteWithOpty(quoteIdStr);
  }
}