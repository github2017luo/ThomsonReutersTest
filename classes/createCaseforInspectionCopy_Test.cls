/**
 * Validates the functionality provided by the AccountAddressController class.
 *
 * @author  Srikanth Kuruva
 * @version  2012-07-27
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-15   Sriaknth Kuruva        Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class createCaseforInspectionCopy_Test 
{
    public static testMethod void testCasecreationforInspectionCopy()
    {
        createCaseforInspectionCopy testCreateCaseforInspectionCopy = new createCaseforInspectionCopy();
        
    
        Test.startTest();
        
        Account oTestAccount = UnitTest.getAccountInstance();
        insert oTestAccount;
        
        Contact oTestContact = UnitTest.getContactInstance(oTestAccount.Id);
        insert oTestContact;
        
        
        
        Course__c oTestCourse = new Course__c();
        oTestCourse.Account_Name__c = oTestAccount.Id;
        oTestCourse.Contact_Name__c = oTestContact.Id;
        oTestCourse.Course_Name__c = 'Constitutional law';
        oTestCourse.Course_Code__c = '001';
        oTestCourse.Competitor__c = 'Other';
        oTestCourse.Competitor_Text__c = 'Test123';
        oTestCourse.Semester__c = 'Other';
        oTestCourse.Type__c = 'Academic';
        oTestCourse.Number_of_Students__c = 65;
        oTestCourse.Comments__c = 'Comments';
        insert oTestCourse;
        
        Opportunitylineitem oOpportunityLineItem = new Opportunitylineitem();
        
        
        Opportunity oTestOpportunity = UnitTest.getOpportunityInstance(oTestAccount.Id);
        oTestOpportunity.Request_Inspection_Copy__c = true;
        oTestOpportunity.Product_Participation__c = oTestCourse.Id;
       // oTestOpportunity.Product_Participation__r.Course_Name__c = 'test';
        insert oTestOpportunity;
        
        oTestOpportunity.Request_Inspection_Copy__c = false;
        update oTestOpportunity;
        
        oTestOpportunity.Request_Inspection_Copy__c = true;
        update oTestOpportunity;
 
        Test.stopTest();
        
        
        
    }
}