/**
 * Contains helper methods for PrintDiscountAnalysis Page
 * Contains the methods which will process the request and response
 *
 * @author  Srikanth Kuruva
 * @version  2012-02-13
 */
 /*
======================================================================================================================
CLASS NAME:    PrintDiscountAnalysisController 
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class PrintDiscountAnalysisController 
{
    public static final string sSystemId ='SFDC-CORE-LEGAL';
    public static final string sSubType = 'PDA';
    public static final Boolean bIncludeActiveSubs = true;
    public static final Boolean bIncludeLapsedSubs = false;
    public static final Integer iMaxResults = 250;
    public static final Decimal dcMinimumIncrementalValue = 1.5;
    public Account oAccount{get;set;}
    public string sDiscount{get; set;}
    public String headerVal;
    public List<SelectOption> listDiscountValues;
    public List<wrapPDASubItems> listPDASubItems{get;set;}
    public SubscriptionServices.PdaItem oPdaItem{get;set;}
    public string sExportFormat{get;set;}
    public Boolean bMultipleAccounts{get;set;}
    public Boolean bRenderPage{get;set;}
    public IXOSCodeMap__c oSalesOrgDetail = new IXOSCodeMap__c();
    public List<wrapPartnerFunctions> oPartnerFunctions{get;set;}
    public Map<string, SubscriptionServices.SubItem> mapPDASubItems{get;set;}
    public List<wrapExportResult> listSelectedVal;
    public Map<String, SubscriptionServices.PdaLineItem> oLineItem{get;set;}
    public List<SubscriptionServices.SubItem> oLstSubItem = new List<SubscriptionServices.SubItem>();
    public List<SubscriptionServices.SubItem> ListSubItems = new List<SubscriptionServices.SubItem>();    
       
    public PrintDiscountAnalysisController(ApexPages.StandardController controller){
        oAccount = (Account) Controller.getRecord();
        oAccount = [select  BillingStreet, BillingState, BillingPostalCode, BillingCity, Work_Fax__c,PhoneNumberTwo__c, Fax, Street_Address_2__c, Phone,Street_Address_3__c,  Street_Address_4__c, Street_Address_5__c, SAPAccountNumber__c, Sales_Org__c,Name from Account where id = :oAccount.Id];
        oAccount.SAPAccountNumber__c = AppUtil.isNull(oAccount.SAPAccountNumber__c, '0');        
        if(oAccount.Sales_Org__c != null){
            oSalesOrgDetail = IXOSCodeMap__c.getInstance(oAccount.Sales_Org__c);
            getPartnerFunctions();
            bMultipleAccounts = false;
            oPdaItem = new SubscriptionServices.PdaItem();
            getlistPDASubItems();
            bRenderPage = true;
        }
        else{
            bRenderPage = false;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Sales Org for the Account is blank.')); // Replaced with custom label as part of S2E Optimization
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.PrintDiscountError));
        }
    }
    
   
    
    public void getlistPDASubItems(){
        //build the request based on the values entered on the UI
        SubscriptionServices.SubsRequest oSubsRequest = new SubscriptionServices.SubsRequest();        
        oSubsRequest.AcctSapId = new Decimal[]{};
/*system.debug('oAccount.SAPAccountNumber__c:'+oAccount.SAPAccountNumber__c);-- commented to reduce character for s2e optimization */
        //check for multiple accounts or single account
        if(bMultipleAccounts){
            for(wrapPartnerFunctions oSinglePartnerFunction : oPartnerFunctions){
                if(oSinglePartnerFunction.bPFSelected){
                    oSubsRequest.AcctSapId.add(Decimal.valueOf(oSinglePartnerFunction.oPartnerFunction.Account_SAP_Number__c));
                }
            }
        }
        else{
            oSubsRequest.AcctSapId.add(Decimal.valueOf(oAccount.SAPAccountNumber__c));
        }
        if(!oSubsRequest.AcctSapId.isEmpty()){
            oSubsRequest.SystemId = sSystemId;
            oSubsRequest.SalesOrgCode = oAccount.Sales_Org__c;
            oSubsRequest.CompanyCode = oSalesOrgDetail.Company_Code__c;
            oSubsRequest.DistChanCode = oSalesOrgDetail.Dist_Chan_Code__c;//Distribution_Channel__c;
            oSubsRequest.DivisionCode = oSalesOrgDetail.Division_Code__c;
            oSubsRequest.SubType = sSubType;
            oSubsRequest.IncludeActiveSubs = bIncludeActiveSubs;
            oSubsRequest.IncludeLapsedSubs = bIncludeLapsedSubs;
            oSubsRequest.MaxResults = iMaxResults;
            oSubsRequest.StartRec=1;
            SubscriptionServices.SortParm oSortParm = new SubscriptionServices.SortParm(); 
            oSortParm.sParmName = 'MaterialDesc';
            oSortParm.sSortDirection = 'ASC';
            oSubsRequest.listSortParms = new List<SubscriptionServices.SortParm>();
            oSubsRequest.listSortParms.add(oSortParm);
            //send the request and get response into a map
            ListSubItems = SubscriptionServices.getSubItems(oSubsRequest);
            mapPDASubItems = new  Map<string, SubscriptionServices.SubItem>();
            for(string ostrng :SubscriptionServices.mapSubItems.keySet()){
                mapPDASubItems.put(ostrng ,SubscriptionServices.mapSubItems.get(ostrng));
            }
            //put the subitems in the list which can be accessed from VF page
            listPDASubItems = new List<wrapPDASubItems>();
            for(SubscriptionServices.SubItem oSinglePDASubItem : ListSubItems){
                listPDASubItems.add(new wrapPDASubItems(oSinglePDASubItem));
            }
        }
        else{
            if(bMultipleAccounts){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one Partner Function.')); //Replaced with custom Label as part of S2E Optimization
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.PrintDiscountError1));
            }
            else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The SAP Account Number on Account is null.')); //Replaced with custom Label as part of S2E Optimization
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.PrintDiscountError2));
            }
        }
    }
    
    public pageReference CalculatePDA(){
        //build Calcualte PDA Request
        SubscriptionServices.CalculatePDARequest oCalculatePDARequest = new SubscriptionServices.CalculatePDARequest();
        oPdaItem = new SubscriptionServices.PdaItem();
        oCalculatePDARequest.SubKey = new string[]{};
        for (wrapPDASubItems oItem : listPDASubItems){
            if(oItem.bPDAselected)
                oCalculatePDARequest.SubKey.add(oItem.oPDASubItem.SubKey);
        }
        if(!oCalculatePDARequest.SubKey.isEmpty()){
            oCalculatePDARequest.SystemId = sSystemId;
            oCalculatePDARequest.DiscountPercent = Decimal.valueOf(sDiscount);
            oCalculatePDARequest.MinimumIncrementalValue = dcMinimumIncrementalValue;           
            //send the request and get response into a pda item
            oPdaItem = SubscriptionServices.CalculatePDA(oCalculatePDARequest);
            //After calculating PDA update additional columns on Sub for selected subs
                //and update 0.0 on additional columns on non selected items
            for (wrapPDASubItems oItem : listPDASubItems){
                if(!oItem.bPDAselected){                
                    oItem.oPDASubItem.TotalEstimatedUpkeep = 0.0;        
                    oItem.oPDASubItem.DiscountPerUnit = 0.0;
                    oItem.oPDASubItem.TotalPrintDiscount = 0.0;
                    oItem.oPDASubItem.TotalUpkeepAfterDiscount = 0.0;
                    oItem.oPDASubItem.MinimumIncremental = 0.0;
                }
            }
            for(SubscriptionServices.PdaLineItem oPdalineItem : oPdaItem.PdaLineItem){
                mapPDASubItems.get(oPdalineItem.SubKey);
                mapPDASubItems.get(oPdalineItem.SubKey).TotalEstimatedUpkeep = oPdalineItem.EstimatedUpKeep;        
                mapPDASubItems.get(oPdalineItem.SubKey).DiscountPerUnit = oPdalineItem.DiscountPerUnit;
                mapPDASubItems.get(oPdalineItem.SubKey).TotalPrintDiscount = oPdalineItem.Discount;
                mapPDASubItems.get(oPdalineItem.SubKey).TotalUpkeepAfterDiscount = oPdalineItem.UpKeepAfterDiscount;
                mapPDASubItems.get(oPdalineItem.SubKey).MinimumIncremental = oPdalineItem.MinimumIncremental;               
            }
        }
        else{
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must first select at least one product to perform a calculation.')); //Replaced with custom Label as part of S2E Optimization
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.PrintDiscountError3));
        }        
        return null;
    }
    public class wrapPDASubItems{
        public Boolean bPDAselected{get;set;}
        public SubscriptionServices.SubItem oPDASubItem{get;set;}
        public  wrapPDASubItems(SubscriptionServices.SubItem oSinglePDASubItem){           
            bPDAselected = false;
            oPDASubItem = oSinglePDASubItem;
        }               
    }
    public pageReference showMultipleAccounts(){
        bMultipleAccounts = true;
        
        return null;
    }
    public pageReference hideMultipleAccounts(){
        bMultipleAccounts = false;
        getlistPDASubItems();
        oPdaItem = new SubscriptionServices.PdaItem();
        return null;
    }
    public PageReference clearSelections(){
        //clear the check box field for the PDA Subs
        for(wrapPDASubItems oWrapPDASubItem : listPDASubItems){
            oWrapPDASubItem.bPDAselected = false;
            oWrapPDASubItem.oPDASubItem.TotalEstimatedUpkeep = 0.0;        
            oWrapPDASubItem.oPDASubItem.DiscountPerUnit = 0.0;
            oWrapPDASubItem.oPDASubItem.TotalPrintDiscount = 0.0;
            oWrapPDASubItem.oPDASubItem.TotalUpkeepAfterDiscount = 0.0;
            oWrapPDASubItem.oPDASubItem.MinimumIncremental = 0.0;
        }
        //clear the PDA calculations
        oPdaItem = new SubscriptionServices.PdaItem();
        //clear the discount value
        sDiscount = '0';
        return null; 
    }
    public PageReference Export()
    {        
        PageReference pgExport;
        if(sExportFormat == 'PDF'){
            pgExport = new PageReference('/apex/PrintDiscountAnalysisPDF');            
        }
        else if(sExportFormat == 'Excel'){
            pgExport = new PageReference('/apex/PrintDiscountAnalysisXL');            
        }
        else if(sExportFormat == 'Word'){
            pgExport = new PageReference('/apex/PrintDiscountAnalysisWORD');            
        }
        pgExport.setRedirect(false);
        return pgExport;
    }
    
    
    //discount picklist values
    public List<SelectOption> getlistDiscountValues(){
        listDiscountValues = new List<SelectOption>();
        listDiscountValues.add(new selectOption('0','0'));
        listDiscountValues.add(new selectOption('5','5'));
        listDiscountValues.add(new selectOption('10','10'));
        listDiscountValues.add(new selectOption('15','15'));
        listDiscountValues.add(new selectOption('20','20'));
        listDiscountValues.add(new selectOption('25','25'));
        listDiscountValues.add(new selectOption('30','30'));
        listDiscountValues.add(new selectOption('35','35'));
        listDiscountValues.add(new selectOption('40','40'));
        listDiscountValues.add(new selectOption('45','45'));
        listDiscountValues.add(new selectOption('50','50'));        
        return listDiscountValues;
    }
    
    public List<wrapPartnerFunctions> getPartnerFunctions(){
        oPartnerFunctions = new List<wrapPartnerFunctions>();
        for (Business_Partner_Function__c oSinglePartnerFunction : [select Account_SAP_Number__c, Related_Account__r.Name, Related_Account__r.NameTwo__c, Related_Account__r.NameThree__c, Street__c, Related_Account__r.Street_Address_2__c, City__c, State__c, Zip__c from Business_Partner_Function__c where Sold_To_Account__c = :oAccount.Id])
        {
            oPartnerFunctions.add(new wrapPartnerFunctions(oSinglePartnerFunction));
        }
        return oPartnerFunctions;
    }
    public class wrapPartnerFunctions{
        public Boolean bPFSelected{get;set;}
        public Business_Partner_Function__c oPartnerFunction{get;set;}
        public  wrapPartnerFunctions(Business_Partner_Function__c oSinglePartnerFunction){           
            bPFSelected = false;
            oPartnerFunction = oSinglePartnerFunction;
        }               
    }
    
    public class wrapExportResult{
        public SubscriptionServices.PdaLineItem oPdaLineItem{get;set;}
        public SubscriptionServices.SubItem oSubItem{get;set;}
        public  wrapExportResult(SubscriptionServices.PdaLineItem oLineItem, SubscriptionServices.SubItem oSub){           
            oPdaLineItem =oLineItem;
            oSubItem = oSub;
        } 
                     
    }   
    
    //get the selected rows for export pages
    public List<wrapExportResult> getlistSelectedVal(){        
        oLineItem = new Map<String, SubscriptionServices.PdaLineItem>();
        for (wrapPDASubItems oItem : listPDASubItems){
            if(oItem.bPDAselected)
                oLstSubItem.add(oItem.oPDASubItem);                            
        }
        for (SubscriptionServices.PdaLineItem oItem : oPdaItem.PdaLineItem){
            oLineItem.put(oItem.SubKey, oItem );                          
        }        
        listSelectedVal= new List<wrapExportResult>();
        for (SubscriptionServices.SubItem sub: oLstSubItem){
            listSelectedVal.add(new wrapExportResult(oLineItem.get(sub.SubKey),sub));                      
        }
        return listSelectedVal;
     }
     
     //Returns heading for one of the columns on export pages
     public String getHeaderVal(){
         String s = ' Unit Upkeep Discount';
         if(sDiscount != null && sDiscount != ' ')
             headerVal= '%'+sDiscount+s;
         return headerVal;
     }
}