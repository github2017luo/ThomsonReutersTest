/**
* Test class for CustomerReviewPostback.cls
*
* @author  Nandita Shet
* @version 2013-03-06
*/
/**
* CHANGE HISTORY
* =======================================================================
* Date           Name                 Description
* 2013-03-06     Nandita Shet         Created
* =======================================================================
*/

@IsTest

public class CreateCustomerReviewPostback_test{
    
    public static testMethod void handleCustomerReviewPostbackTestmethod(){
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '7683';
        insert testAcc;
        
        Account testAcc_Org = UnitTest.getAccountInstance();
        testAcc_Org.SAPAccountNumber__c = '7682';
        insert testAcc_Org;
        
        
        CreateCustomerReviewPostback.CustomerReviewPostbackRequest oRequest = new CreateCustomerReviewPostback.CustomerReviewPostbackRequest();
        CreateCustomerReviewPostback.CustomerReviewPostbackResponse oResponse = new CreateCustomerReviewPostback.CustomerReviewPostbackResponse();
        CreateCustomerReviewPostback.CustomerReviewPostbackResponse oResponse1 = new CreateCustomerReviewPostback.CustomerReviewPostbackResponse();
       
        // Test Case 1 : ExternalAccountId is null 
        oRequest.CreatedCustomerNumber= '7683';
        oRequest.AlternateCustomerNumber= '7682';
        oRequest.ExternalAccountId = null;
        oResponse = CreateCustomerReviewPostback.handleCustomerReviewPostback(oRequest);
        System.AssertEquals(oResponse.bSuccess,false,'Error :'+oResponse.sError);
        System.AssertEquals(oResponse.sError,'externalAccountId is null','Error :'+oResponse.sError);
        
        
        // Test Case 2 : CreatedCustomerNumberis null 
        oRequest.CreatedCustomerNumber= null;
        oRequest.AlternateCustomerNumber= '7682';
        oRequest.ExternalAccountId = testAcc.Id;
        oResponse = CreateCustomerReviewPostback.handleCustomerReviewPostback(oRequest);
        System.AssertEquals(oResponse.bSuccess,false,'Error :'+oResponse.sError);
        System.AssertEquals(oResponse.sError,'createdCustomerNumber is null','Error :'+oResponse.sError);
       
       
        // Test Case 3 : AlternateCustomerNumberis null (No duplicate Account created)
        oRequest.CreatedCustomerNumber= '7683';
        oRequest.AlternateCustomerNumber= null;
        oRequest.ExternalAccountId = testAcc.Id;
        oResponse = CreateCustomerReviewPostback.handleCustomerReviewPostback(oRequest);
        System.AssertEquals(oResponse.bSuccess,true,'Error :'+oResponse.sError);
       
        // Test Case 4 : Duplicate Account created is merged with Original Account
        oRequest.CreatedCustomerNumber= '7683';
        oRequest.AlternateCustomerNumber= '7682';
        oRequest.ExternalAccountId = testAcc.Id;
        
        oResponse1 = CreateCustomerReviewPostback.handleCustomerReviewPostback(oRequest);
        System.AssertEquals(oResponse1.bSuccess,true,'Error :'+oResponse.sError);
    }


}