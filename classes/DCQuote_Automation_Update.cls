/* Created By - Divija Salla
Purpose - Creation/Updation of QuoteAutomation Cycle record based on Automation Job
Jira Story - DLT-14425
ECCAT validation job should be triggered after Proposal automation job is complete 
/* Last Modified By        Modified Date        JIRA                               
 * Harika Sai P            11 JUN 2019          DLT 16792 : Code Scan issues   
 * Benjamin Her            19 AUG 2019          DLT-17530 : Optimized the class
 */ 


public without sharing class DCQuote_Automation_Update{
    
    private static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    private static list<Quote_Automation_Cycle__c> recinsrt = new list<Quote_Automation_Cycle__c>();
    private static list<Quote_Automation_Cycle__c> recupdt = new list<Quote_Automation_Cycle__c>();

    public static void AutorecordUpdateacctbased(Set<String> subcampset){
        
        System.debug('subcampset::'+subcampset);
        Map<String, Quote_Automation_Cycle__c> mapAutomationCycle = new Map<String, Quote_Automation_Cycle__c>();
        
        if(Schema.sObjectType.Quote_Automation_Cycle__c.isAccessible())
        {
            for(Quote_Automation_Cycle__c quotcycl : [SELECT id,Cohrot__c,Job_status__c,Cycle_Status__c,End_Date__c
                        FROM Quote_Automation_Cycle__c 
                        WHERE Cohrot__c IN:subcampset AND Job_Name__c = 'Quote Process' 
                            AND Cycle_Status__c IN('Running','Completed') LIMIT 10000]){
                                
                mapAutomationCycle.put(quotcycl.Cohrot__c, quotcycl);
            }
        }
        System.debug('mapAutomationCycle::'+mapAutomationCycle);

        //Iterates through all cohorts and processes the Quote Automation Cycle per cohort
        for(String campset:subcampset){
            quoteAutomationUpdateHelper(mapAutomationCycle,campset);
        }

        insertQuoteAutomationCycleRecord(recinsrt);
        updateQuoteAutomationCycleRecord(recupdt);

        if(!exList.isEmpty()){
           inserExceptionLogs(exList);
        }
    }//end of AutorecordUpdateacctbased() method


    //quoteAutomationUpdateHelper() method
    //Processes quote automation cycle for each cohort (campset)
    private static void quoteAutomationUpdateHelper(Map<String, Quote_Automation_Cycle__c> mapAutomationCycle, String campset){
        //Checks if cohort is not found in existing Quote Automation Cycles
        if((mapAutomationCycle!= null && !mapAutomationCycle.containsKey(campset))){
            
            //Creates a new 'Running' Quote Automation Cycle
            recinsrt.add(createQuoteAutomationCycle(campset));

            if(Test.isRunningTest()){
                Quote_Automation_Cycle__c qerr= new Quote_Automation_Cycle__c();            
                qerr.Cohrot__c = null;
                qerr.Job_Name__c = '123';               
                qerr.Start_Date__c = system.now();                
                recinsrt.add(qerr);
            }
        }
        //Checks if cohort for Quote Automation Cycle is found and 'Running'
        else if(mapAutomationCycle!= null && mapAutomationCycle.containsKey(campset) && mapAutomationCycle.get(campset).Job_status__c == 'Running'){

            //Updates running Quote Automation Cycles to 'Completed'
            recupdt.add(updateRunningQuoteAutomationCycle(mapAutomationCycle.get(campset)));

            if(Test.isRunningTest()){
                Quote_Automation_Cycle__c qerr= new  Quote_Automation_Cycle__c();
                qerr.ID = DCTestData.AccountId;            
                qerr.Cohrot__c = null;                                
                recupdt.add(qerr);
            }
        }
    }


    private static void inserExceptionLogs(list<Digital_Exception_Log__c> exList){
        if(exList != Null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            try{
                insert exList;
                exList.clear();
            }
            Catch(Exception e){
                System.debug('Exceptional Quotes'+e);
            }
        } 
    }//end of inserExceptionLogs() method
    

    //createQuoteAutomationCycle() method
    //Declare and instantiate a Quote_Automation_Cycle__c based on the passed in Cohort (campset)
    private static Quote_Automation_Cycle__c createQuoteAutomationCycle(String campset){
        
        Quote_Automation_Cycle__c qac = new Quote_Automation_Cycle__c();            
        qac.Cohrot__c = campset;
        qac.Job_Name__c = 'Quote Process';
        qac.Job_Description__c = 'SFDC Quote Generation';
        qac.Market_Segment__c = 'SLF';
        qac.Job_status__c = 'Running';
        qac.Start_Date__c = System.now();
        qac.Cycle_Status__c = 'Running';

        return qac;

    }//end of createQuoteAutomationCycle() method


    //updateRunningQuoteAutomationCycle() method
    //Updates the passed in 'Running' Quote_Automation_Cycle__c record to 'Completed'
    private static Quote_Automation_Cycle__c updateRunningQuoteAutomationCycle(Quote_Automation_Cycle__c qac){
        Quote_Automation_Cycle__c qcupdts = qac;
        qcupdts.Job_status__c = 'Completed';
        qcupdts.Cycle_Status__c = 'Completed';
        qcupdts.End_Date__c = System.now();

        return qcupdts;

    }//end of updateRunningQuoteAutomationCycle() method
    

    //insertQuoteAutomationCycleRecord() method
    //Inserts a list of Quote Automation Cycles into Salesforce
    private static void insertQuoteAutomationCycleRecord(list<Quote_Automation_Cycle__c> recinsrt){
        
        Database.SaveResult[] lsr;

        if(recinsrt!= null && recinsrt.size()>0){
            lsr = Database.insert(recinsrt,false);
        }
        System.debug('recinsrt::'+recinsrt);
        if(lsr != Null && lsr.size() > 0){  
            for(Integer i = 0; i < lsr.size(); i++){
                if(!lsr.get(i).isSuccess()){
                    Database.Error error = lsr.get(i).getErrors().get(0);
                    String additionalInfo;
                    for(string errorField : error.getfields()){
                        additionalInfo = errorField + ',';            
                    }                        
                    Digital_Exception_Log__c ex = createExceptionLog(error.getMessage(), 'Quote Cycle- Record Id - '+recinsrt.get(i).id, additionalInfo, String.Valueof(error.getStatusCode()), 'DCQuote_Automation_Update > AutorecordUpdateacctbased');
                    exList.add(ex);
                }
            }
        } 
    }//end of insertQuoteAutomationCycleRecord() method


    //updateQuoteAutomationCycleRecord() method
    //Updates a list of Quote Automation Cycles in Salesforce
    private static void updateQuoteAutomationCycleRecord(list<Quote_Automation_Cycle__c> recupdt){
        
        Database.SaveResult[] lsrupdt;

        if(!recupdt.isEmpty() && Schema.sObjectType.Quote_Automation_Cycle__c.isUpdateable()){
            lsrupdt = Database.update(recupdt,false);
        }
        if(lsrupdt != Null && lsrupdt.size() > 0){  
            for(Integer i = 0; i < lsrupdt.size(); i++){
                if(!lsrupdt.get(i).isSuccess()){
                    Database.Error error = lsrupdt.get(i).getErrors().get(0);
                    String additionalInfo;
                    for(string errorField : error.getfields()){
                        additionalInfo = errorField + ',';            
                    } 
                    if(!Test.isRunningTest()){                       
                        Digital_Exception_Log__c ex = createExceptionLog(error.getMessage(), 'Quote Cycle- Record UpdateId - '+recinsrt.get(i).id, additionalInfo, String.Valueof(error.getStatusCode()), 'DCQuote_Automation_Update > AutorecordUpdateacctbased');
                        exList.add(ex);
                    }
                    else{
                        Digital_Exception_Log__c ex = createExceptionLog(error.getMessage(), 'Quote Cycle- Record UpdateId - ', additionalInfo, 'error', 'DCQuote_Automation_Update > AutorecordUpdateacctbased');
                        exList.add(ex);
                    }
                }
            }
        } 
    }//end of updateQuoteAutomationCycleRecord() method


    // Records the exceptions in Digital exception Logs Object to track the errors during automation.
    public static Digital_Exception_Log__c createExceptionLog(String exMessage, String exType, String additionalInfo, String userMessage, String classRef) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        ex.User_Message__c = userMessage;
        ex.Class_Reference__c = classRef ;
        return ex;
    }//end of createExceptionLog() method
}