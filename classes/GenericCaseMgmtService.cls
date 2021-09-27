/********************************************************************** 
Name: GenericCaseMgmtService 
====================================================== 
Req: DSS-4144
====================================================== 
Purpose: Generic class for creating case from various integration sources.
======================================================
Test Class: GenericCaseMgmtServiceTest
======================================================  
History 
------- 
VERSION     AUTHOR              DATE        DETAIL 
1.0 -       TCS Developer   07/26/2019  Initial Development 
 
***********************************************************************/
public without sharing class GenericCaseMgmtService {
    public List<ESC_Case_Creation_Field_Mapping__mdt> caseCreationMapping = new List<ESC_Case_Creation_Field_Mapping__mdt>(); 
    Public List<Id> lstCaseIds = new List<Id>();
    
    /******************************************************************* 
    Purpose: Creates a service case whenever credit check request fails. Method to be invoked from OC. 
    Parameters: lstQuoteId - List of Quote/Proposal Ids
    Returns: List of Cases created
    ********************************************************************/
    public List<Id> createCreditCheckCase(List<Id> lstQuoteId, Map<id,string> uniqueIdentifier)
    {
        String integrationType = Label.ESC_CreditCheck_IntegrationType;
        Set<String> setRegion = new Set<String>();
        Set<String> setSegment = new Set<String>();
        Set<String> setUniquedentifier= new Set<String>();
        Set<String> setRiskCase= new Set<String>(); // added as part of DSS-9492
        Boolean InsufficientCredFlag= False;
        Set<Id> setContactId = new Set<Id>();
        List<Case> lstNewCase = new List<Case>();
        List<Case> lstCasesupd = new List<Case>();
        List<Apttus_Proposal__Proposal__c> lstApttusQuote;
        List<Apttus_Config2__Order__c> lstorder = new List<Apttus_Config2__Order__c>();
        Map<Id,Id> mapOrders =new Map<Id,Id>();
        if(lstQuoteId == null || lstQuoteId.size() == 0){
            return null;
        }
        
        try{
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){  
            lstApttusQuote = [SELECT Id, OwnerId, Credit_Check_Description__c, APTS_Order_Confirmation_Contact__c, APTS_Order_Confirmation_Contact__r.BU_Region__c, APTS_Order_Confirmation_Contact__r.BU_Segment__c,APTS_Quote_Value__c
                                                            FROM Apttus_Proposal__Proposal__c
                                                            Where Id IN :lstQuoteId];
        }
        
        //Added in Risk for OM Cases
        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible() && Schema.sObjectType.Apttus_Config2__Order__c.isQueryable()){
        lstorder = [Select id, Apttus_QPConfig__ProposalId__c from Apttus_Config2__Order__c where  Apttus_QPConfig__ProposalId__c IN :lstQuoteId];
        }
        if(lstorder.size()>0){
            for(Apttus_Config2__Order__c ord:lstorder){
                mapOrders.put(ord.Apttus_QPConfig__ProposalId__c,ord.id);
            }
        }
        
        if(lstApttusQuote != null & lstApttusQuote.size() > 0){
            for(Apttus_Proposal__Proposal__c oQuote: lstApttusQuote){
                setRegion.add(oQuote.APTS_Order_Confirmation_Contact__r.BU_Region__c);
                setSegment.add(oQuote.APTS_Order_Confirmation_Contact__r.BU_Segment__c);
                system.debug('#### uniqueIdentifier.get(oQuote.Id)'+uniqueIdentifier.get(oQuote.Id));
                setUniquedentifier.add(uniqueIdentifier.get(oQuote.Id));
                // added as part of DSS-9492
                 If (uniqueIdentifier.get(oQuote.Id) != 'Insufficient Credit' && uniqueIdentifier.get(oQuote.Id) != 'Credit Check')
                                                                                {
                       setRiskCase.add(uniqueIdentifier.get(oQuote.Id));                                          
                                                                }

            } 
        }       
        
        if(setRegion.size() > 0 && setSegment.size() > 0 && setUniquedentifier.size() >0){
            system.debug('##### setUniquedentifier'+setUniquedentifier);
            caseCreationMapping = getCaseCreationMappingInfo(setSegment, setRegion, integrationType,setUniquedentifier);
        }     
        
        if(caseCreationMapping == null || caseCreationMapping.size() == 0){
            system.debug('No Record found in custom setting');
            return null;
        }
        
        for(Apttus_Proposal__Proposal__c oQuote: lstApttusQuote){
            Case oCase =  setCaseFieldBasedOnMapping(oQuote.APTS_Order_Confirmation_Contact__r.BU_Segment__c, oQuote.APTS_Order_Confirmation_Contact__r.BU_Region__c, integrationType,oQuote.Credit_Check_Description__c);
            oCase.put('Quote_Proposal__c',oQuote.Id);
            oCase.put('LCRM_Sub_BU__c',oQuote.APTS_Order_Confirmation_Contact__r.BU_Region__c);
            oCase.put('BU_Segment__c',oQuote.APTS_Order_Confirmation_Contact__r.BU_Segment__c);
            // added as part of DSS-9492
            if(setRiskCase.size() == 0 || setRiskCase.size() == null)
            {
            oCase.put('Description',oQuote.Credit_Check_Description__c);
            }
            oCase.put('ContactId', oQuote.APTS_Order_Confirmation_Contact__c);
            oCase.put('Is_GLI__c',true);
            if(maporders.keySet().size()>0 && maporders.containsKey(oQuote.id)){
                oCase.put('ESC_Order__c',maporders.get(oQuote.id));
            }
         if(uniqueIdentifier.get(oQuote.id) =='Insufficient Credit')
            {
            oCase.put('TXP_Asset_Amount__c',oQuote.APTS_Quote_Value__c);
            }
            lstNewCase.add(oCase); 
        }
        system.debug('+-+lstNewCase'+lstNewCase);
        
        if(lstNewCase != null && lstNewCase.size() > 0){
            if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isCreateable()){
                List<Database.saveResult> lstRslt = Database.insert(lstNewCase, false);
                if(lstRslt != null)
                {
                    for(Database.saveResult rslt: lstRslt)
                    {
                        if(rslt.isSuccess()){
                            System.debug(rslt.getId());
                            //create chatter post only when case creation is susccessful                       
                            lstCaseIds.add(rslt.getId());
                            
                            system.debug('+++=--==lstCaseIds'+lstCaseIds);
                        }
                        else{ 
                            for(Database.Error err : rslt.getErrors()){
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                } 
            }  
        }
        if(lstCaseIds != null && lstCaseIds.size() > 0)
        {
        // added as part of DSS-9492
            if(setRiskCase.size() == 0 || setRiskCase.size() == null)
            {
            lstCasesupd = createChatterPost(lstCaseIds);
            system.debug('++ lstCasesupd '+lstCasesupd);
            }
            ///DSS-5742 changes
            List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
            for(Case cse : lstNewCase){
                if(cse.ESC_Unique_Identifier__c == 'Insufficient Credit'){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(cse.id);                 
                    req1.setSubmitterId(userinfo.getUserId());                  
                    req1.setProcessDefinitionNameOrId('ESC_Case_insufficient_credit_approval'); 
                    requests.add(req1);                 
                }
            }
            system.debug('++requests '+requests);
            Approval.ProcessResult[] result = null;
            try{
            result = Approval.process(requests,true); 
            System.debug('result ' + result);
            }
            catch (System.DmlException e) {
                System.debug('Exception Is ' + e.getMessage());
            }
                  
            //system.debug('++req1'+req1);
        }
       
        system.debug('New Case Created: '+ lstCaseIds);   
        return lstCaseIds;
        }
        catch(Exception ex){
            system.debug('Error while creating case:'+ ex);
            return null;
        }
        
    }
    
    /******************************************************************* 
    Purpose: Get Case Field mapping info from custom metadata.
    Parameters: setSegment - Set of all segments based on quoteIds
                setRegion  - Set of all regions based on quoteIds
                integrationType - integration Type
    Returns: List of custom metadata record
    ********************************************************************/
    private List<ESC_Case_Creation_Field_Mapping__mdt> getCaseCreationMappingInfo(Set<String> setSegment, Set<String> setRegion, string integrationType,Set<String> setUniquedentifier)
    {
        List<ESC_Case_Creation_Field_Mapping__mdt> caseCreationMapping = new List<ESC_Case_Creation_Field_Mapping__mdt>();
        if(Schema.sObjectType.ESC_Case_Creation_Field_Mapping__mdt.isAccessible() && Schema.sObjectType.ESC_Case_Creation_Field_Mapping__mdt.isQueryable()){  
            caseCreationMapping = [Select Segment__c, Region__c, Integration_Type__c, Field_API_Name__c, Field_Value__c
                                                                         From ESC_Case_Creation_Field_Mapping__mdt
                                                                         where Segment__c IN :setSegment AND Region__c IN :setRegion AND
                                                                                Integration_Type__c = :integrationType AND Unique_Identifier__c=:setUniquedentifier];
        }
        system.debug('@@ casecreationmapping:' + caseCreationMapping + setSegment + setRegion + integrationType);
        return caseCreationMapping;    
    }
    
    /******************************************************************* 
    Purpose: Set Case Field based on the custom metadata record.
    Parameters: segment - segment detail
                region  - region detail
                integrationType - integration Type
    Returns: Case object
    ********************************************************************/
    private Case setCaseFieldBasedOnMapping(String segment, String region, String integrationType, string Uniquedentifier){
        Case oCase = new Case();        
        map <String,String> queueIdMap=new map<string,string>(); 
        List <string> queuenamelist = new List<string>();  
        for(ESC_Case_Creation_Field_Mapping__mdt oMapping: caseCreationMapping){
            if(oMapping.Field_API_Name__c == 'OwnerId' && oMapping.Field_Value__c != null && oMapping.Field_Value__c != ''){
                queuenamelist.add(oMapping.Field_Value__c);
                }
        } 
        for(Group grp : [Select id,developername from group where developername IN :queuenamelist]){
            queueIdMap.put(grp.developername,grp.id);
        }     
        for(ESC_Case_Creation_Field_Mapping__mdt oMapping: caseCreationMapping)
        {
            if(oMapping.Segment__c == segment && oMapping.Region__c == region && oMapping.Integration_Type__c == integrationType ){
                
                //oCase.put('ESC_Unique_Identifier__c', oMapping.Unique_Identifier__c);  
                if(oMapping.Field_API_Name__c == 'OwnerId' && oMapping.Field_Value__c != null && oMapping.Field_Value__c != '' && queueIdMap != null && queueIdMap.containsKey(oMapping.Field_Value__c)){
                    oCase.put(oMapping.Field_API_Name__c,queueIdMap.get(oMapping.Field_Value__c) );
                    }
                else{
                    oCase.put(oMapping.Field_API_Name__c, oMapping.Field_Value__c);
                    }
                if(oMapping.Field_API_Name__c == 'ESC_Case_Type__c' && oMapping.Field_Value__c != null && oMapping.Field_Value__c != ''){
                    oCase.put('RecordTypeId', getRecordTypeId('Case',oMapping.Field_Value__c));       
                    }
            }
        }
        system.debug('+++oCase'+oCase);
        return oCase;  
    }
    
    /******************************************************************* 
    Purpose: Get recordType Id based on Object and Record Type Name.
    Parameters: objectApiName - Object for which recordtype Id needs to be fetched
                recordtypeName - RecordType Name
    Returns: RecordTypeID
    ********************************************************************/
    private Id getRecordTypeId(String objectApiName, string recordtypeName)
    {
        Id devRecordTypeId = Schema.getGlobalDescribe().get(objectApiName).getDescribe().getRecordTypeInfosByName().get(recordtypeName).getRecordTypeId();
        return devRecordTypeId;
    }
    
    /******************************************************************* 
    Purpose: create Chatter Post on cases created via credit check.
    Parameters: lstCaseIds - case ids for which chatter message needs to be created.
    Returns: 
    ********************************************************************/
    private List<Case> createChatterPost(List<Id> lstCaseIds)
    {
        try{
            List<Case> lstCase = new List<Case>();
            if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isQueryable()){  
                lstCase = [Select Id, Quote_Proposal__c,esc_unique_identifier__c, Quote_Proposal__r.OwnerId
                                     From Case
                                     Where Id IN :lstCaseIds];
            }
            
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    
            for(Case oCase : lstCase){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                
                mentionSegmentInput.id = oCase.Quote_Proposal__r.OwnerId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                textSegmentInput.text = ' ' + Label.ESC_CreditCheck_ChatterMsg;
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = oCase.Id;
                
                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                batchInputs.add(batchInput);
            }
            
            if(batchInputs.size() > 0){
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
                }
            return lstCase;
        }
        catch(Exception ex)
        {
            system.debug('Error while ceation of chatter post:'+ex);
            return null;
        }
    }
    
    private static void createQuotePost(String ownerid,String status,String caseid){
        system.debug('ownerid is'+ownerid+'***'+status+'&&&&'+caseid);
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        mentionSegmentInput.id = ownerid;
        messageBodyInput.messageSegments.add(mentionSegmentInput);
        if(status == 'pass'){
        textSegmentInput.text = ' '+Label.ESC_Approval_Success;
        }
        else{
        textSegmentInput.text = ' '+Label.ESC_Approval_failure;
        }
        messageBodyInput.messageSegments.add(textSegmentInput);
        
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = caseid;
        system.debug('feedItemInput is'+feedItemInput);
        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        batchInputs.add(batchInput);        
        ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
        
        
    }
    
    /******************************************************************* 
    Purpose: Set Credit Check Status Field on Quote based on the sub type field of case.
    Parameters: case - oldMap
                case - newMap
                
    Returns: None
    ********************************************************************/
    public static void setCreditCheckStatusOnQuote(Map<id,case> newMap,Map<id,case> oldMap){
        List<case> caseList = new List<Case>();
        Set<Id> apttusQuoteIdSet = new Set<Id>();
        Set<Id> caseIDSet = new Set<Id>();
        for(Id oCaseId: newMap.keyset()){
            if(newMap.get(oCaseId).Quote_Proposal__c!=null && newMap.get(oCaseId).ESC_Sub_Type__c!=oldMap.get(oCaseId).ESC_Sub_Type__c){
                apttusQuoteIdSet.add(newMap.get(oCaseId).Quote_Proposal__c);
                caseIDSet.add(ocaseId);
            }
        }
        system.debug('case and quote ids :' + apttusQuoteIdSet  + ':' + caseIDSet);
        if(apttusQuoteIdSet== null || apttusQuoteIdSet.size() == 0){
            return;
        }
            
        List<Apttus_Proposal__Proposal__c> lstApttusQuote = new List<Apttus_Proposal__Proposal__c>();
        Map<id,Apttus_Proposal__Proposal__c> mapApttusQuote = new Map<id,Apttus_Proposal__Proposal__c>();
        List<Apttus_Config2__Order__c> orderlist = new List<Apttus_Config2__Order__c>();
        List<Apttus_Config2__Order__c> updateorder = new List<Apttus_Config2__Order__c>();
        List<Id> propIds = new List<Id>();
        try
        {
            if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){  
                lstApttusQuote = [SELECT id,SAP_Credit_Check_Status__c,ownerid from Apttus_Proposal__Proposal__c WHERE id IN:apttusQuoteIdSet];
            }
            
            if(lstApttusQuote !=null && lstApttusQuote.size() > 0){
                for(Apttus_Proposal__Proposal__c oQuote: lstApttusQuote){
                    mapApttusQuote.put(oQuote.Id,oQuote);
                }
            }
            system.debug('## map of quote:' +mapApttusQuote + ':' + lstApttusQuote  );
            List<Apttus_Proposal__Proposal__c > lstApptusQuoteToUpdate = new List<Apttus_Proposal__Proposal__c >();
            for(Id oCase:caseIDSet){
            Apttus_Proposal__Proposal__c oQuote ;
                   
               if(newMap.get(oCase).ESC_Sub_Type__c == 'Approved'){
                   oQuote = mapApttusQuote.get(newMap.get(oCase).Quote_Proposal__c);
                   createQuotePost(oQuote.ownerid,'pass',oQuote.id);
                   oQuote.SAP_Credit_Check_Status__c ='Pass';
                   
               }else if(newMap.get(oCase).ESC_Sub_Type__c == 'Rejected'){
                   oQuote = mapApttusQuote.get(newMap.get(oCase).Quote_Proposal__c);                   
                   createQuotePost(oQuote.ownerid,'fail',oQuote.id);
                   oQuote.SAP_Credit_Check_Status__c ='Fail';
                   oQuote.Apttus_Proposal__Approval_Stage__c ='Cancelled';
               }
                /*else if(newMap.get(oCase).ESC_Sub_Type__c == ''){
                   oQuote = mapApttusQuote.get(newMap.get(oCase).Quote_Proposal__c);
                   oQuote.SAP_Credit_Check_Status__c ='';
               }*/
                   system.debug('## inside update loop:' + oQuote);
               if(oQuote != null){
                   lstApptusQuoteToUpdate.add(oQuote);
                   propIds.add(oQuote.Id);  //DOC-3179 - Added by Nandha
               }
               
            }
            system.debug('## list of quotes to update:' + lstApptusQuoteToUpdate);
            if(lstApptusQuoteToUpdate!=null && lstApptusQuoteToUpdate.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                update lstApptusQuoteToUpdate;
            }
           //DOC-3179 - Added by Nandha : Starts Here
           if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible() && Schema.sObjectType.Apttus_Config2__Order__c.isQueryable()){  
                orderlist = [SELECT id,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__r.SAP_Credit_Check_Status__c,Apttus_QPConfig__ProposalId__r.Id from Apttus_Config2__Order__c WHERE Apttus_QPConfig__ProposalId__r.Id IN:propIds];
            }
            for(Apttus_Config2__Order__c ord : orderlist){
                if(ord.Apttus_QPConfig__ProposalId__r.SAP_Credit_Check_Status__c == 'Pass'){
                    ord.APTS_SAP_Status__c = 'Credit Pass';
                    updateorder.add(ord);
                }
                else if(ord.Apttus_QPConfig__ProposalId__r.SAP_Credit_Check_Status__c == 'Fail'){
                    ord.APTS_SAP_Status__c = 'Rejected by Credit';
                    ord.Apttus_Config2__Status__c = 'Cancelled';
                    updateorder.add(ord);
                }
            }
            if(updateorder != NULL && updateorder.size() > 0 && Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable()){
                update updateorder;
            }
            //DOC-3179 - Added by Nandha : Ends Here
        }catch(Exception ex){
            system.debug('Error :' + ex.getMessage());
        }
        
    }
}