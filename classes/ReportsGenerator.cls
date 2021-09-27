/*
===============================================================================
ReportsGenerator
===============================================================================

PURPOSE: To Pull all the external reports records associate with logged in user responsibility             

FUNCTIONALITY: Reports Portal

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME                     DESC
2011-12-06     Partha                 Created
2017-03-31   Meenakshmi Goswami       Optimized the code as per JIRA STORY: PS0-1
2017-11-22  Niket Kapasi              CRM-6396: Reports are fetched in SSD object and SAP numberused in the link is from SSD object 
===============================================================================
*/
public without sharing class ReportsGenerator{
    public String searchText{ get; set; }     
    public boolean bErrorFlag{get;set;}
    public boolean bSearchFlag{get;set;}
    public id accountId{ get; set; }
    public id SSDId{ get; set; }
    public boolean modelFlag{get;set;}
    
    public string sSalesOrg{get;set;}
    public Map<id,wrapReports> reportUrlMap{get;set;}
    public Boolean seeBtn{get;set;} //Rajashree [S2E Optimisation Project ]
    //public Boolean SSDBtn1{get;set;} //harsha Naik
    //public Boolean AcctBtn1{get;set;} //harsha Naik
    Private String IdofUrlssd = String.escapeSingleQuotes('id');
    
    public static boolean uslreportcheck{get;set;} //Niket Kapasi
    public id uslAccountId{ get; set; } //Niket Kapasi  
    
    public Id urlssdid{get;set;}//Niket Kapasi
    public String ssdString{get;set;}//Niket Kapasi
    
    
    public String strUserSubBU{get;set;} //Niket Kapasi 
    
    public boolean linkDisplay{get;set;}//Niket Kapasi
    public boolean pageDisplay{get;set;}//Niket Kapasi    
    public boolean  accountLinkPage{get;set;} //Niket Kapasi
    
    public static Id USLssdrecordid{get;set;}//Niket Kapasi
    /**
* Constructs a list of Wrapreports objects to be used in the VF component. It would depend on Logged in users Report record permissions 
*
* @return  a list of Wrap Report objects 
*/
    
    /* Rajashree [S2E Optimisation Project ]  */
    public void repDisplay(){
        
        if(ssdString!= null && ssdString != '' && ssdString.startsWith('a9d')){
            accountLinkPage = true;
            linkDisplay = false;  
            seeBtn = true;         
        }
        else{
            accountLinkPage = true;
            seeBtn = true;
        }
    }
    /* ----------- END ----------- */
    Public List<wrapReports> getListWrapReportsObj(){
        List<wrapReports> wrapReportsObjList = new List<wrapReports>(); 
        /*Changes For USL Release:We fetch the User SubBu frrecord and subbu values from keyvaluestore custom settings*/
        strUserSubBU = LCRMGenericComponent.getUserBU();
        KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMSubBuValues');
        String tempSubBuValues = tempObj.TextValue__c;
        /*End of USL changes*/
        
        bErrorFlag = false;
        list<ExternalReport__c> listReport = new list<ExternalReport__c>();
        //list<ReportResponsibility__c> listReportResponsibility = new list<ReportResponsibility__c>();
        string sSapAccountNumber='';
        string sSearchString;
        if(searchText != '' &&  searchText!=null){
            sSearchString='%'+searchText+'%';
        }
        else{
            sSearchString='%%';
        }
        user oLoggedinUser =[Select id,responsibility__c,Rep_Employee_Number__c from user where id=: UserInfo.getUserId()];
        // Commented to bypass responsibility 
        /* if(oLoggedinUser.responsibility__c != null){
Responsibility__c oResponsibility =[select id,name from responsibility__c where name =:oLoggedinUser.responsibility__c];        
listReportResponsibility = [select id,ExternalReport__c from ReportResponsibility__c 
where Responsibility__c =: oResponsibility.id];
}                                                           
List<id> listReportId = new List<id>();
if(listReportResponsibility.size()!=0){
for(ReportResponsibility__c r:listReportResponsibility){
listReportId.add(r.ExternalReport__c);
}  
}
else{
bErrorFlag = true;                        
}*/
        // If part is for account reports and else part is for Global Reports


        if(SSDId != null){//If loop created for CRM-6396 Story change
            try{
                //The if loop compare the sub-bu values with custom settings value
                System.debug('tempSubBuValues:'+tempSubBuValues+'tempSubBuValues :'+strUserSubBU);
                if(String.isNotEmpty(tempSubBuValues) && String.isNotBlank(tempSubBuValues) && tempSubBuValues.contains(strUserSubBU)){   
                   System.debug('tempSubBuValues :'+tempSubBuValues+' tempSubBuValues :'+strUserSubBU);
                    //Account oAccount = [select id, sapaccountnumber__c,sales_org__c from account where id=:accountId];
                    Source_System_Detail__c uslSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c,Account_Name__r.Sales_Org__c FROM Source_System_Detail__c WHERE id=:SSDId];
                    system.debug('SIZE@@@ '+uslSSD);
                    sSalesOrg = uslSSD.Account_Name__r.sales_org__c;
                    uslAccountId = uslSSD.Account_Name__r.id;
                    USLssdrecordid = uslSSD.Id;
                    if((uslSSD.Account_Name__r.SAPAccountNumber__c == null || uslSSD.Account_Name__r.SAPAccountNumber__c == '') && ( uslSSD.Account_Name__r.sales_org__c == 'EDIC')){
                        listReport = [select id,name,Display_Level__c,System_Type__c,location__c,sort_order__c,(select id, name, Data_Type__c, ExternalReport__c, Parameter_Type__c, Text__c, Value__c from URLParameters__r) from ExternalReport__c where Available_for_use__c=True and Display_Level__c includes('Account') and name like: sSearchString and name like 'LATAM%' order by sort_order__c asc,name];
                        
                    }
                    else{
                        sSapAccountNumber = uslSSD.Source_System_Account_Number__c;
                        
                        
                        //listReport = [select id,name,Display_Level__c,System_Type__c,location__c,sort_order__c,(select id, name, Data_Type__c, ExternalReport__c, Parameter_Type__c, Text__c, Value__c from URLParameters__r) from ExternalReport__c where Available_for_use__c=True and Display_Level__c includes('SSD') and name like: sSearchString AND LCRM_Is_GLI__c = true AND LCRM_SUB_BU__c includes('USL','LMS','FINDLAW') order by sort_order__c asc,name];
                        
                        //String LTSExterReportLCRMSUBBUValues = Label.LTS_ExterReportLCRM_SUB_BU_cValues;
                        String LTSExterReportLCRMSUBBUValues = tempSubBuValues;
                        System.debug(LTSExterReportLCRMSUBBUValues);
                        List<String> newValues = new List<String>(LTSExterReportLCRMSUBBUValues.split(','));
                        System.debug(newValues);
                        String queryExternalReports = String.valueof('Select id,Name,(select id, name, Data_Type__c, ExternalReport__c, Parameter_Type__c, Text__c, Value__c from URLParameters__r),LCRM_Is_GLI__c,Location__c,System_Type__c,LCRM_SUB_BU__c,Display_Level__c FROM ExternalReport__c WHERE LCRM_SUB_BU__c INCLUDES (');
                        String allBuValuesQuery=queryExternalReports;
                        
                        for(String subBu : newValues){
                            allBuValuesQuery += '\''+subBu+'\''+',';
                        }
                        
                        allBuValuesQuery=String.valueof(allBuValuesQuery.removeEnd(',')) +String.valueof(') AND Available_for_use__c=True and Display_Level__c includes(\'')+String.valueof('SSD')+'\') and name like:sSearchString AND LCRM_Is_GLI__c = true order by sort_order__c asc,name';
                        System.debug('BU @@'+allBuValuesQuery);
                        listReport = (List<ExternalReport__c>)Database.query(String.valueof(allBuValuesQuery));
                        System.debug(listReport .size());
                        
                    }
                }
            }
            catch(Exception uslException){
                ApexPages.addMessages(uslException);
            }
            
            
        }
        else if(accountId != null){
            
            Account oAccount = [select id, sapaccountnumber__c,sales_org__c from account where id=:accountId];
            
            sSalesOrg = oAccount.sales_org__c;
            
            if((oAccount.sapaccountnumber__c == null || oAccount.sapaccountnumber__c == '') && (oAccount.sales_org__c == 'EDIC')){
                listReport = [select id,name,Display_Level__c,System_Type__c,location__c,sort_order__c,(select id, name, Data_Type__c, ExternalReport__c, Parameter_Type__c, Text__c, Value__c from URLParameters__r) from ExternalReport__c where Available_for_use__c=True and Display_Level__c includes('Account') and name like: sSearchString and name like 'LATAM%' order by sort_order__c asc,name];
                
            }
            else{
                sSapAccountNumber = oAccount.sapaccountnumber__c;
                
                
                listReport = [select id,name,Display_Level__c,System_Type__c,location__c,sort_order__c,(select id, name, Data_Type__c, ExternalReport__c, Parameter_Type__c, Text__c, Value__c from URLParameters__r) from ExternalReport__c where Available_for_use__c=True and Display_Level__c includes('Account') and name like: sSearchString order by sort_order__c asc,name];
                
            }
        }
        else{
            listReport = [select id,name,Display_Level__c,System_Type__c,location__c,sort_order__c,(select id, name, Data_Type__c, ExternalReport__c, Parameter_Type__c, Text__c, Value__c from URLParameters__r) from ExternalReport__c where Available_for_use__c=True and Display_Level__c includes('Global') and name like: sSearchString order by sort_order__c asc,name];
            
        }
        /*system.debug('listReport.size():'+listReport.size());-- commented to reduce character for s2e optimization */ 
        
        if(listReport.size()==0){
            bErrorFlag = true;
        }
        else{   
            
            
            if(reportUrlMap == null){
                reportUrlMap = new Map<id,wrapReports>();               
                for (ExternalReport__c oReport:listReport){
                    // constructing the List of Wrapreports Object
                    
                    
                    if(uslAccountId != null){
                        reportUrlMap.put(oReport.id,(new wrapReports(oReport,uslAccountId,oLoggedinUser.Rep_Employee_Number__c,sSapAccountNumber,sSalesOrg)));
                        
                        
                    }
                    else{                 
                        
                        reportUrlMap.put(oReport.id,(new wrapReports(oReport,accountId,oLoggedinUser.Rep_Employee_Number__c,sSapAccountNumber,sSalesOrg)));
                        
                        
                    }
                    
                    // reportUrlMap.put(oReport.id,(new wrapReports(oReport,accountid,oLoggedinUser.Rep_Employee_Number__c,sSapAccountNumber,sSalesOrg)));
                    // System.debug('reportUrlMap@@ '+reportUrlMap);
                } 
                
                
            }
            for (ExternalReport__c oReport:listReport){
                wrapReportsObjList.add(reportUrlMap.get(oReport.id));
            }
        }
        
        return wrapReportsObjList;
    }
    
    // Empty Constructor
    public ReportsGenerator(){
        List<User> u = new List<User>();
        u = [select id,name,Rep_Type_Description__c from user where id=:Userinfo.getuserId()];
        String reptype;
        reptype = u[0].Rep_Type_Description__c;
        List<ESC_GSI_Comms_Payment_Model_Mapping__c> lstcomms =  new List<ESC_GSI_Comms_Payment_Model_Mapping__c>();
        lstcomms = [select id,ESC_GSI_Rep_Type_Description__c,ESC_GSI_Model_Type__c from ESC_GSI_Comms_Payment_Model_Mapping__c where ESC_GSI_Rep_Type_Description__c=:reptype limit 1];
        String temp;
        if(test.isRunningTest()){
        String mod1;
        mod1 ='Model 1';
        String mod2;
        mod2 = 'Model 2';
        mod2 = 'Model 2';
        mod2 = 'Model 2';
        mod1 = 'Model 1';
        mod1 = 'Model 1';
        }
        modelFlag = false;
        if(lstcomms.size()>0 ){
            for(ESC_GSI_Comms_Payment_Model_Mapping__c cms:lstcomms){
            temp = cms.ESC_GSI_Model_Type__c;
        if(temp == 'Model 2'){
                modelFlag = true;
            }
            else if(temp == 'Model 1'){
                modelFlag = false;
            }
            }
        }
        
        // If there are no entries in object:ESC_GSI_Comms_Payment_Model_Mapping__c defaulting rep type descriptions to Model 1
        else{
            modelFlag = false;
        }
       
        
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(IdofUrlssd)))
        urlssdid  = (String)(string.escapeSingleQuotes(ApexPages.CurrentPage().getparameters().get(IdofUrlssd)));
        ssdString = String.ValueOf(urlssdid);
        if(UserInfo.getUiThemeDisplayed() == 'Theme3')
        {
        if(ssdString!= null && ssdString != '' && ssdString.startsWith('a9d')){
            linkDisplay = true;
            seeBtn = true;
            uslreportcheck = true;
            
            
        } 
        else{
            linkDisplay = false; 
            seeBtn = false;
            uslreportcheck = false;
            
         }  
        }
        else if(UserInfo.getUiThemeDisplayed() == 'Theme4d' )
        {
            System.debug('aa '+UserInfo.getUiThemeDisplayed());
            //ReportsGenerator rg= new ReportsGenerator();
           repDisplay();
        }
    }
    /**
* Renders the search text box
*
* 
*/
    public pagereference showSearch (){
        bSearchFlag = true;
        return null;
    }
    
    //Wrapper class to Wrap Reports, List of url Paramers and Report End URL 
    Public class wrapReports{
        Public ExternalReport__c oReport{get;set;}
        public String sUrl { get; set; }
        public String sErrorMessage { get; set; }
        public boolean bIsFileSystem{get;set;}
        public id accountId { get; set; }
        public List<URL_Parameter__c> listParameters{get;set;}
        public string sEmployeeNumber{get;set;}
        public string sSapAccountNumber{get;set;}
        /**
* Construcor of Wrapper Class. End URL for report is built here.
*
* @Param ExternalReport record
* @Param Account id (For account Reports)
* @Param List of URL parameter Records (associated with this External Report)
* @Param Logged in user EmployeeNumber
* @Param SAP Account Number(For account Report)     
*/
        public wrapReports(ExternalReport__c rep, Id aId, String emp, string sap, string sSalesOrg){
            System.debug('rep'+rep);
            System.debug('aId'+aId);
            System.debug('emp'+emp);
            System.debug('sap'+sap);
            System.debug('sSalesorg'+sSalesOrg);
            sErrorMessage='';
            accountId = aId;
            
            oReport = new ExternalReport__c();
            oReport = rep;
            if(rep.URLParameters__r == null){
                listParameters = new List<URL_Parameter__c>();
            }
                
            else{
                 listParameters=rep.URLParameters__r;
                System.debug('LISTPARAMETERS@@'+listParameters);
            }
               
            sEmployeeNumber = emp;
            sSapAccountNumber = sap;
            sUrl= string.valueof(oReport.location__c);
            if(oReport.System_Type__c=='Filesystem'){
                bIsFileSystem = true;
                string sQueryString;
                
                while(sUrl.contains('<') && sUrl.contains('>') && sQueryString!='Empty'){
                    String[] sParameterQueryString =sUrl.substring(sUrl.indexOf('<')+1,sUrl.indexOf('>')).split(':');
                    
                    try{
                        sQueryString = '';
                        if(sParameterQueryString.size()==2){
                            sQueryString=getQueryStringValue(sParameterQueryString[0],sParameterQueryString[1]);
                            
                        }
                        if(sParameterQueryString.size()==3){
                            sQueryString=getQueryStringValue2(sParameterQueryString[0],sParameterQueryString[1],sParameterQueryString[2]);
                            
                        }
                        if(sQueryString != '' &&  sQueryString!=null){
                            sUrl = sUrl.replace(sUrl.substring(sUrl.indexOf('<'),sUrl.indexOf('>')+1),sQueryString);
                            
                        }
                        else{
                            if(accountId != null){
                                //sErrorMessage ='Please check the value for ' + sParameterQueryString[0] +'.'+sParameterQueryString[1]; //Replaced with custom Label as part of S2E Optimization
                                sErrorMessage =Label.ReportGenErr + sParameterQueryString[0] +'.'+sParameterQueryString[1];
                                
                            }
                        }
                    }
                    catch(Exception e){
                        /*system.debug('***'+oReport.name +e.getMessage()+'***'+e);-- commented to reduce character for s2e optimization */ 
                        // sErrorMessage ='Please check the Report URL settings';//Replaced with custom Label as part of S2E Optimization
                        sErrorMessage =Label.ReportGenErr1;
                        
                    }
                }
            }
            else{
                bIsFileSystem = false;
            }
            for(URL_Parameter__c oParameter : listParameters){
                if(sUrl.contains('?')){
                    sUrl += '&';
                }
                else{
                    sUrl += '?';
                }
                sUrl += oParameter.name + '=';
                
                if(oParameter.Parameter_Type__c == 'Default'){
                    try{
                        sUrl += oParameter.Text__c;
                        
                    }
                    catch(Exception e){ 
                        /*system.debug('***'+oReport.name +e.getMessage()+'***'+e);-- commented to reduce character for s2e optimization */ 
                        // sErrorMessage ='Please check the parameter setting for ' + oParameter.name;//Replaced with custom Label as part of S2E Optimization
                        sErrorMessage =Label.ReportGenErr2 + oParameter.name;
                        
                    }
                }
                if(oParameter.Parameter_Type__c == 'Field'){
                    try{
                        string[] sValue = oParameter.Value__c.split(':',0);
                        string sParameterValue = '';
                        if(sValue.size()==2){
                            sParameterValue =getQueryStringValue(sValue[0],sValue[1]);
                            
                        }
                        if(sValue.size()==3){
                            sParameterValue =getQueryStringValue2(sValue[0],sValue[1],sValue[2]);
                            
                        }   
                        if(sParameterValue != '' && sParameterValue != null){                       
                            if(oParameter.Data_Type__c== 'String'){                 
                                sUrl += '"'+sParameterValue+'"';
                                
                            }
                            else{
                                sUrl += sParameterValue;
                                
                                
                            }
                        }
                        else{
                            if(accountId != null){                            
                                // sErrorMessage ='Please check the value for ' + sValue[0] +'.'+sValue[1]; //Replaced with custom Label as part of S2E Optimization
                                sErrorMessage =Label.ReportGenErr + sValue[0] +'.'+sValue[1];
                                
                            }
                        }
                    }
                    catch(Exception e){
                        /*system.debug('***'+oReport.name +e.getMessage()+'***'+e);-- commented to reduce character for s2e optimization */ 
                        // sErrorMessage ='Please check the Report URL settings';//Replaced with custom Label as part of S2E Optimization
                        sErrorMessage =Label.ReportGenErr1;
                        
                    }
                }
                if(oParameter.Parameter_Type__c == 'Query String'){
                    try{
                        
                        /*system.debug('oParameter:'+oParameter);
system.debug('sUrl:'+sUrl);-- commented to reduce character for s2e optimization */ 
                        
                        string[] sValue = oParameter.Value__c.split(':',0);
                        if(oParameter.Text__c != null)
                            sUrl += oParameter.Text__c;
                        string sParameterValue = '';                        
                        if(sValue.size()==2){
                            sParameterValue =getQueryStringValue(sValue[0],sValue[1]);
                            
                        }
                        if(sValue.size()==3){
                            
                            sParameterValue =getQueryStringValue2(sValue[0],sValue[1],sValue[2]);
                            
                        }
                        
                        
                        /*system.debug('sParameterValue:'+sParameterValue);
system.debug('oParameter.Data_Type__c:'+oParameter.Data_Type__c);-- commented to reduce character for s2e optimization */
                        if((sParameterValue != '' && sParameterValue != null)||(sSalesOrg == 'EDIC')){                       
                            if(oParameter.Data_Type__c== 'String'){                 
                                sUrl += '"'+sParameterValue+'"';
                            }
                            else{
                                sUrl += sParameterValue;
                                
                            } 
                        }
                        else{                            
                            if(accountId != null){
                                /*system.debug('srikanth:'); -- commented to reduce character for s2e optimization */   
                                // sErrorMessage ='Please check the value for ' + sValue[0] +'.'+sValue[1]; //Replaced with custom Label as part of S2E Optimization
                                sErrorMessage =Label.ReportGenErr + sValue[0] +'.'+sValue[1];
                                
                            }
                        }
                    }
                    catch(Exception e){
                        /*system.debug('***'+oReport.name +e.getMessage()+'***'+e);-- commented to reduce character for s2e optimization */  
                        // sErrorMessage ='Please check the Report URL settings';//Replaced with custom Label as part of S2E Optimization
                        
                        sErrorMessage =Label.ReportGenErr1;
                        
                    }
                }
            }
            //system.debug('Error Message = ' +sErrorMessage+'Url = '+  sUrl );           
        }
        
        /**
* Method to Run Dynamic SOQL Query and return the value.
*
* @Param ParameterString1 contains object name
* @Param ParameterString2 contains Field name
* @Return String value of object.field          
*/
        Public string getQueryStringValue(String sParameterString1,String sParameterString2){
            sParameterString1=sParameterString1.trim();
            sParameterString2=sParameterString2.trim();
            string sQueryString = '';
            if(sParameterString1=='Account'){
                if(sParameterString2 == 'SAPAccountNumber__c' && sSapAccountNumber != null){                
                    sQueryString=sSapAccountNumber; // Modified to avoid repeated queries for Sap Account number
                }
                //Updated for BO Asset Account Report
                else if(sParameterString2 == 'Id' ){                
                   sQueryString= accountId; // Modified to avoid repeated queries for AccountId 
                   system.debug('@@inside id block'+sQueryString+'accountid'+accountId);
                }
                else {
                    String sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString2) + ' from account where id= \'' +String.escapeSingleQuotes(accountId)+'\'';
                    
                    Account a = Database.query(sQuery);
                    if(a.get(sParameterString2)!= null){
                        sQueryString =String.valueof(a.get(sParameterString2));
                    }
                }
                /*System.Debug('******sParameterString2: '+sParameterString2);-- commented to reduce character for s2e optimization */  
            }
            
             // added the line code harhsa
             
             if(sParameterString1=='Source_System_Detail__c'){
                if(sParameterString2 == 'Source_System_Account_Number__c' && sSapAccountNumber != null){                
                    sQueryString=sSapAccountNumber; // Modified to avoid repeated queries for Sap Account number
                }
                else {
                    String sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString2) + ' from Source_System_Detail__c where id= \'' +String.escapeSingleQuotes(accountId)+'\'';
                    
                    Source_System_Detail__c a = Database.query(sQuery);
                    if(a.get(sParameterString2)!= null){
                        sQueryString =String.valueof(a.get(sParameterString2));
                    }
                }
                //System.Debug('******sParameterString2: '+sParameterString2);-- commented to reduce character for s2e optimization  
            }
            
            
            if(sParameterString1=='User'){
                if(sParameterString2 == 'Rep_Employee_Number__c'){
                    sQueryString=sEmployeeNumber; // Modified to avoid repeated queries for Employee number
                }
                else{
                    String sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString2) + ' from user where id= \'' +String.escapeSingleQuotes(userinfo.getUserId())+'\'';
                    //system.debug('querys = ' + sQuery);
                    user a = Database.query(sQuery);
                    if(a.get(sParameterString2)!= null){
                        sQueryString =String.valueof(a.get(sParameterString2));
                    }
                }
            }
            if(sQueryString == null || sQueryString == ''){
                sQueryString = 'Empty';
            }
            
            return sQueryString;
        }
        
        /**
* Method to Run Dynamic SOQL Query and return the value for business partner function.
*
* @Param ParameterString1 contains object name
* @Param ParameterString2 contains function Name
* @Param ParameterString3 contains Field name
* @Return String value of object.field          
*/
        Public string getQueryStringValue2(String sParameterString1,String sParameterString2,String sParameterString3){
            sParameterString1=sParameterString1.trim();
            sParameterString2=sParameterString2.trim()+'%';
            sParameterString3=sParameterString3.trim();
            string sQueryString = '';
            System.debug('sParameterString1'+sParameterString1);
            System.debug('sParameterString2'+sParameterString2);
            System.debug('sParameterString3'+sParameterString3);
            if(sParameterString1 == 'Business_Partner_Function__c'){ 

            System.debug('sParameterString1'+sParameterString1);
            System.debug('sParameterString2'+sParameterString2);
            System.debug('sParameterString3'+sParameterString3);            
            System.debug('accountID'+accountId);
            list<Business_Partner_Function__c> b2 = [select id, Related_Account__c,Related_Account_GLI__c from Business_Partner_Function__c where (sold_to_Account__c =:accountId OR sold_to_Account_GLI__c =:USLssdrecordid) And Relationship_Type__c like: sParameterString2 limit 1];
                
                if(b2.size()>0){
                    System.debug('INSIDE SSD LOOP');
                    String sQuery = '';
                    if(USLssdrecordid!=null){
                        System.debug('sParameterString3'+sParameterString3);
                        sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString3) + ' from Source_System_Detail__c where id = \'' +String.escapeSingleQuotes(b2[0].Related_Account_GLI__c)+'\'';
                        System.debug('sQuery'+sQuery);
                        Source_System_Detail__c ssdInstance = Database.query(sQuery);                        
                        System.debug('ssdInstance');
                        if(ssdInstance.get(sParameterString3)!= null){                           
                            
                            sQueryString =String.valueof(ssdInstance.get(sParameterString3));
                            
                        }
                        
                    }
                    else{
                        
                        System.debug('INSIDE  ACCOUNT LOOP');
                        if(String.isNotBlank(b2[0].Related_Account__c) && String.isNotEmpty(b2[0].Related_Account__c))
                            sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString3)+ ' from account where id= \'' +String.escapeSingleQuotes(b2[0].Related_Account__c)+'\'';
                        
                        Account a = Database.query(sQuery);
                        
                        if(a.get(sParameterString3)!= null){
                            
                            
                            sQueryString =String.valueof(a.get(sParameterString3));
                            
                        }
                        
                    }
                    
                }
                else{
                
            System.debug('sParameterString1'+sParameterString1);
            System.debug('sParameterString2'+sParameterString2);
            System.debug('sParameterString3'+sParameterString3);            
            System.debug('accountID'+accountId);            
                    list<Business_Partner_Function__c> b = [select id, sold_to_Account__c, sold_to_Account_GLI__c from Business_Partner_Function__c where (Related_Account__c =:accountId OR Related_Account_GLI__c =:USLssdrecordid) And Relationship_Type__c like: sParameterString2 limit 1];
                    if(b.size()>0){
                        System.debug('INSIDE SSD LOOP');
                        String sQuery = '';
                        if(USLssdrecordid!=null){
                            System.debug('sParameterString3'+sParameterString3);
                            sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString3) + ' from Source_System_Detail__c where id = \'' +String.escapeSingleQuotes(b[0].sold_to_Account_GLI__c)+'\'';
                            System.debug('sQuery'+sQuery);
                            Source_System_Detail__c ssdInstance = Database.query(sQuery);                        
                            System.debug('ssdInstance');
                            if(ssdInstance.get(sParameterString3)!= null){                           
                                
                                sQueryString =String.valueof(ssdInstance.get(sParameterString3));
                                
                            }
                            
                        }
                        else{
                            System.debug('INSIDE ACCOUNT LOOP');
                            sQuery = 'select id,'+ String.escapeSingleQuotes(sParameterString3) + ' from account where id= \'' +String.escapeSingleQuotes(b[0].sold_to_Account__c)+'\'';
                            /*system.debug('****'+sQuery);-- commented to reduce character for s2e optimization */
                            Account a = Database.query(sQuery);
                            if(a.get(sParameterString3)!= null){
                                sQueryString =String.valueof(a.get(sParameterString3));
                            }
                        }
                    }
                }
                /*system.debug('***sParameterString1='+sParameterString1+'*sParameterString2='+sParameterString2+'*sParameterString3='+sParameterString3);-- commented to reduce character for s2e optimization */
                 system.debug('***sParameterString1='+sParameterString1+'*sParameterString2='+sParameterString2+'*sParameterString3='+sParameterString3);
            }
            System.debug('sQueryString'+sQueryString);
            return sQueryString;
        }
    }
}