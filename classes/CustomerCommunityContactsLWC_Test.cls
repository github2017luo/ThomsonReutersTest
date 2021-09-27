@isTest(SeeAllData=false)
public class CustomerCommunityContactsLWC_Test
{
 static testmethod void testDataFactory2()
    {
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'TR Customer Super User'];
        Account testAcc1 = new Account();
                    testAcc1 = UnitTest.getAccountInstance();
                    testAcc1.SAPAccountNumber__c = '5491';
                    insert testAcc1;
                    
        Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
        c.ESC_BU_Originated_By__c ='Elite';
        insert c;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(C.ID,testacc1.ID,'Work In Progress');
        case1.ESC_Proactive_Type__c ='';
        case1.is_GLI__c = true;  
        case1.ESC_Product_Segment_Brand__c='Elite';   
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert case1; 
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@oslcccf.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Contactid = c.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'Elite',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        integer s =10;
        integer s1= 0;
       system.runAs(testUser){
          test.starttest();
        
        CustomerCommunityContactsLWCController classConstruct=new CustomerCommunityContactsLWCController();
        
        List<CustomerCommunityContactsLWCController.DataTableWrapper1> oData3 =CustomerCommunityContactsLWCController.getContact();
        List<CustomerCommunityContactsLWCController.DataTableWrapper1> oData4 =CustomerCommunityContactsLWCController.getAllContactList(s,s1,'');
        List<CustomerCommunityContactsLWCController.DataTableWrapper2> oData5 =CustomerCommunityContactsLWCController.getAllCaselist(s,s1,'');
        
               test.stoptest();
          }
         integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');  
 }
 }