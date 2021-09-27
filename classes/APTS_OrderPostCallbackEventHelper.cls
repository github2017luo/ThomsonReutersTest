/**
 * @description Helper class that contains logic to handle Platform event for Order submission and Postback events for Order
 */
public without sharing class APTS_OrderPostCallbackEventHelper {
    Set<String> orderNoSet = new Set<String>();    
    //Map<String,String> orderNoToStatusUpdateMap = new Map<String,String>();    
    Map<String,Order_Status__c> orderStatusSortingMap = null;
    List<APTS_Case_Brand__mdt> caseBrandMetadata = null;

    APTS_OrderPostCallbackEventHelper2 helper2 = new APTS_OrderPostCallbackEventHelper2();

    /*  */
    /**
     * @description Method to handle Order postback event records
     * @param newObjects     
     */
    public void handleOrderPostbackEvents(APTS_Order_Postback__e[] newObjects) {
        System.debug(LoggingLevel.Debug,'inside handleOrderPostbackEvents : '+newObjects);
        loadOrderBasedOnEvents(newObjects);
        String currentTime = String.valueOf(DateTime.Now());
        for(APTS_Order_Postback__e orderPostbackCallbackEvent : newObjects) {
            Integration_Logger__c logger = helper2.orderNoToLoggerMap.get(orderPostbackCallbackEvent.OrderNo__c);
            System.debug(LoggingLevel.Debug,'logger : before : ' + logger);
            String requestMsg = (String.isNotBlank(orderPostbackCallbackEvent.OrderSubStatus__c) ? orderPostbackCallbackEvent.OrderSubStatus__c : orderPostbackCallbackEvent.PostbackJSON__c);
            if(logger == null){
                logger = addILMessage(orderPostbackCallbackEvent.OrderNo__c, ' ', false);
                logger.Exception_Message__c = ' ';
            }
            logger.Request_Message__c = logger.Request_Message__c + '\n\n' + currentTime + ':\n' + requestMsg;
            if(String.isNotBlank(orderPostbackCallbackEvent.OrderNo__c) && helper2.orderNoToOrderMap.containsKey(orderPostbackCallbackEvent.OrderNo__c)) {
                System.debug(LoggingLevel.Debug,'Got callback event for Order ' + orderPostbackCallbackEvent.OrderNo__c);

                try {                   
                    
                    Apttus_Config2__Order__c order = helper2.orderNoToOrderMap.get(orderPostbackCallbackEvent.OrderNo__c);
                    //populate Order id in logger
                    logger.Order__c = order.Id;
                    Logger.Exception_Message__c = Logger.Exception_Message__c + '\n\n' + currentTime + ':\nReplay ID : ' + orderPostbackCallbackEvent.replayID + '\nOrderNo : ' 
                                                    + orderPostbackCallbackEvent.OrderNo__c + '\nOrderSubStatus : '
                                                    + orderPostbackCallbackEvent.OrderSubStatus__c + '\nPostbackJSON : '
                                                    + orderPostbackCallbackEvent.PostbackJSON__c;
                    
                    
                    logger.Success__c = handlePostbackEvent(orderPostbackCallbackEvent, order);
                }
                catch(Exception ex) {
                    System.debug(LoggingLevel.ERROR,ex.getMessage());
                    System.debug(LoggingLevel.ERROR,ex.getStacktraceString());
                    logger.Exception_Message__c += '\n\n' + currentTime + ':\nEx Msg : '+ex.getMessage() + '\nTrace : ' + ex.getStacktraceString();
                }
                logger.Exception_Message__c = helper2.trimString(logger.Exception_Message__c);
                logger.Request_Message__c = helper2.trimString(logger.Request_Message__c);
                System.debug(LoggingLevel.Debug,'logger : after : ' + logger);
                //helper2.loggerList.add(logger);
                helper2.orderNoToLoggerMap.put(orderPostbackCallbackEvent.OrderNo__c, logger);
            }
        }
        //if(!Test.isRunningTest()){
            helper2.performDMLS();
        //}
    }

    /**
     * @description Method to perform DML's on objects
     * @param orderPostbackCallbackEvent object of APTS_Order_Postback__e
     * @param order object
     * @return boolean
     */
    private boolean handlePostbackEvent(APTS_Order_Postback__e orderPostbackCallbackEvent, Apttus_Config2__Order__c order) {
        boolean isSuccessFull = false;

        //Check if event was fired for Order submission status if field is not empty
        if(String.isNotBlank(orderPostbackCallbackEvent.OrderSubStatus__c)) {
            System.debug(LoggingLevel.Debug,'Order submission JSON Found ');
            System.debug(LoggingLevel.Debug,orderPostbackCallbackEvent.OrderSubStatus__c);
            
            isSuccessFull = handleOrderSubmission(orderPostbackCallbackEvent.OrderNo__c, order, orderPostbackCallbackEvent.OrderSubStatus__c);
        }
        //Check if event was fired for Order Postback if field is not empty
        else if(String.isNotBlank(orderPostbackCallbackEvent.PostbackJSON__c) && helper2.orderNoToOrderMap.containsKey(orderPostbackCallbackEvent.OrderNo__c)) {
            System.debug(LoggingLevel.Debug,'Order Postback JSON Found ');
            System.debug(LoggingLevel.Debug,'orderPostbackCallbackEvent.PostbackJSON__c : '+orderPostbackCallbackEvent.PostbackJSON__c);
            
            isSuccessFull = handlePostBack(orderPostbackCallbackEvent.OrderNo__c, order, orderPostbackCallbackEvent.PostbackJSON__c);                     
        }
        return isSuccessFull;
    }

    /**
     * @description Method to query orders based on Orderno's in Platform events
     * @param newObjects triggered platform events
     */
    private void loadOrderBasedOnEvents(APTS_Order_Postback__e[] newObjects) {
        for(APTS_Order_Postback__e orderPostbackCallbackEvent : newObjects) {
            if(String.isNotBlank(orderPostbackCallbackEvent.OrderNo__c)) {
                orderNoSet.add(orderPostbackCallbackEvent.OrderNo__c);
            }
        }

        System.debug(LoggingLevel.DEBUG, 'orderNoSet : '+orderNoSet);
        
        for(Apttus_Config2__Order__c order : [select Id,APTS_SAP_Status__c,
                                                IDOC__c, Apttus_Config2__Status__c,
                                                Apttus_Config2__OrderReferenceNumber__c, Apttus_Config2__OrderDate__c,
                                                Apttus_QPConfig__ProposalId__r.Name,
                                                Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c,
                                                Apttus_QPConfig__ProposalId__r.APTS_Check_COB__c,
                                                Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c,
                                                Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c
                                                from Apttus_Config2__Order__c WHERE Apttus_QPConfig__ProposalId__r.Name in :orderNoSet]) {
            helper2.orderNoToOrderMap.put(order.Apttus_QPConfig__ProposalId__r.Name, order);
        }

        for(Integration_Logger__c il : [SELECT ID, Success__c, Request_Message__c, Exception_Message__c, Order__r.Apttus_QPConfig__ProposalId__r.Name FROM Integration_Logger__c where Order__r.Apttus_QPConfig__ProposalId__r.Name IN :orderNoSet and Service_Name__c = 'Order Submission Status Postback']){
            helper2.orderNoToLoggerMap.put(il.Order__r.Apttus_QPConfig__ProposalId__r.Name, il);
        }
    }

    /**
     * @description Method to handle Order submission JSON
     * @param orderNo Order Number that is sent to Dell boomi which is Proposal Name
     * @param order Order object
     * @param jsonString Order object
     * @return boolean     
     */
    private boolean handleOrderSubmission(String orderNo, Apttus_Config2__Order__c order, String jsonString){
        //Deserialize JSON to class
        OrderSubmissionStatus orderSubmissionStatusObj = (OrderSubmissionStatus)JSON.deserialize(jsonString, OrderSubmissionStatus.class);
        System.debug(LoggingLevel.DEBUG, 'orderSubmissionStatusObj : '+orderSubmissionStatusObj);
        if(orderSubmissionStatusObj.CreateOrderResponse != null && orderSubmissionStatusObj.CreateOrderResponse.Status != null
            && String.isNotBlank(orderSubmissionStatusObj.CreateOrderResponse.Status.Code) && orderSubmissionStatusObj.CreateOrderResponse.Status.Code.equalsIgnoreCase('200')) {
            order.Apttus_Config2__Status__c='Submitted';
            helper2.orderNoToOrderMap.put(orderNo, order);
            helper2.orderListToUpdate.add(order);
            return true;
        }else if(orderSubmissionStatusObj.orderResponse != null && orderSubmissionStatusObj.orderResponse.statusDetail != null
        && String.isNotBlank(orderSubmissionStatusObj.orderResponse.statusDetail.statusCode) && orderSubmissionStatusObj.orderResponse.statusDetail.statusCode.equalsIgnoreCase('200')){
            order.Apttus_Config2__Status__c='Submitted';
            helper2.orderNoToOrderMap.put(orderNo, order);
            helper2.orderListToUpdate.add(order);
            return true;
        }
        return false;
    }

    /**
     * @description Method to handle Order Postback JSON
     * @param orderNo Order Number that is sent to Dell boomi which is Proposal Name
     * @param order Order object
     * @param jsonString Order object
     * @return boolean     
     */
    private boolean handlePostBack(String orderNo, Apttus_Config2__Order__c order, String jsonString){
        boolean response = false;
        System.debug(LoggingLevel.DEBUG, 'order : '+order);
        System.debug(LoggingLevel.DEBUG, 'jsonString : '+jsonString);
        //Deserialize JSON to class
        APTS_OrderPostCallbackEventHelper.orderStatusPostback ospostback = (APTS_OrderPostCallbackEventHelper.orderStatusPostback)JSON.deserialize(jsonString, APTS_OrderPostCallbackEventHelper.orderStatusPostback.class);
        ApttusORDERSTATUSPostback.StatusUpdate statusUpdate = ospostback.StatusUpdate;
        System.debug(LoggingLevel.DEBUG, 'statusUpdate : '+statusUpdate);
        
        if(orderStatusSortingMap == null) {
            orderStatusSortingMap = Order_Status__c.getAll();
        }
        System.debug(LoggingLevel.DEBUG, 'orderStatusSortingMap : '+orderStatusSortingMap);
        
        //if(StatusUpdate==null || AppUtil.IsEmpty(StatusUpdate.originatingOrderNumber) || AppUtil.IsEmpty(StatusUpdate.orderID) || AppUtil.IsEmpty(StatusUpdate.docStatus) || order.APTS_SAP_Status__c == orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c) {
        //    return false;
        //}
        if(helper2.checkRequestFields(orderStatusSortingMap, StatusUpdate , order)){
            return false;
        }
            
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(id =order.Apttus_QPConfig__ProposalId__r.Id);
        order.Apttus_Config2__OrderReferenceNumber__c = StatusUpdate.orderID;
        order.APTS_SAP_Status__c = orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c;

        System.debug(LoggingLevel.DEBUG, 'order.APTS_SAP_Status__c : '+order.APTS_SAP_Status__c);
        
        switch on orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c {
            when 'Order Completed' {
                order.Apttus_Config2__Status__c='Activated';
                response = true;
            }
            when 'No Inventory Available' {
                proposal.Apttus_Proposal__Approval_Stage__c='Rejected';
                helper2.proposalList.add(proposal);
                response = true;
            }
            when 'Ready for COB' {
                proposal.APTS_Check_COB__c = true;
                helper2.proposalList.add(proposal);
                response = true;
            }
            when 'Order Created'{
                order.IDOC__c=StatusUpdate.idocNumber;
                //Added for DOC-13521
                handleFailureReason(order);
                response = true;
            }
        }
        helper2.orderListToUpdate.add(order);
            
        // if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='Order Completed'){
        //     order.Apttus_Config2__Status__c='Activated';
        //     response = true;
        // }
        // //Changes added by Gowthami as part of SOC-7011 dated 21/3/2018
        // else if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='No Inventory Available'){
        //     proposal.Apttus_Proposal__Approval_Stage__c='Rejected';
        //     proposalList.add(proposal);
        //     response = true;
        // }
        // //Changes added by Sakshi as part of SOC-9388 dated 12/06/2018
        // else if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='Ready for COB'){
        //     proposal.APTS_Check_COB__c = true;
        //     proposalList.add(proposal);
        //     response = true;
        // }


        //get IDOC number from ESI-Pathra
        /*if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='Order Created'){
            order.IDOC__c=StatusUpdate.idocNumber;
            //Added for DOC-13521
            
            handleFailureReason(order);
            response = true;
        }*/
        System.debug(LoggingLevel.DEBUG, 'order : '+order);
        helper2.orderNoToOrderMap.put(orderNo, order);

        return response;
    }

    /**
     * @description Method to handle failure reason for Order based on Metadata value
     * @param order
     */
    private void handleFailureReason(Apttus_Config2__Order__c order) {
        if(caseBrandMetadata == null && Schema.sObjectType.APTS_Case_Brand__mdt.isAccessible()) {
            caseBrandMetadata = [Select MasterLabel,DeveloperName,APTS_Case_Brand_Value__c,APTS_Case_Type__c,APTS_Product_Family__c,APTS_Proposal_Business_Unit__c from APTS_Case_Brand__mdt where APTS_Case_Type__c =: 'Entitlement'];
        }

        for(APTS_Case_Brand__mdt val : caseBrandMetadata){
            if(val.APTS_Product_Family__c == order.Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c && order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c != null && val.APTS_Proposal_Business_Unit__c.contains(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c)){
                helper2.listofprop.add(order.Apttus_QPConfig__ProposalId__r.Id);
                helper2.failurereason.put(order.Apttus_QPConfig__ProposalId__r.Id,val.APTS_Case_Brand_Value__c);
                System.debug(LoggingLevel.Debug,'############ val.APTS_Case_Brand_Value__c'+val.APTS_Case_Brand_Value__c);
            }                                           
        }
    }

    /**
     * @description Method to create Integration Logger record
     * @param objectId
     * @param requestMsg
     * @param isSuccess
     * @return Integration_Logger__c     
     */
    private static Integration_Logger__c addILMessage(String objectId, String requestMsg, boolean isSuccess){
        
        Integration_Logger__c oIntegrationLogger = new Integration_Logger__c();
        oIntegrationLogger.Object_Id__c = objectId;
        oIntegrationLogger.Object_Name__c = 'Order';
        oIntegrationLogger.Request_Message__c = requestMsg;         
        oIntegrationLogger.Request_Type__c = 'Outbound';
        oIntegrationLogger.Service_Name__c = 'Order Submission Status Postback';
        oIntegrationLogger.Success__c = isSuccess;
        return oIntegrationLogger;
        
    }

    /**
     * @description 1st Level wrapper to handle Order Submission JSON
     */
    public class OrderSubmissionStatus {
        /**
         * @description Wrapper for CreateOrderResponseResponse
         * @return CreateOrderResponseResponse
         */
        public CreateOrderResponseResponse createOrderResponse {get; set;}
        /**
         * @description Wrapper for CreateOrderResponseResponse
         * @return CreateOrderResponseResponse
         */
        public orderResponse orderResponse {get; set;}
    }

    /**
     * @description 2nd Level wrapper to handle Order Submission JSON
     */
    public class CreateOrderResponseResponse {
        /**
         * @description Wrapper for StatusResponse
         * @return StatusResponse
         */
        public StatusResponse status {get; set;}
    }

    /**
     * @description 2nd Level wrapper to handle Order Submission JSON
     */
    public class OrderResponse {
        /**
         * @description Wrapper for StatusResponse
         * @return StatusResponse
         */
        public statusDetail statusDetail {get; set;}
    }

    /**
     * @description 3rd Level wrapper to handle Order Submission JSON
     */
    public class StatusResponse {
        /**
         * @description Response code for Order submission
         * @return String
         */
        public String code {get; set;}
        /**
         * @description response Description
         * @return String
         */
        public String description {get; set;}
    }

    /**
     * @description 3rd Level wrapper to handle Order Submission JSON
     */
    class StatusDetail {
        /**
         * @description Response code for Order submission
         * @return String
         */
        String statusCode {get; set;}
        /**
         * @description response Description
         * @return String
         */
        String statusDescription {get; set;}
        /**
         * @description response statusDetailMessage
         * @return String
         */
        String statusDetailMessage {get; set;}
        /**
         * @description response trackingId
         * @return String
         */
        String trackingId {get; set;}
    }
    
    @testvisible
    class OrderStatusPostback{
        @testvisible ApttusORDERSTATUSPostback.StatusUpdate statusUpdate{get; set;}
    }

    
}