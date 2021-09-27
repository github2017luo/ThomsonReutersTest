/*  Author - Dinesh Kumar Voonna
    Purpose - To generate Documnets for Digital Quotes 
    Scheduled Job - Runs for every 5 Min and process 1 record 
    Story Number - DLT-282

    History
    -------
    Dinesh - Updated to Batcahable class and runs for every 10 min and process 30 records
    Dinesh - 11/08/2017 - Updated the global soql to generate docs for 'Approved' Quotes - move login callout to start method
    Dinesh - 06/12/2017 - Runs once in a day and process all available records at a time

    2018-09-19      Brenda Shields      DLT-12135 - Changes to improve performance
    2018-09-19      Brenda Shields      DLT-12378 - Create error log when login user can not connect
    2019-02-19      Srikanth Kota       DLT-15197 - Update Automation job to create Order Form for FindLaw
    2019-04-11      HarikaSai P         DLT-15968 - Create Data Layer (operational Layer)
    2019-05-24      Harika Sai P        DLT-16538 - [SLF][Tech Story] Enhance exception processing - Digital_GenerateDocumentsBatch
    2019-07-09      Srikanth Kota       DLT-16958 - [Tech Story] [SLF] Automation to create Plus and Premium proposal only based Ineligible sub flag on DS object
    2020-04-30      Brenda Shields      DLT-19727 - Update Renewal process for manual quotes, to include creation of the order form 
    2020-05-29      Benjamin Her        DLT-19913 - Update Ineligible sub logic to no longer expire Straight Renewal proposal    
*/

global without sharing class Digital_GenerateDocumentsBatch implements Database.AllowsCallouts, Database.Batchable<Apttus_Config2__ProductConfiguration__c > , Database.Stateful {

	private static Final String INELIGIBLE = 'Ineligible'; //DLT-16958
	public list<Apttus_Config2__ProductConfiguration__c > cartList = [select id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
		Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c, APTS_Proposal_Business_Unit__c, Apttus_QPConfig__Proposald__r.Contract_Type__c
		from Apttus_Config2__ProductConfiguration__c
		where((Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c = TRUE AND Apttus_Config2__Status__c = 'Finalized'
			AND(Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Draft'
				OR Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Approved') AND Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c != Null AND Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c IN(Null, '')) AND Apttus_QPConfig__Proposald__r.Digital_Batch_Processed__c = TRUE AND Digital_Pending_Cart__c = FALSE)
	];

	public static Map<String, Apttus__APTS_Template__c > tempMap = new MAP<String, Apttus__APTS_Template__c > (); // DLT-15197 updated 

	global Iterable<Apttus_Config2__ProductConfiguration__c > start(database.batchablecontext bC) {

		if (!Test.isRunningTest()) { return cartList;
			
		} else {
			return [select id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c, Apttus_QPConfig__Proposald__r.Contract_Type__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c, APTS_Proposal_Business_Unit__c from Apttus_Config2__ProductConfiguration__c where(Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c = TRUE AND Apttus_Config2__Status__c = 'Finalized'
				AND(Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Draft'
					OR Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Approved') AND Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c != Null) Limit 10];
		}
	}

	// Execute method
	public void execute(Database.BatchableContext bC, List<Apttus_Config2__ProductConfiguration__c > scope) {

		List<Apttus_Config2__ProductConfiguration__c > prodList = new List<Apttus_Config2__ProductConfiguration__c > ();
		for (Apttus_Config2__ProductConfiguration__c q: Scope) {
			prodList.add(q);
		}
		Digital_GenerateDocumentsBatch.generateOrderForm(prodList);
	}

	// main processing class 
	// Generate Order Forms
	public static void generateOrderForm(List<Apttus_Config2__ProductConfiguration__c > listProdConfig) {
		Set<id> ineliProSet = new Set<id> ();
		list<Digital_Exception_Log__c > errorList = new list<Digital_Exception_Log__c > ();
		//DLT-15197 added for Change Template
		list<string> templateTames = new list<string> {
			System.Label.Digital_OF,
			System.Label.Digital_FOF
		};
		for (Apttus__APTS_Template__c temp: [select id, name from Apttus__APTS_Template__c where Apttus__IsActive__c = TRUE AND name in: templateTames]) {
			tempMap.put(temp.name, temp);
		}
		// Common Layer Framework Implementation    
		IGlobalOperationLayer glbOpObj = new GlobalOperationLayer();
		system.debug('tempMap: ' + tempMap);
		if (tempMap != null) {
			try {
				// the scope is always 1 so this loop isn't really necessary
				for (Apttus_Config2__ProductConfiguration__c cart: listProdConfig) {
					system.debug('logs***' + cart.Apttus_QPConfig__Proposald__r.Contract_Type__c + cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c);

					//Removed sessionID logic and using userInfo.getSeeionid from Framework class.        
					//DLT-16538 added class reference and record ID for enhanced exception processing.      
					if (cart.APTS_Proposal_Business_Unit__c == 'FindLaw') {
						//For  Findlaw Order Form             
						glbOpObj.generatePDFDocument(tempMap.get(System.Label.Digital_FOF).Id, cart.Apttus_QPConfig__Proposald__c, 'Digital_GenerateDocumentsBatch > Execute');
					} else {
						//For west order form
						glbOpObj.generatePDFDocument(tempMap.get(System.Label.Digital_OF).Id, cart.Apttus_QPConfig__Proposald__c, 'Digital_GenerateDocumentsBatch > Execute');
					}
				}
			} catch (Exception e) { 	DCUtils.trackLog(e, 'Digital_GenerateDocumentsBatch', 'execute'); 	}
		}
	}

	global void finish(Database.BatchableContext info) {

		if (!test.isrunningtest()) {
			Digital_DocusignSchedulable ddc = new Digital_DocusignSchedulable(); ddc.execute(null);
		}
	}
}