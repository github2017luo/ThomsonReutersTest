/**
* Contains methods for ServiceNotes VF Page
* Depends on ServiceNotesServices Class
* Depends on ServiceNotesServicesWS and  ServiceNotesServicesWS Objects Class which are created using the wsdl file
* Contains the method to build the request to get the list of service notes based on the date range entered on the VF page.
* Contains the method to build the request to get the detail of the service note selected on the VF page
*
* @author  Srikanth Kuruva
* @version  2012-12-13
*/
/**
* CHANGE HISTORY 
* ======================================================================================================================================
* Date         Name                    Description
* 2012-10-20   Sripriya Kongot         Modified - QC 2159 Fixed the sorting issue - Results will be sorted DESC by                                      CreatedDate
* 2012-10-20   Sripriya Kongot         Modified - QC 2140 Added pagination to display the results
* 2017-03-31   Karthi                  Optimized the code as per JIRA STORY: PS0-1
*2017-10-11    Niket                   Developed functionality for CRM-7742[Lift and shift of SAP number from Account to SSD]
*2020-08-20    Ramesh T N              Given fix to avoid Null pointer exception and Error mesaage Handling issues as part of FSC-49
* =======================================================================================================================================
*/
public without sharing class ServiceNotes {
    public Account oAccount{get;set;}      
    public string dFromDt{get;set;}
    public string dToDt{get;set;}
    public string serviceNoteDetailId{get;set;}     
    public List<ServiceNotesServices.ServiceNoteItem> listServiceNotes{get;set;}      
    public ServiceNotesServices.ServiceNoteItem ServiceNoteDetail{get;set;}
    public List<ServiceNotesServices.ServiceNoteActivity> listServiceNoteActivities{get;set;}
    public String snId{get;set;}
    public Boolean RenderServiceNoteList{get;set;}
    public Boolean RenderServiceNoteDetail{get;set;}
    public String FilterByDepartmentValue{get;set;}
    public Boolean showFilter{get;set;}
    //public CustomDate__c DateRange{get;set;}
    public List<ServiceNotesServices.ServiceNoteItem> listServiceNotesResult{get;set;}
    public ServiceNoteItems ServiceNotesResults {get;set;}    
    public string UserBusinessUnit{get;set;}//CRM-7742 
    public Boolean SSDFlag = false; // FSC-49
    
    
    
    public ServiceNotes(ApexPages.StandardController controller) { 
        oAccount = new account();
        oAccount = (account) controller.getRecord();
        //oAccount = [select ParentId,SAPAccountNumber__c, id from Account where id = :oAccount.Id];
        //Query modified for CRM-7742
        
       if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Source_System_Detail__c.isAccessible())
        oAccount = [Select Id,ParentId,SAPAccountNumber__c,(Select Source_System_Account_Number__c FROM Source_System_Details__r WHERE LCRM_Sales_Org__c = 'West') FROM Account WHERE Id =:oAccount.Id];
        //oAccount.AccountInceptionDate__c = System.Today().addMonths(-1);        
        //oAccount.Last_Trained__c = System.Today();
        //DateRange = new CustomDate__c(Begin_date__c=system.today().addMonths(-1),End_date__c= system.today());
        dFromDt = system.today().addMonths(-1).format();
        dToDt = system.today().format();
        PageReference pg = getlistServiceNoteItems(); 
        ServiceNotesResults = new ServiceNoteItems();
    }
    
    /*
Description: pagereference method to get service note details   
*/
    public PageReference getlistServiceNoteItems()
    {
        try{
            //if(dFromDt == '' || dFromDt == null){
            
            if(String.isBlank(dFromDt) || String.isEmpty(dFromDt) || String.isBlank(dToDt) || String.isEmpty(dToDt)){
                
                /*system.debug('dFromDt :'+dFromDt +'dToDt :'+dToDt);-- commented to reduce character for s2e optimization */
                ApexPages.Message mErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Please_enter_the_Date_Range);
                
                ApexPages.addMessage(mErrorMsg);                
            }
            else{
                RenderServiceNoteList = true;
                RenderServiceNoteDetail = false;
                ServiceNotesServices.ServiceNotesRequest oServiceNotesRequest = new ServiceNotesServices.ServiceNotesRequest();
                oServiceNotesRequest.sSystemId = 'SFDC CORE LEGAL';
                String UserBusinessUnit = LCRMGenericComponent.getUserBU();
                
                /*===================================CRM 7742
Description: For LCRM the below if/else loop handles the code for SAP Number which is mandatory to fetch service note and service note item details.
Here if the account contains the SAP number in SSD account and UserBusinessUnit is either USL,LMS or Findlaw then only the service notes results will be fetched for Legal CRM.
==========================================*/
                if (oAccount.ParentId != null){
                    
                    Set<Decimal> setUSLSAPAccountNumbers = new Set<Decimal>();
                    List<Decimal> listUSLSAPAccountNumbers = new List<Decimal>();
                    
                    if(((oAccount.Source_System_Details__r) != null) && (!(oAccount.Source_System_Details__r).isEmpty()) && (UserBusinessUnit == 'USL' || UserBusinessUnit=='LMS' || UserBusinessUnit == 'FindLaw')){
                        for(Source_System_Detail__c Ssd : oAccount.Source_System_Details__r){
                            
                            
                            setUSLSAPAccountNumbers.add(Decimal.valueOf(Ssd.Source_System_Account_Number__c));
                            
                            //oServiceNotesRequest.dcAcctSAPId = new Decimal[]{Decimal.valueOf(Ssd.Source_System_Account_Number__c)};
                        }
                        listUSLSAPAccountNumbers.addAll(setUSLSAPAccountNumbers);
                        oServiceNotesRequest.dcAcctSAPId = listUSLSAPAccountNumbers; 
                    }
                    else if(oAccount.SAPAccountNumber__c != null){
                        oServiceNotesRequest.dcAcctSAPId = new Decimal[]{Decimal.valueOf(oAccount.SAPAccountNumber__c)};
                            }
                    else{
                        // FSC-49 commented error message
                        if(((oAccount.Source_System_Details__r).isEmpty()) && UserBusinessUnit == 'USL' || UserBusinessUnit=='LMS' || UserBusinessUnit == 'FindLaw'){
                        
                            ApexPages.Message LCRMssdErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Account_source_system_detail_not_found);
                            
                            //ApexPages.addMessage(LCRMssdErrorMsg); 
                            oServiceNotesRequest.dcAcctSAPId = new Decimal[]{Decimal.valueOf('0')};
                                }
                        else{
                            oServiceNotesRequest.dcAcctSAPId = new Decimal[]{Decimal.valueOf('0')};
                                }
                        // oServiceNotesRequest.dcAcctSAPId = new Decimal[]{Decimal.valueOf('0')};
                    }}
                else{
                    Set<Id> setChildAccountIds = AccountDetailController.getChildAccountIds(oAccount.Id);
                    Set<Decimal> setSAPAccountNumbers = new Set<Decimal>();
                    
                    
                    
                    for (Account acc : [Select Id,ParentId,SAPAccountNumber__c,(Select Source_System_Account_Number__c FROM Source_System_Details__r WHERE LCRM_Sales_Org__c = 'West') FROM Account WHERE Id IN :setChildAccountIds]){
                        
                        
                        // FSC-49 Added null check and setting up SSDFlag
                        if((acc.Source_System_Details__r) != null && !(acc.Source_System_Details__r).isEmpty()  && (UserBusinessUnit == 'USL' || UserBusinessUnit=='LMS' || UserBusinessUnit == 'FindLaw')){
                            
                            for(Source_System_Detail__c Ssd : acc.Source_System_Details__r){
                                if(Ssd.Source_System_Account_Number__c != null && !setSAPAccountNumbers.contains(Decimal.valueOf(Ssd.Source_System_Account_Number__c)))
                                    setSAPAccountNumbers.add(Decimal.valueOf(Ssd.Source_System_Account_Number__c)); 
                                    SSDFlag = true;                               
                            }
                        }
                        else if(acc.SAPAccountNumber__c != null){
                            if(!setSAPAccountNumbers.contains(Decimal.valueOf(acc.SAPAccountNumber__c)))
                                setSAPAccountNumbers.add(Decimal.valueOf(acc.SAPAccountNumber__c));
                                SSDFlag = true;
                        }
                        else{
                        /*
                            if(UserBusinessUnit == 'USL' || UserBusinessUnit=='LMS' || UserBusinessUnit == 'FindLaw'){
                                ApexPages.Message LCRMssdErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Account source system detail not found ');
                                
                                ApexPages.addMessage(LCRMssdErrorMsg); 
                                setSAPAccountNumbers.add(Decimal.valueOf('0'));
                            }
                            else{
                                setSAPAccountNumbers.add(Decimal.valueOf('0'));
                            }
                         */
                            setSAPAccountNumbers.add(Decimal.valueOf('0'));
                            
                        }
                        
                    }
                    
                    // FSC-49 Error message will throw if any of the SSD Contains SAPAccountNumber__c
                   if(!SSDFlag && (UserBusinessUnit == 'USL' || UserBusinessUnit=='LMS' || UserBusinessUnit == 'FindLaw')){
                        ApexPages.Message LCRMssdErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Account source system detail not found ');
                        ApexPages.addMessage(LCRMssdErrorMsg); 
                    }
                    
                    List<Decimal> listSAPAccountNumbers = new List<Decimal>();
                    
                    listSAPAccountNumbers.addAll(setSAPAccountNumbers);
                    
                    oServiceNotesRequest.dcAcctSAPId = listSAPAccountNumbers; 
                    
                }
                //oServiceNotesRequest.dBegDt = oAccount.AccountInceptionDate__c;
                //oServiceNotesRequest.dEndDt = oAccount.Last_Trained__c;
                //oServiceNotesRequest.dBegDt = DateRange.Begin_Date__c;
                //oServiceNotesRequest.dEndDt = DateRange.End_Date__c;
                oServiceNotesRequest.dBegDt = date.parse(dFromDt);
                oServiceNotesRequest.dEndDt = date.parse(dToDt);
                listServiceNotesResult = ServiceNotesServices.getServiceNotesInfo(oServiceNotesRequest);  
                listServiceNotes = listServiceNotesResult; 
                // Initialize the result list & init paging
                ServiceNotesResults = new ServiceNoteItems();
                ServiceNotesResults.listServiceNotesItems =  listServiceNotesResult;
                /*System.Debug('ServiceNotesResults.listServiceNotesItems size()'+ServiceNotesResults.listServiceNotesItems.size());-- commented to reduce character for s2e optimization */
                this.ServiceNotesResults.initPaging();  
                ShoworHideFilter();
            }
        }
        catch(Exception oException){
            if(oException.getMessage().contains('timed out'))
                // ApexPages.addMessages(new AppUtil.AppException(System.Label.ServiceNotesEx)); //Replaced with custom Label as part of S2E Optimization
                ApexPages.addMessages(new AppUtil.AppException(Label.ServiceNotesEx));
            
            else    
                ApexPages.addMessages(oException);
        } 
        return null;
    }
    
    public PageReference changeServiceNoteDetail(){        
        ServiceNotesServices.ServiceNoteItemDetailRequest oServiceNoteItemDetailRequest = new ServiceNotesServices.ServiceNoteItemDetailRequest();
        oServiceNoteItemDetailRequest.sSystemId = 'SFDC CORE LEGAL';
        oServiceNoteItemDetailRequest.sServiceNoteId = ApexPages.currentPage().getParameters().get('snId');        
        /*system.debug('oServiceNoteItemDetailRequest'+oServiceNoteItemDetailRequest);-- commented to reduce character for s2e optimization */        
        ServiceNoteDetail = ServiceNotesServices.getServiceNoteItemDetail(oServiceNoteItemDetailRequest);
        listServiceNoteActivities = ServiceNoteDetail.ActivityCodeItemList;
        /*system.debug('ServiceNoteDetail'+ServiceNoteDetail);-- commented to reduce character for s2e optimization */
        RenderServiceNoteDetail = true;        
        return null;
    }
    
    public PageReference FilterByDepartment(){
        listServiceNotes = new List<ServiceNotesServices.ServiceNoteItem>();
        if(FilterByDepartmentValue!=''){
            listServiceNotes.clear();
            List<String> listDepartmentValues = FilterByDepartmentValue.split(',');
            for(ServiceNotesServices.ServiceNoteItem sni: listServiceNotesResult){
                for(string s : listDepartmentValues){
                    /*system.debug('sni.DepartmentDesc:'+sni.DepartmentDesc.toLowerCase()+'s:'+s.toLowerCase());-- commented to reduce character for s2e optimization */
                    if(sni.DepartmentDesc.toLowerCase().contains(s.trim().toLowerCase()))
                    {                        
                        listServiceNotes.add(sni);
                        break;
                    }
                }
            }
        }
        else{
            listServiceNotes.clear();
            listServiceNotes = listServiceNotesResult;
        }
        //ShoworHideFilter();
        //Reinitialize the result list & paging upon filtering
        ServiceNotesResults.listServiceNotesItems.clear();
        ServiceNotesResults.listServiceNotesItems =  listServiceNotes;
        this.ServiceNotesResults.initPaging();  
        return null;
    }
    
    public void ShoworHideFilter(){
        if(!listServiceNotes.isEmpty()){
            showFilter = true;
        }
        else{
            showFilter = false;
        }
    }
}