/**
 * Provides methods helper methods for working with Orders 
 * @author  Anshita Sharma
 * @version 2013-02-06
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-02-06   Anshita Sharma          Created                                                       
 * =============================================================================
 */

  
public class OrderHandler{ 
  
  //method will check the lowest order for each quote associated with an oppty 
  //and update oppty order status field.
  
  @future
  public static void updateOpportunity(List<Id> QuoteIds){  
      
      Map<String,Order_Status__c> orderStatusSortingMap = new Map<String, Order_Status__c>();
      Map<Id, String> oppStatusMap = new Map<Id, String>();  
      Map<String, Order__c> OrderTimeStampMap = new Map<String, Order__c>();
      List<Opportunity> oppListToUpdate = new List<Opportunity>();
      List<Order__c> orderToDelete = new List<Order__c>();
          
      //get the sorting order from custom setting
      
      //orderStatusSortingMap = Order_Status__c.getAll();
      List<Order_Status__c> orderStatusList = Order_Status__c.getAll().values();
      for(Order_Status__c oStat:orderStatusList){
          orderStatusSortingMap.put(oStat.SFDC_Order_Status__c, oStat);
      }
      
      //check for duplicate orderIDs and delete the one with older timestamp
          
      List<Order__c> orderList = [Select id, Order_Number__c, Order_Status__c, Quote__c, Quote__r.OpportunityId, timestamp__c from Order__c where Quote__c In : QuoteIds Order by timestamp__c desc];
      for(Order__c oOrder: orderList){
          if(!OrderTimeStampMap.containsKey(oOrder.Order_Number__c))
              OrderTimeStampMap.put(oOrder.Order_Number__c, oOrder);
          else{
              if(oOrder.timestamp__c > OrderTimeStampMap.get(oOrder.Order_Number__c).timestamp__c)
                  orderToDelete.add(OrderTimeStampMap.get(oOrder.Order_Number__c));
              else
                  orderToDelete.add(oOrder);    
          }
        }  
        if(!orderToDelete.isEmpty())
            delete orderToDelete ; 
      
      
      //Based on quote Ids, get orders and opportunity
        
      List<Order__c> listOrders = [Select id,Order_Number__c,Order_Status__c, Quote__c, Quote__r.OpportunityId, timestamp__c  from Order__c where Quote__c In:QuoteIds];
      for(Order__c oOrder: listOrders){
          //create oppty and order status map using the custom setting to check lowest value
          if(!oppStatusMap.containsKey(oOrder.Quote__r.OpportunityId))
              oppStatusMap.put(oOrder.Quote__r.OpportunityId, oOrder.Order_Status__c); 
          else{
              
              String tempStatus = oppStatusMap.get(oOrder.Quote__r.OpportunityId);
              Integer i = Integer.valueOf(orderStatusSortingMap.get(tempStatus).Sorting_Order__c); 
              Integer j = Integer.valueOf(orderStatusSortingMap.get(oOrder.Order_Status__c).Sorting_Order__c);
              if(j<i){
                  oppStatusMap.remove(oOrder.Quote__r.OpportunityId);
                  oppStatusMap.put(oOrder.Quote__r.OpportunityId, oOrder.Order_Status__c);
              }          
          }         
              
      } 
     
      //Commenting out below section regarding IM02317545 (SFD-1289). As per Business, the stage value should not update in any scenario below. Commented by Aman Bhansali 11/01/2016.    
      //if(oppStatusMap.size()!=0){
          //query the opportunties and update the order status with lowest value
         // for(Opportunity oOppty :[Select id,Order_Status__c, StageName from Opportunity where id In:oppStatusMap.keySet()]){
              //Opportunity oOpp = new Opportunity(id =oOppty.id);
              //check if the opp order status is being changed from completed status to non completed status.
            //  if(oOppty.Order_Status__c == 'Order Completed' && oppStatusMap.get(oOppty.id) != oOppty.Order_Status__c)
                 // oOppty.StageName ='95%';
              // if all orders all complete, move oppty to 100%
            //  if(oppStatusMap.get(oOppty.id) == 'Order Completed')
                  //oOppty.StageName ='100%';//Commented by Piyali SFD-1032 as we have change it to 95%
                  //oOppty.StageName ='95%';
             // oOppty.Order_Status__c = oppStatusMap.get(oOppty.id);
              
              
             // oppListToUpdate.add(oOppty);                 
          //}
          if(!oppListToUpdate.isEmpty())
              update oppListToUpdate;
      //}    
   }
}