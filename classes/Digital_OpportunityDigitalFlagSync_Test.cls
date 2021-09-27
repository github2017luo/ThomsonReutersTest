/**
 * This test class is used to test the Digital_OpportunityDigitalFlagSyn class.  Digital_OpportunityDigitalFlagSyn is a batch
 * class to sync Digital Subscriptions with Opportunities and update the Opportunities as needed.
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-10-18   Brenda Shields          Created for CX Digital Project
 * 2019-03-01   Brenda Shields          DLT-15263 - Add SSD to Opportunity if it's not there already
 * 2019-03-20   Navleen Kaur            DLT-15672  [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
 * 2019-06-24   Brenda Shields          DLT-16903 - Combine code for Opportunity update/creation for the Automation process
 * 2019-07-08   Brenda Shields          DLT-16681 - set Sub Campaign Code in Opp if it's created or updated
 * 2020-08-12   Brenda Shields          DLT-20482 - [SFDC] [REN] Opportunity Creation - increase code coverage
 * 2020-10-27   Brenda Shields          DLT-21010 - Create new Opp if a finance one is not found (remove contract type logic for early renewals) 
 *                                                  Update for test coverage and PMD Violations
 * 2020-12-23   Brenda Shields          DLT-21196 - Update to Territory Roles --- Updated for additional PMD changes 
 * 2021-03-17   Brenda Shields          DLT-21426 - DLT-21425 - Add method to update DS records with message if any errors occur
 * =============================================================================
 */
/** 
 * @description : Test Class for Digital_OpportunityDigitalFlagSync class
 */ 
