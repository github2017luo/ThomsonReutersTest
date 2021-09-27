/**
 * @description Helper class for APTS_OrderQueueToESI    
 */
public with sharing class APTS_OrderSubmissionUtilityExt3{

    /**
     * @description updateLapseDate
     * @return updateLapseDate
     * @param objOLI
     */
    public static Date updateLapseDate(Apttus_Config2__OrderLineItem__c objOLI) {
        String strSAPAgreementNumber = '';
        String strSSDId = '';
        ID accountIds;
        Date lapseDate = null;
    
        
        if (returnObjPLICheck(objOLI)) {
                strSAPAgreementNumber = objOLI.Apttus_Config2__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c;
                strSSDId = objOLI.APTS_SSD_Sold_To__c;
                accountIds = objOLI.Apttus_Config2__BillToAccountId__c;
        }
       

        Map<String, Date> mapAssetIdToRenewalDate = new Map<String, Date>();
        Map<Id, String> mapAssetToMLANumber = new Map<Id, String>();
        if (returnCheckSets(accountIds, strSSDId)) {
           
            List<Apttus_Config2__AssetLineItem__c> lstAssetLineItems = returnQueryLstAssetLineItems(accountIds, strSSDId);
            
            if (returnlstALI(lstAssetLineItems)) 
            {
                for (Apttus_Config2__AssetLineItem__c objALI : lstAssetLineItems ) {
                    mapAssetIdToRenewalDate = returnMapAssetIdToRenewalDate(objALI, strSAPAgreementNumber, mapAssetIdToRenewalDate);
                    mapAssetToMLANumber = APTS_OrderSubmissionUtilityExt4.returnMLAPLIs(objALI, mapAssetToMLANumber );
                }
            }
        }
       
        lapseDate = setDate(objOLI, mapAssetToMLANumber, mapAssetIdToRenewalDate);
        return lapseDate;
    }

    
    /**
     * @description returnObjPLICheck
     * @return returnObjPLICheck
     * @param objOLI
     */
    public static Boolean returnObjPLICheck(Apttus_Config2__OrderLineItem__c objOLI) {
        Boolean isBlnObj =false;
        if (objOLI.Apttus_Config2__ProductId__r.ProductCode != null 
            && objOLI.Apttus_Config2__AssetLineItemId__c != null 
            && objOLI.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c != null
            && objOLI.APTS_SSD_Sold_To__c != null
            && objOLI.Apttus_Config2__BillToAccountId__c != null
            && objOLI.Apttus_Config2__LineStatus__c == 'Cancelled') {
            isBlnObj =true;
        }
        return isBlnObj;
    }

    /**@description returnCheckSets
     * @return returnCheckSets
     * @param accountIds
     * @param strSSDId
     */
    public static Boolean returnCheckSets(Id accountIds, String strSSDId) {
        Boolean isBlnSet = false;
        if (accountIds != null && !String.isBlank(strSSDId)) {
                isBlnSet = true;
        }
        return isBlnSet;
    }

    /**
     * @description returnQueryLstAssetLineItems
     * @return returnQueryLstAssetLineItems
     * @param accountIds
     * @param strSSDId
     */
    public static List<Apttus_Config2__AssetLineItem__c> returnQueryLstAssetLineItems(ID accountIds, String strSSDId){
        List<Apttus_Config2__AssetLineItem__c> lstAssetLineItems = new List<Apttus_Config2__AssetLineItem__c>();
        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
            lstAssetLineItems = [Select Id, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,
                                                                        Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.Family, APTS_Info_RenewalDate__c
                                                                        from Apttus_Config2__AssetLineItem__c
                                                                        where Apttus_Config2__BillToAccountId__c =: accountIds
                                                                        AND APTS_SSD_Sold_To__c =: strSSDId];
        }
        return lstAssetLineItems;
    }


    /**@description returnlstALI
     * @return returnlstALI
     * @param lstAssetLineItems
     */
    public static Boolean returnlstALI(List<Apttus_Config2__AssetLineItem__c> lstAssetLineItems){
        Boolean islstALI = false;
        if(lstAssetLineItems != null && lstAssetLineItems.size() > 0) {
            islstALI =true;
        }
        return islstALI;
    }

    /**
     * @description returnMapAssetIdToRenewalDate
     * @return returnMapAssetIdToRenewalDate 
     * @param objALI
     * @param strSAPAgreementNumber
     * @param mapAssetIdToRenewalDate
     */
    public static Map<String, Date> returnMapAssetIdToRenewalDate(Apttus_Config2__AssetLineItem__c objALI, String strSAPAgreementNumber, Map<String, Date> mapAssetIdToRenewalDate) { 
        if (APTS_OrderSubmissionUtilityExt4.returnCLAssets(objALI) && !String.isBlank(objALI.APTS_SAP_MLA_Agreement_Number__c)) {
            mapAssetIdToRenewalDate.put(objALI.APTS_SAP_MLA_Agreement_Number__c, objALI.APTS_Info_RenewalDate__c);       
        }  else if (APTS_OrderSubmissionUtilityExt4.returnCLAssets(objALI) && String.isBlank(objALI.APTS_SAP_MLA_Agreement_Number__c)) {
            mapAssetIdToRenewalDate.put(objALI.Id, objALI.APTS_Info_RenewalDate__c);  
        }
        return mapAssetIdToRenewalDate;
    }


    /**
     * @description setDate
     * @return setDate
     * @param objOLI
     * @param mapAssetToMLANumber
     * @param mapAssetIdToRenewalDate
     */
    public static Date setDate(Apttus_Config2__OrderLineItem__c objOLI, Map<Id, String> mapAssetToMLANumber, Map<String, Date> mapAssetIdToRenewalDate){
        Date lapseDate = null;
        if (APTS_OrderSubmissionUtilityExt4.returnProfCheck(objOLI, mapAssetToMLANumber, mapAssetIdToRenewalDate)) {
                Date tempRenewalDate = mapAssetIdToRenewalDate.get(mapAssetToMLANumber.get(objOLI.Apttus_Config2__AssetLineItemId__c));
                lapseDate  = returnLapseDate(tempRenewalDate);
    
        } else if (APTS_OrderSubmissionUtilityExt4.returnCslnStandCheck(objOLI, mapAssetIdToRenewalDate)) {
                Date tempRenewalDate = mapAssetIdToRenewalDate.get(objOLI.Apttus_Config2__AssetLineItemId__c);
                lapseDate  = returnLapseDate(tempRenewalDate);
        }
        return lapseDate;
    }
    

    /**
     * @description returnLapseDate
     * @param renewalDate
     * @return date
     */
    public static Date returnLapseDate(Date renewalDate){
        Date lapseDate;
        Date tempRenewalDate = renewalDate;
        
        Integer renwlDay = tempRenewalDate.day() - 1;
        Integer renwlMonth = tempRenewalDate.month();
         
        Date dt = System.today();
        Integer currentMonth = dt.month();
        Integer currentYear = dt.year();
        Integer currentdate = dt.day();
         
        if(currentMonth > renwlMonth) {
            lapseDate = date.newInstance(currentYear+1, renwlMonth, renwlDay); 
        } else if (currentMonth == renwlMonth && renwlDay >= currentdate ) {
            lapseDate = date.newInstance(currentYear, renwlMonth, renwlDay); 
        } else if (currentMonth < renwlMonth) {
            lapseDate = date.newInstance(currentYear, renwlMonth, renwlDay); 
        } else if (currentMonth == renwlMonth && renwlDay < currentdate ){
            lapseDate = date.newInstance(currentYear+1, renwlMonth, renwlDay);
        }  
        return lapseDate;
    }

}