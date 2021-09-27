@RestResource(urlMapping='/TRStoreOrderAction/*')
global with sharing class TRStore_OrderService {
    
    // class for the Post request parameters 
    global class TRStore_RequestClass
    {
        public string leadId;
        public string quoteId;
        public string cartId;
        public string emailID;
        public string accNumber;
        public string requestFor;
        public Boolean orderComplete;
    }

    private static map<String,String> initialize(){
        map<String,String> staticValuesMap = new Map<String,String>();
        staticValuesMap.put('PETypeLC',(Static_Values__c.getAll().containsKey('TRStorePELeadConvertCode'))?Static_Values__c.getAll().get('TRStorePELeadConvertCode').Value__c:'');
        staticValuesMap.put('PETypeOC',(Static_Values__c.getAll().containsKey('TRStorePEOrderConfirmationCode'))?Static_Values__c.getAll().get('TRStorePEOrderConfirmationCode').Value__c:'');
        staticValuesMap.put('PEmicrositeOrderCompl',(Static_Values__c.getAll().containsKey('TRStoremicrositeOrderComplete'))?Static_Values__c.getAll().get('TRStoremicrositeOrderComplete').Value__c:'');

        return staticValuesMap;
    }
    
   //public static String quoteName = '';
    @HttpPost
    global static TRStore_OrderServiceResponse getDetailsForOrderSubmission(TRStore_OrderService.TRStore_RequestClass orderReq){
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;  
        
        String quoteName = '';
        TRStore_OrderServiceResponse resp ;
        System.debug('orderReq'+orderReq);
        
        // Following code for Order Creation through Queueable class 
        resp = TRStore_OrderService.runQueueable(orderReq);
        if(orderReq.quoteId != null && orderReq.quoteId != ''){
          quoteName = linkQuoteCart(orderReq.quoteId, orderReq.cartId);
          resp.statusCode = quoteName;
        }
        if(String.isNotBlank(quoteName) && quoteName != null){
            resp.statusCode = quoteName;
        }
        return resp;   
    }

    private static TRStore_OrderService.TRStore_OrderServiceResponse runQueueable(TRStore_OrderService.TRStore_RequestClass orderReq){
        Id jobId;
        Map<String,String> staticValMap = TRStore_OrderService.initialize();
        TRStore_OrderService.TRStore_OrderServiceResponse resp;
            if(orderReq.requestFor.equalsIgnoreCase(staticValMap.get('PETypeOC'))){
                resp = TRStore_OrderService.orderJob(orderReq);
                
            }
            else if(orderReq.leadId!= null && orderReq.emailID != null && orderReq.cartId != null && orderReq.requestFor.equalsIgnoreCase(staticValMap.get('PETypeLC'))){
                    Integer snum = 1;
                    String result = String.valueOf(snum++);
                    jobId = AsyncApexJob.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result; 
                    resp = TRStore_OrderService.responseCode(jobId,'Issue on Lead Convert',null);
                
            }
            else if(orderReq.leadId!= null && orderReq.requestFor.equalsIgnoreCase(staticValMap.get('PEmicrositeOrderCompl'))){
                    database.saveresult leadresp = TRStoreLeadprocess.updateMicrositeLeadOrder( orderReq.leadId ,orderReq.orderComplete); 
                    resp = TRStore_OrderService.responseCode(null,string.valueOf(leadresp.getErrors()),leadresp);
            }
            else{
                resp = new TRStore_OrderService.TRStore_OrderServiceResponse(null, TRStore_OrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, TRStoreConstants.REQUIREDFIELDSMISSING)); 
            }
            
        return resp;
    }

    private static TRStore_OrderService.TRStore_OrderServiceResponse orderJob(TRStore_OrderService.TRStore_RequestClass orderReq){
        TRStore_OrderService.TRStore_OrderServiceResponse resp ;
        if(orderReq.leadId!= null && orderReq.quoteId != null && orderReq.cartId != null){
                         
        	Id jobId = system.enqueueJob(new TRStore_LeadConvertQueueable(orderReq.quoteId, orderReq.leadId, orderReq.cartId, orderReq.emailId, orderReq.accNumber));
            resp = TRStore_OrderService.responseCode(jobId,'Issue on Order Creation',null);
        }else{
            resp = new TRStore_OrderService.TRStore_OrderServiceResponse(null, TRStore_OrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, TRStoreConstants.REQUIREDFIELDSMISSING)); 
        }
        return resp;
    }

    private static TRStore_OrderService.TRStore_OrderServiceResponse responseCode(Id jobId, String msg, database.saveresult leadresp){
        TRStore_OrderService.TRStore_OrderServiceResponse resp ;
        if(jobId != null || leadresp.isSuccess()){
            //Call to store details in custom object 
            resp = new TRStore_OrderService.TRStore_OrderServiceResponse(jobid, TRStore_OrderService.formatStatus(TRStoreConstants.SUCCESS_STATUS, TRStoreConstants.SUCCESS_CODE, ''));
            
        }else{
            resp = new TRStore_OrderService.TRStore_OrderServiceResponse(jobid, TRStore_OrderService.formatStatus(TRStoreConstants.FAILURESTATUS, TRStoreConstants.ERROR_CODE, msg));
            
        }
        return resp;
    }

    private static Map<String,String> formatStatus(String status, String code, String msg){
        Map<String,String> statusMap = new Map<String,String>();
        statusMap.put('status',status);
        statusMap.put('statusCode',code);
        statusMap.put('statusDetail',msg);
        return statusMap;
    }
    
    
    private static String linkQuoteCart(String quoteId, String cartId){
        System.debug('quoteId'+quoteId+'cartId'+cartId);
        String resp = 'Quote Not Found';
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c (Id=cartId,Apttus_QPConfig__Proposald__c=quoteId, Apttus_Config2__BusinessObjectType__c = 'Proposal', Apttus_Config2__BusinessObjectRefId__c = quoteId,Apttus_Config2__BusinessObjectId__c=quoteId);
        Database.Update(config,false);
        
        String query = 'SELECT Id, name from Apttus_Proposal__Proposal__c limit 1';
        List<Apttus_Proposal__Proposal__c> propList = Database.query(query);
        if(!propList.isEmpty()){
            resp = propList[0].name; 
        }
        
        return resp ;
    }
    
    global class TRStore_OrderServiceResponse{
        
        public id jobId{get; set;}
        public string statusCode{get; set;}
        public string status{get;set;}
        public string statusDetail{get; set;} 
        
        global TRStore_OrderServiceResponse(id j, map<String,String> statusMap){
            jobId = j;
            status = statusMap.get('status');
            statusCode = statusMap.get('statusCode');
            statusDetail = statusMap.get('statusDetail');
        }
    }
       
}