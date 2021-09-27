/*
 * This class is a wrapper class used for DCQuoteService and DCGetQuoteDetails.
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-08-15   Harika Sai P            DLT-11661 - Combine the Landing Page service into a single service
 * 2018-11-05   Rajan Tatuskar          DLT-12679 - Recommendations reason from Automation file for Upsell Offers
 * 2019-02-19   Benjamin Her            DLT-15324 - Add basePrice field to LineItem
 * 2019-09-04   Srikanth kota           DLT-17452 - [CORP][SFDC] Straight renew Option products alongwith the core product
 *                                 
 * ==================================================================================================================================   
 */
global class DCQuoteDetails {
   
    global Integer responseCode;
    global String responseMessage;
    global QuoteDetailsResponse getQuoteDetails;//DLT-11661
    global List<QuoteDetail> quoteDetails;  
  global List<promocodetails> promcods;
    
    global class promocodetails{
        global String promocode;
        global date EffectiveDate;
        global date ExpiryDate;
        global Decimal adjustmentamount;
    }
    
    global class QuoteDetail{
        global String contractTerm; 
        global Integer customerCategory;    
        global Integer defaultNoOfAttorneys;    
        global Double quotePrice;   
        global String quoteId;  
        global String quoteType;    
        global Integer maxNoOfAttorneys;    
        global Integer noOfAttorneys;   
        global boolean updatedOnConfigurator;
        global boolean Contract_Not_In_Sync;
        global String sendEmailOnBeHalfOf;//Added as part of DLT-9251
        global List<ContractTermDetail> contractTermDetails = new List<ContractTermDetail>();
        global List<LineItem> lineItems = new List<LineItem>();
        global String digitalFirm; // Added as part of DLT-9964
        
        //*** START :: Added by Rajan :: DLT-12679 - Recommendations reason from Automation file for Upsell Offers
        global String PlusRecTextCode;
        global String PremiumRecTextCode;
        //*** END :: Added by Rajan :: DLT-12679 - Recommendations reason from Automation file for Upsell Offers
    }
    
    global class ContractTermDetail {
        global boolean isBestValue;
        global String term; 
        global Decimal markupPercentage;    
        global Decimal yearOnYearRenewal;   
        global Decimal yearOnYearTwoPlus;
        global String adjustmentType;
        global Decimal adjustmentAmount;
        global boolean isVisible;
        global boolean isEditable;
    }

    global class LineItem {
        global String productId;
        global String optionProductId; //  DLT-17452
        global String category;
        global Decimal price;  
        global Integer quantity; 
        public String pricingModel;
        global List<Pricematrix> matrices = new List<Pricematrix>();
        global Decimal basePrice;//added for DLT-15324
    }
    global class Pricematrix{
        global Integer quantity;    
        global Decimal amount;  
    }
    
    
}