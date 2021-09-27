/*
===============================================================================
CLASS NAME: PPOAlerts
===============================================================================

PURPOSE: Send Email Alert to Sales Reps about the PPOs

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
17-06-2014        Srikanth          created
31-03-2017        Gunaseelan K      Optimized the code as per JIRA STORY: PS0-1
==============================================================================
*/

global class PPOAlerts implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    public Set<Id> OpportunityIds = new Set<Id>();
    public Set<string> setOpportunityOwnerEmails = new Set<string>();
    public Set<User> setOpportunityOwners = new Set<User>();
    public Map<String,Integer> mapOpportunityCount = new Map<String,Integer>();
    public Map<String,String> mapOppOwnerLanguageKey = new Map<String,String>();
    public Id PPORecordTypeId = RecordtypeIds__c.getInstance('Pre-Pipeline Opportunities').recTypeId__c;
    public KeyValueListStore__c oPPOAlerts_LastRun = KeyValueListStore__c.getInstance('PPOAlerts_LastRun');
    public DateTime JobLastRunDateTime;
    public DateTime CurrentDateTime;
    global database.querylocator start(Database.BatchableContext BC){
        //set up variables required to run the job
        CurrentDateTime = DateTime.Now();
        String sJobLastRunDateTime = oPPOAlerts_LastRun.TextValue__c;
        JobLastRunDateTime = DateTime.valueOfGmt(sJobLastRunDateTime);
        //1.) field history tracking should be enabled on Opportunity Owner.
        //for(OpportunityFieldHistory oOppFieldHistory : [SELECT Field,Id,IsDeleted,NewValue,OldValue,OpportunityId,createddate FROM OpportunityFieldHistory where Field = 'Owner' and Opportunity.RecordTypeId = :PPORecordTypeId and createddate >= :JobLastRunDateTime order by createddate desc]){
            //OpportunityIds.add(oOppFieldHistory.OpportunityId);
        //}
        //run the below query for the past one day. maintain the date time in a custom setting.
        //return Database.getQueryLocator([SELECT Id, Owner.Email FROM Opportunity where (Id in :OpportunityIds or CreatedDate >= :JobLastRunDateTime) and RecordTypeId = :PPORecordTypeId order by ownerId, createddate desc]);
        return Database.getQueryLocator([SELECT Id, Owner.Email, Owner.LanguageLocaleKey, CreatedDate FROM Opportunity where (LastModifiedDate > :JobLastRunDateTime and LastModifiedDate <= :CurrentDateTime) and RecordTypeId = :PPORecordTypeId order by ownerId, createddate desc]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Set<Id> setOpportunityIds = new Set<Id>();
        for(OpportunityFieldHistory oOppFieldHistory : [SELECT Field,Id,IsDeleted,NewValue,OldValue,OpportunityId FROM OpportunityFieldHistory where Field = 'Owner' and Opportunity.RecordTypeId = :PPORecordTypeId and OpportunityId in :scope and CreatedDate > :JobLastRunDateTime and CreatedDate <= :CurrentDateTime order by createddate desc]){
            setOpportunityIds.add(oOppFieldHistory.OpportunityId);
        }
        for(sObject s : scope){
            //collect the email ids and send mail or just collect the email id 
            Opportunity oOpp = (Opportunity)s;
            if((oOpp.CreatedDate > JobLastRunDateTime && oOpp.CreatedDate <= CurrentDateTime) || (setOpportunityIds.contains(oOpp.Id))) {
                if(mapOpportunityCount.containsKey(oOpp.Owner.Email)){
                    Integer iCount = mapOpportunityCount.get(oOpp.Owner.Email);
                    iCount ++;
                    mapOpportunityCount.put(oOpp.Owner.Email,iCount);
                }
                else{
                    mapOpportunityCount.put(oOpp.Owner.Email,1);
                }
                mapOppOwnerLanguageKey.put(oOpp.Owner.Email,oOpp.Owner.LanguageLocaleKey);
                /*setOpportunityOwnerEmails.add(oOpp.Owner.Email);
                User oUser = new User(Email = oOpp.Owner.Email, LanguageLocaleKey = oOpp.Owner.LanguageLocaleKey);
                setOpportunityOwners.add(oUser);*/
            }
        }
    }
    global void finish(Database.BatchableContext ctx){
        //see if the email can be sent from here
        List<Messaging.SingleEmailMessage> listEmailMessages = new List<Messaging.SingleEmailMessage>();
        for(String sEmail : mapOppOwnerLanguageKey.keySet()){
            Messaging.SingleEmailMessage oSingleEmailMessage = new Messaging.SingleEmailMessage();
            oSingleEmailMessage.setToAddresses(new string[]{sEmail});
            oSingleEmailMessage.setReplyTo('noreply@salesforce.com');
            oSingleEmailMessage.setSubject('New Opportunities');
            oSingleEmailMessage.setSenderDisplayName('DoNotReply');
          //  oSingleEmailMessage.setOrgWideEmailAddressId('0D2f000000000we');
            //oSingleEmailMessage.setPlainTextBody('There are new opportunities created for you.');
            if(mapOppOwnerLanguageKey.get(sEmail) == 'es'){
                oSingleEmailMessage.setSubject(system.Label.PPOAlertsSubject_es);
                oSingleEmailMessage.setHtmlBody(system.Label.PPOAlertsP1T1_es+' '+mapOpportunityCount.get(sEmail)+' '+system.Label.PPOAlertsP1T2_es);
            }
            else if(mapOppOwnerLanguageKey.get(sEmail) == 'pt_BR'){
                oSingleEmailMessage.setSubject(system.Label.PPOAlertsSubject_pt_BR);
                oSingleEmailMessage.setHtmlBody(system.Label.PPOAlertsP1T1_pt_BR+' '+mapOpportunityCount.get(sEmail)+' '+system.Label.PPOAlertsP1T2_pt_BR);
            }
            else{
                oSingleEmailMessage.setSubject(system.Label.PPOAlertsSubject);
                oSingleEmailMessage.setHtmlBody(system.Label.PPOAlertsP1T1+' '+mapOpportunityCount.get(sEmail)+' '+system.Label.PPOAlertsP1T2+system.Label.PPOAlertsP1T3);
            }
            listEmailMessages.add(oSingleEmailMessage);
        }
        if(!listEmailMessages.isEmpty()){
            Messaging.SendEmail(listEmailMessages);
        }
        //update the custom setting to the current date time so that the next day's batch job starts from here.
        oPPOAlerts_LastRun.TextValue__c = string.valueOf(CurrentDateTime);
        update oPPOAlerts_LastRun;
    }

    global void execute(SchedulableContext sc) {
        PPOAlerts oPPOAlerts  = new PPOAlerts();
        database.executeBatch(oPPOAlerts);
    }
}