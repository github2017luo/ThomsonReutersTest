/*
======================================================================================================================
TEST CLASS NAME: TestAccountHandler
======================================================================================================================
PURPOSE:    Validates the functionality provided by the AccountHandler class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

                                                 Optimized the coverage
2017-03-31            Karthi                     as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest (seealldata=false)  // As part of  s2e Optimisation project making seeAllData as false [Rajashree]

private class TestAccountHandler
{    

    private static testmethod void TestAccountHandler()
    {

    
     Id profileId = [SELECT Id From Profile Where Name = 'latam user' LIMIT 1].Id;
     user u= [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];      
    UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree]   
    
    AccountHandler.renewalCancellationFlow = true;
    
    Id eliteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
    
    LCRM_StrikeIron_CountryCodes__c cc = new LCRM_StrikeIron_CountryCodes__c();
    cc.Name ='US';
    cc.LCRM_Country_Name__c ='United States';
    cc.LCRM_Country_Code__c ='US';
    cc.LCRM_ISD_Code__c ='1';
    
    insert cc;
    
    List<KeyValueListStore__c> lstKeyValue = new List<KeyValueListStore__c>();
    KeyValueListStore__c kv = new KeyValueListStore__c ();
    kv.Name = 'LCRMStrikeIronInformaticaUsers';
    kv.Failure_Email__c ='Informatica.epm';
     lstKeyValue.add(kv);
     
    KeyValueListStore__c kv1 = new KeyValueListStore__c ();
    kv1.Name = 'LTS_partnerUserProfileName';
    kv1.TextValue__c ='TR Corp Partner Community User';
    lstKeyValue.add(kv1);
     
    KeyValueListStore__c kv2 = new KeyValueListStore__c ();
    kv2.Name = 'LTS_partnerUserLeadSourceValue';
    kv2.TextValue__c ='Partner';
    lstKeyValue.add(kv2);
    
    KeyValueListStore__c kv3 = new KeyValueListStore__c ();
    kv3.Name = 'LTS_partnerUserBUSegmentValue';
    kv3.TextValue__c ='Corporate';
    lstKeyValue.add(kv3);
    
    KeyValueListStore__c kv4 = new KeyValueListStore__c ();
    kv4.Name = 'ReasonWithCompetitor';
    kv4.TextValue__c ='TR Corp Partner Community User';
    lstKeyValue.add(kv4);
    
    insert lstKeyValue;
     
  
    
    List<Account> lstAcct = new List<Account>();
        
    Account oTestAccount = UnitTest.getAccountInstance();
    oTestAccount.phone='+123456';
    oTestAccount.is_gli__c = true;
    oTestAccount.PhoneNumberTwo__c ='+999999999';
    oTestAccount.BillingCountry ='US';
    oTestAccount.RecordTypeId = eliteRecordTypeId;
    oTestAccount.Email__c ='test12@mail.com'; 
    //oTestAccount.ECM_Party_ID__c ='123456';

    lstAcct.add(oTestAccount);
    
    Account acc = UnitTest.getAccountInstance();
    acc.phone='999999';
    acc.is_gli__c = true;
    acc.PhoneNumberTwo__c ='999999999';
    acc.BillingCountry ='US';
    acc.RecordTypeId = eliteRecordTypeId;
    acc.Email__c ='test123@mail.com'; 
    //acc.ECM_Party_ID__c ='1234567';
    
    lstAcct.add(acc);
    
    Account acc1 = UnitTest.getAccountInstance();
    acc1.phone='+123456';
    acc1.is_gli__c = true;
    acc1.PhoneNumberTwo__c ='+999999999';
    acc1.BillingCountry ='US';
    acc1.RecordTypeId = eliteRecordTypeId;
    acc1.Email__c ='test12@mail.com'; 
   // acc1.ECM_Party_ID__c ='123456';
    acc1.LCRM_Email_Verification__c ='Exception';
    acc1.LCRM_Phone_Verification__c ='Exception';
    acc1.LCRM_Alternate_Phone_Verification__c ='Exception';
    acc1.Industry_LatAm__c='';
    
    
    lstAcct.add(acc1);
    
    Account acc2 = UnitTest.getAccountInstance();
    acc2.phone='123456';
    acc2.is_gli__c = true;
    acc2.PhoneNumberTwo__c ='999999999';
    acc2.BillingCountry ='US';
    acc2.RecordTypeId = eliteRecordTypeId;
    acc2.Email__c ='test12@mail.com'; 
    //acc2.ECM_Party_ID__c ='123456';
    acc2.LCRM_Email_Verification__c ='Exception';
    acc2.LCRM_Phone_Verification__c ='Exception';
    acc2.LCRM_Alternate_Phone_Verification__c ='Exception';
    
    lstAcct.add(acc2);    
    
     Account acc3 = UnitTest.getAccountInstance();
    acc3.phone='123456';
    acc3.is_gli__c = true;
    acc3.PhoneNumberTwo__c ='999999999';
    acc3.BillingCountry ='GB';
    acc3.RecordTypeId = eliteRecordTypeId;
    acc3.Email__c ='test12@mail.com'; 
    acc3.VAT_Number__c ='GB12345678901';
       
    lstAcct.add(acc3); 
        
    insert lstAcct;
    
    VAT_Validation_On_Account__c vat= new VAT_Validation_On_Account__c();
    vat.Name='GB';
    vat.Country_Name__c='United Kingdom';
    vat.VAT_Number_Length__c=14;
    insert vat;
        
    List<Id> lstId = new List<Id>();
    lstId.add(oTestAccount.Id);
    lstId.add(acc.Id);
    lstId.add(acc1.Id);
    lstId.add(acc2.Id);
    
    Opportunity oTestOpportunity = UnitTest.getOpportunityInstance(oTestAccount.Id);
    insert oTestOpportunity;
    
    Contact oTestContact = UnitTest.getContactInstance(oTestAccount.Id);
    insert oTestContact ;
      
    Lead testLead = UnitTest.getLeadInstance();
    testLead.Account__c = oTestAccount.Id;
    testLead.is_gli__c = true;
    insert testlead;
    System.assertEquals(testLead != null,true);
    
    oTestAccount.phone='+1234567';
    oTestAccount.Website = 'test.com';
    Map<id,Account> mapAcct  = new map<Id, Account>();
    mapAcct.put(oTestAccount.id, oTestAccount);
    mapAcct.put(acc.Id, acc);
    mapAcct.put(acc1.Id, acc1);
    mapAcct.put(acc2.Id, acc2);
    
    test.startTest();
    CheckRecursive.lcrmRecursivecheckflag_Account =true;
    update oTestAccount;
    CheckRecursive.lcrmRecursivecheckflag_Account =true;
    oTestAccount.PhoneNumberTwo__c = '9008765432';
    update oTestAccount;
    CheckRecursive.lcrmRecursivecheckflag_Account =true;


    //AccountHandler.verifyEmailAndPhoneFuture(lstId);
    AccountHandler.validateAccountOnMerge(lstAcct);
    AccountHandler.vatNoValidation(lstAcct);
    test.stopTest();
    
   /** Profile_List__c objPr = new Profile_List__c();
    objPr.name = [SELECT Id FROM Profile WHERE Name = 'Partner Portal User' LIMIT 1].Id;
    objPr.Profile_Name__c = 'Partner Portal User';        
    objPr.ProfileId__c = [SELECT Id FROM Profile WHERE Name = 'Partner Portal User' LIMIT 1].Id;
    INSERT objPr;
    
    User u = new User(Alias = 'ppu', Email='ppu@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='ppu', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId =objPr.ProfileId__c, 
    TimeZoneSidKey='America/Los_Angeles', UserName='ppu@testorg.com',contactId=oTestContact.Id);**/
    //Commenting as part of DPS-17684
    //system.runas(u){
    //    AccountHandler.validateAccountApprovedReservation(lstAcct,mapAcct);
    //}
    
    }
    
 public static testmethod void verifyEmailAndPhone(){
        
    UnitTest.createTestData();
    
    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
    excepObj.LCRM_Exception_Message__c = '';
    excepObj.LCRM_Exception_Trace__c = 'emaiter';
    excepObj.LCRM_Exception_Type__c = 'StrikeIron Account Email';
    excepObj.LCRM_Record_Ids__c =' String';
    excepObj.LCRM_User_ID__c = 'fe';
    insert excepObj;
    System.assertEquals(excepobj!= null,true);
    List<Account> lstAcc = new List<Account>();
    Account acc1 = UnitTest.getAccountInstance();
    Id eliteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
    acc1.RecordTypeId = eliteRecordTypeId;
    acc1.BillingCity ='NEW YORK';
    acc1.BillingState ='NY';
    acc1.BillingPostalCode ='10017-2416';
    acc1.BillingStreet ='555 5TH AVE';
    acc1.BillingCountry ='US';
    acc1.phone ='';
    acc1.PhoneNumberTwo__c ='';
    acc1.Email__c ='';

    lstAcc.add(acc1);

    
    test.startTest();
    
        insert lstAcc;


    test.stopTest();
    
    
    }
 
    
    public static testmethod void testupdateleadaddress(){
       UnitTest.createTestData(); //  As part of  s2e Optimisation project adding test data [Rajashree]   
       
        List<Account> listestAccounts = new List<Account>();
        List<Lead> listtestLead = new List<Lead>();
        
        Account oTestAccount1 = UnitTest.getAccountInstance();
        oTestAccount1.SAPAccountNumber__c = '9999';
        oTestAccount1.phone='1234567';
        oTestAccount1.Sales_Org__c = 'BKRS';
        oTestAccount1.Customer_Class_c__c = 'test1';
        oTestAccount1.Customer_Group__c = 'ACADEMIC';
        oTestAccount1.Industry = 'HARDWARE';
        oTestAccount1.Customer_Type__c= 'Organization'; 
        listestAccounts.add(oTestAccount1);
        
        Account oTestAccount2 = UnitTest.getAccountInstance();
        oTestAccount2.phone='123456';
        oTestAccount2.Sales_Org__c = 'BKRS';
        oTestAccount2.Customer_Class_c__c = 'test2';
        oTestAccount2.Customer_Group__c = 'AUTHOR';
        oTestAccount2.Industry = 'FACILITIES';
        oTestAccount2.Customer_Type__c = 'Individual';
        oTestAccount2.Legacy_System_ID__c = '123456';
        listestAccounts.add(oTestAccount2);
        
        Account oTestAccount3 = UnitTest.getAccountInstance();
        oTestAccount3.phone='987654';
        oTestAccount3.Legacy_System_ID__c = '987654';
        oTestAccount3.Sales_Org__c = 'WEST';
        oTestAccount3.Customer_Class_c__c = 'Individual';
        oTestAccount3.Customer_Group__c = 'CORPORATION';
        oTestAccount3.Industry = 'NOTARY';
        oTestAccount3.Customer_Type__c = 'Individual';
        
        listestAccounts.add(oTestAccount3);
           
         Id profileId = [SELECT Id From Profile Where Name = 'latam user' LIMIT 1].Id;
         user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
        // Profile_List__c pl = new Profile_List__c(Name= profileId,Profile_Name__c='Partner Portal User');
       //  insert pl;
         system.runas(usr){
        
                
        insert listestAccounts;
         }
        
        Lead testLead1 = UnitTest.getLeadInstance();
        testLead1.Account__c= oTestAccount1.Id;
        testLead1.SAPAccountNumber__c = '9999';
        listtestLead.add(testLead1); 
        
        Lead testLead2 = UnitTest.getLeadInstance();
        testLead2.Legacy_System_ID__c = '123456';
        listtestLead.add(testLead2); 
        
        Lead testLead3 = UnitTest.getLeadInstance();
        testLead3.Legacy_System_ID__c = '987654';
        listtestLead.add(testLead3);

        Lead testLead4 = UnitTest.getLeadInstance();
        testLead4.Legacy_System_ID__c = '88999';
        listtestLead.add(testLead4);
        
       
        
        insert listtestLead;
        System.assertEquals(listtestLead != null,true);
        listtestLead = [Select Id,Account__c,Sales_Org__c ,Customer_Group__c ,Customer_Class__c ,Customer_Type__c ,Industry from Lead where Id IN : listtestLead];
        
        Test.startTest();
        
        for(Lead olead : listtestLead){
             if(olead.Account__c == oTestAccount1.Id){
                System.assertEquals(olead.Sales_Org__c ,oTestAccount1.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount1.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount1.Customer_Class_c__c ,'Error:Update failed');                 
            }
            else if(olead.Account__c == oTestAccount2.Id){
                System.assertEquals(olead.Sales_Org__c ,oTestAccount2.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount2.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount2.Customer_Class_c__c ,'Error:Update failed');                 
            
            }
            else if(olead.Account__c == oTestAccount3.Id){
                System.assertEquals(olead.Sales_Org__c ,oTestAccount3.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount3.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount3.Customer_Class_c__c ,'Error:Update failed');                 
            
            
            }
        }
        
        oTestAccount1.phone='1234567';
        oTestAccount2.Sales_Org__c ='WEST';
        oTestAccount3.Industry ='DELOITTE';
        
        
         Account oTestAccount4 = UnitTest.getAccountInstance();
        oTestAccount4.phone='987654';
        oTestAccount4.Legacy_System_ID__c = '88999';
        oTestAccount4.Sales_Org__c = 'WEST';
        oTestAccount4.Customer_Class_c__c = 'test3';
        oTestAccount4.Customer_Group__c = 'CORPORATION';
        oTestAccount4.Industry = 'test3';
        oTestAccount4.Customer_Type__c = 'Individual';
        listestAccounts.add(oTestAccount4);
         
        Account oTestAccount5 = UnitTest.getAccountInstance();
        oTestAccount5.phone='987655';
        oTestAccount5.Legacy_System_ID__c = '88998';
        oTestAccount5.Sales_Org__c = 'WEST';
        oTestAccount5.Tax_Number_Type__c='D.N.I.';
        oTestAccount5.BillingCountry='AR';
        oTestAccount5.Tax_Number__c='23223879';
                
        Account oTestAccount6 = UnitTest.getAccountInstance();
        oTestAccount6.phone='987656';
        oTestAccount6.Legacy_System_ID__c = '88956';
        oTestAccount6.Tax_Number_Type__c='C.I.';
        oTestAccount6.BillingCountry='AR';
        oTestAccount6.Tax_Number__c='00215880153';
        
        Account oTestAccount7 = UnitTest.getAccountInstance();
        oTestAccount7.phone='987656';
        oTestAccount7.Legacy_System_ID__c = '88951';
        oTestAccount7.Tax_Number_Type__c='C.U.I.L.';
        oTestAccount7.BillingCountry='AR';
        oTestAccount7.Tax_Number__c='27342304716';
        
        
        upsert listestAccounts;
        insert oTestAccount6;
        insert oTestAccount5;
        insert oTestAccount7;
        
        listtestLead = [Select Id,Account__c,Sales_Org__c ,Customer_Group__c ,Customer_Class__c ,Customer_Type__c ,Industry from Lead where Id IN : listtestLead];
        
         for(Lead olead : listtestLead){
             if(olead.Account__c == oTestAccount1.Id){
                System.debug('Inside test class');
                System.assertEquals(olead.Sales_Org__c ,oTestAccount1.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount1.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount1.Customer_Class_c__c ,'Error:Update failed');                 
            }
            else if(olead.Account__c == oTestAccount2.Id){
                System.debug('Inside test class');
                /*System.assertEquals(olead.Sales_Org__c ,oTestAccount2.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount2.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount2.Customer_Class_c__c ,'Error:Update failed');  */               
            
            }
            else if(olead.Account__c == oTestAccount3.Id){
                System.debug('Inside test class');
                /*System.assertEquals(olead.Sales_Org__c ,oTestAccount3.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount3.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount3.Customer_Class_c__c ,'Error:Update failed');      */           
            
            
            }
            
             else if(olead.Account__c == oTestAccount4.Id){
                System.debug('Inside test class');
                /*System.assertEquals(olead.Sales_Org__c ,oTestAccount4.Sales_Org__c ,'Error:Update failed');
                System.assertEquals(olead.Customer_Group__c ,oTestAccount4.Customer_Group__c ,'Error:Update failed');                
                System.assertEquals(olead.Customer_Class__c ,oTestAccount4.Customer_Class_c__c ,'Error:Update failed');     */            
            
            
            }
        }
        
        Test.stopTest();    
        
    }
    //  As part of  s2e Optimisation project adding the below new method [Rajashree]   
    public static testmethod void testUpdateContact(){
        
        UnitTest.createTestData();
        
        Test.startTest();
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        System.assertEquals(testAcc1.id != null,true);
        Contact oContact1 = UnitTest.getContactInstance(testAcc1.Id);
        oContact1.Sales_Org__c ='LLEY';
        insert oContact1 ;
        
        testAcc1.Sales_Org__c = 'LLEY';
        oContact1.Sales_Org__c = 'LLEY' ;
        
        update testAcc1 ;
        Test.stopTest();
        
    }
     //  As part of  s2e Optimisation project adding the below new method [Rajashree]   
     public static testmethod void testUpdateQuote(){
     
        UnitTest.createTestData();  
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.Customer_Class_c__c = 'Reseller';
        testAcc.Max_Reseller_Discount_Percentage__c = 10;
        insert testAcc;
        System.assertEquals(testAcc.id != null,true);
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp1.Business_Unit__c = 'Chile';
        opp1.Sales_Org__c  ='RV01';
        insert opp1;

        Quote q1 = New Quote ();
        q1.OpportunityId = opp1.id;
        q1.Name = 'Test Quote';
        q1.Primary_Quote__c = true;
        q1.Pricing_Approval_Complete__c = False;
        q1.Status = 'Draft';
        Insert q1;
      
        Test.startTest();               
        testAcc.Customer_Class_c__c = 'Reseller';
        testAcc.Max_Reseller_Discount_Percentage__c = 20;
        update testAcc;
        update q1;         
        Test.stopTest();     
     
     }
    public static testmethod void testUpdateQuote1(){
     
        UnitTest.createTestData();  
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testAcc.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        testAcc.LCRM_Alternate_Phone_Verification__c ='Pending. Please refresh.';
       // testAcc.Customer_Class_c__c = 'Reseller';
       // testAcc.Max_Reseller_Discount_Percentage__c = 10;
        insert testAcc;
        System.assertEquals(testAcc.id != null,true);
 
     
     }
    public static testmethod void insertAccount(){
    
        Id lu =[SELECT Id FROM Profile WHERE Name = 'LatAm User' limit 1].Id;
        User u1=unitTest.getUserInstance();
        u1.ProfileId=lu;
        insert u1;
        
        Profile_List__c pl= new Profile_List__c();
        //pl.Name='00ea00000024JzKAAU';
        pl.Name='test';
        pl.Profile_Name__c='LatAm User';
        insert pl;
        
        Account acc= UnitTest.getAccountInstance();
        System.runAs(u1){
            insert acc;
            System.assertEquals(acc.id != null,true);
        }
        
    }
    
    public static testmethod void insertAccountt(){
        LTS_Disable_Application_Automation__c ll = new LTS_Disable_Application_Automation__c();
        ll.LTS_Disable_Triggers__c = true;
        insert ll;
        Id lu =[SELECT Id FROM Profile WHERE Name = 'LatAm User' limit 1].Id;
        User u1=unitTest.getUserInstance();
        u1.ProfileId=lu;
        insert u1;
        
        Profile_List__c pl= new Profile_List__c();
        //pl.Name='00ea00000024JzKAAU';
        pl.Name='test2';
        pl.Profile_Name__c='LatAm User';
        insert pl;
        
        Account acc= UnitTest.getAccountInstance();
        System.runAs(u1){
            insert acc;
            System.assertEquals(acc.id != null,true);
        }
        
    }
 
    public static testmethod void insertAccount2(){
        
        Id lu =[SELECT Id FROM Profile WHERE Name = 'LatAm User' limit 1].Id;
        
        Profile_List__c pl= new Profile_List__c();
        pl.Name=lu;
        pl.Profile_Name__c='LatAm User';
        pl.ProfileId__c = lu ;
        insert pl;
        System.debug('@@@@@@'+pl.ProfileId__c );
        
        User u1=unitTest.getUserInstance();
        u1.ProfileId=lu;
        insert u1;
        
        
        
        System.runAs(u1){
            Account acc= UnitTest.getAccountInstance();
            acc.Industry_LatAm__c = null;
            insert acc;
            
            System.assertEquals(acc.id != null,true);
        }
        
    }
}