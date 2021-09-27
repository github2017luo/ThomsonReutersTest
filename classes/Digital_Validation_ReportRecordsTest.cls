/***************************************************************************************************
    CLASS NAME  : Digital_Validation_ReportRecordsTest
    DESCRIPTION : Test Class for record creation of all Digital Validation Cohort classes
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 07-10-2020      Brenda Shields          DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
====================================================================================================*/

@isTest
public class Digital_Validation_ReportRecordsTest {
	
	public static list<Account> acclist = new list<Account> ();
    public static list<Contact> conList = new list<Contact> ();
    public static list<Source_System_Detail__c> ssdList = new list<Source_System_Detail__c> ();
    public static list<Opportunity> oppList = new list<Opportunity> ();
    public static list<Apttus_Proposal__Proposal__c> qlist = new list<Apttus_Proposal__Proposal__c> ();
    public static list<Product_Account_Detail__c> dslist = new list<Product_Account_Detail__c> ();
    public static list<Product2> pList = new list<Product2> ();
    public static list<Apttus_Config2__AssetLineItem__c> assetList = new list<Apttus_Config2__AssetLineItem__c> ();
    public static list<Digital_Settings__c> dsSettingsList = new list<Digital_Settings__c> ();
    public static list<Digital_Customer__c> dsCustomerList = new list<Digital_Customer__c> ();

    public static void digitalValidationCreateRecords() {

		// create basic test data
		// web store/ opp record types/ DS records
		createBasicTestData();
        
        Account ac0 = new Account();
        ac0.Name = 'Test Account0';
        ac0.Email__c = null;
        ac0.Phone = null;
        ac0.Bu_Segment__c = null;
        acclist.add(ac0);

        Account ac1 = new Account();
        ac1.Name = 'Test Account1';
        ac1.Email__c = null;
        ac1.Phone = null;
        ac1.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac1.Bu_Segment__c = 'Government';
        acclist.add(ac1);

        Account ac2 = new Account();
        ac2.Name = 'Test Account2';
        ac2.Email__c = 'test.account@thomsonreuters.com';
        ac2.Phone = '9876543210';
        ac2.Bu_Segment__c = 'Professional Legal';
        acclist.add(ac2);

        Account ac3 = new Account();
        ac3.Name = 'Test Account3';
        ac3.Email__c = 'test.account@thomsonreuters.com';
        ac3.Phone = '9876543210';
        ac3.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac3.Bu_Segment__c = 'Government';
        acclist.add(ac3);

        Account ac4 = new Account();
        ac4.Name = 'Test Account4';
        ac4.Email__c = 'test.account@thomsonreuters.com';
        ac4.Phone = '9876543210';
        ac4.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac4.Bu_Segment__c = 'Government';
        acclist.add(ac4);

        Account ac5 = new Account();
        ac5.Name = 'Test Account5';
        ac5.Email__c = 'test.account@thomsonreuters.com';
        ac5.Phone = '9876543210';
        ac5.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac5.Bu_Segment__c = 'Government';
        acclist.add(ac5);
        
        // testing for FindLaw
        Account ac6 = new Account();
        ac6.Name = 'Test Account6';
        ac6.Email__c = 'test.account@thomsonreuters.com';
        ac6.Phone = '9876543210';
        ac6.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
        ac6.Bu_Segment__c = 'Professional Legal';
        ac6.ECC_Segment_Level_2__c = 'Small Law';
        acclist.add(ac6);
        
        insert acclist;

		Contact con1 = createContact(1, ac2.Id, null);
		conList.add(con1);
		Contact con2 = createContact(2, ac3.Id, 'Invalid Contact');
		conList.add(con2);
		Contact con5 = createContact(3, ac5.Id, 'Invalid Contact');
		conList.add(con5);
        insert conList;

        Source_System_Detail__c ssd1 = new Source_System_Detail__c();
        ssd1.Name = 'Test SSD1';
        ssd1.Source_System_Name__c = 'Test SSD1';
        ssd1.Account_Name__c = ac1.Id;
        ssd1.LCRM_Email__c = 'test@ssd.com';
        ssd1.LCRM_APTS_Band_Number__c = null;
        ssd1.BU_Segment_Level_2__c = 'Professional Legal';
        ssd1.LCRM_Market_Segment__c = 'Medium Law';
        ssd1.LCRM_Frozen_Market_Segment__c = 'State/Local';
        ssd1.Source_System_Account_Number__c = '100001';
        ssdList.add(ssd1);

        Source_System_Detail__c ssd2 = new Source_System_Detail__c();
        ssd2.Name = 'Test SSD2';
        ssd2.Source_System_Name__c = 'Test SSD2';
        ssd2.Account_Name__c = ac2.Id;
        ssd2.LCRM_Email__c = 'test@ssd.com';
        ssd2.LCRM_APTS_Band_Number__c = 10;
        ssd2.BU_Segment_Level_2__c = 'Solo Law Firm';
        ssd2.LCRM_Market_Segment__c = 'Medium Law';
        ssd2.LCRM_Frozen_Market_Segment__c = 'State/Local';
        ssd2.Source_System_Account_Number__c = '100002';
        ssdList.add(ssd2);

        Source_System_Detail__c ssd4 = new Source_System_Detail__c();
        ssd4.Name = 'Test SSD4';
        ssd4.Source_System_Name__c = 'Test SSD4';
        ssd4.Account_Name__c = ac3.Id;
        ssd4.LCRM_Email__c = null;
        ssd4.BU_Segment_Level_2__c = 'Government';
        ssd4.LCRM_APTS_Band_Number__c = 10;
        ssd4.Source_System_Account_Number__c = '100004';
        ssdList.add(ssd4);

        Source_System_Detail__c ssd5 = new Source_System_Detail__c();
        ssd5.Name = 'Test SSD5';
        ssd5.Source_System_Name__c = 'Test SSD5';
        ssd5.Account_Name__c = ac4.Id;
        ssd5.LCRM_Email__c = null;
        ssd5.BU_Segment_Level_2__c = 'Government';
        ssd5.LCRM_APTS_Band_Number__c = 10;
        ssd5.Source_System_Account_Number__c = '100005';
        ssdList.add(ssd5);

        Source_System_Detail__c ssd6 = new Source_System_Detail__c();
        ssd6.Name = 'Test SSD6';
        ssd6.Account_Name__c = ac4.Id;
        ssd6.BU_Segment_Level_2__c = 'Government';
        ssd6.Source_System_Name__c = 'Test SSD6';
        ssd6.Source_System_Account_Number__c = '100006';
        ssdList.add(ssd6);

        Source_System_Detail__c ssd7 = new Source_System_Detail__c();
        ssd7.Name = 'Test ssd7';
        ssd7.Account_Name__c = ac4.Id;
        ssd7.BU_Segment_Level_2__c = 'Government';
        ssd7.Source_System_Name__c = 'Test ssd7';
        ssd7.Source_System_Account_Number__c = '100007';
        ssdList.add(ssd7);

        Source_System_Detail__c ssd8 = new Source_System_Detail__c();
        ssd8.Name = 'Test ssd8';
        ssd8.Account_Name__c = ac4.Id;
        ssd8.BU_Segment_Level_2__c = 'Government';
        ssd8.Source_System_Name__c = 'Test ssd8';
        ssd8.Source_System_Account_Number__c = '100008';
        ssd8.LCRM_APTS_Band_Number__c = 5;
        ssdList.add(ssd8);

        Source_System_Detail__c ssd9 = new Source_System_Detail__c();
        ssd9.Name = 'Test ssd9';
        ssd9.Account_Name__c = ac4.Id;
        ssd9.BU_Segment_Level_2__c = 'Government';
        ssd9.Source_System_Name__c = 'Test ssd9';
        ssd9.Source_System_Account_Number__c = '100009';
        ssd9.LCRM_APTS_Band_Number__c = 5;
        ssdList.add(ssd9);

        Source_System_Detail__c ssd10 = new Source_System_Detail__c();
        ssd10.Name = 'Test ssd10';
        ssd10.Account_Name__c = ac4.Id;
        ssd10.BU_Segment_Level_2__c = 'Government';
        ssd10.Source_System_Name__c = 'Test ssd10';
        ssd10.Source_System_Account_Number__c = '100010';
        ssd10.LCRM_Email__c = null;
        ssd10.LCRM_APTS_Band_Number__c = null;
        ssdList.add(ssd10);

		// update for SSDCheck segment 
        Source_System_Detail__c ssd11 = new Source_System_Detail__c();
        ssd11.Name = 'Test ssd11';
        ssd11.Account_Name__c = ac5.Id;
        ssd11.BU_Segment_Level_2__c = 'Government';
        ssd11.LCRM_Market_Segment__c = 'Small Law';
        ssd11.LCRM_Frozen_Market_Segment__c = 'FindLaw';
        ssd11.Source_System_Name__c = 'Test ssd11';
        ssd11.Source_System_Account_Number__c = '100011';
        ssd11.LCRM_Email__c = null;
        ssd11.LCRM_APTS_Band_Number__c = null;
        ssdList.add(ssd11);

        Source_System_Detail__c ssd12 = new Source_System_Detail__c();
        ssd12.Name = 'Test ssd12';
        ssd12.Account_Name__c = ac5.Id;
        ssd12.BU_Segment_Level_2__c = 'Government';
        ssd12.Source_System_Name__c = 'Test ssd12';
        ssd12.Source_System_Account_Number__c = '100012';
        ssd12.LCRM_Email__c = null;
        ssd12.LCRM_APTS_Band_Number__c = 5;
        ssdList.add(ssd12);

        Source_System_Detail__c ssd13 = new Source_System_Detail__c();
        ssd13.Name = 'Test ssd13';
        ssd13.Account_Name__c = ac5.Id;
        ssd13.BU_Segment_Level_2__c = 'Government';
        ssd13.Source_System_Name__c = 'Test ssd13';
        ssd13.Source_System_Account_Number__c = '100013';
        ssd13.LCRM_Email__c = null;
        ssd13.LCRM_APTS_Band_Number__c = 5;
        ssdList.add(ssd13);

		// FindLaw testing
		Source_System_Detail__c ssd14 = new Source_System_Detail__c();
        ssd14.Name = 'Test SSD1';
        ssd14.Source_System_Name__c = 'Test SSD1';
        ssd14.Account_Name__c = ac6.Id;
        ssd14.LCRM_Email__c = 'test@ssd.com';
        ssd14.LCRM_APTS_Band_Number__c = null;
        ssd14.BU_Segment_Level_2__c = 'Professional Legal';
        ssd14.LCRM_Market_Segment__c = 'Medium Law';
        ssd14.LCRM_Frozen_Market_Segment__c = 'State/Local';
        ssd14.Source_System_Account_Number__c = '1000000';
        ssdList.add(ssd14);
        
        insert ssdList;
        
		// create SSD Contact
        createSSDContact(con2.id, ssd2.Id);

        
        // create Assets with data specific to each SSD
        createAssets(6, ssd6.Id);
        createAssets(8, ssd8.Id);
        createAssets(10, ssd10.Id);
        insert assetList;

		// create Opportunity and Quote
		//createOppAndQuote(ac5.Id, con5.Id, ssd11.Id);
		createOppAndQuote(ac4.Id, con5.Id, ssd10.Id);

		// created digital customers (moved)
		createCustomers();
		//createMessage(dsCustomerList[16].Id, dsSettingsList[12].Id);
		
		// not needed
        //Digital_Exception_Log__c de1=new Digital_Exception_Log__c();
        //insert de1;

        //dsSettingsList[12].End_Time__c = system.Now(); // dsSettings13.End_Time__c=System.Now();
        //update dsSettingsList[12]; //dsSettings13;     

    }
    
    
    // create basic test data
	public static void createBasicTestData() {
		
		// create key value list stores
		createKeyValueListStores();

		// create Opportunity Record Types
		createOppRecordTypes();
				

        
		// create Digital Setting Records
		createDigitalSettings(); 
		

        
		}
		
		
	// created digital customer
	public static void createCustomers() {
		// create Digital Customer Records
		createDigitalCustomers();
		createMessage(dsCustomerList[16].Id, dsSettingsList[12].Id);
		
		// create all DS records - Small Law, FindLaw
		createDSRecords();
		// create all DS records - Government
		createDSRecordsGov();
        insert dslist;
        
		
	}
		
