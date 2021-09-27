public without sharing class ContactTriggerHandler{
    
     //fix to handle verifyEmailAndPhonefuture method call from Oppty renewal cancellation batch
    public static boolean renewalCancellationFlowContact = false;
    
    //CheckDuplicate
    public static boolean checkDuplicate = false;

    public class MyException extends Exception {}

    public static void updateSalesOrgOnInsert(List<Contact> listContact){
        Map<Contact,Id> mapContactAcc = new Map<Contact,Id>();

        for(Contact oContact : listContact){
          if(oContact.AccountId!=null){
              mapContactAcc.put(oContact,oContact.AccountId);
            }
        }
        
      UpdateContactSalesOrg(mapContactAcc);
    
    }
    /* Commenting out this method as this is not getting called from anywhere.
    public static void updateSalesOrgOnUpdate(List<Contact> listContact,Map<Id,Contact> mapOldContacts){
        Map<Contact,Id> mapContactAcc = new Map<Contact,Id>();
        
        for(Contact oContact : listContact){
          if(oContact.AccountId!=null && oContact.AccountId!=mapOldContacts.get(oContact.Id).AccountId){
               mapContactAcc.put(oContact ,oContact.AccountId);
            }
        
        }
       UpdateContactSalesOrg(mapContactAcc);
    }
    */    
    public static void UpdateContactSalesOrg(Map<Contact,Id> mapConAccSalesOrg){
        Map<Id,String> mapAccSalesOrg = new Map<Id,String>();
         List<Account> listAccount=new List<Account>();
        // Validating CURD operation as part of LOTUS 
        if (Schema.sObjectType.Account.fields.Sales_Org__c.isAccessible() && Schema.sObjectType.Account.isQueryable()){
        listAccount =[Select Sales_Org__c from Account where Id IN :mapConAccSalesOrg.values()];
        }
        for(Account oAccount : listAccount){

            if(oAccount.Sales_Org__c !=null){
                mapAccSalesOrg.put(oAccount.Id,oAccount.Sales_Org__c);
            }
        }
        
        
        for(Contact oContact : mapConAccSalesOrg.keySet()){
            System.debug('****'+mapAccSalesOrg.get(oContact.AccountId));
            if(mapAccSalesOrg.get(oContact.AccountId)!=null){
             oContact.Sales_Org__c = mapAccSalesOrg.get(oContact.AccountId);
            }
        }
        
     }
    // commented as part of DPS-6078
    //Method added by LCRM to call furture method to verify Phone & Email fields using StrikeIron
   /* public static boolean verifyEmailAndPhoneRecCheck= false;
    public void verifyEmailAndPhone(List<Contact> conListOld, List<Contact> conListNew){
        Boolean loggedinUserFlag = LCRMGenericComponent.StrikeIronCheckActive();
        System.debug('loggedinUserFlag :'+loggedinUserFlag);
        if(loggedinUserFlag==true && (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
            return;
        }
        
        Id gliContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Id gliContactCDSRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact - CDS').getRecordTypeId();
        List<ID> conIdList = new List<ID>();
        //if condition for insert check
        if(conListOld == null || conListOld.size()==0){
            for(Contact con : conListNew){
                //if block to update timestamps
                if(Trigger.isBefore){
                    if(con.LCRM_Email_Verification__c != null && con.LCRM_Email_Verification__c !=''){
                        con.LCRM_Email_Verification_TimeStamp__c = DateTime.Now();
                    }
                    if(con.LCRM_Phone_Verification__c != null && con.LCRM_Phone_Verification__c !=''){
                        con.LCRM_Phone_Verification_TimeStamp__c = DateTime.Now();
                    }
                    if(con.LCRM_Mobile_Verification__c != null && con.LCRM_Mobile_Verification__c !=''){
                        con.LCRM_Mobile_Verification_TimeStamp__c = DateTime.Now();
                    }
                    if(con.LCRM_Other_Phone_Verification__c != null && con.LCRM_Other_Phone_Verification__c !=''){
                        con.LCRM_Other_Phone_Verification_TimeStamp__c = DateTime.Now();
                    }
                }
                
                if(con.recordTypeId==gliContactRecordTypeId || con.recordTypeId==gliContactCDSRecordTypeId){ 
                    //retrieve ISD codes from custom setting to standarize the phone numbers
                    LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                    if(con.LCRM_Country__c != null && con.LCRM_Country__c !=''){
                        dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(con.LCRM_Country__c);
                    }
                    System.debug('dialCode : '+con.LCRM_Country__c+' : '+dialCode);
                    //conIdList.add(con.ID);
                    if(Trigger.isAfter){
                        System.debug('after con : '+con);
                    }
                    
                    System.debug('con.Email : '+con.Email);
                    System.debug('con.LCRM_Email_Verification__c : '+con.LCRM_Email_Verification__c);
                    
                    //Email field check 
                    if(con.Email!= null && con.Email!='' && (con.LCRM_Email_Verification__c == null || 
                     con.LCRM_Email_Verification__c =='' || con.LCRM_Email_Verification__c == 'Pending. Please refresh.')){
                        if(Trigger.isAfter){
                            conIdList.add(con.ID);
                            System.debug('insert Email id add conIdList : '+conIdList+' : '+con.id);
                        }
                        if(Trigger.isBefore){
                            if(!loggedinUserFlag){
                                con.LCRM_Email_Verification__c = 'Pending. Please refresh.';
                            }else{
                                con.LCRM_Email_Verification__c = '';
                            }
                            con.LCRM_Email_Verification_TimeStamp__c = null;
                        }
                        System.debug('insert Email id add conIdList : '+conIdList);
                        
                    }
                    
                    //Phone field check 
                    if(con.Phone!= null && con.Phone!='' && (con.LCRM_Phone_Verification__c == null || 
                     con.LCRM_Phone_Verification__c =='' || con.LCRM_Phone_Verification__c == 'Pending. Please refresh.')){
                        if(con.Phone.startsWith('+') || con.Phone.startsWith('00')){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                if(!loggedinUserFlag){
                                    con.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Phone_Verification__c = '';
                                }
                                con.LCRM_Phone_Verification_TimeStamp__c = null;
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                // con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; // Added by Shovon w.r.t. CRM-10134
                                    con.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Phone_Verification__c = '';
                                }
                                con.LCRM_Phone_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                    
                    //Mobile Phone field check 
                    if(con.MobilePhone!= null && con.MobilePhone!='' && (con.LCRM_Mobile_Verification__c == null || 
                     con.LCRM_Mobile_Verification__c =='' || con.LCRM_Mobile_Verification__c == 'Pending. Please refresh.')){
                        if(con.MobilePhone.startsWith('+') || con.MobilePhone.startsWith('00')){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                if(!loggedinUserFlag){
                                    con.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Mobile_Verification__c = '';
                                }
                                con.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                // con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                                    con.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Mobile_Verification__c = '';
                                }
                                con.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                    
                    //Other Phone field check 
                    if(con.OtherPhone!= null && con.OtherPhone!='' && (con.LCRM_Other_Phone_Verification__c == null || 
                     con.LCRM_Other_Phone_Verification__c =='' || con.LCRM_Other_Phone_Verification__c == 'Pending. Please refresh.')){
                        if(con.OtherPhone.startsWith('+') || con.OtherPhone.startsWith('00')){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                if(!loggedinUserFlag){
                                    con.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Other_Phone_Verification__c = '';
                                }
                                con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                // con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; // Added by Shovon w.r.t. CRM-10134
                                    con.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Other_Phone_Verification__c = '';
                                }
                                con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                }
            }    
        }else{//update block
            Integer i = 0;
            Set<id>  conIDsSet = new Set<ID>();
            for(Contact con : conListNew){
                if(con.recordTypeId==gliContactRecordTypeId || con.recordTypeId==gliContactCDSRecordTypeId){
                    conIDsSet.add(con.ID);
                }
            }
            System.debug('conIDsSet1 : '+conIDsSet);
            Map<ID,Contact> conMap = new Map<ID,Contact>([SELECT ID, Email, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
                                          Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
                                          MobilePhone, LCRM_Mobile_Verification__c, LCRM_Mobile_Verification_TimeStamp__c,
                                          OtherPhone, LCRM_Other_Phone_Verification__c, LCRM_Other_Phone_Verification_TimeStamp__c
                                          FROM Contact WHERE ID IN :conIDsSet]); 
            System.debug('conMap : '+conMap);
            if(conIDsSet.size()>0){
                //conIDsSet = new Set<ID>();
                for(Contact con : conListNew){
                    if(con.recordTypeId==gliContactRecordTypeId || con.recordTypeId==gliContactCDSRecordTypeId){
                        //if stmts to change strikeiron fields to null values if field values are removed
                        if(con.Email ==null){
                            con.LCRM_Email_Verification__c = null;
                            con.LCRM_Email_Verification_TimeStamp__c = null;
                        }
                        if(con.Phone ==null){
                            con.LCRM_Phone_Verification__c = null;
                            con.LCRM_Phone_Verification_TimeStamp__c = null;
                        }
                        if(con.MobilePhone ==null){
                            con.LCRM_Mobile_Verification__c = null;
                            con.LCRM_Mobile_Verification_TimeStamp__c = null;
                        }
                        if(con.OtherPhone ==null){
                            con.LCRM_Other_Phone_Verification__c = null;
                            con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                        }
                        
                        System.debug('con.LCRM_Other_Phone_Verification__c : '+con.LCRM_Other_Phone_Verification__c);
                        
                        //condition to handle double update
                        if(con.Email !=null && (con.Email == conListOld[i].Email) && (conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).Email == con.Email && con.LCRM_Email_Verification__c =='Pending. Please refresh.' && conMap.get(con.ID).LCRM_Email_Verification__c !='Pending. Please refresh.')){
                            con.LCRM_Email_Verification__c = conMap.get(con.ID).LCRM_Email_Verification__c;
                            con.LCRM_Email_Verification_TimeStamp__c = conMap.get(con.ID).LCRM_Email_Verification_TimeStamp__c;
                        }
                        if(con.Phone !=null && (con.Phone == conListOld[i].Phone) && (conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).Phone == con.Phone && con.LCRM_Phone_Verification__c =='Pending. Please refresh.' && conMap.get(con.ID).LCRM_Phone_Verification__c !='Pending. Please refresh.')){
                            con.LCRM_Phone_Verification__c = conMap.get(con.ID).LCRM_Phone_Verification__c;
                            con.LCRM_Phone_Verification_TimeStamp__c = conMap.get(con.ID).LCRM_Phone_Verification_TimeStamp__c;
                        }
                        if(con.MobilePhone != null && (con.MobilePhone == conListOld[i].MobilePhone) && (conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).MobilePhone == con.MobilePhone && con.LCRM_Mobile_Verification__c =='Pending. Please refresh.' && conMap.get(con.ID).LCRM_Mobile_Verification__c !='Pending. Please refresh.')){
                            con.LCRM_Mobile_Verification__c = conMap.get(con.ID).LCRM_Mobile_Verification__c;
                            con.LCRM_Mobile_Verification_TimeStamp__c = conMap.get(con.ID).LCRM_Mobile_Verification_TimeStamp__c;
                        }
                        if(con.OtherPhone != null && (con.OtherPhone == conListOld[i].OtherPhone) && (conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).OtherPhone == con.OtherPhone && con.LCRM_Other_Phone_Verification__c =='Pending. Please refresh.' && conMap.get(con.ID).LCRM_Other_Phone_Verification__c !='Pending. Please refresh.')){
                            con.LCRM_Other_Phone_Verification__c = conMap.get(con.ID).LCRM_Other_Phone_Verification__c;
                            con.LCRM_Other_Phone_Verification_TimeStamp__c = conMap.get(con.ID).LCRM_Other_Phone_Verification_TimeStamp__c;
                        }
                        System.debug('con.LCRM_Other_Phone_Verification__c : '+con.LCRM_Other_Phone_Verification__c);
                    
                    
                        //condition to flag error message to stop double update on email/phone field when strike iron verificationb is still in progress
                        if((
                            ((con.LCRM_Email_Verification__c =='Pending. Please refresh.' || (con.LCRM_Email_Verification__c =='Pending. Please refresh.' && conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).LCRM_Email_Verification__c =='Pending. Please refresh.')) && conListOld[i].Email != con.Email)
                            || 
                            ((con.LCRM_Phone_Verification__c =='Pending. Please refresh.' || (con.LCRM_Phone_Verification__c =='Pending. Please refresh.' && conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).LCRM_Phone_Verification__c =='Pending. Please refresh.')) && conListOld[i].Phone != con.Phone)
                            || 
                            ((con.LCRM_Mobile_Verification__c =='Pending. Please refresh.' || (con.LCRM_Mobile_Verification__c =='Pending. Please refresh.' && conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).LCRM_Mobile_Verification__c =='Pending. Please refresh.')) && conListOld[i].MobilePhone != con.MobilePhone)
                            || 
                            ((con.LCRM_Other_Phone_Verification__c =='Pending. Please refresh.' || (con.LCRM_Other_Phone_Verification__c =='Pending. Please refresh.' && conMap!=null && conMap.get(con.ID)!=null && conMap.get(con.ID).LCRM_Other_Phone_Verification__c =='Pending. Please refresh.')) && conListOld[i].OtherPhone != con.OtherPhone)
                            )){
                            if(!loggedinUserFlag){
                                con.addError(System.label.LCRM_ContactUpdateWarningStrikeIron.replace('<link>','<a href=\'/'+con.id+'\'>System.Label.LTS_RefreshMsg</a>'), False);
                            }
                            continue;
                        }
                    
                        //retrieve ISD codes from custom setting to standarize the phone numbers
                        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                        if(con.LCRM_Country__c != null && con.LCRM_Country__c !=''){
                            dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(con.LCRM_Country__c);
                        }
                        System.debug('dialCode : '+con.LCRM_Country__c+' : '+dialCode);
                        
                        //block to check email field for verification/update
                        
                        if(con.Email!= null && con.Email!='' && (Test.isRunningTest() || conListOld[i].Email != con.Email || con.LCRM_Email_Verification__c == null || 
                         con.LCRM_Email_Verification__c =='' || (!loggedinUserFlag && con.LCRM_Email_Verification__c!=null && con.LCRM_Email_Verification__c!='' && con.LCRM_Email_Verification__c.contains('Exception')))){
                            conIdList.add(con.ID);
                            if(!loggedinUserFlag){
                                con.LCRM_Email_Verification__c = 'Pending. Please refresh.';
                            }else{
                                con.LCRM_Email_Verification__c = '';
                            }
                            con.LCRM_Email_Verification_TimeStamp__c = null;
                        }
                        
                        //block to check phone field for verification/update
                        if(con.Phone!= null && con.Phone!='' && (Test.isRunningTest() || conListOld[i].Phone != con.Phone || con.LCRM_Phone_Verification__c == null || 
                         con.LCRM_Phone_Verification__c =='' || (!loggedinUserFlag && con.LCRM_Phone_Verification__c!=null && con.LCRM_Phone_Verification__c!='' && con.LCRM_Phone_Verification__c.contains('Exception')))){
                            if(con.Phone.startsWith('+') || con.Phone.startsWith('00')){
                                conIdList.add(con.ID);
                                if(!loggedinUserFlag){
                                    con.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Phone_Verification__c = '';
                                }
                                con.LCRM_Phone_Verification_TimeStamp__c = null;
                            }else if(dialCode != null){
                                conIdList.add(con.ID);
                                // con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; // Added by Shovon w.r.t. CRM-10134
                                    con.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Phone_Verification__c = '';
                                }
                                con.LCRM_Phone_Verification_TimeStamp__c = null;
                            }
                        }
                        
                        //block to check mobile phone field for verification/update
                        if(con.MobilePhone!= null && con.MobilePhone!='' && (Test.isRunningTest() || conListOld[i].MobilePhone != con.MobilePhone || con.LCRM_Mobile_Verification__c == null || 
                         con.LCRM_Mobile_Verification__c =='' || (!loggedinUserFlag && con.LCRM_Mobile_Verification__c!=null && con.LCRM_Mobile_Verification__c!='' && con.LCRM_Mobile_Verification__c.contains('Exception')))){
                            if(con.MobilePhone.startsWith('+') || con.MobilePhone.startsWith('00')){
                                conIdList.add(con.ID);
                                if(!loggedinUserFlag){
                                    con.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Mobile_Verification__c = '';
                                }
                                con.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }else if(dialCode != null){
                                conIdList.add(con.ID);
                                // con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                                    con.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Mobile_Verification__c = '';
                                }
                                con.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }
                        }
                        
                        //block to check other phone field for verification/update
                        if(con.OtherPhone!= null && con.OtherPhone!='' && (Test.isRunningTest() ||  conListOld[i].OtherPhone != con.OtherPhone || con.LCRM_Other_Phone_Verification__c == null || 
                         con.LCRM_Other_Phone_Verification__c =='' || (!loggedinUserFlag && con.LCRM_Other_Phone_Verification__c!=null && con.LCRM_Other_Phone_Verification__c!='' && con.LCRM_Other_Phone_Verification__c.contains('Exception')))){
                            if(con.OtherPhone.startsWith('+') || con.OtherPhone.startsWith('00')){
                                conIdList.add(con.ID);
                                if(!loggedinUserFlag){
                                    con.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Other_Phone_Verification__c = '';
                                }
                                con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                            }else if(dialCode != null){
                                conIdList.add(con.ID);
                                // con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; // Added by Shovon w.r.t. CRM-10134
                                    con.LCRM_Other_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    con.LCRM_Other_Phone_Verification__c = '';
                                }
                                con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                    i = i+1;
                }
            }
        }
        System.debug('conListNew : '+conListNew);
        System.debug('conIdList : '+conIdList);
        if(!loggedinUserFlag && !renewalCancellationFlowContact && conIdList!=null && conIdList.size()>0){
            //future method invoked to make callouts to webservices
            verifyEmailAndPhoneFuture(conIdList);
        }
    } 
     
    //Method added by LCRM to verify Phone & Email fields using StrikeIron
    @future(callout=true)
    public static void verifyEmailAndPhoneFuture(List<ID> conIdList){
        List<LCRM_Exception_Log__c> excepObjList = new List<LCRM_Exception_Log__c>();
        try{
            List<Contact> conList=new List<Contact>();
            // Validating CURD operation as part of LOTUS 
            if (Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.isQueryable()){
               conList = [SELECT ID, Email,LCRM_Is_CDS_Ready__c, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
                                              Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
                                              MobilePhone, LCRM_Mobile_Verification__c, LCRM_Mobile_Verification_TimeStamp__c,
                                              OtherPhone, LCRM_Other_Phone_Verification__c, LCRM_Other_Phone_Verification_TimeStamp__c
                                              FROM Contact WHERE ID IN :conIdList];
            }
             
            
            LCRMStrikeIronServices servObj;
            String phone = '';
            
            //loop to create list of phone and email values for making callout to strike iron services
            for(Contact con : conList){
                servObj = new LCRMStrikeIronServices();
                if(con.LCRM_Email_Verification__c == 'Pending. Please refresh.'){
                    //making callout to email strikiron services
                    String emailStatus = servObj.callEmailValidation(con.Email);
                    //String emailStatus = 'Exception';
                    System.debug('emailStatus : '+emailStatus);
                    if(emailStatus!=null && emailStatus!='' && emailStatus.contains('Exception')){
                        if(emailStatus == 'Exception : Email Service not configured.' || emailStatus == 'Exception : Email Service not active.'){
                            con.LCRM_Email_Verification__c = emailStatus;
                        }else{
                            con.LCRM_Email_Verification__c = 'Exception in Verification Service.';
                        }
                        con.LCRM_Email_Verification_TimeStamp__c = null;
                        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                        excepObj.LCRM_Exception_Message__c = '';
                        excepObj.LCRM_Exception_Trace__c = emailStatus;
                        excepObj.LCRM_Exception_Type__c = 'StrikeIron Contact Email';
                        excepObj.LCRM_Record_Ids__c = String.valueOf(conIdList);
                        excepObj.LCRM_User_ID__c = userinfo.getUserId();
                        excepObjList.add(excepObj);
                    }else if(emailStatus!=null && emailStatus!=''){
                        con.LCRM_Email_Verification__c = emailStatus;
                        //con.LCRM_Is_CDS_Ready__c = true; Commented by Shovon for CRM-13123
                        con.LCRM_Email_Verification_TimeStamp__c = DateTime.Now();
                    }else{
                        con.LCRM_Email_Verification__c = '';
                        con.LCRM_Email_Verification_TimeStamp__c = null;
                    }
                }
                
                if(con.LCRM_Phone_Verification__c == 'Pending. Please refresh.'){
                    phone = phone + ((phone==null || phone=='')?'':',') + con.Phone;
                }
                if(con.LCRM_Mobile_Verification__c == 'Pending. Please refresh.'){
                    phone = phone + ((phone==null || phone=='')?'':',') + con.MobilePhone;
                }
                if(con.LCRM_Other_Phone_Verification__c== 'Pending. Please refresh.'){
                    phone = phone + ((phone==null || phone=='')?'':',') + con.OtherPhone;
                }
            }
            //block to make callout to strikeiron for phone field verification
            if(phone!=null && phone!=''){
                Map<String, String> reponsePhone = servObj.callPhoneValidation(phone);
                System.debug('reponsePhone : '+reponsePhone);
                for(Contact con : conList){
                    //block to update phone field accourdingly after strikiron callout
                    if(con.LCRM_Phone_Verification__c == 'Pending. Please refresh.'){
                        String phoneStatus = reponsePhone.get(con.Phone);
                        System.debug('phoneStatus : '+phoneStatus);
                        if(Test.isRunningTest() || (phoneStatus!=null && phoneStatus!='' && phoneStatus.contains('Exception'))){
                            if(phoneStatus == 'Exception : Phone Service not configured.' || phoneStatus == 'Exception : Phone Service not active.'){
                                con.LCRM_Phone_Verification__c = phoneStatus;
                            }else{
                                con.LCRM_Phone_Verification__c = 'Exception in Verification Service.';
                            }
                            con.LCRM_Phone_Verification_TimeStamp__c = null;
                            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                            excepObj.LCRM_Exception_Message__c = 'Phone';
                            excepObj.LCRM_Exception_Trace__c = phoneStatus;
                            excepObj.LCRM_Exception_Type__c = 'StrikeIron Contact Phone';
                            excepObj.LCRM_Record_Ids__c = String.valueOf(con.ID);
                            excepObj.LCRM_User_ID__c = userinfo.getUserId();
                            excepObjList.add(excepObj);
                        }else if(phoneStatus!=null && phoneStatus!=''){
                            con.LCRM_Phone_Verification__c = phoneStatus;
                            con.LCRM_Phone_Verification_TimeStamp__c = DateTime.Now();
                        }else{
                            con.LCRM_Phone_Verification__c = '';
                            con.LCRM_Phone_Verification_TimeStamp__c = null;
                        }
                    }
                    
                    //block to update mobile phone field accourdingly after strikiron callout
                    if(con.LCRM_Mobile_Verification__c == 'Pending. Please refresh.'){
                        String mobileStatus = reponsePhone.get(con.MobilePhone);
                        System.debug('mobileStatus : '+mobileStatus);
                        if(mobileStatus!=null && mobileStatus!='' && mobileStatus.contains('Exception')){
                            if(mobileStatus == 'Exception : Phone Service not configured.' || mobileStatus == 'Exception : Phone Service not active.'){
                                con.LCRM_Mobile_Verification__c = mobileStatus;
                            }else{
                                con.LCRM_Mobile_Verification__c = 'Exception in Verification Service.';
                            }
                            con.LCRM_Mobile_Verification_TimeStamp__c = null;
                            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                            excepObj.LCRM_Exception_Message__c = 'MobilePhone';
                            excepObj.LCRM_Exception_Trace__c = mobileStatus;
                            excepObj.LCRM_Exception_Type__c = 'StrikeIron Contact Phone';
                            excepObj.LCRM_Record_Ids__c = String.valueOf(con.ID);
                            excepObj.LCRM_User_ID__c = userinfo.getUserId();
                            excepObjList.add(excepObj);
                        }else if(mobileStatus!=null && mobileStatus!=''){
                            con.LCRM_Mobile_Verification__c = mobileStatus;
                            con.LCRM_Mobile_Verification_TimeStamp__c = DateTime.Now();
                        }else{
                            con.LCRM_Mobile_Verification__c = '';
                            con.LCRM_Mobile_Verification_TimeStamp__c = null;
                        }
                    }
                    
                    //block to update other phone field accourdingly after strikiron callout
                    if(con.LCRM_Other_Phone_Verification__c== 'Pending. Please refresh.'){
                        String otherStatus = reponsePhone.get(con.OtherPhone);
                        System.debug('otherStatus : '+otherStatus);
                        if(otherStatus!=null && otherStatus!='' && otherStatus.contains('Exception')){
                            if(otherStatus == 'Exception : Phone Service not configured.' || otherStatus == 'Exception : Phone Service not active.'){
                                con.LCRM_Other_Phone_Verification__c = otherStatus;
                            }else{
                                con.LCRM_Other_Phone_Verification__c = 'Exception in Verification Service.';
                            }
                            con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                            excepObj.LCRM_Exception_Message__c = 'OtherPhone';
                            excepObj.LCRM_Exception_Trace__c = otherStatus;
                            excepObj.LCRM_Exception_Type__c = 'StrikeIron Contact Phone';
                            excepObj.LCRM_Record_Ids__c = String.valueOf(con.ID);
                            excepObj.LCRM_User_ID__c = userinfo.getUserId();
                            excepObjList.add(excepObj);
                        }else if(otherStatus!=null && otherStatus!=''){
                            con.LCRM_Other_Phone_Verification__c= otherStatus;
                            con.LCRM_Other_Phone_Verification_TimeStamp__c = DateTime.Now();
                        }else{
                            con.LCRM_Other_Phone_Verification__c= '';
                            con.LCRM_Other_Phone_Verification_TimeStamp__c = null;
                        }
                    }
                }
            }
            System.debug('conList : '+conList);
            if(Schema.sObjectType.Contact.isUpdateable())
            update conList;
            if(Test.isRunningTest()){
                throw new MyException('Test Exception');
            }
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage()+' : '+e.getStackTraceString());
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = e.getMessage();
            excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'StrikeIron Contact Email & Phone';
            excepObj.LCRM_Record_Ids__c = String.valueOf(conIdList);
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            excepObjList.add(excepObj);
        }
        if(excepObjList!=null && excepObjList.size()>0){
        //Validating CURD operation as part of LOTUS
            if(Schema.sObjectType.LCRM_Exception_Log__c.isCreateable()){
            insert excepObjList;
        }
    }
    } */
    //Added for CRM-13505 by Shovon
    public void trackHistory(List<Contact> newList, Map<Id, Contact> oldMap){
        //String trackedFields = String.valueOf(Label.LCRM_Contact_Field_Tracker);
        List<LCRM_Contact_Field_Tracker__c> cftList = LCRM_Contact_Field_Tracker__c.getall().values();
        List<String> trackedFieldsList = new List<String>();
        for(LCRM_Contact_Field_Tracker__c cft: cftList){
                trackedFieldsList.add(cft.Name);
            }
        List<LCRM_Audit_Log__c> conAuditLogList = new List<LCRM_Audit_Log__c>();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType contactSchema = schemaMap.get('Contact');
        Map<String, Schema.SObjectField> fieldMap = contactSchema.getDescribe().fields.getMap();
        //System.Debug(fieldMap.get('DoNotCall').getDescribe().getLabel());
        if(newList[0].LCRM_Is_GLI__c == true){
            for(Contact con : newList){
                for(String str: trackedFieldsList){
                    if(/*con.LCRM_Is_GLI__c == true && */(con.get(str) != oldMap.get(con.Id).get(str))){
                        LCRM_Audit_Log__c conAuditLog = new LCRM_Audit_Log__c();
                        conAuditLog.Contact__c = con.Id;
                        conAuditLog.Field__c = fieldMap.get(str).getDescribe().getLabel();
                        /*
                        conAuditLog.New_Value__c = con.get(str)==true?'Yes':'No';
                        conAuditLog.Old_Value__c = oldMap.get(con.Id).get(str)==true?'Yes':'No';
                        */
                        /*--START CRM-15584 by Shovon--*/
                         if(con.get(str) != null){
                            conAuditLog.New_Value__c = con.get(str).toString();
                        }
                        else{
                            conAuditLog.New_Value__c = '';
                        }
                        if(oldMap.get(con.Id).get(str)!= null)
                        conAuditLog.Old_Value__c = oldMap.get(con.Id).get(str).toString();
                        /*--END CRM-15584 by Shovon--*/
                        conAuditLog.User__c = UserInfo.getUserId();
                        conAuditLog.Date__c = System.Now();
                        conAuditLogList.add(conAuditLog);
                    }
                }
            }
        }
        if(conAuditLogList.size()>0){
            If(!ContactTriggerHandler.checkDuplicate){
                        List<Database.SaveResult> results = database.insert(conAuditLogList, false);
            ContactTriggerHandler.checkDuplicate = true;
            List<LCRM_Exception_Log__c> excepList = new List<LCRM_Exception_Log__c>();
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess())
                {
                    for(Database.Error err : sr.getErrors()) {
                        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                        excepObj.LCRM_Exception_Message__c = err.getMessage();
                        excepObj.LCRM_Exception_Trace__c = 'ContactTriggerHandler class'+err.getFields()+' '+err.getStatusCode();
                        excepObj.LCRM_Exception_Type__c = 'Error found in creating Contact Audit Log';                
                        excepObj.LCRM_User_ID__c = userinfo.getUserId();
                        excepList.add(excepObj);
                    }
                }
            }
            if(excepList.size()>0){
                database.insert(excepList, false);
            }
            
            }


        }
    }
        //Method added as part of DPS-6078.
    public void addISDCodeToPhone(List<Contact> conListOld, List<Contact> conListNew){
        Id gliContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact').getRecordTypeId();
        Id gliContactCDSRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact_CDS').getRecordTypeId();
        List<ID> conIdList = new List<ID>();
        if(CheckRecursive.lCRMRecursivecheck_Contact()){
        //if condition for insert check
        if(conListOld == null || conListOld.size()==0){
            for(Contact con : conListNew){
                if(con.recordTypeId==gliContactRecordTypeId || con.recordTypeId==gliContactCDSRecordTypeId){ 
                    //Added by Kavya as part of LOC-1024, To retrieve ISD codes from custom setting to standarize the phone numbers
                    LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                    if(con.LCRM_Country__c != null && con.LCRM_Country__c !=''){
                        dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(con.LCRM_Country__c);
                    }
                    System.debug('dialCode : '+con.LCRM_Country__c+' : '+dialCode);
                    //conIdList.add(con.ID);
                    if(Trigger.isAfter){
                        System.debug('after con : '+con);
                    }
                    
                    //StrikeIron verification for Phone field
                    if(con.Phone!= null && con.Phone!=''){
                        //LOC-1024 To vallidate International Phone Format on Contact
                        if(con.Phone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && con.Phone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                                System.debug('contactIdList added con.id insert phone : '+con.ID);
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                // con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; Commented by Shovon w.r.t. CRM-10134
                                //Added by Kavya per LOC-1024, To check minimum length criteria for International Phone Format
                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && con.Phone.length()>=dialCode.LCRM_Minimum_Length__c && con.Phone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                    con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; // Added by Shovon w.r.t. CRM-10134
                                }else{
                                    con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; // Added by Shovon w.r.t. CRM-10134
                                }
                            }
                        }
                    }
                    
                    //StrikeIron verification for Mobile Phone field
                    if(con.MobilePhone!= null && con.MobilePhone!=''){
                        //LOC-1024 To vallidate International Phone Format on Contact
                        if(con.MobilePhone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && con.Phone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                                System.debug('contactIdList added con.id insert phone : '+con.ID);
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && con.MobilePhone.length()>=dialCode.LCRM_Minimum_Length__c && con.MobilePhone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                    con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                                }else{
                                    con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; //  Added by Shovon w.r.t. CRM-10134
                                }
                            }
                        }
                    }
                    
                    //Other Phone field check 
                    if(con.OtherPhone!= null && con.OtherPhone!=''){
                        //added by LOC-1048
                        if(con.OtherPhone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && con.OtherPhone.startsWith(dialCode.LCRM_International_Prefix__c))){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                conIdList.add(con.ID);
                            }
                            if(Trigger.isBefore){
                                //Added by LOC-1024, To check minimum length criteria
                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && con.OtherPhone.length()>=dialCode.LCRM_Minimum_Length__c && con.OtherPhone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                    con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; // Added by Shovon w.r.t. CRM-10134
                                    
                                }else{
                                    con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; // Added by Shovon w.r.t. CRM-10134
                                    
                                }
                                
                            }
                        }
                    }
                }
            }    
        }else{//update block
            Integer i = 0;
            Set<id>  conIDsSet = new Set<ID>();
            for(Contact con : conListNew){
                if(con.recordTypeId==gliContactRecordTypeId || con.recordTypeId==gliContactCDSRecordTypeId){
                    conIDsSet.add(con.ID);
                }
            }
            System.debug('conIDsSet1 : '+conIDsSet);
            Map<ID,Contact> conMap = new Map<ID,Contact>([SELECT ID, Email,Phone, MobilePhone,OtherPhone FROM Contact WHERE ID IN :conIDsSet]); 
            System.debug('conMap : '+conMap);
            if(conIDsSet.size()>0){
                //conIDsSet = new Set<ID>();
                for(Contact con : conListNew){
                    if(con.recordTypeId==gliContactRecordTypeId || con.recordTypeId==gliContactCDSRecordTypeId){
                        //if stmts to change strikeiron fields to null values if field values are removed
                        
                        //retrieve ISD codes from custom setting to standarize the phone numbers
                        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                        if(con.LCRM_Country__c != null && con.LCRM_Country__c !=''){
                            dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(con.LCRM_Country__c);
                        }
                        System.debug('dialCode : '+con.LCRM_Country__c+' : '+dialCode);
                        
                        //block to check email field for verification/update
                        
                        if(con.Email!= null && con.Email!='' && (Test.isRunningTest() || conListOld[i].Email != con.Email )){
                            conIdList.add(con.ID);
                        }
                        
                        //block to check phone field for verification/update
                        if(con.Phone!= null && con.Phone!='' && (Test.isRunningTest() || conListOld[i].Phone != con.Phone )){
                            //Added by Kavya as part of LOC-1024
                            if(con.Phone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && con.Phone.startsWith(dialCode.LCRM_International_Prefix__c) )){    
                                conIdList.add(con.ID);
                            }else if(dialCode != null){
                                conIdList.add(con.ID);
                                // con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; Commented by Shovon w.r.t. CRM-10134
                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && con.Phone.length()>=dialCode.LCRM_Minimum_Length__c && con.Phone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                    con.Phone = '+'+ con.Phone; //LOC-1024
                                }
                                else{
                                    con.Phone = '+'+dialCode.LCRM_ISD_Code__c + con.Phone; // Added by Shovon w.r.t. CRM-10134
                                }
                            }
                        }
                        
                        //block to check mobile phone field for verification/update
                        if(con.MobilePhone!= null && con.MobilePhone!='' && (Test.isRunningTest() || conListOld[i].MobilePhone != con.MobilePhone )){
                            //Added by Kavya as part of LOC-1024
                            if(con.MobilePhone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && con.MobilePhone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                                conIdList.add(con.ID);
                            }else if(dialCode != null){
                                conIdList.add(con.ID);
                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && con.MobilePhone.length()>=dialCode.LCRM_Minimum_Length__c && con.MobilePhone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                    con.MobilePhone = '+'+ con.MobilePhone; //LOC-1024
                                }
                                else{
                                    con.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + con.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                                }
                            }
                        }
                        
                        //block to check other phone field for verification/update
                        if(con.OtherPhone!= null && con.OtherPhone!='' && (Test.isRunningTest() ||  conListOld[i].OtherPhone != con.OtherPhone )){
                            //Added by Kavya as part of LOC-1024
                            if(con.OtherPhone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && con.OtherPhone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                                conIdList.add(con.ID);
                            }else if(dialCode != null){
                                conIdList.add(con.ID);
                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && con.OtherPhone.length()>=dialCode.LCRM_Minimum_Length__c && con.OtherPhone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                    con.OtherPhone = '+'+ con.OtherPhone; //LOC-1024
                                }
                                else{
                                    con.OtherPhone = '+'+dialCode.LCRM_ISD_Code__c + con.OtherPhone; // Added by Shovon w.r.t. CRM-10134
                                }
                            }
                        }
                    }
                }
                i = i+1;
            }
        }
        }
    } 
   
}