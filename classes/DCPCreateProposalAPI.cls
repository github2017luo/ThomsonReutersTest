/* Class: DCPCreateProposalAPI
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
* 2021-05-24   Avudaiappan A     DCP-1982   Code Refactoring for USL Support and PMD
* =============================================================================
*/
@RestResource(urlMapping='/newsale/DCPCreateProposalService')
/********************************************************************************************************
*  @description  DCPCreateProposalAPI - This is the main class to handle the create Quote/Propsoal
*********************************************************************************************************/
      
global with sharing class DCPCreateProposalAPI{
 /********************************************************************************************************
*  @description  StatusCls - Status class
*********************************************************************************************************/   
public static String proposalIds;
        
global  class StatusCls{
        global string status;
        global string statusCode;
        global string quoteId;
        global string cartId;
        global string lineItemId;
        global string cartName;
        global string priceListId;
    }
    
    /********************************************************************************************************
    *  @description  initialize - Method to initialize the value 
    * @param req - Rest request
    * @return Map<String,String> - returns all the value mapped 
    *********************************************************************************************************/
    public static Map<String,String> initialize(RestRequest req){
        Map<String,String> staticVal = new Map<String,String>();
        staticVal.put('supportEmail',Static_Values__c.getValues('OrderProcessSupportEmail').Value__c); // Email address of support team member
        staticVal.put('site',req.Params.get('appId'));
        staticVal.put('cartId',req.Params.get('cartId'));
        staticVal.put('lineItemNumber',req.Params.get('lno'));
        staticVal.put('priceListName',(string.isnotBlank(req.Params.get('appId')) && (req.Params.get('appId')).equalsIgnoreCase('UECAPR'))?Static_Values__c.getValues('TRStorePricelistCA').Value__c:Static_Values__c.getValues('PriceListName').Value__c);
        return staticVal;
    }

    @HttpGet
   /********************************************************************************************************
    *  @description  createProposalData - Method to Create the proposal record
    * @return StatusCls - Status class as response
    *********************************************************************************************************/    
    global static DCPCreateProposalAPI.StatusCls createProposalData(){
        
        RestRequest req = RestContext.request;
        Integer thresholdLimit =  Integer.valueof(static_values__c.getValues('thresholdLimit').value__c);
        system.debug(loggingLevel.INFO, 'Higher Limit:'+thresholdLimit);
        integer halfPointLimit = Integer.valueof(static_values__c.getValues('halfPointLimit').value__c);
        Map<String,String> staticVal = DCPCreateProposalAPI.initialize(req);
        String jsonData;
        DCPCreateProposalAPI.StatusCls sts = new DCPCreateProposalAPI.StatusCls();
              
        
        RestContext.response.addHeader('Content-Type', 'application/json');

            if(String.isNotBlank(staticVal.get('site')) && String.isBlank(staticVal.get('cartId'))){
                jsonData = DCPCreateProposalAPIHandler.checkForData(staticVal,halfPointLimit);
            }else if(String.isNotBlank(staticVal.get('cartId')) && String.isNotBlank(staticVal.get('lineItemNumber'))){
                jsonData = DCPCreateProposalAPIHandler.createLines(staticVal);
            }else{
                jsonData = null;
            }
            
            try{
                if(String.isNotBlank(jsonData)) {
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

    /********************************************************************************************************
    *  @description  createProposal - Method to Create the proposal record in UE Proposal Object
    * @param priceListName - Name of the price List
    * @param thresholdLimit - Integer to hold the thresholdLimit
    * @param site - String for site
    *********************************************************************************************************/
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
               proposalList = DCPCreateProposalAPI.createProposals(proposalItems,thresholdLimit);
               
                system.debug(loggingLevel.INFO, 'Proposal Records:'+proposalList);
            
            if(proposalList!=null && proposalList.size()>0){
                Database.SaveResult[] saveResultList = Database.insert(proposalList, false);
                prodConfigList=DCPCreateProposalAPI.createProdConfig(proposalItems,saveResultList,thresholdLimit);
               
            }
                
                
                if(prodConfigList!=null && prodConfigList.size()>0){
                    Database.SaveResult[] cartSaveResultList = Database.insert(prodConfigList, false);
                    //prodConfigIds.addAll(cartSaveResultList.getId());
                    DCPCreateProposalAPI.ProductConfigWrapper lineMap = DCPCreateProposalAPIHandler.createLineItems(thresholdLimit,cartSaveResultList);
                    lineItemList = lineMap.lineItemList;
                    prodConfigIdSet=lineMap.prodConfigIds;
                }   
                if(!lineItemList.isEmpty()){
                    Database.SaveResult[] liSaveResultList = Database.insert(lineItemList, false);
                    system.debug(loggingLevel.INFO, 'Higher Limit:'+liSaveResultList);
                }
                
            
                DCPCreateProposalAPIHandler.insertCart(prodConfigIdSet,thresholdLimit,proposalItems);
                DCPCreateProposalAPIHandler.deleteCart(thresholdLimit,site,supportEmail);
        
    }
/********************************************************************************************************
    *  @description  ProductConfigWrapper - Wrapper Class
    *********************************************************************************************************/
    public  class ProductConfigWrapper{
        public  List<Apttus_Config2__LineItem__c> lineItemList;
        public  Set<Id> prodConfigIds;
        /********************************************************************************************************
    *  @description  ProductConfigWrapper - Construcor class
    *********************************************************************************************************/
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
 
}