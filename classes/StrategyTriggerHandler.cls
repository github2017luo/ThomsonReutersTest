/*
===============================================================================
    StrategyTriggerHandler
===============================================================================

PURPOSE: To create relation record Strategy2Oppty

FUNCTIONALITY: Creates Strategy2Oppty/Strategy2Training record when a Stratgey created 
                    from opportunity/Training Event
               Checks duplicate Strategy2oppty/Strategy2Training record insertion

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2012-12-05      Nandita          Created

===============================================================================
*/

public class StrategyTriggerHandler{

    public static void createStrategy2Oppty(List<SFDC_Strategy__c> listStrategy){
       List<SFDC_Strategy2Oppty__c> listStrategy2Oppty = new List<SFDC_Strategy2Oppty__c >();        
        for(SFDC_Strategy__c oStrategy : listStrategy){
          if(oStrategy.Opportunity__c!=null){
           SFDC_Strategy2Oppty__c Strategy2oppty = new SFDC_Strategy2Oppty__c(Opportunity_Name__c=oStrategy.Opportunity__c,
                                                                              SFDC_Strategy__c=oStrategy.Id);
                                                                              
           listStrategy2Oppty.add(Strategy2oppty);
          }
        }
        
        Insert listStrategy2Oppty;
    
    }
    
    public static void createStrategy2TE(List<SFDC_Strategy__c> listStrategy){
       List<Strategy2TrainingEvent__c> listStrategy2TE = new List<Strategy2TrainingEvent__c>();        
        for(SFDC_Strategy__c oStrategy : listStrategy){
          if(oStrategy.Training_Event__c!=null){
           Strategy2TrainingEvent__c Strategy2TE = new Strategy2TrainingEvent__c(Training_Event__c=oStrategy.Training_Event__c,
                                                                              Strategy__c=oStrategy.Id);
                                                                              
           listStrategy2TE.add(Strategy2TE);
          }
        }
        
        Insert listStrategy2TE;
    
    }
    
    public static void Strategy2OpptyDuplicatePreventer(List<SFDC_Strategy2Oppty__c> listStrategy2Oppty,Map<Id,SFDC_Strategy2Oppty__c> mapStrategy2Oppty){
        List<SFDC_Strategy2Oppty__c> listStrategy2Opptydupcheck = new List<SFDC_Strategy2Oppty__c>();
        for(SFDC_Strategy2Oppty__c oStrategy2Oppty : listStrategy2Oppty){
            if(oStrategy2Oppty.SFDC_Strategy__c!= mapStrategy2Oppty.get(oStrategy2Oppty.Id).SFDC_Strategy__c
                 || oStrategy2Oppty.Opportunity_name__c!= mapStrategy2Oppty.get(oStrategy2Oppty.Id).Opportunity_name__c){
                listStrategy2Opptydupcheck.add(oStrategy2Oppty );
            }
        }
        Strategy2OpptyDuplicatePreventer(listStrategy2Opptydupcheck);
    
    }
    
    public static void Strategy2OpptyDuplicatePreventer(List<SFDC_Strategy2Oppty__c> listStrategy2Oppty){
        List<Id> listStrategyId = new List<Id>();
        Map<String,SFDC_Strategy2Oppty__c> mapStrategy2Oppty = new Map<String,SFDC_Strategy2Oppty__c>();
        String StrategyIdOptyId;
        
        for(SFDC_Strategy2Oppty__c oStrategy2Oppty : listStrategy2Oppty){
            listStrategyId.add(oStrategy2Oppty.SFDC_Strategy__c);
            if(!mapStrategy2Oppty.containskey(String.valueOf(oStrategy2Oppty.SFDC_Strategy__c) + String.valueOf(oStrategy2Oppty.Opportunity_name__c))){
                mapStrategy2Oppty.put(String.valueOf(oStrategy2Oppty.SFDC_Strategy__c) + String.valueOf(oStrategy2Oppty.Opportunity_name__c),oStrategy2Oppty);
            }else{
                oStrategy2Oppty.adderror('The Opportunity has already been added to this Strategy.');
            }
        
        }
        
        for(SFDC_Strategy2Oppty__c oStrategyOppty : [Select SFDC_Strategy__c,Opportunity_name__c from SFDC_Strategy2Oppty__c where SFDC_Strategy__c IN :listStrategyId ]){
            StrategyIdOptyId = String.valueOf(oStrategyOppty.SFDC_Strategy__c) + String.valueOf(oStrategyOppty.Opportunity_name__c);
            if(mapStrategy2Oppty.containskey(StrategyIdOptyId)){
                SFDC_Strategy2Oppty__c newStrategyOpty = mapStrategy2Oppty.get(StrategyIdOptyId);
                newStrategyOpty.adderror('The Opportunity has already been added to this Strategy.');
            }
        }
    }
    
    public static void Strategy2TrainingEventDuplicatePreventer(List<Strategy2TrainingEvent__c> listStrategy2TrainingEvent,Map<Id,Strategy2TrainingEvent__c> mapStrategy2TrainingEvent){
      List<Strategy2TrainingEvent__c> listStrategy2TEdupcheck = new List<Strategy2TrainingEvent__c>();
        for(Strategy2TrainingEvent__c oStrategy2TrainingEvent : listStrategy2TrainingEvent){
            if(oStrategy2TrainingEvent.Strategy__c!= mapStrategy2TrainingEvent.get(oStrategy2TrainingEvent.Id).Strategy__c
                 || oStrategy2TrainingEvent.Training_Event__c!= mapStrategy2TrainingEvent.get(oStrategy2TrainingEvent.Id).Training_Event__c){
                listStrategy2TEdupcheck.add(oStrategy2TrainingEvent);
            }
        }
        Strategy2TrainingEventDuplicatePreventer(listStrategy2TEdupcheck);
    
    }
    
    public static void Strategy2TrainingEventDuplicatePreventer(List<Strategy2TrainingEvent__c> listStrategy2TrainingEvent){
        List<Id> listStrategyId = new List<Id>();
        Map<String,Strategy2TrainingEvent__c> mapStrategy2TrainingEvent = new Map<String,Strategy2TrainingEvent__c>();
        String StrategyIdTrngEventId;
        
        for(Strategy2TrainingEvent__c oStrategy2TrainingEvent : listStrategy2TrainingEvent){
            listStrategyId.add(oStrategy2TrainingEvent.Strategy__c);
            if(!mapStrategy2TrainingEvent.containskey(String.valueOf(oStrategy2TrainingEvent.Strategy__c) + String.valueOf(oStrategy2TrainingEvent.Training_Event__c))){
                mapStrategy2TrainingEvent.put(String.valueOf(oStrategy2TrainingEvent.Strategy__c) + String.valueOf(oStrategy2TrainingEvent.Training_Event__c),oStrategy2TrainingEvent);
            }else{
                oStrategy2TrainingEvent.adderror('The Training Event has already been added to this Strategy.');
            }
        
        }
        
        for(Strategy2TrainingEvent__c oStrategyTrngEvent : [Select Strategy__c,Training_Event__c from Strategy2TrainingEvent__c where Strategy__c IN :listStrategyId ]){
            StrategyIdTrngEventId = String.valueOf(oStrategyTrngEvent.Strategy__c) + String.valueOf(oStrategyTrngEvent.Training_Event__c);
            if(mapStrategy2TrainingEvent.containskey(StrategyIdTrngEventId)){
                Strategy2TrainingEvent__c newStrategyTE = mapStrategy2TrainingEvent.get(StrategyIdTrngEventId);
                newStrategyTE.adderror('The Training Event has already been added to this Strategy.');
            }
        }
    }

}