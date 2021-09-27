/*
======================================================================================================================
Trigger Name : LeadBeforeEventListener 
Test Classes for Trigger :AppUtil_Test,LCRMLeadTerritoryService_Test,LeadTriggerHandler_Test

CRM-18016 : Lead Conversion failure due to Strike Iron validation
DPS-19692 : Added LMLeadTrigger triger logic into LeadBeforeEventListener trigger as part of Triggers Logic Optimization JIRA   
======================================================================================================================
*/
trigger LeadBeforeEventListener on Lead (before update,before insert,before delete) {
//LTS_6300 : Exclusion framework
      //System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability()); //Commented as part of DPS-19692
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
    LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler(); //Relocated-to this line here as part of DPS-19692
    LeadRepAssignmentHandler oLeadRepAssignmentHandler = new LeadRepAssignmentHandler();//Added as part of DPS-19692
    LIST<String> EloquaUserList= new LIST<String>();  //Added as part of DPS-19692       
    SET<String> EloquaUserSet= new SET<String>(); //Added as part of DPS-19692
    private static final String USERNAME_TRLEGALUS_ELOQUA = 'TRLegalUS Eloqua'; //Added as part of DPS-19692
    string loggedInUser = system.label.UserLoggedIn; //Added as part of DPS-19692
if(Boolean.valueOf(System.Label.DisableTrigger_Lead) == False){ // Added as a part of CRM -14346 to bypass triggers while informatica performs data load
    List<Lead> listLead = new List<Lead>();
    List<Lead> listLeadContact = new List<Lead>();
    List<Lead> lstLead = new List<Lead>();
    //LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler(); //Commented as part of DPS-19692
    List<Lead> listRecordTypeLead = new List<Lead>(); //Added for LCRM LEAD Tejas
    //System.debug('Trigger.new1-->'+Trigger.new); //Commented as part of DPS-19692

    if(trigger.IsInsert || (trigger.IsUpdate && LeadTriggerHandler.PopulateLeadOwnerRecCheck == false)){
        oLeadTriggerHandler.PopulateLeadOwner(Trigger.new);
         string strProfileNAme = AppUtil.getProfileName(userInfo.getProfileId()); 
         //Added for CRM-15772
        if(strProfileNAme != 'System Administrator'){
            oLeadTriggerHandler.updateLastUpdatedByLeadOwner(Trigger.new);
        }
        if(trigger.IsUpdate){
            LeadTriggerHandler.PopulateLeadOwnerRecCheck = true;
        }
       //System.debug('Trigger.new1-->'+Trigger.new);//Commented as part of DPS-19692
         /*//BIG RULE
         SET<id> accountIdSet= new SET<Id>();
         for(Lead l:Trigger.new){
             accountIdSet.add(l.Account__c);    
         }
         if(accountIdSet!= null && accountIdSet.size() >0 && ProcessorControl.inFutureContext == false && !(System.isFuture() || System.isBatch())){
             Set<ID> newLeadIDs = Trigger.newMap.keySet();
             LeadTriggerHandler.updateLeadFromAccount(newLeadIDs, accountIdSet);
         }*/

    }
    if(trigger.IsInsert){
     if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){ 
    //System.debug('Method calledpopulateSubbu**'); //Commented as part of DPS-19692
         LCRMGenericComponent.populateSubbu(trigger.new);//tejas code to update subbu    
     }
     
     System.debug('LCRMGenericComponent.StrikeIronCheckActive()'+LCRMGenericComponent.StrikeIronCheckActive());
     System.debug('LCRMGenericComponent.isLotusUser()**'+LCRMGenericComponent.isLotusUser());
    if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()) {
       System.debug('Lead info'+trigger.new.size());
       if(trigger.new.size()>0){
           //LCRMPopulateBuRegionSegment.populateRegiononLeadCreation(trigger.new);
           LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
           /*for(Lead o:trigger.new){
               System.debug('ISclone**'+o.isClone());
               if(o.isClone()){
                   ID exelead= o.getCloneSourceId();
                   System.debug('exelead***'+exelead);
                   Lead leadval=[select id,Billing_Country__c,IS_GLI__c from lead where id=:exelead];
                   System.debug('exelead.Billing_Country__c**'+leadval.Billing_Country__c);
                   o.Billing_Country__c=leadval.Billing_Country__c;
                   o.IS_GLI__c=true;
               }
               System.debug('Lead rec**'+o);
           }*/
           
           }
      }
      //Populate Segment for Partner User
      //SYSTEM.DEBUG('****populateSegmetForPartnerUser**** ');//Commented as part of DPS-19692
      if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()) {
       //System.debug('Lead info'+trigger.new);//Commented as part of DPS-19692
       //SYSTEM.DEBUG('**** INSIDE populateSegmetForPartnerUser**** ');//Commented as part of DPS-19692
       //SYSTEM.DEBUG('****populateSegmetForPartnerUser**** ');//Commented as part of DPS-19692
       if(trigger.new.size()>0){
       LTS_populateSegmentForPartnerUser.populateSegmetForPartnerUser(trigger.new);
       }
      }
     oLeadTriggerHandler.PopulateAccountonLead(trigger.new);
     oLeadTriggerHandler.PopulateContactonLead(trigger.new);
     
     // Start : Assigning TMS Territory Number to a lead - CRM-13625 and CRM-13435- By Navjyoti
     //Commenting out as a part of removal of TM1.0 components
     //LCRMLeadTerritoryService.updateLeadTerritoryNumber(Trigger.New);
     //End
