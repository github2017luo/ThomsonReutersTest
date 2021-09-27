global class OnlineContactsSerializeandDeserializeReq {

  //json serialization class to construct a request
    global class OnlineContactsRequest {
        public  ESIHeader ESIHeader{get; set;}
        public  OnlineContactFilter OnlineContactFilter{get; set;}
        public Account account {get; set;}
        public Integer maxContactsInChunk{get;set;}
        public Integer beginIndex{get;set;}
        
        public OnlineContactsRequest () {
            ESIHeader= new ESIHeader();
            OnlineContactFilter= new OnlineContactFilter();
            account = new account();
            maxContactsInChunk=900;
            beginIndex=0;
        }
     } 
    public class ESIHeader {
        public string applicationId   {get;set;}       
        public ESIHeader() {
            applicationId = '';          
        }          
    }
    public class OnlineContactFilter{
        
        public Boolean checkEntitlementDetails {get; set;}
        public Boolean checkPrism    {get; set;}        
        public OnlineContactFilter() {
            checkEntitlementDetails = False;    
            checkPrism =False;
        }          
    }
    public class account {
        public string accountNumber {get; set;}
       
        public account() {
            accountNumber = '';
        }
    }    
}