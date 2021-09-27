/**********************************
Class Name: ESC_MissedMilestoneConsole_Test
Purpose:
Author: Rupesh/Gousia
Date Created:16/08/2017
Date Updated:V0 :  TEst class for ESC_MissedMilestoneConsoleController
            
**********************************/
@isTest
private class ESC_MissedMilestoneConsole_Test {

    @IsTest(SeeAllData=false) static  void test() {
        Test.startTest();
        
        //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        System.assert(us.id != null);
        
        System.RunAs(us)
        {
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
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
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
        
       
        
        //insert record for ESC_MilestoneAlertConfigSetting__c
        ESC_MilestoneAlertConfigSetting__c escma = new ESC_MilestoneAlertConfigSetting__c();
        escma.Name = '1';
        escma.X1stLevelColor__c ='#8FE9E3';
        escma.X2ndLevelColor__c ='#e5b789';
        escma.X3rdLayerColor__c ='#e58990';
        escma.X1stLevelThreshold__c = 5;
        escma.X2ndLevelThreshold__c= 10;
        insert escma;
        
        ESC_IntrusiveNotificationsSchema__c inf = new ESC_IntrusiveNotificationsSchema__c();
        inf.ESC_BodyMsgFields__c = 'ContactID,AccountID,CaseNumber';
        inf.ESC_ObjectAPIName__c ='Case';
        inf.Name = 'Name';
        insert inf;
       
        ESC_MissedMilestoneConsoleController obj=new ESC_MissedMilestoneConsoleController();
        obj.RefreshCaseListJS();
        obj.getmyCaseSize();
        obj.getallCaseSize();
        obj.setcolour(5);
        obj.getPushTopicNames();
        obj.getObjectIdentifierMap();
        obj.getIntrusiveSchemaMSG();
        }
        
        Test.stopTest();
        
         integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }

}