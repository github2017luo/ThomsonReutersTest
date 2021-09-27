/*
 * This class has Load Details related to Digital Configuration Page.
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-12-17   Divija Salla            DLT-13779 - Create an API to get Configurator plan details
 * ==================================================================================================================================  
 */
global class DCConfigdetails {
	global Integer responseCode;
    global String responseMessage;
    global UIResponseWrapper responseWrapper;
    global DCMessage configmsg;
    global DCMessage Bestmsg;
    
    global class Section {
        public String categoryId;  
        public Integer sectionLevel; 
        public String sectionTitle; 
        public Boolean isSectionTitleVisible; 
        public Boolean isMultiSelect; 
        public Integer sequenceNo;
        public Boolean hasProducts;
        public Boolean containsBestValue;
        public List<Section> subSections; 
        public List<CartItem> cartItems; 
    }
 
    global class UIResponseWrapper {
        public String bestValueAdjustmentType;
		public Decimal bestValueAdjustmentAmount;
        public String customQuoteId; 
        public String bestValueQuoteId; 
        public String accountId; 
        public Integer noOfAttorneys; 
        public Integer defaultNoOfAttorneys; 
        public Decimal maxNoOfAttorneys;
        public String priceListId; 
        public Decimal discountPercentage; 
        public Decimal customQuotePrice;
        public String cQPriceDollarPart;
        public String cQPriceCentPart;
        public Decimal bestValueQuotePrice;     
        public String pageHeaderTitle;
        public String pageHeaderText;
        public String landingPageURL;
        public String summaryPageURL;
        public Boolean updatedOnConfigurator;
        public List<ContractTermWrapper> contractTermDetails;
        public List<Section> cartDetails; 

    }
    
    global class ContractTermWrapper {
        public String term;
        public Integer sequenceNo;
        public Decimal markupPercentage;
        public Boolean isSelected;
        public Boolean isBestValue;    
    }
    
    global class CartItem {
        public String productId; 
        public String quoteLineItemId; 
        public Decimal sequenceNo; 
        public boolean isSelected; 
        public boolean isBestValue; 
        public String title; 
        public String description; 
        public Decimal price; 
        public String jurisdiction; 
        public String priceDollarPart;
        public String priceCentPart;
        public boolean isDisabled;
        public List<PriceMatrix> matrices;
    }

    global class Categories {
        public String CategoryId;  
        public String Name;
        public List<SubCategory> SubCategories;
    }

    global class SubCategory {        
        public String CategoryId;  
        public String Name;
        public SubCategory[] SubCategories;
    }
    global class PriceMatrix{
        public String ProductId;
        public Integer quantity;
        public Decimal amount;
    }
}