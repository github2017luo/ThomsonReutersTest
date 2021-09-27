/**
* @description       : OmniOnePassResponseGenereicWrapper 
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public class OmniOnePassResponseGenereicWrapper {

    /**           * @description */         
    public class Criteria {
        /**           * @description */         
        @AuraEnabled public String emailAddress;
        /**           * @description */         
        @AuraEnabled public String firstName;
        /**           * @description */         
        @AuraEnabled public String identifier;
        /**           * @description */         
        @AuraEnabled public String lastName;
        /**           * @description */         
        @AuraEnabled public String productCode;
        /**           * @description */         
        @AuraEnabled public String registrationKey;
        /**           * @description */         
        @AuraEnabled public String username;
    }
     /**           * @description */         
    public class Trace {
        /**           * @description */         
        @AuraEnabled public String executionType;
        /**           * @description */         
        @AuraEnabled public String parentGuid;
        /**           * @description */         
        @AuraEnabled public String product;
        /**           * @description */         
        @AuraEnabled public String rootGuid;
        /**           * @description */         
        @AuraEnabled public String serverInformation;
        /**           * @description */         
        @AuraEnabled public String sessionGuid;
        /**           * @description */         
        @AuraEnabled public String transactionGuid;
        /**           * @description */         
        @AuraEnabled public String userGuid;
    }
    /**           * @description */         
    public class Header {
        /**           * @description */         
        @AuraEnabled public String authenticationToken;
        /**           * @description */         
        @AuraEnabled public String contextualInformation;
        /**           * @description */         
       // @AuraEnabled public String productIdentifier;
        /**           * @description */         
        //@AuraEnabled public String sessionToken;
        /**           * @description */         
        //@AuraEnabled public String slideInformation;
        /**           * @description */         
        //@AuraEnabled public String userHostIpAddress;
        /**           * @description */        
        //@AuraEnabled public String version;
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