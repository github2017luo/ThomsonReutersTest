/**
 * Validates the functionality provided by the LeadUpdateController class.
 *
 * @author  Nandita Shet
 * @version 2012-07-11
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-11   Nandita Shet        Created                                                                   
 * =============================================================================
 */
 
@IsTest
private class LeadUpdateController_Test {
  /**
     * Validates controller handling for a null standard controller
     */
    public static testMethod void testLeadUpdateController() {
       
       Lead testLead = unittest.getLeadInstance();
       insert testLead;
      
       ApexPages.standardController sc = new ApexPages.standardController(testLead);
       test.setcurrentPage(page.LeadDiscardReasonUpdate);
       ApexPages.currentPage().getParameters().put('Ids',testLead.id);
       LeadUpdateController oController = new LeadUpdateController(sc);
        oController.getDiscardReasonOptions();
        oController.Save();
        }
    
    }