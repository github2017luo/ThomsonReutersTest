/**
 * Test Class for the StrikeIronPhoneService
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
public class StrikeIronPhoneService_Test{
    public static testMethod Void StrikeIronPhoneService_Test(){
        Test.startTest();
        StrikeIronPhoneService.ValidateNumber_element validNumEle = new StrikeIronPhoneService.ValidateNumber_element();
        StrikeIronPhoneService.CountryCodeDatabaseEntry conCdDb= new StrikeIronPhoneService.CountryCodeDatabaseEntry();
        StrikeIronPhoneService.GetStatusCodesForMethodResponse_element respEle= new StrikeIronPhoneService.GetStatusCodesForMethodResponse_element();
        StrikeIronPhoneService.ValidateNumberCountryName_element validNumConNmEle = new StrikeIronPhoneService.ValidateNumberCountryName_element();
        StrikeIronPhoneService.CountryCodePhoneNumberPair ConCodePhNumPair = new StrikeIronPhoneService.CountryCodePhoneNumberPair();
        StrikeIronPhoneService.SIWsResultArrayOfGlobalPhoneEntryWithStatus phEntryWithSt = new StrikeIronPhoneService.SIWsResultArrayOfGlobalPhoneEntryWithStatus();
        StrikeIronPhoneService.ValidateNumberCountryNameResponse_element validNumConNmRespEle = new StrikeIronPhoneService.ValidateNumberCountryNameResponse_element();
        StrikeIronPhoneService.GetStatusCodesForMethod_element stCdForMtEle = new StrikeIronPhoneService.GetStatusCodesForMethod_element();
        StrikeIronPhoneService.ArrayOfCountryCodePhoneNumberPair arrConCdPhNumP = new StrikeIronPhoneService.ArrayOfCountryCodePhoneNumberPair();
        StrikeIronPhoneService.MethodStatusRecord metStRec = new StrikeIronPhoneService.MethodStatusRecord();
        StrikeIronPhoneService.GetCountryInfo_element getConInEle = new StrikeIronPhoneService.GetCountryInfo_element();
        StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfServiceInfoRecord t1 = new StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfServiceInfoRecord();
        StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfCountryCodeDatabaseEntryWithStatus t2 = new StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfCountryCodeDatabaseEntryWithStatus();
        StrikeIronPhoneService.ArrayOfCountryCodeDatabaseEntryWithStatus t3 = new StrikeIronPhoneService.ArrayOfCountryCodeDatabaseEntryWithStatus();
        StrikeIronPhoneService.ArrayOfMethodStatusRecord t4 = new StrikeIronPhoneService.ArrayOfMethodStatusRecord();
        StrikeIronPhoneService.ValidateNumberResponse_element t5 = new StrikeIronPhoneService.ValidateNumberResponse_element();
        StrikeIronPhoneService.GlobalPhoneEntryWithStatus t6 = new StrikeIronPhoneService.GlobalPhoneEntryWithStatus();
        StrikeIronPhoneService.SIWsStatus t7 = new StrikeIronPhoneService.SIWsStatus();
        StrikeIronPhoneService.ValidateNumberISOResponse_element t8 = new StrikeIronPhoneService.ValidateNumberISOResponse_element();
        StrikeIronPhoneService.ServiceInfoRecord t9 = new StrikeIronPhoneService.ServiceInfoRecord();
        StrikeIronPhoneService.GetServiceInfo_element t10 = new StrikeIronPhoneService.GetServiceInfo_element();
        StrikeIronPhoneService.ArrayOfServiceInfoRecord t11 = new StrikeIronPhoneService.ArrayOfServiceInfoRecord();
        StrikeIronPhoneService.ValidateNumberCountryCode_element t12 = new StrikeIronPhoneService.ValidateNumberCountryCode_element();
        StrikeIronPhoneService.GetAllCountriesResponse_element t13 = new StrikeIronPhoneService.GetAllCountriesResponse_element();
        StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfMethodStatusRecord t14 = new StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfMethodStatusRecord();
        StrikeIronPhoneService.ValidateNumberCountryCodeResponse_element t15 = new StrikeIronPhoneService.ValidateNumberCountryCodeResponse_element();
        StrikeIronPhoneService.CountryNamePhoneNumberPair t16 = new StrikeIronPhoneService.CountryNamePhoneNumberPair();
        StrikeIronPhoneService.GetStatusCodesResponse_element t17 = new StrikeIronPhoneService.GetStatusCodesResponse_element();
        StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus t18 = new StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus();
        StrikeIronPhoneService.ISOCountryCodePhoneNumberPair t19 = new StrikeIronPhoneService.ISOCountryCodePhoneNumberPair();
        StrikeIronPhoneService.GetCountryInfoResponse_element t20 = new StrikeIronPhoneService.GetCountryInfoResponse_element();
        StrikeIronPhoneService.GetServiceInfoResponse_element t21 = new StrikeIronPhoneService.GetServiceInfoResponse_element();
        StrikeIronPhoneService.SIWsResultArrayOfServiceInfoRecord t22 = new StrikeIronPhoneService.SIWsResultArrayOfServiceInfoRecord();
        StrikeIronPhoneService.CountryCodeDatabaseEntryWithStatus t23 = new StrikeIronPhoneService.CountryCodeDatabaseEntryWithStatus();
        StrikeIronPhoneService.ValidateNumberISO_element t24 = new StrikeIronPhoneService.ValidateNumberISO_element();
        StrikeIronPhoneService.GetAllCountries_element t25 = new StrikeIronPhoneService.GetAllCountries_element();
        StrikeIronPhoneService.GetStatusCodes_element t26 = new StrikeIronPhoneService.GetStatusCodes_element();
        StrikeIronPhoneService.SIWsResultArrayOfCountryCodeDatabaseEntryWithStatus t27 = new StrikeIronPhoneService.SIWsResultArrayOfCountryCodeDatabaseEntryWithStatus();
        StrikeIronPhoneService.ArrayOfSIWsStatus t28 = new StrikeIronPhoneService.ArrayOfSIWsStatus();
        StrikeIronPhoneService.GlobalPhoneEntryVerbose t29 = new StrikeIronPhoneService.GlobalPhoneEntryVerbose();
        StrikeIronPhoneService.SIWsResultArrayOfMethodStatusRecord t30 = new StrikeIronPhoneService.SIWsResultArrayOfMethodStatusRecord();
        StrikeIronPhoneService.ArrayOfISOCountryCodePhoneNumberPair t31 = new StrikeIronPhoneService.ArrayOfISOCountryCodePhoneNumberPair();
        StrikeIronPhoneService.SIWsOutputOfMethodStatusRecord t32 = new StrikeIronPhoneService.SIWsOutputOfMethodStatusRecord();
        StrikeIronPhoneService.ArrayOfGlobalPhoneEntryWithStatus t33 = new StrikeIronPhoneService.ArrayOfGlobalPhoneEntryWithStatus();
        StrikeIronPhoneService.SIWsResultArrayOfSIWsStatus t34 = new StrikeIronPhoneService.SIWsResultArrayOfSIWsStatus();
        
        StrikeIronPhoneService.GlobalPhoneValidation15Soap t35 = new StrikeIronPhoneService.GlobalPhoneValidation15Soap();
        try{
            t35.GetAllCountries();
        }catch(Exception e){}
        try{
            t35.ValidateNumberISO(null);
        }catch(Exception e){}
        try{
            t35.GetStatusCodesForMethod('test');
        }catch(Exception e){}
        try{
            t35.ValidateNumberCountryCode(null);
        }catch(Exception e){}
        try{
            t35.ValidateNumberCountryName(null);
        }catch(Exception e){}
        try{
            t35.ValidateNumber('+916787868678');
        }catch(Exception e){}
        try{
            t35.GetStatusCodes();
        }catch(Exception e){}
        try{
            t35.GetServiceInfo();
        }catch(Exception e){}
        try{
            t35.GetCountryInfo('test');
        }catch(Exception e){}
        try{
            t35.GetRemainingHits();
        }catch(Exception e){}
        Test.stopTest();
    }
}