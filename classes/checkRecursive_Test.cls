@IsTest
public class checkRecursive_Test {

    public static testMethod void CheckRecursion() {
   
        checkRecursive.runOnce();
        checkRecursive.runTaskTriggerOnce();
        checkRecursive.runUserTriggerOnce();
        checkRecursive.hasAlreadyRunBeforeUpdateQuote();
        checkRecursive.setAlreadyRunBeforeUpdateQuote();
        checkRecursive.runQuoteTriggerOnce(); 
        checkRecursive.runQuoteTrigger();
        checkRecursive.runOpptyLockOnce();
        checkRecursive.runOpptySyncOnce();
        checkRecursive.runEventTriggerOnce(); //Added for CRM-7710
        checkRecursive.runRenewalOpptySyncOnce();
        checkRecursive.runoptycontactroleonce();
        checkRecursive.runRenewalQLISyncOnce();
        checkRecursive.runRenewalOLISyncOnce();
        checkRecursive.runRenewalQuoteSyncOnce();
        checkRecursive.runOpptyBeforeListnerOnce();
        checkRecursive.hasAlreadyRunBeforeUpdateOppLI();
        checkRecursive.setAlreadyRunBeforeUpdateOppLI();
        checkRecursive.runFirstTime();
        checkRecursive.runpropsaltrgr_Digital_SecondaryQuoteExpirationOnce();
        checkRecursive.runpropsaltrgr_updateTmpOrderConfirmationContactOnce();
        checkRecursive.runpropsaltrgr_createOrderAndAssetLineItemsOnce();
        checkRecursive.hasRunVerifyEmailAndPhone();
        checkRecursive.runAutoPayment_Update_TriggerOnce();
        checkRecursive.runpropsaltrgr_updatePriceListOnce();
        checkRecursive.runAcvProductLogicOnce();
        checkRecursive.runpropsaltrgr_updateOpportunityStageOnce();
        checkRecursive.runpropsaltrgr_updateApprovalSegmentOnce();
        checkRecursive.runpropsaltrgr_updateAddressFeildsOnce();
        checkRecursive.runpropsaltrgr_propsaltrgr_updatebilltoshiptoOnce();
        checkRecursive.runupdateOppTerritory();
        checkRecursive.runsyncOppTeamToOppTeamClone();
        checkRecursive.lCRMRecursivecheck_Account();
        checkRecursive.lCRMRecursivecheck_Contact();
        checkRecursive.lCRMRecursivecheck_Lead();
        checkRecursive.lcrmRecursivecheckflag_Account = false;
        checkRecursive.lcrmRecursivecheckflag_Account = false;
        checkRecursive.lcrmRecursivecheckflag_Account = false;
        checkRecursive.lCRMRecursivecheck_Account();
        checkRecursive.lCRMRecursivecheck_Contact();
        checkRecursive.lCRMRecursivecheck_Lead();
        checkRecursive.runForApproval();
        checkRecursive.runLineItemCalIncrementalMethflagOnce();
        checkRecursive.runAfterUpdateOnce();
		checkRecursive.runUpdateProposalFromOrderOnce();
    }
}