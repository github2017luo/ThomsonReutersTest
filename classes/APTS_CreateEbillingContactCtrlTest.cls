@isTest
public class APTS_CreateEbillingContactCtrlTest {

    @isTest static void testMethodOne(){
         
        //Dynamic retrieval of value
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
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
        
        //inserting SSD
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        insert accountSSD;
        
        //Inserting the Opportunity
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
       
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,accountSSD.id);
        insert proposal;
        
        Test.startTest();
        PageReference pageRef = Page.APTS_CreateEbillingContact; // Add your VF page Name here
        pageRef.getParameters().put('id', proposal.id);        
        Test.setCurrentPage(pageRef);                                
         
        APTS_CreateEbillingContactCtrl eBill = new APTS_CreateEbillingContactCtrl();
        eBill.doAction();
        eBill.contactObj.FirstName = 'ebill1';
        eBill.contactObj.LastName = 'ebill2';
        eBill.contactObj.AccountId = a.Id;
        eBill.doSave();
        eBill.doCancel();
        
    Test.stopTest();    
    }
    
    @isTest static void testMethodTwo(){
        //Dynamic retrieval of value
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
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
        
        //inserting SSD
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        insert accountSSD;
        
        
        //Inserting the Opportunity
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        //inserting proposal
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,accountSSD.Id);
        insert proposal;
        
        Test.startTest();
        PageReference pageRef = Page.APTS_CreateEbillingContact; // Add your VF page Name here
        pageRef.getParameters().put('id', proposal.id);        
        Test.setCurrentPage(pageRef);                                
         
        APTS_CreateEbillingContactCtrl eBill2 = new APTS_CreateEbillingContactCtrl();
        eBill2.doAction();
        //eBill.contactObj.FirstName = 'ebill1';
        //eBill.contactObj.LastName = 'ebill2';
        //eBill.contactObj.AccountId = a.Id;
        eBill2.doSave();
        eBill2.doCancel();
        
    Test.stopTest();    
    }
    
}