@isTest(seealldata=false)
public with sharing class Digital_OpportunityDigitalFlagSync_Test {
    
    public static String accountId;
    public static String oppId;
    public static String quoteId;
    public static string attachmentId;
    public static String accssdid;

    // Create basic Account and Opportunity Data
    @testSetup
    static void setup(){
        list<String> lstCampaigns = new list<String>(Label.Digital_Opp_Sync_Campaigns.split(','));
        string strCCode = lstCampaigns.get(0);
        
        // create account, ssd and opp      
        DCTestData.createData();
        Test.startTest();
        DCTestData.createPaymentCreditWebService();
        DCTestData.createPaymentAutoCharge();
        DCTestData.createQuote();
            
        // this is a Findlaw user
        DCTestData.CreateUser();
        User oUser = [SELECT Id, Name FROM User WHERE FirstName = 'Test' limit 1];
                      
        // update renewal date on Opp
        Opportunity oOpp = new Opportunity();
        oOpp.Owner = oUser;
        oOpp.id = DCTestData.oppId;
        oOpp.StageName = 'Contacting';
        oOpp.isDigitalSpearhead__c = false;
        oOpp.Unmarked_Digital_Channel__c = false;
        oOpp.DRS_Status_Digital__c = '';
        oOpp.Campaign_Code__c = strCCode;
        
        oOpp.Renewal_Date__c = system.today()+30;
        update oOpp;  
        oppId = oOpp.id;  

        // we need contact and Account SSD for link
        Source_System_Detail__c oAcctSSD = [Select id, Name, Account_Name__c, Source_System_Account_Number__c, Digital_Firm__c
                                        FROM Source_System_Detail__c limit 1];
        Contact oContact = [Select id, SAP_Role__c, SAP_Contact_ID__c, Email from Contact limit 1];                                        
        LCRM_Contact_SSD__c oContSSD = DCTestData.createContactSSD(oContact, oAccTSSD);
		system.debug(logginglevel.INFO, 'SSD Contacts: ' + oContSSD);
		
        // create a matching Digital Subscription record
        Product_Account_Detail__c prodAcctDetail = DCTestData.createDigitalSubscriptions('42072689','42072690', 'Plus', '1004284494', System.Today()+30, strCCode);
        prodAcctDetail.Current_Subscription__c = '41010973';
        update prodAcctDetail;
        Test.StopTest();
    }
    
    static testmethod void testDigitalReady() {
        list<String> lstDigitalReady = new list<String>(Label.Digital_Opp_Sync_ReadyDateRange.split(','));  
            
        // Test for Opp Renewal that is Ready for Renewal processing
        Test.startTest();   
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
        
        // Check to see if the Opp status has been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = true LIMIT 1];
        system.AssertEquals(lstDigitalReady[2], oOppty.DRS_Status_Digital__c, 'DRS Status should be set');   // 'Digital / Ready for Channel'
    }
    
    static testmethod void testDigitalOnly() {
        list<String> lstDigitalOnly = new list<String>(Label.Digital_Opp_Sync_OnlyDateRange.split(','));  
        
        // Test for Opp Renewal that is Digital only
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c, AccountId, Source_System_Detail__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today() + 140;
        oOpp.Name = oOpp.Name = '-FL-DigitalOpp';
        update oOpp;
        
        Product_Account_Detail__c oDigSub  = [SELECT id, Renewal_Date__c from Product_Account_Detail__c limit 1];
        oDigSub.Renewal_Date__c = system.today() + 140;
        oDigSub.Current_Subscription__c = '42072689';
        oDigSub.Bypass_Automation__c = false;
        update oDigSub; 
        
        Test.startTest();  
        
        Opportunity oNewOpp = DCTestData.createOpportunityRec('Test Old Opp', oOpp.AccountId, 'Appointment Scheduled', system.today()+30, oOpp.Source_System_Detail__c);
        oNewOpp.Renewal_Date__c = system.today()-20;
        oNewOpp.Unmarked_Digital_Channel__c = false;
        oNewOpp.DRS_Status_Digital__c = 'Digital Only';
        oNewOpp.isDigitalSpearhead__c = true;
        oNewOpp.Campaign_Code__c = 'OldCampaign';
        insert oNewOpp;
        
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
        
        // Check to see if the Opp status has been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = true LIMIT 1];
        system.AssertEquals(lstDigitalOnly[2], oOppty.DRS_Status_Digital__c, 'DRS Status should be set');   // 'Digital Only'
    }  
 
     static testmethod void testDigitalFindLaw() {
        list<String> lstDigitalOnly = new list<String>(Label.Digital_Opp_Sync_ReadyDateRange.split(','));  
        
        // Test for Opp Renewal that is Digital only
        
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c, AccountId, Source_System_Detail__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today() + 140;
        oOpp.Name = oOpp.Name = '-FL-DigitalOpp';
        update oOpp;
        
        // set up FindLaw test to create new FindLaw Opp
        Product_Account_Detail__c oDigSub  = [SELECT id, Renewal_Date__c from Product_Account_Detail__c limit 1];
        oDigSub.Digital_Firm__c = 'FindLaw';
        oDigSub.Current_Subscription__c = '42072689';
        oDigSub.Bypass_Automation__c = false;
        update oDigSub; 
        
        Test.startTest();  
        
        Opportunity oNewOpp = DCTestData.createOpportunityRec('Test Old Opp', oOpp.AccountId, 'Appointment Scheduled', system.today()+30, oOpp.Source_System_Detail__c);
        oNewOpp.Renewal_Date__c = system.today()-20;
        oNewOpp.Unmarked_Digital_Channel__c = false;
        oNewOpp.DRS_Status_Digital__c = 'Digital Only';
        oNewOpp.isDigitalSpearhead__c = true;
        oNewOpp.Campaign_Code__c = 'OldCampaign';
        insert oNewOpp;
        
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
        
        // Check to see if the Opp status has been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = true LIMIT 1];
        system.AssertEquals(lstDigitalOnly[2], oOppty.DRS_Status_Digital__c, 'Digital / Ready for Channel');   // 'Digital Only'
    }
    
    static testmethod void testDigitalMidContract() {
        list<String> lstMidContract = new list<String>(Label.Digital_Opp_Sync_MidContractDateRange.split(',')); 
        
        // Test for Opp Renewal that is Mid Contract
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today() + 300;
        update oOpp;
        
        Product_Account_Detail__c oDigSub  = [SELECT id, Renewal_Date__c, Contract_Type__c
                            from Product_Account_Detail__c limit 1];
        oDigSub.Renewal_Date__c = system.today() + 300;
        oDigSub.Contract_Type__c = 'Old Mid Contract';
        update oDigSub; 
        
        Test.startTest();   
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
        
        // Check to see if the opp status has been udpated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where id =: oOpp.Id limit 1]; //isDigitalSpearhead__c = true and Digital_Mid_Contract__c = true LIMIT 1];
        system.AssertEquals(lstMidContract[2], oOppty.DRS_Status_Digital__c, 'DRS Status should be set');   // 'Digital Only'
    }  

     static testmethod void testDigitalNoSSD() {

        // create a matching Digital Subscription record
        Product_Account_Detail__c prodAcctDetail = DCTestData.createDigitalSubscriptions('42072689','42072690', 'Plus', '1004284494', System.Today()+30, '00237KI');
        prodAcctDetail.Current_Subscription__c = '41010973';
        prodAcctDetail.Digital_Firm__c = 'FindLaw';
        prodAcctDetail.Bypass_Automation__c = false;
        update prodAcctDetail;

        list<String> lstCampaigns = new list<String>(Label.Digital_Opp_Sync_Campaigns.split(','));
        system.debug(logginglevel.INFO, 'Default Campaigns: ' + lstCampaigns);
        
        // Test for Opp where there is not a lookup to a SSD record
        // Account.SAPAccountNumber__c
        Opportunity oOpp = [SELECT id,AccountId,SAP_Account_Number__c,Source_System_Detail__c,Campaign_Code__c,Stagename,DRS_Status_Digital__c,isDigitalSpearhead__c FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        
        //oOpp.SAP_Account_Number__c = '';
        oOpp.Source_System_Detail__c = null;
        // updated to bypass process builder error
        oOpp.Latam_Is_System_Generated__c = true;
        oOpp.Campaign_Code__c = '00237KI';
        oOpp.DRS_Status_Digital__c ='';
        oOpp.Renewal_Date__c = System.Today()+30 ;
        oOpp.Unmarked_Digital_Channel__c = true;
        update oOpp;
                
        Test.startTest();   
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
                
        // Check to see if the opp status has not been updagted
        system.AssertEquals(false, oOpp.isDigitalSpearhead__c, 'Opp should not be marked as Digital');
    }
      
    static testmethod void testDigitalNoOpps() {        
        // test returns no Opp results to the class due to renewal date  
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today();
        oOpp.Campaign_Code__c = 'test';
        update oOpp;
       
        Test.startTest();   
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();

        // Check to see if the status has not been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = false limit 1]; 
        system.AssertEquals(null, oOppty.DRS_Status_Digital__c, 'DRS Status should not be set');        
    }
    
    static testmethod void testDigitalContact() {        
        // test returns no Opp results to the class due to renewal date  
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today();
        oOpp.Campaign_Code__c = 'test';
        update oOpp;
                                        
        LCRM_Contact_SSD__c oContSSD = [Select id from LCRM_Contact_SSD__c limit 1]; 
        oContSSD.Contact_Inactive__c = true;
        update oContSSD;
        
        Test.startTest();   
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();

        // Check to see if the status has not been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = false limit 1]; 
        system.AssertEquals(null, oOppty.DRS_Status_Digital__c, 'DRS Status should not be set');        
    }  
    
     static testmethod void testDigitalInactiveContact() {   
        list<String> lstDigitalOnly = new list<String>(Label.Digital_Opp_Sync_OnlyDateRange.split(','));  
        system.debug(logginglevel.INFO, 'Date Range: ' + lstDigitalOnly);
        
        // Test for Opp Renewal that is Digital only
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Digital_PreviousStageName__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today() + 140;
        oOpp.Name = oOpp.Name = '-FL-DigitalOpp';
        update oOpp;
        
        Product_Account_Detail__c oDigSub  = [SELECT id, Renewal_Date__c from Product_Account_Detail__c limit 1];
        oDigSub.Renewal_Date__c = system.today() + 140;
        update oDigSub; 
        
        Contact oContact = [Select id from Contact limit 1]; 
        oContact.Contact_Inactive__c = true;
        update oContact;
                                  
        LCRM_Contact_SSD__c oContSSD = [Select id from LCRM_Contact_SSD__c limit 1]; 
        oContSSD.Contact_Inactive__c = true;
        update oContSSD;
        
        Test.startTest();   
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
  
        // Check to see if the status has not been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = false limit 1]; 
        system.AssertEquals(null, oOppty.DRS_Status_Digital__c, 'DRS Status should not be set'); 
    
    } 
               
    static testmethod void testDigitalSchedule() {
        // test schedule class
        Test.startTest();   
        Digital_OpportunityDigitalFlagSyncSch dc = new Digital_OpportunityDigitalFlagSyncSch();
        dc.execute(null);        
        Test.stopTest();
        
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = true LIMIT 1];
        system.AssertEquals('Digital / Ready for Channel', oOppty.DRS_Status_Digital__c, 'DRS Status should be set');
    }


    static testmethod void buildTeamMemberMapTest() {
    	map<string, string> mapAcctMidContract = new map<string, string>(); 
		Account oAcct = [SELECT id FROM Account]; 
		mapAcctMidContract.put(oAcct.Id, 'New Mid Contract');
		
        Territory2Type terrType = [SELECT id FROM Territory2Type LIMIT 1];
        Territory2Model terrModel;
        Territory2 terr;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            
            terrModel = new Territory2Model(DeveloperName='Test_Territory_Model',Name='Test Territory Model');
            insert terrModel;

            terr = new Territory2(DeveloperName='Test_Territory2', Name='Test Territory2', Territory2ModelId=terrModel.id, Territory2TypeId=terrType.id,
                TMS_Sales_Force_Desc__c='SAM',TMS_Market_Segment_Desc__c='Medium Law',TMS_Rep_Function_Desc__c='Account Manager');
            insert terr;

            User u = [SELECT id FROM User where IsActive = true LIMIT 1];
            UserTerritory2Association userTerr = new UserTerritory2Association(Territory2Id=terr.Id,UserId=u.id);
            insert userTerr;
        }

        Account acc = [SELECT id FROM Account LIMIT 1];
        ObjectTerritory2Association objectTerr = new ObjectTerritory2Association(ObjectId=acc.Id,Territory2Id=terr.id,AssociationCause='Territory2Manual');
        insert objectTerr;

        Set<String> accIds = new Set<String>();
        accIds.add(acc.Id);
        Test.startTest();
        Map<string, id> teamMap = Digital_OpportunityDigitalFlagSyncUtil.buildTeamMemberMap(accIds, mapAcctMidContract);
        System.assert(teamMap != null,'teamMap is null');
        Test.stopTest();
    }
                          
       static testmethod void testDigitalError() {
        // test error handler
        Test.startTest();   
        list<Product_Account_Detail__c> listDSUpdate = new list<Product_Account_Detail__c>();
        // setup an update to call error processing
        Product_Account_Detail__c oDigSub  = [SELECT id, Renewal_Date__c from Product_Account_Detail__c limit 1];
        id idOriginalID = oDigSub.Id;
        // set id to null to cause an update error
     	oDigSub.id = null;
        oDigSub.Digital_Firm__c = 'FindLaw';
        oDigSub.Current_Subscription__c = '42072689';
        oDigSub.Bypass_Automation__c = false;
        listDSUpdate.add(oDigSub);
        
        Database.UpsertResult[] lsr;
        lsr =  Database.upsert(listDSUpdate, false);
		Digital_OpportunityDigitalFlagSyncUtil.handleException(0, lsr, oDigSub.Id);
		      
        Product_Account_Detail__c oDSRecord  = [SELECT id, Renewal_Date__c from Product_Account_Detail__c limit 1];
		system.assertEquals(oDSRecord.id, idOriginalID, 'DS Record should be available');     
        Test.stopTest();
        
    }
    
    
    static testmethod void testDigitalWithManual() {
        list<String> lstDigitalOnly = new list<String>(Label.Digital_Opp_Sync_OnlyDateRange.split(','));  
		// get DS record
        Product_Account_Detail__c oDigSub  = [SELECT id, Renewal_Date__c, AccountSSD__c, ZP_Cust_Number__c  
        			from Product_Account_Detail__c limit 1];
        oDigSub.Renewal_Date__c = system.today() + 140;
        oDigSub.Current_Subscription__c = '42072689';
        oDigSub.Digital_Firm__c = 'Corp-SMB';
        oDigSub.Bypass_Automation__c = false;
        update oDigSub; 
        
        // Test for Opp Renewal that is Digital only
        Opportunity oOpp = [SELECT id, Renewal_Date__c, StageName, Campaign_Code__c, Digital_PreviousStageName__c, AccountId, Source_System_Detail__c
                            FROM Opportunity 
                            WHERE StageName = 'Contacting'];
        oOpp.Renewal_Date__c = system.today() + 140;
        oOpp.Name = oOpp.Name = '-DigitalOpp';
        oOpp.Digital_Firm__c = 'Corp-SMB';
        update oOpp;
        
        Test.startTest();  
        // create manual Opp
        Opportunity oNewOpp = DCTestData.createOpportunityRec('Test Old Opp', oOpp.AccountId, 'Appointment Scheduled', system.today()+30, oOpp.Source_System_Detail__c);
        oNewOpp.Renewal_Date__c = oOpp.Renewal_Date__c;
        oNewOpp.Unmarked_Digital_Channel__c = false;
        oNewOpp.DRS_Status_Digital__c = 'Digital Only';
        oNewOpp.isDigitalSpearhead__c = true;
        oNewOpp.Campaign_Code__c = oOpp.Campaign_Code__c;
        // 50% probability
        oNewOpp.StageName = 'Solution Recommended';
        insert oNewOpp;
        
        //Create Rep Driven quote
        Apttus_Proposal__Proposal__c cproposal = DCTestData.createQuote(oOpp.AccountId, 'Manual');
        cproposal.APTS_SSD_Sold_To__c = oOpp.Source_System_Detail__c;
        cproposal.APTS_SSD_bill_to__c = oOpp.Source_System_Detail__c;
        cproposal.Apttus_Proposal__Opportunity__c = oNewOpp.Id;                                                       
        insert cproposal;
        
        Digital_OpportunityDigitalFlagSync dc = new Digital_OpportunityDigitalFlagSync();
        database.executebatch(dc,5); 
        Test.stopTest();
        
        // Check to see if the Opp status has been updated
        Opportunity oOppty = [Select id, DRS_Status_Digital__c from Opportunity where isDigitalSpearhead__c = true LIMIT 1];
        system.AssertEquals(lstDigitalOnly[2], oOppty.DRS_Status_Digital__c, 'DRS Status should be set');   // 'Digital Only'
    } 
    
}