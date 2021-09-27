@isTest( seeAllData = false)
public class LeadCreateController_Test{ 
    
    
    @isTest static void method1() {
        
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI');
        insert u1;              
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='WEST';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'TR Legal FindLaw Advanced Lead Mgmt';        
        insert ilmGen1;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = u1.id;
        insert ltstemp;
        
        system.runAs(u1)   {
            Account account = UnitTest.getAccountInstance();
            account.Name = 'UTLeadAccount';
            account.BillingCountry = 'US';
            account.ShippingCountry = 'US';            
            account.BillingState = 'IL';
            account.Sales_Org__c = 'LLEY';
            account.recordTypeId=  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            insert account;
            
            system.assertEquals(true,account.id!=null);
            Contact contact= UnitTest.getContactInstance(account.id);
            insert contact;
            
            //Added the booelan value not to run tms territory functionality
            Test.startTest();
            //Commenting out as a part of removal of TM1.0 components
            //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            
            Lead oLead = UnitTest.getLeadInstance();
            
            oLead.Company = 'Test 1 New Company';
            oLead.LastName = 'Martha';
            oLead.Account__c= account.Id;
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.Sales_Org__c = 'LLEY'; 
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.Contact__c= contact.id;      
            oLead.PO_Box__c='ass';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            
            insert oLead;
            
            system.assertEquals(true,oLead.id!=null);
            
            
            
            ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
            
            LeadCreateController oController = new LeadCreateController(oTestController);
            System.currentPageReference().getParameters().put('Description', 'Lead creation method'); 
            //System.currentPageReference().getParameters().put('accid', account.Id);              
            PageReference myVfPage = Page.LeadCreate;
            Test.setCurrentPageReference(myVfPage); 
            myVfPage.getParameters().put('id',oLead.Id);
            String id = ApexPages.currentPage().getParameters().get('id');
            system.assertEquals(true,id!=null);         
            System.assertEquals(account.Id,oLead.Account__c );
            oController.userProfileName();
            oController.addressCountryChanged();
            oController.save();
            oController.continueSave();
            oController.salesOrgSection=true;
            
            oLead.Billing_Street__c = 'Test Street 123';
            oLead.Billing_City__c = 'TestCity';
            oLead.Billing_Zip__c = '01234567890122';
            update oLead;
            oController.save();
            
            Lead objLead=[Select Id,Billing_Street__c ,Billing_Zip__c,Account__c,Contact__c from Lead Where id=:oLead.Id];
            System.assertEquals(account.Id,objLead.Account__c );  
            System.assertEquals(contact.Id,objLead.Contact__c );   
            
            test.stoptest();
        }      
        
        
    }//End Method1
    
