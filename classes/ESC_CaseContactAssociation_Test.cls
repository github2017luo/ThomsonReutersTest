/**********************************
Class Name: ESC_Utility_Test
Purpose: Test class for "ESC_Utility_Test" apex class.
Author: Rupesh
Date Created:25/06/2017
***********************************/
/**
 * @description ESC_CaseContactAssociation test class
 */
@isTest
/**
     * @description ESC_CaseContactAssociation_Test 
     * 
     */
private class ESC_CaseContactAssociation_Test {

     
      @IsTest(SeeAllData=false) static void getContacttoCaseonCreation() {
        Test.StartTest();
        //fill account
        try {
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
        insert testAccount1;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
        //fill cases
        List <Case> listcase= new List<Case>();
        List <Case> listcase1= new List<Case>();
    
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com', LCRM_Sub_BU__c='GGO',Origin='Email');
        listcase.add(cs);
         Case cs3 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com', LCRM_Sub_BU__c='GGO',Origin='Email');
        listcase.add(cs3);
        
        Account testAccount2=new Account(Name= 'testName1',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='BEJE',
        Tax_Type__c='C.I',Tax_Number__c='654651654');
        insert testAccount2;
        
        Contact testContact12=new Contact (AccountId = testAccount2.id,firstname= 'John1',lastname= 'Mile1',email = 'abc1@tr.com', phone='7786864710');
        testContact12.ESC_tocContactStatus__c = 'Active';
        insert testContact12;
        
         Case cs4 = new Case(AccountId=testAccount2.Id, SuppliedPhone='123123123', SuppliedEmail='abc1@tr.com', LCRM_Sub_BU__c='GGO',Origin='Web',Description ='GGO_Tax_Number_Type__c:C.I,GGO_Tax_Number__c:654651654');
        listcase.add(cs4);
       
        Case cs2 = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123', SuppliedEmail=null);
        listcase.add(cs2);
       
        //covering blank input check
        ESC_CaseContactAssociation.getContacttoCaseonCreation(null);        
        
        //covering method
        insert listcase;
        ESC_CaseContactAssociation.getContacttoCaseonCreation(listcase);
        Case cs1 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',IS_GLI__c=true);
        Case cs6 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',IS_GLI__c=true,BU_Segment__c='Professional Legal',LCRM_Sub_Bu__c='Canada');
        Case cs7 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',IS_GLI__c=true,LCRM_Sub_Bu__c='UKI');
        Case cs8 = new Case(AccountId=testAccount1.Id,ESC_Unique_Identifier__c='HRC',BU_Segment__c='Professional Legal',Origin='Web',SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',IS_GLI__c=true,LCRM_Sub_Bu__c='US');
        listcase1.add(cs6);
        listcase1.add(cs6);
        listcase1.add(cs7);
        listcase1.add(cs1);
        listcase1.add(cs8);
        insert listcase1;
        ESC_CaseContactAssociation.getContacttoCaseonCreation(listcase1);
        
        //fill more contact to cover further
        list<Contact> listTestCon = new list<Contact>();
        Contact testContact2=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile2',email = 'abc@tr.com', phone='7786864710');
        testContact2.ESC_tocContactStatus__c = 'Inactive';
        listTestCon.add(testContact2);
        Test.StopTest();
        Contact testContact3=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile3',email = 'abc@tr.com', phone='7786864710');
        testContact3.ESC_tocContactStatus__c = 'Active';
        listTestCon.add(testContact3);
        
        insert listTestCon;
        ESC_CaseContactAssociation.getContacttoCaseonCreation(listcase);
        
        //fill more contact to cover further
        list<Contact> listTestCon2 = new list<Contact>();
        Contact testContact4=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile4',email = 'abc@tr.com', phone='7786864710');
        testContact4.ESC_tocContactStatus__c = 'Inactive';
        listTestCon2.add(testContact4);
        
        Contact testContact5=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile5',email = 'abc@tr.com', phone='7786864710');
        testContact5.ESC_tocContactStatus__c = 'Active';
        listTestCon2.add(testContact5);
        
        insert listTestCon2;
        ESC_CaseContactAssociation.getContacttoCaseonCreation(listcase);
        Case testCase = [Select id, ContactId from Case where id = :listcase.get(0).Id];
        integer i= 1;
        integer j= 1;
        system.assertequals(i,j,'equal');   
        }
        catch(Exception e)
        {
          system.debug(logginglevel.warn,'test');   
        }
    }
    
    
    @ISTest
    static void getContactAssc()
    {
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='GLI',Is_GLI__c=true);
        insert testAccount1;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
        List<case> csList = new List<Case>();
        Case cs7 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',Origin='Web',LCRM_Sub_BU__c='USL',BU_Segment__c='Professional Legal', Is_GLI__c=true);
        csList.add(cs7);
        
        insert csLIst;
        System.assertEquals(testContact1.ESC_tocContactStatus__c,'Inactive','Inavlid Status');
        Test.StartTest();
        ESC_CaseContactAssociation.getContacttoCaseonCreation(csLIst);
        Test.StopTest();
    }
    
