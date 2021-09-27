Global class Ecom_StoreResponse {

    public String responseMessage; //Success
    public Integer responseCode; //2000
    public cls_storeDetails[] storeDetails;
    public class cls_storeDetails {
        public String storeName; //Small Law
        public String storeId;
        public Integer quantityRequested; //1
        public String[] jurisdictionRequested;
        public Integer maxNoOfPerSeatUsers; //...
        public Integer maxNoOfAttorneys;
        public String defaultContractTerm;
        public String adjustmentType;
        public Decimal adjustmentAmount;
        public Integer noOfRecommendations;
        public cls_productCatalog productCatalog;
        public cls_promoCode[] promotions;
        public List < Ecom_StoreResponse.cls_ContractTermDetails > contractTermDetails = new List < Ecom_StoreResponse.cls_ContractTermDetails > ();
    }

    public class cls_promoCode {
        public String id;
        public String promoCode;
        public String description;
        public Boolean isActive;
        public date startDate;
        public date endDate;
        public String validContractTerms;
        public Decimal minQuantity;
        public Decimal maxQuantity;
        public String validJurisdiction;
        public String adjustmentType;
        public Decimal adjustmentAmount;
    }

    public class cls_productCatalog {
        public cls_sections[] sections;
    }
    public class cls_sections {
        public Integer sequenceNo;
        public String categoryId;
        public Boolean hasProducts;
        public Integer sectionLevel;
        public String sectionName;
        public String sectionTitle;
        public cls_sections[] sections;
        public PriceMatrix[] minPriceMatrix;
        public cls_products[] products;
        public PriceMatrix[] priceMatrix;
    }

    public class cls_ContractTermDetails {
        public string categoryId;
        public List < ContractTermDetail > terms;
    }

    public class ContractTermDetail {
        public String term;
        public String planID;
        public String planName;
        public Decimal markupPercentage;
        public Decimal yearOnYearRenewal;
        public Decimal yearOnYearTwoPlus;
    }
    public class cls_products {
        public String productId; //a4N0m00000054QlEAI
        public String productName; //
        public String productTitle; //
        public String jurisdiction; //
        public String shortDescription; //
        public String longDescription; //
        public String pricingModel; //
        public string cType;
        public Material[] material;
        public PriceMatrix[] priceMatrix;
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
    public class PriceMatrix {
        public Integer quantity;
        public Decimal amount;
        public String contractTerm;
        public transient String productId;
    }

    public class Adjustments {
        public String adjustmentType;
        public Decimal adjustmentAmount;
        public String categoryId;
    }

    public static Ecom_StoreResponse parse(String json) {
        return (Ecom_StoreResponse) System.JSON.deserialize(json, Ecom_StoreResponse.class);
    }

    public static void testParse() {
        String json = '{' +
            '  "responseMessage": "Success",' +
            '  "responseCode": 200,' +
            '  "storeDetails": [' +
            '    {' +
            '      "storeName": "Small Law",' +
            '      "storeId": "a4N0m00000054QlEAI",' +
            '      "quantityRequested": 1,' +
            '      "jurisdictionRequested": ["National/Federal",' +
            '      "Minnesota"' +
            '        ],' +
            '      "maxNoOfPerSeatUsers": 10,' +
            '      "maxNoOfAttorneys": 3,' +
            '      "defaultContractTerm": "3 Years",' +
            '      "noOfRecommendations": 2,' +
            '      "productCatalog": {' +
            '        "sections": [' +
            '          {' +
            '            "sectionTitle": "State Primary",' +
            '            "sectionName": "State Primary",' +
            '            "sectionLevel": 1,' +
            '            "hasProducts": true,' +
            '            "categoryId": "",' +
            '            "sequenceNo": 1,' +
            '            "sections": null,' +
            '           "minPriceMatrix": [' +
            '             {' +
            '               "quantity": 1,' +
            '               "amount": 210' +
            '             },' +
            '             {' +
            '               "quantity": 2,' +
            '               "amount": 240' +
            '             },' +
            '             {' +
            '               "quantity": 3,' +
            '               "amount": 260' +
            '             }' +
            '           ],' +
            '            "products": [' +
            '              {' +
            '                "productId": "a4N0m00000054QlEAI",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              },' +
            '              {' +
            '                "productId": "",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              },' +
            '              {' +
            '                "productId": "",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              }' +
            '            ]' +
            '          },' +
            '          {' +
            '            "sectionTitle": "State Primary & Analytical",' +
            '            "sectionName": "State Primary & Analytical",' +
            '            "sectionLevel": 1,' +
            '            "hasProducts": true,' +
            '            "categoryId": "",' +
            '            "sequenceNo": 2,' +
            '            "sections": null,' +
            '           "minPriceMatrix": [' +
            '             {' +
            '               "quantity": 1,' +
            '               "amount": 260' +
            '             },' +
            '             {' +
            '               "quantity": 2,' +
            '               "amount": 280' +
            '             },' +
            '             {' +
            '               "quantity": 3,' +
            '               "amount": 300' +
            '             }' +
            '           ],' +
            '            "products": [' +
            '              {' +
            '                "productId": "a4N0m00000054QlEAI",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              },' +
            '              {' +
            '                "productId": "",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              },' +
            '              {' +
            '                "productId": "",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              }' +
            '            ]' +
            '          },' +
            '          {' +
            '            "sectionTitle": "National Primary & State Analytical",' +
            '            "sectionName": "National Primary & State Analytical",' +
            '            "sectionLevel": 1,' +
            '            "hasProducts": true,' +
            '            "categoryId": "",' +
            '            "sequenceNo": 3,' +
            '            "sections": null,' +
            '           "minPriceMatrix": [' +
            '             {' +
            '               "quantity": 1,' +
            '               "amount": 300' +
            '             },' +
            '             {' +
            '               "quantity": 2,' +
            '               "amount": 320' +
            '             },' +
            '             {' +
            '               "quantity": 3,' +
            '               "amount": 340' +
            '             }' +
            '           ],' +
            '            "products": [' +
            '              {' +
            '                "productId": "a4N0m00000054QlEAI",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              },' +
            '              {' +
            '                "productId": "",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              },' +
            '              {' +
            '                "productId": "",' +
            '                "productName": "",' +
            '                "productTitle": "",' +
            '                "jurisdiction": "",' +
            '                "shortDescription": "",' +
            '                "longDescription": "",' +
            '                "pricingModel": "",' +
            '                "material": [' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004ERHAA2",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Text forms, fillable PDF forms, clauses and checklists from numerous form sets, including legal and business, transactional, litigation and pleading and practice forms. Coverage is based on the jurisdictions in your subscription.",' +
            '                    "classificationValueSortOrder": 3,' +
            '                    "classificationValue": "Forms"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004EfQAAU",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "CA",' +
            '                    "internalDescription": "Procedural guides includes key citations to statutes, rules, and cases, forms and \"how to\" practice pointers.",' +
            '                    "classificationValueSortOrder": 9,' +
            '                    "classificationValue": "Practice Guide"' +
            '                  },' +
            '                  {' +
            '                    "subscriptionNumber": "40973618",' +
            '                    "productPlanId": "01t30000003ilKBAAY",' +
            '                    "productGroupSortOrder": 2,' +
            '                    "productGroup": "Secondary Sources/Analytical",' +
            '                    "materialNumber": "40982163",' +
            '                    "materialId": "a9f0m0000004Ek7AAE",' +
            '                    "materialDescription": "WN PRO RUTTER CIVIL BANDED",' +
            '                    "jurisdiction": "Federal,CA",' +
            '                    "internalDescription": "Legal publications on a particular subject.",' +
            '                    "classificationValueSortOrder": 12,' +
            '                    "classificationValue": "Treatise"' +
            '                  }' +
            '                ],' +
            '                "priceMatrix": [' +
            '                  {' +
            '                    "quantity": 1,' +
            '                    "amount": 100' +
            '                  },' +
            '                  {' +
            '                    "quantity": 2,' +
            '                    "amount": 120' +
            '                  },' +
            '                  {' +
            '                    "quantity": 3,' +
            '                    "amount": 140' +
            '                  }' +
            '                ]' +
            '              }' +
            '            ]' +
            '          }' +
            '        ]' +
            '      }' +
            '    }' +
            '  ]' +
            '}';
        Ecom_StoreResponse obj = parse(json);
    }
}