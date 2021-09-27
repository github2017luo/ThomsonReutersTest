/**
* @description Helper class to prepare customer details
*/
public without sharing class CreateSSDCustomerFromESIHelper4{
    
    /**
     * @description Helper method5 to prepare customer details
     * @param addressObject of type APTS_CreateSSDJSON2Apex.address
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex.address
    */
    public static APTS_CreateSSDJSON2Apex.address preparecustomerinfo5(APTS_CreateSSDJSON2Apex.address addressObject,Source_System_Detail__c oSsdDetails){
        Country_Region__c oCountryRegion = setcountryregion(oSsdDetails); 
        if(oCountryRegion != null && oCountryRegion.Region_Code__c != null && oCountryRegion.Region_Code__c != ''){
            if(oCountryRegion.Region_Code__c.length() >3){
                addressObject.region = oCountryRegion.Region_Code__c.substring(0, 3);
            }else{
                addressObject.region = oCountryRegion.Region_Code__c;
            }
        }
        //Start: DOC-6893 (Check if SSD has State or not) 
        else if (oSsdDetails.State__c != null && oSsdDetails.State__c != ''){
            if(oSsdDetails.State__c.length() >3){
                addressObject.region = oSsdDetails.State__c.substring(0, 3);
            }else{
                addressObject.region = oSsdDetails.State__c;
            }
        }
        //End DOC-6893
        System.debug(LoggingLevel.DEBUG,'Region : '+addressObject.region);
        addressObject.country = oSsdDetails.Country__c;
        return addressObject;
    }
    
    /**
     * @description Helper method to set country and region
     * @param oSsdDetails of type Source_System_Detail__c
     * @return Country_Region__c
    */
    @testVisible private static Country_Region__c setcountryregion(Source_System_Detail__c oSsdDetails){
        Country_Region__c oCountryRegion = new Country_Region__c();
        String strBillState = oSsdDetails.State__c;
        String strBillCountry = (Country_BigRule_Exception__c.getInstance(oSsdDetails.Country__c) == null)?null:Country_BigRule_Exception__c.getInstance(oSsdDetails.Country__c).Name;  
        if(strBillCountry != null && Schema.sObjectType.Country_Region__c.isAccessible()){
            try{
                oCountryRegion = [SELECT Country_Code__c,Region_Code__c,Region_Name__c from Country_Region__c where (Country_Code__c = :strBillCountry AND Region_Code__c = :strBillState) OR (Country_Code__c = :strBillCountry AND Region_Name__c = :strBillState)];
            }catch(Exception ex){
                system.debug(LoggingLevel.DEBUG,'Region or Region code value not correct : '+ex.getMessage());
            }
        }
        return oCountryRegion;
    }
    
    /**
     * @description Helper method6 to prepare customer details
     * @param addressObject of type APTS_CreateSSDJSON2Apex.address
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex.address
    */
    public static APTS_CreateSSDJSON2Apex.address preparecustomerinfo6(APTS_CreateSSDJSON2Apex.address addressObject,Source_System_Detail__c oSsdDetails){
        if(oSsdDetails.name.length() >35){
            addressObject.firstName= oSsdDetails.name.substring(0, 35);
        }else{
            addressObject.firstName= oSsdDetails.name;
        }
        addressObject.postalCode = oSsdDetails.Postal_Code__c;
        addressObject.poBox = oSsdDetails.LCRM_PO_Box__c;
        if(!String.isEmpty(oSsdDetails.County__c) && oSsdDetails.County__c!= null && oSsdDetails.County__c.length() >35){
            addressObject.district = oSsdDetails.County__c.substring(0, 35);
        }else{
            addressObject.district = oSsdDetails.County__c;  
        }
        return addressObject;
    }
    
    /**
     * @description Helper method7 to prepare customer details
     * @param addressObject of type APTS_CreateSSDJSON2Apex.address
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex.address
    */
    public static APTS_CreateSSDJSON2Apex.address preparecustomerinfo7(APTS_CreateSSDJSON2Apex.address addressObject,Source_System_Detail__c oSsdDetails){
        if(oSsdDetails.LCRM_Phone__c != null){    
            //checck the size of phone field 
            if(oSsdDetails.LCRM_Phone__c.length()<= 16){
                addressObject.phone = oSsdDetails.LCRM_Phone__c; 
            }else{
                addressObject = setphone(addressObject,oSsdDetails) ;  
            }      
        }
        return addressObject;
    }
    
    /**
     * @description Method to set Phone Number
     * @param addressObject of type APTS_CreateSSDJSON2Apex.address
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex.address
    */
    @testVisible private static APTS_CreateSSDJSON2Apex.address setphone(APTS_CreateSSDJSON2Apex.address addressObject,Source_System_Detail__c oSsdDetails){
        // Replace all special characters with null and check the size, 
        // if less than 16 assign the same otherwise get first 16 characters 
        String originalPhone = oSsdDetails.LCRM_Phone__c.replaceAll('[^a-zA-Z0-9\\s+-]', '');
        if(originalPhone != null){
            if(originalPhone.length() <= 16 ){
                addressObject.phone = originalPhone;
            }else{
                addressObject.phone = originalPhone.subString(0,16);
            }
        } 
        return addressObject;
    }
}