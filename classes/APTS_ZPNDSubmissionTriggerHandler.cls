/**
 * @description Handler class for ZPND Submission PE Trigger
 */
public without sharing class APTS_ZPNDSubmissionTriggerHandler{

    @testVisible
    static Map<String, Integration_Logger__c> loggerMap = new Map<String, Integration_Logger__c>();
           
    /**
     * @description Method handleSubTrigger
     * @param peList
     */
    public static void handleSubTrigger(List<APTS_ZPND_Submission__e> peList){   
        List<String> ssdIds = new List<String>(); 
        String currentTime = String.valueOf(DateTime.Now());
        Map<String, String> ssdToPropMap = new Map<String, String>();
        Map<String, String> ssdToOrderMap = new Map<String, String>();
        for(APTS_ZPND_Submission__e pe : peList){
            ssdIds.add(pe.SSD_ID__c);
            ssdToPropMap.put(pe.SSD_ID__c, pe.Proposal_ID__c);
            ssdToOrderMap.put(pe.SSD_ID__c, pe.Order_ID__c);
        }
        System.debug(LoggingLevel.DEBUG, 'ssdIds : '+ ssdIds);
        System.debug(LoggingLevel.DEBUG, 'ssdToPropMap : '+ ssdToPropMap);
        System.debug(LoggingLevel.DEBUG, 'ssdToOrderMap : '+ ssdToOrderMap);
        queryRecords(ssdIds);
        for(APTS_ZPND_Submission__e pe : peList) {
            Integration_Logger__c logger = loggerMap.get(pe.SSD_ID__c);
            System.debug(LoggingLevel.Debug,'logger : before : ' + logger);
            if(logger == null){
                logger = new Integration_Logger__c();
                logger.Exception_Message__c = ' ';
                logger.Service_Name__c = 'ZPND Retry';
                logger.Object_Name__c = 'Source System Detail';
                logger.Request_Type__c = 'Outbound';
                logger.Object_Id__c = pe.SSD_ID__c;
                logger.Order__c = pe.Order_ID__c;
                logger.Source_System_Detail__c = pe.SSD_ID__c;
            }

            Logger.Exception_Message__c = Logger.Exception_Message__c + '\n\n' + currentTime + ':' 
                                                + ((pe.Order_ID__c==null)?'\nZPND Initiated':'\nRetry for ZPND Initiated : ') 
                                                + ':\nReplayId : ' + pe.ReplayId 
                                                + '\nOrder_ID__c : ' + pe.Order_ID__c 
                                                + '\nProposal_ID__c : ' + pe.Proposal_ID__c 
                                                + '\nSSD_ID__c : ' + pe.SSD_ID__c;
            
            loggerMap.put(pe.SSD_ID__c, logger);
        }
        System.debug(LoggingLevel.DEBUG, 'loggerMap post update : '+ loggerMap);
        if(Integration_Logger__c.sObjectType.getDescribe().isUpdateable() && Integration_Logger__c.sObjectType.getDescribe().isCreateable() && loggerMap.size()>0){
            upsert loggerMap.values();
        }
        callSuccessZPND(ssdToPropMap, ssdToOrderMap);
    }

    @testVisible
    static void queryRecords(List<String> ssdIds){
        //List<Integration_Logger__c> intLogList =new List<Integration_Logger__c>();
        if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable()){
            for(Integration_Logger__c il : [Select Id, Exception_Message__c, Order__c, Source_System_Detail__c, 
                                                Service_Name__c, Object_Name__c, Request_Type__c, Object_Id__c                                   
                                                from Integration_Logger__c 
                                                where Service_Name__c ='ZPND Retry' AND Source_System_Detail__c IN: ssdIds]){
                loggerMap.put(il.Source_System_Detail__c, il);
            }
            System.debug(LoggingLevel.DEBUG, 'loggerMap before update : '+ loggerMap);
        }
    }

    static void raiseOrderPE(List<String> orderIDList){
        List<Apttus_Config2__Order__c> orderUpList = new List<Apttus_Config2__Order__c>();
        System.debug(LoggingLevel.DEBUG, 'orderIDList : '+ orderIDList);
        if(orderIDList!=null){
            for(Apttus_Config2__Order__c order : [SELECT ID, Retry_Count__c, APTS_Platform_Event_Triggered__c from Apttus_Config2__Order__c where ID IN :orderIDList]){
                System.debug(LoggingLevel.DEBUG, 'order : '+ order);
                if(order.APTS_Platform_Event_Triggered__c!=true){
                    orderUpList.add(order);
                }
            }
        }
        System.debug(LoggingLevel.DEBUG, 'orderUpList : '+ orderUpList);
        if(orderUpList.size()>0 && Apttus_Config2__Order__c.sObjectType.getDescribe().isUpdateable()){
            update orderUpList;
        }
    }

    /**
     * @description Method callSuccessZPND
     * @param ssdToPropMap     
     * @param ssdToOrderMap     
     */
    @future(callout=true)
    public static void callSuccessZPND(Map<String, String> ssdToPropMap, Map<String, String> ssdToOrderMap){
        String currentTime = String.valueOf(DateTime.Now());
        List<String> ssdIDList = new List<String>();
        List<String> orderIDList = new List<String>();
        ssdIDList.addAll(ssdToPropMap.keySet());
        queryRecords(ssdIDList);
        for(String str : ssdToPropMap.keySet()){
            Integration_Logger__c logger = loggerMap.get(str);
            System.debug(LoggingLevel.Debug,'logger : before : ' + logger);
            Logger.Exception_Message__c = Logger.Exception_Message__c + '\n\n' + currentTime + ':\nZPND Initiated Future.'; 
            try{
                CreateSSDCustomerFromESI.triggerCustomerCreation(str, ssdToPropMap.get(str));   
                if(ssdToOrderMap.get(str)!=null){
                    orderIDList.add(ssdToOrderMap.get(str));
                }         
            }catch(Exception e) {
                System.debug(LoggingLevel.DEBUG, 'exception : '+ e.getMessage()+' : '+e.getStackTraceString());
                logger.Exception_Message__c += '\nEx Msg : '+e.getMessage() + '\nTrace : ' + e.getStacktraceString();
            }
            loggerMap.put(str, logger);
        }
        if(Integration_Logger__c.sObjectType.getDescribe().isUpdateable() && Integration_Logger__c.sObjectType.getDescribe().isCreateable() && loggerMap.size()>0){
            upsert loggerMap.values();
        }
        raiseOrderPE(orderIDList);
    }

    
}