/*
======================================================================================================================
CLASS NAME:  TMSLoadTerritory  Trigger
======================================================================================================================
PURPOSE:  A new batch needs to be written to load TMS Territory and Account Territory from Territory. Refresh periodically after the informatica job runs.
Technical Details:  A new batch class needs to be created in SFDC to populate TMS Territory and Account Territory Objects
JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
CHANGE HISTORY:

PURPOSE:  Re parenting of Notes & Attachments across all Objects(CRM-13837)
======================================================================================================================
DATE                    Developer NAME              DESC
01/02/2017              Radhika Pawar               Created.
03/02/2018              Radhika Pawar               Updated for CRM-13837
10/22/2018              Jason Flippen               Updated for CRM-13127
======================================================================================================================
*/

trigger GLILoadTrackerAfterEventListener on GLI_Load_Tracker__c (after update) {
    try{  
    
        map<String,GLI_Load_Tracker__c> mapofGliloadtracker = new map<String,GLI_Load_Tracker__c>(); 
        Set <String> nameOfGLItracker = new Set<String>();
        
        if(trigger.isUpdate){ 
            for(GLI_Load_Tracker__c gliTracker:Trigger.new){                
                mapofGliloadtracker.put(gliTracker.name,gliTracker);
            }
            
           
            if(mapofGliloadtracker.size()>0){
                
                //Commenting out as a part of removal of TM1.0 components
                /*if(mapofGliloadtracker.containsKey('Informatica Territory Load')){
                    if(mapofGliloadtracker.get('Informatica Territory Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica Territory Load').Id).JobCompletedDate__c){
                    System.debug('** TMSLoadTerritory **');
                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('TMSTerritory_AccountTeamBatch');
                    if(objGame.Batch_Size__c!=null){
                        System.debug('Batch size not null');
                        TMSTerritory_AccountTeamBatch AccountTerritoryLoad = new TMSTerritory_AccountTeamBatch();
                        Database.executeBatch(AccountTerritoryLoad,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        System.debug('Default');
                        TMSTerritory_AccountTeamBatch AccountTerritoryLoad = new TMSTerritory_AccountTeamBatch();
                        Database.executeBatch(AccountTerritoryLoad,100);
                    } 
                  }
                }//end informaticaterritory load
                */
                
                //Commenting out as a part of removal of TM1.0 components
                /*if(mapofGliloadtracker.containsKey('Opportunity Assignment')){
                    if(mapofGliloadtracker.get('Opportunity Assignment').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Opportunity Assignment').Id).JobCompletedDate__c){
                    LCRM_BatchsizeDefine__c opptyCustomIns = LCRM_BatchsizeDefine__c.getValues('OpptyTerritoryUpdateBatchSize');
                    if(opptyCustomIns.Batch_Size__c!=null){
                    
                    System.debug('** Opportunity Assignment **'); 
                    LcrmOpptyTerrIdUpdateBatch updateOpptyTerritoryId = new LcrmOpptyTerrIdUpdateBatch();
                    Database.executeBatch(updateOpptyTerritoryId,integer.valueof(opptyCustomIns.Batch_Size__c));
                    }
                  }
                }//End Opportunity Assignment
                */
                
                //Commenting out as a part of removal of TM1.0 components
                /*if(mapofGliloadtracker.containsKey('Lead Assignment')){
                    if(mapofGliloadtracker.get('Lead Assignment').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Lead Assignment').Id).JobCompletedDate__c){
                        LCRMBatchUpdateTMSTerritoryInLead  updateLeadTerritoryId = new LCRMBatchUpdateTMSTerritoryInLead ();
                        Database.executeBatch(updateLeadTerritoryId,100);
                    }
                    
                    if (mapofGliloadtracker.get('Lead Assignment').LCRMOpportunityStartDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Lead Assignment').Id).LCRMOpportunityStartDate__c) {
                    RefreshLeadActivityCountBatch refreshLACBatch = new RefreshLeadActivityCountBatch();
                    Database.executeBatch(refreshLACBatch,100);
                   }
                }//end lead assignement
                */
                
                if(mapofGliloadtracker.containsKey('Informatica XREF Account Family Load')){
                
                if(mapofGliloadtracker.get('Informatica XREF Account Family Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica XREF Account Family Load').Id).JobCompletedDate__c){
                    System.debug('**Informatica XREF Account Family Load**');
                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('XREFAccountFamily_Batch');
                //System.debug('objGame:-'+objGame);
                    if(objGame.Batch_Size__c!=null){
                        XREFAccountFamily_Batch AccountLoad = new XREFAccountFamily_Batch();
                        Database.executeBatch(AccountLoad,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        XREFAccountFamily_Batch AccountLoad = new XREFAccountFamily_Batch();
                        Database.executeBatch(AccountLoad,200);    
                    }
                }
                }//end XREF Account Family load
                
                if(mapofGliloadtracker.containsKey('Informatica XREF Opportunity Family Load')){
                
                if(mapofGliloadtracker.get('Informatica XREF Opportunity Family Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica XREF Opportunity Family Load').Id).JobCompletedDate__c){              

                    System.debug('**Informatica XREF Opportunity Family Load**');
                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('XREFOpportunityFamily_Batch');
                    //System.debug('objGame:-'+objGame);
                    if(objGame.Batch_Size__c!=null){
                        XREFOpportunityFamily_Batch OpptyLoad = new XREFOpportunityFamily_Batch();
                        Database.executeBatch(OpptyLoad,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        XREFOpportunityFamily_Batch OpptyLoad = new XREFOpportunityFamily_Batch();
                        Database.executeBatch(OpptyLoad,200);
                    }
                }
                
                }//Oppty ;oad
                
                if(mapofGliloadtracker.containsKey('Informatica XREF Case Family Load')){
                
                if(mapofGliloadtracker.get('Informatica XREF Case Family Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica XREF Case Family Load').Id).JobCompletedDate__c){              

                    System.debug('**Informatica XREF Case Family Load**');
                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('XREFCaseFamily_Batch');
                   // System.debug('objGame:-'+objGame);
                    if(objGame.Batch_Size__c!=null){
                        XREFCaseFamily_Batch CaseLoad = new XREFCaseFamily_Batch();
                        Database.executeBatch(CaseLoad,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        XREFCaseFamily_Batch CaseLoad = new XREFCaseFamily_Batch();
                        Database.executeBatch(CaseLoad,200);
                    }
                }
                
                }//
                
                
                
                if(mapofGliloadtracker.containsKey('Informatica XREF TrainingEvent Family Load')){
                
                if(mapofGliloadtracker.get('Informatica XREF TrainingEvent Family Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica XREF TrainingEvent Family Load').Id).JobCompletedDate__c){              

                    System.debug('**Informatica XREF TrainingEvent Family Load**');
                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('XREFTrainingEventFamily_Batch');
                    //System.debug('objGame:-'+objGame);
                    if(objGame.Batch_Size__c!=null){
                        XREFTrainingEventFamily_Batch TrainingEvent = new XREFTrainingEventFamily_Batch();
                        Database.executeBatch(TrainingEvent,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        XREFTrainingEventFamily_Batch TrainingEvent = new XREFTrainingEventFamily_Batch();
                        Database.executeBatch(TrainingEvent,200);
                     }
                }
                
                }
                
                
                if(mapofGliloadtracker.containsKey('Informatica Account SSD Load')){
                
                if(mapofGliloadtracker.get('Informatica Account SSD Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica Account SSD Load').Id).JobCompletedDate__c){              

                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('SSDBatchSize')!=null?LCRM_BatchsizeDefine__c.getValues('SSDBatchSize'):new LCRM_BatchsizeDefine__c();
                    //System.debug('objGame:-'+objGame);
                    if(objGame.Batch_Size__c!=null){
                        LCRMAccountSSDRollUp_Batch accountSSD= new LCRMAccountSSDRollUp_Batch ();
                        Database.executeBatch(accountSSD,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        LCRMAccountSSDRollUp_Batch accountSSD= new LCRMAccountSSDRollUp_Batch ();                      
                        Database.executeBatch(accountSSD,200);
                     }
                }
                
                }
                
                if(mapofGliloadtracker.containsKey('Informatica Account Segment Update')){
                    
                if(mapofGliloadtracker.get('Informatica Account Segment Update').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica Account Segment Update').Id).JobCompletedDate__c){
                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('XREFAccountSegment');
                    system.debug('XREFACCSEGMENTRECORD' +objGame);
                    Map<Id, Account> accountIdSegmentMap = new Map<Id, Account>();
                    List<XREFAccountSegment__c> accountSegmentList = new List<XREFAccountSegment__c>([SELECT Id, Name, BU_Segment__c, Is_Processed_Activity__c FROM XREFAccountSegment__c WHERE Is_Processed_Activity__c = false]);
                 for(XREFAccountSegment__c accsegment :accountSegmentList){
                        accountIdSegmentMap.put(Id.valueOf(accsegment.Name), new Account(Id = Id.valueOf(accsegment.Name), Bu_Segment__c = accsegment.BU_Segment__c));
                 }
                 SYSTEM.DEBUG('@@@aacountIdSegmentMap' +accountIdSegmentMap.size());
                 system.debug('@@@accountSegmentList@@@' +accountSegmentList);
                    if(accountIdSegmentMap.size()>0 && objGame.Batch_Size__c!=null && accountSegmentList!=Null){
                        LOTUSUpdateOpportunitySegmentBatch childObjUpdateBatch = new  LOTUSUpdateOpportunitySegmentBatch(accountIdSegmentMap, accountSegmentList);
                        system.debug('AfterEntering' +accountSegmentList);
                        database.executeBatch(childObjUpdateBatch,integer.valueof(objGame.Batch_Size__c));
                        LOTUSUpdateTaskSegmentBatch childActivityUpdateBatch = new  LOTUSUpdateTaskSegmentBatch(accountIdSegmentMap, accountSegmentList);
                        //database.executeBatch(childActivityUpdateBatch, 200);
                        System.scheduleBatch(childActivityUpdateBatch, 'LOTUSchildActivitySegmentUpdateBatch', 60);
                    }
                    
                   }
                }
                
                                //Start of Renewal Notifications Batch
                 if(mapofGliloadtracker.containsKey('Informatica Renewal Notifications Load')){
                
                if(mapofGliloadtracker.get('Informatica Renewal Notifications Load').JobCompletedDate__c != Trigger.oldMap.get(mapofGliloadtracker.get('Informatica Renewal Notifications Load').Id).JobCompletedDate__c){              

                    LCRM_BatchsizeDefine__c objGame = LCRM_BatchsizeDefine__c.getValues('RenewalNotificationsBatchSize')!=null?LCRM_BatchsizeDefine__c.getValues('RenewalNotificationsBatchSize'):new LCRM_BatchsizeDefine__c();
                    if(objGame.Batch_Size__c!=null){
                        RenewalQuoteBatch rQBatch = new RenewalQuoteBatch ();
                        Database.executeBatch(rQBatch,integer.valueof(objGame.Batch_Size__c));
                    }else{
                        RenewalQuoteBatch rQBatch= new RenewalQuoteBatch ();                      
                        Database.executeBatch(rQBatch,10);
                     }
                }
                
                }
                
                
            //Map checked    
            }else{
                        System.debug('No records found');
                    }           
            
        }//End IF condition
    }catch(Exception Ex){
      System.debug('Error:'+Ex);
  }
        
}