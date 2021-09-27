/*============================================================================================
Name                : ContactsListConCallout
Description         : This class is developed as part of CXD-ODT project and it is a helper class for contactsListCon class
Created Date        : 3/15/2018
Author              : TCS CXD ODT team

Enhancements:
Date          Name                Jira        Description
1)  01-05-2020    Rahul Natarajan    DLT-19818   ODT track Product Details is not dynamically sent from SFDC to Eloqua
2)  24-05-2020    Rahul Natarajan    DLT-20201   ODT-[ALL][SFDC] Rep extended an existing trial through SFDC, Eloqua should not receive a value of "null"
3)  12-11-2020    Brenda Shields     DLT-21106   Update parameter name from uniqueID to odtuniqueid via new label and fix PMD errors
4)	22-01-2021	  Ameeta A			 DLT-21255	 Update opportunity id in postback to eloqua
=====================================================================================================================================*/

public class ContactsListConCallout implements Queueable, Database.AllowsCallouts {
    private string fname;
    private string lname;
    private string email;
    private string sapAId;
    private string sapCId;
    private string sfdcAId;
    private string sfdcCId;
    private string appGUId;
    private string sDomain;
    private string scustomer;
    //private ID LId;
    private ID oppId;
    private ID tId; 
    private String companyName;
    private string urlType; // Added aspart of V2 URL solution 
    
    private string trs;
    private string trsc; 
    private date tred;
    private boolean ep;
    private boolean ec; 
    private boolean islapsed; 
    private boolean isAdduser;
    private boolean isReactivate;
    private date trialStartDate;
    
    string rawURL;
    string trialSource = trsc;
    string trialResendInvURL = '';
    String trialReactivateURL='';
    String lapsedAccURL = '';
    string trialstatus = 'Invite';
    string prodCategory;    
    String prodName;
    Invite_Colleagues__c ic = new Invite_Colleagues__c();
    public Trial__c trial{get;set;}
    
