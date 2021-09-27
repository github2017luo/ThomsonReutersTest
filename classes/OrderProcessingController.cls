/**
 * Provides methods helper methods for working with OrderProcessing VF page 
 * @author  Srtikanth Kuruva
 * @version 2013-05-03
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-05-03   Srikanth Kuruva          Created   
 * 2013-07-02   Sadasiva Banda            Updated (# added a function to navigate NZ Prodman URL)                                                 
 * 2013-10-17   Shawn Gray               Updated (# added a function to navigate PIC and PICAM )
 * 2014-04-08   Shawn Gray               CreateSAPCustomer to select the opportunity again to make sure have the most recent data
 * =============================================================================
 */

  
public class OrderProcessingController{ 
    public Opportunity oOpportunity{get;set;}
    public string sStatus{get;set;}
    private Set<String> setQuoteStages;
    private string sQuoteStage;
    private Id UserId;
    public string sCurrentUserProfile{get;set;}
    public string sPageReference{get;set;}
    public string sCurrentUserLanguage{get;set;}
    public string sStage{get;set;}
    public string sSalesOrg{get;set;}
    public User sCurrentUser{get;set;}
    public OrderProcessingController(ApexPages.StandardController controller) {
        oOpportunity = (Opportunity)controller.getRecord();
        oOpportunity = [select AccountId, StageName, Require_Manual_Trigger_for_Quote__c, SAP_Account_Number__c,
        Account.RecordType.Name, Account.Sales_Org__c, Account.Source__c, Account.NameTwo__c, MDB_Account_Number__c
        from Opportunity where Id = :oOpportunity.Id];
        //oAccount = [select RecordType.Name, Sales_Org__c   from Account where Id =:oOpportunity.AccountId];
        if(BigRuleGenericSettings__c.getInstance('QS:'+ oOpportunity.Account.Sales_Org__c)!= null)
            sQuoteStage = BigRuleGenericSettings__c.getInstance('QS:'+ oOpportunity.Account.Sales_Org__c).Value__c;
        else
            sQuoteStage='';
        setQuoteStages = new set<String>();
        setQuoteStages.addAll(sQuoteStage.split(',',0));
        UserId = UserInfo.getUserId();
        sCurrentUserLanguage = UserInfo.getLanguage();
        sCurrentUser = [select Id,Profile.Name, Sales_Org__c from User where Id = :UserId];
        sCurrentUserProfile = sCurrentUser.Profile.Name;
        sStage = oOpportunity.StageName ;
        sSalesOrg = oOpportunity.Account.Sales_Org__c;
        if ((sCurrentUserProfile == 'LatAm User' || sCurrentUserProfile == 'Partner Portal User') && !AppUtil.isEmpty(sCurrentUser.Sales_Org__c)){
            sSalesOrg = sCurrentUser.Sales_Org__c;
        }
    }
    
    public pageReference CreateSAPCustomer(){
        oOpportunity = [select AccountId, StageName, Require_Manual_Trigger_for_Quote__c, SAP_Account_Number__c,
        Account.RecordType.Name, Account.Sales_Org__c, Account.Source__c, Account.NameTwo__c, MDB_Account_Number__c
        from Opportunity where Id = :oOpportunity.Id];

        if (oOpportunity.Account.RecordType.Name == 'Prospect'){
            sStatus = CreateCustomer.triggerCustomerCreation(oOpportunity.Account.Id);
        }
        else{
            sStatus = 'Associated account should be a prospect to initiate the customer creation';
            
        }
        return null;
    }
    
    public pageReference CreateSAPQuote(){
        if(!oOpportunity.Require_Manual_Trigger_for_Quote__c){
            sStatus = 'Manual trigger for Quote creation is not needed for this opportunity, Please check the Manually Create Quote flag';
        }
        else{
            if(setQuoteStages.contains(oOpportunity.StageName)){
                sStatus = createQuote.triggerQuoteCreationFrmOpp(oOpportunity.Id);
            }
            else{
                sStatus = 'Quote creation can not be initiated if opportunity is not staged at '+sQuoteStage.replace(',',' or ');
            }
        }
        return null;
    }
    
