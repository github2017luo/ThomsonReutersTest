@isTest
private class GGO_Special_instruction_Capture_Test{
    
@isTest public static void GGO_Special_instruction_Capture_TestMethod() {
       
Account testAccount1=new Account(Name= 'testName1',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet1');
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'Boss',lastname= 'Baby',email = 'B.baby@tr.com', phone='7286864710');
insert testContact1;
        
ESC_Special_Instruction__c Si1 =New ESC_Special_Instruction__c(ESC_Account__c=testAccount1.id,ESC_Status__c='Active',ESC_Category_Account__c='TLC',ESC_Instructions__c='Test inst');
insert Si1;
ESC_Special_Instruction__c Si2 =New ESC_Special_Instruction__c(ESC_Account__c=testAccount1.id,ESC_Status__c='Active',ESC_Category_Account__c='Bejerman Customized Customer',ESC_Instructions__c='Test inst');
insert Si2;
/**Group testGroup = new Group(Name='test group', Type='Queue');
insert testGroup;**/

list<case> caseList=new List<case>();


System.runAs(new User(Id=UserInfo.getUserId()))
{
   /** QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
    insert testQueue;**/
}
Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=False,SuppliedPhone='1123123', SuppliedEmail='B.babyc@tr.com' );
caseList.add(cs);

insert CaseList;

GGO_Special_instruction_Capture.AccountSICapture(CaseList);


}
}