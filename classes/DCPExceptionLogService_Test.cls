@isTest
public class DCPExceptionLogService_Test {
	@isTest
	Private static void test1(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/digital/renewal/exceptionlog';
        req.httpMethod = 'POST';
        req.requestBody = blob.valueOf('{	"appName":"Hi1",	"className":"Hi2",	"methodName":"abc",	"ShortHeader":"This is short header",	"LongDescription":"This is long header",	"type":"Exception",	"ExceptionType":"Type Of Exception"}');
        RestContext.request = req;
        RestContext.response =res;

        DCPServiceResponse response = DCPExceptionLogService.createException();
		system.assertEquals(String.isBlank(response.response),false, 'Success');
    }
    @isTest
	Private static void test2(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/digital/renewal/exceptionlog';
        req.httpMethod = 'POST';
        req.requestBody = blob.valueOf(' ');
        RestContext.request = req;
        RestContext.response =res;

        DCPServiceResponse response = DCPExceptionLogService.createException();
		system.assertEquals(String.isBlank(response.response),false, 'Success');
    }
}