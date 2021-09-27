/**
* {Purpose} - Test class for CNAppUtils.
*
* @author   Shah Kadirmohideen
* @version  2011-10-26
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2011-10-26    Shah Kadirmohideen      Created      
* 2011-12-20    Shah Kadirmohideen      Added OnInstall annotation to enforce test method execution during package installation.
* 2012-01-20    Shah Kadirmohideen      Incorporated enhanced list (go to list) functionality related changes.
* 2012-05-01    Shah Kadirmohideen      Updated test_getTopDomain() to work with the new signature of CNAppUtils.getTopDomain() method.
*                                       Added test_concatenateListIds() method.
* 2011-10-05    Shah Kadirmohideen      Added test_handleException() method 
* 2014-09-10    David Sarbello          Added additional test methods ()
* 2017-01-11	Denis Mitropolsky		#602 removed check for Chatter
* =============================================================================
*/
@isTest(SeeAllData=true) 
 
public class CNAppUtilsTest {
    /**
    * Validates data retrieval from CN App Settings
    */
    @isTest (OnInstall=false)
    private static void test_getAppCustomSetting() {
        //09.15.14 CNUnitTest.initializeCustomSetting();
        
        Test.startTest();
        
        CN_App_Settings__c oCustomSetting = CNAppUtils.getAppCustomSetting();
        System.assertNotEquals(oCustomSetting, null, 'Custom setting data not created');
        
        Test.stopTest();
    }
    
    /**
    * Validates the web service active flag
    */
    @isTest (OnInstall=false)
    private static void test_isServiceActive() {
        //09.15.14 CNUnitTest.initializeCustomSetting();
        
        Test.startTest();
        
        System.assertEquals(CNAppUtils.isServiceActive(), true, 'Webservice active flag is not set on custom setting');
        
        Test.stopTest();
    }
    
    /**
    * Validates exception handling method
    */
    @isTest (OnInstall=false)
    private static void test_handleException() {
        //09.15.14 CN_App_Settings__c oSetup = CNUnitTest.initializeCustomSetting();
        //CN_App_Settings__c oSetup = CNAppUtils.getAppCustomSetting();
        CN_App_Settings__c oSetup = [SELECT Display_General_Error_Message__c FROM CN_App_Settings__c];
        CNData.CNException oExp = new CNData.CNException();
        CNData.CNExceptionInfo oExpInfo = new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
                    'CNAppUtils', 'test_handleException()',
                    'test mode=true', false, true, 'Test Error');
        Test.startTest();
        
