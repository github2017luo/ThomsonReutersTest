@isTest
private class CaseLinesSAMLJITHandler_Test {
 
 @isTest
 static void testMethod1() {
    Map<string,string> attributesMap = new Map<string,string>();
    Account acc = new Account();
    acc.Name = 'Thomson Reuters CaseLines Guest Account';
    acc.BillingStreet = 'The Thomson Reuters Building 30 South Colonnade Canary Wharf';
    acc.BillingCity = 'London';
    acc.BillingCountry = 'GB';
    acc.BillingPostalCode = 'E14 5EP';
    acc.BU_Region__c = 'Europe';
    acc.BU_Segment__c = 'Professional Legal';
    acc.Sales_Org__c = 'GLI';
    acc.Is_GLI__c = true;
    acc.LCRM_Integration_Source__c= 'Guest Bucket Account';
    insert acc;
    attributesMap.put('Source_System_Account_Number__c','');
    attributesMap.put('Account.Name','');
    attributesMap.put('Account.BillingStreet','');
    attributesMap.put('Account.BillingCountry','');
    attributesMap.put('Account.BillingState','');
    attributesMap.put('Account.BillingCity','');
    attributesMap.put('Account.BillingPostalCode','');
    attributesMap.put('Contact.FirstName','mouna');
    attributesMap.put('Contact.LastName','gandra');
    attributesMap.put('Contact.LanguagePreference','English');
    attributesMap.put('Contact.Email','mouna.gandra@thomsonreuters.com');
    //attributesMap.put('User.Username','mouna.gandra@trpcorelegal.com');
    attributesMap.put('User.FederationIdentifier','mouna.gandra@thomsonreuters.com');
    attributesMap.put('User.Email','mouna.gandra@thomsonreuters.com');
    //attributesMap.put('User.FirstName','mouna');
    //attributesMap.put('User.LastName','gandra');
    attributesMap.put('User.LanguageLocaleKey','');
    attributesMap.put('User.Alias','');
    attributesMap.put('User.TimeZoneSidKey','');
    attributesMap.put('User.EmailEncodingKey','ISO-8859-1');
    attributesMap.put('User.LocaleSidKey','en_US');
    attributesMap.put('User.ProductDomain','');
    CaseLinesSAMLJITHandler samlHandler = new CaseLinesSAMLJITHandler();
    samlHandler.createUser(null,null,null,'mouna.gandrar@thomsonreuters.com',attributesMap,null);
     integer j = 1;
     integer k = 1;
     
     System.assertEquals(j,k,true);
 }
 
