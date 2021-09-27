/*
 * CHANGE HISTORY
 * 
 *==================================================================================================================================
 * Date         Name                    Description
 * 2018-07-02   Navleen Kaur          DLT-10836 - Fix test class failure "DCConfiguratorUtil_Test".
 * 2018-07-02   Brenda Shields        DLT-10717 - Remove obsolete items - removing call to update Product Xref records - DCConfiguratorUtil.updateDBCategories
 * 2019-06-12   Pavithra              DLT-16789 : [Tech Story] [Code Scan] - Fix code scan MAJOR issues in this DCConfiguratorControllerV2_Test,DCConfiguratorImplServiceV2 and DCConfiguratorUtil_Test.cls
 * 2019-06-28   Srikanth Kota         DLT-16917 : [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCCartServiceV2, DCConfigdetails 
 * 2019-09-04   Pavithra              DLT-16927 : [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCConfiguratorImplServiceV2, DCConfiguratorUtil_Test, DCDocuSignController  
 * ==================================================================================================================================   
 */
@isTest
private class DCConfiguratorUtil_Test {
    @testSetup static void createData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote(); 
        Test.stopTest();
        Product2 prod2 = [Select ID ,Productcode,Subscription_Number__c from Product2 limit 1];

    }
    
    static testMethod void synchronizeCartTest() {
        Test.startTest(); 
        Apttus_Proposal__Proposal__c quote =  [Select ID from Apttus_Proposal__Proposal__c limit 1];
        DCConfiguratorUtil.synchronizeCart(quote.Id);
        test.stopTest();
        system.assert(quote!=null);
    }
    
    static testMethod void synchronizeCartTest1() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new DCConfiguratorMockHttpLoginTest());
        List<DC_Global_Settings__mdt> globalSettingList = [SELECT    Login_Domain__c,Username__c, Password__c, Security_Token__c, Request_Timeout__c,Use_API_User__c FROM    DC_Global_Settings__mdt LIMIT    1];
        Apttus_Proposal__Proposal__c quote =  [Select ID from Apttus_Proposal__Proposal__c limit 1];
        DCConfiguratorUtil.synchronizeCartAsAPIUser(quote.Id,globalSettingList[0]);
        Test.stopTest(); 
        system.assert(quote!=null);
    }
    
    // this method is obsolete
    //static testMethod void updateDBCategoriesTest() {
        //Test.startTest();
        //Apttus_Proposal__Proposal__c quote =  [Select ID from Apttus_Proposal__Proposal__c limit 1];
        //DCConfiguratorUtil.updateDBCategories(quote.Id);
        //Test.stopTest();
    //}
}