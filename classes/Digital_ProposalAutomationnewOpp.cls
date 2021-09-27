/* Created By - Divija S
   Purpose - Create Opportunities when automation does not find any opportunities associated with them.
   Jira Story - DLT-13499

   Modified by Divija S   6th Feb    DLT-14618 - Digital firm should be populated based Firm type in automation feed/file
   Modified by Navleen    25 April   DLT-16176 - [FindLaw] [TECH STORY] Opportunity Creation is failing for Findlaw and throwing 201 SOQL issue.
   Modified by Harika Sai 20 May     DLT-16594 - [ALL] Fix for duplicate opportunity is created for expired proposals
*/
public without sharing Class Digital_ProposalAutomationnewOpp implements Database.Batchable<Product_Account_Detail__c>,Database.Stateful{
    
    private static Final String GLIOPP='GLI Pipeline Opportunity';
    //public static  Final Set<String> STAGENAMES= new Set<String>{'Closed Lost','Order Complete','Contract Signed'}; 
    public Static Set<id> accIdSET =new Set<id>();
    
    private static Set<Id> recordIds = new Set<Id>{Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GLIOPP).getRecordTypeId()};
    private list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    public Static List<Product_Account_Detail__c > digitalSubscriptionsList = new List<Product_Account_Detail__c>();    
    public Static list<Source_System_Detail__c> ssdOpp= new list<Source_System_Detail__c>();  
    public  Map<id, list<Opportunity>> opids = new Map<id, list<Opportunity>>();
    public Map<String, Source_System_Detail__c> acclstMap = new Map<String, Source_System_Detail__c>();
    //prod Issue
    public Set<Date> renDatesSet = new Set<Date>(); 
    public Set<string> CampCodeSet = new Set<string>();   
                                                            
    //prod Issue ends
    //Batch Started to filter the Opportunities to execute upon
    public Iterable<Product_Account_Detail__c> start(database.batchablecontext bC){
        //Getting the subscriptions whose renewal date is greater than today and with non empty campaign codes.
        digitalSubscriptionsList = [SELECT AccountSSD__c,Renewal_Date__c,Campaign_Code__c                                    
                                    FROM Product_Account_Detail__c where Current_Subscription__c != Null AND Campaign_Code__c != Null AND Renewal_Date__c > Today 
                                    AND Digital_Firm__c !=Null Limit 50000]; 
        SET<string> accSSDSetWithNoOppties = new SET<string>();                         
        for(Product_Account_Detail__c  newprd: digitalSubscriptionsList){
            accIdSET.add(newprd.AccountSSD__c); 
            renDatesSet.add(newprd.Renewal_Date__c);//Harika
            CampCodeSet.add(newprd.Campaign_Code__c);//Harika
                                              
        }
        //DLT-16594 start
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible() && Schema.sObjectType.Opportunity.isAccessible()){
             //Getting ssds and their related opportunities matching Renewal date and campaign code with GLI Pipe line Record type.
             ssdOpp =[Select id,name,Account_Name__c,Digital_Firm__c,Source_System_Account_Number__c,
                         (Select id from Opportunities__r where (isDigitalSpearHead__c = TRUE OR Unmarked_Digital_Channel__c = TRUE) AND RecordTypeId IN : recordIds AND 
                          Renewal_Date__c IN:renDatesSet AND  Campaign_Code__c IN:CampCodeSet
                         )
                     FROM Source_System_Detail__c where id IN :accIdSET];
        }
        
        for(Source_System_Detail__c ssd: ssdOpp){ 
            System.debug('ssd:ssd.Opportunities__r:'+ ssd.id + ' ' +ssd.Opportunities__r);           
            opids.put(ssd.id, ssd.Opportunities__r);
            if((opids.get(ssd.id).isEmpty() || opids.get(ssd.id)== Null) && opids.get(ssd.id).size()== 0){
                
                if(ssd.Source_System_Account_Number__c!=null){
                    //acclstMap.put(ssd.Source_System_Account_Number__c, ssd);
                    accSSDSetWithNoOppties.add(ssd.id);
                }                
            }
        } 
       digitalSubscriptionsList = new List<Product_Account_Detail__c>(); 
       digitalSubscriptionsList = [SELECT AccountSSD__c,Renewal_Date__c,sub_Campaign_Code__c,Campaign_Code__c,Digital_Firm__c,Quantity__c,Actual_New_Service__c,
                                    Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c 
                                    FROM Product_Account_Detail__c where Current_Subscription__c != Null AND Campaign_Code__c != Null AND Renewal_Date__c > Today 
                                    AND Digital_Firm__c !=Null AND AccountSSD__c IN :accSSDSetWithNoOppties LIMIT 50000];   
        //Ends here                           
        return digitalSubscriptionsList;
    }

    // Passing Filtered Opportunities into batch Scope
    public void execute(Database.BatchableContext bC, List<Product_Account_Detail__c> scope){
      accIdSET =new Set<id>();  
      acclstMap = new Map<String, Source_System_Detail__c>();
      for(Product_Account_Detail__c  newprd: scope){
            accIdSET.add(newprd.AccountSSD__c); 
        }
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible() && Schema.sObjectType.Opportunity.isAccessible()){
             ssdOpp =[Select id,name,Account_Name__c,Digital_Firm__c,Source_System_Account_Number__c,
                         (Select id from Opportunities__r where (isDigitalSpearHead__c = TRUE OR Unmarked_Digital_Channel__c = TRUE) AND RecordTypeId IN : recordIds AND 
                          Renewal_Date__c IN:renDatesSet AND  Campaign_Code__c IN:CampCodeSet
                         )// updated the filter with matching Renwal date and campaign codes and digital checks
                     FROM Source_System_Detail__c where id IN :accIdSET];
        }
        Map<String, Set<Date>> dsRenewalDateMap = new Map<String, Set<Date>>();
        list<Opportunity> opfnllst = new list<Opportunity>();
        dsRenewalDateMap=getRenewalDateMapFromDS(scope);              
        for(Source_System_Detail__c ssd: ssdOpp){            
            System.debug('ssd:ssd.Opportunities__r:'+ ssd.id + ' ' +ssd.Opportunities__r); 
            opids.put(ssd.id, ssd.Opportunities__r);
            if((opids.get(ssd.id).isEmpty() || opids.get(ssd.id)== Null) && opids.get(ssd.id).size()== 0){                
                if(ssd.Source_System_Account_Number__c!=null){
                    acclstMap.put(ssd.Source_System_Account_Number__c, ssd);
                }                
            }
        } 
        system.debug('**acclstMap:' +acclstMap);      
        if(acclstMap.get(scope[0].ZP_Cust_Number__c)!=null){                
              opfnllst =  DigitalOpportunityCreationAutomation.getOpportunlist(scope, dsRenewalDateMap,acclstMap.get(scope[0].ZP_Cust_Number__c));  
        }               
               
    }
    //Get a Map of Account SSD ID with the Renewal Dates.
    private Map<String, Set<Date>>  getRenewalDateMapFromDS(list<Product_Account_Detail__c> digitalSubscriptionsList){
        Set<Date> renDates=new Set<Date>();   
        Map<String, Set<Date>>  dsRenewalDateMap=new Map<String, Set<Date>>();  
        for(Product_Account_Detail__c dsMach: digitalSubscriptionsList){
            //Creating a map of Account SSD with the related Renewal date.
            if(dsRenewalDateMap.containsKey(dsMach.AccountSSD__c)){
                renDates.add(dsMach.Renewal_Date__c);
                dsRenewalDateMap.put(dsMach.AccountSSD__c,renDates);
            }else{  
                renDates=new Set<Date>();
                renDates.add(dsMach.Renewal_Date__c);
                dsRenewalDateMap.put(dsMach.AccountSSD__c,renDates);
                
            }
        } 
        return dsRenewalDateMap;
    }
    
    

    
    // Initiates Best Proposal Automation
    public void finish(Database.BatchableContext info){ 
        
        if(!test.isrunningtest()){    
            Digital_ProposalAutomation dpb = new Digital_ProposalAutomation();        
            Database.executeBatch(dpb, 1);       
        } 
    }
}