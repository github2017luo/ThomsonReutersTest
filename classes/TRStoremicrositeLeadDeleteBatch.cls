public without sharing class TRStoremicrositeLeadDeleteBatch implements Database.Batchable<sObject>,  Database.Stateful  {
    
    public LIST<id> leadIds = new LIST<ID>();
    public integer noOfrecords =0;
    public string errorMessages = '';
    
    public Iterable<sObject>  start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        LIST<string>  micrositesList = new LIST<String>();
        
        Integer noOfDays = 30;
        if(Static_Values__c.getAll().get('micrositesToDelete') != null){
            if(Static_Values__c.getAll().get('micrositesToDelete').Value__c != null){
                micrositesList = Static_Values__c.getAll().get('micrositesToDelete').Value__c.split(',');
            }
            
        }
        
        //Fetch No.of days to get delete from custom settings 
        if(Static_Values__c.getAll().get('MicrositeLeaddeletedays') != null){
            if(Static_Values__c.getAll().get('MicrositeLeaddeletedays').Value__c != null){
                noOfDays = integer.valueOf(Static_Values__c.getAll().get('MicrositeLeaddeletedays').Value__c);
            }
            
        }
        
        system.debug(Logginglevel.INFO+'Hello noOfDays '+ noOfDays +'   micrositesList   '+micrositesList);
        //Query and send the results to execute method 
         return [Select id, name from Lead WHERE Lead_Microsite__c != null AND Lead_Microsite__c =:micrositesList AND isconverted = false AND LastModifiedDate <=: (system.now()- noOfDays) ];
       
        
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> records){
      
      //Delete the records from DB 
       LIST<database.deleteresult> delRes =  Database.delete(records, false);
       
       // Gather any failure records are there.  
       for(Database.deleteResult d: delRes){
           if(!d.isSuccess()){
               leadIds.add(d.getId());
               errorMessages += ' '+string.valueof(d.getErrors());
           }else
               noOfrecords += 1;    
       }
       
    }    
    
    public void finish(Database.BatchableContext bc){
       
       // If any failure records are there, create a record on integration logger 
       if(!leadIds.isEmpty() || Test.isRunningTest()){ 
            string messagetoStore = 'We have completed the microsite leads deletion, Please find the results ';
            
            
            if(Static_Values__c.getAll().get('micrositedeleteleadsemailTemplate') != null){
                if(Static_Values__c.getAll().get('micrositedeleteleadsemailTemplate').Value__c != null){
                    messagetoStore = Static_Values__c.getAll().get('micrositedeleteleadsemailTemplate').Value__c;
                
                }
            }    
            
            messagetoStore += ' Records Successfully processed: '+noOfrecords;
            messagetoStore += ' Records Failed to delete: '+leadIds.size();
            
            if(!leadIds.isEmpty())
                messagetoStore += ' Failed records are : '+leadIds;
            
            if(messagetoStore.length() > 32767)
                messagetoStore = messagetoStore.substring(0, 32766);
            
            if(errorMessages.length() > 32767)
                errorMessages = errorMessages.substring(0, 32766);
            
            
            TRStoreLeadprocess.logTRStoreException(messagetoStore ,errorMessages ,' Delete Microsite leads afer 30 days ',null);
        }    
        
         
    }    
    
    
    
}