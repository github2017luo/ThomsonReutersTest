/**
 * @description       : DPS-20709 OmniTrialProductRelationship
 * @author            : 
 * @group             : 
 * @last modified on  : 
 * @last modified by  : TCS Trial Teaem
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   JUN 2021   Initial Version
**/
public without sharing  class OmniTrialProductRelationship {

    public static List<ProductRelationShipWrap> productRelationList = new List<ProductRelationShipWrap>();

    /**
     * @description ProductRelationShipWrap
    **/
    public class ProductRelationShipWrap{
        
        public Id productId;//Product 2 record Id
        public String segmentType;//To be fetched from Segment__c field of  Product_Relationship__c object
        public String relationshipType;// To be fetched from Relationship_Type__c  field of Product_Relationship__c object
        public String baseMaterialNumber;// Product From Lookup value
        public String baseMaterialName;// Product From Lookup value - Name
    }

    /**
     * @description ProductRelationShipIdsWrap
    **/
    public class ProductRelationShipIdsWrap{
        
        public List<ProductRelationShipWrap> productRelationListWrap;//Product 2 record Id
        public Set<id> prodFromToIds;
    }

    /**
    * @description getProducts
    * @return prdRelIds ProductRelationShipIdsWrap
    */
    public static ProductRelationShipIdsWrap getProducts(){
        
        //productRelationList = new List<ProductRelationShipWrap>();
        
        list<Product_Relationship__c>  prdRelationList = getTrialPrdRelationShipList();
        
        Set<Id> productToIds = getProductToIds(prdRelationList);
        
        //get Product From Ids which has Type Accesssory Product
        Set<Id> productFromIds = getProductFromIds(productToIds);
        
        Set<Id> prodFromToIds = new Set<Id>();
        prodFromToIds.addAll(productToIds);
        prodFromToIds.addAll(productFromIds);
        
        ProductRelationShipIdsWrap prdRelIds = new ProductRelationShipIdsWrap();
        prdRelIds.productRelationListWrap = productRelationList;
        prdRelIds.prodFromToIds = prodFromToIds;
        System.debug(LoggingLevel.DEBUG,'prdRelIds: '+prdRelIds);
        return prdRelIds;
    }
        

    /**
     * @description getProductRelationShipWrap
     * @param prdRelation
     * @return prdWrapper
     */
    @testVisible
    private static ProductRelationShipWrap  getProductRelationShipWrap(Product_Relationship__c prdRelation){
    
        ProductRelationShipWrap prdWrapper = new ProductRelationShipWrap();
        prdWrapper.segmentType = prdRelation.Segment__c;
        prdWrapper.relationshipType = prdRelation.Relationship_Type__c;
        prdWrapper.baseMaterialName = prdRelation.Product_From__r.name;
        prdWrapper.baseMaterialNumber = prdRelation.Product_From__c;
        
        return prdWrapper;
    }   
    /**
     * @description getProductFromIds
     * @param productToIds
     * @return productFromIds
     */
    @testVisible
    private static Set<Id>  getProductFromIds(Set<Id>  productToIds){
        
        Set<Id> productFromIds  = new Set<Id>();
        list<Product_Relationship__c> productAddOnList = new list<Product_Relationship__c>();
        //Get the Add-Ons for the Best product (Law Firm/In House Counsel or Government)
        if(Schema.sObjectType.Product_Relationship__c.isAccessible()){
            productAddOnList = [select Product_To__c,Product_To__r.name, Product_From__c,Product_From__r.Name, Relationship_Type__c, Relationship_Link_Type__c, Segment__c from Product_Relationship__c where (Product_To__r.Free_Trial__c = 'Digital;Omni' OR Product_To__r.Free_Trial__c = 'Omni') AND (Product_From__c =:productToIds and Relationship_Type__c = 'Accessory Product') ];
        }
        System.debug(LoggingLevel.DEBUG,'productAddOnList : '+productAddOnList );
        //Best Product and associated Add On's
        for(Product_Relationship__c prAddOn: productAddOnList){
        
                productFromIds.add(prAddOn.Product_To__c);
                
                ProductRelationShipWrap  prdWrap = getProductRelationShipWrap(prAddOn);
                prdWrap.productId = prAddOn.Product_To__c;
                productRelationList.add(prdWrap);
            
        }
        System.debug(LoggingLevel.DEBUG,'productFromIds: '+productFromIds);
        return productFromIds;   
    }

    /**
     * @description getProductToIds
     * @param prdRelationList
     * @return productToIds
     */
    @testVisible
    private static Set<Id>  getProductToIds(list<Product_Relationship__c>  prdRelationList){
        Set<Id> productToIds  = new Set<Id>();
        
        for(Product_Relationship__c prdRel :   prdRelationList){
            productToIds.add(prdRel.Product_To__c);
            
        ProductRelationShipWrap  prdWrap = getProductRelationShipWrap(prdRel);
        prdWrap.productId = prdRel.Product_To__c;
        productRelationList.add(prdWrap);
        }
        System.debug(LoggingLevel.DEBUG,'productToIds: '+productToIds);
        return productToIds;   
    }

    /**
     * @description getTrialPrdRelationShipList
     * @return productRelList
     */
    @testVisible
    private static list<Product_Relationship__c>  getTrialPrdRelationShipList(){

        list<Product_Relationship__c> productRelList = new list<Product_Relationship__c> ();
        // mapProdtoSegmentandPlan - Map which gives details of a Product and associated Segment/Plan.
        // One propduct can be avialable in multiple segment - however not for MVP1.
        if(Schema.sObjectType.Product_Relationship__c.isAccessible()){
         productRelList = [select Product_To__c,Product_To__r.name, Product_From__c,Product_From__r.name,  Relationship_Link_Type__c, Segment__c,Relationship_Type__c  from Product_Relationship__c
                                                        where (Product_To__r.Free_Trial__c = 'Digital;Omni' OR Product_To__r.Free_Trial__c = 'Omni') ];
        }
        System.debug(LoggingLevel.DEBUG,'productRelList: '+productRelList);
        return productRelList;
    }
}