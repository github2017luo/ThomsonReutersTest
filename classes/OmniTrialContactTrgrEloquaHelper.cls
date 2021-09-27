/**
* class : OmniTrialContactTrgrEloquaHelper
* JIRA Details: 
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JULY 2021     TCS DevTeam             Created as Part of DPS-20419
*                                       to update the Trial Status Based on the Trail contact status
*                                                                 
* =====================================================================================================================
*/
/**
* @description OmniTrialContactTrgrEloquaHelper
* 
*/

public without sharing class OmniTrialContactTrgrEloquaHelper {
    
    /**
* @description updateEntitlementEmailSentByEloqua
* @param newTrialcontact
*/
    public static void updateEntitlementEmailSentByEloqua(List<Trial_Contact__c> newTrialcontact){
        
        set<id> trailContId= new set<id>();
        System.debug(LoggingLevel.DEBUG, '@@newTrialcontact: '+newTrialcontact);
        for(Trial_Contact__c c: newTrialcontact){ 
            
            if(c.Trials__c!=null && (c.status__c == 'Active' && !c.Entitlement_Email_Sent__c) || 
               (c.status__c == 'Extended' && !c.Extended_Email_Sent__c)){                
                trailContId.add(c.Id);
            }                
        }
        
        if(trailContId != null && trailContId.size() >0 ){
            System.debug(LoggingLevel.DEBUG, '@@trailContId: '+trailContId);
            processEloquaRequest(trailContId);
        }
        
    }    
    
    
     /**
    * @description processEloquaRequest
    * @param trailContId
    */
    public static void processEloquaRequest(set<id> trailContId){
        
        List<Trial_Contact__c> trialContSobjList = fetchTrialContactRecords(trailContId);
        
        Map<Id, List<Trial_Contact__c>> mapTrialWithContacts = getMapTrialWIthTrialContacts(trialContSobjList);
        
        if(mapTrialWithContacts != null && mapTrialWithContacts.size()>0){
            List<Trial_Product__c> trialProdobjList = fetchTrialProductRecords(mapTrialWithContacts.keyset());
            
            Map<Id, List<Trial_Product__c>> mapTrialWithProducts = getMapTrialWIthTrialProducts(trialProdobjList);
            
            if(mapTrialWithProducts != null && mapTrialWithProducts.size()>0  && trialContSobjList != null && trialContSobjList.size()>0){
            for(Trial_Contact__c trialCont : trialContSobjList){
                List<Id> trailProdIdList = fetchListOfProductid(mapTrialWithProducts.get(trialCont.Trials__c));
                List<Id> trailConIdList = fetchListOfContactid(mapTrialWithContacts.get(trialCont.Trials__c));
                sendEloquaRequest(Id.valueOf(trialCont.Trials__c),trailConIdList,trailProdIdList);
                
            }
            }
        }
    }
    
    
    
    
    /**
* @description fetchTrialProductRecords
* @param trailId
* @return trialProdList 
* 
*/    
    
    public static List<Trial_Product__c> fetchTrialProductRecords(set<id> trailId){
        List<Trial_Product__c> trialProdList = new List<Trial_Product__c>();
        if( Schema.sObjectType.Trial_Product__c.isAccessible()){
            trialProdList = [Select id,Trial__c from Trial_Product__c where Trial__c IN: trailId];
        }
        return trialProdList;
    }
    
    /**
* @description getMapTrialWIthTrialContacts
* @param trialConSobjtList
* @return mapTrialWithContacts
*/
    @testVisible
    private static Map<Id, List<Trial_Contact__c>> getMapTrialWIthTrialContacts(List<Trial_Contact__c> trialConSobjtList){
        Map<Id, List<Trial_Contact__c>>  mapTrialWithContacts = new Map<Id, List<Trial_Contact__c>> ();
        if(trialConSobjtList !=null && trialConSobjtList.size()>0){
        for(Trial_Contact__c trialCont : trialConSobjtList){
            if(mapTrialWithContacts.containsKey(trialCont.Trials__c)) {
                List<Trial_Contact__c> trialContList= mapTrialWithContacts.get(trialCont.Trials__c);
                trialContList.add(trialCont);
                mapTrialWithContacts.put(trialCont.Trials__c, trialContList);
            } 
            else 
            {
                mapTrialWithContacts.put(trialCont.Trials__c, new List<Trial_Contact__c> { trialCont });
            }
        }
        }
        return mapTrialWithContacts;
    }
    
    /**
* @description getMapTrialWIthTrialProducts
* @param trialProdobjList
* @return mapTrialWithProducts
*/
    @testVisible
    private static Map<Id, List<Trial_Product__c>> getMapTrialWIthTrialProducts(List<Trial_Product__c> trialProdobjList){
        Map<Id, List<Trial_Product__c>>  mapTrialWithProducts = new Map<Id, List<Trial_Product__c>> ();
        if(trialProdobjList !=null && trialProdobjList.size()>0){
        for(Trial_Product__c trialProd : trialProdobjList){
            if(mapTrialWithProducts.containsKey(trialProd.Trial__c)) {
                List<Trial_Product__c> trialProdList= mapTrialWithProducts.get(trialProd.Trial__c);
                trialProdList.add(trialProd);
                mapTrialWithProducts.put(trialProd.Trial__c, trialProdList);
            } 
            else 
            {
                mapTrialWithProducts.put(trialProd.Trial__c, new List<Trial_Product__c> { trialProd });
            }
            
        }
    }
        return mapTrialWithProducts;
    }
    
    
    /**
* @description sendEloquaRequest
* @param trialId
* @param trialContIds
* @param trialProdIds
*/
    
    @future(callout=true)
    public static void sendEloquaRequest(String trialId, List<Id> trialContIds, List<Id> trialProdIds) {
        if(!Test.isRunningTest()){           
            OmniCalltoEloqua.getOmniTrialsEloquaCalls(trialId,trialContIds,trialProdIds);
        }
    }
    
     /**
* @description fetchListOfContactid
* @param trailConList
* @return trialconidList
*/
    
    public static List<id> fetchListOfContactid(List<Trial_Contact__c> trailConList ){
        List<Id> trialconidList = new List<id>();
        for (Trial_Contact__c trailCon : trailConList){
            trialconidList.add(trailCon.id);
        }
        return trialconidList;
        
    }
    
    
     /**
* @description fetchListOfProductid
* @param trailProdList
* @return trailProdIdList
*/
    public static List<id> fetchListOfProductid(List<Trial_Product__c> trailProdList ){
        List<Id> trailProdIdList = new List<id>();
        for (Trial_Product__c trailProd : trailProdList){
            trailProdIdList.add(trailProd.id);
        }
        return trailProdIdList;
        
    }
    
    /**
* @description fetchTrialContactRecords
* @param trailContId
* @return trialContList 
* 
*/    
    
    private static List<Trial_Contact__c> fetchTrialContactRecords(set<id> trailContId){
        List<Trial_Contact__c> trialContList = new List<Trial_Contact__c>();
        if( Schema.sObjectType.Trial_Contact__c.isAccessible()){
            trialContList = [Select id, Status__c,Trials__c,Entitlement_Email_Sent__c  from Trial_Contact__c where ID IN: trailContId];
        }
        return trialContList;
    }
}