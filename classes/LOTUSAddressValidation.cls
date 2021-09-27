/**********************************************************************************************************
 *
 * LOTUSAddressValidation is a single service to validate address fields on the standard objects like
 * Lead, Account, Contact and other objects which has Address.
 *
 * This service will trigger validation only for LOTUS Users who are in Lightning Experience(based on Theme).
 This class is initiated by the respective object before trigger.
 *
 * Change History:
 * ********************************************************************************************************
 * Date             Name                            Description
 * ********************************************************************************************************
 * 2020-02-04       Surendra Kamma                  Created.
 *
 * ********************************************************************************************************/
public with sharing class LOTUSAddressValidation{
    public class CustomException Extends Exception{
    }

    public Static void validateAddress(Sobject sobj){

        String objType = sobj.getSObjectType().getDescribe().getName();
        //objType is to query the related object address fields from the custom metadata.

        //Set<String> mapExcludeCountry = new Set<String>();
        Set<String> mapExcludeCountry = fetchExcludedCountries();


        //List fieldName is used to access the specific field in a map using index for better performance(0-Country,1-State,2-Street,3-City,4-Zip).
        List<String> fieldName = new List<String>();
        //mapLF is a custom metadata having all the objects, related address fields and respective error messages.
        Map<String, LOTUS_Address_Field__mdt> mapLF = new Map<String, LOTUS_Address_Field__mdt>();
        if (Schema.SObjectType.LOTUS_Address_Field__mdt.isAccessible() && Schema.SObjectType.LOTUS_Address_Field__mdt.isQueryable()){
            for (LOTUS_Address_Field__mdt lf : [Select Sequence__c, Object__c, Field_API_Name__c, Error_Message__c, Length_Error__c, Active__c
                                                from LOTUS_Address_Field__mdt
                                                where Active__c = true and Object__c = :objType
                                                order by Sequence__c ASC]){
                mapLF.put(lf.Field_API_Name__c, lf);
                fieldName.add(lf.Field_API_Name__c);
            }
        }

        checkValidation(mapLF, fieldName, sobj);
    }

    /*commented as a part of DPS - 19578
     public static void validateLeadAddress(Sobject obj){
     String objType=  obj.getSObjectType().getDescribe().getName();
    //objType is to query the related object address fields from the custom metadata.
    //mapLF is a custom metadata having all the objects, related address fields and respective error messages.
     Map<String,LOTUS_Address_Field__mdt> mapLF= new Map<String,LOTUS_Address_Field__mdt>();
     if(Schema.SObjectType.LOTUS_Address_Field__mdt.isAccessible()&& Schema.SObjectType.LOTUS_Address_Field__mdt.isQueryable()){
     for(LOTUS_Address_Field__mdt lf:[Select Sequence__c,Object__c, Field_API_Name__c, Error_Message__c,Length_Error__c, Active__c from LOTUS_Address_Field__mdt where Active__c=true and Object__c =:objType order by Sequence__c ASC]){
     mapLF.put(lf.Field_API_Name__c, lf) ;
     }
     }
    //checking only Country field before inserting & editing Lead from Lightning Component.
     for(String field:mapLF.keySet()){
     if(obj.get(field)==Null || obj.get(field)==''){
     Throw new CustomException(mapLF.get(field).Error_Message__c);
     }
     }
     }commented as a part of DPS - 19578 */
    public static void checkValidation(Map<String, LOTUS_Address_Field__mdt> mapLF, List<String> fieldName, Sobject sobj){
        Set<String> mapExcludeCountry = fetchExcludedCountries();
        for (String field : mapLF.keySet()){        

                /*if ((sobj.get(field) == Null || sobj.get(field) == '') && 
                (field == 'BillingCity' || field == 'BillingStreet' || field == 'BillingCountryCode' || (field == 'BillingStateCode' && !mapExcludeCountry.contains((String)sobj.get('BillingCountryCode'))) || (field == 'BillingPostalCode' && !mapExcludeCountry.contains((String)sobj.get('BillingCountryCode'))))){
                    Throw new CustomException(mapLF.get(field).Error_Message__c);
                }*/
                //This logic is for checking PostalCode length.
                /*String stringLength = '';
                if (sobj.get(field) != null && sobj.get(field) != ''){
                    stringLength = (String)sobj.get(field);
                }*/
                validateFields(field,mapLF,sobj);
                if ((sobj.get(field) != Null && sobj.get(field) != '') && field == 'BillingPostalCode' && field.contains(fieldName.get(4)) && ((String)sobj.get(field)).length() > 10){

                    Throw new CustomException(mapLF.get(field).Length_Error__c);
                }
            
        }
    }

    Public static Set<String> fetchExcludedCountries(){
        Set<String> mapExcludeCountry = new Set<String>();
        // mapExcludeCountry is to exclude all the Countries which don't have any States defined in the Org.
        if (Schema.SObjectType.Exclude_Country__mdt.isAccessible()){
            for (LOTUS_Exclude_Country__mdt ec : [Select label, Country_Code__c
                                                  from LOTUS_Exclude_Country__mdt]){
                if (ec.Country_Code__c != null){
                    mapExcludeCountry.add(ec.Country_Code__c);
                }


            }

        }

        return mapExcludeCountry;
    }
    public static void validateFields(String field, Map<String, LOTUS_Address_Field__mdt> mapLF,Sobject sobj){
        String[] fieldnames = new String[] {'BillingCity', 'BillingStreet', 'BillingCountryCode'}; 
        Set<String> mapExcludeCountry = fetchExcludedCountries();
        if ((sobj.get(field) == Null || sobj.get(field) == '') && 
            (fieldnames.contains(field) || ((field == 'BillingStateCode' || field == 'BillingPostalCode') && !mapExcludeCountry.contains((String)sobj.get('BillingCountryCode'))))){
            Throw new CustomException(mapLF.get(field).Error_Message__c);
        }
       
    }

    
}