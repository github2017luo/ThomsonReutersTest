@istest
public class IncentivePasswordRegistrationWS_Test {
    private static testMethod void testController(){
    
        IncentivePasswordRegistrationWS testObj= new IncentivePasswordRegistrationWS();
        IncentivePasswordRegistrationWS.UserRegistration testUserRegistration = new IncentivePasswordRegistrationWS.UserRegistration();
        IncentivePasswordRegistrationWS.PromotionUser testPromotionUser = new IncentivePasswordRegistrationWS.PromotionUser();
        IncentivePasswordRegistrationWS.GetPromotionPasswords_element testPromotionPasswords_element = new IncentivePasswordRegistrationWS.GetPromotionPasswords_element();        
        IncentivePasswordRegistrationWS.GetPromotionPasswordsResponse_element testGetPromotionPasswordsResponse_element = new IncentivePasswordRegistrationWS.GetPromotionPasswordsResponse_element();
        IncentivePasswordRegistrationWS.GetOpenPromotionsResponse_element testGetOpenPromotionsResponse_element = new IncentivePasswordRegistrationWS.GetOpenPromotionsResponse_element();
        IncentivePasswordRegistrationWS.GetOpenPromotions_element testGetOpenPromotions_element = new IncentivePasswordRegistrationWS.GetOpenPromotions_element();
        IncentivePasswordRegistrationWS.IncentivePassword testIncentivePassword = new IncentivePasswordRegistrationWS.IncentivePassword();
        IncentivePasswordRegistrationWS.OpenPromotion testOpenPromotion = new IncentivePasswordRegistrationWS.OpenPromotion();
        
        List<IncentivePasswordRegistrationWS.PromotionUser> prmList = new List<IncentivePasswordRegistrationWS.PromotionUser>();
        List<String> prmKey = new List<String>();
        
        IncentivePasswordRegistrationWS.Registration_v2_0Port oService = new IncentivePasswordRegistrationWS.Registration_v2_0Port();
        oService.inputHttpHeaders_x = new Map<String,String>();
        oService.outputHttpHeaders_x = new Map<String,String>();
        oService.clientCertName_x = '';
        oService.clientCert_x = '';
        oService.clientCertPasswd_x = '';
        oService.timeout_x = 0;
        
        try{
            oService.GetPromotionPasswords(prmKey, prmList, '', '');
        }
        catch(exception ex){
        }
        try{
            oService.GetOpenPromotions('', '', ''); 
        }
        catch(exception ex){
        }
        /*        
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.timeout_x = 1000; //1 Second
        oService.endpoint_x = 'http://unittest@thomsonreuters.com';
        oService.outputHttpHeaders_x = new Map<String,String>();
        IncentivePasswordRegistrationWS.OpenPromotion[] oOpenPromotionTest =oService.GetOpenPromotions('test','test','test');
        IncentivePasswordRegistrationWS.PromotionUser oUserTest = new IncentivePasswordRegistrationWS.PromotionUser();
        IncentivePasswordRegistrationWS.UserRegistration[] oUserRegistrationTest = oService.GetPromotionPasswords
        (new string[]{'test'},new IncentivePasswordRegistrationWS.PromotionUser[]{oUserTest},'test','test');
        */
    }
}