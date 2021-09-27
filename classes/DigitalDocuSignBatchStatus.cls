/**
 * This class is designed to be utilized as a schedulable routine which is expected to run daily or more.
 * This job creates DocuSign Envelopes for Quotes that meet specific criteria.
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-04   Brenda Shields          Created to sync DocuSign with Salesforce
 *                                      We need to change the approval status for all Digital Quotes in SFDC from "Expired" to "Denied"
 *                                      if the Envelope has been voided/denied in DocuSign
 *                                      Update Envelopes before the Quote so that the Quote trigger will have the correct Env data available
 * 2018-06-29   Brenda Shields          DLT-10717 - Remove Obsolete Items - Remove SendOnBehalfOfEmail labels and CMT
 * 2018-12-26   Bishanka Dassarma       DLT-14156 - Fix Code Scan Security Issues
 * 2019-02-15   Navleen Kaur            DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * =============================================================================
 */
global without sharing class  DigitalDocuSignBatchStatus implements  Database.AllowsCallouts, Database.Batchable<Apttus_DocuApi__DocuSignEnvelope__c>{
     
private static final string TOKEN_URL = System.label.Digital_TOKEN_URL; 
private static final string userName = System.label.Digital_UserName;
private static final string password = System.label.Digital_Password;
private static final string integrationKey = System.label.Digital_Integration_Key;

Public List<Apttus_DocuApi__DocuSignEnvelope__c> EnvelopeList = [SELECT Id, Apttus_QPDSign__QuoteProposal__c, Apttus_DocuApi__EnvelopeId__c, 
                                Apttus_DocuApi__Status__c, APTTUS_DOCUAPI__RECALLREASON__C,
                                Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
                                Apttus_QPDSign__QuoteProposal__r.Is_Digital_New_Sales__c,
                                Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c
                            FROM Apttus_DocuApi__DocuSignEnvelope__c 
                            WHERE Apttus_QPDSign__QuoteProposal__r.is_Digital_Channel__c = TRUE
                            AND Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Approval_Stage__c = 'Expired' 
                            AND Apttus_QPDSign__QuoteProposal__r.Digital_Quote_Type__c != 'Manual'
                            AND Apttus_DocuApi__Status__c = 'voided' and Apttus_DocuApi__RecallReason__c = '' 
                            order by createddate desc];

Public Static Apttus_DocuApi__DocuSignUser__c oDocuSignAccount = [SELECT Apttus_DocuApi__DocuSignAccountId__c, Apttus_DocuApi__DocuSignEmailAddress__c, Apttus_DocuApi__DocuSignUserName__c 
                            FROM Apttus_DocuApi__DocuSignUser__c where Apttus_DocuApi__Default__c = TRUE LIMIT 1];
               
    global Iterable<Apttus_DocuApi__DocuSignEnvelope__c> start(database.batchablecontext BC){
        return EnvelopeList;
    }
    
    global void execute(Database.BatchableContext BC, List<Apttus_DocuApi__DocuSignEnvelope__c> scope) {
       List<Apttus_DocuApi__DocuSignEnvelope__c> qList = new List<Apttus_DocuApi__DocuSignEnvelope__c>();
       for(Apttus_DocuApi__DocuSignEnvelope__c q : Scope){
           qList.add(q);        
       } 
        DigitalDocuSignBatchStatus.UpdateEnvelopes(qList);  
    }
    
    public static Digital_Exception_Log__c createExceptionLog(string additinformation, string classref, string exceptmessage, string excepttype, string usermessage){
        Digital_Exception_Log__c exLog = new Digital_Exception_Log__c();
        exLog.Additional_Information__c = additinformation;
        exLog.Class_Reference__c = classref;
        exLog.Exception_Message__c = exceptmessage;
        exLog.Exception_Type__c = excepttype;
        exLog.User_Message__c = usermessage;
        return exLog;
    }
       
    public static void UpdateEnvelopes(List<Apttus_DocuApi__DocuSignEnvelope__c> listEnvelopes) {
        system.debug('UPDATEME:::'+listEnvelopes);
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        list<Apttus_Proposal__Proposal__c> listToUpdate = new List<Apttus_Proposal__Proposal__c>();  
        list<Apttus_DocuApi__DocuSignEnvelope__c> listofEnvelopes = new list<Apttus_DocuApi__DocuSignEnvelope__c>();

        string sTemp;
        string sTokenURL;
        string sUserName;
        string sPassword;
        string sIntegrationKey;
        string sendonBehalfofEmail;
        String baseEnvelopeUrl;
        String createEnvelopeUrl;
        string authenticationHeader;
         
        //is this Production or a demo account 
        boolean bDemoAccount = true;
        boolean bDocuSignError = false;
        boolean bMyAccount = false;
           
        // setup default values
        sTokenURL = TOKEN_URL;
        sUserName = userName;
        sPassword = password;
        sIntegrationKey = integrationKey;
                                             
        // map to manage dynamic send on behalf of emails
        Map<String, String> mapSendEmails = new Map<String, String>();   
        Map<String, String> mapSendAuth = new Map<String, String>();
        
        // Build DocuSign credentials 
        if(WebServiceSettings__c.getInstance('Digital DocuSign Connection') != null) {      
            sTokenURL = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Endpoint__c;
            sUserName = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Username__c;
            // password contains password and integration key
            sTemp = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Password__c;
            list<string> listTemp = (sTemp.split(':'));
            sPassword = listTemp[0];
            sIntegrationKey = listTemp[1];
        } 
            
        // Build map for multiple send of behalf emails
        for(Digital_Firm_Defaults__mdt oSender : [SELECT Label, DocuSign_Send_on_Behalf_of_Email__c
                                                        FROM Digital_Firm_Defaults__mdt]) {
            mapSendEmails.put(oSender.Label, oSender.DocuSign_Send_on_Behalf_of_Email__c); 
        }
        system.debug('Dynamic Send On Behalf Of Emails: ' + mapSendEmails);
           
        // we have work to do - sign into DocuSign
        if(listEnvelopes != null && listEnvelopes.size() >0) {  
                  
            for (String firm : mapSendEmails.keySet()) {  
                // build Auth Headers
                authenticationHeader = 
                    '<DocuSignCredentials>' + 
                        '<Username>' + sUserName+ '</Username>' +
                        '<Password>' + sPassword + '</Password>' + 
                        '<IntegratorKey>' + sIntegrationKey  + '</IntegratorKey>' + 
                        '<SendOnBehalfOf>' + mapSendEmails.get(firm) + '</SendOnBehalfOf>' +
                    '</DocuSignCredentials>';                     
                
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();        

                req.setEndpoint(sTokenURL);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                req.setHeader('X-DocuSign-Authentication', authenticationHeader);
                req.setMethod('GET');

                // send request
                res = http.send(req);           
            
                if (res.getStatusCode() != 200){
                    exList.add(createExceptionLog('SFDC : WebServiceSettings__c : Digital DocuSign Connection', 'DigitalDocuSignBatchStatus > DocuSign Login Failure', 
                        res.tostring(), sTokenURL, 'Check Docusign Connection custom setting and user: ' + mapSendEmails.get(firm)));
                } else { 
                    JSONParser parser = JSON.createParser(res.getBody());
                    bMyAccount = false;
                    while (parser.nextToken() != null) {
                        if(parser.getText() == 'accountId') {
                            parser.nextToken();
                            if(parser.getText() == oDocuSignAccount.Apttus_DocuApi__DocuSignAccountId__c) {
                                bMyAccount = true;                        
                            }
                        }
                        if(parser.getText() == 'baseUrl' && bMyAccount == true) {
                            parser.nextToken();
                            baseEnvelopeUrl = parser.getText(); 
                            // is this a demo account or production
                            bDemoAccount = baseEnvelopeUrl.contains('demo');                  
                            break;
                        }
                    } // end of while loop
                    // if we found the account/url then we have a good auth header - add it to the list to use
                    if (bMyAccount == true) {
                        mapSendAuth.put(firm, authenticationHeader);
                    }
                }   // end else   
            }     // end loop
            //system.debug('Dynamic Authentications: ' + mapSendAuth);
            
            // if we don't find any users then stop process, if we find at least one user, then process as much as we can
            if (mapSendAuth.isEmpty()) {
                bDocuSignError = true;
            }           
               Map<String, String> dsFirmMap = new Map<String, String>();          
            // Process all envelopes to get current DocuSign status
            if (bDocuSignError == false) {
                 Set<String> setOfCustNumber  = new Set<String>();
                 for(Apttus_DocuApi__DocuSignEnvelope__c oEnv : listEnvelopes) {
                    setOfCustNumber.add(oEnv.Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c);
                 }
                 for(Product_Account_Detail__c prd: [SELECT ZP_Cust_Number__c,Digital_Firm__c FROM Product_Account_Detail__c 
                                                        where ZP_Cust_Number__c IN :setOfCustNumber] ){           
                    dsFirmMap.put(prd.ZP_Cust_Number__c, prd.Digital_Firm__c);
                 }
                for(Apttus_DocuApi__DocuSignEnvelope__c oEnv : listEnvelopes) {
                    system.debug('DocuSign Processing - quote: ' + oEnv.Apttus_QPDSign__QuoteProposal__c + ' envelope: ' + oEnv.Apttus_DocuApi__EnvelopeId__c + 
                             + ' Firm: ' + dsFirmMap.get(oEnv.Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c));

                    // build the end point for envelope creation
                    createEnvelopeUrl = baseEnvelopeUrl + '/envelopes/' + oEnv.Apttus_DocuApi__EnvelopeId__c;   
                    
                    // create DocuSign request 
                    // if there is no digital firm or it's not setup, use the defalut value of 'None'
                     authenticationHeader = (oEnv.Apttus_QPDSign__QuoteProposal__r.Is_Digital_New_Sales__c ? mapSendAuth.get(oEnv.Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c) : mapSendAuth.get(dsFirmMap.get(oEnv.Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c)));
                    if(authenticationHeader == null) {
                        authenticationHeader = mapSendAuth.get('None');
                
                      }            
                    HttpRequest req1 = new HttpRequest();
                    HttpResponse res1 = new HttpResponse();
                    Http http1 = new Http(); 
                    req1.setEndpoint(createEnvelopeUrl);
                    req1.setHeader('Content-Type', 'application/json');
                    req1.setHeader('Accept', 'application/json');
                    req1.setHeader('X-DocuSign-Authentication', authenticationHeader);
                    req1.setMethod('GET');
                    // send the request
                    res1= Http1.send(req1); 
        
                    if(res1.getStatusCode()!=200 && res1.getStatusCode()!=201){
                        // don't log this error for Demo accounts since DocuSign will purge the envelopes after 30 days
                        if (bDemoAccount == false) {
                            exList.add(createExceptionLog(res1.getBody(),'DigitalDocuSignBatchStatus > DocuSign Request for Envelope Status','Quote Id: ' + oEnv.Apttus_QPDSign__QuoteProposal__c + ' Envelope Id: ' + oEnv.Apttus_DocuApi__EnvelopeId__c + ' DocuSign Response: ' + res1.tostring(),createEnvelopeUrl,'DocuSign dose not contains this envelope.'));
                        }
                        system.debug('DocuSign Processing - Envelope not found in DocuSign: Quote: ' + oEnv.Apttus_QPDSign__QuoteProposal__c + ' Envelope: ' + oEnv.Apttus_DocuApi__EnvelopeId__c);

                        // Update the envelope with the voided reason - DocuSign purges envelopes older than 30 days in Demo Accounts
                        Apttus_DocuApi__DocuSignEnvelope__c UpdateEnvelope = new Apttus_DocuApi__DocuSignEnvelope__c();
                        UpdateEnvelope.Id = oEnv.Id;
                        UpdateEnvelope.APTTUS_DOCUAPI__RECALLREASON__C = 'DocuSign has Purged this Envelope from this Demo Account';
                        listofEnvelopes.add(UpdateEnvelope);
                                                
                    } else { 
                        //process Docusign reponse for the requested envelope
                        processDocusignJSON(listToUpdate, listofEnvelopes, oEnv, res1);
                    }   // end processing
               }
               system.debug('ENVELOPES UPDATED'+listofEnvelopes);
               system.debug('Proposals updated'+listToUpdate);
               // Update new Envelope records - this data needs to be saved before the Quote so the trigger will have the udpated data
               try { 
                   if(listofEnvelopes != null && listofEnvelopes.size() >0 && Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable()) {
                       Update listofEnvelopes;
                   }
               } catch(Exception exc) {
                   exList.add(createExceptionLog(string.valueOf(exc.getLineNumber()), 'DigitalDocuSignBatcgStatus > Update Envelope',exc.getMessage(), 'Envelope Update', 'Apttus_DocuApi__DocuSignEnvelope__c object not updated'));
               }                
            
               // update Quotes
               try {
                   if(listToUpdate != null && listToUpdate.size() > 0) {
                       Database.SaveResult[] srList = Database.update(listToUpdate, false);            
                       
                       for (Database.SaveResult sr : srList) {
                           if(sr.isSuccess()) {
                               System.debug('Successfully inserted Quote Proposal. ID: ' + sr.getId());
                           } else {
                               for(Database.Error err : sr.getErrors()) {
                                   exList.add(createExceptionLog(string.valueOf(err.getFields()),'DigitalDocuSignBatchStatus > Update Quote/Proposal',err.getStatusCode() + '' + err.getMessage(),'Quote Update','Quote/Proposal not udpated in SFDC, Id:'+sr.getId()));
                               }
                           }
                       }
                   }
               } catch(Exception e) {
                   exList.add(createExceptionLog(string.valueOf(e.getLineNumber()), 'DigitalDocuSignBatcgStatus > Update Quote/Proposal',e.getMessage(), 'Quote Update','Quote/Proposal not udpated in SFDC'));
               }
 
               // finish up
               try {
                   if(exlist != null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {
                       insert exList;
                   }
               } catch(Exception e) {
                   System.debug('Exception object'+e);
               }
          
           } // end of Successful login to DocuSign
        }  // end of work to do
    
    }
     
    //Internal Classes

    /*
     * processDocusignJSON() method
     * Calls different methods based on the 'status' of the Docusign envelope
     *
     */
    private static void processDocusignJSON(list<Apttus_Proposal__Proposal__c> listToUpdate, list<Apttus_DocuApi__DocuSignEnvelope__c> listofEnvelopes,Apttus_DocuApi__DocuSignEnvelope__c oEnv,HttpResponse res1){
        system.debug('ENVELOPES UPDATED1'+listofEnvelopes);
        system.debug('Proposals updated1'+listToUpdate);       
        JSONParser parser1 = JSON.createParser(res1.getBody());

        while(parser1.nextToken() != null){
            if(parser1.getText() =='status'){

                parser1.nextToken();
                //Switch Statement based on value of envelope 'status'
                system.debug('envelope status'+parser1.getText());                   
                switch on parser1.getText(){
                    when 'completed' {
                        system.debug('Accepted Proposal');
                        updateAcceptedProposals(listToUpdate, listofEnvelopes, oEnv);
                    }
                    when 'voided' {
                        system.debug('Voided Proposal');
                        updateVoidedProposals(listToUpdate, listofEnvelopes,oEnv, res1);
                    }
                }

                break;
            }

        }

        system.debug('ENVELOPES UPDATED2'+listofEnvelopes);
        system.debug('Proposals updated2'+listToUpdate);
    }//end of processDocusignJSON() method

    /*
     * updateVoidedProposals() method
     * Updates SFDC with information based on the Voided Docusign envelope
     *
     */
    private static void updateVoidedProposals(list<Apttus_Proposal__Proposal__c> listToUpdate, list<Apttus_DocuApi__DocuSignEnvelope__c> listofEnvelopes,Apttus_DocuApi__DocuSignEnvelope__c oEnv,HttpResponse res1){
        string strVoidedDate = '';
        string strVoidedReason = '';
        
        // we need to get the envelope id from the results and upadte the quote
        JSONParser parser1 = JSON.createParser(res1.getBody());
        String EnvelopeId; //docusign envelope id
        while (parser1.nextToken() != null){
            if(parser1.getText() == 'voidedDateTime'){
                parser1.nextToken();
                strVoidedDate = parser1.getText();
                }
            if(parser1.getText() == 'voidedReason'){
                parser1.nextToken();
                strVoidedReason = parser1.getText();                               
            }
            if (strVoidedDate != '' && strVoidedReason != '')
                break;
        } // end of while loop for res1
        
        system.debug('DocuSign Processing - Envelope voided in DocuSign: Quote: ' + oEnv.Apttus_QPDSign__QuoteProposal__c + ' Envelope: ' + oEnv.Apttus_DocuApi__EnvelopeId__c + 
                'Voided Date: ' + strVoidedDate + ' Voided Reason: ' + strVoidedReason);
        
        // update the quote with the correct status - Propoeals are already set as expired so we only need to udpate to Denied status
        if (strVoidedReason != '' && strVoidedReason != 'Envelope has expired.') {
            Apttus_Proposal__Proposal__c UpdatedQuote = new Apttus_Proposal__Proposal__c();
            UpdatedQuote.Id = oEnv.Apttus_QPDSign__QuoteProposal__c;
            UpdatedQuote.Apttus_Proposal__Approval_Stage__c = 'Denied';
            listToUpdate.add(UpdatedQuote);
        }
        // Update the envelope with the voided reason
        if (strVoidedReason != '') {
            Apttus_DocuApi__DocuSignEnvelope__c UpdateEnvelope = new Apttus_DocuApi__DocuSignEnvelope__c();
            UpdateEnvelope.Id = oEnv.Id;
            UpdateEnvelope.APTTUS_DOCUAPI__RECALLREASON__C = strVoidedReason;
            listofEnvelopes.add(UpdateEnvelope);
        }
    }//end of updateVoidedProposals() method

    /*
     * processDocusignJSON() method
     * Updates SFDC with information based on the Accepted Docusign envelope
     *
     */
    private static void updateAcceptedProposals(list<Apttus_Proposal__Proposal__c> listToUpdate, list<Apttus_DocuApi__DocuSignEnvelope__c> listofEnvelopes,Apttus_DocuApi__DocuSignEnvelope__c oEnv){
        
             Apttus_Proposal__Proposal__c UpdatedQuote = new Apttus_Proposal__Proposal__c();
            UpdatedQuote.Id = oEnv.Apttus_QPDSign__QuoteProposal__c;
            UpdatedQuote.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            listToUpdate.add(UpdatedQuote);       

            Apttus_DocuApi__DocuSignEnvelope__c UpdateEnvelope = new Apttus_DocuApi__DocuSignEnvelope__c();
            UpdateEnvelope.Id = oEnv.Id;
            UpdateEnvelope.Apttus_DocuApi__Status__c  = 'completed';
            listofEnvelopes.add(UpdateEnvelope);
    }//end of updateAcceptedProposals() method

    public class DigitalDocuSignBatchStatusException extends Exception {}
    
    global void finish(Database.BatchableContext info) {
        // when this job finishes, schedule it to run again every 6 hours
        // job, name, interval, scope
        if(!test.isRunningTest()) system.scheduleBatch(New DigitalDocuSignBatchStatus(),
                'DigitalDocuSignBatchStatus Next 6 hours', 360, 15);
        
    }
    
}