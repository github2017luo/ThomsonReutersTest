/**
* This apex class  is  responsible for logging the outbound and inbound messages under Integration Logger Object.  
* Created as part of Big Rule#1 project
* @author  Sripriya Kongot
* @version  2013-04-02
*/
/**
* CHANGE HISTORY
* ================================================================================================
* Date         Name                    Description
* 2013-04-02   Sripriya Kongot         Created 
* 2019-03-07   Vignesh Purushothaman   Added method createLatAmServiceStagingRecord for LOC-6428    
* =================================================================================================
*/
public without sharing class IntegrationLogger {
    /**
* This method is responsible for adding a new record in Integration Logger object. Each record represents 
* one incoming request or outgoing request
* This object will store the real time transactions to and from Salesforce to MiddleTier(SAP). It captures the key data request elements and any success/error codes.
*/
    public static String addMessage(String exceptionMsg, String objectId, String objectName,String requestMsg, String requestType, String serviceName,boolean isSuccess){
        try{
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c();
            oIntegrationLogger.Exception_Message__c = exceptionMsg;
            oIntegrationLogger.Object_Id__c = objectId;
            oIntegrationLogger.Object_Name__c = objectName;
            oIntegrationLogger.Request_Message__c = requestMsg;         
            oIntegrationLogger.Request_Type__c = requestType;
            oIntegrationLogger.Service_Name__c = serviceName;
            oIntegrationLogger.Success__c = isSuccess;
            insert oIntegrationLogger;
            return oIntegrationLogger.Id;
        }catch(Exception e){
            System.debug('Exception in IntegrationLogger addMessage: '+e);
        }
        return null;
    }
    
    
    
    /**
* This method is responsible for updating an existing message as per input parameters
*/
    public static void updateMessage(String msgId, boolean isSuccess, String exceptionMsg){
        try{
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c(id=msgId);
            oIntegrationLogger.Success__c = isSuccess;
            oIntegrationLogger.Exception_Message__c = exceptionMsg; 
            System.debug('oIntegrationLogger : '+oIntegrationLogger);         
            update oIntegrationLogger;
            
            /*if(CreateSSDCustomerFromESI.ServiceNowSync == true){
                createLatAmServiceStagingRecord(oIntegrationLogger.id,exceptionMsg,'');
            } */
        }catch(Exception e){
            System.debug('Exception in IntegrationLogger updateMessage: '+e);
        }
    }
    
    /*Added as part of Tax Prof OC */
    public static void TaxupdateMessage(String msgId, boolean isSuccess, String exceptionMsg, String requestMsg){
        try{
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c(id=msgId);
            oIntegrationLogger.Success__c = isSuccess;
            oIntegrationLogger.Exception_Message__c = exceptionMsg; 
           // oIntegrationLogger.Request_Message__c = requestMsg;commented by rahul
               oIntegrationLogger=assignmessage(oIntegrationLogger,requestMsg);
            System.debug('oIntegrationLogger : '+oIntegrationLogger);         
            update oIntegrationLogger;
             
           }catch(Exception e){
            System.debug('Exception in IntegrationLogger updateMessage: '+e);
        }
    }
        public static String TaxaddMessage(String exceptionMsg, String objectId, String objectName,String requestMsg, String requestType, String serviceName,boolean isSuccess){
        try{
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c();
            oIntegrationLogger.Exception_Message__c = exceptionMsg;
            oIntegrationLogger.Object_Id__c = objectId;
            oIntegrationLogger.Object_Name__c = objectName;
            oIntegrationLogger.Request_Message__c = requestMsg;         
            oIntegrationLogger.Request_Type__c = requestType;
            oIntegrationLogger.Service_Name__c = serviceName;
            oIntegrationLogger.Success__c = isSuccess;
            insert oIntegrationLogger;
            return oIntegrationLogger.Id;
        }catch(Exception e){
            System.debug('Exception in IntegrationLogger addMessage: '+e);
        }
        return null;
    }
    /*Added as part of TaxProfOC*/
        public static string TaxprofOCAddMessage(String exceptionMsg, String objectId, String objectName,String requestMsg, String requestType, String serviceName,boolean isSuccess,string QuoteID, String SSDID){
        try{
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c();
            oIntegrationLogger.Exception_Message__c = exceptionMsg;
            oIntegrationLogger.Object_Id__c = objectId;
            oIntegrationLogger.Object_Name__c = objectName;
            oIntegrationLogger.Request_Message__c = requestMsg;         
            oIntegrationLogger.Request_Type__c = requestType;
            oIntegrationLogger.Service_Name__c = serviceName;
            oIntegrationLogger.Success__c = isSuccess;
           // oIntegrationLogger.Order__c= QuoteID;
            oIntegrationLogger.Source_System_Detail__c = SSDID;
            insert oIntegrationLogger;
            return oIntegrationLogger.Id;
            
        }catch(Exception e){
            System.debug('Exception in IntegrationLogger addMessage: '+e);
        }
        
        return null;
    } 
    /* This method added as part of GLI-OC */
    
    public static string OCAddMessage(String exceptionMsg, String objectId, String objectName,String requestMsg, String requestType, String serviceName,boolean isSuccess,string OrderId){
        
        try{
            System.debug('**test');
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c();
            oIntegrationLogger.Exception_Message__c = exceptionMsg;
            oIntegrationLogger.Object_Id__c = objectId;
            oIntegrationLogger.Object_Name__c = objectName;
            //oIntegrationLogger.Request_Message__c = requestMsg;         
            oIntegrationLogger=assignmessage(oIntegrationLogger,requestMsg);
            oIntegrationLogger.Request_Type__c = requestType;
            oIntegrationLogger.Service_Name__c = serviceName;
            oIntegrationLogger.Success__c = isSuccess;
            oIntegrationLogger.Order__c= OrderId;
            insert oIntegrationLogger;
            return oIntegrationLogger.Id;
        }catch(Exception e){
            System.debug('Exception in IntegrationLogger addMessage: '+e);
        }
        return null;
        
    }
    /* This method added as part of GGO-OC */
    public static string OCAddMessage(String exceptionMsg, String objectId, String objectName,String requestMsg, String requestType, String serviceName,boolean isSuccess,string OrderId, String SSDID){
        try{
            Integration_Logger__c oIntegrationLogger = new Integration_Logger__c();
            oIntegrationLogger.Exception_Message__c = exceptionMsg;
            oIntegrationLogger.Object_Id__c = objectId;
            oIntegrationLogger.Object_Name__c = objectName;
            oIntegrationLogger.Request_Message__c = requestMsg;         
            oIntegrationLogger.Request_Type__c = requestType;
            oIntegrationLogger.Service_Name__c = serviceName;
            oIntegrationLogger.Success__c = isSuccess;
            oIntegrationLogger.Order__c= OrderId;
            oIntegrationLogger.Source_System_Detail__c = SSDID;
            insert oIntegrationLogger;
            
      /*      if(CreateSSDCustomerFromESI.ServiceNowSync == true){
                createLatAmServiceStagingRecord(oIntegrationLogger.id,exceptionMsg,SSDID);
            } 
            */
            return oIntegrationLogger.Id;
            
        }catch(Exception e){
            System.debug('Exception in IntegrationLogger addMessage: '+e);
        }
        
        return null;
    }   
    public static void createLatAmServiceStagingRecord(Id intLoggerId, String msg, String SsdId){

      /*  Boolean insertOpration= false;
        List<ESC_ServiceNow_Staging__c> snsList = [Select id, ESC_ID__c, ESC_Description__c from ESC_ServiceNow_Staging__c where ESC_ID__c=:intLoggerId Limit 1];
        Integration_Logger__c intLogger = [select id,Exception_Message__c,Source_System_Detail__c from Integration_Logger__c where Id =:intLoggerId];
        if(!snsList.isEmpty()){
            if(snsList[0].ESC_Description__c != Label.LatAm_ESC_description+ intLogger.Source_System_Detail__c +' \r\n'+
               msg){
                   insertOpration = true;
               }
            else{
                return;
            }
        }
        else{
            insertOpration = true;
        }
        try{
            if(insertOpration){
                SN_ESI_Values_del__c snesival = SN_ESI_Values_del__c.getInstance();
                if(snesival.Type__c !=null){
                    ESC_ServiceNow_Staging__c Staging = new ESC_ServiceNow_Staging__c();
                    
                    Staging.ESC_ID__c = intLoggerId;
                    Staging.ESC_Staging_Status__c = snesival.Staging_Status__c;
                    if(SsdId !=null){
                        Staging.ESC_Description__c = Label.LatAm_ESC_description+ intLogger.Source_System_Detail__c +' \r\n'+
                            msg;
                    }else{
                        Staging.ESC_Description__c =snesival.Description__c;
                    }
                    Staging.ESC_SourceSystem__c = snesival.sourceSystem__c;
                    Staging.ESC_ReportKey__c =snesival.reportKey__c+Label.LatAm_ReportKey;
                    Staging.ESC_BusinessArea__c = snesival.businessArea__c;
                    Staging.ESC_Source__c = snesival.source__c;
                    Staging.ESC_AssignmentGroup__c = snesival.assignmentGroup__c;
                    Staging.ESC_RequestType__c = 'Update';
                    Staging.ESC_SourceLink__c = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+intlogger.Source_System_Detail__c;
                    Staging.ESC_CustomerNumber__c = snesival.customerNumber__c;
                    Staging.ESC_SLA__c=snesival.SLA__c;
                    Staging.ESC_SLAJustification__c = snesival.SLAJustification__c;
                    Staging.ESC_CaseNumber__c = intlogger.Source_System_Detail__c;
                    Staging.ESC_AuditResult__c = snesival.AuditResult__c;
                    Staging.ESC_QuoteNumber__c = snesival.quoteNumber__c;
                    Staging.ESC_Feed_Comment__c=snesival.FeedComment__c;
                    Staging.ESC_SystemIdentifier__c = snesival.systemIdentifier__c;
                    Staging.ESC_Key__c = snesival.key__c;
                    insert Staging;
                }
            }
        }
         
        catch(Exception e){
            
            system.debug(e);
        }
        
     */   
        
    } 
    public static Integration_Logger__c assignmessage(Integration_Logger__c oIntegrationLogger,String requestMsg)
    {
      Boolean testrunning = Test.isRunningTest(); 
           if((requestMsg!=null && requestMsg!='' && requestMsg.length()>131072)||testrunning)
           {
                            Decimal deci = ((Decimal)requestMsg.length())/131072;
                            long reqmsg = deci.round(System.RoundingMode.UP);
                            Integer  no = Integer.valueOf(reqmsg);    
               if(testrunning)
               {
                   no = 7;
               }
                switch on no{
                    when 2 {oIntegrationLogger.Request_Message__c = requestMsg.substring(0,131072);oIntegrationLogger.Request_Message_1__c = requestMsg.substring(131072);
                    } 
                    when 3 {oIntegrationLogger.Request_Message__c = requestMsg.substring(0,131072);oIntegrationLogger.Request_Message_1__c = requestMsg.substring(131072,262144);oIntegrationLogger.Request_Message_2__c = requestMsg.substring(262144);
                    }
                    when 4 {oIntegrationLogger.Request_Message__c = requestMsg.substring(0,131072);oIntegrationLogger.Request_Message_1__c = requestMsg.substring(131072,262144);oIntegrationLogger.Request_Message_2__c = requestMsg.substring(262144,393216);oIntegrationLogger.Request_Message_3__c = requestMsg.substring(393216);
                    }
                    when 5 {oIntegrationLogger.Request_Message__c = requestMsg.substring(0,131072);oIntegrationLogger.Request_Message_1__c = requestMsg.substring(131072,262144);oIntegrationLogger.Request_Message_2__c = requestMsg.substring(262144,393216);oIntegrationLogger.Request_Message_3__c = requestMsg.substring(393216,524288);oIntegrationLogger.Request_Message_4__c = requestMsg.substring(524288);
                    }
                    when 6 {oIntegrationLogger.Request_Message__c = requestMsg.substring(0,131072);oIntegrationLogger.Request_Message_1__c = requestMsg.substring(131072,262144);oIntegrationLogger.Request_Message_2__c = requestMsg.substring(262144,393216);oIntegrationLogger.Request_Message_3__c = requestMsg.substring(393216,524288);oIntegrationLogger.Request_Message_4__c = requestMsg.substring(524288,655360);oIntegrationLogger.Request_Message_5__c = requestMsg.substring(655360);
                    }
                 }
            }
            else
            {
                 oIntegrationLogger.Request_Message__c = requestMsg;
            }
        system.debug(logginglevel.debug,'request message'+ oIntegrationLogger.Request_Message__c);
        system.debug(logginglevel.debug,'request message1'+ oIntegrationLogger.Request_Message_1__c);
        system.debug(logginglevel.debug,'request message2'+ oIntegrationLogger.Request_Message_2__c);
        system.debug(logginglevel.debug,'request message3'+ oIntegrationLogger.Request_Message_3__c);
        system.debug(logginglevel.debug,'request message4'+ oIntegrationLogger.Request_Message_4__c);
        system.debug(logginglevel.debug,'request message5'+ oIntegrationLogger.Request_Message_5__c);
        return oIntegrationLogger;
    }
}