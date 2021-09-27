/*
* CHANGE HISTORY
* ==================================================================================================================================
* 2018-08-20   Raviteja Murukutla        DLT-11748 [TECH STORY- SFDC] - Create a service for Digital exception logs
* ==================================================================================================================================   
*/

@RestResource(urlMapping='/digitalconfigurator/DigitalException/*')
global class Ecom_DigitalExceptionService {
    /*
    *  Rest API will trigger this Method and return response
    */
    @HttpPost
    global static DigtialExceptionResponse CreateDigtialException(Ecom_DigitalExceptionRequest Req){
    
     DigtialExceptionResponse response = new DigtialExceptionResponse();
     if(Req !=null && (!String.isBlank(Req.DigitalExceptionRequest.Info) || !String.isBlank(Req.DigitalExceptionRequest.ExceptionMessage) || !String.isBlank(Req.DigitalExceptionRequest.TimeStamp) )) {
           Ecom_DigitalExceptionService service = new Ecom_DigitalExceptionService();
           //try
           {
               response = service.DigtialException(req.DigitalExceptionRequest);
               
                response.responseCode = 200;
                response.responseMessage = 'Success';
             }/*Catch(Exception ex){
                  DCUtils.trackLog(ex,'Ecom_DigitalExceptionService','CreateDigtialException');
                  response.responseCode = 4000;
                  response.responseMessage = ex.getMessage();
              }  */
     }
     else
     {
         response.responseMessage = 'Digital Exception is not available';
     }
            return response;
}
    
   public DigtialExceptionResponse DigtialException(Ecom_DigitalExceptionRequest.cls_DigitalExceptionRequest Req)
   {
      DigtialExceptionResponse res = new DigtialExceptionResponse();
      
          Digital_Exception_Log__c DigitalException = New Digital_Exception_Log__c();
          DigitalException.Additional_Information__c = Req.Info;
          DigitalException.Exception_Message__c = Req.ExceptionMessage;
          DigitalException.User_Message__c = Req.TimeStamp;
          Insert DigitalException;
          res.exceptionId = DigitalException.Id;
      
      return res;
    }
    
      global class DigtialExceptionResponse{
        global Integer responseCode;
        global String responseMessage;
        global String exceptionId; 
    }
}