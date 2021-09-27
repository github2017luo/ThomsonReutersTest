/*==========================================================================================================
    Purpose: Controller for ShowSDDRecords visualforce component.
    
    Change History: created
    
    Developer : Shailesh Patel 

    Modification History:Modified by Ameeta Antonio on 10/22/2018
                         DLT-12944 : Initiation of trial by SalesRep or Trial Manager from the opportunity page
    
===============================================================================================================*/
public with sharing class ShowSDDRecords{
    
    public String recordId;
    public String selectedRecordId{get; set;}
    public String pageNameVal;
    
    public List<Source_System_Detail__c> SDDList{get; set;}
    public string selectedSDDId{get; set;}
    public string selectedOpptyId{get; set;}
    
    public Boolean SSDrecPopupBool{get; set;}
    public Boolean displayOppSection{get; set;}
    public Source_System_Detail__c selectedSDDRecord{get; set;}
    Map<Id, Source_System_Detail__c> SDDMap;
    
    public Opportunity selectedOppRecord{get; set;}
    Map<Id, Opportunity> listOppMap;
    Map<String, String> mktSegmentMap;
    public boolean isLoading{get; set;}
    
    public Boolean checkVisibility {get; set;}
    
    public ShowSDDRecords(){
        
        User user = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        checkVisibility = ODT_TrialInitiationHelper.isValidUserRole(user);                
        
        SDDList = new List<Source_System_Detail__c>();
        SDDMap = new Map<Id, Source_System_Detail__c>();
        selectedSDDRecord = New Source_System_Detail__c();
        SSDrecPopupBool = TRUE;
        displayOppSection = TRUE;
        
        listOpp = New List<Opportunity>();
        listOppMap = new Map<Id, Opportunity>();
        mktSegmentMap = new Map<String, String>();
        selectedOppRecord = New Opportunity();
        ssdSelectedId = null;
        selectedOptionVal = null;
        selectedRecordId = recordId;
        isListOppNull = FALSE;    
        
        isLoading = false;
        
        //DLT-12944....Start:Added by Ameeta
        selectedOpptyId = ApexPages.currentPage().getParameters().get('oppid');
        if(selectedOpptyId != null)
            selectedOpptyId = string.escapeSingleQuotes(selectedOpptyId);
            
        System.debug('#####selectedOpptyId'+selectedOpptyId);
        if(selectedOpptyId != null){
            selectedOppRecord = [Select Id,Name,Type, StageName FROM Opportunity where id=:selectedOpptyId];
            selectedOptionVal = 'existing';
            //selectedOppRecord.id = selectedOpptyId;
            displayOppSection = false;
            selectedRecordId = selectedOpptyId;
            isListOppNull = TRUE;
        }
        //DLT-12944....End:Added by Ameeta
        
    }
    
    public String getPageNameVal(){
        return pageNameVal;
    }
    
    public void setpageNameVal(String s){     
        pageNameVal = s;
        queryData();
    }
    
    public String getrecordId(){
        return recordId;
    }
    
    public void setrecordId(String s){     
        recordId = s;
        //queryData();
    }
    
    public void queryData(){
        
        //Start : DLT-14600 : Dynamic Market Segment
        List<ODT_Market_Segments__mdt> marketSegmentList = new List<ODT_Market_Segments__mdt>([SELECT Business_Type__c,Market_Segment__c FROM ODT_Market_Segments__mdt]);
        if(marketSegmentList.size() > 0){
            for(ODT_Market_Segments__mdt mktSegment : marketSegmentList){
                mktSegmentMap.put(mktSegment.Market_Segment__c, mktSegment.Business_Type__c);
            } 
        }
        
        Set<String> mktSegmentSet=new Set<String>();
        mktSegmentSet.addAll(mktSegmentMap.keySet());
        //END : DLT-14600
        
        
        String fieldNamesStr = 'Name, Id, Account_Name__c, Account_Name__r.Name, Source_System_Account_Number__c,';
               fieldNamesStr += 'Trial_Status__c,Account_Name__r.SAPAccountNumber__c';
        
        String strQuery = 'SELECT ' + fieldNamesStr + ' FROM Source_System_Detail__c Where Account_Name__c=:recordId';
        
        //WHERE clause for contactsList Vfpage
        if( String.isNotblank(pageNameVal) && pageNameVal.equalsIgnoreCase('contactsList')){
            strQuery += ' AND LCRM_Sales_Org__c = \'' + 'WEST' + '\' ';
            strQuery += ' AND OLC_Account_Number__c = \'' + '' + '\' ';
            strQuery += ' AND Account_Inactive__c = FALSE '; 
            //Added Small Law products in the validation check
            /*strQuery += ' AND ( BU_Segment_Level_2__c = \'' + 'SLF 11-20' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'SLF 2-3' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'SLF 21-29' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'SLF 4-6' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'SLF 7-10' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'Solo Law Firm' + '\' ' +' OR';
            //Added corporate products in the validation check
            strQuery += ' BU_Segment_Level_2__c LIKE \'' + 'Corp%' + '\''  +')'; */                    
             
            strQuery += ' AND (BU_Segment_Level_2__c IN : mktSegmentSet )';
            /*strQuery += ' BU_Segment_Level_2__c = \'' + 'Corporation National Accounts' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'Corp National Investigative' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'Corp Counsel' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'Corp Investigative Financial' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'Corp Investigative' + '\' ' +' OR ';
            strQuery += ' BU_Segment_Level_2__c = \'' + 'Corp Counsel Existing' + '\' ' +')';*/
        }
        
        if(String.isNotblank(pageNameVal) && pageNameVal.equalsIgnoreCase('ODTTrialManage')){
            strQuery += ' AND Trial_Status__c != \'' + '' + '\' ';
        }
        
        System.debug('strQuery: '+strQuery);
        
        List<Source_System_Detail__c> results = Database.query(strQuery);
        SDDMap = new Map<Id,Source_System_Detail__c>(results);
        
        SDDList = SDDMap.Values();
    
    }
    
    public void getSelected()
    {
        selectedSDDId = ApexPages.currentPage().getParameters().get('accid');
        SSDrecPopupBool = FALSE;
        selectedSDDRecord = SDDMap.get(selectedSDDId);
        
        System.debug('selectedSDDId: '+selectedSDDId);
        System.debug('selectedOppId: '+selectedOppId);
        
       if(String.isNotBlank(selectedOppId)){
            selectedOppRecord = listOppMap.get(selectedOppId);
        }
        
        
    }
    
     public void changeToSDD(){
        SSDrecPopupBool = TRUE;
        listOpp = New List<Opportunity>();
        
        ssdSelectedId = null;
        selectedOppId = null;
        selectedOptionVal = null;
        selectedOppRecord = New Opportunity();
        
        System.debug('selectedSDDId In Changed SDD: '+selectedSDDId);
        System.debug('selectedOppId In Changed SDD: '+selectedOppId);
        
        isListOppNull = FALSE;
        
        isLoading = true;
    }
     
    
    public List<Opportunity> listOpp{get; set;}
    public string ssdSelectedId {get; set;} //Source system detail record Id
    public string selectedOptionVal{get; set;} // Store New or existing
    public boolean isListOppNull {get; set;}
    public string selectedOppId{get; set;} // Store Opportunity ID
    
    public void getOpportunities(){
        System.debug('selectedOptionVal: '+selectedOptionVal);
        listOpp = New List<Opportunity>();
        isListOppNull = FALSE;
        if(String.isNotBlank(selectedOptionVal) && selectedOptionVal.equalsIgnoreCase('existing')){
            listOppMap = new Map<Id,Opportunity>([Select Id, Name, StageName, Type, Probability, CloseDate from Opportunity  WHERE Source_System_Detail__c=:ssdSelectedId AND IsClosed = FALSE]);
            listOpp = listOppMap.values();
            
            if(!listOpp.isEmpty()){
                isListOppNull = TRUE;
            }
        }
        else{
            selectedOppId = null;
        }
    }
    
    
    public void blankOptionVal(){
        //DLT-12944....Start:Added by Ameeta
        if(selectedOpptyId != null){
            selectedOptionVal = 'existing';
            selectedOppRecord.id = selectedOpptyId;
            isListOppNull = TRUE;
            
        }
         //DLT-12944....End:Added by Ameeta
        else{
        selectedOptionVal = null;
        selectedOppRecord = New Opportunity();
        selectedOppId = null;
        isListOppNull = FALSE;
        }
    }
    
    public void isClosedPopup(){
        SSDrecPopupBool = FALSE;    
    }
    
     public PageReference newCustomerRedirect() {
        String pfParams = 'Id=' + selectedOpptyId;
        PageReference pf = new PageReference('/apex/ODTStartNCJ?' + pfParams);
        System.debug('PageRef: ' + pf);
        
        pf.setRedirect(true);
        return pf;
    } 
}