/**
* @description Helper class for OrderSubmission
*/
public without sharing class APTS_OrderTriggerHelper2{
    /**
     * @description startCaseCreation
     * @param order of type Apttus_Config2__Order__c
     * @return Apttus_Config2__Order__c
    */    
    public static List<Apttus_Config2__Order__c> startCaseCreation(List<Apttus_Config2__Order__c> order){
        List<Apttus_Config2__Order__c> orderlist = new List<Apttus_Config2__Order__c>();
        for(Apttus_Config2__Order__c rec:order){
            Boolean executionstatus = callcasecreation(rec);
            if(executionstatus == true){
                rec.APTS_SAP_Status__c = 'Case Created';                orderlist.add(rec);
            }
        }
        return orderlist; 
    }
    
    /**
     * @description callcasecreation
     * @param rec of type Apttus_Config2__Order__c
     * @return Boolean
    */
    @testVisible private static Boolean callcasecreation(Apttus_Config2__Order__c rec){
        Boolean executionstatus=false;
        String billingcase = '';
        String entcase = '';
        for(APTS_Case_Brand__mdt val : [Select MasterLabel,DeveloperName,APTS_Case_Brand_Value__c,APTS_Case_Type__c,APTS_Product_Family__c,APTS_Proposal_Business_Unit__c from APTS_Case_Brand__mdt]){
            if(conditioncallcase(val,rec) && val.APTS_Case_Type__c.contains('Billing')){
                billingcase = val.APTS_Case_Brand_Value__c;
            }
            if(conditioncallcase(val,rec) && val.APTS_Case_Type__c.contains('Entitlement')){
                entcase = val.APTS_Case_Brand_Value__c;
            }
        }
        try{
            System.debug(logginglevel.DEBUG, 'KS--> rec.Apttus_QPConfig__ProposalId__r.ID '+rec.Apttus_QPConfig__ProposalId__r.ID);
            executionstatus = createCreditCheckCase(rec,new Map<String, String>{'billingcase'=>billingcase,'entcase'=>entcase});
            
        }catch(Exception ex){executionstatus = false;System.debug(logginglevel.ERROR, 'KS--> inside catch exception');
            if(rec !=NULL){IntegrationLogger.OCAddMessage('Case not Created for Order. '+ex.getMessage(), rec.ID, 'Order', 'Case Creation for Order.', 'Outound', 'OrderSubmission', false, rec.id);                
            }
        }
        return executionstatus;
    }
    @testVisible private static Boolean conditioncallcase(APTS_Case_Brand__mdt val,Apttus_Config2__Order__c rec)
    {
        if(val !=NULL && rec !=NULL && val.APTS_Product_Family__c == rec.Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c && val.APTS_Proposal_Business_Unit__c !=NULL && rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c !=NULL && val.APTS_Proposal_Business_Unit__c.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c) && val.APTS_Case_Type__c != null)
          {
              return true;
          }
          return false;
    }
    @testVisible private static Boolean createCreditCheckCase(Apttus_Config2__Order__c rec, Map<String,String> stringMap){
        Boolean executionstatus = false;
        String billingcase = stringMap.get('billingcase');
        String entcase = stringMap.get('entcase');
        GenericCaseMgmtService casecall = new GenericCaseMgmtService();
        List<Id> listofprop = new List<Id>{rec.Apttus_QPConfig__ProposalId__c};
        Map<Id,String> failurereason = new Map<Id,String>();
        List<Id> createdcases = new List<Id>();
        if(billingcase != null && billingcase != ''){
            failurereason.put(rec.Apttus_QPConfig__ProposalId__c,billingcase);
            createdcases = casecall.createCreditCheckCase(listofprop,failurereason);
        }
        if(createdcases != null && createdcases.size() > 0 && entcase != null && entcase != ''){
            failurereason.put(rec.Apttus_QPConfig__ProposalId__c,entcase);
            createdcases = casecall.createCreditCheckCase(listofprop,failurereason); 
        }
        System.debug(logginglevel.DEBUG, 'KS--> createdCases '+createdcases);
        executionstatus = createCreditCheckCaseIntLogger(rec,createdcases,stringMap);
        return executionstatus;
    }
    
    @testVisible private static Boolean createCreditCheckCaseIntLogger(Apttus_Config2__Order__c rec, List<Id> createdcases, Map<String, String> stringMap){
        Boolean executionstatus=false;
        String billingcase = stringMap.get('billingcase');
        String entcase = stringMap.get('entcase');
        if((billingcase != null && billingcase != '') || (entcase != null && entcase != '')){
            if(createdCases == null || createdCases.size() ==0){
                system.debug(logginglevel.DEBUG, 'KS--> inside If');
                executionstatus = false;
                IntegrationLogger.OCAddMessage('Case not Created for Order.', rec.ID, 'Order', 'Case Creation for Order.', 'Outbound', 'OrderSubmission', false, rec.id);    
            }else{
                executionstatus = True;
                system.debug(logginglevel.DEBUG, 'KS--> inside else');
                IntegrationLogger.OCAddMessage('Case creation successfull for Order. Case Id is: '+createdcases.get(0), rec.ID, 'Order', 'Case Creation for Order.', 'Outbound', 'OrderSubmission', true, rec.id);    
            }      
        }      
        return executionstatus;
    }

    /**
    * @description Method for querying orders
    * @param idSet of type Map<Id,String>
    * @return List<Apttus_Config2__Order__c>
    */
    @testVisible public static Map<ID, Apttus_Config2__Order__c> getOrderList(Set<Id> idSet){
        Map<ID, Apttus_Config2__Order__c> tempOrderMap = new Map<ID, Apttus_Config2__Order__c>();
        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible() && idSet!=null && idSet.size()>0){
            tempOrderMap = new Map<ID, Apttus_Config2__Order__c>([Select Id,Name,Apttus_QPConfig__ProposalId__r.Digital_Has_Line_Items__c, APTS_Count_of_Line_Items__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Platform_Event_Triggered__c,Apttus_QPConfig__ProposalId__c,APTS_Proposal_Business_Unit__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c,Apttus_QPConfig__ProposalId__r.Id,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c from Apttus_Config2__Order__c where ID IN: idSet]);
        }
        return tempOrderMap;
    }
   
    
}