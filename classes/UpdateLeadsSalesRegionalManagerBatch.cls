/*
======================================================================================================================
CLASS NAME: UpdateLeadsSalesRegionalManagerBatch
======================================================================================================================
=
PURPOSE:    'LEGACY CODE' updating Regional Manager field on Lead object 

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2020-03-18        Yojit Handa      Added this code to optimize the UserTriggerHandler class (VAC-512)
======================================================================================================================
*/
global class UpdateLeadsSalesRegionalManagerBatch implements Database.Batchable<sObject> {
        Map<string,string> userManagerIdMap=new Map<string,string>();
        String query;
        global Integer recordsProcessed=0;
        
        public UpdateLeadsSalesRegionalManagerBatch(Map<string,string> userManagerIdMap){
            this.userManagerIdMap=userManagerIdMap;
            
        }
    global Database.QueryLocator start(Database.BatchableContext context) {
        SET<String> keys = userManagerIdMap.keySet();

        query= 'SELECT Id,OwnerId,Regional_Manager__c,LastModifiedDate FROM LEAD WHERE isConverted = false AND OwnerId IN :keys';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext context, List<sObject> scope){
        List<Lead> leadsToUpd= new List<Lead>();
        List<Lead> leadsToUpdate= (List<Lead>)scope;
        try{
            System.debug('...leadsToUpdate'+leadsToUpdate);
            if(leadsToUpdate!= null && leadsToUpdate.size() >0){
                for(Lead l: leadsToUpdate){        
                    if(userManagerIdMap.get(l.ownerId) != null){
                        l.Regional_Manager__c = userManagerIdMap.get(l.ownerId);
                        leadsToUpd.add(l);  
                        recordsProcessed+=1;  
                    }       
                }
            }
            if(leadsToUpd!= null && leadsToUpd.size() >0){
                    System.debug('***leadsToUpd' +leadsToUpd);
                    UPDATE leadsToUpd;
            }
        }
        catch(Exception e){
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c(LCRM_Exception_Message__c=e.getMessage(),LCRM_Exception_Trace__c =  e.getStackTraceString(),LCRM_User_ID__c = userinfo.getUserId());            
            insert excepObj;
        }
    }    
    global void finish(Database.BatchableContext context){
       System.debug(recordsProcessed);
    }    
}