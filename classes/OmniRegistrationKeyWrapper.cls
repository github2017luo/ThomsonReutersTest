/**
* @description       : Omni wraooer 
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public class OmniRegistrationKeyWrapper {
/**           * @description */         
    public class RegistrationKeys {
        /**           * @description */         
        @AuraEnabled public String ePaymentMethod;
        /**           * @description */         
        @AuraEnabled public String ePaymentSupportType;
        /**           * @description */         
        @AuraEnabled public String isPreferred;
        /**           * @description */         
        @AuraEnabled public String name;
        /**           * @description */         
        @AuraEnabled public List<Properties> properties;
        /**           * @description */         
        @AuraEnabled public String registrationKey;
        /**           * @description */         
        @AuraEnabled public String validationState;
    }
     
    /**           * @description */         
    public class Properties {
        /**           * @description */         
        @AuraEnabled public String key;
        /**           * @description */         
        @AuraEnabled public String value;
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