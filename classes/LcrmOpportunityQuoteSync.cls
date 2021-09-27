/*
===============================================================================
* Contains methods to keep opportunity and proposal in  sync using custom metadata named 'lcrm_opportunity_quote_sync__mdt' 
===============================================================================

PURPOSE: Keep the values of below fields in sync 

Opportunity
Opportunity.Bill_To_Account_SSD__c
Opportunity.Bill_To_Contact_SSD__c
Opportunity.Ship_To_Account_SSD__c
Opportunity.Ship_To_Contact__c
Opportunity.Payer_Account_SSD__c

Proposal 
APTS_Bill_To_Contact__c
APTS_Payer__c
APTS_Ship_To_Contact__c
APTS_SSD_bill_to__c
APTS_SSD_ship_to__c


CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-06-22    TCS Developer             Created for : DPS-16170                                         
===============================================================================
*/
public without sharing class LcrmOpportunityQuoteSync implements Queueable {
    public static Boolean invokeOnce=false;
    List<sobject> listsobject = new List<sobject>();
    Map<Id, sobject> mapOldSobj= new Map<Id, sobject>();
    Map<Id, sobject> mapNewSobj= new Map<Id, sobject>();
    List<sobject> opptylistsobject = new List<sobject>();
    List<sobject> proposallistsobject = new List<sobject>();
    String objectname = '';
    
    
    public LcrmOpportunityQuoteSync(list<sobject> newList){
        this.listsobject=new List<sobject>(newList);
        
    }
    public LcrmOpportunityQuoteSync(list<sobject> newList, Map<Id,sobject> oldMap, Map<Id, sobject> newMap ){
        this.listsobject=new List<sobject>(newList);
        this.mapOldSobj= oldMap;
        this.mapNewSobj= newMap;
    }

    public  void execute(QueueableContext qc){
        system.debug('In Execute invokeOnce--'+invokeOnce);
        objectname = (listsobject[0].id).getSObjectType().getDescribe().getName();
        System.debug('objectname@@@ '+objectname);
        if(objectname=='Opportunity'){
            System.debug('mapOldSobj.isEmpty()#### '+mapOldSobj.isEmpty());
            if(mapOldSobj.isEmpty()){
                opptylistsobject= onInsert(listsobject,objectname);
            }
            else{
                opptylistsobject=onUpdate(listsobject,mapOldSobj,mapNewSobj,objectname);
            }
        }
        else if(objectname=='Apttus_Proposal__Proposal__c'){
            System.debug('mapOldSobj.isEmpty()#### '+mapOldSobj.isEmpty());
            if(mapOldSobj.isEmpty()){
                proposallistsobject= onInsert(listsobject,objectname);
            }
            else{
                proposallistsobject=onUpdate(listsobject,mapOldSobj,mapNewSobj,objectname);
            }   
        }
        System.debug('opptylistsobject.size()' +opptylistsobject.size());
        System.debug('proposallistsobject.size()' +proposallistsobject.size());
        //if(opptylistsobject.size() > 0 && invokeOnce==true){
        if(opptylistsobject.size() > 0 ){
            updateRecordstoSync(opptylistsobject,objectname,mapNewSobj); 
        }
        if(proposallistsobject.size() > 0 ){
            updateRecordstoSync(proposallistsobject,objectname,mapNewSobj);
        }
        
    }
    
    public static void updateRecordstoSync(list<sobject> sobjectlist,String objectname, Map<Id,Sobject> newMap){
        Map<String,String> keytargetApiNames = new Map<String,String>(); 
        keytargetApiNames = getFieldApiNames(objectname); 
        Set<Id> setId= newMap.keySet();
        if(objectname == 'Opportunity'){
            try{
                System.debug('Inside Opportunity Part');
               // Map<String, Object> fieldsToValue = new Map<String, Object>();
            
                list<id> opptyIds = new list<id>();
                List<Apttus_Proposal__Proposal__c> quoteRecordList = new List<Apttus_Proposal__Proposal__c>();
           
                List<Apttus_Proposal__Proposal__c> proposalQuoteList = new List<Apttus_Proposal__Proposal__c>();
                
                /*for (sObject obj : sobjectlist) {
                    fieldsToValue = obj.getPopulatedFieldsAsMap();
                }*/
                opptyIds.addAll(setId);
                
                if(opptyIds.size() > 0){
                  
                    quoteRecordList = getQuoteRecord(opptyIds);
                    
                    if(quoteRecordList.size()>0){
                        
                        for(Apttus_Proposal__Proposal__c quoteins : quoteRecordList){
                            if(opptyIds.contains(quoteins.Apttus_Proposal__Opportunity__c)){
                                sobject genericObj = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c').newSObject();
                                genericObj.put('id',quoteins.id);
                                for(String oppFielddApiname  : keytargetApiNames.keyset()){
                                    
                                    
                                    if(String.isNotBlank(keytargetApiNames.get(oppFielddApiname))){
                                        System.debug('newMap## '+newMap.get(quoteins.Apttus_Proposal__Opportunity__c).get(oppFielddApiname));
                                        //System.debug('fieldsToValue.get(oppFielddApiname)## '+fieldsToValue.get(oppFielddApiname));
                                        if(String.isNotBlank(keytargetApiNames.get(oppFielddApiname)) && 
                                           String.isNotBlank((String)newMap.get(quoteins.Apttus_Proposal__Opportunity__c).get(oppFielddApiname))){
                                               //genericObj.put(keytargetApiNames.get(oppFielddApiname),(String)fieldsToValue.get(oppFielddApiname));
                                               
                                               genericObj.put(keytargetApiNames.get(oppFielddApiname),(String)newMap.get(quoteins.Apttus_Proposal__Opportunity__c).get(oppFielddApiname));
                                               system.debug('@@@ genericObj'+genericObj);
                                           }
                                        else{
                                            genericObj.put(keytargetApiNames.get(oppFielddApiname),'');
                                            system.debug('@@@ genericObj'+genericObj);
                                        }
                                        
                                    }
                                    
                                }
                                proposalQuoteList.add((Apttus_Proposal__Proposal__c)genericObj);    
                            }
                        }
                        
                    }
                    if(proposalQuoteList.size()>0){
                        Database.update(proposalQuoteList,true);
                    }
                    
                    
                    
                }
            } catch (Exception e) {
                System.debug('Exception: ' + e.getTypeName() + ', ' + e.getMessage());
                
            }
        }
        
        else if(objectname == 'Apttus_Proposal__Proposal__c'){
            system.debug('Inside Proposal Part');
            List<Sobject> updateOpptyList= new List<Sobject>();    
            Map<Id, Opportunity> opptyMap= getOpportunityRec(sobjectlist);
            try{
                for (sObject obj : sobjectlist) {
                    Apttus_Proposal__Proposal__c quote=(Apttus_Proposal__Proposal__c)obj;
                    System.debug('@@@'+opptyMap.containsKey(quote.Apttus_Proposal__Opportunity__c)+'@@@@@@'+quote.Apttus_Proposal__Opportunity__c);
                    if(opptyMap.containsKey(quote.Apttus_Proposal__Opportunity__c) && opptyMap.get(quote.Apttus_Proposal__Opportunity__c).Is_GLI__c==true && quote.Apttus_Proposal__Opportunity__c !=null){
                        Sobject opp = new Opportunity(Id=quote.Apttus_Proposal__Opportunity__c);
                        for(String keyField:keytargetApiNames.keySet()){
                            opp.put(keytargetApiNames.get(keyField), obj.get(keyField));
                        }
                        updateOpptyList.add(opp);
                    }
                }
                
                if(!updateOpptyList.isEmpty()){
                    Database.update(updateOpptyList,true);
                }
            }Catch(Exception e){System.debug('Exception---'+e.getMessage()+'---'+e.getStackTraceString());}
        }        
    }
    private static List<Apttus_Proposal__Proposal__c> getQuoteRecord(list<Id> opportunityIds){
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>([Select id,APTS_SSD_bill_to__c,
                                                                                                  APTS_Bill_To_Contact__c,
                                                                                                  APTS_Payer__c,
                                                                                                  APTS_SSD_ship_to__c,
                                                                                                  APTS_Ship_To_Contact__c,
                                                                                                  Apttus_Proposal__Opportunity__c,
                                                                                                  Apttus_Proposal__Primary__c,
                                                                                                  Apttus_Proposal__Opportunity__r.is_gli__c FROM Apttus_Proposal__Proposal__c WHERE 
                                                                                                  Apttus_Proposal__Opportunity__c IN : opportunityIds AND 
                                                                                                  Apttus_Proposal__Primary__c = true AND 
                                                                                                  Apttus_Proposal__Opportunity__r.is_gli__c = true LIMIT 1]);
        
        
        if(!proposalList.isEmpty()){
            return proposalList;
        }else{return null;}
    }
    public static Map<String,String> getFieldApiNames(String objectName){
        List<lcrm_opportunity_quote_sync__mdt> testList = [Select Object_name__c,                                                           
                                                           Key_field__c,
                                                           Target_field__c,
                                                           Sync_active__c FROM lcrm_opportunity_quote_sync__mdt WHERE Object_name__c =: objectName AND Sync_active__c = true];
        Map<String,String> objectfieldMap = new Map<String,String>();
        for(lcrm_opportunity_quote_sync__mdt test : testList){
            System.debug(test.Key_field__c);
            objectfieldMap.put(test.Key_field__c,test.Target_field__c);   
        }
        return objectfieldMap;
        
    }
    
    public static List<sobject> onInsert(List<Sobject> listSobj,String objName){
        System.debug('## INSIDE INSERT ##');
        System.debug('listSobj##'+listSobj);
        System.debug('objName##'+objName);
        List<sobject> oppList = new List<sobject>();
        List<sobject> proposalList = new List<sobject>();
        if(objName=='Opportunity'){
            oppList= new List<sobject>(listSobj);
            return oppList;
        }
        else{
            for(Sobject sobj:listSobj){
                Apttus_Proposal__Proposal__c oProposal= (Apttus_Proposal__Proposal__c)sobj;
                if(oProposal.Apttus_Proposal__Primary__c==true ){
                    proposalList.add(oProposal);
                    
                }
                System.debug('proposalList.size()### '+proposalList.size());
            }
            return proposalList;
        }
    }
    public static List<sobject> onUpdate(List<Sobject> listSobj, Map<Id, Sobject> oldMap,Map<Id, Sobject> newMap, String objName){
        System.debug('## INSIDE UPDATE ##');
        System.debug('listSobj##'+listSobj);
        System.debug('objName##'+objName);
        System.debug('oldMap##'+oldMap);
        List<sobject> oppList = new List<sobject>();
        List<sobject> proposalList = new List<sobject>();
        Set<sobject> oppSet = new Set<sobject>();
        Set<sobject> proposalSet = new Set<sobject>();
        Map<String,String> keytargetApiNames = new Map<String,String>(); 
        keytargetApiNames = getFieldApiNames(objName); 
        if(objName=='Opportunity'){
            for(Sobject sobj:listSobj){
                Opportunity opp=  (Opportunity)sobj;
                for(String keyField:keytargetApiNames.keySet()){
                    system.debug('keyField# '+keyField+'sobj.get(keyField)---'+sobj.get(keyField)+'---'+'oldMap.get(oProposal.Id).get(keyField)---'+oldMap.get(opp.Id).get(keyField));
                    System.debug('if(newMap.get(opp.Id).get(keyField) != oldMap.get(oProposal.Id).get(keyField))'+newMap.get(opp.Id).get(keyField) != oldMap.get(opp.Id).get(keyField));
                    if(sobj.get(keyField) !=oldMap.get(opp.Id).get(keyField)){
                        oppSet.add(sobj);
                    }
                }
            }
            oppList.addAll(oppSet);
            return oppList;
        }else{
            for(Sobject sobj:listSobj){
                Apttus_Proposal__Proposal__c oProposal= (Apttus_Proposal__Proposal__c)sobj;
                if(oProposal.Apttus_Proposal__Primary__c==true){
                    for(String keyField:keytargetApiNames.keySet()){
                        system.debug('keyField# '+keyField+'sobj.get(keyField)---'+sobj.get(keyField)+'---'+'oldMap.get(oProposal.Id).get(keyField)---'+oldMap.get(oProposal.Id).get(keyField));
                        System.debug('if(sobj.get(keyField) != oldMap.get(oProposal.Id).get(keyField))'+sobj.get(keyField) != oldMap.get(oProposal.Id).get(keyField));
                        System.debug('if(newMap.get(oProposal.Id).get(keyField) != oldMap.get(oProposal.Id).get(keyField))'+newMap.get(oProposal.Id).get(keyField) != oldMap.get(oProposal.Id).get(keyField));
                        //if(sobj.get(keyField) != oldMap.get(oProposal.Id).get(keyField)){
                        proposalSet.add(sobj);
                        //}	
                    }
                }
            }
            System.debug('proposalSet.size()##'+proposalSet.size());
            proposalList.addAll(proposalSet);
            System.debug('proposalList.size()##'+proposalList.size());
            return proposalList;
        }
        
    }
    
    private static Map<Id, Opportunity> getOpportunityRec(list<sobject> objList){
        List<Id> listOppId = new List<Id>();
        for(Sobject obj:objList){
            Id oppId= (ID)obj.get('Apttus_Proposal__Opportunity__c');
            listOppId.add(oppId);
        }
        System.debug('Opportunity List--'+listOppId);
        Map<Id, Opportunity> OpptyMap= new Map<Id, Opportunity>();
        List<Opportunity> oppList= new List<Opportunity>();
        oppList=[select Id, Is_GLI__c from Opportunity where Id IN: listOppId and Is_GLI__c=true]; 
        OpptyMap.putAll(oppList);
        return OpptyMap;
    }
    
  
}