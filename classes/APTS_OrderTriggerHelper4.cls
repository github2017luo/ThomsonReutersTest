/**
* @description Helper class for OrderSubmission
*/
public without sharing class APTS_OrderTriggerHelper4{
    @testvisible private static Boolean recursivePAVQueryCheck = false;
    @testvisible private static Map<Id,Integer> attplist = new Map<Id,Integer>();
    //@testvisible private static Boolean countPLIFlag = false;
      /**
    * @description attributevaluesorder
    * @param orderIds
    * @return  Map<Id,Integer>
    */
      @testVisible public static Map<Id,Integer> attributevaluesorder(Set<Id> orderIds){
        //if(countPLIFlag==false){
        //    return attplist;
        //}
        List<AggregateResult> attributelist= new List<AggregateResult>();
        Map<Id,Integer> attolist = new Map<Id,Integer>();
        if(Schema.sObjectType.Apttus_Config2__OrderProductAttributeValue__c.isAccessible()){
            attributelist = [SELECT Apttus_Config2__LineItemId__r.Apttus_Config2__OrderId__c,COUNT(Id) FROM Apttus_Config2__OrderProductAttributeValue__c WHERE Apttus_Config2__LineItemId__r.Apttus_Config2__OrderId__c IN: orderIds GROUP BY Apttus_Config2__LineItemId__r.Apttus_Config2__OrderId__c];
        }
        for(AggregateResult ar : attributelist){
          attolist.put(String.valueOf(ar.get('Apttus_Config2__OrderId__c')),Integer.valueof(ar.get('expr0')));
        }
        return  attolist;
    }
    
   
    /**
     * @description Method for querying Proposal attribute value
     * @param propIds of type List<Id>
     * @return Map<Id,Integer>
    */
    @testVisible public static Map<Id,Integer> attributevaluesproposal(List<Id> propIds){
        if(recursivePAVQueryCheck == true){
            return attplist;
        }
        List<AggregateResult> attributelist = new List<AggregateResult>();
        //Map<Id,Integer> attplist = new Map<Id,Integer>();
        if(Schema.sObjectType.Apttus_QPConfig__ProposalProductAttributeValue__c.isAccessible()){
            attributelist = [SELECT Apttus_QPConfig__LineItemId__r.Apttus_Proposal__Proposal__c,COUNT(Id) FROM Apttus_QPConfig__ProposalProductAttributeValue__c WHERE Apttus_QPConfig__LineItemId__r.Apttus_Proposal__Proposal__c IN: propIds GROUP BY Apttus_QPConfig__LineItemId__r.Apttus_Proposal__Proposal__c];
        }
        for(AggregateResult ar : attributelist){
            attplist.put(String.valueOf(ar.get('Apttus_Proposal__Proposal__c')),Integer.valueof(ar.get('expr0')));
            //if(Integer.valueof(ar.get('expr0'))>0){
            //    countPLIFlag = true;
            //}
        }
        recursivePAVQueryCheck = true;
        return attplist;
    } 
      /**
     * @description Method for querying Order Line Item records
     * @param orderIds of type List<Id>
     * @return Map<Id,Integer>
      
    @testVisible public static Map<Id,Integer> queryolirecords(Set<Id> orderIds){
        List<AggregateResult> olilist = new List<AggregateResult>();
        Map<Id,Integer> olimap = new Map<Id,Integer>();
        if(Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isAccessible()){
            olilist = [SELECT Apttus_Config2__OrderId__c,COUNT(Id) FROM Apttus_Config2__OrderLineItem__c WHERE Apttus_Config2__OrderId__c IN: orderIds GROUP BY Apttus_Config2__OrderId__c];
        }
        for(AggregateResult ar : olilist){
            olimap.put(String.valueOf(ar.get('Apttus_Config2__OrderId__c')),Integer.valueof(ar.get('expr0')));
        }
        return olimap;
    }*/  
}