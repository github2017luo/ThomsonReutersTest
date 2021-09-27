/***********************************************************************************************
Purpose      : Custom Case Escaletion Management
Date         : 04-Jan-2017
Changed Log  :
************************************************************************************************/
global class BatchForCaseEscaletion implements Database.Batchable<SObject>,Database.Stateful{

    private String query;
    Integer diffDates;
    date currentDate= date.today();
    Integer numberOfDaysBetween;
    List<Case> updCaseLst = new List<Case>();
    String excelHeader ='Case Id, CaseNumber, Status, Last Modified Date \n';
    String bodyStr = excelHeader;
    String recordString = null;
    String issueType=System.Label.CM_EscaletionBatchWhereClause; // 'CAC -'
    
    global Database.QueryLocator start(Database.BatchableContext BcthCon) { 
        //query = 'SELECT CaseNumber,Status,CreatedDate,Last_Modified_Date__c, OwnerId, Owner.Name,Owner.Type,Escalation_Level_Number__c from Case where Id=\'500S0000008AZrw\' and Owner.Type<>\'Queue\'';
        // and CreatedDate<LAST_N_DAYS:7
        query = 'SELECT CaseNumber,Status,CreatedDate,Last_Modified_Date__c, OwnerId, Owner.Name,Owner.Type,Escalation_Level_Number__c from Case where ANZ_Issue__c Like \'' + issueType + '%\' and (RecordType.DeveloperName = \'ANZ\' or RecordType.DeveloperName = \'Site_Originated\') and Owner.Type<>\'Queue\' and Status<>\'Closed\'';
        System.debug('@@Start query ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BtchCon, List<SObject> scope){
        System.debug('@@Scope data '+scope);
        try{
            List<Id> lstUserIds1=new List<Id>();
            List<Case> lstCase = (List<Case>)scope;
            if(lstCase.size()>0){
                for(Case oCase:lstCase){
                    lstUserIds1.add(oCase.OwnerId);
                }
                Map<Id,User> mapUsers1=new Map<Id,User>([SELECT Id,TimeZoneSidKey,ManagerId FROM User WHERE Id in :lstUserIds1]);
                //Map<Id,BusinessHours> mapBusinessHours1=new Map<Id,BusinessHours>([select Id, TimeZoneSidKey from BusinessHours]);
                //1/26/2017 Indu Kanjingat; Exclude the (LM SLA) Business Hours. This is used for lead assignment. Fix for jira bug [CMI-46]
                //added by AG to exclude the default one 27-Jan-2017
                string bHourLab = Label.BusinessHoursLeadSLA;
                string strDefaultBH = Label.BusinessHoursDefault;
                List<BusinessHours> lstBusinesshours = [select Id, TimeZoneSidKey from BusinessHours where name !=: bHourLab and name !=: strDefaultBH];
                //System.debug('lst of Businesshours ---->'+lstBusinesshours);
                Map<String,Id> mapBusinesshours = new Map<String,Id>();
                for(BusinessHours oBusinesshours:lstBusinesshours){
                    if(mapBusinesshours.containsKey(oBusinesshours.TimeZoneSidKey) == false){
                        mapBusinesshours.put(oBusinesshours.TimeZoneSidKey,oBusinesshours.Id);
                    }
                }
                Map<string, Case_Escalation_Settings__c> allCESRecords = Case_Escalation_Settings__c.getAll();
                System.debug('@@Before logic starts');
                for(Case oCase:lstCase){
                    
                    String strBusinesshoursId='';
                    Long longIntInactiveHours=0;
                    Long longIntHoursCheck=0;
                    System.debug('Check Business Hours');
                    if(mapUsers1.containsKey(oCase.OwnerId)==true && (mapUsers1.get(oCase.OwnerId)).TimeZoneSidKey != null 
                    && mapBusinesshours.containsKey((mapUsers1.get(oCase.OwnerId)).TimeZoneSidKey) == true){
                        
                        strBusinesshoursId = mapBusinesshours.get((mapUsers1.get(oCase.OwnerId)).TimeZoneSidKey);
                    }
                    System.debug('Going for Escalation');
                    
                    if(strBusinesshoursId!='' && strBusinesshoursId!=null && oCase.Last_Modified_Date__c!=null){
                        longIntHoursCheck=BusinessHours.diff(strBusinesshoursId, System.now(), oCase.Last_Modified_Date__c);
                    }
                    longIntInactiveHours=((longIntHoursCheck/1000)/60/60)*-1;
                    System.debug('longIntInactiveHours---->'+longIntInactiveHours);
                    System.debug('longIntHoursCheck---->'+longIntHoursCheck);
                    if(oCase.Escalation_Level_Number__c!=null 
                    && allCESRecords.get('LATAM Escalation- Level 0').Escalation_SLA_Min__c!=null
                    && allCESRecords.get('LATAM Escalation- Level 0').Escalation_SLA_Max__c!=null
                    && oCase.Escalation_Level_Number__c==allCESRecords.get('LATAM Escalation- Level 0').Escalation_Level__c 
                    && longIntInactiveHours>=allCESRecords.get('LATAM Escalation- Level 0').Escalation_SLA_Min__c 
                    && longIntInactiveHours<=allCESRecords.get('LATAM Escalation- Level 0').Escalation_SLA_Max__c){
                        
                        if(oCase.Owner.Type<>'Queue'){
                            oCase.IsEscalated=true;                        
                            oCase.Old_Owner__c=oCase.OwnerId;
                            oCase.Escalation_Level_Number__c=1;
                            oCase.Status='Escalated';
                            oCase.OwnerId=(mapUsers1.get(oCase.OwnerId)).ManagerId;                        
                            updCaseLst.add(oCase);
                        }
                        
                    }
                    else if(oCase.Escalation_Level_Number__c!=null 
                    && allCESRecords.get('LATAM Escalation- Level 1').Escalation_SLA_Min__c!=null
                    && allCESRecords.get('LATAM Escalation- Level 1').Escalation_SLA_Max__c!=null
                    && oCase.Escalation_Level_Number__c==allCESRecords.get('LATAM Escalation- Level 1').Escalation_Level__c 
                    && longIntInactiveHours>=allCESRecords.get('LATAM Escalation- Level 1').Escalation_SLA_Min__c 
                    && longIntInactiveHours<=allCESRecords.get('LATAM Escalation- Level 1').Escalation_SLA_Max__c){
                        
                        
                        if(oCase.Owner.Type<>'Queue'){
                            oCase.IsEscalated=true;
                            oCase.Old_Owner__c=oCase.OwnerId;
                            oCase.Escalation_Level_Number__c=2;
                            oCase.Status='Escalated';
                            oCase.OwnerId=(mapUsers1.get(oCase.OwnerId)).ManagerId;
                            updCaseLst.add(oCase);
                        }
                        
                    }
                    else if(oCase.Escalation_Level_Number__c!=null 
                    && allCESRecords.get('LATAM Escalation- Level 2').Escalation_SLA_Min__c!=null
                    && allCESRecords.get('LATAM Escalation- Level 2').Escalation_SLA_Max__c!=null
                    && oCase.Escalation_Level_Number__c==allCESRecords.get('LATAM Escalation- Level 2').Escalation_Level__c 
                    && longIntInactiveHours>=allCESRecords.get('LATAM Escalation- Level 2').Escalation_SLA_Min__c 
                    && longIntInactiveHours<=allCESRecords.get('LATAM Escalation- Level 2').Escalation_SLA_Max__c){
                    
                        
                        if(oCase.Owner.Type<>'Queue'){
                            oCase.IsEscalated=true;
                            oCase.Old_Owner__c=oCase.OwnerId;
                            oCase.Escalation_Level_Number__c=3;
                            oCase.Status='Escalated';
                            oCase.OwnerId=(mapUsers1.get(oCase.OwnerId)).ManagerId;
                            updCaseLst.add(oCase);
                        }
                        
                    }
                    
                }
                System.debug('updCaseLst---->'+updCaseLst);
                if(updCaseLst.size()>0){
                    Database.SaveResult[] results = Database.Update(updCaseLst, false);
                }
            }    
        }catch(Exception e){
            System.debug('@@Exception occured '+e);
            excelHeader ='Error Details \n'; 
            bodyStr = excelHeader ;
            recordString = e + '\n';
            bodyStr = bodyStr + recordString; 
        }
    }

    global void finish(Database.BatchableContext BtchCon){
        //Send failure mail to SysAdmin with failed records in attachment.
        String toAddress = label.CM_BatchJob_Email;        
        //Messaging.EmailFileAttachment excelAttc = new Messaging.EmailFileAttachment();
        System.debug('***Inside finish method of the case management vatch class***'+bodyStr);
        /*blob excelBlob = Blob.valueOf(bodyStr);
        string excelFileName= 'CaseManagementUpdates.xls';
        excelAttc.setFileName(excelFileName);
        excelAttc.setBody(excelBlob);*/
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {toAddress};
        String subject ='Escalation batch execution notification';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        if(bodyStr.containsAny('Error Details')){
            email.setPlainTextBody('This mail is to inform you that the batch for Case Escalation, has failed for attached Cases. Please do the  needful analysis.');
        }
        /*else {
            email.setPlainTextBody('This mail is to inform you that the batch execution for Case Escalation, has completed successfully.');
        }*/
        //email.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttc});
        try{
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
        catch(Exception e){
            System.debug('@@Exception occured '+e);
        }
    }
}