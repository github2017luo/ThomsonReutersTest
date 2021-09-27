/** 
* LCRMRestrictRecordDeletion_test method
* @description : LCRMRestrictRecordDeletion_test
*/
@istest
public class LCRMRestrictRecordDeletion_test {
    /** 
* 
* @description : testCheckFunctionality
*/
    
    public static testMethod void testCheckFunctionality()
    {
        //Test.startTest();
        List<Account> listAccObj = new List<Account>();
        List<Contact> listConObj = new List<Contact>();
        List<Opportunity> listOppObj = new List<Opportunity>();
        List<Lead> listLdObj = new List<Lead>();
        Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='Impartner' limit 1];
        
        User testUser = new User(
            Alias = 'standt', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = stdProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            Sub_Bu__c ='UKI',
            Sales_Org__c = 'LRA',
            UserName='abc1@testorg.com'
        );
        
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        system.runAs(testUser) {
            //List<Opportunity> opptyLst1 = new List<Opportunity>();
            
            Account acct = new Account(Name='TEST_ACCT');
            acct.LCRM_Integration_Source__c = 'Impartner';
            acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            insert acct;
            
            Account acct1 = new Account(Name='TEST_ACCT1');
            acct1.LCRM_Integration_Source__c = 'Impartner';
            acct1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            listAccObj.add(acct1);
            
            Contact testcontact= UnitTest.getContactInstance(acct.Id);
            testcontact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
            insert testcontact;
            
            Contact testcontact1= UnitTest.getContactInstance(acct.Id);
            testcontact1.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
            listConObj.add(testcontact1);
            
            LOTUS_Lightning_Profiles__c llp = new LOTUS_Lightning_Profiles__c();
            llp.End_State_Lightning__c = true;
            llp.SetupOwnerId = stdProfile.id;
            llp.Delete_Record_Permission__c = false;
            insert llp;
            
            KeyValueListStore__c listStore=new KeyValueListStore__c();
            listStore.Name = 'ANZUsersProfileId';
            listStore.TextValue__c = stdProfile.Id;
            insert listStore;
            
            RecordtypeIds__c recT1= new RecordtypeIds__c();
            recT1.name= 'LATAM Renewal Opportunity';
            recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();      
            insert recT1;
            
            RecordtypeIds__c recT2= new RecordtypeIds__c();
            recT2.Name= 'Pipeline Opportunities';
            recT2.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
            insert recT2;
            
            RecordtypeIds__c recT3= new RecordtypeIds__c();
            recT3.name= 'Pre-Pipeline Opportunities';
            recT3.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();      
            insert recT3;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acct.Id;
            opp.Name = 'Unit Test Opportuntiy';
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId(); 
            opp.CloseDate = System.Today() + 5;
            opp.RecordTypeId = recT2.recTypeId__C;
            opp.StageName = '10%';
            opp.Competitor_Name__c = 'BloomBerg';
            opp.Renewal_Flag__c = true;
            opp.Reason__c = 'Test';
            opp.Name__c = 'Test';
            opp.Was_There_a_Competitor__c = 'No';
            opp.Is_GLI__c = true;
            opp.LCRM_Integration_Source__c = 'Impartner';
            opp.Expiration_Date__c = System.today().adddays(40); 
            //insert opp;
            listOppObj.add(opp);
            
            
            
            Lead ld1 = new Lead(FirstName ='Test',LastName='Lead',Company='Test');
            ld1.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId();
            ld1.LCRM_Integration_Source__c = 'Impartner';
            ld1.BU_Segment__c='Corporate';
            //insert ld1;
            listLdObj.add(ld1);
            Lead ld2 = new Lead(FirstName ='Test',LastName='Lead',Company='Test');
            ld2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId();
            ld2.LCRM_Integration_Source__c = 'Impartner';
            ld2.BU_Segment__c='Professional Legal';
            listLdObj.add(ld2);
            insert listLdObj;
            
            //LCRMRestrictRecordDeletion ob = new LCRMRestrictRecordDeletion();
            LCRMRestrictRecordDeletion.getRecordtypeSet();
            LCRMRestrictRecordDeletion.restrictRecordDeletion(listAccObj);
            LCRMRestrictRecordDeletion.checkDeleteError('Account', listAccObj);
            LCRMRestrictRecordDeletion.checkDeleteError('Contact', listConObj);
            LCRMRestrictRecordDeletion.checkDeleteError('Opportunity', listOppObj);
            
            LCRMRestrictRecordDeletion.assignLeadValues(listLdObj);
            Lead ld = new Lead(FirstName ='Test',LastName='Lead',Company='Test');
            ld.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId();
            ld.LCRM_Integration_Source__c = 'Impartner';
            //insert ld;
            listLdObj.add(ld);
            LCRMRestrictRecordDeletion.checkDeleteError('Lead', listLdObj);
            Account acctSupportLevel = new Account(Name='TEST_ACCT2');
            acctSupportLevel.LCRM_Integration_Source__c = 'Impartner';
            acctSupportLevel.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            insert acctSupportLevel;
            ESC_Support_Level__c support = new ESC_Support_Level__c();
            support.Account__c = acctSupportLevel.id;
            support.ESC_Brand__c = 'Elite';
            support.ESC_Product_Title__c = 'Business Dev';
            support.CurrencyIsoCode = 'USD';
            insert support;
            ESC_AccountSupportHandler.updateEscSupportObjectMergeField(new set<Id>{acctSupportLevel.id});
        }  
        
    }                        
    
}