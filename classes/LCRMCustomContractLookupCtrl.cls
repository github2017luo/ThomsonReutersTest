/*
===============================================================================
LCRMCustomContractLookupCtrl
===============================================================================

PURPOSE: Controller Class for LCRMCustomContractLookupPage Page

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-08-21      Rajesh                  Created 
===============================================================================
*/
public with sharing class LCRMCustomContractLookupCtrl{

    //properties
    List<Contract> records=new List<Contract>();
    public String searchvalue { get; set; }
    public String oppId {get; set;}
    public Boolean errorFlag{get;set;}
    public String parentId{get;set;}
    public String namefield{get;set;}
    public Id idfield{get;set;}
    public Integer totalRecords{get;set;}
    public Integer totalPages{get;set;}
    Integer pageSize = (KeyValueListStore__c.getValues('LCRMTrialNotifyOBA_LookupPageSize') == null || 
                       KeyValueListStore__c.getValues('LCRMTrialNotifyOBA_LookupPageSize').TextValue__c == null || 
                       KeyValueListStore__c.getValues('LCRMTrialNotifyOBA_LookupPageSize').TextValue__c == '')?
                       (20):Integer.valueOf(KeyValueListStore__c.getValues('LCRMTrialNotifyOBA_LookupPageSize').TextValue__c);
    
    //contructor 
    public LCRMCustomContractLookupCtrl(){
        try{
            oppId = ApexPages.currentPage().getParameters().get('oppid');
            searchvalue = ApexPages.currentPage().getParameters().get('parentname');
            parentId = ApexPages.currentPage().getParameters().get('parentid');
            namefield = ApexPages.currentPage().getParameters().get('namefield');
            idfield = ApexPages.currentPage().getParameters().get('idfield');
            System.debug('idfield : '+idfield);
            errorFlag = false;
            //if opp id not recieved in url them flag error on ui
            if(oppId == null || oppId == ''){
                errorFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LCRM_TrialCustomLkpError));
            }
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception trace : '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
    }
    
    //method binded with go button on ui
    public PageReference searchAction() {
        con=null;
        return new PageReference('/apex/LCRMCustomContractLookupPage?namefield=' + String.valueof(namefield) + '&idfield=' +
                                idfield + '&parentid=' + parentId + '&parentname=' + String.valueof(searchvalue) + '&oppid=' + oppid);
    }
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                //if search string is not equal to null then pull records filtered based on it else pull all records
                if(String.IsNotBlank(searchvalue)){
                    String tempsearchvalue = '%'+searchvalue+'%';
                    con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, ContractNumber, Status, 
                            LCRM_Transaction_Type__c, StartDate, TR_Retention__Contract_End_Date__c, LCRM_Total_Price__c, 
                            LCRM_Bill_To_Account__c from Contract where LCRM_Originating_Opportunity__c = :oppId 
                            And ContractNumber like :+tempsearchvalue+'%' order by ContractNumber asc limit 50000]));
                    //to get count of records        
                    totalRecords = [Select count() from Contract where LCRM_Originating_Opportunity__c = :oppId 
                            And ContractNumber like :+tempsearchvalue+'%' limit 50000];
                }else{
                    con = new ApexPages.StandardSetController(Database.getQueryLocator([Select id, ContractNumber, Status, 
                        LCRM_Transaction_Type__c, StartDate, TR_Retention__Contract_End_Date__c, LCRM_Total_Price__c, 
                        LCRM_Bill_To_Account__c from Contract where LCRM_Originating_Opportunity__c = :oppId 
                        order by ContractNumber asc limit 50000]));
                    //to get count of records   
                    totalRecords = [Select count() from Contract where LCRM_Originating_Opportunity__c = :oppId limit 50000];
                }
                con.setPageSize(pageSize);
                totalPages = (totalRecords/pageSize)+1;
            }
            return con;
        }
        set;
    }
 
    //method used to return record set according to current page
    public List<Contract> getRecords(){
        return con.getRecords();
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

     // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
    
    //returns if previous button should be enabled on ui
    public boolean AllowMovePrev {
        get{ 
            return (pageNumber > 1); 
        }
    } 
    
    
    //returns if next button should be enabled on ui
    public boolean AllowMoveNext {
        get{ 
            return (pageNumber < totalPages); 
        }
    }
}