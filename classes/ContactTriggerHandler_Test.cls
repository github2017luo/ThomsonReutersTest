/**
 * Validates the functionality provided by the ContactTriggerHandler class.
 *
 * @author  Nandita R. Shet
 * @version  2012-09-07
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-09-07   Nandita R. Shet        Created                                                                   
 * =============================================================================
 */
 
@IsTest
private class ContactTriggerHandler_Test {
 
    public static testMethod void testupdateSalesOrgOnInsert() {
        
        Schema.DescribeSObjectResult objDescribe = Account.getSObjectType().getDescribe();   
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> listSalesOrgValues = fieldMap.get('Sales_org__c').getDescribe().getPicklistValues();
        
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'WEST';
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        insert testContact;
        
        List<Account> listTestAccounts = new List<Account>();
        List<Contact> listTestContacts = new List<Contact>();
        Map<Id,String> MapAccountSalesOrg = new Map<Id,String>();
        Integer i=0,j = 0;
        
        for(Schema.PicklistEntry sValue : listSalesOrgValues){
            listTestAccounts.add(UnitTest.getAccountInstance());
            listTestAccounts[i].Sales_org__c = String.Valueof(sValue);
            i++;
        }
        
        Insert listTestAccounts;
        for(Account oAccount : listTestAccounts){
          if(!MapAccountSalesOrg.ContainsKey(oAccount.Id)){
            MapAccountSalesOrg.put(oAccount.Id,oAccount.Sales_Org__c);
            }
        }
        
        for(i = 0; i<10;i++){
          if(i<listTestAccounts.size()){
            listTestContacts.add(UnitTest.getContactInstance(listTestAccounts[i].Id));
            listTestContacts[i].LastName += i;
            
          }
          else{
              listTestContacts.add(UnitTest.getContactInstance(listTestAccounts[j].Id));
              j++;
              
          }
        }
        
        Insert listTestContacts;
        testContact = [Select Sales_org__c from Contact where AccountId=: testAcc1.Id];
        listTestContacts = [Select Sales_org__c,AccountId from Contact where AccountId IN :listTestAccounts];
        Test.StartTest();
         System.assertEquals(testContact.Sales_org__c,testAcc1.Sales_org__c,'Error: Sales Org on Contact not updated');
         
        for(Contact oContact : listTestContacts){
          System.assertEquals(oContact.Sales_org__c,MapAccountSalesOrg.get(oContact.AccountId),'Error: Sales Org on Contact not updated');
              
        } 
    /*    for(i=0;i<listTestAccounts.size();i++){
        
            listTestContacts[i+1].AccountId = listTestAccounts[i].Id;
        }*/
          i = 0;
          for(Contact oContact : listTestContacts){
              i++;
              if(i<listTestAccounts.size()){
                  oContact.AccountId =  listTestAccounts[i].Id;
              }
          
          }
        
        
        Update listTestContacts;
        listTestContacts = [Select Sales_org__c,AccountId from Contact where AccountId IN :listTestAccounts];
        for(Contact oContact : listTestContacts){
          System.assertEquals(oContact.Sales_org__c,MapAccountSalesOrg.get(oContact.AccountId),'Error: Sales Org on Contact not updated');
              
        } 
       
        Test.StopTest();
        
     }
    public static testMethod void test1() {
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'United States', LCRM_ISD_Code__c = '1');
        insert dialCode;
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'GLI';
        testAcc1.BillingCountry = 'US';
        insert testAcc1;
        System.debug('@@@@@@@@@@testAcc1Country: '+ testAcc1.BillingCountry);
        
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.Email = 'test@test.com';
        testContact.Phone = '9999000010';
        testContact.MobilePhone = '9999000010';
        testContact.OtherPhone = '9999000010';
        insert testContact;
        System.debug('@@@@@@@@@@dialCode: '+ LCRM_StrikeIron_CountryCodes__c.getInstance(testContact.LCRM_Country__c));
        testContact.Phone = '9999000011';
        testContact.MobilePhone = '9999000011';
        testContact.OtherPhone = '9999000011';
        update testContact;
        
