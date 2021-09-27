/**
 * Controller for the MasterContacts.page that extends the 
 * Quote/Proposal standard controller
 *
 * @author  TCS
 * @version 2016-08-01
 * 
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2016-08-01   Sreenu D                     Created
 * 2016-11-01   Sreenu D                     IP addresses for Clear and Patron contacts-R2                                              
 * =============================================================================
 */
global with sharing class MasterContactsController {
    // Variables
    global string proposalId = '';
    global Apttus_Proposal__Proposal__c aptProposal;
    global List<Apttus_Proposal__Proposal_Line_Item__c> apliList;
    global List<Apttus_Proposal__Proposal_Line_Item__c> apliUpdList;
    global Set<Id> apliIds;
    Map<Id, String> ipIdsMap; // Map contains Ids of clear and Patron products line Itelms    
    global List<Customer_Master_Contacts__c> mstrConList;
    public List<LCRM_Contact_SSD__c > contactssdList;
    global List<Contact> contactList;
    global List<MCWrapper> techConList {get; set;}
    global List<MCWrapper> clrPrimaryList {get; set;}
    global List<MCWrapper> glpPrimaryList {get; set;} //GLP-5
    global List<MCWrapper> pwdEmailList {get; set;}
    global List<MCWrapper> patronConList {get; set;}
    global List<MCWrapper> ebConList {get; set;}
    global List<MCWrapper> updateConList {get; set;}
    global List<MCWrapper> interConList {get; set;}
    global Boolean onlyGLP {get;set;}
    global List<MCWrapper> intraConList {get; set;}
    global List<MCWrapper> sentryConList {get; set;}
    global List<MCWrapper> compLearnConList {get; set;}
    global List<MCWrapper> filingConList {get; set;}
    // Boolean variables for Tabs display
    global Boolean isTechContact {get; set;}
    global Boolean isClrPrimary {get; set;}
    global Boolean isPwdEmailCon {get; set;}
    global Boolean isPatronAccCon {get; set;}
    global Boolean isEbillityCon {get; set;}
    global Boolean isUpdateCon {get; set;}
    global Boolean isInterCon {get; set;}
    global Boolean isIntraCon {get; set;}
    global Boolean isSentryCon {get; set;}
    global Boolean isCompLearnCon {get; set;}
    global Boolean isFilingCon {get; set;}
    global Boolean isGLPProduct {get; set;} //GLP-5
    global Boolean isError = False;
    global Boolean strTabName {get; set;} //GLP-5
    global string techMaterials = '';
    global string clrMaterials = '';
    global string printMaterials = ''; //GLP-5
    global string pwdMaterials = '';
    global string patronMaterials = '';
    global string ebillMaterials = '';
    global string updateMaterials = '';
    global string interMaterials = '';
    global string intraMaterials = '';
    global string sentryMaterials = '';
    global string regIntMaterials = '';
    global string compLearnMaterials = '';
    global string filingMaterials = '';
    global ipWrapper clrIps {get; set;}
    global ipWrapper glpIps {get; set;} //GLP-5
    global ipWrapper patIps {get; set;}
    global string fromIP {get; set;}
    global string toIP {get; set;}
    global string fromIPac {get; set;}
    global string toIPac {get; set;} 
    
    // Constructor
    global MasterContactsController(ApexPages.StandardController stdCon) {
        setParametersForConstructor();
        // get the current page parameter - Id value
        proposalId = ApexPages.CurrentPage().getParameters().get('id').escapeHtml4();
        
        if(!string.isEmpty(proposalId)) {
            try {
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() 
                && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()) {
                   
                    aptProposal = [Select Id, Name, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.Name, APTS_SSD_Sold_To__r.LCRM_Sales_Org__c, APTS_SSD_Sold_To__r.LCRM_SAP_Account_Number__c , APTS_SSD_Sold_To__r.Source_System_Account_Number__c, APTS_Is_HighQ_Quote__c From Apttus_Proposal__Proposal__c Where Id =: proposalId];
                }
                system.debug('aptProposal...'+aptProposal);
                if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() 
                && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()) {
                   
                    apliList = [Select Id, Name, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Subscription_Number__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c,  Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name,Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c From Apttus_Proposal__Proposal_Line_Item__c Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed') Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last];    
                    if(Schema.sObjectType.Customer_Master_Contacts__c.isAccessible() 
                    && Schema.sObjectType.Customer_Master_Contacts__c.isQueryable()) {
                        
                        mstrConList = [SELECT Id, Contact_SDD__c, Contact__c, Customer_Type_Description__c, Email_Address__c, First_Name__c, Last_Name__c, To_IP_Address__c, To_IP_Address1__c, To_IP_Address2__c, From_IP_Address__c, From_IP_Address1__c, From_IP_Address2__c, Phone__c, Quote__c FROM Customer_Master_Contacts__c WHERE Quote__c = : proposalId];
                        //contactList = [Select Id, FirstName, LastName, Email, Phone, SAP_Role__c From Contact Where AccountId = :aptProposal.Apttus_Proposal__Account__c AND (SAP_Role__c != null AND SAP_Role__c != '')];
                        //system.debug('mstrConList...'+mstrConList);
                        if(Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible() 
                        && Schema.sObjectType.LCRM_Contact_SSD__c.isQueryable()) {
                            
                            contactssdList = [Select Id, LCRM_Contact__c, LCRM_Contact__r.FirstName, LCRM_Contact__r.LastName, LCRM_Contact__r.Email, LCRM_Contact__r.Phone, LCRM_SAP_Role__c From LCRM_Contact_SSD__c Where LCRM_Contact__r.AccountId = :aptProposal.Apttus_Proposal__Account__c AND (LCRM_SAP_Role__c != null AND LCRM_SAP_Role__c != '')];
                            system.debug('contactssdList...'+contactssdList);
                            returnAPIList(apliList);
                            // Identify the types products and set the flags to rendered the tabs
                            
                           //find the selected contacts by comparing with Master contacts
                           //system.debug('contactList ...'+contactList);
                           //for(Contact con :contactList) 
                           system.debug('apliIds ...'+apliIds);
                           system.debug('contactssdList ...'+contactssdList);
                           returnContactList(contactssdList);
                           // Assign the Master Contacts which contacts have Contact field is null
                           for(Customer_Master_Contacts__c mc :mstrConList) {
                               MCWrapper mcw = new MCWrapper();
                               //if(mc.Contact__c == null) 
                               if(mc.Contact_SDD__c == null) {
                                   mcAssigntoList(mc.Customer_Type_Description__c, mc);                       
                               }
                           }
                           system.debug('techConList...'+techConList);
                           // If list is empty assign blank row
                           MCWrapper mcw = new MCWrapper();
                           if(isTechContact) {                   
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'TECHNICAL CONTACT';
                               techConList.add(mcw);
                               mcw = new MCWrapper();
                               selectCB(techConList);
                           } 
                           if(isClrPrimary) {                   
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'CLEAR PRIMARY CONT';
                               clrPrimaryList.add(mcw);
                               mcw = new MCWrapper();
                               selectCB(clrPrimaryList);
                           } 
                           //Start: GLP-5
                           if (isGLPProduct) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'EML PSWD CONTACT';
                               glpPrimaryList.add(mcw);
                               mcw = new MCWrapper();
                               selectCB(glpPrimaryList);
                           }
                           //End
                           if(isPwdEmailCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'EML PSWD CONTACT';
                               pwdEmailList.add(mcw);
                               mcw = new MCWrapper();
                               selectCB(pwdEmailList);
                           } 
                           if(isPatronAccCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'PATRON ACC TECH CONT';
                               patronConList.add(mcw);
                               mcw = new MCWrapper();
                               selectCB(patronConList);
                           } 
                           if(isEbillityCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'ADMINISTRATOR';
                               ebConList.add(mcw);
                               selectCB(ebConList);
                           } 
                           if(isUpdateCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'SRR MEDIA CONTACT';
                               updateConList.add(mcw);
                               selectCB(updateConList);
                           } 
                           if(isInterCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c= 'PT INTER MEDIA CONT';
                               interConList.add(mcw);
                               selectCB(interConList);
                           } 
                           if(isIntraCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'PT INTRA MEDIA CONT';
                               intraConList.add(mcw);
                               selectCB(intraConList);
                           } 
                           if(isSentryCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'PT SENTRY MEDIA CONT';
                               sentryConList.add(mcw);
                               selectCB(sentryConList);
                           } 
                           if(isCompLearnCon) {
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'COMPLIANCE LEARNING';
                               compLearnConList.add(mcw);
                               selectCB(compLearnConList);
                           } 
                           if(isFilingCon){
                               mcw = new MCWrapper();
                               mcw.mstrCon.Customer_Type_Description__c = 'Filing Contact';
                               filingConList.add(mcw);
                               selectCB(filingConList);
                           }
                           system.debug('techConList...'+techConList);
                           system.debug('clrPrimaryList...'+clrPrimaryList);
                           system.debug('glpPrimaryList...'+glpPrimaryList);
                           system.debug('patronConList...'+patronConList);
                           system.debug('ebConList...'+ebConList);
                           system.debug('updateConList...'+updateConList);
                           system.debug('interConList...'+interConList);
                           system.debug('intraConList...'+intraConList);
                           system.debug('sentryConList...'+sentryConList);
                           system.debug('compLearnConList...'+compLearnConList);
                       }
                   }
               }
            }catch(Exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()+':'+ex.getLineNumber()+'<br/>'+ex.getStackTraceString()));               
            }
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Quote/Proposal'));               
        }
    }
    
    global void setParametersForConstructor() {
        apliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        apliIds = new Set<Id>();
        ipIdsMap = new Map<Id, string>(); 
        aptProposal = new Apttus_Proposal__Proposal__c();
        mstrConList = new List<Customer_Master_Contacts__c>();
        //contactList = new List<Contact>();
        contactssdList = new List<LCRM_Contact_SSD__c>();
        techConList = new List<MCWrapper>();
        clrPrimaryList = new List<MCWrapper>();
        glpPrimaryList = new List<MCWrapper>(); //GLP-5
        pwdEmailList = new List<MCWrapper>();
        patronConList = new List<MCWrapper>();
        ebConList = new List<MCWrapper>();
        updateConList = new List<MCWrapper>();
        onlyGLP = false;
        interConList = new List<MCWrapper>();
        intraConList = new List<MCWrapper>();
        sentryConList = new List<MCWrapper>();
        compLearnConList = new List<MCWrapper>();
        filingConList = new List<MCWrapper>();
        isTechContact = False;
        isClrPrimary = False;
        isGLPProduct = False; //GLP-5
        isPwdEmailCon = False;
        isPatronAccCon = False;
        isEbillityCon = False;
        isUpdateCon = false;
        isInterCon = false;
        isIntraCon = false;
        isSentryCon = false;
        isCompLearnCon = false;
        isFilingCon = false;
        clrIps = new ipWrapper();
        patIps = new ipWrapper();
        glpIps = new ipWrapper(); //GLP-5
        fromIP = '';
        toIP = '';
        fromIPac = '';
        toIPac = '';
    }
    
    global void returnAPIList(List<Apttus_Proposal__Proposal_Line_Item__c> apliList) {
        for(Apttus_Proposal__Proposal_Line_Item__c aplis :apliList) {
            if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' &&
            aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                onlyGLP = True;
            }
        }
        for(Apttus_Proposal__Proposal_Line_Item__c aplis :apliList) {
            if((!OnlineContactsController.validateProductLLCode((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c+aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP' ) {
                 if(aplis.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '064' && aplis.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c!=Label.SALESORGCAN) {
                     isTechContact = True;
                     apliIds.add(aplis.Id);
                     techMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 } 
                 if(aplis.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '076' && aplis.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c!=Label.SALESORGCAN) {
                     isClrPrimary = True;
                     apliIds.add(aplis.Id);
                     ipIdsMap.put(aplis.Id, 'Clear');
                      clrMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 //Start: GLP-5
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
                     && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                     isGLPProduct = True;
                     apliIds.add(aplis.Id);
                     ipIdsMap.put(aplis.Id, 'Print');
                     System.debug('##### isGLPProduct '+isGLPProduct );
                     printMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 //End GLP - 5
                //SOC-5488 Additional Conditions
                // if((!OnlineContactsController.validateProductLLCode((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c+aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP')
                if (onlyGLP) {
                    isPwdEmailCon = False;
                    isGLPProduct = True;    
                        
                    if((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06'     
                        && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='AB')     
                        || (aptProposal.APTS_Is_HighQ_Quote__c==0 &&    
                          (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06'  
                          || aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'    
                          || aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13'    
                          || aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='LW')   
                        && (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c != '13'     
                        || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13'     
                            && (aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NX'     
                            && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NT'  
                            && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NW'  
                            && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NZ'))))){    
                            if (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'     
                                && (aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'CQ' || 
                                aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == '')) {  
                                apliIds.add(aplis.Id);  
                                printMaterials += (aplis.Apttus_Proposal__Product__r.productCode +','); 
                            } else if (aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'CQ') {  
                                apliIds.add(aplis.Id);  
                                printMaterials += (aplis.Apttus_Proposal__Product__r.productCode +','); 
                            }   
                            system.debug('#### printMaterials '+printMaterials );   
                    }
                } else {
                  if(!onlyGLP && (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='AB') 
                    || (aptProposal.APTS_Is_HighQ_Quote__c==0 && 
                    (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' || aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' || aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13'|| aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='LW') 
                    && (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c != '13' || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && (aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NX' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NT' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NW' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c !='NZ'))))
                    ) {
                              isPwdEmailCon = True;
                              apliIds.add(aplis.Id);
                              pwdMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                         }
                 }
                 //SOC-5488 Additional Conditions
                 if(aplis.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c!=Label.SALESORGCAN &&((!string.isEmpty(aplis.Apttus_Proposal__Product__r.Name) && aplis.Apttus_Proposal__Product__r.Name.Contains('Patron Access'))  || aplis.Apttus_Proposal__Product__r.ProductCode == '41727130' || aplis.Apttus_Proposal__Product__r.Subscription_Number__c == '41727130' || aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c == 'L5_L1451_FP' || aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c == 'L5_L0064_FP'  || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c =='06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='LW'))) {
                      isPatronAccCon = True;
                     apliIds.add(aplis.Id);
                     ipIdsMap.put(aplis.Id, 'Patron');
                      patronMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 } 
                 if(aplis.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c!=Label.SALESORGCAN && (aplis.Apttus_Proposal__Product__r.ProductCode == '41409998' || aplis.Apttus_Proposal__Product__r.ProductCode== '41815778' ||
                     aplis.Apttus_Proposal__Product__r.Subscription_Number__c == '41409998' || aplis.Apttus_Proposal__Product__r.Subscription_Number__c == '41815778')) {
                     isEbillityCon = True;
                     apliIds.add(aplis.Id);
                     ebillMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '05' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='NZ') {
                     isUpdateCon = True;
                     apliIds.add(aplis.Id);
                     updateMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='NT') {
                     isInterCon = True;
                     apliIds.add(aplis.Id);
                     interMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='NX') {
                     isIntraCon = True;
                     apliIds.add(aplis.Id);
                     intraMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='NW') {
                     isSentryCon = True;
                     apliIds.add(aplis.Id);
                     sentryMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '05' && (aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='E9' || aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='' || aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c ==null)) {
                     isCompLearnCon = True;
                     apliIds.add(aplis.Id);
                     compLearnMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
                 if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && (aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='NX' || aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c =='NT')) {
                     isFilingCon = True;
                     apliIds.add(aplis.Id);
                     filingMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                 }
             }
        } 
    }
    
    global void returnContactList(List<LCRM_Contact_SSD__c> contactssdList) { 
        for(LCRM_Contact_SSD__c con :contactssdList) {
           Boolean isConFound = False;
           List<string> strList = new List<string>();                   
               if(!mstrConList.isEmpty()) {
                   for(Customer_Master_Contacts__c mc :mstrConList) {
                       //if(con.Id == mc.Contact__c) 
                       if(con.Id == mc.Contact_SDD__c) {
                           isConFound = True;                               
                           //strList = con.SAP_Role__c.split(';');
                           strList = con.LCRM_SAP_Role__c.split(';');
                           for(string str :strList) {
                               mcAssigntoList(str, mc);                                        
                           }
                       }                           
                   }
                   If(!isConFound) {
                       //mcListHelper(con.SAP_Role__c.split(';'), con);                          
                       mcListHelper(con.LCRM_SAP_Role__c.split(';'), con);                          
                   }
               }
               else {
                   //system.debug('con.SAP_Role__c...'+con.SAP_Role__c);
                   //mcListHelper(con.SAP_Role__c.split(';'), con);                     
                   system.debug('con.LCRM_SAP_Role__c...'+con.LCRM_SAP_Role__c);
                   mcListHelper(con.LCRM_SAP_Role__c.split(';'), con);                     
               }
               system.debug('strList...'+strList);
           }
       }
       
    
    // method to check the check box of records by default
    global void selectCB(List<MCWrapper> listMC) {
        Boolean isChecked = False;
        for(MCWrapper mcr :listMC) {
            If(mcr.isSelected == True) {
                isChecked = True;
                Break;
            }            
        }
        if(!isChecked) {
            for(MCWrapper mcr :listMC) {
                mcr.isSelected = True;
                Break;                
            }
        }
    }
    // helper method to assign the contact field to Master Contacts Fields.
    global Customer_Master_Contacts__c mcAssignHelper(LCRM_Contact_SSD__c con) {
        Customer_Master_Contacts__c mcCon = new  Customer_Master_Contacts__c();
        mcCon.First_Name__c = con.LCRM_Contact__r.FirstName;
        mcCon.Last_Name__c = con.LCRM_Contact__r.LastName;
        mcCon.Email_Address__c = con.LCRM_Contact__r.Email;
        mcCon.Phone__c = con.LCRM_Contact__r.Phone;
        mcCon.Contact__c = con.LCRM_Contact__c;
        mcCon.Contact_SDD__c = con.Id;
        mcCon.Quote__c = proposalId;  
        return mcCon;      
    }
    // helper method to assign the recs to list if existing contact is matched or new master contact is found
    global void mcAssigntoList(string str, Customer_Master_Contacts__c mc) {
        MCWrapper mcw = new MCWrapper();
        mcw.isSelected = True;
        mcw.mstrCon = mc;
        mcListUtil(mcw, str);
    }
    global void mcListUtil(MCWrapper mcw, string str) {
       if(str == 'TECHNICAL CONTACT' && isTechContact) {           
           techConList.add(mcw);                                         
       }
       if(str == 'CLEAR PRIMARY CONT' && isClrPrimary) { 
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address__c)) {
               clrIps.fromIp = mcw.mstrCon.From_IP_Address__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address__c)) {
               clrIps.toIp = mcw.mstrCon.To_IP_Address__c;
           } if(!string.isEmpty(mcw.mstrCon.From_IP_Address1__c)) {
               clrIps.fromIp1 = mcw.mstrCon.From_IP_Address1__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address1__c)) {
               clrIps.toIp1 = mcw.mstrCon.To_IP_Address1__c; 
           } if(!string.isEmpty(mcw.mstrCon.From_IP_Address2__c)) {
               clrIps.fromIp2 = mcw.mstrCon.From_IP_Address2__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address2__c)) {
               clrIps.toIp2 = mcw.mstrCon.To_IP_Address2__c;
           }               
           clrPrimaryList.add(mcw);                                         
       }
       //GLP-5
       if(str == 'EML PSWD CONTACT' && isGLPProduct) {
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address__c)) {
               glpIps.fromIp = mcw.mstrCon.From_IP_Address__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address__c)) {
               glpIps.toIp = mcw.mstrCon.To_IP_Address__c;
           } if(!string.isEmpty(mcw.mstrCon.From_IP_Address1__c)) {
               glpIps.fromIp1 = mcw.mstrCon.From_IP_Address1__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address1__c)) {
               glpIps.toIp1 = mcw.mstrCon.To_IP_Address1__c; 
           } if(!string.isEmpty(mcw.mstrCon.From_IP_Address2__c)) {
               glpIps.fromIp2 = mcw.mstrCon.From_IP_Address2__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address2__c)) {
               glpIps.toIp2 = mcw.mstrCon.To_IP_Address2__c;
           }              
           glpPrimaryList.add(mcw);                                         
       }
       if(str == 'EML PSWD CONTACT' && isPwdEmailCon) {        
           system.debug('##### mcw'+mcw);   
           pwdEmailList.add(mcw);                                         
       }
       if(str == 'PATRON ACC TECH CONT' && isPatronAccCon) {
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address__c)) {
               patIps.fromIp = mcw.mstrCon.From_IP_Address__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address__c)) {
               patIps.toIp = mcw.mstrCon.To_IP_Address__c;
           } if(!string.isEmpty(mcw.mstrCon.From_IP_Address1__c)) {
               patIps.fromIp1 = mcw.mstrCon.From_IP_Address1__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address1__c)) {
               patIps.toIp1 = mcw.mstrCon.To_IP_Address1__c; 
           } if(!string.isEmpty(mcw.mstrCon.From_IP_Address2__c)) {
               patIps.fromIp2 = mcw.mstrCon.From_IP_Address2__c;
           } if(!string.isEmpty(mcw.mstrCon.To_IP_Address2__c)) {
               patIps.toIp2 = mcw.mstrCon.To_IP_Address2__c;
           }              
           patronConList.add(mcw);                                         
       }
       mcListUtil1(mcw,str);
       
    }
    global void mcListUtil1(MCWrapper mcw, string str) {
        if(str == 'ADMINISTRATOR' && isEbillityCon) {           
           ebConList.add(mcw);                                         
       } 
       if(str.equalsIgnoreCase('SRR MEDIA CONTACT') && isUpdateCon) {           
           updateConList.add(mcw);                                         
       } 
       if(str.equalsIgnoreCase('PT INTER MEDIA CONT') && isInterCon) {           
           interConList.add(mcw);                                         
       } 
       if(str.equalsIgnoreCase('PT INTRA MEDIA CONT') && isIntraCon) {           
           intraConList.add(mcw);                                         
       } 
       if(str.equalsIgnoreCase('PT SENTRY MEDIA CONT') && isSentryCon) {           
           sentryConList.add(mcw);                                         
       } 
       if(str.equalsIgnoreCase('COMPLIANCE LEARNING') && isCompLearnCon) {           
           compLearnConList.add(mcw);                                         
       }
       if(str.equalsIgnoreCase('Filing Contact') && isFilingCon) {           
           filingConList.add(mcw);                                         
       }
    }
    
    // Helper method for assign the mc to list if existing contacts found and not selected by the user
    global void mcListHelper(List<string> strList, LCRM_Contact_SSD__c  con) {
        for(string str :strList) {
            MCWrapper mcwr = new MCWrapper();
            mcwr.mstrCon = mcAssignHelper(con);
            mcwr.mstrCon.Customer_Type_Description__c = str;
            mcListUtil(mcwr, str);           
       }
    }
    // Save button 
    global PageReference save() {
        Integer count = 0;
        Boolean isExceeded = False;
        string conType = '';
        Boolean isDataFill = False;
        isError = False;
        List<Customer_Master_Contacts__c> cmList = new List<Customer_Master_Contacts__c >();
        
        cmList .addAll(saveUtilValidations(techConList));
        cmList .addAll(saveUtilValidations(clrPrimaryList));
        cmList .addAll(saveUtilValidations(glpPrimaryList)); //GLP-5
        cmList .addAll(saveUtilValidations(pwdEmailList));
        cmList .addAll(saveUtilValidations(patronConList));
        cmList .addAll(saveUtilValidations(ebConList));
        cmList .addAll(saveUtilValidations(updateConList));
        cmList .addAll(saveUtilValidations(interConList));
        cmList .addAll(saveUtilValidations(intraConList));
        cmList .addAll(saveUtilValidations(sentryConList));
        cmList .addAll(saveUtilValidations(compLearnConList));
        cmList .addAll(saveUtilValidations(filingConList));
        system.debug('cmList...'+cmList);
        if(isError) {
            return null;
        }
        if(!Schema.sObjectType.Customer_Master_Contacts__c.isAccessible() 
        && !Schema.sObjectType.Customer_Master_Contacts__c.isdeletable()){
            return null;
        }
        if(!mstrConList.isEmpty()) {
            delete mstrConList;
        }
        if(!Schema.sObjectType.Customer_Master_Contacts__c.isAccessible() 
        && !Schema.sObjectType.Customer_Master_Contacts__c.isCreateable()){
            return null;
        }
        if(!cmList.isEmpty()) {
            insert cmList;
        }
        // update the line items with
        apliUpdList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        addLineItemIds(apliIds);        
        if(!Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() 
        && !Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isUpdateable()){
            return null;
        }
        if(!apliUpdList.isEmpty()) {
            update apliUpdList;
        }
        PageReference oPage = new PageReference('/'+proposalId);
        return oPage;
    }
    // method to check ip adderess flag assign for clear and Patron contacts on Line Items
    global void addLineItemIds(Set<Id> ids) {
        for(Id pId :ids) {
            Apttus_Proposal__Proposal_Line_Item__c apliRec = new Apttus_Proposal__Proposal_Line_Item__c(Id = pId, APTS_Master_Contacts_Validation__c = True);
            if(!ipIdsMap.isEmpty() && ipIdsMap.containsKey(pId)) {
                apliRec.IP_Address_Check__c = False;   
                if(ipIdsMap.get(pId) == 'Clear' && !string.isEmpty(clrIps.fromIp)) {            
                    apliRec.IP_Address_Check__c = True;   
                } else If(ipIdsMap.get(pId) == 'Patron' && !string.isEmpty(patIps.fromIp)) {
                    apliRec.IP_Address_Check__c = True;   
                } //Start: GLP- 5 
                else If(ipIdsMap.get(pId) == 'Print' && !string.isEmpty(glpIps.fromIp)) {
                    apliRec.IP_Address_Check__c = True;   
                }  
                //End GLP-5       
            } 
            apliUpdList.add(apliRec);
        }   
    }
    // Save validations method
    global List<Customer_Master_Contacts__c> saveUtilValidations(List<MCWrapper> mcList) {
        List<Customer_Master_Contacts__c> cmList1 = new List<Customer_Master_Contacts__c >();
        Integer count = 0;
        Boolean isExceeded = False;
        string conType = '';
        Boolean isDataFill = False;
        Boolean isvalidIP = True;
        Boolean glpiperror = false;// GLP-5
        system.debug('mclist >>'+mclist);
        for(MCWrapper mcw :mcList) {
            conType = mcw.mstrCon.Customer_Type_Description__c;
            
            if(mcw.isSelected == True) {   
                count +=1;                               
                system.debug('######## in'+isGLPProduct);
                if((!string.isEmpty(mcw.mstrCon.First_Name__c) && !string.isEmpty(mcw.mstrCon.Last_Name__c) && !string.isEmpty(mcw.mstrCon.Email_Address__c))
                ) {
                    isDataFill = True;
                    system.debug('######## in'+isGLPProduct);
                }
                // validate the Ip Addresses for CLEAR Primary & Patron Access Tech Contact
                if(conType == 'CLEAR PRIMARY CONT'){
                    
                    if(isvalidIP = validateIP(clrIps)) {    
                        mcw.mstrCon.From_IP_Address__c = clrIps.fromIP;
                        mcw.mstrCon.To_IP_Address__c =  clrIps.toIP;
                        mcw.mstrCon.From_IP_Address1__c = clrIps.fromIP1;
                        mcw.mstrCon.To_IP_Address1__c =  clrIps.toIP1;
                        mcw.mstrCon.From_IP_Address2__c = clrIps.fromIP2;
                        mcw.mstrCon.To_IP_Address2__c =  clrIps.toIP2;    
                    }                   
                }
                //Start: GLP-5
                if(conType == 'EML PSWD CONTACT'){
                    
                    if(isvalidIP = validateIP(glpIps)) {    
                        mcw.mstrCon.From_IP_Address__c = glpIps.fromIP;
                        mcw.mstrCon.To_IP_Address__c =  glpIps.toIP;
                        mcw.mstrCon.From_IP_Address1__c = glpIps.fromIP1;
                        mcw.mstrCon.To_IP_Address1__c =  glpIps.toIP1;
                        mcw.mstrCon.From_IP_Address2__c = glpIps.fromIP2;
                        mcw.mstrCon.To_IP_Address2__c =  glpIps.toIP2;    
                    }                   
                }
                //End 
                if(conType == 'PATRON ACC TECH CONT') {
                    if(isvalidIP = validateIP(patIps)) {    
                        mcw.mstrCon.From_IP_Address__c = patIps.fromIP;
                        mcw.mstrCon.To_IP_Address__c =  patIps.toIP;
                        mcw.mstrCon.From_IP_Address1__c = patIps.fromIP1;
                        mcw.mstrCon.To_IP_Address1__c =  patIps.toIP1;
                        mcw.mstrCon.From_IP_Address2__c = patIps.fromIP2;
                        mcw.mstrCon.To_IP_Address2__c =  patIps.toIP2;     
                    }  
                }
                cmList1.add(saveHelper(mcw.mstrCon));                
            }
            if(count > 1) {
                isExceeded = True;                
                break;    
            }
        }
        if(!mcList.isEmpty() && count == 0) {
            isError = True;
            glpiperror = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select one Contact for '+conType));
        }
        if(!isDataFill && count > 0) {
            isError = True;
            glpiperror = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill First Name , Last Name and Email of selected Contact for '+conType));
        }
        if(isExceeded) {
            isError = True;
            glpiperror = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select only one Contact for '+conType));
        }
        // GLP-5
        if(isGLPProduct && !mcList.isEmpty() && glpiperror == false && ((string.isEmpty(glpIps.fromIp) || string.isEmpty(glpIps.toIp)) && (string.isEmpty(glpIps.fromIp1) || string.isEmpty(glpIps.toIp1)) && (string.isEmpty(glpIps.fromIp2) || string.isEmpty(glpIps.toIp2)))){
            isError = True;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter an IP addresses '));
        }
        if(!isvalidIP) {
            isError = True;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter valid IP addresses '+conType));
        }
        return cmList1;
    }
    global Customer_Master_Contacts__c saveHelper(Customer_Master_Contacts__c mc) {
        Customer_Master_Contacts__c cmc = new Customer_Master_Contacts__c();
        cmc.First_Name__c = mc.First_Name__c;
        cmc.Last_Name__c = mc.Last_Name__c;
        cmc.Email_Address__c = mc.Email_Address__c;
        cmc.Quote__c = proposalId;
        cmc.Contact__c = mc.Contact__c;
        cmc.Contact_SDD__c = mc.Contact_SDD__c;
        cmc.Material__c = assignProductMaterials(mc.Customer_Type_Description__c);
        cmc.Customer_Type_Description__c = mc.Customer_Type_Description__c;
        cmc.From_IP_Address__c = mc.From_IP_Address__c;
        cmc.To_IP_Address__c = mc.To_IP_Address__c; 
        cmc.From_IP_Address1__c = mc.From_IP_Address1__c;
        cmc.To_IP_Address1__c = mc.To_IP_Address1__c;    
        cmc.From_IP_Address2__c = mc.From_IP_Address2__c;
        cmc.To_IP_Address2__c = mc.To_IP_Address2__c;       
        return cmc;
    }
    // asign the matirials based on the contact type.
    global string assignProductMaterials(string conType) {
        string materials = '';
        if(conType == 'TECHNICAL CONTACT') {           
           materials = techMaterials;                                       
       }
       else if(conType == 'CLEAR PRIMARY CONT') {           
           materials = clrMaterials;                                       
       } else if (conType == 'EML PSWD CONTACT' && isGLPProduct) { //GLP- 5
           materials = printMaterials; //GLP- 5
       }
       else if(conType  == 'EML PSWD CONTACT' && isPwdEmailCon ) {           
           materials = pwdMaterials;                                        
       }
       else if(conType == 'PATRON ACC TECH CONT') {           
           materials = patronMaterials;                                        
       }
       else if(conType == 'ADMINISTRATOR') {           
           materials = ebillMaterials;                                       
       } 
       else if(conType.equalsIgnoreCase('SRR MEDIA CONTACT')) {           
           materials = updateMaterials;                                       
       } 
       else if(conType.equalsIgnoreCase('PT INTER MEDIA CONT')) {           
           materials = interMaterials;                                       
       } 
       else if(conType.equalsIgnoreCase('PT INTRA MEDIA CONT')) {           
           materials = intraMaterials;                                       
       } 
       else if(conType.equalsIgnoreCase('PT SENTRY MEDIA CONT')) {           
           materials = sentryMaterials;                                       
       } 
       else if(conType.equalsIgnoreCase('COMPLIANCE LEARNING')) {           
           materials = compLearnMaterials;                                       
       } 
       else if(conType.equalsIgnoreCase('Filing Contact')) {           
           materials = filingMaterials;                                       
       } 
       return materials;
    }
    
    global Boolean validateIP(ipWrapper ipw) {
        Boolean isvalid = True;
        Boolean b1 = True;
        Boolean b2 = True;
        Boolean b3 = True;
        Boolean b4 = True;
        Boolean b5 = True;        
        Boolean b6 = True;
        if(!string.isEmpty(ipw.fromIp)) {
            b1 = validIP(ipw.fromIp); 
        } if(!string.isEmpty(ipw.toIp)) {
            b2 = validIP(ipw.toIp);
        } if(!string.isEmpty(ipw.fromIp1)) {
            b3 = validIP(ipw.fromIp1); 
        } if(!string.isEmpty(ipw.toIp1)) {
            b4 = validIP(ipw.toIp1);
        } if(!string.isEmpty(ipw.fromIp2)) {
            b5 = validIP(ipw.fromIp2); 
        } if(!string.isEmpty(ipw.toIp2)) {
            b6 = validIP(ipw.toIp2);
        } if(!b1 || !b2 || !b3 || !b4 || !b5 || !b6) {
            isvalid = False;    
        }
            
        return isvalid; 
    }
    
    // method to validate the Ip Addreess    
    global Boolean validIP(string ip) {
        boolean isValidIP = True;
        String reIP = '^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$'; 
        Pattern myPattern = Pattern.compile(reIP);        
        Matcher myMatcher = myPattern.matcher(ip);
        if(!myMatcher.matches()) {
            isValidIP = False;
            system.debug('invalid, do something...');
        }
        return isValidIP;
    }
    
    //Cance method
    global PageReference cancel() {
        PageReference oPage = new PageReference('/'+proposalId);
        return oPage;
    }
    // Wrapper Class
    global class MCWrapper {
        global Boolean isSelected {get; set;}
        global Customer_Master_Contacts__c mstrCon {get; set;}
        
        global MCWrapper() {
            isSelected = False;
            mstrCon = new Customer_Master_Contacts__c();
        }
    }
    // Wrapper class for IP Addresses'
    global class IPWrapper {
        global string fromIp {get; set;}
        global string toIp {get; set;}
        global string fromIp1 {get; set;}
        global string toIp1 {get; set;}
        global string fromIp2 {get; set;}
        global string toIp2 {get; set;}
        global ipWrapper(){
            fromIp = '';
            toIp = '';
            fromIp1 = '';
            toIp1 = '';
            fromIp2 = '';
            toIp2 = '';
        }
    } 
}