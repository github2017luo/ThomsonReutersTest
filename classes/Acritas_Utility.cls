public without sharing class Acritas_Utility {
    
    public Case c { get; set; } 
    public boolean isNotSupported{get;set;} 
    public static boolean displayForm{get;set;}
    public static boolean successPage { get; set; }
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
    public Acritas_Utility(ApexPages.StandardController controller) {
        system.debug('Inside constructor');
        //strsource = apexpages.currentpage().getparameters().get('source');
        c = new Case();
        
    }
    
    
        
      
       public static void attachfile(Case c1,List<Attachment> newAttachments){
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
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GLI_W2C_CaseSucess1+c1.CaseNumber+'</b>. '+ attlist.size() +' '+Label.GLI_W2C_CaseSuccess4+Label.Acritas_W2C_CaseSuccess));
          }
          if(attlist.size()>1){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GLI_W2C_CaseSucess1+c1.CaseNumber+'</b>. '+ attlist.size() +' '+Label.GLI_W2C_CaseSuccess3+Label.Acritas_W2C_CaseSuccess));
          }
        }
        else{
          displayform=false;
          successPage= true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GLI_W2C_CaseSucess1 + c1.CaseNumber+Label.Acritas_W2C_CaseSuccess));
        }
    }   
    public void unsupportedBrowser(){
        isNotSupported = true;
        displayform=false;
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.GLi_W2C_UnsupportedBrowser);
        ApexPages.addMessage(msg);        
    }
     public static string emailvalidate(string suppliedEmail,string repEmail){
        string errorFields = '';
        boolean emailvalidate = true;
        boolean emailValidate1 = true;
        if(suppliedEmail != null && suppliedEmail!=''){
              emailValidate = ESC_Utility.validateEmail(suppliedEmail);
         }
         
         if(repEmail !=null && repEmail!=''){
             emailValidate1 = ESC_Utility.validateEmail(repEmail);
         }
             
        if(!EmailValidate){
            errorFields='invalid';
           throw new ESC_HandlerCustomException('invalid');
        }   
        if(!EmailValidate1){
                    errorFields='incorrect contact';
                   throw new ESC_HandlerCustomException('incorrect contact');
        }   
        return errorFields;
    }
    
    public  static List<SelectOption> getOProdSections()
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

    public  static List<SelectOption> getOProdItemTitles(string oProdSection)
    {
        List<SelectOption> options = new List<SelectOption>();
        if(oProdSection == 'Billing')
        {     
            options.add(new SelectOption('None','--- None ---'));
            options.add(new SelectOption('Request for action;Billing;Invoice/Billing Document Copy;;3 - Low;UKI OTC Admin support','Copy invoice'));
            //added for DSS-11897
            options.add(new SelectOption('Request for action;Billing;e-Invoicing;;3 - Low;UKI Online Order Management','Billing enquiry'));
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
           options.add(new SelectOption('Incident;Content Explanation;;;3 - Low;UKI Acritas Product Support','Content enquiry'));
           options.add(new SelectOption('Incident;Content integrity;;;3 - Low;UKI Acritas Product Support','Incorrect or missing content')); 
           //added for DSS-11897
           options.add(new SelectOption('Tech Support;Entitlement;Content Not Available;;3 - Low;UKI Acritas Product Support','Cannot access subscribed content'));
        }
        else if(oProdSection == 'Access')
        {       
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Entitlements;User ID Update/Swap;;3 - Low;UKI Acritas Product Support','Add / modify / inactivate user, reset password'));
           //added for DSS-11897
           options.add(new SelectOption('Tech Support;Application Issue;;;3 - Low;UKI Acritas Product Support','Technical issue')); 
           options.add(new SelectOption('Tech Support;Entitlement;Login Issue;;3 - Low;UKI Acritas Product Support','Login failure'));
        }
        else if(oProdSection == 'General')
        {   
           options.add(new SelectOption('None','--- None ---'));
           options.add(new SelectOption('Request for action;Information Request;Account Management Inquiry;;3 - Low;UKI Online Customer Support','General enquiry'));
           options.add(new SelectOption('Request for action;Account Master Data;Account Edit/Update;;3 - Low;UKI Online Order Management','Name/address amendment'));
           options.add(new SelectOption('Feedback;Complaint;;;3 - Low;UKI Online Customer Support','Complaint'));
           options.add(new SelectOption('Enquiry;Account enquiry;;;3 - Low;UKI Moj & Key Accounts','PLC Magazine'));
           options.add(new SelectOption('Request for service;;;;3 - Low;UKI Acritas Project Inquiry','New Project Inquiry'));           
        }
        else
        {
            options.add(new SelectOption('None','--- None ---'));
        }   
        
        
        return options;
    }
    
    public static List<string> getSectionDetails(string oProdSection,string oProditem,string oProdRenewal){

        List<String> casetypelist= new List<String>();
         string natureofquery;
         string querytypeName;
         string renewalName;
            for (SelectOption so : Acritas_Utility.getOProdSections()){
            if (so.getValue() == oProdSection){
                natureofquery = so.getLabel();
            }
            }
            for (SelectOption so7 : Acritas_Utility.getOProdItemTitles(oProdSection)){
            if (so7.getValue() == oProditem){
                querytypeName = so7.getLabel();
            }
            }
            for (SelectOption so9 : Acritas_utility.getOProdRenewals(oProditem)){
            if (so9.getValue() == oProdRenewal){
                renewalName = so9.getLabel();
            }
            }
            for(String temp: oProditem.split(';')){
                Casetypelist.add(temp);
            }
            casetypelist.add(natureofquery);
            casetypelist.add(querytypename);
            casetypelist.add(renewalName);
        return caseTypeList;
     }
    public  static List<SelectOption> getOProdRenewals(string oProditem)
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
 }