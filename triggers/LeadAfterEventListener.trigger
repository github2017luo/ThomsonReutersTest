/*
======================================================================================================================
Trigger Name : LeadBeforeEventListener 
Test Classes for Trigger :AppUtil_Test,LCRMLeadTerritoryService_Test,LeadTriggerHandler_Test
CRM-18016 : Lead Conversion failure due to Strike Iron validation 
DPS-6078  : Add Code to stop the Strike Iron Code  
======================================================================================================================
*/
trigger LeadAfterEventListener on Lead (after update,after insert) {

//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){return;}


    if(Boolean.valueOf(System.Label.DisableTrigger_Lead) == False){ // Added as a part of CRM -14346 to bypass triggers while informatica performs data load
    List<Lead> listleadconvert = new List<Lead>();
    Map<Id,Lead> mapleadconvert = new Map<Id,Lead>();
    List<Lead> Newlistlead = new List<Lead>();
    List<Lead> listConvertdLead = new List<Lead>();//12-16-2016: Mrinmoy Sarkar Added for MCL-1570
    
    if(trigger.IsInsert || trigger.IsUpdate){
        //BIG RULE
        SET<id> accountIdSet= new SET<Id>();
        for(Lead l:Trigger.new){
            if(l.Account__c!=null){accountIdSet.add(l.Account__c); }   
        }
        System.debug('accountIdSet : '+accountIdSet);
        System.debug('inFutureContext : '+LeadTriggerHandler.inFutureContext);
        if(accountIdSet!= null && accountIdSet.size() >0 && LeadTriggerHandler.inFutureContext == false && !(System.isFuture() || System.isBatch())){
            string strProfileNAme = AppUtil.getProfileName(userInfo.getProfileId()); 
            //Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
            //if(ProfileName.Name=='LatAm User' || ProfileName.Name=='Partner Portal User'){
            if(strProfileNAme=='LatAm User' || strProfileNAme=='Partner Portal User'){
                Set<ID> newLeadIDs = Trigger.newMap.keySet();
                LeadTriggerHandler.updateLeadFromAccount(newLeadIDs, accountIdSet);
            }
        }
    }
 
 if(Trigger.IsUpdate ){
     //Release 1 Legal CRM Tejas Naik
     //Code written to populate custom contact lookup field on opportunity.
     LCRMGenericComponent.populateKeycontactonoppty(trigger.newMap,trigger.oldMap); //tejas code 
     for(Lead oLead : trigger.new){
         if(oLead.Is_Web_to_PPO__c!=trigger.oldmap.get(oLead.Id).Is_Web_to_PPO__c
                &&  oLead.Source__c == 'Practical Law' && oLead.Is_Web_to_PPO__c == true && oLead.Status!='Converted' ){
             listleadconvert.add(oLead);
             mapleadconvert.put(oLead.Id,oLead);
         }          
     }

 }
 
   if(!listleadconvert.IsEmpty()){
        LeadUtils.ConvertleadtoPPO(listleadconvert,mapleadconvert);
   
   }
   
    if(Trigger.IsInsert&&Trigger.IsAfter){
        if(!TEST.isRunningTest())
         {          
               for(lead nLead : trigger.new)
            {
               if(nLead.Lead_Scoring_Combined__c !=null && nLead.Business_Org__c != Null)
               {Newlistlead.add(nLead);}
            }
        }
        if(!Newlistlead.IsEmpty())
        {
             LeadCreateSendMail.NewLeadCreation(Newlistlead);
        }
    
    }
    //Lead Assignment Rules
        if(Trigger.isInsert && Trigger.isAfter /*&& !LCRMGenericComponent.StrikeIronCheckActive()*/ && LCRMGenericComponent.isLotusUser()){
 LTS_populateSegmentForPartnerUser.LeadAssign(Trigger.newmap.keyset());
        }
    //Start : LCRM Project : StrikeIron verification
    /*if(Trigger.IsAfter && Trigger.IsInsert){
        LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler();
        oLeadTriggerHandler.verifyEmailAndPhone(null,Trigger.New);
    }*/
    
    List<Lead> Leadlst= new List<Lead>();
    Set<String>SubBUstr = new Set<String>();
    if(Trigger.IsAfter && Trigger.IsInsert){
        System.debug('Trigger After and Insert');
        
        KeyValueListStore__c tempValueStore = KeyValueListStore__c.getValues('LCRMStrikeIronSubBULeads');
        system.debug('tempValueStore **'+tempValueStore );
        if(tempValueStore !=null && tempValueStore.TextValue__c!=null && tempValueStore.TextValue__c!=''){              
        System.debug('tempValueStore.TextValue__c*'+tempValueStore.TextValue__c);
        SubBUstr.add(tempValueStore.TextValue__c);
        }   
        //System.debug('Sub_BUmap**'+SubBUstr);    
        for(Lead LeadValue : Trigger.New ){    
        System.debug('LCRmSUB BU'+LeadValue.LCRM_Sub_BU__c);
        
        if(String.isnotblank(LeadValue.LCRM_Sub_BU__c)) {    
            If(!JSON.serialize(SubBUstr).contains(LeadValue.LCRM_Sub_BU__c)){
                System.debug('Not contains data');  
                Leadlst.add(LeadValue);  
            }
        }

       }
       System.debug('LeadAfterEvent Trigger'+Leadlst.size());
     if(!Leadlst.isempty()){
        LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler();
        // oLeadTriggerHandler.verifyEmailAndPhone(null,Leadlst);  //Commented out as a aprt of DPS-6078
        oLeadTriggerHandler.addISDcodeWithPhoneOrMobile(null,Leadlst);
     }
    }
    //End : LCRM Project : StrikeIron verification   
  //Lotus Future Address
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert && !LCRMGenericComponent.StrikeIronCheckActive() && (LCRMGenericComponent.isLotusUser() || LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).End_State_Lightning__c == true)){
            LotusAddressCallout.validateAddress(Trigger.New);
        }  
    }
    
    
     //Added for DPS-7851
        if(Trigger.isAfter && Trigger.isUpdate && (Userinfo.getUiThemeDisplayed() == Label.theme || LCRMConvertLeadMaptoLeadHistory.isInSalesforceLightning == true)  && !LCRMGenericComponent.StrikeIronCheckActive() && (LCRMGenericComponent.isLotusUser() || LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).End_State_Lightning__c == true))
        {
        system.debug('inside if condition');
        if(LCRMConvertLeadMaptoLeadHistory.isFirstTime){ LCRMConvertLeadMaptoLeadHistory.isFirstTime = false;
          for(Lead lead : Trigger.new) {
          if (lead.IsConverted) {
          system.debug('lead.IsConverted'+lead.IsConverted);
          try{LCRMConvertLeadMaptoLeadHistory lcl = new LCRMConvertLeadMaptoLeadHistory();
          lcl.createLeadHistory(trigger.new[0]);
                //add campaign details
                LotusOpptyExecutionAfterLeadConversion.addCampaignDetails(trigger.new[0]);
                }catch(Exception e){trigger.new[0].addError(e.getMessage());}
            }}}
        }
        //End for DPS-7851
    //DPS-20901
    if(Trigger.isAfter && Trigger.isUpdate &&
       UpdateLeadConvertDetails.updateConvertDetails == true &&
       !LCRMGenericComponent.StrikeIronCheckActive() && 
       (Userinfo.getUiThemeDisplayed() == Label.theme || UpdateLeadConvertDetails.isInSalesforceLightning == true) &&
       (LCRMGenericComponent.isLotusUser() || LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).End_State_Lightning__c == true)){
           
           UpdateLeadConvertDetails.updateDetails(Trigger.newmap);
       }
}