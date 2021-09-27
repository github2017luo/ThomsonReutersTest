public class DCSmJsonRequestFormatter {
    
    public class SmartMatchingRequest {

        public esiHeader esiHeader {get; set;}
		public string sourceSystem {get;set;}
        public string business {get; set;}
        public string targetSystem	 {get; set;} 
        public string domain	 {get; set;} 
		public string domainStatus	 {get; set;}
		public string contactStatus	 {get; set;}  
        public account account {get; set;}
        
         public SmartMatchingRequest(){
            esiHeader  = new esiHeader ();
			sourceSystem = '';
            business = '';
            targetSystem = '';
			domain = '';
			domainStatus = '';
			contactStatus = '';
            account = new account ();
         }
   }
   
   public class esiHeader { 
	
		public string applicationId {get; set;}
        
        public esiHeader() {
            applicationId = '';
        }

	}
	
    public class account {
        public string accountNumber {get; set;}
        
        public account() {
            accountNumber = '';
        }
    }
   
    public class Notification {
        public String StatusCode {get;set;}
        public String StatusDescription {get;set;}
        public Notification() {
            StatusCode = '';
            StatusDescription = '';
        }
    }
   
}