trigger APTS_OrderPostCallbackEventTrigger on APTS_Order_Postback__e (after insert) {
    System.debug(LoggingLevel.Debug,'APTS_OrderPostCallbackEventTrigger trigger start ');
    APTS_OrderPostCallbackEventHandler.handler(Trigger.new);
}