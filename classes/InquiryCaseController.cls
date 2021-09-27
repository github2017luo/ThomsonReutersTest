/*
======================================================================================================================
CLASS/ TRIGGER NAME:    InquiryCaseController

======================================================================================================================

PURPOSE:    Adding new functionalily to LEGACY CODE to populate accountid from account ssd when user redicts 
from OBIEE dashboard and create case.

CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
16-01-2018         Niket Kapasi      CRM - 11866                                      -
======================================================================================================================
*/ 

public class InquiryCaseController {
    private final ApexPages.StandardController standardController;
    //private final Case oCase;
    
    public case ocase {get;set;}
    //public string sProfile {get;set;}
    //public string sProfileid {get;set;}
    //public id IDProfile {get;set;}
    public id myAccountid {get;set;}
    public string sSapAcct {get;set;} 
    public string sUserRepType {get;set;} 
    //public string myprofilename {get;set;}
    //public string myprofileid {get;set;}
    public Attachment attachment{get; set;}
    public string RegionalManager{get; set;}
    public string parentRecId;
    
    public list<user> UserRM = new list<User>();
    public list<user> RMIds = new list<user>();
    public map<string, RecordType> caseRecordTypes = new map<string, RecordType>();
    
    // Case Team Members change for add
    /* public string cTMFile{get;set;}
public Blob cTMName{get;set;}
public List<CaseTeamMember> ctmList {get; set;} */
    
