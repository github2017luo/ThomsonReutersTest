/********************************************************************************
Class Name : DCPSSD 
@description : SSD data layer class 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                        Developer                       Description
30-04-21                  Vishnu Santhosh               Initial Creation
25-06-21                  Vishnu Santhosh               DCP 2212 | Added 'Digital firm' field - getSSD method
13-09-21                  Benjamin Her                  DCP-5114 Update logic for minimum number of attorney
*/ 

public without sharing class DCPSSD {
   
    /**
        @description Stores the queried accounts
     */
    public static List<Source_System_Detail__c> ssdList;

    /**
    @description Run queries on Source System Detail Object
    @param ssdId ssdIds to query    
    @return Returns the queried ssds
    */
    public static List<Source_System_Detail__c> getSSD(List<Id> ssdId){
        ssdList = [ SELECT Id, Name, Account_Name__c, Source_System_Account_Number__c,County__c, Number_Street__c, City__c, 
                    State__c,LCRM_PO_Box__c, Postal_Code__c, Country__c, Digital_Firm__c, LCRM_APTS_Band_Number__c,
                    (SELECT id,Apttus_Config2__Quantity__c FROM Asset_Line_Items1__r 
                    WHERE Apttus_Config2__AssetStatus__c = 'Activated')
                    FROM Source_System_Detail__c
                    WHERE Id IN : ssdId
                    WITH SECURITY_ENFORCED];
        return ssdList;
    } 

    
}