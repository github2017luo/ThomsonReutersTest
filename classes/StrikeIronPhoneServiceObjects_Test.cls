/**
 * Test Class for the StrikeIronPhoneServiceObjects
 *
 *
 * @author  TCS
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2017-07-15   TCS                 Created
 *                                                
 * =============================================================================
 */
 @IsTest
public class StrikeIronPhoneServiceObjects_Test{
    public static testMethod Void StrikeIronPhoneServiceObjects_Test(){
        Test.startTest();
        StrikeIronPhoneServiceObjects.LicenseInfo licInfo = new StrikeIronPhoneServiceObjects.LicenseInfo();
        StrikeIronPhoneServiceObjects.GetRemainingHitsResponse_element remHits = new StrikeIronPhoneServiceObjects.GetRemainingHitsResponse_element();
        StrikeIronPhoneServiceObjects.GetRemainingHits_element remHitEle = new StrikeIronPhoneServiceObjects.GetRemainingHits_element();
        StrikeIronPhoneServiceObjects.SubscriptionInfo subsInfo = new StrikeIronPhoneServiceObjects.SubscriptionInfo();
        StrikeIronPhoneServiceObjects.RegisteredUser regUser = new StrikeIronPhoneServiceObjects.RegisteredUser();
        Test.stopTest();
    }
}