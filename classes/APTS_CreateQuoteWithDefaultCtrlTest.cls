/*APTS_CreateAddressFromProposalCtrlTest


* History
* 14/2/2018,  Tejasree Tadi, APTTUS -  Rewritten APTS_CreateAddressFromProposalCtrlTest Class as a part of GLI OC

*/
    @isTest
    private class APTS_CreateQuoteWithDefaultCtrlTest {
      @testSetup static void allTheRequiredDataForThisClass(){
          
         Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
         insert priceList;

         
         //Creating WebServiceSetting
         WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease'); 
        
         //inserting KeyValuestore
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
           
          //Inserting RecordList   
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
        
         //Inserting Account Object
         Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        //Dynamic Retrieval of a recordType for SSd Object and Inserting SSd
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
        
        //Dynamic Retrieval of a recordType for opportunity Object and Inserting Opportunity 
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        //Inserting Proposal Object
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert proposal;
        
      }

      @isTest static void test_CreateQuoteWithDefaultSegment() {
         
         //Fetching Account Object and Proposal object
         Account a=[SELECT id,name from Account WHERE name='Test Account' ];
         Apttus_Proposal__Proposal__c p = [SELECT APTS_Approval_Segment__c, APTS_Approval_Segment_Default__c FROM Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' ];
 
         Test.startTest();
              //Referencing an apex Page
              PageReference pf = new PageReference('/apex/APTS_CreateQuoteWithApprovalSegment?acctId='+a.Id);
              Test.setCurrentPage(pf);
              APTS_CreateQuoteWithDefaultCtrl ctrl = new APTS_CreateQuoteWithDefaultCtrl();
              ctrl.doAction();
         Test.stopTest();

         System.assertEquals(p.APTS_Approval_Segment__c, p.APTS_Approval_Segment_Default__c);
      }
    
      @isTest static void test_DeleteQuoteFromDefaultSegment() {
        
         //Fetching Proposal Object details
         Apttus_Proposal__Proposal__c p=[SELECT id from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' ];
         //Referencing an apex Page 
         PageReference pf = new PageReference('/apex/APTS_CreateQuoteWithApprovalSegment?proposalId='+p.Id);
         Test.setCurrentPage(pf);

         Test.startTest();
             APTS_CreateQuoteWithDefaultCtrl ctrl = new APTS_CreateQuoteWithDefaultCtrl();
             ctrl.doAction();
         Test.stopTest();

         System.assertEquals(0, [SELECT Count() FROM Apttus_Proposal__Proposal__c]);
      }
   
    
    }