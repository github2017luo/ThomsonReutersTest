/********************************************************************************
Class Name : DCPRenewalAccount
@description : This class is used by DCPGetRenewal class to populate Account JSON Data.
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer                      Description
29-04-2021                  Vishnu Santhosh           DCP-1118 | Initial Creation

*/ 

public without sharing class DCPRenewalAccount {

    /**
    @description Populate the Account Wrapper Details
    @param acc Account Instance containing details to be populated in the response.
    @param ssd Source System Detail Instance containing details to be populated in the response.
    @return Returns the populated Account Wrapper Object
    */
    public static DCPRenewalAccountWrapper populateAccountDetails(Account acc, Source_System_Detail__c ssd){

        DCPRenewalAccountWrapper objAccountWrapper = new DCPRenewalAccountWrapper();
        
        objAccountWrapper.accountId = acc.id;
        objAccountWrapper.ssdId = ssd.Id;
        objAccountWrapper.accountNumber = ssd.Source_System_Account_Number__c;
        objAccountWrapper.accountName = DCPUtility.formatName(ssd.Name,false);

        objAccountWrapper.accountAddress.addressStreet = DCPUtility.formatName(ssd.Number_Street__c,true);
        objAccountWrapper.accountAddress.addressCity = DCPUtility.formatName(ssd.City__c,false);
        objAccountWrapper.accountAddress.addressState = DCPUtility.nullCheck(ssd.State__c);
        objAccountWrapper.accountAddress.addressPostalCode = DCPUtility.nullCheck(ssd.Postal_Code__c);
        objAccountWrapper.accountAddress.addressCounty = DCPUtility.formatName(ssd.County__c,true);
        objAccountWrapper.accountAddress.addressCountry = DCPUtility.nullCheck(ssd.Country__c);
        objAccountWrapper.accountAddress.addressPOBox = DCPUtility.nullCheck(ssd.LCRM_PO_Box__c);
        
        return objAccountWrapper;

    }

    
}