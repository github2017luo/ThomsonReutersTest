/*
* This is the test class for ODTDG_LeadConvert
*
* CHANGE HISTORY
* ========================================================================================================
* Date          Name                JIRA        Description
* 2021-08-23    Brenda Shields      DCP-4144    Add SAP Account Number as a new parameter into this method
* ========================================================================================================
*/
@istest(seeAllData=false)
public with sharing class ODTDG_LeadConvert_Test {


/********************************************************************************************************
*  @description method1: this is the test method to check Lead Convert
*********************************************************************************************************/
    public static testmethod void method1() {
       
        Profile p = [select id from Profile where name = 'System Administrator']; 
        User bdeUser = new User(alias = 'newUser9', email = 'user@mydomain.com',
                emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = p.Id, employeenumber = '0144020',
                Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite', timezonesidkey = 'America/Los_Angeles', username = p.id+'user89@mydomain.com', Rep_Type_Description__c = 'test'); 
        insert bdeUser;
       
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'ODTDG_PermissionSet'];
        insert new PermissionSetAssignment(AssigneeId = bdeUser.id, PermissionSetId = ps.Id);

        system.runAs(bdeUser) {

		// create lead 
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';
        ld.IsConverted=false;
        ld.Company='TCS';
        insert ld;
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name =: 'ANZ Users'];
        User u1 = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'
            AND Profile.id =: p1.id limit 1];
        
        //Keyvalue setting for OpportunityUtil class
        KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = p1.id);
        insert keyCustomSetting;
        
        Map<String, Schema.RecordTypeInfo > recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId();
        Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
        Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
        RecordType defaultRecordType = [SELECT id,Name FROM RecordType WHERE SobjectType='Opportunity' Limit 1];
        system.debug(logginglevel.INFO, 'Pipeline' + optyPipeRecTypeId + 'Pre-pipeline' + optyPreRecTypeID + 'GLI pipeline' + optyGLIRecTypeID);
        
        RecordtypeIds__c recT1 = new RecordtypeIds__c();
        recT1.Name = 'Pipeline Opportunities';
        recT1.recTypeId__C = optyPipeRecTypeId != null ? optyPipeRecTypeId : defaultRecordType.id;
        insert recT1;

        RecordtypeIds__c recT2 = new RecordtypeIds__c();
        recT2.Name = 'GLI Pipeline Opportunity';
        recT2.recTypeId__C = optyGLIRecTypeID != null ? optyGLIRecTypeID : defaultRecordType.id;
        insert recT2;

        RecordtypeIds__c recT = new RecordtypeIds__c();
        recT.name = 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = optyPreRecTypeID != null ? optyPreRecTypeID : defaultRecordType.id;
        insert recT;
        
        // create Account
        Account newAcct = new Account();
        newAcct.Name = 'Test Class Account';
        newAcct.SAPAccountNumber__c = '173468929';
        newAcct.BillingState = 'FL';
        newAcct.BillingCity = 'Orlando';
        newAcct.BillingCountry = 'US';
        newAcct.BillingPostalCode = '32801';
        newAcct.BillingStreet = '223 E. Concord Street';
        newAcct.Phone = '08061393678';
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;
        
        // create ssd
        Source_System_Detail__c acctSSD = new Source_System_Detail__c();
        acctSSD.Name = 'Test Account SSD';
        acctSSD.Source_System_Name__c = 'Test Account SSD';
        acctSSD.Source_System_Account_Number__c = '173468930';
        acctSSD.Trial_Status__c = '';
        acctSSD.LCRM_Market_Segment__c = 'SLF 4-6';
        acctSSD.LCRM_Sales_Org__c = 'West';
        insert acctSSD;
        
        //create opportunity
        Id ssdRecorType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;
                        
        // create opp
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = ssdRecorType;
        opp.Owner = u1;
        opp.StageName = 'Prospect';
        opp.AccountId = newAcct.Id;
        opp.Pricebook2id = pbook.id;
        opp.Source_System_Detail__c = acctSSD.Id;
        insert opp;
        
		// create entitlement trial
        Ent_Trial__c trl = new Ent_Trial__c();
        trl.Trial_Start_Date__c = system.today();
        trl.Trial_End_Date__c = system.today()+7;
        trl.External_Account_Number__c = '4332938';
        trl.Opportunity__c = opp.Id;
        trl.Lead__c = ld.id;
        insert trl;
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.Lead__c = ld.id;
        trlcon.One_Pass_ID__c = 'onepassIdgdskjadkadsgaDGKGGSYHs';
        insert trlCon;

        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        insert trprd;    
        
        Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
        trialPrdCont.Trial_Contact__c = trlCon.id;
        trialPrdCont.Trial_Product__c = trprd.Id;
        trialPrdCont.Trials__c = trl.Id;
        insert trialPrdCont;

		// call getTrialsDetails
        ODTDG_TrialRecord odtLc = ODTDG_LeadConvert.getTrialsDetails('onepassIdgdskjadkadsgaDGKGGSYHs', 'Test Account SSD', '');

        system.debug(LoggingLevel.INFO,'odtLc...............'+odtLc);  
        system.debug(LoggingLevel.INFO,'odtLc...............'+ odtLc.odtdgTrialDetails.trialAccountInfo.accountNumber );
             
        system.assert(odtLc.odtdgTrialDetails.trialAccountInfo.accountNumber == trl.External_Account_Number__c,'Details are match...');
        }

    }

    /********************************************************************************************************
	*  @description method2: this is the test method to check Lead Convert
	*********************************************************************************************************/
    public static testmethod void method2() {
       Profile p = [select id 
                            from 
                            Profile 
                            where 
                            name='System Administrator']; 
       
        LIST<KeyValueListStore__c> keyList = new LIST<KeyValueListStore__c>();
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserProfileName', TextValue__c='TR Corp Partner Community User'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserBUSegmentValue', TextValue__c='Corporate'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserLeadSourceValue', TextValue__c='Partner'));
        keyList.add(new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c=p.id));
        insert keyList;
       
       	RecordtypeIds__c orecordType2 = new RecordtypeIds__c ();
        orecordType2.name ='Pre-Pipeline Opportunities';       
        orecordType2.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Pre_Pipeline_Opportunity' LIMIT 1].Id; 
       	insert orecordType2;
        
        RecordtypeIds__c orecordType1 = new RecordtypeIds__c ();
        orecordType1.name ='Pipeline Opportunities';       
        orecordType1.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Pipeline_Opportunity' LIMIT 1].Id; 
        insert orecordType1;

        User bdeUser = new User(alias = 'newUser9', email = 'user@mydomain.com',
                emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = p.Id, employeenumber = '0144020',
                Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite', timezonesidkey = 'America/Los_Angeles', username = p.id+'user89@mydomain.com', Rep_Type_Description__c = 'test'); 
        insert bdeUser;
       
       	system.runAs(bdeUser){
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'ODTDG_PermissionSet'];
            insert new PermissionSetAssignment(AssigneeId = bdeUser.id, PermissionSetId = ps.Id);
           
        lead ld = new lead();
        ld.FirstName='rohit';
        ld.LastName='sharma';
        ld.Email='testfirst.testlast@test.com';
        ld.Company='TCS';
        ld.hasActiveTrial__c = true;
        insert ld;

        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today()+7;
        trl.External_Account_Number__c = '4332938';
        trl.Lead__c = ld.id;
        insert trl;
        
        //Sales Qualified
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(ld.id);
        lc.setDoNotCreateOpportunity(FALSE);
        lc.setConvertedStatus('Sales Qualified');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        system.debug(LoggingLevel.INFO,'Convert Results......'+lcr);
        system.debug(LoggingLevel.INFO,'ld.isConverted......'+ld.isConverted);
        
        system.assert(lcr.isSuccess() == TRUE,'Lead has been converted...');
        }

    }

}