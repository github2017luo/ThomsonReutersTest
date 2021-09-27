/**
    @description Response wrapper for Json response
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-07-09      Benjamin Her        DCP-2266 Initial Creation
    2021-07-23      Kavya S             DCP-3193 Added qualifier tag
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPRenewalProductResponse{
    
    public string status;
    public integer code;
    public string message;
    public DCPProductData data;
    /**
        @description Wrapper to store data
     */
    public DCPRenewalProductResponse(){
        data = new DCPProductData();
    }

    /**
        @description Contains all objects to be sent as part of response
     */
    public class DCPProductData{
        public List<DCPOfferProductDetail> offerProductDetail;
        
        /**
        @description  Constructor
         */
        public DCPProductData(){
            offerProductDetail = new List<DCPOfferProductDetail>();
        }
    }

    /**
        @description Contains proposal and product information
     */
    public class DCPOfferProductDetail{
        public String proposalId;
        public String proposalType;
        public List<DCPProductDetail> productDetail;

        /**
        @description  Constructor
         */
        public DCPOfferProductDetail(){
            productDetail = new List<DCPProductDetail>();
        }
    }

    /**
        @description Contains product pricing details
     */
    public class DCPProductDetail{
        public String productName;
        public String materialNumber;
        public String productId;
        public integer quantity;
        public decimal amount;
        public String qualifier;
        //public Map<String,Decimal> productPricing;
    }
    
}