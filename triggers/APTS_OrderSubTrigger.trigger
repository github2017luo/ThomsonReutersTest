trigger APTS_OrderSubTrigger on APTS_Order_Submission__e (after insert) {
    APTS_OrderSubTriggerHandler.handleSubTrigger(Trigger.new);
}