/********************************************************************************
Class Name : DCPOfferDetails
@description : Request Structure for OfferDetail Array
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer              Description
21-04-2021                  Benjamin Her            Initial Creation

*/ 
public class DCPOfferDetails{
    public decimal savingPrice;
    public string contractTerm;
    public decimal yearOnYearRate;      
    public List<DCPPricingDetails> pricing;
    public Date renewalEndDate;
    public boolean isSelectedTerm;
    
    /**
     * @description 
     */
    public DCPOfferDetails(){
        pricing = new List<DCPPricingDetails>();
    }

    /**
     * @description 
     */
    public class DCPPricingDetails{
        public decimal price;
        public integer year;
    }
    
}