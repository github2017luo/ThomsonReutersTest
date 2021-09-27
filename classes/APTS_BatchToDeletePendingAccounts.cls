/**********************************************************************

Copyright © 2017 TATA CONSULTANCY SERVICES.

---------------------------------------------------------------------------------------

Req: CRM-10886 : Develop - Parameters for deleting pending customer only in Salesforce

----------------------------------------------------------------------------------------

Purpose : Batch class to Delete all Pending SSD records based on filter condition SAP Number is Blank and Record Type is USL and all proposals(Sold to) Approval Stage 'Expired' that are associated to SSD record 
 

----------------------------------------------------------------------------------------

History :

1.0     Tejaswi Nissankula      12/27/2017

**********************************************************************/
global class APTS_BatchToDeletePendingAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query;
        try{
            query='select id,Name,(Select id,Apttus_Proposal__Approval_Stage__c from Proposals__r) from  Source_System_Detail__c where (Source_System_Account_Number__c=null or Source_System_Account_Number__c=\'\') and RecordType.DeveloperName=\'USL_Source_Systems\'';
            system.debug('@@query::'+query);
            return Database.getQueryLocator(query);
        }catch(exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause'+ex.getCause());
            system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());
            return Database.getQueryLocator(query);
        }
        
    }
    global void execute(Database.BatchableContext bc,List<Source_System_Detail__c> ssdRecs){
        
        List<Source_System_Detail__c> ssdDeleteList=new List<Source_System_Detail__c>();
        try{
            if(ssdRecs!=null & ssdRecs.size()>0){
                system.debug('ssdRecs size'+ssdRecs.size());
                for(Source_System_Detail__c ssd:ssdRecs){
                    if(ssd.Proposals__r!=null && ssd.Proposals__r.size()>0){
						List<Apttus_Proposal__Proposal__c> totalProp=new List<Apttus_Proposal__Proposal__c>();
						List<Apttus_Proposal__Proposal__c> expiredProp=new List<Apttus_Proposal__Proposal__c>();
                        system.debug('proposals size'+ssd.Proposals__r.size());
                        for(Apttus_Proposal__Proposal__c rec:ssd.Proposals__r){
                                system.debug('propo rec id'+rec.Id);
                                totalProp.add(rec);
                            if(rec.Apttus_Proposal__Approval_Stage__c=='Expired'){
                                expiredProp.add(rec);
                            }
                        }
                        if(totalProp!=null && expiredProp!=null){
							system.debug('totalProp.size'+totalProp.size()+'expiredProp.size'+expiredProp.size()); 
                            if(totalProp.size()==expiredProp.size()){
                                ssdDeleteList.add(ssd);
                            }
                         }
                    }
        
                }
            }
            system.debug('@@##ssdDeleteList:: '+ssdDeleteList);
            if(ssdDeleteList!=null && ssdDeleteList.size()>0){
                delete ssdDeleteList;
            }
        }catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause'+ex.getCause());
            system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
}