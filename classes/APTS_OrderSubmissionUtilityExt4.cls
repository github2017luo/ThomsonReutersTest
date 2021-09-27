/**
 * @description Helper class for APTS_OrderQueueToESI    
 */
public with sharing class APTS_OrderSubmissionUtilityExt4{

        /**
     * @description returnProfCheck
     * @return returnProfCheck
     * @param objOLI
     * @param mapAssetToMLANumber
     * @param mapAssetIdToRenewalDate
     */
    public static boolean returnProfCheck(Apttus_Config2__OrderLineItem__c objOLI, Map<Id, String> mapAssetToMLANumber, Map<String, Date> mapAssetIdToRenewalDate){
        Boolean isBlnCheck = false;
        if (objOLI.Apttus_Config2__ProductId__r.ProductCode != null 
            && System.Label.APTS_Proflex_Materials.contains(objOLI.Apttus_Config2__ProductId__r.ProductCode)
            && mapAssetToMLANumber != null 
            && mapAssetToMLANumber.containsKey(objOLI.Apttus_Config2__AssetLineItemId__c)
            && mapAssetIdToRenewalDate != null 
            && mapAssetIdToRenewalDate.containskey(mapAssetToMLANumber.get(objOLI.Apttus_Config2__AssetLineItemId__c))) {
                    isBlnCheck = true;
        }
        return isBlnCheck;
    }

    /**
     * @description returnCslnStandCheck
     * @return returnCslnStandCheck
     * @param objOLI
     * @param mapAssetIdToRenewalDate
     */
    public static Boolean returnCslnStandCheck(Apttus_Config2__OrderLineItem__c objOLI, Map<String, Date> mapAssetIdToRenewalDate){
        Boolean isBlnCheckCS =false;
        if (returnIsObjCheck(objOLI)
            && mapAssetIdToRenewalDate != null 
            && mapAssetIdToRenewalDate.containskey(objOLI.Apttus_Config2__AssetLineItemId__c)){
                isBlnCheckCS = true;
        }
        return isBlnCheckCS;
    }

    /**
     * @description returnIsObjCheck
     * @return returnIsObjCheck
     * @param objOLI
     */
    public static Boolean returnIsObjCheck(Apttus_Config2__OrderLineItem__c objOLI){
        Boolean isBlnCaseLine = false;
        if(objOLI.Apttus_Config2__AssetLineItemId__c != null 
            && objOLI.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' && objOLI.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='PQ'
            && (objOLI.Apttus_Config2__ProductId__r.Family != null 
            && objOLI.Apttus_Config2__ProductId__r.Family.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
                isBlnCaseLine = true;
            }
        return isBlnCaseLine;
    }
    
    /**
     * @description returnBooleanFor13PQ
     * @return returnCLAssets
     * @param objALI
     */
    public static Boolean returnCLAssets(Apttus_Config2__AssetLineItem__c objALI) { 
        Boolean blnIsCLAsset = false;
        if (objALI.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' 
            && objALI.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='PQ'
            && (objALI.Apttus_Config2__ProductId__r.Family != null 
            && objALI.Apttus_Config2__ProductId__r.Family.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
               blnIsCLAsset = true;      
        }
        return blnIsCLAsset ;
    }
    
    /**
     * @description returnMLAPLIs
     * @return returnMLAPLIs
     * @param objALI
     * @param mapAssetToMLANumber
     */
    public static Map<Id, String> returnMLAPLIs(Apttus_Config2__AssetLineItem__c objALI, Map<Id, String> mapAssetToMLANumber) { 
        if (!String.isBlank(objALI.APTS_SAP_MLA_Agreement_Number__c)) {
            mapAssetToMLANumber.put(objALI.Id, objALI.APTS_SAP_MLA_Agreement_Number__c);
        }
        return mapAssetToMLANumber;
    }
    
    /**
    * @description handleException
    * @param orderId
    * @param ex
    * @param ordersubwrap
    */
    public static void handleException(Id orderId, Exception ex, APTS_Ordersubmissionwrapper ordersubwrap){
        List<Integration_Logger__c> intLogList;
        String loggerId;
        if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
            intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId and Service_Name__c='OrderSubmission'];
        }
        if(intLogList!=null && intLogList.size()==1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,ex.getMessage()+'\n'+ex.getStackTraceString(),'');
            loggerId = intLogList[0].Id;
        }else{
            loggerId = IntegrationLogger.OCAddMessage(ex.getMessage()+'\n'+ex.getStackTraceString(),'', 'Order', '', 'Outbound','OrderSubmission',false,orderId);         
        }
        ordersubwrap.orderId = orderId;
        ordersubwrap.applicationId = '';
        ordersubwrap.isSuccess = false;
        ordersubwrap.loggerrecordId = loggerId;
        System.debug(LoggingLevel.Warn,'ordersubwrap : '+ordersubwrap);
        //return ordersubwrap;   
    } 
   
    /**
    * @description createLoggerforPE
    * @param orderId
    * @param ordreq
    * @param ordersubwrap
    */
    public static void createLoggerforPE(Id orderId, CreateOrderRequest ordreq, APTS_Ordersubmissionwrapper ordersubwrap){
        List<Integration_Logger__c> intLogList;
        String loggerId;
        String strBody = JSON.serialize(ordreq);
        if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
            intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId];
        }
        if(intLogList!=null && intLogList.size()==1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, true,'',strBody);
            loggerId = intLogList[0].Id;
        }else{
            loggerId = IntegrationLogger.OCAddMessage('','', 'Order', strBody, 'Outbound','OrderSubmission',true,orderId);         
        }
        ordersubwrap.orderId = orderId;
        ordersubwrap.orderNo = ordreq.CreateOrderRequest.OrderHeader.originatingOrderNumber;
        ordersubwrap.applicationId = ordreq.CreateOrderRequest.ESIHeader.applicationId;
        ordersubwrap.isSuccess = true;
        ordersubwrap.loggerrecordId = loggerId;
        System.debug(LoggingLevel.Warn,'ordersubwrap : '+ordersubwrap);
        //return ordersubwrap;
     }
     
     /**
     * @description 
     * @param mastercon1
     * @param ordcontact1
     * @return ordcontact1
     */
    public static CreateOrderRequest.orderContact returnOrdContact1(Customer_Master_Contacts__c mastercon1,CreateOrderRequest.orderContact ordcontact1){
        
        ordcontact1.firstName=mastercon1.First_Name__c;
        ordcontact1.lastName=mastercon1.Last_Name__c;
        ordcontact1.emailAddress=mastercon1.Email_Address__c;
        
        if(mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT' || mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT1'){
            ordcontact1.ContactType='24';
        }
        else {
            switch on mastercon1.Customer_Type_Description__c{
                when 'CLEAR PRIMARY CONT'{
                    ordcontact1.ContactType= '46';
                }
                when 'PATRON ACC TECH CONT'{
                    ordcontact1.ContactType='59';
                }
                when 'TECHNICAL CONTACT'{
                    ordcontact1.ContactType='03';
                }
                when 'ADMINISTRATOR'{
                    ordcontact1.ContactType='60';
                }
                when 'SRR MEDIA CONTACT'{
                    ordcontact1.ContactType='36';
                }
                when 'PT INTER MEDIA CONT'{
                    ordcontact1.ContactType='32';
                }
                when 'PT INTRA MEDIA CONT'{
                    ordcontact1.ContactType='33';
                }
                when 'PT SENTRY MEDIA CONT'{
                    ordcontact1.ContactType='35';
                }
                when 'COMPLIANCE LEARNING'{
                    ordcontact1.ContactType='40';
                }
                when 'Filing Contact'{
                    ordcontact1.ContactType='34';
                }
                when 'AUTO PAYMENT PROCESS'{
                    ordcontact1.ContactType='26';
                }
            }
        }

        return ordcontact1;
    }

}