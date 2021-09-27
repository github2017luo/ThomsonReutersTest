/**
 * @description ESC_IXOSHanaMockResponse 
 */
@IsTest(SeeAllData=false)
public class ESC_IXOSHanaMockResponse implements HttpCalloutMock{
      /**
 * @description ESC_IXOSHanaMockResponse
 
 * */
      public ESC_IXOSHanaMockResponse (){
         System.debug(LoggingLevel.DEBUG,'ESC_IXOSHanaMockResponse  constructor called');
     }
    
  /**
 * @description respond
 * @return HTTPResponse
 * @param req
 */
    public HTTPResponse respond(HTTPRequest req) {
        
         String jSONResponse = '{'+
                '      \"getDocumentDetailsResponse\" : {'+
        '        \"documentDetails\" : [ {'+
        '         \"documentHeader\" : {'+
              '         \"account\" : {'+
              '          \"accountNumber\" :  \"2000000246\",'+
             '          \"companyId\" :  \"1078\"'+
             
             '},'+
             '          \"documentNumber\" :  \"80000001556\",'+
             '        \"documentType\" : [\"ZI\"],'+
             '          \"documentUrl\" :  \"test\",'+
             '          \"billPeriod\" :  \"test\",'+
             '          \"billDate\" :  \"2020-04-01\",'+
             '          \"startDate\" :  \"2020-03-21\",'+
             '          \"endDate\" :  \"2020-03-21\",'+
              '         \"status\" : {'+
                                 ' \"statusCode\" :  \"S\",'+  
                                 ' \"statusDescription\" :  \"test\"'+ 
                          '}'+
             '}'+
        '        } ]'+
        '      }'+
              
             '}';
        
        System.debug(LoggingLevel.DEBUG,'mock json'+JSONResponse);        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        res.setBody(JSONResponse);
        res.setStatusCode(200);
        System.debug(LoggingLevel.DEBUG,'res....'+res);       
        return res;       
        
    }

}