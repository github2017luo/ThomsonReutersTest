@istest
public class sendReferral_test{
    public static testmethod void testSendReferral(){
       sendReferral oController = new sendReferral();
       oController.getEmailurl();
    }
    public static testmethod void testSendReferralEmail(){
       sendreferralEmail oController = new sendreferralEmail();
       Account testAccount = unittest.getAccountInstance();
       insert testAccount;
       Task oactivity = unittest.getTaskInstance(testAccount.id,true);
       OActivity.type='Email';
       test.setcurrentPage(page.sendReferralEmail);
       ApexPages.currentPage().getParameters().put('accountid',testAccount.id);
       insert OActivity;
       oController.updateActivity();
    }
}