/*
* CHANGE HISTORY
* ==================================================================================================================================
* 2018-08-20   Raviteja Murukutla        DLT-11748 [TECH STORY- SFDC] - Create a Request for Digital exception logs
* ==================================================================================================================================   
*/
global class Ecom_DigitalExceptionRequest {
    
     public cls_DigitalExceptionRequest DigitalExceptionRequest;
     public Ecom_DigitalExceptionRequest(cls_DigitalExceptionRequest DigitalExceptionRequest){
         this.DigitalExceptionRequest = DigitalExceptionRequest;
     }
     public Ecom_DigitalExceptionRequest(){}
     
     public class cls_DigitalExceptionRequest {
        public String Info;    
        public String ExceptionMessage;
        public String TimeStamp;
        }

        
}