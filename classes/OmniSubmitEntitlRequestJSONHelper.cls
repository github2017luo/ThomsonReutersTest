/**
* @description       : 
* @author            : TCS Developer
* @group             : 
* @last modified on  : 06-22-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-24-2021   TCS Developer                         Initial Version 
**/
public with sharing class OmniSubmitEntitlRequestJSONHelper {
    
    /**
    * @description       : getContactFuntionValue
    * @param buSegment
    * @return contactFunctionValue
    * */
    public static String getContactFuntionValue(String buSegment){

        String contactFunctionValue = '';
        List<OmniContactFunctionCreateTrial__c> contactFunList = OmniContactFunctionCreateTrial__c.getAll().values();
        
        //get Map of BU Segment and Contact Function Value
        Map<String,String> buSegmentContFunMap =getBuSegmentContFunMap(contactFunList);
        
        System.debug(LoggingLevel.DEBUG,'buSegmentContFunMap: '+buSegmentContFunMap);
        
        if(String.isNotBlank(buSegment) && buSegmentContFunMap.containsKey(buSegment)){
            contactFunctionValue = buSegmentContFunMap.get(buSegment);
        }
        if(String.isblank(contactFunctionValue) || contactFunctionValue == null){
        contactFunctionValue = '100';
        }
        return contactFunctionValue;
    }

    /**
    * @description       : getBuSegmentContFunMap
    * @param contactFunList
    * @return buSegmentContFunMap
    * */
    private static Map<String,String> getBuSegmentContFunMap(List<OmniContactFunctionCreateTrial__c> contactFunList){
        Map<String,String> buSegmentContFunMap = new Map<String,String>();

        for(OmniContactFunctionCreateTrial__c conFun : contactFunList){
            buSegmentContFunMap.put(conFun.Bu_Segment__c, conFun.Contact_Function_Value__c);
        }
        return buSegmentContFunMap;
    }

    /**
    * @description       : getCustomerSegment
    * @param buSegment
    * @param governmentType
    * @param country
    * @return customerSegmentValue
    * */
    public static String getCustomerSegmentValue(String buSegment, String governmentType, String country){
        String customerSegmentValue = '';
        List<OmniCustomerSegmentCreateTrial__c> customerSegMapList = OmniCustomerSegmentCreateTrial__c.getAll().values();
        String keyValue = buSegment;
        
        Boolean isBuSegmentLeglTaxCorp = getBUSegmentCheck(buSegment);
        if(!isBuSegmentLeglTaxCorp ){
            
            keyValue = getKeyValueFromGovtType(governmentType, keyValue);
            
            if(String.isNotBlank(country) && country == 'US' && buSegment=='Government' && 
            String.IsNOTBlank(governmentType) &&governmentType=='Federal'){
                keyValue +=country;
            }
        }
        
        Map<String,String> customSettingMap = getBuSegCountryGovtTypeMap(customerSegMapList);
        System.debug(LoggingLevel.DEBUG,'customSettingMap: '+customSettingMap);
        System.debug(LoggingLevel.DEBUG,'keyValue: '+keyValue);
        
        if(String.isNotBlank(keyValue) && customSettingMap.containsKey(keyValue)){
            customerSegmentValue = customSettingMap.get(keyValue);
        }
        
        customerSegmentValue = getCustomerSegmentValueDefault(customerSegmentValue);
        
        return customerSegmentValue;
    }
    
    /**
    * @description       : getCustomerSegmentValueDefault
    * @param customerSegmentValue
    * @return customerSegmentValue
    * */
    private static String getCustomerSegmentValueDefault(String customerSegmentValue){
        
        if(String.isblank(customerSegmentValue) || customerSegmentValue == null){
            customerSegmentValue = '01';
        }
        return customerSegmentValue;
    }
    /**
    * @description       : getBUSegmentCheck
    * @param governmentType
    * @param keyValue
    * @return keyValue 
    * */
    private static String getKeyValueFromGovtType(String governmentType,String keyValue)
    {
        if(String.isNotBlank(governmentType)){
            keyValue +=governmentType;
        }
        return keyValue;
    }
    /**
    * @description       : getBUSegmentCheck
    * @param busegment
    * @return isBUsegment 
    * */
    private static Boolean getBUSegmentCheck(String busegment){
        
        Boolean isBUsegment = false;
        
        if(buSegment == 'Professional Legal' || buSegment == 'Professional Tax' || buSegment == 'Corporate'){
            isBUsegment = true;
        }
        return isBUsegment ;
    }
    /**
    * @description       : getBuSegmentContFunMap
    * @param customerSegMapList
    * @return customSettingMap
    * */
    private static Map<String,String> getBuSegCountryGovtTypeMap(List<OmniCustomerSegmentCreateTrial__c> customerSegMapList){
        Map<String,String> customSettingMap= new Map<String,String>();
        
        for(OmniCustomerSegmentCreateTrial__c customerSeg :  customerSegMapList){
            
            String buSegment = customerSeg.Bu_Segment__c;
            String govtType = customerSeg.Government_Type__c;
            String country = customerSeg.Country__c;
            
            if(buSegment == null){
                buSegment ='';
            }
            if(govtType == null){
                govtType='';
            }
            if(country == null){
                country  ='';
            } 
            String key = buSegment +govtType+country ;
            
            customSettingMap.put(key,customerSeg.Customer_Segment_Value__c);
        }
        return customSettingMap;
    }
}