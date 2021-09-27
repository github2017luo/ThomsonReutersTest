@isTest
private class GGO_ReferralPB_Test{
    static testmethod void method1(){
        test.startTest();
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
        test.stopTest();
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.Origin='Email';        
        cs.Is_GLI__c=false;
        cs.ESC_Origin_Name__c='txt';
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c  ='GGO';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();        
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        
        insert cs;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';       
        cc.ESC_referral_status__c = 'New';                
        insert cc;
        
        system.assertequals(cc.ESC_referral_status__c,'New');
        
    }
    
    static testmethod void method2(){
    
        test.startTest(); 
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
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
        test.stopTest();
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.Origin='Email';        
        cs.Is_GLI__c=false;
        cs.ESC_Origin_Name__c='txt';
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c  ='GGO';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();        
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        
        insert cs;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';      
        cc.ESC_referral_status__c = 'New';               
        insert cc;
        system.assertequals(cc.ESC_referral_status__c,'New');
        cc.ownerid = Us.id;
        update cc;
        
    }
    
    static testmethod void method3(){
    
        test.startTest();
        Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest11',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james13456.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
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
        test.stopTest();
        Case cs = new Case();
        cs.Type='Data';
        //cs.Status='Work In Progress';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.Origin='Email';        
        cs.Is_GLI__c=false;
        cs.ESC_Origin_Name__c='txt';
        cs.accountid=acct.id;
        cs.LCRM_Sub_BU__c  ='GGO';
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();        
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        //cs.ESC_UPD_Owner__c = False;
        
        insert cs;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();
        cc.ESC_Case__c = cs.id;
        cc.ESC_Role__c = 'Accountable Resolver';       
        cc.ESC_Referral_Status__c='New';            
        insert cc;
        system.assertequals(cc.ESC_referral_status__c,'New');
        cc.ESC_referral_status__c = 'Closed';
        update cc;
        
    }
}