/*
======================================================================================================================
NAME: IntegrationController
======================================================================================================================
PURPOSE:  Functionality for displaying the failed orders and to retry them.
          From this page users can also search and retry for failed transaction.
          Methods:Search()
                  getIntegrationLoggerDetails()
                  UpdateIntegrationLogger(Boolean isApiStatus,String OrdNum,String selectedLogId)
                  retry()
                  retryAll()
                  SubmitORder(string OrdNum,string oldLogId)
======================================================================================================================
CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

 23-1-2018            Gowthami.R              created as per JIRA STORY: CRM-9456
======================================================================================================================
*/
public class IntegrationController {    
   
    public List<Integration_Logger__c> searchResults{get;set;}
    public List<Integration_Logger__c> retryResults{get;set;}
    public static Map<Id, Integration_Logger__c> mapRetryResults{get;set;}
    public String logObjectList{get;set;}
    public Integration_Logger__c iLogger{get;set;}
    public Boolean IsPrev{get;set;}
    public Boolean IsNext{get;set;}
    public Integer intOffSet =0;
    public final Integer PAGE_SIZE = 10;
    public Integer totalRecs=0;
    public List<wrapLogger> wrapLoggerList{get;set;}
    public static String selectedOrdNum {get;set;}
    public static String selectedOrdId{get;set;}
    public static String selectedLogId {get;set;}
    public string searchValue
    {
        get
        {
            if(searchValue == null)
                searchValue = '';
            return searchValue;
        }
        set;
    }
    public Integer size{get;set;}      
    public IntegrationController(ApexPages.StandardSetController controller){
        this.iLogger = (Integration_Logger__c)controller.getRecord();
        //getIntegrationLoggerDetails();
        mapRetryResults = new Map<Id, Integration_Logger__c>();
        IsPrev = false;
        IsNext = true;
        if(logObjectList == null) 
            logObjectList = 'Quote/Proposal';            
        Search();     
    }
       
    //search function holds the logic that works behind the search button and calls the Loggerdetails function that display the failed order details
    public Pagereference Search(){
      intOffSet = 0;
      getIntegrationLoggerDetails();       
      return null;
    }
    
    //holds the search functionality depending on the serachvalue both the interface name and record number
    @TestVisible private void getIntegrationLoggerDetails(){
        wrapLoggerList= new List<wrapLogger>();
        mapRetryResults = new Map<Id, Integration_Logger__c>(); 
        String query;
        try{
            //checks whether the user have entered some search value
            if(!String.isEmpty(searchValue)){ 
               query='Select id,Name,Exception_Message__c,Request_Message__c,Success__c,Order__r.Retry_Count__c,Object_Id__c,Object_Name__c,Request_Type__c,Order__r.Name from Integration_Logger__c Where Object_Name__c =:logObjectList AND Success__c != true AND Order__r.Name LIKE \'' + searchValue.trim()+ '%\' Order by CreatedDate Desc LIMIT '+PAGE_SIZE+' OFFSET '+(PAGE_SIZE*intOffSet);   
            }
            else{
                query='Select id,Name,Exception_Message__c,Request_Message__c,Success__c,Order__r.Retry_Count__c,Object_Id__c,Object_Name__c,Request_Type__c,Order__r.Name from Integration_Logger__c Where Object_Name__c =:logObjectList AND Success__c != true Order by CreatedDate Desc LIMIT '+PAGE_SIZE+' OFFSET '+(PAGE_SIZE*intOffSet);
            }
            system.debug('Query--'+query);
            //It will take the results of the query and adds the log results to the map
            for(Integration_Logger__c log: Database.Query(query)){   
                wrapLoggerList.add(new wrapLogger(log));           
                mapRetryResults.put(log.Id,log);            
            } 
        
            IsPrev= (intOffSet > 0); 
            IsNext= (wrapLoggerList.size()>=10);
            system.debug('Next disabled :'+IsNext);               
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
            }
      }
    /*//Updates the integration logger on retry with the new exception message if the retry is failed again
    public static void UpdateIntegrationLogger(Boolean isApiStatus,String OrdNum,String selectedLogId){
        //Checks for the isApiStatus from the retry function which holds the result whether ordernumber is successfully sent to Ordersubmission class or not
        try{
            if(!isApiStatus){
                Integration_Logger__c  newLogger = [SELECT Order__r.Retry_Count__c,Exception_Message__c,Id,Name,Request_Message__c,Request_Type__c,Service_Name__c,Success__c FROM Integration_Logger__c WHERE Order__r.Name =:OrdNum Order by CreatedDate Desc Limit 1];
                Integration_Logger__c  oldLogger = new Integration_Logger__c(Id=selectedLogId);
                if(mapRetryResults != null && mapRetryResults.containsKey(selectedLogId)){
                  oldLogger = mapRetryResults.get(selectedLogId);
                }
                oldLogger.Exception_Message__c = newLogger.Exception_Message__c ;
                delete newLogger;//It will delete the new loggerid
                update oldLogger;//It wil update the old logger id with new exception message
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully retried'));
                
            }
        }catch(exception e){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Order is not mapped for this log!!Please try to map order and retry again'));
        }
    }*/
    
