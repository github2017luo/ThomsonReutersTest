/* -----------------------------------------------------------------------------------------------------
CLASS NAME: LCRMPostbackServiceAPI

PURPOSE : LCRMPostbackServiceAPI Service is used to update opportunity and upsert the opportunityLineItem.

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/
@RestResource(urlmapping='/LCRMPostbackServiceAPI/*')
global without sharing class LCRMPostbackServiceAPI {
    
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: updateLCRMOpportunity

PURPOSE : updateLCRMOpportunity method is used to update opportunity and upsert the opportunityLineItem.

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/
    @httppost
    global static ResponseWrapper updateLCRMOpportunity(){
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        String JSONSTR = request.requestBody.toString();
        system.debug('+++ JSON Opportunity Post back is  '+ JSONSTR);
        ResponseWrapper responseWrapper = new ResponseWrapper();  
        
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        List<RequestOpportunityLineItem> RequestOpportunityLineItemList = new List<RequestOpportunityLineItem>();

        List<MultiYearOrBridgeInfo> MultiYearOrBridgeInfoList = new List<MultiYearOrBridgeInfo>(); //Added w.r.t. CRM-13416 by Shovon
        
        OpptyPostbackRequestWrapper result = new OpptyPostbackRequestWrapper();
        String messageId;
        String applicationId;
        String contractType;
        String quoteId;
        String salesStage;
        String opptyStatus;
        String renewalDate;
        String expectedStartDate;
        String negotiationExtnDate;
        String extensionAccessDate;
        String newAnnualContractValue;
        Id opportunityId;
        
        try{
            result = (OpptyPostbackRequestWrapper)System.JSON.deserialize(JSONSTR,OpptyPostbackRequestWrapper.class);
       
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.opportunityHeader.opptyId) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.opportunityHeader.opptyId))
            {opportunityId = (ID)result.UpdateOpportunityRequest.opportunity.opportunityHeader.opptyId; } 
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.esiHeader.messageId) && String.isNotEmpty(result.UpdateOpportunityRequest.esiHeader.messageId))
            {messageId = result.UpdateOpportunityRequest.esiHeader.messageId;}
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.esiHeader.applicationId) && String.isNotEmpty(result.UpdateOpportunityRequest.esiHeader.applicationId))
            {applicationId = result.UpdateOpportunityRequest.esiHeader.applicationId;}
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.contractType) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.contractType)){
                contractType = result.UpdateOpportunityRequest.opportunity.OpportunityHeader.contractType;
            }
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.quoteId) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.quoteId)){
                quoteId = result.UpdateOpportunityRequest.opportunity.OpportunityHeader.quoteId;
            }
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.salesStage) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.salesStage))
            {salesStage =  result.UpdateOpportunityRequest.opportunity.OpportunityHeader.salesStage;}
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.opptyStatus) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.OpportunityHeader.opptyStatus))
            {opptyStatus = result.UpdateOpportunityRequest.opportunity.OpportunityHeader.opptyStatus;}
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.expectedEndDate) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.expectedEndDate))
            {renewalDate = result.UpdateOpportunityRequest.opportunity.opportunityRenewal.expectedEndDate;}
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.expectedStartDate) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.expectedStartDate))
            {expectedStartDate = result.UpdateOpportunityRequest.opportunity.opportunityRenewal.expectedStartDate;
             System.debug('expectedStartDate**'+expectedStartDate);}
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.extensionAccessDate) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.extensionAccessDate))
            {extensionAccessDate = result.UpdateOpportunityRequest.opportunity.opportunityRenewal.extensionAccessDate;}            
            
            if(String.isNotBlank(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.negotiationExtnDate) && String.isNotEmpty(result.UpdateOpportunityRequest.opportunity.opportunityRenewal.negotiationExtnDate))
            {negotiationExtnDate = result.UpdateOpportunityRequest.opportunity.opportunityRenewal.negotiationExtnDate;}
            
            if(result.UpdateOpportunityRequest.opportunity.opportunityLineItem != null)
            {RequestOpportunityLineItemList = result.UpdateOpportunityRequest.opportunity.opportunityLineItem;}
            
            //Added w.r.t. CRM-13416 by Shovon
            if(result.UpdateOpportunityRequest.opportunity.OpportunityRenewal.multiYearOrBridgeInfo != null)
            {MultiYearOrBridgeInfoList = result.UpdateOpportunityRequest.opportunity.OpportunityRenewal.multiYearOrBridgeInfo;}
            
            System.debug('result***'+result); 
            System.debug('messageId**'+messageId);
            System.debug('opportunityId***'+opportunityId+'applicationId***'+applicationId+'salesStage***'+salesStage+'opptyStatus***'+opptyStatus+'renewalDate***'+renewalDate+'negotiationExtnDate***'+negotiationExtnDate+'');
            System.debug('RequestOpportunityLineItemList Size***' +RequestOpportunityLineItemList.size());
            System.debug('MultiYearOrBridgeInfoList Size***' +MultiYearOrBridgeInfoList.size());
        }
        Catch(Exception e){
            System.debug('e.getMessage()'+e.getMessage());
            responseWrapper = checkResponseWrapper(false,e.getMessage());
        }
        
        
        if(applicationId == 'CW' || applicationId == 'TW'){
            System.debug('INSIDE CW');
            
            /*opportunity status along with Opportunity ID*/
            if(messageId == 'LCRM_Status' && applicationId == 'CW'){
                System.debug('Inside LCRM_Status**');
                if((String.isNotBlank(opportunityId) && String.isNotEmpty(opportunityId)) && (String.isNotBlank(opptyStatus) && String.isNotEmpty(opptyStatus))){
                    try{
                        opportunity oppStatus = new opportunity();
                        oppStatus.Id = opportunityId;
                        oppStatus.LCRM_Status__c = opptyStatus;
                        System.debug('oppStatus.Id'+oppStatus.Id+'oppStatus.LCRM_Status__c'+oppStatus.LCRM_Status__c);
                        //oppStatus.LCRM_Contract_Wizard_ID__c = quoteId;
                        update oppStatus;
                        System.debug('SUCCESS UPDATE');
                        responseWrapper = checkResponseWrapper(true,'Success');  
                        
                    }
                    catch(Exception e){
                        System.debug('Exception** '+e.getMessage());
                        responseWrapper = checkResponseWrapper(false,e.getMessage());
                        
                    }
                }
            }
            
            else if(messageId == 'LCRM_Stage' && applicationId == 'CW'){
                System.debug('Inside LCRM_Stage**');
                if((String.isNotBlank(opportunityId) && String.isNotEmpty(opportunityId)) && (String.isNotBlank(salesStage) && String.isNotEmpty(salesStage))){                    
                    try{
                        opportunity oppStage = new opportunity();
                        oppStage.Id = opportunityId;
                        oppStage.StageName = salesStage;
                        System.debug('oppStatus.Id'+oppStage.Id+'oppStatus.StageName'+oppStage.StageName);
                        
                        String stageValue = KeyValueListStore__c.getInstance('LCRMOpptyStageValues').TextValue__c;                        
                        Set<String> stageValueSet = new Set<String>();
                        for(String vals : stageValue.split(',')){
                            stageValueSet.add(vals);                            
                        }                        
                        if(stageValueSet.contains(oppStage.StageName)){
                            oppStage.Win_Loss__c = 'Not Defined';
                            oppStage.Reason__c = 'Not Defined';
                        }
                        //oppStage.LCRM_Contract_Wizard_ID__c = quoteId;
                        update oppStage;
                        System.debug('SUCCESS UPDATE');
                        responseWrapper = checkResponseWrapper(true,'Success');  
                        
                    }
                    catch(Exception e){
                        System.debug('Exception** '+e.getMessage());                        
                        responseWrapper = checkResponseWrapper(false,e.getMessage());
                        
                    }
                }
            }
            /* Expected Start Date/Expected End Date UPDATE
            else if(messageId == 'LCRM_renewalDate' && applicationId == 'CW'){
                System.debug('Inside LCRM_renewalDate**');
                if((String.isNotBlank(opportunityId) && String.isNotEmpty(opportunityId)) && (String.isNotBlank(renewalDate) && String.isNotEmpty(renewalDate))){
                    try{
                        opportunity oppRenewalDate = new opportunity();
                        oppRenewalDate.Id = opportunityId;
                        oppRenewalDate.Expected_End_Date__c = Date.valueof(renewalDate);
                        
                        if(String.isNotBlank(expectedStartDate) && String.isNotEmpty(expectedStartDate))
                        {   System.debug('expectedStartDate**'+expectedStartDate);
                         oppRenewalDate.Expected_Start_Date__c = Date.valueof(expectedStartDate);                        
                        }
                        //oppRenewalDate.LCRM_Contract_Wizard_ID__c = quoteId;
                        update oppRenewalDate;
                        responseWrapper = checkResponseWrapper(true,'Success');
                    }
                    Catch(Exception e){
                        System.debug('Exception** '+e.getMessage());
                        responseWrapper = checkResponseWrapper(false,e.getMessage());
                    }
                    
                }
            }*/
            
            /* Negotiation Date alongwith opportunity Id*/
            else if(messageId == 'LCRM_negotiationExtnDate' && applicationId == 'CW'){
                System.debug('Inside LCRM_negotiationExtnDate**');
                if((String.isNotBlank(opportunityId) && String.isNotEmpty(opportunityId)) && (String.isNotBlank(negotiationExtnDate) && String.isNotEmpty(negotiationExtnDate))){
                    try{
                        opportunity oppExtensionDate = new opportunity();
                        oppExtensionDate.Id = opportunityId;
                        oppExtensionDate.LCRM_Extended_Negotiation_Date__c = Date.valueof(negotiationExtnDate);
                        //oppExtensionDate.LCRM_Contract_Wizard_ID__c = quoteId;
                        update oppExtensionDate;
                        responseWrapper = checkResponseWrapper(true,'Success');
                    }
                    Catch(Exception e){
                        System.debug('Exception** '+e.getMessage());
                        responseWrapper = checkResponseWrapper(false,e.getMessage());
                    }
                    
                }
                
            }
            /*populate LCRM_Extended_Access_Date__c date field with messageId 'LCRM_extensionAccessDate'*/            
            else if(messageId == 'LCRM_extensionAccessDate' && applicationId == 'CW'){
                System.debug('Inside LCRM_extensionAccessDate**');
                if((String.isNotBlank(opportunityId) && String.isNotEmpty(opportunityId)) && (String.isNotBlank(extensionAccessDate) && String.isNotEmpty(extensionAccessDate))){
                    try{
                        opportunity oppExtensionDate = new opportunity();
                        oppExtensionDate.Id = opportunityId;
                        oppExtensionDate.LCRM_Extended_Access_Date__c = Date.valueof(extensionAccessDate);
                        //oppExtensionDate.LCRM_Contract_Wizard_ID__c = quoteId;
                        update oppExtensionDate;
                        responseWrapper = checkResponseWrapper(true,'Success');
                    }
                    Catch(Exception e){
                        System.debug('Exception** '+e.getMessage());
                        responseWrapper = checkResponseWrapper(false,e.getMessage());
                    }
                    
                }
                
            }
            
            /*Update Opportunity Line Item*/
            else if(messageId == 'LCRM_productUpdate' && applicationId == 'CW'){           
                System.debug('INSIDE CW AND productUpdate');     
                Opportunity productOpportunity = new Opportunity();
                try{
                    productOpportunity.Id = opportunityId;
                    productOpportunity.LCRM_Transaction_Type__c = contractType;
                    productOpportunity.LCRM_Contract_Wizard_ID__c = quoteId;
                                        
                    if(String.isNotBlank(renewalDate) && String.isNotEmpty(renewalDate)){
                        productOpportunity.Expected_End_Date__c = Date.valueof(renewalDate);
                    }                
                    
                    if(String.isNotBlank(expectedStartDate) && String.isNotEmpty(expectedStartDate))
                    {   System.debug('expectedStartDate**'+expectedStartDate);
                     productOpportunity.Expected_Start_Date__c = Date.valueof(expectedStartDate);                        
                    }
                    //START Added w.r.t. CRM-13416 by Shovon
                    if(contractType == 'Multi-Year Deal' || contractType == 'Bridge'){
                        if(MultiYearOrBridgeInfoList.size()>0){
                            for(MultiYearOrBridgeInfo mybi: MultiYearOrBridgeInfoList){
                                if(String.isNotBlank(mybi.period) && String.isNotEmpty(mybi.period)){
                                    if(mybi.period.equals('1')){
                                        if(String.isNotBlank(mybi.price) && String.isNotEmpty(mybi.price)){
                                            productOpportunity.LCRM_Period_1_Price__c = Decimal.valueof(mybi.price);
                                        }else{
                                            productOpportunity.LCRM_Period_1_Price__c = 0.00;
                                        }
                                        if(String.isNotBlank(mybi.startDate) && String.isNotEmpty(mybi.startDate)){
                                            productOpportunity.LCRM_Period_1_Start_Date__c = Date.valueof(mybi.startDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_1_Start_Date__c = null;
                                        }
                                        if(String.isNotBlank(mybi.endDate) && String.isNotEmpty(mybi.endDate)){
                                            productOpportunity.LCRM_Period_1_End_Date__c = Date.valueof(mybi.endDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_1_End_Date__c = null;
                                        }
                                    }
                                    if(mybi.period.equals('2')){
                                        if(String.isNotBlank(mybi.price) && String.isNotEmpty(mybi.price)){
                                            productOpportunity.LCRM_Period_2_Price__c = Decimal.valueof(mybi.price);
                                        }else{
                                            productOpportunity.LCRM_Period_2_Price__c = 0.00;
                                        }
                                        if(String.isNotBlank(mybi.startDate) && String.isNotEmpty(mybi.startDate)){
                                            productOpportunity.LCRM_Period_2_Start_Date__c = Date.valueof(mybi.startDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_2_Start_Date__c = null;
                                        }
                                        if(String.isNotBlank(mybi.endDate) && String.isNotEmpty(mybi.endDate)){
                                            productOpportunity.LCRM_Period_2_End_Date__c = Date.valueof(mybi.endDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_2_End_Date__c = null;
                                        }
                                    }
                                    if(mybi.period.equals('3')){
                                        if(String.isNotBlank(mybi.price) && String.isNotEmpty(mybi.price)){
                                            productOpportunity.LCRM_Period_3_Price__c = Decimal.valueof(mybi.price);
                                        }else{
                                            productOpportunity.LCRM_Period_3_Price__c = 0.00;
                                        }
                                        if(String.isNotBlank(mybi.startDate) && String.isNotEmpty(mybi.startDate)){
                                            productOpportunity.LCRM_Period_3_Start_Date__c = Date.valueof(mybi.startDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_3_Start_Date__c = null;
                                        }
                                        if(String.isNotBlank(mybi.endDate) && String.isNotEmpty(mybi.endDate)){
                                            productOpportunity.LCRM_Period_3_End_Date__c = Date.valueof(mybi.endDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_3_End_Date__c = null;
                                        }
                                    }
                                    if(mybi.period.equals('4')){
                                        if(String.isNotBlank(mybi.price) && String.isNotEmpty(mybi.price)){
                                            productOpportunity.LCRM_Period_4_Price__c = Decimal.valueof(mybi.price);
                                        }else{
                                            productOpportunity.LCRM_Period_4_Price__c = 0.00;
                                        }
                                        if(String.isNotBlank(mybi.startDate) && String.isNotEmpty(mybi.startDate)){
                                            productOpportunity.LCRM_Period_4_Start_Date__c = Date.valueof(mybi.startDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_4_Start_Date__c = null;
                                        }
                                        if(String.isNotBlank(mybi.endDate) && String.isNotEmpty(mybi.endDate)){
                                            productOpportunity.LCRM_Period_4_End_Date__c = Date.valueof(mybi.endDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_4_End_Date__c = null;
                                        }
                                    }
                                    if(mybi.period.equals('5')){
                                        if(String.isNotBlank(mybi.price) && String.isNotEmpty(mybi.price)){
                                            productOpportunity.LCRM_Period_5_Price__c = Decimal.valueof(mybi.price);
                                        }else{
                                            productOpportunity.LCRM_Period_5_Price__c = 0.00;
                                        }
                                        if(String.isNotBlank(mybi.startDate) && String.isNotEmpty(mybi.startDate)){
                                            productOpportunity.LCRM_Period_5_Start_Date__c = Date.valueof(mybi.startDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_5_Start_Date__c = null;
                                        }
                                        if(String.isNotBlank(mybi.endDate) && String.isNotEmpty(mybi.endDate)){
                                            productOpportunity.LCRM_Period_5_End_Date__c = Date.valueof(mybi.endDate);
                                        }
                                        else{
                                            productOpportunity.LCRM_Period_5_End_Date__c = null;
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    //END Added w.r.t. CRM-13416 by Shovon
                    update productOpportunity;
                    responseWrapper = upsertLineItem(RequestOpportunityLineItemList,opportunityId,applicationId);
                }
                Catch(Exception e){
                    System.debug('Exception** '+e.getMessage());
                    responseWrapper = checkResponseWrapper(false,e.getMessage());
                }                
                //responseWrapper = upsertLineItem(RequestOpportunityLineItemList,opportunityId,applicationId);
                System.debug('responseWrapper'+responseWrapper);
                
            }
            else if(messageId == 'LCRM_productUpdate' && applicationId == 'TW'){
                System.debug('INSIDE TW AND productUpdate');
                Opportunity productOpportunity = new Opportunity();
                try{
                    productOpportunity.Id = opportunityId;
                    //productOpportunity.LCRM_Transaction_Type__c = contractType;
                    productOpportunity.LCRM_Trails_Wizard_ID__c = Decimal.valueof(quoteId);                    
                    update productOpportunity;
                }
                Catch(Exception e){
                    System.debug('Exception** '+e.getMessage());
                    responseWrapper = checkResponseWrapper(false,e.getMessage());
                }
                responseWrapper = upsertLineItem(RequestOpportunityLineItemList,opportunityId,applicationId);
            }
            
            
        } 
        return responseWrapper;
    }
    
    /* -----------------------------------------------------------------------------------------------------
Method NAME: upsertLineItem

PURPOSE : upsertLineItem method is used to update opportunitylineitem or insert new product

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/
    public static LCRMPostbackServiceAPI.ResponseWrapper upsertLineItem(List<RequestOpportunityLineItem> RequestOpportunityLineItemList,ID opportunityId,String Application){
        LCRMPostbackServiceAPI.ResponseWrapper responseWrapperLineItem = new LCRMPostbackServiceAPI.ResponseWrapper();
        List<LCRM_Exception_Log__c> updateExceptionList = new List<LCRM_Exception_Log__c>();
        
        if(!RequestOpportunityLineItemList.isEmpty()){           
            
            Set<String> productCodeSet = new Set<String>();/*Set to store the productCode from request*/
            
            for(RequestOpportunityLineItem reqLineItemProductId :RequestOpportunityLineItemList){
                productCodeSet.add(reqLineItemProductId.opptyProductId);
            }
            Opportunity oppIsoCode = [Select id,CurrencyIsoCode FROM opportunity WHERE ID =: opportunityId];
            
            List<PricebookEntry> priceBookEntryList = [SELECT Id, Name, Pricebook2Id, Product2Id, IsActive, ProductCode FROM PricebookEntry WHERE ProductCode IN : productCodeSet AND Pricebook2.Name = 'GLI Price Book - UKI' AND Pricebook2.IsActive = true AND CurrencyIsoCode =: oppIsoCode.CurrencyIsoCode]; 
            
            System.debug('priceBookEntryList'+priceBookEntryList);
            Map<String,Id>lineItemMap = new Map<String,Id>();
            for(PricebookEntry pricebookIns :priceBookEntryList){
                //lineItemMap.put(pricebookIns.Product2Id, pricebookIns.Id);
                lineItemMap.put(pricebookIns.ProductCode, pricebookIns.Id);
                System.debug('lineItemMap'+lineItemMap);
            }
            
            /*For loop to update  or insert the opportunity line item*/
            List<opportunityLineItem> opportunityLineItemList = new List<opportunityLineItem>();
            for(RequestOpportunityLineItem reqLineItem :RequestOpportunityLineItemList){
                //Id reqOpportunitylineItemid = (Id)reqLineItem.opptyLineItemId;
                if(String.isNotBlank(reqLineItem.opptyLineItemId) && String.isNotEmpty(reqLineItem.opptyLineItemId)){
                    opportunityLineItem oppItem = new opportunityLineItem(); 
                    System.debug('INSERT UPDATE PRODUCT');
                    oppItem.OpportunityId = opportunityId;
                    system.debug('reqLineItem.opptyLineItemId**'+reqLineItem.opptyLineItemId);
                    
                    if(String.isNotBlank(reqLineItem.opptyLineItemId) && String.isNotEmpty(reqLineItem.opptyLineItemId)){
                        oppItem.Id = (Id)reqLineItem.opptyLineItemId;
                        System.debug('oppItem.LCRM_Cancel_Reason__c**'+oppItem.Id);
                    }                  
                    
                    if(String.isNotBlank(reqLineItem.newActualContractValue) && String.isNotEmpty(reqLineItem.newActualContractValue)){
                        oppItem.LCRM_New_ACV_SalesPrice__c = Decimal.valueOf(reqLineItem.newActualContractValue);
                        System.debug('oppItem.LCRM_Cancel_Reason__c**'+oppItem.LCRM_New_ACV_SalesPrice__c);
                    }
            //Added as a part of DPS-7202  
                    if(String.isNotBlank(reqLineItem.currentActualContractValue) && String.isNotEmpty(reqLineItem.currentActualContractValue)){
                        oppItem.LCRM_Current_ACV__c = Decimal.valueOf(reqLineItem.currentActualContractValue);
                        System.debug('oppItem.LCRM_Current_ACV__c**'+oppItem.LCRM_Current_ACV__c);
                    } //DPS-7202 - END
                    
                    if(String.isNotBlank(reqLineItem.opptyProductAction) && String.isNotEmpty(reqLineItem.opptyProductAction)){
                        oppItem.LCRM_Action__c = reqLineItem.opptyProductAction;
                        
                        if((reqLineItem.opptyProductAction.containsIgnoreCase('cancel')) && (String.isNotBlank(reqLineItem.productComments) && String.isNotEmpty(reqLineItem.productComments))){
                            oppItem.LCRM_Cancel_Reason__c = reqLineItem.productComments;
                            System.debug('oppItem.LCRM_Cancel_Reason__c**'+oppItem.LCRM_Cancel_Reason__c);
                        }                       
                    }                    
                    
                    /*if((reqLineItem.opptyProductAction).contains('cancel'))
{//&& (String.isNotBlank(reqLineItem.productComments) && String.isNotEmpty(reqLineItem.productComments)))

System.debug('oppItem.LCRM_Cancel_Reason__c**'+oppItem.LCRM_Cancel_Reason__c);
}*/
                    
                    opportunityLineItemList.add(oppItem);
                }
                if(String.isNotEmpty(reqLineItem.opptyProductId) && String.isNotBlank(reqLineItem.opptyProductId)
                   &&(String.isBlank(reqLineItem.opptyLineItemId) && String.isEmpty(reqLineItem.opptyLineItemId))
                  ) {
                      System.debug('INSERT PRODUCT');
                      opportunityLineItem oppnewItem = new opportunityLineItem();
                      oppnewItem.OpportunityId = opportunityId;
                      System.debug('lineItemMap.get(reqLineItem.opptyProductId)**'+lineItemMap.get(reqLineItem.opptyProductId));
                      if(String.isNotBlank(reqLineItem.opptyProductId) && String.isNotEmpty(reqLineItem.opptyProductId))
                      {oppnewItem.PricebookEntryId = lineItemMap.get(reqLineItem.opptyProductId);}
                      
                      if(String.isNotBlank(reqLineItem.newActualContractValue) && String.isNotEmpty(reqLineItem.newActualContractValue))
                      {oppnewItem.LCRM_New_ACV_SalesPrice__c = Decimal.valueOf(reqLineItem.newActualContractValue);}
                      //Added as a part of DPS-7202
                      if(String.isNotBlank(reqLineItem.currentActualContractValue) && String.isNotEmpty(reqLineItem.currentActualContractValue)){
                        oppnewItem.LCRM_Current_ACV__c = Decimal.valueOf(reqLineItem.currentActualContractValue);
                        System.debug('oppnewItem.LCRM_Current_ACV__c**'+oppnewItem.LCRM_Current_ACV__c);
                       } //DPS-7202 - END
                    
                      
                      if(String.isNotBlank(reqLineItem.opptyProductAction) && String.isNotEmpty(reqLineItem.opptyProductAction))
                      {oppnewItem.LCRM_Action__c = reqLineItem.opptyProductAction;}
                      
                      if((reqLineItem.opptyProductAction).contains('cancel')&& (String.isNotBlank(reqLineItem.productComments) && String.isNotEmpty(reqLineItem.productComments)))
                      {System.debug('Inside cancel');
                       oppnewItem.LCRM_Cancel_Reason__c = reqLineItem.productComments;
                       System.debug('oppItem.LCRM_Cancel_Reason__c**'+oppnewItem.LCRM_Cancel_Reason__c);
                      }   
                      oppnewItem.LCRM_Units__c = 1;
                      opportunityLineItemList.add(oppnewItem);
                      System.debug('opportunityLineItemList**'+opportunityLineItemList);
                  }
                
                
            }
            if(!opportunityLineItemList.isEmpty()){
                try{
                    upsert opportunityLineItemList;                
                    System.debug('UPSERT SUCCESS');
                    responseWrapperLineItem = checkResponseWrapper(true,'Success');
                }
                catch(Exception e){
                    System.debug('Exception Message'+e.getMessage());                
                    responseWrapperLineItem = checkResponseWrapper(false,e.getMessage());
                }   
            }
            
            
        }
        return responseWrapperLineItem;
        
    }
    /* -----------------------------------------------------------------------------------------------------
Method NAME: checkResponseWrapper

PURPOSE : checkResponseWrapper method is used to create response.

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/    
    public static ResponseWrapper checkResponseWrapper(Boolean status,String message){
        System.debug('INSIDE CHECK RESPONSE');
        System.debug('status'+status+'message'+message);
        ResponseWrapper resMessage = new ResponseWrapper();   
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        UpdateOpportunityResponse opportunityesponse = new UpdateOpportunityResponse();
        StatusDetails StatusDetailsResponse = new StatusDetails();
        if(status == true){
            System.debug('INSIDE STATUS TRUE');
            StatusDetailsResponse.statusCode = '200';
            StatusDetailsResponse.statusDescription = 'SUCCESS';
            StatusDetailsResponse.statusDetailMessage = 'SUCCESS';
            opportunityesponse.statusDetails = StatusDetailsResponse;
            resMessage.updateOpportunityResponse = opportunityesponse;   
        }
        else if(status == false){
            System.debug('INSIDE STATUS FALSE');
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = message;
            //excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'LCRMPostbackServiceAPI';                
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            exceptionList.add(excepObj);
            insert exceptionList;
            StatusDetailsResponse.statusCode = '400';
            StatusDetailsResponse.statusDescription = 'Failure';
            StatusDetailsResponse.statusDetailMessage = message;
            opportunityesponse.statusDetails = StatusDetailsResponse;
            resMessage.updateOpportunityResponse = opportunityesponse;    
        }
        
        return resMessage;
        
    }
    
    /* -----------------------------------------------------------------------------------------------------
CLASS NAME: ResponseWrapper

PURPOSE : ResponseWrapper class is the class for creating response.

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/
    global class ResponseWrapper {
        public UpdateOpportunityResponse updateOpportunityResponse;
    }
    
    public class UpdateOpportunityResponse {
        public StatusDetails statusDetails;
    }
    
    public class StatusDetails {
        public String statusCode;
        public String statusDescription;
        public String statusDetailMessage;
    }    
    
    /* -----------------------------------------------------------------------------------------------------
CLASS NAME: OpptyPostbackRequestWrapper

PURPOSE : OpptyPostbackRequestWrapper class is used to deserialize the JSON request.

Created By : TCS

Date : 28/07/2017
-------------------------------------------------------------------------------------------------------*/
    public class OpptyPostbackRequestWrapper{
        public UpdateOpportunityRequest updateOpportunityRequest;
    }
    public class UpdateOpportunityRequest {
        public EsiHeader esiHeader;
        public OpportunityRequest opportunity;
    }
    public class EsiHeader {
        public String applicationId;
        public String transactionId;
        public String messageId;
        public String messageHistory;
        public String tracingId;
        public String timeStamp;
        public String instanceId;
        public String companyId;
        public String configGroup;
        public String payloadVersion;
        public String postBackURL;
        public List<ExtensibleAttributes> extensibleAttributes;
    }
    public class ExtensibleAttributes {
        public String systemIdentifier;
        public String key;
        public String value;
    }
    public class OpportunityRequest{
        public String actionCode;
        public OpportunityHeader opportunityHeader;
        public OpportunityRenewal opportunityRenewal;
        public List<RequestOpportunityLineItem> opportunityLineItem;
    } 
    public class RequestOpportunityLineItem {
        public String opptyProductId;
        public String opptyLineItemId;
        public String newActualContractValue;
        public String opptyProductAction;
        public String productComments;
        public String currentActualContractValue;//Added as a part of DPS-7202
    }
    public class OpportunityHeader {
        public String opptyId;
        public String salesStage;
        public String opptyStatus;
        public String contractType;
        public String quoteId;
    }
    public class OpportunityRenewal {
        public String expectedStartDate; 
        public String expectedEndDate;
        public String negotiationExtnDate;        
        public String extensionAccessDate;
        public List<MultiYearOrBridgeInfo> multiYearOrBridgeInfo; //Added w.r.t. CRM-13416 by Shovon
    }
    //Added w.r.t. CRM-13416 by Shovon
    public class MultiYearOrBridgeInfo { 
        public String period;
        public String startDate;
        public String endDate;
        public String price;
    }

}