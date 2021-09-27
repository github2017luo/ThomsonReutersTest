/*
======================================================================================================================
CLASS NAME:    OpportunityDetailController 
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-28        Priyanka Kar           Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class  OpportunityDetailController {
    public list<OpportunityTeamMember> listSalesTeamMember{get;set;}
    public string delRowId{get;set;}
    private opportunity oOpportunity ;
    public Id AccountId{get;set;}
    public boolean showPage{get;set;}
  /*public list<Case> listCases{get;set;}
  public list<SFDC_Strategy2Oppty__c> listStrtgy{get;set;}
  public integer CaseRowsToDisplay{get;set;}
  public integer StrgyRowsToDisplay{get;set;}
  public RecordtypeIds__c recId;
  public String rId;
  public Boolean isPO{get;set;}
  public Boolean isLatAmSalesOrg{get;set;}
   public String oSalesOrg{get;set;} 
    public integer rowsToDisplay{get;set;}
    public boolean bEditAccess{get;set;}*/
    public boolean InConsoleView {get;set;}
    public boolean isCustomerError{get;set;}
    public boolean isQuoteError{get;set;}
	public User usr;
    public Account acc;
    public Opportunity opp;
    public date expDate;
    public string expDateStr;
    
    /*constructor*/
    public OpportunityDetailController(ApexPages.StandardController controller){
        oOpportunity = (opportunity) Controller.getRecord();
        AccountId = oOpportunity.AccountId = [select AccountId from Opportunity where id = :oOpportunity.Id].AccountId;
       /*  // rowsToDisplay = 5;
       // InConsoleView = AppUtil.getURLParam(ApexPages.currentPage(), 'isdtp', null) != null;
      listSalesTeamMember =getlistSalesTeamMember();    
       // listCases = new List<Case>();       
        bEditAccess= [SELECT HasEditAccess,RecordId 
                        FROM UserRecordAccess
                        WHERE UserId =: UserInfo.getUserId() AND RecordId=:oOpportunity.Id].HasEditAccess;
       // CaseRowsToDisplay = 5;
        if(AccountId!=null){
            listCases = [SELECT Id, CaseNumber, Opportunity__r.Name, ContactId, Subject, Priority, CreatedDate, Status, OwnerId  FROM Case where AccountId = :oOpportunity.AccountId  limit 50];
        }        
       /* recId = RecordtypeIds__c.getValues('Pipeline Opportunities'); 
        if(recId !=null)
            if(oOpportunity.RecordTypeId != recId.recTypeId__c)
                isPO = false;
            else
                isPO = true;    
        listStrtgy = new list<SFDC_Strategy2Oppty__c>();
        StrgyRowsToDisplay =5;
        listStrtgy = [SELECT  Opportunity_Name__r.RecordTypeId, SFDC_Strategy__c, SFDC_Strategy__r.Name, SFDC_Strategy__r.Strategy_Status__c, SFDC_Strategy__r.CreatedDate,SFDC_Strategy__r.SFDC_Acct_Plan__r.Name, SFDC_Strategy__r.SFDC_Acct_Plan__r.Id, SFDC_Strategy__r.Id FROM SFDC_Strategy2Oppty__c where Opportunity_Name__c = :oOpportunity.Id];
        */
        Decimal accErrorCounter = [Select Account_Error_Counter__c from Account where id=:AccountId].Account_Error_Counter__c;
        if(accErrorCounter >0)
            isCustomerError = true;
        else
            isCustomerError = false;  
        List<Quote> oQuote = [Select Quote_Error_Counter__c from Quote where OpportunityId =:oOpportunity.id];
        if(!oQuote.isEmpty()){
            Decimal quoteErrorCounter = oQuote[0].Quote_Error_Counter__c ;
            if(quoteErrorCounter >0)
                isQuoteError = true;
            else
                isQuoteError = false;    
        }
     /*added for custom new case functionality 
       oSalesOrg = [Select id, Sales_Org__c from User WHERE id=: UserInfo.getUserId()].Sales_Org__c;
        if(oSalesOrg == 'ABEP' || oSalesOrg == 'BEJE'||oSalesOrg == 'EDIC'||oSalesOrg == 'FSCO'||oSalesOrg == 'LJUU'||oSalesOrg == 'LLEY'||oSalesOrg == 'LLPA'||oSalesOrg == 'LPCL' ||oSalesOrg == 'LPTC'||oSalesOrg == 'RV01'||oSalesOrg == 'TSL'||oSalesOrg == 'SMHK'||oSalesOrg == 'LRA'||oSalesOrg == 'BKRS')
            isLatAmSalesOrg = true;
        else
            isLatAmSalesOrg = false;    */
	
	// MCL-1926
    usr = [Select Id,profile.name from User where id=:UserInfo.getUserId()];
    acc = [Select Id,Tax_Document_Expiration_Date__c from Account where id=:AccountId];
    opp = [Select Stagename from Opportunity where Id=: oOpportunity.id];
    system.debug('stage..'+opp.StageName);
    if(acc.Tax_Document_Expiration_Date__c != NULL){
        if(System.today() >= (acc.Tax_Document_Expiration_Date__c - 30) && (usr.profile.name == 'LatAm User' || usr.profile.name == 'Partner Portal User') && (System.today() < acc.Tax_Document_Expiration_Date__c) && opp.StageName >= '75%'){
       
           System.debug('inside if');
           expDate = date.newinstance(acc.Tax_Document_Expiration_Date__c.year(),acc.Tax_Document_Expiration_Date__c.month(),acc.Tax_Document_Expiration_Date__c.day());
           expDateStr = String.valueof(acc.Tax_Document_Expiration_Date__c);
          // isTaxError = true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Your Tax Documents will expire on: '+expDateStr));
         }
              }
              
    }    
   /* Public void showMore(){
        RowsToDisplay=((listSalesTeamMember.size()>2*RowsToDisplay)?2*RowsToDisplay:listSalesTeamMember.size());
    }
    Public void showMoreCases()
    {
        CaseRowsToDisplay=((listCases.size()>2*CaseRowsToDisplay)?2*CaseRowsToDisplay:listCases.size());
    } 
  /*  Public void showMoreStrgy()
    {
        StrgyRowsToDisplay=((listStrtgy.size()>2*RowsToDisplay)?2*RowsToDisplay:listStrtgy.size());
    } */
    
    Public pagereference goToList(){        
        PageReference pageRef = new PageReference('/apex/OpportunityRelatedListView');        
        pageRef.getParameters().put('id', oOpportunity.id);
        return pageRef;
    }  
    public pagereference addSalesTeam(){
        string retURL = ApexPages.currentPage().getURL();
        PageReference newOpportunityPageReference = new PageReference('/apex/OpportunityTeamUserLookup');
        newOpportunityPageReference.getParameters().put('opportunityid',oOpportunity .id);
        newOpportunityPageReference.getParameters().put('accountid',oOpportunity .accountid);
        newOpportunityPageReference.getParameters().put('retURL', retURL); 
        return newOpportunityPageReference;
    }
    
    public pagereference addToSalesTeam()
    {
        OpportunityUtil opptyUtil = new OpportunityUtil();
        opptyUtil.callAddToSalesTeam();
        String opportunityId = ApexPages.currentPage().getparameters().get('id');
        PageReference pageReference = new PageReference('/' + opportunityId);
         pageReference.getParameters().put('retURL', '/' + opportunityId);
         return pageReference;
    }
    
    
    public void deleteRow(){
        try{
            integer delIndex=-1;/*System.debug(delRowId +'******');-- commented to reduce character limit for s2e optimization */
            if(delRowId != null){
                for(integer counter = 0;counter<listSalesTeamMember.size();counter++){
                    if(listSalesTeamMember[counter].id==delRowId )
                       delIndex= counter;
                }/* System.debug(delIndex+'%%%%%');-- commented to reduce character limit for s2e optimization */
                if(delIndex!=-1){                    
                    OpportunityTeamMember oMember = listSalesTeamMember[delIndex];                    
                    deleteShares(new OpportunityTeamMember[]{oMember});                    
                    delete oMember ;                                                                
                }
            }
        }
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }
        listSalesTeamMember =getlistSalesTeamMember();
    } 
    public void deleteAllRow(){
        try{ 
            if(listSalesTeamMember.size() == 250){
              listSalesTeamMember = [Select UserId,User.Rep_Type_Description__c, User.Phone, User.Email, User.Name,OpportunityId, Id
                                        From OpportunityTeamMember where OpportunityId=:oOpportunity.id];
            }
            deleteShares(listSalesTeamMember);
            delete listSalesTeamMember;            
        }
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }
        listSalesTeamMember =getlistSalesTeamMember(); 
    }
    private list<OpportunityTeamMember> getlistSalesTeamMember(){
        return [Select UserId,User.Rep_Type_Description__c, User.Phone, User.Email, User.Name,OpportunityId, Id From OpportunityTeamMember 
                  where OpportunityId=:oOpportunity.id Order by User.Name Limit 250 ];
    }               

    private void deleteShares(list<OpportunityTeamMember> TeamMembers){
        List<id> userIds = new List<id>();
        for(OpportunityTeamMember TeamMember:TeamMembers){
            if(TeamMember.userId != oOpportunity.ownerid){ 
                userIds.add(TeamMember.userId);
            }
        }
        list<OpportunityShare> oShare = [select id from opportunityshare where opportunityId=:oOpportunity.Id and UserOrGroupId in:userIds];
        if(oShare != null){
            delete oShare;
        }
    }
    
    public PageReference onPageLoad(){
        PageReference oPageReference = null;
        try {
           // String profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
           // String strDepartment = [Select Id,LatAm_Department__c from User where Id=:userinfo.getuserid()].LatAm_Department__c;
             User ouser = [Select Id,LatAm_Department__c,Profile.Name from User where Id=:userinfo.getuserid() LIMIT 1];
             String profileName = ouser.Profile.Name;
             String strDepartment = ouser.LatAm_Department__c;
            if(profileName == 'Partner Portal User' && oOpportunity.ownerId != UserInfo.getUserID()){
                Id AllPartnerUsersGroupId = [SELECT Id FROM Group where Type='PRMOrganization' limit 1].Id;
                List<OpportunityShare> oppShare =[Select o.Id, o.OpportunityAccessLevel, o.OpportunityId, o.UserOrGroupId,o.RowCause from OpportunityShare o where (o.UserOrGroupId =:UserInfo.getUserID() or o.UserOrGroupId=:AllPartnerUsersGroupId) and o.OpportunityId =:oOpportunity.id LIMIT 1];
                if(!oppShare.isEmpty()){
                  if(strDepartment == 'Mastersaf - Canal'){
                    showPage = false;
                  }else{
                    showPage = true;
                  }
                }
                else{
                    showPage = false;
                    isQuoteError = false;
                    isCustomerError = false;
                }
                return null;
             }
           /** else{
                     if (InConsoleView == true) {
                          oPageReference = new PageReference('/' + oOpportunity.Id);
                         oPageReference.getParameters().putAll(ApexPages.currentPage().getParameters());
                         oPageReference.getParameters().put('nooverride', '1');
                   }
           }**/
      }
      catch (Exception oException) {
            ApexPages.addMessages(oException);
      }
       showPage = true; 
       return oPageReference;
    }
}