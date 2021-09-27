/*==========================================================================================================
    Purpose: To populate lookup to text on Attirbute Value Combination object.
    
    Change History: created
    
    Developer : Shailesh Patel 

    Modification History: NA
    
===============================================================================================================*/
public with sharing class AttributeValueCombTrigHelper{
   
    //Assign Attribute Value Name To Text Field 
    public static void updateAttributeValues(List<APTS_Attribute_Value_Combination__c> newSObjList, Map<Id, APTS_Attribute_Value__c> attributeValuemap){
                
        for(APTS_Attribute_Value_Combination__c attributeVal :  newSObjList){
        
            String attr0Name = null;
            String attr1Name = null;
            String attr2Name = null;
            String attr3Name = null;
            
            if(String.isNotBlank(attributeVal.APTS_Attribute_Value0__c)){
                attr0Name = attributeValueMap.get(attributeVal.APTS_Attribute_Value0__c).Name;
            }
            if(String.isNotBlank(attributeVal.APTS_Attribute_Value1__c)){
                attr1Name = attributeValueMap.get(attributeVal.APTS_Attribute_Value1__c).Name;
            }
            if(String.isNotBlank(attributeVal.APTS_Attribute_Value2__c)){
                attr2Name = attributeValueMap.get(attributeVal.APTS_Attribute_Value2__c).Name;
            }
            if(String.isNotBlank(attributeVal.APTS_Attribute_Value3__c)){
                attr3Name = attributeValueMap.get(attributeVal.APTS_Attribute_Value3__c).Name;
            }
            attributeVal.Attribute0_Name__c = attr0Name;
            attributeVal.Attribute1_Name__c = attr1Name;
            attributeVal.Attribute2_Name__c = attr2Name;
            attributeVal.Attribute3_Name__c = attr3Name;
            
        }
    }
    
    //Add Ids of Attribute Value 
    public static Set<Id> getAttributeList(List<APTS_Attribute_Value_Combination__c> listNewSobj){
        
        Set<Id> listIds = new Set<Id>();
        
        for(APTS_Attribute_Value_Combination__c attrValComb : listNewSobj){
            listIds.add(attrValComb.APTS_Attribute_Value0__c);
            listIds.add(attrValComb.APTS_Attribute_Value1__c);
            listIds.add(attrValComb.APTS_Attribute_Value2__c);
            listIds.add(attrValComb.APTS_Attribute_Value3__c);
        }
        return listIds;
    }
    
    //Fetch Attribute Value records
    public static Map<Id, APTS_Attribute_Value__c> getAttributeValueSobj(Set<Id> listIds){
        
        Map<Id, APTS_Attribute_Value__c> attributeValMap= new Map<Id, APTS_Attribute_Value__c>([Select id,name
                                                                     from APTS_Attribute_Value__c where Id IN :listIds]);
        return attributeValMap;
    }
    
    //Prepare ProductIDs
    public static Set<Id> getProductIdList(List<APTS_Attribute_Value_Combination__c> listNewSobj){
        
        Set<Id> setOfProductIds = new Set<Id>();
        
        for(APTS_Attribute_Value_Combination__c attrValComb : listNewSobj){
            if(attrValComb.APTS_Product__c != null){
                setOfProductIds.add(attrValComb.APTS_Product__c);
            }
        }
        return setOfProductIds;
    }
    
    //Fetch values from Product
    public static Map<Id, Product2> getProducts(Set<Id> listIds){
        
        Map<Id, Product2> productMap = new Map<Id, Product2>([Select id, name, ProductCode, APTS_CustomUI_Category__c
                                                                     from Product2 where Id IN :listIds]);
        return productMap;
    }
    
    //Assign Product Field Values
    public static void updateProductValues(List<APTS_Attribute_Value_Combination__c> newSObjList, Map<Id, Product2> productValueMap){

        String productName = null;
        String prodCustomUI = null;
        String productCode = null;
        
        for(APTS_Attribute_Value_Combination__c attributeVal : newSObjList){
        
            if(String.isNotBlank(attributeVal.APTS_Product__c)){
                productName = productValueMap.get(attributeVal.APTS_Product__c).Name;
                prodCustomUI = productValueMap.get(attributeVal.APTS_Product__c).APTS_CustomUI_Category__c;
                productCode = productValueMap.get(attributeVal.APTS_Product__c).ProductCode;
            }
            
            attributeVal.APTS_Product_Name__c = productName;
            attributeVal.APTS_CustomUI_Category__c = prodCustomUI;
            attributeVal.APTS_Product_Code__c = productCode;
        }
    }
}