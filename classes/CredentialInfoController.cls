/**
 * Controller for the CredentialInfo VF page that extends the 
 * Account standard controller And depends on IPRestrictionServices and CredentialInfoServices classes
 *
 * @author  Zahedul Hossain
 * @version 2013-06-26
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-03-31   Meenakshmi              Optimized the code as per JIRA STORY: PS0-1                                                            
 * =============================================================================
 */
 public with sharing class CredentialInfoController{
//Properties
    public List<CredentialInfoServices.CredentialInfoBusinessRestrictionItem> CredInfoList{get;set;}  
    public List<IPRestrictionServices.IPRestrictionItem> IPInfoList{get;set;}  
    public decimal accountSapId{get;set;}
    public String strCompanyCode{get;set;}
    public String strSalesOrgCode{get;set;}
    public String strDistChanCode{get;set;}
    public String strDivisionCode{get;set;}
    public string sSelectedOption{get;set;}
    public string strValidityDate{get;set;}
    public CredentialInfoServices.CredentialRequest oRequest;
    public IPRestrictionServices.IPRestrictRequest oIPRequest;
    
    //Constructor
    public CredentialInfoController(ApexPages.StandardController controller)
    {    
      try{
            Account oAccount = new account();
            oAccount = (Account)controller.getRecord();
            oAccount = [select id,SAPAccountNumber__c,Sales_org__c from account where id = :oAccount.Id];
            IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAccount.Sales_org__c);
            //strValidityDate= null;
            strValidityDate= system.today().format();
            strCompanyCode = oIXOSCodeMap.Company_Code__c;
            strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            strDivisionCode = oIXOSCodeMap.Division_Code__c;
            if(oAccount.SAPAccountNumber__c != null){
            accountSapId=Decimal.valueOf(oAccount.SAPAccountNumber__c);
/*system.debug('accountSapId in decimal is' + accountSapId);-- commented to reduce character for s2e optimization */
            }  
         }    
         catch (Exception oException){
            ApexPages.addMessages(oException);
        }                                    
     }
    
   public pagereference displayCredInfoList(){
       try{
            displayIPInfoList();
            CredInfoList = new list<CredentialInfoServices.CredentialInfoBusinessRestrictionItem>();         
            oRequest = new CredentialInfoServices.CredentialRequest();
            oRequest.AcctSapId = accountSapId;
            oRequest.CompanyCode = strCompanyCode;
            oRequest.SalesOrgCode = strSalesOrgCode;
            oRequest.DistChanCode = strDistChanCode;
            oRequest.DivisionCode = strDivisionCode;
            CredInfoList = CredentialInfoServices.getCredentialInfoItems(oRequest);
/*system.debug('CredInfoList in Main controller' + CredInfoList);-- commented to reduce character for s2e optimization */
           }
           catch (Exception oException){
                 ApexPages.addMessages(oException);
             } 
             return null; 
       }   
    
       public pagereference displayIPInfoList()
       {   
           try{
                IPInfoList = new list<IPRestrictionServices.IPRestrictionItem>();         
                oIPRequest = new IPRestrictionServices.IPRestrictRequest();
                oIPRequest.Domain = sSelectedOption;
                oIPRequest.AcctSapId = accountSapId;
                if (strValidityDate== ''){
                  oIPRequest.ValidityDt = Date.valueof('0001-01-01'); 
                }
                else{
                  oIPRequest.ValidityDt = date.parse(strValidityDate);
                }
                IPInfoList = IPRestrictionServices.getIPRestrictItems(oIPRequest);
              }
           catch (Exception oException){
               ApexPages.addMessages(oException);
             } 
           return null;
        }   
    
     
       public List<selectoption> getDomainListOptions(){
            List<selectoption> DomainList = new  List<selectoption>();
            Map<String,CredentialInfo__c> mapDomain = CredentialInfo__c.getAll();
            for(String strDomain : mapDomain.keySet()){
                DomainList.add(new selectoption(strDomain,strDomain));
            }
            return DomainList;
       }
}