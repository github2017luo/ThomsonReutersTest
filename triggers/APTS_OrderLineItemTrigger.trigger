trigger APTS_OrderLineItemTrigger on Apttus_Config2__OrderLineItem__c (after update) {
        APTS_OrderLineItemTriggerHandler.doAfterUpdate(trigger.new,trigger.oldMap);
}