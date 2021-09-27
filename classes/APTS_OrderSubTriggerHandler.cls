/**
 * @description APTS_OrderSubTriggerHandler handler for platform event APTS_Order_Submission__e
 */
@SuppressWarnings('PMD.CyclomaticComplexity')
public with sharing class APTS_OrderSubTriggerHandler{

    /**
     * @description HandleSubTrigger
     * @param platformEvent
     */
    public static void handleSubTrigger(List<APTS_Order_Submission__e> platformEvent){   
        try{
            List<String> loggerids = new List<String>(); 
            Map<String, APTS_Order_Submission__e> platfrommap = new Map<String, APTS_Order_Submission__e>();
            for(APTS_Order_Submission__e pl:platformEvent){
                loggerids.add(pl.JSONRecordID__c);
                platfrommap.put(pl.JSONRecordID__c,pl);
            }
            System.debug(LoggingLevel.DEBUG , 'loggerids : '+ loggerids);
            System.debug(LoggingLevel.DEBUG , 'platfrommap : '+ platfrommap);
            List<Integration_Logger__c> intLogList =new List<Integration_Logger__c>();
            if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable()){
                intLogList = [Select Id,Exception_Message__c from Integration_Logger__c where Service_Name__c ='OrderSubmission' AND ID IN: loggerids];
            }
            System.debug(LoggingLevel.DEBUG , 'intLogList before update : '+ intLogList);
            for(Integration_Logger__c intel:intLogList){
                System.debug(LoggingLevel.DEBUG , 'intel.Id : '+ intel.Id);
                if(platfrommap!= null && platfrommap.get(intel.Id) != null){
                  APTS_Order_Submission__e pl =  platfrommap.get(intel.Id);
                   intel.Exception_Message__c =((String.valueOf(intel.Exception_Message__c)==null)?'Platform Event successfully raised.\n':String.valueOf(intel.Exception_Message__c)+'\n\nPlatform Event successfully raised.\n') 
                                               +'PE ReplayId : '+String.valueOf(pl.ReplayId)+'\nApplicationID__c : '
                                               +String.valueOf(pl.ApplicationID__c)+'\nCompanyID__c : '+String.valueOf(pl.CompanyID__c)+'\nJSONRecordID__c : '
                                               +String.valueOf(pl.JSONRecordID__c)+'\nOrderNo__c : '+String.valueOf(pl.OrderNo__c);
                }
           }
           System.debug(LoggingLevel.DEBUG , 'intLogList post update : '+ intLogList);
           if(Integration_Logger__c.sObjectType.getDescribe().isUpdateable()&&intLogList!=Null){
               update intLogList;
           }
       }catch(exception e){
           System.debug(LoggingLevel.DEBUG , 'exception : '+ e.getMessage()+' : '+e.getStackTraceString());
       } 
    } 
}