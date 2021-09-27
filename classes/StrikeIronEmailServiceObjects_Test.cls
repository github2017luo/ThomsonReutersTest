/**
 * Test Class for the StrikeIronEmailServiceObjects
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
public class StrikeIronEmailServiceObjects_Test{
    public static testMethod Void StrikeIronEmailServiceObjects_Test(){
        Test.startTest();
        StrikeIronEmailServiceObjects.LicenseInfo licInfo = new StrikeIronEmailServiceObjects.LicenseInfo();
        StrikeIronEmailServiceObjects.GetRemainingHitsResponse_element remHitresp = new StrikeIronEmailServiceObjects.GetRemainingHitsResponse_element();
        StrikeIronEmailServiceObjects.GetRemainingHits_element remHitEle = new StrikeIronEmailServiceObjects.GetRemainingHits_element();
        StrikeIronEmailServiceObjects.SubscriptionInfo subsInfo = new StrikeIronEmailServiceObjects.SubscriptionInfo();
        StrikeIronEmailServiceObjects.RegisteredUser regUser = new StrikeIronEmailServiceObjects.RegisteredUser();
        Test.stopTest();
    }
}