/*String userSubbbu = LCRMGenericComponent.getUserBU();
if(LCRMGenericComponent.isLotusUser() && !LCRMGenericComponent.StrikeIronCheckActive() ){
    LTSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
}
else if(String.isNotBlank(userSubbbu) && LCRMGenericComponent.validateUserBU(userSubbbu)){
    LTSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
}*/

     //Add method to check for Associated account change and throw and error if GLi Account is attached to an S2E lead
     oLeadTriggerHandler.ValidateGLIAccountNotAssociatedToS2ELead(trigger.new);
     //oLeadTriggerHandler.updaterecordtype(trigger.new);//Tejas code to update recordtype on lead
      //start: DPS-1711 Create Pick List Field for BU Segment and Text Field for BU Region for Lead Records 
     
    }
    if(trigger.IsUpdate){
        
        //System.debug('LCRMGenericComponent.StrikeIronCheckActive()'+LCRMGenericComponent.StrikeIronCheckActive());
        //System.debug('LCRMGenericComponent.isLotusUser()**'+LCRMGenericComponent.isLotusUser());
        //System.debug('trigger.newMap**'+trigger.newMap);//Commented as part of DPS-19692
        //System.debug('trigger.newMap**'+trigger.newMap);//Commented as part of DPS-19692
        //System.debug('trigger.newMapSize**'+trigger.newMap.size());//Commented as part of DPS-19692
        //System.debug('trigger.oldMap**'+trigger.oldMap);//Commented as part of DPS-19692
        //System.debug('trigger.oldMapSize**'+trigger.oldMap.size());//Commented as part of DPS-19692
        
        oLeadTriggerHandler.rejectionReasonValidation(Trigger.oldMap, Trigger.newMap);
        oLeadTriggerHandler.checkFieldsBeforeApproval(Trigger.oldMap, Trigger.new);
        
        if(/*!LCRMGenericComponent.StrikeIronCheckActive() &&*/ LCRMGenericComponent.isLotusUser()) {
             // added executeOnce recurssive check as part of MCL-2506
                if(trigger.newMap.size()>0 &&trigger.oldMap.size()>0 && LeadTriggerHandler.executeOnce == true){
                LCRMPopulateBuRegionSegment.populateRegiononLeadupdate(trigger.newMap,trigger.oldMap);
                LeadTriggerHandler.executeOnce = false;
                }
        }
        //
        //System.debug('Trigger.new2-->'+Trigger.new);//Commented as part of DPS-19692
         if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){ 
         //System.debug('Legal_CRM_Switch**');//Commented as part of DPS-19692
            LCRMGenericComponent.ownerChangeForGlilead(trigger.newMap,trigger.oldMap);//tejas code to change of owner from queue to user.
            LCRMGenericComponent.changerecordtypesubuonlead(trigger.newMap,trigger.oldMap);//tejas code to update subbu on change of owner
        }
        //System.debug('Trigger.new3-->'+Trigger.new);//Commented as part of DPS-19692
        for(Lead oLead : trigger.new){
            if(oLead.SAPAccountNumber__c!=trigger.oldmap.get(oLead.Id).SAPAccountNumber__c 
            || oLead.OwnerId!=trigger.oldmap.get(oLead.Id).OwnerId
            || oLead.MDBID__c!=trigger.oldmap.get(oLead.Id).MDBID__c 
            || oLead.Legacy_System_ID__c!=trigger.oldmap.get(oLead.Id).Legacy_System_ID__c
            || oLead.WLD_ID__c!=trigger.oldmap.get(oLead.Id).WLD_ID__c){
                listLead.add(oLead);
            }
            if(oLead.Contact_SAP_ID__c !=trigger.oldmap.get(oLead.Id).Contact_SAP_ID__c 
                || oLead.External_Contact_ID__c !=trigger.oldmap.get(oLead.Id).External_Contact_ID__c){
                listLeadContact.add(oLead);

            }
            if(oLead.LCRM_Sub_BU__c != trigger.oldmap.get(oLead.Id).LCRM_Sub_BU__c ){
                listRecordTypeLead.add(oLead);
            }
        }
        //System.debug('Trigger.new4-->'+Trigger.new);//Commented as part of DPS-19692
        //system.debug('listLead : '+listLead);//Commented as part of DPS-19692
        if(!listLead.IsEmpty()){
            if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
                oLeadTriggerHandler.PopulateAccountonLead(listLead);
            }
        }
        //System.debug('Trigger.new5->'+Trigger.new);//Commented as part of DPS-19692
        if(!listLeadContact.IsEmpty()){
            oLeadTriggerHandler.PopulateContactonLead(listLeadContact);
         }
        //System.debug('Trigger.new6-->'+Trigger.new);//Commented as part of DPS-19692
         //if(!listRecordTypeLead.isEmpty())
         //{
             //oLeadTriggerHandler.updaterecordtype(listRecordTypeLead);
         //}
         
        // Start : Assigning TMS Territory Number to a lead - CRM-13625 and CRM-13435- By Navjyoti
        //Commenting out as a part of removal of TM1.0 components
        /*if(LCRMLeadTerritoryService.canIRun()&&LCRMConvertLeadController.restrictTMSFunc){
        system.debug('+++++++ entered if :');
         LCRMLeadTerritoryService.updateLeadTerritoryNumber(Trigger.New);
        }
        System.debug('Trigger.new7-->'+Trigger.new);*/
        //End
