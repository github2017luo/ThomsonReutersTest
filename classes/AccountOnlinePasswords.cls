/*
======================================================================================================================
CLASS NAME:    AccountOnlinePasswords
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class AccountOnlinePasswords{
    Public Account oAccount{get;set;}
    Public  string sSelectedOption{get;set;}
    Public List<ContactPasswordsServices.OnlineAccountUsers> listOnlineUser{get;set;}
    Public PagingOnlineAccountPasswords oPagingOnlineAccountPasswords {get;set;}
    Public String strCompanyCode{get;set;}
    Public String strSalesOrgCode{get;set;}
    Public String strDistChanCode{get;set;}
    Public String strDivisionCode{get;set;}
    
    
    public AccountOnlinePasswords(ApexPages.StandardController stdController){
        oAccount =  new Account();
        oAccount = (account) stdController.getRecord();
        oAccount = [Select Name,Sales_Org__c,SAPAccountNumber__c from Account where Id =:oAccount.Id];
        sSelectedOption ='WESTLAW';
        IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAccount.Sales_org__C);
        strCompanyCode = oIXOSCodeMap.Company_Code__c;
        strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
        strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
        strDivisionCode = oIXOSCodeMap.Division_Code__c;
        displayAccountOnlinePasswords();
    }

    public void displayAccountOnlinePasswords(){
        try{
            ContactPasswordsServices.AccountPasswordRequest oRequest = new ContactPasswordsServices.AccountPasswordRequest();
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswordsESI');       
            oRequest.endpoint= oWebServiceSettings.Endpoint__c;
            oRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            oRequest.username=oWebServiceSettings.Username__c;
            oRequest.password= oWebServiceSettings.Password__c;
            oRequest.AcctSapId = decimal.valueof(oAccount.SAPAccountNumber__c);
            oRequest.Domain = sSelectedOption;
            oRequest.CompanyCode = strCompanyCode;
            oRequest.SalesOrgCode = strSalesOrgCode;
            oRequest.DistChanCode = strDistChanCode;
            oRequest.DivisionCode = strDivisionCode;
            oRequest.StartRec = 1;
            oRequest.MaxResults = 250;
            oPagingOnlineAccountPasswords = new PagingOnlineAccountPasswords(oRequest);
            oPagingOnlineAccountPasswords.PageSize = 250;
            oPagingOnlineAccountPasswords.getOnlineAccountUsers();         
            oPagingOnlineAccountPasswords.iTotalrecs = ContactPasswordsServices.TotalofRecs;
           }
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }
    }
    
    
    
     public List<selectoption> getDomainListOptions(){
        List<selectoption> DomainList = new  List<selectoption>();
        Map<String,Domain__c> mapDomain = Domain__c.getAll();
        for(String strDomain : mapDomain.keySet()){
            DomainList.add(new selectoption(strDomain,strDomain));
        }
        return DomainList;
    }
    
    public PageReference exportAccountPswds(){
        PageReference oPageReference = Page.AccountPasswordExport;
        oPageReference.setRedirect(false);
        return oPageReference;
    }
    
    // Codes for implementing Pagination for Online Account Users
    // Pageable class has been extended here.
   
    
     public class PagingOnlineAccountPasswords extends Pageable{
        public ContactPasswordsServices.AccountPasswordRequest oRequest;
        public Integer iTotalrecs;
        Public List<ContactPasswordsServices.OnlineAccountUsers> listOnlineUser{get;set;}
        public PagingOnlineAccountPasswords(ContactPasswordsServices.AccountPasswordRequest oRequest){
            this.oRequest = oRequest;
            iTotalrecs = 0;
        }
        public override integer getRecordCount(){
          return (listOnlineUser == null ? 0 : iTotalrecs);
        }
        public void getOnlineAccountUsers(){
          ContactPasswordsServices oContactPasswordsServices = new ContactPasswordsServices();
          oRequest.StartRec = (PageIndex * Pagesize +1);
          oRequest.MaxResults = oRequest.MaxResults+oRequest.StartRec;
          listOnlineUser = oContactPasswordsServices.GetAccountPasswords(oRequest);
        }
        public override void moveNext(){
          super.moveNext();
          getOnlineAccountUsers();
        }   
       public override void movePrev(){
         super.movePrev();
          getOnlineAccountUsers();
       }
        public override void moveLast(){
            super.moveLast();
            getOnlineAccountUsers();
        }
        public override void moveFirst(){
           super.moveFirst();
           getOnlineAccountUsers();
        }
    }
}