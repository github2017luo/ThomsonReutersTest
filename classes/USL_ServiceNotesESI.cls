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
 * =============================================================================
 * Date         Name                    Description
 * 2012-10-20   Sripriya Kongot         Modified - QC 2159 Fixed the sorting issue - Results will be sorted DESC by CreatedDate
 * 2012-10-20   Sripriya Kongot         Modified - QC 2140 Added pagination to display the results
 * 2017-03-31   Karthi                  Optimized the code as per JIRA STORY: PS0-1
 * 2018-06-13   Matthew Main            Cloned from ServiceNotes Class. Implementation of ESI Integration ESD-381
 * =============================================================================
 */
public without sharing class USL_ServiceNotesESI {
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
    public User sCurrentUser{get;set;}
    public List<Source_System_Detail__c> listOfSSD;
    public String strSalesOrg;
    public List<String> accountSapIdList;


    public USL_ServiceNotesESI(ApexPages.StandardController controller) { 
        oAccount = new account();
        oAccount = (account) controller.getRecord();
        oAccount = [select Account_Indicator__c,ParentId,SAPAccountNumber__c, id from Account where id = :oAccount.Id];
        dFromDt = system.today().addMonths(-1).format();
        dToDt = system.today().format();
        ServiceNotesResults = new ServiceNoteItems();
        PageReference pg = getlistServiceNoteItems(); 
    }
   
        
    public PageReference getlistServiceNoteItems()
    {
        try{
        if(dFromDt == '' || dFromDt == null){
/*system.debug('dFromDt :'+dFromDt +'dToDt :'+dToDt);-- commented to reduce character for s2e optimization */
            ApexPages.Message mErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the Date Range.');
            ApexPages.addMessage(mErrorMsg);
        }
        else {
            RenderServiceNoteList = true;
            RenderServiceNoteDetail = false;
            ServiceNotesServices.ServiceNotesRequest oServiceNotesRequest = new ServiceNotesServices.ServiceNotesRequest();
            oServiceNotesRequest.sSystemId = 'SFDC CORE LEGAL';
 
            sCurrentUser = [select LanguageLocaleKey,Sales_Org__c,Sub_Bu__c from User where id = :UserInfo.getUserId()];
            Set<ID> accountIdSet = USLARHelper.getAccountSetList(oAccount);
            String strSubBu  = sCurrentUser.Sub_Bu__c;
            ListofSSD = new List<Source_System_Detail__c>();
            accountSapIdList = new List<String>();
            
            if(accountIdSet.size()>0 && String.isnotblank(strSubBu)){
                ListofSSD = USLARHelper.getSourceSystemDetails(accountIdSet,strSubBu);
                System.debug('ListofSSD:'+ListofSSD);
                if(ListofSSD.size()>0){
                    if(String.isnotblank(ListofSSD[0].LCRM_Sales_Org__c)){
                        strSalesOrg = ListofSSD[0].LCRM_Sales_Org__c;
                        for(Source_System_Detail__c SSD : ListofSSD){
                            if(String.IsNotBlank(SSD.Source_System_Account_Number__c)){
                                accountSapIdList.add(SSD.Source_System_Account_Number__c);
                            }
                        }//End For Loop
                    }
                }else if(ListofSSD == null || ListofSSD.isEmpty()){
                    System.debug('SSD List is blank');
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,(Label.LCRMNoSubBUError)));
                }
                //End SSD List Size Checking
            }else{
                //Need to add new lable for SUB BU blank
                System.debug('Not found SUB BU');
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMCurrentUsersSub_BU));
            }
            
            List<Decimal> accountSapList = new List<Decimal>();
            if(accountSapIdList != null){
                for(String s : accountSapIdList){
                   accountSapList.add(Decimal.valueOf(s));
                   
                }
                 oServiceNotesRequest.dcAcctSAPId = accountSapList;    
            }
            
            oServiceNotesRequest.dBegDt = date.parse(dFromDt);
            oServiceNotesRequest.dEndDt = date.parse(dToDt);


            listServiceNotesResult = ServiceNotesServices.getServiceNotesInfoESI(oServiceNotesRequest);


            listServiceNotes = listServiceNotesResult;
            //ServiceNotesResults = new ServiceNoteItems();
            ServiceNotesResults.listServiceNotesItems =  listServiceNotesResult;
            this.ServiceNotesResults.initPaging();  
            ShoworHideFilter();
          }
        }
        catch(Exception oException){
            if(oException.getMessage().contains('Unexpected character (\'U\' (code 85))')){
                ApexPages.addMessages(new AppUtil.AppException('401 Unauthorized response received from server. Please verify the username and password in the web service custom setting'));
            }
            else if(oException.getMessage().contains('timed out'))
              // ApexPages.addMessages(new AppUtil.AppException('A time-out error has occurred, please narrow your search criteria and try again.')); //Replaced with custom Label as part of S2E Optimization
              ApexPages.addMessages(new AppUtil.AppException(Label.ServiceNotesEx));
            
            else    
                ApexPages.addMessages(oException);
        }
        return null;
    }
    
    public boolean changeServiceNoteDetail(){
        ServiceNotesServices.ServiceNoteItemDetailRequest oServiceNoteItemDetailRequest = new ServiceNotesServices.ServiceNoteItemDetailRequest();
        oServiceNoteItemDetailRequest.sSystemId = 'SFDC CORE LEGAL';
        oServiceNoteItemDetailRequest.sServiceNoteId = ApexPages.currentPage().getParameters().get('snId');        
/*system.debug('oServiceNoteItemDetailRequest'+oServiceNoteItemDetailRequest);-- commented to reduce character for s2e optimization */




        try{
            ServiceNoteDetail = ServiceNotesServices.getServiceNoteItemDetailESI(oServiceNoteItemDetailRequest);
            if(ServiceNoteDetail != null) {
                listServiceNoteActivities = ServiceNoteDetail.ActivityCodeItemList;
                /*system.debug('ServiceNoteDetail'+ServiceNoteDetail);-- commented to reduce character for s2e optimization */
                RenderServiceNoteDetail = true;
                return null;
            }
        }
        catch(Exception e){
            ApexPages.addMessages(new AppUtil.AppException('Unable to retrieve the Service Note Detail.' + e));
            //throw e;
            RenderServiceNoteDetail =  false;
            return null;
        }


        //ApexPages.addMessages(new AppUtil.AppException('Unable to retrieve the Service Note Detail.'));
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