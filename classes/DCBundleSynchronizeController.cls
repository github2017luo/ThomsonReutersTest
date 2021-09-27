/**Class name: DCBundleSynchronizeController 
 *
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-10-25   Dev Team                Created   
 * 2018-06-08   Harika Sai P            DLT-9765 -  Added Sold to Account SSD reference
 * 2019-01-08   Benjamin Her            DLT-14348 - Code Scan Fixes
 * 2019-06-26   Bishanka Dassarma       DLT-16915 - [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveOnlineContacts, DCBundleSynchronizeController
 * 2020-06-29   Brenda Shields          DLT-20241 - Exclude dynamic bundlings for Federal Gov customers
 * =============================================================================
 */
 
@RestResource(urlMapping='/digitalconfigurator/bundleSynchronize/*') 
global with sharing class DCBundleSynchronizeController {

    private DCBundleSynchronizeController(){
    
    }

    @HttpPost
    global static DynamicBundleResponse bundleAndSynchronize(){
        RestRequest req = RestContext.request;
        //RestResponse res = RestContext.response;
        System.debug('req -------'+ req.requestBody.toString());       
        List<String> quoteIdList = new List<String>();
        DynamicBundleRequest resp = new DynamicBundleRequest();       
        resp = (DynamicBundleRequest)System.JSON.deserialize(req.requestBody.toString(), DynamicBundleRequest.class);
        quoteIdList = resp.quoteIds;
        System.debug('resp -----------'+ resp.quoteIds);
        List<Apttus_Config2__ProductConfiguration__c> configList = new List<Apttus_Config2__ProductConfiguration__c>();
        DynamicBundleResponse resWrap = new DynamicBundleResponse();
        if(quoteIdList == null || ( quoteIdList != null && quoteIdList.isEmpty() )){
            resWrap.responseCode = 400;
            resWrap.responseMessage = 'Invalid parameter';
            return resWrap;
        }else{
            String bundleGroup = System.Label.BundleGroup;
            //Boolean isStraight= false;
            //List<Id> straightConfigIds = new List<Id>();
            
            if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
                throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__ProductConfiguration__c');
            }  
            // Exclude Straight Renewals
            // DLT-20241 - exclude Government and Federal Proposals      
            configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,APTS_SSD_Sold_To__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, 
                          Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 
                          Apttus_Config2__AccountId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c 
                          WHERE Apttus_QPConfig__Proposald__c IN: quoteIdList AND Apttus_Config2__Status__c = 'Finalized' 
                          AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Straight Renewal'
                          AND (Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c != 'Government' 
                          OR Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.BU_Segment_Level_2__c != 'Federal')]; 
            system.debug('***configList ::'+configList );
            try{  
                if( !configList.isEmpty() ){
                
                    DCDynamicBundle.performBundling(bundleGroup, configList); 
                }  
                resWrap.responseCode = 200;
                resWrap.responseMessage = 'Dynamic Bundle creation successfully';
            }catch(Exception e){               
                DCBundleFinalizeService.doLogException(e);
            }
        }
        return resWrap;
    }
    
    global class DynamicBundleResponse{
        global Integer responseCode;
        global String responseMessage;
    }
    
    global class DynamicBundleRequest{
        global String BundleName;
        global List<String> quoteIds;
    }
}