    public string strUserSubBU{get;set;}//Variable to store loggedin user SubBu
    public String LCRMprofileName{get;set;}//Variable to store the profile name based on user profile Id
    
    
    public InquiryCaseController(ApexPages.StandardController controller) {
        standardcontroller = controller;  
        attachment = new Attachment();  
        ocase = (case)controller.getRecord();     
        ocase.doc_number__c = AppUtil.getURLParam(ApexPages.currentPage(), 'DocNum', ''); //PageReference, UrlParamKey, Default Value
        ocase.Line_item_number__c = AppUtil.getURLParam(ApexPages.currentPage(), 'LineNum', ''); //PageReference, UrlParamKey, Default Value
        ocase.SYM__c = AppUtil.getURLParam(ApexPages.currentPage(), 'SYM', ''); //PageReference, UrlParamKey, Default Value
        ocase.Revenue__c = decimal.valueof(AppUtil.getURLParam(ApexPages.currentPage(), 'Rev', '0').remove(','));

        ocase.Compensation_Amount__c = decimal.valueof(AppUtil.getURLParam(ApexPages.currentPage(), 'CompAmt', '0').remove(',')); //PageReference, UrlParamKey, Default Value
        //ocase.Rep_Type__c = AppUtil.getURLParam(ApexPages.currentPage(), 'RepType', ''); //PageReference, UrlParamKey, Default Value
        ocase.Material_Number__c = AppUtil.getURLParam(ApexPages.currentPage(), 'MatNum', ''); //PageReference, UrlParamKey, Default Value
        ocase.Material_Description__c = AppUtil.getURLParam(ApexPages.currentPage(), 'MatDesc', ''); //PageReference, UrlParamKey, Default Value
        ocase.Payee_Number__c = AppUtil.getURLParam(ApexPages.currentPage(), 'PayeeNum', ''); //PageReference, UrlParamKey, Default Value
        ocase.Payee_ID__c = AppUtil.getURLParam(ApexPages.currentPage(), 'PayeeID', ''); //PageReference, UrlParamKey, Default Value
        ocase.Payee_Type__c = AppUtil.getURLParam(ApexPages.currentPage(), 'PayeeType', ''); //PageReference, UrlParamKey, Default Value
        ocase.Period__c = AppUtil.getURLParam(ApexPages.currentPage(), 'Period', ''); //PageReference, UrlParamKey, Default Value
        //ocase.Compensation_Amount__c = decimal.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'CompAmt', '0'));
        ocase.Territory__c = AppUtil.getURLParam(ApexPages.currentPage(), 'Territory', ''); //PageReference, UrlParamKey, Default Value
        ocase.ESC_ASYM__c = AppUtil.getURLParam(ApexPages.currentPage(), 'ASYM', ''); //PageReference, UrlParamKey, Default Value
        ocase.ESC_Customer_Number__c = AppUtil.getURLParam(ApexPages.currentPage(), 'CustNumber', ''); //PageReference, UrlParamKey, Default Value
        ocase.ESC_Opp_ID__c = AppUtil.getURLParam(ApexPages.currentPage(), 'Oppid', ''); //PageReference, UrlParamKey, Default Value
        ocase.ESC_GSI_Order_Source__c = AppUtil.getURLParam(ApexPages.currentPage(), 'OrdSource', ''); //PageReference, UrlParamKey, Default Value
        //oCase.Compensation_Amount__c = decimal.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'CompAmt', '0'));
        
        ocase.Salesperson__c = UserInfo.getUserId();
        ocase.OwnerId = UserInfo.getUserId();
        ocase.Status = 'Open';
        ocase.Origin = 'Web';
        
        
        id profileId = userinfo.getProfileId();
        Profile pObj = [select Name from profile where id = :profileId];
        LCRMprofileName= pObj.Name;
        
        KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMSubBuValues');//Gets the SUBBU value from KeyValueListStore__c custom settings
        String tempSubBuValues = tempObj.TextValue__c;
        KeyValueListStore__c tempProfileObj = KeyValueListStore__c.getInstance('LCRMGLIProfileNames');//Gets the profile name value from KeyValueListStore__c custom settings
        String tempProfileValues = tempProfileObj.TextValue__c;
        
        strUserSubBU = LCRMGenericComponent.getUserBU(); 
        
     
        for(RecordType caseRecType : [SELECT Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'case']) {
            caseRecordTypes.put(caseRecType.Name, caseRecType);
        }    
        
        List<Profile> Profilename = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(Profilename.size() > 0) {        
            
            if(Profilename[0].Name == 'TR Legal FindLaw User' ||
               Profilename[0].Name == 'TR Legal FindLaw Advanced Lead Mgmt' ||
               ((String.isNotEmpty(tempProfileValues) &&  String.isNotBlank(tempProfileValues) &&
                  String.isNotBlank(LCRMprofileName) && String.isNotEmpty(LCRMprofileName) &&
                 tempProfileValues.contains(LCRMprofileName) &&                 
                 (LCRMprofileName == 'GLI Sales User' || LCRMprofileName == 'GLI Sales Ops User')) &&
                ( String.isNotEmpty(tempSubBuValues) && String.isNotBlank(tempSubBuValues) && 
                  String.isNotBlank(strUserSubBU) && String.isNotEmpty(strUserSubBU) &&
                 tempSubBuValues.contains(strUserSubBU) &&                 
                 strUserSubBU == 'FindLaw' )) 
              ){
                  ocase.RecordTypeId = caseRecordTypes.get(System.Label.Case_Record_Type_Findlaw_Inquiry).Id; 
              }
            else {
                ocase.RecordTypeId = caseRecordTypes.get(System.Label.Case_Record_Type_SCS_Inquiry).Id;
            }    
        }  
        
        //R4 Change
        
        /*id profileId = userinfo.getProfileId();
Profile pObj = [select Name from profile where id = :profileId];
LCRMprofileName= pObj.Name;

KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMSubBuValues');//Gets the SUBBU value from KeyValueListStore__c custom settings
String tempSubBuValues = tempObj.TextValue__c;
KeyValueListStore__c tempProfileObj = KeyValueListStore__c.getInstance('LCRMGLIProfileNames');//Gets the profile name value from KeyValueListStore__c custom settings
String tempProfileValues = tempProfileObj.TextValue__c;

strUserSubBU = LCRMGenericComponent.getUserBU(); */        
        
        // set the Account from the parameter
        sSapAcct = Apputil.getURLParam(apexpages.currentpage(),'SAPAcct', null);
        system.debug('sSapAcct '+sSapAcct );
        if (sSapacct != NULL) {
            /*List<Account> ListAccount = [SELECT Id, Name FROM Account WHERE SAPAccountNumber__c=:sSapacct LIMIT 1];
if(ListAccount.size() > 0)
myAccountid = string.valueof(ListAccount[0].id);
ocase.accountid = myAccountid;*/
            if (String.isNotEmpty(tempProfileValues) && String.isNotBlank(tempProfileValues) && tempProfileValues.contains(LCRMprofileName)){
                
                //uslCheck = true;
                //Desc@@: The loop checks if strUserSubBU is 'USL' OR 'LMS' OR 'FindLaw'
                if(String.isNotEmpty(tempSubBuValues) && String.isNotBlank(tempSubBuValues) && tempSubBuValues.contains(strUserSubBU)){
                    
                    List<Source_System_Detail__c> ssdRecord = [Select id,Source_System_Account_Number__c,Account_Name__c  FROM Source_System_Detail__c WHERE Source_System_Account_Number__c =:sSapacct];     
                    if(!ssdRecord.isEmpty())
                        myAccountid = string.valueof(ssdRecord[0].Account_Name__c);
                    ocase.accountid = myAccountid;
                    
                    
                }  
            }
            else{
                List<Account> ListAccount = [SELECT Id, Name FROM Account WHERE SAPAccountNumber__c=:sSapacct LIMIT 1];
                if(ListAccount.size() > 0)
                    myAccountid = string.valueof(ListAccount[0].id);
                ocase.accountid = myAccountid;
            }
            
        }
        // Logic for populating the Account Name if the page is calling from List buttons.
        else {               
            ocase.accountid = ApexPages.currentPage().getParameters().get('def_account_id');  
            // To associate the case with Contact/Opportunity 
            if(ApexPages.currentPage().getParameters().get('retURL') != null)
                parentRecId = ApexPages.currentPage().getParameters().get('retURL').substring(1);          
        }
        
        
        system.debug('parent rec..'+parentRecId);    
        // Populate the Regional Manager
        userRM = [select Regional_Mgr__c, Sales_Org__c,Sub_Bu__c,Segment__c,Default_Catalog__c,Rep_Type_Description__c from user where Id=:UserInfo.getUserId() limit 1];
        if(userRM.size() > 0 ){
            ocase.Sales_Org__c= userRM[0].Sales_Org__c;
            ocase.LCRM_Sub_BU__c = userRM[0].Sub_Bu__c;
            ocase.BU_Segment__c = userRM[0].Segment__c;
            ocase.ESC_Default_Catalog__c = userRM[0].Default_Catalog__c;
            
            sUserReptype= userrm[0].Rep_Type_Description__c;
            if(userRm[0].Regional_Mgr__c!= NULL && userRm[0].Regional_Mgr__c!='UNASSIGNED') {
                RegionalManager = userRM[0].Regional_Mgr__c;
                
                string[] RegionalManager1 =RegionalManager.split(', ');
                if(RegionalManager1.size()==2){
                    RegionalManager = RegionalManager1[1]+' '+ RegionalManager1[0];
                }
                if(RegionalManager1.size()==1){
                    RegionalManager = RegionalManager1[0];
                }                       
                
                RMIds = [SELECT Id FROM User WHERE Name =:RegionalManager];
                if(RMIds.size() > 0)    
                    ocase.Regional_Manager_lkp__c = RMIds[0].id;
            }  
        } 
        /* CaseTeamMember ctm = new CaseTeamMember();
ctmList = new List<CaseTeamMember>();
ctmlist.add(ctm); */
        
    }
    
