/**
* CreateCustomerReviewPostback is a RESTful Service which updates the 
* CustomerReviewPostback sent by SAP on SFDC and returns the success
* message
*
* @author  Nandita Shet
* @version 2013-03-03
*/
/**
* CHANGE HISTORY
* =======================================================================
* Date           Name                 Description
* 2013-03-03     Nandita Shet         Created
* 2013-03-22     Srikanth Kuruva      Updated: converted from SOAP to RESTful Service
* =======================================================================
*/
@RestResource(urlMapping='/customerpostback/*')
global class CreateCustomerReviewPostback{
/*
* Updates the CustomerReviewPostback on Salesforce
*
* @param createdCustomerNumber  this is the SAPAccountNumber which is returned from the CreateCustomerWebservice response
* @param alternateCustomerNumber this is the original SAPAccountNumber which is sent from SAP 
* @param externalAccountId This is the SFDC Account Id corresponding to the CREATED_CUST_NUM
* @return success or failure message if the postback is updated on salesforce
*/
  //  webservice static updatePostbackResponse updatePostback(string createdCustomerNumber, string alternateCustomerNumber, string externalAccountId){
      @HttpPost
      global static CustomerReviewPostbackResponse handleCustomerReviewPostback(CustomerReviewPostbackRequest CustomerConfirmation){
          
          CustomerReviewPostbackResponse oUpdatePostbackResponse = new CustomerReviewPostbackResponse();
          Account oAccount,oAccountOrg;
          String integrationMsgId;
          
          try{
                
                if(!AppUtil.isEmpty(CustomerConfirmation.externalAccountId)){
                    //Create a log entry    
                    integrationMsgId =IntegrationLogger.addMessage('', CustomerConfirmation.externalAccountId, 'Account', '', 'Inbound','Create Customer Review Postback',true);
                    oAccount = new Account(Id = CustomerConfirmation.externalAccountId);
                    
                    if(!AppUtil.isEmpty(CustomerConfirmation.createdCustomerNumber)){
                        if(!AppUtil.isEmpty(CustomerConfirmation.alternateCustomerNumber) && CustomerConfirmation.alternateCustomerNumber != CustomerConfirmation.createdCustomerNumber){
                            //oAccount.Alternate_Customer_ID__c = CustomerConfirmation.alternateCustomerNumber;
                            //update oAccount;
                            for (Account oAcc : [Select Id, Name, SAPAccountNumber__c from Account where SAPAccountNumber__c=:CustomerConfirmation.alternateCustomerNumber or SAPAccountNumber__c=:CustomerConfirmation.createdCustomerNumber]){
                                if(oAcc.SAPAccountNumber__c == CustomerConfirmation.alternateCustomerNumber)
                                    oAccountOrg = oAcc;
                                else{
                                    //oAccount = new Account();
                                    oAccount = oAcc;
                                }
                            }
                            List<Opportunity> listOpportunity = [Select Original_Account__c from Opportunity where AccountId = :CustomerConfirmation.externalAccountId];
                            if(!listOpportunity.isEmpty()){
                                for(Opportunity oOpportunity : listOpportunity){
                                    oOpportunity.Original_Account__c = oAccount.SAPAccountNumber__c + ' - ' + oAccount.Name;
                                }
                                update listOpportunity;
                            }
                            //oAccountOrg = [Select Id from Account where SAPAccountNumber__c=:CustomerConfirmation.alternateCustomerNumber];
                            Merge oAccountOrg oAccount;
                        }
                    }else{
                        oUpdatePostbackResponse.sError = 'createdCustomerNumber is null';
                    }
                    
                }else{
                    oUpdatePostbackResponse.sError = 'externalAccountId is null';
                }
                    

           
            if(oUpdatePostbackResponse.sError==''){
                oUpdatePostbackResponse.bSuccess = true;
                if(!AppUtil.isEmpty(CustomerConfirmation.alternateCustomerNumber)){
                    oAccountOrg.Is_Customer_Review_Complete__c = true;                   
                    update oAccountOrg;
                }else{
                    oAccount.Is_Customer_Review_Complete__c = true;
                    update oAccount;
                }
                
            }else{
                    oUpdatePostbackResponse.bSuccess = false;
            }
           //Log  entry for success
            IntegrationLogger.updateMessage(integrationMsgId, true,'' );
          
           
        }catch(Exception ex){
            oUpdatePostbackResponse.bSuccess = false;
            oUpdatePostbackResponse.sError = ex.getMessage()+'. StackTraceString:'+ex.getStackTraceString();
            IntegrationLogger.updateMessage(integrationMsgId, false,'Line:'+ex.getLineNumber()+' Type:'+ex.getTypeName()+' **Exception: ' +ex.getMessage() );
        }
        
        
        /*populate and return updatePostbackResponse*/
                
        return oUpdatePostbackResponse;
    }
/*
* updatePostbackResponse wrapper class
*/
    global class CustomerReviewPostbackResponse{
        global Boolean bSuccess;
        global String sError;
        
        public CustomerReviewPostbackResponse(){
            sError='';
        }
    
    }  
/*
*  Request wrapper class 
*/   
    global class CustomerReviewPostbackRequest {
        global String createdCustomerNumber;
        global String alternateCustomerNumber;
        global String externalAccountId;
        global String productId;
        global String status;        
        global String transId;
    }
  
}