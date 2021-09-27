/**
 * Test Class for the StrikeIronEmailService
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
public class StrikeIronEmailService_Test{
    public static testMethod Void StrikeIronEmailService_Test(){
        Test.startTest();
        StrikeIronEmailService.VerifyEmailRecord verEmailRec = new StrikeIronEmailService.VerifyEmailRecord();
        StrikeIronEmailService.GetStatusCodesForMethodResponse_element t1 = new StrikeIronEmailService.GetStatusCodesForMethodResponse_element();
        StrikeIronEmailService.GetStatusCodesForMethod_element t2 = new StrikeIronEmailService.GetStatusCodesForMethod_element();
        StrikeIronEmailService.Reason t3 = new StrikeIronEmailService.Reason();
        StrikeIronEmailService.MethodStatusRecord t4 = new StrikeIronEmailService.MethodStatusRecord();
        StrikeIronEmailService.VerifyEmail_element t5 = new StrikeIronEmailService.VerifyEmail_element();
        StrikeIronEmailService.ArrayOfStringKeyValuePair t6 = new StrikeIronEmailService.ArrayOfStringKeyValuePair();
        StrikeIronEmailService.SIWsOutputOfSIWsResultArrayOfServiceInfoRecord t7= new StrikeIronEmailService.SIWsOutputOfSIWsResultArrayOfServiceInfoRecord();
        StrikeIronEmailService.ArrayOfReason t8 = new StrikeIronEmailService.ArrayOfReason();
        StrikeIronEmailService.ArrayOfMethodStatusRecord t9 = new StrikeIronEmailService.ArrayOfMethodStatusRecord();
        StrikeIronEmailService.StringKeyValuePair t10 = new StrikeIronEmailService.StringKeyValuePair();
        StrikeIronEmailService.SIWsStatus t11 = new StrikeIronEmailService.SIWsStatus();
        StrikeIronEmailService.ServiceInfoRecord t12 = new StrikeIronEmailService.ServiceInfoRecord();
        StrikeIronEmailService.GetServiceInfo_element t13 = new StrikeIronEmailService.GetServiceInfo_element();
        StrikeIronEmailService.ArrayOfServiceInfoRecord t14 = new StrikeIronEmailService.ArrayOfServiceInfoRecord();
        StrikeIronEmailService.GetReasonCodes_element t15 = new StrikeIronEmailService.GetReasonCodes_element();
        StrikeIronEmailService.VerifyEmailResponse_element t16 = new StrikeIronEmailService.VerifyEmailResponse_element();
        StrikeIronEmailService.SIWsOutputOfSIWsResultArrayOfMethodStatusRecord t17 = new StrikeIronEmailService.SIWsOutputOfSIWsResultArrayOfMethodStatusRecord();
        StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord t18 = new StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord();
        StrikeIronEmailService.SIWsOutputOfSIWsResultArrayOfReason t19 = new StrikeIronEmailService.SIWsOutputOfSIWsResultArrayOfReason();
        StrikeIronEmailService.GetStatusCodesResponse_element t20 = new StrikeIronEmailService.GetStatusCodesResponse_element();
        StrikeIronEmailService.GetReasonCodesResponse_element t21 = new StrikeIronEmailService.GetReasonCodesResponse_element();
        StrikeIronEmailService.GetServiceInfoResponse_element t22 = new StrikeIronEmailService.GetServiceInfoResponse_element();
        StrikeIronEmailService.SIWsResultArrayOfServiceInfoRecord t23 = new StrikeIronEmailService.SIWsResultArrayOfServiceInfoRecord();
        StrikeIronEmailService.SIWsResultArrayOfReason t24 = new StrikeIronEmailService.SIWsResultArrayOfReason();
        StrikeIronEmailService.GetStatusCodes_element t25 = new StrikeIronEmailService.GetStatusCodes_element();
        StrikeIronEmailService.ArrayOfSIWsStatus t26 = new StrikeIronEmailService.ArrayOfSIWsStatus();
        StrikeIronEmailService.SIWsResultArrayOfMethodStatusRecord t27 = new StrikeIronEmailService.SIWsResultArrayOfMethodStatusRecord();
        StrikeIronEmailService.SIWsOutputOfMethodStatusRecord t28 = new StrikeIronEmailService.SIWsOutputOfMethodStatusRecord();
        StrikeIronEmailService.SIWsResultArrayOfSIWsStatus t29 = new StrikeIronEmailService.SIWsResultArrayOfSIWsStatus();
        StrikeIronEmailService.EMV6HygieneSoap t30 = new StrikeIronEmailService.EMV6HygieneSoap();
        try{
            t30.GetStatusCodesForMethod('test');
        }catch(Exception e){}
        try{
            t30.VerifyEmail('Email',2000,'OptionalSourceId');
        }catch(Exception e){}
        try{
            t30.GetServiceInfo();
        }catch(Exception e){}
        try{
            t30.GetRemainingHits();
        }catch(Exception e){}
        try{
            t30.GetReasonCodes();
        }catch(Exception e){}
        try{
            t30.GetStatusCodes();
        }catch(Exception e){}
        Test.stopTest();
    }
}