    public PageReference Save() {
        //this.SkipAddressCleanse = true;
        //return save();
        PageReference oPageReference = null;
        Id caseTeamSalesRoleId = [SELECT Id,Name FROM CaseTeamRole WHERE Name ='Sales'].Id;
        try {
            system.debug('in save' );
            //ApexPages.addMessages("in save");
            //Validate Address
            
            if(parentRecId != null && parentRecId.substring(0, 3) == '006'){
                oCase.Opportunity__c = parentRecId;
                system.debug('Opp Id..'+oCase.Opportunity__c);
            }
            else if(parentRecId != null && parentRecId.substring(0, 3) == '003'){
                oCase.ContactId = parentRecId;
                system.debug('Contact Id..'+oCase.ContactId );
            }
            ocase.ESC_GSI_Salesperson_Email__c = [select id,name,email from user where id=:ocase.Salesperson__c].email;
            //insert oCase;
            if(ocase.CaseType__c != 'KS Inquiry'){
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            //dmo.assignmentRuleHeader.assignmentRuleID='01Q180000000E3AEAU';
            oCase.setOptions(dmo);
            }
            insert oCase; 
            
            if((attachment.Name != null && attachment.Name != '')) {
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId = oCase.id; 
                // Inserting an Attachment with Case.    
                insert attachment;
            }
            /* Case Team Members changes for csv file
system.debug('Blob...'+cTMName);
if(cTMName != null && cTmName.size() > 0 && (cTMFile != null && cTMFile != '')  ) {
List<CaseTeamMember> caseTeamMbr = new List<CaseTeamMember>();
List<User> userList = new List<User>();
list<string> cTMNames = new list<string>();
list<string> inputvalues = new list<string>();
cTmFile = cTmName.toString();
system.debug('cTM name...'+cTmFile);
cTMNames = cTmFile.split('\n');
system.debug('cTM names...'+cTMNames);
for (Integer i=0;i<cTMNames.size();i++)
{
inputvalues.add(cTMNames[i].trim());
}
system.debug('inputvalues ...'+inputvalues);
if(cTMNames.size() >0) {

userList = [select Id, Name from user where Name In :inputvalues];
system.debug('cTM users...'+userList);
}
if(userList.size()> 0){

for(User usr :userList ) {
CaseTeamMember ctMbr = new CaseTeamMember();
ctMbr.ParentId = oCase.Id;
ctMbr.MemberId = usr.Id;
ctMbr.TeamRoleId = caseTeamSalesRoleId;
caseTeamMbr.add(ctMbr);
}
}
if(caseTeamMbr.size() > 0) {
insert caseTeamMbr;
}          
} */
            // Case Team changes end csv file
            // changes for case team
            /* if(ctmList.size() > 0) {
for(integer i = 0; i<ctmList.size(); i++) {
ctmList[i].ParentId = oCase.Id;
ctmList[i].TeamRoleId = caseTeamSalesRoleId;
}
system.debug('ctm List..'+ctmList);
insert ctmList;
} */
            
            oPageReference= new Pagereference('/' +oCase.Id);           
            oPageReference.setRedirect(true);
            system.debug('pagereference ='  + oPageReference);
        }
        
        catch (Exception unknownException) {
            ApexPages.addMessages(unknownException);
        }
        
        return oPageReference;
    }
    
    //changes for case team member
    /*    public void caseTeamMemberAdd() {
CaseTeamMember ctm1 = new CaseTeamMember();
ctmList.add(ctm1);
} */
    
    public PageReference route(){
        
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosById();
        
        PageReference oPageReference = null;
        //String Rec = Schema.SObjectType.ocase.getRecordTypeInfosByName().get('SCS_Inquiry').getRecordTypeId();
        if(rtMap.get(ocase.RecordTypeId).getName() == 'ANZ'){
            oPageReference = new PageReference('/objstandardedit?override=1');
            
        }
        if(rtMap.get(ocase.RecordTypeId).getName() == 'Findlaw Inquiry' || rtMap.get(ocase.RecordTypeId).getName() == 'SCS Inquiry'){
            oPageReference = new PageReference('/apex/inquirycase');
            
        }
        
        return oPageReference;
    }   
    
    //public PageReference cancel() {
    //this.Redirect = true;
    //standardcontroller.cancel();
    //return null;
    
    //}
    
    
}