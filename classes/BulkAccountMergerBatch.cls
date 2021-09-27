/***********************************************************************************************
Purpose      : Merger source accounts with master account in bulk 
Developed By : TCS Offshore
Date         : 11/18/2016
Changed Log  :
************************************************************************************************/
global class BulkAccountMergerBatch implements Database.Batchable<SObject>,Database.Stateful{
    private String query;
    Set<Id> setMasterAccId = new Set<Id>();
    Map<ID, Account> mapParentAcc = new Map<ID, Account>();
    String fieldName = null;
    BulkAccountMergeSettings__c accFields;
    List<Account> lstMasterAcc = new List<Account>();
    String excelHeader;
    String bodyStr;
    String errorMessage = null;
    String recordString = null;
    String[] acctSplitFields;
    String queryCommon;
    String queryExecute;
    
    global Database.QueryLocator start(Database.BatchableContext BcthCon){ 
        //Fetch Accounts for which Master_Account is not null    
        BulkAccountMergeSettings__c accFields = BulkAccountMergeSettings__c.getValues('Fields');
        fieldName = accFields.Value__c;
        if( fieldName != NULL)
        { 
            acctSplitFields = fieldName.split(',');  
            queryCommon = 'Select Id,MasterAccount__c,'+fieldName;
            System.debug('****Start queryCommon***'+queryCommon);        
            query = queryCommon +' from Account where MasterAccount__c != null';
            System.debug('****Start query***'+query);
            return Database.getQueryLocator(query);
        }
        else
        {
            return null;
        }
    }
    global void execute(Database.BatchableContext BtchCon, List<SObject> scope){
        System.debug('****accList in Scope****'+scope);
        try
        {   
            System.debug('****child acc field name****'+fieldName);
            List<Account> lstAccount = (List<Account>)scope;
            if(lstAccount.size()>0){
                for(Account mAcc : lstAccount){
                    setMasterAccId.add(mAcc.MasterAccount__c);
                }
            }
            if(setMasterAccId.size()>0){   
                queryExecute = queryCommon+' FROM Account WHERE Id IN : setMasterAccId';
                System.debug('****Execute queryExecute****'+queryExecute);
                List<Account> lstMasterAcc = Database.query(queryExecute);
                System.debug('****Execute before List ****'+lstMasterAcc);
                for(Account pAcc : lstMasterAcc)
                {
                    mapParentAcc.put(pAcc.Id,pAcc) ;   
                }
                System.debug('****Execute mapParentAcc****'+mapParentAcc);

                //mapParentAcc = new Map<ID, Account>([SELECT Id, Name,MasterAccount__c,SLASerialNumber__c FROM Account WHERE Id IN : setMasterAccId]);
            }
            if(lstAccount.size()>0){
                for(Account acc : lstAccount){
                    Account parAcc = mapParentAcc.get(acc.MasterAccount__c);
                    
                    //parAcc.put(fieldName, acc.get(fieldName));
                    for(String s : acctSplitFields)
                    {
                        parAcc.put(s, acc.get(s)); 
                        lstMasterAcc.add(parAcc);   
                    }
                    System.debug('###### After update lstMasterAcc'+ lstMasterAcc);
                    Database.MergeResult mergeResults = Database.merge(parAcc, acc);
                    if (!mergeResults.isSuccess()) {
                        excelHeader ='Source Account Id, Master Account Id,Comments \n';
                        bodyStr = excelHeader ;
                        //System.debug('****MASTER SUCCESS ID***'+mergeResults.getId());
                        //string recordString = acc.Id+','+acc.MasterAccount__c+'\n';
                        //recordString = acc.Id+','+acc.MasterAccount__c+','+'Account Merged Successfully'+'\n';
                        //bodyStr = bodyStr +recordString;
                        for(Database.Error err : mergeResults.getErrors()) {
                            errorMessage = errorMessage + 'The error has occurred.' + err.getStatusCode() + ': ' + err.getMessage() + '. Account fields that affected this error: ' + err.getFields();                            
                        }
                        recordString = acc.Id+','+acc.MasterAccount__c+','+errorMessage+'\n';
                        bodyStr = bodyStr +recordString;
                    }//Get the error message for failed accounts
                    /*else{
                        for(Database.Error err : mergeResults.getErrors()) {
                            errorMessage = errorMessage + 'The error has occurred.' + err.getStatusCode() + ': ' + err.getMessage() + '. Account fields that affected this error: ' + err.getFields();                            
                        }
                        recordString = acc.Id+','+acc.MasterAccount__c+','+errorMessage+'\n';
                        bodyStr = bodyStr +recordString;
                        //System.debug('NO Success' + bodyStr);
                    }*/
                } 
                //UPDATE lstMasterAcc;//Update legacyId in SAP account
            }
        
        }
        catch(Exception e)
        {
        
             System.debug('**** Exception ****'+e);
             excelHeader ='Error Details \n'; 
             bodyStr = excelHeader ;
             //recordString = e+'\n';
             recordString += e.getMessage()+ '\n';
             recordString += e.getStackTraceString()+ '\n\n';
             bodyStr = bodyStr +recordString;       
        }
                                             
    }
    
    global void finish(Database.BatchableContext BtchCon){
        if(recordString !=null && recordString!=''){
            //Send failure mail to sysadmin with attached failed records.
            BulkAccountMergeSettings__c toEmailAddr = BulkAccountMergeSettings__c.getValues('ToEmailAddress');
            String toAddress = toEmailAddr.Value__c;        
            Messaging.EmailFileAttachment excelAttc = new Messaging.EmailFileAttachment();
            System.debug('****bodyStr in finish ***'+bodyStr);
            blob excelBlob = Blob.valueOf(bodyStr);
            //String toAddress = System.Label.SendAccountMergeResultToAddress;
            string excelFileName= 'AccountMergeResult.xls';
            excelAttc.setFileName(excelFileName);
            excelAttc.setBody(excelBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {toAddress};
            String subject ='SourceTOMaster Account Merge Result';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('This mail to inform you that source to master account merger has been failed for attached accounts. Please do the analysis to fix the issue.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
    }
}