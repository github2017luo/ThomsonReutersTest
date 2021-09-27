/**
* @file name          : DCPLeadWrapper
* @description        : This is wrapper class for DCPLeadService class
* @author             : Priyanka Mondal
* @group              : TR
* @last modified by   : Priyanka Mondal
* @last modified on   : 01/09/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 01/09/2021   Priyanka Mondal    DCP-4205     Wrapper class created to solve the PMD issue
* =============================================================================
**/
// DCP-4205 PMD issue solution created
   public with sharing class DCPLeadWrapper{
       // DCP-4205 - Created fetchTrialInfo method as part of DCP-4205 by Priyanka
        /** 
        *  @description  fetchTrialInfo - 
        *  @param dcpOrder 
        @param trialData
        @return ODTDG_TrialRecord  
        **/ 
        public static ODTDG_TrialRecord fetchTrialInfo(DCPLeadRequestHandler.DCPOrders dcpOrder, ODTDG_TrialRecord trialData){   
            if(dcpOrder.referencesDetails.leadId == null|| dcpOrder.referencesDetails.leadId == ''){
          
                trialData = ODTDG_LeadConvert.getTrialsDetails(dcporder.orderDetails.customerDetails.organizationDetails.onePassGUID,
                                                            dcpOrder.orderDetails.customerDetails.organizationDetails.accountANumber,
                                                            dcpOrder.orderDetails.productFamily);
       
                return trialData;  
                  
            } else{
                return trialData; 
            } 
        }

        /**
*
*  @description  mapLeadOwnerId - map the lead owner ID  
*  @param dcpOrder : Main paramters to store owner ID 
*  @param l
*  @return lead
**/
    public static lead mapLeadOwnerId(DCPLeadRequestHandler.DCPOrders dcpOrder, lead l){
        LIST<User> aemConnectUsers = new List<User>();
        String userEmail = '';
        
        if(dcpOrder.OrderDetails.leadsourceCountryCode != null ){
            if(dcpOrder.OrderDetails.leadsourceCountryCode == 'US'){
                userEmail = DCPLeadServiceHelper.getValuesFromStaticValuesCs('TransactLeadOwnerGroupUS');
            }else if(dcpOrder.OrderDetails.leadsourceCountryCode == 'CA'){
                userEmail = DCPLeadServiceHelper.getValuesFromStaticValuesCs('TransactLeadOwnerGroupCA');
            }
        }    
        if(userEmail != '' && Schema.sObjectType.User.isQueryable()){
            try{
                aemConnectUsers = [select id, userName from User where userName =: userEmail];
            }catch(Exception e){
                system.debug(LoggingLevel.INFO,'Exception came...........'+e);
                
            }
        }
        if( !aemConnectUsers.isEmpty()){
            l.ownerId = aemConnectUsers[0].id; 
        }    

        return l;
    }

     /**
*
*  @description  mapTrialLeadId - map the lead owner ID  
*  @param refInfo : Main paramters to store owner ID 
*  @param trialData
*  @return DCPLeadRequestHandler.References
**/
public static  DCPLeadRequestHandler.References mapTrialLeadId( DCPLeadRequestHandler.References refInfo,
                                    ODTDG_TrialRecord trialData){
    if(trialData != null && trialData.odtdgTrialDetails.trialInfo!= null &&(trialData.OdtdgTrialDetails.trialInfo.leadId!=null
        && trialData.OdtdgTrialDetails.trialInfo.leadId!='')){
                refInfo.leadId = trialdata.odtdgTrialDetails.trialInfo.leadId; 
    }
    return refInfo;
}

/**
*
*  @description  mapTrialDataInResp- map the lead owner ID  
*  @param resp : Main paramters to store owner ID 
*  @param trialData
*  @return DCPLeadRequestHandler.DCPResponse
**/
public static  DCPLeadRequestHandler.DCPResponse mapTrialDataInResp(DCPLeadRequestHandler.DCPResponse resp,
                                    ODTDG_TrialRecord trialData){
    if(trialData != null && trialData.odtdgTrialDetails.trialInfo!= null && 
        (trialData.odtdgTrialDetails.trialInfo.trialSfId != '' ||
        trialData.odtdgTrialDetails.trialInfo.trialSfId != null)){
                resp.trialID = trialData.OdtdgTrialDetails.trialInfo.trialSfId;
                 resp.trialStatus = trialData.OdtdgTrialDetails.trialInfo.trialStatus;
    }
    return resp;
}  
   }