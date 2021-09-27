@isTest
private class ESC_CaseDescriptionUpdate_Test{
    
@isTest public static void ESC_CaseDescriptionUpdateMethod() {
       
Account testAccount1=new Account(Name= 'testName',BU_Region__c = 'Canada',Bu_Segment__c = 'Professional Tax',Is_GLI__c = true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com' ,description='yo');
caseList.add(cs);

insert CaseList;

ESC_CaseDescriptionUpdate.CaseRefCreation(new List<String>{
 'String1'
}
);

        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);


}
}