        System.assertEquals(true, testContact.Id != null);
    }
    
    public static testMethod void test2() {
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'United States', LCRM_ISD_Code__c = '1');
        insert dialCode;
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'GLI';
        testAcc1.BillingCountry = 'US';
        insert testAcc1;
        System.debug('@@@@@@@@@@testAcc1Country: '+ testAcc1.BillingCountry);
        
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.LCRM_Email_Verification__c = 'Email Valid';
        testContact.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.Email = 'test@test.com';
        testContact.Phone = '+9999000010';
        testContact.MobilePhone = '+9999000010';
        testContact.OtherPhone = '+9999000010';
        insert testContact;
        System.debug('@@@@@@@@@@dialCode: '+ LCRM_StrikeIron_CountryCodes__c.getInstance(testContact.LCRM_Country__c));
        testContact.Email = 'test1@test.com';
        testContact.Phone = '+9999000010';
        testContact.MobilePhone = '+9999000010';
        testContact.OtherPhone = '+9999000010';
        testContact.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
        update testContact;
        System.assertEquals(true, testContact.Id != null);
        
    }
    
    public static testMethod void test3() {
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'United States', LCRM_ISD_Code__c = '1');
        insert dialCode;
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'GLI';
        testAcc1.BillingCountry = 'US';
        insert testAcc1;
        System.debug('@@@@@@@@@@testAcc1Country: '+ testAcc1.BillingCountry);
        
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        insert testContact;
        System.assertEquals(true, testContact.Id != null);
    }
    public static testMethod void test4() {
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'IN', LCRM_Country_Code__c = 'IN', LCRM_Country_Name__c = 'India', LCRM_ISD_Code__c = '91');
        insert dialCode;
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'GLI';
        testAcc1.BillingCountry = 'US';
        insert testAcc1;
        System.debug('@@@@@@@@@@testAcc1Country: '+ testAcc1.BillingCountry);
        
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.Email = 'test@test.com';
        testContact.Phone = '9999000010';
        testContact.MobilePhone = '9999000010';
        testContact.OtherPhone = '9999000010';
        insert testContact;
        System.debug('@@@@@@@@@@dialCode: '+ LCRM_StrikeIron_CountryCodes__c.getInstance(testContact.LCRM_Country__c));
        testContact.Phone = '9999000011';
        testContact.MobilePhone = '9999000011';
        testContact.OtherPhone = '9999000011';
        update testContact;
        System.assertEquals(true, testContact.Id != null);
    }
    public static testMethod void test5() {
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'United States', LCRM_ISD_Code__c = '1');
        insert dialCode;
        KeyValueListStore__c tempValueStore = new KeyValueListStore__c(Name = 'LCRMStrikeIronInformaticaUsers', Failure_Email__c = 'Test GLI User' );
        insert tempValueStore;
        Id ProfileId = [SELECT Id FROM Profile Where Name = 'System Administrator'].Id;
        user u = UnitTest.getUserInstance();
        u.LastName = 'Test GLI User';
        u.ProfileId = ProfileId;
        insert u;
        System.runAs(u){
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_org__c = 'GLI';
        testAcc1.BillingCountry = 'US';
        insert testAcc1;
        System.debug('@@@@@@@@@@testAcc1Country: '+ testAcc1.BillingCountry);
        
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        testContact.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
        testContact.Email = 'test@test.com';
        testContact.Phone = '9999000010';
        testContact.MobilePhone = '9999000010';
        testContact.OtherPhone = '9999000010';
        insert testContact;
        System.debug('@@@@@@@@@@dialCode: '+ LCRM_StrikeIron_CountryCodes__c.getInstance(testContact.LCRM_Country__c));
        testContact.Phone = '9999000011';
        testContact.MobilePhone = '9999000011';
        testContact.OtherPhone = '9999000011';
        CheckRecursive.lcrmRecursivecheckflag_contact =true;
        testContact.Phone = '9008765432';
        update testContact;
        System.assertEquals(true, testContact.Id != null);
        }
    }
    //Added for CRM-13505 by Shovon
    public static testMethod void testContactAuditLog() {
        
        LCRM_Contact_Field_Tracker__c cft = new LCRM_Contact_Field_Tracker__c(Name = 'LCRM_Consent_To_Mail__c');
        insert cft;
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Is_GLI__c = true;
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        testContact.LCRM_Consent_To_Mail__c = 'Unknown';
        insert testContact;
        testContact.LCRM_Consent_To_Mail__c = 'Opt-out';
        update testContact;
        
        List<LCRM_Audit_Log__c> conAuditLogList = new List<LCRM_Audit_Log__c>([SELECT Id, Contact__c, New_Value__c, Old_Value__c FROM LCRM_Audit_Log__c WHERE Contact__c =: testContact.Id LIMIT 1]);
        if(conAuditLogList.size() > 0){
            System.assertEquals('Unknown', conAuditLogList[0].Old_Value__c);
            System.assertEquals('Opt-out', conAuditLogList[0].New_Value__c);
        }
    } 
     
 }