    //performs the retry functionality by taking a particular order id and sends to the orderSubmissionToESI and calls UpdateIntegrationLogger
    /*public Pagereference retry(){
        boolean isApiStatus;
        boolean isSuccess;
        system.debug('wrapLoggerList'+wrapLoggerList);
        try{
            if(wrapLoggerList!=null && wrapLoggerList.size()>0){
                if(!String.isEmpty(selectedOrdNum)){
                isApiStatus = APTS_OrderQueuetoESI.orderSubmissionToESI(selectedOrdNum);
                }
                if(isApiStatus)
                UpdateIntegrationLogger(isApiStatus,selectedOrdNum,selectedLogId);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully retried'));
                //PageUtility.showConfirm('Successfully retried');
            }          
        }catch (Exception ex){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Order is not mapped for this log!!Please try to map order and retry again'));
            }
        return null; 
       }
       
    //performs the retry all functionality and calls submitorder 
    public Pagereference retryAll(){
        boolean isApiStatus;
        try{
            if(wrapLoggerList!=null && wrapLoggerList.size()>0){
                for(wrapLogger  wrp :wrapLoggerList){      
                //only for selected valid orders will be retried   
                   if(wrp.selected && wrp.logger.Order__r.Name!=null){
                       SubmitORder(wrp.logger.Order__r.Name,wrp.logger.Id);
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully retried'));
                   }               
                 }
               }
           }catch(exception e){
              ApexPages.addMessages(e);
           }    
        return null;
    }*/
    
    /*@future(callout=true)
    public static void SubmitORder(string OrdNum,string oldLogId)
    {   
        boolean isApiStatus;
        isApiStatus = APTS_OrderQueuetoESI.orderSubmissionToESI(OrdNum);
        if(isApiStatus){
            UpdateIntegrationLogger(isApiStatus,OrdNum,oldLogId);
        }         
    }*/
    
    //shows up the previous page of records
    public void Previous(){
        intOffSet= intOffSet-1;
        IsPrev= (intOffSet > 0);
        if(intOffSet >= 0)
            getIntegrationLoggerDetails();                     
    }
    
    //shows up the next set of records
    public void next(){
        intOffSet= intOffSet+1;
        getIntegrationLoggerDetails();
        IsNext= (wrapLoggerList.size()>=10);
        IsPrev= (intOffSet >= 1);        
    }   
    
    //wrapper class to work for checkboxes
    public class wrapLogger{
        public Integration_Logger__c logger{get; set;}
        public Boolean selected {get; set;}
 
        public wrapLogger(Integration_Logger__c logObj) {
            logger = logObj;
            selected = false;
        } 
    }     
}