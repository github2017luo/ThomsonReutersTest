/**
 * @description ESC_IXOSHanaRequestWrapper
 */
public class ESC_IXOSHanaRequestWrapper {

    /**
 * @description IXOSReqWrapper
 */
    
    public class IXOSReqWrapper {
        public GetDocumentDetailsRequest getDocumentDetailsRequest;
        
        /**
 * @description IXOSReqWrapper
 */
        public IXOSReqWrapper(){
            getDocumentDetailsRequest = new GetDocumentDetailsRequest();
        }
    }
    
    /**
 * @description GetDocumentDetailsRequest
 */
    public class GetDocumentDetailsRequest {
     /**
* @description isConsolidated
*/
        public Boolean isConsolidated;
           /**
* @description esiHeader
*/
        public EsiHeader esiHeader;
                   /**
* @description baseDocument
*/
        public List<BaseDocument> baseDocument;
          /**
* @description documentDetails
*/
        public DocumentDetails documentDetails;
        
        public GetDocumentDetailsRequest(){
            esiHeader = new EsiHeader();
            baseDocument = new List<BaseDocument>();
            documentDetails = new DocumentDetails();
            isConsolidated = true;
        }
    }
    
      /**
 * @description EsiHeader
 */
    public class EsiHeader {
          /**
 * @description applicationId
 */
        public String applicationId;   
                  /**
 * @description companyId
 */
        public String companyId;
        /**
 * @description postBackURL
 */
        public String postBackURL;
        
        public EsiHeader(){
            applicationId ='';           
            companyId ='';
            postBackURL ='';
        }
    }
    
            /**
 * @description BaseDocument
 */
    public class BaseDocument {
                /**
 * @description account
 */
        public Account account;
      /**
 * @description referenceNumber
 */
        public String referenceNumber;
        
        public BaseDocument(){
            account = new Account();
            referenceNumber ='';
        }
    }
    
        /**
 * @description Account 
 */
    public class Account {
    /**
 * @description accountNumber
 */
        public String accountNumber;
         /**
 * @description salesforeOrg
 */
        public String salesforeOrg;
        public Account(){
            accountNumber='';
            salesforeOrg = '';
        }
    }
    
    /**
 * @description DocumentDetails
 */
    public class DocumentDetails {
        public DocumentHeader documentHeader;
        
        /**
 * @description DocumentDetails
 */
        public DocumentDetails(){
            documentHeader = new DocumentHeader();
        }
    }
             /**
 * @description DocumentHeader 
 */
     
    public class DocumentHeader {   
      /**
 * @description startDate
 */
        public Date startDate;
             /**
 * @description endDate
 */
        public Date endDate;
        
        public DocumentHeader(){          
            startDate = System.today();
            endDate =System.today().addDays(-365);
        }
    }
}