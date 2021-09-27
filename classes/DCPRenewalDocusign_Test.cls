@isTest
public class DCPRenewalDocusign_Test {
    @TestSetup
    private static void makeData(){
        DCPCreateDocusignEnvelope_Test.createDocusignTestData();
    }

    @isTest
    private static void createDocusignEnvelopeTestSuccess(){
        
        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Approval_Stage__c = 'Generated' LIMIT 1];
        Map<String,String> requestBody = new Map<String,String>{'proposalId'=>prop.id};

        String docusignValue = DCPRenewalDocusign.createDocusignEnvelope(requestBody);
        System.assert(String.isNotBlank(docusignValue), 'Envelope not created');
        
        Test.stopTest();
    }
    
    @isTest
    private static void createDocusignEnvelopeTestImproperRequest(){
        
        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'proposalId'=>''};
        try{
            DCPRenewalDocusign.createDocusignEnvelope(requestBody);
        }
        catch(Exception ex){
            String errorMsg = ex.getMessage();
            System.assert(String.isNotBlank(errorMsg), 'Assertion Failed. No error message');
        }
        
        
        Test.stopTest();
    }

    @isTest
    private static void getEnvelopeViewTestSuccess(){
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = prop.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;

        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid'};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new DCPViewDocusignEnvelope_Test.DocusignViewEnvelopeSuccess());

        String docusignValue = DCPRenewalDocusign.viewDocusignEnvelope(requestBody);
        System.assert(String.isNotBlank(docusignValue),'Assertion failed. docusignValue is blank');
        
        Test.stopTest();
    }

    @isTest
    private static void getEnvelopeViewTestImproperRequest(){
        
        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>''};
        try{
            DCPRenewalDocusign.viewDocusignEnvelope(requestBody);
        }
        catch(Exception ex){
            String errorMsg = ex.getMessage();
            System.assert(String.isNotBlank(errorMsg), 'Assertion Failed. No error message');
        }
        
        
        Test.stopTest();
    }

    @isTest
    private static void updateCompleteDocusignEnvelopeTest(){
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = prop.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;

        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid','updateAction'=>'complete'};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());

        String docusignValue = DCPRenewalDocusign.updateDocusignEnvelope(requestBody);
        System.assert(String.isNotBlank(docusignValue),'Assertion failed. docusignValue is blank');
        
        Test.stopTest();
    }
    @isTest
    private static void updateVoidDocusignEnvelopeTest(){
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = prop.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;

        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid','updateAction'=>'void','voidReason'=>'Some reason'};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());

        String docusignValue = DCPRenewalDocusign.updateDocusignEnvelope(requestBody);
        System.assert(String.isNotBlank(docusignValue),'Assertion failed. docusignValue is blank');
        
        Test.stopTest();
    }
    @isTest
    private static void updateDocusignEnvelopeFailTest(){
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = prop.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;

        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid','updateAction'=>''};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        try{
            DCPRenewalDocusign.updateDocusignEnvelope(requestBody);  
        }
        catch(Exception ex){
            String errorMsg = ex.getMessage();
            System.assert(String.isNotBlank(errorMsg), 'Assertion Failed. No error message');
        }
        
        Test.stopTest();
    }
}