    public ContactsListConCallout(string firstname, string lastName, string email, String sapAcctID, String sapContID, String sfdcAcctID, String sfdcContID,String appGUID, 
                                  string selectedDomain, string selectedcustomer, id opportunityId, id trialId, String compName, string urlType, string ts, string tsc, 
                                  date ted, boolean ep, boolean ec, boolean islapsed, boolean isAdduser, boolean isReactivate, date trStartDate){
                                      system.debug(LoggingLevel.INFO, 'Constructor callout');
                                      this.fname = firstname;
                                      this.lname = lastName;
                                      this.email = email;
                                      this.sapAId = sapAcctID;
                                      this.sapCId = sapContID;
                                      this.sfdcAId = sfdcAcctID;
                                      if(sfdcContID != null){
                                          this.sfdcCId = sfdcContID;
                                      } else {
                                          this.sfdcCId = '';
                                      }
                                      
                                      this.appGUId = appGUID;
                                      this.sDomain = selectedDomain;
                                      this.scustomer = selectedcustomer; 
                                      //this.LId = leadId;
                                      this.oppId = opportunityId;
                                      this.tId = trialId;
                                      this.companyName = compName; 
                                      this.urlType = urlType;
                                      this.trs = ts;
                                      this.trsc = tsc;
                                      this.tred = ted;
                                      this.ep = ep;
                                      this.ec = ec;
                                      this.islapsed = islapsed;
                                      this.isAdduser = isAdduser;
                                      this.isReactivate = isReactivate; 
                                      this.trialStartDate=trStartDate;                              
                                  }
/********************************************************************************************************
@description execute: execute Method of the batch class.
@param QueueableContext context
*********************************************************************************************************/ 
    public void execute(QueueableContext context) {
        
        System.debug(LoggingLevel.INFO, 'execute callout started.......' + tId); 
        trial = [SELECT ID,Name,Trial_Initiated_Mode__c,ODT_Email__c,Profile_Type__c,ODT_SAP_Account_Number__c,Contact_id_SAP__c, 
                 ODT_Product_Bundle__r.Bundle_ID__c, ODT_Product_Bundle__r.cellcode__c, Source_System_Detail__c, Source_System_Detail__r.Name, Source_System_Detail__r.LCRM_Phone__c, Source_System_Detail__r.Country__c, Source_System_Detail__r.Postal_Code__c, ODT_Product_Bundle__r.Business_Type__c,ODT_Product_Bundle__r.Trial_Expiry_Days__c, Unique_Identifier__c,
                 (SELECT ID, Email__c, First_Name__c, Last_Name__c, Trial__r.trial_source__c, Trial__r.ODT_SAP_Account_Number__c, Trial__r.Contact_id_SAP__c, Trial__r.Global_Trial_ID__c, Trial__r.ODT_Email__c, Trial__r.Trial_Start_Date__c, Trial__r.Trial_End_Date__c, Trial__r.ODT_Trial_Product_Category__c, SapContactId__c, Trial__c, User_Auth_ID__c, Trial__r.Is_Lapsed__c
                  FROM Invite_Colleagues__r WHERE Trial_Status__c='Rep Initiated' OR Trial_Status__c='Accepted' OR Trial_Status__c='Invited' OR Trial_Status__c='Ended') 
                 FROM Trial__c where id =: tId];
        
        
        
        for (Invite_Colleagues__c iclist : trial.Invite_Colleagues__r) {
            ic = iclist;
        } 
        
        list<ODT_Product_Bundle__c> listPrdBundle = [SELECT ID, Name, Bundle_ID__c, Bundle_Type__c, Company_Code__c, Product_Category__c 
                                                     from ODT_Product_Bundle__c 
                                                     WHERE Is_Enabled_For_Sales_Rep_Trial__c = TRUE AND Is_Active__c = TRUE 
                                                     AND Bundle_Type__c = 'CTX' ORDER BY Bundle_Order__c ASC ];
        
        mapProdCategory(listPrdBundle);
        
        
        WebServiceSettings__c oWebServiceSettings2;    
        HttpRequest req = new HttpRequest();    
        
        
        
        if (trs != null) {
            trialstatus = trs;
        }
        
        if (trsc == 'SFDC') {
            oWebServiceSettings2 = AppUtil.getWebServiceSettings('ODTEloquaServiceSFDCSource');
        } else {
            oWebServiceSettings2 = AppUtil.getWebServiceSettings('ODTEloquaServiceOtherSources');
        }
        
        mapResendReactUrl();
        
        mapLapsedUrl();   
        
        if (urlType.containsIgnoreCase('V2')) {
            
            processRawUrl();
            system.debug(LoggingLevel.INFO, 'Final rawURL ContactsListConCallout ......... ' + rawURL);  
            
            req.setEndpoint(oWebServiceSettings2.Endpoint__c+'&'+rawURL );
            
        } // end of V2
        
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setTimeout(120000);
        
        Http http = new Http();
        HTTPResponse res;
        if (!test.isrunningtest()) {  
            res = http.send(req);
        } else {
            // Code for test classes.......
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Success');
            res.setStatusCode(200); 
        }
        system.debug(LoggingLevel.INFO, '0.......'+req);
        system.debug(LoggingLevel.INFO, 'BODY:......... '+res.getBody());
        system.debug(LoggingLevel.INFO, 'STATUS:'+res.getStatus());
        system.debug(LoggingLevel.INFO, 'STATUS_CODE:'+res.getStatusCode());
        
        //if (res.getStatusCode()==200) {
        //}
        
        try {
            //create Note Record
            if (String.isNotBlank(tId)) {
                CallToOLCTofetchActiveTr.createNote(tId, String.valueOf(req));
            }
        } catch (Exception e) {
            DCUtils.trackLog(e,'ContactsListConCallout','CallToOLCTofetchActiveTr.createNote');
            
        }
    }
 
/********************************************************************************************************
@description setSSDCompany: set SSD details on post back URL.
@param Trial__c trial
@returns String strRawURL
*********************************************************************************************************/
    private string setSSDCompany(Trial__c trial) {
        string strRawURL = '';
        
        if ((trial.Source_System_Detail__r.Name != null) && (trial.Source_System_Detail__r.Name != '')) {
            strRawURL += '&companyName='+trial.Source_System_Detail__r.Name;  
        }
        if ((trial.Source_System_Detail__r.LCRM_Phone__c != null) && (trial.Source_System_Detail__r.LCRM_Phone__c != '')) {
            strRawURL += '&Phone='+trial.Source_System_Detail__r.LCRM_Phone__c;  
        }
        if ((trial.Source_System_Detail__r.Country__c != null) && (trial.Source_System_Detail__r.Country__c != '')) {
            strRawURL += '&country='+trial.Source_System_Detail__r.Country__c;  
        }
        if ((trial.Source_System_Detail__r.Postal_Code__c != null) && (trial.Source_System_Detail__r.Postal_Code__c != '')) { 
            strRawURL += '&zipcode='+trial.Source_System_Detail__r.Postal_Code__c; 
        }  
        return strRawURL;
    }
 
/********************************************************************************************************
@description processRawUrl: set URL parameters for post back URL to Eloqua.
*********************************************************************************************************/  
    private void processRawUrl(){
        String startDate='';
        String endDate='';
        
        if (this.trialStartDate != null && this.tred != null) {
            startDate=String.valueOf(this.trialStartDate); 
            endDate=String.valueOf(this.tred);   
        }
        
        rawURL ='emailAddress='+this.email+'&trialrecordId='+this.tId+'&trialStatus='+trialstatus +'&TrialSource='+trsc +'&trialcategory='+prodCategory+'&firstName='+this.fname+'&lastName='+this.lname+'&TrialStartDate='+startDate+'&TrialEndDate='+endDate+'&retURL=';   
        
        //  DLT-20201  Starts
        mapUrlWithCompanyDetails(trial);
        
        
        rawURL +='&customerType='+trial.Profile_Type__c;
        
        // DLT-21106 - parm name has changed - use label to get parameter text ODT_Unique_ID_Parameter
        if ((trial.Unique_Identifier__c != null) && (trial.Unique_Identifier__c != '')) {
            rawURL += Label.ODT_Unique_ID_Parameter + trial.Unique_Identifier__c;
        }
        if (trialResendInvURL != '') {    
            rawURL += trialResendInvURL;  
        }    
        if (trialReactivateURL != '') {
            rawURL += trialReactivateURL;  
        }   
        
        if (isLapsed == TRUE) {
            rawURL += lapsedAccURL;
        }
        
        if (trial.Trial_Initiated_Mode__c == 'Started Immediately') {
            rawURL += '&repType=Started';
        } else {
            rawURL +='&repType=Initiated';
        }
        
        mapUrlWithAccConOppDetails(trial);
        
        mapUrlWithBundleDetails(trial);
        
        
        
        
    }
 
/********************************************************************************************************
@description mapProdCategory: map product category from bundle.
*********************************************************************************************************/
    private void mapProdCategory(list<ODT_Product_Bundle__c> listPrdBundle){
        if (!listPrdBundle.isEmpty()) {
            for (ODT_Product_Bundle__c odtprods : listPrdBundle) {
                if (odtprods.Bundle_ID__c == this.sDomain) {
                    prodCategory = odtprods.Product_Category__c;
                    prodName = odtprods.Name;
                } 
            }
        }
    }
    
/********************************************************************************************************
@description mapResendReactUrl: map URL with Resend and Reactivate trial parameters required in post back.
*********************************************************************************************************/
    private void mapResendReactUrl(){
        if (trs == 'reSend' && ep != null && ec != null ) {
            trialResendInvURL ='&emailResendP='+ep+'&emailResendC='+ec;   
        }
        
        if (isReactivate == true && trs == 'accepted' && ep != null && ec != null ) {
            trialReactivateURL ='&reactivateP='+ep+'&reactivateC='+ec+'&isLapsed='+isLapsed+'&addUser='+isAdduser;   
        }
        
        
    }
 
/********************************************************************************************************
@description mapLapsedUrl: map URL with Lapsed account parameters required in post back.
*********************************************************************************************************/
    private void mapLapsedUrl(){
        if (isLapsed == TRUE && isAdduser == false && isReactivate == false) {
            lapsedAccURL ='&isLapsed='+isLapsed;   
        }
    }

/********************************************************************************************************
@description mapUrlWithCompanyDetails: map URL with Org details required in post back.
@param Trial__c trial
*********************************************************************************************************/    
    private void mapUrlWithCompanyDetails(Trial__c trial){
        if ((this.companyName != null) && (this.companyName != '')) {
            rawURL += '&companyName='+this.companyName;
        } else if (trial.Source_System_Detail__c != null) {
            rawURL += setSSDCompany(trial);  
        }
        
        if ((trial.ODT_Product_Bundle__r.Business_Type__c != null) && (trial.ODT_Product_Bundle__r.Business_Type__c != '')) {
            rawURL += '&organizationType='+trial.ODT_Product_Bundle__r.Business_Type__c;
        }
    }
 
/********************************************************************************************************
@description mapUrlWithAccConOppDetails: map URL with Account,Contact and Opportunity details required in post back.
@param Trial__c trial
*********************************************************************************************************/ 
    private void mapUrlWithAccConOppDetails(Trial__c trial){
        string strProfileType;
        if (trial.Profile_Type__c == 'NET_NEW') {
            strProfileType = '&olc';
        } else {
            strProfileType = '&sap';
        }
        if ((trial.ODT_SAP_Account_Number__c != null) && (trial.ODT_SAP_Account_Number__c != '')) { 
            rawURL += strProfileType + 'AccountId=' + trial.ODT_SAP_Account_Number__c;
        }
        if ((trial.Contact_id_SAP__c != null) && (trial.Contact_id_SAP__c != '')) {
            rawURL += strProfileType + 'ContactId=' + trial.Contact_id_SAP__c;
        }
        //  DLT-20201  Ends
        if(oppId != null){
            rawURL += '&opportunityId=' + oppId; 
        }       
        if(String.IsNotBlank(trial.Source_System_Detail__c)){
            rawURL +='&accountSSD='+trial.Source_System_Detail__c;
        }
    }
 
/********************************************************************************************************
@description mapUrlWithBundleDetails: map URL with Bundle details required in post back.
@param Trial__c trial
*********************************************************************************************************/
    private void mapUrlWithBundleDetails(Trial__c trial){
        //  DLT-19818  Starts
        if (trial.ODT_Product_Bundle__r.Trial_Expiry_Days__c != null) {
            rawURL +='&trialLength='+trial.ODT_Product_Bundle__r.Trial_Expiry_Days__c;
        }
        if (trial.ODT_Product_Bundle__r.Bundle_ID__c != null) {
            rawURL +='&trialId='+trial.ODT_Product_Bundle__r.Bundle_ID__c;
        }
        if (trial.ODT_Product_Bundle__r.cellcode__c != null) {
            rawURL +='&cellCode='+trial.ODT_Product_Bundle__r.cellcode__c;
        }
        //  DLT-19818 Ends
        
        if (trial.Trial_Initiated_Mode__c == 'Started Immediately' && trial.ODT_Email__c == ic.Email__c ) {
            rawURL += '&addUser=false&isPrimaryRequester=true';
        }  
        if (rawURL.contains(' ')) {
            rawURL = rawURL.replaceAll(' ','_');
        }
    }
}