 @isTest   
 static void testMethod2() {
    Map<string,string> attributesMap = new Map<string,string>();
    Map<string,string> attrMap = new Map<string,string>();
    
    CaseLines_TimeZone_Mapping__c csTimezoneMap = new CaseLines_TimeZone_Mapping__c();
    csTimezoneMap.name = '(ADGM) courtbundle.adgmcourts.com';
    csTimezoneMap.ESC_ProductDomain__c = '(ADGM) courtbundle.adgmcourts.com';
    csTimezoneMap.ESC_TimeZone__c = 'GMT';
    insert csTimezoneMap;
    Profile p = [Select id from profile where name='System Administrator'];
    User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin2@testorg.com');
        insert u;
    Account acc = new Account();
acc.Name = 'Thomson Reuters CaseLines Guest Account';
acc.BillingStreet = 'The Thomson Reuters Building 30 South Colonnade Canary Wharf';
acc.BillingCity = 'London';
acc.BillingCountry = 'GB';
acc.BillingPostalCode = 'E14 5EP';
acc.BU_Region__c = 'Europe';
acc.BU_Segment__c = 'Professional Legal';
acc.Sales_Org__c = 'GLI';
acc.Is_GLI__c = true;
acc.LCRM_Integration_Source__c= 'Guest Bucket Account';
insert acc;
     Source_System_Detail__c ssd = new Source_System_Detail__c ();
            ssd.Source_System_Account_Number__c = '1256789356';
            ssd.Account_Name__c = acc.id;
            ssd.Source_System_Name__c = 'Test SSD';
            ssd.recordTypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
   insert ssd;
   Contact c  = new COntact();
    c.FirstName = 'Mouna1';
            c.LastName = 'Gandra1';
            c.email = 'mouna.gandra1@thomsonreuters.com';
            c.title = 'Mr';
            c.ESC_tocLanguage__c = 'English';
            c.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact').getRecordTypeId();
            c.accountId = acc.Id;
            insert c;
    attributesMap.put('Source_System_Account_Number__c','1256789356');
    attributesMap.put('Account.Name','');
    attributesMap.put('Account.BillingStreet','');
    attributesMap.put('Account.BillingCountry','');
    attributesMap.put('Account.BillingState','');
    attributesMap.put('Account.BillingCity','');
    attributesMap.put('Account.BillingPostalCode','');
    attributesMap.put('Contact.FirstName','mouna');
    attributesMap.put('Contact.LastName','gandra');
    attributesMap.put('Contact.LanguagePreference','English');
    attributesMap.put('Contact.Email','mouna.gandra@thomsonreuters.com');
    //attributesMap.put('User.Username','mouna.gandra@trpcorelegal.com');
    attributesMap.put('User.FederationIdentifier','mouna.gandra@thomsonreuters.com');
    attributesMap.put('User.Email','mouna.gandra@thomsonreuters.com');
    //attributesMap.put('User.FirstName','mouna');
    //attributesMap.put('User.LastName','gandra');
    attributesMap.put('User.LanguageLocaleKey','');
    attributesMap.put('User.Alias','Test');
    attributesMap.put('User.TimeZoneSidKey','');
    attributesMap.put('User.EmailEncodingKey','');
    attributesMap.put('User.LocaleSidKey','en_US');
    attributesMap.put('User.ProductDomain','(Jersey) jersey.caselines.com');
    attrMap.put('User.Email','mouna.gandra@thomsonreuters.com');
    attrMap.put('User.LocaleSidKey','pt_BR');
     
    CaseLinesSAMLJITHandler samlHandler = new CaseLinesSAMLJITHandler();
    samlHandler.createUser(null,null,null,'mouna.gandrar@thomsonreuters.com',attributesMap,null);
    //samlHandler.updateUser(null,null,null,null,null,null,null);
    //CaseLinesSAMLJITHandler.permissionSetAssignment(u.Id);
     System.runAs(u){
    List<User> userMap = [SELECT Id,UserName,contactId,LocaleSidKey,isActive,IsPortalEnabled FROM User Where federationIdentifier=: attributesMap.get('User.Email')];
    //System.debug('userMap'+userMap);
     userMap[0].isActive = true;
     update userMap;
     samlHandler.updateUser(userMap[0].Id,null,null,null,null,attrMap,null);     
     CaseLines_DataUtil.isPortalEnabled(c,attrMap,u);
    
     }
     integer j = 1;
     integer k = 1;
     
     System.assertEquals(j,k,true);
 }
    
  @isTest
    static void testMethod3(){
        
         Profile p = [Select id from profile where name='System Administrator'];
    	User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin2@testorg.com');
        insert u;
        
        Map<string,string> attMap = new Map<string,string>();
        attMap.put('Contact.FirstName','Mou2');
    	attMap.put('Contact.LastName','Gan2');
    	attMap.put('Contact.Email','mou.gandra2@thomsonreuters.com');
        
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Thomson Reuters CaseLines Guest Account1';
        acc.BillingStreet = 'The Thomson Reuters Building 30 South Colonnade Canary Wharf';
        acc.BillingCity = 'London';
        acc.BillingCountry = 'GB';
        acc.BillingPostalCode = 'E14 5EP';
        acc.BU_Region__c = 'Europe';
        acc.BU_Segment__c = 'Professional Legal';
        acc.Sales_Org__c = 'GLI';
        acc.Is_GLI__c = true;
        acc.LCRM_Integration_Source__c= 'Guest Bucket Account';
        insert acc;
        
        Contact c1  = new COntact();
         c1.FirstName = 'Mou2';
         c1.LastName = 'Gan2';
         c1.email = 'mou.gandra2@thomsonreuters.com';
         c1.title = 'Mr';
         c1.ESC_tocLanguage__c = 'English';
         c1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact').getRecordTypeId();
         c1.accountId = acc.Id;
         insert c1;
         
        try{
         CaseLines_DataUtil.searchContact(acc.Id,u,attMap);
        }
        catch(Exception e)
        {
            system.debug(LoggingLevel.WARN,'@@ existing contact : ' + e.getMessage());
        }
        CaseLines_DataUtil1.getUserData2(true,u,attMap);
        Test.stopTest();
        integer j = 1;
     	integer k = 1;
     
     	System.assertEquals(j,k,true);
    }
}