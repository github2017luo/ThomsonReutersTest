/**
 * trac_User
 * @description trigger to update language on user object
 *
 * @author Rauza Zhenissova, Traction on Demand
 * @date 06-01-2015
 */

trigger trac_User on User (before insert, before update) {
    //DPS-1650: Added asa part of Exclusion framework 
    System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
    If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){ return;}
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        trac_UserHelper.updateLanguage(trigger.new);
    }

}