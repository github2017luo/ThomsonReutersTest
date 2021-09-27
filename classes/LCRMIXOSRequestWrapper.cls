/*
======================================================================================================================
CLASS:    LCRMIXOSRequestWrapper
======================================================================================================================
=
PURPOSE:    Request Wrapper Class generated using JSON payloads for Document Service.
CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
1-2-2018         Navjyoti            Created for CRM-11779
1-29-2018        Seema               Updated for CRM-11442
======================================================================================================================
*/

public class LCRMIXOSRequestWrapper {
    
    // IXOS Request Wrapper Begins
  public class IXOSReqWrapper {
    public GetDocumentDetailsRequest getDocumentDetailsRequest;
        
        public IXOSReqWrapper(){
            getDocumentDetailsRequest = new GetDocumentDetailsRequest();
        }
  }
  
  public class GetDocumentDetailsRequest {
    public EsiHeader esiHeader;
    public List<BaseDocument> baseDocument;
    public DocumentDetails documentDetails;
        
        public GetDocumentDetailsRequest(){
            esiHeader = new EsiHeader();
            baseDocument = new List<BaseDocument>();
            documentDetails = new DocumentDetails();
        }
  }
  
  public class EsiHeader {
    public String applicationId;
    public String messageId;
    public String companyId;
    public String postBackURL;
        
        public EsiHeader(){
            applicationId ='';
            messageId ='';
            companyId ='';
            postBackURL ='';
        }
  }
  
  public class BaseDocument {
    public Account account;
    public String referenceNumber;
        
        public BaseDocument(){
            account = new Account();
            referenceNumber ='';
        }
  }
  
  public class DocumentDetails {
    public DocumentHeader documentHeader;
        
        public DocumentDetails(){
            documentHeader = new DocumentHeader();
        }
  }
  
  public class Account {
    public String accountNumber;
        
        public Account(){
            accountNumber='';
        }
  }
  
  public class DocumentHeader {
    public List<String> documentType;
    public String startDate;
    public String endDate;
        
        public DocumentHeader(){
            documentType = new List<String>();
            startDate ='';
            endDate ='';
        }
  }
    // Request Wrapper Ends
    
}