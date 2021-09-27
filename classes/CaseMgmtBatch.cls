/***********************************************************************************************
Purpose      : To find out the difference between Current date & Last modified date based on Case status. This is   required for sending out mails to customers per given conditions.
Developed By : Anshu Thakur
Date         : 12/14/2016
Changed Log  :
************************************************************************************************/
global class CaseMgmtBatch implements Database.Batchable<SObject>,Database.Stateful{

    private String query;
    Integer diffDates;
    date currentDate= date.today();
    Integer numberOfDaysBetween;
    List<Case> updCaseLst = new List<Case>();
    String excelHeader ='Case Id, CaseNumber, Status, Last Modified Date \n';
    String bodyStr = excelHeader;
    String recordString = null;
    String errorMessage = null;
    
    global Database.QueryLocator start(Database.BatchableContext BcthCon){ 
        query = 'SELECT CaseNumber,Priority,Status,CreatedDate,Last_Modified_Date__c,FiveDaysCheck__c,Five_Days_Pending_Case__c,Five_Days_Pending_Case_Escl__c,ThreeDaysCheck__c,Three_Days_Pending_Case__c from Case where Status<>\'Closed\' and RecordType.DeveloperName =\'Site_Originated\'';
        //query = 'SELECT CaseNumber,Priority,Status,CreatedDate,Last_Modified_Date__c,FiveDaysCheck__c,Five_Days_Pending_Case__c,Five_Days_Pending_Case_Escl__c,ThreeDaysCheck__c,Three_Days_Pending_Case__c from Case where CaseNumber=\'01270127\' and Status<>\'Closed\' and RecordType.DeveloperName =\'Site_Originated\'';
        System.debug('@@Start query '+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BtchCon, List<SObject> scope){
        System.debug('@@Scope data '+scope);
        try{
            List<Case> lstCase = (List<Case>)scope;
            if(lstCase.size()>0){
                for(Case oCase:lstCase){
                    if(oCase.Last_Modified_Date__c!=NULL){
                        numberOfDaysBetween = (Date.valueof(oCase.Last_Modified_Date__c)).daysBetween(currentDate);
                        System.debug('@@Current date '+currentDate);
                        System.debug('@@Last modified date '+oCase.Last_Modified_Date__c+' Case ID '+oCase.Id);
                        System.debug('@@days since case is pending '+numberOfDaysBetween);
                        System.debug('numberOfDaysBetween>0 && numberOfDaysBetween<25'+(numberOfDaysBetween>0 && numberOfDaysBetween<25));
                        if(numberOfDaysBetween>0 && numberOfDaysBetween<25){
                            System.debug('@@inside numberOfDaysBetween>0');
                            if(oCase.Status=='On Hold'){// && numberOfDaysBetween==3
                                oCase.Three_Days_Pending_Case__c = numberOfDaysBetween;
                                System.debug('@@oCase.Three_Days_Pending_Case__c '+oCase.Three_Days_Pending_Case__c);
                                //updCaseLst.add(oCase);
                            } else if(numberOfDaysBetween==5 || numberOfDaysBetween>5){
                                if(oCase.Status =='Escalated'){   
                                    oCase.Five_Days_Pending_Case_Escl__c = numberOfDaysBetween;
                                    System.Debug('@@oCase.Five_Days_Pending_Case_Escl__c '+oCase.Five_Days_Pending_Case_Escl__c);
                                    //updCaseLst.add(oCase);
                                }else if(oCase.Status!='On Hold' && oCase.Status!='Escalated' && oCase.Status!='Open' && oCase.Status!='New' && oCase.Status!='Closed' && numberOfDaysBetween>5){// && numberOfDaysBetween==5
                                    oCase.Five_Days_Pending_Case__c = numberOfDaysBetween;
                                    System.debug('@@oCase.Five_Days_Pending_Case__c '+oCase.Five_Days_Pending_Case__c);
                                    //updCaseLst.add(oCase);
                                }   
                            }
                            System.debug('numberOfDaysBetween---->'+numberOfDaysBetween);
                            if(numberOfDaysBetween>=20){
                                System.debug('oCase.Priority---->o'+oCase.Priority);
                                oCase.Priority='High';
                                System.debug('oCase.Priority---->n'+oCase.Priority);
                                //updCaseLst.add(oCase);
                                System.debug('updCaseLst---->n'+updCaseLst);
                            }
                            updCaseLst.add(oCase);
                        }else{
                            System.debug('@@No changes done as the last modified date is same as today');
                        }
                        System.debug('@@Updating fetched cases');
                        
                    }
                    else
                    System.debug('@@Last_Modified_Date__c is **NULL** '+oCase.Last_Modified_Date__c+' Case Id '+oCase.Id);
                    
                    //recordString = oCase.Id+', '+oCase.CaseNumber+', '+oCase.Status+', '+oCase.Last_Modified_Date__c+ '\n';
                    //bodyStr = bodyStr + recordString;
                }
                Database.SaveResult[] srList = Database.update(updCaseLst,false);
                System.debug('updCaseLst---->'+updCaseLst);
                System.debug('After Update srList'+srList);
                for(Database.SaveResult sr : srList){
                    if (!sr.isSuccess()){
                        System.debug('After Update Exception');
                        for(Database.Error err : sr.getErrors()){
                            excelHeader ='Error Details \n';
                            errorMessage =  errorMessage + 'Error has occurred' + err.getStatusCode() + ': ' + err.getMessage() + '. Account fields that affected this error: ' + err.getFields();  
                            recordString = recordString + ',' + errorMessage+'\n';                          
                            bodyStr = bodyStr + recordString;
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('@@Exception occured '+e);
            excelHeader ='Error Details \n'; 
            bodyStr = excelHeader ;
            recordString += e.getMessage()+ '\n';
            recordString += e.getStackTraceString()+ '\n\n';
            bodyStr = bodyStr + recordString; 
        }
    }

    global void finish(Database.BatchableContext BtchCon){
        //Send failure mail to SysAdmin with failed records in attachment.
        String toAddress = label.CM_BatchJob_Email; 
        Messaging.EmailFileAttachment excelAttc = new Messaging.EmailFileAttachment();
        System.debug('***Inside finish method of the case management batch class***'+bodyStr);
        blob excelBlob = Blob.valueOf(bodyStr);
        string excelFileName= 'CaseManagementUpdates.xls';
        excelAttc.setFileName(excelFileName);
        excelAttc.setBody(excelBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {toAddress};
        String subject ='Days since a Case is last modified, for sending mails to customers';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        if(bodyStr.containsAny('Error Details')){ 
            email.setPlainTextBody('This mail to inform you that the batch for calculating days since a case is last modified for sending out notification mails to customers, has failed for attached Cases. Please do the  needful analysis.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
    }
}