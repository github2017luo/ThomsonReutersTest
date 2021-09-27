/**
* @description Helper class for CreateSSDCustomerFromESI to validate the request payload
*/
public without sharing class CreateSSDCustomerFromESIHelper1{
    
    @testVisible private static String tempStr = '';
    @testVisible private static String countrystate1;
    @testVisible private static String latamsalesorgs;
    
    /**
     * @description Method to set the default values
    */
    @testVisible private static void setvalues(){
        if(Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible()){
            List<APTS_Integration_Variables__mdt> countrystate=[Select Integration_Class__c,MasterLabel,Value__c from APTS_Integration_Variables__mdt where Integration_Class__c=:'CreateSSDCustomerFromESI'];
            for(APTS_Integration_Variables__mdt var : countrystate){
                if(var.masterlabel=='Island Countries for SSD'){
                    countrystate1=var.Value__c;
                }else if(var.masterlabel=='Tax Code for Latam Sales Org'){
                    latamsalesorgs=var.Value__c;
                }
            }
        }
    }
    
    /**
     * @description Handler method for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @return String
    */
    public static String validaterequestpayload(APTS_CreateSSDJSON2Apex oRequest){
        setvalues();
        validaterequestpayload1(oRequest);
        validaterequestpayload2(oRequest);
        validaterequestpayload3(oRequest);
        validaterequestpayload4(oRequest);
        validaterequestpayload5(oRequest);
        tempStr = CreateSSDCustomerFromESIHelper2.validaterequestpayload6(oRequest,tempStr);
        tempStr = CreateSSDCustomerFromESIHelper2.validaterequestpayload7(oRequest,tempStr);
        tempStr = CreateSSDCustomerFromESIHelper2.validaterequestpayload8(oRequest,latamsalesorgs,tempStr);
        if(tempStr!=null && tempStr!=''){
            tempStr = 'Required Information missing : ' + tempStr;
        }
        return tempStr;
    }
    
    /**
     * @description Helper method1 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    @testVisible private static void validaterequestpayload1(APTS_CreateSSDJSON2Apex oRequest){
        if(oRequest.customer.address_x.get(0).street1 == null){
            tempStr = (tempStr==null || tempStr=='')?'Street': tempStr+', Street';
        }
        if(oRequest.customer.address_x.get(0).firstname == null){
            tempStr = (tempStr==null || tempStr=='')?'Source System Account Name': tempStr+', Source System Account Name';
        }
    }
    
    /**
     * @description Helper method2 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    @testVisible private static void validaterequestpayload2(APTS_CreateSSDJSON2Apex oRequest){
        if(oRequest.customer.address_x.get(0).city== null){
            tempStr = (tempStr==null || tempStr=='')?'city': tempStr+', city';
        }
        if(oRequest.customer.address_x.get(0).country == null){
            tempStr = (tempStr==null || tempStr=='')?'Country': tempStr+', Country';
        }
    }
    
    /**
     * @description Helper method3 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    @testVisible private static void validaterequestpayload3(APTS_CreateSSDJSON2Apex oRequest){
        List<String> countrylist = new List<String>{'US','AR','PY','CL','UY'};
        if(oRequest.customer.address_x.get(0).region == null && oRequest.customer.address_x.get(0).country != null && countrylist.contains(oRequest.customer.address_x.get(0).country) && oRequest.customer.salesOrg == 'TA61'){
            tempStr = (tempStr==null || tempStr=='')?'State': tempStr+', State';
        }
    }
    
    /**
     * @description Helper method4 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    @testVisible private static void validaterequestpayload4(APTS_CreateSSDJSON2Apex oRequest){
        if(oRequest.customer.address_x.get(0).region == null && oRequest.customer.salesOrg != 'TA61' && !countrystate1.contains(oRequest.customer.address_x.get(0).country)){
            tempStr = (tempStr==null || tempStr=='')?'State': tempStr+', State';
        }
    }
    
    /**
     * @description Helper method5 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    @testVisible private static void validaterequestpayload5(APTS_CreateSSDJSON2Apex oRequest){
        if(oRequest.customer.salesOrg ==null){
            tempStr = (tempStr==null || tempStr=='')?'Sales Org': tempStr+', Sales Org';
        }
    }
}