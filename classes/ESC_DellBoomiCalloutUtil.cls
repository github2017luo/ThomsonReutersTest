public without sharing class ESC_DellBoomiCalloutUtil{

    public static HTTPResponse sendS4Request(ESC_CaseFormExtensionRequestWrapper oReq,string wsName) {
        Http http = new Http();
        Httprequest req = new httprequest();
        HTTPResponse res = new HTTPResponse();
        try {
             System.debug('$$$$$$$$$$$$$$$$$$$$$$$'+oReq);
             WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(wsName);
                    
             String requestBodyStringSafe = JSON.serialize(oReq);
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"currency_x\":', '\"currency\":');
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"sort_x\":', '\"sort\":');
             System.debug('$$$$$$$$$$$$$$$$$$$$$$$ '+requestBodyStringSafe);
            
                
            String grantType = 'client_credentials';
            String contentType= 'application/x-www-form-urlencoded';
            String accessToken = ' ';
            if(!Test.isRunningTest()){
                accessToken = DellBoomiTokenGeneration.getAuthToken();
            }
                 
                    
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            req.setMethod('POST');
            req.setTimeout(120000);
            //req.setTimeout(1000);    
            req.setHeader('Authorization','Bearer '+accessToken);                
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('grant_type', grantType);
            req.setBody(requestBodyStringSafe);
            System.debug('Http request'+req); 
               
                
            /* Oauth Ends */
            
            //if(!Test.isRunningTest()){                
                res = http.send(req);
            /*}else{
                res.setStatusCode(200);
                res.setBody('{"InvoiceDetail" : {"writeOffReferenceNumber" : " ","statusDetails" : [{"statusCode" : "E","statusDescription" : "Document: 079000000095 can not be written off(payment specification)","statusMssage" : "Document: 079000000095 can not be written off(payment specification)"}]}}');
            }*/
            
            system.debug('request...'+req);
            System.debug('response from boomi...'+res);
                
                     
        }
        catch(Exception ex){    
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber());  
            ApplicationLogUtility.logException('TXP','ESC_DellBoomiCalloutUtil','sendS4Request',ex);                   
        }
        return res ;
    }
    
        public static HTTPResponse sendS4RequestAsset(ESC_AssetSubscriptionWrapper oReq,string wsName) {
        Http http = new Http();
        Httprequest req = new httprequest();
        HTTPResponse res = new HTTPResponse();
        try {
             System.debug('$$$$$$$$$$$$$$$$$$$$$$$'+oReq);
             WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(wsName);
                    
             String requestBodyStringSafe = JSON.serialize(oReq);
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"currency_x\":', '\"currency\":');
             requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"sort_x\":', '\"sort\":');
             System.debug('$$$$$$$$$$$$$$$$$$$$$$$ '+requestBodyStringSafe);
            
                
            String grantType = 'client_credentials';
            String contentType= 'application/x-www-form-urlencoded';
            String accessToken = ' ';
            if(!Test.isRunningTest()){
                accessToken = DellBoomiTokenGeneration.getAuthToken();
            }
                 
                    
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            req.setMethod('POST');
            req.setTimeout(120000);
            //req.setTimeout(1000);    
            req.setHeader('Authorization','Bearer '+accessToken);                
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('grant_type', grantType);
            req.setBody(requestBodyStringSafe);
            System.debug('Http request'+req); 
               
                
            /* Oauth Ends */
            
            //if(!Test.isRunningTest()){                
                res = http.send(req);
            /*}else{
                res.setStatusCode(200);
                res.setBody('{"InvoiceDetail" : {"writeOffReferenceNumber" : " ","statusDetails" : [{"statusCode" : "E","statusDescription" : "Document: 079000000095 can not be written off(payment specification)","statusMssage" : "Document: 079000000095 can not be written off(payment specification)"}]}}');
            }*/
            
            system.debug('request...'+req);
            System.debug('response from boomi...'+res);
                
                     
        }
        catch(Exception ex){    
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber());  
            ApplicationLogUtility.logException('TXP','ESC_DellBoomiCalloutUtil','sendS4Request',ex);                   
        }
        return res ;
    }
    public static void updateFormExtLineItem(HttpResponse resp,List<ESC_Case_Form_Extension_Line_Item__c> formExtLineItemLst,string caseId,string formId,string formName){
        boolean createReferral = false;
        string strBody = resp.getBody();
        try{
            
            ESC_CaseFormExtensionResponseWrapper res = (ESC_CaseFormExtensionResponseWrapper)System.JSON.deserialize(strBody,ESC_CaseFormExtensionResponseWrapper.class); 
            system.debug('Writeoff obj :-'+res);
            List<ESC_Case_Form_Extension_Line_Item__c> caseFormExtLIList = new List<ESC_Case_Form_Extension_Line_Item__c>();
            ESC_Case_Form_Extension_Line_Item__c cFormExtLI;
            ESC_CaseFormExtensionResponseWrapper responseWrapper = new ESC_CaseFormExtensionResponseWrapper();
            if(resp.getStatusCode() == 200){
                for(ESC_CaseFormExtensionResponseWrapper.statusDetails sDetail:res.InvoiceDetail.statusDetails){
                    
                    system.debug('sDetail' + sDetail);
                    if(sDetail.statusCode =='E' && formExtLineItemLst!=null & formExtLineItemLst.size() >0 ){
                        if(formExtLineItemLst!=null && formExtLineItemLst.size() >0)
                        
                       {
                           for(ESC_Case_Form_Extension_Line_Item__c cli:formExtLineItemLst ){
                               string lineNumber;
                               if(cli.ESC_Line__c !=null ){
                                   Integer MyInt = integer.valueOf(cli.ESC_Line__c);
                                   if(formName.containsIgnoreCase('Write Off')){
                                       lineNumber = String.valueOf(MyInt).leftPad(4,'0');
                                   }else{
                                       lineNumber = String.valueOf(MyInt).leftPad(8,'0');
                                   }
                                   
                               }
                                if(sDetail.statusDescription!=null && cli.ESC_Billing_Doc__c!=null && cli.ESC_Line__c!=null && sDetail.statusDescription.contains(cli.ESC_Billing_Doc__c) && sDetail.statusDescription.contains(System.Label.ESC_LineItemMessage+' '+lineNumber)){
                                    cFormExtLI = new ESC_Case_Form_Extension_Line_Item__c(Id = cli.Id ,ESC_Error_Message__c =sDetail.statusDescription);
                                    caseFormExtLIList.add(cFormExtLI );
                                    createReferral =true;
                                }else if(sDetail.statusDescription!=null && cli.ESC_Billing_Doc__c!=null && cli.ESC_Line__c==null && sDetail.statusDescription.contains(cli.ESC_Billing_Doc__c)){
                                    cFormExtLI = new ESC_Case_Form_Extension_Line_Item__c(Id = cli.Id ,ESC_Error_Message__c =sDetail.statusDescription);
                                    caseFormExtLIList.add(cFormExtLI );
                                    createReferral =true;
                                }
                            }
                       }
                        
                        
                    }
                    if(caseFormExtLIList.size() ==0 && (sDetail.statusCode !='S' || sDetail.statusCode=='503' || sDetail.statusCode=='504' || sDetail.statusCode=='302')){
                        
                        if(sDetail.statusCode == 'E'){
                            createReferral = true;
                        }
                        cFormExtLI = new ESC_Case_Form_Extension_Line_Item__c(Id = formExtLineItemLst[0].Id ,ESC_Error_Message__c =sDetail.statusDescription);
                        caseFormExtLIList.add(cFormExtLI );
                        break;
                    }
                    
                }
                
                    if(!createReferral){
                        List<Id> caseIds = new List<Id>();
                        if(caseId!=null && caseId!=''){
                            caseIds.add(caseId);
                        }
                        if(formName.equalsIgnoreCase('Write Off Form')){
                            createChatterPostAndCaseClose(caseIds,System.Label.ESC_WriteOffChatterMsg,true);
                        }else if (formName.equalsIgnoreCase('Write Off Exception Form')){
                             createChatterPostAndCaseClose(caseIds,System.Label.ESC_WriteOffExChatterMsg,true);
                             
                        }else if(formName.equalsIgnoreCase('Charge Cancellation')){
                            createChatterPostAndCaseClose(caseIds,System.Label.ESC_CCChatterMsg,false);
                        }
                        
                    }
                //create a referral record 
                if(caseFormExtLIList.size() >0 && createReferral ){
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseId,formId,formName);
                        obj.createReferral();
                    
                }
                        
            }else{
                cFormExtLI = new ESC_Case_Form_Extension_Line_Item__c(Id = formExtLineItemLst[0].Id ,ESC_Error_Message__c =resp.getStatus());
                                caseFormExtLIList.add(cFormExtLI );
            }
            
            if(caseFormExtLIList!=null && caseFormExtLIList.size() >0){
             if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isUpdateable()){
                 update caseFormExtLIList;
             }
                
            }
        }catch(Exception ex){
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            ApplicationLogUtility.logException('TXP','ESC_DellBoomiCalloutUtil','updateFormExtLineItem',ex);
        }
    }
    
    public static void createChatterPostAndCaseClose(List<Id> lstCaseIds,string formNameLabel,boolean isCaseClose){
    
        try{
            List<Case> lstCase = new List<Case>();
            List<case> casesToUpdate = new List<Case>();
            if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isQueryable() && lstCaseIds!=null){  
                lstCase = [Select Id,casenumber,status,recordtype.name, ownerId,USL_SAP_Account_Number__c
                                     From Case
                                     Where Id IN:lstCaseIds];
            }
            
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    
            for(Case oCase : lstCase){
                if(formNameLabel!=null && formNameLabel!=''){
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    
                    mentionSegmentInput.id = oCase.OwnerId;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);
                    
                    formNameLabel= formNameLabel.replace('XXXXX',oCase.casenumber);
                    formNameLabel= formNameLabel.replace('YYYYY',oCase.USL_SAP_Account_Number__c);
                    textSegmentInput.text = ' ' + formNameLabel;
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = oCase.Id;
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                    batchInputs.add(batchInput);
                }
                
                if(isCaseClose){
                    Case caseObj = oCase;
                    caseObj.status = 'Closed';
                      
           
            if(caseObj.recordtype.name!=''){
                if(!caseObj.recordtype.name.contains('Read Only')){
                    String recordTypeReadonly=caseObj.recordtype.name+' (Read Only)';
                    caseObj.RecordtypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeReadonly).getRecordTypeId();
                }
               
            }
            
                    casesToUpdate.add(caseObj);
                }
                
           }
           
           if(batchInputs.size() > 0){
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
           }
           if(casesToUpdate!=null && casesToUpdate.size() >0){
               if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()){ 
                    update casesToUpdate;
                   
                }
           }
        }
        catch(Exception ex)
        {
            system.debug('Error while creation of chatter post:'+ex);
            ApplicationLogUtility.logException('Tax Professionals','ESC_DellBoomiCalloutUtil','createChatterPostAndCaseClose',ex);
        }
     }
    
}