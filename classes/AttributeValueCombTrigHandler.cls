/*==========================================================================================================
    Purpose: AttributeValueCombTrigHandler.
    
    Change History: created
    
    Developer : Shailesh Patel 

    Modification History: NA
    
===============================================================================================================*/
Public Class AttributeValueCombTrigHandler{
    
    public static void beforeInsert(List<APTS_Attribute_Value_Combination__c> newObj){
        
        //Fetch Attribute Value Ids
        Set<Id> attriValueIds = AttributeValueCombTrigHelper.getAttributeList(newObj);
        
        //Retrieve Map of Attribute Values which are in scope
        Map<Id, APTS_Attribute_Value__c> attributeValuemap = AttributeValueCombTrigHelper.getAttributeValueSobj(attriValueIds);
        
        //Update Attribute Name to Text 
        AttributeValueCombTrigHelper.updateAttributeValues(newObj, attributeValuemap);
        
        //Fetch ProductIds 
        Set<Id> setOfProductIds = AttributeValueCombTrigHelper.getProductIdList(newObj);
        
        //Retrieve Map of Product Values which are in scope
        Map<Id, Product2> productValueMap = AttributeValueCombTrigHelper.getProducts(setOfProductIds);

        //Update Product Fields 
        AttributeValueCombTrigHelper.updateProductValues(newObj, productValueMap);
    }
    
    public static void beforeUpdate(Map<Id, APTS_Attribute_Value_Combination__c> newObjMap, Map<Id,APTS_Attribute_Value_Combination__c> oldObjMap){
        
        //Fetch Attribute Value Ids
        Set<Id> attriValueIds = AttributeValueCombTrigHelper.getAttributeList(newObjMap.Values());
        
        //Retrieve Map of Attribute Values which are in scope
        Map<Id, APTS_Attribute_Value__c> attributeValuemap = AttributeValueCombTrigHelper.getAttributeValueSobj(attriValueIds);
        
        //Update Attribute Name to Text
        AttributeValueCombTrigHelper.updateAttributeValues(newObjMap.Values(), attributeValuemap);
        
        //Fetch ProductIds 
        Set<Id> setOfProductIds = AttributeValueCombTrigHelper.getProductIdList(newObjMap.Values());
        
        //Retrieve Map of Product Values which are in scope
        Map<Id, Product2> productValueMap = AttributeValueCombTrigHelper.getProducts(setOfProductIds);

        //Update Product Fields 
        AttributeValueCombTrigHelper.updateProductValues(newObjMap.Values(), productValueMap);
    }
    
}