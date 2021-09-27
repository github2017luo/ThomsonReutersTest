global class DCUIResponseV2 {

    global UIResponseWrapper responseWrapper { get; set;}
    
    global class Section {
        public String categoryId {get;set;}  
        public Integer sectionLevel {get;set;} 
        public String sectionTitle {get;set;} 
        public Boolean isSectionTitleVisible {get;set;} 
        public Boolean isMultiSelect {get;set;} 
        public Integer sequenceNo {get;set;}
        public Boolean hasProducts {get;set;}
        public Boolean containsBestValue {get;set;}
        public List<Section> subSections {get;set;} 
        public List<CartItem> cartItems {get;set;} 
    }
 
    global class UIResponseWrapper {
        public String bestValueAdjustmentType;
		public Decimal bestValueAdjustmentAmount;
        public String customQuoteId {get;set;} 
        public String bestValueQuoteId {get;set;} 
        public String accountId {get;set;} 
        public Integer noOfAttorneys {get;set;} 
        public Integer defaultNoOfAttorneys {get;set;} 
        public Decimal maxNoOfAttorneys {get;set;}
        public String priceListId {get;set;} 
        public Decimal discountPercentage {get;set;} 
        public Decimal customQuotePrice {get;set;}
        public String cQPriceDollarPart {get;set;}
        public String cQPriceCentPart {get;set;}
        public Decimal bestValueQuotePrice {get;set;}     
        public String pageHeaderTitle {get;set;}
        public String pageHeaderText {get;set;}
        public String landingPageURL {get;set;}
        public String summaryPageURL {get;set;}
        public Boolean updatedOnConfigurator {get;set;}
        public List<ContractTermWrapper> contractTermDetails {get;set;}
        public List<Section> cartDetails {get;set;} 

    }
    
    global class ContractTermWrapper {
        public String term {get;set;}
        public Integer sequenceNo {get;set;}
        public Decimal markupPercentage {get;set;}
        public Boolean isSelected {get;set;}
        public Boolean isBestValue {get;set;}    
    }
    
    global class CartItem {
        public String productId {get;set;} 
        public String quoteLineItemId {get;set;} 
        public Decimal sequenceNo {get;set;} 
        public boolean isSelected {get;set;} 
        public boolean isBestValue {get;set;} 
        public String title {get;set;} 
        public String description {get;set;} 
        public Decimal price {get;set;} 
        public String jurisdiction {get;set;} 
        public String priceDollarPart {get;set;}
        public String priceCentPart {get;set;}
        public boolean isDisabled {get;set;}
        public List<PriceMatrix> matrices {get;set;}
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