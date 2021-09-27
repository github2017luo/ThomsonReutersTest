/**********************************
Class Name: USLARInvoicedetailwrapper
**********************************/
/**
 * @description USLARInvoicedetailwrapper class
 */
public class USLARInvoicedetailwrapper{ 
 
  public class ARrequest {
         public EsiHeader esiHeader{get;set;}
         public List<String> invoiceNumberList{get;set;}
    }
    public class EsiHeader {
        public String applicationId{get;set;}
        public String companyId{get;set;}
        public string configGroup{get;set;}
        
        public EsiHeader(String appid,String comid,String configGrp){
            this.applicationId=appid;
            this.companyId=comid;
            this.configGroup = configGrp;
        }
    }
    public class ARdetail{
        public list<cls_details> details{get;set;}
        public cls_processStatus processStatus{get;set;}
    }
    public class cls_details {
        public cls_invoiceHeader invoiceHeader{get;set;}
        public List<cls_invoiceLines> invoiceLines{get;set;}
    }
  public class cls_invoiceHeader {      
        public String referencekey{get;set;}
        public String amount{get;set;}  
        public String netAmount{get;set;} 
        public String taxAmount{get;set;}

    }
   public class cls_invoiceLines {
        public String description{get;set;} 
        public String quantity{get;set;}    
        public String netPrice{get;set;}    
        public String taxAmount{get;set;}   
        public String PONumber{get;set;}    
        public String lineNumber{get;set;}  
        public cls_document document{get;set;}
        public String netPerUnitDocCurr{get;set;}   
        public String taxPerUnitDocCurr{get;set;}   
        public String materialNumber{get;set;}  
        public String serviceDate{get;set;} 
        public String invListNumber{get;set;}
    }   
   public class cls_document {
        public String docNumber{get;set;} 
        public String type{get;set;}  
    }
    public class cls_processStatus {
        public String statusCode;   //400
        public String statusDescription;    //Uknown Application
        public String statusDetailMessage;  //Invalid Application Id found for retrieving Invoice Details
    }
     public class responsewrapper{
        public responsewrapper () { }
        public String responseBodyJSON { get; set; }
        public Boolean isSuccess { get; set; }
        public String errorMessage { get; set; }
    }
}