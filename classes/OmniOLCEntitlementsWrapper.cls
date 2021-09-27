/**
* @description       : OmniOLCEntitlementsWrapper  used in OLC by Email request
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public class OmniOLCEntitlementsWrapper {
    /**
     * @description Entitlements 
     */
    public class Entitlements {
    
        /** * @description applicationId*/
        @AuraEnabled public String applicationId;
        
        /** * @description status*/
        @AuraEnabled public String status;
        
        /** * @description statusReason*/
        @AuraEnabled public String statusReason;
        
        /** * @description appUserGuid*/
        @AuraEnabled public String appUserGuid;
        
        /** * @description accessStartDate*/
        @AuraEnabled public String accessStartDate;
        
        /** * @description accessEndDate*/
        @AuraEnabled public String accessEndDate;
        
        /** * @description registered*/
        @AuraEnabled public Boolean registered;
        
        /** * @description detailsIncomplete*/
        @AuraEnabled public Boolean detailsIncomplete;
        
        /** * @description authFirstName*/
        @AuraEnabled public String authFirstName;
        
        /** * @description authLastName*/
        @AuraEnabled public String authLastName;
        
        /** * @description authEmail*/
        @AuraEnabled public String authEmail;
        
        /** * @description authId */
        @AuraEnabled public String authId;
        
        /** * @description logonName*/
        @AuraEnabled public String logonName;
        
        /** * @description appUserRefId*/
        @AuraEnabled public String appUserRefId;
        //@AuraEnabled public String appUserRefIdNickName;
        //@AuraEnabled public Boolean appUserRefIdPrimary;
        //@AuraEnabled public String lastPasswordChangeDate;
        
        /** * @description authenticationSystem*/
        @AuraEnabled public String authenticationSystem;
    }
    
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