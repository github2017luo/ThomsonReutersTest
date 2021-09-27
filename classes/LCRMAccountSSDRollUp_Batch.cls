global class LCRMAccountSSDRollUp_Batch implements Database.Batchable<SObject>,Database.stateful{ 

     global Database.QueryLocator start(Database.BatchableContext BcthCon){
        
         Datetime maxstampDate ;
         string query;
         Set<Id> InformaticaUserSetId = new Set<Id>();
         String InformaticaGLIUser = Label.LCRM_Informatica_GLI_Integration;
         List<String> nameList = new List<String>();
         String profileName  = 'System Administrator';
         if(String.isnotempty(InformaticaGLIUser) && String.isnotblank(InformaticaGLIUser)){
            nameList = InformaticaGLIUser.split(',');
        }
        
        Map<Id, User> userMap = new Map<Id, User>([Select id FROM User Where Name in : nameList]);
        InformaticaUserSetId = userMap.keyset();
        /*
         Purpose: We have used max aggregate of 'LCRM_Total_Active_Subs_Timestamp__c' account field to fetch the account which are last updated or created in 
        24 hours. The fetched opportunities are furthers processed with the help of service class and Total active subscription is updated to the Account.

        */
        if(!InformaticaUserSetId.isEmpty()){
            List<aggregateResult> results = [select Max(Account_Name__r.LCRM_Total_Active_Subs_Timestamp__c) from Source_System_Detail__c WHERE lastmodifiedDate < LAST_N_DAYS:7 AND Account_Name__r.Is_GLI__c = true  AND Account_Name__r.LCRM_Total_Active_Subs_Timestamp__c!= null AND (lastmodifiedbyId IN : InformaticaUserSetId OR lastmodifiedby.profile.name = :profileName  )  ];
            
            if(!results.isEmpty()){
                for (aggregateResult ar : results){
                    
                    maxstampDate = Date.valueOf(ar.get('expr0'));
                }
                
            }
        }
        
             query = 'SELECT Account_Name__c,LCRM_Count_of_Subscriptions__c,lastmodifieddate,Account_Name__r.Is_GLI__c from Source_System_Detail__c WHERE (lastmodifiedbyId IN : InformaticaUserSetId OR lastmodifiedby.profile.name = :profileName) AND Account_Name__r.Is_GLI__c = true ';
             
             if(maxstampDate !=null){
                 query += ' AND lastmodifieddate >: maxstampDate  AND Account_Name__c!=null';
             }else{
                 query += ' AND Account_Name__c!=null';
             }
             
             system.debug('@@ InformaticaUserSetId' + InformaticaUserSetId);
             system.debug('@@ query  ' + query );
             return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext bcContext, List<Source_System_Detail__c > AccountSSD){
        
        List<Account> accountList = new List<Account>();
        Set<Id> AccountSet = new Set<Id>();
        
        for(Source_System_Detail__c ssdList: AccountSSD){
            AccountSet.add(ssdList.Account_Name__c);
        }
        
        system.debug('@@ Account Set' + AccountSet );
        accountList = [Select id,Total_Active_Subscriptions__c from Account where id in:AccountSet ];
        
        system.debug('@@ Account List' + accountList);
        LCRMAccountCustomRollupService.updatetotalActiveSubscription(accountList);
        
    }
    
     global void finish(Database.BatchableContext bcContext) {
    
     }
}