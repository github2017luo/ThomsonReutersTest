/*
======================================================================================================================
CLASS NAME:    AccountHandler
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
2017-06-01        Rajesh                  added verifyEmailAndPhone & verifyEmailAndPhoneFuture methods toverify Phone & Email fields using StrikeIron for LCRM
2018-08-18        Legal OC                Added to fix Production Incident :INC1204237 - When trying to submit an Order we are receiving a Java Script, Too Many SOQL queries: 101 error message.
======================================================================================================================
*/

public with sharing class AccountHandler
{
    //fix to avaoid SOQL 101 Error on Apttus proposal Sumit Order
    public static boolean bypassLeadUpdateonOrderSubmission =false;    
    //fix to handle verifyEmailAndPhonefuture method call from Oppty renewal cancellation batch
    public static boolean renewalCancellationFlow = false;
    //Fix to avoid CPU Time Limit Error on opportunity Creation 
    public static boolean bypassLeadUpdateonOpptyCreation =false;
    /* Commented the code by Shovon for ECM load issue
//method for updating phone on contact and opp
public static void updatePhoneonContactOpportunity(List<Account> listAccounts,Map<Id,Account> mapNewAccounts)
{
//query on contact and opp objects
List<Opportunity> listOpportunity = [select id,ContactPhone__c,accountid from Opportunity where AccountId IN :listAccounts];
List<contact> listContacts = [select id,Account_SAP_Phone1__c,accountid from Contact where AccountId IN :listAccounts];
//update the phone on contact and oppo
for(opportunity oOpportunity : listOpportunity )
oOpportunity.ContactPhone__c = mapNewAccounts.get(oOpportunity.accountid).Phone;
for(Contact cContact: listContacts)
cContact.Account_SAP_Phone1__c = mapNewAccounts.get(cContact.accountid).Phone;
//DML s to update contact and opp
update listOpportunity ;
update listContacts ;
}
*/
    public static void updatePhoneonContactOpportunity(List<Id> listAccounts){
        if(!System.isFuture()){
            updatePhoneonContactOpportunityFuture(listAccounts);
        }
        else{
            updatePhoneonContactOpportunityNonFuture(listAccounts);
        }
    }
    @future
    public static void updatePhoneonContactOpportunityFuture(List<Id> listAccounts){
        updatePhoneonContactOpportunityNonFuture(listAccounts);
    }
    public static void updatePhoneonContactOpportunityNonFuture(List<Id> listAccounts){
        //query on contact and opp objects
        List<Opportunity> listOpportunity = [select id,ContactPhone__c,accountid from Opportunity where AccountId IN :listAccounts];
        List<contact> listContacts = [select id,Account_SAP_Phone1__c,accountid from Contact where AccountId IN :listAccounts];
        Map<Id,Account> mapNewAccounts = new Map<Id,Account>([select id, Phone from Account where id IN: listAccounts]);
        //update the phone on contact and oppo
        for(opportunity oOpportunity : listOpportunity )
            oOpportunity.ContactPhone__c = mapNewAccounts.get(oOpportunity.accountid).Phone;
        for(Contact cContact: listContacts)
            cContact.Account_SAP_Phone1__c = mapNewAccounts.get(cContact.accountid).Phone;
        //DML s to update contact and opp
        update listOpportunity ;
        update listContacts ;
    }   
    
    public static void updateLeadBillingAddress(List<Account> listAccount,Map<Id,Account> mapNewAccounts){
        system.debug('Check FLag'+bypassLeadUpdateonOrderSubmission);
        system.debug('Check FLag'+bypassLeadUpdateonOrderSubmission);
        
        if(!bypassLeadUpdateonOrderSubmission && !bypassLeadUpdateonOpptyCreation){
            Map<Id,Lead> MapLeadAccount =  new Map<Id,Lead>();
            Map<String,Account> MapAccountSysId = new Map<String,Account>();
            Set<String> setLegacySysIds = new Set<String>();
            List<Lead> listLead = new List<Lead>();
            //List<Lead> listLead = [Select Email,Title,Account__c from Lead where Account__c IN : listAccount and isConverted = false];
            // String LeadsQuery = 'Select Email,Title,Account__c,Legacy_System_ID__c from Lead where isConverted = false and ';   //Replaced with custom Label as part of S2E Optimization
            String LeadsQuery = Label.AccHandlerLeadsQry;
            for(Account oAccount : listAccount){
                if(oAccount.Legacy_System_Id__c!=null){
                    if(!MapAccountSysId.containskey(String.valueof(oAccount.Legacy_System_Id__c))){
                        MapAccountSysId.put(String.valueof(oAccount.Legacy_System_Id__c),oAccount);            
                    }
                }
            }
            setLegacySysIds = MapAccountSysId.keyset();
            if(!listAccount.IsEmpty()){
                LeadsQuery += '(Account__c IN : listAccount';
                if(!MapAccountSysId.IsEmpty()){
                    LeadsQuery += ' OR Legacy_System_Id__c IN : setLegacySysIds)';
                }else{
                    LeadsQuery += ')';
                }
            }else if(!MapAccountSysId.IsEmpty()){
                LeadsQuery += ' Legacy_System_Id__c IN : setLegacySysIds ';
            }
            try{
                if(!listAccount.IsEmpty() || !MapAccountSysId.IsEmpty()){
                    listLead = Database.query(LeadsQuery);}
                for(Lead oLead : listLead){
                    if(mapNewAccounts.containskey(oLead.Account__c) && oLead.Account__c!=null){
                        oLead.Billing_City__c= mapNewAccounts.get(oLead.Account__c).BillingCity;
                        oLead.Billing_State__c = mapNewAccounts.get(oLead.Account__c).BillingState;
                        oLead.Billing_Street__c = mapNewAccounts.get(oLead.Account__c).BillingStreet;
                        oLead.Billing_Zip__c = mapNewAccounts.get(oLead.Account__c).BillingPostalCode; 
                        oLead.Billing_Country__c = mapNewAccounts.get(oLead.Account__c).BillingCountry; 
                        oLead.URL__c = mapNewAccounts.get(oLead.Account__c).URL_2__c;
                        oLead.Sales_Org__c = mapNewAccounts.get(oLead.Account__c).Sales_Org__c;
                        oLead.Customer_Class__c = mapNewAccounts.get(oLead.Account__c).Customer_Class_c__c;
                        oLead.Customer_Group__c = mapNewAccounts.get(oLead.Account__c).Customer_Group__c;
                        oLead.Customer_Type__c = mapNewAccounts.get(oLead.Account__c).Customer_Type__c;
                        oLead.Billing_Country__c = mapNewAccounts.get(oLead.Account__c).BillingCountry;
                        oLead.Industry = mapNewAccounts.get(oLead.Account__c).Industry ;
                        if(mapNewAccounts.get(oLead.Account__c).Phone!=null){
                            oLead.Phone = mapNewAccounts.get(oLead.Account__c).Phone;  
                        }
                        oLead.MDBID__c = mapNewAccounts.get(oLead.Account__c).MDBID__c;
                    }else if(MapAccountSysId.containskey(String.valueof(oLead.Legacy_System_ID__c))){
                        oLead.Billing_City__c= MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).BillingCity;
                        oLead.Billing_State__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).BillingState;
                        oLead.Billing_Street__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).BillingStreet;
                        oLead.Billing_Zip__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).BillingPostalCode; 
                        oLead.Billing_Country__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).BillingCountry; 
                        oLead.URL__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).URL_2__c;
                        oLead.Sales_Org__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Sales_Org__c;
                        oLead.Customer_Class__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Customer_Class_c__c;
                        oLead.Customer_Group__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Customer_Group__c;
                        oLead.Customer_Type__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Customer_Type__c; 
                        oLead.Billing_Country__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).BillingCountry; 
                        oLead.Industry = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Industry ;                     
                        if(MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Phone!=null){
                            oLead.Phone = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).Phone;
                        }
                        oLead.MDBID__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).MDBID__c;
                        oLead.Account__c = MapAccountSysId.get(String.valueof(oLead.Legacy_System_ID__c)).id;
                    }
                }
                update listLead;
            }catch(Exception ex){}
        }
    }
    
    /*
public static void updateContactSalesOrg(List<Account> listAccount){
Map<Id,String> mapAccountSalesOrg = new map<Id,String>();
List<Contact> listContact = [Select AccountId,Sales_Org__c from Contact where AccountId IN : listAccount];
for(Account oAccount : listAccount){
if(!mapAccountSalesOrg.containsKey(oAccount.Id)){
mapAccountSalesOrg.put(oAccount.Id,oAccount.Sales_Org__c);
}
}
for(Contact oContact : listContact){
oContact.Sales_Org__c = mapAccountSalesOrg.get(oContact.AccountId);
}
update listContact;
}
*/
    
    public static void updateContactSalesOrg(List<Id> listAccountId){
        if(!System.isFuture()){
            updateContactSalesOrgFuture(listAccountId);
        }
        else{
            updateContactSalesOrgNonFuture(listAccountId);
        }
    }
    @future
    public static void updateContactSalesOrgFuture(List<Id> listAccountId){
        updateContactSalesOrgNonFuture(listAccountId);
    }
    public static void updateContactSalesOrgNonFuture(List<Id> listAccountId){
        system.debug('Check FLag'+bypassLeadUpdateonOrderSubmission);
        if(!bypassLeadUpdateonOrderSubmission ){
            Map<Id,String> mapAccountSalesOrg = new map<Id,String>();
            List<Contact> listContact = [Select AccountId, Sales_Org__c from Contact where AccountId IN : listAccountId];
            List<Account> listAccount = [Select Id, Sales_Org__c from Account where Id IN : listAccountId];
            for(Account oAccount : listAccount){
                if(!mapAccountSalesOrg.containsKey(oAccount.Id)){
                    mapAccountSalesOrg.put(oAccount.Id,oAccount.Sales_Org__c);
                }
            }
            for(Contact oContact : listContact){
                oContact.Sales_Org__c = mapAccountSalesOrg.get(oContact.AccountId);
            }
            update listContact;
        }
    }
    /*  public static void checkLatamCommercialAccount(map<Id, Account> mapOldAccs, list<Account> newAccs, boolean isInsert) {

list<user> usr = [SELECT UserRole.Name, Profile.Name From User WHERE Id =: UserInfo.getUserId()];
string roleName = usr[0].UserRole.Name;
string profileName = usr[0].Profile.Name;
system.debug('Role...'+roleName);
system.debug('Profile...'+profileName);
if(profileName == 'Latam User' || profileName =='System Administrator') {
for(Account accnt :newAccs) {

if((accnt.Sales_Org__c == 'LLEY' || accnt.Sales_Org__c == 'ABEP') && (accnt.Customer_Type__c == 'Organization' || accnt.Customer_Type__c == 'Individual')) {
system.debug('Company Code...'+IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c);
if(IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '2054' ||
IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '2056' ||
IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '2057' ||
IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '2064' ||
IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '2079' ||
IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '2080' ||
IXOSCodeMap__c.getInstance(accnt.Sales_Org__c).Company_Code__c == '0300') {

if(accnt.Commercial_Account__c != TRUE && isInsert == TRUE) {
accnt.Commercial_Account__c = True;                                       
system.debug('yes..'+accnt.Commercial_Account__c);
}
if(roleName != 'Dir.Comercial Cono Sur' && isInsert != TRUE && (accnt.Commercial_Account__c != mapOldAccs.get(accnt.Id).Commercial_Account__c)) {
accnt.addError(System.Label.Commercial_Account_error_for_Latam_Users);
} 
}
}     
}
}           
} */
    
    /*
//Commeting this method as part of DPS-17684  
// Ravi H - validate the account having reservation approved and active otherwise through an error  
public static void validateAccountApprovedReservation(LIST<Account> newList, map<id, Account> oldmap){
if(!bypassLeadUpdateonOrderSubmission ){
SET<string> AccountIds= new SET<string>();
for(Account acc: newList){
AccountIds.add(acc.Id);
}
string strprfName= ContactUtil.getProfileName();
if(strprfName == Label.Partner_Portal_Profile){
MAP<string,boolean> accountResrvationMap= new MAP<string,boolean>();
SET<string> acctsWithApprvdResrvtns = new SET<string>();
List<RESERVATION__c> resrvtnLst= new List<RESERVATION__c>();
resrvtnLst=[SELECT Id, Account__c FROM RESERVATION__c WHERE Approval_Status__c = 'Approved' AND Active__c = True AND Account__c IN : AccountIds];
String infUser = system.label.Informatica_User;
//system.debug('***resrvtnLst' +resrvtnLst);- commented to reduce character for s2e optimization
for(Reservation__c r:resrvtnLst){
acctsWithApprvdResrvtns.add(r.Account__c);
}
//system.debug('***acctsWithApprvdResrvtns' +acctsWithApprvdResrvtns);- commented to reduce character for s2e optimization
for(Account accnt: newList){
if( oldmap.get(accnt.Id).MDBID__c == accnt.MDBID__c){
//SFD-317
if(!(acctsWithApprvdResrvtns.Contains(accnt.Id) || accnt.OwnerId == infUser)){
accnt.AddError(system.label.AccountUpdateWithoutReservation);
}  
}                
}
}
}
} 
*/
    // Ravi H -LegalCRM change-20th DEC 16- Validate the account if ECM Ready is equal to true can not be merged(deleted).  
    public static void validateAccountOnMerge(List<Account> accList){
        String usrName = [Select Name From User Where Id =: UserInfo.getUserId()].Name;
        for(Account a : accList){
            /*
If(a.Validated_Account__c != NULL &&  a.Validated_Account__c == True && usrName != 'Informatica User'){  
*/
            If(a.ECM_Party_ID__c != NULL && ! LCRMGenericComponent.StrikeIronCheckActive()){  
                a.addError(System.label.LCRM_ECM_Validated_Account);     
            }
        }
    }    
    /********************************************************************************************
MethodName: addBillAcct
Description: Method is used for updating Quotes which are associated with a Account.
When user change value of Max Resller Discount #, then system update Quote for fired Quote workflow.
DevelopedBy: TCS Offshore 
Revision:
Fixed Defect#:
*********************************************************************************************/
    public static void updateQuote(Map<Id, Account> mapNewAcct, Map<Id, Account> mapOldAcct) 
    {   
        if(!bypassLeadUpdateonOrderSubmission ){
            try{
                Set<Id> setChangeAcct = new Set<Id>();
                for(Id objId : mapNewAcct.keySet()){
                    if((mapNewAcct.get(objId).Customer_Class_c__c == 'Reseller') && (mapNewAcct.get(objId).Max_Reseller_Discount_Percentage__c != mapOldAcct.get(objId).Max_Reseller_Discount_Percentage__c) && (mapNewAcct.get(objId).Is_GLI__c != true )){ //updtaed for CRM-15772
                        setChangeAcct.add(objId);
                    }
                }
                /*System.Debug('setChangeAcct='+ setChangeAcct);- commented to reduce character for s2e optimization*/            
                //REMOVED ABEP AS PART OF HER-20
                //List<Quote> lstQuote = [SELECT Id FROM Quote WHERE Opportunity.Account.Id IN : setChangeAcct AND Status NOT IN ('Sales Admin - Pending Review', 'Prevalidate for Final Approval', 'Approved', 'Order Completed', 'In Review') AND RecordType.DeveloperName = 'LATAM_New_Quote' AND Primary_Quote__c = true AND Pricing_Approval_Complete__c = False AND Business_Unit__c IN ('Chile', 'Laley', 'Paraguay', 'Revista - Print') AND Sales_Org__c IN ('RV01', 'LLEY', 'ABEP', 'LPCL', 'LPTC', 'LLPA')];
                List<Quote> lstQuote = new List<Quote>();
                Map<String,String> businessUnitMap = new Map<String,String>();
                Map<String,String> salesorgMap = new Map<String,String>();
                if(setChangeAcct.size()>0){
                    businessUnitMap = MexicoUtility.classBasedOrgValues('AccountHandler','Business_Unit__c');
                    salesorgMap = MexicoUtility.classBasedOrgValues('AccountHandler','Sales_Org__c');
                    lstQuote = [SELECT Id FROM Quote WHERE Opportunity.Account.Id IN : setChangeAcct AND Status NOT IN ('Sales Admin - Pending Review', 'Prevalidate for Final Approval', 'Approved', 'Order Completed', 'In Review') AND RecordType.DeveloperName = 'LATAM_New_Quote' AND Primary_Quote__c = true AND Pricing_Approval_Complete__c = False AND Business_Unit__c IN : businessUnitMap.values() AND Sales_Org__c IN : salesorgMap.values()];
                    //lstQuote = [SELECT Id FROM Quote WHERE Opportunity.Account.Id IN : setChangeAcct AND Status NOT IN ('Sales Admin - Pending Review', 'Prevalidate for Final Approval', 'Approved', 'Order Completed', 'In Review') AND RecordType.DeveloperName = 'LATAM_New_Quote' AND Primary_Quote__c = true AND Pricing_Approval_Complete__c = False AND Business_Unit__c IN ('Chile', 'Laley', 'Paraguay', 'Revista - Print') AND Sales_Org__c IN ('RV01', 'LLEY','LPCL', 'LPTC', 'LLPA')];
                }
                /*System.Debug('lstQuote='+ lstQuote);- commented to reduce character for s2e optimization*/
                if(lstQuote.size() > 0){
                    UPDATE lstQuote;
                }
            }
            catch(DmlException ex){
                /*System.Debug('Exception occured on Quote update, Method = updateQuote, Class = AccountHandler, ERROR='+ ex);  - commented to reduce character for s2e optimization*/         
            }
        }
    }
    
    // commented as part of DPS-6078
    //Method added by LCRM to call furture method to verify Phone & Email fields using StrikeIron
    /* public static Boolean verifyStrikeIronRecCheck = false;
public void verifyEmailAndPhone(List<Account> accountListOld, List<Account> accountListNew){
if(!bypassLeadUpdateonOrderSubmission ){
//Boolean loggedinUserFlag = UserInfo.getName().toLowerCase().containsIgnoreCase('Informatica');
Boolean loggedinUserFlag = LCRMGenericComponent.StrikeIronCheckActive();
System.debug('loggedinUserFlag :'+loggedinUserFlag);
if(loggedinUserFlag==true && (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
return;
}

Id eliteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
Id eliteRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account-ECM').getRecordTypeId();
List<ID> accountIdList = new List<ID>();
//if condition for insert check
if(accountListOld == null || accountListOld.size()==0){
for(Account acc : accountListNew){
//if block to update timestamps
if(Trigger.isBefore){
if(acc.LCRM_Email_Verification__c != null && acc.LCRM_Email_Verification__c !=''){
acc.LCRM_Email_Verification_TimeStamp__c = DateTime.Now();
}
if(acc.LCRM_Phone_Verification__c != null && acc.LCRM_Phone_Verification__c !=''){
acc.LCRM_Phone_Verification_TimeStamp__c = DateTime.Now();
}
if(acc.LCRM_Alternate_Phone_Verification__c != null && acc.LCRM_Alternate_Phone_Verification__c !=''){
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = DateTime.Now();
}
}

if(acc.recordTypeId==eliteRecordTypeId || acc.recordTypeId==eliteRecordTypeId1){
//accountIdList.add(acc.ID);
//retrieve ISD codes from custom setting to standarize the phone numbers
LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
if(acc.BillingCountry != null && acc.BillingCountry !=''){
dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(acc.BillingCountry);
}
System.debug('dialCode : '+acc.BillingCountry+' : '+dialCode);

//Email field check 
if(acc.Email__c!= null && acc.Email__c!='' && (acc.LCRM_Email_Verification__c == null || 
acc.LCRM_Email_Verification__c =='' || acc.LCRM_Email_Verification__c == 'Pending. Please refresh.')){
if(Trigger.isAfter){
accountIdList.add(acc.ID);
System.debug('accountIdList added acc.id insert email : '+acc.ID);
}
if(Trigger.isBefore){
if(!loggedinUserFlag){
acc.LCRM_Email_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Email_Verification__c = '';
}
acc.LCRM_Email_Verification_TimeStamp__c = null;
}
}

//Phone field check
if(acc.Phone!= null && acc.Phone!='' && (acc.LCRM_Phone_Verification__c == null || 
acc.LCRM_Phone_Verification__c =='' || acc.LCRM_Phone_Verification__c == 'Pending. Please refresh.')){
if(acc.Phone.startsWith('+') || acc.Phone.startsWith('00')){
if(Trigger.isAfter){
accountIdList.add(acc.ID);
System.debug('accountIdList added acc.id insert phone : '+acc.ID);
}
if(Trigger.isBefore){
if(!loggedinUserFlag){
acc.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Phone_Verification__c = '';
}
acc.LCRM_Phone_Verification_TimeStamp__c = null;
}
}else if(dialCode != null){
if(Trigger.isAfter){
accountIdList.add(acc.ID);
System.debug('accountIdList added acc.id insert phone1 : '+acc.ID);
}
if(Trigger.isBefore){
//acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone;  Commented by Shovon w.r.t. CRM-10134
if(!loggedinUserFlag){
acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone;  // Added by Shovon w.r.t. CRM-10134
acc.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Phone_Verification__c = '';
}
acc.LCRM_Phone_Verification_TimeStamp__c = null;
}
}
}

//Alternate Phone field check
if(acc.PhoneNumberTwo__c!= null && acc.PhoneNumberTwo__c!='' && (acc.LCRM_Alternate_Phone_Verification__c == null || 
acc.LCRM_Alternate_Phone_Verification__c =='' || acc.LCRM_Alternate_Phone_Verification__c == 'Pending. Please refresh.')){

if(acc.PhoneNumberTwo__c.startsWith('+') || acc.PhoneNumberTwo__c.startsWith('00')){
if(Trigger.isAfter){
accountIdList.add(acc.ID);
System.debug('accountIdList added acc.id insert altphone : '+acc.ID);
}
if(Trigger.isBefore){
if(!loggedinUserFlag){
acc.LCRM_Alternate_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Alternate_Phone_Verification__c = '';
}
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
}
}else if(dialCode != null){
if(Trigger.isAfter){
accountIdList.add(acc.ID);
System.debug('accountIdList added acc.id insert altphone1 : '+acc.ID);
}
if(Trigger.isBefore){
//acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c; Commented by Shovon w.r.t. CRM-10134
if(!loggedinUserFlag){
acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c; // Added by Shovon w.r.t. CRM-10134
acc.LCRM_Alternate_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Alternate_Phone_Verification__c = '';
}
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
}
}
}
}

}    
}else{
//update block
Integer i = 0;
Set<id> ldIDsSet = new Set<ID>();
for(Account acc : accountListNew){
if(acc.recordTypeId==eliteRecordTypeId || acc.recordTypeId==eliteRecordTypeId1){
ldIDsSet.add(acc.ID);
}
}
Map<ID,Account> accountMap = new Map<ID,Account>([SELECT ID, Email__c, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
PhoneNumberTwo__c, LCRM_Alternate_Phone_Verification__c, LCRM_Alternate_Phone_Veri_TimeStamp__c FROM Account WHERE ID IN :ldIDsSet]); //accountIdList
if(ldIDsSet.size()>0){
//ldIDsSet = new Set<ID>();
for(Account acc : accountListNew){
System.debug('LCRM Account : '+acc);
System.debug('acc.Email__c : '+acc.Email__c);
System.debug('accountListOld[i].Email__c : '+accountListOld[i].Email__c);
//System.debug('accountMap.get(acc.ID).Email__c : '+accountMap.get(acc.ID).Email__c); //commented by saloni because of null pointer exception
if(acc.recordTypeId==eliteRecordTypeId || acc.recordTypeId==eliteRecordTypeId1){
//if stmts to change strikeiron fields to null values if field values are removed
if(acc.Email__c ==null){
acc.LCRM_Email_Verification__c = null;
acc.LCRM_Email_Verification_TimeStamp__c = null;
}
if(acc.Phone ==null){
acc.LCRM_Phone_Verification__c = null;
acc.LCRM_Phone_Verification_TimeStamp__c = null;
}
if(acc.PhoneNumberTwo__c ==null){
acc.LCRM_Alternate_Phone_Verification__c = null;
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
}

//condition to handle double update
if(acc.Email__c !=null && (acc.Email__c == accountListOld[i].Email__c) && (accountMap!=null && accountMap.get(acc.ID)!=null && accountMap.get(acc.ID).Email__c == acc.Email__c && acc.LCRM_Email_Verification__c =='Pending. Please refresh.')){
acc.LCRM_Email_Verification__c = accountMap.get(acc.ID).LCRM_Email_Verification__c;
acc.LCRM_Email_Verification_TimeStamp__c = accountMap.get(acc.ID).LCRM_Email_Verification_TimeStamp__c;
}
if(acc.Phone !=null && (acc.Phone == accountListOld[i].Phone) && (accountMap!=null && accountMap.get(acc.ID)!=null && accountMap.get(acc.ID).Phone == acc.Phone && acc.LCRM_Phone_Verification__c =='Pending. Please refresh.')){
acc.LCRM_Phone_Verification__c = accountMap.get(acc.ID).LCRM_Phone_Verification__c;
acc.LCRM_Phone_Verification_TimeStamp__c = accountMap.get(acc.ID).LCRM_Phone_Verification_TimeStamp__c;
}
if(acc.PhoneNumberTwo__c!=null && (acc.PhoneNumberTwo__c == accountListOld[i].PhoneNumberTwo__c) && (accountMap!=null && accountMap.get(acc.ID)!=null && accountMap.get(acc.ID).PhoneNumberTwo__c == acc.PhoneNumberTwo__c && acc.LCRM_Alternate_Phone_Verification__c =='Pending. Please refresh.')){
acc.LCRM_Alternate_Phone_Verification__c = accountMap.get(acc.ID).LCRM_Alternate_Phone_Verification__c;
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = accountMap.get(acc.ID).LCRM_Alternate_Phone_Veri_TimeStamp__c;
}

//condition to flag error message to stop double update on email/phone field when strike iron verificationb is still in progress
if((
((acc.LCRM_Email_Verification__c =='Pending. Please refresh.' || (acc.LCRM_Email_Verification__c =='' && accountMap!=null && accountMap.get(acc.ID)!=null && accountMap.get(acc.ID).LCRM_Email_Verification__c =='Pending. Please refresh.')) && accountListOld[i].Email__c != acc.Email__c)
|| 
((acc.LCRM_Phone_Verification__c =='Pending. Please refresh.' || (acc.LCRM_Phone_Verification__c =='' && accountMap!=null && accountMap.get(acc.ID)!=null && accountMap.get(acc.ID).LCRM_Phone_Verification__c =='Pending. Please refresh.')) && accountListOld[i].Phone != acc.Phone)
|| 
((acc.LCRM_Alternate_Phone_Verification__c =='Pending. Please refresh.' || (acc.LCRM_Alternate_Phone_Verification__c =='' && accountMap!=null && accountMap.get(acc.ID)!=null && accountMap.get(acc.ID).LCRM_Alternate_Phone_Verification__c =='Pending. Please refresh.')) && accountListOld[i].PhoneNumberTwo__c != acc.PhoneNumberTwo__c)
)){
if(!loggedinUserFlag){
acc.addError(System.label.LCRM_AccountUpdateWarningStrikeIron.replace('<link>','<a href=\'/'+acc.id+'\'>Click to refresh.</a>'), False);
}
continue;
}

//retrieve ISD codes from custom setting to standarize the phone numbers
LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
if(acc.BillingCountry != null && acc.BillingCountry !=''){
dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(acc.BillingCountry);
}
System.debug('dialCode : '+acc.BillingCountry+' : '+dialCode);

//block to check email field for verification/update
if(acc.Email__c!= null && acc.Email__c!='' && (accountListOld[i].Email__c != acc.Email__c || acc.LCRM_Email_Verification__c == null || 
acc.LCRM_Email_Verification__c =='' || (!loggedinUserFlag && acc.LCRM_Email_Verification__c!=null && acc.LCRM_Email_Verification__c!='' && acc.LCRM_Email_Verification__c.contains('Exception')))){
accountIdList.add(acc.ID);
if(!loggedinUserFlag){
acc.LCRM_Email_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Email_Verification__c = '';
}
acc.LCRM_Email_Verification_TimeStamp__c = null;
}

//block to check phone field for verification/update
if(acc.Phone!= null && acc.Phone!='' && (accountListOld[i].Phone != acc.Phone || acc.LCRM_Phone_Verification__c == null || 
acc.LCRM_Phone_Verification__c =='' || (!loggedinUserFlag && acc.LCRM_Phone_Verification__c!=null && acc.LCRM_Phone_Verification__c!='' && acc.LCRM_Phone_Verification__c.contains('Exception')))){
if(acc.Phone.startsWith('+') || acc.Phone.startsWith('00')){
accountIdList.add(acc.ID);
if(!loggedinUserFlag){
acc.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Phone_Verification__c = '';
}
acc.LCRM_Phone_Verification_TimeStamp__c = null;
}else if(dialCode != null){
accountIdList.add(acc.ID);
//acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone; Commented by Shovon w.r.t. CRM-10134
if(!loggedinUserFlag){
acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone; // Added by Shovon w.r.t. CRM-10134
acc.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Phone_Verification__c = '';
}
acc.LCRM_Phone_Verification_TimeStamp__c = null;
}
}

//block to check altphone field for verification/update
if(acc.PhoneNumberTwo__c!= null && acc.PhoneNumberTwo__c!='' && (accountListOld[i].PhoneNumberTwo__c != acc.PhoneNumberTwo__c || acc.LCRM_Alternate_Phone_Verification__c == null || 
acc.LCRM_Alternate_Phone_Verification__c =='' || (!loggedinUserFlag && acc.LCRM_Alternate_Phone_Verification__c!=null && acc.LCRM_Alternate_Phone_Verification__c!='' && acc.LCRM_Alternate_Phone_Verification__c.contains('Exception')))){

if(acc.PhoneNumberTwo__c.startsWith('+') || acc.PhoneNumberTwo__c.startsWith('00')){
accountIdList.add(acc.ID);
if(!loggedinUserFlag){
acc.LCRM_Alternate_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Alternate_Phone_Verification__c = '';
}
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
}else if(dialCode != null){
accountIdList.add(acc.ID);
//acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c; Commented by Shovon w.r.t. CRM-10134
if(!loggedinUserFlag){
acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c;  // Added by Shovon w.r.t. CRM-10134
acc.LCRM_Alternate_Phone_Verification__c = 'Pending. Please refresh.';
}else{
acc.LCRM_Alternate_Phone_Verification__c = '';
}
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
}
}
}
i = i+1;
}
}

}
if(!loggedinUserFlag && !renewalCancellationFlow && accountIdList!=null && accountIdList.size()>0){
//future method invoked to make callouts to webservices
verifyEmailAndPhoneFuture(accountIdList);
}
}
}

//Method added by LCRM to verify Phone & Email fields using StrikeIron
@future(callout=true)
public static void verifyEmailAndPhoneFuture(List<ID> accountIdList){
if(!bypassLeadUpdateonOrderSubmission ){
List<LCRM_Exception_Log__c> excepObjList = new List<LCRM_Exception_Log__c>();
try{
List<Account> accountList = [SELECT ID, Email__c, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
PhoneNumberTwo__c, LCRM_Alternate_Phone_Verification__c, LCRM_Alternate_Phone_Veri_TimeStamp__c FROM Account WHERE ID IN :accountIdList];
LCRMStrikeIronServices servObj;
String phone = '';

//loop to create list of phone and email values for making callout to strike iron services
for(Account acc : accountList){
servObj = new LCRMStrikeIronServices();
if(acc.LCRM_Email_Verification__c == 'Pending. Please refresh.'){
//making callout to email strikiron services
String emailStatus = servObj.callEmailValidation(acc.Email__c);
//String emailStatus = 'Exception';
System.debug('emailStatus : '+emailStatus);
if(emailStatus!=null && emailStatus!='' && emailStatus.contains('Exception')){
if(emailStatus == 'Exception : Email Service not configured.' || emailStatus == 'Exception : Email Service not active.'){
acc.LCRM_Email_Verification__c = emailStatus;
}else{
acc.LCRM_Email_Verification__c = 'Exception in Verification Service.';
}
acc.LCRM_Email_Verification_TimeStamp__c = null;
LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
excepObj.LCRM_Exception_Message__c = '';
excepObj.LCRM_Exception_Trace__c = emailStatus;
excepObj.LCRM_Exception_Type__c = 'StrikeIron Account Email';
excepObj.LCRM_Record_Ids__c = String.valueOf(accountIdList);
excepObj.LCRM_User_ID__c = userinfo.getUserId();
excepObjList.add(excepObj);
}else if(emailStatus!=null && emailStatus!=''){
acc.LCRM_Email_Verification__c = emailStatus;
acc.LCRM_Email_Verification_TimeStamp__c = DateTime.Now();
}else{
acc.LCRM_Email_Verification__c = '';
acc.LCRM_Email_Verification_TimeStamp__c = null;
}
}

if(acc.LCRM_Phone_Verification__c == 'Pending. Please refresh.'){
phone = phone + ((phone==null || phone=='')?'':',') + acc.Phone;
}
if(acc.LCRM_Alternate_Phone_Verification__c == 'Pending. Please refresh.'){
phone = phone + ((phone==null || phone=='')?'':',') + acc.PhoneNumberTwo__c;
}
}
//block to make callout to strikeiron for phone field verification
if(phone!=null && phone!=''){
Map<String, String> reponsePhone = servObj.callPhoneValidation(phone);
System.debug('reponsePhone : '+reponsePhone);
for(Account acc : accountList){
//block to update phone field accourdingly after strikiron callout
if(acc.LCRM_Phone_Verification__c == 'Pending. Please refresh.'){
String phoneStatus = reponsePhone.get(acc.Phone);
System.debug('phoneStatus : '+phoneStatus);
if(phoneStatus!=null && phoneStatus!='' && phoneStatus.contains('Exception')){
if(phoneStatus == 'Exception : Phone Service not configured.' || phoneStatus == 'Exception : Phone Service not active.'){
acc.LCRM_Phone_Verification__c = phoneStatus;
}else{
acc.LCRM_Phone_Verification__c = 'Exception in Verification Service.';
}
acc.LCRM_Phone_Verification_TimeStamp__c = null;
LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
excepObj.LCRM_Exception_Message__c = 'Phone';
excepObj.LCRM_Exception_Trace__c = phoneStatus;
excepObj.LCRM_Exception_Type__c = 'StrikeIron Account Phone';
excepObj.LCRM_Record_Ids__c = String.valueOf(acc.ID);
excepObj.LCRM_User_ID__c = userinfo.getUserId();
excepObjList.add(excepObj);
}else if(phoneStatus!=null && phoneStatus!=''){
acc.LCRM_Phone_Verification__c = phoneStatus;
acc.LCRM_Phone_Verification_TimeStamp__c = DateTime.Now();
}else{
acc.LCRM_Phone_Verification__c = '';
acc.LCRM_Phone_Verification_TimeStamp__c = null;
}
}

//block to update alt phone field accourdingly after strikiron callout
if(acc.LCRM_Alternate_Phone_Verification__c == 'Pending. Please refresh.'){
String altPhoneStatus = reponsePhone.get(acc.PhoneNumberTwo__c);
System.debug('altPhoneStatus : '+altPhoneStatus);
if(altPhoneStatus!=null && altPhoneStatus!='' && altPhoneStatus.contains('Exception')){
if(altPhoneStatus == 'Exception : Phone Service not configured.' || altPhoneStatus == 'Exception : Phone Service not active.'){
acc.LCRM_Alternate_Phone_Verification__c = altPhoneStatus;
}else{
acc.LCRM_Alternate_Phone_Verification__c = 'Exception in Verification Service.';
}
system.debug('acc.LCRM_Alternate_Phone_Verification__c : '+acc.LCRM_Alternate_Phone_Verification__c);
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
excepObj.LCRM_Exception_Message__c = 'PhoneNumberTwo__c';
excepObj.LCRM_Exception_Trace__c = altPhoneStatus;
excepObj.LCRM_Exception_Type__c = 'StrikeIron Account Phone';
excepObj.LCRM_Record_Ids__c = String.valueOf(acc.ID);
excepObj.LCRM_User_ID__c = userinfo.getUserId();
excepObjList.add(excepObj);
}else if(altPhoneStatus!=null && altPhoneStatus!=''){
acc.LCRM_Alternate_Phone_Verification__c = altPhoneStatus;
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = DateTime.Now();
}else{
acc.LCRM_Alternate_Phone_Verification__c = '';
acc.LCRM_Alternate_Phone_Veri_TimeStamp__c = null;
}
}
}
}
update accountList;
}catch(Exception e){
System.debug('Exception : '+e.getMessage()+' : '+e.getStackTraceString());
LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
excepObj.LCRM_Exception_Message__c = e.getMessage();
excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
excepObj.LCRM_Exception_Type__c = 'StrikeIron Account Email & Phone';
excepObj.LCRM_Record_Ids__c = String.valueOf(accountIdList);
excepObj.LCRM_User_ID__c = userinfo.getUserId();
excepObjList.add(excepObj);
}
if(excepObjList!=null && excepObjList.size()>0){
insert excepObjList;
}
}
} */
    
    /****
Start
Added Vat No Validation method 
Added as a part of DPS - 6407
****/   
    
    public static void vatNoValidation(LIST<Account> accList){  
        
        Id gliAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
        Id gliAccountECMId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account_ECM').getRecordTypeId();
        Id gliArchiveId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Archive').getRecordTypeId();  
        System.debug('11  '+gliAccountId+'  12  '+gliAccountECMId+ '  13  '+gliArchiveId);
        
        Map<String,VAT_Validation_On_Account__c> vatMap= VAT_Validation_On_Account__c.getAll();
        System.debug('aa '+vatMap);
        Set<String> isoCodeSet= vatMap.keySet();
        //new VAT_Validation_On_Account__c();
        for(Account ac: accList)
        {
            if((ac.RecordTypeId==gliAccountId || ac.RecordTypeId==gliAccountECMId ||ac.RecordTypeId==gliArchiveId) && isoCodeSet.contains(ac.BillingCountry))
            {
                //String countryIsoCode= ac.BillingCountry;
                Integer vatLength= Integer.valueOf(VAT_Validation_On_Account__c.getValues(ac.BillingCountry).VAT_Number_Length__c);
                System.debug('bb '+vatLength);
                //Integer countryLength= Integer.valueOf(countryValue.right(2))  ;
                
                if(ac.VAT_Number__c!=null && ac.VAT_Number__c.length()>vatLength)
                    ac.addError(Label.Vat_No_Validation_on_Account);
                System.debug('aa '+Label.Vat_No_Validation_on_Account);
            }  
        }
        
    }
    //End DPS - 6407
    
    //Method added as part of DPS-6078
    public void addISDCodeToPhone(List<Account> accountListOld, List<Account> accountListNew){
        if(!bypassLeadUpdateonOrderSubmission ){
            
            System.debug('accountListNew : '+accountListNew);
            Id eliteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            Id eliteRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account_ECM').getRecordTypeId();
            Id latAmRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account_LatAm').getRecordTypeId();
            List<ID> accountIdList = new List<ID>();
            if(CheckRecursive.lCRMRecursivecheck_Account()){    
                //if condition for insert check
                if(accountListOld == null || accountListOld.size()==0){
                    for(Account acc : accountListNew){
                        //if block to update timestamps
                        if(acc.recordTypeId==eliteRecordTypeId || acc.recordTypeId==eliteRecordTypeId1 || acc.recordTypeId==latAmRecordTypeId){ //LOC-1019 - Added LatAm Recordtype
                            //accountIdList.add(acc.ID);
                            //retrieve ISD codes from custom setting to standarize the phone numbers
                            LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                            if(acc.BillingCountry != null && acc.BillingCountry !=''){
                                dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(acc.BillingCountry);
                            }
                            System.debug('dialCode : '+acc.BillingCountry+' : '+dialCode);
                            
                            //Phone field check
                            if(acc.Phone!= null && acc.Phone!=''){
                                //   System.debug('inside phone verification LCRMConvertLeadController.leadAccountStrikeIronBypassPhone'+LCRMConvertLeadController.leadAccountStrikeIronBypassPhone);
                                
                                //LOC-1019 - Changes to include International Prefix and Minimum Length Consideration 
                                if(acc.Phone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && acc.Phone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                                    if(Trigger.isAfter){
                                        accountIdList.add(acc.ID);
                                        System.debug('accountIdList added acc.id insert phone : '+acc.ID);
                                    }
                                }else if(dialCode != null){
                                    if(Trigger.isAfter){
                                        accountIdList.add(acc.ID);
                                        System.debug('accountIdList added acc.id insert phone1 : '+acc.ID);
                                    }
                                    if(Trigger.isBefore){
                                        //acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone;  Commented by Shovon w.r.t. CRM-10134
                                        if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && acc.Phone.length()>=dialCode.LCRM_Minimum_Length__c && acc.Phone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                            
                                            acc.Phone = '+'+ acc.Phone;  // LOC -1019 modification by Lipika
                                        }                                   
                                        else{
                                            acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone;  // Added by Shovon w.r.t. CRM-10134
                                        }
                                        
                                    }
                                    
                                    //Alternate Phone field check
                                    if(acc.PhoneNumberTwo__c!= null && acc.PhoneNumberTwo__c!=''){
                                        
                                        if(acc.PhoneNumberTwo__c.startsWith('+') || acc.PhoneNumberTwo__c.startsWith('00')){
                                            if(Trigger.isAfter){
                                                accountIdList.add(acc.ID);
                                                System.debug('accountIdList added acc.id insert altphone : '+acc.ID);
                                            }
                                            
                                        }else if(dialCode != null){
                                            if(Trigger.isAfter){
                                                accountIdList.add(acc.ID);
                                                System.debug('accountIdList added acc.id insert altphone1 : '+acc.ID);
                                            }
                                            if(Trigger.isBefore){
                                                //acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c; Commented by Shovon w.r.t. CRM-10134
                                                if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && acc.PhoneNumberTwo__c.length()>=dialCode.LCRM_Minimum_Length__c && acc.PhoneNumberTwo__c.startsWith (dialCode.LCRM_ISD_Code__c)){
                                                    
                                                    acc.PhoneNumberTwo__c = '+'+ acc.PhoneNumberTwo__c;  // LOC -1019 modification by Lipika
                                                }else{
                                                    acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c;  // Added by Shovon w.r.t. CRM-10134
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } 
                    }
                }else{
                    //update block
                    Integer i = 0;
                    Set<id> ldIDsSet = new Set<ID>();
                    for(Account acc : accountListNew){
                        if(acc.recordTypeId==eliteRecordTypeId || acc.recordTypeId==eliteRecordTypeId1 || acc.recordTypeId==latAmRecordTypeId){ //LOC-1019 - Added LatAm Recordtype
                            ldIDsSet.add(acc.ID);
                        }
                    }
                    Map<ID,Account> accountMap = new Map<ID,Account>([SELECT ID, Email__c, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
                                                                      Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
                                                                      PhoneNumberTwo__c, LCRM_Alternate_Phone_Verification__c, LCRM_Alternate_Phone_Veri_TimeStamp__c FROM Account WHERE ID IN :ldIDsSet]); //accountIdList
                    if(ldIDsSet.size()>0){
                        //ldIDsSet = new Set<ID>();
                        for(Account acc : accountListNew){
                            //System.debug('accountMap.get(acc.ID).Email__c : '+accountMap.get(acc.ID).Email__c); //commented by saloni because of null pointer exception
                            if(acc.recordTypeId==eliteRecordTypeId || acc.recordTypeId==eliteRecordTypeId1 || acc.recordTypeId==latAmRecordTypeId){ //LOC-1019 - Added LatAm Recordtype
                                //retrieve ISD codes from custom setting to standarize the phone numbers
                                LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                                if(acc.BillingCountry != null && acc.BillingCountry !=''){
                                    dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(acc.BillingCountry);
                                }
                                System.debug('dialCode : '+acc.BillingCountry+' : '+dialCode);
                                
                                
                                //block to check phone field for verification/update
                                if(acc.Phone!= null && acc.Phone!='' && (accountListOld[i].Phone != acc.Phone )){
                                    if(acc.Phone.startsWith('+') || acc.Phone.startsWith('00')){
                                        accountIdList.add(acc.ID);
                                        
                                    }else if(dialCode != null){
                                        accountIdList.add(acc.ID);
                                        if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && acc.Phone.length()>=dialCode.LCRM_Minimum_Length__c && acc.Phone.startsWith(dialCode.LCRM_ISD_Code__c) ){
                                            acc.Phone = '+'+ acc.Phone;  // Added by Lipika
                                        }else{
                                            acc.Phone = '+'+dialCode.LCRM_ISD_Code__c + acc.Phone;  // Added by Shovon w.r.t. CRM-10134
                                        }
                                        
                                        
                                    }
                                }
                                
                                //block to check altphone field for verification/update
                                if(acc.PhoneNumberTwo__c!= null && acc.PhoneNumberTwo__c!='' && (accountListOld[i].PhoneNumberTwo__c != acc.PhoneNumberTwo__c )){
                                    
                                    if(acc.PhoneNumberTwo__c.startsWith('+') || acc.PhoneNumberTwo__c.startsWith('00')){
                                        accountIdList.add(acc.ID);
                                        
                                    }else if(dialCode != null){
                                        accountIdList.add(acc.ID);
                                        
                                        if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && acc.PhoneNumberTwo__c.length()>=dialCode.LCRM_Minimum_Length__c && acc.PhoneNumberTwo__c.startsWith (dialCode.LCRM_ISD_Code__c)){
                                            
                                            acc.PhoneNumberTwo__c = '+'+ acc.PhoneNumberTwo__c;  // LOC -1019 modification by Lipika
                                        }                                   
                                        else{
                                            acc.PhoneNumberTwo__c = '+'+dialCode.LCRM_ISD_Code__c + acc.PhoneNumberTwo__c;  // Added by Shovon w.r.t. CRM-10134
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
    
}