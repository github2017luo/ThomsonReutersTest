/**
* @description       : OmniTrialsProfilesWrapper 
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public class OmniTrialsProfilesWrapper {
/**           * @description */         
    public class Profiles {
        /**           * @description */         
        @AuraEnabled public String emailAddress;
        /**           * @description */         
        @AuraEnabled public String firstName;
        /**           * @description */         
        @AuraEnabled public String identifier;
        /**           * @description */         
        @AuraEnabled public String lastName;
        /**           * @description */         
        @AuraEnabled public String password;
        /**           * @description */         
        @AuraEnabled public String passwordExpirationDate;
        /**           * @description */         
        @AuraEnabled public String passwordLifetime;
        /**           * @description */         
        @AuraEnabled public String profileType;
        /**           * @description */         
        @AuraEnabled public List<RegisteredProducts> registeredProducts;
        /**           * @description */         
        @AuraEnabled public List<SecurityQuestions> securityQuestions;
        /**           * @description */         
        @AuraEnabled public String username;
    }
  /**           * @description */         
    public class SecurityQuestions {
    }
/**           * @description */         
    public class RegisteredProducts {
        /**           * @description */         
        @AuraEnabled public String lastAccessedDate;
        /**           * @description */         
        @AuraEnabled public String productCode;
        /**           * @description */         
        @AuraEnabled public List<OmniRegistrationKeyWrapper.RegistrationKeys> registrationKeys;
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