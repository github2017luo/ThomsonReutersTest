/**
     * @description ESC_IXOSHanaResponseWrapper        
     */
    public class ESC_IXOSHanaResponseWrapper {

        /**
     * @description IXOSRespWrapper        
     */
        public class IXOSRespWrapper {   
          /**
         * @description getDocumentDetailsResponse        
         */ 
            public GetDocumentDetailsResponse getDocumentDetailsResponse;
                
            public IXOSRespWrapper(){
                getDocumentDetailsResponse = new GetDocumentDetailsResponse();
            }
        }
        /**
         * @description GetDocumentDetailsResponse        
         */
        public class GetDocumentDetailsResponse {
        /**
         * @description documentDetails        
         */
            public List<DocumentDetails> documentDetails;
        
            
            public GetDocumentDetailsResponse(){
                documentDetails = new List<DocumentDetails>();            
            }
        }
        /**
         * @description DocumentDetails        
         */
        public class DocumentDetails {
        /**
         * @description documentHeader        
         */
            public DocumentHeader documentHeader;
            
            public DocumentDetails(){
                documentHeader = new DocumentHeader();
            }
        }
         /**
         * @description Status        
         */
        public class Status {
        /**
         * @description statusCode        
         */
            public String statusCode;
            /**
         * @description statusDescription        
         */
            public String statusDescription;
        
            
            public Status(){
                statusDescription ='';
                statusCode ='';
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
         * @description DocumentHeader        
         */
        public class DocumentHeader {
          /**
         * @description documentType        
         */
            public List<String> documentType;  
            /**
         * @description endDate        
         */
            public String endDate;  
         /**
         * @description documentNumber        
         */     
            public String documentNumber;  
         /**
         * @description documentUrl        
         */     
            public String documentUrl;
            /**
         * @description billDate        
         */ 
            public String billDate;
            /**
         * @description account        
         */ 
            public Account account; 
            /**
         * @description startDate        
         */ 
            public String startDate;
            /**
         * @description billPeriod        
         */ 
            public String billPeriod;
            /**
         * @description status        
         */ 
            public Status status;
           
            public DocumentHeader(){
                documentType = new List<String>();
                endDate ='';             
                documentNumber ='';                      
                documentUrl ='';
                billDate ='';
                account = new Account();  
                startDate ='';
                billPeriod = '';
                status = new Status();
                
            }
      }
      /**
         * @description DisplayIxos        
         */
      // Wrapper to display IXOS repsonse on VF 
        public class DisplayIxos{
        
            /**
         * @description contractNumber        
         */
        public string contractNumber {get; set;}
        /**
         * @description DocDescription        
         */
            public string docDescription {get; set;}
            /**
         * @description CreatedDate        
         */
            public string createdDate {get; set;}
            /**
         * @description docUrl        
         */
            public string docUrl {get; set;}
            /**
         * @description documentType        
         */
            public String documentType {get; set;}
            /**
         * @description DisplayIxos        
         */
            public DisplayIxos (){
                System.debug(LoggingLevel.DEBUG,'test'); 
            }

            /**
         * @description DisplayIxos 
         * @param docdetails       
         */
               public DisplayIxos (DocumentDetails docdetails){
                ContractNumber = docdetails.DocumentHeader.documentNumber ;          
                CreatedDate = docdetails.DocumentHeader.startDate ;
                docUrl = docdetails.DocumentHeader.documentUrl ;
                }
        }
        /**
        * @description displayIxosMapping
        * @return List<DisplayIxos>
        * @param jsonResponse
        */
          public static List<DisplayIxos> displayIxosMapping(string jsonResponse){
              
            list<DisplayIxos> displayIxosItemslist = new list<DisplayIxos>();
            IXOSRespWrapper ixosResWrap = new IXOSRespWrapper();
            
             try{
                 
                  ixosResWrap = (IXOSRespWrapper)System.JSON.deserialize(jsonResponse,ESC_IXOSHanaResponseWrapper.IXOSRespWrapper.class);
                if(ixosResWrap.GetDocumentDetailsResponse.documentDetails != null){
                    for(DocumentDetails doc :ixosResWrap.GetDocumentDetailsResponse.documentDetails){
                        displayIxosItemslist.add(new DisplayIxos(doc));
                    }
                }
               
            }catch(Exception e){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+e.getMessage()));
            }
            return displayIxosItemslist;
        
        
            
          }
    
    }