/**
* updates the ORDERSTATUSPostback sent by SAP on SFDC and returns the success
* message
*
* @author: Anshita Sharma
* @version: 2013-02-05
*/
/**
* CHANGE HISTORY
* =======================================================================
* 2013-03-06   Anshita Sharma    Created
* 2013-03-14   Anshita Sharma    Updated Order Status Mapping Values
* 2013-04-04   Sripriya Kongot   Added logging entries to Integration Logger
* 2013-04-17   Sripriya Kongot   Corrected success entry to Integration Logger & parameters
* 2013-04-23   Sripriya Kongot   Added 1 more pararmeter timestamp & TO DO remaining logic
* =======================================================================
*/
@RestResource(urlMapping='/orderpostback/*')
global class ORDERSTATUSPostback{
    //Variable to hold the integration message id for logging purposes
    public static String integrationMsgId;  
    public static String requestMsg;  
    /*
* Updates the ORDERSTATUSPostback on Salesforce
* @param OrderConfirmation list of orders sent by SAP
* @return success or failure message if the postback is updated on salesforce
*/
    @HttpPost
    global static OrderStatusPostbackResponse handleOrderStatusPostback(OrderConfirmation OrderConfirmation){
        /*Get the params from OrderConfirmation & execute the logic inside salesforce*/
        Map<String,Order_Status__c> orderStatusSortingMap = new Map<String, Order_Status__c>();
        OrderStatusPostbackResponse oOrderStatusPostbackResponse = new OrderStatusPostbackResponse();
        boolean quoteUpdate = false;
        //Create a log entry & update request parameters 
        oOrderStatusPostbackResponse.bSuccess = true;
        requestMsg = 'externalQuoteId='+OrderConfirmation.externalQuoteId+'**idocNumber='+OrderConfirmation.idocNumber+'**status='+OrderConfirmation.status+'**originatingOrderNumber='+OrderConfirmation.originatingOrderNumber+'**orderID='+OrderConfirmation.orderID+'**Timestamp='+OrderConfirmation.timestamp;
        integrationMsgId =IntegrationLogger.addMessage('', OrderConfirmation.externalQuoteId, 'Quote', requestMsg, 'Inbound','Order Status Postback',false);            
        try{
            orderStatusSortingMap = Order_Status__c.getAll();
            //check if the external quote id is not null
            if(!AppUtil.IsEmpty(OrderConfirmation.externalQuoteId)){            
                //check if IDOC number on quote is changed               
                List<Quote> listQuote = [Select Id,  Order_Processed_by__c ,SAP_IDOC_Number__c ,SAP_Order_Number__c ,status from Quote where QuoteNumber =: OrderConfirmation.externalQuoteId];
                //there will be only one record in listQuote
                if(!listQuote.isEmpty()){
                    //SAP can send  zero IDOC number 0000000000000000, hence it need to be excluded from updates
                    if(listQuote[0].SAP_IDOC_Number__c != OrderConfirmation.idocNumber && (!OrderConfirmation.idocNumber.containsOnly('0')) ){ 
                        //Update IDOC number on Quote
                        listQuote[0].SAP_IDOC_Number__c = OrderConfirmation.idocNumber;
                        quoteUpdate = true;
                        
                    }
                    if(listQuote[0].Order_Processed_by__c != OrderConfirmation.orderProcessedBy){
                        listQuote[0].Order_Processed_by__c = OrderConfirmation.orderProcessedBy;
                        quoteUpdate = true; 
                    }
                    system.debug('************');
                    if(orderStatusSortingMap.get(OrderConfirmation.status).SFDC_Order_Status__c == 'Order Completed' ){
                            listQuote[0].SAP_Order_Number__c = OrderConfirmation.orderID;
                            listQuote[0].status = 'Order Completed';
                            quoteUpdate = true; 
                    }
                    /*-----Start:SFD-1055-------*/
                    else if(orderStatusSortingMap.get(OrderConfirmation.status).SFDC_Order_Status__c == 'Order Credit Block' ){
                        listQuote[0].status = 'Order Processed - Credit Block'; 
                        listQuote[0].SAP_Order_Number__c = OrderConfirmation.orderID;
                        quoteUpdate = true;                       
                    }
                    else if(orderStatusSortingMap.get(OrderConfirmation.status).SFDC_Order_Status__c == 'Order Other Block'){
                        listQuote[0].status = 'Order Processed – Review Needed';
                        listQuote[0].SAP_Order_Number__c = OrderConfirmation.orderID;
                        quoteUpdate = true;
                    }
                    /*------End:SFD-1055--------*/
                    
                        //-----------Start: LBS-1-------
                        listQuote[0].SAP_Order_Number__c = OrderConfirmation.orderID;
                        quoteUpdate = true;
                    
                        if(orderStatusSortingMap.containsKey(OrderConfirmation.status)){
                        listQuote[0].status = orderStatusSortingMap.get(OrderConfirmation.status).MappingName__c;
                        }
                        else{
                            listQuote[0].status = OrderConfirmation.status;
                    }    
                        //-----------End: LBS-1-------
                    
                    if(quoteUpdate){
                        update listQuote[0];
                    }
                    //check if other parameters sent by SAP are not blank
                    if(!(AppUtil.IsEmpty(OrderConfirmation.orderID) && AppUtil.IsEmpty(OrderConfirmation.status) ) ){
                        List<Order__c> listOrders = [Select id,Order_Number__c, Order_Status__c, Quote__c, Ordermation_Number__c, timestamp__c from Order__c where Order_Number__c =:OrderConfirmation.orderID order by timestamp__c desc];
                        //there will be only one record in listOrders
                        if(!listOrders.isEmpty()){
                            
                            //update the Order only if status is changed and existing timestamp value is old
                            if(listOrders[0].Order_Status__c!= orderStatusSortingMap.get(OrderConfirmation.status).SFDC_Order_Status__c){
                                if(OrderConfirmation.timestamp > listOrders[0].timestamp__c){
                                    listOrders[0].Ordermation_Number__c = OrderConfirmation.originatingOrderNumber ;
                                    listOrders[0].Order_Status__c= orderStatusSortingMap.get(OrderConfirmation.status).SFDC_Order_Status__c;
                                    listOrders[0].timestamp__c = OrderConfirmation.timestamp;
                                    update listOrders[0];
                                    IntegrationLogger.updateMessage(integrationMsgId, true,'');
                                }
                            }
                        }
                        else{
                            System.Debug('Creating new order');
                            //create the order
                            Order__c oNewOrder = new Order__c();
                            oNewOrder.Order_Number__c = OrderConfirmation.orderID;
                            oNewOrder.Order_Status__c= orderStatusSortingMap.get(OrderConfirmation.status).SFDC_Order_Status__c;
                            oNewOrder.Ordermation_Number__c = OrderConfirmation.originatingOrderNumber ;
                            oNewOrder.timestamp__c = OrderConfirmation.timestamp;
                            oNewOrder.Quote__c = listQuote[0].Id;
                            insert oNewOrder;
                            IntegrationLogger.updateMessage(integrationMsgId, true,''); 
                        }
                    }
                }
                else{
                    oOrderStatusPostbackResponse.bSuccess = false;
                    oOrderStatusPostbackResponse.sError= 'The externalQuoteId does not exist in salesforce';
                    IntegrationLogger.updateMessage(integrationMsgId, false,'externalQuoteId does not exist' );
                }
            }
            else{
                oOrderStatusPostbackResponse.bSuccess = false;
                oOrderStatusPostbackResponse.sError= 'externalQuoteId is null';
                IntegrationLogger.updateMessage(integrationMsgId, false,'externalQuoteId is null' );
            }
        }
        catch(Exception ex){
            oOrderStatusPostbackResponse.bSuccess = false;
            oOrderStatusPostbackResponse.sError= ex.getMessage();
            IntegrationLogger.updateMessage(integrationMsgId, false,'Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage());
        }
        //populate and return OrderStatusPostbackResponse        
        return oOrderStatusPostbackResponse;
    }

    //ORDER object wrapper class
    global class OrderConfirmation{
        global string originatingOrderNumber;
        global string idocNumber;
        global string soldToAccount;
        global string orderID;
        global string productId;
        global string orderCancelled;
        global string status;
        global string contractNum;
        global string contractLine;
        global string deliveryDoc;
        global string deliveryDate;
        global string shipMethod;
        global string shipCarrier;
        global string trackingNum;
        global string externalQuoteId;
        global string externalUserId;
        global string timestamp ;
        global string orderProcessedBy;

    }     

    //ORDERSTATUSPostbackResponse wrapper class
    global class OrderStatusPostbackResponse{
        global boolean bSuccess;
        global string sError;
    }    
}