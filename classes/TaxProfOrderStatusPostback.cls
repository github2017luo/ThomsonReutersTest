/*Created for Postback response form Boomi ffor integration of SOM and TFMS
*   
============================================================================================
Date            Name               Description
04/07/2019     Poorva Sinha        Created for TaX Proffesional Order integration postback
============================================================================================
*/

@RestResource(urlMapping='/apttustaxproforderpostback/*')
global without sharing class TaxProfOrderStatusPostback{
    static Map<String,Order_Status__c> orderStatusSortingMap;
    static String quoteId;
    static String orderId;
    static String applicationId; 
    static String timeStamp;             
    static Integer retryCount =0;
    
    @HttpPost
    global static status doPost(DellBoomiResponse orderResponse_Input){
        String requestMsgPayload = JSON.serialize(orderResponse_Input);
        system.debug('Rsponse from DellBoomi' +orderResponse_Input);
        orderStatusSortingMap = new Map<String, Order_Status__c>();       
        quoteId = orderResponse_Input.orderResponseData.orderPostBackHeader.externalQuoteId;
        orderId = orderResponse_Input.orderResponseData.orderPostBackHeader.sourceOrTargetOrderID;
        applicationId = orderResponse_Input.BOOMIHeader.applicationId;              
        timeStamp = orderResponse_Input.BOOMIHeader.timeStamp;
        status st = new status ();
        Map<String,Apttus_Config2__OrderLineItem__c> mapOrderLineItem = new Map<String,Apttus_Config2__OrderLineItem__c>();
        Apttus_Config2__Order__c order;
        
        if(!Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()){                
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        
        if(!Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        
        //Added by Kruti Shah for DOC-10571
        if(!Schema.sObjectType.Source_System_Detail__c.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            return null;
        }
        
        try{
            System.debug('Test $$$$$ '+orderId);
            system.debug('Rsponse from DellBoomi' +orderResponse_Input);
            
            orderStatusSortingMap = Order_Status__c.getAll();
            List<Apttus_Config2__OrderLineItem__c> orderLineItemList = new  List<Apttus_Config2__OrderLineItem__c>(); 
            List<Apttus_Config2__AssetLineItem__c> assetLineItemUpdateList = new List<Apttus_Config2__AssetLineItem__c>(); 
            List<Source_System_Detail__c> SSDUpdateList = new List<Source_System_Detail__c>(); //Added by Kruti Shah
            Set<ID> setOfSSD = new Set<ID>(); //Added by Kruti Shah
            order = [Select id,Name,APTS_SAP_Status__c, APTS_TFMS_Id__c, 
                     Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c,Apttus_QPConfig__ProposalId__r.Name,
                     Apttus_Config2__OrderReferenceNumber__c, Apttus_Config2__OrderDate__c, IDOC__c,
                     APTS_SSD_bill_to__c,APTS_SSD_Ship_To__c,APTS_SSD_Sold_To__c,APTS_Payer__c, //Added by Kruti Shah
                     (Select id, Name,Apttus_Config2__ActivatedDate__c,
                      APTS_Entitlement_Date__c,APTS_Entitlement_Status__c ,Apttus_Config2__Quantity__c, Apttus_Config2__OrderId__r.Name,
                      Apttus_Config2__AssetLineItemId__c,  Apttus_Config2__LineStatus__c,
                      Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__OptionId__r.ProductCode, Tax_Asset_Auto_Number__c, APTS_Contract_Number__c 
                      ,APTS_SSD_Sold_To__c  //Added by Kruti Shah                      
                      from Apttus_Config2__OrderLineItems__r) from Apttus_Config2__Order__c 
                     where Apttus_QPConfig__ProposalId__r.Name =:quoteId limit 1 FOR UPDATE]; 
            
            String status = '';
            String errMsg = '';
            Date readyForActDate;
            orderPostBackHeader orderPBH = orderResponse_Input.orderResponseData.orderPostBackHeader ;    
            
            if(order != null){
                if(applicationId == 'SF07' || applicationId == 'SF12'){             
                    if(orderPBH != null){                                                   
                        //Storing IDOC on order
                        if(orderPBH.iDocNum != null && orderPBH.iDocNum != '' && (order.IDOC__c == null || order.IDOC__c =='')){
                            order.IDOC__c = orderPBH.iDocNum;
                        }
                        
                        //Storing SAP Status on order  Added as part of DOC-7558
                        if(orderPBH.statusDetail != null && orderPBH.statusDetail.statusCode != null){ 
                            if(orderStatusSortingMap.get(orderPBH.statusDetail.statusCode.toUpperCase()) != null 
                               && order.APTS_SAP_Status__c != 'Order Completed' 
                               && order.APTS_SAP_Status__c  !='Order Failed'){                       
                                   order.APTS_SAP_Status__c =  orderStatusSortingMap.get(orderPBH.statusDetail.statusCode.toUpperCase()).SFDC_Order_Status__c;
                               } 
                            if((orderPBH.statusDetail.statusCode.toUpperCase().contains('FAILED') ||
                                orderPBH.statusDetail.statusCode.toUpperCase().contains('FAILURE')) && orderPBH.statusDetail.statusMessage != ''){
                                    errMsg = orderPBH.statusDetail.statusCode + ' - ' +orderPBH.statusDetail.statusMessage;    //will be used to log error in integration logger                        
                                } 
                        }
                        //Storing Provider Order Number on order
                        if(orderPBH.orderID != null && orderPBH.orderID != '' ){
                            order.Apttus_Config2__OrderReferenceNumber__c = orderPBH.orderID;
                        }
                        
                        //Storing TFMS ID on order
                        if(orderPBH.entitlementID != null && orderPBH.entitlementID !=''){
                            order.APTS_TFMS_Id__c = orderPBH.entitlementID;
                        }        
                    } 
                    
                    //if(errMsg != ''){
                    //    logException(errMsg,'Integration Failure ', order.Id, false);
                    //}
                    
                    for(Apttus_Config2__OrderLineItem__c ol: order.Apttus_Config2__OrderLineItems__r){
                        mapOrderLineItem.put(ol.Tax_Asset_Auto_Number__c, ol);
                    }
                    System.debug('mapOrderLineItem : '+mapOrderLineItem);
                    
                    // TFMS Entitlement Postback or Contract Postback from SOM
                    if(orderPBH.iDocNum == '' || orderPBH.iDocNum == null || (orderPBH.orderID != null && orderPBH.orderID != '')){
                        if(orderResponse_Input.orderResponseData.orderPostBackLineItem != null){
                            for(orderPostBackLineItem orderPB : orderResponse_Input.orderResponseData.orderPostBackLineItem){ 
                                if(orderPB.assetId == null || !mapOrderLineItem.containsKey(orderPB.assetId)){
                                    st.description='Asset Number  '+ orderPB.assetId + ' is invalid';
                                    st.code='404';
                                }else{
                                    //Provider Contract Postback Code - DOC-8996
                                    if(orderPB.contractNumber != null && orderPB.contractNumber != ''){
                                        mapOrderLineItem.get(orderPB.assetId).APTS_Contract_Number__c = Decimal.ValueOf(orderPB.contractNumber.trim());
                                        orderLineItemList.add(mapOrderLineItem.get(orderPB.assetId)); 
                                        
                                        if(mapOrderLineItem.get(orderPB.assetId).Apttus_Config2__AssetLineItemId__c != null){
                                            Apttus_Config2__AssetLineItem__c assetLineItem1 = New Apttus_Config2__AssetLineItem__c();
                                            assetLineItem1.Id = mapOrderLineItem.get(orderPB.assetId).Apttus_Config2__AssetLineItemId__c;                          
                                            assetLineItem1.APTS_Contract_Number__c =  Decimal.ValueOf(orderPB.contractNumber.trim());
                                            if(orderPB.poNumber != null && orderPB.poNumber != '')
                                                assetLineItem1.TAX_APTS_PO_Number__c = orderPB.poNumber;
                                            if(assetLineItem1.Id != null){
                                                assetLineItemUpdateList.add(assetLineItem1);
                                            }  
                                        }    
                                    }
                                    //Provider Contract Code Ends
                                    //Entitlement Postback Starts
                                    if(orderPB.status != null && (orderPB.status).equals('ENT_COMPLETE')){
                                        if(orderPB.accessStartDate != null){
                                            mapOrderLineItem.get(orderPB.assetId).APTS_Entitlement_Date__c = Date.valueOf(orderPB.accessStartDate);    
                                            mapOrderLineItem.get(orderPB.assetId).Apttus_Config2__ActivatedDate__c = DateTime.valueOf(orderPB.accessStartDate.replace('T',' '));
                                            status  = 'COMPLETE'; 
                                            mapOrderLineItem.get(orderPB.assetId).APTS_Entitlement_Status__c = status;
                                            orderLineItemList.add(mapOrderLineItem.get(orderPB.assetId));
                                        }   
                                        
                                        if(mapOrderLineItem.get(orderPB.assetId).Apttus_Config2__AssetLineItemId__c != null){
                                            Apttus_Config2__AssetLineItem__c assetLineItem = New Apttus_Config2__AssetLineItem__c();
                                            assetLineItem.Id = mapOrderLineItem.get(orderPB.assetId).Apttus_Config2__AssetLineItemId__c;                          
                                            assetLineItem.APTS_Entitlement_Date__c = Date.valueOf(orderPB.accessStartDate);
                                            assetLineItem.APTS_Entitlement_Status__c = status;
                                            //Added as part of DOC-10826
                                            if(orderPB.platformAccountIds != null){
                                                String platform = '',account  = '';
                                                for(platformAccountIds pfa : orderPB.platformAccountIds){
                                                    platform += pfa.platform + ',' ;
                                                    account += pfa.accountId + ',' ;
                                                }
                                                assetLineItem.APTS_Platform_Name__c = platform.removeEnd(',');
                                                assetLineItem.APTS_Platform_Account_ID__c = account.removeEnd(',');
                                            }
                                            if(assetLineItem.Id != null){
                                                assetLineItemUpdateList.add(assetLineItem);
                                            }  
                                            //Added by Kruti Shah(DOC-10571)
                                            System.debug('KS-->assetLineItem.Apttus_Config2__AssetStatus__c '+assetLineItem.Apttus_Config2__AssetStatus__c);
                                            System.debug('KS-->assetLineItem.APTS_SSD_Sold_To__r.ID '+assetLineItem.APTS_SSD_Sold_To__r.ID);
                                            if(assetLineItem.APTS_Entitlement_Status__c == 'COMPLETE'){ 
                                                /*                                          
                                                setOfSSD.add(mapOrderLineItem.get(orderPB.assetId).APTS_SSD_Sold_To__c);
                                                setOfSSD.add(mapOrderLineItem.get(orderPB.assetId).APTS_SSD_Ship_to__c);
                                                setOfSSD.add(mapOrderLineItem.get(orderPB.assetId).APTS_SSD_Bill_To__c);
                                                setOfSSD.add(mapOrderLineItem.get(orderPB.assetId).APTS_Payer_SSD__c);
                                                */
                                                setOfSSD.add(order.APTS_SSD_bill_to__c);
                                                setOfSSD.add(order.APTS_SSD_Ship_To__c);
                                                setOfSSD.add(order.APTS_SSD_Sold_To__c);
                                                setOfSSD.add(order.APTS_Payer__c);
                                            }
                                        }                                                      
                                    }
                                    //Entitlement Postback Ends
                                } 
                            }              
                        }                      
                        if(st.code !='404'){
                            if(Schema.sObjectType.Apttus_Config2__OrderLineItem__c.IsUpdateable() && orderLineItemList.size() > 0){                        
                                update orderLineItemList;
                            } 
                            if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.IsUpdateable() && assetLineItemUpdateList.size() > 0){                      
                                update assetLineItemUpdateList;    
                            } 
                            //Added by Kruti Shah(DOC-10571)
                            System.debug('KS-->setOfSSD.size() '+setOfSSD.size());
                            if(Schema.sObjectType.Source_System_Detail__c.IsUpdateable() && setOfSSD.size() > 0){  
                                for(Source_System_Detail__c objSSD : [SELECT Id,Name,APTS_Is_Customer__c
                                                                    FROM Source_System_Detail__c 
                                                                    WHERE ID in :setOfSSD])
                                    {
                                        objSSD.APTS_Is_Customer__c = true;
                                        SSDUpdateList.Add(objSSD);  
                                    }                                   
                                Update SSDUpdateList;
                            } 
                        }
                    }  
                    if(orderPBH != null && orderPBH.iDocNum != ''){
                        update order;
                    }
                    if(st.code !='404'){
                        st.description='Received Successfully by Salesforce'+orderResponse_Input;
                        st.code='202';
                        System.debug('TEST_RRRRRRRRR'+st.description); 
                    }  
                }     
            }else{
                st.description='SourceOrTargetQuoteID '+ quoteId+ ' does not exist';
                st.code='404';                
                //logException('Response : '+JSON.serialize(st), requestMsgPayload, order.Id, false);
            } 
            logException(((retryCount==0)?requestMsgPayload:'Same as previous. Retry Count : '+String.valueOf(retryCount)), ((errMsg!=null && errMsg !='')?errMsg+'\n':'')+'Response : '+JSON.serialize(st), order.Id, ((st.code=='202')?true:false));   
        }
        catch(Exception ex){
            if(retryCount <5 && (ex.getMessage().contains('The record you are attempting to edit, or one of its related records, is currently being modified by another user.')||
                                 ex.getMessage().contains('UNABLE_TO_LOCK_ROW'))){
                                     retryCount++;
                                     doPost(orderResponse_Input);
                                 }
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            st.description='Something went wrong'+ex.getMessage()+ex.getLineNumber(); 
            st.code='404';
            if(order != null){
                logException(((retryCount==0)?requestMsgPayload:'Same as previous. Retry Count : '+String.valueOf(retryCount)), 'Response : '+JSON.serialize(st), order.Id,false);
            }
        } 
        return st;
    }
    
    //Logging exceptions in case of failure from SOM Postback
    public static void logException(String requestMsgPayload, String exceptionMsg, Id orderId, Boolean status) { 
        System.debug('requestMsgPayload : '+requestMsgPayload);
        System.debug('exceptionMsg : '+exceptionMsg);
        System.debug('status : '+status);
        String serviceName = 'Order Postback';
        List<Integration_Logger__c> intLogList;
        String prevRequestMsg = '';
        String prevExcepMsg = '';
        String requestMsg = Datetime.now().format()+'\n';
        try{
            intLogList = intLogList=[Select Id, Request_Message__c, Exception_Message__c, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Order__c =:orderId and Service_Name__c = :serviceName];
            prevRequestMsg = intLogList[0].Request_Message__c + '\n\n';
            prevExcepMsg = intLogList[0].Exception_Message__c + '\n\n';
        }catch(Exception ex){
            System.debug('intLogList record not found : '+ex.getMessage()+ex.getLineNumber());
        }
        if(intLogList!=null && intLogList.size()>=1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, prevExcepMsg + requestMsg + exceptionMsg, prevRequestMsg + requestMsg + 'Request : '+requestMsgPayload); 
        }else{
            IntegrationLogger.OCAddMessage(requestMsg + exceptionMsg, '', 'Order', requestMsg + 'Request : '+requestMsgPayload, 'Inbound', serviceName , status, orderId);    
        }
    }
    
    global class DellBoomiResponse{
        global BOOMIHeader BOOMIHeader;
        global orderResponseData orderResponseData;
    }
    
    global class BOOMIHeader {
        public String applicationId;    //SF07
        public String timeStamp;    //20190528 000000.000
        
        public BOOMIHeader(){
            applicationId='';
            timeStamp='';
        } 
    }
    
    global class orderResponseData {
        public orderPostBackHeader orderPostBackHeader;
        public List<orderPostBackLineItem> orderPostBackLineItem;
    }
    
    global class orderPostBackHeader {
        public documentInfo documentInfo;
        public String externalQuoteId;  //Q-00431092
        public String iDocNum;  //3333
        public String orderID;  //202980716
        public String originatingSystem;    //SF07
        public String productId;    //123456
        public String poNumber;
        public String returnOrderNumber;    //1111
        public String sourceOrTargetOrderID;    //O-00145884
        public String sourceOrTargetQuoteID;    //Q-00431092
        public statusDetail statusDetail;
        public String trackingNumber;   //2222
        public String entitlementID; //TFMS ID
        
        public orderPostBackHeader(){
            returnOrderNumber = '';
            externalQuoteId = '';
            iDocNum ='';
            orderID ='';
            IDocNum='';
            sourceOrTargetOrderID='';
            originatingSystem='';
            sourceOrTargetQuoteID = '';
            trackingNumber = '';
            productId = '';
            poNumber ='';
            documentInfo = new documentInfo();
        }
    }
    
    global class documentInfo {
        public String documentDate; //20190522 000000.000
        public String documentNumber;   //202980716
        public String documentType; //ZNEW
    }
    
    global class statusDetail {
        public String statusCode;   //order_completed
        public String statusMessage;
        public String isEntitlementDelayed; //used in case of delayed entitlement
    }
    
    global class orderPostBackLineItem {
        public String lineReferenceNumber;  //000010
        public String materialDescription;  //LLAR CHP LAB Y SEG SOC PROF 2.0 SUB
        public String materialNumber;   //1234
        public String returnQuantity;
        public String lineNumber;
        public String actionCode;
        public String quantity;
        public String assetId;
        public String materialType;
        public String contractStartDate;
        public String contractEndDate;
        public String accessStartDate;
        public String accessEndDate;
        public String accountNumber;
        public String status;
        public String entitlementCompletionDate; //used in case of delayed entitlement
        public String isEntitlementDelayed; //used in case of delayed entitlement
        public String contractNumber;
        public String poNumber; 
        public List<platformAccountIds> platformAccountIds;
        
        public orderPostBackLineItem(){
            lineReferenceNumber='';
            materialNumber='';
            returnQuantity = '';
            materialDescription  = '';
            lineNumber='';
            actionCode='';
            quantity='';
            assetId='';
            materialType='';
            contractStartDate='';
            contractEndDate='';
            accessStartDate='';
            accessEndDate=''; 
            accountNumber='';
            status='';
            contractNumber = '';
            poNumber ='';
        }
    }
    //Added as part of DOC-10826
    global class platformAccountIds {
        public String platform;
        public String accountId;      
        public platformAccountIds(){
            platform = '';
            accountId = '';
        }
    }
    
    //variable to sent Status response from Apttus to DellBoomi.        
    global class status{
        global String description;
        global String code;
        public status()
        {
            description='';
            code='';
        }
    }
    
}