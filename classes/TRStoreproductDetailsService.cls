/* Class: TRStoreProductdetails
* Purpose: This class is for providing the product details service details to AEM  as part of TRStore 
* Created: 7/30/2019
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 07/30/2019                   DLT-17259     Created 
* 04/05/2020   Kanishk         DLT-19888     Author Biography changes
* 24/07/2020   Ameeta          DLT-20303     Added product Format changes
* =============================================================================
*/


global class TRStoreproductDetailsService{

    
    // Main wrapper class to store product details 
    global class ProductWrapper{
        
        public string productName;
        public string ProductCode;
        public string Description;
        public string serviceNumber;
        //public string ProductFormat;
        public string publisher;
        public string Jurisdiction;
        public string practiceArea;
        public string publicationDate;
        public string author;
        public string shortDesc;
        public string isbn;
        public string longDesc;
        public string sub;
        
        public LIST<ProductFormats> ProductFormat = new LIST<ProductFormats>();
        public LIST<productAuthors> Authors = new LIST<productAuthors>();
        public LIST<pricelist> priceListDetails = new LIST<pricelist>();
        public RequestStatus status;
        public LIST<productsFeatures> productFeatureset = new LIST<productsFeatures>();
        public ProductWrapper(){
            isbn='';
        }
         
    }
    
    // Sending product list pricing fields on following fields....
    global class Pricelist{
        
        public Decimal listPrice;
        public string chargeType;
        
    }
    
    // sending service details
    global class RequestStatus{
        public string statusCode;
        public string statusDesc;
        public string status;
    }
    
    global class ProductsFeatures{
        public boolean isFormat; 
        public string key;
        public string value;
        //public string formatType;
    } 
    
    global class ProductAuthors{
        public string authorId{get; set;}
        public string authorName{get; set;}
        public string sfdcId{get; set;}
    }
    
    global class ProductFormats{
        public string format;
        public string productId;
        public string bundleType;    // DLT-20536     Bundle Implementations 
        public string bundleTitle;  // DLT-20536      Bundle Implementations 
        
    }
   
    
}