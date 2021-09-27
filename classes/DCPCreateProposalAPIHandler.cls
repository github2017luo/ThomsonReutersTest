/* Class: DCPCreateProposalAPIHandler
* Purpose: Handler to handle the Rest API Service to create proposal records for three different sites like USL, Tax Professional, Canada
* Created: 05/24/2021
* Author: Avudaiappan A
*
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-05-24   Avudaiappan A     DCP-1982   Refactoring for PMD
*/
/********************************************************************************************************
*  @description  DCPCreateProposalAPIHandler - Handler class to perform business logic for CreateProposalAPI
********************************************************************************************************/
public with sharing class DCPCreateProposalAPIHandler{

 /********************************************************************************************************
*  @description  createLines - Method to create line item
*  @param staticVal - Bring all static values
*  @return String - jsonData 
*********************************************************************************************************/ 
public static string createLines(Map<String,String> staticVal){
        String jsonData;
        DCPCreateProposalAPI.statusCls sts = new DCPCreateProposalAPI.statusCls();
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
      Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','webServiceName'=>'CreateProposalAPI','requestType'=>'Line Item Record Creation','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>staticVal.get('cartId'),'supportEmail'=>staticVal.get('supportEmail'),'toSupport'=>'true'};
        List<Id> lineIds = new List<Id>();
        string cartId = staticVal.get('cartId');
        String query = 'Select id,Apttus_Config2__ProductId__c from Apttus_Config2__LineItem__c where (Apttus_Config2__ConfigurationId__c =:cartId and Mark_Removed__c = true)';
        lineItemList = Database.Query(query);
        if(!lineItemList.isEmpty()){
            for(Apttus_Config2__LineItem__c li: lineItemList){
                if(String.isBlank(li.Apttus_Config2__ProductId__c)){
                    lineIds.add(li.Id);
                }
            }
        }
        if(!lineIds.isEmpty()){
            jsonData = (String.isNotBlank(String.ValueOf(lineIds[0])))?NULL+','+staticVal.get('cartId')+','+String.ValueOf(lineIds[0])+','+NULL+','+NULL+','+NULL:NULL;
        }else{
            
        Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
                lineSO.Apttus_Config2__ConfigurationId__c = cartId;
                lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
                lineSO.Mark_Removed__c = true;
                lineSO.Apttus_Config2__LineNumber__c = Decimal.valueOf(staticVal.get('lineItemNumber'));
                lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
                lineSO.Apttus_Config2__IsPrimaryLine__c = true;
                try{
                    Database.insert(lineSO,true);
                    jsonData = (String.isNotBlank(lineSO.Id))?null+','+staticVal.get('cartId')+','+lineSO.Id+','+NULL+','+NULL+','+NULL:NULL;
                }catch(Exception e){
                   sts.status = TRStoreConstants.FAILURESTATUS;
                   sts.statusCode = TRStoreConstants.ERROR_CODE;
                   errorhandlerMap.put('expMsg',e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString());
                   TRStore_ErrorHandler.logException(errorHandlerMap);
                }
            }
                return jsonData;
    }
  
     /********************************************************************************************************
*  @description  checkForData - Method to check the data.
*  @param staticVal - Bring all static values
*  @param halfPointLimit - halfPointLimit for getting the custom data limit
*  @return String - jsonData 
*********************************************************************************************************/ 
    public Static String checkForData(Map<String,String> staticVal,Integer halfPointLimit){
        String jsonData;
        List<UE_Proposal__c> oQList = new List<UE_Proposal__c>([Select lineitemId__c,quoteId__c,cartId__c,InActive__c from UE_Proposal__c where appId__c =:staticVal.get('site') and InActive__c=false]);
        if(OQList!=null && OQList.size()>0){ 
            List<Apttus_Config2__ProductConfiguration__c> pcList = [Select Id, Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c, name from Apttus_Config2__ProductConfiguration__c where Id =:OQList[0].CartId__c WITH SECURITY_ENFORCED];
            jsonData = OQList[0].QuoteId__c+','+OQList[0].CartId__c+','+OQList[0].lineItemId__c+','+pcList[0].Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c+','+pcList[0].name;
            OQList[0].inactive__c = true;
            Update OQList[0];
        }else{
            jsonData = DCPCreateProposalAPIHandler.getJSONData(staticVal);
        }
        
       if((oQlist.size() <= halfPointLimit)&&((staticVal.get('site')).contains('UECAPR') || (staticVal.get('site')).contains('UEUSPR'))){
            String[] status = new String[]{'Holding','Preparing','Processing','Queued'};
            List<AsyncApexJob> asyncJobList = new  List<AsyncApexJob>([select Id,ApexClass.Name,Status from AsyncApexJob where CreatedDate = TODAY and ApexClass.Name = 'TRStore_CreateProposalApexQueue' and (status IN:Status) WITH SECURITY_ENFORCED]);
           if(asyncJobList.size()==0){
             System.enqueueJob(new TRStore_CreateProposalApexQueue(staticVal.get('site')));
            }
        }
        return jsonData;
    }

  private static string getJSONData(Map<String,String> staticVal){
        String jsonData;
        if((staticVal.get('site')).contains('UECAPR') || (staticVal.get('site')).contains('UEUSPR')){
            DCPCreateProposalAPI.createProposal(staticVal.get('priceListName'),1,staticVal.get('site'));
            jsonData = String.isNotBlank(DCPCreateProposalAPI.proposalIds)?DCPCreateProposalAPI.proposalIds:NULL;
        }else{
            jsonData = null;
        }
        return jsonData;
    }


   /********************************************************************************************************
*  @description  createLineItems - Method to create Lines
*  @param thresholdLimit - thresholdLimit for getting the custom data limit
*  @param cartSaveResultList - cartSaveResultList is the list of cart
*  @return DCPCreateProposalAPI.ProductConfigWrapper - Wrapper class 
*********************************************************************************************************/ 
    
    public static DCPCreateProposalAPI.ProductConfigWrapper createLineItems(Integer thresholdLimit, Database.SaveResult[] cartSaveResultList){
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        DCPCreateProposalAPI.ProductConfigWrapper lineMap = new DCPCreateProposalAPI.ProductConfigWrapper();
        Set<Id> prodConfigIds = new Set<Id>();
        for(integer i=0; i<thresholdLimit;i++){
            Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
            lineSO.Apttus_Config2__ConfigurationId__c = cartSaveResultList[i].getId();
            lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
            lineSO.Mark_Removed__c = true;
            lineSO.Apttus_Config2__LineNumber__c = 1000;
            lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
            lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
            lineSO.Apttus_Config2__IsPrimaryLine__c = true;
            //lineSO.Apttus_Config2__PriceListId__c = (pli!=null)?pli.id:null;
            prodConfigIds.add(cartSaveResultList[i].getId());
            lineItemList.add(lineSO);
        }
        lineMap.lineItemList = lineItemList;
        lineMap.prodConfigIds = prodConfigIds;
        return lineMap;
    }
