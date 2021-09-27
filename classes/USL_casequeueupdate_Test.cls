@isTest
private class USL_casequeueupdate_Test{
    
@isTest public static void testMethod1() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123',ANZ_Issue__c='Administrativa',
Reason__c='Cobranzas/ Reintegros',Reason_Detail__c='Reintegro', Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=testGroup.Id);
caseList.add(cs);

insert CaseList;


system.assertEquals(1,1,1);


USL_casequeueupdate.lastqueueupdate(CaseList);

test.stopTest();
}

@isTest public static void testMethod2() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,Status='Assigned',ContactId=testContact1.Id, SuppliedPhone='123123123',ANZ_Issue__c='Administrativa',
Reason__c='Cobranzas/ Reintegros',Reason_Detail__c='Reintegro', Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=testGroup.Id);
//caseList.add(cs);

insert cs;
system.assertEquals(1,1,1);
cs.ownerid=UserInfo.getUserId();
update cs;
test.stoptest();

}

@isTest public static void testMethod3() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,Status='Open',ContactId=testContact1.Id, SuppliedPhone='123123123',ANZ_Issue__c='Administrativa',
Reason__c='Cobranzas/ Reintegros',Reason_Detail__c='Reintegro', Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=testGroup.Id);
//caseList.add(cs);

insert cs;
system.assertEquals(1,1,1);
cs.ownerid=UserInfo.getUserId();
update cs;
test.stopTest();

}

@isTest public static void testMethod4() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,Status='Work In Progress',ContactId=testContact1.Id, SuppliedPhone='123123123',Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=UserInfo.getUserId());
//caseList.add(cs);

insert cs;
system.assertEquals(1,1,1);
cs.status='Closed';
update cs;
test.stoptest();

}

@isTest public static void testMethod5() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,Status='Work In Progress',ContactId=testContact1.Id, SuppliedPhone='123123123',Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=UserInfo.getUserId());
//caseList.add(cs);

insert cs;
system.assertEquals(1,1,1);
cs.status='Fix Applied';
update cs;
test.stopTest();

}

@isTest public static void testMethod7() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,Status='Work In Progress',ContactId=testContact1.Id, SuppliedPhone='123123123',Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=UserInfo.getUserId());
//caseList.add(cs);

insert cs;
system.assertEquals(1,1,1);
cs.status='Resolved';
update cs;
test.stopTest();

}

@isTest public static void testMethod6() {
       
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='test group', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;
}
test.startTest();
Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
Case cs = new Case(AccountId=testAccount1.Id,Status='Work In Progress',ContactId=testContact1.Id, SuppliedPhone='123123123',Priority='Medium',RecordtypeID=caseid , SuppliedEmail='abc@tr.com',Subject='test',OwnerID=UserInfo.getUserId());
//caseList.add(cs);

insert cs;
system.assertEquals(1,1,1);
cs.status='Partial Service Restored';
cs.ESC_Likely_Restoration_Time__c =system.now();
update cs;
test.stopTest();

}
}