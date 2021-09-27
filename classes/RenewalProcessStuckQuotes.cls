/**
 * @description RenewalProcessStuckQuotes
 */
@SuppressWarnings('PMD')
global class RenewalProcessStuckQuotes implements Database.Batchable<sObject>{
/**
 * @description start
 * @param bc
 * @return start
 */ 
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        String soqlQuery = 'SELECT ID,Status__c FROM Renewal_Quote__c WHERE Status__c =\'In Progress\' OR Status__c=\'Failed\'' ;
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<Renewal_Quote__c> scope){
        list<Renewal_Quote__c> listOfRQuotes =  new list<Renewal_Quote__c>();
        
        for(Renewal_Quote__c tempQuote : scope){
            if(tempQuote.Status__c != 'In Progress'){
                tempQuote.Status__c = 'In Progress';
                listOfRQuotes.add(tempQuote);
            }
            
        }
        
        
        
        if(!listOfRQuotes.isEmpty()){
            update listOfRQuotes;
        }
        
        if(!Test.isRunningTest()){GLI_Load_Tracker__c testBulkLoadGLI = [SELECT ID,Name,JobCompletedDate__c FROM GLI_Load_Tracker__c WHERE Name = 'Informatica Renewal Notifications Load'];
        testBulkLoadGLI.JobCompletedDate__c = Datetime.now();update testBulkLoadGLI;}
    }
    
    global void finish(Database.BatchableContext bc){}
         
    }