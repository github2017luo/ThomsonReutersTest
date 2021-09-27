/**
 *  trac_OST.cls
 *
 *  @description
 *      Class to run most of the OST Logic.  Working here to try to generalize the work of Merisha in trac_OST_Case.cls
 *
 *  @date - 01/30/2015
 *  @author - Dan Reich: Traction on Demand
 */
public without sharing class Trac_OST {
    public enum LogType { STATUS, OWNER, TIMER }
    public static final String WAITING = 'Assigned';
    public static final String CLOSED = 'Closed';

    private static final Integer MILLISECONDS_IN_SECOND = 1000;
    private static final Integer SECONDS_IN_MINUTE = 60;


    public static void handleNewCases( List<Case> newCases ) {
        List<Case> insertedCases = [SELECT Id, Owner.Id, Owner.Type, Owner.Name, Status, RecordTypeId FROM Case WHERE Id in: newCases];

        List<Time_Log__c> newTimeLogs = new List<Time_Log__c>();
        //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
        Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId(); 
        //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
        Id caseRecordTypeEliteClosedCPQ =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId(); 
        for( Case c : insertedCases ) {
            if(String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteClosedCPQ){
                newTimeLogs.add( startTimeLog( c, LogType.STATUS, WAITING ) );
                newTimeLogs.add( startTimeLog( c, LogType.OWNER, WAITING ) );
            }
        }
        if( !newTimeLogs.isEmpty() ) {
            System.debug('Ziwei new: ' + newTimeLogs);
            insert newTimeLogs;
        }
    }

    public static void handleUpdatedCases( List<Case> newCases, Map<Id, Case> oldCaseMap ) {
        Set<Id> ownerChanges = new Set<Id>();
        Set<Id> statusChanges = new Set<Id>();
        Set<Id> reopenedCases = new Set<Id>();
        Set<Id> closedCases = new Set<Id>();
        //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
        Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId(); 
        //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
        Id caseRecordTypeEliteClosedCPQ =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId(); 
        
        
        
        for( Case newCase : newCases ) {
            Case oldCase = oldCaseMap.get( newCase.Id );
            
            if(String.valueOf(newCase.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(newCase.RecordTypeId)!=caseRecordTypeEliteClosedCPQ){
                // Check to see if the owners have changed
                if( newCase.OwnerId != oldCase.OwnerId ) {
                    ownerChanges.add( newCase.Id );
                }
                if( newCase.Status != oldCase.Status ) {
                    statusChanges.add( newCase.Id );
                    if( !newCase.IsClosed && oldCase.isClosed ) {
                        reopenedCases.add( newCase.Id );
                    }
                }
                if( newCase.IsClosed ) {
                    closedCases.add( newCase.Id );
                }
            }
        }

        List<OSTCaseLogWrapper> ostCaseWrappers = getOSTCaseWrappers( ownerChanges, statusChanges, reopenedCases );
        if( !ostCaseWrappers.isEmpty() ) {
            List<Time_Log__c> newTimeLogs = new List<Time_Log__c>();
            List<Time_Log__c> logsToStop = new List<Time_Log__c>();

            for( OSTCaseLogWrapper wrapper : ostCaseWrappers ) {
                Case c = wrapper.getCase();
                // handle update
                logsToStop.addAll( wrapper.getLogsToBeStopped() );
                // handle new
                if( wrapper.isClosed ) {
                    newTimeLogs.add( startTimeLog( c, LogType.OWNER, CLOSED ) );
                    newTimeLogs.add( startTimeLog( c, LogType.STATUS, CLOSED ) );
                } else if( wrapper.isReopened ) {
                    newTimeLogs.add( startTimeLog( c, LogType.OWNER, wrapper.recentCaseStatus ) );
                    newTimeLogs.add( startTimeLog( c, LogType.STATUS, WAITING, wrapper.recentOwnerName ) );
                } else {
                    if( ( wrapper.isOwnerChanged && c.Owner.Name != wrapper.recentOwnerName ) || !wrapper.hasOpenOwnerLog ) {
                        newTimeLogs.add( startTimeLog( c, LogType.OWNER, WAITING ) );
                    }
                    if( ( wrapper.isStatusChanged && c.Status != wrapper.recentCaseStatus ) || !wrapper.hasOpenStatusLog ) {
                        newTimeLogs.add( startTimeLog( c, LogType.STATUS, WAITING ) );
                    }
                }
            }
            if( !newTimeLogs.isEmpty() ) {
                System.debug('Ziwei updated: ' + newTimeLogs);
                insert newTimeLogs;
            }
            if( !logsToStop.isEmpty() ) {
                for( Time_Log__c log : logsToStop ) {
                    stopTimeLog( log );
                }
                update logsToStop;
            }
        }
    }

    private static Time_Log__c startTimeLog( Case caseForLog, LogType lt, String status ) {
        return startTimeLog( caseForLog, lt, status, caseForLog.Owner.Name );
    }

    private static Time_Log__c startTimeLog( Case caseForLog, LogType lt, String status, String ownerName ) {
        Time_Log__c tl = new Time_Log__c(
            Owner_Name__c = ownerName,
            User__c = UserInfo.getUserId(),
            Case__c = caseForLog.Id,
            Case_Status__c = caseForLog.Status,
            Start_Time__c = Datetime.now(),
            Log_Type__c = lt.name(),
            Status__c = status
        );
        System.debug( 'Owner Type:: ' + caseForLog.owner.Type );
        if( caseForLog.owner.Type == 'Queue' ) {
            tl.Owner_Queue__c = caseForLog.owner.Name;
        } else {
            tl.Owner_User__c = caseForLog.owner.Id;
        }
        
        //Set start time right away if case is closed
        if(caseForLog.Status == CLOSED) {
            tl.Stop_Time__c = Datetime.now();
            tl.Business_Hour_Duration__c = 0;
        }
        
        return tl;
    }

    public static void stopTimeLog(Time_Log__c tl) {
        tl.Stop_Time__c = Datetime.now();
        tl.Business_Hour_Duration__c = BusinessHours.diff(tl.Case__r.BusinessHoursId, tl.Start_Time__c, tl.Stop_Time__c) / (MILLISECONDS_IN_SECOND * SECONDS_IN_MINUTE);
        if( tl.Log_Type__c == LogType.OWNER.name() ) {
            tl.User__c = UserInfo.getUserId();
        }
    }

    private static List<OSTCaseLogWrapper> getOSTCaseWrappers( Set<Id> ownerChanges, Set<Id> statusChanges, Set<Id> reopenedIds ) {
        Map<Id, OSTCaseLogWrapper> wrappers = new Map<Id, OSTCaseLogWrapper>();
        
        Set<Id> combinedIds = new Set<Id>( statusChanges );
        combinedIds.addAll( ownerChanges );
        
        if( !combinedIds.isEmpty() ) {
            List<Case> cases = [
                SELECT Id, Status, IsClosed, OwnerId, Owner.Name, Owner.Type 
                FROM Case
                WHERE Id IN :combinedIds
            ];

            for( Case c : cases ) {
                wrappers.put( c.Id, new OSTCaseLogWrapper( c, ownerChanges.contains( c.Id ), statusChanges.contains( c.Id ), reopenedIds.contains( c.Id ) ) );
            }

            List<Time_Log__c> existingLogs = [
                SELECT Id, Case__r.BusinessHoursId, Start_Time__c, Stop_Time__c, Case_Status__c, Status__c, Owner_Name__c, User__c, Log_Type__c, Case__c, Case__r.Owner.Type, Owner_Queue__c, Owner_User__c  
                FROM Time_Log__c 
                WHERE ( Case__c IN :combinedIds AND Stop_Time__c = null AND (Log_Type__c = :LogType.OWNER.name() OR Log_Type__c = :LogType.STATUS.name()) )
                    OR ( Case__c IN :statusChanges AND Duration_Minutes__c = 0 AND Status__c = :CLOSED )
            ];
            for( Time_Log__c tl : existingLogs ) {
                OSTCaseLogWrapper caseLogWrapper = wrappers.get( tl.Case__c );
                if( caseLogWrapper != null ) {
                    caseLogWrapper.addLog( tl );
                }
            }
        }
        return wrappers.values();
    }

    public class OSTCaseLogWrapper {
        private Case ostCase;
        private List<Time_Log__c> existingLogs;

        public Boolean isOwnerChanged {get; set;}
        public Boolean isStatusChanged {get; set;}
        public Boolean isClosed {get; set;}
        public Boolean isReopened {get; set;}
        public Boolean hasOpenOwnerLog {get; set;}
        public Boolean hasOpenStatusLog {get; set;}

        private String recentCaseStatus {get; set;}
        private String recentOwnerName {get; set;}

        public OSTCaseLogWrapper( Case fCase, Boolean isOwnerChanged, Boolean isStatusChanged, Boolean isReopened ) {
            this.ostCase = fCase;
            this.existingLogs = new List<Time_Log__c>();
            this.isClosed = ostCase.isClosed;
            this.isReopened = isReopened;

            this.isOwnerChanged = isOwnerChanged;
            this.isStatusChanged = isStatusChanged;
            this.hasOpenOwnerLog = false;
            this.hasOpenStatusLog = false;
        }

        public Id getCaseId() {
            return this.ostCase.Id;
        }

        public Case getCase() {
            return this.ostCase;
        }

        public void addLog( Time_Log__c tl ) {
            if( tl.Log_Type__c == LogType.OWNER.name() ) {
                this.hasOpenOwnerLog = true;
                this.recentOwnerName = tl.Owner_Name__c;

            } else if( tl.Log_Type__c == LogType.STATUS.name() ) {
                this.hasOpenStatusLog = true;
                this.recentCaseStatus = tl.Case_Status__c;
            }
            this.existingLogs.add( tl );
        }

        public List<Time_Log__c> getLogsToBeStopped() {
            List<Time_Log__c> runningLogsToStop = new List<Time_Log__c>();
            if( this.isClosed || this.isReopened ) {
                runningLogsToStop.addAll( existingLogs );
            } else {
                for( Time_Log__c log : existingLogs ) {
                    if( this.isOwnerChanged && log.Log_Type__c == LogType.OWNER.name() && ostCase.Owner.Name != this.recentOwnerName  ) {
                        runningLogsToStop.add( log );
                    } else if( this.isStatusChanged && log.Log_Type__c == LogType.STATUS.name() ) {
                        runningLogsToStop.add( log );
                    }
                }
            }
            return runningLogsToStop;
        }
    }
}