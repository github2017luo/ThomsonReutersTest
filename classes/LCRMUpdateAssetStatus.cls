/**
* CRM-6138 Legal CRM November release
* Class for changing the status of Asset to 'Lapsed' when trial expires
*
* @author  Saloni Sukhija
* @version 2017-08-18
*/

global class LCRMUpdateAssetStatus implements Database.Batchable<sObject>{

    public String query;
    public Date d = System.today().addDays(-5);
   
    global LCRMUpdateAssetStatus(){
        query = 'SELECT Id FROM Asset WHERE LCRM_Is_GLI__c=TRUE AND TR_Retention__Contract_End_Date__c<TODAY AND TR_Retention__Contract_End_Date__c>:d AND Status!=\'Lapsed\'';
    }
    
    global Database.queryLocator Start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> assetList){
        
        //if there are trials that are expiring, then the status will be updated
        if(assetList!=null && assetList.size() > 0){
            List<Asset> assetsToUpdate = new List<Asset>();
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            
            for(sObject a:assetList){
                Asset assetToUpdate = (Asset)a;
                assetToUpdate.Status = 'Lapsed';
                assetsToUpdate.add(assetToUpdate);
            }
            
            //update assetsToUpdate;
            Database.SaveResult[] results = Database.update(assetsToUpdate, false);
            for(Integer i=0;i<results.size();i++){
            if(!results.get(i).isSuccess()){
                Database.Error error = results.get(i).getErrors().get(0);
                exceptionList.add(createExceptionLog(error.getMessage(), assetsToUpdate.get(i).Id));  
                
            }
        }
        
        if(exceptionList.size() > 0)
            insert exceptionList ;
        }
    }
    
    global void finish(Database.BatchableContext BC){
 
    }
    
    @TestVisible
    private LCRM_Exception_Log__c createExceptionLog(String errorMessage, String recordId){
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c= errorMessage;
        excepObj.LCRM_Record_Ids__c= recordId;
        excepObj.LCRM_Exception_Type__c = 'Asset status update job failure';
        return excepObj;
    }

}