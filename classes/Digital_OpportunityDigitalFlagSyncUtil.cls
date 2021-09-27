/**
 * This is a Utility class for Digital_OpportunityDigitalFlagSync 
 * This was created due to PMD violations of Excessive Class length, Ncss Method Count and Too Many Fields errors
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name               Description
 * 2020-10-29   Brenda Shields     DLT-21010 - Created to resolve PMD Violations
 * 2020-12-23   Brenda Shields     DLT-21196 - Update Territory Roles --- include new early/mid contract roles for Small Law Territories
 * 2021-03-17   Brenda Shields     DLT-21426 - DLT-21425 - Add method to update DS records with message if any errors occur
 * =============================================================================
 */  

/** 
 * @description : Utility functions for Digital_OpportunityDigitalFlagSyncUtil
 */ 
public with sharing class Digital_OpportunityDigitalFlagSyncUtil {
	private static final String OLD_MID_CONTRACT = 'Old Mid Contract';
	private static final String NEW_MID_CONTRACT = 'New Mid Contract';
	private static list<Product_Account_Detail__c> listDSUpdates = new list<Product_Account_Detail__c>();
	
    // create map for Owner lookup
    private static map<string, id> mapTeamMember = new map<string, id>();
    // create map for Owner lookup for accounts with mid-contract terms - they have different roles
    private static map<string, id> mapContractTeamMember = new map<string, id>();
    private static map<string, id> mapDigitalOwner = new map<string, id>();
    private static map<string, string> mapDigitalFirmCodes = new map<string, string>();
    private static list<string> lstRoles = new list<string>();   
    private static map<String, Digital_Territory_Roles__mdt> roleToDigitalTerritoryMap = new map<String, Digital_Territory_Roles__mdt>();
    private static map<String, Digital_Territory_Roles__mdt> roleToContractTerritoryMap = new map<String, Digital_Territory_Roles__mdt>();
        
    // create maps for Opp Team Member creation
    private static map<string, id> mapOppTeamRoles = new map<string, id>();
    private static list<string> lstOppTeamRoles = new list<string>();
    private static map<String, ObjectTerritory2Association> accSegmentToObjTerritoryMap = new map<String, ObjectTerritory2Association>();
 
    private static set<string> setSSDIds = new set<string>();  
    private static set<string> setAcctIds = new set<string>();
    // ssd account id, ssd id
    private static map<id, id> mapAcctSSD = new map<id, id>();   
    
        
    /** 
     * @description : Updates DS records to add matching Opp id
     * @param listUpdateOpps : list of existing Opportunities that have been updated
     * @param listDigitalOpps : list of new Opportunities that have been created
     * @param setSSDIdsForAllOpps : set of SSD ids to map the Opportunity to the Digital Subscription               
     */ 
    public static void updateDigitalSubscriptions(list<Opportunity> listUpdateOpps, list<Opportunity> listDigitalOpps, set<string> setSSDIdsForAllOpps) {
        list<Product_Account_Detail__c> listSelectedDS = new list<Product_Account_Detail__c>();
        
        system.debug(LoggingLevel.INFO, 'Update DS Records in: ' + setSSDIdsForAllOpps);
        // update DS records to include newly created/updated Opportunity lookup 
        if (((listUpdateOpps != null && listUpdateOpps.size() > 0) || (listDigitalOpps != null && listDigitalOpps.size() > 0))
                		&& Schema.sObjectType.Product_Account_Detail__c.isUpdateable()) {
            listSelectedDS = [Select id, Opportunity__c, Campaign_Code__c, Contract_Type__c, Renewal_Date__c, ZP_Cust_Number__c, 
                        Digital_Firm__c, Account__c, AccountSSD__c  
                        From Product_Account_Detail__c where AccountSSD__c in : setSSDIdsForAllOpps];
        } 
         
        // loop through all existing Opps to update the Digital Subscrition to add the Opp id
        for (Opportunity oOppUpdRec: listUpdateOpps) {
            setDigitalSubOpportunity(oOppUpdRec, listSelectedDS);
        } 
        // loop through all newly created Opps to update the Digital Subscrition to add the Opp id
        for (Opportunity oOppUpdRec: listDigitalOpps) {
            setDigitalSubOpportunity(oOppUpdRec, listSelectedDS);
        } 
       
        // remove any nulls from the Digital Subscription list
        integer j = 0;
		while (j < listDSUpdates.size()) {
  			if (listDSUpdates.get(j).id == null) {
			    listDSUpdates.remove(j);
  			} else {
    			j++;
  			}
		}
        // Update DS Records  
        updateDSRecords(listDSUpdates);
    }
       
    
    /** 
     * @description : Matches the DS records with appropriate Opp and adds the Opp id to the DS records
     * @param oOppUpdRec : the Opportunity to match to the DS records
     * @param listSelectedDS : list of DS Records to update for the matching Opp              
     */      
    public static void setDigitalSubOpportunity(Opportunity oOppUpdRec, list<Product_Account_Detail__c > listSelectedDS) {
        string strDSMatchKey;
        string strOppMatchKey;        
        
        // build match key for Opp
        strOppMatchKey = oOppUpdRec.Campaign_Code__c + ':'+ string.valueOf(oOppUpdRec.Renewal_Date__c); 
        system.debug(LoggingLevel.INFO, 'Update to DS - Opp ID: ' + oOppUpdRec.ID + ' Opp match Key: ' + strOppMatchKey +
            ' SSD: ' + oOppUpdRec.Source_System_Detail__c + ' ACCT: ' + oOppUpdRec.AccountID + ' DIGITAL: ' + oOppUpdRec.isDigitalSpearHead__c);
        // loop through all DS records and look for a match
        for (Product_Account_Detail__c oSelectedDSRec : listSelectedDS) {
            // build match key for DS rec
            strDSMatchKey = oSelectedDSRec.Campaign_Code__c + ':'+ string.valueOf(oSelectedDSRec.Renewal_Date__c); 
                
            // if we have a match - add the Opp id to the DS record
            // we don't want to include the old opps we are updating
            // only update the record if the opp is missing or wrong
            if (strDSMatchKey == strOppMatchKey && oOppUpdRec.isDigitalSpearHead__c == true &&
                (oOppUpdRec.Source_System_Detail__c == oSelectedDSRec.AccountSSD__c || oOppUpdRec.AccountID == oSelectedDSRec.Account__c)
                && oOppUpdRec.Id != oSelectedDSRec.Opportunity__c) {
                system.debug(LoggingLevel.INFO, 'Update to DS: ' + oSelectedDSRec);
                // update DS record              
                Product_Account_Detail__c oDSRecord = new Product_Account_Detail__c();  
                oDSRecord.id = oSelectedDSRec.Id;
                oDSRecord.Opportunity__c = oOppUpdRec.ID;
                listDSUpdates.add(oDSRecord);
            }
        }  // end of for loop 
    }
    
    
    /** 
     * @description : Updated the DS Records 
     * @param listUpdateDS : List of DS records to update
     */ 
    public static void updateDSRecords(list<Product_Account_Detail__c> listUpdateDS) {
        Database.UpsertResult[] lsr;
            
		// remove any duplicates
		Set<sobject> setTemp1 = new Set<sobject>();
		list<sobject> listFinalDS1 = new list<sobject>();
		for (sobject s1 : listUpdateDS) {
  			if (setTemp1.add(s1)) {
    			listFinalDS1.add(s1);
  			}
		}
		Set<Product_Account_Detail__c> setTemp = new Set<Product_Account_Detail__c>();
		list<Product_Account_Detail__c> listFinalDS = new list<Product_Account_Detail__c>();
		setTemp.addAll(listUpdateDS);
		listFinalDS.addAll(setTemp);

		system.debug(LoggingLevel.INFO, 'Opp Sync - Final DS Recs to Update pass 1: ' + listFinalDS1); 
        system.debug(LoggingLevel.INFO, 'Opp Sync - Final DS Recs to Update: ' + listFinalDS);    
        system.debug(LoggingLevel.INFO, 'Opp Sync - DS Recs to Update: ' + listUpdateDS);
        // Update DS Records  
        if (listFinalDS != null && listFinalDS.size() > 0  && Schema.sObjectType.Product_Account_Detail__c.isUpdateable()
        	&& !Test.isRunningTest()) {
            lsr = Database.upsert(listFinalDS, False);  
            for (Integer i = 0;  i < lsr.size(); i++) {
                id updatedDSId = listFinalDS.get(i).id;
                if (!lsr.get(i).isSuccess()) {
                    handleException(i, lsr, updatedDSId);
                }
            }
        }
    }
	
	    
    /** 
     * @description : For FindLaw Opportunities, create additional Team Members
     * @param mapOppAcctTeams : map of Account Teams
     * @param lstOppTeamRoles : list of Team Roles
     * @param mapOppTeamRoles : map of Team Roles
     */ 
    public static void createOppTeamMembers(map<id, id> mapOppAcctTeams, list<string> lstOppTeamRoles, map<string, id> mapOppTeamRoles) {
        list<OpportunityTeamMember> lstCreateOppTeams = new list<OpportunityTeamMember>();
        id idAccount;
        id idUser;
        
        // loop through the opp map to get the opp id and associated account
        for (Id idOpp : mapOppAcctTeams.keySet()) { 
            system.debug(LoggingLevel.INFO, 'looping results: ' + idOpp + ' : ' + mapOppAcctTeams.get(idOpp));
            idAccount = mapOppAcctTeams.get(idOpp);
            
            // Create Opp Team Members - one record for each role if the team member was found
            for (string oppRole : lstOppTeamRoles) {
                // did we find a user for this account and role
                idUser = mapOppTeamRoles.get(idAccount + oppRole);
                if (idUser != null) {
                    OpportunityTeamMember otm = new OpportunityTeamMember();
                    otm.OpportunityId = idOpp;
                    otm.UserId = idUser;
                    otm.TeamMemberRole = oppRole;
                    lstCreateOppTeams.add(otm);
                }
            }
        }
        insertOpportunityTeamMember(lstCreateOppTeams);
    }
    

	// insert Opportunity Team Member records
    private static void insertOpportunityTeamMember(list<OpportunityTeamMember> lstCreateOppTeams) {
        Database.UpsertResult[] lsr; 
        if (lstCreateOppTeams != null && lstCreateOppTeams.size() > 0 && Schema.sObjectType.OpportunityTeamMember.isUpdateable()) {  
            system.debug(LoggingLevel.INFO, 'Creating Opp Team Owners : ' + lstCreateOppTeams);
            // create Opportunity Team Members  
            lsr = Database.upsert(lstCreateOppTeams, False);  
            for (Integer i = 0;  i < lsr.size(); i++) {
                id updatedId = lstCreateOppTeams.get(i).OpportunityId;
                if (!lsr.get(i).isSuccess()) {
                    handleException(i, lsr, updatedId);
                }
            }
        }
    }
      
          
    /** 
     * @description : Creates a map of team members in use to set the Opp owners
     *                This also include creating map to set the Opp Team Members
     * @param setAcctIds : List of account ids to select account team members
     * @param mapAcctMidContract : map of Accounts with Mid Contracts
     * @return : returns map of team member owners
     */ 
    public static map<string, id> buildTeamMemberMap(set<string> setAcctIds, map<string, string> mapAcctMidContract) {
        map<string, string> mapTeamMemberFirm = new map<string, string>();
        map<id, id> mapTerrUser = new map<id, id>(); 
		
		// select roles and priorities for setting the Opportunity owner and build the appropriate maps
		mapTeamMemberFirm = selectDigitalRolesMDT();
		// select Territory2 users to assign as Opp owners and team members        
        mapTerrUser = selectTerr2Users(lstRoles, lstOppTeamRoles, setAcctIds);
        
        // select account territories and map to User territories - ObjectId is the associated Account ID
        for (ObjectTerritory2Association oAcctTerr : [select ObjectId, Territory2Id, Territory2.TMS_Territory_Team_Role__c 
                        from ObjectTerritory2Association 
                        where ObjectId in : setAcctIds 
                        and (Territory2.TMS_Territory_Team_Role__c in : lstRoles  
                        or Territory2.TMS_Territory_Team_Role__c in : lstOppTeamRoles)]) {
        	// make sure we get the user with the highest priority
        	if (mapAcctMidContract.get(oAcctTerr.ObjectId) == OLD_MID_CONTRACT ||
        			mapAcctMidContract.get(oAcctTerr.ObjectId) == NEW_MID_CONTRACT) {
        		// use map of all early and mid Contract roles
            	accSegmentToObjTerritoryMap = getFinalObjectTerritory2AssociationMap(roleToContractTerritoryMap, oAcctTerr, mapTeamMemberFirm);
        	} else {
        		// user map of all standard renewal roles (no early or mid contracts)
        		accSegmentToObjTerritoryMap = getFinalObjectTerritory2AssociationMap(roleToDigitalTerritoryMap, oAcctTerr, mapTeamMemberFirm);
        	}
        }
        
        system.debug(LoggingLevel.INFO, 'Find User: mapTerrUser: ' + mapTerrUser);  
		system.debug(LoggingLevel.INFO, 'Find User: accSegmentToObjTerritoryMap: ' + accSegmentToObjTerritoryMap);  
		
		// each record in this map should have the territory role found with the highest priority
        for(String key : accSegmentToObjTerritoryMap.keySet()){
            ObjectTerritory2Association oAcctTerr = accSegmentToObjTerritoryMap.get(key);
            String teamRole = String.valueOf(oAcctTerr.Territory2.TMS_Territory_Team_Role__c);
            String segment = mapTeamMemberFirm.get(teamRole);
            String strAccountId = String.valueOf(oAcctTerr.ObjectId);
            if (lstRoles.contains(teamRole)) {
                mapTeamMember.put(strAccountId + segment, mapTerrUser.get(oAcctTerr.Territory2Id));
            }
            if (lstOppTeamRoles.contains(teamRole)) {
                mapOppTeamRoles.put(strAccountId + teamRole, mapTerrUser.get(oAcctTerr.Territory2Id));
            }
        }
        
        system.debug(LoggingLevel.INFO, 'map Opp Team Member Roles : ' + mapOppTeamRoles);              
        system.debug(LoggingLevel.INFO, 'Team Members: ' + mapTeamMember);
        return mapTeamMember;
    }
    
    
    /** 
     * @description : select custom metadata type list of Digital Terrirory Role maps to Firm
     * @return : map Team Members to Firms
     */     
    public static map<string, string> selectDigitalRolesMDT() {
    	map<string, string> mapTeamMemberFirm = new map<string, string>();
		
        for (Digital_Territory_Roles__mdt oRoles : [SELECT Label, Role__c, Firm_Code__c, Opp_Team_Member_Role__c, Priority__c,
        											Early_Mid_Contract__c                            
                                                    FROM Digital_Territory_Roles__mdt]) { 
            // Roles and Priorities can be shared by different segments, so keep spearate maps to aid in the correct lookup
            if (oRoles.Early_Mid_Contract__c) {
            	roleToContractTerritoryMap.put(oRoles.Role__c, oRoles); 
            } else {
            	roleToDigitalTerritoryMap.put(oRoles.Role__c, oRoles); 
            }
            mapTeamMemberFirm.put(oRoles.Role__c, oRoles.Label); 

            // this Role is used to set Opportunity Team Members 
            if (oRoles.Opp_Team_Member_Role__c) {
                lstOppTeamRoles.add(oroles.Role__c);                
            // this Role is used to set the Opportunity Owner   
            } else {
                mapDigitalFirmCodes.put(oRoles.Label, oRoles.Firm_Code__c); 
                lstRoles.add(oRoles.Role__c);  
            }
        }
        system.debug(LoggingLevel.INFO, 'CMT Opp Owner Roles : ' + lstRoles);
        system.debug(LoggingLevel.INFO, 'CMT Opp Team Member Roles : ' + lstOppTeamRoles);
        
        return mapTeamMemberFirm;
    }    
    
    
    // select Users from user territory2 object
    private static map<id, id> selectTerr2Users(list<string> lstRoles, list<string> lstOppTeamRoles, set<string> setAcctIds) {
    	map<id, id> mapTerrUser = new map<id, id>();
        // we use to use AccountTeamMember to assign team members
        // but now we will start using Territory2 for user/role assignments           
        // select all users and their associated territory roles 
        for (UserTerritory2Association oUserRoles : [select id, IsActive, Territory2Id, User.Username, UserId, Territory2.TMS_Territory_Team_Role__c 
                        from UserTerritory2Association 
                        where (Territory2.TMS_Territory_Team_Role__c in : lstRoles
                        or Territory2.TMS_Territory_Team_Role__c in : lstOppTeamRoles)                              
                        and Territory2Id in (select Territory2Id from ObjectTerritory2Association 
                        where ObjectId in : setAcctIds)]) {
            mapTerrUser.put(oUserRoles.Territory2Id, oUserRoles.UserId);
        }
        return mapTerrUser;
    }
    

    /** 
     * @description : get Territory 2 association map
     * @param roleToDigitalTerritoryMap : map of roles to Territories
     * @param oAcctTerr : Account Territory
     * @param mapTeamMemberFirm : map of Team Members to Firms
     * @return : map of Account and Segment to Territory
     */ 
    public static map<String, ObjectTerritory2Association> getFinalObjectTerritory2AssociationMap(map<String, Digital_Territory_Roles__mdt> roleToDigitalTerritoryMap, ObjectTerritory2Association oAcctTerr, map<string, string> mapTeamMemberFirm) {
        // check to see which map to add the user to
        // a role can also be the same for the owner and for the opp team member
        string teamRole = String.valueOf(oAcctTerr.Territory2.TMS_Territory_Team_Role__c);
        string segment = mapTeamMemberFirm.get(teamRole);
        string strAccountId = String.valueOf(oAcctTerr.ObjectId);
         
        // if this is't a valid role for this account, then return   
        if (!roleToDigitalTerritoryMap.containsKey(teamRole)) {
        	return accSegmentToObjTerritoryMap;
        }
        
        //If key does not exist, add new key-value pair
        if (accSegmentToObjTerritoryMap.containsKey(strAccountId+segment)) {
            //Get the ObjectTerritory2Association inside of map and compare it with the current ObjectTerritory2Association
            String currentTopPriorityRole = accSegmentToObjTerritoryMap.get(strAccountId+segment).Territory2.TMS_Territory_Team_Role__c;

			system.debug(LoggingLevel.INFO, 'currentTopPriorityRole : ' + currentTopPriorityRole);
			system.debug(LoggingLevel.INFO, 'roleToDigitalTerritoryMap : ' + roleToDigitalTerritoryMap);

            if (roleToDigitalTerritoryMap.containsKey(currentTopPriorityRole) &&
            	roleToDigitalTerritoryMap.get(teamRole).Priority__c != null
                && (roleToDigitalTerritoryMap.get(currentTopPriorityRole).Priority__c == null
                || (roleToDigitalTerritoryMap.get(currentTopPriorityRole).Priority__c != null
                && roleToDigitalTerritoryMap.get(teamRole).Priority__c < roleToDigitalTerritoryMap.get(currentTopPriorityRole).Priority__c))) {

                accSegmentToObjTerritoryMap.put(strAccountId+segment, oAcctTerr);
            }
        } else {
            accSegmentToObjTerritoryMap.put(strAccountId+segment, oAcctTerr);
        }
        return accSegmentToObjTerritoryMap;
    }
    
    
    /** 
     * @description : Creates a map of the Digital Onwers by Firm to use as a default to set the Opp owner
     * @return : returns map of digital owners
     */ 
    public static map<string, id> buildDigitalOwnerMap() {
        map<string, id> mapDigitalOwner = new map<string, id>();
  
        // get the owner default for each Digital Firm
        if (Schema.sObjectType.Digital_Firm_Defaults__mdt.isAccessible()) {
            for (Digital_Firm_Defaults__mdt oDefaults: [SELECT Opportunity_Owner_Id__c, Proposal_Approval_Segment__c                            
                                                       FROM Digital_Firm_Defaults__mdt]) {                          
                mapDigitalOwner.put(oDefaults.Proposal_Approval_Segment__c, oDefaults.Opportunity_Owner_Id__c);     
            }
        }
        return mapDigitalOwner;
    }
    
  
    /** 
     * @description : Creates a map of Contacts to set Key Contact on the Opportunity
     * @param setSSDIds : List of SSD ids to select Contacts
     * @return : returns map of Contacts
     */ 
    public static map<id, string> buildContactsMap(set<string> setSSDIds) {
        set<string> setNotFound = new set<string>();
        map<id, string> mapContact = new map<id, string>();
        
        // Create set of all Acct ids and remove those when found, so we end up with a list of only those not found
        setNotFound = setAcctIds.clone();
        
        // select contacts
        // DLT-20475 make sure the contact is active AND valid
        if (Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()) {
            for (LCRM_Contact_SSD__c csd : [Select id, name, LCRM_Contact__c, LCRM_Account_SSD__c, LCRM_Contact__r.AccountId 
                                            from LCRM_Contact_SSD__c where Contact_Inactive__c = false and
                                            LCRM_Contact__r.Contact_Inactive__c = false and LCRM_Contact__r.IsEmailBounced = false
                                            and LCRM_Account_SSD__c in : setSSDIds]) {
                mapContact.put(csd.LCRM_Account_SSD__c, csd.LCRM_Contact__c);
                setNotFound.remove(csd.LCRM_Contact__r.AccountId);
            }
        }
        
        // if we didn't find all the Contacts from SSD, check the Contacts on the Account
        // DLT-20475 make sure the contact is active AND valid
        if (!setNotFound.isEmpty() && Schema.sObjectType.Contact.isAccessible()) {
            for (Contact oCont : [Select id, name, AccountId
                                  from Contact where Contact_Inactive__c = false and IsEmailBounced = false
                                   and AccountId in : setNotFound]) {
                mapContact.put(mapAcctSSd.get(oCont.AccountId), oCont.Id);
            }
        }
        
        system.debug(LoggingLevel.INFO, 'All Contacts: ' + mapContact);
        return mapContact;
    }
     
     
    /** 
     * @description : Set/verify Contact and Owner information before Committing changes
     *                This contains all pre existing and new Opportunities
     * @param listUpdateOpps : List of Opportunity records to update
     * @param setSSDAccounts : set of all SSD Accounts
     * @param mapAcctMidContract : map of all mid-contract accounts
     */ 
    public static void finalizeOppRecords(list<Opportunity> listUpdateOpps, set<string> setSSDAccounts, map<string, string> mapAcctMidContract) {
    	list<Opportunity> listOppsToUpdate = new list<Opportunity>();
    	
    	// build info to set the correct contacts
    	map<id, string> mapContact = new map<id, string>();
        string strOwner;
        string strDigitalFirm;
        
        // build all account and ssd lists
        for (Opportunity oOpp : listUpdateOpps) {
        	setAcctIds.add(oOpp.AccountID);
        	mapAcctSSD.put(oOpp.AccountID, oOpp.Source_System_Detail__c);
        }
        
        if (!(Schema.sObjectType.Digital_Territory_Roles__mdt.isAccessible() 
            && Schema.sObjectType.ObjectTerritory2Association.isAccessible() 
            && Schema.sObjectType.UserTerritory2Association.isAccessible())) {
            throw new DCCustomException('buildTeamMemberMap() method: User does not have access to objects');
        } else {
            // select account team owners and build map  
            // roles have been expanded to mid-contract so include those that map
        	mapTeamMember = buildTeamMemberMap(setAcctIds, mapAcctMidContract);
        }
        
        // build Default Digital Owners
        mapDigitalOwner = buildDigitalOwnerMap();
		// build Contact list for all accounts - check to make sure they are all valid 
		mapContact = buildContactsMap(setSSDAccounts); 
		    
		// loop through all Opportunities and udpate Contacts and Owners if needed 
		for (Opportunity oOpp : listUpdateOpps) {
			// Don't update Opps if we are just unmarking them as digital
			if (oOpp.Unmarked_Digital_Channel__c == false) {
				// the digital firm should be set for all opps being updated or inserted
				// set to FindLaw if needed
				strDigitalFirm = getOppDigitalFirm(oOpp);

				// Set/reset the Contact - these are already verified			
            	oOpp.Key_Contact__c = mapContact.get(oOpp.Source_System_Detail__c); //oSSDRecord.id);

                // set the owner 
                strOwner = mapTeamMember.get(oOpp.AccountID + strDigitalFirm);
                // reset Digital Firm back to the correct value - only for Corp
                // also needed if no territory owner was found and we need to use the default owner
                if (strDigitalFirm == 'Corp-SMB') {
                	oOpp.Digital_Firm__c = 'Corporate';
                	strDigitalFirm = 'Corporate';
                }
                if (strOwner == null && mapDigitalOwner.get(strDigitalFirm) != null) {
                    strOwner = mapDigitalOwner.get(strDigitalFirm);
                }
                oOpp.Ownerid = strOwner;
                // update the Opp Name to contain a digital firm code and to add DigitalOpp at the end
        		oOpp.Name = oOpp.Name + '-' + mapDigitalFirmCodes.get(strDigitalFirm) + '-DigitalOpp';
                system.debug(LoggingLevel.INFO, 'Opp Owner: ' + strOwner);
        	} // end of if for unmarked digital
		} // end of for Opp loop

        
        // check for errors and remove them from the list of opps to be inserted/updated
        listOppsToUpdate = checkForOppErrors(listUpdateOpps);
        if (listOppsToUpdate.size() > 0) {
        	updateALLOppRecords(listOppsToUpdate, setSSDAccounts);
        } 
	} 
    
    
    // the digital firm should be set for all opps being updated or inserted
	private static string getOppDigitalFirm(Opportunity oOpp) {
		string strDigitalFirm;
				
		strDigitalFirm = oOpp.Digital_Firm__c;
		if (oOpp.Owner.Sub_Bu__c == 'FindLaw' || 
	       	(oOpp.Owner.Rep_Type_Description__c != null && oOpp.Owner.Rep_Type_Description__c.containsIgnoreCase('FindLaw'))) {
    	   	strDigitalFirm = 'FindLaw';
        }
		return strDigitalFirm;
	}
	
    
    private static list<Opportunity> checkForOppErrors(list<Opportunity> listUpdateOpps) {
    	list<Digital_Exception_Log__c> listEx = new list<Digital_Exception_Log__c>();
    	list<Opportunity> listToUpdate = new list<Opportunity>();
    	
    	for (Opportunity oOpt : listUpdateOpps) {
    		// don't check on Opps where we are just unmarking as digital
    		if (oOpt.Unmarked_Digital_Channel__c == false && 
        		(oOpt.Ownerid == null || oOpt.Key_Contact__c == null || oOpt.Renewal_Date__c == null || 
        		oOpt.Campaign_Code__c == null)) {
           		Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            	ex.Exception_Message__c = 'Opportunity field is null';
            	ex.Exception_Type__c = 'Opportunity Insert Failed for SSD: ' + oOpt.Source_System_Detail__c; //failed record from the list
            	ex.Additional_Information__c = 'Opp Owner: ' + oOpt.Ownerid + ', Opp Contact: ' + oOpt.Key_Contact__c + 
                           ', Opp Renewal Date: ' + oOpt.Renewal_Date__c + ', Opp Campaign Code: ' + oOpt.Campaign_Code__c;            
	            ex.User_Message__c = 'An Opportunity field value could not be found.';
    	        ex.Class_Reference__c = 'Digital_OpportunityDigitalFlagSyncUtil - Error Creating Opportunity';
        	    listEx.add(ex);   
        	} else {
            	listToUpdate.add(oOpt);
        	}
    	}
    	// insert any errors
    	if (listEx.size() > 0) {
    		insertDigitalErrors(listEx);
    	}
    	return listToUpdate;
    }
    
       
    /** 
     * @description : Commit changes Update/Insert for Opportunities.  This is updating existing Opps,
     *                inserting new Opps and un-marking old Opps as Digital 
     * @param listUpdateOpps : List of Opportunity records to update
     * @param setSSDAccounts : Set of SSD records
     */ 
    public static void updateALLOppRecords(list<Opportunity> listUpdateOpps, set<string> setSSDAccounts) {
    	map<id, id> mapOppAcctTeams = new map<id, id>();
        Database.UpsertResult[] lsr;
        id idOpp;
        id idAccount;
        string strOppName;
        boolean bOppDigital;
               
        // Update/insert any Opportunities    
        lsr = Database.upsert(listUpdateOpps, False);  
        for (Integer i = 0;  i < lsr.size(); i++) {
            idOpp = listUpdateOpps.get(i).id;
            idAccount = listUpdateOpps.get(i).AccountID;
            if (lsr.get(i).isSuccess()) {  
                strOppName = listUpdateOpps.get(i).Name;
                bOppDigital = listUpdateOpps.get(i).isDigitalSpearHead__c;
                // if this is FindLaw and we are not un-marking the, save the Opp so we can set Opp Team Members
                if (bOppDigital && strOppName.contains('-FL-')) {
                    mapOppAcctTeams.put(idOpp, idAccount);  
                }
            } else {   
                if (idOpp == null) {
                    idOpp = idAccount;
                }
                handleException(i, lsr, idOpp);
            }
            system.debug(LoggingLevel.INFO, 'Opp Update Results: ' + lsr);
            
        }
        // after Opps have been created, Create Opportunity Team Members
        if (!mapOppAcctTeams.isEmpty()) {
        	createOppTeamMembers(mapOppAcctTeams, lstOppTeamRoles, mapOppTeamRoles);
        }
    }

 
    /** 
     * @description : Create Digital Validation Setting and all Customers for this run
     *                This will help the Cohort validation process if it's not included as a part of the automation run
     * @param setDigitalFirms : set of unique digital firm values
     * @param listDSubRecords : list of digital subscriptions for the creation of validation customers
     */     
    public static void createValCustomers(set<string> setDigitalFirms, list<Product_Account_Detail__c> listDSubRecords) {
        // list to create the digital settings and digital customer records
        list<Digital_Settings__c> listDSettings = new list<Digital_Settings__c>();
        //list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        // create a new list of Digital Firms from the set passing in
        list<string> listDigitalFirms = new list<string>(setDigitalFirms);
        // map of digital setting is to included in the digital customer records
        map<string, id> mapDSettingIds = new map<string, id>();
        id idSettingRecord;
        Database.UpsertResult[] lsr;
        
        system.debug(LoggingLevel.INFO, 'Opp Sync Util - Set Digital Firms: ' + setDigitalFirms);
        system.debug(LoggingLevel.INFO, 'Opp Sync Util - List Digital Firms: ' + listDigitalFirms);

        if (!Schema.sObjectType.Digital_Settings__c.isCreateable() || 
        	!Schema.sObjectType.Digital_Customer__c.isCreateable()) { 
        	//if (Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {    
            	//throw new DCCustomException('Digital_OpportunityDigitalFlagSyncUtil : User does not have all the required access to create digital validation settings and customers');
           	 	//Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            	//ex.Exception_Message__c = 'User does not have all the required access to create digital validation settings and customers';
            	//ex.Exception_Type__c = 'Record Creation failed';      
	        	//ex.User_Message__c = 'Cohort Validation record creation failed';
           		//ex.Class_Reference__c = 'Digital_OpportunityDigitalFlagSyncUtil - Error Creating validation objects';
           		//insert ex;
        	//}
 			return;
        }
        // if the Automation run is a part of the Cohort Validation then there is no need to re-create the settings or customers
        list<Digital_Settings__c> ds = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c 
        	from Digital_Settings__c where Data_Status__c = 'Post-CohortsJob' and Job_Status__c = 'Started'
            and RecordTypeId =: Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId() and CreatedById =: Userinfo.getUserId()];
		if (!ds.isEmpty()) {
            return;
		}
        
        // create settings record - one for each digital firm
		DateTime myDateTime = system.Now();
		string strDateTime = myDateTime.formatGMT('yyyyMMdd HH:mm:ss');
		// create a Digital Settings record for each different segment
        for (string strDigitalFirm : listDigitalFirms) {
        	Digital_Settings__c dvs = new Digital_Settings__c();
           	dvs.Name = 'Auto ' + strDigitalFirm + ' ' + strDateTime;
           	dvs.Data_Status__c = 'Digital Auto-Run';
           	dvs.Job_Status__c = 'Holding ' + strDateTime;
           	dvs.Segment__c = strDigitalFirm;
           	dvs.Batch_Size__c = 1;
           	listDSettings.add(dvs);  
       		system.debug(LoggingLevel.INFO, 'Opp Sync Util - new setting record: ' + dvs);     
        }
		lsr =  Database.upsert(listDSettings, false);
        if (lsr != null && lsr.size() > 0) {
           	for (Integer i = 0; i < lsr.size(); i++) {
               	if (lsr.get(i).isSuccess()) {
               		// get ids to map to the digital customer records
               		idSettingRecord = listDSettings.get(i).id;
                   	mapDSettingIds.put(listDSettings.get(i).Segment__c, listDSettings.get(i).id);
                   	system.debug(LoggingLevel.INFO, 'Opp Sync Util - INSERTING Segment : ' + listDSettings.get(i).Segment__c); 
                   	system.debug(LoggingLevel.INFO, 'Opp Sync Util - INSERTING ID: ' + listDSettings.get(i).id);
               	} else {
					handleException(i, lsr, idSettingRecord);
               	} 
           	} // end of for
        }
        // insert the validation customers    
		insertValCustomers(listDSubRecords, mapDSettingIds);	 
    }
    
    
    /** 
     * @description : Creates and inserts Digital Validation Customers for this run
     *                This will help the Cohort validation process if it's not included as a part of the automation run
     * @param listDSubRecords : list of digital subscriptions for the creation of validation customers
     * @param mapDSettingIds : map of Validation Settings id to map to new customers     
     */      
    public static void insertValCustomers(list<Product_Account_Detail__c> listDSubRecords, map<string, id> mapDSettingIds) {
    	list<Digital_Customer__c> listDCustomers = new list<Digital_Customer__c>();
    	        
    	system.debug(LoggingLevel.INFO, 'Opp Sync Util - Segment Map: ' + mapDSettingIds); 
        // create the digital Customer records
        for (Product_Account_Detail__c dsSub : listDSubRecords) {
        	Digital_Customer__c dCustomer = new Digital_Customer__c();
         	dCustomer.Digital_Settings__c = mapDSettingIds.get(dsSub.Digital_Firm__c); 
           	dCustomer.SAP_Number__c = dsSub.ZP_Cust_Number__c;
           	listDCustomers.add(dCustomer);
        }
        try {
            if (listDCustomers.size() > 0 && listDCustomers != Null) {
                insert listDCustomers; 
            } 
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, 'Exception' + e);
        } 
    }
    
    
    /** 
     * @description : Exception handler - Write out exceptions to the Exception log
     * @param i : index to error record
     * @param updateList : List of records to update
     * @param updatedRecordId : ID of record in error
     */     
    public static void handleException (integer i, Database.UpsertResult[] updateList, Id updatedRecordId) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        Database.Error error = updateList.get(i).getErrors().get(0);
        ex.Exception_Message__c = error.getMessage(); //failedDML;
        ex.Exception_Type__c = 'Record Update Error: Id - ' + updatedRecordId; //failed record from the list
        for (string errorField : error.getfields()) {
            ex.Additional_Information__c += errorField + ',';            
        }
        ex.User_Message__c = String.Valueof(error.getStatusCode());
        ex.Class_Reference__c = 'Digital_OpportunityDigitalFlagSync - Error Updating Opportunity';

        try {
        	if (Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {
            	insert ex; 
        	}
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, 'Exception' + e);
        } 
    } // end of error handling  
    
  
    /** 
     * @description : insert any errors
     * @param exList : list of exception records to insert
     */     
    public static void insertDigitalErrors(list<Digital_Exception_Log__c> exList) {
        try {
            if (exList.size() > 0 && exList != Null && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {
                insert exList;
            } 
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, 'Exception' + e);
        } 
	}
	
	
	/** 
     * @description : Updates DS records where an Opportunity was not created
     * @param listOpps : List of Opportunities with Rep Driven Proposals              
     */      
    public static void setDigitalSubOppError(list<Opportunity> listOpps) {
        list<Product_Account_Detail__c> listSelectedDS = new list<Product_Account_Detail__c>();
        set<id> setSSDids = new set<id>();
        string strDSMatchKey;
        string strOppMatchKey;
        
        // get SSD Ids to query DS records
        for (Opportunity oOppRec: listOpps) {
        	setSSDids.add(oOppRec.Source_System_Detail__c);
        }
        
        system.debug(LoggingLevel.INFO, 'Update DS Records in: ' + setSSDids);
        if (listOpps != null && listOpps.size() > 0 && Schema.sObjectType.Product_Account_Detail__c.isUpdateable()) {
                			
            listSelectedDS = [Select id, Opportunity__c, Campaign_Code__c, Contract_Type__c, Renewal_Date__c, ZP_Cust_Number__c, 
                        Digital_Firm__c, Account__c, AccountSSD__c  
                        From Product_Account_Detail__c where AccountSSD__c in : setSSDids];
        } 
         
        // loop through all Opps list, there are multiple DS records for each 
        for (Opportunity oOppRec: listOpps) {

		    // build match key for Opp
		    strOppMatchKey = oOppRec.Campaign_Code__c + ':'+ string.valueOf(oOppRec.Renewal_Date__c); 
		    system.debug(LoggingLevel.INFO, 'Update to DS - Opp ID: ' + oOppRec.ID + ' Opp match Key: ' + strOppMatchKey);
		    
		    // loop through all DS records and look for a match
		    for (Product_Account_Detail__c oSelectedDSRec : listSelectedDS) {
		        // build match key for DS rec
		        strDSMatchKey = oSelectedDSRec.Campaign_Code__c + ':'+ string.valueOf(oSelectedDSRec.Renewal_Date__c); 
		            
		        // if we have a match - Update the DS record with the message and Opp id 
		        if (strDSMatchKey == strOppMatchKey && oOppRec.Source_System_Detail__c == oSelectedDSRec.AccountSSD__c ) {
		            system.debug(LoggingLevel.INFO, 'Update to DS: ' + oSelectedDSRec);
		            
		            // update DS record              
		            Product_Account_Detail__c oDSRecord = new Product_Account_Detail__c();  
		            oDSRecord.id = oSelectedDSRec.Id;
		            oDSRecord.Digital_Offer_Status__c = 'Bypassed';
		            oDSRecord.Status_Message__c = 'Automation Bypass: This account is associated to the following ' +
		            	'Rep Driven Opportunity: ' + oOppRec.ID;
		            listDSUpdates.add(oDSRecord);
		        }
		    }  // end of for loop for Digital Subscriptions
        }  // end of for loop for Opportunities
        
        // Update DS Records  
        if (listDSUpdates != null && listDSUpdates.size() > 0) {
        	updateDSRecords(listDSUpdates);
        }	
    }
                 
}