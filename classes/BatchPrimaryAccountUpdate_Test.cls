@isTest
public class BatchPrimaryAccountUpdate_Test {
//Failure_Email__c Batch_Query__c
    static testmethod void test() {        
        account acc =new account(Name='ACME ACCOUNT TEST',SAPAccountNumber__c='9123456789',Sales_Org__c ='LLPA',BPFAccountProcessed__c= true);
        account acc1 =new account(Name='Test289',SAPAccountNumber__c='9123456788',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        account acc2 =new account(Name='Test479',SAPAccountNumber__c='9123456787',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        insert acc;
        insert acc1;
        insert acc2;
        account acc3 =new account(Name='Test489',SAPAccountNumber__c='9123456786',Sales_Org__c ='TSL',ParentId = acc.Id,is_Primary__c=TRUE,BPFAccountProcessed__c= FALSE);
        insert acc3;
        
        Business_Partner_Function__c BPF = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc1.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        Business_Partner_Function__c BPF1 = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc2.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Payer');
        insert BPF;
        insert BPF1;
        
        
        KeyValueListStore__c kvl = new KeyValueListStore__c(Batch_Query__c ='SELECT Id, LastModifiedDate, Relationship_Type__c, Sold_To_Account__c, Sold_To_Account__r.Sales_Org__c, Sold_To_Account__r.BPFAccountProcessed__c',Batch_Query_1__c= ' FROM Business_Partner_Function__c WHERE (Relationship_Type__c = \'Customer Org\' AND Sales_Org__c IN (\'SCSI\',\'TSL\')) ',Failure_Email__c='rajashree.behera@thomsonreuters.com',Name = 'BatchPrimaryAccountUpdate',TextValue__c='200');        
        insert kvl;               
        
        Test.startTest();
            Database.executeBatch(new BatchPrimaryAccountUpdate(), 200);
        Test.stopTest();
        acc1=[SELECT Is_Primary__c,Id FROM Account where Id=:acc1.Id];
        acc = [SELECT ParentID FROm Account where Id=:acc.Id];    
        System.assertEquals(acc1.id,acc.ParentID);        
     } 
     
     static testmethod void testTwoBPFForSameOne() {        
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg1',Ranking__c = '1',Sales_org__c ='TSL' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg2',Ranking__c = '2',Sales_org__c ='BEJE' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg3',Ranking__c = '3',Sales_org__c ='LLEY' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg4',Ranking__c = '4',Sales_org__c ='LLPA' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg5',Ranking__c = '5',Sales_org__c ='WEST' );

        
        account acc =new account(Name='ACME ACCOUNT TEST',SAPAccountNumber__c='9123456789',Sales_Org__c ='LLPA',BPFAccountProcessed__c= true);
        account acc1 =new account(Name='Test289',SAPAccountNumber__c='9123456788',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        account acc2 =new account(Name='Test479',SAPAccountNumber__c='9123456787',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        insert acc;
        insert acc1;
        insert acc2;
        account acc3 =new account(Name='Test489',SAPAccountNumber__c='9123456786',Sales_Org__c ='TSL',ParentId = acc.Id,is_Primary__c=TRUE,BPFAccountProcessed__c= FALSE);
        insert acc3;
        
        Business_Partner_Function__c BPF = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc1.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        Business_Partner_Function__c BPF1 = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc2.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        insert BPF;
        insert BPF1;
        
        
        KeyValueListStore__c kvl = new KeyValueListStore__c(Batch_Query__c ='SELECT Id, LastModifiedDate, Relationship_Type__c, Sold_To_Account__c, Sold_To_Account__r.Sales_Org__c, Sold_To_Account__r.BPFAccountProcessed__c',Batch_Query_1__c= ' FROM Business_Partner_Function__c WHERE (Relationship_Type__c = \'Customer Org\' AND Sales_Org__c IN (\'SCSI\',\'TSL\')) ',Failure_Email__c='rajashree.behera@thomsonreuters.com',Name = 'BatchPrimaryAccountUpdate',TextValue__c='200');        
       insert kvl;        
       Test.startTest();
            Database.executeBatch(new BatchPrimaryAccountUpdate(), 200);
        Test.stopTest();
        acc2=[SELECT Is_Primary__c,Id FROM Account where Id=:acc2.Id];
        acc = [SELECT ParentID FROm Account where Id=:acc.Id];  
        System.assertEquals(acc2.id,acc.ParentID);          
     } 
    static testmethod void testIsPrimaryFalseNormal() {        
                     
        account acc =new account(Name='ACME ACCOUNT TEST',SAPAccountNumber__c='9123456789',Sales_Org__c ='LLPA',BPFAccountProcessed__c= true);
        account acc1 =new account(Name='Test289',SAPAccountNumber__c='9123456788',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        account acc2 =new account(Name='Test479',SAPAccountNumber__c='9123456787',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        insert acc;
        insert acc1;
        insert acc2;
        account acc3 =new account(Name='Test489',SAPAccountNumber__c='9123456786',Sales_Org__c ='TSL',ParentId = acc.Id,is_Primary__c=TRUE,BPFAccountProcessed__c= FALSE);
        insert acc3;
        
        Business_Partner_Function__c BPF = new Business_Partner_Function__c(Sold_To_Account__c = acc1.Id,Related_Account__c = acc1.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        Business_Partner_Function__c BPF1 = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc2.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        insert BPF;
        insert BPF1;
        
        Account accUpdate =[select Id, Is_Primary__c from Account where id =:acc.Id limit 1];
        accUpdate.Is_Primary__c = false;
        update accUpdate;
        
        KeyValueListStore__c kvl = new KeyValueListStore__c(Batch_Query__c ='SELECT Id, LastModifiedDate, Relationship_Type__c, Sold_To_Account__c, Sold_To_Account__r.Sales_Org__c, Sold_To_Account__r.BPFAccountProcessed__c',Batch_Query_1__c= ' FROM Business_Partner_Function__c WHERE (Relationship_Type__c = \'Customer Org\' AND Sales_Org__c IN (\'SCSI\',\'TSL\')) ',Failure_Email__c='rajashree.behera@thomsonreuters.com',Name = 'BatchPrimaryAccountUpdate',TextValue__c='200');        
        insert kvl;               
        
        Test.startTest();
            Database.executeBatch(new BatchPrimaryAccountUpdate(), 200);
        Test.stopTest();
        acc2=[SELECT Is_Primary__c,Id FROM Account where Id=:acc2.Id];
        acc = [SELECT ParentID FROm Account where Id=:acc.Id];   
        System.debug('test1 '+acc.ParentID);
        System.assertEquals(acc2.id,acc.ParentID);               
     }   
     static testmethod void testTwoBPFForSameOne_IsPrimaryFalse() {        
          
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg1',Ranking__c = '1',Sales_org__c ='TSL' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg2',Ranking__c = '2',Sales_org__c ='BEJE' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg3',Ranking__c = '3',Sales_org__c ='LLPA' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg4',Ranking__c = '4',Sales_org__c ='LLUR' );
        insert new Ranking_Salesorg__c(Name='Ranking_Salesorg5',Ranking__c = '5',Sales_org__c ='WEST' );

        account acc =new account(Name='ACME ACCOUNT TEST',SAPAccountNumber__c='9123456789',Sales_Org__c ='LLPA',BPFAccountProcessed__c= true);
        account acc1 =new account(Name='Test289',SAPAccountNumber__c='9123456788',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        account acc2 =new account(Name='Test479',SAPAccountNumber__c='9123456787',Sales_Org__c ='TSL',BPFAccountProcessed__c= FALSE);
        insert acc;
        insert acc1;
        insert acc2;
        account acc3 =new account(Name='Test489',SAPAccountNumber__c='9123456786',Sales_Org__c ='TSL',ParentId = acc.Id,is_Primary__c=TRUE,BPFAccountProcessed__c= FALSE);
        insert acc3;
        
        Business_Partner_Function__c BPF = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc1.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        Business_Partner_Function__c BPF1 = new Business_Partner_Function__c(Sold_To_Account__c = acc.Id,Related_Account__c = acc2.Id, Sales_Org__c ='TSL', Relationship_Type__c = 'Customer Org');
        insert BPF;
        insert BPF1;
        
        Account accUpdate =[select Id, Is_Primary__c from Account where id =:acc.Id limit 1];
        accUpdate.Is_Primary__c = false;
        update accUpdate;
        
        KeyValueListStore__c kvl = new KeyValueListStore__c(Batch_Query__c ='SELECT Id, LastModifiedDate, Relationship_Type__c, Sold_To_Account__c, Sold_To_Account__r.Sales_Org__c, Sold_To_Account__r.BPFAccountProcessed__c',Batch_Query_1__c= ' FROM Business_Partner_Function__c WHERE (Relationship_Type__c = \'Customer Org\' AND Sales_Org__c IN (\'SCSI\',\'TSL\')) ',Failure_Email__c='rajashree.behera@thomsonreuters.com',Name = 'BatchPrimaryAccountUpdate',TextValue__c='200');        
       insert kvl;        
       Test.startTest();
            Database.executeBatch(new BatchPrimaryAccountUpdate(), 200);
        Test.stopTest();
        acc2=[SELECT Is_Primary__c,Id FROM Account where Id=:acc2.Id];
        acc = [SELECT ParentID FROm Account where Id=:acc.Id];  
        System.assertEquals(acc2.id,acc.ParentID);            
     } 
}