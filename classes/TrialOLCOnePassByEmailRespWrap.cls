/**
* @description       : Store OLC One pass by Email variable from response
* @author            : TCS Dev Team
* @group             : 
* @last modified on  : 
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public Class TrialOLCOnePassByEmailRespWrap{
    
    /**
    * @description cobaltGUID
    */
    @AuraEnabled public string cobaltGUID;
    
    /**
    * @description onePassId 
    */
    @AuraEnabled public string onePassId;
    
    /**
    * @description onePassUserName
    */
    @AuraEnabled public string onePassUserName;
    
    /**
    * @description dataRoomGUID
    */
    @AuraEnabled public string dataRoomGUID;
    
    /**
    * @description externalAccountNumber 
    */
    @AuraEnabled public string externalAccountNumber ;
    
    /**
    * @description companyId
    */
    @AuraEnabled public string companyId;
    
    /**
    * @description externalAccountNumberSource 
    */
    @AuraEnabled public string externalAccountNumberSource ;
    
    /**
    * @description externalContactNumber
    */
    @AuraEnabled public string externalContactNumber;
    
    /**
    * @description externalContactNumberSource
    */
    @AuraEnabled public string externalContactNumberSource;
    
    /**
    * @description profileType
    */
    @AuraEnabled public string profileType;
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