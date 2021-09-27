/**
* Controller class for TrainingEventProductsList visualforce component. This is used to show the products which will be covered in the training event.
*
* @author  Saloni Sukhija
* @version 2018-04-12
*/

public class TrainingEventProductsListController{

    public Id trainingEventId{get;set;}
    public List<Training_Event_Product__c> prods{get;set;}
        
    public List<Training_Event_Product__c> getProducts(){
        prods = new List<Training_Event_Product__c>();
        prods = [SELECT LCRM_Product__r.Name FROM Training_Event_Product__c WHERE LCRM_Training_Event__c = :trainingEventId];
        
        return prods;
    }
}