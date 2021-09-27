public with Sharing class WebserviceResponseHandler{  
    /********************************************************************************************
    MethodName: updateQuoteOnRemoveSuccess
    Description: Method is called from this class and also called from class "CaseTriggerHandler".
                 Method updates Quote and Opportunity on webservice success call out or Case closer process.
    DevelopedBy: Sushen Adhikary 
    Revision:
    ======================================================================================================================
    DATE              NAME                    DESC
    2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
    2019-12-10        Shyam Sundar Shet       Endpoint changed from MISSOA to DellBoomi as part of JIRA BMP-1218
    ======================================================================================================================
    Fixed Defect#:
    *********************************************************************************************/
    public static void updateQuoteOnRemoveSuccess(List<Quote> lstProcessQuote, String sWSresponseDes)
    {
        try{

            List<Quote> lstUpdateQuote = new List<Quote>();
            List<Opportunity> lstUpdateOpprty = new List<Opportunity>();
            Set<Id> setQtyId = new Set<Id>();
            for(Quote qt : lstProcessQuote){
                setQtyId.add(qt.Id);
            }
            Map<String, Renewal_Request__c> mapRR = new Map<String, Renewal_Request__c>();
            for(Renewal_Request__c rr : [SELECT Id, Quote__c, Remove_Reason__c, Remove_Comments__c, Was_There_a_Competitor__c, Competitor_Name__c FROM Renewal_Request__c WHERE Quote__c IN : setQtyId ORDER BY CreatedDate DESC]){
                if(mapRR.get(rr.Quote__c) == null){
                    mapRR.put(rr.Quote__c, rr);
                }
            }
/*System.Debug('mapRR='+ mapRR);-- commented to reduce character for s2e optimization */
            List<Renewal_Request__c> lstRR = new List<Renewal_Request__c>();
            List<Quote> lstLockQuote = new List<Quote>();
            for(Quote objQty : lstProcessQuote){
                //Preparing Quote for update.
                Quote objQuote = new Quote();
                objQuote.Id = objQty.Id; //objQuote.Status = 'Remove';
                Opportunity objOpp = new Opportunity();
                objOpp.Id = objQty.OpportunityId;
                if(mapRR.get(objQty.Id) != null){
                    if(mapRR.get(objQty.Id).Remove_Reason__c != null){
                        objQuote.Remove_Reason__c = mapRR.get(objQty.Id).Remove_Reason__c;
                    }
                    if(mapRR.get(objQty.Id).Remove_Comments__c != null){
                        objQuote.Remove_Renewal_Comments__c = mapRR.get(objQty.Id).Remove_Comments__c;
                    }
                    objQuote.Win_Loss__c = 'Lost';
                    objQuote.Reason__c = 'Remove Renewal';
                    objQuote.IsSkipQtyLockingValidation__c = true;
                    objOpp.StageName = '0%';
                    objOpp.Status__c = 'Discarded';
                    objOpp.Win_Loss__c = 'Lost';
                    objOpp.Reason__c = 'Remove Renewal';
                    objOpp.Approval_Status__c = 'Removed';
                    objOpp.Manual_Renewal_stage_change__c = true;
                    if(mapRR.get(objQty.Id).Was_There_a_Competitor__c != null){
                        objQuote.Was_There_a_Competitor__c = mapRR.get(objQty.Id).Was_There_a_Competitor__c;
                        objOpp.Was_There_a_Competitor__c = mapRR.get(objQty.Id).Was_There_a_Competitor__c;
                    }
                    if(mapRR.get(objQty.Id).Competitor_Name__c != null){
                        objQuote.Competitor_Name__c = mapRR.get(objQty.Id).Competitor_Name__c;
                        objOpp.Competitor_Name__c = mapRR.get(objQty.Id).Competitor_Name__c;
                    }
                    //By pass Quote locking validation
                    Quote objLockQuote = new Quote();
                    objLockQuote.Id = objQty.Id;
                    objLockQuote.IsSkipQtyLockingValidation__c = false;
                    lstLockQuote.add(objLockQuote);
                    Renewal_Request__c objRR = new Renewal_Request__c();
                    objRR.Id = mapRR.get(objQty.Id).Id;
                    objRR.Remove_Renewal_Update_Status__c = 'Closed';
                    objRR.SAP_Remove_Renewal_Request_Status__c = 'Success';
                    if(sWSresponseDes != ''){
                        objRR.SAP_Remove_Renewal_Status_Description__c = sWSresponseDes;
                    }
                    lstRR.add(objRR);
                }
                objQuote.Remove_Renewal_Update_Status__c = 'Closed';
                objQuote.SAP_Remove_Renewal_Request_Status__c = 'Success';
                if(sWSresponseDes != ''){
                    objQuote.SAP_Remove_Renewal_Status_Description__c = sWSresponseDes;
                }
                lstUpdateQuote.add(objQuote);
                lstUpdateOpprty.add(objOpp);
            }
            if(lstRR.size() > 0){
                Database.UPDATE (lstRR,false);
            }
            if(lstUpdateQuote.size() > 0){
                Database.UPDATE (lstUpdateQuote,false);  
            }
            if(lstLockQuote.size() > 0){
                Database.UPDATE (lstLockQuote,false);
            }
            if(lstUpdateOpprty.size() > 0){
                checkRecursive.isAllowChildQuoteDiscard = false;
                Database.UPDATE (lstUpdateOpprty,false); 
                checkRecursive.isAllowChildQuoteDiscard = true;
            }

        }
        catch(DmlException ex){
            System.debug(ex.getMessage());
        /* System.Debug('Exception occured on Remove or Cancel Request Submit, Method = updateQuoteOnRemoveSuccess, Class = WebserviceResponseHandler, ERROR='+ ex);  -- commented to reduce character for s2e optimization */                    
        }
    }
     
    /********************************************************************************************
    MethodName: createNewCase
    Description: Method is called from this class and also called from class "QuoteTriggerHandler".
                 Method creates a new Case when manager approve the Quote for Cancellation request..
    DevelopedBy: Sushen Adhikary
    Revision:
    ======================================================================================================================
    DATE              NAME                    DESC
    2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
    ======================================================================================================================
    Fixed Defect#:
    *********************************************************************************************/
    public static void createNewCase(Quote objQty, String sRenewalType)
    {       
        try{
/*System.Debug('In Method createNewCase, objQty='+ objQty);-- commented to reduce character for s2e optimization */
            //Preparing a new Case for insert.      
            Case objNewCase = new Case();
            objNewCase.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName = 'ANZ' LIMIT 1].Id;
            objNewCase.OwnerId = [select Id from Group where type='Queue' AND DeveloperName='Order_Processing_Queue' LIMIT 1].Id;
            objNewCase.Quote__c = objQty.Id;
            objNewCase.Opportunity__c = objQty.OpportunityId;
            objNewCase.AccountID = objQty.AccountID;
            objNewCase.Reason_Detail__c = sRenewalType;
            objNewCase.Reason__c = sRenewalType;
            objNewCase.Origin = 'Created by System';
            if(objQty.SAP_Quote_Number__c != null && objQty.SAP_Quote_Number__c != ''){
                objNewCase.Subject = sRenewalType + ' - ' + objQty.SAP_Quote_Number__c;
            }
            else{
                objNewCase.Subject = sRenewalType;
            }
            objNewCase.Sales_Org__c = objQty.Sales_Org__c;
            objNewCase.ANZ_Issue__c = 'Renewal Requests';
            if(sRenewalType == 'Full Cancellation'){
                objNewCase.Approval_Status__c = 'Approved'; //Added for Defect# SFD-1026 
            }
            else if(sRenewalType == 'Remove Renewal'){
                objNewCase.Approval_Status__c = 'Webservice Failure';
            }

            Database.INSERT (objNewCase,false);

        }
        catch(DmlException ex){
            System.debug(ex.getMessage());
       //System.Debug('Exception occured on Remove or Cancel Request Submit, Method = createNewCase, Class = WebserviceResponseHandler, ERROR='+ ex);
        }
    }
    
        /********************************************************************************************
    MethodName: updateSAPQuote
    Description: Method is called from the class RenewalRequestController. This is triggered from
                the button Remove Renewal on Quote object.                    
    *******************************************************************************************/
 
    
