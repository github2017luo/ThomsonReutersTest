/*
======================================================================================================================
CLASS NAME:  InvoiceController
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class InvoiceController{
    public String InvoiceItem{get;set;}
    Public Account oAcc{get;set;}
    public String refKey {get;set;}    
    public String stringBeginDate ;
    public String stringEndDate;    
    public String Begindt{get;set;}    
    public String Enddt{get;set;}
    Public String sSelectedOption{get;set;}
    public List<InvoiceServices.CombinedOpenClearedItems> InvoiceItemList{get;set;}    
    public InvoiceServices.DocumentUrl oDocUrl{get;set;} 
    public String strUrl{get;set;}     
    public String strCompanyCode,strSalesOrgCode,strDistChanCode,strDivisionCode;
    public Decimal accountSapId;
    public InvoiceServices.InvoiceItemsRequest oRequest;
    
    public InvoiceController(ApexPages.StandardController controller) {
         try{
            sSelectedOption = 'All';           
            oAcc = new account();
            strUrl='';
            oAcc = (account) controller.getRecord();           
            oAcc = [select id, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c from account where id = :oAcc.Id];
            InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
            IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAcc.Sales_org__c);
            strCompanyCode = oIXOSCodeMap.Company_Code__c;
            strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            strDivisionCode = oIXOSCodeMap.Division_Code__c;
                if(oAcc.SAPAccountNumber__c != null ){  
                    accountSapId = Decimal.valueOf(oAcc.SAPAccountNumber__c);
                }
                else{
                   /* //ApexPages.addMessages(new AppUtil.AppException('SAP Account Number is null')); 
                    //throw new AppUtil.AppException('SAP Account Number is null'); Replaced with custom Label as part of S2E Optimization */
                     throw new AppUtil.AppException(Label.SAPError);
                }
                if(oAcc.Sales_Org__c == null){
                      // throw new AppUtil.AppException('Sales Org is null'); //Replaced with custom Label as part of S2E Optimization
                    throw new AppUtil.AppException(Label.SalesOrgError);
                }
           Begindt = system.today().addDays(-180).format();
           Enddt = system.today().format();
           InvoiceItemList = getInvoiceItemList(Begindt,Enddt);
      }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }                 
    }     
    
    public void setInvoiceDateRange(){
        try{   
              InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
              InvoiceItemList = getInvoiceItemList(Begindt,Enddt);       
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }        
    }
   
    public list<InvoiceServices.CombinedOpenClearedItems> getInvoiceItemList(String invoiceBeginDate,String invoiceEndDate){
        try{
        Integer iTotalNumberOfDays = Date.parse(invoiceBeginDate).daysBetween(Date.parse(invoiceEndDate));
        if(invoiceBeginDate != null ||  invoiceEndDate != null){
                if(Date.parse(invoiceBeginDate) > Date.parse(invoiceEndDate)){
                    //throw new AppUtil.AppException('Begin Date must be less than End Date');//Replaced with custom Label as part of S2E Optimization 
                     throw new AppUtil.AppException(Label.DateError);
                } 
                else if(iTotalNumberOfDays > 180){
                    // throw new AppUtil.AppException('Date range should not exceed 180 days'); //Replaced with custom Label as part of S2E Optimization 
                   throw new AppUtil.AppException(Label.DateError1);
                }           
            }  
        oRequest = new InvoiceServices.InvoiceItemsRequest(); 
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServices');    
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Username = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();            
        oRequest.AccountSAPID = accountSapId;
        oRequest.CompanyCode = strCompanyCode;
        oRequest.SalesOrgCode = strSalesOrgCode;
        oRequest.DistChanCode = strDistChanCode;
        oRequest.DivisionCode = strDivisionCode;
        oRequest.OpenItemsRequested = true;
        oRequest.ClearedItemsRequested = true;
        oRequest.AdditionalTextRequested = true;
        oRequest.InvoiceBegDt = date.parse(invoiceBeginDate);
        oRequest.InvoiceEndDt = date.parse(invoiceEndDate);
            if(sSelectedOption == 'Open'){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            } 
/*System.debug(InvoiceItemList+'Nand&&&&&&&'); ---- commented to reduce character for s2e optimization */           
            if(sSelectedOption == 'Cleared'){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
           InvoiceItemList = new InvoiceServices().getInvoiceItems(oRequest) ;
           if(InvoiceItemList.IsEmpty()){
            InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
             }           
         }
         catch(Exception oException) {
                // if(oException.getMessage().Contains('Customer Record Not Found For SAPID')) //Replaced with custom Label as part of S2E Optimization
                   oException.setMessage('Customer Record Not Found For SAPID: '+ accountSapId );                         // oException.setMessage('Customer Record Not Found For SAPID: '+ accountSapId ); //Replaced with custom Label as part of S2E Optimization
             if(oException.getMessage().Contains(Label.InvoiceError)) 
                   oException.setMessage(Label.InvoiceError+': '+ accountSapId );
                    ApexPages.addMessages(oException);
            } 
         return InvoiceItemList;
    }
    
    public PageReference getDocUrl(){
        InvoiceServices  oInvoiceServices = new InvoiceServices();
        refKey = Apexpages.currentPage().getParameters().get('refkey');
        strUrl = '';
        oDocurl = new InvoiceServices.DocumentUrl();
    try{
           if(refKey != ''){
            InvoiceServices.InvoiceDocUrlRequest oDocrequest = new InvoiceServices.InvoiceDocUrlRequest();
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServices');  
            Map<String,InvoiceDocType__c> InvoiceDocTypes  = new Map<String,InvoiceDocType__c>();
            InvoiceDocTypes = InvoiceDocType__c.getall();
            Map<String,String> mapInvoiceDocTypes = new  Map<String,String>();
            for(InvoiceDocType__c oInvoiceDocType : InvoiceDocTypes.values()){
                if(mapInvoiceDocTypes.containsKey(oInvoiceDocType.Sales_Org__c)){
                   String str1 = mapInvoiceDocTypes.get(oInvoiceDocType.Sales_Org__c)+oInvoiceDocType.Doc_Types__c;
                   mapInvoiceDocTypes.remove(oInvoiceDocType.Sales_Org__c);
                   mapInvoiceDocTypes.put(oInvoiceDocType.Sales_Org__c,str1);
/*   system.debug(mapInvoiceDocTypes.get(strSalesOrgCode).split(';').size()+'hello');-- commented to reduce character for s2e optimization */      
                }else{
                    mapInvoiceDocTypes.put(oInvoiceDocType.Sales_Org__c,oInvoiceDocType.Doc_Types__c);
                }
            }
/* system.debug('DocRequest' + oRequest);   -- commented to reduce character for s2e optimization */            
            oDocrequest.EndPoint =oWebServiceSettings.Endpoint__c;
            oDocrequest.Username = oWebServiceSettings.Username__c;
            oDocrequest.Password = oWebServiceSettings.Password__c;
            oDocrequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();
            oDocrequest.AccountSAPID = Integer.valueof(oAcc.SAPAccountNumber__c);
            oDocrequest.CompanyCode = strCompanyCode ;
            oDocrequest.SalesOrgCode = strSalesOrgCode;
            oDocrequest.DivisionCode = strDivisionCode;
            oDocrequest.DistChanCode = strDistChanCode;
            oDocrequest.referenceKey1 = refKey;
            oDocrequest.DocumentType = new List<String>();
            oDocrequest.DocumentType = mapInvoiceDocTypes.get(strSalesOrgCode).split(';');
            oDocUrl = oInvoiceServices.getInvoiceDocumentUrl(oDocrequest);
/*system.debug('Document Response' + oDocurl);  -- commented to reduce character for s2e optimization */    
            }
            if(oDocUrl.Url != null){
                strUrl = oDocUrl.Url; 
                return null;
            }     
        }catch(Exception oException) {
             if(oException.getMessage().contains('NO_PROVIDED_IMAGE_TYPES_CONFIG'))
                 //if(oException.getMessage().contains('NO_PROVIDED_IMAGE_TYPES_CONFIG'))//Replaced with custom Label as part of S2E Optimization
               // ApexPages.addMessages(new AppUtil.AppException('The requested image is not found')); //Replaced with custom Label as part of S2E Optimization
               if(oException.getMessage().contains(Label.InvoiceError1))
               ApexPages.addMessages(new AppUtil.AppException(Label.ImageError));
            else    
                ApexPages.addMessages(oException);
        } 
         return null;
    }
    
    public List<SelectOption> getInvoiceItemType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Open','Open'));
        options.add(new SelectOption('Cleared','Cleared'));
        options.add(new SelectOption('All','All'));
        return options;
    }
}