@istest
public with sharing class IncentivePasswordRegistration_Test {
    private static testMethod void testIncentivePromo(){
           IncentivePasswordRegistration.OpenPromotionRequest oPromotionRequest = new IncentivePasswordRegistration.OpenPromotionRequest();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
        oPromotionRequest.endpoint= oWebServiceSettings.Endpoint__c;
        oPromotionRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        oPromotionRequest.username=oWebServiceSettings.Username__c;
        oPromotionRequest.password= oWebServiceSettings.Password__c;
        oPromotionRequest.DomainName = 'test';
        oPromotionRequest.CompanyCode = 'test';
        oPromotionRequest.PromotionType = 'test';        
        IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();
        List<IncentivePasswordRegistration.Promotion> listPromotions = oRegistrationService.requestOpenPromotions(oPromotionRequest);
         
    }
    private static testMethod void testIncentivePwd(){
        IncentivePasswordRegistration.PromotionPasswordRequest oPasswordRequest = new IncentivePasswordRegistration.PromotionPasswordRequest();
        list<Incentive_Password__c> ListIncentivePwds = new list<Incentive_Password__c>();       
        oPasswordRequest.Contacts.add(new IncentivePasswordRegistration.PromotionUserContact());       
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
        oPasswordRequest.endpoint= oWebServiceSettings.Endpoint__c;
        oPasswordRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        oPasswordRequest.username=oWebServiceSettings.Username__c;
        oPasswordRequest.password= oWebServiceSettings.Password__c; 
        
        IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();        
            List<IncentivePasswordRegistration.PromotionPassword> listPasswords = oRegistrationService.requestPromotionPasswords(oPasswordRequest);
    }
}