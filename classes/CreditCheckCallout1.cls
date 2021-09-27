/**
* @description Interface to send Credit Check to Dell Boomi
* @author  TCS
*/

public without sharing class CreditCheckCallout1{

 // @description This method sends the request and get the response from Dell Boomi for Credit Check

    public static String creditchekcallout(Id orderId){
        String serviceName = 'Order Credit Check';
        String ObjName = 'Order';
        String prevRequestMsg = '';
        String prevExcepMsg = '';
        String requestMsg = Datetime.now().format()+'\n';
        String responseMsg = Datetime.now().format()+'\n';
        Boolean isSuccess = true;
        String sapstatus;
        List<Apttus_Config2__Order__c> listOfProposals = new List<Apttus_Config2__Order__c>();
        List<Integration_Logger__c> intLogList;
        try{
            if(Schema.sObjectType.Integration_Logger__c.isAccessible()){
                intLogList=[Select Id,Request_Message__c, Exception_Message__c, Source_System_Detail__c, Order__c from Integration_Logger__c where Order__c =: orderId and Service_Name__c = :serviceName];
                if(intLogList!=null && intLogList.size()>0){
                    prevRequestMsg = intLogList[0].Request_Message__c + '\n\n';
                    prevExcepMsg = intLogList[0].Exception_Message__c + '\n\n';
                }
            }
            if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()){ 
                listOfProposals = [select Apttus_QPConfig__ProposalId__r.id from Apttus_Config2__Order__c where Id  =: orderId];
            }
            List<Id> listOfProposalIds = new List<Id>();
            List<Id> listOfcasecreationIds = new List<Id>();
            Map<Id,String> failurereason = new Map<Id,String>();
            String amt;
            for(Apttus_Config2__Order__c o : listOfProposals){
                listOfProposalIds.add(o.Apttus_QPConfig__ProposalId__r.id);
            }
            system.debug(listOfProposalIds);
            List<id> accounts = new List<id>();
            for(Apttus_Proposal__Proposal__c p : [select id,APTS_SSD_Sold_To__c,Apttus_Proposal__Approval_Stage__c,APTS_Quote_Value__c,APTS_Send_NACI_Form__c,Credit_Check_Flag__c from Apttus_Proposal__Proposal__c where id in: listOfProposalIds]){
                 accounts.add(p.APTS_SSD_Sold_To__c);
                 amt = String.valueOf(p.APTS_Quote_Value__c);
                 system.debug('accountstest'+accounts);
            }
            List<Source_System_Detail__c> accountsDetails = new List<Source_System_Detail__c>();
            if(Schema.sObjectType.Source_System_Detail__c.isAccessible()){ 
                accountsDetails = [select id,currencyIsoCode,LCRM_Credit_Exposure__c,LCRM_Credit_Limit_Amount__c,Source_System_Account_Number__c,LCRM_SAP_Account_Number__c,LCRM_Segment__c from Source_System_Detail__c where id in : accounts ];
            }
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('CreditCheck');  
            system.debug('oWebServiceSettings...'+oWebServiceSettings);
            CreditCheckSerializeandDeserializeReq smpReq = new CreditCheckSerializeandDeserializeReq(); 
            List<CreditCheckSerializeandDeserializeReq.CreditCheckRequest> smpReq2 = new List <CreditCheckSerializeandDeserializeReq.CreditCheckRequest>(); 
            CreditCheckSerializeandDeserializeReq.CreditCheckRequest creditcheck = new CreditCheckSerializeandDeserializeReq.CreditCheckRequest();
            creditcheck.account = new List<CreditCheckSerializeandDeserializeReq.Account>();
            List<CreditCheckSerializeandDeserializeReq.account> accList = new List<CreditCheckSerializeandDeserializeReq.account>();
            CreditCheckSerializeandDeserializeReq.CreditCheckInfo checkinfo= new CreditCheckSerializeandDeserializeReq.CreditCheckInfo();
            KeyValueListStore__c appId = KeyValueListStore__c.getValues('BOOMIProductId');
            checkinfo.currencyCode ='USD';
            checkinfo.amount = amt;
            smpReq.BOOMIHeader.applicationId  = appId.TextValue__c;
            smpReq.BOOMIHeader.timeStamp = String.valueof(System.now());
            checkinfo.retrievalPermission = 'true';
            for(Source_System_Detail__c ssd : accountsDetails){
                 CreditCheckSerializeandDeserializeReq.account acc1= new CreditCheckSerializeandDeserializeReq.account();
                 acc1.accountNumber = ssd.Source_System_Account_Number__c;
                 acc1.customerSegment='2000';
                 accList.add(acc1);
            }
            System.debug('accList!!!!!!!!!!'+ accList);
            creditcheck.account =accList;
            creditcheck.CreditCheckInfo =checkinfo;
            smpReq2.add(creditcheck);
            smpReq.CreditCheckRequest=smpReq2;
            string strBody = JSON.serialize(smpReq);
            system.debug('strBody...'+strBody);
            requestMsg = requestMsg + 'Request : ' + strBody;
            if(checkinfo.currencyCode == null || checkinfo.amount == null || checkinfo.retrievalPermission == null || smpReq.BOOMIHeader.applicationId == null || smpReq.BOOMIHeader.timeStamp == null || creditcheck.account[0].accountNumber == null || creditcheck.account[0].customerSegment == null){
                //IntegrationLogger.OCAddMessage('','', 'Order', 'Required Information missing', '','CreditCheck',false,orderId);  
                responseMsg = responseMsg  + 'Required Information missing : ';
                responseMsg = responseMsg  + '\ncheckinfo.currencyCode : ' + checkinfo.currencyCode;
                responseMsg = responseMsg  + '\ncheckinfo.amount : ' + checkinfo.amount;
                responseMsg = responseMsg  + '\ncheckinfo.retrievalPermission : ' + checkinfo.retrievalPermission;
                responseMsg = responseMsg  + '\nsmpReq.BOOMIHeader.applicationId : ' + smpReq.BOOMIHeader.applicationId;
                responseMsg = responseMsg  + '\nsmpReq.BOOMIHeader.timeStamp : ' + smpReq.BOOMIHeader.timeStamp;
                responseMsg = responseMsg  + '\ncreditcheck.account[0].accountNumber : ' + creditcheck.account[0].accountNumber;
                responseMsg = responseMsg  + '\ncreditcheck.account[0].customerSegment : ' + creditcheck.account[0].customerSegment;
                sapstatus = 'fail';
                isSuccess = false;
            }else{
                String requestBodyStringSafe = strBody.replaceAll('\"currency_x\":', '\"currency\":');
                requestBodyStringSafe = requestBodyStringSafe.replaceAll('\"address_x\":', '\"address\":');
                Http http;
                HttpRequest request;
                String grantType = 'client_credentials';
                String contentType= 'application/x-www-form-urlencoded';
                String accessToken;
                if(!Test.isRunningTest()){   
                    accessToken=DellBoomiTokenGeneration.getAuthToken();
                }
                else{
                    accessToken= 'DtOdJzb5sjdWBpqcvWyGTmGdRYTR';
                }
                if(accessToken!=null){
                    http = new Http();
                    request = new HttpRequest();
                }
                HttpResponse resp = new HttpResponse();
                request.setEndpoint(oWebServiceSettings.Endpoint__c);
                request.setMethod('POST');
                request.setTimeout(120000);    
                request.setHeader('Authorization','Bearer '+accessToken);
                request.setHeader('Content-Type', contentType);
                request.setHeader('grant_type', grantType);
                request.setBody(requestBodyStringSafe );
                if(!Test.isRunningTest()) {
                    resp = http.send(request);
                }
                else{
                    resp = CreditCheckMockHttpResponseGenerator.respond(request);
                }
                string strRes = resp.getBody();
                responseMsg = responseMsg + 'Reponse : ' + JSON.serialize(resp.getBody());
                system.debug('strRes..'+strRes);    
                system.debug('strRes..'+resp.getStatusCode());   
                CreditCheckSerializeandDeserializeRes.SetCCBySAPAccountResponse oCreditChk = (CreditCheckSerializeandDeserializeRes.SetCCBySAPAccountResponse) JSON.deserialize(strRes, CreditCheckSerializeandDeserializeRes.SetCCBySAPAccountResponse.class);
                system.debug('oCreditChk...'+oCreditChk);
                List<Source_System_Detail__c> updateSSDs = new List<Source_System_Detail__c>();
                List<Apttus_Proposal__Proposal__c> updateProposals = new List<Apttus_Proposal__Proposal__c>();
                List<id> propIds = new List<id>();
                List<Apttus_Config2__Order__c> updateOrder = new list<Apttus_Config2__Order__c>();
                for(Apttus_Proposal__Proposal__c p1 : [select id,SAP_Credit_Check_Status__c,Credit_Check_Description__c ,APTS_SSD_Sold_To__c,Apttus_Proposal__Approval_Stage__c,APTS_Send_NACI_Form__c,Credit_Check_Flag__c,APTS_SSD_Sold_To__r.LCRM_SAP_Account_Number__c from Apttus_Proposal__Proposal__c where id in: listOfProposalIds ]){
                    if(oCreditChk.CreditCheckResponse.creditStatus == 'Pass' || oCreditChk.CreditCheckResponse.creditStatus == 'Pending'){
                        p1.SAP_Credit_Check_Status__c = oCreditChk.CreditCheckResponse.creditStatus;
                    }
                    p1.Credit_Check_Description__c = oCreditChk.CreditCheckResponse.checkingDescription;
                    if(p1.SAP_Credit_Check_Status__c != null){  
                        if(p1.SAP_Credit_Check_Status__c.containsIgnoreCase('Credit limit')){
                            failurereason.put(p1.Id,'Insufficient Credit');
                        }else{
                            failurereason.put(p1.Id,'Credit Check');
                        }
                    }
                    updateProposals.add(p1);
                    propIds.add(p1.id);
                }
                if(updateProposals.size()>0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                    system.debug('######@@@@@@!!!!!'); 
                    update updateProposals;
                }
                for(Apttus_Config2__Order__c o : [select id,Apttus_QPConfig__ProposalId__r.SAP_Credit_Check_Status__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__r.Id from Apttus_Config2__Order__c  where Apttus_QPConfig__ProposalId__c in : propIds AND Id  =: orderId]){
                    if(o.Apttus_QPConfig__ProposalId__r.SAP_Credit_Check_Status__c=='Pass'){
                        o.APTS_SAP_Status__c = 'Credit Pass';
                    }
                    else if(o.Apttus_QPConfig__ProposalId__r.SAP_Credit_Check_Status__c=='Pending'){
                        o.APTS_SAP_Status__c = 'Order Credit Block';
                        listOfcasecreationIds.add(o.Apttus_QPConfig__ProposalId__r.Id);
                    } 
                    updateOrder.add(o);
                    sapstatus = o.APTS_SAP_Status__c; 
                    system.debug('updateOrder.size()'+updateOrder.size());
                }
                if(updateOrder.size()>0 && Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable()){
                    system.debug('######@@@@@@!!!!!updateOrder'+updateOrder); 
                    update updateOrder;
                    if(listOfcasecreationIds.size() > 0 && failurereason.size() > 0){
                        GenericCaseMgmtService casecall = new GenericCaseMgmtService();
                        List<Id> createdcases = casecall.createCreditCheckCase(listOfcasecreationIds,failurereason); 
                    }
                }    
            }
        }catch(Exception ex){
            isSuccess = false;
            responseMsg = responseMsg + 'Exception Message : '+ex.getMessage()+' \nException Trace : '+ex.getStackTraceString();
        }
        if(intLogList!=null && intLogList.size()>=1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, isSuccess, prevExcepMsg + responseMsg, prevRequestMsg + requestMsg); 
        }else{
            IntegrationLogger.OCAddMessage(responseMsg, orderId, ObjName, requestMsg, 'Outound', serviceName , isSuccess, orderId);    
        }
        return sapstatus;
    }           
}