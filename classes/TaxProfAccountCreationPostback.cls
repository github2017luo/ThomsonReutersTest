/*Created for Postback response form Boomi for integration of SAP
*   
============================================================================================
Date            Name               Description
08/02/2019     Gokila V        Created for TaX Professional ZPEND integration postback
03/02/2020     Roma            Updated the code to meet the requirement for E2E testing
============================================================================================
*/


@RestResource(urlMapping='/apttustaxprofzpendpostback/*')
global with sharing class TaxProfAccountCreationPostback
{
    
    static string customerNumber; 
    static String applicationId; 
    static String prevAcct;
    static String status1;
    //Variable to hold the integration message id for logging purposes
    public static String integrationMsgId; 
    public static String requestMsgPayload;  
    public static String oppID;
    public static String QuoteID;
                         
     
    @HttpPost
    global static status doPost(DellBoomiResponse AccountPostbackResponse_Input)
    {
        system.debug('Response from DellBoomi' +AccountPostbackResponse_Input);
        List<Integration_Logger__c> intLogList;
        List<Integration_Logger__c> intLogListHandshake;
        Id ssdId;
        status st = new status ();   
        List<Business_Partner_Function__c> listBusinessPartnerFunctions = new List<Business_Partner_Function__c>();   
        customerNumber=AccountPostbackResponse_Input.customerNumber;     
        applicationId = AccountPostbackResponse_Input.BOOMIHeader.applicationId;              
        prevAcct=AccountPostbackResponse_Input.prevAcct;
        status1= AccountPostbackResponse_Input.status;
        String serviceName, exceptionMsg, requestMsg;
        if(applicationId == 'SF12'){
            serviceName = 'ZPND Postback';
            exceptionMsg = 'Postback Rejected.';
            requestMsg = 'ZPND PostBack.\n';
        }else if(applicationId == 'SF12-ZPND_Handshake'){
            serviceName = 'Create Tax Account SSD';
            exceptionMsg = 'Handshake Rejected.';
            requestMsg = 'ZPND Handshake.\n';
        }
            
        //String serviceName1 = 'Create Tax Account SSD';
        String ObjName = 'Quote/Proposal';
        requestMsgPayload = JSON.serialize(AccountPostbackResponse_Input);
        String prevRequestMsg = '';
        String prevExcepMsg = '';
        try{
            if(Schema.sObjectType.Integration_Logger__c.isAccessible()){
                intLogList=[Select Id, Request_Message__c, Exception_Message__c, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:AccountPostbackResponse_Input.externalAccountId and Service_Name__c = :serviceName];
                System.debug('intLogListQuo-->'+intLogList);
                if(applicationId == 'SF12-ZPND_Handshake'){
                    prevRequestMsg = intLogList[0].Request_Message__c + '\n\n';
                    prevExcepMsg = intLogList[0].Exception_Message__c + '\n\n';
                }
              }
           } 
         catch(Exception ex){
              System.debug('intLogList record not found : '+ex.getMessage()+ex.getLineNumber()); 
         }  
        
        try
        {
            system.debug('Rsponse from DellBoomi' +AccountPostbackResponse_Input);
            System.debug('TEST_RRRRRRRRR '+ AccountPostbackResponse_Input.externalAccountId);
            
            //integrationMsgId =IntegrationLogger.addMessage('', ssdId, 'Source System Detail', 'Postback Test', 'Outbound','Create SAP Customer',false);
                
            source_system_detail__c oSsdDetails = [Select ID,LCRM_Sales_Org__c, LCRM_Distribution_Channel__c, LCRM_Division_Code_Description__c, 
                                         LCRM_Industry__c, LCRM_Customer_Group__c, Name, Number_Street__c, City__c,Source_System_Account_Number__c,
                                        State__c, LCRM_Country_Code__c,Country__c, Postal_Code__c, LCRM_PO_Box__c, LCRM_Phone__c, LCRM_Fax__c, CurrencyIsoCode,
                                        LCRM_Street3__c, LCRM_Street4__c,OLC_Account_Number__c, RecordType.DeveloperName, LCRM_Name_2__c, LCRM_Name_3__c,LCRM_Street_2__c,County__c,LCRM_External_Trail_Acount_ID__c,LCRM_Tax_3__c,LCRM_Tax_4__c,LCRM_Tax_Number__c,LatAm_Tax_Number_Type__c 
                                        from source_system_detail__c  where Id = :AccountPostbackResponse_Input.externalAccountId];
            System.debug('TEST_RRRRRRRRR'+ oSsdDetails);  
                                        
           if(oSsdDetails!= null)
            {
                ssdId = oSsdDetails.Id;                       
                System.debug('Test $$$$$ '+ssdId);
                if(applicationId == 'SF12-ZPND_Handshake'){
                       st.statusDescription='Handshake Received Successfully by Salesforce '+AccountPostbackResponse_Input;
                       st.statusCode='200';
                        System.debug('TEST_RRRRRRRRR'+st.statusDescription);
                  }      
                else if(applicationId == 'SF12')
                {
                    if(AccountPostbackResponse_Input!=null)
                    {
                        if(AccountPostbackResponse_Input.customerNumber!=null)
                            oSsdDetails.Source_System_Account_Number__c=AccountPostbackResponse_Input.customerNumber;
                        if(AccountPostbackResponse_Input.prevAcct!=null)
                            oSsdDetails.LCRM_External_Trail_Acount_ID__c=AccountPostbackResponse_Input.prevAcct;               
                        update oSsdDetails;
                    }   
                    if(AccountPostbackResponse_Input.PartnerFunction !=null)  {
                        for(PartnerFunction oPartnter : AccountPostbackResponse_Input.partnerFunction){
                            Business_Partner_Function__c  oBusinessPartnerFunction=new Business_Partner_Function__c ();
                            oBusinessPartnerFunction.Sales_Org__c=oPartnter.salesOrg;
                            oBusinessPartnerFunction.Related_Account_GLI__c = AccountPostbackResponse_Input.externalAccountId;
                            oBusinessPartnerFunction.Sold_To_Account_GLI__c = AccountPostbackResponse_Input.externalAccountId;
                            if(BigRuleGenericSettings__c.getInstance('PF:'+oPartnter.functionId) != null){
                                oBusinessPartnerFunction.Relationship_Type__c = BigRuleGenericSettings__c.getInstance('PF:'+oPartnter.functionId).Value__c;               
                                listBusinessPartnerFunctions.add(oBusinessPartnerFunction);
                            }
                        }
                    } 
                    if(listBusinessPartnerFunctions != null && !listBusinessPartnerFunctions.isEmpty() && customerNumber != null){
                        insert listBusinessPartnerFunctions ;
                        st.statusDescription='Received Successfully by Salesforce '+AccountPostbackResponse_Input;
                        st.statusCode='200';
                        System.debug('TEST_RRRRRRRRR'+st.statusDescription);
                        
                    }    
                }
            }
            else{ 
                st.statusCode='404';  
                st.statusDescription='Not Received Source System Account Number';
                System.debug('POSTBACK TEST response$$$$$$$$$$$$$enteredsuccessmsg333333333333333'); 
            }
            if(intLogList!=null && intLogList.size()>=1)
            {
                IntegrationLogger.TaxupdateMessage(intLogList[0].Id, ((st.statusCode=='200')?true:false), prevExcepMsg + requestMsg + 'Response : '+JSON.serialize(st), prevRequestMsg + requestMsg + 'Request : '+requestMsgPayload); 
                System.debug('POSTBACK TEST response$$$$$$$$$$$$$enteredsuccessmsg1111111');
            }
            else
                IntegrationLogger.TaxprofOCAddMessage(requestMsg + 'Response : '+JSON.serialize(st),ssdId, 'Quote/Proposal', requestMsg + 'Request : '+requestMsgPayload, 'Inbound',serviceName,((st.statusCode=='200')?true:false),'',ssdId);
            
        }catch(Exception ex)
        {
            if(ex.getMessage().contains('The record you are attempting to edit, or one of its related records, is currently being modified by another user.')){
                doPost(AccountPostbackResponse_Input);
          }
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            st.statusDescription='Hand Something went wrong'+ex.getMessage()+ex.getLineNumber(); 
            st.statusCode='404';
            //Integration Logger
            system.debug('Error LineNumber: '+ex.getLineNumber());
            system.debug('Error Message: '+ex.getStackTraceString());
           
            if(intLogList!=null && intLogList.size()>=1){
                IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, prevExcepMsg + exceptionMsg + requestMsg + '\nException Message : '+ex.getMessage()+' \nException Trace : '+ex.getStackTraceString()+'\nResponse : '+JSON.serialize(st), prevRequestMsg + requestMsg + 'Request : '+requestMsgPayload ); 
            }else{
                IntegrationLogger.TaxprofOCAddMessage(requestMsg + exceptionMsg + '\nException Message : '+ex.getMessage()+' \nException Trace : '+ex.getStackTraceString()+'\nResponse : '+JSON.serialize(st),ssdId, 'Quote/Proposal', requestMsg + 'Request : '+requestMsgPayload, 'Inbound',serviceName,false,'',ssdId);
            }
        }          
        return st;
    }  
      
    global class DellBoomiResponse{
        global BOOMIHeader BOOMIHeader;
        global List<confirmations> confirmations;
        global string trackingId;
        global string customerNumber;
        public string externalAccountId;
        global string prevAcct;
        global List<PartnerFunction> partnerFunction;
        global string status;
    }
    
    global class BOOMIHeader {
        public String applicationId;    //SF12
        public String timeStamp;    //20190528 000000.000
        public string transactionId;
        public string messageId;
        public string messageHistory;
        public string tracingId;
        public string instanceId;
        public string companyId;
        public string configGroup;
        public string payloadVersion;
        public string postBackURL;
        
        public BOOMIHeader()
        {
            applicationId='';
            timeStamp='';
            transactionId='';
            messageId='';
            messageHistory='';
            tracingId='';
            instanceId='';
            companyId='';
            configGroup='';
            payloadVersion='';
            postBackURL='';
        } 
    }
    
    global class confirmations {
       public string serviceNoteNumber;
       public string trackingID;
       public string serviceNoteMessage;
       public string messageSeverity;
       //  public list<extensibleAttributes> extensibleAttributes;
         
       
       public confirmations()
       {
           serviceNoteNumber='';
           trackingID='';
           serviceNoteMessage='';
           messageSeverity='';
       }       
   
    }
   /*  public class extensibleAttributes{
        public string key;
        public string value;
        
        public extensibleAttributes(){
        key='';
        value='';
        }     
    }*/
   
   
   public class PartnerFunction{
        public string salesOrg;
        public string distChannel;
        public string division;
        public string functionId;
        public string counter;
        public string businessPartner;
        public string vendorCreditorNumber;
        public string contactNumber;
        public string personnalNumber;
        public string description;
        public string defaultPartner;        
        
        public PartnerFunction()
        {
            salesOrg='';
            distChannel='';
            division='';
            functionId='';
            counter='';
            businessPartner='';
            vendorCreditorNumber='';
            contactNumber='';
            personnalNumber='';
            description='';
            defaultPartner='';
        }
    }
    
    //variable to sent Status response from Apttus to DellBoomi.        
    global class status{
        global String statusCode;
        global String statusDescription;
        public string statusMessage;
        
        public status()
        {
            statusCode='';
            statusDescription='';
            statusMessage='';
        }
    }
    
}