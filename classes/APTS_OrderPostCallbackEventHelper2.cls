/**
 * @description Helper class 2 that main object lists that needs to be updated
 */
public without sharing class APTS_OrderPostCallbackEventHelper2 {
    public List<Integration_Logger__c> loggerList = new List<Integration_Logger__c>();
    public List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
    public Map<Id,String> failurereason = new Map<Id,String>();
    public List<Id> listofprop = new List<Id>();
    public Map<String,Apttus_Config2__Order__c> orderNoToOrderMap = new Map<String,Apttus_Config2__Order__c>();
    public Map<String,Integration_Logger__c> orderNoToLoggerMap = new Map<String,Integration_Logger__c>();
    public List<Apttus_Config2__Order__c> orderListToUpdate = new List<Apttus_Config2__Order__c>();

    /**
     * @description Method to perform DML's on objects
     */
    public void performDMLS() {
        System.debug(LoggingLevel.DEBUG, 'failurereason : '+failurereason);
        try{
            if(!failurereason.isEmpty() && failurereason != null){
                
                List<Id> createdcases = new List<Id>();
                GenericCaseMgmtService casecall = new GenericCaseMgmtService();
                System.debug(LoggingLevel.Debug,'############ failurereason'+failurereason);
                createdcases = casecall.createCreditCheckCase(listofprop,failurereason);
            }
            System.debug(LoggingLevel.DEBUG, 'loggerList : '+loggerList);
            if(!orderNoToLoggerMap.isEmpty() && Schema.sObjectType.Integration_Logger__c.isCreateable() && Schema.sObjectType.Integration_Logger__c.isUpdateable()) {
                upsert orderNoToLoggerMap.values();
            }
            System.debug(LoggingLevel.DEBUG, 'orderNoToOrderMap : '+orderNoToOrderMap);
            /*if(!orderNoToOrderMap.isEmpty() && Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable()) {
                update orderNoToOrderMap.values();
                System.debug(LoggingLevel.DEBUG, 'inside orderNoToOrderMap update');
            }*/
            if(!orderListToUpdate.isEmpty() && Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable()) {
                update orderListToUpdate;
                System.debug(LoggingLevel.DEBUG, 'inside orderListToUpdate update');
            }
            performDMLSContinue();
        }catch(Exception e){
            System.debug(LoggingLevel.DEBUG, 'Exception : '+e.getStackTraceString());
        }
    }

    @testVisible
    private void performDMLSContinue(){
        System.debug(LoggingLevel.DEBUG, 'proposalList : '+proposalList);
        if(!proposalList.isEmpty() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            update proposalList;
            System.debug(LoggingLevel.DEBUG, 'inside orderNoToOrderMap update');
        }
    }
    
    /**
     * @description Method to check required fields
     * @return Boolean
     * @param orderStatusSortingMap
     * @param statusUpdate
     * @param order
     */
    public Boolean checkRequestFields(Map<String,Order_Status__c> orderStatusSortingMap, ApttusORDERSTATUSPostback.StatusUpdate statusUpdate, Apttus_Config2__Order__c order){
        Boolean flag = false;
        if(StatusUpdate==null ||  AppUtil.IsEmpty(StatusUpdate.originatingOrderNumber) || AppUtil.IsEmpty(StatusUpdate.docStatus) || orderStatusSortingMap.get(StatusUpdate.docStatus)==null || order.APTS_SAP_Status__c == orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c) {
            flag = true;
        }
        System.debug(LoggingLevel.DEBUG, 'checkRequestFields : '+flag);
        return flag;
    }

    
    /**
     * @description Method to check required fields
     * @return String
     * @param str
     */
    public String trimString(String str){
        if(str!=null && str!='' && str.length()>131072){
            str = str.reverse();str = str.substring(0,131000); str = str.reverse();
        }
        return str;
    }
}