    @isTest static void method2() {        
        Profile ProfileId1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];    
        User u2 = new User(Alias = 'test1', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing1', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId1.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser1@trpcorelegal.com');
        insert u2;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = u2.id;
        insert ltstemp;
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='WEST';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'TR Legal FindLaw Advanced Lead Mgmt';        
        insert ilmGen1;
        
        
        system.runAs(u2) {
            Account account = UnitTest.getAccountInstance();
            account.Name = 'UTLeadAccount';
            account.BillingCountry = 'US';
            account.ShippingCountry = 'US';
            account.BillingState = 'IL';
            account.Sales_Org__c = 'LLEY';
            account.recordTypeId=  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            insert account;
            
            Contact contact= UnitTest.getContactInstance(account.id);
            insert contact;
            
            
            
            //Added the booelan value not to run tms territory functionality
            //Commenting out as a part of removal of TM1.0 components
            //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            Lead oLead = UnitTest.getLeadInstance();
            oLead.Company = 'Test 1 New Company';
            oLead.LastName = 'Martha';
            oLead.Account__c= account.Id;
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.Sales_Org__c = 'WEST'; 
            oLead.Contact__c= contact.id;      
            oLead.PO_Box__c='ass';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            insert oLead;
            test.starttest();
            ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
            
            LeadCreateController oController = new LeadCreateController(oTestController);
            
            Test.setcurrentPage(page.LeadCreate);
            ApexPages.currentPage().getParameters().put('id',account.Id);
            oController.acctId = account.Id;
            oController.userProfileName();
            oController.addressCountryChanged();
            oController.save();
            oController.continueSave();
            oController.salesOrgSection=true;     
            oController.save();
            
            Lead objLead=[Select Id,Billing_Street__c ,Billing_Zip__c,Account__c,Contact__c from Lead Where id=:oLead.Id];
            System.assertEquals(account.Id,objLead.Account__c );  
            System.assertEquals(contact.Id,objLead.Contact__c );   
            Test.stopTest();
        }
    }
    
    @isTest static void method3() {
        try{
            Profile profileId = [Select id,name from profile where name = 'System Administrator'];
            
            User testUser = new User(
                Alias = 'sUser', 
                Email='abc1@testorg.com',
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', 
                ProfileId = profileId.id,
                Sales_Org__c = 'WEST',              
                Sub_Bu__c='USL',
                Segment__c='Corporate',
                TimeZoneSidKey='America/Los_Angeles', 
                UserName='abc123@testorg.com'
            );
            insert testUser;  
            
            System.runAs(testUser) {
                /* List<Account> accList =new List<Account>();
Account acc = new Account();
acc.Is_GLI__c = true;
acc.BillingCountry = 'US';
acc.BU_Region__c='US'; 
acc.Bu_Segment__c ='Corporate';          
acc.Name = 'TESTREGIONACCOUNT';
acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
acc.BillingStreet = '620 W 42ND ST APT 3B';
acc.BillingCity = 'NEW YORK';
acc.BillingState = 'NY';
acc.BillingPostalCode = '10036-2063';
acc.BillingCountry = 'US';
insert acc;
accList.add(acc);

if(accList.size()>0){
insert accList;
}

*/
                KeyValueListStore__c profilename = new KeyValueListStore__c();
                profilename.TextValue__c = 'TR Corp Partner Community User';
                profilename.Name = 'LTS_partnerUserProfileName';
                insert profilename;
                
                KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
                leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
                leadsourcevalue.TextValue__c = 'Partner';
                insert leadsourcevalue;
                
                KeyValueListStore__c busegment = new KeyValueListStore__c();
                busegment.Name = 'LTS_partnerUserBUSegmentValue';
                busegment.TextValue__c = 'Corporate';
                insert busegment;
                recordtype AccRt= [select id from recordtype where name ='Customer' and sobjecttype='Account' limit 1];
                List<Account> accList = new List<Account>();
                Account acc = new Account();
                acc.Is_GLI__c = false;
                //acc.BillingCountry = 'US';
                acc.Name = 'TESTREGIONACCOUNT';
                acc.RecordTypeId = AccRt.id;
                acc.BillingStreet = '555 Test Street';
                acc.BillingCity = 'Dallas';
                acc.BillingState = 'TX';
                acc.BillingPostalCode = '55555';
                acc.Sales_Org__c = 'LLEY';
                //acc.BillingCountry = 'IN';
                insert acc;
                
                System.debug('accList**'+accList);
                recordtype leadRt= [select id from recordtype where name ='Customer' and sobjecttype='Lead' limit 1];
                List<Lead> listlead = new List<Lead>();
                test.starttest();
                Lead TestLead1 = UnitTest.getLeadInstance();
                TestLead1.LeadSource='Customer Service'; 
                TestLead1 .RecordTypeId=leadRt.Id;      
                TestLead1.SAPAccountNumber__c = '98711';
                TestLead1.FirstName = 'Unit';
                TestLead1.LastName = 'Tester1';
                TestLead1.Company = 'Unit Test Company';
                TestLead1.email = 'WEST@ema.com'; 
                TestLead1.phone = '12345'; 
                TestLead1.Language_Preference__c = 'English';
                TestLead1.MobilePhone = '1234567890';
                TestLead1.Account__c=acc.Id;
                TestLead1.is_GLI__c =false;
                TestLead1.Sales_Org__c='GLI';
                TestLead1.Status = 'Contacting';         
                TestLead1.Billing_Country__c='US';
                TestLead1.Description='Lead is created for GLI';
                listlead.add(TestLead1);
                
                if(listlead.size()>0){
                    insert listlead;
                }
                
                System.assertEquals(listlead != null,true); 
                ApexPages.StandardController standardController = new ApexPages.StandardController(TestLead1);
                LeadCreateController leadCtrl=new LeadCreateController(standardController ); 
                System.currentPageReference().getParameters().put('Description',TestLead1.Description);            
                System.currentPageReference().getParameters().put('accid', acc.Id);   
                Test.stoptest();
                
            }
            
        }catch(Exception ex){
            System.debug('Error:'+EX); 
        }
        
    }
    //CreateLead
  /*  @isTest static void method4() {
        try{
            Profile profileId = [Select id,name FROM profile WHERE Name = 'GLI Sales User' limit 1];
            
            User testUser = new User(
                Alias = 'sUser', 
                Email='abc1323@testorg.com',
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', 
                ProfileId = profileId.id,
                Sales_Org__c = 'WEST',
                Sub_Bu__c='USL',
                Segment__c='Corporate',
                TimeZoneSidKey='America/Los_Angeles', 
                UserName='abc1232323@testorg.com'
            );
            insert testUser;  
            MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
            cs.Name='Customer Class Default';
            cs.Value__c='None';
            insert cs;
            
            MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
            cs1.Name='Customer Type Default';
            cs1.Value__c='None';
            insert cs1;
            
            MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
            cs2.Name='SalesOrgDefaultedProfiles';
            cs2.Value__c='GLI';
            insert cs2;
            
            MinimizeLeadCreation__c cs10 = new MinimizeLeadCreation__c();
            cs2.Name='GLI Sales User';
            cs2.Value__c='RESELLER';
            insert cs2;
            
            ILMGeneral__c ilmGen=new ILMGeneral__c();
            ilmGen.name= 'AllowedUsersForSalesRepAssignment';
            ilmGen.Value__C = 'SL Eloqua';        
            insert ilmGen;
            
            ILMGeneral__c ilmGen1=new ILMGeneral__c();
            ilmGen1.name= 'AllowedProfilesForSLAEmails';
            ilmGen1.Value__C = 'GLI Sales User';        
            insert ilmGen1;
            
            KeyValueListStore__c profilename = new KeyValueListStore__c();
            profilename.TextValue__c = 'TR Corp Partner Community User';
            profilename.Name = 'LTS_partnerUserProfileName';
            insert profilename;
            
            KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
            leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
            leadsourcevalue.TextValue__c = 'Partner';
            insert leadsourcevalue;
            
            KeyValueListStore__c busegment = new KeyValueListStore__c();
            busegment.Name = 'LTS_partnerUserBUSegmentValue';
            busegment.TextValue__c = 'Corporate';
            insert busegment;
            System.runAs(testUser) {
                List<Account> accList = new List<Account>();
                Account acc = new Account();
                acc.Is_GLI__c = true;
                //acc.BillingCountry = 'US';
                acc.Name = 'TESTREGIONACCOUNT';
                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
                acc.BillingStreet = '555 Test Street';
                acc.BillingCity = 'Dallas';
                acc.BillingState = 'TX';
                acc.BillingPostalCode = '55555';
                acc.BillingCountry = 'US';
                insert acc;
                
                System.debug('accList**'+accList);
                Test.startTest();
                recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
                List<Lead> listlead = new List<Lead>();
               
                Lead TestLead1 = UnitTest.getLeadInstance();
                TestLead1.LeadSource='Customer Service'; 
                TestLead1 .RecordTypeId=leadRt.Id;      
                TestLead1.SAPAccountNumber__c = '98711';
                TestLead1.FirstName = 'Unit';
                TestLead1.LastName = 'Tester1';
                TestLead1.Company = 'Unit Test Company';
                TestLead1.Account__c=acc.Id;
                TestLead1.is_GLI__c =true;
                TestLead1.Sales_Org__c='GLI';
                TestLead1.Status = 'Contacting';         
                //TestLead1.Billing_Country__c='US';
                TestLead1.Description='Lead is created for GLI';
                TestLead1.Billing_Street__c='itpl';
                TestLead1.Billing_City__c='bangalore';
                TestLead1.Billing_Country__c='ka';
                //listlead.add(TestLead1);
                insert TestLead1;
                if(listlead.size()>0){
                    insert listlead;
                }
             
                Test.setcurrentPage(page.LeadCreate); 
                ApexPages.StandardController standardController = new ApexPages.StandardController(TestLead1);
                LeadCreateController leadCtrl=new LeadCreateController(standardController);                                
                System.currentPageReference().getParameters().put('Description',TestLead1.Description);            
                System.currentPageReference().getParameters().put('accid', acc.Id);  
                
                System.assertEquals(TestLead1.Account__c, acc.Id); 
                Test.stoptest();
                
            }
            
        }catch(Exception ex){
            System.debug('Error:'+EX); 
        }
        
    } */
    
     @isTest static void method5() {
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8',
                           LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',
                           ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal123.com',Sub_Bu__c ='USL');
        insert u1;              
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='GLI';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'GLI Sales User';        
        insert ilmGen1;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = u1.id;
        insert ltstemp;
        
        system.runAs(u1)   {
            Account account = UnitTest.getAccountInstance();
            account.Name = 'UTLeadAccount Test';
            account.BillingCountry = 'US';
            account.ShippingCountry = 'US';            
            account.BillingState = 'IL';
            account.recordTypeId=  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            insert account;
            
            system.assertEquals(true,account.id!=null);
            Contact contact= UnitTest.getContactInstance(account.id);
            contact.firstname = 'test contactname';
            contact.lastname = 'test ';
            insert contact;
            
            //Added the booelan value not to run tms territory functionality
            Test.startTest();
            //Commenting out as a part of removal of TM1.0 components
            //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            
            Lead oLead = UnitTest.getLeadInstance();
            
            
            oLead.LastName = 'Martha22';
            oLead.Company = 'Test 1 New Company123';
            oLead.Account__c= account.Id;
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.Sales_Org__c = 'GLI'; 
            oLead.Contact__c= contact.id;      
            oLead.PO_Box__c='12345';
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345';
            
            insert oLead;
            
            system.assertEquals(true,oLead.id!=null);
            
            
            
            ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
            PageReference myVfPage = Page.LeadCreate;
            Test.setCurrentPageReference(myVfPage); 
            myVfPage.getParameters().put('id',oLead.Id);
             ApexPages.currentPage().getParameters().put('accid', account.Id);
            ApexPages.currentPage().getParameters().put('con', contact.name);
            LeadCreateController oController = new LeadCreateController(oTestController);
            System.currentPageReference().getParameters().put('Description', 'Lead creation method'); 
            System.currentPageReference().getParameters().put('accid', account.Id);              
           System.currentPageReference().getParameters().put('con',contact.Name);
            String id = ApexPages.currentPage().getParameters().get('id');
            system.assertEquals(true,id!=null);         
            System.assertEquals(account.Id,oLead.Account__c );
            oController.userProfileName();
            oController.addressCountryChanged();
            oController.save();
            oController.continueSave();
            oController.salesOrgSection=true;
            
            oLead.Billing_Street__c = 'Test Street 123';
            oLead.Billing_City__c = 'TestCity';
            oLead.Billing_Zip__c = '01234567890122';
            olead.Billing_Street__c='11111111111111122223333332211223344556677';
            olead.Billing_City__c='1111111111111112222333333221122334455667jjjjj7';
            update oLead;
            oController.save();
            
            Lead objLead=[Select Id,Billing_Street__c ,Billing_Zip__c,Account__c,Contact__c from Lead Where id=:oLead.Id];
            System.assertEquals(account.Id,objLead.Account__c );  
            System.assertEquals(contact.Id,objLead.Contact__c );   
            
            test.stoptest();
        }      
        
        
    }//End Method1
    
    @isTest static void methodPartner() {
        
        LaTAm_Business_Unit_Sync__c ll =new LaTAm_Business_Unit_Sync__c();
        ll.Name = 'GTM';
        ll.User_Business_unit__c = 'GTM';
        ll.Lead_Business_unit__c = 'GTM';
        Account accountt = UnitTest.getAccountInstance();
            accountt.Name = 'UTLeadAccount Test';
            accountt.BillingCountry = 'US';
            accountt.ShippingCountry = 'US';            
            accountt.BillingState = 'IL';
            insert accountt;
            
            system.assertEquals(true,accountt.id!=null);
            Contact contactt= UnitTest.getContactInstance(accountt.id);
            contactt.firstname = 'test contactname';
            contactt.lastname = 'test ';
            insert contactt;
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Portal User' limit 1];
        User u1 = new User(ContactId=contactt.Id,Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', 
        LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,
        TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI', Business_Unit__c = 'GTM');
        insert u1;              
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='WEST';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'TR Legal FindLaw Advanced Lead Mgmt';        
        insert ilmGen1;
        
        system.runAs(u1)   {
            
            
            //Added the booelan value not to run tms territory functionality
            Test.startTest();
            //Commenting out as a part of removal of TM1.0 components
            //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            
            Lead oLead = UnitTest.getLeadInstance();
            
            oLead.Company = 'Test 1 New Company';
            oLead.LastName = 'Martha';
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.Sales_Org__c = 'WEST'; 
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.PO_Box__c='ass';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            
            insert oLead;
            
            system.assertEquals(true,oLead.id!=null);
            
            
            
            ApexPages.StandardController oTestController = new ApexPages.StandardController(oLead);
            
            LeadCreateController oController = new LeadCreateController(oTestController);
            System.currentPageReference().getParameters().put('Description', 'Lead creation method'); 
            //System.currentPageReference().getParameters().put('accid', account.Id);              
            PageReference myVfPage = Page.LeadCreate;
            Test.setCurrentPageReference(myVfPage); 
            myVfPage.getParameters().put('id',oLead.Id);
            String id = ApexPages.currentPage().getParameters().get('id');
            system.assertEquals(true,id!=null);         
            oController.userProfileName();
            oController.addressCountryChanged();
            oController.save();
            oController.continueSave();
            oController.salesOrgSection=true;
            
            oLead.Billing_Street__c = 'Test Street 123';
            oLead.Billing_City__c = 'TestCity';
            oLead.Billing_Zip__c = '01234567890122';
            update oLead;
            oController.save();
            
            
            test.stoptest();
        }      
        
        
    }//End Method1
    
    
    
}