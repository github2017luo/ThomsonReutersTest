/**************************************************************************************
/*
Version     : 1.0
Name        : SalesforceLicenseManagerTest
Function    : Test methods for Salesforce License Manager application
*/
/**************************************************************************************/

@isTest
private class SalesforceLicenseManagerTest 
{
    
    static User getTestUser(boolean status, Id profileId, integer i) 
    {
        User inFrequentUser = new User();
        inFrequentUser.Username = 'Infrequent' + i + '@user.com';
        inFrequentUser.LastName = 'User';
        inFrequentUser.Email = 'infrequent.user' + i + '@tr.com';
        inFrequentUser.alias = 'IFU' + i;
        inFrequentUser.TimeZoneSidKey = 'Europe/London';
        inFrequentUser.LocaleSidKey = 'en_US';
        inFrequentUser.EmailEncodingKey = 'ISO-8859-1';
        inFrequentUser.LanguageLocaleKey = 'en_US';
        inFrequentUser.isActive = status;
        inFrequentUser.ProfileId = profileId;
        inFrequentUser.employeeNumber = 'X0909090-' + i;
        inFrequentUser.FederationIdentifier = 'X0909090-' + i; 
        inFrequentUser.Infrequent_User__c = true;
        inFrequentUser.Infrequent_User_Timeout__c = 1.0;
        
        return inFrequentUser;
    }
    
    static License_Manager_Settings__c createTestSettings() 
    {
        License_Manager_Settings__c settings = new License_Manager_Settings__c();
        settings.Bypass_Triggers__c = false;
        settings.Objects_to_Monitor__c = 'Account, Contact';
        settings.Monitoring_Time_Period_in_min__c = 30;
        settings.Deactivation_Slide_out_in_min__c = 30;
        settings.Notification_Email__c = 'test.user@licensemanager.tr.com';
        insert settings;  
        
        return settings;
    }
    
    static User_License_Activation_Log__c getUserLicenseActivationLog(User inFrequentUser, Datetime dtDeactivationDate) 
    {
        User_License_Activation_Log__c log = new User_License_Activation_Log__c();
        log.User__c = inFrequentUser.Id;
        log.Unique_Id__c = inFrequentUser.Id;
        log.Deactivate_User__c = false;
        log.Deactivation_Date__c = dtDeactivationDate;
        
        return log;
    }
                 
    static Account getAccount(Id inFrequentUserId, Integer i)
    {
        Account acc = new Account();
        acc.Name = 'test account' + String.valueOf(Datetime.now());
        acc.CreatedById = inFrequentUserId;
        acc.LastModifiedById = inFrequentUserId;
        
        acc.ShippingStreet = 'high street';
        acc.ShippingCity = 'London';
        acc.ShippingPostalCode = 'P' + i;   
        acc.ShippingState = 'GJ';                     
        acc.ShippingCountry = 'IN';
        
        acc.BillingStreet = acc.ShippingStreet;
        acc.BillingCity = acc.ShippingCity;
        acc.BillingPostalCode = acc.ShippingPostalCode;   
        acc.BillingState = acc.ShippingState;                     
        acc.BillingCountry = acc.ShippingCountry;

        return acc;
    }
    
    static Contact getContact(Account acc, Id inFrequentUserId, Integer i)
    {
        Contact con = new Contact();
        con.Salutation = 'M';
        con.FirstName = 'Test';
        con.LastName = 'Contact' + i;
        con.Email = 'test.contact'+i+'@testrecord.tr.com';
        con.AccountId = acc.Id;
        
        con.CreatedById = inFrequentUserId;
        con.LastModifiedById = inFrequentUserId;
        
        return con;
    }
    
    static Note getNote(Account acc, Id inFrequentUserId, Integer i)
    {
        Note note = new Note();
        note.Title = 'test note : ' + i;
        note.ParentId = acc.Id;
        
        note.CreatedById = inFrequentUserId;
        note.LastModifiedById = inFrequentUserId;
        
        return note;
    }
                 
    
    
