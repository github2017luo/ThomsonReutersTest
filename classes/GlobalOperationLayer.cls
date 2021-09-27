/*
/*** @Author: Harika Sai P 
/*** Created Date: 29 MAR 2019
/*** Purpose: This is a class used for generic operations as part of the framework
/*** JIRA : DLT-15694 Create Global Data Layer - All our Sobjects operation should go with this layer */
/*** Change History  ******************************************************************************************************
/*** Modified Date   Modified By           JIRA    
/*** 2019-05-11      Harika sai P          DLT-16389 - Find Law- AEM call to set Correct template for Findlaw to SFDC during Generate Document
/*** 2019-05-24      Harika Sai P          DLT-16538 - [SLF][Tech Story] Enhance exception processing - Digital_GenerateDocumentsBatch
/*** 2019-06-24      Harika Sai P          DLT-16854 [Tech Story] - Remove Unnecessary code lines from Proposal Automation and move to Dataoperation Layer
/**************************************************************************************************************************/

public without sharing class GlobalOperationLayer implements IGlobalOperationLayer {

    IExceptionFactory exF= new ExceptionFactory();    
    public static list<Opportunity> oppsToUpdate = new list<Opportunity>();
    private static final string TOKENURL= System.label.Digital_TOKEN_URL; 
    private static final string USERNAME= System.label.Digital_UserName;
    private static final string PASSWORD= System.label.Digital_Password;
    private static final string INTEGRATIONKEY= System.label.Digital_Integration_Key; 
    private static final string ACCESSLEVEL= 'Read only'; 
    private static final string DOCFORMAT= 'PDF';
    ExceptionFactory.ExceptionWrapper exWrap = new ExceptionFactory.ExceptionWrapper();  
    
    //Generate PDF Document for the proposal using apttus mergeWebService.
    public Id generatePDFDocument(Id templateId,Id quoteId,string strClassRef){  //16538 addded class reference and prposalid to the exception log message
        Id docId;
        try{   
            
            String accessLevel = accessLevel;
            String docFormat = docFormat ; 
            String apiServerURL = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/36.0/' + UserInfo.getOrganizationId();
            String sessionId = UserInfo.getSessionId();
            docId = Apttus_Proposal.MergeWebService.generateDoc(templateId, quoteId, accessLevel, docFormat, sessionId, apiServerURL);
            
        }
        catch(Exception Ex){                   
            exWrap.classRef = strClassRef; 
            exWrap.recordId = quoteId;   //16538   
            createException(exWrap,ex);        
        }
          
        return docId;
    }
    
    // Created an Evnelope and sends it to DocuSign for each proposal in the list which is passed into this method
    public void CreateEnvelopes(List<Apttus_Proposal__Proposal__c> listQuotes,string exObjType) {
       
  
    }
    
    //Performs bundling operation
    public void performBundling(String groupId, List<Apttus_Config2__ProductConfiguration__c> configList,string exObjType){
    
        try{           
           DCDynamicBundle.performBundling(groupId,configList);        
        }
        catch(Exception Ex){
           // createException(exObjType,ex);        
        }
    
    }
    
     //Performs cart finalize for digital as of now
    public void finalizeCart(ID cartId,string strClassRef){
    
       
        if(cartId!= Null){
            try{
                Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
                request.CartId = cartId;
                Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);    
            }
            catch(Exception ex){
                exWrap.classRef = strClassRef;  
                exWrap.recordId = cartId;  //16538   
                createException(exWrap,ex);
            }    
        }
    }
    //DLT-16854 starts
    //This method returns owner Id for specific digital firm from Digital_Firm_Defaults__mdt.
    public Id setTheDigitalOwnerAppSegment(string strDigtlFrm){
         // map to lookup opportunity owner based on Digital Firm value   
        Map<String, Id> mapDigitalOwner = new Map<String, Id>();
        Id digtlOwnerId;
        if(Schema.sObjectType.Digital_Firm_Defaults__mdt.isAccessible()){
            for(Digital_Firm_Defaults__mdt oDefaults: [SELECT Label, Opportunity_Owner_Id__c, Proposal_Approval_Segment__c                            
                              FROM Digital_Firm_Defaults__mdt]){                          
              mapDigitalOwner.put(oDefaults.Label, oDefaults.Opportunity_Owner_Id__c);     
            } 
        }
        if(!mapDigitalOwner.isEmpty()) {        
            digtlOwnerId = mapDigitalOwner.get(strDigtlFrm);
        }                
        return digtlOwnerId;       
    }
    //DLT-16854 ends
    //Logs Exception from Exception Factory class
    @TestVisible
    private void createException(ExceptionFactory.ExceptionWrapper exWrap, Exception ex){
        if(exWrap.classRef != '' && (exWrap.classRef.containsIgnoreCase('Digital') || exWrap.classRef.startsWithIgnoreCase('DC'))){
            exWrap.sObjType='Digital_Exception_Log__c';
        }
            exWrap.ex = ex;
            exF.LogException(exWrap);
        }

   
}