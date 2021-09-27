/**
 * @Comment LCRMSubscriptiondisplayInfoUtility Description
 * @description LCRMSubscriptiondisplayInfoUtility
 *
 */
public without sharing class LCRMSubscriptiondisplayInfoUtility {

    /**
 * @Comment getSubtypes description
 * @description getSubtypes description
 * @param sSelectedOption (String): sSelectedOption
 * @return String: Return description
 */
	public static String getSubtypes(String sSelectedOption){
		String subType = '';
		if (sSelectedOption == 'ALL Lapsed'){
			subType = 'ALL';
		}
		if (sSelectedOption == 'All Active'){
			subType = 'ALL';
		}
		if (sSelectedOption == 'Online'){
			subType = 'ONLINE';
		}
		if (sSelectedOption == 'FindLaw'){
			subType = 'FINDLAW';
		}
		if (sSelectedOption == 'Print'){
			subType = 'PRINT';
		}
		if (sSelectedOption == 'WPD'){
			subType = 'WPD';
		}
		return subType;
	}
    /**
     *  @Comment getIncludeActiveTab description
     *  @description getIncludeActiveTab description
     * @param sSelectedOption (String): sSelectedOption
     * @return boolean: sortCheck
     */
	public static String getIncludeActiveTab(String sSelectedOption){
		String includeActiveSubs = '';
		if (sSelectedOption == 'ALL Lapsed'){
			includeActiveSubs = 'false';
		}
		if (sSelectedOption == 'All Active'){
			includeActiveSubs = 'true';
		}
		return includeActiveSubs;

	}
    /**
     * @Comment getincludeLapsedSubs description
     * @description getincludeLapsedSubs
     * @param sSelectedOption (String): sSelectedOption
     * @return String: Return description
     */
	public static String getincludeLapsedSubs(String sSelectedOption){
		String includeLapsedSubs = '';
		if (sSelectedOption == 'ALL Lapsed'){
			includeLapsedSubs = 'true';
		}
		if (sSelectedOption == 'All Active'){
			includeLapsedSubs = 'false';
		}
		return includeLapsedSubs;
	}
    /**
     * @Comment sSelectedOptionForSort description
     * @description
     * @param sSelectedOption (String): sSelectedOption
     * @return boolean: Return description
     */
	public static boolean sSelectedOptionForSort(String sSelectedOption){
        boolean sortCheck = false;
        if ((sSelectedOption == 'ALL Active' || sSelectedOption == 'ALL Lapsed') || (sSelectedOption == 'WPD' || sSelectedOption == 'Online' || sSelectedOption == 'Print' || sSelectedOption == 'Findlaw')){
            sortCheck = true;
        }
        return sortCheck;


	}
/**
 * @Comment getAccountList description
 * @description getAccountList description
 * @param accountSapIdList (List<String>): accountSapIdList
 * @return List<LCRMsubscriptionsJsonWrapper.Accountcls>: Return description
 */
    public static 	List<LCRMsubscriptionsJsonWrapper.Accountcls> getAccountList(List<String> accountSapIdList) {
        List<LCRMsubscriptionsJsonWrapper.Accountcls> accountlst = new List<LCRMsubscriptionsJsonWrapper.Accountcls>();
        for (String accsap : accountSapIdList){
            LCRMsubscriptionsJsonWrapper.Accountcls accountRe = new LCRMsubscriptionsJsonWrapper.Accountcls();
            accountRe.accountNumber = accsap;
            accountlst.add(accountRe);
        }
        return accountlst;
    }
}