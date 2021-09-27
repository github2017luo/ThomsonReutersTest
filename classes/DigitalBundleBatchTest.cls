/**
 * This test class is used to test the DigitalBundleBatch
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-07-22   Brenda Shields          DLT-20324 - Fix Initial query time out - updated for code coverage 
 * =============================================================================
 */
/** 
 * @description : Test Class for DigitalBundleBatch
 */ 
@isTest
public class DigitalBundleBatchTest{

    @testSetup 
    static void setupData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();    
        Test.stopTest();
        
        // Get SSD
        Source_System_Detail__c oSSDAccount = [Select id from Source_System_Detail__c limit 1];
         
		// update cart
        Apttus_Proposal__Proposal__c oQuote = [Select id from Apttus_Proposal__Proposal__c limit 1];
        oQuote.APTS_SSD_Sold_To__c = oSSDAccount.Id;
        update oQuote;
        
        // create a matching Digital Subscription record
        Product_Account_Detail__c prodAcctDetail = DCTestData.createDigitalSubscriptions('42072689','42072690', 'Plus', '1004284494', System.Today()+30, '00196KK');
        prodAcctDetail.Current_Subscription__c = '41010973';
        prodAcctDetail.AccountSSD__c = oSSDAccount.Id;
        update prodAcctDetail;
        
    }
    
    private static testMethod void bundleBatchTest(){
    
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        for(Apttus_Config2__ProductConfiguration__c cart : [SELECT id, Digital_Pending_Cart__c 
                                                            FROM Apttus_Config2__ProductConfiguration__c]){
            cart.Digital_Pending_Cart__c = TRUE;
            cartList.add(cart);
        }
        update cartList;
        Test.startTest();
        Database.executeBatch(new DigitalBundleBatch());
        System.assert(cartList[0].Digital_Pending_Cart__c == TRUE, 'Cart not updated');
        Test.stopTest();
    }


}