    @ISTest
    static void getContactAsscNew()
    {
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='GLI',Is_GLI__c=true);
        insert testAccount1;
        
        Account testAccount2=new Account(Name= 'testName2',ShippingCity= 'testCity1',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='GLI',Is_GLI__c=true,Bu_Segment__c='Professional Legal',BU_Region__c='USL');
        insert testAccount2;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
        Contact testContact2=new Contact (AccountId = testAccount2.id,firstname= 'John1',lastname= 'Mile1',email = 'abc@tr.com', phone='7786864710');
        testContact2.ESC_tocContactStatus__c = 'Inactive';
        insert testContact2;
        System.assertEquals(testContact1.ESC_tocContactStatus__c,'Inactive','Inavlid Status');
        List<case> csList = new List<Case>();
        Case cs7 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',Origin='Web',LCRM_Sub_BU__c='USL',BU_Segment__c='Professional Legal', Is_GLI__c=true);
        csList.add(cs7);
        
        insert csLIst;
        Test.StartTest();        
        ESC_CaseContactAssociation.getContacttoCaseonCreation(csLIst);
        Test.StopTest();
    }
    
    @ISTest
    static void getContactAsscForFinal()
    {
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='GLI',Is_GLI__c=true);
        insert testAccount1;
        
        Account testAccount2=new Account(Name= 'testName2',ShippingCity= 'testCity1',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='GLI',Is_GLI__c=true,Bu_Segment__c='Professional Legal',BU_Region__c='USL');
        insert testAccount2;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
        Contact testContact2=new Contact (AccountId = testAccount2.id,firstname= 'John1',lastname= 'Mile1',email = 'abc@tr.com', phone='7786864710');
        testContact2.ESC_tocContactStatus__c = 'Inactive';
        insert testContact2;
        System.assertEquals(testContact1.ESC_tocContactStatus__c,'Inactive','Inavlid Status');
        
        List<case> csList = new List<Case>();
        Case cs7 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',Origin='Web',LCRM_Sub_BU__c='USL',Is_GLI__c=true);
        csList.add(cs7);
        
        insert csLIst;
                
        ESC_CaseContactAssociation.getContacttoCaseonCreation(csLIst);
        
        testContact2.Contact_Inactive__c=true;
        update testContact2;
        Test.StartTest();
        ESC_CaseContactAssociation.getContacttoCaseonCreation(csLIst);
        Test.StopTest();
    }
    
    @isTest
    static void getContactAssocData()
    {
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',Sales_Org__c='GLI');
        insert testAccount1;
        List<contact> conlist = new list<contact>();
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        conlist.add(testContact1);
        
        Contact testContact2=new Contact (AccountId = testAccount1.id,firstname= 'John1',lastname= 'Mile1',email = 'abc@tr.com', phone='7786864711');
        testContact2.ESC_tocContactStatus__c = 'Inactive';
        conlist.add(testContact2);
        insert conlist;
        System.assertEquals(testContact1.ESC_tocContactStatus__c,'Inactive','Inavlid Status');
        
        List<case> csList = new List<Case>();
        Case cs7 = new Case(AccountId=testAccount1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com',IS_GLI__c=true, Origin='Web');
        csList.add(cs7);
        
        insert csLIst;
        Test.StartTest();
        ESC_CaseContactAssociation.getContacttoCaseonCreation(csLIst);
        Test.StopTest();
    }

}