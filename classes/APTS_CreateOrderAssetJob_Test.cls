@istest
public class APTS_CreateOrderAssetJob_Test{

    static testmethod void testmethod1(){
    
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
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
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
        oppty.Account=a;
        insert oppty;
        List<Apttus_Proposal__Proposal__c > propList = new list<Apttus_Proposal__Proposal__c >();
       
         Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal1.Apttus_Proposal__Approval_Stage__c='Accepted';
         proposal1.DocusignOrderAssetFlag__c=true;
         proposal1.APTS_Docusign_Order_Created__c =false;
       
         proplist.add(proposal1);
         insert proplist;
         system.debug('proplist============>'+proplist);
        test.startTest();
         APTS_CreateOrderAssetJob test1=new APTS_CreateOrderAssetJob();
        Database.executebatch(test1);            
        test.stopTest();
    }


}