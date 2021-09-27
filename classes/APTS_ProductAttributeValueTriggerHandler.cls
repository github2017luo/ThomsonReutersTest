public with sharing class APTS_ProductAttributeValueTriggerHandler {
    
    public APTS_ProductAttributeValueTriggerHandler() {
    }
    public void OnBeforeInsert(Apttus_Config2__ProductAttributeValue__c[] newObjects){
       }    
    public void OnAfterInsert(Apttus_Config2__ProductAttributeValue__c[] newObjects){
        }    
   
    public void OnBeforeUpdate(Apttus_Config2__ProductAttributeValue__c[] newObjects){
        }
    
   public void OnAfterUpdate(Apttus_Config2__ProductAttributeValue__c[] newObjects){         
        APTS_ProductAttributeValueTriggerHelper.setLineItemFieldsPA(newObjects);
        } 
    
    public void onBeforeDelete(Apttus_Config2__ProductAttributeValue__c[] oldObjects){
        }
}