/********************************************************************************************************
*  @description  insertCart - Method to create Lines
*  @param prodConfigIds - prodConfigIds for getting the cartIds
*  @param thresholdLimit - thresholdLimit is the integer limit
*  @param params - list of params
*********************************************************************************************************/ 
 
    public static void insertCart(Set<Id> prodConfigIds,Integer thresholdLimit,Map<String,String> params){
        List<UE_Proposal__c> oQList = new List<UE_Proposal__c>();
        if(!prodConfigIds.isEmpty()){
            for (Apttus_Config2__lineItem__c li : [Select Id,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.name, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c from Apttus_Config2__lineItem__c where Apttus_Config2__ConfigurationId__c IN:prodConfigIds ]) {
                if(thresholdLimit>=1){ 
                    OQlist.add(new UE_Proposal__c(LineItemId__c = li.id,CartId__c = li.Apttus_Config2__ConfigurationId__c,QuoteId__c=li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,appId__c = params.get('site')));
                }else{
                    DCPCreateProposalAPI.proposalIds = li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c+','+li.Apttus_Config2__ConfigurationId__c+','+li.id+', '+li.Apttus_Config2__ConfigurationId__r.name+', '+li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c;
                }
            }
                system.debug(loggingLevel.INFO, 'Orphan Records:'+OQlist);
        }
        if(OQlist!=null && OQlist.size()>0){
             Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','webServiceName'=>'CreateProposalAPI','requestType'=>'UEProposal Creation','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>OQlist[0].id,'supportEmail'=>params.get('supportEmail'),'toSupport'=>'true'};

            try{
                Database.insert(OQlist,true);
                
            }catch(Exception e){
                 errorhandlerMap.put('expMsg',e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString());
        TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        }
    }
/********************************************************************************************************
*  @description  deleteCart - Method to delete Lines
*  @param thresholdLimit - thresholdLimit for getting the cartIds
*  @param site - site represents current site
*  @param supportEmail - Email to be dropped for any issues
*********************************************************************************************************/ 
 
    public static void deleteCart(Integer thresholdLimit,String site,String supportEmail){
        //Delete the inactive records
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','webServiceName'=>'CreateProposalAPI','requestType'=>'UEProposalRecord deletion','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>'','supportEmail'=>supportEmail,'toSupport'=>'true'};
        if(thresholdLimit>=1){
            List<UE_Proposal__c> uEList = [Select id from UE_Proposal__c where InActive__c = true and appId__c =:site WITH SECURITY_ENFORCED Limit 200];
            system.debug(loggingLevel.INFO, 'Orphan Records:'+uElist);
            if(uEList!=null && uEList.size()>0){
                try{
                    Database.delete(uEList,true);
                }catch(Exception e){
                    errorhandlerMap.put('expMsg',e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString());
                    TRStore_ErrorHandler.logException(errorHandlerMap);
                }
            }
        }
    }
}