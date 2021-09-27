/*
===============================================================================
 $AddressCleanseController_Test$
===============================================================================

PURPOSE:            Contains all the testMethods for AddressCleanseController.cls

FUNCTIONALITY:  

COMMENTS:       
CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2011-06-23      Nick Cook               Created
===============================================================================
*/
@isTest
private class AddressCleanseController_Test {

    static testMethod void CoverFunction()
    {   
        Account Acc = UnitTest.getAccountInstance();
        Acc.BillingStreet = '18321 kerrville';
        Acc.BillingCity = 'lakeville';
        Acc.BillingState = 'MN';
        Acc.BillingCountry = 'US';
        Acc.BillingPostalCode = '55044';
        insert Acc; 
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accid',Acc.Id);
        ApexPages.standardController sController = new ApexPages.standardController(Acc);
        AddressCleanseController oAddressCleanseController = new AddressCleanseController(sController); 
    
        
        PageReference cancel =  oAddressCleanseController.cancel();
        PageReference edit =  oAddressCleanseController.edit();
        PageReference savewidoutCleanse =  oAddressCleanseController.savewithoutCleanse();
        PageReference save= oAddressCleanseController.save();
        Test.stopTest();
    } 
}