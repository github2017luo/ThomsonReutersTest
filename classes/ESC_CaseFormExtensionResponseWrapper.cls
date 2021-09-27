public without sharing class ESC_CaseFormExtensionResponseWrapper{
    
    public ESC_CaseFormExtensionResponseWrapper(){}
    public InvoiceDetail InvoiceDetail;
    public class InvoiceDetail {
        public String writeOffReferenceNumber;  // 
        public statusDetails[] statusDetails;
    }
    public class statusDetails {
        public String statusCode;   //E
        public String statusDescription;    //Document: 080000000253 can not be written off(payment specification)
        public String statusMssage; //Document: 080000000253 can not be written off(payment specification)
    }
}