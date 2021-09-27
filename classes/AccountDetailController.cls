/**
* CHANGE HISTORY
* =========================================================================================================
* Date         Name                    Description
* 2011-12-19   Parthasarathy M         Created
* 2012-05-09   Srikanth Kuruva         Modified the SOQLs(on contacts) 
Added columns Job_Function__c, MailingCity, 
Work_Direct__c.
* 2012-08-30   Anshita Sharma          Added method 'getTrainingEvents' for QC 3207.
* 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1 
* 2017-06-21   Karthi G                Added condition for UKI Service users - UKD-40
* 2017-11-14   Kruthi Nadig            Added optimized code for 'Tax documents' related lists - MCL-1926   
* 2017-09-11   Rinesh Rajan            Added method 'online password' for CRM-6700 
* 2017-09-12   Noopur Rathod           Added Method 'incentivepassword()' for Custom Buttons section
* 2017-09-20   Noopur Rathod           Added Method 'credential()' for Custom Buttons section 
* 2017-10-10   Harsha Naik             Added  method  'getAccountTeamViews'for CRM 5               
* 2018-03-12   Seema Nagdev            Added changes for Account Team Member Related list(CRM-12987) 
* ==========================================================================================================
*/ 
public without sharing class AccountDetailController{
    //Protected Members
    private Account oAccount;  
    public integer OpportunityRowsToDisplay {get;set;}
    Public integer ContactRowsToDisplay{get;set;}
    public integer ActivityHistoryRowsToDisplay {get;set;}
    Public integer OpenActivityRowsToDisplay{get;set;}
    Public integer OnlineContactRowsToDisplay{get;set;}
    Public integer BusinessContactRowsToDisplay{get;set;}
    public integer AccountTeamRowsToDisplay{get;set;}
    public integer TrainingEvtRowsToDisplay {get;set;}
    public boolean IsMasterAccount {get;set;}
    public boolean showPage{get;set;}
    public String relListName{get;set;}
    /*public String ClassfieldId{get;set;}-- commented to reduce character for s2e optimization */
    public String contactClass{get;set;}
    public String AccountTeamview{get;set;}
    public string sUrl{get;set;}
    public List<Opportunity> MasterAccountOpportunities {get;set;}
    public List<Contact> MasterAccountContacts {get;set;}
    public List<openActivity> MasterAccountopenActivities {get;set;}
    public List<ActivityHistory> MasterAccountActivityHistories{get;set;}
    //public List<Contact> AccountOnlineContacts {get;set;} public List<Contact> AccountBusinessContacts {get;set;}
    public List<AccountTeamMember> listAccountTeamMembers {get;set;}
    public list<AccountTeamMember> ListAccountTeamvalues{get;set;}
    public List<Training_Event__c> MasterAccountTrainingEvents {get;set;}
    public String profileName;
    public Boolean bAccountTeam {get;set;}
    public string delRowId{get;set;}
    public boolean InConsoleView {get;set;}    
    public boolean GGOUser {get;set;}
    public boolean GLIServiceUser {get;set;}    
    public String butnVal{get;set;}
    public List<AccountDetailRelatedListView.DispAccTeamMemberWrapper> dispAccTeamlist{get; set;}   //Added for CRM-12987

  
  public list<Tax_Document__c> AccountTaxDocuments{get; set;} //MCL-1926
  public integer TaxDocumentsRowsToDisplay{get;set;} //MCL-1926 
    public boolean displayCredentialing{get;set;}
    public boolean displayOrders{get;set;}
    public boolean displaySubscription{get;set;}
    public boolean displayNonTrial{get;set;}
    public boolean displayServiceNotes{get;set;}
    public boolean displayToAdmin{get;set;}
    Public Boolean inLightning{get;set;}
    //Constructor

    
    /**
* Account Standard Controller Constructor
*
* @param oController  an instance of an ApexPages.StandardController for an Account
*/
    public AccountDetailController(ApexPages.StandardController oController){
  AccountTaxDocuments = new list<Tax_Document__c>(); //MCL-1926
        Datetime x =  Datetime.now();
        Integer m = x.millisecond();
        string profileID = UserInfo.getProfileID(); 
    ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
        String subbu= LCRMGenericComponent.getUserBU();
        /*System.debug('***time1' + m);-- commented to reduce character for s2e optimization */
        try {     
    
          List<GGO_Static_Values__mdt> GGOSV =[SELECT MasterLabel,GGO_Value__c from GGO_Static_Values__mdt];
        /* System.debug('GGOSV Is'+GGOSV); */
        Set<String> ProfileSet = new Set<String>();
        if(GGOSV.size()>0){
            for(GGO_Static_Values__mdt val: GGOSV){
                if(val.MasterLabel == 'Profiles'){
                    for(String temp:val.GGO_Value__c.split(';')){
                            ProfileSet.add(temp);
                        }
                }
             }
        }
        GGOUser =false;
        if(ProfileSet.contains(profileName)){
            GGOUser =true;
        }
        // UKD-40 --- START -------/
        GLIServiceUser = GLIGenericUtilityHelper.GLIServiceUserCheck();
        // UKD-40 --- END -------/
            bAccountTeam = false;
            List<PermissionsetAssignment> permissionset = [Select Id,AssigneeId,PermissionsetId from PermissionSetAssignment where AssigneeId=:userinfo.getuserid() and Permissionset.Name='Latam_Acc_Team'];       
            if(permissionset.size()>0){
                bAccountTeam = true;
            }
            if (Test.isRunningTest()) {
                oAccount= [select id, parentID,Name,OwnerId,Tax_Number__c from account where id =:oController.getRecord().id]; 
            }
            else{
                oController.addFields(new string[]{'Id', 'ParentId', 'Name','OwnerId'});               
                oAccount = (Account) oController.getRecord();
            }
            InConsoleView = AppUtil.getURLParam(ApexPages.currentPage(), 'isdtp', null) != null;      
    //MCL-1926
     TaxDocumentsRowsToDisplay =TrainingEvtRowsToDisplay =OpportunityRowsToDisplay =ActivityHistoryRowsToDisplay =OpenActivityRowsToDisplay= OnlineContactRowsToDisplay=BusinessContactRowsToDisplay= ContactRowsToDisplay=AccountTeamRowsToDisplay=5;      
            TrainingEvtRowsToDisplay =OpportunityRowsToDisplay =ActivityHistoryRowsToDisplay =OpenActivityRowsToDisplay= OnlineContactRowsToDisplay=BusinessContactRowsToDisplay= ContactRowsToDisplay=AccountTeamRowsToDisplay=5;      
            MasterAccountOpportunities = new list<opportunity>();        
            MasterAccountContacts =new list<contact>();
            MasterAccountopenActivities = new list<openActivity>();
            MasterAccountActivityHistories=new list<ActivityHistory>();      
            //  AccountBusinessContacts =new list<contact>();AccountOnlineContacts =new list<contact>();
            MasterAccountTrainingEvents =new list<Training_Event__c>();        
            //if (!InConsoleView) {
            IsMasterAccount = (oAccount.ParentId == null);
            /*if (IsMasterAccount) {
Set<Id> setAccountIds = getChildAccountIds(oAccount.Id);
MasterAccountOpportunities = getOpportunities(setAccountIds,50);        
MasterAccountContacts = getContacts(setAccountIds,50);
MasterAccountopenActivities = getOpenActivities(setAccountIds,50,true);
MasterAccountActivityHistories=getActivityHistories(setAccountIds,50,true);         
MasterAccountTrainingEvents = getTrainingEvents(setAccountIds,50);             
}*/       
            
            // AccountOnlineContacts = [SELECT   Id ,Name ,AccountId,Account.Name,LastName ,FirstName ,Title,Email, Phone,
            //                         Contact_type__c, SAP_Role__c, Job_Function__c, MailingCity, Work_Direct__c FROM contact WHERE Accountid =:oAccount.id and Class__c='ONLINE' limit 250];
            //   AccountBusinessContacts = [SELECT   Id ,Name ,AccountId,Account.Name,LastName ,FirstName ,Title,Email, Phone,
            //                          Contact_type__c, SAP_Role__c, Job_Function__c, MailingCity, Work_Direct__c FROM contact WHERE Accountid =:oAccount.id and Class__c='REGULAR' limit 250];
            ListAccountTeamvalues=new list<AccountTeamMember>();
            dispAccTeamlist = new List<AccountDetailRelatedListView.DispAccTeamMemberWrapper>();//Added for CRM-12987
            listAccountTeamMembers = [select id,userid,User.Rep_Type_Description__c,User.Name,User.Sub_Bu__c,User.Business_Unit__c, user.email,user.phone,TeamMemberRole,user.District__c from AccountTeamMember where Accountid =:oAccount.id order by User.Name limit 250];                       
            ListAccountTeamvalues.Addall(listAccountTeamMembers);
            dispAccTeamlist = AccountDetailRelatedListView.getTerrNum(ListAccountTeamvalues,oAccount.id);
            //}      
    AccountTaxDocuments = [Select id,Name,Tax_Document_Type__c,Tax_Document_Effective_Date__c from Tax_Document__c where Account__c=:oAccount.id and Tax_Document_Expiration_Date__c > TODAY]; //MCL-1926
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
        Datetime x1 =  Datetime.now();
        Integer m1 = x1.millisecond();
        /*System.debug('***time11' + m1);-- commented to reduce character for s2e optimization */
        
         List<LCRMMockupButton__c> lstbutton = LCRMMockupButton__c.getall().values(); 
         displayCredentialing = false;
         displayOrders = false;
         displaySubscription = false;
         displayNonTrial = false;
         displayServiceNotes = false;
         displayToAdmin = false;
         
         
         System.debug('lstbutton:-' +lstbutton);
         if(!lstbutton.isEmpty()){
            for(LCRMMockupButton__c val :lstbutton) {
                System.debug('Val:-'+val);
                System.debug('profileName:-'+profileName);
                System.debug('subbu:-'+subbu);
                Set<String> profileList = new Set<String>();
                Set<String> subBuList = new Set<String>();
                
                if(val.ProfileName__c != null && profileName !=null){
                    for(String tempProfile : val.ProfileName__c.split(';')){
                        profileList.add(tempProfile);
                    }
                }
                if(val.Sub_Bu__c != null & subbu !=null){
                    for(String tempSubbu : val.Sub_Bu__c.split(';')){
                        subBuList.add(tempSubbu);
                    }   
                }
                if(subbu!=null){
                    if(profileList.isEmpty() && !subBuList.isEmpty()){
                        if(subBuList.contains(subbu)){
                            if(val.Name == 'CredentialingButton' ){
                            displayCredentialing = true;
                            }
                            if(val.Name == 'NonTrialButton' ){
                                displayNonTrial = true;
                            }
                            if(val.Name == 'ServiceNotesButton'){
                                displayServiceNotes = true;
                            }
                            if(val.Name == 'OrdersButton' ){
                                displayOrders = true;
                            }
                            if(val.Name == 'SubscriptionButton'){
                                displaySubscription = true;
                            }
                        }
                    } 
                    else if(!profileList.isEmpty() && !subBuList.isEmpty()){
                        if(subBuList.contains(subbu)&& profileList.contains(profileName)){
                            if(val.Name == 'CredentialingButton' ){
                                displayCredentialing = true;
                            }
                            if(val.Name == 'NonTrialButton' ){
                                displayNonTrial = true;
                            }
                            if(val.Name == 'ServiceNotesButton'){
                                displayServiceNotes = true;
                            }
                            if(val.Name == 'OrdersButton' ){
                                displayOrders = true;
                            }
                            if(val.Name == 'SubscriptionButton'){
                                displaySubscription = true;
                            }
                        }
                    }
            
                }
                if(val.Name == 'Admin' && val.ProfileName__c ==  profileName){
                    displayToAdmin = true;
                }
            }
             
         }
    }
    
    // Added By harsha naik Filter condation base on SUb_BU Crm-5
    
    public list<selectoption> getAccountTeamViews(){
       List<SelectOption> options = new List<SelectOption>();
        String strName=Label.AccountTeamViewFilter;
        if(strName!=null && strName !=''){
            system.debug('@@strName' + strName);
           for(String lists:strName.split(',')){
               options.Add(new SelectOption(lists,lists));
           }
          }
      return options;
    }
    public void FliterAccountteam(){
        ListAccountTeamvalues.clear();  
        
        for(AccountTeamMember Listaccount :listAccountTeamMembers){
            if(Listaccount.User.Sub_Bu__c==AccountTeamview){
                ListAccountTeamvalues.add(Listaccount);
                }
               else{
             if(AccountTeamview =='ALL'){
                ListAccountTeamvalues.add(Listaccount);
                System.debug('@@@test1 :' + ListAccountTeamvalues);
                }                     
              }
        }
        dispAccTeamlist = AccountDetailRelatedListView.getTerrNum(ListAccountTeamvalues,oAccount.id); //Added for CRM-12987
     }  
    
    // Added By Priyanka For S2E Optimisation Start  
    public void getCusReltdLst(){
        IsMasterAccount = (oAccount.ParentId == null);
        if (IsMasterAccount) {
            Set<Id> setAccountIds = getChildAccountIds(oAccount.Id);
            MasterAccountOpportunities = getOpportunities(setAccountIds,50);        
            MasterAccountContacts = getContacts(setAccountIds,50);
            MasterAccountopenActivities = getOpenActivities(setAccountIds,50,true);
            MasterAccountActivityHistories=getActivityHistories(setAccountIds,50,true);         
            MasterAccountTrainingEvents = getTrainingEvents(setAccountIds,50);             
        }  
    }
    // Added By Priyanka For S2E Optimisation End 
    
    public PageReference onPageLoad(){
        PageReference oPageReference = null;
        inLightning = false;
        // String acctSharechild = '';
        try {        
            //ID idUsr = UserInfo.getUserId();
            //acctSharechild = apexpages.currentpage().getparameters().get('ShareAccChild');    
            //uncommented below if condition for DSS-8287        
            if(UserInfo.getUiThemeDisplayed() =='Theme4t' || UserInfo.getUiThemeDisplayed() =='Theme4d'||UserInfo.getUiThemeDisplayed() =='Theme4u')  {
                system.debug('lightning check'+inLightning);
                 inLightning = true;
             }
            profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
            if(( inLightning==true &&(profilename == 'TR Sales' ||profilename == 'TR Sales Ops'||profilename == 'TR Read Only'))||profileName == 'GLI Accountable Resolver Agent' || profileName == 'GLI Helpdesk Manager' || profileName == 'GLI Helpdesk Agent' || profileName == 'USL Helpdesk Agent' || profileName == 'USL Helpdesk Manager' || profileName == 'USL Hybrid Agent' || profilename == 'USL Accountable Resolver' || profilename == 'TR Helpdesk Agent' || profilename == 'TR Accountable Resolver' || profilename == 'TR Helpdesk Manager' || profilename == 'TR Hybrid Agent' ){
                 system.debug('lightning check'+inLightning);
                    PageReference nextPage = new PageReference('/' + OAccount.id);
                    nextPage.getParameters().put('nooverride', '1');
                    nextPage.setredirect(true);
                    return nextPage;
                }
            //if(profileName == 'Partner Portal User' && UserInfo.getUserID()!=oAccount.OwnerId){
                //List<Reservation__c> reservLst = [Select id, Start_Date__c, End_Date__c, Active__c,Partner_Portal_User__c,Account__c from Reservation__C where Account__c =: oAccount.id and Partner_Portal_User__c =: UserInfo.getUserID() ORDER By CreatedDate DESC];
                /*system.debug('reservLst : '+reservLst);-- commented to reduce character for s2e optimization */
                //if(!reservLst.isEmpty()){
                    /*if(reservLst[0].Active__c != true || reservLst[0].End_Date__c < System.today()){
//add error msg here and retrun
//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Insufficient Privileges: You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.');//Replaced with Custom Label as part of S2E Optimization
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.AccDetailCtlrApexMsg);
showPage = false;
ApexPages.addMessage(myMsg);
return null;
}
else{
}
*/
                    /*boolean active = false;
                    for(Reservation__c tempRes : reservLst){
                        if(tempRes.Active__c == true && tempRes.End_Date__c >= System.today()){
                            active = true;
                            break;
                        }
                    }
                    if(active != true){
                        //add error msg here and retrun
                        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Insufficient Privileges: You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.');//Replaced with Custom Label as part of S2E Optimization
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.AccDetailCtlrApexMsg);
                        showPage = false;
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                else{
                    //add error msg here saying no reservations available and return
                    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Insufficient Privileges: You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.');//Replaced with Custom Label as part of S2E Optimization
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.AccDetailCtlrApexMsg);
                    showPage = false;
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }*/
            else{
                /*if (InConsoleView == true) {
oPageReference = new PageReference('/' + oAccount.Id);
oPageReference.getParameters().putAll(ApexPages.currentPage().getParameters());
oPageReference.getParameters().put('nooverride', '1');
}*/
            }
            
            /*if(oAccount.Id != null && acctSharechild != 'true')
{
List <Opportunity> Opptys;
Opptys = [SELECT Id, Name FROM Opportunity WHERE AccountId = :oAccount.Id];
List<OpportunityShare> osharesExist = new List<OpportunityShare>([SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel  FROM OpportunityShare WHERE OpportunityId = :Opptys and UserOrGroupId =:idUsr and rowcause = 'manual']);

Database.DeleteResult[] dr; 
if (osharesExist.size() > 0){}               
dr = DataBase.delete(osharesExist);

// return null;
} */
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
            return oPageReference;
        }
        showPage = true;
        return oPageReference;
    }
    //Methods
    
    /**
* Retrieves a set of account ids for the specified master account id
*
* @param  masterAccountId  the account id to retrieve child account ids for
* @return  a set of account ids 
*/
    public static Set<Id> getChildAccountIds(Id masterAccountId){
        Set<Id> setChildAccountIds = new Set<Id>();
        Set<Id> setChildAccountIdstmp = new Set<Id>();
        setChildAccountIds.add(masterAccountId);
        setChildAccountIdstmp.add(masterAccountId);
        integer counter = 0;
        /*while (counter < 5) {
List<Account> listAccount = [SELECT Id FROM Account WHERE Id !=:masterAccountId AND ParentId != null AND ParentId IN :setChildAccountIds];

for (Account oAccount : listAccount) {
setChildAccountIds.add(oAccount.Id);
}
counter++;
}*/
        List<Account> listAccount = [SELECT Id FROM Account WHERE Id !=:masterAccountId AND ParentId != null AND ParentId IN :setChildAccountIdstmp];
        while (counter < 5){
            
            //System.debug('###listAccount' + counter + listAccount); 
            setChildAccountIdstmp = new Set<Id>();    
            if(listAccount.size() == 0 || listAccount.isEmpty()){
                break;
            } 
            else{
                for (Account oAccount : listAccount) {
                    setChildAccountIdstmp.add(oAccount.Id);
                } 
            } 
            //System.debug('###setChildAccountIdstmp' + counter + setChildAccountIdstmp);
            setChildAccountIds.addAll(setChildAccountIdstmp); 
            //System.debug('###setChildAccountIds' + counter + setChildAccountIds);    
            listAccount = new list<Account>();
            counter++;
        }
        return setChildAccountIds;
    }
    
    /**
* Retrieves a list of opportunity objects for the specified set of account ids
*
* @param  accountIds  a set of account ids
* @return  a list of opportunity objects 
*/
    public static List<Opportunity> getOpportunities(Set<Id> accountIds, Integer limitRows){
        return [SELECT Id,Name,AccountId,Account.Name,StageName,Amount,CloseDate FROM Opportunity WHERE AccountId IN :accountIds 
                ORDER By CloseDate DESC limit :limitRows ];
    }
    
    /**
* Retrieves a list of Contact objects for the specified set of account ids
*
* @param  accountIds  a set of account ids
* @return  a list of contact objects 
*/
    public static List<Contact> getContacts(Set<Id> accountIds, Integer limitRows){
        return [SELECT Id,Name
                ,AccountId,Account.Name,LastName,FirstName,Title,Email,Phone,Contact_type__c
                ,SAP_Role__c,Job_Function__c,MailingCity,Work_Direct__c FROM contact WHERE AccountId IN :accountIds ORDER By
                AccountId limit :limitRows];
    }
    
    /**
* Retrieves a list of OpenActivity objects for the specified set of account ids
*
* @param  accountIds  a set of account ids
* @return  a list of OpenActivity objects 
*/
    public static List<OpenActivity> getOpenActivities(Set<Id> accountIds,Integer limitRows,boolean bSort) {    
        List <Account> oAccount2 =[SELECT (SELECT Id,Subject,activitytype,who.name,WhoId,what.name,istask,WhatId,status,ownerId,owner.name,activitydate               
                                           FROM OpenActivities ORDER BY ActivityDate DESC, LastModifiedDate DESC) From ACcount WHERE Id IN :accountIds Limit 200];
        List<OpenActivity>  oOpenActivities = new List<OpenActivity>();
        List<OpenActivity>  oOpenActivities2 = new List<OpenActivity>();    
        for (Account a:oAccount2){
            if(a.OpenActivities.size()!=0){
                oOpenActivities.addall(a.OpenActivities);
                
            }       
        }
        if(oOpenActivities.size() != 0){
            if(bSort){
                oOpenActivities=GenericSort.sortList(oOpenActivities,'ActivityDate','desc');
            }       
            for(integer count = 0; count<limitRows && oOpenActivities.size()>count;count++){
                oOpenActivities2.add(oOpenActivities.get(count));
            }
        }   
        return oOpenActivities2;
    }
    
    /**
* Retrieves a list of ActivityHistory objects for the specified set of account ids
*
* @param  accountIds  a set of account ids
* @return  a list of ActivityHistory objects 
*/
    public static List<ActivityHistory> getActivityHistories(Set<Id> accountIds, Integer limitRows, boolean bSort) {    
        List <Account> oAccount2 =[SELECT (SELECT Id,Subject,activitytype,who.name,WhoId,what.name,istask,WhatId,status,ownerId,owner.name,activitydate               
                                           FROM ActivityHistories ORDER BY ActivityDate DESC, LastModifiedDate DESC) From ACcount WHERE Id IN :accountIds Limit 200];
        Integer count = 0;
        List<ActivityHistory>  oActivityHistories = new List<ActivityHistory>();
        List<ActivityHistory>  oActivityHistories2 = new List<ActivityHistory>();
        for (Account a:oAccount2){
            if(a.ActivityHistories.size()!=0){
                oActivityHistories.addall(a.ActivityHistories);
                count ++;
            }
        }
        if(oActivityHistories.size() != 0){
            if(bSort){
                oActivityHistories=GenericSort.sortList(oActivityHistories,'ActivityDate','desc');
            }
            for(integer count2 = 0; count2<limitRows && oActivityHistories.size()>count2;count2++){
                oActivityHistories2.add(oActivityHistories.get(count2));
            }
        }
        return oActivityHistories2;    
    }
    
    /**
* Retrieves a list of training events objects for the specified set of account ids
*
* @param  accountIds  a set of account ids
* @return  a list of training events object
*/
    public static List<Training_Event__c> getTrainingEvents(Set<Id> accountIds, Integer limitRows){
        return [SELECT Id,Name,Account__c,Account__r.Name,Training_Name__c,Training_Date__c,Training_Type__c,Status__c
                ,Number_of_Candidates__c,Number_Trained__c,Campaign_Name__c,Campaign_Name__r.Id,Campaign_Name__r.Name
                ,OwnerId,Owner.LastName,State__c,Account__r.BillingCity FROM Training_Event__c WHERE Account__c IN :accountIds
                ORDER By Training_Date__c DESC NULLS LAST limit :limitRows ];
    }
    
    /**
* Increases the related List size from where it was clicked
*   
* @return  Pagereference 
*/
    
    Public pagereference showMore(){
        if(relListName=='Contact'){
            contactRowsToDisplay=((masterAccountContacts.size()>2*contactRowsToDisplay)?2*contactRowsToDisplay:masterAccountContacts.size());
        }
        /*  if(relListName=='OnlineContact'){
OnlineContactRowsToDisplay=((AccountOnlineContacts.size()>2*OnlineContactRowsToDisplay)?2*OnlineContactRowsToDisplay:AccountOnlineContacts.size());
}
if(relListName=='BusinessContact'){
BusinessContactRowsToDisplay=((AccountBusinessContacts.size()>2*BusinessContactRowsToDisplay)?2*BusinessContactRowsToDisplay:AccountBusinessContacts.size());
}*/
        if(relListName=='Opportunity'){
            opportunityRowsToDisplay=((MasterAccountOpportunities .size()>2*opportunityRowsToDisplay)?2*opportunityRowsToDisplay:masterAccountOpportunities.size());
        }
        if(relListName=='OpenActivity'){
            OpenActivityRowsToDisplay=((MasterAccountOpenActivities .size()>2*OpenActivityRowsToDisplay)?2*OpenActivityRowsToDisplay:masterAccountOpenActivities.size());
        }
        if(relListName=='ActivityHistory'){
            ActivityHistoryRowsToDisplay=((MasterAccountActivityHistories .size()>2*ActivityHistoryRowsToDisplay)?2*ActivityHistoryRowsToDisplay:masterAccountActivityHistories.size());
        }
        if(relListName=='AccountTeam'){
           AccountTeamRowsToDisplay=((listAccountTeamMembers.size()>2*AccountTeamRowsToDisplay)?2*AccountTeamRowsToDisplay:listAccountTeamMembers.size());
            
        }
        if(relListName=='TrainingEvents'){
            trainingEvtRowsToDisplay=((MasterAccountTrainingEvents
                                       .size()>2*trainingEvtRowsToDisplay)?2*trainingEvtRowsToDisplay:masterAccountTrainingEvents.size());
        }
    
    if(relListName=='TaxDocuments'){
           TaxDocumentsRowsToDisplay=((AccountTaxDocuments.size()>2*TaxDocumentsRowsToDisplay)?2*TaxDocumentsRowsToDisplay:AccountTaxDocuments.size());
        } //MCL-1926
    
        return null;
    }
    
    /**
* Redirects to related list page
*   
* @return  Pagereference 
*/    
    Public pagereference goToList(){        
        PageReference pageRef = new PageReference('/apex/AccountDetailRelatedListView');      
        pageRef.getParameters().put('RelatedListName', relListName);
        pageRef.getParameters().put('id', oAccount.id);
        return pageRef;
    }  
    
    
    public pagereference addSalesTeam(){
        string retURL = ApexPages.currentPage().getURL();
        PageReference newOpportunityPageReference = new PageReference('/opp/salesteaminsert.jsp?');
        newOpportunityPageReference.getParameters().put('id',oAccount.id);      
        newOpportunityPageReference.getParameters().put('retURL', '/'+oAccount.Id); 
        return newOpportunityPageReference;
    }
    //Updated the method for CRM-12987
    public void deleteRow(){
        try{
            integer delIndex=-1;
            /*System.debug(delRowId +'******');-- commented to reduce character for s2e optimization */
            if(delRowId != null){
                for(integer counter = 0;counter<dispAccTeamlist.size();counter++){
                   // if(listAccountTeamMembers[counter].id==delRowId )
                       if(dispAccTeamlist[counter].teamid==delRowId )
                        delIndex= counter;
                }
                /*System.debug(delIndex+'%%%%%');-- commented to reduce character for s2e optimization */
                if(delIndex!=-1){                    
                    /**AccountTeamMember oMember = listAccountTeamMembers[delIndex];
                    delete oMember ;**/
                    AccountDetailRelatedListView.DispAccTeamMemberWrapper oMember = dispAccTeamlist[delIndex];
                    System.debug('oMember-->'+oMember.teamId);
                    delete [Select id from AccountTeamMember where id = :oMember.teamId] ;
                }
            }
        }
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }
        listAccountTeamMembers = [select id,userid,User.Rep_Type_Description__c, User.Name, user.email,TeamMemberRole from AccountTeamMember where Accountid =:oAccount.id order by User.Name limit 250];                   
    }     
    
    /* public pagereference NewContactEdit(){      
PageReference pageRef = new PageReference('/003/e');
string RetUrl='/apex/AccountDetail?id='+oAccount.id;      
pageRef.getParameters().put('retUrl',RetUrl);
pageRef.getParameters().put('cancelUrl',RetUrl);
pageRef.getParameters().put('saveUrl',RetUrl);
pageRef.getParameters().put('sfdc.override','1');
pageRef.getParameters().put(FieldIds__c.getValues('Class__c').Id__c,contactClass);
pageRef.getParameters().put(FieldIds__c.getValues('Account').Id__c,oAccount.Name); 
pageRef.getParameters().put(FieldIds__c.getValues('Account').Id__c+'_lkid',oAccount.id);
sUrl =  pageRef.getURL();     
return null;
}*/ 
    
    //function to redirect online password button
    
    
    public PageReference onlinepassword()
    {
        //String unameParam = ApexPages.currentPage().getParameters().get('Id');
        PageReference pr = new PageReference('/apex/AccountPasswords');
        pr.getParameters().put('id',oAccount.Id);
        pr.getParameters().put('retURL', '/'+oAccount.Id); 
        pr.setRedirect(true);
        
        return pr;
    }

    //Created for Mockup asked for Integration -Noopur (12th Sep 2017)
   public PageReference incentivepassword()
    {
        PageReference pageRef = new PageReference('/apex/IncentivePassword');
        pageRef.getParameters().put('id',oAccount.Id); 
        pageRef.setRedirect(true);
        
        return pageRef;
    }

//Created for CRM 6243 (Promo Password Functionality) 

    public PageReference promopassword()
    {
        
        PageReference promoref = new PageReference('/apex/PromoPassword');
        promoref.getParameters().put('id',oAccount.Id);
        promoref.getParameters().put('retURL', '/'+oAccount.Id); 
        promoref.setRedirect(true);
        
        return promoref;
    }
    
    //Created for Mockup asked for Integration -Noopur (20th Sep 2017)
    public PageReference credential()
    {
        PageReference pageRef = new PageReference('/apex/LCRMCredentialInfo');
        pageRef.getParameters().put('id',oAccount.Id); 
        pageRef.getParameters().put('retURL', '/'+oAccount.Id); 
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    
    
}