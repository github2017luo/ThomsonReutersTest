/**
*   {Purpose} - Test Class for GLILeadStatusMassUpdateController.
*
*   CHANGE HISTORY
*   =============================================================================
*   Date        Name                Description
*   20180918    Jason Flippen       Created
*   =============================================================================
**/
/**
     * @description  GLILeadStatusMassUpdateControllerTest
     */
@isTest
private class GLILeadStatusMassUpdateControllerTest {

    /**
    *   {Purpose} - Method to test non-error functionality in
    *               GLILeadStatusMassUpdateController class.
    *
    *   CHANGE HISTORY
    *   =============================================================================
    *   Date        Name                Description
    *   20180918    Jason Flippen       Created
    *   =============================================================================
    **/
    /**
     * @description  testController_Positive
     */
    private static testMethod void testControllerPositive() {
        
        Id gliLeadRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'GLI'].Id;
        
        List<Lead> testLeadList = new List<Lead>();
        Lead testLead = new Lead(RecordTypeId = gliLeadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked');
        insert testLead;
        testLeadList.add(testLead);
        
        Test.startTest();
        
        ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(testLeadList);
        standardSetController.setSelected(testLeadList);
        GLILeadStatusMassUpdateController controller = new GLILeadStatusMassUpdateController(standardSetController);
        
        controller.Cancel();
        controller.LeadUpdate.Status = 'Disqualified';
        controller.LeadUpdate.TRWayLeadMgmt__Panorama_DQ_Reason__c = 'Competitor';
        controller.LeadUpdate.Disqualification_Justification__c = 'Competitor';
        controller.LeadUpdate.TRWayLeadMgmt__Panorama_Competitor__c = 'Google';
        controller.Save();
        
        Test.stopTest();
        
        Lead updatedLead = [SELECT Id, Status FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, updatedLead.Status == 'Disqualified','lead status is disqualified');
        
    } // End Method: testController_Positive()
    
    /**
    *   {Purpose} - Method to test error functionality in
    *               GLILeadStatusMassUpdateController class.
    *
    *   CHANGE HISTORY
    *   =============================================================================
    *   Date        Name                Description
    *   20180924    Jason Flippen       Created
    *   =============================================================================
    **/
    /**
     * @description  testController_Negative
     */
    private static testMethod void testControllerNegative() {
        
        Id gliLeadRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'GLI'].Id;
        
        List<Lead> testLeadList = new List<Lead>();
        Lead testLead = new Lead(RecordTypeId = gliLeadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked');
        insert testLead;
        testLeadList.add(testLead);
        
        Test.startTest();
        
        ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(testLeadList);
        standardSetController.setSelected(testLeadList);
        GLILeadStatusMassUpdateController controller = new GLILeadStatusMassUpdateController(standardSetController);
        
        controller.LeadUpdate.Status = 'Disqualified';
        try {
            controller.Save();
        }
        catch(Exception ex) {
            String errorMessage = ex.getMessage();
            System.assertEquals(true,errorMessage.contains(Label.GLILeadStatusMassUpdate_Page_Save_Error_Msg),'error message');
        }
        
        Test.stopTest();
        
    } // End Method: testController_Negative()
    
}