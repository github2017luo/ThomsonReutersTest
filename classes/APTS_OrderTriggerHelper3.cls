/**
* @description Helper class for OrderSubmission
*/
public without sharing class APTS_OrderTriggerHelper3{
   Public static String apttuslite = apttuslitevalue();
    /**
       * @description varialbe for recusive check of case creation
    */
    //public static Boolean caseCreated = false;
    
    /**
     * @description integrationloggerNotSAP
     * @param orderNotSap of type List<Apttus_Config2__Order__c>
     * @return List<Apttus_Config2__Order__c>
     */
    public static List<Apttus_Config2__Order__c> integrationloggerNotSAP(List<Apttus_Config2__Order__c> orderNotSap){   
        List<Apttus_Config2__Order__c> orderNotSapUpdt = new List<Apttus_Config2__Order__c>();
        String loggerId;
        List<Integration_Logger__c> intLogList =new List<Integration_Logger__c>();
        Map<Id,Id> loggerRecordMap = new Map<Id,Id>();
        if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable()){
            intLogList = [Select Id,Order__c from Integration_Logger__c where Service_Name__c ='OrderSubmission' AND Order__c IN: orderNotSap];
        }
        for(Integration_Logger__c inteL:intLogList){
            loggerRecordMap.put(inteL.Order__c,inteL.Id);
        }
        List<APTS_ZPND_Submission__e> listoforderplatform = new  List<APTS_ZPND_Submission__e>();
        for(Apttus_Config2__Order__c order1 : orderNotSap){
            if(order1.Retry_Count__c>3){
                continue;
            }
            APTS_ZPND_Submission__e pe = new APTS_ZPND_Submission__e();
            pe.Order_ID__c = order1.ID; 
            pe.Proposal_ID__c = order1.Apttus_QPConfig__ProposalId__c;  
            pe.SSD_ID__c = order1.APTS_SSD_Sold_To__c;  
            listoforderplatform.add(pe);
            if(loggerRecordMap != null && loggerRecordMap.get(order1.id) != null){
                IntegrationLogger.TaxupdateMessage(loggerRecordMap.get(order1.id),false,'Order submission to SAP failed. Reason : ZPND failed','');
                loggerId = loggerRecordMap.get(order1.id);
            }else{
                loggerId = IntegrationLogger.OCAddMessage('Order submission to SAP failed. Reason : ZPND failed','', 'Order','', 'Outbound','OrderSubmission',false,order1.Id);    
            }
            Apttus_Config2__Order__c orderRec = new Apttus_Config2__Order__c(ID=order1.ID, Retry_Count__c = (order1.Retry_Count__c==null)?1:order1.Retry_Count__c + 1);
            orderNotSapUpdt.add(orderRec);
        }
        chatterPost(orderNotSap);
        List<Database.SaveResult> results = EventBus.publish(listoforderplatform);
        System.debug(LoggingLevel.DEBUG, 'results : '+results);     
        System.debug(LoggingLevel.DEBUG, 'orderNotSapUpdt : integrationloggerNotSAP :'+orderNotSapUpdt);
        return orderNotSapUpdt;
    }
       
       /**
       * @description chatterPost
       * @param orderNotSap of type List<Apttus_Config2__Order__c>
       */
       @testVisible private static void chatterPost(List<Apttus_Config2__Order__c> orderNotSap){    
           List<FeedItem> postlist = new List<FeedItem>();
            FeedItem post = new FeedItem();
           for(Apttus_Config2__Order__c order1 : orderNotSap){
              
               post.ParentId = order1.Apttus_QPConfig__ProposalId__c;
               post.Body = 'Order submission to SAP failed. Reason : ZPND failed';
               postlist.add(post);
           }
           if(FeedItem.sObjectType.getDescribe().isCreateable() && postlist != null){
               insert postlist;
           }
       } 
    
       /**
    * @description Method for updating Order records for Order Submission
    * @param orderrecords of type List<Apttus_Config2__Order__c>
    * @param orderLite of type List<Apttus_Config2__Order__c>
    * @param orderNotSapUpdt of type List<Apttus_Config2__Order__c>
    */
    public static void updateorder(Map<Id,String> orderrecords,List<Apttus_Config2__Order__c> orderLite, List<Apttus_Config2__Order__c> orderNotSapUpdt){
        List<Apttus_Config2__Order__c> ordercaselist = new List<Apttus_Config2__Order__c>();
        List<Apttus_Config2__Order__c> ordersaplist = new List<Apttus_Config2__Order__c>();
        if(orderrecords != null){
            ordersaplist = APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        }
        /*for(Apttus_Config2__Order__c o:orderLite)
        {
        system.debug(LoggingLevel.DEBUG, 'orderLite : '+o.id);
        }*/
        //if(orderLite.size()>0 && caseCreated == false){
        if(orderLite.size()>0){
            ordercaselist = APTS_OrderTriggerHelper2.startCaseCreation(orderLite);
        //    caseCreated = true;
        }
        verifyList(ordercaselist, orderNotSapUpdt, ordersaplist);
        if(Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable() && ordersaplist != null){
            update ordersaplist;
            System.debug(LoggingLevel.DEBUG, 'ordersaplist : updateorder :'+ordersaplist);
        }
    }

    @testvisible
    private static void verifyList(List<Apttus_Config2__Order__c> ordercaselist, List<Apttus_Config2__Order__c> orderNotSapUpdt, List<Apttus_Config2__Order__c> ordersaplist){
        if(ordercaselist!=null && ordercaselist.size()>0){
            ordersaplist.addAll(ordercaselist);
        }
        if(orderNotSapUpdt!=null && orderNotSapUpdt.size()>0){
            ordersaplist.addAll(orderNotSapUpdt);
        }
    }

    /**
    * @description getting apttus lite values
    *@return String 
    */
    public static String apttuslitevalue()
    {   List<APTS_Integration_Variables__mdt> apttusten = new List<APTS_Integration_Variables__mdt>(); 
       String apttuslite; 
       if(Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible())
       {
           apttusten = [Select Value__c  from APTS_Integration_Variables__mdt where MasterLabel ='RISKGlobalProposalBusinessUnit'];
       }
     for(APTS_Integration_Variables__mdt v :apttusten ){
         apttuslite=v.Value__c;
     }
     
       return apttuslite;
    }

    /**
    * @description Method for querying orders
    * @param tempOrderMap of type Map<ID, Apttus_Config2__Order__c>
    * @param order of type Apttus_Config2__Order__c
    * @param saporderbus of type Set<String>
    * @return Integer
    */
    @testVisible public static Integer getconditionNumber(Map<ID, Apttus_Config2__Order__c> tempOrderMap, Apttus_Config2__Order__c order, Set<String> saporderbus){
        Integer i = 0;
        
         
        if(apttuslite.contains(order.APTS_Proposal_Business_Unit__c) && order.APTS_SAP_Status__c != 'Case Created'){
           i=1;
        }else if(tempOrderMap.get(order.ID)!=null && tempOrderMap.get(order.ID).APTS_SSD_Sold_To__r.Source_System_Account_Number__c == null && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
            i=2;
        }else if(order.APTS_Platform_Event_Triggered__c != true && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
            i=3;
        }
        return i;
    }
}