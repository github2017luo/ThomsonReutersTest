/**
 * Provides methods for submitting requests to the IXOS web service
 * <p>
 * Note: As a best practice only this class and it's associated test class should
 * have a dependency on the IXOSServiceWS class. This will ease 
 * any future modifications to the web service wsdl and abstract the web service 
 * interface from the rest of the application.
 *
 * @authorNandita
 * @version2012-02-24
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * DateNameDescription
 * 2012-02-24 NanditaCreated
 * =============================================================================
 */

public with sharing class IXOSServices {
 //Constants
    public static final string WEB_SERVICE_NAME = 'IXOSServices';
    
/**
 * Submits the supplied request to the IXOS web service to retrieve
 * list of IXOS Documents
 *
 * @paramoRequestan instance of an IXOSRequest object
 * @returnlist<IXOSDocument> objects representing the results of the web service callout
 * 
 */
    public List<IXOSDocument> GetIXOSDocumentDetails(IXOSRequest oRequest) {
        List<IXOSDocument> IXOSDocumentList = new List<IXOSDocument>();
        IxosWSObjects.DocumentHeader DocHeader = new IxosWSObjects.DocumentHeader();
        List<IxosWSObjects.DocumentHeader> DocumentHeaderList = new List<IxosWSObjects.DocumentHeader>();
        ValidationResult oValidationResult = validateRequest(oRequest);
        if (oValidationResult.IsValid == true) {
            List<IxosWSObjects.IXOSDocument> oResponse = new List<IxosWSObjects.IXOSDocument>();
            for(DocumentHeader oDocHeader:oRequest.DocumentHeaderList){
                DocHeader.AcctSapId = oDocHeader.AcctSapId ;
                DocHeader.OrderNumber = oDocHeader.OrderNumber ;
                DocumentHeaderList.add(DocHeader);
            }   
            if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(WEB_SERVICE_NAME);
                returnService(oRequest);            
                if (oMockResponse instanceof IxosWSObjects.IXOSDocument) {
                    oResponse.add((IxosWSObjects.IXOSDocument) oMockResponse);
                }
            }       
            else {
            //Execute Web Service Callout
                oResponse = returnService(oRequest).GetIXOSDocumentDetails(oRequest.SystemId,DocumentHeaderList, oRequest.CompanyCode,oRequest.SalesOrgCode,oRequest.DistChanCode,oRequest.DivisionCode,oRequest.IxosDocBegDt,oRequest.IxosDocEndDt,oRequest.DocumentTypeList);
            }
            //Parse Response
            if(oResponse !=null){
                for(IxosWSObjects.IXOSDocument res:oResponse){
                    IXOSDocumentList.add(new IXOSDocument(res));
                } 
            } 
        }
        else {
            throw new IXOSServices.ValidationException(oValidationResult.toString());
        }
        return IXOSDocumentList;
    }

//Private Methods

    Private IxosWS.IXOSDocument_v2_0Port returnService(IXOSRequest oRequest){
        IxosWS.IXOSDocument_v2_0Port oService = new IxosWS.IXOSDocument_v2_0Port();
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.timeout_x = oRequest.Timeout;
        oService.endpoint_x = oRequest.EndPoint;
        Blob blobCredentials = Blob.valueOf(oRequest.Username + ':' + oRequest.Password);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        oService.outputHttpHeaders_x = new Map<String,String>();
        return oService;
    }


/**
 * Validates that all required fields are populated for the specified Request
 *
 * @paramoRequestan instance of a Request object to validate
 * @returnan instance of a ValidationResult representing the results of the validation test
 */
    private ValidationResult validateRequest(Request oRequest) {
        ValidationResult oValidation = new ValidationResult();
        oValidation.IsValid = true;
        if (oRequest != null) {
            //Validate Request Credentials
            boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
            if (isMissingEndpoint) {
                oValidation.IsValid = false;
                oValidation.Failures.add('Invalid request. Web service endpoint is not configured');
            }
            //Validate Timeout Limit
            boolean isTimeoutValid = (oRequest.Timeout > 0);
            if (!isTimeoutValid) {
                oValidation.IsValid = false;
                oValidation.Failures.Add(System.Label.InvalidTimeoutValue);
            }
        }
        else {
            oValidation.IsValid = false;
            oValidation.Failures.add('Invalid Request Object. Request can not be null');
        }
        return oValidation;
    }

//Internal Classes

/**
 * Custom exception class representing a validation error
 */
    public class ValidationException extends Exception {}

/**
 * Virtual class representing a base IXOS request
 */
    public virtual class Request {
    //Properties
        public string EndPoint {get;set;}
        public string Username {get;set;}
        public string Password {get;set;}
        public integer Timeout {get;set;}

        //Constructors

        /**
         * Default Constructor
         */
        public Request() {
            Timeout = 5000; //5 Seconds
        }
    }
    
    public class DocumentHeader { 
        public Decimal AcctSapId{get;set;}
        public String OrderNumber{get;set;}
        public DocumentHeader(){}
        public DocumentHeader(IxosWSObjects.DocumentHeader oDocumentHeader){
            AcctSapId = oDocumentHeader.AcctSapId;
            OrderNumber = oDocumentHeader.OrderNumber;
        }
    }

/**
 * Data structure representing an IXOS request
 * 
 */
    public class IXOSRequest extends Request {
    //Properties
        public string SystemId{get;set;}
        public List<DocumentHeader> DocumentHeaderList{get;set;}
        public String CompanyCode{get;set;}
        public String SalesOrgCode{get;set;}
        public String DistChanCode{get;set;}
        public String DivisionCode{get;set;}
        public Date IxosDocBegDt{get;set;}
        public Date IxosDocEndDt{get;set;}
        public List<String> DocumentTypeList{get;set;}
    }

//Data Structures

/**
 * Data structure representing an IXOS Document 
 */ 

    public class IXOSDocument {
        public Decimal AcctSapId{get;set;}
        public String OrderNumber{get;set;}
        public Date BillDate{get;set;}
        public String BillPeriod{get;set;}
        public Date BeginDate{get;set;}
        public Date EndDate{get;set;}
        public String DocumentType{get;set;}
        public String DocumentDesc{get;set;}
        public String ArchiveId{get;set;}
        public String ObjectId{get;set;}
        public String ArchiveDocId{get;set;}
        public String SapObject{get;set;}
        public String BlockStatus{get;set;}
        public String URL{get;set;}

        //Constructor
        public IXOSDocument(){} 
        public IXOSDocument(IxosWSObjects.IXOSDocument oIXOSDocument){
            AcctSapId=oIXOSDocument.AcctSapId;
            OrderNumber=oIXOSDocument.OrderNumber;
            BillDate=oIXOSDocument.BillDate;
            BillPeriod=oIXOSDocument.BillPeriod;
            BeginDate=oIXOSDocument.BeginDate;
            EndDate=oIXOSDocument.EndDate;
            DocumentType=oIXOSDocument.DocumentType;
            DocumentDesc=oIXOSDocument.DocumentDesc;
            ArchiveId=oIXOSDocument.ArchiveId;
            ObjectId=oIXOSDocument.ObjectId;
            ArchiveDocId=oIXOSDocument.ArchiveDocId;
            SapObject=oIXOSDocument.SapObject;
            BlockStatus=oIXOSDocument.BlockStatus;
            URL=oIXOSDocument.URL;
        } 
    }
}