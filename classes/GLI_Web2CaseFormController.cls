/**********************************
Class Name: GLI_Web2CaseFormController
Purpose:Controller for GLI_Web2CaseForm which is used in 
        Web2Case for GLI users.
JIRA: UKD-128/UKD-161
Author: Karthi G
Date Created:08/09/2017
Date Updated:Version0test
***********************************/

public without sharing class GLI_Web2CaseFormController {

    public String formheader { get; set; }
    public Case c { get; set; }    
    public boolean displayform { get; set; }
    public String acctnum { get; set; }
    public String invoicenumber { get; set; }
    public String productname { get; set; }
    public String firstname { get; set; }
    public String surname { get; set; }
    public String title { get; set; }
    public String address { get; set; }
    public String postcode { get; set; }
    public String hostURL {get;set;}
    public String strsource {get;set;}
    public String device {get;set;  }
    public String deviceos {get;set;}
    public Boolean isSiteDown {get;set;}
    public Boolean isGeneralForm {get;set;}
    public Boolean isTHForm {get;set;}
    public Boolean isOrderForm {get;set;}
    public Boolean isAdminForm {get;set;}
    public Boolean isOCSForm {get;set;}
    public Boolean isPPOForm {get;set;}
    public Boolean isPPOCMDForm {get;set;}
    public Boolean isCMDForm {get;set;}
    public Boolean isDiffForm {get;set;}
    public Boolean isMPForm {get;set;}
    public Boolean isICRForm {get;set;}
    public Boolean isCFForm {get;set;}
    public Boolean isGenReqTFForm{get;set;}
    public Boolean isPrintSales {get;set;}
    public Boolean isSalesSupport {get;set;}
    public Boolean isSolcara {get;set;}
    public Boolean isInternal {get;set;}
    public Boolean isComplaint {get;set;}
    public Boolean isContract {get;set;}
    public String casetype {get;set;}
    public boolean isNotSupported { get; set; }
    public boolean successPage { get; set; }
    public String natureofquery {get;set;}
    public String errorFields {get;set;}
    public string querySubject{get;set;}
    //public string querySubjectbilling{get;set;}
    public string queryOutcome{get;set;}
    public string repName{get;set;}
    public string repEmail{get;set;}
    public string jctUser{get;set;}
    public List<Attachment> newAttachments {get; set;}
    
    //added for DSS-8368
    public Boolean isCredit {get;set;}
    public string accountnumber{get;set;}
    public string creditReference{get;set;}
    public string refundAmount{get;set;}
    public string bankAccName{get;set;}
    public string bankName{get;set;}
    public string sortCode{get;set;}
    public string accNumber{get;set;}
    public string iBAN{get;set;}
    public string bic{get;set;}
    public string creditcomments{get;set;}
    public string userband{get;set;}
    
    //added for DSS-6019
    public Boolean isUKICommissions {get;set;}
    public String salesarea {get;set;}
    public String refNumber {get;set;}
    
    //added for DSS-6168
    public Boolean isCustSupport {get;set;}
    public Boolean isOProdSupport {get;set;}
    public Boolean isJCT {get;set;}
    public Boolean isDebit{get;set;}
    
    public String ordernum { get; set; }
    public String isbn { get; set; }
    public String pagesrequired { get; set; }
    public String quantity { get; set; }
    public String claimreason { get; set; }
    public String address1 { get; set; }
    public String town { get; set; }
    //public String county { get; set; }
    public String country { get; set; }
    public boolean checklist { get; set; }
    public boolean filinginstructions { get; set; }
    public List<String> titlelist {get; set;}
    public List<String> isbnlist {get; set;}
    public List<String> authorlist {get; set;}
    public string queueName{get;set;}
    public string businessName{get;set;}
    public string locationName{get;set;}
    public string querytypeName{get;set;}
    public string renewalName{get;set;}
    private static List<UKI_Static_Values__mdt> captchaConfig=[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt where MasterLabel='Web2Case reCaptcha Key'];
    
    public String publicKey { 
        get { 
            if(captchaConfig.size()>0){
                publicKey = String.valueOf(captchaConfig[0].UKI_Value__c);
            }
            else{
                 publicKey='';
            }
            return publicKey;
            }
            public set;
    } 

    
 public GLI_Web2CaseFormController(ApexPages.StandardController stdController){     
     displayform = true;
     successPage = false;
     isPrintSales = false;
     isSalesSupport = false;
     isSiteDown =false;
     titlelist  = new List<String>{'','',''};
     isbnlist  = new List<String>{'','',''};
     authorlist = new List<String>{'','',''};
     strsource = apexpages.currentpage().getparameters().get('source');
     c = new Case();
     hostURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();
     string s = Label.ESC_Web_Form_Spam_Blocker;
     string[] so = s.split(',');
     for(string s1 : so){
     if(strsource == s1){
        displayform = false;
        isSiteDown = true;
     }
     }
     if(strsource =='121'){
         formheader='General enquiry';
     }else if(strsource =='122'){
         formheader='Solcara Support';
     }
     //added for DSS-3451
     else if(strsource =='InternalSSUP'){
         formheader='Internal Form';
     }else if(strsource =='123'){
         formheader='Firmstyle Support';
     }else if(strsource =='117'){
         formheader='Online services';
     }else if(strsource =='118'){
         formheader='Technical Support';
     }else if(strsource =='120'){
         formheader='International customer service team';
     }else if(strsource =='116'){
         formheader='Online customer support';
     }else if(strsource =='115'){
         formheader='Print orders';
     }else if(strsource =='175'){
         formheader='Copy invoices';
         c.Subject =Label.GLI_W2C_QS_175;
     }else if(strsource =='102'){
         formheader='Adding and changing users';
     }else if(strsource =='113'){
         formheader='Practical Law Magazine enquiries';
     }else if(strsource =='109'){
         formheader='Product & Pricing Operations';
     }else if(strsource =='108'){
         formheader='Customer Master Data';
     }else if(strsource =='121MP'){
         formheader='Missing pages';
         c.Subject =Label.GLI_W2C_QS_121MP;
     }else if(strsource =='121CFI'){
         formheader='Checklists and filling instructions';
         c.Subject =Label.GLI_W2C_QS_121CFI;
     }else if(strsource =='115ICR'){
         formheader='Inspection Copies';
         c.Subject = Label.GLI_W2C_QS_115ICR;
     }
     else if(strsource== '115PSALE'){
          formheader='Print Sales';
         isPrintSales = true;
     }
      else if(strsource== '115SSUP'){
          formheader='Sales Support';
         isSalesSupport = true;
     }
     //added for DSS-3451. 
      else if(strsource== 'ESSUP'){
          formheader='Sales Support';
         
     }
     //added for DSS-6019
     else if(strsource== '124'){
          formheader='Commission Enquiries';     
     }
     //added for DSS-6168
     else if(strsource== '125'){
          formheader='Customer Support';     
     }
     else if(strsource== '126'){
          formheader='Online Product Support';     
     }
     else if(strsource == '127'){
          formheader = 'Lodging your complaint with Thomson Reuters';
     }
     else if(strsource== 'contract'){
          formheader = 'Contract Analysis';
     }
     //added for DSS-8368
     else if(strsource== 'credit'){
          formheader = 'Credit Refund';
     }
     //added for DSS-9594
     else if(strsource == 'JCT'){
         formheader = 'JCT Construct';
     }
     else if(strsource == 'DirectDebit'){
         formheader = 'Request for Payment via Direct Debit';
         }
     
    /* 
     if(strsource =='121' || strsource=='117' || strsource=='120' || strsource =='102' || strsource =='113'){
         isGeneralForm = true;
     }*/
     if(strsource=='117' || strsource =='102' ){
         isGeneralForm = true;
     }
     //added for DSS-3451. Just added ESSUP
     else if(strsource =='120' || strsource=='121'|| strsource =='113'||strsource=='ESSUP'){
         isGeneralForm = true;
         isGenReqTFForm= true;
     }
     //added for DSS-3451
     else if(strsource=='InternalSSUP'){
         isInternal= true;
     }
     else if(strsource=='122'){
         isGenReqTFForm= true;
         isSolcara = true;
     }
     else if(strsource=='115'){
         isGeneralForm = true;
         isOrderForm = true;
         isGenReqTFForm= true;
     }
     else if(strsource=='109'){
         isPPOForm = true;
         isPPOCMDForm = true;
     }
     else if(strsource=='108'){
        isCMDForm= true;
         isPPOCMDForm = true;
     }
     else if(strsource=='118'||strsource=='123'){
         isTHForm = true;
     }
     else if(strsource=='175'){
         isAdminForm = true;
     }
     else if(strsource=='116'){
         isOCSForm = true;
         isGenReqTFForm= true;
     }
     else if(strsource=='121MP'){
         isMPForm = true;
         isDiffForm = true;
     }
     else if(strsource=='115ICR'){
         isICRForm = true;
         isDiffForm = true;
     }
     else if(strsource=='121CFI'){
         isCFForm = true;
         isDiffForm = true;
     }
     else if(strsource=='124'){
        isUKICommissions = true;
     }
     else if(strsource=='125'){
        isCustSupport = true;
     }
     else if(strsource=='126'){
        isOProdSupport = true;
     }
     else if(strsource=='127'){
         isComplaint = true;
     }
     else if(strsource== 'contract'){
         isContract= true;
     }
     //added for DSS-8368
     else if(strsource== 'credit'){
         isCredit = true;
     }
    else if(strsource == 'JCT'){
         qsubject = 'JCT Construct - I would like to submit an enquiry';
         isJCT = true;
         tempJCTchanged = false;
     }
     else if (strsource == 'DirectDebit'){
         qsubject = 'I would like to sign up for Direct Debit';
         isDebit =true;
     }
     newAttachments = new List<Attachment>();
     for (Integer idx=0; idx<5; idx++)
        {
            newAttachments.add(new Attachment());
        }
     initializeAttachment();
 }
 private void initializeAttachment(){
     newAttachments = new List<Attachment>();
     for (Integer idx=0; idx<5; idx++)
        {
            newAttachments.add(new Attachment());
        }
 }
  public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            if(strsource =='121'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low','Name/address amendment'));
                options.add(new SelectOption('Request for Action;Billing;e-Invoicing;3 - Low','Billing enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Payment Inquiry;3 - Low','Payment enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Refund Request;3 - Low;;','Refund enquiry'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Tech Support;;Content Explanation;3 - Low','Incorrect or missing content'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment Not Received;2 - Medium','Order not received'));
                options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Information Request;3 - Low','Product enquiry'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment damaged;2 - Medium','Product damaged'));
            }
            //added for DSS-3451.
           else if(strsource =='ESSUP'){
                options.add(new SelectOption('Request for action;;;2 - Medium','General enquiry'));
            }
            else if(strsource =='122'){
                options.add(new SelectOption('Request for action;;;3 - Low','Support Request'));
                options.add(new SelectOption('Request for action;;;3 - Low','Professional Services (Installation, Upgrade, Migration)'));
                options.add(new SelectOption('Request for action;;;3 - Low','Connector Request'));
                options.add(new SelectOption('Request for action;;;3 - Low','Connector Issue'));
                options.add(new SelectOption('Request for action;;;3 - Low','General enquiry'));
                options.add(new SelectOption('Request for action;;;3 - Low','Billing Enquiry'));
                options.add(new SelectOption('Request for action;;;3 - Low','Product Enquiry'));
                options.add(new SelectOption('Request for action;;;3 - Low','Complaint'));
                
            }
            //added for DSS-3451
           /* else if(strsource =='InternalSSUP'){
                options.add(new SelectOption('Request for action;;;3 - Low','Support Request'));
        ///needs to develop
                
            }*/
             /* else if(strsource =='122'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low','Name/address amendment'));
                options.add(new SelectOption('Incident;Invoice Explanation;;3 - Low','Billing enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Payment Inquiry;3 - Low','Payment enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Refund Request;3 - Low;;','Refund enquiry'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Incident;Content Integrity;;3 - Low','Incorrect or missing content'));
                options.add(new SelectOption('Incident;Shipment Not Received;;2 - Medium','Order not received'));
                options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Information Request;3 - Low','Product enquiry'));
                options.add(new SelectOption('Incident;Shipment Damaged;Shipment damaged;2 - Medium','Product damaged'));
                
            }*/
            else if(strsource =='117'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low','Name/address amendment'));
                options.add(new SelectOption('Request for Action;Billing;e-Invoicing;3 - Low','Billing enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Payment Inquiry;3 - Low','Payment enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Refund Request;3 - Low;;','Refund enquiry'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low','Renewal cancellation'));
                options.add(new SelectOption('Request for Action;Order Processing;Order;2 - Medium','New order'));
            }
            else if(strsource =='175'){
                options.add(new SelectOption('Request for Action;Billing;Invoice/Billing Document Copy;3 - Low','Copy invoice'));
            }
            else if(strsource =='102'){
                options.add(new SelectOption('Request for Action;Entitlements;User ID Update/Swap;2 - Medium','Add / modify / inactivate user, reset password'));
            }
            else if(strsource =='120'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low','Name/address amendment'));
                options.add(new SelectOption('Request for Action;Billing;e-Invoicing;3 - Low','Billing enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Payment Inquiry;3 - Low','Payment enquiry'));
                options.add(new SelectOption('Request for Action;Cash Apps;Refund Request;3 - Low;;','Refund enquiry'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Legal Content;;Content Explanation;3 - Low','Incorrect or missing content'));
                options.add(new SelectOption('Request for Action;Order Processing;Order;2 - Medium','New order'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;1','Renewal change'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment Not Received;2 - Medium','Order not received'));
                options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Information Request;3 - Low','Product enquiry'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Product Return;3 - Low','Return request'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment damaged;2 - Medium','Product damaged'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;2','Renewal cancellation'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment Not Received;3 - Low','Subscription item missing'));
                
            }
            else if(strsource =='115'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Request for Action;Order Processing;Order;2 - Medium','New order'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;1','Renewal change'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Product Return;3 - Low','Return request'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;2','Renewal cancellation'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment Not Received;3 - Low','Subscription item missing'));
               
            }
             else if(strsource =='116'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Tech Support;;Configuration;3 - Low','Technical issue'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Legal Content;;Content Explanation;3 - Low','Content enquiry'));
                options.add(new SelectOption('Legal Content;;Content Explanation;3 - Low','Incorrect or missing content'));
                options.add(new SelectOption('Tech Support;;Login Issue;1 - High','Login failure'));
                options.add(new SelectOption('Tech Support;;Configuration;1 - High','Cannot access subscribed content'));
             }
             else if(strsource =='118' || strsource =='123'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Incident;Application Issue;;3 - Low','Technical issue'));
                options.add(new SelectOption('Feedback;Complaint;;3 - Low','Complaint'));
                options.add(new SelectOption('Tech Support;;Configuration;3 - Low','Incorrect or missing content'));
                options.add(new SelectOption('Tech Support;;Login Issue;1 - High','Login failure'));
                options.add(new SelectOption('Tech Support;;Configuration;1 - High','Cannot access subscribed content'));
                options.add(new SelectOption('Tech Support;;Configuration;2 - Medium','My Account'));
             }
             /*else if(strsource =='123'){
                options.add(new SelectOption('Incident;;;1 - High','General enquiry'));
                options.add(new SelectOption('Incident;;;1 - High','Technical issue'));
                options.add(new SelectOption('Incident;;;1 - High','Complaint'));
                options.add(new SelectOption('Incident;;;1 - High','Incorrect or missing content'));
                options.add(new SelectOption('Incident;;;1 - High','Login failure'));
                options.add(new SelectOption('Incident;;;1 - High','Cannot access subscribed content'));
                options.add(new SelectOption('Incident;;;1 - High','My Account'));
             } */
             else if(strsource =='109'){
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;1','Product - new'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;2','Product - amend'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;3','Product - terminate'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Information Request;3 - Low;4','Product - enquiry'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;5','Pricing - new'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;6','Pricing - amend'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;7','Pricing - terminate'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Information Request;3 - Low;8','Pricing - enquiry'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;9','Discount - new'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;10','Discount - amend'));
                options.add(new SelectOption('Request for Action;Product Master Data;Product or Price-New/Amend;3 - Low;11','Discount - terminate'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Information Request;3 - Low;12','Discount - enquiry'));
             }
             
             else if(strsource =='108'){
                options.add(new SelectOption('Request for Action;Account Master Data;Account Creation / Close;1 - High','Account Creation'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low;13','Address Change'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low;14','Contact Data Change'));
                options.add(new SelectOption('Request for Action;Account Master Data;Account Edit/Update;3 - Low;15','Account Name Change'));
                options.add(new SelectOption('Request for Action;Account Master Data;Customer Account Segmentation;3 - Low;16','Customer Account Segmentation'));
             }
            else if(strsource =='113'){
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
            }
            else if(isSalesSupport){
                options.add(new SelectOption('Request for Action;Billing;e-Invoicing;3 - Low','Billing enquiry'));
                 options.add(new SelectOption('Request for Action;Cash Apps;Payment Inquiry;3 - Low','Payment enquiry'));
                 options.add(new SelectOption('Legal Content;;Content Explanation;3 - Low','Content enquiry'));
                  options.add(new SelectOption('Request for Action;Order Processing;Order;2 - Medium','New order'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;1','Renewal change'));
                options.add(new SelectOption('Request for Action;Shipments & Delivery;Shipment Not Received;2 - Medium','Order not received'));
                 options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;2','Renewal cancellation'));
                 options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Information Request;3 - Low;4','Product - enquiry'));
            }
            else if(isPrintSales){
                options.add(new SelectOption('Request for Action;Billing;Invoice/Billing Document Copy;3 - Low','Copy invoice'));
                options.add(new SelectOption('Request for Action;Billing;e-Invoicing;3 - Low','Billing enquiry'));
                options.add(new SelectOption('Request for Action;Order Processing;Order;2 - Medium','New order'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Modify Subscription;3 - Low;1','Renewal change'));
                options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Information Request;3 - Low;4','Product - enquiry'));
                options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;3 - Low','General enquiry'));
                
            }
            else if(strsource =='DirectDebit'){
                options.add(new SelectOption('Request for Action;Cash Apps;Autopay Payment Method;3 - Low;1','I would like to sign up for Direct Debit'));
                options.add(new SelectOption('Request for Action;Cash Apps;Autopay Payment Method;3 - Low;2','Please Update my Direct Debit banking information'));
                options.add(new SelectOption('Request for Action;Cash Apps;Autopay Payment Method;3 - Low;3','Please cancel my Direct Debit'));
                options.add(new SelectOption('Request for Action;Cash Apps;Autopay Payment Method;3 - Low;4','I have a question about Direct Debit'));
            }
            return options;
        }   
    public List<SelectOption> getProductlist() {        
        Map<String,GLI_Webform_products__c> prodListmap = GLI_Webform_products__c.getall();
            Set<string> prodList =prodListmap.keySet();

    List<SelectOption> options = new List<SelectOption>();
    system.debug('*****selected value inside'+prodList);
     for(string  prod : prodList){

        options.add(new SelectOption(prod,prod));
      }
       system.debug('*****selected value inside'+options);
       return options;
      }
      public List<SelectOption> getSalesAreaList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('LPE','LPE'));
        options.add(new SelectOption('Corporate Legal','Corporate Legal'));
        options.add(new SelectOption('TaxA','TaxA'));
       return options;
      }
    public void attachfile(Case c1){
    List<Attachment> attlist = new List<Attachment>();
    system.debug('newAttachments:@ '+newAttachments);
    for(Attachment a: newAttachments){
        if(a.name!=null){
        a.parentid= c1.Id;
        attlist.add(a);
        }
    }
    if(Schema.sObjectType.Attachment.isAccessible() || Schema.sObjectType.Attachment.isCreateable()){
      Insert attlist;
    }
    if(attlist.size()>0){
       displayform=false;
       successPage= true;
       if(attlist.size()==1){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GLI_W2C_CaseSucess1+c1.CaseNumber+'</b>. '+ attlist.size() +' '+Label.GLI_W2C_CaseSuccess4+Label.GLI_W2C_CaseSuccess2));
       }
       if(attlist.size()>1){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GLI_W2C_CaseSucess1+c1.CaseNumber+'</b>. '+ attlist.size() +' '+Label.GLI_W2C_CaseSuccess3+Label.GLI_W2C_CaseSuccess2));
       }
     }
     else{
       displayform=false;
       successPage= true;
       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GLI_W2C_CaseSucess1 + c1.CaseNumber+Label.GLI_W2C_CaseSuccess2));
     }
}
  public pagereference submitCase(){     
    try{
        //system.debug('newAttachments 1 :@ '+newAttachments);
        System.debug('!!!2'+natureofquery);
        System.debug('!!!3'+queueName);
        String finalquerydetails;
        String checkboxvalue;
        List<String> casetypelist= new List<String>();
        /* Validation of required fields in forms - START- */
        ErrorFields='';
        List<String> requiredList;
        Map<String,String> parametersMap=New Map<String,String>();
        parametersMap.put('firstname',firstname);
        parametersMap.put('surname',surname);
        parametersMap.put('address',address);
        parametersMap.put('postcode',postcode);
        parametersMap.put('email',c.SuppliedEmail);
        parametersMap.put('Query',c.Description);
        parametersMap.put('productname',productname);
        parametersMap.put('invoicenumber',invoicenumber);
        parametersMap.put('pagesrequired',pagesrequired);
        parametersMap.put('quantity',quantity);
        parametersMap.put('claimreason',claimreason);
        parametersMap.put('town',town);
        parametersMap.put('country',country);
        parametersMap.put('institution',c.suppliedcompany);
        parametersMap.put('pubtitle1',titlelist[0]);
        parametersMap.put('isbn1',isbnlist[0]);
        parametersMap.put('author1',authorlist[0]);
        parametersMap.put('telePhone',c.SuppliedPhone);
        parametersMap.put('querySubject',c.Subject);
        parametersMap.put('repName',c.ESC_UKI_WebForm_Rep_Name__c);
        parametersMap.put('salesarea',salesarea);
        parametersMap.put('refNumber',refNumber);
        parametersMap.put('repEmail',c.ESC_UKI_WebForm_Rep_Email__c);
        parametersMap.put('queryOutcome',queryOutcome);
        //added for DSS-8368
        parametersMap.put('accountnumber',accountnumber);
        parametersMap.put('creditReference',creditReference);
        parametersMap.put('refundAmount',refundAmount);
        parametersMap.put('bankAccName',bankAccName);
        parametersMap.put('bankName',bankName);
        parametersMap.put('sortCode',sortCode);
        parametersMap.put('accNumber',accNumber);
        parametersMap.put('AcctNum',AcctNum);
        parametersMap.put('iBAN',iBAN);
        parametersMap.put('bic',bic);
        parametersMap.put('creditcomments',creditcomments);
        parametersMap.put('userband',userband);
        parametersMap.put('qsubject',qsubject);
        
        if(strsource=='121mp'){
            casetype = 'Request for Action;Orders, Pricing & subscriptions;Information request;3 - Low';
            requiredList= new List<String>{'productname','pagesrequired','quantity','claimreason','firstname','surname','town','postcode','country','email','telePhone','querySubject','address'};
        }
        else if(strsource=='121cfi'){
            casetype = 'Request for Action;Orders, Pricing & Subscriptions;Information Request;3 - Low';
            requiredList= new List<String>{'productname','firstname','surname','address','town','postcode','country','email','telePhone','querySubject'};
        }
        else if(strsource=='115icr'){
            casetype = 'Request for Action;Order Processing;Order;3 - Low';
            requiredList= new List<String>{'firstname','surname','address','town','postcode','country','email','institution','pubtitle1','isbn1','author1','telePhone','querySubject'};
        }
        else if(strsource=='JCT'){
            requiredList= new List<String>{'firstname','surname','address','town','postcode','country','email','telePhone','qsubject','Query'};
            if(tempJCTchanged && jctUserBand == 'None'){
                requiredList.add('userband');
            }
            boolean attach1 = true;
            system.debug('jct attachmnent1--->'+newAttachments);
             for(Attachment a: newAttachments){
                if(a.name!=null){
                    attach1 = false;
                    break;
            }
            }
            if(tempJCTchanged && attach1 && jctUserBand != '1' && jctUserBand != 'None'){
            system.debug('jct attachmnent--->'+newAttachments);
                throw new ESC_HandlerCustomException('attachmentrequired');
            }
        }
        //added for DSS-8368
        else if(strsource== 'credit'){
             casetype = 'Request for Action;Cash Apps;Refund Request;1 - High';
             requiredList= new List<String>{'firstname','surname','email','accountnumber','creditReference','refundAmount','bankAccName','bankName','sortCode','accNumber'};
        }
        else if(strsource=='109' || strsource=='108'){
         requiredList= new List<String>{'firstname','surname','email','Query','querySubject'};
        }
        else if(strsource=='116'){
         requiredList= new List<String>{'firstname','surname','email','Query','querySubject','telePhone'};
        }
        else if(strsource=='DirectDebit'){
         requiredList= new List<String>{'firstname','surname','email','Query','address','town','postcode','country','qsubject','telePhone'};
        }
        else if(strsource=='122'){
          //casetype = 'Request for Action;;;3 - Low';   
         requiredList= new List<String>{'firstname','surname','email','Query','querySubject','telePhone'};
        }
        //added for DSS-3451. Just added ESSUP
        else if(strsource=='InternalSSUP'){
          casetype = 'Request for Action;;;2 - Medium';
         requiredList= new List<String>{'firstname','surname','email','institution','Query','querySubject','repName','repEmail'};
        }
        else if(strsource=='124'){
          //casetype = 'Request for Action;;;2 - Medium';
         requiredList= new List<String>{'Query','email'};
        }
        else if(strsource=='127'){
         requiredList= new List<String>{'institution','firstname','surname','email','telePhone','Query','querySubject','queryOutcome'};
        }
        else if(strsource=='contract'){
         casetype = 'Request for Action;Information request;Documentation;3 - Low';
         requiredList= new List<String>{'firstname','surname','email','institution','telePhone','Query','querySubject'};
        }
        else if(strsource=='125'|| strsource=='126'){
            requiredList= new List<String>{'firstname','surname','address','postcode','email','Query','town','country','telePhone','querySubject'};
                if(isBilling){
                    requiredList.add('invoicenumber');
                    requiredList.add('AcctNum');
                    }  
             }
        else{
         requiredList= new List<String>{'firstname','surname','address','postcode','email','Query','town','country','querySubject'};
             if(strsource=='118'|| strsource=='123'){
                requiredList.add('productname');
                requiredList.add('telePhone');
             }
             else if(strsource=='175'){
                 requiredList.add('invoicenumber');
                 requiredList.add('telePhone');
             }
             //added for DSS-3451. Just added ESSUP
             else if(strsource=='120'||strsource=='121'||strsource=='113'||strsource=='115'||strsource=='ESSUP'){
                 requiredList.add('telePhone');
             }
             else if(isPrintSales){
                 requiredList.add('telePhone');
             }
             else if(isSalesSupport){
                 requiredList.add('productname');
                 requiredList.add('telePhone');
             }
             
             
        }

         for(String req:requiredList){
            if(parametersMap.get(req)==null || parametersMap.get(req)==''){
                ErrorFields+=req;
            }
         }
         
        if((strsource=='127' && serviceComplaint == 'None') || (strsource=='contract' && productVersion== 'None') )
        {
            throw new ESC_HandlerCustomException('required');
        }
        
         if(ErrorFields.length()>0){
                throw new ESC_HandlerCustomException('requiredmissing');
         }
         Boolean emailValidate = true;
         if(c.SuppliedEmail != null && c.SuppliedEmail!=''){
          emailValidate = ESC_Utility.validateEmail(c.SuppliedEmail);
         }
          if(!EmailValidate){
                ErrorFields='invalid';
               throw new ESC_HandlerCustomException('incorrectemailaddress');
         }
         
         //Changes done for DSS-3451
        if(strsource=='InternalSSUP'){ 
        Boolean emailValidate2 = ESC_Utility.validateEmail(c.ESC_UKI_WebForm_Rep_Email__c);
          if(!EmailValidate2){
                ErrorFields='notvalid';
               throw new ESC_HandlerCustomException('incorrectemailaddress');
         }
        }
         
          /**Pattern p1 = Pattern.compile( '[0-9+\\-\\(\\)\\s]*');
         Matcher m1 = p1.matcher(c.SuppliedPhone);
        if(!m1.matches()){
               ErrorFields='incorrectphone';
               throw new ESC_HandlerCustomException('incorrectphonenumber');
         }**/
        /* Validation of required fields in forms - End- */
        
        if(strsource=='121cfi'){
        if(Checklist){
            checkboxvalue='Checklist';
        }
        if(Filinginstructions){
            if(checkboxvalue !='' && checkboxvalue!=null){
                checkboxvalue+=', Filing instructions';
            }
            else{
            checkboxvalue='Filing instructions';
            }
        }
        }
       if(casetype != null){
       for(String temp: casetype.split(';')){
           Casetypelist.add(temp);
       }
       }
       if(Casetypelist.size()>0){
           Recordtype rec = new Recordtype();
           if(Schema.sObjectType.recordtype.isAccessible() || Schema.sObjectType.recordtype.isQueryable()){
            rec =[Select id from recordtype where name =:Casetypelist[0]  limit  1];  
           }
           if(rec != null){
             c.recordtypeid =rec.id;
           }  
            c.ESC_Case_Type__c=Casetypelist[0];
           if(Casetypelist[0] =='Incident'|| Casetypelist[0] =='Tech Support'|| Casetypelist[0] =='Legal Content'){
               c.ESC_Customer_Symptom__c= Casetypelist[1];
               c.ESC_Diagnosis_Summary__c= Casetypelist[2];
               c.Priority= Casetypelist[3];
           }
            else if(Casetypelist[0] =='Enquiry' || Casetypelist[0] == 'Request for Action' ||Casetypelist[0] == 'Feedback'){
               c.ESC_Case_Sub_Type__c= Casetypelist[1];
               c.ESC_EnquiryType__c= Casetypelist[2];
               c.Priority= Casetypelist[3];
           }
           
       }
      for (SelectOption so : getItems()){
        if (so.getValue() == casetype){
            natureofquery = so.getLabel();
        }
       
       }
       
       for (SelectOption so1 : getQueues()){
          if (so1.getValue() == queue){
            queueName = so1.getLabel();
          }  
       }
         for (SelectOption so2 : getBusinesses()){
          if (so2.getValue() == business){
            businessName = so2.getLabel();
          }  
         }
        if(strsource == 'DirectDebit'){
            c.subject = qsubject;
            c.USL_SAP_Account_Number__c = AcctNum;  
        }
      /** for (SelectOption so : getProductlist()){
        
            productname = so.getLabel();
        
       }**/
       //DSS-3451 changes
       if(strsource=='InternalSSUP'){
        c.ESC_UKI_WebForm_Queue_Name__c=queueName;
       }
       //DSS-6019 code block start
        if(strsource== '124'){
       for(String temp: cItem.split(';')){
           Casetypelist.add(temp);
       }
       
       if(Casetypelist.size()>0){
           Recordtype rec = new Recordtype();
           if(Schema.sObjectType.recordtype.isAccessible() || Schema.sObjectType.recordtype.isQueryable()){
            rec =[Select id from recordtype where name =:Casetypelist[0]  limit  1];  
           }
           if(rec != null){
             c.recordtypeid =rec.id;
           }  
            c.ESC_Case_Type__c=Casetypelist[0];
            c.Priority= Casetypelist[1];
           /*if(Casetypelist[0] =='Incident'){
               c.ESC_Customer_Symptom__c= Casetypelist[1];
               c.ESC_Diagnosis_Summary__c= Casetypelist[2];
               
           }
            else if(Casetypelist[0] =='Enquiry' || Casetypelist[0] == 'Request for Action' ||Casetypelist[0] == 'Feedback'){
               c.ESC_Case_Sub_Type__c= Casetypelist[1];
               c.ESC_EnquiryType__c= Casetypelist[2];
               c.Priority= Casetypelist[3];
           }*/
       }
      
      for (SelectOption so : getCItems()){
          system.debug('cItem--->'+cItem);
        if (so.getValue() == cItem){
            natureofquery = so.getLabel();
        }
       
       }
        }
       //DSS-6019 code block end
       if(strsource == 'contract'){
      for (SelectOption sol : getproductVersions()){
         if (sol.getValue() == productVersion){
            natureofquery = sol.getLabel();
        }  
      }
      }
       //DSS-6168 code block start
      
       if(strsource== '125' || strsource == '126'){
         system.debug('entered for 125 or 126--->'+section);
        if(strsource == '125'){ 
            for (SelectOption so : getSections()){
            if (so.getValue() == section){
                natureofquery = so.getLabel();
            }
            }
            for (SelectOption so7 : getItemTitles()){
            if (so7.getValue() == itemTitle){
                querytypeName = so7.getLabel();
            }
            }
            for(String temp: itemTitle.split(';')){
                Casetypelist.add(temp);
            }
        }
        if(strsource == '126'){ 
            for (SelectOption so : getOProdSections()){
            if (so.getValue() == oProdSection){
                natureofquery = so.getLabel();
            }
            }
            for (SelectOption so7 : getOProdItemTitles()){
            if (so7.getValue() == oProditem){
                querytypeName = so7.getLabel();
            }
            }
            for (SelectOption so9 : getOProdRenewals()){
            if (so9.getValue() == oProdRenewal){
                renewalName = so9.getLabel();
            }
            }
            for(String temp: oProditem.split(';')){
                Casetypelist.add(temp);
            }
        }
       if(Casetypelist.size()>0){
           Recordtype rec = new Recordtype();
           if(Schema.sObjectType.recordtype.isAccessible() || Schema.sObjectType.recordtype.isQueryable()){
            rec =[Select id from recordtype where name =:Casetypelist[0]  limit  1];  
           }
           if(rec != null){
             c.recordtypeid =rec.id;
           }  
            c.ESC_Case_Type__c=Casetypelist[0];
           if(Casetypelist[0] =='Incident' || Casetypelist[0] =='Tech Support'|| Casetypelist[0] =='Legal Content'){
               c.ESC_Customer_Symptom__c= Casetypelist[1];
               c.ESC_Diagnosis_Summary__c= Casetypelist[2];
               c.Priority= Casetypelist[4];
           }
            else if(Casetypelist[0] =='Enquiry' || Casetypelist[0] == 'Request for Action' ||Casetypelist[0] == 'Feedback'){
               c.ESC_Case_Sub_Type__c= Casetypelist[1];
               c.ESC_EnquiryType__c= Casetypelist[2];
               c.ESC_Sub_Type__c= Casetypelist[3];
               c.Priority= Casetypelist[4];
           }
        if(strsource == '125'){
          for (SelectOption so2 : getLocations()){
          if (so2.getValue() == location){
            locationName = so2.getLabel();
            system.debug('locationName--->'+locationName);
          }  
         }
           if(location == 'Inside'){
               queueName = Casetypelist[5];
               c.ESC_UKI_WebForm_Queue_Name__c = Casetypelist[5];
           }
           else if(location == 'Outside'){
               queueName = Casetypelist[6];
               c.ESC_UKI_WebForm_Queue_Name__c = Casetypelist[6];
           }
        }
        if(strsource == '126'){
            queueName = Casetypelist[4];
            c.ESC_UKI_WebForm_Queue_Name__c = Casetypelist[5];
        }
       }
        if(AcctNum != null && AcctNum != '' && invoicenumber != null && invoicenumber!=''){
           c.ESC_Proactive_Type__c = 'Dispute Pending review';
        }
           c.USL_SAP_Account_Number__c = AcctNum;
           c.ESC_Invoice_Numbers__c = invoicenumber;
       }
       //DSS-6168 code block end
       //DSS-7156 code block start
      if(strsource == 'JCT' || strsource == '127'){
      if(strsource == 'JCT'){
      for (SelectOption so10 : getJCTqueries()){
         if (so10.getValue() == jctQuery){
            natureofquery = so10.getLabel();
        }  
      }
      for (SelectOption so21 : getJCTUsers()){
         if (so21.getValue() == jctUserBand ){
            jctUser = so21.getLabel();
        }  
      }
         for(String temp: jctQuery.split(';')){
                Casetypelist.add(temp);
            }
            c.subject = qsubject;
            c.USL_SAP_Account_Number__c = AcctNum;
      }
       if(strsource == '127'){
       for (SelectOption so4 : getserviceComplaints()){
            if (so4.getValue() == serviceComplaint){
                natureofquery = so4.getLabel();
            }
            }
        system.debug('serviceComplaint--->'+serviceComplaint);
           for(String temp: serviceComplaint.split(';')){
                Casetypelist.add(temp);
            }
       }
           if(Casetypelist.size()>0){
           Recordtype rec = new Recordtype();
           if(Schema.sObjectType.recordtype.isAccessible() || Schema.sObjectType.recordtype.isQueryable()){
            rec =[Select id from recordtype where name =:Casetypelist[0]  limit  1];  
           }
           if(rec != null){
             c.recordtypeid =rec.id;
           }  
            c.ESC_Case_Type__c=Casetypelist[0];
           if(Casetypelist[0] =='Incident' || Casetypelist[0] =='Tech Support'|| Casetypelist[0] =='Legal Content'){
               c.ESC_Customer_Symptom__c= Casetypelist[1];
               c.ESC_Diagnosis_Summary__c= Casetypelist[2];
               c.Priority= Casetypelist[4];
           }
            else if(Casetypelist[0] =='Enquiry' || Casetypelist[0] == 'Request for Action' ||Casetypelist[0] == 'Feedback'){
               c.ESC_Case_Sub_Type__c= Casetypelist[1];
               c.ESC_EnquiryType__c= Casetypelist[2];
               c.ESC_Sub_Type__c= Casetypelist[3];
               c.Priority= Casetypelist[4];
           }
           c.ESC_UKI_WebForm_Queue_Name__c = Casetypelist[5];
           }
       }
       
       //DSS-7156 code block end
        c.SuppliedName = firstname +' '+ Surname;
        c.Status='New';
        c.ESC_Origin_Name__c=hostURL;
        c.Origin = 'Web';
        c.Sales_Org__c = 'GLI';
        c.LCRM_Sub_BU__c='UKI';
        c.Is_GLI__c= true;
        c.ESC_UKI_WebForm_Query_Details__c=c.Description;
        
        BusinessHours bh = new BusinessHours();
        if(Schema.sObjectType.BusinessHours.isAccessible() || Schema.sObjectType.BusinessHours.isQueryable()){
           bh = [SELECT Id FROM BusinessHours WHERE Name='Europe/London'];
        }
            if(bh !=null){
            c.BusinessHoursId= bh.Id;
            }
            
        //added for DSS-3451. Just added ESSUP
        
        if(strsource =='121' || strsource=='117' || strsource=='120'|| strsource=='115' || strsource =='102'|| strsource =='113'|| strsource =='ESSUP'){
        finalquerydetails = 'Nature of Query : '+natureofquery +
                        '  \r\n Account Number : '+ AcctNum +
                        '  \r\n Invoice Number : '+ invoicenumber +
                        '  \r\n Product Name : '+productname+
                        '  \r\n First Name : '+ firstname +
                        '  \r\n Surname : '+ surname +
                        '  \r\n Job Title : '+ title +
                        '  \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        '  \r\n Query Details : '+ c.Description;
        }
        else if(strsource =='122'){
            System.debug('!!!'+natureofquery);
        finalquerydetails = 'Nature of Query : '+natureofquery +
                        '  \r\n Product Name : '+productname+
                        '  \r\n First Name : '+ firstname +
                        '  \r\n Surname : '+ surname +
                        '  \r\n Job Title : '+ title +
                        '  \r\n Organisation : '+ c.SuppliedCompany +
                        '  \r\n Query Details : '+ c.Description;
        }
        //added for DSS-8368
        else if(strsource =='credit'){
            finalquerydetails =  'First Name : '+firstname +
                        '  \r\n Surname : '+ surname +
                        '  \r\n Thomson Retuers account number : '+accountnumber +
                        '  \r\n Thomson Reuters credit reference : '+ creditReference +
                        '  \r\n Refund amount requested : '+ refundAmount +
                        '  \r\n Bank Account Name : '+ bankAccName +
                        '  \r\n Bank Name : '+ bankName +
                        '  \r\n Sort Code : '+ sortCode +
                        '  \r\n Account Number : '+ accNumber +
                        '  \r\n IBAN : '+ iBAN +
                        '  \r\n BIC : '+ bic +
                        '  \r\n Comments : '+ creditcomments +c.Description;
            c.Subject = 'Credit refund request';
        }
        else if(strsource =='124'){
            System.debug('!!!'+natureofquery);
        finalquerydetails = 'Nature of Query : '+natureofquery +
                        '  \r\n Sales Area : '+ salesarea +
                        '  \r\n Contract Key or Reference Number : '+ refNumber +
                        '  \r\n Query Details : '+ c.Description;
        }
        //added for DSS-7156
        else if(strsource =='127'){
        finalquerydetails = 'Service complaint is regarding : '+natureofquery +
                        '  \r\n Company Name : '+ c.SuppliedCompany+
                        '  \r\n First Name : '+ firstname +
                        '  \r\n Surname : '+ surname +
                        '  \r\n Details of complaint : '+ c.Description +
                        '  \r\n Desired outcome : '+ queryOutcome;
        }
        //added for DSS-3451
        else if(strsource =='InternalSSUP'){
            System.debug('!!!'+natureofquery);
            System.debug('!!!queueName'+queueName);
        finalquerydetails ='Business Name : '+ businessName +
                        '  \r\n Queue Name : '+ queueName +
                        '  \r\n Account Number : '+ AcctNum +
                        '  \r\n Product Name : '+ productname +
                        '  \r\n Customer First Name : '+ firstname +
                        '  \r\n Customer Surname : '+ surname +
                        '  \r\n Customer Organisation Name : '+ c.suppliedcompany +
                        ' \r\n Customers Email Address : '+ c.SuppliedEmail +
                        ' \r\n Customers Telephone Number : '+ c.SuppliedPhone +
                        ' \r\n Rep Name : '+ c.ESC_UKI_WebForm_Rep_Name__c +
                        ' \r\n Rep Email Address : '+ c.ESC_UKI_WebForm_Rep_Email__c +
                        '  \r\n Query Details : '+ c.Description;
            
            
        }
        //added fro DSS-7637
        else if(strsource =='contract'){
        productname ='Contract Analysis';
        finalquerydetails ='Nature of Query : '+natureofquery +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Product Name : '+productname+
                        '  \r\n Query Details : '+ c.Description;
            
            
        }
        else if(strsource=='118'||strsource=='123'){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Product Name : '+productname+
                        ' \r\n Device : '+ device +
                        ' \r\n Device Operating System : '+ deviceos +
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='125'){
             finalquerydetails = 'Your location : '+locationName +
                        ' \r\n Nature of Query : '+natureofquery +
                        ' \r\n Query type : '+querytypeName+
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Invoice Number : '+ invoicenumber +
                        ' \r\n Product Name : '+productname+
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='126' && temprenewalchanged){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Query type : '+querytypeName+
                        ' \r\n Cancellation Reason : '+renewalName+
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Invoice Number : '+ invoicenumber +
                        ' \r\n Product Name : '+productname+
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='126' && !temprenewalchanged){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Query type : '+querytypeName+
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Invoice Number : '+ invoicenumber +
                        ' \r\n Product Name : '+productname+
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='DirectDebit'){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='JCT' && !tempJCTchanged){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='JCT' && tempJCTchanged){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Address : '+ address +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Service : '+ jctService +
                        ' \r\n User Band : '+jctUser +
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='175'){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Account Number : '+AcctNum +
                        ' \r\n Invoice Number : '+ invoicenumber +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Job Title : '+ title +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='116'){
            finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Account Number : '+AcctNum +       
                        ' \r\n Product Name : '+productname+
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Job Title : '+ title +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='109'){
            finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +     
                        ' \r\n Product Name : '+productname+
                        ' \r\n Query Details : '+ c.Description;
        }
        else if(strsource=='108'){
            finalquerydetails = 'Nature of Query : '+natureofquery +    
                        ' \r\n First Name : '+ firstname +
                        ' \r\n Surname : '+ surname +
                        ' \r\n Account Number : '+AcctNum +  
                        ' \r\n Query Details : '+ c.Description;
        }
        
        else if(strsource=='121mp'){
             finalquerydetails = ' Account Number : '+AcctNum +
                        '\r\n Order Number(s) : '+ordernum+
                        '\r\n Invoice Number : '+invoicenumber+
                        '\r\n Product Item Number or ISBN : '+isbn+
                        '\r\n Product title : '+productname+
                        '\r\n Pages required : '+pagesrequired+
                        '\r\n Quantity : '+quantity+
                        '\r\n Claim reason : '+claimreason+
                        ' \r\n First name : '+ firstname +
                        ' \r\n Last name : '+ surname +
                        ' \r\n Job Title : '+ title +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        //' \r\n County : '+ county +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Additional information : '+ c.Description;
        }
        else if(strsource=='121cfi'){
             finalquerydetails = ' Account Number : '+AcctNum +
                        '\r\n Product Item Number or ISBN : '+isbn+
                        '\r\n Product title : '+productname+
                        '\r\n Request type : '+checkboxvalue+
                        ' \r\n First name : '+ firstname +
                        ' \r\n Last name : '+ surname +
                        ' \r\n Job Title : '+ title +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        //' \r\n County : '+ county +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Additional information : '+ c.Description;
        }
        else if(strsource=='115icr'){
             finalquerydetails = ' Account Number : '+AcctNum +
                        ' \r\n First name : '+ firstname +
                        ' \r\n Last name : '+ surname +
                        ' \r\n Job Title : '+ title +
                        ' \r\n Institution : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        //' \r\n County : '+ county +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        ' \r\n Publication 1:'+
                        ' \r\n   Title : '+titlelist[0]+
                        ' \r\n   ISBN : '+isbnlist[0]+
                        ' \r\n   Author : '+authorlist[0]+
                        ' \r\n Publication 2:'+
                        ' \r\n   Title : '+titlelist[1]+
                        ' \r\n   ISBN : '+isbnlist[1]+
                        ' \r\n   Author : '+authorlist[1]+
                        ' \r\n Publication 3:'+
                        ' \r\n   Title : '+titlelist[2]+
                        ' \r\n   ISBN : '+isbnlist[2]+
                        ' \r\n   Author : '+authorlist[2];
        }
         else if(isPrintSales){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        '  \r\n Account Number : '+ AcctNum +
                        '  \r\n Invoice Number : '+ invoicenumber +
                        '  \r\n Product Name : '+productname+
                        '  \r\n First Name : '+ firstname +
                        '  \r\n Surname : '+ surname +
                        '  \r\n Job Title : '+ title +
                        '  \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        '  \r\n Query Details : '+ c.Description;
        }
         else if(isSalesSupport){
             finalquerydetails = 'Nature of Query : '+natureofquery +
                        '  \r\n Account Number : '+ AcctNum +
                        '  \r\n Invoice Number : '+ invoicenumber +
                        '  \r\n Product Name : '+productname+
                        '  \r\n First Name : '+ firstname +
                        '  \r\n Surname : '+ surname +
                        '  \r\n Job Title : '+ title +
                        '  \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address1 : '+ address +
                        ' \r\n Address2 : '+ address1 +
                        ' \r\n Town / City : '+ town +
                        ' \r\n Postcode : '+ postcode +
                        ' \r\n Country : '+ country +
                        '  \r\n Query Details : '+ c.Description;
        }
        
        if(finalquerydetails.length() > 31990) {
            c.Description = finalquerydetails.left(31900) + '... [TRUNCATED]';
        }
        else{
        c.Description = finalquerydetails;
        }
         Database.DMLOptions dmo = new Database.DMLOptions();
         dmo.assignmentRuleHeader.useDefaultRule = true;
        // dmo.EmailHeader.triggerAutoResponseEmail = true;
        // c.setOptions(dmo);
         Database.SaveResult srList = Database.insert(c,dmo);
            if(!srList.isSuccess()){
                Database.Error[] we=srList.getErrors();
                String we1 = we[0].getMessage();
                system.debug('Failed to create case error '+we1);
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,we1);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,Label.GLI_W2C_CaseCreationError);
                ApexPages.addMessage(msg);
            }
            else{
              //  gcasid=c.id;
                case c1 = new case();
                if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isQueryable()){
                c1 = [select id, casenumber from case where id=:c.id];
                }
                if(c1 != null){
                    attachfile(c1);
                }
                
                displayform = false;
               successPage = true;
            }
        
    }
    catch(ESC_HandlerCustomException ex){
        if(ex.getMessage().equals('required')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Service_Complaint_is_required)); 
        }
        if(ex.getMessage().equals('incorrectemailaddress')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GLI_W2C_EmailError));
        }
        /**if(ex.getMessage().equals('incorrectphonenumber')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GLI_W2C_PhoneError));
        }**/
        if(ex.getMessage().equals('requiredmissing')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.GLI_W2C_Mandatory));
        }
        if(ex.getMessage().equals('attachmentrequired')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GLI_W2C_AttachmentRequired)); 
        }
    }
    finally{
        initializeAttachment();
    }
    return null;
 }

 public void unsupportedBrowser(){
        IsNotSupported = true;
        displayform=false;
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.GLi_W2C_UnsupportedBrowser);
        ApexPages.addMessage(msg);        
    }
    //added for DSS-3451, DSS-6019, DSS-6168
    public string business{get;set;}
    public string queue{get;set;}
    public boolean tempchanged{get;set;}
    public boolean tempsectionchanged{get;set;}
    public boolean tempitemchanged{get;set;}
    public boolean temprenewalchanged{get;set;}
    public boolean tempJCTchanged{get;set;}
    public boolean isBilling{get;set;}
    public string location{get;set;}
    public string section{get;set;}
    public string itemTitle{get;set;}
    public string oProdSection{get;set;}
    public string oProditem{get;set;}
    public string oProdRenewal{get;set;}
    public string cItem{get;set;}
    public void changed(){ 
       tempchanged = true; 
    }
    public string qsubject{get;set;}
    public void sectionchanged(){   
       tempsectionchanged = true;
        System.debug('jctQuery--->'+jctQuery);
      if(strsource == 'JCT'){
      for (SelectOption so15 : getJCTqueries()){
         if (so15.getValue() == jctQuery){
            qsubject = 'JCT Construct - ' + so15.getLabel();
        }  
        }
        if(jctQuery == 'Request for Action;Order Processing;Order;;1 - High;UKI OTC Print'){
           System.debug('temprenewalchangedlabel--->'+tempJCTchanged);
        tempJCTchanged =true;
       }
       else{
         tempJCTchanged = false;  
       }
      }
      if (strsource == 'DirectDebit'){
          for (SelectOption so55 : getItems()){
            if (so55.getValue() == casetype){
            qsubject = so55.getLabel();
        }
       }
      }
    }
    public void itemchanged(){  
       tempitemchanged = true;
       System.debug('oProditem--->'+oProditem);
            if (oProditem == 'Request for action;Orders, Pricing & Subscriptions;Modify Subscription;Cancel Subscription;3 - Low;UKI Online Order Management'){
                temprenewalchanged = true;
                System.debug('temprenewalchangedlabel--->'+temprenewalchanged);
            }
            else{
                temprenewalchanged = false;
            }
            //added for DSS-10123/DSS-10125         
            if((section == 'Billing' && itemTitle != 'Request for action;Cash Apps;Refund Request;;3 - Low;UKI Customer Support;UKI International Invoice Queries') || (oProdSection == 'Billing' && oProditem != 'Request for action;Cash Apps;Refund Request;;3 - Low;UKI Customer Support'))
            {
                 isBilling = true;
            }
            else{
                isBilling = false;
            }
    }
    public List<SelectOption> getBusinesses()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('Cr','Corporate'));
        options.add(new SelectOption('LP','Legal Professionals'));
        return options;
    } 
    
    public List<SelectOption> getQueues()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(business == 'Cr')
        {    
            options.add(new SelectOption('None','--- None ---'));
            options.add(new SelectOption('Lead Key','Lead Key'));
            options.add(new SelectOption('Lead Growth','Lead Growth'));
            options.add(new SelectOption('Lead Core','Lead Core'));
            options.add(new SelectOption('Lead Opportunity / New Business','Lead Opportunity / New Business'));
            options.add(new SelectOption('Lead Solutions','Lead Solutions'));
            options.add(new SelectOption('Lead Tax','Lead Tax'));
            options.add(new SelectOption('Lead Legal Software','Lead Legal Software'));
        }
        else if(business == 'LP')
        {  
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Strategic Accounts','Strategic Accounts'));
           options.add(new SelectOption('Field Sales','Field Sales'));
           options.add(new SelectOption('Inside Sales','Inside Sales'));
           options.add(new SelectOption('Software Sales','Software Sales'));
        
            
        }
        else
        {
            options.add(new SelectOption('None','--- None ---'));
        }   
        
        
        return options;
    } 
    public List<SelectOption> getCItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Request for action;3 - Low;1','Varicent Query'));
        options.add(new SelectOption('Request for action;3 - Low;2','Other Commission Calculation Query'));
        options.add(new SelectOption('Request for action;3 - Low;3','Commission Plan Query'));
        options.add(new SelectOption('Request for action;3 - Low;4','Employee On-Boarding (new starter, leaver, absentee etc)'));
        options.add(new SelectOption('Request for action;3 - Low;5','Target Query'));
        options.add(new SelectOption('Request for action;3 - Low;6','Order that has been Processed Query'));
        options.add(new SelectOption('Incident;3 - Low;7','Misc Issue Query'));
        return options;  
    } 
    public List<SelectOption> getLocations()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('Inside','I am located in the UK / Ireland'));
        options.add(new SelectOption('Outside','I am located outside UK / Ireland'));
        return options;
    }
    public List<SelectOption> getSections()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(location == 'Inside')
        {   
            options.add(new SelectOption('None','--- None ---'));    
            options.add(new SelectOption('Billing','Billing'));
            options.add(new SelectOption('Orders','Orders and subscriptions'));
            options.add(new SelectOption('General','General'));
        }
        else if(location == 'Outside')
        { 
            options.add(new SelectOption('None','--- None ---'));       
            options.add(new SelectOption('Billing','Billing'));
            options.add(new SelectOption('Orders','Orders and subscriptions'));
            options.add(new SelectOption('General','General'));
        }
        else{
            options.add(new SelectOption('None','--- None ---'));
        }
        return options;
    }
    public List<SelectOption> getItemTitles()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(section == 'Billing')
        {      
            options.add(new SelectOption('None','--- None ---'));
            options.add(new SelectOption('Request for action;Billing;Invoice/Billing Document Copy;;3 - Low;UKI OTC Admin support;UKI OTC Admin support','Copy invoice'));
            options.add(new SelectOption('Request for action;Billing;;;3 - Low;UKI Customer Support;UKI International Invoice Queries','Billing enquiry'));
            options.add(new SelectOption('Request for action;Cash Apps;Payment Inquiry;;3 - Low;UKI Customer Support;UKI International Invoice Queries','Payment enquiry'));
            options.add(new SelectOption('Request for action;Cash Apps;Refund Request;;3 - Low;UKI Customer Support;UKI International Invoice Queries','Refund enquiry'));  
        }
        else if(section == 'Orders')
        {  
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Order Processing;Order;;3 - Low;UKI OTC Print;UKI International EXIM Orders','New order'));
           options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Modify Subscription;;3 - Low;UKI OTC Print;UKI International General Queries','Renewal change'));
           options.add(new SelectOption('Request for action;Shipments & Delivery;Shipment Not Received;;3 - Low;UKI Customer Support;UKI International General Queries','Order not received'));
           options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Information Request;;3 - Low;UKI Customer Support;UKI International EXIM Orders','Product enquiry'));
           options.add(new SelectOption('Request for action;Shipments & Delivery;Product Return;;3 - Low;UKI OTC Print;UKI International General Queries','Return request'));
           options.add(new SelectOption('Request for action;Shipments & Delivery;Shipment damaged;;3 - Low;UKI Customer Support;UKI International General Queries','Product damaged'));
           options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Modify Subscription;Cancel Subscription;3 - Low;UKI OTC Print;UKI International General Queries','Renewal cancellation')); 
        }
        else if(section == 'General')
        {        
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;;3 - Low;UKI Customer Support;UKI International General Queries','General enquiry'));
           options.add(new SelectOption('Request for action;Account Master Data;Account Edit/Update;;3 - Low;UKI Customer Support;UKI International General Queries','Name/address amendment'));
           options.add(new SelectOption('Feedback;Complaint;;;3 - Low;UKI Customer Support;UKI International General Queries','Complaint'));
           options.add(new SelectOption('Request for action;Shipments & Delivery;Shipment not received;;3 - Low;UKI Customer Support;UKI International EXIM Claims','Subscription item missing'));
           options.add(new SelectOption('Enquiry;Account enquiry;;;3 - Low;UKI Moj & Key Accounts;UKI Moj & Key Accounts','PLC Magazine'));           
        }
        else
        {
            options.add(new SelectOption('None','--- None ---'));
        }   
        
        
        return options;
    }
    public List<SelectOption> getOProdSections()
    {
        List<SelectOption> options = new List<SelectOption>(); 
            options.add(new SelectOption('None','--- None ---'));    
            options.add(new SelectOption('Billing','Billing'));
            options.add(new SelectOption('Orders','Orders and contracts'));
            options.add(new SelectOption('Online','Using online services'));
            options.add(new SelectOption('Access','Accessing online services'));
            options.add(new SelectOption('General','General'));
        return options;
    }
    public List<SelectOption> getOProdItemTitles()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(oProdSection == 'Billing')
        {     
            options.add(new SelectOption('None','--- None ---'));
            options.add(new SelectOption('Request for action;Billing;Invoice/Billing Document Copy;;3 - Low;UKI OTC Admin support','Copy invoice'));
            options.add(new SelectOption('Request for action;Billing;;;3 - Low;UKI Online Order Management','Billing enquiry'));
            options.add(new SelectOption('Request for action;Cash Apps;Payment Inquiry;;3 - Low;UKI Customer Support','Payment enquiry'));
            options.add(new SelectOption('Request for action;Cash Apps;Refund Request;;3 - Low;UKI Customer Support','Refund enquiry'));  
        }
        else if(oProdSection == 'Orders')
        {       
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Order Processing;Order;;3 - Low;UKI Online Order Management','New order'));
           options.add(new SelectOption('Request for action;Orders, Pricing & Subscriptions;Modify Subscription;Cancel Subscription;3 - Low;UKI Online Order Management','Renewal cancellation')); 
        }
        else if(oProdSection == 'Online')
        {       
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Tech Support;;Content Explanation;;3 - Low;UKI Online Customer Support','Content enquiry'));
           options.add(new SelectOption('Tech Support;;Content Explanation;;3 - Low;UKI Online Customer Support','Incorrect or missing content')); 
           options.add(new SelectOption('Tech Support;;Login Issue;;3 - Low;UKI Online Customer Support','Cannot access subscribed content'));
        }
        else if(oProdSection == 'Access')
        {       
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Entitlements;User ID Update/Swap;;3 - Low;UKI Online Access','Add / modify / inactivate user, reset password'));
           options.add(new SelectOption('Tech Support;;Configuration;;3 - Low;UKI Online Customer Support','Technical issue')); 
           options.add(new SelectOption('Tech Support;;Login Issue;none;3 - Low;UKI Online Customer Support','Login failure'));
        }
        else if(oProdSection == 'General')
        {   
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;;3 - Low;UKI Online Customer Support','General enquiry'));
           options.add(new SelectOption('Request for action;Account Master Data;Account Edit/Update;;3 - Low;UKI Online Order Management','Name/address amendment'));
           options.add(new SelectOption('Feedback;Complaint;;;3 - Low;UKI Online Customer Support','Complaint'));
           options.add(new SelectOption('Enquiry;Account enquiry;;;3 - Low;UKI Moj & Key Accounts','PLC Magazine'));           
        }
        else
        {
            options.add(new SelectOption('None','--- None ---'));
        }   
        
        
        return options;
    }
    //added for DSS-9593
     public List<SelectOption> getOProdRenewals()
    {
     List<SelectOption> options = new List<SelectOption>(); 
     if(oProditem == 'Request for action;Orders, Pricing & Subscriptions;Modify Subscription;Cancel Subscription;3 - Low;UKI Online Order Management'){
            options.add(new SelectOption('None','--- None ---'));    
            options.add(new SelectOption('Usage','I don\'t use the service'));
            options.add(new SelectOption('Offer','I have been offered a better rate for a similar service'));
            options.add(new SelectOption('Afford','I can\'t afford the service at this moment'));
            options.add(new SelectOption('Cessation','Cessation of Business'));
            options.add(new SelectOption('Other','Other (please state in Query Details)'));
            }
        return options;
    }
     //added for DSS-7156
     public string serviceComplaint{get;set;}
     public List<SelectOption> getserviceComplaints()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('Feedback;Complaint;;;1 - High;UKI Online Customer Support','Online Products'));
        options.add(new SelectOption('Feedback;Complaint;;;1 - High;UKI Customer Support','Print Products'));
        options.add(new SelectOption('Feedback;Complaint;;;1 - High;UKI Customer Support','Billing'));
        options.add(new SelectOption('Feedback;Complaint;;;1 - High;UKI Customer Support ','Other '));
        return options;
    } 
    //added for DSS-7637
     public string productVersion{get;set;}
     public List<SelectOption> getproductVersions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('UKI','UKI'));
        options.add(new SelectOption('Unsure','Unsure'));
        return options;
    } 
    
    //added for DS-9594
     public string jctQuery{get;set;}
     public List<SelectOption> getJCTqueries(){
        List<SelectOption> options = new List<SelectOption>();       
        options.add(new SelectOption('Request for Action;Orders, Pricing & Subscriptions;Information request;;2 - Medium;UKI Customer Support','I would like to submit an enquiry'));
        options.add(new SelectOption('Incident; Application issue;configuration;;2 - Medium;UKI Technical Support','I have a technical issue')); 
        options.add(new SelectOption('Request for Action;Order Processing;Order;;1 - High;UKI OTC Print','I would like to place an order'));
        return options;
    }
    public string jctService{get;set;}
     public List<SelectOption> getJCTServices(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('Small Works','Small Works'));
        options.add(new SelectOption('Complete','Complete'));
        return options;
    }
    public string jctUserBand{get;set;}
     public List<SelectOption> getJCTUsers(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('1','1 User'));
        options.add(new SelectOption('2','2-3 Users'));
        options.add(new SelectOption('3','4-5 Users'));        
        options.add(new SelectOption('4','6-10 Users'));
        options.add(new SelectOption('5','11-15 Users'));
        options.add(new SelectOption('6','16-20 Users'));   
        options.add(new SelectOption('7','21-25 Users'));
        options.add(new SelectOption('8','26-50 Users'));
        options.add(new SelectOption('9','50+ Users'));
        return options;
    }
    
}