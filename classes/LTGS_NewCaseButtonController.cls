/*
 * Created: 03/12/2019
 * Author: Akansha Gill
 * CHANGE HISTORY
 * ==========================================================================================================
 *  Date          Name                 Description
 *  2019-03-12    Akansha             Initial Version
 * ==========================================================================================================
 @description  Class: LTGS_NewCaseButtonController
 @comment  Controller class to fetch Case record type and logged-in User's Profile data inorder for creating Lightning Component which is used
 to Achieve 'New' button functionality for Case object.
 
 */
public without sharing class LTGS_NewCaseButtonController{
    /**
     @description profileString
     @comment stringvalue
     */
	public static String profile = '';
	/*
	 @description get-set method
	 @comment  Controller class to fetch Case record type and logged-in User's Profile data inorder for creating Lightning Component which is used
	 to Achieve 'New' button functionality for Case object.
	 
	 *
	 */
	public static Map<Id, String> recordtypemap{ get; set; }

	/********************************************************************************************************
	 @description fetchRecordTypeValues
	 @comment  Method to get Case Record type.
	 @return mapofvalues
	 @param objectName
	 ********************************************************************************************************/
	@AuraEnabled
	public static Map<Id, String> fetchRecordTypeValues(String objectName){
		List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();
		recordtypemap = new Map<Id, String>();
		for (RecordTypeInfo rt : recordtypes){
			if (rt.getName() != 'Master' && rt.isAvailable() && rt.getName().trim() != ''){
				recordtypemap.put(rt.getRecordTypeId(), rt.getName());
				System.debug(LoggingLevel.DEBUG, 'record type=-' + recordtypemap);
			}
		}
		System.debug(LoggingLevel.DEBUG, 'return rec--' + recordtypemap);
		return recordtypemap;
	}

	/********************************************************************************************************
	 @description getCurrentUserProfile
	 @comment  Method to get logged-in user profile
	 @return profileName
	 ********************************************************************************************************/
	@AuraEnabled
	public static String getCurrentUserProfile(){
		Id profileId = userinfo.getProfileId();
		String profileName = [Select Id, Name
		                      from Profile
		                      where Id = :profileId].Name;
		return profileName;
	}

	/********************************************************************************************************
	 @description getCurrentUserProfile
	 @comment Method to get Case Record type.
	 @return booleanCheck
	 ********************************************************************************************************/
	@AuraEnabled
	public static boolean executeProfiles(){
		List<String> listOfValue = new List<String>();
		List<ESC_Static_Value__mdt> escStaticValues = new List<ESC_Static_Value__mdt>();
		//List<string> splprofile = new List<string>();
		Boolean retVar = false;
		profile = getCurrentUserProfile();
		if (Schema.sObjectType.ESC_Static_Value__mdt.isAccessible()){
			escStaticValues = [SELECT ESC_profile_value__c
			                   FROM ESC_Static_Value__mdt
			                   Where Label = 'Profiles'];
		}
		for (ESC_Static_Value__mdt a : escStaticValues){
			listOfValue.add(a.ESC_profile_value__c);
		}
		retVar = listOfValue.contains(profile) ? true : false;
		return retVar;
	}

	/********************************************************************************************************
	 @description getParentAccountId
	 @comment  Method to get Account Id from Contact Related List
	 @return StringaccountID
	 @param contactId
	 ********************************************************************************************************/
	@AuraEnabled
	public static String getParentAccountId(String contactId){
		Id contactIdRec = Id.valueof(contactId);
		return [SELECT AccountId
		        FROM Contact
		        WHERE Id = :contactIdRec] ?.AccountId;
	}
}