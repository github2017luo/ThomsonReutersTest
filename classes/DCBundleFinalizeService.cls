/**Class name: DCBundleFinalizeService
 *
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-10-25   Dev Team                Created   
 * 2018-06-08   Harika Sai P          DLT-9765 -  Added Sold to Account SSD reference
 * 2018-06-19   Srikanth Kota         DLT-9753 - APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
 * 2019-01-08   Benjamin Her          DLT-14348 - Code Scan Fixes
 * 2019-06-25   Navleen Kaur          DLT-16914 - Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveAddOns, DCBundleFinalizeService
 * =============================================================================
 */
@RestResource(urlMapping='/digitalconfigurator/finalizeCart/*') 
global with sharing class DCBundleFinalizeService {
    private DCBundleFinalizeService(){
        
    }
    @HttpPost
    global static FinalizeBundleResponse finalizeBundleCart(){
        RestRequest req = RestContext.request;
        System.debug('req -------'+ req.requestBody.toString());
        List<String> quoteIdList = new List<String>();
        FinalizeBundleRequest resp = new FinalizeBundleRequest();        
        resp = (FinalizeBundleRequest)System.JSON.deserialize(req.requestBody.toString(), FinalizeBundleRequest.class);
        quoteIdList = resp.quoteIds;
        System.debug('resp -----------'+ resp.quoteIds);
        List<Apttus_Config2__ProductConfiguration__c> configList = new List<Apttus_Config2__ProductConfiguration__c>();
        FinalizeBundleResponse resWrap = new FinalizeBundleResponse();
        try{ 
            if(quoteIdList == null || ( quoteIdList != null && quoteIdList.isEmpty() )){
                resWrap.responseCode = 400;
                resWrap.responseMessage = 'Invalid parameter';
                return resWrap;
            }else{                
                List<Id> configIds = new List<Id>();
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){ 
                configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, 
                              Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, 
                              Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, APTS_SSD_Sold_To__c,Apttus_Config2__AccountId__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c
                              WHERE Apttus_QPConfig__Proposald__c IN: quoteIdList AND Apttus_Config2__Status__c = 'New'];
        }
        for(Apttus_Config2__ProductConfiguration__c conf : configList){
            configIds.add(conf.Id);
        }
                
        for(Id obj : configIds){
            DCDynamicBundle.finalizeCart(obj);
        }
        resWrap.responseCode = 200;
        resWrap.responseMessage = 'Cart Finalized Successfully';
            }
        }catch(Exception ex){
            doLogException(ex);
            resWrap.responseCode = 4000;
            resWrap.responseMessage = ex.getMessage();
        }
        return resWrap;
    }
    public static void doLogException(Exception e){
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  
        ex.Exception_Message__c = e.getMessage();
        ex.Exception_Type__c = e.getTypeName();        
        ex.Additional_Information__c = String.valueof(e.getLineNumber());   
        ex.User_Message__c = String.valueof(e.getCause());
        ex.Class_Reference__c = 'DCBundleFinalizeService > finalizeBundleCart';
     if(Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){    
        insert ex;
     }
    }
    
    global class FinalizeBundleResponse{
        @testVisible
        private Integer responseCode;
        @testVisible
        private String responseMessage;
    }
    
    global class FinalizeBundleRequest{
        @testVisible
        private List<String> quoteIds;
    }
}