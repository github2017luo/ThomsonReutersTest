@isTest
public class DCPViewDocusignEnvelope_Test {

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
    private static void getEnvelopeViewTest(){
        
        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new DocusignViewEnvelopeSuccess());
        
        String docusignValue = DCPViewDocusignEnvelope.getEnvelopeView('someid');
        System.assert(String.isNotBlank(docusignValue),'Assertion failed. docusignValue is blank');
        
        Test.stopTest();
    }

    /**
        @description Implments a mock response for Docusign view recipient service
     */
    public class DocusignViewEnvelopeSuccess implements HttpCalloutMock{
        /**
            @description Implments a mock response for Docusign view recipient service
            @param req Http Request
            @return Return mock response
        */
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getMethod()=='GET') { 
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"loginAccounts": [{"name": "TestAccount", "accountId": "1970775", ' +
                    '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1970775", "isDefault": "true", "userName": "Test User",' +
                    '"userId": "78f6118b-abcd-1a23-b124-60e4cd196047", "email": "test.user@tr.com", "siteDescription": ""},' +
                    '{"name": "TestAccount2", "accountId": "1234555", ' +
                    '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1234555", "isDefault": "false", "userName": "Test User 2",' +
                    '"userId": "78f6118b-abcd-1a23-b124-60e4cd196048", "email": "test.user2@tr.com", "siteDescription": ""}]}');
                res.setStatusCode(200);
                return res;
            } else {
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"url": "Some URL"}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
}