public static String updateSAPQuote(String quoteNumber){
    
    String trackingId;
    quoteNumber = '00'+ quoteNumber;
    ecomRenewalWebservice.SubRenewalServiceV01 objSRS = new ecomRenewalWebservice.SubRenewalServiceV01();
    ecomRenewalWebservice.context_element objConEle = new ecomRenewalWebservice.context_element();
    objConEle.productId = KeyValueListStore__c.getInstance('BigRuleProductId').TextValue__c; //'SF03';
    objConEle.configGroup = KeyValueListStore__c.getInstance('BigRuleCconfigGroup').TextValue__c; //'WRP';
    WebServiceSettings__c objWBSSetting = AppUtil.getWebServiceSettings('RemoveRenewalRequest');
    try{
    String accessToken=DellBoomiTokenGeneration.getAuthToken(); //BMP-1218
    //Blob blobCredentials = Blob.valueOf(objWBSSetting.Username__c + ':' + objWBSSetting.Password__c);
    //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
    string sAuthorizationHeader = 'Bearer ' +accessToken;
    Map<String,String> pass = new Map<String,String>();
    pass.put('Authorization', sAuthorizationHeader);
    objSRS.inputHttpHeaders_x = pass;
    objSRS.endpoint_x = objWBSSetting.Endpoint__c;  
    objSRS.timeout_x = (objWBSSetting.Timeout__c * 1000).intValue();    
    trackingId=(!Test.isRunningTest())?objSRS.endRenewal(objConEle, quoteNumber):'';    
    }
    catch(Exception e){
    IntegrationLogger.addMessage(String.ValueOf(e),quoteNumber, 'Quote','', 'Outbound','WebserviceResponseHandler',false);
    } 
    return trackingId;
}
}