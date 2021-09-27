trigger APTS_DigitalProductTrigger on Product_Account_Detail__c (before insert, before update) {


    APTS_DigitalProductTriggerHandler handler = new APTS_DigitalProductTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    } else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new);
    } 
   
}