/*============================================================================================
    Name                : Ecom_AccountExecutiveBatch_Test
    Description         : Test class for Ecom_AccountExecutiveBatch, which is a batch class which sets the Opportunity owner for New Sales orders 

    DATE          DEVELOPER          CHANGE HISTORY
    12-08-2020    Brenda Shields     DLT-21195 : [INC3695907] [NSE] [SLF]| Reps are not receiving email notifications when an NSE sale is closed in their territory
                                                 Updated for PMD Violations and code coverage
    07-21-2021    Brenda Shields     DLT-21912 : Update code to determine rep Territory role based on Account SSD information (not info on the quote)                                                 
==============================================================================================*/
@isTest
public class Ecom_AccountExecutiveBatch_Test {
    
    public static product2 p1;
    public static APTSECOM_Store__c store;
    public static Apttus_Config2__PriceList__c priceList;
    public static Account acc;
    public static String orderId;
    public static String accssdid;
    public static Source_System_Detail__c accountSSDlst;
    public static string categoryId;
    public static string userId;
    
    @testSetup 
    static void setup(){
    	
    	//disable functions blocking tests from running
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Apttus_Config2__PriceList__c priceList1 = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList1;
        priceList = priceList1;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';
        insert pbook;
        
        KeyValueListStore__c testKeyValueSetting= new KeyValueListStore__c();
        testKeyValueSetting.name = 'ANZUsersProfileId';
        testKeyValueSetting.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;    
       
        insert testKeyValueSetting;
        
        List<RecordtypeIds__c> rectype = new List<RecordtypeIds__c>();
        RecordtypeIds__c recordTypeIds = new RecordtypeIds__c();
        recordTypeIds.name = 'Pre-Pipeline Opportunities';
        recordTypeIds.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;    
        rectype.add(recordTypeIds);
        
        RecordtypeIds__c recordTypeIds1 = new RecordtypeIds__c();
        recordTypeIds1.name = 'Pipeline Opportunities';
        recordTypeIds1.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;    
        rectype.add(recordTypeIds1);
        insert rectype;
        
        list<WebServiceSettings__c> webServiceList = new list<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webServiceList;
        
        Product2 p2 = DCTestData.createProduct('WestLaw Product', '42009581','42009634','Arizona');
        p1 = p2;
        
        APTSECOM_Store__c store1 = DCTestData.createStore('Small Law', null,priceList.Id);
        insert store1;
        store = store1;
             
        Apttus_Config2__Order__c od = DCTestData.createOrder(priceList.id,store.id );
        insert od;
        orderId = od.Id;
        
        DateTime myDateTime = DateTime.now();
        system.debug(LoggingLevel.INFO, 'myDateTime.millisecond() ? '+myDateTime.getTime());
        Account acc1 = DCTestData.createAccount('Test Account');
        acc1.SAPAccountNumber__c = '1004284494'; 
        acc1.ECC_Dynamic_Segment_L2__c = 'Small Law';
        acc1.ECC_Segment_Level_2__c = 'Small Law';
        insert acc1;
        acc = acc1;
        
        Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
        mainCategory.Apttus_Config2__HierarchyLabel__c = 'Ecom-Small Law';
        mainCategory.Name = 'Ecom-Small Law';
        Insert mainCategory;
        
        Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        
        hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierMain.Name = 'Ecom-Small Law';
        hierMain.Apttus_Config2__Label__c = 'Ecom-Small Law';
        hierMain.Apttus_Config2__Level__c = 0;
        Insert hierMain;
        
       
        List<Apttus_Config2__ClassificationHierarchy__c> level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        hierPL.Apttus_Config2__Level__c = 1;
        hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPL.Name = 'Premium';
        hierPL.Apttus_Config2__Label__c = 'Premium';
        hierPL.DC_Sequence_No__c = 1;
        
        level1HierList.add(hierPL);
        insert level1HierList;
        
        categoryId = hierPL.Id;
                
        
        Source_System_Detail__c ssd = createSourceSystemDetail(acc);
        ssd.BU_Segment_Level_2__c = 'Small Law';
        ssd.ECC_Dynamic_Segment_L2__c = 'Small Law';
        update ssd;
        
        String newUser = createUser();
        
        AccountTeamMember accTM = new AccountTeamMember();
        accTM.accountid = acc.Id;
        accTM.TeamMemberRole = 'SAM-Small Law-Sales Rep';
        accTM.userid = newUser;
        insert accTM;

        Opportunity opty = DCTestData.createOpportunityRec( 'TestOpty', acc.Id,  'Contract Signed',  System.Today() + 30, String.valueOf(ssd.Id));
        opty.Probability = 95;
        opty.Is_Digital_New_Sales__c = true;
        opty.ownerId = newUser;
        insert opty;

        Apttus_Proposal__Proposal__c quote = createQuote(acc.Id,'New Sales');
        quote.Apttus_Proposal__Opportunity__c = opty.Id;   
        quote.APTS_SSD_bill_to__c = ssd.Id;
        insert quote;
        
    }
    
