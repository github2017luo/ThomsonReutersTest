@isTest
public class addlClausesTest {
    @isTest
  static void setup(){ 
       
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        System.assertequals('test',a.Name,'Success');
        
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        
        KeyValueListStore__c keyval1 = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        keyvaluestoreList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
         List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
       // Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
         
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'New',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
        
       Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
       proposal.Apttus_Proposal__Account__c=a.id;
       proposal.APTS_SSD_Sold_To__c=accountSSD.id;
       proposal.Apttus_Proposal__Opportunity__c = opp.id;
       proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
       proposal.APTS_Existing_Database__c=true;
       proposal.APTS_Client_Database_Code__c='12345';
       proposal.Apttus_Proposal__Approval_Stage__c='Presented';
       proposal.Apttus_Proposal__Primary__c=false;
      proposal.APTS_Add_l_Clauses__c='abc111;';

        insert proposal;
      
      Final String repRecordtypeId = Schema.SObjectType.APTS_Additional_Clauses__c.getRecordTypeInfosByName().get('Representative Clause').getRecordTypeId();
          
      APTS_Additional_Clauses__c ac = new APTS_Additional_Clauses__c(APTS_Clause_Title__c='abc111',APTS_isActive__c=true,recordtypeId=repRecordtypeId);
    insert ac;
  }
  @isTest   
  Public static void test1()
  {   setup();
    
     Test.startTest();  
     Account a = [Select Id from Account where Name = 'test'];
     Opportunity opp = [Select Id from Opportunity where Name = 'abc'];
     Apttus_Proposal__Proposal__c prop = [Select Id from Apttus_Proposal__Proposal__c where APTS_Proposal_Business_Unit__c = 'Corp OneOTC US'];
     List<Id> srecId = new List<Id>();
     srecId.add(a.Id);
     srecId.add(opp.Id);
     additionalClausesMultiSelectController.getResults('APTS_Additional_Clauses__c', 'APTS_Clause_Title__c', 'a', null );
     additionalClausesMultiSelectController.getdefaultitems('APTS_Additional_Clauses__c', 'APTS_Clause_Title__c', prop.Id);
     Test.stopTest();
   }
            
 }