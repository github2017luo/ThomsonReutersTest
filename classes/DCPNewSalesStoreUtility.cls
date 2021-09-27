/* Class: DCPNewSalesStoreUtility
* Purpose: A utility class to gather store information
* Created: 6/18/2021
**/
/**
* @description A utility class to gather store information
*/
public without sharing class DCPNewSalesStoreUtility {

    /********************************************************************************************************
    *  @description  getStoreDetails - This method fetches store details 
    *  @return StoreWrapper  : Returns the details about store  
    *  @param storeName
    *  @param customerSegment
    *  @param storeType - Store Type (New Sales or Renewals)
    *********************************************************************************************************/
    public static StoreWrapper getStoreDetails(String storeName, String customerSegment, String storeType){
        StoreWrapper storeWrap = null;
        for(APTSECOM_Store__c store : [Select Id, Name, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c, APTSECOM_Customer_Pricing_Segment__c, 
                                       APTSECOM_Default_Contract_Term__c, APTSECOM_Has_Error__c, APTSECOM_Max_No_Of_Attorneys__c, 
                                       APTSECOM_Max_No_Of_PerSeatUsers__c, APTSECOM_Page_Title__c, APTSECOM_Price_List__c, 
                                       Max_Quantity_PM_Recom_Banded__c, Max_Quantity_PM_Recom_PerSeat__c, Type__c 
                                       from APTSECOM_Store__c
                                       where name =:storeName and APTSECOM_Customer_Pricing_Segment__c=:customerSegment 
                                       and Type__c = :storeType limit 1]){
                                           
                                           storeWrap = new StoreWrapper();
                                           storeWrap.storeName= store.Name;
                                           storeWrap.segment= store.APTSECOM_Customer_Pricing_Segment__c;
                                           storeWrap.storeId= store.Id;
                                           storeWrap.storeType= store.Type__c;
                                           storeWrap.adjustAmount = store.APTSECOM_Adjustment_Amount__c;
                                           storeWrap.adjustType = store.APTSECOM_Adjustment_Type__c;
                                           storeWrap.priceListId = store.APTSECOM_Price_List__c;
                                           storeWrap.maxNoOfAttorneys= store.APTSECOM_Max_No_Of_Attorneys__c;
                                           storeWrap.contractTerm= store.APTSECOM_Default_Contract_Term__c;
            
        }        
        return storeWrap;
    }
    
    /**
     * @description wrapper for store data
     */
    public class StoreWrapper{
        public string storeName;
        public string segment;
        public Id storeId;
        public String storeType;
        public String priceListId;
        public String contractTerm;
        public Decimal maxNoOfAttorneys;
        public Integer maxNoPerSeatUsers;
        public Integer maxQtyPmBanded;
        public Decimal adjustAmount;
        public String adjustType;
        public Integer maxQtyPmPerSeat;
    }
}