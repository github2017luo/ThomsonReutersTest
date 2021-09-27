/**
* @description Helper class to update SSD,Business Partner Function,send request to ESI and prepare customer details
*/
public without sharing class CreateSSDCustomerFromESIHelper3{
    
    /**
     * @description Helper method to update SSD
     * @param responseObject of type APTS_CreateSSDJSON2ApexResponse
     * @param ssdId of type Id
    */
    public static void updatessd(APTS_CreateSSDJSON2ApexResponse responseObject,Id ssdId){
        Source_system_detail__c oUpdatessd = new Source_system_detail__c();
        Account acc = new Account();
        if(Schema.sObjectType.Source_system_detail__c.isAccessible()){
            oUpdatessd = [Select Id,Source_System_Account_Number__c,LCRM_External_Trail_Acount_ID__c,Suspended__c,Account_Name__c from Source_system_detail__c where Id =: ssdId FOR UPDATE];
        }
        if(Schema.sObjectType.Account.isAccessible()){
            acc = [Select Id,Suspended_Acct_Srce_Sys__c from Account where Id =: oUpdatessd.Account_Name__c FOR UPDATE];
        }
        oUpdatessd.Source_System_Account_Number__c= responseObject.customerNumber;
        if(!String.isEmpty(responseObject.prevAcct) && responseObject.prevAcct != null){
            oUpdatessd.LCRM_External_Trail_Acount_ID__c= responseObject.prevAcct;
        }
        oUpdatessd.RecordTypeId = KeyValueListStore__c.getInstance('CustomerSSDRecordTypeId').TextValue__c;
        if(Schema.sObjectType.Source_system_detail__c.isUpdateable()){
            update oUpdatessd;
        }
    }
    
    /**
     * @description Helper method to update Business Partner Function
     * @param responseObject of type APTS_CreateSSDJSON2ApexResponse
     * @param ssdId of type Id
    */
    public static void updatebpf(APTS_CreateSSDJSON2ApexResponse responseObject,Id ssdId){
        List<Business_Partner_Function__c> listBusinessPartnerFunctions = new List<Business_Partner_Function__c>();
        for(APTS_CreateSSDJSON2ApexResponse.PartnerFunction oPartnter : responseObject.partnerFunction){
            Business_Partner_Function__c oBusinessPartnerFunction = new Business_Partner_Function__c();
            oBusinessPartnerFunction.Related_Account_GLI__c = ssdId;
            oBusinessPartnerFunction.Sold_To_Account_GLI__c = ssdId;
            oBusinessPartnerFunction.Sales_Org__c =oPartnter.salesOrg;
            if(BigRuleGenericSettings__c.getInstance('PF:'+oPartnter.functionId) != null){
                oBusinessPartnerFunction.Relationship_Type__c = BigRuleGenericSettings__c.getInstance('PF:'+oPartnter.functionId).Value__c;               
                listBusinessPartnerFunctions.add(oBusinessPartnerFunction);
            }
        }
        if(!listBusinessPartnerFunctions.isEmpty() && Schema.sObjectType.Business_Partner_Function__c.isCreateable()){ 
            insert listBusinessPartnerFunctions;
        }
    }
    
    /**
     * @description Helper method to send HTTP request to ESI
     * @param oRequest of type APTS_CreateSSDJSON2ApexResponse
     * @return HttpResponse
    */
    public static HttpResponse sendhttprequest(APTS_CreateSSDJSON2Apex oRequest){
        String jsonString = JSON.serialize(oRequest);
        //String requestBodyStringSafe = JSON.parse(JSON.stringify(jsonString ));
        String requestBodyStringSafe = jsonString.replaceAll('\"currency_x\":', '\"currency\":');
        requestBodyStringSafe = requestBodyStringSafe.replaceAll('\"address_x\":', '\"address\":');
        //WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('CreateCustomerESI');
        System.debug(LoggingLevel.DEBUG,'requestBodyStringSafe'+requestBodyStringSafe );
        Http http = new Http();
        HttpRequest request = new HttpRequest();      
        //request.setEndpoint(oWebServiceSettings.Endpoint__c);
        request.setEndpoint('callout:CreateCustomerESI'); 
        request.setMethod('POST');
        request.setTimeout(120000);
        String authorizationHeader = 'Basic ' + KeyValueListStore__c.getInstance('ESICustomerAuthorization').TextValue__c;
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json');
        // Set the body as a JSON object
        request.setBody(requestBodyStringSafe );
        System.debug(LoggingLevel.DEBUG,'Http request'+request);
        HttpResponse response;
        if(Test.isRunningTest()){
            response = CreateSSDMockHttpResponseGenerator.respond(request);
        }else{
            response = http.send(request);
        }
        return response;
    }
    
    /**
     * @description Helper method1 to prepare customer details
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex
    */
    public static APTS_CreateSSDJSON2Apex preparecustomerinfo1(APTS_CreateSSDJSON2Apex oRequest,Source_System_Detail__c oSsdDetails){
        if(oSsdDetails.OLC_Account_Number__c!=null){                         
            oRequest.extSapAcct = oSsdDetails.OLC_Account_Number__c;
        }
        oRequest.customer.action= KeyValueListStore__c.getInstance('ESIProductId').TextValue__c;
        if(oSsdDetails.LCRM_Sales_Org__c!=null){ 
            oRequest.customer.salesOrg = oSsdDetails.LCRM_Sales_Org__c;         
            oRequest.customer.distributionChannel = IXOSCodeMap__c.getInstance(oSsdDetails.LCRM_Sales_Org__c).Dist_Chan_Code__c;
            oRequest.customer.division = IXOSCodeMap__c.getInstance(oSsdDetails.LCRM_Sales_Org__c).Division_Code__c;
            oRequest.customer.CompanyId = IXOSCodeMap__c.getInstance(oSsdDetails.LCRM_Sales_Org__c).Company_Code__c;  
            oRequest.customer.Companyname = IXOSCodeMap__c.getInstance(oSsdDetails.LCRM_Sales_Org__c).Company_Code__c; 
            oRequest.ESIHeader.CompanyId = KeyValueListStore__c.getInstance('ESIconfigGroup').TextValue__c;
        }
        if(oSsdDetails.LCRM_Industry__c!=null){                 
            oRequest.customer.industryCode = BigRuleGenericSettings__c.getInstance('IND:'+oSsdDetails.LCRM_Industry__c).Value__c;
        }
        if(oSsdDetails.LCRM_Customer_Group__c!=null){
            oRequest.customer.accountGroup = BigRuleGenericSettings__c.getInstance('CG:'+oSsdDetails.LCRM_Customer_Group__c).Value__c;
        }
        return oRequest;
    }
    
    /**
     * @description Helper method2 to prepare customer details
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex
    */
    public static APTS_CreateSSDJSON2Apex preparecustomerinfo2(APTS_CreateSSDJSON2Apex oRequest,Source_System_Detail__c oSsdDetails){
        Map<String,String> taxnumtypelist = new Map<String,String>();
        if(Schema.sObjectType.Latam_Tax_Number_Type__mdt.isAccessible()){
            for(Latam_Tax_Number_Type__mdt txnm : [Select MasterLabel, Tax_Number_Code__c, Tax_Number_Desc__c from Latam_Tax_Number_Type__mdt ORDER BY MasterLabel]){
                taxnumtypelist.put(txnm.Tax_Number_Desc__c,txnm.Tax_Number_Code__c);
            }
        }
        if(oSsdDetails.LCRM_Sales_Org__c == 'LLEY' || oSsdDetails.LCRM_Sales_Org__c == 'TSL'){
            oRequest.customer.jurisdictionCode=oSsdDetails.LCRM_Tax_Number__c; 
            if(oSsdDetails.LatAm_Tax_Number_Type__c!=null && !taxnumtypelist.isEmpty()){
                oRequest.customer.taxCodeType = taxnumtypelist.get(oSsdDetails.LatAm_Tax_Number_Type__c);                    
            }
            oRequest.customer.taxCode1 = oSsdDetails.LCRM_Tax_3__c;
            oRequest.customer.taxCode2 = oSsdDetails.LCRM_Tax_4__c;
        }
        return oRequest;
    }
    
    /**
     * @description Helper method3 to prepare customer details
     * @param addressObject of type APTS_CreateSSDJSON2Apex.address
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex.address
    */
    public static APTS_CreateSSDJSON2Apex.address preparecustomerinfo3(APTS_CreateSSDJSON2Apex.address addressObject,Source_System_Detail__c oSsdDetails){
        if(oSsdDetails.Number_Street__c!=null){
            addressObject.street1 = AppUtil.IsEmpty(oSsdDetails.Number_Street__c)?oSsdDetails.LCRM_PO_Box__c:oSsdDetails.Number_Street__c;  
        }
        if(!String.isEmpty(addressObject.street1) && addressObject.street1 != null && addressObject.street1.length() >35){
            addressObject.street1= addressObject.street1.substring(0, 35);
        }
        //oRequest.customer.street2 = '';
        if(!String.isEmpty(oSsdDetails.LCRM_Street_2__c) && oSsdDetails.LCRM_Street_2__c != null && oSsdDetails.LCRM_Street_2__c.length() >35){
            addressObject.street2 = oSsdDetails.LCRM_Street_2__c.substring(0, 35);
        }else{
            addressObject.street2 = oSsdDetails.LCRM_Street_2__c;
        }
        return addressObject;
    }
    
    /**
     * @description Helper method3 to prepare customer details
     * @param addressObject of type APTS_CreateSSDJSON2Apex.address
     * @param oSsdDetails of type Source_System_Detail__c
     * @return APTS_CreateSSDJSON2Apex.address
    */
    public static APTS_CreateSSDJSON2Apex.address preparecustomerinfo4(APTS_CreateSSDJSON2Apex.address addressObject,Source_System_Detail__c oSsdDetails){
        if(!String.isEmpty(oSsdDetails.LCRM_Street3__c) && oSsdDetails.LCRM_Street3__c!= null && oSsdDetails.LCRM_Street3__c.length() >35){
            addressObject.street3 = oSsdDetails.LCRM_Street3__c.substring(0, 35);
        }else{
            addressObject.street3 = oSsdDetails.LCRM_Street3__c;
        }
        //oRequest.customer.address.get(0).street4 = oSsdDetails.LCRM_Street4__c;
        if(oSsdDetails.City__c != null && oSsdDetails.City__c.length() >35){
            addressObject.city = oSsdDetails.City__c.substring(0, 35);
        }else{
            addressObject.city = oSsdDetails.City__c; 
        }
        return addressObject;
    }
}