/*String userSubbbu = LCRMGenericComponent.getUserBU();
if(LCRMGenericComponent.isLotusUser() && !LCRMGenericComponent.StrikeIronCheckActive() ){
    LTSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
}
else if(String.isNotBlank(userSubbbu) && LCRMGenericComponent.validateUserBU(userSubbbu)){
    LTSTerritoryAssignmentHandler.assignTerritory(Trigger.New);
}*/
    }
    
    
    
      
    //Process On: Insert or Update Events for Tax number validation CMC-3
    if (trigger.isInsert || trigger.isUpdate) {
        //Update Address Tokens
         boolean valid = true;
         //CMC-4
        string strProfileNAme = AppUtil.getProfileName(userInfo.getProfileId()); 
        //Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];         
        for(Lead a : Trigger.new) {
     
        //if(ProfileName.Name=='LatAm User'){
        if(strProfileNAme=='LatAm User'){
          
        if(a.Industry_LatAm__c==null || a.Industry_LatAm__c==''|| a.Industry_LatAm__c=='--None--')
            {a.Industry='NOT APPLICABLE';}
                else
                    {a.Industry=a.Industry_LatAm__c;}
        
        }
     
     
        String tipo = a.Tax_Number_Type__c;
        String nro = a.Tax_Number__c;
        String BillCon = a.Billing_Country__c;
        
        if(tipo != null && nro != null) {
 
             if(BillCon=='AR' && tipo.equalsIgnoreCase('C.U.I.T.'))
               {valid = LeadTriggerHandler.isValidCUIT(nro);}
           else
               if(BillCon=='AR' && (tipo.equalsIgnoreCase('C.U.I.L.')||tipo.equalsIgnoreCase('C.D.I')))
               {valid = LeadTriggerHandler.isValidCUILCDI(nro);}
           else
               if(BillCon=='AR' && (tipo.equalsIgnoreCase('D.N.I.')||tipo.equalsIgnoreCase('L.E.')||tipo.equalsIgnoreCase('L.C.')))
               {valid = LeadTriggerHandler.isValidDNILELC(nro);}
           else
             if(BillCon=='AR' && (tipo.equalsIgnoreCase('C.I.')||tipo.equalsIgnoreCase('PASAPORTE')))
               {valid = LeadTriggerHandler.isValidCI(nro );}
                    

            
          if(!valid)
            {a.Tax_Number__c.addError('Tax Number '+tipo+' is not valid');}
            }
        }
        //System.debug('Trigger.new8-->'+Trigger.new);//Commented as part of DPS-19692
        if(trigger.isUpdate)
        {
            for(Lead oLead:trigger.new)
            {
                if(oLead.Account__c != null && oLead.Account__c != trigger.OldMap.get(oLead.id).Account__c){
                    lstLead.add(oLead);
                }
            }
            //Add method to check for Associated account change and throw and error if GLi Account is attached to an S2E lead
            oLeadTriggerHandler.ValidateGLIAccountNotAssociatedToS2ELead(lstLead);
        }
        //System.debug('Trigger.new9-->'+Trigger.new);//Commented as part of DPS-19692
    }
    //CRM-18016 Start : LCRM Project : StrikeIron verification
    List<Lead> Leadlst= new List<Lead>();
    Set<String>SubBUstr = new Set<String>();
    if(Trigger.IsBefore && Trigger.IsInsert || Trigger.IsBefore && Trigger.IsUpdate /*&& LeadTriggerHandler.verifyEmailAndPhoneRecCheck == false*/ && !System.isFuture() && !System.isBatch()){
        //System.debug('Trigger Before and Update and Insert');//Commented as part of DPS-19692
        
        KeyValueListStore__c tempValueStore = KeyValueListStore__c.getValues('LCRMStrikeIronSubBULeads');
        //system.debug('tempValueStore **'+tempValueStore );//Commented as part of DPS-19692
        if(tempValueStore !=null && tempValueStore.TextValue__c!=null && tempValueStore.TextValue__c!=''){              
       //System.debug('tempValueStore.TextValue__c*'+tempValueStore.TextValue__c);//Commented as part of DPS-19692
        SubBUstr.add(tempValueStore.TextValue__c);
        }   
        //System.debug('Sub_BUmap**'+SubBUstr);    
        for(Lead LeadValue : Trigger.New ){    
        //System.debug('LCRmSUB BU'+LeadValue.LCRM_Sub_BU__c);//Commented as part of DPS-19692
        
        if(String.isnotblank(LeadValue.LCRM_Sub_BU__c)) {    
            If(!JSON.serialize(SubBUstr).contains(LeadValue.LCRM_Sub_BU__c)){
                //System.debug('Not contains data');//Commented as part of DPS-19692  
                Leadlst.add(LeadValue);  
            }
        }

       }
    }
    //System.debug('Leadlst**'+Leadlst);//Commented as part of DPS-19692
    //System.debug('Leadlst**'+Leadlst.size());//Commented as part of DPS-19692
     if(!Leadlst.isempty()){
        if(Trigger.IsBefore && Trigger.IsInsert){
            //System.debug('Leadlst Trigger New:-'+Leadlst);//Commented as part of DPS-19692
            //oLeadTriggerHandler.verifyEmailAndPhone(null,Leadlst);
            oLeadTriggerHandler.addISDcodeWithPhoneOrMobile(null,Leadlst);
        }else if(Trigger.IsBefore && Trigger.IsUpdate /*&& LeadTriggerHandler.verifyEmailAndPhoneRecCheck == false*/ && !System.isFuture() && !System.isBatch()){
            //System.debug('Leadlst Trigger New:-'+Leadlst);//Commented as part of DPS-19692
            //oLeadTriggerHandler.verifyEmailAndPhone(Trigger.Old,Leadlst);
            //LeadTriggerHandler.verifyEmailAndPhoneRecCheck = true;
            oLeadTriggerHandler.addISDcodeWithPhoneOrMobile(Trigger.Old,Leadlst);
        }  

     } 
     
    //End : LCRM Project : StrikeIron verification
    /*if(Label.Theme == userinfo.getUiThemeDisplayed() &&  LCRMGenericComponent.isLotusUser()){
    try{
    LOTUSAddressValidation.validateLeadAddress(trigger.new[0]);// Added as part of DPS-13875
    }catch(Exception e){trigger.new[0].addError(e.getMessage());}
    }*/
    }
        
    //DPS-17696 - Update business Unit (LatAm) and Sales Org on Lead from User    
    If(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){       
        LeadTriggerHandler.updateLatAmBUSalesOrg(trigger.New);           
        //START-DPS-19692-Added Below code snippet as part of Trigger merging JIRA. 
        if(UserInfo.getName() == USERNAME_TRLEGALUS_ELOQUA || loggedInUser.contains(UserInfo.getName()) || checkRecursive.runOnce())
        {           
            oLeadTriggerHandler.IsHoliday(trigger.new,trigger.newmap,trigger.oldmap, trigger.IsInsert,trigger.IsUpdate);          
            oLeadTriggerHandler.setSLAFromSLAAdminTable(trigger.new,trigger.newmap,trigger.oldmap, trigger.IsInsert,trigger.IsUpdate);
            oLeadTriggerHandler.UpdateSalesRegionalMAnager(trigger.new,trigger.newmap,trigger.oldmap, trigger.IsInsert,trigger.IsUpdate);
            
            //Below logic is commented as part DPS-19692 JIRA's Request to stop Lead Owner Assignment process.
            /*if(trigger.IsInsert){ 
                if(!TEST.isRunningTest()){
                 EloquaUserList= ILMGeneral__c.getValues('AllowedUsersForSalesRepAssignment').value__c.split(';');
                     for(String str:EloquaUserList){
                         EloquaUserSet.add(str.trim().toUpperCase());
                     }  
                     
                 } 
                 else {
                     EloquaUserSet.add('SL ELOQUA');
                 }     
                     string strUsername= UserInfo.getFirstName() + ' '+ userInfo.getLastName();
                     system.debug('*****strUsername'+strUsername + 'set :'+EloquaUserSet);
                     if(EloquaUserSet!=null && EloquaUserSet.contains(strUsername.toUpperCase())){
                         oLeadRepAssignmentHandler.leadRepAssigmentProcess(trigger.new);
                     }
            }*/
            
            
        }
        //END-DPS-19692-Added Below code snippet
    }
    if(Trigger.IsBefore && Trigger.isdelete){
        LCRMRestrictRecordDeletion.restrictRecordDeletion(Trigger.old);
    }
    if(Trigger.IsBefore && Trigger.isInsert){
        LCRMRestrictRecordDeletion.assignLeadValues(Trigger.new);
    }
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) && 
      (LCRMGenericComponent.isLotusUser() || LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).End_State_Lightning__c == true)){
        //system.debug('Inside gsi sales org');//Commented as part of DPS-19692
        LeadTriggerHandler.updateGSISalesOrg(Trigger.New);
    }
    
}