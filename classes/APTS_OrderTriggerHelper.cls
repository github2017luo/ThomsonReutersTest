/**
 * @description APTS_OrderTriggerHelper
 */
public with sharing class APTS_OrderTriggerHelper {

    // This method updates the stage and status of the associated opportunities to 100%.
    /**
     * @description updateOpportunity
     * @param orders
     */
     public static boolean runUpdateProposalFromOrderTrigger  = true; 
     public static boolean runUpdateOppFromOrderTrigger  = true;
    public static void updateOpportunity(List<Apttus_Config2__Order__c> orders)
    {
           List<opportunity> opportunities = new List<opportunity>();
           List<Id> oppIdList = new List<Id>();
           Set<Id> OCOpportunityIds = new Set<Id>();
           for(Apttus_Config2__Order__c order : orders) {
                if (order.Apttus_Config2__Status__c == 'Activated') {
                     //DOC-8896: Jinal Bhatt - Added for all business 
                     oppIdList.add(order.Apttus_Config2__RelatedOpportunityId__c);
                     if(order.APTS_Proposal_Business_Unit__c == 'SCS'
                     || order.APTS_Proposal_Business_Unit__c == 'FindLaw'
                     || order.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US'
                     || order.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK'
                     || order.APTS_Proposal_Business_Unit__c == 'Canada'){
                         OCOpportunityIds.add(order.Apttus_Config2__RelatedOpportunityId__c);
                     }
                }
                if(order.APTS_SAP_Status__c == 'Order Completed' && order.APTS_Proposal_Business_Unit__c == 'Tax Professional') {
                     oppIdList.add(order.Apttus_Config2__RelatedOpportunityId__c);
                     OCOpportunityIds.add(order.Apttus_Config2__RelatedOpportunityId__c);
                }
          }
          
          if (oppIdList.size() > 0) {
               try {
                    System.debug(LoggingLevel.WARN,'***** in the try block ******');
                    opportunities = [SELECT id, Status__c, StageName, CloseDate FROM opportunity WHERE id IN :oppIdList];
                    for (opportunity opp : opportunities) {
                         opp.Status__c = 'Converted';
                         opp.StageName = 'Order Complete';
                         opp.APTS_Is_Order_Created__c = true; //DOC-16198
                         if(OCOpportunityIds != null && !OCOpportunityIds.contains(opp.Id)){
                             opp.Reason__c = 'Order Capture Default';
                         }
                         //opp.stageName = '100%';
                         opp.CloseDate = System.today();     //Added by Chirag
                    }
                    update opportunities;
               } catch(DmlException e) {
                    System.debug(LoggingLevel.WARN,'An unexpected error has occurred: ' + e.getMessage());
               }
          }
     }
     
    // This method updates the ready for activation date.
    /**
     * @description
     * @param orders
     */
    public static void activateOrder(List<Apttus_Config2__Order__c> orders)
    {     //SOC-8212 changes by Priyanka start 
        List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
        List<ID> orderIds = new List<ID>();
        List<Id> assetLineItemsIds = new List<Id>();
        List<Apttus_Config2__AssetLineItem__c> assetLineItemsToDelete = new List<Apttus_Config2__AssetLineItem__c>();
       
         
        for(Apttus_Config2__Order__c order : orders) {
            if (order.APTS_SAP_Status__c == 'Order Completed' && order.APTS_Proposal_Business_Unit__c != 'Tax Professional') {
                if (order.Apttus_Config2__ActivatedDate__c == null) {
                    order.Apttus_Config2__ActivatedDate__c = datetime.now();
                    order.Apttus_Config2__Status__c = 'Activated';
                }
            }
             if (order.APTS_SAP_Status__c == 'Order Cancelled') {
                orderIds.add(order.Id);
            }
            
        }
        System.debug(LoggingLevel.WARN,'order Ids *********'+orderIds.size() );
        if(orderIds.size() > 0){
        oliList =[select id,APTS_Proposal_Business_Unit__c,Apttus_Config2__LineStatus__c,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__OrderId__c,Apttus_Config2__OrderId__r.APTS_SAP_Status__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c IN :orderIds ];
        for(Apttus_Config2__OrderLineItem__c oli:oliList ){
        System.debug(LoggingLevel.WARN,'In iF $$$$$$$$$$$$$$$'+oli.Apttus_Config2__OrderId__r.APTS_SAP_Status__c);
       
        System.debug(LoggingLevel.WARN,'In iF $$$$$$$$$$$$$$$');
        if(oli.Apttus_Config2__LineStatus__c =='New' && (oli.APTS_Proposal_Business_Unit__c == 'SCS'))
        assetLineItemsIds.add(oli.Apttus_Config2__AssetLineItemId__c);       
        
        
        }
         System.debug(LoggingLevel.WARN,'orderline items Ids *********'+oliList.size() );    
        System.debug(LoggingLevel.WARN,'Update Asset line items::::::'+assetLineItemsIds.size() );
        if(assetLineItemsIds.size() > 0){
        assetLineItemsToDelete =[select id,Apttus_Config2__IsInactive__c from Apttus_Config2__AssetLineItem__c where id IN :assetLineItemsIds];
         for(Apttus_Config2__AssetLineItem__c  ast:assetLineItemsToDelete ){
         ast.Apttus_Config2__IsInactive__c = true;
         }
         update assetLineItemsToDelete;
        }
         // SOC-8212 changes by Priyanka end
      }
    }
    //This method sends an email to the Corp User
    //DOC-1655-Added by Nandha : Starts here
    /**
     * @description databaseEntitlement
     * @param orders
     * @param oldorders
     */
    public static void databaseEntitlement(List<Apttus_Config2__Order__c> orders,Map<Id,Apttus_Config2__Order__c> oldorders){
        List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
        List<ID> orderIds = new List<ID>();
        Set<String> productFamily = new Set<String>();
        Boolean sendmail = false;       
        Id propId;
        String propName;
        Boolean wetsign;
        String proposalBusinessUnit;//DOC-4862 changes
        //DOC-2690 starts
        Boolean existingDatabase = false;
        String clientDatabaseCode;
        //DOC-2690 ends
        for(Apttus_Config2__Order__c order : orders) {
           Apttus_Config2__Order__c oldord = oldorders.get(order.Id);
           if (order.IDOC__c != NULL && order.IDOC__c != '' && oldord.IDOC__c == NULL) {
              orderIds.add(order.Id);
           } 
        }            
        if(orderIds.size() > 0){
            for(CORPPRODFAMILY__c prodfamily : CORPPRODFAMILY__c.getall().values()){
                productFamily.add(prodfamily.Product_Pricing_Model__c);
            }
            oliList =[select id,Apttus_Config2__LineStatus__c,Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.APTS_Client_Database_Code__c,Apttus_QPConfig__ProposalId__r.APTS_Existing_Database__c,Apttus_Config2__OrderId__c,Apttus_Config2__ProductId__r.WLEC_Product_Category__c,APTS_Product_Pricing_Model__c,Apttus_QPConfig__ProposalId__r.Name,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c IN :orderIds AND Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c IN ('Corp OneOTC US','Corp OneOTC UK') ];
            for(Apttus_Config2__OrderLineItem__c oli:oliList ){
                if(oli.Apttus_Config2__LineStatus__c == System.Label.CORPLINESTATUS && oli.Apttus_Config2__ProductId__r.WLEC_Product_Category__c != System.Label.CORPPS && productFamily.contains(oli.APTS_Product_Pricing_Model__c)){
                    sendmail = True;                    
                    propId = oli.Apttus_QPConfig__ProposalId__c;
                    propName = oli.Apttus_QPConfig__ProposalId__r.Name;
                    wetsign = oli.Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c;
                    //DOC-4862 starts       
                    proposalBusinessUnit=oli.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c;     
                    //DOC-4862 ends 
                      //DOC-2690 starts
                    if(oli.Apttus_QPConfig__ProposalId__r.APTS_Existing_Database__c ||  oli.Apttus_QPConfig__ProposalId__r.APTS_Client_Database_Code__c!=null){                  
                       existingDatabase = oli.Apttus_QPConfig__ProposalId__r.APTS_Existing_Database__c;
                       clientDatabaseCode = oli.Apttus_QPConfig__ProposalId__r.APTS_Client_Database_Code__c;
                    }
                    //DOC-2690 ends added by Keerthana
                    break;
                  }
                }
            }  
            System.debug(LoggingLevel.WARN,'existingDatabase--'+existingDatabase+'clientDatabaseCode--'+clientDatabaseCode);
            //added proposalBusinessUnit parameter as part of DOC-4862          
            if(sendmail == True){
                String message = APTS_ProposalUtilities.sendEmailForDatabaseEntitlement(propId,System.Label.CORPEMAILADDRESS,propName,wetsign,existingDatabase,clientDatabaseCode,proposalBusinessUnit); 
            }
        } 
    //DOC-1655-Added by Nandha : Ends here
    // DOC 2996 Added By Poonam Garg.This method updates field on Quote/Proposal Object 
    /**
     * @description updateRelatedProposal
     * @param orders
     */
    public static void updateRelatedProposal(List<Apttus_Config2__Order__c> orders){
        System.debug(LoggingLevel.WARN,'***Inside After Insert****');
        if(runUpdateProposalFromOrderOnce()){
        List<Apttus_Proposal__Proposal__c> upProposals=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c prop;
         for(Apttus_Config2__Order__c ord:    orders){
            if(!String.isEmpty(ord.Apttus_QPConfig__ProposalId__c)){
                prop=new Apttus_Proposal__Proposal__c();
                prop.APTS_Is_Order_Created__c=true;
                prop.id=ord.Apttus_QPConfig__ProposalId__c;
                upProposals.add(prop);
            }
        }
        if(!upProposals.isEmpty()){
            update upProposals;            
            }
        }
        }
      // DOC 16198 Added By Poonam Garg.This method updates field on Opportunity Object 
    /**
     * @description updateRelatedProposal
     * @param orders
     */
    public static void updateRelatedOpp(List<Apttus_Config2__Order__c> orders){
        System.debug(LoggingLevel.WARN,'***Inside After Insert****');
        if(runUpdateOppFromOrderOnce()){
        List<Opportunity> upOpp=new List<Opportunity>();
        Opportunity opp;
         for(Apttus_Config2__Order__c ord:    orders){
            if(!String.isEmpty(ord.Apttus_Config2__RelatedOpportunityId__c)){
                opp=new Opportunity();
                opp.APTS_Is_Order_Created__c=true;
                opp.id=ord.Apttus_Config2__RelatedOpportunityId__c;
                upOpp.add(opp);
            }
        }
        if(!upOpp.isEmpty()){
            update upOpp;            
            }
        }
        }     
     //DOC-9225 : Dates Calculation for TaxProf - Added by Nandha
     /**
      * @description updatetaxprofdates
      *@param orders
      *@param oldorders
      */
     public static void updatetaxprofdates(List<Apttus_Config2__Order__c> orders,Map<Id,Apttus_Config2__Order__c> oldorders){
        List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
        List<Apttus_Config2__OrderLineItem__c> updateoli = new List<Apttus_Config2__OrderLineItem__c>();
        List<Apttus_Config2__AssetLineItem__c> asllist = new List<Apttus_Config2__AssetLineItem__c>();
        List<ID> orderIds = new List<ID>();
        Integer bridgemonths,myrMonths;
        for(Apttus_Config2__Order__c order : orders) {
           Apttus_Config2__Order__c oldord = oldorders.get(order.Id);
           if (order.APTS_Proposal_Business_Unit__c == 'Tax Professional' && order.APTS_SAP_Status__c == 'Order Submitted' && oldord.APTS_SAP_Status__c != 'Order Submitted') {
              orderIds.add(order.Id);
           } 
        }
        if(orderIds != NULL){
            oliList =[select Id,Apttus_Config2__AssetLineItemId__c,APTS_Bridge_Start_Date__c,APTS_Bridge_End_Date__c,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,APTS_MYR_Start_Date__c,APTS_MYR_End_Date__c,APTS_Contract_Start_Date__c,APTS_Contract_End_Dates__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Term_Type__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c IN :orderIds];
        }
        if(oliList != NULL && oliList.size() >0){
        for(Apttus_Config2__OrderLineItem__c oli : oliList){
            System.debug(LoggingLevel.WARN,'Order @ 2');
            bridgemonths = 0;
            myrMonths = 0;
            if(oli.APTS_Bridge__c != NULL){
                if(oli.APTS_Bridge__c == '1 Month' || oli.APTS_Bridge__c == '2 Months' || oli.APTS_Bridge__c == '3 Months' || oli.APTS_Bridge__c == '4 Months' || oli.APTS_Bridge__c == '5 Months' || oli.APTS_Bridge__c == '6 Months' || oli.APTS_Bridge__c == '7 Months' || oli.APTS_Bridge__c == '8 Months' || oli.APTS_Bridge__c == '9 Months'){
                    bridgemonths = integer.valueof(oli.APTS_Bridge__c.left(1));
                }else if(oli.APTS_Bridge__c == '10 Months' || oli.APTS_Bridge__c == '11 Months'){
                    bridgemonths = integer.valueof(oli.APTS_Bridge__c.left(2));
               }
            }
            if(oli.APTS_Contract_Term__c != NULL){
                System.debug(LoggingLevel.WARN,'Order @ 4');
                if(oli.APTS_Contract_Term__c == '1 Year'){
                    myrMonths = 12;
                }else if(oli.APTS_Contract_Term__c == '2 Years'){
                    myrMonths = 24;
                }else if(oli.APTS_Contract_Term__c == '3 Years'){
                    myrMonths = 36;
                }else if(oli.APTS_Contract_Term__c == '4 Years'){
                    myrMonths = 48;
                }else if(oli.APTS_Contract_Term__c == '5 Years'){
                    myrMonths = 60;
                }
            }
            System.debug(LoggingLevel.WARN,'Order @ 8');
            if(bridgemonths != 0 && myrMonths != 0){
                System.debug(LoggingLevel.WARN,'Order @ 9');
                if(oli.APTS_Term_Type__c == 'Future Start Date'){
                    oli.APTS_Bridge_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_Bridge_End_Date__c = oli.APTS_Bridge_Start_Date__c.addMonths(bridgemonths).toStartofMonth().addDays(-1);
                    oli.Apttus_Config2__StartDate__c = oli.APTS_Bridge_End_Date__c.addMonths(1).toStartofMonth();
                    oli.Apttus_Config2__EndDate__c = oli.Apttus_Config2__StartDate__c.addMonths(12).toStartofMonth().addDays(-1);
                    oli.APTS_MYR_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_MYR_End_Date__c = oli.APTS_MYR_Start_Date__c.addMonths(myrMonths).toStartofMonth().addDays(-1);
                    oli.APTS_Contract_Start_Date__c = oli.APTS_Bridge_Start_Date__c;
                    oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
                }
                else if(oli.APTS_Term_Type__c == 'Future Start Date and Co-term'){
                    oli.APTS_Bridge_Start_Date__c = System.Date.today().addMonths(1).toStartOfMonth();
                    oli.APTS_Bridge_End_Date__c = oli.APTS_Bridge_Start_Date__c.addMonths(bridgemonths).toStartofMonth().addDays(-1);
                    oli.APTS_MYR_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_MYR_End_Date__c = oli.Apttus_Config2__EndDate__c.addMonths(myrMonths - 12);
                    oli.APTS_Contract_Start_Date__c = System.Date.today();
                    oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
                }
                else if(oli.APTS_Term_Type__c == NULL){
                    oli.APTS_Bridge_Start_Date__c = System.Date.today().addMonths(1).toStartOfMonth();
                    oli.APTS_Bridge_End_Date__c = oli.APTS_Bridge_Start_Date__c.addMonths(bridgemonths).toStartofMonth().addDays(-1);
                    oli.Apttus_Config2__StartDate__c = oli.APTS_Bridge_End_Date__c.addMonths(1).toStartofMonth();
                    oli.Apttus_Config2__EndDate__c = oli.Apttus_Config2__StartDate__c.addMonths(12).toStartofMonth().addDays(-1);
                    oli.APTS_MYR_Start_Date__c = oli.APTS_Bridge_End_Date__c.addMonths(1).toStartofMonth();
                    oli.APTS_MYR_End_Date__c = oli.APTS_MYR_Start_Date__c.addMonths(myrMonths).toStartofMonth().addDays(-1);
                    oli.APTS_Contract_Start_Date__c = System.Date.today();
                    oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
                }
           }    
           else if(myrMonths != 0){
               System.debug(LoggingLevel.WARN,'Order @ 10');
               if(oli.APTS_Term_Type__c == 'Co-term'){
                    oli.Apttus_Config2__StartDate__c = System.Date.today().addMonths(1).toStartofMonth();
                    oli.APTS_MYR_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_MYR_End_Date__c = oli.Apttus_Config2__EndDate__c.addMonths(myrMonths - 12);
                    oli.APTS_Contract_Start_Date__c = System.Date.today();
                    oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
               }
               else if(oli.APTS_Term_Type__c == 'Future Start Date'){
                    oli.Apttus_Config2__EndDate__c = oli.Apttus_Config2__StartDate__c.addMonths(12).toStartofMonth().addDays(-1); 
                    oli.APTS_MYR_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_MYR_End_Date__c = oli.APTS_MYR_Start_Date__c.addMonths(myrMonths).toStartofMonth().addDays(-1);
                    oli.APTS_Contract_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
              }
              else if(oli.APTS_Term_Type__c == 'Future Start Date and Co-term'){
                    oli.APTS_MYR_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_MYR_End_Date__c = oli.Apttus_Config2__EndDate__c.addMonths(myrMonths - 12);
                    oli.APTS_Contract_Start_Date__c = oli.Apttus_Config2__StartDate__c;
                    oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
             }
             else{
                 oli.Apttus_Config2__StartDate__c = System.Date.today().addMonths(1).toStartofMonth();
                 oli.Apttus_Config2__EndDate__c = oli.Apttus_Config2__StartDate__c.addMonths(12).toStartofMonth().addDays(-1);
                 oli.APTS_MYR_Start_Date__c = System.Date.today().addMonths(1).toStartofMonth();
                 oli.APTS_MYR_End_Date__c = oli.APTS_MYR_Start_Date__c.addMonths(myrMonths).toStartofMonth().addDays(-1);
                 oli.APTS_Contract_Start_Date__c = System.Date.today();
                 oli.APTS_Contract_End_Dates__c = oli.APTS_MYR_End_Date__c;
            }
         }
         updateoli.add(oli);
         Apttus_Config2__AssetLineItem__c asl = new Apttus_Config2__AssetLineItem__c(Id = oli.Apttus_Config2__AssetLineItemId__c);
         asl.APTS_Bridge_Start_Date__c = oli.APTS_Bridge_Start_Date__c;
         asl.APTS_Bridge_End_Date__c = oli.APTS_Bridge_End_Date__c;
         asl.Apttus_Config2__StartDate__c = oli.Apttus_Config2__StartDate__c;
         asl.Apttus_Config2__EndDate__c = oli.Apttus_Config2__EndDate__c;
         asl.APTS_MYR_Start_Date__c = oli.APTS_MYR_Start_Date__c;
         asl.APTS_MYR_End_Date__c = oli.APTS_MYR_End_Date__c;
         asl.APTS_Contract_Start_Date__c = oli.APTS_Contract_Start_Date__c;
         asl.APTS_Contract_End_Dates__c = oli.APTS_Contract_End_Dates__c;
         asllist.add(asl);         
      }
      if(updateoli != NULL && updateoli.size() > 0){
        update updateoli;
      }
      if(asllist != NULL && asllist.size() > 0){
            update asllist; 
      }
     }
    }
     //DOC 2996 Added by Poonam Garg to avoid running Method recursively on Order After Insert
    public static boolean runUpdateProposalFromOrderOnce(){
        if(runUpdateProposalFromOrderTrigger  ){
         runUpdateProposalFromOrderTrigger  =false;
         return true;
        }else{
            return runUpdateProposalFromOrderTrigger ;
        }
    }
    //DOC 16198 Added by Poonam Garg to avoid running Method recursively on Order After Insert
    public static boolean runUpdateOppFromOrderOnce(){
        if(runUpdateOppFromOrderTrigger  ){
         runUpdateOppFromOrderTrigger  =false;
         return true;
        }else{
            return runUpdateOppFromOrderTrigger ;
        }
    }
}