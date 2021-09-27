/* Class: DCPProcessDocusignController
* Purpose: This class will handle all the calls to cover Docusign Process
* Created: 6/14/2021
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-06-14   Avudaiappan A   DCP-2252   Docusign Calls 
* =============================================================================
*/
/** 
* @description : Make all docusign calls in a sequence to cover the process.
*/

public with sharing class DCPProcessDocusignController {
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    public Static String priceListNameUS = Static_Values__c.getValues('PriceListName').Value__c;//Fetch the name of PL :'Thomson Reuters Master - US Legal'

    /********************************************************************************************************
    *  @description  generateDoc - This is a main method to generate a document for docusign 
    *  @param quoteId - expected quote id
    *********************************************************************************************************/   
    @Future(Callout=true)
    public static void generateDoc(String quoteId){
        Digital_WS_GenerateDocument.DigitalResponse sendDoc;
        Map<String,String> errorHandlerMap;
         sendDoc = new Digital_WS_GenerateDocument.DigitalResponse();
            if(String.isNotBlank(quoteId)){
                try{
                    sendDoc = Digital_WS_GenerateDocument.doPost(quoteId);
                }catch(Exception ex){
                    errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>String.valueof(ex.getLineNumber())+','+ex.getMessage(),'webServiceName'=>'UEUSL Docusign - Generate Document Call','requestType'=>'Class DCPProcessDocusignController','reqMsg'=>ex.getStackTraceString(),'module'=>'UEStore','recId'=>quoteId,'supportEmail'=>supportEmail,'toSupport'=>'false'};
                    DCPProcessDocusignController.logExceptions(errorHandlerMap);            
                }
            }
        
        //return sendDoc;
    }
    /********************************************************************************************************
    *  @description  createEnv - This is a main method to create an envelope for docusign 
    *  @param quoteId - expected quote id
    *********************************************************************************************************/   
    @Future(Callout=true)
    public static void createEnv(String quoteId){
        DCDocuSignController.DocuSignResponse createEnv;
            Map<String,String> errorHandlerMap;
            createEnv = new DCDocuSignController.DocuSignResponse();
            if(String.isNotBlank(quoteId)){
                try{
                createEnv = DCDocuSignController.envelopeCreation(quoteId);  
                }catch(Exception ex){
                    errorHandlerMap = new Map<String,String>{'objectName'=>'Quote/Proposal','expMsg'=>String.valueof(ex.getLineNumber())+','+ex.getMessage(),'webServiceName'=>'UEUSL Docusign - Create Envelope Call','requestType'=>'Class DCPProcessDocusignController','reqMsg'=>ex.getStackTraceString(),'module'=>'UEStore','recId'=>quoteId,'supportEmail'=>supportEmail,'toSupport'=>'false'};
                    DCPProcessDocusignController.logExceptions(errorHandlerMap);          
                }
            }
        
        //return createEnv;
    }
    /********************************************************************************************************
    *  @description  callUpdateQuote - This is a main method to update Digitally Signed Date in proposal 
    *  @param quoteId - expected quote id
    *********************************************************************************************************/ 
    public static void callUpdateQuote(string quoteId){
        Apttus_Proposal__Proposal__c proposal = [select Id,Apttus_Proposal__Primary__c,Digitally_Signed_Date__c from Apttus_Proposal__Proposal__c where id=:quoteId WITH SECURITY_ENFORCED LIMIT 1];
            if(proposal.Id!=null){
                proposal.Apttus_Proposal__Primary__c = true;
                proposal.Digitally_Signed_Date__c = system.now();
                Database.update(proposal);
            }
        
    }
    
         /********************************************************************************************************
* @description logException: Upsert Exception
*  @param logMap
*********************************************************************************************************/ 
    public static void logExceptions(Map<String,String> logMap){
        if(logMap!=null){
            DCPNewSaleUtilityCls.logException(logMap);
        }
    }
    
    /********************************************************************************************************
    *  @description  docusignProcess - This is a main method to call the docusign process
    *  @param quoteId - expected quote id
    *********************************************************************************************************/
    /*@Future(callout=true)
    public static void docusignProcess(String quoteId){
        DCDocuSignController.DocuSignResponse createEnv = new DCDocuSignController.DocuSignResponse();
        Digital_WS_GenerateDocument.DigitalResponse sendDoc = new Digital_WS_GenerateDocument.DigitalResponse();
        
        sendDoc = DCPProcessDocusignController.generateDoc(quoteId);
        
        if((sendDoc.Status == 'Success' && sendDoc.documentId!=null) || (Test.isRunningTest())){
            createEnv = DCPProcessDocusignController.createEnv(quoteId);
        }
        if(createEnv.responseCode == 200 && createEnv.envelopeId!=null){
            DCPNewSaleCompleteDocusignEnvelope.completeEnvelope(createEnv.envelopeId,quoteId);
        }
        
    }*/
    
    /********************************************************************************************************
* @description : mapProposalDetails - Method to map the fields which need to be updated on Proposal Record
*  @param billTo - SSD Detail
*  @param leadInfo - lead information
*  @param quoteInfo - quote information 
*  @return proposal list
*********************************************************************************************************/    
    public static List<Apttus_Proposal__Proposal__c> mapProposalDetails(String billTo, List<Lead> leadInfo, List<Apttus_Proposal__Proposal__c> quoteInfo){
        String priceListName;
        if(!leadInfo.isEmpty() && !quoteInfo.isEmpty()){
        priceListName = (leadInfo[0].Lead_Region__c=='TR Store US Print')? priceListNameUS:'' ;
        string query = 'SELECT id,Name FROM Apttus_Config2__PriceList__c WHERE name =: priceListName LIMIT 1';
        List<Apttus_Config2__PriceList__c> priceListDetails = database.Query(query);
            for(Lead lead : leadInfo){
                
                    quoteInfo[0].Apttus_Proposal__Opportunity__c = lead.ConvertedOpportunityId;
                    quoteInfo[0].Apttus_Proposal__Account__c = lead.convertedAccountid;
                    quoteInfo[0].APTS_Order_Confirmation_Contact__c = lead.ConvertedContactId;
                    quoteInfo[0].Apttus_Proposal__Primary_Contact__c = lead.ConvertedContactId;
                    //quoteInfo[0].APTS_Customer_Pricing_Segment__c = 'Law Firm';
                    //quoteInfo[0].Customer_Group__c = 'FIRM';
                    //quoteInfo[0].APTS_Approval_Segment__c = 'Small Law';
                    quoteInfo[0].TR_Store_Source__c = lead.Lead_Region__c;
                    if(priceListDetails != null && priceListDetails.size() > 0){
                        for(Apttus_Config2__PriceList__c pl : priceListDetails){
                            quoteInfo[0].Apttus_QPConfig__PriceListId__c = pl.id;
                        }
                    }
                    
                    quoteInfo[0].APTS_SSD_bill_to__c = billTo;
                    quoteInfo[0].APTS_SSD_Sold_To__c = quoteInfo[0].APTS_SSD_Ship_to__c = quoteInfo[0].APTS_Payer__c = billTo;
                    quoteInfo[0].Digital_Quote_Type__c = 'New Sales';   
                    quoteInfo[0].Apttus_QPConfig__BillToAccountId__c = lead.convertedAccountid;
                    quoteInfo[0].Apttus_Proposal__Primary__c = true;
                    quoteInfo[0].Apttus_Proposal__ReadyToGenerate__c = true;
                    quoteInfo[0].APTS_Ebilling_exempt__c = false;
                    quoteInfo[0].DC_Contract_Not_In_Sync__c = true;
                    quoteInfo[0].Latam_APTS_Reason__c = 'DIGITAL';
                    quoteInfo[0].APTS_Ebilling_contact__c = lead.ConvertedContactId;
                    //For Docusign Template to generate clauses for online WL Products
                    quoteInfo[0].APTS_Boolean_Count_of_Online__c = true;
                    quoteInfo[0].APTS_Count_of_NEW_Proposal_Line_Item__c = true;
                    quoteInfo[0].APTS_Number_of_Bridged_ProFlex_BDL__c = 0;
                    quoteInfo[0].APTS_Number_of_Non_Bridged_ProFlex_BDL__c = 0;
                    quoteInfo[0].APTS_MasterContacts_Collected__c = true;
                    //proposalList.add(quoteInfo);
                
            }                
        }
        
        return quoteInfo;
    }

    /*public static void dynamicBundle(String proposalId){
            String bundleGroup = System.Label.BundleGroup;
            List<Apttus_Config2__ProductConfiguration__c> configList = [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,APTS_SSD_Sold_To__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, 
                          Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, 
                          Apttus_Config2__AccountId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c 
                          WHERE Apttus_QPConfig__Proposald__c =:proposalId AND Apttus_Config2__Status__c = 'Finalized' 
                          AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Straight Renewal'
                          AND (Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c != 'Government' 
                          OR Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.BU_Segment_Level_2__c != 'Federal')]; 
             
                if( !configList.isEmpty() ){
                
                    DCDynamicBundle.performBundling(bundleGroup, configList); 
                }  
    }*/


}