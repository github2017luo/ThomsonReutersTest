/**
 * Validates the functionality provided by the ProductTrialTriggerHandler class.
 *
 * @author  Nandita Shet
 * @version  2012-11-06
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-11-06   Nandita Shet        Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata = true)
private class ProductTrialTriggerHandler_Test {
    public static testmethod void UpdateAccountOnTrial_Test(){
        Account testAccount = UnitTest.getAccountInstance();
        insert testAccount;
        
        Opportunity testOpportunity = UnitTest.getOpportunityInstance(testAccount.Id);
        insert testOpportunity ;
        Contact testContact = UnitTest.getContactInstance(testAccount.Id);
        insert testContact;
        OpportunityContactRole testOpportunityContactRole = new OpportunityContactRole(ContactId=testContact.Id,OpportunityId =testOpportunity.Id,Role='Trial User');
        insert testOpportunityContactRole;
        Product_Trial__c testProductTrial = new Product_Trial__c(Opportunity__c = testOpportunity.Id,Trial_Start_Date__c=System.Today());
        insert testProductTrial;
        update testProductTrial;
        List<Trial_User__c> ListTrialUsers = [Select Product_Trial__c,Contact__c from Trial_User__c where Product_Trial__c =:testProductTrial.Id];
        System.debug(ListTrialUsers.size()+'****testmethod');
    }


}