    static testmethod void testUserDectivationSlideoutInBulk()
    {
        Set<Id> inFrequentUserIds = new Set<Id>();
        
        Test.startTest();
        
        License_Manager_Settings__c settings = SalesforceLicenseManagerTest.createTestSettings();
        settings.Objects_to_Monitor__c = 'Note';
        update settings;
        System.assert(settings.Id != null);

        Datetime dtDeactivationDate = Datetime.now().addMinutes(1);
        System.debug('## dtDeactivationDate : ' + dtDeactivationDate);

        Integer bulkSize = 200;
        
        List<User> lstInFrequentUser = new List<User>();
        Id adminProfileId = [select Id from Profile where Name='System Administrator'].Id;

        for(Integer i = 0; i < bulkSize; i++)
        {
            User inFrequentUser = SalesforceLicenseManagerTest.getTestUser(true, adminProfileId, i);
            lstInFrequentUser.add(inFrequentUser);
        }
        
        if(lstInFrequentUser.size() > 0)
        {
            insert lstInFrequentUser;
            System.debug('## lstInFrequentUser : ' + lstInFrequentUser);
        
            List<User_License_Activation_Log__c> lstULAL = new List<User_License_Activation_Log__c>();
            
            for(User inFrequentUser : lstInFrequentUser)
            {
                System.assert(inFrequentUser.Id != null);
                inFrequentUserIds.add(inFrequentUser.Id);
                
                User_License_Activation_Log__c log = SalesforceLicenseManagerTest.getUserLicenseActivationLog(inFrequentUser, dtDeactivationDate);
                lstULAL.add(log);
            }
            
            if(lstULAL.size() > 0)
            {
                upsert lstULAL Unique_Id__c;
                System.debug('## lstULAL : ' + lstULAL);
                
                System.assert(lstULAL.size() == bulkSize);
                
                Integer i = 0;
                List<Note> lstNote = new List<Note>();
                
                Account acc = null;
                
                //TEMP PMD Scan Fix
                User_License_Activation_Log__c logtest  = [Select id,User__c from User_License_Activation_Log__c limit 1];
                
                if(acc == null)
                {
                    acc = SalesforceLicenseManagerTest.getAccount(logtest.User__c, 0);
                    insert acc;
                }
                for(User_License_Activation_Log__c log : lstULAL)
                {
                    System.assert(log.Id != null);
                    
                    /* if(acc == null)
                    {
                        acc = SalesforceLicenseManagerTest.getAccount(log.User__c, i);
                        insert acc;
                    } */
                    
                    Note note  = SalesforceLicenseManagerTest.getNote(acc, log.User__c, i);
                    i++;
                    
                    lstNote.add(note);
                }
                
                if(lstNote.size() > 0)
                {
                    insert lstNote;
                    System.debug('## lstNote : ' + lstNote);
                    
                    List<Note> lstNoteRequery = [Select Id, Title, CreatedById, LastModifiedById from Note limit 50000];
                    System.debug('## lstNoteRequery : ' + lstNoteRequery);
                    
                    
                    for(Note note : lstNote)
                    {
                        System.assert(note.Id != null);
                    }
                }
                
                for(User_License_Activation_Log__c log : lstULAL)
                {
                    log.Deactivate_User__c = true;
                }
                
                update lstULAL;
                System.debug('## lstULAL : ' + lstULAL);
            }
        }

        Test.stopTest();
        
        // system should detect that the user is active in last 30 min and reset the deactivate user flag back to false
        if(inFrequentUserIds.size() > 0)
        {
            List<User_License_Activation_Log__c> lstULAL = [Select Id, Deactivate_User__c, Deactivation_Date__c, Status__c from User_License_Activation_Log__c where Unique_Id__c in :inFrequentUserIds];
            System.debug('## lstULAL : ' + lstULAL);
            
            System.assert(lstULAL != null && lstULAL.size() > 0);
            
            for(User_License_Activation_Log__c log : lstULAL)
            {
                System.assert(log.Deactivate_User__c == false);
                System.assert(log.Status__c == 'Deactivation Delayed');
            }
        }
    } 
    

