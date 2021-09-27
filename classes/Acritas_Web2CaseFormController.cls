/**********************************
Class Name: Acritas_Web2CaseFormController
Purpose:Controller for Acritas_Web2CaseForm which is used in 
        Web2Case for UKI/Acritas users.
JIRA: DSS-10379
Author: Vaishali N
Date Created:05/10/2020
Date Updated:Version0
***********************************/
public without sharing class Acritas_Web2CaseFormController {

    //public String formheader { get; set; }
    public Case c { get; set; }    
    String hostURL ;
    String strsource ;
    public boolean displayform { get; set; }
    public boolean successPage { get; set; }
    public boolean tempsectionchanged {get;set;}
    public String errorFields {get;set;}
    public Acritas_CaseFieldsMappingWrapper csWrapper{get;set;}
    public  List<Attachment> newAttachments {get; set;}
    public boolean tempitemchanged {get;set;}
    public boolean temprenewalchanged {get;set;}
    public Acritas_ProductSelectOptionWrapper prodWrapper{get;set;}
    
  public Acritas_Web2CaseFormController(ApexPages.StandardController stdController){
     
     displayform = true;
     successPage = false;
     strsource = apexpages.currentpage().getparameters().get('source');
     c = new Case();
     csWrapper = new Acritas_CaseFieldsMappingWrapper();
     prodWrapper = new Acritas_ProductSelectOptionWrapper();
     prodWrapper.oProdsections = Acritas_Utility.getoProdSections();
     hostURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();
         
     newAttachments = new List<Attachment>();
        for (Integer idx=0; idx<5; idx++)
           {
               newAttachments.add(new Attachment());
           }
           initializeAttachment();
 }
 
 private  void initializeAttachment(){
    newAttachments = new List<Attachment>();
    for (Integer idx=0; idx<5; idx++)
       {
           newAttachments.add(new Attachment());
       }
}
public pagereference submitCase(){
      
    try{
         string natureofquery;
         string querytypeName;
         string renewalName;
        System.debug('!!!2'+natureofquery);
        String checkboxvalue;
        List<String> casetypelist= new List<String>();
        /* Validation of required fields in forms - START- */
        
         ErrorFields = requiredFieldValidation();
       if(ErrorFields.length()>0){
                throw new ESC_HandlerCustomException('requiredmissing');
         }
        ErrorFields = Acritas_utility.emailvalidate(c.suppliedEmail,c.ESC_UKI_WebForm_Rep_Email__c);
       
        caseTypeList = Acritas_utility.getSectionDetails(prodWrapper.oProdSection,prodWrapper.oProditem,prodWrapper.oProdRenewal);
        if(!Test.isRunningTest()){
        natureofquery = caseTypeList[6];
        querytypeName = caseTypeList[7];
        renewalName = caseTypeList[8];
        
     }
       if(Casetypelist.size()>0){
           
        caseTypeList(caseTypeList);
       }
       setCaseFields(querytypeName);
        
        //added for DSS-3451. Just added ESSUP
        if(strsource=='Acritas'){ 
            insertCase(natureofquery,querytypeName,renewalName);
        }
        
    }
    catch(ESC_HandlerCustomException ex){
        exceptionHandling(ex.getMessage());
    }
    finally{
        initializeAttachment();
    }
    return null;
 }
 
 private void exceptionHandling(string msg){
    if(msg.equals('invalid')){
        ErrorFields = 'invalid';
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GLI_W2C_EmailError));
    }if(msg.equals('incorrect contact')){
        ErrorFields = 'incorrect contact';
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Acritas_W2C_EmailError));
    }
    if(msg.equals('requiredmissing')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.GLI_W2C_Mandatory));
    }

 }
 private void insertCase(string natureofquery,string querytypeName,string renewalName){
    String finalquerydetails;
    if(temprenewalchanged){
    
    finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Query type : '+querytypeName+
                        ' \r\n Cancellation Reason : '+renewalName+
                        ' \r\n First Name : '+ csWrapper.firstname +
                        ' \r\n Surname : '+ csWrapper.surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address : '+ csWrapper.address +
                        ' \r\n Town / City : '+ csWrapper.town +
                        ' \r\n Postcode : '+ csWrapper.postcode +
                        ' \r\n Country : '+ csWrapper.country +
                        ' \r\n Email Address : '+ c.SuppliedEmail +
                        ' \r\n Telephone number : '+ c.SuppliedPhone +
                        ' \r\n Internal Contact Email Address : '+ c.ESC_UKI_WebForm_Rep_Email__c +
                        ' \r\n Account Number : '+csWrapper.AcctNum +
                        ' \r\n Invoice Number : '+ csWrapper.invoicenumber +
                        ' \r\n Product Brand : '+ 'Acritas' +
                        ' \r\n Product Name : '+csWrapper.productname+
                        ' \r\n Query Details : '+ c.Description;
    }else{
    finalquerydetails = 'Nature of Query : '+natureofquery +
                        ' \r\n Query type : '+querytypeName+
                        ' \r\n First Name : '+ csWrapper.firstname +
                        ' \r\n Surname : '+ csWrapper.surname +
                        ' \r\n Organisation : '+ c.SuppliedCompany +
                        ' \r\n Address : '+ csWrapper.address +
                        ' \r\n Town / City : '+ csWrapper.town +
                        ' \r\n Postcode : '+ csWrapper.postcode +
                        ' \r\n Country : '+ csWrapper.country +
                        ' \r\n Email Address : '+ c.SuppliedEmail +
                        ' \r\n Telephone number : '+ c.SuppliedPhone +
                        ' \r\n Internal Contact Email Address : '+ c.ESC_UKI_WebForm_Rep_Email__c +
                        ' \r\n Account Number : '+csWrapper.AcctNum +
                        ' \r\n Invoice Number : '+ csWrapper.invoicenumber +
                        ' \r\n Product Brand : '+ 'Acritas' +
                        ' \r\n Product Name : '+csWrapper.productname+
                        ' \r\n Query Details : '+ c.Description;
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
                                    Acritas_Utility.attachfile(c1,newAttachments);
                                }
                                
                                displayform = false;
                               successPage = true;
                            
                 }                    
}
        
 private void setCaseFields(string querytypeName){

    c.SuppliedName = csWrapper.firstname +' '+ csWrapper.Surname;
        c.Status='New';
        c.ESC_Origin_Name__c=hostURL;
        c.Origin = 'Web';
        c.Sales_Org__c = 'GLI';
        if(((prodWrapper.oProdSection =='General' && querytypeName =='New Project Inquiry') || prodWrapper.oProdSection =='Online' || prodWrapper.oProdSection=='Access') && strsource=='Acritas'){
            c.LCRM_Sub_BU__c='Europe';
            c.BU_Segment__c = 'Professional Legal';
            c.ESC_Unique_Identifier__c = 'Acritas-PS' ;
            
            
        }else{
            c.LCRM_Sub_BU__c = 'UKI';
        }
        c.ESC_Product_Segment_Brand__c = 'Acritas';
        c.Is_GLI__c= true;
        c.ESC_UKI_WebForm_Query_Details__c=c.Description;
        BusinessHours bh = new BusinessHours();
        if(Schema.sObjectType.BusinessHours.isAccessible() || Schema.sObjectType.BusinessHours.isQueryable()){
           bh = [SELECT Id FROM BusinessHours WHERE Name='Europe/London'];
        }
            if(bh !=null){
            c.BusinessHoursId= bh.Id;
            }
         
 }
 private void caseTypeList(List<string> caseTypeList){

    Recordtype rec = new Recordtype();
           if(Schema.sObjectType.recordtype.isAccessible() || Schema.sObjectType.recordtype.isQueryable()){
            rec =[Select id from recordtype where name =:Casetypelist[0]  limit  1];  
           }
           if(rec != null){
             c.recordtypeid =rec.id;
           }  
            c.ESC_Case_Type__c=Casetypelist[0];
           if(Casetypelist[0] =='Incident' || Casetypelist[0] =='Legal Content' || Casetypelist[0] =='Tech Support'){
               c.ESC_Customer_Symptom__c= Casetypelist[1];
               c.ESC_Diagnosis_Summary__c= Casetypelist[2];
               c.Priority= Casetypelist[4];
           }
            else if(Casetypelist[0] =='Enquiry' || Casetypelist[0] == 'Request for Action' ||Casetypelist[0] == 'Feedback' || Casetypelist[0] == 'Request for service'){
               c.ESC_Case_Sub_Type__c= Casetypelist[1];
               c.ESC_EnquiryType__c= Casetypelist[2];
               c.ESC_Sub_Type__c= Casetypelist[3];
               c.Priority= Casetypelist[4];
           }
           if(strsource =='Acritas'){
                c.ESC_UKI_WebForm_Queue_Name__c = Casetypelist[5];
            }
            
 }
 
