/* Author- Sameeksha Sharma   
   Date- 5 August 2021
   Description- When the status of the order get submitted then this trigger will fire */

trigger ODTDG_OrderStatusUpdate_Trigger on Apttus_Config2__Order__c (after update) {
    //System.enqueueJob(new ODTDG_OrderStatusUpdate(Trigger.New, Trigger.oldMap));   
    
    ODTDG_EntitleTrialCustomerServiceHelper.sendOrderDetailsToPendo(Trigger.New, Trigger.oldMap);
}