    static testmethod void testUserDectivationWithoutSlideoutInBulk()
    {
        Set<Id> inFrequentUserIds = new Set<Id>();
        
        Test.startTest();
        
        License_Manager_Settings__c settings = SalesforceLicenseManagerTest.createTestSettings();
        System.assert(settings.Id != null);

        Datetime dtDeactivationDate = Datetime.now().addMinutes(1);
        System.debug('## dtDeactivationDate : ' + dtDeactivationDate);

        Integer bulkSize = 200;
        
        List<User> lstInFrequentUser = new List<User>();
        Id adminProfileId = [select Id from Profile where Name='System Administrator'].Id;

        for(Integer i = 0; i < bulkSize; i++)
        {
            User inFrequentUser = SalesforceLicenseManagerTest.getTestUser(true, adminProfileId, i);
            lstInFrequentUser.add(inFrequentUser);
        }
        
        if(lstInFrequentUser.size() > 0)
        {
            insert lstInFrequentUser;
            System.debug('## lstInFrequentUser : ' + lstInFrequentUser);
        
            List<User_License_Activation_Log__c> lstULAL = new List<User_License_Activation_Log__c>();
            
            for(User inFrequentUser : lstInFrequentUser)
            {
                System.assert(inFrequentUser.Id != null);
                inFrequentUserIds.add(inFrequentUser.Id);
                
                User_License_Activation_Log__c log = SalesforceLicenseManagerTest.getUserLicenseActivationLog(inFrequentUser, dtDeactivationDate);
                lstULAL.add(log);
            }
            
            if(lstULAL.size() > 0)
            {
                upsert lstULAL Unique_Id__c;
                System.debug('## lstULAL : ' + lstULAL);
                
                System.assert(lstULAL.size() == bulkSize);
                
                for(User_License_Activation_Log__c log : lstULAL)
                {
                    System.assert(log.Id != null);
                    log.Deactivate_User__c = true;
                }
                
                update lstULAL;
                System.debug('## lstULAL : ' + lstULAL);
            }
        }

        Test.stopTest();
        
        if(inFrequentUserIds.size() > 0)
        {
            List<User_License_Activation_Log__c> lstULAL = [Select Id, Deactivate_User__c, Deactivation_Date__c, Status__c from User_License_Activation_Log__c where Unique_Id__c in :inFrequentUserIds];
            System.debug('## lstULAL : ' + lstULAL);
            
            System.assert(lstULAL != null && lstULAL.size() > 0);
            
            for(User_License_Activation_Log__c log : lstULAL)
            {
                System.assert(log.Deactivate_User__c == true);
                System.assert(log.Status__c == 'Deactivated');
            }
        }
    } 
    
    static testmethod void testSAMLJITHandler()
    {
        Test.startTest();

        List<User> lstInFrequentUser = new List<User>();
        Id adminProfileId = [select Id from Profile where Name='System Administrator'].Id;

        User inFrequentUser = SalesforceLicenseManagerTest.getTestUser(false, adminProfileId, 0);
        insert inFrequentUser;
        System.assert(inFrequentUser.Id != null);

        List<User_License_Activation_Log__c> lstLog = [Select Id, User_Active__c, Status__c from User_License_Activation_Log__c where Unique_Id__c =: inFrequentUser.Id];
        System.assert(lstLog != null && lstLog.size() == 0);        
        
        SalesforceLicenseManagerJITHandler sfLicenseManagerJITHandler = new SalesforceLicenseManagerJITHandler();

        // create user JIT - not used
        sfLicenseManagerJITHandler.createUser(null, null, null, null, null, null);
    
        // update user JIT - activate the user
        sfLicenseManagerJITHandler.updateUser(inFrequentUser.Id, null, null, null, inFrequentUser.FederationIdentifier, null, null);

        inFrequentUser = [Select Id, IsActive from User where Id =:inFrequentUser.Id];
        System.assert(inFrequentUser.IsActive == true);
        
        Test.stopTest();

        lstLog = [Select Id, User_Active__c, Status__c from User_License_Activation_Log__c where Unique_Id__c =: inFrequentUser.Id];
        System.assert(lstLog != null && lstLog.size() == 1);  
             
    }
    
    
}