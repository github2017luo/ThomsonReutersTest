global class DCQuoteUpdate {
    
    global class QuoteUpdateRequest{
        global String quoteId;
        global Integer quantity;
        global String contractTerm;
        global String quoteType;
        global List<String> productIds;
        
        //*** START :: Added by Rajan :: DLT-10632 - Update APIs to accommodate per seat products assignment and Quantity updates from landing page.
        global List<ProductDetails> productDetails;
        //*** END :: Added by Rajan :: DLT-10632 - Update APIs to accommodate per seat products assignment and Quantity updates from landing page.
    }
    
    //*** START :: Added by Rajan :: DLT-10632 - Update APIs to accommodate per seat products assignment and Quantity updates from landing page.
    global class ProductDetails {
        public String productId;
        public Integer productQuantity;
    }
    //*** END :: Added by Rajan :: DLT-10632 - Update APIs to accommodate per seat products assignment and Quantity updates from landing page.
    
    global class QuoteUpdateResponse{ 
        global Integer responseCode; 
        global String responseMessage;
        global List<QuotePricingStatus> quotePricingStatus = new List<QuotePricingStatus>();
    }
    global class QuotePricingStatus{
        global String quoteId;
        global Boolean isPricingPending;
        // global String quoteId;
    }
    
}