    public static void createMessage(id custId, Id settingId) {
        Digital_Message__c dm1 =new Digital_Message__c();
        dm1.Name='Test Results';
        dm1.Digital_Customer__c = custId; // dc17.Id;
        dm1.Digital_Settings__c = settingId; // dsSettings13.Id;
        dm1.Message__c='Test Results';

        insert dm1;
	}


    // Create Contact
    public static Contact createContact(integer noContact, Id acctId, string strReason) {
    	
    	Contact oContact = new Contact();
        oContact.FirstName = 'Test' + noContact;
        oContact.LastName = 'Contact' + noContact;
        oContact.AccountId = acctId;
        if (strReason == null) {
        	oContact.Email = null;
        	oContact.Phone = null;
        } else {
        	oContact.Email = 'test@cs.com';
        	oContact.Phone = '1112221234';
        }
        oContact.LCRM_Suppression_Reason__c = strReason;
        return oContact;
    }
    
    
    // create key value list stores
    public static void createKeyValueListStores() {
    	
    	KeyValueListStore__c kvs = new KeyValueListStore__c();
        kvs.name = 'ANZUsersProfileId';
        kvs.TextValue__C = System.Label.Digital_ANZ_User_Profile_Id; //'00e30000001ZUki';

        KeyValueListStore__c kvs1 = new KeyValueListStore__c();
        kvs1.name = 'LCRMMergeOpportunityPageSize';
        kvs1.TextValue__C = '20';

        KeyValueListStore__c kvs2 = new KeyValueListStore__c();
        kvs2.name = 'LCRMMergeOpportunityExcludeStage';
        kvs2.TextValue__C = 'Contract Signed,Order Complete,Closed Lost';

        insert new list<KeyValueListStore__c> {
            kvs,
            kvs1,
            kvs2
        };
        
        Apttus_Config2__PriceList__c price = new Apttus_Config2__PriceList__c(name = 'tst-pl', apttus_config2__active__c = true);
        insert price;
        
        Product2 p1 = new Product2();
        p1.Name = 'Test Product1';
        p1.Subscription_Number__c = '102';
        p1.ProductCode = '101';
        p1.Service_Number__c = '101';
        pList.add(p1);

        insert pList;
    }
    
    
    // create ssd contact
    public static void createSSDContact(id contactId, id ssdId) {

        LCRM_Contact_SSD__c conssd = new LCRM_Contact_SSD__c();
        conssd.Name = 'Test Contact SSD1';
        conssd.LCRM_Contact__c = contactId;
        conssd.LCRM_Hard_Bounce__c = true;
        conssd.LCRM_Email__c = null;
        conssd.Contact_Inactive__c = true;
        conssd.LCRM_Contact_Inactive_Reason__c = 'Contact Expired';
        conssd.LCRM_SAP_Account_Number__c = '123456';
        conssd.LCRM_Account_SSD__c = ssdId;
        insert conssd;
    }     
           
    
    // create Assets with data specific to each SSD
    public static void createAssets(integer ssdNo, Id ssdId) {

		if (ssdNo == 6) {
        	Apttus_Config2__AssetLineItem__c asset6 = new Apttus_Config2__AssetLineItem__c();
       		asset6.Name = 'Test Asset 6';
        	asset6.Apttus_Config2__AssetStatus__c = 'Activated';
        	asset6.Apttus_Config2__Quantity__c = 5;
        	asset6.APTS_SSD_Sold_To__c = ssdId;
        	asset6.Apttus_Config2__IsInactive__c = false;
        	asset6.APTS_Subscription_Number__c = '10';
        	asset6.APTS_Info_RenewalDate__c = System.today() + 500;
        	assetList.add(asset6);
		}
		
		if (ssdNo == 8) {
        	Apttus_Config2__AssetLineItem__c asset80 = new Apttus_Config2__AssetLineItem__c();
        	asset80.Name = 'Test Asset 80';
        	asset80.Apttus_Config2__AssetStatus__c = 'Pending Activation';
        	asset80.Apttus_Config2__Quantity__c = 10;
        	asset80.APTS_SSD_Sold_To__c = ssdId;
        	asset80.Apttus_Config2__IsInactive__c = false;
        	asset80.APTS_Subscription_Number__c = '102';
        	asset80.APTS_Info_RenewalDate__c = null;
       		assetList.add(asset80);

	        Apttus_Config2__AssetLineItem__c asset81 = new Apttus_Config2__AssetLineItem__c();
    	    asset81.Name = 'Test asset81';
        	asset81.Apttus_Config2__AssetStatus__c = 'Cancelled';
	        asset81.Apttus_Config2__Quantity__c = 10;
    	    asset81.APTS_SSD_Sold_To__c = ssdId;
        	asset81.Apttus_Config2__IsInactive__c = true;
	        asset81.APTS_Subscription_Number__c = '102';
    	    asset81.APTS_Info_RenewalDate__c = System.today() - 20;
        	assetList.add(asset81);

        	for (Integer i = 0; i < 50; i++) {
            	Apttus_Config2__AssetLineItem__c assetn = new Apttus_Config2__AssetLineItem__c();
            	assetn.Name = 'Test asset ' + i;
            	assetn.Apttus_Config2__AssetStatus__c = 'Activated';
            	assetn.Apttus_Config2__Quantity__c = 10;
            	assetn.APTS_SSD_Sold_To__c = ssdId;
            	assetn.Apttus_Config2__IsInactive__c = false;
            	assetn.APTS_Subscription_Number__c = '102';
            	assetn.APTS_Info_RenewalDate__c = System.today() - 20;
            	assetList.add(assetn);
        	}

        	Apttus_Config2__AssetLineItem__c asset90 = new Apttus_Config2__AssetLineItem__c();
        	asset90.Name = 'Test asset81';
        	asset90.Apttus_Config2__AssetStatus__c = 'Cancelled';
        	asset90.Apttus_Config2__Quantity__c = 10;
        	asset90.APTS_SSD_Sold_To__c = ssdId;
        	asset90.Apttus_Config2__IsInactive__c = true;
        	asset90.APTS_Subscription_Number__c = '102';
        	asset90.APTS_Info_RenewalDate__c = System.today() + 1000;
        	assetList.add(asset90);
		}
		
		if (ssdNo == 10) {
   		    Apttus_Config2__AssetLineItem__c asset010 = new Apttus_Config2__AssetLineItem__c();
        	asset010.Name = 'Test asset010';
        	asset010.Apttus_Config2__AssetStatus__c = 'Cancelled';
        	asset010.Apttus_Config2__Quantity__c = 10;
        	asset010.APTS_SSD_Sold_To__c = ssdId;
        	asset010.Apttus_Config2__IsInactive__c = true;
        	asset010.APTS_Subscription_Number__c = '102';
        	asset010.APTS_Info_RenewalDate__c = System.today() + 1000;
        	assetList.add(asset010);
		}
        
	}
        
    
    // create Opportunity Record Types
	public static void createOppRecordTypes() {
			
        list<RecordtypeIds__c> recTList = new list<RecordtypeIds__c> ();
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
	}
    
    
    // create digital subscription records
    public static void createDSRecords() {
		
		// test FindLaw
        Product_Account_Detail__c ds00 = new Product_Account_Detail__c();
        ds00.ZP_Cust_Number__c = '1000000';
        ds00.Renewal_Date__c = System.Today() + 5;
        ds00.Digital_Firm__c = 'Findlaw';
        ds00.Type__c = null;
        ds00.Campaign_Code__c = null;
        ds00.Current_Subscription__c = '012';
        ds00.Actual_New_Service__c = null;
        ds00.Actual_New_Subscription__c = null;
        ds00.Premium_New_Service__c = null;
        ds00.Premium_New_Subscription__c = null;
        ds00.Add_On_Svc__c = null;
        ds00.Add_On_Sub__c = null;
        ds00.sub_Campaign_Code__c = null;
        ds00.Quantity__c = 5;
        dslist.add(ds00);
        
        Product_Account_Detail__c ds01 = new Product_Account_Detail__c();
        ds01.ZP_Cust_Number__c = '1000000';
        ds01.Renewal_Date__c = System.Today() + 5;
        ds01.Digital_Firm__c = 'Findlaw';
        ds01.Type__c = null;
        ds01.Campaign_Code__c = null;
        ds01.Current_Subscription__c = '101';
        ds01.Actual_New_Service__c = null;
        ds01.Actual_New_Subscription__c = null;
        ds01.Premium_New_Service__c = null;
        ds01.Premium_New_Subscription__c = null;
        ds01.Add_On_Svc__c = null;
        ds01.Add_On_Sub__c = null;
        ds01.sub_Campaign_Code__c = null;
        ds01.Quantity__c = 5;
        dslist.add(ds01);
        
        Product_Account_Detail__c ds10 = new Product_Account_Detail__c();
        ds10.ZP_Cust_Number__c = '100001';
        ds10.Renewal_Date__c = System.Today() + 5;
        ds10.Digital_Firm__c = 'Government';
        ds10.Type__c = null;
        ds10.Campaign_Code__c = null;
        ds10.Current_Subscription__c = null;
        ds10.Actual_New_Service__c = null;
        ds10.Actual_New_Subscription__c = null;
        ds10.Premium_New_Service__c = null;
        ds10.Premium_New_Subscription__c = null;
        ds10.Add_On_Svc__c = null;
        ds10.Add_On_Sub__c = null;
        ds10.sub_Campaign_Code__c = null;
        ds10.Quantity__c = 5;
        dslist.add(ds10);

        Product_Account_Detail__c ds11 = new Product_Account_Detail__c();
        ds11.ZP_Cust_Number__c = '100001';
        ds11.Renewal_Date__c = System.Today() + 1;
        ds11.Digital_Firm__c = 'Small Law';
        ds11.Current_Term_Length__c = 1;
        ds11.Quantity__c = 6;
        dslist.add(ds11);

        Product_Account_Detail__c ds20 = new Product_Account_Detail__c();
        ds20.ZP_Cust_Number__c = '100002';
        ds20.Renewal_Date__c = System.Today() + 1;
        ds20.Digital_Firm__c = 'FindLaw';
        ds20.Current_Term_Length__c = 1;
        ds20.Quantity__c = 6;
        ds20.Current_Subscription__c = null;
        ds20.DC_Contract_Number__c = null;
        dslist.add(ds20);

        Product_Account_Detail__c ds012 = new Product_Account_Detail__c();
        ds012.ZP_Cust_Number__c = '100012';
        ds012.Renewal_Date__c = System.Today() + 10;
        ds012.Digital_Firm__c = 'FindLaw';
        ds012.Current_Term_Length__c = 1;
        ds012.Quantity__c = 6;
        ds012.Current_Subscription__c = null;
        ds012.Type__c = 'Premium';
        dslist.add(ds012);
	}


