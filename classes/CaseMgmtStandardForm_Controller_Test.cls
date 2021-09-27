@istest
public class CaseMgmtStandardForm_Controller_Test
{
/********************************************************************************************
MethodName: testLogicForCaseMgmtStdForm
Description: Test method to test the logic of 'CaseMgmtStandardForm_Controller' class
CreatedBy: Anshu Thakur 
CreatedDate: 04-Jan-2017
LastModifiedBy: Anshu Thakur 
LastModifiedDate: 04-Jan-2017
Reason for Change:
Revision:
Fixed Defect#:
*********************************************************************************************/
    static testmethod void testLogicForCaseMgmtStdForm()
    {
        String strIssue = 'Administrativa';
        String strReason = 'Modificación de datos';
        String strProduct = 'Proview';
        //List<Case> lstCase = List<Case>();
        
        //Preparing test data for Case : set1
        Case objCase = new Case();
        objCase.CurrencyIsoCode = 'USD';
        objCase.Sales_Org__c = 'LLEY';
        
        //lstCase.add(objCase1);
        
        Test.startTest();
        INSERT objCase;
        System.assertEquals(objCase.Sales_Org__c, 'LLEY');
        Test.stopTest();
    }
}