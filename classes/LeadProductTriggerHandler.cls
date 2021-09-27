/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-16   Shailesh Patel          Created
 * =============================================================================
 */ 
public class LeadProductTriggerHandler{
    
    static List<String> listTrialIds;
    static List<String> listCellCodes;
    
    //TO Handle the recusion call
    public static Boolean trialProductFlag = true;
    
    public static void handlBeforeInsert(List<LCRM_Recommended_Product__c> listOfLeadPrd){
    
        //DLT-9069-Store Trial Id and Cell Code from Lead Product records to fetch related Product Records
        listTrialIds = New List<String>();
        listCellCodes = New List<String>();
        LIST<Id> ProdLeadIds = new LIST<Id>();
        
        for(LCRM_Recommended_Product__c leadPrd : listOfLeadPrd){
            if(String.isNotBlank(leadPrd.Trial_ID__c)){
                listTrialIds.add(leadPrd.Trial_ID__c);
            }
            
            if(String.isNotBlank(leadPrd.Cell_Code__c)){
                listCellCodes.add(leadPrd.Cell_Code__c);
            }
            
            if(String.isNotBlank(leadPrd.LCRM_Lead_Name__c) && String.isBlank(leadPrd.Trial_Details__c))
                ProdLeadIds.add(leadPrd.LCRM_Lead_Name__c);
        }
        
        leadProductLookUpdate(listOfLeadPrd);
        
        if(!ProdLeadIds.isEmpty())
            updateTrialDetailsOnrecomProd(listOfLeadPrd, ProdLeadIds);
    }
    
    public static void handlBeforeUpdate(List<LCRM_Recommended_Product__c> listOfLeadPrd, Map<Id,LCRM_Recommended_Product__c> oldMapTrigger){
        
        //DLT-9069-Store Trial Id and Cell Code from Lead Product records to fetch related Product Records
        listTrialIds = New List<String>();
        listCellCodes = New List<String>();
        LIST<Id> ProdLeadIds = new LIST<Id>();
        
        for(LCRM_Recommended_Product__c leadPrd : listOfLeadPrd){
            LCRM_Recommended_Product__c oldLeadPrd = oldMapTrigger.get(leadPrd.Id);
            
            if(oldLeadPrd.Trial_ID__c != leadPrd.Trial_ID__c || oldLeadPrd.Cell_Code__c != leadPrd.Cell_Code__c || oldLeadPrd.LCRM_Product_Name__c != leadPrd.LCRM_Product_Name__c)
            {
                if(String.isNotBlank(leadPrd.Trial_ID__c)){
                    listTrialIds.add(leadPrd.Trial_ID__c);
                }
                
                if(String.isNotBlank(leadPrd.Cell_Code__c)){
                    listCellCodes.add(leadPrd.Cell_Code__c);
                }
                if(String.isNotBlank(leadPrd.LCRM_Lead_Name__c) && String.isBlank(leadPrd.Trial_Details__c))
                    ProdLeadIds.add(leadPrd.LCRM_Lead_Name__c);
            }
            
            if(oldLeadPrd.LCRM_Lead_Name__c != leadPrd.LCRM_Lead_Name__c){
                ProdLeadIds.add(leadPrd.LCRM_Lead_Name__c);
            }
            
        }
        
        leadProductLookUpdate(listOfLeadPrd);
        
         if(!ProdLeadIds.isEmpty())
            updateTrialDetailsOnrecomProd(listOfLeadPrd, ProdLeadIds);
    }
     
    private static void leadProductLookUpdate(List<LCRM_Recommended_Product__c> listOfLeadPrd)
    {        
        
        //To fetch List of Product records based on Trial Id and Cell Code
        List<Product2> listRelatedPrd = [Select Id, ProductCode, Cellcode__c from Product2 Where (ProductCode IN : listTrialIds AND  Cellcode__c IN : listCellCodes )];
        System.debug('@@listRelatedPrd: '+listRelatedPrd);
        
        //Create Map - Product Id as a Value and Contcate ProductCode and Cell Code as a Key.
        Map<String, String> mapProducts = New Map<String, String>();
        for(Product2 prd : listRelatedPrd){
                //Trial ID and Cell Code combination is unique on Product Object
                mapProducts.put(prd.ProductCode+''+prd.Cellcode__c, prd.ID);
        }
        System.debug('@@mapProducts: '+mapProducts);
        
        
        //Find Related Product Id from the map and populate on Led Product records
        for(LCRM_Recommended_Product__c leadPrd : listOfLeadPrd){
            
            //to fetch Product ID from Map which is cretaed from the Product Object
            String prdId = mapProducts.get(leadPrd.Trial_ID__c+''+leadPrd.Cell_Code__c);
            if(prdId != null)
            leadprd.LCRM_Product_Name__c = prdId;
        }
    }
    
    
    private static void updateTrialDetailsOnrecomProd(LIST<LCRM_Recommended_Product__c> recommendedProds, LIST<ID> leadIds){
        try{
            LIST<Trial__c> trialDetails = new LIST<Trial__c>([SELECT ID, Name, Contact_LeadId__c FROM Trial__c WHERE Contact_LeadId__c IN:leadIds ]);
            
            MAP<id, id> leadTrialIds = new MAP<id, id>();  //Leadid,TrialId loading
            
            for(Trial__c t: trialDetails){
                leadTrialIds.put(t.Contact_LeadId__c , t.id);
            }
            
            for(LCRM_Recommended_Product__c rp: recommendedProds){
                if(leadTrialIds.containsKey(rp.LCRM_Lead_Name__c))
                    rp.Trial_Details__c = leadTrialIds.get(rp.LCRM_Lead_Name__c);
            }
        }catch(exception e){system.debug('Exception LeadProductTriggerHandler'+e);}    
    }
    
    
}