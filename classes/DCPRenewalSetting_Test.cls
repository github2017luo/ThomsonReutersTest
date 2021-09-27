@isTest
public class DCPRenewalSetting_Test{

    @isTest
    private static void renewalSettingTest(){

        Test.startTest();
        DCPRenewalSetting.getRenewalSetting();
        String settingValue = DCPRenewalSetting.getValue('Test Value');
        System.assert(settingValue != null,'No metadata exists');
        Test.stopTest();
    }
}