	// create Digitsl Subscription reocrds for Government test	
    public static void createDSRecordsGov() {

        Product_Account_Detail__c ds10 = new Product_Account_Detail__c();
        ds10.ZP_Cust_Number__c = '100001';
        ds10.Renewal_Date__c = System.Today() + 5;
        ds10.Digital_Firm__c = 'Government';
        ds10.Type__c = null;
        ds10.Campaign_Code__c = null;
        ds10.Current_Subscription__c = null;
        ds10.Actual_New_Service__c = null;
        ds10.Actual_New_Subscription__c = null;
        ds10.Premium_New_Service__c = null;
        ds10.Premium_New_Subscription__c = null;
        ds10.Add_On_Svc__c = null;
        ds10.Add_On_Sub__c = null;
        ds10.sub_Campaign_Code__c = null;
        ds10.Quantity__c = 5;
        dslist.add(ds10);

        Product_Account_Detail__c ds12 = new Product_Account_Detail__c();
        ds12.ZP_Cust_Number__c = '100001';
        ds12.Renewal_Date__c = System.Today() + 10;
        ds12.Digital_Firm__c = 'Government';
        ds12.Type__c = 'Straight';
        ds12.Campaign_Code__c = 'CampCode1';
        ds12.Current_Subscription__c = '102';
        ds12.Actual_New_Service__c = '101';
        ds12.Actual_New_Subscription__c = '102';
        ds12.Premium_New_Service__c = '101';
        ds12.Premium_New_Subscription__c = '102';
        ds12.Add_On_Svc__c = '101';
        ds12.Add_On_Sub__c = '102';
        ds12.sub_Campaign_Code__c = 'SubCampCode1';
        ds12.Current_Term_Length__c = 1;
        ds12.Quantity__c = 8;
        dslist.add(ds12);

        Product_Account_Detail__c ds13 = new Product_Account_Detail__c();
        ds13.ZP_Cust_Number__c = '100001';
        ds13.Renewal_Date__c = System.Today() + 10;
        ds13.Digital_Firm__c = 'Government';
        ds13.Type__c = 'Premium';
        ds13.Campaign_Code__c = 'CampCode2';
        ds13.Current_Subscription__c = '102';
        ds13.Actual_New_Service__c = '101';
        ds13.Actual_New_Subscription__c = '102';
        ds13.Premium_New_Service__c = '101';
        ds13.Premium_New_Subscription__c = '102';
        ds13.Add_On_Svc__c = '101';
        ds13.Add_On_Sub__c = '102';
        ds13.sub_Campaign_Code__c = 'SubCampCode2';
        ds13.Current_Term_Length__c = 2;
        ds13.Quantity__c = 8;
        dslist.add(ds13);

        Product_Account_Detail__c ds14 = new Product_Account_Detail__c();
        ds14.ZP_Cust_Number__c = '100001';
        ds14.Renewal_Date__c = System.Today() + 10;
        ds14.Digital_Firm__c = 'Government';
        ds14.Type__c = 'Premium';
        ds14.Campaign_Code__c = 'CampCode2';
        ds14.Current_Subscription__c = '1000';
        ds14.Actual_New_Service__c = '1000';
        ds14.Actual_New_Subscription__c = '1000';
        ds14.Premium_New_Service__c = '1000';
        ds14.Premium_New_Subscription__c = '1000';
        ds14.Add_On_Svc__c = '1000';
        ds14.Add_On_Sub__c = '1000';
        ds14.sub_Campaign_Code__c = 'SubCampCode2';
        ds14.Current_Term_Length__c = 2;
        ds14.Quantity__c = 8;
        dslist.add(ds14);

        Product_Account_Detail__c ds50 = new Product_Account_Detail__c();
        ds50.ZP_Cust_Number__c = '100005';
        ds50.Renewal_Date__c = System.Today() + 1;
        ds50.Digital_Firm__c = 'Government';
        ds50.Current_Term_Length__c = 1;
        ds50.Quantity__c = 6;
        ds50.Current_Subscription__c = null;
        dslist.add(ds50);

        Product_Account_Detail__c ds60 = new Product_Account_Detail__c();
        ds60.ZP_Cust_Number__c = '100006';
        ds60.Renewal_Date__c = System.Today() + 10;
        ds60.Digital_Firm__c = 'Government';
        ds60.Current_Term_Length__c = 1;
        ds60.Quantity__c = 6;
        ds60.Current_Subscription__c = null;
        dslist.add(ds60);

        Product_Account_Detail__c ds61 = new Product_Account_Detail__c();
        ds61.ZP_Cust_Number__c = '100006';
        ds61.Renewal_Date__c = System.Today() + 10;
        ds61.Digital_Firm__c = 'Government';
        ds61.Current_Term_Length__c = 1;
        ds61.Quantity__c = 6;
        ds61.Current_Subscription__c = null;
        ds61.Type__c = 'Premium';
        dslist.add(ds61);

        Product_Account_Detail__c ds70 = new Product_Account_Detail__c();
        ds70.ZP_Cust_Number__c = '100007';
        ds70.Renewal_Date__c = System.Today() + 10;
        ds70.Digital_Firm__c = 'Government';
        ds70.Current_Term_Length__c = 1;
        ds70.Quantity__c = 6;
        ds70.Current_Subscription__c = null;
        ds70.Actual_New_Service__c = null;
        ds70.Actual_New_Subscription__c = null;
        ds70.Premium_New_Service__c = null;
        ds70.Premium_New_Subscription__c = null;
        ds70.Add_On_Svc__c = null;
        ds70.Add_On_Sub__c = null;
        ds70.Type__c = 'Premium';
        dslist.add(ds70);

        Product_Account_Detail__c ds71 = new Product_Account_Detail__c();
        ds71.ZP_Cust_Number__c = '100007';
        ds71.Renewal_Date__c = System.Today() + 10;
        ds71.Digital_Firm__c = 'Government';
        ds71.Current_Term_Length__c = 1;
        ds71.Quantity__c = 6;
        ds71.Current_Subscription__c = '102';
        ds71.Actual_New_Service__c = '101';
        ds71.Actual_New_Subscription__c = '102';
        ds71.Premium_New_Service__c = '101';
        ds71.Premium_New_Subscription__c = '102';
        ds71.Add_On_Svc__c = '101';
        ds71.Add_On_Sub__c = '102';
        ds71.Type__c = 'Premium';
        dslist.add(ds71);

        Product_Account_Detail__c ds73 = new Product_Account_Detail__c();
        ds73.ZP_Cust_Number__c = '100007';
        ds73.Renewal_Date__c = System.Today() + 10;
        ds73.Digital_Firm__c = 'Government';
        ds73.Current_Term_Length__c = 1;
        ds73.Quantity__c = 6;
        ds73.Current_Subscription__c = null;
        ds73.Actual_New_Service__c = '101';
        ds73.Actual_New_Subscription__c = null;
        ds73.Premium_New_Service__c = '101';
        ds73.Premium_New_Subscription__c = null;
        ds73.Add_On_Svc__c = '101';
        ds73.Add_On_Sub__c = '102';
        ds73.Type__c = 'Premium';
        dslist.add(ds73);

        Product_Account_Detail__c ds72 = new Product_Account_Detail__c();
        ds72.ZP_Cust_Number__c = '100007';
        ds72.Renewal_Date__c = System.Today() + 10;
        ds72.Digital_Firm__c = 'Government';
        ds72.Current_Term_Length__c = 1;
        ds72.Quantity__c = 6;
        ds72.Current_Subscription__c = '100';
        ds72.Actual_New_Service__c = '100';
        ds72.Actual_New_Subscription__c = '100';
        ds72.Premium_New_Service__c = '100';
        ds72.Premium_New_Subscription__c = '100';
        ds72.Add_On_Svc__c = '100';
        ds72.Add_On_Sub__c = '100';
        ds72.Type__c = 'Premium';
        dslist.add(ds72);

        Product_Account_Detail__c ds74 = new Product_Account_Detail__c();
        ds74.ZP_Cust_Number__c = '100007';
        ds74.Renewal_Date__c = System.Today() + 10;
        ds74.Digital_Firm__c = 'Government';
        ds74.Current_Term_Length__c = 1;
        ds74.Quantity__c = 6;
        ds74.Current_Subscription__c = null;
        ds74.Actual_New_Service__c = null;
        ds74.Actual_New_Subscription__c = null;
        ds74.Premium_New_Service__c = null;
        ds74.Premium_New_Subscription__c = null;
        ds74.Add_On_Svc__c = '100';
        ds74.Add_On_Sub__c = '100';
        ds74.Type__c = 'Premium';
        dslist.add(ds74);

        Product_Account_Detail__c ds80 = new Product_Account_Detail__c();
        ds80.ZP_Cust_Number__c = '100008';
        ds80.Renewal_Date__c = System.Today() + 10;
        ds80.Digital_Firm__c = 'Government';
        ds80.Current_Term_Length__c = 1;
        ds80.Quantity__c = 6;
        ds80.Current_Subscription__c = '102';
        ds80.Actual_New_Service__c = null;
        ds80.Actual_New_Subscription__c = null;
        ds80.Premium_New_Service__c = null;
        ds80.Premium_New_Subscription__c = null;
        ds80.Add_On_Svc__c = '100';
        ds80.Add_On_Sub__c = '100';
        ds80.Type__c = 'Premium';
        dslist.add(ds80);

        Product_Account_Detail__c ds90 = new Product_Account_Detail__c();
        ds90.ZP_Cust_Number__c = '100009';
        ds90.Renewal_Date__c = System.Today() + 10;
        ds90.Digital_Firm__c = 'Government';
        ds90.Current_Term_Length__c = 1;
        ds90.Quantity__c = 6;
        ds90.Current_Subscription__c = '102';
        ds90.Type__c = 'Premium';
        dslist.add(ds90);

        Product_Account_Detail__c ds010 = new Product_Account_Detail__c();
        ds010.ZP_Cust_Number__c = '100010';
        ds010.AccountSSD__c = ssdList[8].Id;
        ds010.Renewal_Date__c = System.Today() + 10;
        ds010.Digital_Firm__c = 'Government';
        ds010.Current_Term_Length__c = 1;
        ds010.Quantity__c = 6;
        ds010.Current_Subscription__c = '102';
        ds010.Type__c = 'Premium';
        dslist.add(ds010);

        Product_Account_Detail__c ds011 = new Product_Account_Detail__c();
        ds011.ZP_Cust_Number__c = '100011';
        ds011.Renewal_Date__c = System.Today() + 10;
        ds011.Digital_Firm__c = 'Government';
        ds011.Current_Term_Length__c = 1;
        ds011.Quantity__c = 6;
        ds011.Current_Subscription__c = '102';
        ds011.Type__c = 'Premium';
        dslist.add(ds011);

        Product_Account_Detail__c ds013 = new Product_Account_Detail__c();
        ds013.ZP_Cust_Number__c = '100012';
        ds013.Renewal_Date__c = System.Today() + 10;
        ds013.Digital_Firm__c = 'Government';
        ds013.Current_Term_Length__c = null;
        ds013.Quantity__c = 6;
        ds013.Current_Subscription__c = '102';
        ds013.Type__c = null;
        ds013.Campaign_Code__c   = null;
        ds013.Current_Subscription__c   = null;
        ds013.Actual_New_Service__c   = null;
        ds013.Actual_New_Subscription__c   = null;
        ds013.Premium_New_Service__c   = null;
        ds013.Premium_New_Subscription__c   = null;
        dslist.add(ds013);

        Product_Account_Detail__c ds014 = new Product_Account_Detail__c();
        ds014.ZP_Cust_Number__c = '100013';
        ds014.Renewal_Date__c = System.Today() + 10;
        ds014.Digital_Firm__c = 'Government';
        ds014.Current_Term_Length__c = 1;
        ds014.Quantity__c = 6;
        ds014.Type__c = 'Straight';
        ds014.Campaign_Code__c   = 'Campaign_Code__c';
        ds014.sub_Campaign_Code__c   = 'sub_Campaign_Code__c';
        ds014.Current_Subscription__c   = 'null';
        ds014.Actual_New_Service__c   = 'null';
        ds014.Actual_New_Subscription__c   = 'null';
        ds014.Premium_New_Service__c   = 'null';
        ds014.Premium_New_Subscription__c   = 'null';
        dslist.add(ds014);

        Product_Account_Detail__c ds015 = new Product_Account_Detail__c();
        ds015.ZP_Cust_Number__c = '100013';
        ds015.Renewal_Date__c = System.Today() + 15;
        ds015.Digital_Firm__c = 'Government';
        ds015.Current_Term_Length__c = 2;
        ds015.Quantity__c = 6;
        ds015.Type__c = 'Premium';
        ds015.Campaign_Code__c   = 'Campaign_Code__c1';
        ds015.sub_Campaign_Code__c   = 'sub_Campaign_Code__c1';
        ds015.Current_Subscription__c   = 'null';
        ds015.Actual_New_Service__c   = 'null';
        ds015.Actual_New_Subscription__c   = 'null';
        ds015.Premium_New_Service__c   = 'null';
        ds015.Premium_New_Subscription__c   = 'null';
        dslist.add(ds015);
	}
	
	
	// Create an Opp and Quote
	public static void createOppAndQuote(Id accountId, Id contactId, Id ssdId) {
		
        Opportunity op1 = new Opportunity();
        op1.Name = 'Test Opportunity1 DigitalOpp';
        op1.AccountId = accountId;
        op1.isdigitalSpearhead__c = true;
        op1.Status__c = 'Unworked';
        op1.Key_Contact__c = contactId;
        op1.LCRM_Sub_BU__c = 'SubBU';
        op1.LATAM_Business_Unit__c = 'Not Latam';
        op1.LCRM_Total_Actual_Renewal__c = null;
        op1.StageName = 'Negotiate Contract';
        op1.CloseDate = System.today() + 30;
        op1.Digital_Review_Complete__c = true;
        op1.Renewal_Date__c = System.today() + 10;
        op1.Source_System_Detail__c = ssdId;
        op1.Pricebook2id = System.Label.stdPB;
        op1.RecordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        oppList.add(op1);

        insert oppList;

        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Approval_Stage__c  = 'In Review';
        q1.APTS_Approval_Segment__c = null;
        q1.Digital_Quote_Failure_Reason__c = 'In Review';
        q1.DocuSign_Envelope_ID__c = null;
        q1.APTS_Order_Confirmation_Contact_Email__c = null;
        q1.Apttus_Proposal__Opportunity__c = op1.Id;
        qlist.add(q1);

        insert qlist;
}
	
	
	// Create digital Settings for each test run
	public static void createDigitalSettings() {

        Digital_Settings__c dsSettings1 = new Digital_Settings__c();
        dsSettings1.Name = 'Check Government 1';
        dsSettings1.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings1.Batch_Size__c = 5;
        dsSettings1.Data_Status__c = 'Pre-CohortsJob';
        dsSettings1.Segment__c = 'Government';
        dsSettingsList.add(dsSettings1);

        Digital_Settings__c dsSettings2 = new Digital_Settings__c();
        dsSettings2.Name = 'Empty SSDBatch';
        dsSettings2.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings2.Batch_Size__c = 5;
        dsSettings2.Data_Status__c = 'Data Load';
        dsSettings2.Segment__c = 'Government';
        dsSettingsList.add(dsSettings2);

        Digital_Settings__c dsSettings3 = new Digital_Settings__c();
        dsSettings3.Name = 'Dummy SSDBatch';
        dsSettings3.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings3.Batch_Size__c = 5;
        dsSettings3.Data_Status__c = 'Data Load';
        dsSettings3.Segment__c = 'Government';
        dsSettingsList.add(dsSettings3);

        Digital_Settings__c dsSettings4 = new Digital_Settings__c();
        dsSettings4.Name = 'Check Government DataLoad2';
        dsSettings4.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings4.Batch_Size__c = 5;
        dsSettings4.Data_Status__c = 'Data Load';
        dsSettings4.Segment__c = 'Government';
        dsSettingsList.add(dsSettings4);

        Digital_Settings__c dsSettings5 = new Digital_Settings__c();
        dsSettings5.Name = 'Check EmptyProductCheck1';
        dsSettings5.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings5.Batch_Size__c = 5;
        dsSettings5.Data_Status__c = 'Data Load';
        dsSettings5.Segment__c = 'Government';
        dsSettingsList.add(dsSettings5);

        Digital_Settings__c dsSettings6 = new Digital_Settings__c();
        dsSettings6.Name = 'Check GovernmentProductCheck2';
        dsSettings6.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings6.Batch_Size__c = 5;
        dsSettings6.Data_Status__c = 'Data Load';
        dsSettings6.Segment__c = 'Government';
        dsSettingsList.add(dsSettings6);

        Digital_Settings__c dsSettings7 = new Digital_Settings__c();
        dsSettings7.Name = 'Check GovernmentProductCheck3';
        dsSettings7.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings7.Batch_Size__c = 5;
        dsSettings7.Data_Status__c = 'Data Load';
        dsSettings7.Segment__c = 'Government';
        dsSettingsList.add(dsSettings7);

        Digital_Settings__c dsSettings8 = new Digital_Settings__c();
        dsSettings8.Name = 'Check GovernmentDataLoadAssetCheck1';
        dsSettings8.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings8.Batch_Size__c = 5;
        dsSettings8.Data_Status__c = 'Data Load';
        dsSettings8.Segment__c = 'Government';
        dsSettingsList.add(dsSettings8);

        Digital_Settings__c dsSettings9 = new Digital_Settings__c();
        dsSettings9.Name = 'Check GovernmentDataLoadAssetCheck2';
        dsSettings9.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings9.Batch_Size__c = 5;
        dsSettings9.Data_Status__c = 'Data Load';
        dsSettings9.Segment__c = 'Government';
        dsSettingsList.add(dsSettings9);

        Digital_Settings__c dsSettings10 = new Digital_Settings__c();
        dsSettings10.Name = 'Check GovernmentDataLoadAccountCheck1';
        dsSettings10.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings10.Batch_Size__c = 5;
        dsSettings10.Data_Status__c = 'Data Load';
        dsSettings10.Segment__c = 'Government';
        dsSettingsList.add(dsSettings10);

        Digital_Settings__c dsSettings11 = new Digital_Settings__c();
        dsSettings11.Name = 'Check GovernmentDataLoadSSDCheck21';
        dsSettings11.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings11.Batch_Size__c = 5;
        dsSettings11.Data_Status__c = 'Data Load';
        dsSettings11.Segment__c = 'Government';
        dsSettingsList.add(dsSettings11);

        Digital_Settings__c dsSettings12 = new Digital_Settings__c();
        dsSettings12.Name = 'Check GovernmentDataLoadOppPropCheck1';
        dsSettings12.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings12.Batch_Size__c = 5;
        dsSettings12.Data_Status__c = 'Data Load';
        dsSettings12.Segment__c = 'Government';
        dsSettingsList.add(dsSettings12);

        Digital_Settings__c dsSettings13 = new Digital_Settings__c();
        dsSettings13.Name = 'Check results settings';
        dsSettings13.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings13.Batch_Size__c = 5;
        dsSettings13.Data_Status__c = 'Data Load';
        dsSettings13.Segment__c = 'Government';
        dsSettings13.Start_Time__c =System.Now();
        dsSettingsList.add(dsSettings13);

        Digital_Settings__c dsSettings14 = new Digital_Settings__c();
        dsSettings14.Name = 'Check GovernmentDSCheck1';
        dsSettings14.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings14.Batch_Size__c = 5;
        dsSettings14.Data_Status__c = 'Data Load';
        dsSettings14.Segment__c = 'Government';
        dsSettings14.Start_Time__c =System.Now();
        dsSettingsList.add(dsSettings14);

        Digital_Settings__c dsSettings15 = new Digital_Settings__c();
        dsSettings15.Name = 'Check EmptyGovernmentDSCheck1';
        dsSettings15.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings15.Batch_Size__c = 5;
        dsSettings15.Data_Status__c = 'Data Load';
        dsSettings15.Segment__c = 'Government';
        dsSettings15.Start_Time__c =System.Now();
        dsSettingsList.add(dsSettings15);
        
        // test for FindLaw
        Digital_Settings__c dsSettings16 = new Digital_Settings__c();
        dsSettings16.Name = 'Check FindLawProductCheck2';
        dsSettings16.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dsSettings16.Batch_Size__c = 5;
        dsSettings16.Data_Status__c = 'Data Load';
        dsSettings16.Segment__c = 'FindLaw';
        dsSettingsList.add(dsSettings16);

        insert dsSettingsList;
}


