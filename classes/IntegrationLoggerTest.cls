@isTest
public class IntegrationLoggerTest{


    static testmethod void method1(){
    Source_System_Detail__c ssd = new Source_System_Detail__c();
    Apttus_Config2__Order__c order=new Apttus_Config2__Order__c();
    insert order;
    
    Integration_Logger__c Logger1=new Integration_Logger__c();
    Logger1.Exception_Message__c='error';
     Logger1.Object_Id__c = '';
     Logger1.Object_Name__c = 'Quote/Proposal';
     Logger1.Request_Message__c = '';         
     Logger1.Request_Type__c = 'Outbound';
     Logger1.Service_Name__c = 'OrderSubmission';
     Logger1.Order__c= order.id;
     Logger1.Source_System_Detail__c= ssd.Id;
     Logger1.Success__c = true;
     
     insert Logger1;
     
     
     IntegrationLogger.addMessage( Logger1.Exception_Message__c,Logger1.Object_Id__c,Logger1.Object_Name__c, Logger1.Request_Message__c,Logger1.Request_Type__c,Logger1.Service_Name__c,Logger1.Success__c);
     
    IntegrationLogger.updateMessage(Logger1.Id, Logger1.Success__c,Logger1.Exception_Message__c);
    IntegrationLogger.TaxupdateMessage(Logger1.Id, Logger1.Success__c,Logger1.Exception_Message__c,Logger1.Request_Message__c);
    IntegrationLogger.TaxprofOCAddMessage(Logger1.Exception_Message__c,Logger1.Object_Id__c,Logger1.Object_Name__c, Logger1.Request_Message__c,Logger1.Request_Type__c,Logger1.Service_Name__c,Logger1.Success__c,'','');
    IntegrationLogger.OCAddMessage(Logger1.Exception_Message__c,Logger1.Object_Id__c,Logger1.Object_Name__c, Logger1.Request_Message__c,Logger1.Request_Type__c,Logger1.Service_Name__c,Logger1.Success__c,'','');
    IntegrationLogger.OCAddMessage(Logger1.Exception_Message__c,Logger1.Object_Id__c,Logger1.Object_Name__c, Logger1.Request_Message__c,Logger1.Request_Type__c,Logger1.Service_Name__c,Logger1.Success__c,'');
   // IntegrationLogger.createLatAmServiceStagingRecord(Logger1.Id,Logger1.Exception_Message__c,'');
    IntegrationLogger.TaxaddMessage(Logger1.Exception_Message__c,Logger1.Object_Id__c,Logger1.Object_Name__c,Logger1.Request_Message__c ,Logger1.Request_Type__c ,Logger1.Service_Name__c ,Logger1.Success__c);
    
    }

}