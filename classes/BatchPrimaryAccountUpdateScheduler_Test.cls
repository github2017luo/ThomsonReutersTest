@istest
class BatchPrimaryAccountUpdateScheduler_Test{
   static testmethod void Testmethod1() {
       account acc =new account(Name='ACME ACCOUNT TEST',SAPAccountNumber__c='9123456789',Sales_Org__c ='LLPA',BPFAccountProcessed__c= FALSE);
        account acc1 =new account(Name='Test289',SAPAccountNumber__c='9123456788',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        account acc2 =new account(Name='Test479',SAPAccountNumber__c='9123456787',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        insert acc;
        insert acc1;
        insert acc2;
        account acc3 =new account(Name='Test489',SAPAccountNumber__c='9123456786',Sales_Org__c ='TSL',ParentId = acc.Id,is_Primary__c=TRUE,BPFAccountProcessed__c= FALSE);
        insert acc3;
        
        Business_Partner_Function__c BPF = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc1.Id, Relationship_Type__c = 'Customer Org');
        Business_Partner_Function__c BPF1 = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc2.Id, Relationship_Type__c = 'Payer');
        insert BPF;
        insert BPF1;
        
        
        KeyValueListStore__c kvl = new KeyValueListStore__c(Batch_Query__c ='SELECT Id, LastModifiedDate, Relationship_Type__c, Sold_To_Account__c, Sold_To_Account__r.Sales_Org__c, Sold_To_Account__r.BPFAccountProcessed__c',Batch_Query_1__c= ' FROM Business_Partner_Function__c WHERE (Relationship_Type__c = \'Customer Org\' AND Sales_Org__c IN (\'SCSI\',\'TSL\')) ',Failure_Email__c='rajashree.behera@thomsonreuters.com',Name = 'BatchPrimaryAccountUpdate',TextValue__c='200');        
        insert kvl;       
        // Schedule the test job
        Test.StartTest();
            BatchPrimaryAccountUpdateScheduler sh1 = new BatchPrimaryAccountUpdateScheduler();
            String sch = '0 0 23 * * ?'; 
            system.schedule('BatchPrimaryAccountUpdateScheduler', sch, sh1);
        Test.stopTest();
   }
}