@isTest
private class APTS_OrderAssetCreateQJobTest {
  static testMethod void test_CreateOrderAssetCreate() {
        PriceBook2 pb = new PriceBook2(name='Standard Price Book', isActive=true);
        insert pb;   
        
         Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
       

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
      
       
       
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.forecastcategoryname='Omitted';
        oppty.Pricebook2Id=pb.Id;
        insert oppty;
       
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert proposal;
       
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
       p.RecordTypeId=devRecordTypeId;
       p.CurrencyIsoCode='USD';
       p.Apttus_Proposal__Approval_Stage__c='Presented';
       p.Apttus_Proposal__Proposal_Category__c='Quote';
       p.Apttus_Proposal__ReadyToGenerate__c = true;
       p.Apttus_Proposal__ReadyToPresent__c= true;
       System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);
       insert p;
       
       Test.startTest();
       Set<Id> proposalIds = new Set<Id>();
       proposalIds.add(p.id);
       System.enqueueJob(new APTS_OrderAssetCreateQJob(proposalIds));
       Test.stopTest();
         

       
  }
}