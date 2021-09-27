/**
 * @description handler class methods to process records from Postback event trigger
 */
public class APTS_OrderPostCallbackEventHandler {
    /**
     * @description hanlder method to process Platform event records of after insert event
     * @param newObjects
     */
    public static void handler(APTS_Order_Postback__e[] newObjects){
        if(Trigger.isAfter && Trigger.isInsert) {
         APTS_OrderPostCallbackEventHelper helper = new APTS_OrderPostCallbackEventHelper();
           helper.handleOrderPostbackEvents(newObjects);
        }
    }
}