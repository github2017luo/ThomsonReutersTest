/**
* @description       : This wrapper class help to store Trail Contact Records and display in lightning datatable LWC
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public Class TrialContactWrapper{

    /**
    * @description email
    */
    @AuraEnabled public String email;
    
    /**
    * @description firstName
    */
    @AuraEnabled public String firstName;
    
    /**
    * @description lastName
    */
    @AuraEnabled public String lastName;
    
    /**
    * @description onlineContact
    */
    @AuraEnabled public Boolean onlineContact;
    
    /**
    * @description contactId
    */
    @AuraEnabled public Id contactId;
    
    /**
    * @description fullName
    */
    @AuraEnabled public String fullName;
    
    /**
    * @description isPrimaySelectedFromUI
    */
    @AuraEnabled public Boolean isPrimaySelectedFromUI;
    
    //below are for exiting record
    /**
    * @description trialContRecordId
    */
    @AuraEnabled public string trialContRecordId;
    
    /**
    * @description trialId
    */
    @AuraEnabled public string trialId;
    
    /**
    * @description requestType
    */
    @AuraEnabled public String requestType;
    
    //Use in Trial Console GSI Contact table
    /**
    * @description gsiPrimaryFlag
    */
    @AuraEnabled public Boolean gsiPrimaryFlag;
    
    /**
    * @description onlineContactDesignation
    */
    @AuraEnabled public Boolean onlineContactDesignation;
    
    //below fields for Online Contact table
    /**
    * @description oLCStatus
    */
    @AuraEnabled public string oLCStatus;
    
    /**
    * @description olconepass response store
    */
    @AuraEnabled 
    public TrialOLCOnePassByEmailRespWrap olcOnePass;
    
    /**
    * @description trial Status
    */
    @AuraEnabled 
    public String trialStatus;
    
    
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