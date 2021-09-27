/********************************************************************************************
    ClassName: RenewalRequestController
    Description: Class represent the logic for Submit Remove and Cancel renewal functionality.
    DevelopedBy: Sushen Adhikary 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
public with sharing class RenewalRequestController {
    public Renewal_Request__c objRR {get; set;}    
    public String sSubmitSuccess {get; set;}
    public String sType {get; set;}
    
    Quote objQuote;
    
    String sOppId = '';
    String sQuoteId = '';    
    String sRemoveRecordTypeId = '';       
    
    /********************************************************************************************
    ConstructorName: RenewalRequestController
    Description: Constructor initiates variable and fetching parameters of URL.
    DevelopedBy: Sushen Adhikary 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public RenewalRequestController() {    
        try {
            objRR = new Renewal_Request__c();
            sSubmitSuccess = '';
            sType = '';
            //System.Debug(ApexPages.currentPage());
           // System.Debug(ApexPages.currentPage().getParameters());

            if(ApexPages.currentPage().getParameters().get('quoteId') != null){
                sQuoteId = ApexPages.currentPage().getParameters().get('quoteId');            
            }
            //sQuoteId = '0Q0S00000009LUs';
            System.Debug('sQuoteId='+ sQuoteId);
            
            if(ApexPages.currentPage().getParameters().get('type') != null){
                sType = ApexPages.currentPage().getParameters().get('type');            
            }
            System.Debug('sType='+ sType);
            
            objQuote = [SELECT Id, AccountID,QuoteNumber,SAP_Quote_Number__c, OpportunityId, Status, Activity_Type__c, Remove_Renewal_Requested__c, Remove_Reason__c, Renewal_Request__c, Remove_Renewal_Comments__c, Remove_Renewal_Update_Status__c, RecordTypeId, RecordType.DeveloperName, Renewal_Flag_Formula__c, Sales_Org__c, Opportunity.StageName, Pricing_Approval_Required__c, Approval_Status__c, Primary_Quote__c, Product_Count__c, Is_Child_Quote_MSaf__c, Is_Master_Quote__c  FROM Quote WHERE Id =: sQuoteId LIMIT 1];           
            sOppId = '';
            if(objQuote.OpportunityId != null){
                sOppId = objQuote.OpportunityId;
            }       
            
            sRemoveRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote' AND DeveloperName = 'LATAM_Remove_Renewal_Quote' LIMIT 1].Id;
            //checkRecursive.isCreateCaseOnce = true;
            System.Debug('AMAN TEST - sRemoveRecordTypeId='+ sRemoveRecordTypeId);
        }
        catch(DmlException ex) {
            System.Debug('Exception occured on the class initiate, Constructor = RenewalRequestController, Class = RenewalRequestController, ERROR='+ ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));            
        }
    }
    
    /********************************************************************************************
    MethodName: saveRenewalRequest
    Description: Method is called on the click of Submit button of Remove and Cancel popup window.
    DevelopedBy: Sushen Adhikary
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public void saveRenewalRequest()
    {   
        sSubmitSuccess = '';
        
        if(sType == 'Remove'){
            processRemoveRequest();
        }
        else if(sType == 'FullCancel'){
            processCancelRequest();
        }
    }
    
    /********************************************************************************************
    MethodName: getCompetitorName
    Description: This method is being called from RenewalRequestPage to get values for Competitor_Name__c field depending on values chosen for Was_There_a_Competitor__c
    DevelopedBy: Anshu Thakur 
    Created date: 22-Aug-2016
    *********************************************************************************************/
    public boolean getCompetitorName() 
    {
        System.debug('###Inside CompetitorName ###');
        IF(objRR.Was_There_a_Competitor__c == null)
        {
            return true;
        }
        IF(objRR.Was_There_a_Competitor__c=='Unknown' || objRR.Was_There_a_Competitor__c=='No')
        {
            return false;
        }
        IF(objRR.Was_There_a_Competitor__c=='Yes')
        {
            return true;
        }
        else 
            return false;
    }
    
    /********************************************************************************************
    MethodName: processRemoveRequest
    Description: Method is called from the method "saveRenewalRequest". 
                 It contains the logic of Remove renewal functionality.
    DevelopedBy: Sushen Adhikary 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    private void processRemoveRequest()
    {
        try {               
            //Preparing Quote for update 
            Quote objUpdateQty = new Quote();
            objUpdateQty.Id = objQuote.Id;  
            objUpdateQty.Status = 'Remove';
            objUpdateQty.Activity_Type__c = 'Removed';
            //objUpdateQty.Approval_Status__c = 'Removed';
            objUpdateQty.Remove_Renewal_Requested__c = true;          
            objUpdateQty.Remove_Renewal_Update_Status__c = 'Open';
            objUpdateQty.RecordTypeId = sRemoveRecordTypeId;  
            objUpdateQty.IsSkipQtyLockingValidation__c = true; 
            
            //  
            Quote objUncheckQuote = new Quote();
            objUncheckQuote.Id = objQuote.Id;   
            objUncheckQuote.IsSkipQtyLockingValidation__c = false;  
            
            //Preparing Quote Line Item for update
            List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();
            for(QuoteLineItem qll : [SELECT Id, Status__c, Item_Activity_Type__c FROM QuoteLineItem WHERE QuoteId =: sQuoteId]){
                qll.Status__c = 'Remove';
                qll.Item_Activity_Type__c = 'Removed';
                lstQLI.add(qll);
            }
            
            //Preparing Quote Line Item for update
            List<OpportunityLineItem> lstOppLI = new List<OpportunityLineItem>();
            for(OpportunityLineItem opli : [SELECT Id, Active_Status__c, Activity_Type__c FROM OpportunityLineItem WHERE OpportunityId =: sOppId]){
                opli.Active_Status__c = 'Remove';
                opli.Activity_Type__c = 'Removed';
                lstOppLI.add(opli);
            }
            
            //Preparing Renewal Request for insert.             
            objRR.Quote__c = sQuoteId;          
            objRR.Opportunity__c = sOppId;
            objRR.Request_Type__c = 'Remove'; 
            objRR.Name = 'Remove Renewal - ' + System.today().format();               
            
           // WebserviceResponseHandler.removeRenewalFromSAP(objQuote, objRR, objUpdateQty);
            
            //web service call out.
            String sWBResponseDes = '';
            String sTrackingId = '';
            
            try{
                if(objQuote.SAP_Quote_Number__c != null){
                
                    sTrackingId = WebserviceResponseHandler.updateSAPQuote(objQuote.SAP_Quote_Number__c);
                    system.debug('sTrackingId '+sTrackingId );
                }
                else{
                    sWBResponseDes = 'Unable to update SAP system due to SAP Quote Number is null.';
                }
                
                System.Debug('sTrackingId='+ sTrackingId);
            }
            catch(Exception ex) {
                System.Debug('Exception occured on webService call out, Method = removeRenewalFromSAP, Class = WebserviceResponseHandler, ERROR='+ ex);                      
                sWBResponseDes = ex.getMessage();
            }
            
            //
            objRR.SAP_Remove_Renewal_Status_Description__c = sWBResponseDes;
            UPSERT objRR;  
            objUpdateQty.Renewal_Request__c = objRR.ID; 
            system.debug('>>>>>Quote record before update'+objUpdateQty);        
            UPDATE objUpdateQty;
            
            if(lstQLI.size() > 0){
                UPDATE lstQLI;
            }            
            
            //
            UPDATE objUncheckQuote;
            
            try{
                //Update Opp for bypassing the Opp validation rule.
                Opportunity objUpdateOpp = new Opportunity();
                objUpdateOpp.Id = sOppId;
                objUpdateOpp.Approval_Status__c = 'Pending Removal';
                objUpdateOpp.IsSkipOppLockingValidation__c = true; //Added by Piyali
                UPDATE objUpdateOpp;                
                
                //
                objUpdateOpp.IsSkipOppLockingValidation__c = false; //Added by Piyali
                System.Debug('In failure, objUpdateOpp='+ objUpdateOpp);
                //update oli after IsSkipOppLockingValidation__c = true on opportunity
                
                if(lstOppLI.size() > 0){
                    UPDATE lstOppLI;
                    System.Debug('lstOppLI='+ lstOppLI);
                }                 
                
                UPDATE objUpdateOpp; 
                system.debug('In failure, final objUpdateOpp='+objUpdateOpp);
            }
            catch(Exception ex) {
                System.Debug('Exception occured for Opp update on webService failure, Method = processRemoveRequest, Class = RenewalRequestController, ERROR='+ ex);                                    
            }
            
            if(sTrackingId != ''){ // WebService Success block
                System.Debug('Web Service call out is success for Remove Renewal. Method=processRemoveRequest, Class=RenewalRequestController, sTrackingId='+ sTrackingId);
                
                sTrackingId = 'SAP Tracking Id='+ sTrackingId;
                List<Quote> lstTempQuote = new List<Quote>();   
                lstTempQuote.add(objQuote);
                WebserviceResponseHandler.updateQuoteOnRemoveSuccess(lstTempQuote, sTrackingId);                    
            }
            else{ // WebService fail block
                System.Debug('Web Service call out is failed for Remove Renewal. Method=processRemoveRequest, Class=RenewalRequestController');
                
                try{
                    Quote objUpdateQuote = new Quote();
                    objUpdateQuote.Id = objQuote.Id;   
                    //objUpdateQuote.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote' AND DeveloperName = 'LATAM_Renewal_Quote' LIMIT 1].Id;
                    objUpdateQuote.Remove_Renewal_Update_Status__c = 'Open';
                    objUpdateQuote.SAP_Remove_Renewal_Request_Status__c = 'Failure';
                    objUpdateQuote.SAP_Remove_Renewal_Status_Description__c = sWBResponseDes;
                    objUpdateQuote.IsSkipQtyLockingValidation__c = true; 
                    UPDATE objUpdateQuote;
                    
                    //
                    UPDATE objUncheckQuote;
                    
                    //
                    objRR.Remove_Renewal_Update_Status__c = 'Open'; 
                    objRR.SAP_Remove_Renewal_Request_Status__c = 'Failure';                     
                    UPDATE objRR;
                }
                catch(Exception ex) {
                    System.Debug('Exception occured for final Quote update on webService failure, Method = processRemoveRequest, Class = RenewalRequestController, ERROR='+ ex);                                    
                }
                
                //Below method creates a new Case.      
                WebserviceResponseHandler.createNewCase(objQuote, 'Remove Renewal');                
            }     
            
            sSubmitSuccess = '1';
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm, 'Removal request is submitted successfully.'+ sTrackingId));
        }
        catch(DmlException ex) {
            System.Debug('Exception occured on Remove Request Submit, Method = processRemoveRequest, Class = RenewalRequestController, ERROR='+ ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));            
        }
    }
    
    /********************************************************************************************
    MethodName: processCancelRequest
    Description: Method is called from the method "saveRenewalRequest". 
                 It contains the logic of Cancel renewal functionality.
    DevelopedBy: Sushen Adhikary 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    private void processCancelRequest()
    {
        try {                   
            if(isValidQuoteForCancelRenewal() == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, System.Label.UnableToSubmitFullCancelRequest));                
                return;
            }            
            /*else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, 'Validation is ok.'));
                return;
            }*/
            System.Debug('After Quote Validation');
            
            String sPriorQtyStatus = 'Draft'; 
            if(objQuote.Status != null){
                sPriorQtyStatus = objQuote.Status;
            }
            
            String sPriorQtyAppStatus = ''; 
            if(objQuote.Approval_Status__c != null){
                sPriorQtyAppStatus = objQuote.Approval_Status__c;
            }
            
            //Preparing Quote for update.
            Quote objUpdateQty = new Quote(); 
            objUpdateQty.Id = sQuoteId;
            objUpdateQty.Status = 'MGT Approval – Pending Review';
            objUpdateQty.Approval_Status__c = 'Pending Cancellation Approval'; 
            objUpdateQty.IsSkipQtyLockingValidation__c = true;
            
            //Preparing Renewal Request for insert.         
            objRR.Quote__c = sQuoteId;          
            objRR.Opportunity__c = sOppId;
            objRR.Request_Type__c = 'Full Cancel'; 
            objRR.Name = 'Full Cancel - ' + System.today().format();           
            
            if(objQuote.Renewal_Request__c != null){
                objRR.Id = objQuote.Renewal_Request__c;
                if(objRR.Was_There_a_Competitor__c == 'No' || objRR.Was_There_a_Competitor__c == 'Unknown'){
                    objRR.Competitor_Name__c = null;
                }
            }
            
            System.debug('@@@objRR1 ='+objRR);
            UPSERT objRR;
            System.debug('@@@objRR2 ='+objRR);
            
            objUpdateQty.Renewal_Request__c = objRR.ID;            
            
            UPDATE objUpdateQty;              
            
            //
            Quote objLockQty = new Quote(); 
            objLockQty.Id = sQuoteId;
            objLockQty.IsSkipQtyLockingValidation__c = false; 
            UPDATE objLockQty;
            
            //
            try{
                //Update Opp for bypassing the Opp validation rule.
                Opportunity objUpdateOpp = new Opportunity();
                objUpdateOpp.Id = sOppId;
                objUpdateOpp.Approval_Status__c = 'Pending Cancellation Approval';
                objUpdateOpp.IsSkipOppLockingValidation__c = true;
                UPDATE objUpdateOpp; 

                //
                objUpdateOpp.IsSkipOppLockingValidation__c = false;
                UPDATE objUpdateOpp;    
            }
            catch(DmlException ex){
                System.Debug('Exception occured on Opp update., Method = processCancelRequest, Class = RenewalRequestController, ERROR='+ ex);
            }
            
            //***Start the logic for Initiate Quote record for manager approval process. ***//
            try{
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                //req.setComments('Submitted for Renewal Full Cancel. Please approve.');
                req.setObjectId(sQuoteId);           
                Approval.ProcessResult result = Approval.process(req);           
                System.debug('Submitted for approval successfully: '+ result.isSuccess());
            }
            catch(DmlException ex) {
                System.Debug('Exception occured on Quote entering to the approval process, Method = processCancelRequest, Class = RenewalRequestController, ERROR='+ ex);
                
                DELETE objRR;
                
                objUpdateQty.Status = sPriorQtyStatus;
                objUpdateQty.Approval_Status__c = sPriorQtyAppStatus; 
                objUpdateQty.Renewal_Request__c = null;
                UPDATE objUpdateQty;                
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, System.Label.UnableToSubmitFullCancelRequest));
                return; 
            }
            //***End the logic for Initiate Quote record for manager approval process. ***//
            
            sSubmitSuccess = '1';
        }
        catch(DmlException ex) {
            System.Debug('Exception occured on Cancel Request Submit, Method = processCancelRequest, Class = RenewalRequestController, ERROR='+ ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));            
        }
    }
    
    /********************************************************************************************
    MethodName: isValidQuoteForCancelRenewal
    Description: Method is called from the method "processCancelRequest". 
                 It validate Quote information before entering the Approval process "LATAM_Cancellation_Approval".
    DevelopedBy: Sushen Adhikary 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    private boolean isValidQuoteForCancelRenewal()
    {       
        Boolean flag = true;
        String sProfileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        String sManagerName = [SELECT ManagerId FROM USER WHERE Id =: UserInfo.getUserId() limit 1].ManagerId;
        
        system.debug('@@@In method isValidQuoteForCancelRenewal');
        
        if(sProfileName != 'LatAm User' && sProfileName != 'Partner Portal User' && sProfileName != 'System Administrator'){
            flag = false;  
            System.debug('step1='+ sProfileName);
        }       
        else if(objQuote.RecordType.DeveloperName != 'LATAM_Renewal_Quote'){
            flag = false;  
            System.debug('step2='+ objQuote.RecordType.DeveloperName);
        }  
        else if(objQuote.Renewal_Flag_Formula__c  == false){            
            flag = false;  
            System.debug('step3='+ objQuote.Renewal_Flag_Formula__c);
        } 
        else if(objQuote.Product_Count__c < 0 || objQuote.Product_Count__c == 0){
            flag = false; 
            System.debug('step 4');
        } 
        //else if(objQuote.Sales_Org__c  != 'FSCO' && objQuote.Sales_Org__c  != 'RV01' && objQuote.Sales_Org__c  != 'LPCL' && objQuote.Sales_Org__c  != 'LPTC' && objQuote.Sales_Org__c  != 'TSL' && objQuote.Sales_Org__c  != 'LLEY' && objQuote.Sales_Org__c  != 'LLPA' && objQuote.Sales_Org__c  != 'ABEP' && objQuote.Sales_Org__c  != 'LLUR' && objQuote.Sales_Org__c  != 'BEJE'){
        //else if(objQuote.Sales_Org__c  != 'FSCO' && objQuote.Sales_Org__c  != 'RV01' && objQuote.Sales_Org__c  != 'LPCL' && objQuote.Sales_Org__c  != 'LPTC' && objQuote.Sales_Org__c  != 'TSL' && objQuote.Sales_Org__c  != 'LLPA' && objQuote.Sales_Org__c  != 'LLEY' && objQuote.Sales_Org__c  != 'LLUR' && objQuote.Sales_Org__c  != 'BEJE'){ //REMOVED ABEP AND FSCO AS PART OF HERCULES-ARG AND HERCULES-BRA
        else if(objQuote.Sales_Org__c  != 'RV01' && objQuote.Sales_Org__c  != 'LPCL' && objQuote.Sales_Org__c  != 'LPTC' && objQuote.Sales_Org__c  != 'TSL' && objQuote.Sales_Org__c  != 'LLPA' && objQuote.Sales_Org__c  != 'LLEY' && objQuote.Sales_Org__c  != 'LLUR' && objQuote.Sales_Org__c  != 'BEJE'){
            flag = false; 
            System.debug('step5='+ objQuote.Sales_Org__c);
        }
        else if(objQuote.Opportunity.StageName != '25%' && objQuote.Opportunity.StageName != '50%' && objQuote.Opportunity.StageName != '75%' && objQuote.Opportunity.StageName != '90%'){
            flag = false; 
            System.debug('step6='+ objQuote.Opportunity.StageName);
        }
        else if(objQuote.Primary_Quote__c != true){
            flag = false; 
            System.debug('step 7');
        }
       /* else if(objQuote.Pricing_Approval_Required__c){
            flag = false;            
        }*/
        else if(objQuote.Approval_Status__c != null && objQuote.Approval_Status__c != 'Pending Cancellation Approval' && objQuote.Approval_Status__c != 'Cancellation Rejected'){
            flag = false; 
            System.debug('step8='+ objQuote.Approval_Status__c);
        }
        else if(objQuote.Is_Child_Quote_MSaf__c){
            flag = false;  
            System.debug('step9='+ objQuote.Is_Child_Quote_MSaf__c);
        }       
        else if(objQuote.Is_Master_Quote__c){
            flag = false;  
            System.debug('step10='+ objQuote.Is_Master_Quote__c);
        }
        else if(sManagerName == null){
            flag = false;  
            System.debug('step11='+ sManagerName);
        }
        System.debug('flag='+ flag);
        return flag;   
    }
}