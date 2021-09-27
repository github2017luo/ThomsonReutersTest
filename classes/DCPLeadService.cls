/**
* @file name          : DCPLeadService
* @description        : This class is for holding the business logic for Lead
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 05/20/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 05/20/2021   Servendra Kumar    DCP-1678     Created 
* 01/09/2021   Priyanka Mondal    DCP-4205     Orchestrate the Customer Validation Logic
* =============================================================================
**/

public with sharing class DCPLeadService {
    
    public List<DCPLeadRequestHandler.OLCResponse> olcResult;
    public LIST<String> emailIds = new LIST<String>();
    public LIST<String> cartIds = new LIST<String>();
    public MAP<string, id> existingLeads = new MAP<string, id>();
    public Lead lead = new Lead();
    public LIST<Lead> leads = new LIST<Lead>();
    //public LIST<User> aemConnectUsers = new List<User>();
    public string leadOrigin='';
    public String supportEmail='';
    public String leadOrigon ='';
    public  ODTDG_TrialRecord trailRecord;
    public ODTDG_TrialRecord trialData = new ODTDG_TrialRecord();  
    
    
    /**
*  processLead: Method to create & update lead information.
*  @input Customer info/details, @returns DCPResponse
*  @description  this is the main mrthod to create Lead from queueable 
*  @param dcpOrder : it contaisn the request from APIGEE or UI
*  @return : DCPLeadRequestHandler.DCPResponse and contains lead response 
**/  
    public DCPLeadRequestHandler.DCPResponse processLead(DCPLeadRequestHandler.DCPOrders dcpOrder)
    {        
        DCPLeadRequestHandler.DCPResponse  resp = new DCPLeadRequestHandler.DCPResponse();        
        supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;        
        string emailId='';
        string cartId='';        
        emailId = '';
        cartId = ''; 
       
     //DCP-4205- Added by Priyanka Mondal   
        if(dcpOrder.orderDetails.productfamily=='' || dcpOrder.OrderDetails.CustomerDetails.OrganizationDetails.onePassGUID=='')
        {
            resp.responseStatus= DCPNewSaleUtilityCls.failureStatus;
            resp.responseCode= DCPNewSaleUtilityCls.errorCode;
            resp.statusDetail = DCPNewSaleUtilityCls.requiredFieldMissing;
            return resp;
        }else{
          resp = processLeadMainMethod(dcpOrder);
        return resp;
        }
    }
    /**
*  createDCPLead : creates or updates the lead by performing an upsert operation.
*  @returns DCPResponse 
*  @description  mapLeadOriginValue - this will map the lead origin  
*  @return DCPLeadRequestHandler.DCPResponse  : this is return main lead create 
**/
    private DCPLeadRequestHandler.DCPResponse createDCPLead(){
        DCPLeadRequestHandler.DCPResponse  resp = new DCPLeadRequestHandler.DCPResponse();
        List< Database.UpsertResult> ipr = new LIST<Database.UpsertResult>();
        try{
            if(!leads.isEmpty()){
                ipr = database.upsert(leads);
            }
        }catch(exception e){
            system.debug(LoggingLevel.INFO,'Exception came...........'+e);
            resp.leadId ='';
            resp.responseStatus= DCPNewSaleUtilityCls.failureStatus;
            resp.responseCode= DCPNewSaleUtilityCls.errorCode;
            
            if(e != null){
                resp.statusDetail = string.valueOf(e);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of Lead'+string.valueOf(e)+': '+e.getLineNumber(),'webServiceName'=>'createNewLead','requestType'=>'Lead Creation','reqMsg'=>'Exception Class Name: DCPLeadService','module'=>'DCP','recId'=>resp.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                    DCPNewSaleUtilityCls.logException(errorHandlerMap);
            }
        }
        system.debug(LoggingLevel.Info,'Leads upsert Result..........'+ipr);
        system.debug(LoggingLevel.Info,'Lead..........'+leads);
        
        for(Database.UpsertResult up : ipr){
            if(up.isSuccess()){
                resp.leadId =up.getId();
                resp.responseStatus= 'Success';
                resp.responseCode= DCPNewSaleUtilityCls.successCode;
            }
            else{
                resp.leadId =null;
                resp.responseStatus= DCPNewSaleUtilityCls.failureStatus;
                resp.responseCode= DCPNewSaleUtilityCls.errorCode;   
            }
        }
        return resp;
    }
    
    /**
*  mapReferenceDetails : maps the cart details on lead as well as updates existing lead id if present.
*  @input PlatForm DCPLeadRequestHandler 
*  @description  mapReferenceDetails - This will be map the lookup fields - cartId, leadId other fields   
*  @param refInfo : reference variables for olc
*   
**/
    private void mapReferenceDetails(DCPLeadRequestHandler.References refInfo){
        if(refInfo != null){
            if(refInfo.cartId != null)
            {
                lead.Product_Configuration__c = refInfo.cartId ;
            }                    
        }
        
        if(refInfo.leadId !='' && leadOrigin !='TR Store'){
            lead.id = refInfo.leadId ;
        }
        else {
            system.debug(loggingLevel.info,'inside elase if');
            try{
                Lead.id = DCPLeadServiceHelper.mapLeadrecId(emailIds,cartIds);
            }catch(Exception e){
                system.debug(LoggingLevel.INFO,'Exception came...........'+e);
                
            }
            
            /*if(existingLeads.containsKey(lead.Product_Configuration__c) ){
lead.id = existingLeads.get(lead.Product_Configuration__c);
}else if(existingLeads.containsKey(lead.email)){
lead.id = existingLeads.get(lead.email);
}*/
            
        }
    } 

    /**
*  mapLeadFieldsBasedOnCountry : map lead fields based on country code.
*  @input PlatForm DCPLeadRequestHandler   
*  @description  mapLeadFieldsBasedOnCountry - Map the lead fields based on country 
*  @param dcpOrder : Parameter to have main lead json 
*   
**/
    private void mapLeadFieldsBasedOnCountry(DCPLeadRequestHandler.DCPOrders dcpOrder){
        if(dcpOrder.OrderDetails.leadsourceCountryCode != null){
            if(dcpOrder.OrderDetails.leadsourceCountryCode == 'US'){
                lead.Lead_Region__c = (String.isNotBlank(dcpOrder.OrderDetails.leadOriginSite) && dcpOrder.OrderDetails.leadOriginSite.equalsIgnoreCase('TPRO'))?'TR Store Tax Professional':'TR Store US Print';
                lead.Primary_Campaign_Source__c = Static_Values__c.getAll().get('SFDCCampaignIdUS').value__c;  
                lead.Tracking_Code__c = Static_Values__c.getAll().get('Hive9CodeUS').Value__c;   
            }else if(dcpOrder.OrderDetails.leadsourceCountryCode == 'CA' && dcpOrder.OrderDetails.leadOriginSite.equalsIgnoreCase('UECAPR')){
                lead.Lead_Region__c = Static_Values__c.getAll().get('UECAPR').Value__c;
                lead.Primary_Campaign_Source__c = Static_Values__c.getAll().get('SFDCCampaignIdCA').value__c;  
                lead.Tracking_Code__c = Static_Values__c.getAll().get('Hive9CodeCA').Value__c;   
            }    
            
        }
    }
    
    
    /**
*  mapListOfEmailIdsAndCartIds : map emails id's entered in a list as well as the cart id created in 
*  another list for further processing.
*  @input PlatForm DCPLeadRequestHandler   
*  @description  mapListOfEmailIdsAndCartIds - map emaail and carrt field details  
*  @param dcpOrder : main json 
*   
**/
    private void mapListOfEmailIdsAndCartIds(DCPLeadRequestHandler.DCPOrders dcpOrder){
        if(dcpOrder.OrderDetails.customerDetails != null){
            DCPLeadRequestHandler.DCPCustomerDetails leadInfo = dcpOrder.OrderDetails.customerDetails;     
            if(leadInfo != null){  
                emailIds.add(leadInfo.businessEmail);
            }
            
            DCPLeadRequestHandler.References refInfo = dcpOrder.referencesDetails;  
            if(refInfo != null && refInfo.cartId != null){
                
                cartIds.add(refInfo.cartId);
                
            }
            
        }
    }  
    /**
*  map store Langueage : map lead field - Langueage  based on lang code.    *  @input PlatForm DCPLeadRequestHandler   
* For English site    "siteLanguageCode" will be "EN"    * For French Site     "siteLanguageCode" will be "FR"
*  @description  mapLanguageOnLead - Map the lead Language Fields 
*  @param dcpOrder : Parameter to have main lead json 
*  
**/    
    private void mapLanguageOnLead(DCPLeadRequestHandler.DCPOrders dcpOrder){
        lead.Language_Preference__c = (dcpOrder.OrderDetails.siteLanguageCode != null)? DCPLeadServiceHelper.fetchLangParams(dcpOrder.OrderDetails.siteLanguageCode) : 'English' ;
    }
    


    private DCPLeadRequestHandler.DCPResponse processLeadMainMethod(DCPLeadRequestHandler.DCPOrders dcpOrder){
        DCPLeadRequestHandler.DCPResponse resp = new DCPLeadRequestHandler.DCPResponse();


        if(dcpOrder.OrderDetails != null){            
            this.mapListOfEmailIdsAndCartIds(dcpOrder);            
        }       
    
        if(dcpOrder.OrderDetails != null && dcpOrder.OrderDetails.customerDetails != null){
              
            DCPLeadRequestHandler.DCPCustomerDetails leadInfo = dcpOrder.OrderDetails.customerDetails; 
           
              trialData = DCPLeadWrapper.fetchTrialInfo(dcpOrder, trialData); 
           
            // Mapping of customer details  
            lead = DCPLeadServiceHelper.mapCustomerDetails(leadInfo);
            //adding owner id and record type for creating lead.
            lead = DCPLeadWrapper.mapLeadOwnerId(dcpOrder, lead);
            mapLeadFieldsBasedOnCountry(dcpOrder);
            mapLanguageOnLead(dcpOrder);                

            DCPLeadRequestHandler.References refInfo = dcpOrder.referencesDetails; 
          
            refInfo = DCPLeadWrapper.mapTrialLeadId(refInfo, trialData);

            //system.debug('@@@@refInfo'+refInfo.leadId);
            mapReferenceDetails(refInfo);
            leads.add(lead);
            DCPLeadServiceProviewContactsHelper proviewContact = new DCPLeadServiceProviewContactsHelper();
            olcResult = proviewContact.mapOnlineContacts(dcpOrder,leadInfo,refInfo);
            
            
                      
        }        
        system.debug(LoggingLevel.Info,'List of Leads'+leads);        
        resp = createDCPLead();
        resp = DCPLeadWrapper.mapTrialDataInResp(resp, trialData);
        resp.onlineContactsResponse = olcResult; 
        System.debug(LoggingLevel.INFO,'resp '+resp);
        return resp;
    }
}
/*if(dcpOrder.OrderDetails != null){            
            this.mapListOfEmailIdsAndCartIds(dcpOrder);            
        }       
        
        if(dcpOrder.OrderDetails != null && dcpOrder.OrderDetails.customerDetails != null){
                         
                DCPLeadRequestHandler.DCPCustomerDetails leadInfo = dcpOrder.OrderDetails.customerDetails; 
        
                if(dcpOrder.referencesDetails.leadId == null|| dcpOrder.referencesDetails.leadId == ''){
                  trialData = DCPLeadServiceHelper.fetchTrialInfo(dcpOrder); 
                  //system.Debug('@@@@@trial Dat '+trialData);
                }
               
                // Mapping of customer details  
                lead = DCPLeadServiceHelper.mapCustomerDetails(leadInfo);
                //adding owner id and record type for creating lead.
                mapLeadOwnerId(dcpOrder);
                mapLeadFieldsBasedOnCountry(dcpOrder);
                mapLanguageOnLead(dcpOrder);                
  
                DCPLeadRequestHandler.References refInfo = dcpOrder.referencesDetails; 
              
                if(trialData != null && trialData.odtdgTrialDetails.trialInfo!= null &&(trialData.OdtdgTrialDetails.trialInfo.leadId!=null
                   || trialData.OdtdgTrialDetails.trialInfo.leadId!='')){
                refInfo.leadId = trialdata.odtdgTrialDetails.trialInfo.leadId; 
                }

                //system.debug('@@@@refInfo'+refInfo.leadId);
                mapReferenceDetails(refInfo);
                leads.add(lead);
                DCPLeadServiceProviewContactsHelper proviewContact = new DCPLeadServiceProviewContactsHelper();
                olcResult = proviewContact.mapOnlineContacts(dcpOrder,leadInfo,refInfo);
                
                
                          
        }        
        system.debug(LoggingLevel.Info,'List of Leads'+leads);        
        resp = createDCPLead();
        //system.debug('response   '+resp);
      //  system.debug('trialData'+trialData);
       /* if(trialData.OdtdgTrialDetails.trialInfo.trialStatus != null 
               && trialData.OdtdgTrialDetails.trialInfo.trialSfId != null){
                   resp.trialID = trialData.OdtdgTrialDetails.trialInfo.trialSfId;
                   resp.trialStatus = trialData.OdtdgTrialDetails.trialInfo.trialStatus;
               } 
        resp.onlineContactsResponse = olcResult; 
        System.debug(LoggingLevel.INFO,'resp '+resp);*/