trigger MasterCaseTrigger on Case (before insert, after insert, before update, after update,before delete) {
//LTS_6301 : Exclusion framework
      System.debug(LoggingLevel.WARN,'LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
    // system.debug('MTRCaseManagementService.myTRCase --->'+ MTRCaseManagementService.myTRCase);
    List<case> newCaseList = new List<case>();
    Map<id,case> newCaseMap = new Map<id,case>();
    Map<id,case> oldCaseMap = new Map<id,case>();
    Boolean escCoreCheck = false;
        Boolean ueAccountOriginCheck = false;//Added by Deepika
    List<ESC_RecordTypeList__c> escrectp= ESC_RecordTypeList__c.getall().values();
        if(Trigger.New != null) {newCaseList = ESC_Utility.filteredNonCore(Trigger.New);}
        if(Trigger.NewMap != null)  {newCaseMap  = ESC_Utility.filteredNonCore(Trigger.NewMap);}
        if(Trigger.OldMap != null)  {oldCaseMap  = ESC_Utility.filteredNonCore(Trigger.OldMap);}

    if(trigger.isupdate && oldCaseMap.keySet().size()==0){
      return;
    }
    if(trigger.isbefore && trigger.isinsert){
        for(Case c:trigger.new){
            if(c.recordtypeid!=null){
                 string recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeid).getname();
            for(ESC_RecordTypeList__c escrdc: escrectp){
               if(escrdc.Name == recordtypename){
                    escCoreCheck = true;
                    break;
                       
                }   
           }
           if(recordtypename == 'Sales Case') {
                    ESC_PBUtility.updateSalesCase(Trigger.New);
                     //Added as part of DSS-9492
                   ESC_PBUtility.updateBillingCountry(newCaseList);
                }
            if(recordtypename == 'Case Intake'){
                    ESC_PBUtility.updateBillingCountry(Trigger.New);
                }
             }
        }
    }
    else if((trigger.isafter && trigger.isinsert )|| trigger.isupdate){     
        for(Case c:trigger.new){
                if(c.Origin == Label.UE_Account)    {ueAccountOriginCheck= true;}//Added by Deepika
            if(c.Is_ESC_Case__c){ 
                escCoreCheck = true;}
            else{
                escCoreCheck = false;}        
        }
    }
    //Call method for BeforeDelete - added for DSS-7962
    else if(trigger.isbefore && trigger.isdelete){
           for(sObject caseObj: oldCaseMap.values()){ 
           Case c = (Case)caseObj;   
            if(c.Is_ESC_Case__c && ((String) c.OwnerId).StartsWith('00G')) { 
                 c.addError(System.Label.ESC_DeleteonQueue);
                }       
        }
     }
    If(Trigger.IsBefore && Trigger.IsInsert ){
        if(escCoreCheck){ 
        //Start-Added as part of CP, copied over from Manualcasecontroller to cover for Flow case creation
             if(UserInfo.getName() != 'Automated Process' && !LCRMGenericComponent.isLotusUser()){
             ESC_PBUtility.updateManualCase(newCaseList);
             }
             //End-Added as part of CP
            //added for DSS-9274
           // if(! MTRCaseManagementService.myTRCase)
                ESC_Utility.checkValidationErrors(null,null,newCaseList);
            
            ESC_Utility.RecordTypeAssignemntCase(newCaseList);
            GenericUtilityHelper.CaseUpdates(newCaseList);
            GGO_Special_instruction_Capture.AccountSICapture(newCaseList);
            ESC_PBUtility.lastqueueownerupdate(newCaseList,null);
            ESC_PBUtility.calcCustomHoldTime(newCaseList,null);
            ESC_PBUtility.setGGOCaseVariables(newCaseList,null);
            //Added as part of DSS-9492
            if(UserInfo.getName() != 'Automated Process'){
            ESC_PBUtility.updateBillingCountry(newCaseList);
            }
                //added for Segment and Region Assignment on cloned Cases(DSS-8335/DSS-6785)
            for(case caseObj: newCaseList){
             id cloned = caseObj.getCloneSourceId();
             if(cloned != null){
             ESC_PBUtility.setRegionOnClone(newCaseList,cloned);
             }
            }
        }
        /*else{
            APTS_CaseTriggerGGOHelper.caseSync(Trigger.new,oldCaseMap);
        }*/
         
    }  

    //Call method for AfterInsert
    If(Trigger.IsAfter && Trigger.IsInsert ){
        if(escCoreCheck == true){
            Set<id> setcid = new Set<id>();
            List<case> autoCaseList = new List<case>();
            for(case c:newCaseList){
                setcid.add(c.Id);
                //code block started for DSS-5160
                if(c.AccountId != null || c.ContactId != null)
                {
                    autoCaseList.add(c); 
                }
                if(c.ESC_Reopen_Case__c  == false && UserInfo.getName() != Label.MaritzUser){ 
                    ESC_busHrsUtility.setBushrsOnCase(newCaseList); 
                }
            }
            if(UserInfo.getName() == 'Automated Process' && autoCaseList.size() >0){
                    ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(autoCaseList);
                }
                //code block ended for DSS-5160
            ESC_PBUtility.updatecreditcheckdate(newCaseList);
            ESC_Utility.caseEntitlementAssociation(newCaseMap,newCaseList);
            //ESC_SLA_Utility.caseSLAAssociation(newCaseMap,newCaseList);
            //  ESC_Utility.updateNextMilestoneTimes(setcid); // Has been commented and removed from code as part of EES-1
             //added for DSS-9274
            if(UserInfo.getName()!='Automated Process'/* && MTRCaseManagementService.myTRCase != true*/){
            ESC_FollowersMgmt.manageCaseFollowers(Trigger.new , null);
            }
        }
    }

    //Call method for BeforeUpdate
    If(Trigger.IsBefore && Trigger.IsUpdate ){
        
        if(escCoreCheck == true){
            
            if(MasterCaseTriggerRecursiveCheck.BeforeUpdate){
                ESC_Utility.checkDeActiveUser(Trigger.new);
                ESC_PBUtility.omniRoutedCheck(newCaseList,oldCaseMap);
                ESC_Utility.updateParentDetailsOnChildCase(newCaseList,oldCaseMap);
                //ESC_PBUtility.autoPopulateResolutionComment(newCaseMap,oldCaseMap,newCaseList);
                //added for DSS-7872
                ESC_PBUtility.qAssignOnDispute(newCaseList,oldCaseMap);
                //added for DSS-9274
               // if(MTRCaseManagementService.myTRCase != true)
                ESC_Utility.checkValidationErrors(newCaseMap,oldCaseMap,newCaseList);
                
               ESC_Utility.checkValidationForCancelled(newCaseMap,oldCaseMap);
                ESC_Utility.RecordTypeAssignemnt(newCaseMap,oldCaseMap,newCaseList);
                //ESC_Utility.updateMilestoneEntryFlag(newCaseMap,oldCaseMap);
                ESC_Utility.setCaseUPDFlag(newCaseMap,oldCaseMap,newCaseList);
                
                ESC_UPD_Utility.UPDFlagHelper(newCaseMap,oldCaseMap);
                    ESC_PBUtility.updUnchecking(newCaseList);
                ESC_PBUtility.setSurveyVariables(newCaseList,oldCaseMap);
                ESC_PBUtility.caseFirstCallResolutionUpdate(newCaseList,oldCaseMap);
                ESC_PBUtility.assingGrponDeactiveUsers(newCaseList,oldCaseMap);
           
            //ESC_PBUtility.lastqueueownerupdate(newCaseList,oldCaseMap);
                ESC_PBUtility.calcCustomHoldTime(newCaseList,oldCaseMap);
                ESC_PBUtility.calculateMTTRFields(newCaseList,oldCaseMap);
                ESC_PBUtility.calculateMTTCFields(newCaseList,oldCaseMap);
                ESC_PBUtility.accountUpdateOnContactChange(newCaseList,oldCaseMap);
                ESC_Utility.stopMilestone(newCaseMap,oldCaseMap);

        ESC_Utility.populateExternalTicketInfo(newCaseMap,oldCaseMap);
                 MasterCaseTriggerRecursiveCheck.BeforeUpdate=false;
            } 
            //Added outsiderecurrsive as part of EES-263/UKD-608/BAC-126
            ESC_Utility.updateMilestoneEntryFlag(newCaseMap,oldCaseMap);
            //Added outsiderecurrsive as part of DSS-514
             ESC_PBUtility.lastqueueownerupdate(newCaseList,oldCaseMap);
             ESC_PBUtility.setGGOCaseVariables(newCaseList,oldCaseMap);
            GenericUtilityHelper.CaseUpdates(oldCaseMap,newCaseMap);
            GLI_ResolutionTimeCalculator.CaseResolutionTimefromTrigger(oldCaseMap,newCaseMap);
        }
        /*else{
            APTS_CaseTriggerGGOHelper.caseSync(Trigger.new,oldCaseMap);
        }*/
    }

    //Call method for AfterUpdate
    If(Trigger.IsAfter && Trigger.IsUpdate ){
    
        
        if(escCoreCheck == true){
                  
           if(MasterCaseTriggerRecursiveCheck.AfterUpdate){
                
               ESC_Utility.recTypeAssignmentForMerge(newCaseMap,oldCaseMap);
                //ESC_Utility.caseEntitlementAssociation(newCaseMap,newCaseList);
             ESC_Utility.CloseRelatedReferralsOnCaseClosure(newCaseMap,oldCaseMap);
             //added for DSS-9274
              //  if(MTRCaseManagementService.myTRCase != true)
                ESC_FollowersMgmt.manageCaseFollowers(newCaseList , oldCaseMap);
                
                //ESC_Utility.caseMilestoneClosure(newCaseMap);
                //ESC_Utility.caseMileStoneToClose(newCaseList,oldCaseMap);
         GenericCaseMgmtService.setCreditCheckStatusOnQuote(newCaseMap,oldCaseMap);
     GLIGenericUtilityHelper.AssetSubscriptionLapseorReinstate(newCaseMap,oldCaseMap);
                MasterCaseTriggerRecursiveCheck.AfterUpdate=false;
               // ESC_EPx_Trigger_Methods.removeScheduledSurveysOnCaseReopen(newCaseList);
            }
            //code block started for DSS-5160
            List<case> autoCaseList1 = new List<case>();
            for(case c:newCaseList){
                if(UserInfo.getName() == 'Automated Process' && (oldCaseMap.get(c.id).AccountId != newCaseMap.get(c.id).AccountId || oldCaseMap.get(c.id).ContactId != newCaseMap.get(c.id).ContactId))
                {
                    autoCaseList1.add(c); 
                }
                if(c.ESC_Reopen_Case__c  == false && UserInfo.getName() != Label.MaritzUser && MasterCaseTriggerRecursiveCheck.checkRecursiveForforms){ 
                    ESC_busHrsUtility.setBushrsOnCase(newCaseList);
                } 
                }          
            if(UserInfo.getName() == 'Automated Process' && autoCaseList1.size() > 0){
                    ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(autoCaseList1);
                }
             //code block ended for DSS-5160
            if(!(UserInfo.getName() == Label.MaritzUser)){
            ESC_Utility.caseEntitlementAssociation(newCaseMap,newCaseList);
            ESC_Utility.caseMilestoneClosure(newCaseMap);
            ESC_Utility.caseMileStoneToClose(newCaseList,oldCaseMap); 
            }           
             List<Case> reopencaselist = new List<Case>();
            for(case c:newCaseList){
                if(c.Isclosed==false && oldCaseMap.get(c.id).IsClosed==true){
                    reopencaselist.add(c);
                }
            }
            if(reopencaselist.size()>0){
                ESC_EPx_Trigger_Methods.removeScheduledSurveysOnCaseReopen(reopencaselist);
            }
        }
        else{
                 //Add a conition here that if the origin is UE, the below piece of code should not be invoked - Deepika
                if(!ueAccountOriginCheck){
            CreatingESC_ServiceNow_Staging_Sales.CreateAndUpdateStagingRecords(Trigger.New);
        }
    }
}    }