@istest
public class ESC_CommissionsTest{
    //Case Creation Alert
    //Case waiting for Response Notification
    //Commissions Close Wating update
    //Closed case notification for ICP
    public static testmethod void testDataSetUp() {
    Test.startTest();
       /* KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
         */
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='SCS Inquiry' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);        
       insert u1;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       List<case> lstcase = new List<case>();
        system.runas(u1){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ - ';
       gliCase.Status = 'Open';
       gliCase.LCRM_Sub_BU__c = 'US';
       gliCase.Salesperson__c=u1.id;
       gliCase.AccountID = gliAccount.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       gliCase.status = 'Waiting for Response';
       update gliCase;
       
       gliCase.status = 'Closed';
       gliCase.Resolver_Code__c = 'Compensation Operations';
       gliCase.Sub_Resolver_Code__c = 'Exception - modify award (sales/renewal)';
       //update gliCase;
       lstcase.add(gliCase);
       
       Case gliCase2 = UnitTest.getCaseInstance();
       gliCase2.Subject = 'CPQ - ';
       gliCase2.Status = 'New';
       gliCase2.LCRM_Sub_BU__c = 'US';
       gliCase2.Salesperson__c=u1.id;
       gliCase2.AccountID = gliAccount.Id;
       gliCase2.RecordTypeId=caseRT.Id;
       insert gliCase2;
       gliCase2.Status='Open';
       lstcase.add(gliCase2);
       update lstcase;
        }
      
