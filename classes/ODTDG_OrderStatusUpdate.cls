/*
Author : Sameeksha Sharma
Date: August 2021
Description: Create Request tructure
@description ODTDG_OrderStatusUpdate class to call Boomi service when the oder get submitted
*/

/** @description ODTDG_OrderStatusUpdate : When the status of the order get submitted then the request structure of the pendo api created*/
//@SuppressWarnings('PMD')
public class ODTDG_OrderStatusUpdate implements Queueable, Database.AllowsCallouts{
    public List<Apttus_Config2__Order__c> ordList ; 
    public Map<Id,Apttus_Config2__Order__c> oldMap;
      
    
/** @description : ued to get the list and map 
 @param ordList : accept new list of order
 @param oldMap : accept old map of order */

    public ODTDG_OrderStatusUpdate(List<Apttus_Config2__Order__c> ordList, Map<Id,Apttus_Config2__Order__c> oldMap){
        this.ordList = ordList ; 
        this.oldMap = oldMap;
    }
    
/**@description : used to check whether the status of order is submitted 
@param context : call queueable */
    public void execute(QueueableContext context) {
        
        Id trId;
        List<Id> oppIds= new List<Id>();
        List<Map<String,object>> finalList = new List<Map<String,object>>();  
        String trialConvertion = ODTDG_Helper.getStaticValues('TRIAL_CONVERTION');
        String ordSubmit = ODTDG_Helper.getStaticValues('Order Submitted');
        String planToPlan = ODTDG_Helper.getStaticValues('Plan to Plan'); 
        Map<Id,Apttus_Config2__Order__c> oppDateMap = new Map<Id,Apttus_Config2__Order__c>();
        Map<Id,List<Map<String,String>>> propertyLstMap = new Map<Id,List<Map<String,String>>>();
        
        for(Apttus_Config2__Order__c ord :ordList){
            if(oldMap.get(ord.Id).APTS_SAP_Status__c != ordSubmit && ord.APTS_SAP_Status__c == ordSubmit){
                oppIds.add(ord.Apttus_Config2__RelatedOpportunityId__c);
                oppDateMap.put(ord.Apttus_Config2__RelatedOpportunityId__c , ord);
            }
        }    
        
        propertyLstMap = ordDate(oppDateMap);
        
        if(!oppIds.isEmpty()){
            List<Trial_Product_Contact__c> entTrialList=[SELECT Id, Trials__r.Id,Trials__r.Opportunity__r.Sales_Org__c, Trials__r.Trial_End_Date__c, 
                                                         Trials__r.Trial_Start_Date__c, Trial_Contact__r.Id, 
                                                         Trial_Contact__r.External_Contact_Number__c, 
                                                         Trial_Contact__r.One_Pass_ID__c,Trial_Product__r.Relationship_Type__c,
                                                         Trial_Product__r.Product_Offerings__c FROM Trial_Product_Contact__c 
                                                         where Trials__r.Opportunity__c in :oppIds 
                                                         AND Trial_Product__r.Relationship_Type__c= :planToPlan];
            
            
            if(!entTrialList.isEmpty()){
                for(Trial_Product_Contact__c entTrial : entTrialList){
                    trId = entTrial.Trials__r.Id;
                    Map<String,object> temp = new Map<String,object>();
                    temp.put('properties',propertyLstMap.get(entTrial.Trials__r.Opportunity__c));
                    system.debug(LoggingLevel.INFO,'properties>>'+JSON.serialize(propertyLstMap.get(entTrial.Trials__r.Opportunity__c)));
                    temp.put('actionEventType', trialConvertion);
                    temp.put('endDate',String.valueOf(entTrial.Trials__r.Trial_End_Date__c));
                    temp.put('startDate',String.valueOf(entTrial.Trials__r.Trial_Start_Date__c));
                    temp.put('trialId',entTrial.Trials__r.Id);
                    temp.put('visitorID',entTrial.Trial_Contact__r.One_Pass_ID__c);
                    temp.put('salesOrg', convertToUpper(entTrial.Trials__r.Opportunity__r.Sales_Org__c));
                    temp.put('customerId',entTrial.Trial_Contact__r.External_Contact_Number__c);
                    temp.put('productType',getProductType(entTrial.Trial_Product__r.Product_Offerings__c) );
                    finalList.add(temp);               
                }       
            } 
        }
        if(finalList.size()>0){
          reqStr(JSON.serialize(finalList), trId);
        }     
    }
    
/**@description : used to check whether the status of order is submitted 
@param body : Used to store JSON request structure
@param trId : Used to store Trial Id */
    public static void reqStr(String body, Id trId){
        system.debug(LoggingLevel.INFO,'body In Resp>>'+body);
         
        string tfmsApi = ODTDG_Helper.getStaticValues('ODTDG_Tfms_Auth');
        if(tfmsApi != null){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(tfmsApi);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setbody(body);
            req.setTimeout(120000);
            Http http = new Http();
            HTTPResponse response = http.send(req);
            system.debug(LoggingLevel.INFO,'response>>'+response);
            system.debug(LoggingLevel.INFO,'status code>>'+ response.getStatusCode());
            if(response.getStatusCode() != 200){
                String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Ent_Trial__c ','expMsg'=>'TFMS Call has Failed For Order','webServiceName'=>'TFMS Api','requestType'=>'Produc Information Udation','reqMsg'=>'Exception Class Name: ODTDG_OrderStatusUpdate','module'=>'Trials','recId'=>trId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        } 
    }
    
    /**@description : used to create property key value map 
    @param orderDate : Used to store opportunity id and order date
    @return Map<Id,List<Map<String,String>>> : Used to store Opportunity Id with order date */
    
    public static Map<Id,List<Map<String,String>>> ordDate(Map<Id,Apttus_Config2__Order__c> orderDate){
        
        Map<Id,List<Map<String,String>>> finalMap = new Map<Id,List<Map<String,String>>>();
        for(Id key : orderDate.keySet()){
            List<Map<String,String>> tempproList = new List<Map<String,String>>();
            Datetime datVal = orderDate.get(key).Apttus_Config2__OrderDate__c;
            if(datVal != null){
                Date orDate = Date.newInstance(datVal.year(), datVal.month(), datVal.day());
                Map<String,String> proMap = new Map<String,String>{'value'=> String.valueOf(orDate), 'key'=> 'trial_purchased_date'};
                tempproList.add(proMap);
            }
            else{
                Datetime datValLocal= system.Today();
                Date orDate = Date.newInstance(datValLocal.year(), datValLocal.month(), datValLocal.day());
                
                Map<String,String> proMap = new Map<String,String>{'value'=> String.valueOf(orDate), 'key'=> 'trial_purchased_date'};
                tempproList.add(proMap);
            }
            
            finalMap.put(key, tempproList);
        }
        return finalMap;
    }
    
    
    private string convertToUpper(string val){
        return (val != null) ? val.toUpperCase() : '';
    }


    private string getProductType(string productOffering){
        String type=null;
        if(productOffering!=null && productOffering!=''){
            String offering=productOffering.toLowercase();
            offering='ODTDG_'+offering;
            type = ODTDG_Helper.getStaticValues(offering);
        }
        return convertToUpper(type);
    }
    
}