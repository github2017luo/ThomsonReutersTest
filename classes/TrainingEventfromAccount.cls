/**
 * @description Contains methods for TrainingEventfromAccount VF Page
 *
 * @author  Srikanth Kuruva
 * @version  2012-02-16
 *
 */
public without sharing class TrainingEventfromAccount{
    public static boolean userCheck;
    public Id accountId = System.currentPageReference().getParameters().get('AccId');
    public Id strategyId = System.currentPageReference().getParameters().get('StrategyId');
    public Id userProfileId = Userinfo.getProfileId();
   
	/**
	 * @description gettersetter
	 */
	public Training_Event__c tTrainingEvent{ get; set; }

	/**
	 * @description gettersetter
	 */
	public Account aAccount{ get; set; }

	/**
	 * @description gettersetter
	 */
	public SFDC_Strategy__c oStrategy{ get; set; }

	/**
	 * @description gettersetter
	 */
	public Boolean bRenderAccountInfo{ get; set; }

	/**
	 * @description gettersetter
	 */
	public Boolean bRenderStrategyInfo{ get; set; }
	
	//added by Saloni for CRM-3239 to redirect to GLI Training Event Creation page
	/**
	 * @description : onPageLoad description
	 *
	 * @return PageReference: Return description
	 */
	public PageReference onPageLoad(){
		PageReference oPage;
		//accountId = System.currentPageReference().getParameters().get('AccId');
		//strategyId = System.currentPageReference().getParameters().get('StrategyId');
		//userProfileId = Userinfo.getProfileId();
		String userBusinessUnit = LCRMGenericComponent.getUserBU();
		Boolean bUFlag = LCRMGenericComponent.validateUserBU(userBusinessUnit);
		String destURL = '/apex/LCRMTrainingEventCreation';

		if (bUFlag || LCRMGenericComponent.isLotusUser()){
			userCheck = true;
			Map<String, String> parameters = ApexPages.currentPage().getParameters();
			Map<String, String> customParameters = new Map<String, String>();

			system.debug(LoggingLevel.DEBUG, parameters + '<--parameters');
			String account = FieldId__c.getOrgDefaults().AccOnTrainingEvent__c;
			customParameters.put(account, account);
			String contact = FieldId__c.getOrgDefaults().ContactOnTrainingEvent__c;
			customParameters.put(contact, contact);
			String oppty = FieldId__c.getOrgDefaults().OppOnTrainingEvent__c;
			customParameters.put(oppty, oppty);
			String stragy = FieldId__c.getOrgDefaults().StrategyOnTE__c;
			customParameters.put(stragy, stragy);
			system.debug(LoggingLevel.DEBUG, customParameters.size()+'<--customParameters.size');
			system.debug(LoggingLevel.DEBUG, parameters + '<--parameters');
			system.debug(LoggingLevel.DEBUG, customParameters + '<--customParameters');
			system.debug(LoggingLevel.DEBUG, 'LCRMGenericComponent.isLotusUser()**' + LCRMGenericComponent.isLotusUser());

			//if (parameters != null && (bUFlag || LCRMGenericComponent.isLotusUser())){

			//Boolean checkRedirection = checkParametersforredirection(parameters, customParameters);
			//if (!(parameters.containsKey(account) || parameters.containsKey(contact) || parameters.containsKey(oppty) || parameters.containsKey(stragy))){
			if (parameters != null && (!checkParametersforredirection(parameters, customParameters)) && userCheck == true){
				oPage = new PageReference(destURL);
				system.debug(LoggingLevel.DEBUG, '1# ' + oPage);

			} else if (parameters != null && parameters.get(account) == null){
				//String accountId = parameters.get(account);
				//if (accountId == null){
				String contactId = parameters.get(contact);
				String opptyId = parameters.get(oppty);
				String stratid = parameters.get(Stragy);
				oPage = redirectTEPage(contactId, opptyId, stratid);
				system.debug(LoggingLevel.DEBUG, '2# ' + oPage);


			} else if (parameters != null){

				oPage = new PageReference(destURL + '?AccId=' + accountId);
				system.debug(LoggingLevel.DEBUG, '3# ' + oPage);
			}
			//}
			//}
		}

		return oPage;
	}

	/**
	 * @description TrainingEventfromAccount description
	 * @param  controller
	 * ## controller (ApexPages.StandardController): controller
	 */
	public TrainingEventfromAccount(ApexPages.StandardController controller){
		tTrainingEvent = (Training_Event__c)controller.getRecord();
		tTrainingEvent.Training_Date__c = System.Today();
		Profile p = [select Id, Name
		             from Profile
		             where Id = :userProfileId
		             WITH SECURITY_ENFORCED];
		if (Default_Status_Value__c.getInstance(p.Name) != null){
			tTrainingEvent.Status__c = Default_Status_Value__c.getInstance(p.Name).Default_Status_Value__c;
		}
		if (AccountId != null){
			tTrainingEvent.Account_Level__c = true;
			aAccount = [select Id, Name, SAPAccountNumber__c
			            from Account
			            where Id = :accountId
			            WITH SECURITY_ENFORCED];
			tTrainingEvent.Account__c = aAccount.Id;
			bRenderAccountInfo = true;
		}
		if (strategyId != null){

			oStrategy = [select Id, Name
			             from SFDC_Strategy__c
			             where Id = :strategyId
			             WITH SECURITY_ENFORCED];
			tTrainingEvent.Strategy__c = oStrategy.Id;
			bRenderStrategyInfo = true;
		}
	}

	/**
	 * @description save description
	 *
	 * @return pageReference: Return description
	 */
	public pageReference save(){

		if (Schema.sObjectType.Training_Event__c.isCreateable()){
			insert tTrainingEvent;
		}

		//commented for QC3313
		/* if(AccountId != null)
		 {
		 Training_Event_Account__c tTEA = new Training_Event_Account__c();
		 tTEA.Account__c = AccountId;
		 tTEA.Training_Event__c = tTrainingEvent.Id;
		 insert tTEA;
		 }*/

		//PageReference pg = new PageReference('/apex/ManageContacts?id='+tTrainingEvent.Id+'&AccId='+AccountId);
		PageReference pg = new PageReference('/' + tTrainingEvent.Id);
		return pg;
	}

	/**
	 * @description cancel description
	 *
	 * @return pageReference: Return description
	 */
	public pageReference cancel(){
		String retURL;

		if (strategyId != null){
			retURL = '/' + strategyId;
		} else if (accountId != null){
			retURL = '/' + accountId;
		} else if (System.currentPageReference().getParameters().get('retURL') != null){
			retURL = System.currentPageReference().getParameters().get('retURL');
		} else{
			retURL = '/home/home.jsp';
		}

		PageReference pg = new PageReference(retURL);
		return pg;
	}

	/**
	 * @description checkParametersforredirection description
	 *
	 * @param urlParameters (Map<StringString>): urlParameters
	 * @param customparameters (Map<StringString>): customparameters
	 * @return boolean: Return description
	 */
	private boolean checkParametersforredirection(Map<String, String> urlParameters, Map<String, String> customparameters){
		List<String> booleanCheckList = new List<String>();
		Boolean paramCheck;
		if (urlParameters.size() > 0 && customparameters.size() > 0){
			for (String param : customparameters.keyset()){
				system.debug(LoggingLevel.DEBUG, 'param inside loop-->' + param);
				if (urlParameters.containsKey(param)){
					system.debug(LoggingLevel.DEBUG, urlParameters.containsKey(param));
					booleanCheckList.add(param);
				}


			}
			if (booleanCheckList.size() > 0){
				paramCheck = true;
			} else{
				paramCheck = false;
			}

		}
		system.debug(LoggingLevel.DEBUG, 'paramCheck-->' + paramCheck);
		return paramCheck;
	}

	/**
	 * @description redirectTEPage description
	 *
	 * @param  contactId (String): contactId
	 * @param  opptyId (String): opptyId
	 * @param  stratid (String): stratid
	 * @return pageReference: Return description
	 */
	public pageReference redirectTEPage(String contactId, String opptyId, String stratid){
		PageReference oPage;
		String destURL = '/apex/LCRMTrainingEventCreation';
		if (contactId != null){
			accountId = [SELECT AccountId
			             FROM Contact
			             WHERE id = :contactId].accountId;
			oPage = new PageReference(destURL + '?AccId=' + accountId + '&ConId=' + contactId);
		} else if (opptyId != null){
			accountId = [SELECT AccountId
			             FROM Opportunity
			             WHERE id = :opptyId].accountId;
			oPage = new PageReference(destURL + '?AccId=' + accountId + '&OppId=' + opptyId);
		} else if (stratid != null){
			accountId = [SELECT Account__c
			             FROM SFDC_Strategy__c
			             WHERE id = :stratid].Account__c;
			oPage = new PageReference(destURL + '?AccId=' + accountId + '&strategyId=' + stratid);
		}


		return oPage;
	}
}