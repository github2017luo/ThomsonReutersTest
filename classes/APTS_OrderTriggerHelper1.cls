/**
* @description Helper class for OrderSubmission
*/
public without sharing class APTS_OrderTriggerHelper1{
    
    private static Set<String> saporderbus = new Set<String>{'SCS','Canada','Corp OneOTC US','Corp OneOTC UK','FindLaw','SMGE','TRIE'}; //DOC-15952
    //private static Set<string> apttuslite = new Set<String>{'Argentina-LLEY','Brazil-TSL','Hong Kong-SMHK','India-INWL','Australia-PNG-LRA','NZ-Fiji-BKRS','FACT-TRFR','Russia-1S','SouthKorea-DUZON','SMGE','Dofiscal'};
    @testvisible private static Boolean recursivePLIQueryCheck = false;
    @testvisible private static Map<Id,Integer> plimap = new Map<Id,Integer>();
    public static Boolean orderRecursiveCheck = false;
    @testvisible private static Boolean recursivePAVQueryCheck = false;
    @testvisible private static Map<Id,Integer> attplist = new Map<Id,Integer>();
    
    /**
    * @description Method for querying Order Line Item and Proposal line Items records
    * @param orders of type List<Apttus_Config2__Order__c>
    */
    public static void ordersubmission(List<Apttus_Config2__Order__c> orders){
        system.debug(LoggingLevel.Debug,'inside ordersubmission');
        List<Id> propIds = new List<Id>();
        //List<Apttus_Config2__Order__c> orderNotSap = new List<Apttus_Config2__Order__c>();
        Map<Id,Integer> olimap = new Map<Id,Integer>();
        Map<Id,Integer> plimap = new Map<Id,Integer>();
        Map<Id,Id> orderPropmap = new Map<Id,Id>();
        String apttuslite = APTS_OrderTriggerHelper3.apttuslitevalue();
        for(Apttus_Config2__Order__c order : orders){
            /*if(order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c == null && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
                orderNotSap.add(order);
            }else*/ 
            //if((order.APTS_Platform_Event_Triggered__c != true && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)) || (apttuslite.contains(order.APTS_Proposal_Business_Unit__c) && order.APTS_SAP_Status__c != 'Case Created')){
                if(order.APTS_Proposal_Business_Unit__c!=null && order.APTS_Proposal_Business_Unit__c!='' &&
                (((order.APTS_Platform_Event_Triggered__c != true && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)) || apttuslite.contains(order.APTS_Proposal_Business_Unit__c)) && order.APTS_SAP_Status__c == 'Pending')){
                propIds.add(order.Apttus_QPConfig__ProposalId__c);
                orderPropmap.put(order.Id, order.Apttus_QPConfig__ProposalId__c);
            }         
        }  
        //olimap = APTS_OrderTriggerHelper4.queryolirecords(orderPropmap.keySet());
        //plimap = queryplirecords(propIds);
        if(propIds.size()>0){
            invokeintegrationclass1(orders, orderPropmap, new Map<String, Map<Id, Integer>>{'olimap'=>olimap,'plimap'=>plimap});
        }
        //ordernotsapnull(orderNotSap);
    }

    /**
    * @description Method for querying Order Line Item and Proposal line Items records
    * @param orders of type List<Apttus_Config2__Order__c>
    
    public static void ordersubmission(List<Apttus_Config2__Order__c> orders){
        system.debug(LoggingLevel.Debug,'inside ordersubmission');
        List<Id> propIds = new List<Id>();
        List<Apttus_Config2__Order__c> orderNotSap = new List<Apttus_Config2__Order__c>();
        Map<Id,Integer> olimap = new Map<Id,Integer>();
        Map<Id,Integer> plimap = new Map<Id,Integer>();
        String apttuslite = APTS_OrderTriggerHelper3.apttuslitevalue();
        for(Apttus_Config2__Order__c order : [Select Id,Name,APTS_Platform_Event_Triggered__c,APTS_SAP_Status__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Proposal_Business_Unit__c,Apttus_QPConfig__ProposalId__c from Apttus_Config2__Order__c where Id IN: orders AND APTS_Proposal_Business_Unit__c != 'Tax Professional']){
            if(order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c == null && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
                orderNotSap.add(order);
            }else if((order.APTS_Platform_Event_Triggered__c != true && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)) || (apttuslite.contains(order.APTS_Proposal_Business_Unit__c) && order.APTS_SAP_Status__c != 'Case Created')){
                propIds.add(order.Apttus_QPConfig__ProposalId__c);
            }         
        }  
        olimap = queryolirecords(propIds);
        plimap = queryplirecords(propIds);
        if(propIds != null){
            invokeintegrationclass1(propIds,olimap,plimap);
        }
        ordernotsapnull(orderNotSap);
    }
    */
    /**
     * @description Method for chatter post
     * @param orderNotSap of type List<Apttus_Config2__Order__c>
     * @return List<Apttus_Config2__Order__c
    */
    @testVisible private static List<Apttus_Config2__Order__c> ordernotsapnull(List<Apttus_Config2__Order__c> orderNotSap){
        List<Apttus_Config2__Order__c> orderNotSapUpdt;
        if(orderNotSap != null && orderNotSap.size()>0){
            orderNotSapUpdt = APTS_OrderTriggerHelper3.integrationloggerNotSAP(orderNotSap);
        }  
        return orderNotSapUpdt; 
    }
    
    /**
     * @description Method for querying Order Line Item records
     * @param propIds of type List<Id>
     * @return Map<Id,Integer>
    
    @testVisible private static Map<Id,Integer> queryolirecords(List<Id> propIds){
        List<AggregateResult> olilist = new List<AggregateResult>();
        Map<Id,Integer> olimap = new Map<Id,Integer>();
        if(Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isAccessible()){
            olilist = [SELECT Apttus_QPConfig__ProposalId__c,COUNT(Id) FROM Apttus_Config2__OrderLineItem__c WHERE Apttus_QPConfig__ProposalId__c IN: propIds GROUP BY Apttus_QPConfig__ProposalId__c];
        }
        for(AggregateResult ar : olilist){
            olimap.put(String.valueOf(ar.get('Apttus_QPConfig__ProposalId__c')),Integer.valueof(ar.get('expr0')));
        }
        return olimap;
    }*/
    
   
    /**
     * @description Method for querying Proposal Line Item records
     * @param propIds of type List<Id>
     * @return Map<Id,Integer>
    */
    /*@testVisible private static Map<Id,Integer> queryplirecords(List<Id> propIds){
        if(recursivePLIQueryCheck == true){
            return plimap;
        }
        List<AggregateResult> plilist = new List<AggregateResult>();
        //Map<Id,Integer> plimap = new Map<Id,Integer>();
        if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()){
            plilist = [SELECT Apttus_Proposal__Proposal__c,COUNT(Id) FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c IN: propIds GROUP BY Apttus_Proposal__Proposal__c];
        }
        for(AggregateResult ar : plilist){
            plimap.put(String.valueOf(ar.get('Apttus_Proposal__Proposal__c')),Integer.valueof(ar.get('expr0')));
        }
        recursivePLIQueryCheck = true;
        return plimap;
    }*/
    
    /**
     * @description Method for capturing Order records for Order Submission
     * @param propIds of type List<Id>
     * @param olimap of type Map<Id,Integer>
     * @param plimap of type Map<Id,Integer>
    
    @testVisible private static void invokeintegrationclass1(List<Id> propIds,Map<Id,Integer> olimap,Map<Id,Integer> plimap){
        Map<Id,String> orderrecords = new Map<Id,String>();
        String apttuslite = APTS_OrderTriggerHelper3.apttuslitevalue();
        List<Apttus_Config2__Order__c> orderLite = new List<Apttus_Config2__Order__c>();
        for(Apttus_Config2__Order__c order : [Select Id,Name,APTS_Platform_Event_Triggered__c,Apttus_QPConfig__ProposalId__c,APTS_Proposal_Business_Unit__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c,Apttus_QPConfig__ProposalId__r.Id,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__c IN: propIds]){
            if(olimap != null && plimap != null && olimap.get(order.Apttus_QPConfig__ProposalId__c) == plimap.get(order.Apttus_QPConfig__ProposalId__c)){
                if(apttuslite.contains(order.APTS_Proposal_Business_Unit__c) && order.APTS_SAP_Status__c != 'Case Created'){
                    orderLite.add(order);
                }else if(order.APTS_Platform_Event_Triggered__c != true && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
                    orderrecords.put(order.Id,order.APTS_Proposal_Business_Unit__c);
                }
            }
        }
        APTS_OrderTriggerHelper3.updateorder(orderrecords,orderLite);
    }*/
    
    /**
     * @description Method for capturing Order records for Order Submission
     * @param orders of type Apttus_Config2__Order__c
     * @param orderPropmap of type List<Id>
     * @param tempParam2 of type Map<String, Map<Id, Integer>>
    */
    @testVisible private static void invokeintegrationclass1(List<Apttus_Config2__Order__c> orders, Map<Id,Id> orderPropmap, Map<String, Map<Id, Integer>> tempParam2){
        Map<Id,Integer> olimap = tempParam2.get('olimap');
        //Map<Id,Integer> plimap = tempParam2.get('plimap');
        Map<Id,String> orderrecords = new Map<Id,String>();
        Map<Id,Integer> atto = APTS_OrderTriggerHelper4.attributevaluesorder(orderPropmap.keySet());
        Map<Id,Integer> attp = APTS_OrderTriggerHelper4.attributevaluesproposal(orderPropmap.values());
        //String apttuslite = APTS_OrderTriggerHelper3.apttuslitevalue();
        //APTS_OrderTriggerHelper3.apttuslite = apttuslite;//comment by rahul
        List<Apttus_Config2__Order__c> orderLite = new List<Apttus_Config2__Order__c>();
        List<Apttus_Config2__Order__c> orderNotSap = new List<Apttus_Config2__Order__c>();
        Map<ID, Apttus_Config2__Order__c> tempOrderMap = APTS_OrderTriggerHelper2.getOrderList(orderPropmap.keySet());
        System.debug(LoggingLevel.DEBUG, 'orderPropmap : '+orderPropmap);
        System.debug(LoggingLevel.DEBUG, 'tempOrderMap : '+tempOrderMap);
        System.debug(LoggingLevel.DEBUG, 'olimap : '+olimap);
        System.debug(LoggingLevel.DEBUG, 'attribute order map : '+atto);
        System.debug(LoggingLevel.DEBUG, 'attribute proposal map: '+attp);
        System.debug(LoggingLevel.DEBUG, 'orders: '+orders);
        for(Apttus_Config2__Order__c order : orders){
            System.debug(LoggingLevel.DEBUG, 'order : '+order);
            System.debug(LoggingLevel.DEBUG, 'order1: '+tempOrderMap.get(order.id));
            //if(atto!= null && attp != null && olimap != null && plimap != null && olimap.get(order.ID) == plimap.get(orderPropmap.get(order.Id))&& atto.get(order.ID) == attp.get(orderPropmap.get(order.Id))){
            //if(!order.Apttus_Config2__IsTaskPending__c && atto!= null && attp != null && atto.get(order.ID) == attp.get(orderPropmap.get(order.Id))){
            if(tempOrderMap.get(order.id)!=null 
                && tempOrderMap.get(order.id).Apttus_QPConfig__ProposalId__r.Digital_Has_Line_Items__c==tempOrderMap.get(order.id).APTS_Count_of_Line_Items__c 
                && atto!= null && attp != null && atto.get(order.ID) == attp.get(orderPropmap.get(order.Id))){
                 System.debug(LoggingLevel.DEBUG, 'Data is ready for order');
                Integer i = APTS_OrderTriggerHelper3.getconditionNumber(tempOrderMap, order, saporderbus);
                switch on i{
                    when 1 {
                        orderLite.add(tempOrderMap.get(order.Id));
                        orderRecursiveCheck = true;
                    } 
                    when 2 {
                        orderNotSap.add(order);
                        orderRecursiveCheck = true;
                    }
                    when 3 {
                        orderrecords.put(order.Id,order.APTS_Proposal_Business_Unit__c);
                        orderRecursiveCheck = true;
                    }
                }
                /*if(apttuslite.contains(order.APTS_Proposal_Business_Unit__c) && order.APTS_SAP_Status__c != 'Case Created'){
                    orderLite.add(tempOrderMap.get(order.Id));
                    orderRecursiveCheck = true;
                }else if(tempOrderMap.get(order.ID)!=null && tempOrderMap.get(order.ID).APTS_SSD_Sold_To__r.Source_System_Account_Number__c == null && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
                    orderNotSap.add(order);
                    orderRecursiveCheck = true;
                }else if(order.APTS_Platform_Event_Triggered__c != true && saporderbus.contains(order.APTS_Proposal_Business_Unit__c)){
                    orderrecords.put(order.Id,order.APTS_Proposal_Business_Unit__c);
                    orderRecursiveCheck = true;
                }*/
            }
        }
        List<Apttus_Config2__Order__c> orderNotSapUpdt = ordernotsapnull(orderNotSap);
        APTS_OrderTriggerHelper3.updateorder(orderrecords, orderLite, orderNotSapUpdt);
    }
   
    
    
    /**
    * @description Method for invoking Integration class
    * @param orderrecords of type Map<Id,String>
    * @return List<Apttus_Config2__Order__c>
    */
    @testVisible public static List<Apttus_Config2__Order__c> invokeintegrationclass2(Map<Id,String> orderrecords){
        List<APTS_Ordersubmissionwrapper> orderdetails = new List<APTS_Ordersubmissionwrapper>();
        List<Apttus_Config2__Order__c> orderlist = new List<Apttus_Config2__Order__c>();
        for(Id orderId : orderrecords.keySet()){
            APTS_Ordersubmissionwrapper orderdetail = new APTS_Ordersubmissionwrapper();
            if(orderrecords.get(orderId) == 'SCS'){
                orderdetail = APTS_OrderQueuetoESI.orderSubmissionToESI(orderId);
                orderdetails.add(orderdetail);
            }else if(orderrecords.get(orderId) == 'FindLaw'){
                orderdetail = APTS_FindLawOrderQueuetoESI.FLorderSubmissionToESI(orderId); 
                orderdetails.add(orderdetail);
            }else if(orderrecords.get(orderId) == 'Corp OneOTC US' || orderrecords.get(orderId) == 'Corp OneOTC UK'){
                orderdetail = APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(orderId);
                orderdetails.add(orderdetail);
            }else if(orderrecords.get(orderId) == 'Canada'){ 
                orderdetail = APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(orderId);
                orderdetails.add(orderdetail);
            /*RG:}else if(orderrecords.get(orderId) == 'SMGE' || orderrecords.get(orderId) == 'TRIE'){ 
                orderdetail = APTS_OrderQueuetoBoomi_UKI.orderSubmissionToESI(orderId);
                orderdetails.add(orderdetail); RG */
            }
        }
        if(orderdetails != null){
            orderlist = orderPublishingEvent(orderdetails);
        }
        return orderlist;
    }
    
   
    
    /**
    * @description orderPublishingEvent
    * @param orderdetails
    * @return List<Apttus_Config2__Order__c>
    */
    @testVisible private static List<Apttus_Config2__Order__c> orderPublishingEvent(List<APTS_Ordersubmissionwrapper> orderdetails){ 
        List<Apttus_Config2__Order__c> orderlist = new List<Apttus_Config2__Order__c>();
        List<APTS_Order_Submission__e> listoforderplatform = new  List<APTS_Order_Submission__e>();
        List<ID> orderIDList = new List<ID>();
        for(APTS_Ordersubmissionwrapper order : orderdetails){   
            System.debug(LoggingLevel.DEBUG,'orderdetails : '+orderdetails);            
            if(order.isSuccess==true || Test.isRunningTest()){
                System.debug(LoggingLevel.DEBUG,'order.isSuccess : '+order.isSuccess);            
                APTS_Order_Submission__e orderplatform = new APTS_Order_Submission__e();
                orderplatform.ApplicationID__c = order.applicationId;
                orderplatform.CompanyID__c = order.companyId;
                orderplatform.JSONRecordID__c = order.loggerrecordId;
                orderplatform.OrderNo__c = order.orderNo;
                listoforderplatform.add(orderplatform);
                orderIDList.add(order.orderId);
            }
        }
        List<Database.SaveResult> results = EventBus.publish(listoforderplatform);
        Integer i = 0;
        for(ID orderID : orderIDList){   
        //for(Database.SaveResult sr : results){
            Database.SaveResult sr = results[i];
            if(sr.isSuccess()){
                System.debug(LoggingLevel.WARN,'Successfully published event.');
                Apttus_Config2__Order__c orderRec = new Apttus_Config2__Order__c(ID=orderID, APTS_Platform_Event_Triggered__c=true);
                orderlist.add(orderRec);
            }else{
                System.debug(LoggingLevel.WARN,'Exception returned: ' +sr.getErrors());
                //for(Database.Error err : sr.getErrors()){
                //    System.debug(LoggingLevel.WARN,'Error returned: ' +err.getStatusCode() +' - '+err.getMessage());
                //}
            }
            i++;
        //}
        }
        return orderlist;
    }
}