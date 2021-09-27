/********************************************************************************
Class Name : MTRCommonUtility
Description : This is utility class for My TR across functionalities
********************************************************************************
Modification Details:
Date                    Description                          Owner
03/07/2019              Created                              Deepika Motamarri
24/3/2021               added logic for                      Saravana Kumar Balasubramaniam
                        send email
06/04/2021             Added logic on switch statement               Deepthi KB
                       when 'SUPPORTEDLOCALE' ,DUE-9614
21/07/2021             Added logic on switch statement
                       when 'SOURCENAME', DUE-11998          Pragati Goyal
*********************************************************************************/
/**
 * @description MTRCommonUtility is the utility class to hold common methods
 */
public without sharing class MTRCommonUtility{ 

    //Declare API error codes for help and support
    public static final String CONTACT_IS_MISSING = 'The contact id is missing in the request';
    public static final String INVALID_CONTACT = 'The contact id passed is invalid, it does not exists in salesforce';
    public static final String INVALID_BU = 'Error :Either business unit is not provided or Invalid values has been passed';
    public  static final String INVALID_OPERATION = 'Error :Either operation is not provided or Invalid value has been passed';
    public static final String IMPROPER_REQUEST_FORMAT = 'The request format is improper';
    public static final String ACCOUNT_MISSING = 'Either the SAP account number is missing or the GLI account is missing';
    public static final String QUERY_TYPE_MISSING = 'The query type is not confirgured in salesforce';
    public static final String SFDC_PRODUCT_MAPPING = 'Either the salesforce product is missing or the mapping is missing';
    public static final String QUERY_TYPE_NOT_PROVIDED = 'The query type is not provided';
    public static final String REASON_CODE_NOT_PROVIDED= 'Error: Reason code is not provided';
    public static final String SAP_ACCOUNT_NOT_PASSED = 'Error : SAP Account number has not been passed or one of the contact IDs is blank';
    public static final String SSD_NOT_AVAILABLE = 'Error : Either the SSD record is not available or it is not associated to any GLI account ';
    public static final String OTHER_VALUES_NOT_PASSED ='Error : One of the following values are missing - last/first name, email or role';
    public static final String BUSINESS_UNIT_NOT_CONFIG ='Error : Business unit not configured';
    public static final String MYTR_ORIGIN = 'My TR';
    public  static final String MYTR_ESC_UNIQUE_IDENTIFIER = 'MTRWEB';
    public static final String UE_ESC_UNIQUE_IDENTIFIER = 'UEACCOUNTWEB';
    public static final String MYTR_ESC_GEOGRAPHIC_IMPACT = 'Country';
    public static final String PRODUCT_MISSING = 'The Risk Product is missing';
    public static final String REGION_SEGMENT_DATA_MISSING = 'The Region Segment data is not configured in salesforce';
    public  static final String BU_REGION_MISSING = 'The Region on Contact related Account is missing';
    public final static string RISKBU ='RISK';
    public final static string TAXBU ='TAX';
    public final static string RISK_PROCESS_ERROR ='MTR Email Configuration returned empty rows for RISK BU';
    public final static string TAX_PROCESS_ERROR ='MTR Email Configuration returned empty rows for TAX BU';
    public final static string INVALID_CASE ='Case does not exist';
    public final static string INCORRECT_REASONID ='Incorrect resonID provided';
    public final static string SOURCE_MISSING ='Source missing';
    public final static string UNSUPPORTED_LANGUAGE ='This language is not supported for the given Business Unit';
    public final static string AGENT_FILES_CANNOT_BE_DELETED ='Error: This file cannot be deleted';


    //Declare variables
    public static Map<String,MTR_User_Management_Setting__mdt> systemName = new Map<String,MTR_User_Management_Setting__mdt>();
    //public static Map<String,String> sourceName = new Map<String,MTR_User_Management_Setting__mdt>();
        
    
    /*******************************************************************************************
     * @description This method retrieves the user settings and returns data appropriately
     * @param key as source or setting
     * @param val value as GLI or S2E
     * @return String
     *****************************************************************************************/
    public static String userSettings(String key, String val){
   
        //Retrieve the details from custom metadata if data not available
        if(systemName.IsEmpty()){
            systemName = new Map<String,MTR_User_Management_Setting__mdt>();
            //sourceName = new Map<String,String>();
            
            for(MTR_User_Management_Setting__mdt umSetting : [Select id,DeveloperName,Supported_Locales__c,Source_Name__c,System__c from MTR_User_Management_Setting__mdt WHERE System__c != '' LIMIT 30]){
                
                //if(!String.IsBlank(umSetting.System__c)){
                    systemName.put(umSetting.DeveloperName,umSetting);
                //}
                /**else{
                    SourceName.put(umSetting.DeveloperName,umSetting.Source_Name__c);
                } **/
            }//end of for
         }//end of if  
         
         String returnValue = '';

         switch on key {
             
             when 'SYSTEM'{
                 //returnValue =  (systemName.get(val)).System__c;
                 returnValue = (((systemName.get(val)))==null)?'':(systemName.get(val)).System__c;

             }
             when 'SUPPORTEDLOCALE'{
                if(systemName.containsKey(UECaseManagementService.businessUnit)){
                MTR_User_Management_Setting__mdt  um= systemName.get(UECaseManagementService.businessUnit);
                return returnValue=um.Supported_Locales__c;
                }

             } 
             when 'BUSINESSUNIT' {
                 returnValue = (((systemName.get(val)))==null)?'':'VALID'; 
             }
             when 'SOURCENAME' {
                returnValue = (((systemName.get(val)))==null)?'':(systemName.get(val)).Source_Name__c; 
            }
            
         }
   
         /*if(returnValue == null){
             returnValue = '';
         }*/
         return returnValue;
    
    }//end of usersettings
    
    /*******************************************************************************************
    @description Invoke method from process builder | used to send email to TAX users(contacts)
    @param  listMTRCaseIDs
    *******************************************************************************************/
    @InvocableMethod
    public static void mtrSendCreateCaseNotification(List<ID> listMTRCaseIDs){
        Case mtrCase=[select Id,ContactId,Contact.Email,ESC_Product_Segment_Brand__c,MYTR_Category__c,Origin,
                  SuppliedEmail,LCRM_Sub_BU__c,BU_Segment__c,ESC_Product_Title__c,UE_Language_Locale__c
                 from Case where Id =:listMTRCaseIDs[0] with SECURITY_ENFORCED];
        try{     
            if(mtrCase.ESC_Product_Segment_Brand__c =='Risk'){
                executeProcessRisk(mtrCase);
            }else{
                executeOtherProcess(mtrCase);
            }
        }Catch(Exception e){
            System.debug(LoggingLevel.DEBUG,'Exception from mtrSendCreateCaseNotification----'+e.getMessage());
            ApplicationLogUtility.logException('MY TR' , 'MTRCommonUtility' , 'mtrSendCreateCaseNotification' , e);
        }
    }
    /*******************************************************************************************
     * @description RISK related process to send Email and create EmailMessage
     * @param mtrCase
     *****************************************************************************************/

    public static void executeProcessRisk(Case mtrCase){
        String productTitle;
        
        EmailFields oEmail= new EmailFields();
        productTitle = mtrCase.ESC_Product_Title__c;
        
        List<MTR_Email_Configuration__mdt> emailConfigList = queryEmailConfiguartion(RISKBU,productTitle);
        if(!emailConfigList.isEmpty() ){
              oEmail = populateEmailFields(mtrCase,emailConfigList[0]);
              invokeSendSingleEmail(oEmail);
        }else{
            throw new CustomException(RISK_PROCESS_ERROR);
            //system.debug('MTR Email Configuration returned empty rows for RISK BU');
        }
    }
    /*******************************************************************************************
     * @description Other process to send Email and create EmailMessage
     * @param mtrCase
     *****************************************************************************************/

    // Other process to send Email and create EmailMessage
    public static void executeOtherProcess(Case mtrCase){    
        EmailFields oEmail= new EmailFields();

        List<MTR_Email_Configuration__mdt> emailConfigList = queryEmailConfiguartion(mtrCase);
        if(!emailConfigList.isEmpty() ){
            oEmail = populateEmailFields(mtrCase,emailConfigList[0]);

            //condition added as part of DUE-8312
            //Condition to send email when send_email field is checked and source field equals case_orgin field
           if(emailconfigList[0].Send_Email__c){
                invokeSendSingleEmail(oEmail);
           }
                  
        }else{
            throw new CustomException(TAX_PROCESS_ERROR);
           // system.debug('MTR Email Configuration returned empty rows for TAX');
        } 
    }
    /*******************************************************************************************
     * @description Query the MTR_Email_Configuration__mdt custom metadata obj to get Template,
     *   From Email, ReplyTo email Label names for given BU.
     * @param bu
     * @param productTitle
     * @return List<MTR_Email_Configuration__mdt>
     *****************************************************************************************/

    public static List<MTR_Email_Configuration__mdt> queryEmailConfiguartion(String bu,String productTitle){
        List<MTR_Email_Configuration__mdt> emailConfigList = new List<MTR_Email_Configuration__mdt>();
        emailConfigList=[select Email_Template__c,From_Address__c,ReplyTo_Address__c from MTR_Email_Configuration__mdt where Business_Unit__c=:bu and Product_Title__c=:productTitle with SECURITY_ENFORCED];
        
        return emailConfigList;
    }
    /*******************************************************************************************
     * @description Changes made as part of DUE-7106 | Method Overloaded for the processes other 
     * than risk- Query the MTR_Email_Configuration__mdt custom metadata obj to get Template, 
     * From Email, ReplyTo email Label names for given region and segment 
     * @param mtrCase
     * @return List<MTR_Email_Configuration__mdt>
     *****************************************************************************************/

    public static List<MTR_Email_Configuration__mdt> queryEmailConfiguartion(Case mtrCase){
        List<MTR_Email_Configuration__mdt> emailConfigList = new List<MTR_Email_Configuration__mdt>();
        emailConfigList=[select Email_Template__c,Send_Email__c,From_Address__c,ReplyTo_Address__c,Source__c from MTR_Email_Configuration__mdt where Source__c =: mtrCase.Origin and 
                        Region__c =: mtrCase.LCRM_Sub_BU__c and Segment__c =: mtrCase.BU_Segment__c and Language__c =: mtrCase.UE_Language_Locale__c with SECURITY_ENFORCED];
        return emailConfigList;
        
        //Need to add Langugae criteria in query once langugae field is finalized
    }
    /*******************************************************************************************
     * @description Builds the Emailields object which we use in invokeSendSingleEmail method.
     * @param oCase
     * @param emailConfig
     * @return EmailFields
     *****************************************************************************************/

    public static EmailFields populateEmailFields(Case oCase,MTR_Email_Configuration__mdt emailConfig){
        EmailFields emailFields = new EmailFields();
        List<String> address = new List<String>();
        
        //Changes made as part of DUE-7106
        if(oCase.SuppliedEmail !=null || oCase.SuppliedEmail !=''){
            address.add(oCase.SuppliedEmail);
        }
        if(oCase.origin == MYTR_ORIGIN){
            address.add(oCase.Contact.Email);
        } 
        
        
        emailFields.toAddress=address;
        emailFields.targetObjectId =oCase.ContactId;
        emailFields.whatId=oCase.Id;
        
        Map<String,OrgWideEmailAddress> orgEmailAdd = new Map<String,OrgWideEmailAddress>();
        List<EmailTemplate> template=[SELECT Id FROM EmailTemplate 
                             WHERE DeveloperName =:emailConfig.Email_Template__c  with SECURITY_ENFORCED];
        
        if(!template.isEmpty()){
          emailFields.templateId = template[0].Id;
        }
        
        for(OrgWideEmailAddress owd:[Select Id, Address, DisplayName from OrgWideEmailAddress where 
                                     DisplayName =:emailConfig.From_Address__c or 
                                     DisplayName =:emailConfig.ReplyTo_Address__c with SECURITY_ENFORCED]){
            orgEmailAdd.put(owd.DisplayName, owd);
        }
        
        //Changes made as part of DUE-7106
        if(orgEmailAdd.containsKey(emailConfig.From_Address__c)){
            emailFields.orgWideEmailAddressId= orgEmailAdd.get(emailConfig.From_Address__c).Id; 
            emailFields.fromAddress=  orgEmailAdd.get(emailConfig.From_Address__c).Address;       
        }
        
        if(orgEmailAdd.containsKey(emailConfig.ReplyTo_Address__c)){
            emailFields.replyTo= orgEmailAdd.get(emailConfig.ReplyTo_Address__c).Address;
        }
   
        return emailFields;
    }
    /*******************************************************************************************
     * @description sends SingleEmailMessage to the Contact's Email + Case supplied Email
     *   if provided and Creates EmailMessage object. 
     * @param emailFields
     *****************************************************************************************/

    public static void invokeSendSingleEmail(EmailFields emailFields){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.toAddresses =emailFields.toAddress; 
        mail.setTemplateId(emailFields.templateId);   
        mail.setTargetObjectId(emailFields.targetObjectId);
        mail.setWhatId(emailFields.whatId);
        mail.setOrgWideEmailAddressId(emailFields.orgWideEmailAddressId);
        mail.setReplyTo(emailFields.replyTo);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        system.debug(LoggingLevel.DEBUG,'SingleEmailMessage--'+mail);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
        Messaging.SendEmailResult[] results= Messaging.sendEmail(messages,false);
        if (results[0].success) {
              System.debug(LoggingLevel.DEBUG,'The email was sent successfully.');
        } else {
              System.debug(LoggingLevel.DEBUG,'The email failed to send: ' + results[0].errors);
        }
        //creates EmailMessage object for the Case Record.
        EmailMessage emailForCase = new EmailMessage();
        emailForCase.toAddress = emailFields.toAddress[0];
        emailForCase.fromAddress = emailFields.fromAddress;
        emailForCase.Subject = mail.subject;
        emailForCase.ParentId = emailFields.whatId;
        emailForCase.htmlBody = mail.htmlBody;
        if(Schema.sObjectType.EmailMessage.isCreateable()){
             insert emailForCase;
        }
    }
    
    /*******************************************************************************************
     * @description INner class to hole field names    
     *****************************************************************************************/

    public class EmailFields {
        String templateId;
        List<String> toAddress;
        String targetObjectId;
        String whatId;
        String orgWideEmailAddressId;
        String replyTo;
        String fromAddress;
        /*************************************************************
        @description This is the constructor
        ********************************************************************/
        public EmailFields(){
            templateId = '';
        }
    }
    /*******************************************************************************************
     * @description Custom Exception  
     *****************************************************************************************/
    public class CustomException extends Exception {}
}