/**
 * Processes Account records before a DML event is processed by the system
 *
 * @author  John De Santiago - Thomson Reuters Code Share
 * @version 2011-03-24

 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2011-03-24   John De Santiago        Created
 * 2011-04-06   Mike Eaton              Commented out AccountUtil dependency for packaging
 * 2015-12-12   Ravi Havashetty         Validate the account on update with Reservation
 * 2017-01-04   Ravi Havashetty         Validate the Account on merge with other account(s)
 * 2017-03-31   Karthi                  Optimized the code as per JIRA STORY: PS0-1
 * 2018-05-03   Radhika Pawar           Data Loads by Informatica - Performance Issue (CRM-14872)
 * 2018-05-10   Harika Kalidindi        Added Booelan check to bypass trigger while informatica performs data load(CRM -14346)
 * 2018-07-20   Navleen Kaur            Commented out digitalFieldValueCaptialisation dependency
 * =============================================================================
 */
trigger AccountBeforeEventListener on Account (before delete, before insert, before update) {


  //LTS_5222 : Exclusion framework
   System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
   if(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
   {return;}
  
    if(Boolean.valueOf(System.Label.DisableTrigger_Account) == False){ // Added as a part of CRM -14346 to bypass triggers while informatica performs data load
   List<Account> lstAccSalesOrg = new list<Account>();
    //Process On: Insert Event
    if (trigger.isInsert) {
        //Load the "BU Marketing As Text" field.
        LCRM_BU_Marketing_Handler.UpdateLCRM_BU_Marketing_As_Text_insert(trigger.new);
        //Apply Default Values
        //AccountUtil.applyAccountDefaults(trigger.new);  //commented this as part of DPS-19687 , the method doing nothing 
        AccountUtil.applySalesOrgDefaults(trigger.new);
        system.debug('triggerNew...' +trigger.new);
        if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){     
        LCRMGenericComponent.populateSubbu(trigger.new);//tejas code to update subbu  // uncommented by Ravi
                //Dps-1709
               if( !LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser() )
                {
                    LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
                }
        }   
    }
    //Process On: Update Event
   if (trigger.isUpdate) {
     //Update the "BU Marketing As Text" field.
     LCRM_BU_Marketing_Handler.UpdateLCRM_BU_Marketing_As_Text_update(trigger.old, trigger.new);
     for(Account oAccount : trigger.new){
            if(oAccount.Sales_Org__c !=trigger.oldmap.get(oAccount.Id).Sales_Org__c){
                lstAccSalesOrg.add(oAccount);
            }
        }
        if(!lstAccSalesOrg.IsEmpty()){
            AccountUtil.applySalesOrgDefaults(lstAccSalesOrg);  
        }
            
            //Dps-1709
              /*  if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()) 
                {
                    LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new,trigger.oldmap);
                }*/
            
            
    } 
    
    //Process On: Insert or Update Events
    if (trigger.isInsert || trigger.isUpdate) {
        //start SFD-18
       /* Boolean flag = false;
        String profileName = '';
        try{
            profileName = AppUtil.getProfileName(userinfo.getProfileId());
            flag = AccountTaxNumSalOrgSetting__c.getValues(profileName).Active__c;
        }catch(Exception e){System.debug(e.getStackTraceString());}
        if(flag == true){
            AccountHandler.AccountTaxNumSalOrgDupCheck(Trigger.New,profileName);
        }//end SFD-18
        */
        
        //Update Address Tokens
        //AccountUtil.updateAddressTokens(trigger.new); //commented this as part of DPS-19687 and added teh method logic in teh below for loop
       
       //CMC-4
       string strProfileNAme = AppUtil.getProfileName(userInfo.getProfileId()); 
       //Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
       for(Account a : Trigger.new) {
       
            //added below two line as part DPS-19687 to optimize the code.(these two lines are from updateAddressTokens method in AccountUtil class)
            DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(a);
            a.Address_Token__c = AccountUtil.buildAddressToken(oAddress, a.Sales_Org__c);
              
        //if(ProfileName.Name=='LatAm User'){
        if(strProfileNAme=='LatAm User'){
            if(a.Industry_LatAm__c==null || a.Industry_LatAm__c==''|| a.Industry_LatAm__c=='--None--'){
                a.Industry='NOT APPLICABLE';
            }
            else{
                        a.Industry=a.Industry_LatAm__c;
            }
        }
            //if(ProfileName.Name =='LMS - User'){
           /* Commneted as there is no LMS User in Org.
           if(strProfileNAme =='LMS - User'){
           
               if(a.Industry_LMS__c == null || a.Industry_LMS__c=='' || a.Industry_LMS__c=='--None--')
               a.Industry='NOT APPLICABLE';
               else
                   a.Industry=a.Industry_LMS__c; 
           } */
                 
       if (a.RecordTypeId == AccountUtil.ProspectRecordTypeId) {
         boolean blnValid  = true;
        
        String tipo = a.Tax_Number_Type__c;
        String nro = a.Tax_Number__c;
        String BillCon = a.BillingCountry;
       // system.debug('BillingCountry : '+a.BillingCountry);
        /*if(tipo != null && nro != null) {
            
          if(tipo.equalsIgnoreCase('CPF'))
            blnValid  = Tax_Number_Validator.isValid_CPF(nro);
          else
            if(tipo.equalsIgnoreCase('CNPJ'))
              blnValid  = Tax_Number_Validator.isValid_CNPJ(nro);
           else
             if(tipo.equalsIgnoreCase('C.U.I.T.'))
               blnValid  = Tax_Number_Validator.isValid_CUIT(nro,BillCon);
           /*old comment
            * else
             if(BillCon=='AR' && tipo.equalsIgnoreCase('C.U.I.T.'))
               blnValid  = Tax_Number_Validator.isValid_CUITAR(nro);*/
          /* else
               if(BillCon=='AR' && (tipo.equalsIgnoreCase('C.U.I.L.')||tipo.equalsIgnoreCase('C.D.I')))
               blnValid  = Tax_Number_Validator.isValid_CUILCDI(nro);
           else
               if(BillCon=='AR' && (tipo.equalsIgnoreCase('D.N.I.')||tipo.equalsIgnoreCase('L.E.')||tipo.equalsIgnoreCase('L.C.')))
               blnValid  = Tax_Number_Validator.isValid_DNILELC(nro);
           else
             if(BillCon=='AR' && (tipo.equalsIgnoreCase('C.I.')||tipo.equalsIgnoreCase('PASAPORTE')))
               blnValid  = Tax_Number_Validator.isValid_CI(nro );
         system.debug(logginglevel.info, '>>> Is Valid? ' + blnValid );
           if(!blnValid )
            a.Tax_Number__c.addError('Tax Number '+tipo+' is not valid');
            }*/
         //Dynamic conditions
         if(tipo != null && nro != null) {
           
            if(
               (LaTam_Tax_Number_Type_Condition__mdt.getInstance('AccountBeforeEventListener').Condition_1__c).containsIgnoreCase(tipo)){
                blnValid  = Tax_Number_Validator.isValid_CPF(nro);
            }
            else if(
                    (LaTam_Tax_Number_Type_Condition__mdt.getInstance('AccountBeforeEventListener').Condition_2__c).containsIgnoreCase(tipo)){
                blnValid  = Tax_Number_Validator.isValid_CNPJ(nro);
            }
            else if(
                    (LaTam_Tax_Number_Type_Condition__mdt.getInstance('AccountBeforeEventListener').Condition_3__c).containsIgnoreCase(tipo)
                   ){
                blnValid  = Tax_Number_Validator.isValid_CUIT(nro,BillCon);
            }
            else if(BillCon=='AR' && (LaTam_Tax_Number_Type_Condition__mdt.getInstance('AccountBeforeEventListener').Condition_4__c).containsIgnoreCase(tipo)){
                blnValid  = Tax_Number_Validator.isValid_CUILCDI(nro);
            }
            else if(BillCon=='AR' && (LaTam_Tax_Number_Type_Condition__mdt.getInstance('AccountBeforeEventListener').Condition_5__c).containsIgnoreCase(tipo)){
                blnValid  = Tax_Number_Validator.isValid_DNILELC(nro);
            }
            else if(BillCon=='AR' && ((LaTam_Tax_Number_Type_Condition__mdt.getInstance('AccountBeforeEventListener').Condition_6__c).containsIgnoreCase(tipo))){
                blnValid  = Tax_Number_Validator.isValid_CI(nro );
            }
            if(!blnValid ){
                 a.Tax_Number__c.addError('Tax Number '+tipo+' is not valid');
            }
            }  
           
        }
      }
        //Start Added as a part of DPS - 6407
        //Informatica users check added by Ankit
        if(!LCRMGenericComponent.StrikeIronCheckActive() && (LCRMGenericComponent.isLotusUser()||LCRMGenericComponent.validateUserBU(LCRMGenericComponent.getUserBU()))) //GGO check added by Kavya
        AccountHandler.vatNoValidation(trigger.new);
        //End DPS - 6407
  
    }
 /* checkLatamCommercialAccount method call - CMC-1
     if (trigger.isInsert || trigger.isUpdate) {
          AccountHandler.checkLatamCommercialAccount(trigger.oldMap, trigger.new, trigger.isInsert); 
     }  */             
     /*
     //Commeting this method as part of DPS-17684
     //Ravi - validate the account update with reservation approved and active.    
     if(trigger.isUpdate){
         AccountHandler.validateAccountApprovedReservation(trigger.new, Trigger.oldMap);
     }
     */ 
     /*if(Trigger.isDelete){ // Commented out w.r.t. CRM-12227 by Shovon
         AccountHandler.validateAccountOnMerge(Trigger.Old);
     }*/
     /*if(trigger.isInsert || Trigger.isUpdate){
    digitalFieldValueCaptialisation.accountFirmName(Trigger.New);
   } */ 
       //commented as part of DPS-6078 
      //Start : LCRM Project : StrikeIron verification
        
       /* KeyValueListStore__c LCRMStrikeIronFlagINS = KeyValueListStore__c.getValues('LCRMDisableStrikeIronServices');
        Boolean LCRMStrikeIronFlag = LCRMStrikeIronFlagINS != null ? Boolean.valueof(LCRMStrikeIronFlagINS.TextValue__c) : False;
        System.debug('LCRMStrikeIronFlag****'+LCRMStrikeIronFlag);
        
        if(!LCRMStrikeIronFlag){*/
            AccountHandler handlerObj = new AccountHandler();
            if(Trigger.IsBefore && Trigger.IsInsert){
               // handlerObj.verifyEmailAndPhone(null,Trigger.New);
               handlerObj.addISDCodeToPhone(null,Trigger.New);
            //}else if(Trigger.IsBefore && Trigger.IsUpdate && AccountHandler.verifyStrikeIronRecCheck == false && !System.isFuture() && !System.isBatch()){ //Commenting as part of DPS-6078
            }else if(Trigger.IsBefore && Trigger.IsUpdate /*&& AccountHandler.verifyStrikeIronRecCheck == false */&& !System.isFuture() && !System.isBatch()){
                handlerObj.addISDCodeToPhone(Trigger.Old,Trigger.New);
                //handlerObj.verifyEmailAndPhone(Trigger.Old,Trigger.New);
                //AccountHandler.verifyStrikeIronRecCheck = true;
            }
        //}
        
        //End : LCRM Project : StrikeIron verification
    }//End lcrmSkipTrigger && !LCRMGenericComponent.StrikeIronCheckActive()
    if(Label.Theme == userinfo.getUiThemeDisplayed()  &&  !LCRMGenericComponent.StrikeIronCheckActive() &&
        (LCRMGenericComponent.isLotusUser()  ||  LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).End_State_Lightning__c == true)){  //Added as per DPS-19182
    try{
    LOTUSAddressValidation.validateAddress(trigger.new[0]);// Added as part of DPS-12633
    }catch(Exception e){trigger.new[0].addError(e.getMessage());}
    }
    if(Trigger.IsBefore && Trigger.isdelete){
        LCRMRestrictRecordDeletion.restrictRecordDeletion(Trigger.old);
       ESC_AccountSupportHandler.updateEscSupportObjectMergeField(trigger.oldmap.keySet());
        }
    
}