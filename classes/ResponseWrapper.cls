public class ResponseWrapper{
    public CanvasURL canvasURL;
    
    public class CanvasURL{
        public canvasUrl(){}    
        public String HTPURL;
        public String SessionID;
        public String ReferenceNumber;
        public Boolean Success;
        public String Error;
    }
    
    public class postmessageResponse{
        public postmessageResponse(){}
        public String Hash;
        public Payload Payload;
    }
    
    public class Payload{     
        public Payload(){}  
        public String Token;
        public String Success;
        public String SesssionID;
        public String Error;
        public String CustomerRefNumber; 
        public String ClientIP;
        public String Brand;  
    }
    
    public class Error{
        public Error(){}
        public String Success;
        public String Error;
    }
}