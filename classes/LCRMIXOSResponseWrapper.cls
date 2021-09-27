/*
======================================================================================================================
CLASS:    LCRMIXOSRequestWrapper
======================================================================================================================
=
PURPOSE:     Response Wrapper Class generated using JSON payloads and supports the method to deserialize JSON response for Document Service.

CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
1-2-2018         Navjyoti            Created for CRM-11779
1-29-2018        Seema               Updated for CRM-11442
======================================================================================================================
*/

public class LCRMIXOSResponseWrapper {
    
  // IXOS Response Wrapper Begins
    public class IXOSRespWrapper {    
      public GetDocumentDetailsResponse getDocumentDetailsResponse;
        
        public IXOSRespWrapper(){
            getDocumentDetailsResponse = new GetDocumentDetailsResponse();
        }
  }
  
    public class GetDocumentDetailsResponse {
    public List<DocumentDetails> documentDetails;
    public StatusDetails statusDetails;
        
        public GetDocumentDetailsResponse(){
            documentDetails = new List<DocumentDetails>();
            statusDetails = new StatusDetails();
        }
  }
  
  public class DocumentDetails {
    public DocumentHeader documentHeader;
        
        public DocumentDetails(){
            documentHeader = new DocumentHeader();
        }
  }
  
  public class StatusDetails {
    public String statusDescription;
    public String statusCode;
        
        public StatusDetails(){
            statusDescription ='';
            statusCode ='';
        }
  }
  
  public class DocumentHeader {
    public String referenceObject;
    public String documentDescription;
    public List<String> documentType;
    public String endDate;
    public String documentUrl;
    public String archiveDocumentId;
    public String blockStatus;
    public String billDate;
    public String archiveId;
    public String referenceNumber;
    public Account account;
    public String objectId;
    public String startDate;
    public String billPeriod;
        
        public DocumentHeader(){
            referenceObject ='';
            documentDescription ='';
            documentType = new List<String>();
            endDate ='';
            documentUrl ='';
            archiveDocumentId ='';
            blockStatus ='';
            billDate ='';
            archiveId ='';
            referenceNumber ='';
            account = new Account();
            objectId ='';
            startDate ='';
            billPeriod = '';
            
        }
  }
  public class Account {
    public String accountNumber;
        
        public Account(){
            accountNumber ='';
        }
  }

    //Response Wrapper Ends
    
    //Wrapper to display IXOS repsonse on VF 
    public class DisplayIxos implements Comparable{
        public string ContractNumber {get; set;}
        public string DocDescription {get; set;}
        public string CreatedDate {get; set;}
        public string docUrl {get; set;}
        public String documentType {get; set;} //Added for CRM-11442
        public DisplayIxos (){}
        public DisplayIxos (DocumentDetails docdetails){
            ContractNumber = docdetails.DocumentHeader.referenceNumber ;
            DocDescription = docdetails.DocumentHeader.documentDescription ;
            CreatedDate = docdetails.DocumentHeader.startDate ;
            docUrl = docdetails.DocumentHeader.documentUrl ;
            documentType = docdetails.DocumentHeader.documentType[0]; //Added for CRM-11442
        }
        
        //Start:Added for CRM-11442
        public Integer compareTo(Object objToCompare) {  
            if (objToCompare==NULL)
            return 0;   
                 
            DisplayIxos myObj = (DisplayIxos) objToCompare;
            String fn = myObj.documentType;
            if (fn==NULL) 
            fn='';
            if (this.documentType==NULL)
            return 0; 
            return this.documentType.compareTo(fn);
         }
         //End: for CRM-11442
    }
     /*-------------------------------------------------------------------------------    
        Method to deserialize the response
    --------------------------------------------------------------------------------*/  
    public static List<DisplayIxos> DisplayIxosMapping(string jsonResponse){
        list<DisplayIxos> displayIxosItems_list = new list<DisplayIxos>();
        IXOSRespWrapper ixosResWrap = new IXOSRespWrapper();
        try{
            ixosResWrap = (IXOSRespWrapper)System.JSON.deserialize(jsonResponse,LCRMIXOSResponseWrapper.IXOSRespWrapper.class);
            if(ixosResWrap.GetDocumentDetailsResponse.documentDetails != null){
                for(DocumentDetails doc :ixosResWrap.GetDocumentDetailsResponse.documentDetails){
                    displayIxosItems_list.add(new DisplayIxos(doc));
                }
            }
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+e.getMessage()));
        }
        displayIxosItems_list.sort();
        return displayIxosItems_list;
    }
    
}