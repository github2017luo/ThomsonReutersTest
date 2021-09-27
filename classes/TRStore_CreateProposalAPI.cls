/* Class: TRStore_CreateProposalAPI
* Purpose: Rest API Service to create proposal records for three different sites like USL, Tax Professional, Canada
* Created: 04/28/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-04-28   Avudaiappan A     DUE-2307   Creating Service for Creating Proposal Records in SFDC
* 2020-07-24   Avudaiappan A     DUE-4074   Performance Improvement by removing delete dml and added it in async call
* 2020-08-07   Avudaiappan A     DUE-4362   Added new parameters like lno, cartId & Added lineItem Creation
* 2020-10-29   Avudaiappan A     DUE-6164   Code Refactoring for PMD
* =============================================================================
*/
@RestResource(urlMapping='/createProposalAPI')
/**
        @description class for CreateProposalAPI
     */
global with sharing class TRStore_CreateProposalAPI{
    
    public static String proposalIds;

    /**
        @description class for Status
     */
    global virtual class StatusCls{
        global string status;
        global string statusCode;
        global string quoteId;
        global string cartId;
        global string lineItemId;
        global string cartName;
        global string priceListId;
    }
    
    
    private static Map<String,String> initialize(RestRequest req){
        Map<String,String> staticVal = new Map<String,String>();
        staticVal.put('supportEmail',Static_Values__c.getValues('OrderProcessSupportEmail').Value__c); // Email address of support team member
		staticVal.put('site',req.Params.get('appId'));
        staticVal.put('cartId',req.Params.get('cartId'));
        staticVal.put('lineItemNumber',req.Params.get('lno'));
        staticVal.put('priceListName',(string.isnotBlank(req.Params.get('appId')) && (req.Params.get('appId')).equalsIgnoreCase('UECAPR'))?Static_Values__c.getValues('TRStorePricelistCA').Value__c:Static_Values__c.getValues('PriceListName').Value__c);
        return staticVal;
    }

    private static string createLines(Map<String,String> staticVal){
        String jsonData;
        statusCls sts = new statusCls();
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
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
            jsonData = (String.isNotBlank(String.ValueOf(lineIds[0])))?null+','+staticVal.get('cartId')+','+String.ValueOf(lineIds[0]):NULL;
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
                    jsonData = (String.isNotBlank(lineSO.Id))?null+','+staticVal.get('cartId')+','+lineSO.Id:NULL;
                }catch(Exception e){
                   sts.status = TRStoreConstants.FAILURESTATUS;
                   sts.statusCode = TRStoreConstants.ERROR_CODE;
                   Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CreateProposalAPI','requestType'=>'Line Item Record Creation','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>staticVal.get('cartId'),'supportEmail'=>staticVal.get('supportEmail'),'toSupport'=>'true'};
                   TRStore_ErrorHandler.logException(errorHandlerMap);
                }
            }
                return jsonData;
    }

    private Static String checkForData(Map<String,String> staticVal,Integer halfPointLimit){
        String jsonData;
        system.debug(logginglevel.INFO,'site value:'+staticVal.get('site'));
        List<UE_Proposal__c> oQList = new List<UE_Proposal__c>([Select lineitemId__c,quoteId__c,cartId__c,InActive__c from UE_Proposal__c where appId__c =:staticVal.get('site') and InActive__c=false]);
        if(OQList!=null && OQList.size()>0){ 
            List<Apttus_Config2__ProductConfiguration__c> pcList = [Select Id, Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c, name from Apttus_Config2__ProductConfiguration__c where Id =:OQList[0].CartId__c WITH SECURITY_ENFORCED];
            jsonData = OQList[0].QuoteId__c+','+OQList[0].CartId__c+','+OQList[0].lineItemId__c+','+pcList[0].Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c+','+pcList[0].name;
            OQList[0].inactive__c = true;
            Update OQList[0];
        }else{
            jsonData = TRStore_CreateProposalAPI.processData(staticVal);
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

    private static string processData(Map<String,String>staticVal){
        String jsonData;
        if((staticVal.get('site')).contains('UECAPR') || (staticVal.get('site')).contains('UEUSPR')){
            TRStore_CreateProposalAPI.createProposal(staticVal.get('priceListName'),1,staticVal.get('site'));
            jsonData = String.isNotBlank(TRStore_CreateProposalAPI.proposalIds)?TRStore_CreateProposalAPI.proposalIds:NULL;
        }else{
            jsonData = null;
        }
        return jsonData;
    }

    @HttpGet
    /**
        @description class for createProposal
        @return StatusCls 
     */
    global static StatusCls createProposalData(){
        
        RestRequest req = RestContext.request;
        Integer thresholdLimit =  Integer.valueof(static_values__c.getValues('thresholdLimit').value__c);
        integer halfPointLimit = Integer.valueof(static_values__c.getValues('halfPointLimit').value__c);
        Map<String,String> staticVal = TRStore_CreateProposalAPI.initialize(req);
        system.debug(LoggingLevel.INFO,'Static Values*****:'+staticVal+thresholdLimit);
        String jsonData;
        StatusCls sts = new StatusCls();
              
        
        RestContext.response.addHeader('Content-Type', 'application/json');

            if(String.isNotBlank(staticVal.get('site')) && String.isBlank(staticVal.get('cartId'))){
                jsonData = TRStore_CreateProposalAPI.checkForData(staticVal,halfPointLimit);
            }else if(String.isNotBlank(staticVal.get('cartId')) && String.isNotBlank(staticVal.get('lineItemNumber'))){
                jsonData = TRStore_CreateProposalAPI.createLines(staticVal);
                
            }else{
                jsonData = null;
            }
            
            
            system.debug(LOGGINGLEVEL.INFO,'@@JSON String:'+jsonData); 
            try{
                if(jsonData!=null && jsonData!='') {
                    sts.status = TRStoreConstants.SUCCESS_STATUS;
                    sts.statusCode = TRStoreConstants.SUCCESS_CODE;
                    String[] ids = jsonData.split(',');
                    sts.quoteId = Ids[0];
                    sts.cartId = Ids[1];
                    sts.lineItemId = Ids[2];
                    if(staticVal.get('site') == 'UEUSPR'){
                        sts.priceListId = Ids[3];
                        sts.cartName = Ids[4];
                    }
                }else  {
                    sts.status = TRStoreConstants.FAILURESTATUS;
                    sts.statusCode = TRStoreConstants.ERROR_CODE;
                }
            }catch(Exception e) {
                sts.status = TRStoreConstants.FAILURESTATUS;
                sts.statusCode = TRStoreConstants.ERROR_CODE;
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CreateProposalAPI','requestType'=>'Getting records from UEProposal','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>staticVal.get('cartId'),'supportEmail'=>staticVal.get('supportEmail'),'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);           
             }
                
        return sts;
    }
    
    private static List<Apttus_Proposal__Proposal__c> createProposals(Map<String,String> proposalItems,Integer thresholdLimit){
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        for(integer i=0; i<thresholdLimit;i++){
            Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
            String siteValue = proposalItems.get('site');
            proposal.Apttus_Proposal__Proposal_Name__c = 'UEProposal'+'-'+siteValue;
            if(string.isnotBlank(siteValue) && siteValue.equalsIgnoreCase('UECAPR')){
                proposal.APTS_Proposal_Business_Unit__c = Static_Values__c.getValues('ProposalBusinessUnitCA').Value__c;
            } else if(string.isnotBlank(siteValue) && siteValue.equalsIgnoreCase('UEUSPR')){
                proposal.APTS_Proposal_Business_Unit__c = Static_Values__c.getValues('ProposalBusinessUnitUSL').Value__c;
            } else if(string.isnotBlank(siteValue) && siteValue.equalsIgnoreCase('UEUSTP')){
                proposal.APTS_Proposal_Business_Unit__c = Static_Values__c.getValues('ProposalBusinessUnitTP').Value__c;
            } else{
                proposal.APTS_Proposal_Business_Unit__c ='';
            }
            proposal.Apttus_QPConfig__PriceListId__c = (proposalItems.get('pli'))<>NULL?Id.valueOf(proposalItems.get('pli')):null;
            proposal.CurrencyIsoCode = proposalItems.get('currencyUS');
            proposalList.add(proposal);
        }
        return proposalList;
    }

    private static TRStore_CreateProposalAPI.ProductConfigWrapper createLineItems(Integer thresholdLimit, Database.SaveResult[] cartSaveResultList){
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        TRStore_CreateProposalAPI.ProductConfigWrapper lineMap = new TRStore_CreateProposalAPI.ProductConfigWrapper();
        Set<Id> prodConfigIds = new Set<Id>();
        for(integer i=0; i<thresholdLimit;i++){
            Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
            lineSO.Apttus_Config2__ConfigurationId__c = cartSaveResultList[i].getId();
            lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
            lineSO.Mark_Removed__c = true;
            lineSO.Apttus_Config2__LineNumber__c = 1;
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
    /**
        @description method for createProposal
        @param priceListName
        @param thresholdLimit
        @param site 
     */
    public static void createProposal(String priceListName,Integer thresholdLimit,String site) {
            List<Apttus_Proposal__Proposal__c>   proposalList = new List<Apttus_Proposal__Proposal__c>(); 
            List<Apttus_Config2__ProductConfiguration__c>   prodConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
        	List<Apttus_Config2__LineItem__c>   lineItemList = new List<Apttus_Config2__LineItem__c>();
            Set<Id> prodConfigIdSet = new Set<Id>();
            Apttus_Config2__PriceList__c pli = new Apttus_Config2__PriceList__c ();
            String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
            if(String.isNotBlank(priceListName)){
                 pli = [select Id from Apttus_Config2__PriceList__c where Apttus_Config2__Active__c = true and Name =: priceListName WITH SECURITY_ENFORCED limit 1];
               }   
               Map<String,String> proposalItems = new Map<String,String>();
               proposalItems.put('currencyUS',((string.isnotBlank(site) && site.equalsIgnoreCase('UECAPR'))?'CAD':'USD'));
               proposalItems.put('site',site);
               proposalItems.put('pli',string.valueOf(pli.id));
               proposalItems.put('supportEmail',supportEmail);
               proposalList = TRStore_CreateProposalAPI.createProposals(proposalItems,thresholdLimit);
               
                system.debug(loggingLevel.INFO, 'Proposal Records:'+proposalList);
            
            if(proposalList!=null && proposalList.size()>0){
                Database.SaveResult[] saveResultList = Database.insert(proposalList, false);
                prodConfigList=TRStore_CreateProposalAPI.createProdConfig(proposalItems,saveResultList,thresholdLimit);
               
            }
                
                
                if(prodConfigList!=null && prodConfigList.size()>0){
                    Database.SaveResult[] cartSaveResultList = Database.insert(prodConfigList, false);
                    //prodConfigIds.addAll(cartSaveResultList.getId());
                    TRStore_CreateProposalAPI.ProductConfigWrapper lineMap = TRStore_CreateProposalAPI.createLineItems(thresholdLimit,cartSaveResultList);
                    lineItemList = lineMap.lineItemList;
                    prodConfigIdSet=lineMap.prodConfigIds;
                }   
                if(!lineItemList.isEmpty()){
                    Database.SaveResult[] liSaveResultList = Database.insert(lineItemList, false);
                    System.debug(logginglevel.INFO,'Status:'+liSaveResultList);
                }
                
            
                TRStore_CreateProposalAPI.insertCart(prodConfigIdSet,thresholdLimit,proposalItems);
                TRStore_CreateProposalAPI.deleteCart(thresholdLimit,site,supportEmail);
        
    }
    /**
        @description Wrapper Cls
         
     */
    public  class ProductConfigWrapper{
        public  List<Apttus_Config2__LineItem__c> lineItemList;
        public  Set<Id> prodConfigIds;
        /**
        @description constructor Cls
         
     */
        public productConfigWrapper(){
            lineItemList = new List<Apttus_Config2__LineItem__c>();
            prodConfigIds = new Set<Id>();
        }
    }

    private static List<Apttus_Config2__ProductConfiguration__c> createProdConfig(Map<String,String> proposalItems,Database.SaveResult[] saveResultList,Integer thresholdLimit){
        String siteValue = proposalItems.get('site');
        String currencyUS = ((string.isnotBlank(siteValue) && siteValue.equalsIgnoreCase('UECAPR'))?'CAD':'USD');
        List<Apttus_Config2__ProductConfiguration__c> prodConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
        for(integer i=0; i<thresholdLimit;i++){
            Integer len = 12;
			Blob blobKey = crypto.generateAesKey(128);
			String key = EncodingUtil.convertToHex(blobKey);
			String unqStr = key.substring(0,len);
            
            Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c();
            prodConfig.Name = 'UE'+siteValue+unqStr;
            prodConfig.Apttus_QPConfig__Proposald__c = saveResultList[i].getId();
            prodConfig.Apttus_Config2__BusinessObjectType__c =  'Proposal';
            prodConfig.Apttus_Config2__PriceListId__c = (proposalItems.get('pli')!=null)?Id.ValueOf(proposalItems.get('pli')):null;
            prodConfig.CurrencyIsoCode = currencyUS;
            prodConfig.Apttus_Config2__BusinessObjectRefId__c = saveResultList[i].getId();
            prodConfig.Apttus_Config2__SummaryGroupType__c= 'Ad Hoc';
            prodConfig.Apttus_Config2__EffectivePriceListId__c = (proposalItems.get('pli')!=null)?Id.ValueOf(proposalItems.get('pli')):null;
            prodConfig.Apttus_Config2__Status__c = 'New';
            prodConfig.Apttus_Config2__IsPricePending__c = TRUE;
            prodConfig.Apttus_CQApprov__Approval_Preview_Status__c = 'Complete';
            prodConfigList.add(prodConfig);
            
        }
        return prodConfigList;
    }
	
    private static void insertCart(Set<Id> prodConfigIds,Integer thresholdLimit,Map<String,String> params){
        List<UE_Proposal__c> oQList = new List<UE_Proposal__c>();
        if(!prodConfigIds.isEmpty()){
            for (Apttus_Config2__lineItem__c li : [Select Id,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.name, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c from Apttus_Config2__lineItem__c where Apttus_Config2__ConfigurationId__c IN:prodConfigIds ]) {
                system.debug(logginglevel.INFO,'QuoteId:'+li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
                if(thresholdLimit>1){ 
                    OQlist.add(new UE_Proposal__c(LineItemId__c = li.id,CartId__c = li.Apttus_Config2__ConfigurationId__c,QuoteId__c=li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,appId__c = params.get('site')));
                }else{
                    TRStore_CreateProposalAPI.proposalIds = li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c+','+li.Apttus_Config2__ConfigurationId__c+','+li.id+', '+li.Apttus_Config2__ConfigurationId__r.name+', '+li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c;
                }
            }
                system.debug(loggingLevel.INFO, 'Orphan Records:'+OQlist);
        }
        if(OQlist!=null && OQlist.size()>0){
            try{
                Database.insert(OQlist,true);
            }catch(Exception e){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CreateProposalAPI','requestType'=>'UEProposal Creation','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>OQlist[0].id,'supportEmail'=>params.get('supportEmail'),'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        }
    }
    
    private static void deleteCart(Integer thresholdLimit,String site,String supportEmail){
        //Delete the inactive records
        if(thresholdLimit>1){
            List<UE_Proposal__c> uEList = [Select id from UE_Proposal__c where InActive__c = true and appId__c =:site WITH SECURITY_ENFORCED Limit 200];
            if(uEList!=null && uEList.size()>0){
                try{
                    Database.delete(uEList,true);
                }catch(Exception e){
                    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CreateProposalAPI','requestType'=>'UEProposalRecord deletion','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>'','supportEmail'=>supportEmail,'toSupport'=>'true'};
                    TRStore_ErrorHandler.logException(errorHandlerMap);
                }
            }
        }
    }
    
}