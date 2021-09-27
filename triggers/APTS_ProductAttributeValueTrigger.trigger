trigger APTS_ProductAttributeValueTrigger on Apttus_Config2__ProductAttributeValue__c(before insert, before update, before delete, after insert, after update, after delete) {
       System.debug('inside trigger execution');
        APTS_ProductAttributeValueTriggerHandler handler = new APTS_ProductAttributeValueTriggerHandler();
        if(Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }
        if(Trigger.isInsert && Trigger.isAfter){
            handler.OnAfterInsert(Trigger.new);
        }else if (Trigger.isUpdate && Trigger.isBefore){
            handler.OnBeforeUpdate(Trigger.new);
        } else if (Trigger.isUpdate && Trigger.isAfter){
            handler.onAfterUpdate(Trigger.new);
        } else if (Trigger.isDelete && Trigger.isBefore){
            handler.onBeforeDelete(Trigger.old);
        }
}