/*
======================================================================================================================
CLASS NAME:  RenewalsOpptyMgmtType_Batch 
======================================================================================================================
PURPOSE:  'Legacy code' and we are not sure about the functionality

CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
31/03/2017       Gunaseelan K       Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/

global class RenewalsOpptyMgmtType_Batch implements Database.Batchable<SObject>{
    private String strRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
    private Date dateYesterday = Date.Today() - 1;
    private Date dateToday = Date.Today();
    private String Query;
    global Database.QueryLocator start(Database.BatchableContext BcthCon){ 
        List<String> LatAmSalesOrgs  = System.Label.LatAMSalesOrgs.Split(',');
        if(!Test.isRunningTest()){
        //  Query = 'Select Id, Oppty_Mgmt_Type__c, Originating_Order_Number__c,SyncedQuoteId, (SELECT Id,OpportunityId,Previous_Year_s_SFDC_Quote_No__c FROM OpportunityLineItems WHERE Previous_Year_s_SFDC_Quote_No__c != Null) FROM Opportunity WHERE Oppty_Mgmt_Type__c != \'Split Billing\' AND Renewal_Flag__c = true AND RecordTypeId =: strRecordType AND (Created_Date__c =: dateYesterday OR Created_Date__c =: dateToday)  AND Is_Child_Opportunity__c = FALSE AND Sales_Org__c = \'TSL\'';  
            Query = 'Select Id, Oppty_Mgmt_Type__c, Originating_Order_Number__c,SyncedQuoteId, (SELECT Id,OpportunityId,Previous_Year_s_SFDC_Quote_No__c FROM OpportunityLineItems WHERE Previous_Year_s_SFDC_Quote_No__c != Null) FROM Opportunity WHERE Oppty_Mgmt_Type__c != \'Split Billing\' AND Renewal_Flag__c = true AND RecordTypeId =: strRecordType AND (Created_Date__c =: dateYesterday OR Created_Date__c =: dateToday)  AND Is_Child_Opportunity__c = FALSE AND Sales_Org__c IN :LatAmSalesOrgs';
           
        }
        if(Test.isRunningTest()){
            Query = 'Select Id, Oppty_Mgmt_Type__c, Originating_Order_Number__c,SyncedQuoteId, (SELECT Id,OpportunityId,Previous_Year_s_SFDC_Quote_No__c FROM OpportunityLineItems WHERE Previous_Year_s_SFDC_Quote_No__c != Null) FROM Opportunity WHERE Oppty_Mgmt_Type__c != \'Split Billing\' AND Renewal_Flag__c = true AND RecordTypeId =: strRecordType AND (Created_Date__c =: dateYesterday OR Created_Date__c =: dateToday)  AND Is_Child_Opportunity__c = FALSE AND Sales_Org__c = \'TSL\' limit 50';  
        }
        system.debug('>>>query'+ query);    
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BtchCon, List<SObject> scope){
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
        List<Opportunity> lstOpportunity = (List<Opportunity>)scope;
        Map<String, Opportunity> mapOppty = new Map<String, Opportunity>();
        Map<String, OpportunityLineItem> mapOLI = new Map<String, OpportunityLineItem>();
        Set<String> stStr = new Set<String>(); 
        Map<Id,Integer> mapOLIOptyId = new Map<Id,Integer>(); 
        List<Opportunity> lstOLIChckOppty = new List<Opportunity>();             
        if(lstOpportunity != null && lstOpportunity.size()>0){          
            AggregateResult[] lstOppLnItm = [SELECT OpportunityId, Count(Id) count1 FROM OpportunityLineItem WHERE OpportunityId in: lstOpportunity AND Opportunity.Sales_Org__c = 'TSL' GROUP BY OpportunityId  HAVING (Count(Id)<= 3 AND Count(Id) > 0)];
         system.debug('>>>lstOppLnItm'+ lstOppLnItm);
            //Store the unique Opportunities
            Set<Id> setOpportunityId = new Set<Id>();
            if(lstOppLnItm != null && lstOppLnItm.size() > 0) {
                for(AggregateResult ar : lstOppLnItm) {
                    //mapOLIOptyId.put((Id)ar.get('OpportunityId'), (Integer)ar.get('count1'));
                    setOpportunityId.add((Id)ar.get('OpportunityId'));
                }
            } 
            //End
            for(Opportunity opp : lstOpportunity){
                //if(setOpportunityId.contains(opp.id)) {
                lstOLI.addAll(opp.OpportunityLineItems);
               // }                
            } 
            Map<ID, Set<String>> mapOppIDOrginOrderNumber = new Map<ID, Set<String>>();        
            Set<String> setOriginOrderNumber;
            Opportunity objOpp;
            Map<Id, Opportunity> mapOpportunityUpdated = new Map<Id, Opportunity>();
            for(OpportunityLineItem objOLI : lstOLI) {  
                // bELOW IF-ELSE FOR Split Billing 
                if(setOpportunityId.contains(objOLI.OpportunityId)) { 
                    if(mapOppIDOrginOrderNumber.get(objOLI.OpportunityId) != null) {                    
                        mapOppIDOrginOrderNumber.get(objOLI.OpportunityId).add(objOLI.Previous_Year_s_SFDC_Quote_No__c);
                    }
                    else {
                        setOriginOrderNumber = new Set<String>();
                        setOriginOrderNumber.add(objOLI.Previous_Year_s_SFDC_Quote_No__c);
                        mapOppIDOrginOrderNumber.put(objOLI.OpportunityId, setOriginOrderNumber);
                    }
                } //END
                system.debug('>>>mapOppIDOrginOrderNumber'+ mapOppIDOrginOrderNumber);
                objOpp = new Opportunity(Id = objOLI.OpportunityId);
                String strOriginatingON;
                if(objOLI.Previous_Year_s_SFDC_Quote_No__c != NULL && 
                   mapOpportunityUpdated.get(objOLI.OpportunityId) != null &&
                   mapOpportunityUpdated.get(objOLI.OpportunityId).Originating_Order_Number__c !=null && 
                  !(mapOpportunityUpdated.get(objOLI.OpportunityId).Originating_Order_Number__c).contains(objOLI.Previous_Year_s_SFDC_Quote_No__c)) {
                    objOpp.Originating_Order_Number__c = mapOpportunityUpdated.get(objOLI.OpportunityId).Originating_Order_Number__c + ',' + objOLI.Previous_Year_s_SFDC_Quote_No__c;                   
                    mapOpportunityUpdated.put(objOLI.OpportunityId, objOpp);
                    system.debug('>>>mapOpportunityUpdated1'+ mapOpportunityUpdated);
                }
                else if(mapOpportunityUpdated.get(objOLI.OpportunityId) == null){
                    objOpp.Originating_Order_Number__c = objOLI.Previous_Year_s_SFDC_Quote_No__c;
                    mapOpportunityUpdated.put(objOLI.OpportunityId, objOpp);
                    system.debug('>>>mapOpportunityUpdated2'+ mapOpportunityUpdated);
               } 
            }
            system.debug('>>>mapOpportunityUpdated'+ mapOpportunityUpdated);
        Set<ID> setOppID = new Set<ID>();
        Set<String> setON = new Set<String>();
        List<Opportunity> lstMasterSafOpp = new List<Opportunity>();
        Map<Id, String> mapPrevOppIdQuoNo = new Map<Id, String>();
        Map<String, Id> mapQuotationOppId = new Map<String, Id>();
        for(ID objOppId : mapOppIDOrginOrderNumber.keySet()) {
            if(mapOppIDOrginOrderNumber.get(objOppId).size() == 1) {
                List<String> lstOriginatingOrderNo = new List<String>();
                lstOriginatingOrderNo.addALL(mapOppIDOrginOrderNumber.get(objOppId));
                mapQuotationOppId.put(lstOriginatingOrderNo[0], objOppId);
                setOppID.add(objOppId); //Opportunity ID
                setON.addAll(mapOppIDOrginOrderNumber.get(objOppId)); //Retrieves Quotation number
            }                
        }
        /*lstMasterSafOpp = [SELECT Id, Oppty_Mgmt_Type__c,SAP_Quotation_Document_number__c 
                           FROM Opportunity 
                           WHERE SAP_Quotation_Document_number__c IN: setON 
                           AND Oppty_Mgmt_Type__c = 'Split Billing' AND Is_Master_Opportunity__c = TRUE];
        */
        lstMasterSafOpp = [SELECT Id, Oppty_Mgmt_Type__c,SyncedQuote.QuoteNumber   FROM Opportunity   WHERE SyncedQuote.QuoteNumber IN: setON   AND Oppty_Mgmt_Type__c = 'Split Billing'  AND Is_Master_Opportunity__c = TRUE  AND Sales_Org__c = 'TSL'];
        for(Opportunity objMSafOpp : lstMasterSafOpp){
            //mapPrevOppIdQuoNo.put(objMSafOpp.SAP_Quotation_Document_number__c, objMSafOpp.Id);
            mapOpportunityUpdated.get(mapQuotationOppId.get(objMSafOpp.SyncedQuote.QuoteNumber)).Oppty_Mgmt_Type__c = 'Split Billing'; 
            mapOpportunityUpdated.get(mapQuotationOppId.get(objMSafOpp.SyncedQuote.QuoteNumber)).Original_Master_Opportunity__c = objMSafOpp.Id;           
        }
        if(mapOpportunityUpdated.values() != NULL) {
            Database.UPDATE(mapOpportunityUpdated.values());
        }
        //End of main null IF condition
        } 
    }
    global void finish(Database.BatchableContext BtchCon){
    }
}