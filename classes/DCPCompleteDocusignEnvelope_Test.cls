@isTest
public class DCPCompleteDocusignEnvelope_Test {

    @TestSetup
    private static void makeData(){
        DCPCreateDocusignEnvelope_Test.createDocusignTestData();
        
        Apttus_Proposal__Proposal__c prop = (Apttus_Proposal__Proposal__c)DCPTestDataFactory.objectToDataMap.get('Apttus_Proposal__Proposal__c');
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = prop.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;
    }

    @isTest
    private static void completeDocusignEnvelopeTest(){
        
        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        String docusignValue = DCPCompleteDocusignEnvelope.completeEnvelope('someid');
        System.assert(String.isNotBlank(docusignValue),'Assertion failed. docusignValue is blank');
        
        Test.stopTest();
    }

}