        CNAppUtils.handleException(oExpInfo);
        System.assertequals(false, ApexPages.getMessages().size()>0, 'Error message not added to the page');
        //oSetup.Display_General_Error_Message__c = true;
        oSetup.Display_General_Error_Message__c = true;
        update oSetup;
        CNAppUtils.handleException(oExpInfo);
        oSetup.Display_General_Error_Message__c = false;
        update oSetup;
        CNAppUtils.handleException(oExpInfo);
        //oExpInfo.bAddToPage = true now
        oExpInfo = new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
                    'CNAppUtils', 'test_handleException()',
                    'test mode=true', true, true, 'Test Error');
        CNAppUtils.handleException(oExpInfo);
        System.assertequals(true, ApexPages.getMessages().size()>0);
        //oSetup.Display_General_Error_Message__c = true;
        oSetup.Display_General_Error_Message__c = true;
        update oSetup;
        CNAppUtils.handleException(oExpInfo);
        oSetup.Display_General_Error_Message__c = false;
        update oSetup;
        CNAppUtils.handleException(oExpInfo);            
        Test.stopTest();
    }
    
    /**
    * Validates if a string is non empty or not 
    */
    @isTest (OnInstall=false)
    private static void test_isNonEmpty() {
        Test.startTest();
        
        System.assertEquals(CNAppUtils.isNonEmpty(null), false, 'Expected false');
        System.assertEquals(CNAppUtils.isNonEmpty('test'), true, 'Expected true');
        
        Test.stopTest();
    }
    
    /**
    * Validates if a string is empty or not
    */
    @isTest (OnInstall=false)
    private static void test_isEmpty() {
        Test.startTest();
        
        System.assertEquals(CNAppUtils.isEmpty(null), true, 'Expected true');
        System.assertEquals(CNAppUtils.isEmpty(''), true, 'Expected true');
        System.assertEquals(CNAppUtils.isEmpty('test'), false, 'Expected false');
        
        Test.stopTest();
    }
    
    /**
    * Validates a concatenated string which is created from a set of strings
    */
    @isTest (OnInstall=false)
    private static void test_concatenateSet() {
        Set<String> setData = new Set<String>();
        setData.add('one');
        setData.add('two');
        
        Test.startTest();
        
        String sConcatenatedData = CNAppUtils.concatenateSet(setData, ',');
        System.assertEquals(sConcatenatedData == 'one,two' || sConcatenatedData == 'two,one', true, 'String concatenation did not function properly');
        
        sConcatenatedData = CNAppUtils.concatenateSet(null, ',');
        System.assertEquals(sConcatenatedData, '', 'Concatenated string did not contain empty value');
        
        Test.stopTest();
    }
    
    /**
    * Validates a concatenated string which is created from a list of strings
    */
    @isTest (OnInstall=false)
    private static void test_concatenateList() {
        List<String> listData = new List<String>();
        listData.add('one');
        listData.add('two');
        
        Test.startTest();
        
        String sConcatenatedData = CNAppUtils.concatenateList(listData, ',');
        System.assertEquals(sConcatenatedData == 'one,two', true, 'String concatenation did not function properly');
        
        sConcatenatedData = CNAppUtils.concatenateList(null, ',');
        System.assertEquals(sConcatenatedData, '', 'Concatenated string did not contain empty value');
        
        Test.stopTest();
    }

    /**
    * Validates a concatenated string which is created from a list of ids
    */
    @isTest (OnInstall=false)
    private static void test_concatenateListIds() {
        List<Id> listData = new List<String>();
        listData.add('01Id0000000daWW');
        listData.add('01Id0000000dRWW');
        
        Test.startTest();
        
        String sConcatenatedData = CNAppUtils.concatenateListIds(listData, ', ');
        System.assertEquals(sConcatenatedData == '01Id0000000daWW, 01Id0000000dRWW', true, 'String concatenation did not function properly');
        
        sConcatenatedData = CNAppUtils.concatenateListIds(null, ',');
        System.assertEquals(sConcatenatedData, '', 'Concatenated string did not contain empty value');
        
        Test.stopTest();
    }
    
    /**
    * Validates the URL which is prepared using MAP
    */
    @isTest (OnInstall=false)
    private static void test_prepareURL() {
        String sUrl = 'http://www.testdomain.com';
        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('id', '001');
        Boolean bEncode = true;
        
        Test.startTest();
        
        String sURLWithParams = CNAppUtils.prepareURL(sUrl, mapParams, bEncode);
        System.assertEquals(sURLWithParams, sUrl + '?id=001');
        
        sURLWithParams = CNAppUtils.prepareURL(sUrl, null, bEncode);
        System.assertEquals(sURLWithParams, sUrl);
        
        sURLWithParams = CNAppUtils.prepareURL('', mapParams, bEncode);
        System.assertEquals(sURLWithParams, '');
        
        Test.stopTest();
    }
    
    /**
    * Validates the GET invocation for any URL
    */
    @isTest (OnInstall=false)
    private static void test_getContent() {
       /* CNAppUtils.sHttpBodyInTestContext = 'Success';

        Test.startTest();
        System.assertEquals(CNAppUtils.getContent('http://www.testdomain.com', 30), 'Success', 'Http invocation did not return test input data');
        Test.stopTest();*/
    }
    
    @isTest (OnInstall=false)
    static void test_getTopDomain() { 
        
        // Initialize test account record
        Account oAccount = CNUnitTest.getAccount(true);
        System.debug('acct: ' + oAccount);
        system.assertNotEquals(oAccount, NULL, 'Expected valid Account record');
        
        Id accountID = oAccount.Id;
        system.debug('id: ' + accountID);
        system.assertNotEquals(accountID, NULL, 'Expected valid accountId');
        
        // Initialize batch of test contact records
        List<Contact> listContacts = CNUnitTest.getContacts(accountId, false);
        
        system.assert(listContacts.size()!=NULL, '[ME] listContacts does not contain any records');
        
        // Test POSITIVE results        
        Test.startTest();

        String sDomain = CNAppUtils.getTopDomain(listContacts);
        system.assertNotEquals(sDomain, NULL, 'Expected non-null Domain value');
        system.debug(sDomain);
        
        
        // Test NEGATIVE results
        sDomain = CNAppUtils.getTopDomain(NULL);
        system.assertEquals(sDomain, NULL, 'Expect TopDomain value to be NULL');

        Test.stopTest();
    }

    /**
    * Validates JSON decode functionality.
    */
    @isTest (OnInstall=false)
    private static void test_decodeJsonFieldNames() {
        String sJsonData = CNUnitTest.getArrayOfRelationshipXML(1);
        
        Test.startTest();
        sJsonData = CNAppUtils.decodeJsonFieldNames(sJsonData);
        for (String oldKey : CNAppUtils.mapJSONFieldMapping.keySet()) {
            System.assertEquals(false, sJsonData.contains(oldKey), 'Json field parsing not working');
        }
        Test.stopTest();
    }   

    /**
    * Validates relationship data parsing
    */
    @isTest (OnInstall=false)
    private static void test_parseRelationshipData() {
        String sJsonData = CNUnitTest.getArrayOfRelationshipXML(2);
        Account oAcct = CNUnitTest.getAccount(true);
        Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
        CN_Webservice_Queue__c oQueue = CNUnitTest.getWebserviceQueue(oAcct.Id, null, System.now(), true);
        
        Test.startTest();

        List<CNData.CNRelationship> listRels = CNAppUtils.parseRelationshipData(sJsonData);
        System.assertEquals(2, listRels.size(), 'Relationship JSON parsing not working');

        List<CN_Relationship__c> listCache = CNAppUtils.convertCNRelationshipForContact(listRels, oAcct.Id, oQueue.Id);
        System.assertEquals(2, listCache.size(), 'relationship cache creation not working for salesforce account');

        listCache = CNAppUtils.convertCNRelationshipForColleague(listRels, oAcct.Id, null, oQueue.Id);
        System.assertEquals(2, listCache.size(), 'colleague relationship cache creation not working for salesforce account');

        listCache = CNAppUtils.convertCNRelationshipForColleague(listRels, null, oCont.Id, oQueue.Id);
        System.assertEquals(2, listCache.size(), 'contact relationship cache creation not working for salesforce account');
        CNAppUtils.isChatterEnabled();
        
        Test.stopTest();
    }   

    /**
    * Validates contacts data parsing
    */
    @isTest (OnInstall=false)
    private static void test_parseContactsData() {
        String sJsonData = CNUnitTest.getArrayOfContactXML(1);
        
        Test.startTest();
        List<CNData.CNContact> listConts = CNAppUtils.parseContactsData(sJsonData);
        System.assertEquals(1, listConts.size(), 'Contacts JSON parsing not working');
        Test.stopTest();
    }   

    /**
    * Validates company data parsing
    */
    @isTest (OnInstall=false)
    private static void test_parseCompanyData() {
        String sJsonData = CNUnitTest.getArrayOfCompanyXML(1, 1);
        
        Test.startTest();
        List<CNData.CNCompany> listCompanies = CNAppUtils.parseCompanyData(sJsonData);
        System.assertEquals(1, listCompanies.size(), 'Company JSON parsing not working');
        Test.stopTest();
    }   

    /**
    * Validates conversion of a date from JSON format to salesforce format
    */
    @isTest (OnInstall=false)
    private static void test_convertJSONDate() {
        Test.startTest();
        DateTime dtSFDC = CNAppUtils.convertJSONDate('/Date(1321336800000-0600)/');
        System.assertNotEquals(null, dtSFDC, 'JSON date conversion not working');
        Test.stopTest();
    }   

    /**
    * Validates string split & trim logic
    */
    @isTest (OnInstall=false)
    private static void test_StringManipulations() {
        Test.startTest();
        Set<String> setData = CNAppUtils.splitAsSet('a;b;c', ';');
        System.assertEquals(3, setData.size(), 'splitAsSet not working');
        List<String> listData = CNAppUtils.splitAsList('a;b;c', ';');
        System.assertEquals(3, listData.size(), 'splitAsList not working');
        System.assertEquals('ab' , CNAppUtils.trim('  abcd  ', 2), 'String trimming not working');
        
        Test.stopTest();
    }   
    
    /**
    * Validates relationship query creation
    */
    @isTest (OnInstall=false)
    private static void test_prepareRelationshipSOQL() {
        Account oAcct = CNUnitTest.getAccount(true);
        Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
        
        Test.startTest();
        
        String sQuery = CNAppUtils.prepareRelationshipSOQL('Colleague', oAcct.Id, null, 2, 'Name', 'ASC', 'T'); 
        System.assertEquals(true, sQuery.contains('limit 2'), 'Limit clause not applied');
        System.assertEquals(true, sQuery.contains('order by Name'), 'Order By clause not applied');
        System.assertEquals(true, sQuery.contains('like '), 'Like clause not applied');
        System.assertEquals(true, sQuery.contains('Account__c='), 'Account condition not applied');
        
        sQuery = CNAppUtils.prepareRelationshipSOQL('Colleague', null, oCont.Id, 2, 'Name', 'DESC', 'all'); 
        System.assertEquals(true, sQuery.contains('DESC'), 'Order by DESC clause not applied');
        System.assertEquals(true, sQuery.contains('Contact__c='), 'Account condition not applied');
        
        Test.stopTest();
    }   

    /**
    * Validates custom setting fetch functionality
    */
    @isTest (OnInstall=false)
    private static void test_fetchExistingCustomSetting() {
        //09.15.14 CNUnitTest.initializeCustomSetting();
        
        Test.startTest();
         
        CN_App_Settings__c oAppSetup = CNAppUtils.fetchExistingCustomSetting();
        System.assertNotEquals(null, oAppSetup, 'Custom setting fetch failed');
                
        Test.stopTest();
    }   
    
    /**
    * Validates web service queue handler functionalities.
    */
    @isTest (OnInstall=false)
    private static void test_WebserviceQueueHandler() {
        //09.15.14 CNUnitTest.initializeCustomSetting();
        Account oAcct = CNUnitTest.getAccount(true);
        Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
        Id colRecTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Colleague').getRecordTypeId();
        Id conRecTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        
        Test.startTest();
        
        CNAppUtils.CNWebServiceQueueHandler oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(oAcct.Id, null, '123', 'Colleague');
        System.assertEquals(false, oQueueHandler.queueExistsWithFullyLoaded(), 'Queue loading logic not working');
        System.assertEquals(0, oQueueHandler.getTotalContacts(), 'Total contacts logic not working');
        System.assertEquals(0, oQueueHandler.getTotalColleagues(), 'Total colleagues logic not working');
        oQueueHandler.refresh();
        
        oQueueHandler.createQueue();
        List<CN_Relationship__c> listRelationships = CNUnitTest.getRelationships(oQueueHandler.oQueue.Id, 5, true, colRecTypeId);
        oQueueHandler.refresh();
        System.assertEquals(false, oQueueHandler.queueExistsWithFullyLoaded(), 'Queue loading logic not working');
        System.assertEquals(0, oQueueHandler.getTotalContacts(), 'Total contacts logic not working');
        System.assertEquals(5, oQueueHandler.getTotalColleagues(), 'Total colleagues logic not working');
        
        System.debug('cache testing starts');
        oQueueHandler.updateColleagueStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);
        oQueueHandler.refresh();
        System.assertEquals(true, oQueueHandler.queueExistsWithFullyLoaded(), 'Queue loading logic not working');
        

        CNUnitTest.getRelationships(oQueueHandler.oQueue.Id, 5, true, conRecTypeId);
        oQueueHandler.refresh();
        System.assertEquals(5, oQueueHandler.getTotalContacts(), 'Total contacts logic not working');
        
        oQueueHandler.updateContactStatus(oQueueHandler.ALL_DATA_RECEIVED_STATUS);
        oQueueHandler.refresh();
        oQueueHandler.tabName = 'Contact';
        System.assertEquals(true, oQueueHandler.queueExistsWithFullyLoaded(), 'Queue loading logic not working');
        
        oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(oAcct.Id, null, null, 'Contact');

        CNAppUtils.fetchContactsFromSFDC(oAcct.Id, -1, true);
        CNAppUtils.convertCustomObjectToContactRelationship(listRelationships, true);
        CNAppUtils.fetchColleaguesFromSFDC(oAcct.Id, null, -1, true);
        CNAppUtils.convertCustomObjectToColleagueRelationship(listRelationships, true);
        CNAppUtils.deleteCacheFromCustomObjects();
        
        Test.stopTest();
    }       

    /**
    * Validates insertLogEntry.
    */
    
    @isTest (OnInstall=false)
    private static void test_insertLogEntry() {
        
        Test.startTest(); 

        Account a = CNUnitTest.getAccount(true);  

        //09.15.14 CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();
        CN_App_Settings__c csSettings = CNAppUtils.getAppCustomSetting();
        
        //@future call
        CNAppUtils.insertLogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);

        Test.stopTest();
        
        CN_Audit_Log__c oLog = [Select Id, Account__c from CN_Audit_Log__c Where Account__c=:a.id and Action_Type__c='Initial Load' LIMIT 1];

        System.assertEquals(a.Id, oLog.Account__c,'insertLogEntry logic not working');
        
    }     

    /**
    * Validates SendSummaryAuditReport.
    */
    
    @isTest (OnInstall=false)
    private static void test_SendSummaryAuditReport() {
            
        Test.startTest();

        //09.15.14 CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();
        CN_App_Settings__c csSettings = CNAppUtils.getAppCustomSetting();
        
        CNAppUtils.SendSummaryAuditReport();
        
        Test.stopTest();
    } 

    /**
    * Validates GenerateSummaryAuditLogReport. 
    */
    
    @isTest (OnInstall=false)
    private static void test_GenerateSummaryAuditLogReport() {
        
        Test.startTest();

        Account a = CNUnitTest.getAccount(true);

        //09.15.14 CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();
        CN_App_Settings__c csSettings = CNAppUtils.getAppCustomSetting();
        
        //@future call
        CNAppUtils.insertLogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);

        Test.stopTest(); 

        String s = CNAppUtils.GenerateSummaryAuditLogReport(1);
        
        System.assert(s.length() > 20, 'GenerateSummaryAuditLogReport logic not working');
        
    }       

    /**
    * Validates GenerateAuditLogCSV.
    */
    /*
    @isTest (OnInstall=false)
    private static void test_GenerateAuditLogCSV() {
         
        Test.startTest();

        Account a = CNUnitTest.getAccount(true);

        CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();

        CNAppUtils.insertLogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);

        Test.stopTest();

        String s = CNAppUtils.GenerateAuditLogCSV(1);

        System.assert(s.length() > 80, 'GenerateAuditLogCSV logic not working');
        
    }  
    */
    
    /**
    * Validates CleanAuditLog.
    */
    
    @isTest (OnInstall=false)
    private static void test_CleanAuditLog() {
        
        Test.startTest();

        Account a = CNUnitTest.getAccount(true);

        //09.15.14 CN_App_Settings__c csSettings = CNUnitTest.initializeCustomSetting();
        CN_App_Settings__c csSettings = CNAppUtils.getAppCustomSetting();

        CNAppUtils.insertLogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);

        Test.stopTest();

        CN_Audit_Log__c oLog = [Select Id, Account__c, Expired__c from CN_Audit_Log__c Where Account__c=:a.id and Action_Type__c='Initial Load' LIMIT 1];

        oLog.Expiration_Date__c = System.Today().addDays(-45);
        
        update olog;

        AggregateResult[] aggListBefore = [Select count(Id) from CN_Audit_Log__c Where Expired__c = 'Yes'];

        CNAppUtils.CleanAuditLog();

        AggregateResult[] aggListAfter = [Select count(Id) from CN_Audit_Log__c Where Expired__c = 'Yes'];

        System.assertNotEquals(aggListBefore[0].get('expr0'), aggListAfter[0].get('expr0'), 'CleanAuditLog logic not working');
        
    }     
    @isTest (OnInstall=false)
    private static void test_getDataSensitiveDefault() {
        
        Test.startTest();
        string s = CNAppUtils.getDataSensitiveDefault();
        system.assertEquals('',s);        
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_getContactEnableAddAction() {
        
        Test.startTest();
        boolean b = CNAppUtils.getContactEnableAddAction();
        system.assertNotEquals(null,b);        
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_getContactEnableSearchAction() {
        
        Test.startTest();
        boolean b = CNAppUtils.getContactEnableSearchAction();
        system.assertNotEquals(null,b);        
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_getContactShowEmail() {
        
        Test.startTest();
        boolean b = CNAppUtils.getContactShowEmail();
        system.assertNotEquals(null,b);        
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_getContactEnableActionColumn() {
        
        Test.startTest();
        boolean b = CNAppUtils.getContactEnableActionColumn();
        system.assertNotEquals(null,b);        
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_isChatterEnabled() {
        
        Test.startTest();
        boolean b = CNAppUtils.isChatterEnabled();
      //  system.assertEquals(true,b);        
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_useSensitiveDataDisplay() {        
        Test.startTest();
        boolean b = CNAppUtils.useSensitiveDataDisplay('hello', 'test');
        system.assertEquals(false,b); 
        boolean b1 = CNAppUtils.useSensitiveDataDisplay('hello', '');
        system.assertEquals(false,b1);
        boolean b2 = CNAppUtils.useSensitiveDataDisplay('', 'test');
        system.assertEquals(false,b2); 
        boolean b3 = CNAppUtils.useSensitiveDataDisplay('', '');
        system.assertEquals(false,b3); 
        boolean b4 = CNAppUtils.useSensitiveDataDisplay(null, null);
        system.assertEquals(true,b4);       
        Test.stopTest();
    }
    
    @isTest (OnInstall=false)
    private static void test_getSecurityToken() {
        
        Test.startTest();
        string b = CNAppUtils.getSecurityToken();
        system.assertNotEquals('',b);        
        Test.stopTest();
    }
    @isTest (OnInstall=false)
    private static void test_CNWebServiceQueueHandler() {
     Test.startTest();
     Account a = CNUnitTest.getAccount(true);
      Contact oCont = CNUnitTest.getContact(a.Id, true);
     CNAppUtils.CNWebServiceQueueHandler cnws = new CNAppUtils.CNWebServiceQueueHandler(a.Id, oCont.Id, '5001234', 'Contact');
     system.assertNotEquals(null,cnws);     
     Test.stopTest();
    }
    //
    @isTest (OnInstall=false)
    private static void test_ConfigSettings(){
        Test.startTest();
            CNAppUtils cn = new CNAppUtils(); 
            system.assertNotEquals(null,CNAppUtils.getContactEnableActionColumn());
            system.assertNotEquals(null,CNAppUtils.getShowColleagueEmailData());
            system.assertNotEquals(null,CNAppUtils.getShowColleagueLocation());
            system.assertNotEquals(null,CNAppUtils.getShowColleaguePhoneData());
            system.assertNotEquals(null,CNAppUtils.getShowColleagueRecency());
            system.assertNotEquals(null,CNAppUtils.getShowColleagueRelationshipStrength());
            system.assertNotEquals(null,CNAppUtils.getShowColleagueSource());
            system.assertNotEquals(null,CNAppUtils.getShowColleagueTitle());
            system.assertNotEquals(null,CNAppUtils.getShowContactEmailData());
            system.assertNotEquals(null,CNAppUtils.getShowContactLocation());
            system.assertNotEquals(null,CNAppUtils.getShowContactPhoneData());
            system.assertNotEquals(null,CNAppUtils.getShowContactRecency());
            system.assertNotEquals(null,CNAppUtils.getShowContactRelationshipStrength());
            system.assertNotEquals(null,CNAppUtils.getShowContactSource());
            system.assertNotEquals(null,CNAppUtils.getShowContactTitle());
            system.assertNotEquals(null,CNAppUtils.getShowEmailData());
            system.assertNotEquals(null,CNAppUtils.getShowPhoneData());  
            system.assertNotEquals(null,CNAppUtils.getContactShowPhone());
            system.assertNotEquals(null,CNAppUtils.getContactEnableActionColumn());
            system.assertNotEquals(null,CNAppUtils.validateAppSettings());
            
        Test.stopTest();     
    }                                                            
}