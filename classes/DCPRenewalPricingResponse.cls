/**
    @description Response wrapper for Json response
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-06-30      Benjamin Her        DCP-2265 Initial Creation
    2021-07-19      Kavya S             DCP-2654 Initial creation

 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPRenewalPricingResponse{
    public string status;
    public integer code;
    public string message;
    public DCPPricingObject data;

    /**
        @description  Object for response data
     */
    public class DCPPricingObject{
        public List<DCPOfferPricing> offerPricingDetail;
        /**
        @description  Constructor
         */
        public DCPPricingObject(){
            offerPricingDetail = new List<DCPOfferPricing>();
        }
    }

    /**
        @description Object for storing pricing matrix for proposals
     */
    public class DCPOfferPricing{
        public String proposalId;
        public String proposalType;
        public List<DCPPricingMatrix> priceMatrix;
        public List<DCPSavingMatrix> savingMatrix;

        /**
        @description  Constructor
         */
        public DCPOfferPricing(){
            priceMatrix = new List<DCPPricingMatrix>();
            savingMatrix= new List<DCPSavingMatrix>();
        }
    }

    /**
        @description Object for storing storing pricing
     */
    public class DCPPricingMatrix{
        public integer quantity;
        public Map<String,Decimal> contractTermPricing;
        /**
        @description  Constructor
         */
        public DCPPricingMatrix(){
            contractTermPricing = new Map<String,Decimal>();
        }
    }
    /**
        @description Object for storing storing pricing
     */
    public class DCPSavingMatrix{
        public integer quantity;
        public Map<String,Decimal> contractTermSaving;
        /**
        @description  Constructor
         */
        public DCPSavingMatrix(){
            contractTermSaving= new Map<String,Decimal>();
        }
    }
}