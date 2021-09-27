/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                     Name                                          Description
 * 2019-02-13   Shiva Sri Arun Koralla         DLT-15150 [NSE ALL][Tech Story] Salesforce service to get pricing for Materials
 * ==================================================================================================================================   
 */
Global class Ecom_GetProductDetails_Response{
         
    public cls_products[] products;
    public List<Ecom_StoreResponse.cls_ContractTermDetails> contractTermDetails;
    public PriceMatrix[] priceMatrix;
    
    public class cls_products {
        public String shortDescription;      //null
        public String productTitle;          //null
        public String productName;           //SL Primary - Minnesota (Westlaw PRO™)
        public String productId;             //a4N0m00000054QlEAI
        public String pricingModel;          //Banded
        public Material[] material;
        public PriceMatrix[] priceMatrix;
    }
    
    public class PriceMatrix
    {
        public Integer quantity;      
        public String contractTerm;
        public Decimal amount;
    }

    public class Material {
        public String subscriptionNumber;
        public String productPlanId;    
        public Integer productGroupSortOrder;
        public String productGroup;
        public String materialNumber;
        public String materialId;
        public String materialDescription;  
        public String jurisdiction;
        public String internalDescription;  
        public Integer classificationValueSortOrder;
        public String classificationValue;  
    }
     public class Adjustments {
        public String adjustmentType;
        public Decimal adjustmentAmount;
        public String categoryId;
    }
    public static Ecom_GetProductDetails_Response parse(String json){
        return (Ecom_GetProductDetails_Response) System.JSON.deserialize(json, Ecom_GetProductDetails_Response.class);
    }
    
    
    public static void testParse() {
        String json=        '{'+
        '             "products": ['+
        '              {'+
        '                "shortDescription": "",'+
        '                "productTitle": "",'+
        '                "productName": "SL Primary - Minnesota (Westlaw PRO™)",'+
        '                "productId": "a4N0m00000054QlEAI",'+
        '                "pricingModel": "Banded",'+
        '                "material": ['+
        '                  {'+
        '                    "subscriptionNumber": "40973618",'+
        '                    "productPlanId": "01t30000003ilKBAAY",'+
        '                    "productGroupSortOrder": 2,'+
        '                    "productGroup": "Secondary Sources/Analytical",'+
        '                    "materialNumber": "40982163",'+
        '                    "materialId": "a9f0m0000004ERHAA2",'+
        '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",'+
        '                    "jurisdiction": "CA",'+
        '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",'+
        '                    "classificationValueSortOrder": 3,'+
        '                    "classificationValue": "Forms"'+
        '                  },'+
        '                  {'+
        '                    "subscriptionNumber": "40973618",'+
        '                    "productPlanId": "01t30000003ilKBAAY",'+
        '                    "productGroupSortOrder": 2,'+
        '                    "productGroup": "Secondary Sources/Analytical",'+
        '                    "materialNumber": "40982163",'+
        '                    "materialId": "a9f0m0000004EfQAAU",'+
        '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",'+
        '                    "jurisdiction": "CA",'+
        '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",'+
        '                    "classificationValueSortOrder": 9,'+
        '                    "classificationValue": "Practice Guide"'+
        '                  },'+
        '                  {'+
        '                    "subscriptionNumber": "40973618",'+
        '                    "productPlanId": "01t30000003ilKBAAY",'+
        '                    "productGroupSortOrder": 2,'+
        '                    "productGroup": "Secondary Sources/Analytical",'+
        '                    "materialNumber": "40982163",'+
        '                    "materialId": "a9f0m0000004Ek7AAE",'+
        '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",'+
        '                    "jurisdiction": "Federal,CA",'+
        '                    "internalDescription": "Legal publications on a particular subject.",'+
        '                    "classificationValueSortOrder": 12,'+
        '                    "classificationValue": "Treatise"'+
        '                  }'+
        '                ],'+
        '                "priceMatrix": ['+
        '                  {'+
        '                    "quantity": 1,'+
        '                    "amount": 100'+
        '                  },'+
        '                  {'+
        '                    "quantity": 2,'+
        '                    "amount": 120'+
        '                  },'+
        '                  {'+
        '                    "quantity": 3,'+
        '                    "amount": 140'+
        '                  }'+
        '                ]'+
        '}';
        Ecom_GetProductDetails_Response obj = parse(json);
    }
}