        Test.stopTest();    
    }
    //New Case Email
    //Case Closed Email
        public static testmethod void testDataSetUp2() {
    Test.startTest();
        
       
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='LatAm' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newsUser', email='usser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440s20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);        
       insert u1;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(gliAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
        system.runas(u1){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ';
       gliCase.Status = 'New';
       gliCase.LCRM_Sub_BU__c = 'US';
       gliCase.AccountID = gliAccount.Id;
        gliCase.ContactID = testContact.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       gliCase.Status = 'Closed';
        update gliCase;
        
        }
      
        Test.stopTest();    
    }
    //Account Archive Closed Notification 
    //Account Archive Closed Notification Portuguese
    public static testmethod void testDataSetUp3() {
    Test.startTest();
        
       
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='Archive Requests' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newsUr', email='usser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440s20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true,Language__c='English');
User u2 = new User(alias = 'newsUz', email='ussser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440ss20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertestinsg01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true,Language__c='Portuguese (Brazil)');                           
       insert u1;
       insert u2;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(gliAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
        system.runas(u1){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ';
       gliCase.Description = 'test';
       gliCase.Type = 'Archive';
       gliCase.Status = 'New';
       gliCase.LCRM_Sub_BU__c = 'US';
       gliCase.AccountID = gliAccount.Id;
        gliCase.ContactID = testContact.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       glicase.status='Closed';
       gliCase.Closed_Action__c='Completed';
       update glicase;
       
        }
        
        system.runas(u2){
       Case gliCase2 = UnitTest.getCaseInstance();
       gliCase2.Subject = 'CPQ';
       gliCase2.Description = 'test';
       gliCase2.Type = 'Archive';
       gliCase2.Status = 'New';
       gliCase2.LCRM_Sub_BU__c = 'US';
       gliCase2.AccountID = gliAccount.Id;
        gliCase2.ContactID = testContact.Id;
       gliCase2.RecordTypeId=caseRT.Id;
       insert gliCase2;
       glicase2.status='Closed';
       gliCase2.Closed_Action__c='Completed';
       update glicase2;
       
        }
      
        Test.stopTest();    
    }
    //Account Archive Closed Notification Spanish
    public static testmethod void testDataSetUp4() {
    Test.startTest();
        
       
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='Archive Requests' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newsUr', email='usser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440s20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);
User u2 = new User(alias = 'newsUz', email='ussser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440ss20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertestinsg01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true,Language__c='Spanish');                           
       insert u1;
       insert u2;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(gliAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
        system.runas(u2){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ';
       gliCase.Description = 'test';
       gliCase.Type = 'Archive';
       gliCase.Status = 'New';
       gliCase.LCRM_Sub_BU__c = 'US';
       gliCase.AccountID = gliAccount.Id;
        gliCase.ContactID = testContact.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       glicase.status='Closed';
       gliCase.Closed_Action__c='Completed';
       update glicase;
       
        }
        
        system.runas(u2){
       Case gliCase2 = UnitTest.getCaseInstance();
       gliCase2.Subject = 'CPQ';
       gliCase2.Description = 'test';
       gliCase2.Type = 'Archive';
       gliCase2.Status = 'New';
       gliCase2.LCRM_Sub_BU__c = 'US';
       gliCase2.AccountID = gliAccount.Id;
        gliCase2.ContactID = testContact.Id;
       gliCase2.RecordTypeId=caseRT.Id;
       insert gliCase2;
       glicase2.status='Closed';
       gliCase2.Closed_Action__c='Completed';
       update glicase2;
       
        }
      
        Test.stopTest();    
    }
    //Send email alert when ANZ Support Type equals Customer Care
    //Send email alert when ANZ Support Type equals ServiceFirst
    //Send email alert when ANZ Support Type equals Technical Care
    public static testmethod void testDataSetUp5() {
    Test.startTest();
        
       
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='ANZ' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newxUser', email='usser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440s20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertessting01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);        
       insert u1;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(gliAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
        system.runas(u1){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ';
       gliCase.Status = 'New';
       gliCase.ANZ_Support_Type__c = 'Customer Care';
       gliCase.AccountID = gliAccount.Id;
        gliCase.ContactID = testContact.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       
       Case gliCase2 = UnitTest.getCaseInstance();
       gliCase2.Subject = 'CPQ';
       gliCase2.Status = 'New';
       gliCase2.ANZ_Support_Type__c = 'ServiceFirst';
       gliCase2.AccountID = gliAccount.Id;
        gliCase2.ContactID = testContact.Id;
       gliCase2.RecordTypeId=caseRT.Id;
       insert gliCase2;
      
      Case gliCase3 = UnitTest.getCaseInstance();
       gliCase3.Subject = 'CPQ';
       gliCase3.Status = 'New';
       gliCase3.ANZ_Support_Type__c = 'Technical Care';
       gliCase3.AccountID = gliAccount.Id;
        gliCase3.ContactID = testContact.Id;
       gliCase3.RecordTypeId=caseRT.Id;
       insert gliCase3;
        
        }
      
        Test.stopTest();    
    }
    //Argentina – Case opened Notifications(24 and 48)
    //Brazil - Case opened Notifications(24 and 48)
    public static testmethod void testDataSetUp6() {
    Test.startTest();
        
       
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='ANZ' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newxUser', email='usser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440s20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertessting01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);        
       insert u1;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(gliAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
        system.runas(u1){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ';
       gliCase.Status = 'Active';
       gliCase.Sales_Org__c = 'LLEY';
       gliCase.AccountID = gliAccount.Id;
        gliCase.ContactID = testContact.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       
       Case gliCase2 = UnitTest.getCaseInstance();
       gliCase2.Subject = 'CPQ';
       gliCase2.Status = 'Active';
       gliCase.Sales_Org__c = 'RV01';
       gliCase2.AccountID = gliAccount.Id;
        gliCase2.ContactID = testContact.Id;
       gliCase2.RecordTypeId=caseRT.Id;
       insert gliCase2;
      
        }
      
        Test.stopTest();    
    }
    
    //Case Owner Not Queue
    //LatAm Grace Period Entitlement Email
    public static testmethod void testDataSetUp7() {
    Test.startTest();
        
       
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='ANZ' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='System Administrator'];   
       User u1 = new User(alias = 'newxUser', email='usser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440s20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertessting01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true);        
       insert u1;
       
       User u2 = new User(alias = 'newssUz', email='ussser@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='01440ss20',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertsdestinsg01s2@mydomain.com',Rep_Type_Description__c='test',ICP_Admin__c=true,Language__c='Spanish');
                           
        insert u2;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(gliAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
        system.runas(u1){
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ';
       gliCase.Status = 'New';
       gliCase.Escalation_Level_Number__c  = 2;
       gliCase.AccountID = gliAccount.Id;
        gliCase.ContactID = testContact.Id;
       gliCase.RecordTypeId=caseRT.Id;
       gliCase.Old_Owner__c  = u2.id;
       insert gliCase;
       glicase.ownerId = u2.id;
       gliCase.Escalation_Level_Number__c  = 1;
       update glicase;
       
       Case gliCase2 = UnitTest.getCaseInstance();
       gliCase2.Subject = 'CPQ';
       gliCase2.Status = 'New';
       gliCase.Approval_Status__c = 'Approved';
       gliCase.Reason__c  = 'Grace Period Extension';
       gliCase.Entitlement_Email__c   = 'testemail@tr.com';
       gliCase2.AccountID = gliAccount.Id;
        gliCase2.ContactID = testContact.Id;
       gliCase2.RecordTypeId=caseRT.Id;
       insert gliCase2;
      gliCase2.status='Closed';
      gliCase.Reason__c  = 'Grace Period Extension';
       
      update gliCase2;
      
        }
      
        Test.stopTest();    
    }
    
    
    }