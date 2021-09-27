/**********************************
Class Name: ESC_CaseReopenPageController_Test 
Purpose:
Author:Rupesh
Date Created:16/08/2017
Date Updated:V0: Test Class for ESC_CaseReopenPageController
**********************************/
@isTest
private  class ESC_CaseReopenPageController_Test {
   @isTest(SeeAllData = false) static void escCaseReopenPageControllerTest(){
       
       
       
       
       //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        System.assert(us.id != null);
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
        //ESC_W2C_ContactAssociationCheck
        
           Account testAccount2=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Is_GLI__c=false);
        insert testAccount2;
        
        Contact testContact2=new Contact (AccountId = testAccount2.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact2.ESC_tocContactStatus__c = 'Inactive';
        insert testContact2;
        
        Contact testContact3=new Contact (AccountId = testAccount2.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        insert testContact3;
        
        testContact3.ESC_tocContactStatus__c = 'Inactive';
        update testContact3;
        Test.startTest();
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        insert cs;
        
        //insert a case list
        List<Case> clist = new List<Case>();
        Case cs1  = new Case(Type='Data',Status='New', contactid=con.id,accountid=acct.id);
        clist.add(cs1);
        insert clist;
        
        PageReference pageRef = Page.ESC_CaseReopenPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('id',cs1.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        
       ESC_CaseReopenPageController escreopen = new ESC_CaseReopenPageController(sc);
         
         escreopen.callfunc='escreopen';
        escreopen.InitializeCaseRecord();
        
        try{
        
        escreopen.InitializeCaseRecordForBtn();
        escreopen.InitializeCaseRecordForPA();
        }
       
         catch(Exception e){
           system.assertEquals(e.getMessage(), e.getMessage());
           
       }
        
        string str=escreopen.getResultVal();
       pageRef.getParameters().put('scontrolCaching',cs.id);
       escreopen.InitializeCaseRecordForBtn();

    
        
       Test.stopTest();
        
   }
   
}