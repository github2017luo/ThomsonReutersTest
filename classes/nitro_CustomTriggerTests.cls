/**
 *    Test Class for nitro Custom Triggers and related classes:
 *    - nitroTrigger_OpportunityRenewal
 *    - nitroTrigger_TrainingEvents
 *    - nitroTrigger_Activities
 *    - nitro_TriggerRunOnce class
 */
@isTest(seealldata=true)
private class nitro_CustomTriggerTests {
 /* SKG
  static private StaticResource RenewalRoles = [select id, Name, Body 
                                                from StaticResource 
                                                where Name = 'nitro_RenewalRolesList' limit 1];
    static private nitro__Nitro_Configuration__c getNitro () {
        nitro__Nitro_Configuration__c nitroConfigData = new nitro__Nitro_Configuration__c();
    nitroConfigData.Name = 'nitro1';
    nitroConfigData.nitro__Time__c = 'Quarter';
    nitroConfigData.nitro__Administrator_Email__c = 'test@test.com';
    nitroConfigData.nitro__API_Key__c = 'ff6018c1ef82465eaef9fd755d271662';
    nitroConfigData.nitro__API_Secret__c = '90da2010bbde42d3812f8fa117344a6b';
    return nitroConfigData;
    }
    
    static private string getFiscalMonth() {
        date today = system.today();
        string Year = today.year().format();
        integer M = today.month();
        string Month = (M==1)? 'Jan' : (M==2)? 'Feb' : (M==3)? 'Mar' :
                        (M==4)? 'Apr' : (M==5)? 'May' : (M==6)? 'Jun' :
                        (M==7)? 'Jul' : (M==8)? 'Aug' : (M==9)? 'Sep' :
                        (M==10)? 'Oct' : (M==11)? 'Nov' : 'Dec';
        return Month+' '+Year;
    }
    
    static testMethod void test_nitroTrigger_OpportunityRenewals() {
        nitro__Nitro_Configuration__c nitroConfigData = getNitro();
   /** insert nitroConfigData;
    list<string> Roles = new list<string>{};
    if (RenewalRoles != null) {
        Roles.addAll(RenewalRoles.body.toString().split(',',-2));
    } else
      Roles.add('Home Office-IAM Corp-Account Manager');
    
    User Usr = [select id, UserRoleId from User where id = :UserInfo.getUserId()];
    UserRole Role = [select id from UserRole where Name = :Roles[0] limit 1];
     
    system.runAs(Usr) {
        //Usr.UserRoleID = Role.id;
        //update Usr;
        date ADate = system.today();
        string MthYr = AppUtil.formatDate(ADate, 'MMM yyyy', 'NoDateGen');
        UserQuota__c UQ = new UserQuota__c(Renewal__c = 30000, User__c = Usr.id, Fiscal_Month__c = MthYr,External_Id__c = Usr.Id+MthYr);
      insert UQ; // User Quota is set to the Opportunity via the OpportunityTriggerHandler class
      system.debug('UserQuota ID is '+UQ.id);
        Account testAcct = new Account(Name = 'test');
      insert testAcct;
        
      Opportunity testOpp1 = new Opportunity(Name = 'testOpp1', AccountID = testAcct.id, 
                                              CloseDate = ADate, StageName = '100%',
                                              Renewal_Amount__c = 10000);
      system.debug('INSERT TESTOPP 1');
      insert testOpp1;
      system.debug('INSERT TESTOPP 1 COMPLETE');
        
      Opportunity testOpp2 = new Opportunity(Name = 'testOpp2', AccountID = testAcct.id, 
                                            CloseDate = ADate, StageName = '10%',
                                            Renewal_Amount__c = 10000);
      insert testOpp2;
      
      
      testOpp2.StageName = '100%';
      update testOpp2;
        
      nitro_TriggerRunOnce.resetAlreadyDone();
    }
    */
    /*
    }
    
    static testMethod void test_nitroTrigger_OpportunityNewSale() {
        system.debug('test_nitroTrigger_OpportunityNewSale()');
        nitro__Nitro_Configuration__c nitroConfigData = getNitro();
    insert nitroConfigData;
    id UsrId = UserInfo.getUserId();
    date ADate = system.today();
    string MthYr = AppUtil.formatDate(ADate, 'MMM yyyy', 'NoDateGen');
    UserQuota__c UQ = new UserQuota__c(New_Sale__c = 30000, User__c = UsrId, Fiscal_Month__c = MthYr,External_Id__c = UsrId+MthYr);
    insert UQ; // User Quota is set to the Opportunity via the OpportunityTriggerHandler class
    system.debug('UserQuota ID is '+UQ.id);
    Account testAcct = new Account(Name = 'test');
    insert testAcct;
    
    Opportunity testOpp1 = new Opportunity(Name = 'testOpp1', AccountID = testAcct.id, 
                                          CloseDate = ADate, StageName = '100%',
                                          Incremental_Amount__c = 10000);
    system.debug('INSERT TESTOPP 1');
    insert testOpp1;
    system.debug('INSERT TESTOPP 1 COMPLETE');
    
    
    Opportunity testOpp2 = new Opportunity(Name = 'testOpp2', AccountID = testAcct.id, 
                                        CloseDate = ADate, StageName = '10%',
                                        Incremental_Amount__c = 10000);
    insert testOpp2;
  
  
    testOpp2.StageName = '100%';
    update testOpp2;
    
    }
    
    static testMethod void test_nitroTrigger_Activities() {
        date ADate = system.today();
        
        nitro__Nitro_Configuration__c nitroConfigData = getNitro();
        insert nitroConfigData;
        
        
        Account testAcct = new Account(Name = 'test');
        insert testAcct;
        
        Opportunity testOpp = new Opportunity(Name = 'testOpp', AccountID = testAcct.id, 
                                              CloseDate = ADate, StageName = '100%');
        insert testOpp;
        
      list<Task> testTasks = new list<Task> {new Task (Type = 'Outbound Call', ActivityDate=ADate,
                                                       Status__c = 'Completed', WhatId=testOpp.id,
                                                       Subject='Task', Priority='Normal',
                                                       Activity_Category__c= 'A Referral'),
                                             new Task (Type = 'Email', ActivityDate=ADate,
                                                     Status__c = 'Completed', WhatId=testOpp.id,
                                                     Subject='Task', Priority='Normal',
                                                     Activity_Category__c= 'B Referral'),
                                           new Task (Type = 'Inbound Call', ActivityDate=ADate,
                                                     Status__c = 'Completed', WhatId=testOpp.id,
                                                     Subject='Task', Priority='Normal',
                                                     Activity_Category__c= 'P Referral')};
      insert testTasks; 
    }
    
    static testMethod void test_nitroTrigger_TrainingEvents() {
        Date ADate = system.today();
        list<Training_Event__c> testTrainings = new list<Training_Event__c> { 
            new Training_Event__c(Training_Name__c ='testIns', Status__c = 'Completed', Training_Date__c = ADate),
          new Training_Event__c(Training_Name__c ='testIns', Status__c = 'Contacting', Training_Date__c = ADate)};
        insert testTrainings;
        
        testTrainings[1].Status__c = 'Completed';
        update testTrainings[1];
        
    }*/
}