/* 
 * Class provides web service to check envelope status when provided Docusign Envelope ID.
 * Calls DigitalDocuSignBatchStatus.UpdateEnvelopes() method to check envelope status.
 * Updates associated quote based on current envelope status in Docusign.
 *
 * Change History
 * ==============================================================================================
 * Date                                Name                    Description
 * 2018-11-16                          Benjamin Her            DLT-13461 - Initial Creation. Calls DigitalDocusignBatchStatus class.
 * 2019-02-14                          Navleen Kaur            DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-08-19                          Benjamin Her            DLT-17444 - Update SOQL query to include Is_Digital_New_Sales__c flag
 */

@RestResource(urlMapping='/digitalconfigurator/DCAcceptQuote/*')
global with sharing class DCAcceptQuote{

    //private static Final String ACCEPTED_STATUS = 'Accepted';
    private static Final String APPROVAL_STAGE_APPROVAL_REQUIRED = 'Approval Required';
    
    //acceptQuote() method
    @HttpPost
    global static DCMessage acceptQuote(string envelopeid){
        DCMessage message = new DCMessage();
        if (envelopeid == null){
            message.code = 404;
            message.cause = 'envelopeid is null';
            message.isSuccess = false;
        }
        else{
            try{
                callDocusignStatus(envelopeid);
                message.code = 200;
                message.isSuccess = true;
            }
            catch (exception e){                
                //Captures exception if process fails
                Digital_Exception_Log__c digitalexception = new Digital_Exception_Log__c();
                digitalexception.Exception_Type__c = e.getTypeName();
                digitalexception.Exception_Message__c = e.getMessage();
                digitalexception.Additional_Information__c = e.getStackTraceString();
                
                message.cause = String.valueOf(digitalexception);               
                message.code = 404;
                message.isSuccess = false;
                
                
                if(Schema.sObjectType.Digital_Exception_Log__c .isCreateable()){
                     insert digitalexception;
                 }                  
            }
        }
        System.debug('Returned Reponse:'+message); 
        return message;
    }//end of acceptQuote() method
    
    //callDocusignStatus method()
    //Queries Docusign Envelope record and calls DigitalDocuSignBatchStatus to check status.
    public static void callDocusignStatus(string envelopeid){
        
        if(!Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_DocuApi__DocuSignEnvelope__c');
        } 
        List<Apttus_DocuApi__DocuSignEnvelope__c> envelopes= [SELECT Id, Apttus_QPDSign__QuoteProposal__c, Apttus_DocuApi__EnvelopeId__c, 
                                                                Apttus_DocuApi__Status__c, APTTUS_DOCUAPI__RECALLREASON__C,
                                                                Apttus_QPDSign__QuoteProposal__r.Is_Digital_New_Sales__c,
                                                                Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c,
                                                                Apttus_QPDSign__QuoteProposal__r.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
                                                                Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact_Email__c,
                                                                Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact_Name__c FROM Apttus_DocuApi__DocuSignEnvelope__c 
                                                            WHERE Apttus_DocuApi__EnvelopeId__c =: envelopeid];
        if(envelopes == null || envelopes.isEmpty()){
            throw new DCCustomException('Query returned no record for envelope id ' + envelopeid);
        }
        
        String proposalId = envelopes[0].Apttus_QPDSign__QuoteProposal__c;
        if(proposalId != null && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()){
            List<Apttus_Proposal__Proposal_Line_Item__c> pLineItems = [Select Id
                                                                       From Apttus_Proposal__Proposal_Line_Item__c
                                                                       Where Apttus_Proposal__Proposal__c =: proposalId
                                                                       And Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c !=: APPROVAL_STAGE_APPROVAL_REQUIRED];
            // Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c 
            if(pLineItems.isEmpty()){
                throw new DCCustomException('Proposal does not have Proposal LineItems or Proposal has been moved to Approval Required stage, Proposal Id: ' + proposalId);
            }
        } else {
            throw new DCCustomException('Proposal Id is Null or User does not have access to Proposal LineItems, Proposal Id: ' + proposalId);
        }
        
        //Checks status of the envelope in Docusign and updates quote accordingly
        DigitalDocuSignBatchStatus.UpdateEnvelopes(envelopes);

    }//end of callDocusignStatus method()
}