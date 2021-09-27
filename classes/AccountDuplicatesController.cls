/*
======================================================================================================================
CLASS NAME:    AccountDuplicatesController
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class AccountDuplicatesController{
    //Private members
    private Account moAccount;
    private String msErrorMessage;
    private String msSaveURL = '/';
    private String msCancelURL = '/apex/AccountCreate?id=';
    //Public members
    //Properties
    public List<DataServices.AccountDetail> listAccountDupes {get; set;}
    public Id selectedAccountId {get; set;}
    public Boolean enableButtons {get; set;}
    public Boolean runAsUnitTest {get;set;}
    
    // Default Constructor
    public AccountDuplicatesController(ApexPages.standardController oStdController)
    {
        ID accountId;
        try
        {
            this.moAccount = (Account)oStdController.getRecord();
            accountId = moAccount.Id;
            runAsUnitTest = false;
            moAccount = [SELECT a.Street_Type__c, a.Street_Range__c, a.Street_Pre_Dir__c, a.Street_Post_Dir__c, 
                    a.Street_Name__c, a.Secondary_Range__c, a.Sales_Org__c, a.County__c, a.Name, a.NameTwo__c, a.Id, a.Address_Token__c, 
                    a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity
                    FROM Account a WHERE Id =: accountId];
            this.selectedAccountId = null;
            this.enableButtons = true;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    private Boolean deleteMatchLoser()
    {
        Delete moAccount;
        return true;
    }
    
    public PageReference runAccountDedupe(){
        List<DataServices.AccountDetail> tempList = new List<DataServices.AccountDetail>();
        PageReference pg;
        try {
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('DataServices');
            DataServices oDataServices = new DataServices();
            DataServices.LoginRequest oLoginRequest = new DataServices.LoginRequest();
            oLoginRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oLoginRequest.Username = oWebServiceSettings.Username__c;
            oLoginRequest.Password = oWebServiceSettings.Password__c;
            oLoginRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000);
            DataServices.AccountDeDupeRequest oRequest = new DataServices.AccountDeDupeRequest();
            oRequest.Session = oDataServices.submitLoginRequest(oLoginRequest);
            //Build request obj
            DataServices.AccountDetail oAccountDetail = new DataServices.AccountDetail();
            oAccountDetail.Id = moAccount.Id;
            oAccountDetail.Name1 =  moAccount.Name;
            oAccountDetail.Name2 = moAccount.NameTwo__c;
            oAccountDetail.Street = moAccount.BillingStreet;
            oAccountDetail.City = moAccount.BillingCity;
            oAccountDetail.State = moAccount.BillingState;
            oAccountDetail.PostalCode = moAccount.BillingPostalCode;
            oAccountDetail.County = moAccount.County__c;
            oAccountDetail.Country = moAccount.BillingCountry;
            oAccountDetail.Sales_Org = moAccount.Sales_Org__c;
            oAccountDetail.STREET_RANGE = moAccount.Street_Range__c;
            oAccountDetail.STREET_NAME = moAccount.Street_Name__c;
            oAccountDetail.STREET_PRE_DIR = moAccount.Street_Pre_Dir__c;
            oAccountDetail.STREET_POST_DIR = moAccount.Street_Post_Dir__c;
            oAccountDetail.STREET_TYPE =  moAccount.Street_Type__c;
            oAccountDetail.SECONDARY_RANGE = moAccount.Secondary_Range__c;
            oAccountDetail.DEDUP_TOKEN = moAccount.Address_Token__c;
            oAccountDetail.MASTER = 'T';  //Must set to 'T' for the new prospect that is entered
            //Add Master record
            oRequest.Accounts.add(oAccountDetail);  
            
            //Add duplicates based on address token
            GetDupeAccounts(oRequest.Accounts, moAccount.Address_Token__c, moAccount.Id);
            
            //Call service
            DataServices.AccountDeDupeResponse oResponse = oDataServices.submitAccountDeDupeRequest(oRequest);
            for (DataServices.AccountDetail AD : oResponse.Accounts) {
                if (AD.MASTER != 'T'){
                    tempList.Add(AD);
                }
            }
            if (tempList.Size() > 0){ 
                listAccountDupes = tempList;
                pg = null;
            }
            else{
                pg = new PageReference(msSaveURL + moAccount.Id);
            }
            return pg;
        }   
        catch (Exception oException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,oException.getMessage(),'resultMessage'));
            return null;        
        }   
    }
    
    //Enable the Choose Selected button from an actionSupport using onclick of selectRadio
    public void setEnableButton(){
        enableButtons = false;
    }
    
    
    /* Button processing methods */
    /* CANCEL button */
    public PageReference cancel(){
        PageReference pg;
        pg = new PageReference(msCancelURL + moAccount.Id);
        pg.setRedirect(true);
        return pg;
    }
    
    /* SAVE button */
    public PageReference save(){
        PageReference pg; 
        boolean bDataError = false;
        if(this.selectedAccountId == null){
            bDataError = true;
            msErrorMessage = 'You must choose an existing Account before continuing!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msErrorMessage));
            return null;
        }
        try{
            if (deleteMatchLoser()){
                pg = new PageReference(msSaveURL + this.selectedAccountId);
                pg.setRedirect(true);
                return pg;
            }
            
        }
        catch(Exception ex){
            msErrorMessage = 'Error';
            AppUtil.handleError(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, msErrorMessage));
            return null;
        }
        return pg;
    }
    
    private List<DataServices.AccountDetail> GetDupeAccounts(List<DataServices.AccountDetail> listAccountDetails, 
                String DedupeToken, String AccountId)
    { List<Account> listAccounts;
        try
        {   
            if(DedupeToken != null)
            { 
                listAccounts = new List<Account>([SELECT a.Street_Type__c, a.Street_Range__c, a.Street_Pre_Dir__c, a.Street_Post_Dir__c, 
                    a.Street_Name__c, a.Secondary_Range__c, a.Sales_Org__c, a.County__c, a.Name, a.NameTwo__c, a.Id, a.Address_Token__c, 
                    a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity
                    FROM Account a 
                    WHERE a.Address_Token__c=: DedupeToken AND a.Id !=: AccountId]);
                if(listAccounts.isEmpty() == false)
                {
                    for(Account oAccount : listAccounts)
                    {   
                        DataServices.AccountDetail oAccountDetail = new DataServices.AccountDetail();
                        oAccountDetail.Id = oAccount.Id;
                        oAccountDetail.Name1 =  oAccount.Name;
                        oAccountDetail.Name2 = oAccount.NameTwo__c;
                        oAccountDetail.Street = oAccount.BillingStreet;
                        oAccountDetail.City = oAccount.BillingCity;
                        oAccountDetail.State = oAccount.BillingState;
                        oAccountDetail.PostalCode = oAccount.BillingPostalCode;
                        oAccountDetail.County = oAccount.County__c;
                        oAccountDetail.Country = oAccount.BillingCountry;
                        oAccountDetail.Sales_Org = oAccount.Sales_Org__c;
                        oAccountDetail.STREET_RANGE = oAccount.Street_Range__c;
                        oAccountDetail.STREET_NAME = oAccount.Street_Name__c;
                        oAccountDetail.STREET_PRE_DIR = oAccount.Street_Pre_Dir__c;
                        oAccountDetail.STREET_POST_DIR = oAccount.Street_Post_Dir__c;
                        oAccountDetail.STREET_TYPE =  oAccount.Street_Type__c;
                        oAccountDetail.SECONDARY_RANGE = oAccount.Secondary_Range__c;
                        oAccountDetail.DEDUP_TOKEN = oAccount.Address_Token__c;
                        oAccountDetail.MASTER = 'F';  //Must set to 'F' for the potential duplicates
                        listAccountDetails.Add(oAccountDetail); 
                    }
                }
            }
        }
        catch(Exception oException)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,oException.getMessage(),'resultMessage'));
        }
        return listAccountDetails;
    }   
}