/*
======================================================================================================================
TRIGGER NAME:  OpportunityTrigger
======================================================================================================================
=
PURPOSE: Processes Opportunity records before a DML event is processed by the system

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Karthi                 Optimized the code as per JIRA STORY: PS0-1
2020-10-13        LATAM Community Partner     Commenting code related to Reservation process 
======================================================================================================================
*/ 
trigger OpportunityTrigger on Opportunity (before insert, before update) {
        
         Boolean blnRenewalChck = false;
         //LTS_5227 : Exclusion framework
        System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
        If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){
        return;
        }
        if(trigger.new != NULL && !trigger.new.isEmpty()){
            for(Opportunity op : trigger.new){
                if(op.Renewal_Flag__c == true && RecordtypeIds__c.getInstance('LATAM Renewal Opportunity') != NULL && op.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c )
                    {
                    blnRenewalChck = true;
                    }
                else{
                    blnRenewalChck = false;   
                    }     
            }
        }
        
     List<Opportunity> lstOpty = new List<Opportunity>();
     List<Opportunity> lstOptyTerritory = new List<Opportunity>();
      List<Opportunity> OpptyList = new List<Opportunity>();

     //Insert Event methods
     
    if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){//Added for CRM-14346
        if(trigger.isinsert){
        if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){ 
        LCRMGenericComponent.populateSubbu(trigger.new);//tejas code to update subBu LCRM
        //added as a part of DPS-1442 to check whether the user is from LOTUS
        if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()) 
        {
            LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
        }
        } 
        if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
            //Commenting below line as part of DPS-17684
            //OpportunityTriggerHandler.Reservationactivecheck(trigger.new);
            if(!blnRenewalChck){
                OpportunityTriggerHandler.updateOptyTerritory(trigger.new);
            }
            if(!blnRenewalChck){
                OpportunityTriggerHandler.SyncTerritoryQuota(trigger.new);
            }
            if(!blnRenewalChck){
                OpportunityTriggerHandler.SyncUserQuota(trigger.new);
            }
            if(!blnRenewalChck){
                OpportunityTriggerHandler.UpdatePartneruser(trigger.new,true);    //PHP-2
            }
            //Commenting below lines as part of DPS-17684
            /*if(!blnRenewalChck){
                OpportunityTriggerHandler.validateAccountApprovedReservation(trigger.new); // PHP-50
            }
            */
            if(!blnRenewalChck){
                OpportunityTriggerHandler.insertSalesOrgLatAmBU(trigger.new); // SFD-14
            }
            
            //Commenting below line as part of DPS-17684
            //OpportunityTriggerHandler.updateReservationMng(trigger.new, null); // Added by Shovon for SFD-497 
        }
        /*if(!blnRenewalChck){ //CRM-13436 : To update territoryId for GLI Opportunities        
            LCRMOpportunityTerritoryService.updateOppTerritoryId(Trigger.isExecuting,trigger.new);           
        } */
        String userSubbbu = LCRMGenericComponent.getUserBU();
        if(LCRMGenericComponent.isLotusUser() && !LCRMGenericComponent.StrikeIronCheckActive() ){
        LOTUSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
        }
        else if(String.isNotBlank(userSubbbu) && LCRMGenericComponent.validateUserBU(userSubbbu) && !LCRMGenericComponent.StrikeIronCheckActive()){
    LOTUSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
}
    }

     //Update Event methods
     if(trigger.isupdate && checkRecursive.beforeUpdateOppotunityRecCheck  == false){
     if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
      checkRecursive.beforeUpdateOppotunityRecCheck  = true;
      
       //if(checkRecursive.runOpptyLockOnce()){
           //if(!blnRenewalChck){
               OpportunityTriggerHandler.lockOpptyWithoutSplit(trigger.new,trigger.oldmap);//SFD-541 //Added REcursive cehck for MASTERSAF blocker
           //}
           //03/15/2016 JIRA 418 - Cirrius
      //     if(!blnRenewalChck){
               OpportunityTriggerHandler.Validation_LockOpportunityWhileQuoteBeingApproved(trigger.oldmap, trigger.newMap);//Added REcursive cehck for MASTERSAF blocker
       //    } 
                      
      // }
       
       //if(!blnRenewalChck){
        
       if(OpportunityTriggerHandler.beforeUpdateAcadAdopMappingRecCheck == false){
           OpportunityTriggerHandler.beforeUpdateAcadAdopMapping(trigger.new);
           OpportunityTriggerHandler.beforeUpdateAcadAdopMappingRecCheck = true; 
       }
       
      if(!blnRenewalChck){
           OpportunityTriggerHandler.updateOptyTerritory(trigger.new,trigger.oldmap);
       }
               /*if(!blnRenewalChck && checkRecursive.runupdateOppTerritory()){ //CRM-13436 : To update territoryId for GLI Opportunities     
            LCRMOpportunityTerritoryService.updateOppTerritoryId(trigger.isexecuting,trigger.new,trigger.oldmap);
            
        }*/
        String userSubbbu = LCRMGenericComponent.getUserBU();
if(LCRMGenericComponent.isLotusUser() && !LCRMGenericComponent.StrikeIronCheckActive() ){
        LOTUSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
        }
        else if(String.isNotBlank(userSubbbu) && LCRMGenericComponent.validateUserBU(userSubbbu) && !LCRMGenericComponent.StrikeIronCheckActive()){
    LOTUSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
}
       if(!blnRenewalChck){
           OpportunityTriggerHandler.checkContactRolePrimary(trigger.new, trigger.oldmap);
       }
       List<Opportunity> tempOppOwnerUpList = new List<Opportunity>();
       //Commenting below lines as part of DPS-17684
       //List<Opportunity> tempOppResMgrUpList = new List<Opportunity>();
       for(Opportunity opp : trigger.new){
           if(opp.ownerID != Trigger.OldMap.get(opp.ID).OwnerId){
               tempOppOwnerUpList.add(opp);
           }
           //Commenting below lines as part of DPS-17684
           /*if(opp.Reservation_Number__c != Trigger.OldMap.get(opp.ID).Reservation_Number__c||
              opp.Reservation_Manager__c != Trigger.OldMap.get(opp.ID).Reservation_Manager__c ){
               tempOppResMgrUpList.add(opp);
           }*/
       }
       //if(!blnRenewalChck){ Commented as part of MCL-1649
           if(tempOppOwnerUpList.size()>0){
               OpportunityTriggerHandler.UpdatePartneruser(tempOppOwnerUpList,false);
           //OpportunityTriggerHandler.UpdatePartneruser(trigger.new,false);
       }
       if(checkRecursive.runOpptyBeforeListnerOnce()){
         //  OpportunityTriggerHandler.OpportunityLock(trigger.new, trigger.old);
       
       //03/20/2016 JIRA 440 - Cirrius
       if(!blnRenewalChck){
           OpportunityTriggerHandler.UpdateRelatedQuoteFieldsFromOppotunity(trigger.oldmap, trigger.newMap);
           //OpportunityTriggerHandler.validatecompetitiveinfo(trigger.new);
       }
       }
        //Commenting below line as part of DPS-17684
        //OpportunityTriggerHandler.Reservationactivecheck(trigger.new);
       for(Opportunity oOpportunity : trigger.new){

           if(trigger.oldMap.get(oOpportunity.id).StageName != oOpportunity.stageName && oOpportunity.StageName > '75%' && (oOpportunity.Sales_Org__c != 'EDIC' &&
           oOpportunity.Sales_Org__c != 'SFWS' && oOpportunity.Sales_Org__c != 'SCSI' && oOpportunity.Sales_Org__c != 'TSCE'))
                 {
                    OpptyList.add(oOpportunity);
                   // system.debug('**OpptyList..'+  OpptyList);
                 }
           
           if(oOpportunity.OwnerId!=trigger.oldmap.get(oOpportunity.Id).OwnerId
               || oOpportunity.CloseDate!=trigger.oldmap.get(oOpportunity.Id).CloseDate){
               lstOpty.add(oOpportunity);
           }

      /*     if(oOpportunity.CloseDate!=trigger.oldmap.get(oOpportunity.Id).CloseDate
               || oOpportunity.Territory2Id!=trigger.oldmap.get(oOpportunity.Id).Territory2Id){
               lstOptyTerritory.add(oOpportunity);
           }
           */
             if(oOpportunity.CloseDate!=trigger.oldmap.get(oOpportunity.Id).CloseDate){
               lstOptyTerritory.add(oOpportunity);
           }
           
           
           if(oOpportunity.Is_Master_Opportunity__c == true && oOpportunity.Amount != NULL && oOpportunity.Child_Opportunity_Amount_Subtotal__c !=NULL){
           oOpportunity.Child_Amount_Subtotal_Variance__c = oOpportunity.Amount-oOpportunity.Child_Opportunity_Amount_Subtotal__c;
           }
       }
       ContactUtil.validateOppStage(OpptyList);

       if(!lstOpty.isEmpty()){
           if(!blnRenewalChck){
               OpportunityTriggerHandler.SyncUserQuota(lstOpty);
           }
       }
       if(!lstOptyTerritory.isEmpty()){
           if(!blnRenewalChck){
               OpportunityTriggerHandler.SyncTerritoryQuota(lstOptyTerritory);
           }
       }
       //Commenting below line as part of DPS-17684
       /*if(tempOppResMgrUpList.size()>0){
           OpportunityTriggerHandler.updateReservationMng(tempOppResMgrUpList, trigger.oldmap); // Added by Shovon for SFD-497
       }*/
    }
    }
    // Moved to After trigger
    /*if(trigger.isupdate && trigger.isafter){
       OpportunityTriggerHandler.afterUpdateSalesTeam(trigger.new,trigger.old,trigger.oldmap);
    }
    if(trigger.isinsert && trigger.isafter){
        OpportunityTriggerHandler.CreateOwnerasTeamMember(trigger.new);
    }*/

    }

     if(trigger.isinsert){
        // Added as part of MCL-2442 - to avoid CPU Time Limit Error
        AccountHandler.bypassLeadUpdateonOpptyCreation = true;
    }
    if(Trigger.IsBefore && Trigger.isdelete){
            LCRMRestrictRecordDeletion.restrictRecordDeletion(Trigger.old);
            }

     
}