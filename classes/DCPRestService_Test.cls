@isTest
public class DCPRestService_Test {
    @isTest static void test1(){
         RestRequest request = new RestRequest();
        request.requestUri =
            '/services/apexrest/digital/renewal/envelope';
        String str='{"proposalId": "a4N6u00000000IK"}';
        request.httpMethod = 'put';
        request.requestBody= Blob.valueOf(str);
        RestContext.request = request;
        DCPServiceResponse response1= DCPRestService.post();
        system.assertEquals(String.isBlank(response1.response),false, 'Success');
        
    }
    
    @isTest static void test2(){
        RestRequest request = new RestRequest();
        request.requestUri =
            '/services/apexrest/digital/renewal/envelope';
        String str='{"docusignEnvelopeId":"1d855f69-3fd4-4ce0-b3a0-9667b09a3393"}';
        request.httpMethod = 'put';
        request.requestBody= Blob.valueOf(str);
        RestContext.request = request;
        DCPServiceResponse response1= DCPRestService.post();
        system.assertEquals(String.isBlank(response1.response),false, 'Success');
        
    }
    
    @isTest static void test3(){
        RestRequest request = new RestRequest();
        request.requestUri =
            '/services/apexrest/digital/renewal/envelope?docusignEnvelopeId=1d855f69-3fd4-4ce0-b3a0-9667b09a3393';
        request.httpMethod = 'get';
        RestContext.request = request;
        DCPServiceResponse response1= DCPRestService.get();
        system.assertEquals(String.isBlank(response1.response),false, 'Success');
        
    }
    
    @isTest static void test4(){
        RestRequest request = new RestRequest();
        request.requestUri =
            '/services/apexrest/digital/renewal/envelope';
        String str='{"docusignEnvelopeId":"1d855f69-3fd4-4ce0-b3a0-9667b09a3393"}';
        request.httpMethod = 'put';
        request.requestBody= Blob.valueOf(str);
        RestContext.request = request;
        DCPServiceResponse response1= DCPRestService.put();
        system.assertEquals(String.isBlank(response1.response),false, 'Success');
        
    }
}