    @isTest static void accExectest() {
    
        test.starttest();
        try {
        	Ecom_AccountExecutiveBatch dmc = new Ecom_AccountExecutiveBatch();
        	Database.executeBatch(dmc,1);
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
         
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp Owner Updated should be false');
        test.stoptest();
    }
   
    @isTest static void accExecExistingTask() {
 
        test.starttest();
        
        Opportunity oOppRecord = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        Task task = new Task();
        task.Subject = Label.Ecom_AccountExecutiveActivity;    //'NSE - Account Executive updated'
        task.Status = 'Completed';
        task.Status__c = 'Completed';
        task.Description = Label.Ecom_AccountExecutiveActivity;     //'NSE - Account Executive updated' 
        task.whatid = oOppRecord.Id;
        task.ActivityDate = System.today();
        insert task;     
                
        try {
        	Ecom_AccountExecutiveBatch dmc = new Ecom_AccountExecutiveBatch();
        	Database.executeBatch(dmc,1);
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
         
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp Owner Updated should be false');
        test.stoptest();
    } 
        
    @isTest static void accExecMethods() {
    
    	test.starttest();
        Opportunity oOppRecord = [Select id, Is_Digital_Owner_Updated__c, owner.Id from Opportunity LIMIT 1];
        Apttus_Proposal__Proposal__c oProposal = [Select id from Apttus_Proposal__Proposal__c LIMIT 1];
        User oUser = [select id from User limit 1];
        Ecom_UtilMapping__mdt lstMapping = [SELECT Ecom_AccountTeamRole__c, Ecom_ProposalBU__c, Digital_Firm__c,
            						Priority__c, Exclude__c, Bypass__c 
            						from Ecom_UtilMapping__mdt 
            						WHERE Ecom_DigitalQuoteType__c = 'New Sales' LIMIT 1];

        try {
        	Task oTask = Ecom_AccountExecutiveBatch.addactivity(oOppRecord.Id);
        	// test setting up normal territory owner        	
        	oOppRecord = Ecom_AccountExecutiveBatch.setOppOwner(oOppRecord.Id, oUser.Id, lstMapping);
        	oProposal = Ecom_AccountExecutiveBatch.updateProposal(oProposal, oUser.Id, lstMapping);
        	// test excluded owner
        	lstMapping.Exclude__c = true;
        	lstMapping.Bypass__c = false;
        	oOppRecord = Ecom_AccountExecutiveBatch.setOppOwner(oOppRecord.Id, oUser.Id, lstMapping);
        	oProposal = Ecom_AccountExecutiveBatch.updateProposal(oProposal, oUser.Id, lstMapping);
        	// test bypass owner        	
        	lstMapping.Exclude__c = false;
        	lstMapping.Bypass__c = true;
        	oOppRecord = Ecom_AccountExecutiveBatch.setOppOwner(oOppRecord.Id, oUser.Id, lstMapping);
        	oProposal = Ecom_AccountExecutiveBatch.updateProposal(oProposal, oUser.Id, lstMapping);        	
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
         
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp Owner Updated should be false');
        test.stoptest();
    }
    
    @isTest static void accTestTerritories() {
    
    	test.starttest();
    	// insert territories 
    	Account oAccount = [select id from Account limit 1];
    	insertTestTerritory(oAccount.id);
    	
        list<Opportunity> oOppRecord = [Select id, Is_Digital_Owner_Updated__c, owner.Id from Opportunity LIMIT 1];
        list<Apttus_Proposal__Proposal__c> oProposal = [Select id from Apttus_Proposal__Proposal__c LIMIT 1];
        list<Task> oTask = new list<Task>();
        
        Task task = new Task();
        task.Subject = Label.Ecom_AccountExecutiveActivity;    //'NSE - Account Executive updated'
        task.Status = 'Completed';
        task.Status__c = 'Completed';
        task.Description = Label.Ecom_AccountExecutiveActivity;     //'NSE - Account Executive updated' 
        task.whatid = oOppRecord[0].Id;
        task.ActivityDate = System.today();
        oTask.add(task);
        
        try {
        	Ecom_AccountExecutiveBatch dmc = new Ecom_AccountExecutiveBatch();
        	Database.executeBatch(dmc,1);
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
         
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp Owner Updated should be false');
        test.stoptest();
    }
    
    @isTest static void accExecScheduletest(){
    
        //list<Apttus_Proposal__Proposal__c> proposalList = [select id,Digital_Quote_Type__c,Apttus_Proposal__Opportunity__c,APTS_Proposal_Business_Unit__c, APTS_Customer_Pricing_Segment__c,Apttus_Proposal__Opportunity__r.Probability,Apttus_Proposal__Account__c, Apttus_Proposal__Opportunity__r.StageName, Apttus_Proposal__Approval_Stage__c,Digitally_Signed_Date__c,Is_Digital_New_Sales__c,APTS_SSD_bill_to__r.Source_System_Account_Number__c from Apttus_Proposal__Proposal__c where Is_Digital_New_Sales__c = TRUE AND Digital_Quote_Type__c = 'New Sales' AND Apttus_Proposal__Account__c != NULL AND Apttus_Proposal__Approval_Stage__c = 'Accepted' AND Digitally_Signed_Date__c != NULL AND APTS_SSD_bill_to__r.Source_System_Account_Number__c != NULL AND Apttus_Proposal__Opportunity__r.Probability >= 95 AND APTS_Customer_Pricing_Segment__c != NULL AND Apttus_Proposal__Opportunity__r.StageName IN ('Contract Signed','Order Complete')];
               
        test.starttest();
        try {
        	Ecom_AccountExecutiveSchedulable schdJob = new Ecom_AccountExecutiveSchedulable();
        	String sch = '0 0 23 * * ?'; 
        	system.schedule('Test Account Exec', sch, schdJob ); 
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp Owner Updated should be false');
        test.stoptest();            
    }
    
    @isTest static void accExecExtest(){
    
		test.starttest();
       	try {
        	Ecom_AccountExecutiveBatch dmc = new Ecom_AccountExecutiveBatch();
			dmc.createExceptionLog('Makeexception','testclass','coverage');
        	Database.executeBatch(dmc,1);
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp Owner Updated should be false');
        test.stoptest();
    
    }
    
    
   /** 
 	* @description : createUser method - creates test user
 	* @return user id
 	*/     
     public static String createUser() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name='ANZ Users' LIMIT 1];
        
        User oUser = new User();
        oUser.FirstName = 'Test';
        oUser.LastName = 'User';
        oUser.Email = 'test.user@email.xxx';
        oUser.Alias = 'tuser';
        oUser.EmailEncodingKey = 'UTF-8';
        oUser.LanguageLocaleKey = 'en_US'; 
        oUser.LocaleSidKey = 'en_US';
        oUser.ProfileId = p1.Id;
        oUser.TimeZoneSidKey = 'America/Los_Angeles'; 
        oUser.UserName = 'Test.User@testorg.com';
        oUser.Sub_Bu__c='USL';
        insert oUser;
        userId = oUser.Id;
        return userId;
    }
    
    
   /** 
 	* @description : createQuote method - create Test quote
 	* @param accountId : account id
 	* @param type1 : quote type
 	* @return Proposal record
 	*/     
     public static Apttus_Proposal__Proposal__c createQuote(String accountId, String type1) {    
        
        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Digital_Quote_Type__c = type1; 
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = true;
        q1.Apttus_Proposal__Account__c = accountId;
        q1.Apttus_QPConfig__BillToAccountId__c = accountId;
        q1.Apttus_QPConfig__ShipToAccountId__c = accountId;
        q1.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        q1.APTS_Customer_Pricing_Segment__c = 'Law Firm';
        q1.Digitally_Signed_Date__c =  Date.today();
      
        
        return q1;
    }
    
    
   /** 
 	* @description : create SSD Account method - Create Source System Detail Account
 	* @param acc : Account id
 	* @return SSD Account record
 	*/     
     public static Source_System_Detail__c createSourceSystemDetail(Account acc){
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID; 
        accountSSD.Account_Inactive__c = false;  
        accountSSD.Source_System_Account_Number__c = '1004284494';  
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
        accountSSD.LCRM_SAP_Account_Number__c = '1004284494';        
        accountSSD.LCRM_APTS_Band_Number__c= 1;
        accountSSD.APTS_Customer_Category__c = '3';
        accountSSD.LCRM_eOutput_Eligibility__c= ''; 
        accountSSD.LCRM_Sales_Org__c= 'WEST';
        accountSSD.State__c = 'California';
        accountSSD.LCRM_Customer_Group__c = 'FIRM';
        insert accountSSD;
        accssdid = accountSSD.id;
        accountSSDlst = accountSSD;
        return accountSSD;
        
    }  

    
    private static void insertTestTerritory(Id accId) {
		// build territory structure 
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        
        Territory2Type terrType = [SELECT id FROM Territory2Type LIMIT 1];
        Territory2Model terrModel;
        Territory2 terr;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            
            terrModel = new Territory2Model(DeveloperName='Test_Territory_Model', Name='Test Territory Model');
            insert terrModel;
			// set TMS_Territory_Team_Role__c = 'SAM-Small Law-Sales Rep',
            terr = new Territory2(DeveloperName = 'Test_Territory2', Name = 'Test Territory2', Territory2ModelId = terrModel.id, Territory2TypeId = terrType.id,
            	TMS_Sales_Force_Desc__c = 'SAM', TMS_Market_Segment_Desc__c= 'Small Law', TMS_Rep_Function_Desc__c = 'Sales Rep');
            insert terr;

            User u = [SELECT id FROM User where IsActive = true and ProfileId =: p1.id LIMIT 1];
            UserTerritory2Association userTerr = new UserTerritory2Association(Territory2Id = terr.Id, UserId = u.id);
            insert userTerr;
        }

        ObjectTerritory2Association objectTerr = new ObjectTerritory2Association(ObjectId = accId, Territory2Id = terr.id, AssociationCause = 'Territory2Manual');
        insert objectTerr;
    }  
    
}