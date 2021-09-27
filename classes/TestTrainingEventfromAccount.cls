/**
 * @description : TestTrainingEventfromAccount
 *
 */
@istest
public class TestTrainingEventfromAccount{
	@testSetup
	static void testDataSetUp(){
		KeyValueListStore__c kvs = new KeyValueListStore__c();
		kvs.name = 'ANZUsersProfileId';

		//kvs.TextValue__C = '00e30000001ZUki';
		kvs.TextValue__C = [Select ID
		                    from Profile
		                    where Name = 'ANZ Users'].ID;
		insert kvs;

		List<RecordtypeIds__c> recTList = new List<RecordtypeIds__c>();
		RecordtypeIds__c recT = new RecordtypeIds__c();
		recT.name = 'Pre-Pipeline Opportunities';
		recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT);

		RecordtypeIds__c recT1 = new RecordtypeIds__c();
		recT1.Name = 'Pipeline Opportunities';
		recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
		recTList.add(recT1);

		RecordtypeIds__c orecordType5 = new RecordtypeIds__c();
		orecordType5.name = 'LATAM Renewal Opportunity';
		orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
		recTList.add(orecordType5);

		RecordtypeIds__c orecordType6 = new RecordtypeIds__c();
		orecordType6.name = 'LATAM Renewal Quote';
		orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
		recTList.add(orecordType6);

		insert recTList;

