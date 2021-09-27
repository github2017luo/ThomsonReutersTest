/********************************************************************************************************
*  @description  DCPCartMultiProductRequestUtility - Utility Class for Cart Manipulation API
*********************************************************************************************************/

public with sharing class DCPCartMultiProductRequestUtility {
    /********************************************************************************************************
*  @description  insertCart - Method to create Lines
*  @param lineIds - List of line item Ids from UEProposal Obj
*  @param thresholdLimit - thresholdLimit is the integer limit
*  @param supportEmail - support email
*********************************************************************************************************/ 
    
    public static void insertCart(Set<Id> lineIds,Integer thresholdLimit,String supportEmail){
        List<UE_Proposal__c> oQList = new List<UE_Proposal__c>();
        if(!lineIds.isEmpty()){
            for (Apttus_Config2__lineItem__c li : [Select Id,TRStore_Site__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.name, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__PriceListId__c from Apttus_Config2__lineItem__c where Id IN:lineIds ]) {
                if(thresholdLimit>=1){ 
                    OQlist.add(new UE_Proposal__c(LineItemId__c = li.id,CartId__c = null,QuoteId__c=null,appId__c = null,islineactive__c = true,type_of_line__c='US Legal'));
                }
            }
            system.debug(loggingLevel.INFO, 'Orphan Records:'+OQlist);
        }
        if(OQlist!=null && OQlist.size()>0){
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','webServiceName'=>'DCPCartMultiProductRequestUtility','requestType'=>'UEProposal Creation','reqMsg'=>'Exception Class Name: DCPCartMultiProductRequestUtility','module'=>'UEStore','recId'=>OQlist[0].id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                
                try{
                    Database.insert(OQlist,true);
                    
                }catch(Exception e){
                    errorhandlerMap.put('expMsg',e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString());
                    DCPCartMultiProductRequestUtility.logException(errorHandlerMap);
                }
        }
    }
    /********************************************************************************************************
*  @description  logException - Method to log exception
*  @param errorhandlerMap
* *********************************************************************/
    @TestVisible private static void logException(Map<String,String> errorhandlerMap){
        TRStore_ErrorHandler.logException(errorHandlerMap);
    }
    /********************************************************************************************************
*  @description  deleteCart - Method to delete Lines
*  @param supportEmail - Email to be dropped for any issues
*  @param thresholdLimit - thresholdLimit is the integer limit
*********************************************************************************************************/ 
    
    public static void deleteCart(String supportEmail,Integer thresholdLimit){
        //Delete the inactive records
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','webServiceName'=>'DCPCartMultiProductRequestUtility','requestType'=>'UEProposalRecord Line deletion','reqMsg'=>'Exception Class Name: DCPCartMultiProductRequestUtility','module'=>'UEStore','recId'=>'','supportEmail'=>supportEmail,'toSupport'=>'true'};
            if(thresholdLimit>=1){
                List<UE_Proposal__c> uEList = [Select id from UE_Proposal__c where InActive__c = true and isLineActive__c =false WITH SECURITY_ENFORCED Limit 200];
                system.debug(loggingLevel.INFO, 'Orphan Records:'+uElist);
                if(uEList!=null && uEList.size()>0){
                    try{
                        Database.delete(uEList,true);
                    }catch(Exception e){
                        errorhandlerMap.put('expMsg',e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString());
                        DCPCartMultiProductRequestUtility.logException(errorHandlerMap);
                    }
                }
            }
    }
    /********************************************************************************************************
*  @description  getLIfromUE - Method to get Lines from UE Proposal Record
*  @param oQList - List of records
*  @param cartId - cartId
*  @param pd - product list item
*  @return string - Query String
*********************************************************************************************************/ 
    
    public static string getLIfromUE(List<UE_Proposal__c> oQList,String cartId,DCP_CartPriceRequest.ProductDetail pd){
        String query;
        if(OQList!=null && OQList.size()>0){ 
            query = 'select id,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Customer_Group__c, Name,FELineItemId__c,Apttus_Config2__BaseProductId__c,Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__ItemSequence__c, Apttus_Config2__Quantity__c,Mark_Removed__c, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__BasePrice__c, Apttus_Config2__NetUnitPrice__c, Apttus_Config2__ChargeType__c, Apttus_Config2__ConfigurationId__r.Apttus_config2__Status__c, Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c where Id =\''+String.escapeSingleQuotes(oQList[0].lineitemId__c)+'\'';
            OQlist[0].isLineActive__c=false;
            OQList[0].InActive__c = true;
            Database.update(oQList[0],true);
        }else{
            Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
            lineSO.Apttus_Config2__ConfigurationId__c = cartId;
            lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
            lineSO.Mark_Removed__c = true;
            lineSO.Apttus_Config2__LineNumber__c = Decimal.ValueOf(pd.lineNumber);
            lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
            lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
            lineSO.Apttus_Config2__IsPrimaryLine__c = true;
            
            Database.insert(lineSO,true);
            //Database.insert lineSO;
            String lineId = lineSO.Id;
            query = 'select id,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Customer_Group__c, Name,FELineItemId__c,Apttus_Config2__BaseProductId__c,Apttus_Config2__ItemSequence__c, Apttus_Config2__Quantity__c,Mark_Removed__c, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__BasePrice__c, Apttus_Config2__NetUnitPrice__c, Apttus_Config2__ChargeType__c, Apttus_Config2__ConfigurationId__r.Apttus_config2__Status__c, Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c where Id =\''+String.escapeSingleQuotes(lineId)+'\'';
            
        }
        return query;
    }
    
    /********************************************************************************************************
*  @description  getPlanSegment - Method to get plan segment
*  @param segment - segment
*  @return string - approval segment
*********************************************************************************************************/ 
    
    static String getApprovalSegment(String segment){
        
        Switch on segment {
            when 'law firm'{
                return 'Small Law';
            }
            when 'government'{
                return 'Government';
            }
            when 'corporation'{
                return 'Corporate SMB';
            }
            when else{
                return 'Small Law';
            }
        }
    } 
    
    /********************************************************************************************************
*  @description  getPlanSegment - Method to get plan segment
*  @param appSegment - approval segment
*  @return string - plan segment
*********************************************************************************************************/ 

    
    static String getPlanSegment(String appSegment){
        
        Switch on appSegment{
            when 'Small Law'{
                return 'Small Law';
            }
            when 'Government'{
                return 'Government';
            }
            when 'Corporate SMB'{
                return 'Corporate';
            }
            when else{
                return 'Small Law';
            }
        }
    }  
    
    /********************************************************************************************************
*  @description  getPlanName - Method to get plan name
*  @param prodId - product id
*  @return string - plan Name
*********************************************************************************************************/ 
     
    
    
    static String getPlanName(String prodId){
        if(String.isBlank(prodId)){
            return 'Westlaw';
        }
        
        String prodFamily = [Select Family from Product2 where Id =: prodId].Family;
        
        if(prodFamily.contains('WESTLAW')){
            return 'Westlaw';
        }else if(prodFamily.contains('PRACTICAL')){
            return 'Practical Law';
        }
        else{
            return 'Westlaw';
        }
    }

 /********************************************************************************************************
*  @description  validateSegment- Method to validate approval, plan and segment info
*  @param appSegment - approval segment
*  @param prodId - product Id
*  @param segment - customer segment
*********************************************************************************************************/ 

    
    public static void validateSegment (String appSegment, String prodId, String segment){
        getPlanName(prodId);
        getPlanSegment(appSegment);
        getApprovalSegment(segment);
    }
    /********************************************************************************************************
*  @description  updateQuote- Method to get quote to update
*  @param cartId - cartId id
*  @param pd - product list item
*********************************************************************************************************/ 
    
    public static void updateQuote(String cartId,DCP_CartPriceRequest.ProductDetail pd){
        string query = 'Select Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Customer_Group__c from Apttus_Config2__ProductConfiguration__c where Id =\''+String.escapeSingleQuotes(cartId)+'\'';
        Apttus_Config2__ProductConfiguration__c prodConfig = Database.query(query);
        if( (prodConfig.Apttus_QPConfig__Proposald__r.Customer_Group__c!=null && prodConfig.Apttus_QPConfig__Proposald__r.Customer_Group__c<> pd.lineItemArray.segment) || String.isBlank(prodConfig.Apttus_QPConfig__Proposald__r.Customer_Group__c)){
            Apttus_Proposal__Proposal__c proposal =new Apttus_Proposal__Proposal__c();
            proposal.Id = prodConfig.Apttus_QPConfig__Proposald__c;
            proposal.Customer_Group__c = proposal.APTS_Customer_Pricing_Segment__c  = pd.lineItemArray.segment; 
            proposal.APTS_Approval_Segment__c =  getApprovalSegment(pd.lineItemArray.segment);
            proposal.Apttus_Proposal__Proposal_Name__c = getPlanSegment(proposal.APTS_Approval_Segment__c) + ' ' + getPlanName(pd.productId); 
            
            Database.update(proposal);
        }
    }
}