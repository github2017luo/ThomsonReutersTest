@isTest
public class Ecom_DigitalExceptionService_Test {

         @isTest
        public static void start1(){
            
                
                Test.startTest();
                Ecom_DigitalExceptionRequest.cls_DigitalExceptionRequest request = new Ecom_DigitalExceptionRequest.cls_DigitalExceptionRequest();
                request.Info= '';  
                request.ExceptionMessage= '';
                request.TimeStamp= '';
                
             Ecom_DigitalExceptionRequest req = new Ecom_DigitalExceptionRequest(request);
                Ecom_DigitalExceptionService.CreateDigtialException(req);
                //to cover default constructor
                new Ecom_DigitalExceptionRequest();
                Test.stopTest();
        }
                  @isTest
                 public static void start2()
                 {
            
                Test.startTest();
                Ecom_DigitalExceptionRequest.cls_DigitalExceptionRequest request = new Ecom_DigitalExceptionRequest.cls_DigitalExceptionRequest();
                request.Info= 'Test1';  
                request.ExceptionMessage= 'Test1';
                request.TimeStamp= 'Test1';
                
              Ecom_DigitalExceptionRequest req = new Ecom_DigitalExceptionRequest(request);
                Ecom_DigitalExceptionService.CreateDigtialException(req);
                //to cover default constructor
                new Ecom_DigitalExceptionRequest();
                Test.stopTest();
              
                 }
        
              }