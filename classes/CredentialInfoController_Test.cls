/**
======================================================================================================================
TEST CLASS NAME: CredentialInfoController_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the CredentialInfoController class.
 
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-05  Zahedul hossain          Created  
 * 2017-03-31  Karthi                   Optimized the coverage as per JIRA STORY: PS0-1
 * =============================================================================
 */
 
@IsTest //(seeAllData=true)

private class CredentialInfoController_Test{
 
    public static testMethod void testCredentialInfoController() {
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1234';
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;
        
        
         IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
         testIXOSCodeMap.Company_Code__c = '0010';
         testIXOSCodeMap.Dist_Chan_Code__c= 'W';
         testIXOSCodeMap.Division_Code__c = 'W';
         testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
         testIXOSCodeMap.Name = 'CredTest';
         insert testIXOSCodeMap;
         
         
         
         
        Test.starttest();
        Test.setCurrentPageReference(Page.CredentialInfo);
              
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        CredentialInfoController  oCredentialInfoController  = new CredentialInfoController(sc);
        oCredentialInfoController.getDomainListOptions();
        
        oCredentialInfoController.sSelectedOption = 'CLEAR';
        oCredentialInfoController.displayCredInfoList();
        
        
       
        
        Test.stoptest();
    }
    
    
          
}