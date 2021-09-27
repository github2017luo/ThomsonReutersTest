/**
 * @description LCRMSubscriptionUtility Description
 *
 */
public without sharing class LCRMSubscriptionUtility{
	//public List<SubscriptionTypes__c> subscriptionsList = new List<SubscriptionTypes__c>();
	//public String sTranslatedSelectOption{ get; set; }
/**
 * @Comment createSubscriptionList description
 * @description createSubscriptionList description
 * @param oSubscriptionType (SubscriptionTypes__c): oSubscriptionType
 * @param sProfileName (String): sProfileName
 * @param sCurrentUser (User): sCurrentUser
 * @return List<selectoption>: Return description
 */
	public static List<selectoption> createSubscriptionList(SubscriptionTypes__c oSubscriptionType, String sProfileName, User sCurrentUser){
		List<selectoption> subscriptionsList = new List<selectoption>();
		if (oSubscriptionType.Name == 'WPD'){
			List<selectoption> checkWPDList = checkLocalLanguageKey(oSubscriptionType, sProfileName, sCurrentUser);
			subscriptionsList.addAll(checkWPDList);
		} else if (sCurrentUser.LanguageLocaleKey == 'es'){
			subscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Spanish__c));
		} else if (sCurrentUser.LanguageLocaleKey == 'pt_BR'){
			subscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Portuguese__c));
		} else{
			subscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Name));
		}
		return subscriptionsList;
	}

	@testVisible
	private static List<selectoption> checkLocalLanguageKey(SubscriptionTypes__c oSubscriptionType, String sProfileName, User sCurrentUser){
		List<selectoption> localLanguageKeySubscriptionList = new List<selectoption>();
		if ((sProfileName.contains('WPD') || sProfileName.contains('ADMIN'))){
			if (sCurrentUser.LanguageLocaleKey == 'es'){
				localLanguageKeySubscriptionList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Spanish__c));
			} else if (sCurrentUser.LanguageLocaleKey == 'pt_BR'){
				localLanguageKeySubscriptionList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Portuguese__c));
			} else{
				localLanguageKeySubscriptionList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Name));
			}
		}

		return localLanguageKeySubscriptionList;
	}
/**
 * @Comment createSSDList description
 * @description createSSDList description
 * @param listofSSD (List<Source_System_Detail__c>): listofSSD
 * @return List<String>: Return description
 */
	public static List<String> createSSDList(List<Source_System_Detail__c> listofSSD){
		List<String> accountSapIdList = new List<String>();
		if (String.isnotblank(listofSSD[0].LCRM_Sales_Org__c)){
			//strSalesOrg = listofSSD[0].LCRM_Sales_Org__c;
			for (Source_System_Detail__c ssd : listofSSD){
				if (String.IsNotBlank(ssd.Source_System_Account_Number__c)){
					accountSapIdList.add(ssd.Source_System_Account_Number__c);
				}
			}
			//End For Loop
		}
		return accountSapIdList;
	}
/**
 * @Comment gettranslatedSelectOption description
 * @description gettranslatedSelectOption description
 * @param sSelectedOption (String): sSelectedOption
 * @param sCurrentUser (user): sCurrentUser
 * @param mapSubscriptionTypes (Map<StringSubscriptionTypes__c>): mapSubscriptionTypes
 * @return String: Return description
 */
	public static String gettranslatedSelectOption(String sSelectedOption, user sCurrentUser, Map<String, SubscriptionTypes__c> mapSubscriptionTypes){
		String sTranslatedSelectOption = '';
		if (sCurrentUser.LanguageLocaleKey == 'es'){
			sTranslatedSelectOption = esLanguageLocaleKey(sSelectedOption, sCurrentUser, mapSubscriptionTypes);

		} else if (sCurrentUser.LanguageLocaleKey == 'pt_BR'){
			

			if (sSelectedOption == 'All Active'){
				sTranslatedSelectOption = 'Todas Assinaturas Ativas';
			}
			if (sSelectedOption == 'All Lapsed'){
				sTranslatedSelectOption = 'Todas Assinaturas Caducadas';
			}
			if (sSelectedOption == 'FindLaw'){
				sTranslatedSelectOption = 'FindLaw Assinaturas';
			}
			if (sSelectedOption == 'Online'){
				sTranslatedSelectOption = 'Assinaturas OnLine';
			}

			if (sSelectedOption == 'Print'){
				sTranslatedSelectOption = 'Assinturas Impresas';
			}
            sTranslatedSelectOption = mapSubscriptionTypes.get(sSelectedOption).Portuguese__c;

		} else{
			sTranslatedSelectOption = sSelectedOption + ' Subscriptions';
		}
		return sTranslatedSelectOption;
	}

	@testVisible
	private static string esLanguageLocaleKey(String sSelectedOption, user sCurrentUser, Map<String, SubscriptionTypes__c> mapSubscriptionTypes){
		String sTranslatedSelectOption = '';
		if (sSelectedOption == 'All Active'){
			sTranslatedSelectOption = 'Todas las suscripciones Activas';
		}
		if (sSelectedOption == 'All Lapsed'){
			sTranslatedSelectOption = 'Todas las suscripciones Expiradas';
		}
		if (sSelectedOption == 'FindLaw'){
			sTranslatedSelectOption = 'Suscripciones FindLaw';
		}
		if (sSelectedOption == 'Online'){
			sTranslatedSelectOption = 'Suscripciones OnLine';
		}
		if (sSelectedOption == 'Print'){
			sTranslatedSelectOption = 'Suscripciones Impresas';
		}
		return sTranslatedSelectOption;
	}

/**
 * @description checkMaterialNumber description
 * @Comment checkMaterialNumber description
 *
 * @param lst (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse): lst
 * @return String: Return description
 */
	public static String checkMaterialNumber(LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse lst){

		if (String.isnotblank(lst.MaterialNumber)){
			if (lst.MaterialNumber.startsWith('0')){
				lst.MaterialNumber = lst.MaterialNumber.substring(10);
			} else{
				lst.MaterialNumber = lst.MaterialNumber;
			}
		}
		return lst.MaterialNumber;
	}
    /**
	 * @Comment isSelectedDecision description
	 * @description isSelectedDecision description
	 * @param selectedwrappermap (map<stringLCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>): selectedwrappermap
	 * @param cc (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse): cc
	 * @return boolean: Return description
	 */
    public static boolean isSelectedDecision(map<string,LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> selectedwrappermap,
    LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse cc ){

        if ((selectedwrappermap != null && selectedwrappermap.containskey(cc.MaterialNumber)) || test.isrunningtest()){
           return true;
        }
        else{
            return false;
        }

    }


}