public void sectionchanged(){   
    tempsectionchanged = true;
    prodWrapper.oProdItemTitles = Acritas_utility.getOProdItemTitles(prodWrapper.oProdSection);
    
 }
 
 private string requiredFieldValidation(){
 
        ErrorFields='';
        List<String> requiredList;
        Map<String,String> parametersMap=New Map<String,String>();
        parametersMap.put('firstname',csWrapper.firstname);
        parametersMap.put('surname',csWrapper.surname);
        parametersMap.put('address',csWrapper.address);
        parametersMap.put('postcode',csWrapper.postcode);
        parametersMap.put('email',c.SuppliedEmail);
        parametersMap.put('Query',c.Description);
        parametersMap.put('productname',csWrapper.productname);
        parametersMap.put('invoicenumber',csWrapper.invoicenumber);
        parametersMap.put('town',csWrapper.town);
        parametersMap.put('country',csWrapper.country);
        parametersMap.put('institution',c.suppliedcompany);
        parametersMap.put('telePhone',c.SuppliedPhone);
        parametersMap.put('querySubject',c.Subject);
        parametersMap.put('repEmail',c.ESC_UKI_WebForm_Rep_Email__c);
        //added for DSS-8368
        
        if(strsource =='Acritas'){
            requiredList= new List<String>{'firstname','surname','address','postcode','email','Query','town','country','querySubject','telePhone'};
            
        }
        for(String req:requiredList){
            if(parametersMap.get(req)==null || parametersMap.get(req)==''){
                ErrorFields+=req;
            }
         }
         return ErrorFields;
 }

    public void itemchanged(){  
        tempitemchanged = true;
        prodWrapper.oProdRenewals = Acritas_Utility.getOProdRenewals(prodWrapper.oProditem);
        if (prodWrapper.oProditem == 'Request for action;Orders, Pricing & Subscriptions;Modify Subscription;Cancel Subscription;3 - Low;UKI Online Order Management'){
            temprenewalchanged = true;
            System.debug('temprenewalchangedlabel--->'+temprenewalchanged);
        }
        else{
            temprenewalchanged = false;
        }
    }
    
    
    
}