	// create Digital Customer Records
	public static void createDigitalCustomers() {
		
        Digital_Customer__c dc1 = new Digital_Customer__c();
        dc1.Digital_Settings__c = dsSettingsList[2].Id; // dsSettings3.Id;
        dc1.SAP_Number__c = '012345';
        dsCustomerList.add(dc1);

        Digital_Customer__c dc2 = new Digital_Customer__c();
        dc2.Digital_Settings__c = dsSettingsList[2].Id; // dsSettings3.Id;
        dc2.Customer_SSD__c = ssdList[2].Id; // ssd4.Id;
        dsCustomerList.add(dc2);

        Digital_Customer__c dc3 = new Digital_Customer__c();
        dc3.Digital_Settings__c = dsSettingsList[3].Id; // dsSettings4.Id;
        dc3.Customer_SSD__c = ssdList[3].Id; // ssd5.Id;
        dsCustomerList.add(dc3);

        Digital_Customer__c dc4 = new Digital_Customer__c();
        dc4.Digital_Settings__c = dsSettingsList[3].Id; // dsSettings4.Id;
        dc4.Customer_SSD__c = ssdList[4].Id; // ssd6.Id;
        dsCustomerList.add(dc4);

        Digital_Customer__c dc5 = new Digital_Customer__c();
        dc5.Digital_Settings__c = dsSettingsList[5].Id; // dsSettings6.Id;
        dc5.Customer_SSD__c = ssdList[0].Id; // ssd1.Id;
        dc5.SAP_Number__c = '100001';
        dsCustomerList.add(dc5);

        Digital_Customer__c dc6 = new Digital_Customer__c();
        dc6.Digital_Settings__c = dsSettingsList[6].Id; // dsSettings7.Id;
        dc6.Customer_SSD__c = ssdList[5].Id; // ssd7.Id;
        dc6.SAP_Number__c = '100007';
        dsCustomerList.add(dc6);

        Digital_Customer__c dc7 = new Digital_Customer__c();
        dc7.Digital_Settings__c = dsSettingsList[7].Id; // dsSettings8.Id;
        dc7.Cohort_Execution__c = false;
        dc7.Has_SSD__c = true;
        dc7.Has_DSdata__c = true;
        dc7.Has_Assets__c = true;
        dsCustomerList.add(dc7);

        Digital_Customer__c dc8 = new Digital_Customer__c();
        dc8.Digital_Settings__c = dsSettingsList[8].Id; // dsSettings9.Id;
        dc8.SAP_Number__c = '100008';
        dc8.Customer_SSD__c = ssdList[6].Id; // ssd8.Id;
        dc8.Cohort_Execution__c = false;
        dc8.Has_SSD__c = true;
        dc8.Has_DSdata__c = true;
        dc8.Has_Assets__c = true;
        dsCustomerList.add(dc8);

        Digital_Customer__c dc81 = new Digital_Customer__c();
        dc81.Digital_Settings__c = dsSettingsList[8].Id; // dsSettings9.Id;
        dc81.SAP_Number__c = '100009';
        dc81.Customer_SSD__c = ssdList[7].Id; // ssd9.Id;
        dc81.Cohort_Execution__c = false;
        dc81.Has_SSD__c = true;
        dc81.Has_DSdata__c = true;
        dc81.Has_Assets__c = true;
        dsCustomerList.add(dc81);

        Digital_Customer__c dc9 = new Digital_Customer__c();
        dc9.Digital_Settings__c = dsSettingsList[9].Id; // dsSettings10.Id;
        dc9.Customer_SSD__c = ssdList[0].Id; // ssd1.Id;
        dc9.SAP_Number__c = '100010';
        dc9.Cohort_Execution__c = false;
        dc9.Has_SSD__c = true;
        dc9.Has_DSdata__c = true;
        dc9.Has_Assets__c = true;
        dc9.Has_Account__c = true;
        dsCustomerList.add(dc9);

        Digital_Customer__c dc10 = new Digital_Customer__c();
        dc10.Digital_Settings__c = dsSettingsList[9].Id; // dsSettings10.Id;
        dc10.Customer_SSD__c = ssdList[0].Id; // ssd1.Id;
        dc10.Cohort_Execution__c = false;
        dc10.Has_SSD__c = true;
        dc10.Has_DSdata__c = true;
        dc10.Has_Assets__c = true;
        dc10.Has_Account__c = true;
        dsCustomerList.add(dc10);

        Digital_Customer__c dc11 = new Digital_Customer__c();
        dc11.Digital_Settings__c = dsSettingsList[9].Id; // dsSettings10.Id;
        dc11.Customer_SSD__c = ssdList[1].Id; // ssd2.Id;
        dc11.Cohort_Execution__c = false;
        dc11.Has_SSD__c = true;
        dc11.Has_DSdata__c = true;
        dc11.Has_Assets__c = true;
        dc11.Has_Account__c = true;
        dc11.Has_Contact__c = true;
        dsCustomerList.add(dc11);

        Digital_Customer__c dc12 = new Digital_Customer__c();
        dc12.Digital_Settings__c = dsSettingsList[9].Id; // dsSettings10.Id;
        dc12.Customer_SSD__c = ssdList[2].Id; // ssd4.Id;
        dc12.Cohort_Execution__c = false;
        dc12.Has_SSD__c = true;
        dc12.Has_DSdata__c = true;
        dc12.Has_Assets__c = true;
        dc12.Has_Account__c = true;
        dc12.Has_Contact__c = true;
        dsCustomerList.add(dc12);

        Digital_Customer__c dc13 = new Digital_Customer__c();
        dc13.Digital_Settings__c = dsSettingsList[9].Id; // dsSettings10.Id;
        dc13.Customer_SSD__c = ssdList[3].Id; // ssd5.Id;
        dc13.Cohort_Execution__c = false;
        dc13.Has_SSD__c = true;
        dc13.Has_DSdata__c = true;
        dc13.Has_Assets__c = true;
        dc13.Has_Account__c = true;
        dc13.Has_Contact__c = true;
        dsCustomerList.add(dc13);

        Digital_Customer__c dc14 = new Digital_Customer__c();
        dc14.Digital_Settings__c = dsSettingsList[10].Id; // dsSettings11.Id;
        dc14.Customer_SSD__c = ssdList[8].Id; // ssd10.Id;
        dc14.SAP_Number__c='100010';
        dc14.Cohort_Execution__c = false;
        dsCustomerList.add(dc14);

        Digital_Customer__c dc15 = new Digital_Customer__c();
        dc15.Digital_Settings__c = dsSettingsList[10].Id; // dsSettings11.Id;
        dc15.Customer_SSD__c = ssdList[3].Id; // ssd5.Id;
        dc15.Cohort_Execution__c = false;
        dsCustomerList.add(dc15);

        Digital_Customer__c dc16 = new Digital_Customer__c();
        dc16.Digital_Settings__c = dsSettingsList[11].Id; // dsSettings12.Id;
        dc16.Customer_SSD__c = ssdList[9].Id; // ssd11.Id;
        dc16.Cohort_Execution__c = false;
        dc16.Has_SSD__c = true;
        dc16.Has_DSdata__c = true;
        dc16.Has_Assets__c = true;
        dc16.Has_Account__c = true;
        dc16.Has_Contact__c = true;
        dc16.Has_Opportunity__c = true;
        dc16.Has_Quotes__c  = true;
        dsCustomerList.add(dc16);

        Digital_Customer__c dc17 = new Digital_Customer__c();
        dc17.Digital_Settings__c = dsSettingsList[12].Id; // dsSettings13.Id;
        dc17.Customer_SSD__c = ssdList[3].Id; // ssd5.Id;
        dc17.Cohort_Execution__c = false;
        dc17.SAP_Number__c = '121';
        dsCustomerList.add(dc17);

        Digital_Customer__c dc18 = new Digital_Customer__c();
        dc18.Digital_Settings__c = dsSettingsList[13].Id; // dsSettings14.Id;
        dc18.Customer_SSD__c = ssdList[10].Id; // ssd12.Id;
        dc18.Cohort_Execution__c = false;
        dc18.Has_SSD__c = true;
        dc18.SAP_Number__c='100013';
        dc18.Has_DSdata__c = true;
        dsCustomerList.add(dc18);

        Digital_Customer__c dc19 = new Digital_Customer__c();
        dc19.Digital_Settings__c = dsSettingsList[13].Id; // dsSettings14.Id;
        dc19.Customer_SSD__c = ssdList[11].Id; // ssd13.Id;
        dc19.Cohort_Execution__c = false;
        dc19.Has_SSD__c = true;
        dc19.SAP_Number__c='100013';
        dc19.Has_DSdata__c = true;
        dsCustomerList.add(dc19);
        
        // FindLaw testing
        Digital_Customer__c dc20 = new Digital_Customer__c();
        dc20.Digital_Settings__c = dsSettingsList[15].Id; 
        dc20.Customer_SSD__c = ssdList[12].Id;
        dc20.SAP_Number__c = '1000000';
        dsCustomerList.add(dc20);
        
        // SSDCheck coverage with Opp and quote
        Digital_Customer__c dc21 = new Digital_Customer__c();
        dc21.Digital_Settings__c = dsSettingsList[10].Id; 
        dc21.Customer_SSD__c = ssdList[9].Id; // ssd11.Id;
        dc21.Cohort_Execution__c = false;
        dc21.Has_SSD__c = true;
        dc21.Has_DSdata__c = true;
        dc21.Has_Assets__c = true;
        dc21.Has_Account__c = true;
        dc21.Has_Contact__c = true;
        dc21.Has_Opportunity__c = true;
        dc21.Has_Quotes__c  = true;
        dsCustomerList.add(dc21);
        
        // for OppPropCheck Validation 
        Digital_Customer__c dc22 = new Digital_Customer__c();
        dc22.Digital_Settings__c = dsSettingsList[11].Id; // dsSettings12
        dc22.Customer_SSD__c = ssdList[8].Id; // ssd1.Id;
        dc22.SAP_Number__c = '100010';
        dc22.Cohort_Execution__c = false;
        dc22.Has_SSD__c = true;
        dc22.Has_DSdata__c = true;
        dc22.Has_Assets__c = true;
        dc22.Has_Account__c = true;
        dc22.Has_Opportunity__c = true;
        dc22.Has_Quotes__c = true;
        dsCustomerList.add(dc22);
        insert dsCustomerList;
        
        
}
    
    
    // test class
    @IsTest
    static void testMainFunction(){
      
      test.startTest();
      Digital_Validation_ReportRecordsTest.digitalValidationCreateRecords();
      List<Opportunity> listOpp = [SELECT id FROM Opportunity];
      List<Account> listAcc = [SELECT id FROM Account];
      system.assert(!(listOpp.isEmpty()), 'Opportunity failed to be created');
      system.assert(!(listAcc.isEmpty()), 'Accoutn failed to be created');
      test.stopTest();
    }
    
}