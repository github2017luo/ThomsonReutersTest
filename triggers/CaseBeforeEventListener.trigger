trigger CaseBeforeEventListener on Case (before Insert, before Update) {


//LTS_6301 : Exclusion framework
System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
{return;}

   //Set<String> SetAnzSalesOrg = new Set<String>(KeyValueListStore__c.getInstance('ANZSalesOrg').TextValue__c.split(','));
   // Set<String> setReasonValues = new Set<String>{'Content Enquiry','Contract Enquiry','Demo Request','Follow-Up to Meeting','General / More info',
                                                    //'Pricing Enquiry','Product','Return / Exchange'};
                                                    
   // Set<String> setReasonValues = new Set<String> (KeyValueListStore__c.getInstance('ANZReasonValues').TextValue__c.split(','));
   // System.debug(setReasonValues);
   // List<Case> listCases = new List<Case>();    
   
   // Added by [Rajashree] For LatAm Renewal Cancel and Remove Case lock when once closed-->                                            
    /*  try{
       RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Case' AND Name='ANZ' LIMIT 1];
       System.debug('0 **** Record TypeId'+ rt);
        if(Trigger.isUpdate && Trigger.isBefore){
            for(Case c:trigger.new){
            System.debug('1 ****Status'+ trigger.oldMap.get(c.Id).Status);
            System.debug('2 ****Reason_Detail__c'+ trigger.oldMap.get(c.Id).Reason_Detail__c);
            System.debug('3 ****RecordType.DeveloperName'+ trigger.oldMap.get(c.Id).RecordType.DeveloperName);
                if(
                    trigger.oldMap.get(c.Id).Status == 'Closed' 
                 && (trigger.oldMap.get(c.Id).Reason_Detail__c.contains('Remove')
                     || trigger.oldMap.get(c.Id).Reason_Detail__c.contains('Full'))
                  &&  trigger.oldMap.get(c.Id).RecordTypeId == rt.Id
                ){
                     c.addError('You canot edit as the case has already been closed');
                }
            
            }   
        
        }
    }
    catch(Exception e){
        System.debug('Error : '+e);
    }
    
    */
         //Ajay Gundaveni:Added ESCCoreCheck flag to skip the apex calls for core related record types
     Boolean ESCCoreCheck = false;
   // if(trigger.newMap != NULL && !trigger.newMap.isEmpty()){
        if(trigger.isinsert || trigger.isupdate){
               for(Case c:trigger.new){
                   //Add a condition that if the case is a UE case then the core check should be true -- Deepika
                   if(c.Is_ESC_Case__c || c.Origin == Label.UE_Account){
                      ESCCoreCheck = true;
                   }else{
                      ESCCoreCheck = false;
                   }         
             }
    }
    if(trigger.isInsert || trigger.isUpdate){
        if(ESCCoreCheck ==false){
         if(!CaseTriggerHandler.updateManagerCalled || CaseTriggerHandler.caseRTCheck(Trigger.New)){
        CaseTriggerHandler.updateManager(trigger.oldmap, trigger.new, trigger.isInsert);
        }
        }
        //added by Saloni for CPQ
        if(Trigger.IsUpdate){
            CaseTriggerHandler.updateCaseOwner(trigger.oldmap, trigger.new);
        }
        
        //added by Saloni for Training Event(CRM-3239,CRM-3230)
        //if(Trigger.isInsert){
            //DPS-3328
            //Naushin
            System.debug('UserInfo.getName() for logged in username'+UserInfo.getName());
            if(Trigger.isInsert){
                List<Case> lstnewcase = new List<Case>();
                List<User> u = new List<User>();
                List<Id> lstSP = new List<Id>();
                List<Case> lstnewscscase= new List<Case>();
                List<Case> lstnewFcase= new List<Case>();
            if(UserInfo.getName()!='Automated Process')
             {
                 //Added check to bypass segment region for Commissions Cases
                 Id caseRecordTypeSCSInquiry = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCS_Inquiry').getRecordTypeId();
                 Id caseRecordTypeFLInquiry = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Findlaw_Inquiry').getRecordTypeId();
                  for(Case c:Trigger.new){
                      if(c.recordtypeid == caseRecordTypeFLInquiry){
                            lstnewFcase.add(c);
                            lstSP.add(c.Salesperson__c);
                        }
                      
                        if(c.recordtypeid != caseRecordTypeSCSInquiry){
                            lstnewcase.add(c);
                        }else{
                        if(c.origin!='Web' && c.origin!='Chat'){
                        lstSP.add(c.Salesperson__c);
                        lstnewscscase.add(c);
                        }
                        
                     
                        }
                   }
                    if(lstSP.size()>0){
                        if(Schema.sObjectType.user.isAccessible() && Schema.sObjectType.user.isQueryable()){ 
                            u = [select id,Regional_Mgr__c, Email,Sales_Org__c,Sub_Bu__c,Segment__c,Default_Catalog__c,Rep_Type_Description__c from user where Id in:lstSP];
                        }
                    }
                   system.debug('list u'+u);
                   if(u.size()>0 && lstnewFcase.size()>0){
                      for(Case c:lstnewFcase){
                          for(User usr:u){
                           if(usr.id == c.Salesperson__c){
                               c.ESC_GSI_Salesperson_Email__c = usr.Email;
                           }
                          }
                      }                       
                   }
                   //Populating Segment/region for SCS Cases on manual case creation from account by admins
                   if(u.size()>0 && lstnewscscase.size()>0){
                       for(Case c:lstnewscscase){
                           for(User usr:u){
                           if(usr.id == c.Salesperson__c){
                               system.debug('inside usrs');
                            c.Sales_Org__c= usr.Sales_Org__c;
                            c.LCRM_Sub_BU__c =usr.Sub_Bu__c;
                            c.BU_Segment__c = usr.Segment__c;
                            c.ESC_Default_Catalog__c = usr.Default_Catalog__c;
                            c.ESC_GSI_Salesperson_Email__c = usr.Email;
                            //break;
                            }
                            }
                       }
                   }
                if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()){
                
                   if(lstnewcase.size()>0){
                       LCRMGenericComponent.populatebuRegionSegmentLotus(lstnewcase);
                   }
                 }
              }
             
            CaseTriggerHandler.initialiseTrainingEventCaseValues(trigger.new);
            CaseTriggerHandler.associateContactandAccountwithTrainingEventCase(trigger.new);
             if(UserInfo.getName()!='Automated Process'){
            CaseTriggerHandler.populateSubbu(trigger.new); //added by Harika to set isGLI flag,Sub Bu and Sales Org 
            }
        }
    
    // Added as part of ANZ Stabilization Phase2 for populating Account field
    if(trigger.isInsert && ESCCoreCheck == false){
            CaseTriggerHandler.populateAccountonCase(trigger.new);
    }
    //End of ANZ stabilization phase2 code
    
    }
    
    /*if(trigger.isUpdate){
       Database.DMLOptions dmlOpts = new Database.DMLOptions();
       dmlOpts.assignmentRuleHeader.assignmentRuleId='01Qa0000000VrRH';
       dmlOpts.assignmentRuleHeader.useDefaultRule = false;

      for(Case oCase : trigger.new){ System.debug(oCase.ANZ_Issue__c == 'Enquiry' && setReasonValues.contains(oCase.Reason__c));
          if(SetAnzSalesOrg.contains(oCase.Sales_Org__c) && (
              (oCase.ANZ_Issue__c == 'Billing' && oCase.Reason__c == 'Cancellation - Assigned for Retention Activity')
              || (oCase.ANZ_Issue__c == 'Enquiry' && setReasonValues.contains(oCase.Reason__c))
              || (oCase.ANZ_Issue__c == 'Opportunities' && oCase.Reason__c == 'Sales lead')
              || (oCase.ANZ_Issue__c == 'Subscriptions' && oCase.Reason__c == 'CAB / Agreement Enquiry'))
              ){
                 listCases.add(oCase);
          } 
       }
      
      if(!listCases.IsEmpty()){
        CaseTriggerHandler.UpdateCaseOwner(listCases);
      }
    }*/
    /***************************************/
    try{
        set<id> opptyIdSet = new set<id>();
        map<Id, Opportunity> opptyMap;
        if((Trigger.IsInsert && Trigger.isBefore)||(Trigger.IsUpdate && Trigger.isBefore)){
            //CaseTriggerHandler.updateUserFieldsOnCase(trigger.new);
            System.debug('Update Oppty Mgr---->');
            for(Case c:trigger.new) {
                System.debug('Update Oppty Mgr---->c.Opportunity__c'+c.Opportunity__c+' c.Opportunity__r.Owner :'+c.Opportunity__r.Owner.Id+' c.Reason__c'+c.Reason__c);
                if(c.Opportunity__c!=null && c.Reason__c!=null && c.Is_ESC_Case__c!=true){
                    if(c.Reason__c.equals('Grace Period Extension')){
                        opptyIdSet.add(c.Opportunity__c);
                    }
                    
                }
            }
            if(opptyIdSet.size()>0){
                opptyMap = new map<Id, Opportunity>([SELECT Id, AccountId, OwnerId,Reservation_Manager__c, Owner.ManagerId,Reservation_Number__c from opportunity where Id IN: opptyIdSet]);
            }
            for(Case c:trigger.new) {
                System.debug('Update Oppty Mgr---->c.Opportunity__c'+c.Opportunity__c+' c.Opportunity__r.Ownerid :'+c.Opportunity__r.OwnerId+' c.Reason__c'+c.Reason__c);
                //System.debug('opptyMap.get(c.Opportunity__c).OwnerId---->'+opptyMap.get(c.Opportunity__c).OwnerId);
                if(c.Is_ESC_Case__c!=true && c.Opportunity__c!=null && (opptyMap.get(c.Opportunity__c).OwnerId)!=null && c.Reason__c!=null && c.Approval_Status__c!=null && opptyMap.get(c.Opportunity__c).Owner.ManagerId!=null){
                    if(c.Reason__c.equals('Grace Period Extension')&& (c.Approval_Status__c.equals('Approved')==false))
                    {
                        c.OwnerId=opptyMap.get(c.Opportunity__c).OwnerId;
                        System.debug('Update Oppty owner---->'+c.OwnerId);
                        
                        c.Opportunity_Owner__c=opptyMap.get(c.Opportunity__c).OwnerId;
                        c.Opportunity_Owner_Manager__c=opptyMap.get(c.Opportunity__c).Owner.ManagerId;
                    }
                    
                }
                if(c.Is_ESC_Case__c!=true && c.Opportunity__c!=null && (opptyMap.get(c.Opportunity__c).Reservation_Manager__c)!=null && c.Reason__c!=null && c.Approval_Status__c!=null){
                    if(c.Reason__c.equals('Grace Period Extension')&& (c.Approval_Status__c.equals('Approved')==false))
                    {
                        c.Opportunity_Reservation_Manager__c=opptyMap.get(c.Opportunity__c).Reservation_Manager__c;
                        System.debug('Update Oppty rese4rvetion mgr---->'+c.Opportunity_Reservation_Manager__c);
                        
                    }
                    
                }
            }
            
        }
    }
    catch(Exception e){
        System.debug('Case Owner Update failed for Grace Period : '+e);
    }
    /***************************************/
}