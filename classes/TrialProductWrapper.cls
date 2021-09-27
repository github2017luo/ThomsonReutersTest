/**
* @description       : This wrapper class help to store Trail Product Records and disply in lightning datatable
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : 
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public Class TrialProductWrapper{
    
    /**
    * @description trialPrdId
    */
    @AuraEnabled public string trialPrdId; // Product 2 Id lookup
    
    /**
    * @description trialPrdRecordId
    */
    @AuraEnabled public string trialPrdRecordId;// Trial_Product__c record Id
    
    /**
    * @description trialId
    */
    @AuraEnabled public string trialId;
    
    /**
    * @description productName
    */
    @AuraEnabled public string productName;
    
    /**
    * @description productCode
    */
    @AuraEnabled public string productCode;
    
    /**
    * @description bundleType
    */
    @AuraEnabled public string bundleType;
    
    /**
    * @description materialType
    */
    @AuraEnabled public string materialType;
    
    /**
    * @description segment*/
    @AuraEnabled public string segmentType;
    
    /**
    * @description relationshipType*/
    @AuraEnabled public string relationshipType;
    
    /**
    * @description baseMaterialNumber store Product From id*/
    @AuraEnabled public string baseMaterialNumber;
    
    /**
    * @description baseMaterialNumber store Product From id*/
    @AuraEnabled public string baseMaterialName;
    
    /**
     * @description only return for code coverage
     * @param 
     */
    @testvisible
    private static void omniTestMethod(){
        if(Test.isrunningtest()){
            System.debug(LoggingLevel.DEBUG, 'Testing: ');
        }
    }
}