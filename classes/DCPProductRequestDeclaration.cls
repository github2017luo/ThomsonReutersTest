/* Class: DCPProductRequestDeclaration
* Purpose: This class is for holding the request params for product plan and product detail services
* Created: 5/13/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 08/13/2021    Avudaiappan A    DCP-3428     Created 
* =============================================================================
*/
/** 
* @description : This is the class to handle the product plan request and map output response 
*/ 
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPProductRequestDeclaration {

    /**
        * @description productPlanResponse
        */
       global class ProductPlanResponse{
           global DCPNewSaleUtilityCls.Response response;
           global ProductPlan planDetails;
       }
       /** 
   * @description : This is the class to structure the plan Array
   */   
       //Add-on change
       global virtual class ProductPlan{
           global String segment;
           global List<ProductArray> products;
           //global ProductRecommendation productAddOnList;
           
          //global string brand;
       }
       
       //Add-on change
       /** 
       * @description : This is the class to structure the product Array for Add On Products
       */ 
       global class ProductRecommendation extends ProductPlan{
           public List<ProductArray> productAddOnList;
       }
       
       /** 
   * @description : This is the class to structure the pricing details
   */ 
       public class PricingDetail{
           public String currencyCode;
           public String billingFrequency;
          public String brand;
       }
         /** 
   * @description : This is the class to structure the Addon Products
   
       public virtual class ProductRecommendation{
           public List<ProductArray> productList;
   
       }
       /** 
   * @description : This is the class to structure the product Array
   */ 
       global virtual class ProductArray{
           global String planType;
           global String planName;
           global String productName;
           global String productId;
           global String productCode;
           global String shortDescription;
           global String longDescription;
           global String productType;
           global String format;
           global String freeTrial;
           global String priceListId;
           global String priceListItemId;
           global list<DCPNewSalesYoYUtil.PriceMatrix> priceMatrix;
           //global list<PriceList> priceMatrix;
           //global List<YoYPriceData> yearlyPricing;
           global list<FeatureList> features;
           global List<PricingDetail> pricingDetails;
           //public ProductRecommendation productAddOnList;
       }
       
       /** 
   * @description : This is the class to structure the price Array
   */ 
       global class PriceList{
           global String quantity;
           global String amount;
       }
       
       /** 
   * @description : This is the class to structure the product feature Array
   */    
       global class FeatureList{
           global String platformCategoryFeature;
           global String productCode;
           global String platformGroupSortOrder;
           global String platformGroup;
           global String platformCategoryBenefit;
           global String platformCategorySortOrder;
           global String platformCategory;
       }
       /** 
   * @description : This is the class to structure the service response Array
   */ 
       global class ProductResponse{
           global String statusCode;
           global String status;
           global String statusMsg;
       }
      
       /** 
     * @description : Constructor
     */ 
    public DCPProductRequestDeclaration(){
           system.debug(LoggingLevel.DEBUG,'inside request handler');
       }
       
       
   }