		Profile_List__c objPro = new Profile_List__c();
		objPro.name = 'Partner Portal User';
		objPro.Profile_Name__c = 'Partner Portal User';
		//objPro.ProfileId__c = '00ea00000024JwaAAE';
		objPro.ProfileId__c = [Select ID
		                       from Profile
		                       where Name = 'Partner Portal User'].ID;
		INSERT objPro;

		ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c = 'Sales Qualified');
		insert cl;

		ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c = 'Converted');
		insert cl1;

		TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled', TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
		insert optyStage;

		TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract', TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
		insert optyStage1;

		TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings', TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true, TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head', TRWaySales__I_acknowledge_required__c = true);

		insert exitConfig;

		FieldId__c fi1 = new FieldId__c(AccOnTrainingEvent__c = 'CF00N3000000ALAb5_lkid', ContactOnTrainingEvent__c = 'CF00NS0000001bjmw_lkid', OppOnTrainingEvent__c = 'CF00NS0000001bjn6_lkid', StrategyOnTE__c = 'CF00Na0000009r5ho_lkid');
		insert fi1;

		recordtype accountRT = [select id
		                        from recordtype
		                        where name = 'GLI Account' and sobjecttype = 'Account'
		                        limit 1];
		recordtype opptyRT = [select id
		                      from recordtype
		                      where name = 'GLI Pipeline Opportunity' and sobjecttype = 'Opportunity'
		                      limit 1];
		recordtype conRT = [select id
		                    from recordtype
		                    where name = 'GLI Contact' and sobjecttype = 'Contact'
		                    limit 1];

		Profile ukiProfile = [SELECT Id
		                      FROM profile
		                      WHERE name = 'UKI Users'];
		///UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];

		System.runAs(new User(Id = UserInfo.getUserId())){
			User gliUser = UnitTest.getUserInstance();
			gliUser.Username = 'TestUser1@TR.com';
			gliUser.profileid = ukiProfile.Id;
			gliUser.Sub_Bu__c = 'UKI';
			//gliUser.UserRoleId = ukiRole.Id;
			insert gliUser;
		}

		Account gliAccount = UnitTest.getAccountInstance();
		gliAccount.Name = 'Test Account Training Event';
		gliAccount.Is_GLI__c = true;
		gliAccount.RecordTypeId = accountRT.Id;
		insert gliAccount;

		SFDC_Acct_Plan__c testAccPlan = new SFDC_Acct_Plan__c(Account__c = gliAccount.Id, Name = 'Test Acc Pln', Account_Type__c = 'New Customer', Planning_Year__c = 'FY2012', Plan_Status__c = 'Not Started', Plan_FY_Product_Sales_Goal__c = 1);
		Insert TestAccPlan;

		SFDC_Strategy__c strat = new SFDC_Strategy__c(Name = 'Test', SFDC_Acct_Plan__c = TestAccPlan.Id, Strategy_Status__c = 'Not Started', Est_Comp_Date__c = System.today()+2);
		insert strat;

		Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
		gliOpty.Name = 'Test Opportunity Training Event';
		gliOpty.is_gli__c = true;
		gliOpty.RecordTypeId = opptyRT.Id;
		insert gliOpty;

		Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
		gliContact.LastName = 'Test Contact Training Event';
		gliContact.RecordTypeId = conRT.Id;
		insert gliContact;
	}

	//creating training event from tab
	/*public static testMethod void testCreateTeFromTab(){
	 User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com' LIMIT 1];

	 PageReference oPage = Page.TrainingEventfromAccount;
	 Test.setCurrentPage(oPage);

	 TrainingEventfromAccount controller = new TrainingEventfromAccount(new ApexPages.StandardController(new Training_Event__c(Training_Name__c='Test TE')));
	 Test.startTest();
	 system.runAs(gliUser){
	 controller.onPageLoad();
	 }
	 Test.stopTest();
	 }*/
	//creating training event from account
	/**
	 * testCreateTeFromAccount
	 *
	 * @description : testCreateTeFromAccount
	 */
	public static testMethod void testCreateTeFromAccount(){
		User gliUser = [SELECT id
		                FROM User
		                WHERE Username = 'TestUser1@TR.com'
		                LIMIT 1];
		Account gliAccount = [SELECT Id
		                      FROM Account
		                      LIMIT 1];
		SFDC_Acct_Plan__c testAccPland = [Select id
		                                  from SFDC_Acct_Plan__c
		                                  WHERE Account__c = :gliAccount.id
		                                  limit 1];
		SFDC_Strategy__c stratd = [Select id
		                           from SFDC_Strategy__c
		                           WHERE SFDC_Acct_Plan__c = :testAccPland.id
		                           limit 1];

		PageReference oPage = Page.TrainingEventfromAccount;
		Test.setCurrentPage(oPage);
		ApexPages.currentPage().getParameters().put('CF00N3000000ALAb5_lkid', gliAccount.Id);
		ApexPages.currentPage().getParameters().put('CF00Na0000009r5ho_lkid', stratd.Id);

		TrainingEventfromAccount controller = new TrainingEventfromAccount(new ApexPages.StandardController(new Training_Event__c(Training_Name__c = 'Test TE')));
		Test.startTest();
		system.assertequals(gliUser != null, true, 'Not null');
		system.runAs(gliUser){
			controller.onPageLoad();
		}
		Test.stopTest();
	}

	/**
	 * @description : test class method testCreateTeFromContact
	 */
	public static testMethod void testCreateTeFromContact(){
		User gliUser = [SELECT id
		                FROM User
		                WHERE Username = 'TestUser1@TR.com'
		                LIMIT 1];
		Contact gliContact = [SELECT Id, AccountId, OwnerId
		                      FROM Contact
		                      WHERE LastName = 'Test Contact Training Event'
		                      LIMIT 1];

		PageReference oPage = Page.TrainingEventfromAccount;
		Test.setCurrentPage(oPage);
		ApexPages.currentPage().getParameters().put('CF00NS0000001bjmw_lkid', gliContact.Id);

		TrainingEventfromAccount controller = new TrainingEventfromAccount(new ApexPages.StandardController(new Training_Event__c(Training_Name__c = 'Test TE')));
		//System.Assert(gliUser.Id == gliContact.OwnerId, gliUser.Id +'---'+gliContact.OwnerId);
		Test.startTest();
		system.runAs(gliUser){
			system.assertequals(gliUser != null, true, 'Not null');
			controller.onPageLoad();
		}
		Test.stopTest();
	}

	//creating training event from opportunity
	/**
	 * @description : test class method testCreateTeFromOpportunity
	 */
	public static testMethod void testCreateTeFromOpportunity(){
		User gliUser = [SELECT id
		                FROM User
		                WHERE Username = 'TestUser1@TR.com'
		                LIMIT 1];
		Opportunity gliOpty = [SELECT Id, AccountId
		                       FROM Opportunity
		                       LIMIT 1];

		PageReference oPage = Page.TrainingEventfromAccount;
		Test.setCurrentPage(oPage);
		ApexPages.currentPage().getParameters().put('CF00NS0000001bjn6_lkid', gliOpty.Id);

		TrainingEventfromAccount controller = new TrainingEventfromAccount(new ApexPages.StandardController(new Training_Event__c(Training_Name__c = 'Test TE')));
		Test.startTest();
		system.runAs(gliUser){
			system.assertequals(gliUser != null, true, 'Not null');
			controller.onPageLoad();
		}
		Test.stopTest();
	}

	/**
	 * @description : test class method testTrainingEventfromAccount1
	 */
	public static testmethod void testTrainingEventfromAccount1(){
		Account account = new Account();
		account.Name = 'testAccount';
		account.Customer_Type__c = 'Induvidual';
		account.Customer_Group__c = 'ACADEMIC';
		account.Industry = 'Energy';
		account.SAPAccountNumber__c = '1000550771';
		insert account;
		system.assertequals(account.id != null, true, 'Not null');
		SFDC_Acct_Plan__c testAccPlan = new SFDC_Acct_Plan__c(Account__c = account.Id, Name = 'Test Acc Pln', Account_Type__c = 'New Customer', Planning_Year__c = 'FY2012', Plan_Status__c = 'Not Started', Plan_FY_Product_Sales_Goal__c = 1);
		Insert TestAccPlan;

		SFDC_Strategy__c strat = new SFDC_Strategy__c(Name = 'Test', SFDC_Acct_Plan__c = TestAccPlan.Id, Strategy_Status__c = 'Not Started', Est_Comp_Date__c = System.today()+2);
		insert strat;

		pageReference pgTrainingEventfromAccount = page.TrainingEventfromAccount;
		Test.setCurrentPage(pgTrainingEventfromAccount);
		ApexPages.currentPage().getParameters().put('AccId', account.Id);
		ApexPages.currentPage().getParameters().put('StrategyId', strat.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(new Training_Event__c(Training_Name__c = 'testTrainingEvent'));

		TrainingEventfromAccount controller = new TrainingEventfromAccount(sc);
		controller.Save();
		controller.Cancel();
	}
}