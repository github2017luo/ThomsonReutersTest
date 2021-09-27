/*============================================================================================
    Name                : Ecom_AccountExecutiveBatch   
    Description         : This is a batch class which sets the Opportunity owner for New Sales orders 

    DATE          DEVELOPER          CHANGE HISTORY
    12-08-2020    Brenda Shields     DLT-21195 : [INC3695907] [NSE] [SLF]| Reps are not receiving email notifications when an NSE sale is closed in their territory
                                                 Updated for PMD Violations
    07-21-2021    Brenda Shields     DLT-21912 : Update code to determine rep Territory role based on Account SSD information (not info on the quote)                                                 
==============================================================================================*/
 /** 
 * @description : Checks NSE Proposals and updates the Opportunty Onwer once the Territory Roles have been assigned
 */ 
public without sharing class Ecom_AccountExecutiveBatch implements  Database.AllowsCallouts, Database.Batchable<Apttus_Proposal__Proposal__c>{
    public static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    public static list<string> lstTerrRoles = new list<string>();
    // maps used to find the opportunity owner based on Territory2 
    public static map<string, list<Ecom_UtilMapping__mdt>> mapQuoteTeamRole = new map<string, list<Ecom_UtilMapping__mdt>>();  
    public static map<string, string> mapTerrRoleUsers = new map<string, string>();
    public static map<string, id> mapRoleToTerr = new map<string, id>();
    public static map<id, string> mapUserEmail = new map<id, string>();
    // maps used to set default Opp owner in case the segment has changed since the Opp was created
    public static map<string, string> mapOppOwnerDefaults = new map<string, string>();
    public static map<string, id> mapOppOwnerDefaultIds = new map<string, id>();
    public static set<id> setAcctNoTerr = new set<id>();
    public static Ecom_UtilMapping__mdt oFoundTerrUtil;
    
    // need to select Account SSD Digital_Firm__c to determine the correct segment for each role
    // need to select proposal APTS_Proposal_Business_Unit__c to determine if this is a FindLaw segment
    public static list<Apttus_Proposal__Proposal__c> proposalList = [select id,Digital_Quote_Type__c,Apttus_Proposal__Opportunity__c, 
    				APTS_Proposal_Business_Unit__c, APTS_Customer_Pricing_Segment__c,Apttus_Proposal__Opportunity__r.Probability, 
    				Apttus_Proposal__Account__c,Apttus_Proposal__Opportunity__r.Is_Digital_Owner_Updated__c, Apttus_Proposal__Opportunity__r.StageName, 
    				Apttus_Proposal__Approval_Stage__c,Digitally_Signed_Date__c,Is_Digital_New_Sales__c,
    				APTS_SSD_bill_to__r.Source_System_Account_Number__c, APTS_SSD_bill_to__r.Digital_Firm__c 
    				from Apttus_Proposal__Proposal__c 
    				where Is_Digital_New_Sales__c = TRUE AND Digital_Quote_Type__c = 'New Sales' AND Apttus_Proposal__Account__c != NULL 
    				AND Apttus_Proposal__Approval_Stage__c = 'Accepted' AND Digitally_Signed_Date__c != NULL 
    				AND APTS_SSD_bill_to__r.Source_System_Account_Number__c != NULL AND Apttus_Proposal__Opportunity__r.Probability >= 95 
    				AND Apttus_Proposal__Opportunity__r.StageName IN ('Contract Signed','Order Complete') 
    				AND APTS_Proposal_Business_Unit__c != NULL AND Apttus_Proposal__Opportunity__r.Is_Digital_Owner_Updated__c = false];
   
   
   /** 
 	* @description : Start method - Processes all NSE proposals
 	* @param bCont : batchable context
 	* @return Proposal record
 	*/ 
    public Iterable<Apttus_Proposal__Proposal__c> start(database.batchablecontext bCont) {
        
        system.debug(LoggingLevel.INFO, 'proposalList===============>'+proposalList);      
        return proposalList;
    }
    
    
   /** 
 	* @description : execute method - Processes all NSE proposals
 	* @param bCont : batchable context
 	* @param proposals : list of proposals to process
 	*/ 
    public void execute(Database.BatchableContext bCont, list<Apttus_Proposal__Proposal__c> proposals) {
        
        set<string> teamRole = new set<string>();
        //set<String> pricingSegment = new Set<String>();
        //set<String> proposalBU = new set<String>();
        set<id> oppIds = new set<Id>();
        set<Id> accIds = new set<Id>();
        
        // map for pricing segment to Territory Role
        map<String, Ecom_UtilMapping__mdt> mapPropTeamRole = new map<String, Ecom_UtilMapping__mdt>();
        map<Id, list<Task>> mapOppTasks = new map<Id, list<Task>>();
        
        list<Opportunity> oppToUpdate = new list<Opportunity>();
        list<Task> taskToInsert = new list<Task>();
        list<Apttus_Proposal__Proposal__c> propToUpdate = new list<Apttus_Proposal__Proposal__c>();
        
        // create a map for setting the Opp Default owner, if needed
        mapOppOwnerDefaults = setOppOwnerDefaults();
        mapOppOwnerDefaultIds = setOppOwnerDefaultIds(mapOppOwnerDefaults);
        
        for(Apttus_Proposal__Proposal__c quote : proposals) { 
          	// build sets to lookup team role
            //pricingSegment.add(quote.APTS_Customer_Pricing_Segment__c);
            //proposalBU.add(quote.APTS_Proposal_Business_Unit__c);
      		// build sets for Opp and Account IDs
            oppIds.add(quote.Apttus_Proposal__Opportunity__c);
            accIds.add(quote.Apttus_Proposal__Account__c);
        }
        
        // build the mapping for the team roles to the quote lookup
        mapPropTeamRole = buildTeamRoleMapping(); //pricingSegment, proposalBU);
        //prepare Account Team Member map
        buildAccountTeamMembers(accIds);

        //get opportunity Task
        mapOppTasks = buildOppTasks(oppIds);

        for (Apttus_Proposal__Proposal__c quote : proposals) {
            try {                           
                
                // find the account team member
                id oppOwnerId = findOppOwner(quote, mapPropTeamRole); 
                //get Opportunity Tasks
                list<Task> oppTasks = new list<Task>();
                if (mapOppTasks.containsKey(quote.Apttus_Proposal__Opportunity__c)) {
                    oppTasks = mapOppTasks.get(quote.Apttus_Proposal__Opportunity__c);
                }
                system.debug(LoggingLevel.INFO, 'WHAT WAS FOUND - Opp Task List: ' + oppTasks + ' oppOwnerId: ' + oppOwnerId);
                if (oppTasks.isEmpty() && oppOwnerId != null) { 
					// update the opportunity with the new owner
                    Opportunity opp = setOppOwner(quote.Apttus_Proposal__Opportunity__c, oppOwnerId, oFoundTerrUtil); //accTeamMember.userid);
                    // if we have two proposals for the same Opp (is user cloned the quote) don't update the opp
                    if (!oppToUpdate.contains(opp)) {
	                    oppToUpdate.add(opp);
	                    // create opportunity activity
	                    Task task = addactivity(quote.Apttus_Proposal__Opportunity__c);  
	                    taskToInsert.add(task);
                    }
                    // Update the quotes to trigger the process builder to send the email
                    Apttus_Proposal__Proposal__c oProposal = updateProposal(quote, oppOwnerId, oFoundTerrUtil);
                    propToUpdate.add(oProposal);
                } else {
                	// log error for better tracking of issues
                	Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
                	ex.Record_Id__c = quote.Apttus_Proposal__Opportunity__c;
                	ex.Object__c = 'Opportunity';
            		ex.Exception_Message__c = 'NSE New Opportunity owner cannot be set';
            		if (oppOwnerId == null) {
            			ex.Exception_Type__c = 'An Opportunity Owner could not be found based on Role and/or Territory2 setup';
            		} else {
            			ex.Exception_Type__c = 'An Opportunity Task Activity has already been created so updating the Opporruntiy Owner has been bypassed';
            		}
            		ex.Class_Reference__c = 'Ecom_AccountExecutiveBatch - Failure to set the Opportunity Owner';
            		exList.add(ex);
                }  
            }
            catch(Exception e) {
                
                createExceptionLog(e.getMessage(), e.getStackTraceString(), String.valueof(e.getLineNumber()));
                system.debug(LoggingLevel.INFO, 'String.valueof(e.getCause())===============>'+String.valueof(e.getCause()));
            }
            
        }
        // Update the Opportunity and insert tasks
        updateOpportunity(oppToUpdate, taskToInsert, propToUpdate);
        insertExceptions(exList);
    }
    
    
    // build a map for setting a Opp default owner
    private map<string, string> setOppOwnerDefaults() {
    	map<string, string> mapOppOwnerDefaults = new map<string, string>();
    	
    	if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible()) {
			// select store and Opp Owners
			for (Ecom_OrderService_Mappings__mdt lstMapping : [SELECT Id, Ecom_StoreName__c, Ecom_Owner__c 
						FROM Ecom_OrderService_Mappings__mdt 
						WHERE Ecom_Owner__c != null]) {               
				mapOppOwnerDefaults.put(lstMapping.Ecom_StoreName__c, lstMapping.Ecom_Owner__c);
            } // end of for       
        }
        
    	return mapOppOwnerDefaults;
    }


	// build a map to get the default owner id from their name
    private map<string, id> setOppOwnerDefaultIds(map<string, string> mapOppOwnerDefaults) {
        map<string, id> mapOppOwnerDefaultIds = new map<string, id>();
    	set<string> setOwnerNames = new set<string>();
    	
    	// get list of names
    	for (string strKey : mapOppOwnerDefaults.keyset()) {
    		setOwnerNames.add(mapOppOwnerDefaults.get(strKey));
    	}
    	if(Schema.sObjectType.User.isAccessible()) {
			// select store and Opp Owners
			for (User oUser : [SELECT Id, Name FROM User WHERE Name in: setOwnerNames]) {
           		mapOppOwnerDefaultIds.put(oUser.Name, oUser.Id);
           	}     
        }
        
    	return mapOppOwnerDefaultIds;	
    }
    
    
    // build the mapping information to map the information on a quote to a territory role
    // there can be more than one role per business segment 
    // remove parms (set<string> pricingSegment, set<String> proposalBU) {
    private map<String, Ecom_UtilMapping__mdt> buildTeamRoleMapping() {

        map<string, Ecom_UtilMapping__mdt> mapPropTeamRole = new map<string, Ecom_UtilMapping__mdt>();    	
        list<string> lstRoles = new list<string>();
        string key = '';
        
        if(Schema.sObjectType.Ecom_UtilMapping__mdt.isAccessible()) {
        	// each pricing seg/BU can have multiple roles
        	// add functionality for Priority, Exclude and Bypass processes
            for (Ecom_UtilMapping__mdt lstMapping : [SELECT Ecom_AccountTeamRole__c, Ecom_ProposalBU__c, Digital_Firm__c,
            						Priority__c, Exclude__c, Bypass__c 
            						from Ecom_UtilMapping__mdt 
            						WHERE Ecom_DigitalQuoteType__c = 'New Sales' 
            						order by Ecom_ProposalBU__c, Digital_Firm__c, Priority__c])
            {               
                //key = lstMapping.Ecom_CustPricingSegment__c + lstMapping.Ecom_ProposalBU__c;
                // DLT-21912 start using Digital Firm values to find the correct Role
                // the key is BU and Digital Firm.  BU is needed to determine if this is a FindLaw segment
                key = lstMapping.Ecom_ProposalBU__c + lstMapping.Digital_FIrm__c;
                mapPropTeamRole.put(key, lstMapping);
                // build a list of territory roles to use when we query Territory 2 ojbects
                lstTerrRoles.add(lstMapping.Ecom_AccountTeamRole__c);
                // build map with list of roles, as one segment can have multiple territory roles assigned to it                
			    if (!mapQuoteTeamRole.containsKey(key)) {
				 	mapQuoteTeamRole.put(key, new list<Ecom_UtilMapping__mdt>{lstMapping});
				} else {
				 	mapQuoteTeamRole.get(key).add(lstMapping);
				}
            } // end of for       
        }
        
    	system.debug(LoggingLevel.INFO, 'MDT NEW QUOTE map Team : ' + mapQuoteTeamRole);         
        system.debug(LoggingLevel.INFO, 'MDT map Team : ' + mapPropTeamRole);              
        system.debug(LoggingLevel.INFO, 'MDT list of Roles : ' + lstTerrRoles);
 		return mapPropTeamRole; 
    }
    
    
    // Create a map of team members for the specific roles and accounts needed
    // Updated from Account Teams to Terrirory2
    //private map<Id,list<AccountTeamMember>> buildAccountTeamMembers(set<id> accIds) {
    private void buildAccountTeamMembers(set<id> accIds) {
        map<id, id> mapTerrUser = new map<id, id>();
        string strAcctTerr;  
        		
        // select all territories for accounts to determine is the account has territories or not
        setAcctNoTerr = accIds.clone();
        for (ObjectTerritory2Association oAcctsWithTerr : [select ObjectId, Territory2Id, Territory2.TMS_Territory_Team_Role__c 
                        from ObjectTerritory2Association 
                        where ObjectId in : accIds]) {
        	// remove found accounts so we can have a list of account with no territories
        	if (setAcctNoTerr.contains(oAcctsWithTerr.ObjectId)) {
				setAcctNoTerr.remove(oAcctsWithTerr.ObjectId);
        	}
        }
         		
        // DLT-21195 - switch from using AccountTeamMember to Territory2 to find Opp Owner       
        // select all users and their associated territory roles 
        for (UserTerritory2Association oUserRoles : [select id, IsActive, Territory2Id, User.Username, User.Email, UserId, Territory2.TMS_Territory_Team_Role__c 
                        from UserTerritory2Association 
                        where Territory2.TMS_Territory_Team_Role__c in : lstTerrRoles                            
                        and Territory2Id in (select Territory2Id from ObjectTerritory2Association 
                        where ObjectId in : accIds)]) {
            mapTerrUser.put(oUserRoles.Territory2Id, oUserRoles.UserId);
            // keep a map to the users email to update the proposal
            mapUserEmail.put(oUserRoles.UserId, oUserRoles.User.Email);
        }
        // select account territories and map to User territories - ObjectId is the associated Account ID
        for (ObjectTerritory2Association oAcctTerr : [select ObjectId, Territory2Id, Territory2.TMS_Territory_Team_Role__c 
                        from ObjectTerritory2Association 
                        where ObjectId in : accIds 
                        and Territory2.TMS_Territory_Team_Role__c in : lstTerrRoles]) {
            // build map used to map account/role to a territory           	
            mapRoleToTerr.put(oAcctTerr.ObjectId+oAcctTerr.Territory2.TMS_Territory_Team_Role__c, oAcctTerr.Territory2Id);

        	//for each account/territory, lookup which user is assigned and build mapping 
        	if (mapTerrUser.containsKey(oAcctTerr.Territory2Id)) {
        		strAcctTerr = String.valueof(oAcctTerr.ObjectId) + String.valueof(oAcctTerr.Territory2Id);
        		mapTerrRoleUsers.put(strAcctTerr, mapTerrUser.get(oAcctTerr.Territory2Id));
        	}
        }
      
        system.debug(LoggingLevel.INFO, 'TERR2 map Terr Users : ' + mapTerrUser);        
        system.debug(LoggingLevel.INFO, 'TERR2 map Terr Role User : ' + mapTerrRoleUsers);       
    }
         
    
    // find the account team member
    private id findOppOwner(Apttus_Proposal__Proposal__c quote, map<String, Ecom_UtilMapping__mdt> mapPropTeamRole) { //, map<Id,list<AccountTeamMember>> mapAccTeamMembers) {
                
		// mapQuoteTeamRole - map of quote ps/bu fields used to find all the associated terr roles to check     
        // mapRoleToTerr - map of account id/roles to find the associated territory id       
		// mapTerrRoleUsers - map of account id/Territory id to find the opp owner id
		                
        //get team Role
        //string key = quote.APTS_Customer_Pricing_Segment__c + quote.APTS_Proposal_Business_Unit__c;
        // DLT-21912 Start using SSD Account Digital Firm to get the Territory role
        string key = quote.APTS_Proposal_Business_Unit__c + quote.APTS_SSD_bill_to__r.Digital_Firm__c ;
        string teamRoleName;
        string strAcctTerr;
        string strAcctRole;
        string strRole;
        decimal intPriorPriority;
        decimal intCurPriority;
        id idFoundTerr;
        id idFoundOwner = null;
        
        
        system.debug(LoggingLevel.INFO, 'Find Owner - Searching for key: ' + key + ' for Account: ' + quote.Apttus_Proposal__Account__c);
        oFoundTerrUtil = null;
          
        // search through all the roles for this account and see if we can find a matching territory
        for (string strKey : mapQuoteTeamRole.keyset()) {
        	system.debug(LoggingLevel.INFO, 'Find Owner - looping through: ' + strKey);
        	if (strKey == key) {
        		intPriorPriority = 999;
   				for(Ecom_UtilMapping__mdt oTerrMapping : mapQuoteTeamRole.get(strKey)) {
   					// when searching for roles, select the one with the hightest priority
   					strRole = oTerrMapping.Ecom_AccountTeamRole__c;
   					strAcctRole = String.valueof(quote.Apttus_Proposal__Account__c) + strRole;
   					system.debug(LoggingLevel.INFO, 'Find Owner - checking Role: ' + strRole + ' Account role: ' + strAcctRole);
       				// sort null priorities to the end
       				if (oTerrMapping.Priority__c == null) {
       					intCurPriority = 998;
       				} else {
       					intCurPriority = oTerrMapping.Priority__c;
       				}        			
        			if (mapRoleToTerr.containsKey(strAcctRole) && intCurPriority < intPriorPriority) {
	       				idFoundTerr = mapRoleToTerr.get(strAcctRole);
	        			// Save found utility mapping record to do Exclude and Bypass logic
	        			oFoundTerrUtil = oTerrMapping;
	        			intPriorPriority = intCurPriority;
	        			system.debug(LoggingLevel.INFO, 'Find Owner - Found Terr: ' + idFoundTerr + ' ' + oFoundTerrUtil);
        			}	
     			}
        	} 
		}
                     
        strAcctTerr = String.valueof(quote.Apttus_Proposal__Account__c) + String.valueof(idFoundTerr);
        system.debug(LoggingLevel.INFO, 'Find Owner - Looking for Acct Terr: ' + strAcctTerr);
        if (mapTerrRoleUsers.containsKey(strAcctTerr)) {
            idFoundOwner = mapTerrRoleUsers.get(strAcctTerr);
            system.debug(LoggingLevel.INFO, 'Find Owner - found owner: ' + idFoundOwner);
        }  
        if (idFoundOwner == null) {
            // log error for better tracking of issues
        	Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        	ex.Record_Id__c = quote.Apttus_Proposal__Opportunity__c;
        	ex.Object__c = 'Opportunity';
        	if (setAcctNoTerr.contains(quote.Apttus_Proposal__Account__c)) {
    			ex.Exception_Message__c = 'There are no Territories assigned to account: ' + quote.Apttus_Proposal__Account__c;
        	} else {
        		ex.Exception_Message__c = 'Territory roles not found for account: ' + quote.Apttus_Proposal__Account__c;
        	}
    		ex.Exception_Type__c = 'An Opportunity Owner could not be found based on Role and/or Territory2 setup';
    		ex.Class_Reference__c = 'Ecom_AccountExecutiveBatch - Failure to set the Opportunity Owner';
    		exList.add(ex);
        }    		    
        return idFoundOwner;          
    }

                
    //get opportunity Task
    private map<Id,list<Task>> buildOppTasks(set<id> oppIds) {
    	map<Id,list<Task>> mapOppTasks = new map<Id,list<Task>>();  
    	  
        list<task> accExeTask = [select id, whatid, whoId, subject 
        					from task 
        					WHERE WhatId IN :oppIds AND subject =: 'NSE - Account Executive updated'];
        for (Task task : accExeTask) {
            if (!mapOppTasks.containsKey(task.WhatId)) {
                mapOppTasks.put(task.whatId, new List<Task>());
            }
            mapOppTasks.get(task.whatId).add(task); 
        }   
        return mapOppTasks;
    }
    
     
   /** 
 	* @description : updateOpportunity method - update the Opportunity to set the owner and create a task
 	* @param oppToUpdate : List of Opportunities to update
 	* @param taskToInsert : List of tasks to insert
 	* @param propToUpdate : List of Proposals to update
  	*/ 
    public void updateOpportunity(list<Opportunity> oppToUpdate, list<Task> taskToInsert, list<Apttus_Proposal__Proposal__c> propToUpdate) {

        try {
            // update opportunities
            if(Schema.sObjectType.Opportunity.isUpdateable() && !oppToUpdate.isEmpty()) {
            	update oppToUpdate;
            }
            // insert tasks
            if(Schema.sObjectType.Task.isCreateable() && !taskToInsert.isEmpty()) {
            	insert taskToInsert;
            }
            // update proposals
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable() && !propToUpdate.isEmpty()) {
            	update propToUpdate;
            }
        } catch(Exception e) {  
            createExceptionLog(e.getMessage(), e.getStackTraceString(), String.valueof(e.getLineNumber()));           
        }  
    }
    
        
   /** 
 	* @description : createExceptionLog method - create log records
 	* @param exMessage : Exception Message
 	* @param exType : Exception Type
 	* @param additionalInfo : Additional Information
 	*/         
    public void  createExceptionLog(String exMessage, String exType, String additionalInfo) { 
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        ex.Class_Reference__c = 'Ecom_AccountExecutiveBatch > Execute' ;
        exList.add(ex);
    }
    
     
   /** 
 	* @description : finish method - finish up processing and create any errors
 	* @param info : batchable context
 	*/ 
    public void finish(Database.BatchableContext info) {
        // log errors, if any
        try {
            if (exList.size() > 0) {
                insert exList;
            }
        } catch(Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Exception' + ex);
        }
    }
    

   /** 
 	* @description : addactivity method - adds activity task to the Opportunity
 	* @param oppId : Opportunity ID
 	* @return Task record
 	*/     
    public static Task addactivity(String oppId) {
        Task task = new Task();
        task.Subject = Label.Ecom_AccountExecutiveActivity;    //'NSE - Account Executive updated'
        task.Status = 'Completed';
        task.Status__c = 'Completed';
        task.Description = Label.Ecom_AccountExecutiveActivity;     //'NSE - Account Executive updated' 
        task.whatid = oppId;
        task.ActivityDate = System.today();
       
        return task;
    }
    
    
   /** 
 	* @description : setOppOwner method - update the Opportunity owner
 	* @param opportunityId : Opportunity ID
 	* @param ownerid : Owner Id
 	* @param oFoundTerrUtil : Ecom Util Mapping mdt record for the role found for this quote
 	* @return Opportunity record
 	*/     
    public static Opportunity setOppOwner(String opportunityId, String ownerid, Ecom_UtilMapping__mdt oFoundTerrUtil) {
        Opportunity oppUpdate = new Opportunity();
        oppUpdate.Id = opportunityId;    
        // check if this segment want to be excluded or bypass from updating the Opp owner 
        // Excluded means to keep the original Opp Owner and exclude updating it based on Terr Roles
        // Bypass means to not process this Opp
        if (oFoundTerrUtil.Exclude__c == false && oFoundTerrUtil.Bypass__c == false) {                 
        	oppUpdate.OwnerId = ownerid;
        }
        // if excluded, check to see if original Opp Owner is correct because the segment on the account
        // could have changed since the Opportunity was created
        if (oFoundTerrUtil.Exclude__c == true) {
        	for (string strKey : mapOppOwnerDefaults.keyset()) {
        		if (strKey.contains(oFoundTerrUtil.Digital_Firm__c)) {
        			oppUpdate.OwnerId = mapOppOwnerDefaultIds.get(mapOppOwnerDefaults.get(strKey));
        		}
        	}
        }
        // set the owner updated field so the query won't pick up this proposal again
        oppUpdate.Is_Digital_Owner_Updated__c = true;
       
        return oppUpdate;
    }
    
    
   /** 
 	* @description : updateProposal method - update proposal to trigger the process builder to send the rep the email
 	* @param quote : quote record to update
 	* @param ownerid : Owner id
 	* @param oFoundTerrUtil : Ecom Util Mapping mdt record for the role found for this quote
 	* @return Proposal record
  	*/     
    public static Apttus_Proposal__Proposal__c updateProposal(Apttus_Proposal__Proposal__c quote, string ownerid, Ecom_UtilMapping__mdt oFoundTerrUtil) {
    	Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
    	oProposal.Id = quote.Id;
    	// check if this segment want to be excluded or bypass from updating the Opp owner 
        // Excluded means to keep the original Opp Owner and exclude updating it based on Terr Roles
        // Bypass means to not process this Opp and no Rep email
        oProposal.Opp_Owner_Email__c = 'pending.email@tr.com'; //mapUserEmail.get(ownerid);
        if (oFoundTerrUtil.Exclude__c == true) {
    		oProposal.Opp_Owner_Email__c = 'excluded.email@tr.com'; 
        }
        if (oFoundTerrUtil.Bypass__c == true) {
    		oProposal.Opp_Owner_Email__c = 'bypass.email@tr.com'; 
    		oProposal.Is_NSE_SR__c = true;
    		//oProposal.Is_NSE_SM__c = true;
        }
    	// set to win/loss reason to avoid validation errors
    	oProposal.Latam_APTS_Reason__c = 'Digital';
    	
    	return oProposal;
    }
    
    
   /** 
 	* @description : insertExceptions method - insert any exceptions encountered during processing
 	* @param exList : list of Digital Exception Log records
 	*/     
    public static void insertExceptions(list<Digital_Exception_Log__c> exList) {
    	//log errors, if any
        try {
            if (exList.size() > 0) {
                insert exList;
            }
        } catch(Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Exception' + ex);
        }
    }
    
}