    public pageReference getOrdermationLink(){
        string sQuoteNumber = OrdermationLink.getQuoteId(oOpportunity.Id);
        if (sQuoteNumber != ''){
            sPageReference = KeyValueListStore__c.getInstance('OrdermationLink').TextValue__c+'?acctname='+oOpportunity.SAP_Account_Number__c+'&quoteid='+sQuoteNumber;
        }
        else{
            sPageReference = KeyValueListStore__c.getInstance('OrdermationLink').TextValue__c;
        }
        return null;
    }  
      
    public pageReference getPIClink(){
        string sQuoteNumber = OrdermationLink.getQuoteId(oOpportunity.Id);
        if (sQuoteNumber != ''){
            sPageReference = KeyValueListStore__c.getInstance('PIClink').TextValue__c+'?SAPAccountNumber='+oOpportunity.SAP_Account_Number__c+'&MDBAccountNumber='+oOpportunity.MDB_Account_Number__c+'&QuoteNumber='+sQuoteNumber;
        }
        else{
            sPageReference = KeyValueListStore__c.getInstance('PIClink').TextValue__c+'?SAPAccountNumber='+oOpportunity.SAP_Account_Number__c+'&MDBAccountNumber='+oOpportunity.MDB_Account_Number__c;       
        }
        return null;
    }
     public pageReference getPICAMlink(){
        string sQuoteNumber = OrdermationLink.getQuoteId(oOpportunity.Id);
        if (sQuoteNumber != ''){
            sPageReference = KeyValueListStore__c.getInstance('PICAMlink').TextValue__c+'?SAPAccountNumber='+oOpportunity.SAP_Account_Number__c+'&MDBAccountNumber='+oOpportunity.MDB_Account_Number__c+'&QuoteNumber='+sQuoteNumber;
        }
        else{
            sPageReference = KeyValueListStore__c.getInstance('PICAMlink').TextValue__c+'?SAPAccountNumber='+oOpportunity.SAP_Account_Number__c+'&MDBAccountNumber='+oOpportunity.MDB_Account_Number__c;       
        }
        return null;
    }
     public pageReference getPICCorporatelink(){
        string sQuoteNumber = OrdermationLink.getQuoteId(oOpportunity.Id);
        if (sQuoteNumber != ''){
            sPageReference = KeyValueListStore__c.getInstance('PICCorporatelink').TextValue__c+'?SAPAccountNumber='+oOpportunity.SAP_Account_Number__c+'&MDBAccountNumber='+oOpportunity.MDB_Account_Number__c+'&QuoteNumber='+sQuoteNumber;
        }
        else{
            sPageReference = KeyValueListStore__c.getInstance('PICCorporatelink').TextValue__c+'?SAPAccountNumber='+oOpportunity.SAP_Account_Number__c+'&MDBAccountNumber='+oOpportunity.MDB_Account_Number__c;       
        }
        return null;
    }
        
    public pageReference getAUSProdmanLink(){      
        sPageReference = KeyValueListStore__c.getInstance('AUSProdmanLink').TextValue__c+'?Opid='+oOpportunity.Id+'&acctid='+oOpportunity.AccountId+'&usrid='+UserId;
        return null; 
    }
    public pageReference getNZProdmanLink(){      
        sPageReference = KeyValueListStore__c.getInstance('NZProdmanLink').TextValue__c+'?Opid='+oOpportunity.Id+'&acctid='+oOpportunity.AccountId+'&usrid='+UserId;
        return null;
    }
    public pageReference createEReader(){       
        //String[] sResult = new String[2]; 
        String[] sResult = Wrapper_EReader.generateAccessEReaderWS(oOpportunity.Id);
        sStatus = sResult[1];
        system.debug('sResult:'+sResult);
        system.debug('sStatus:'+sStatus);
        //sStatus = Wrapper_EReader.generateAccessEReaderWS(oOpportunity.Id)[0];
        //sStatus = string.ValueOf(Wrapper_EReader.generateAccessEReader(oOpportunity.Id));
        
        //sStatus = 'Se han generado los accesos E-Reader con éxito!';
        return null;
    }
}