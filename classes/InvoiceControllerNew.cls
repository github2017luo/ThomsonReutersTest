/*
======================================================================================================================
CLASS NAME: InvoiceControllerNew
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Karthi                  Optimized the code as per JIRA STORY: PS0-1
2017-10-04        Seema                   Updated for CRM-8236
2020-03-26        Shyamsundar Shet        BMP-1593 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

======================================================================================================================
*/

public with sharing class InvoiceControllerNew{
    public String InvoiceItem{get;set;}
    Public Account oAccount{get;set;}
    public String referenceKey {get;set;}
    public String stringBeginDate;
    public String stringEndDate;
    public String Begindt{get;set;}    
    public String Enddt{get;set;}
    Public String sSelectedOption{get;set;}
    public List<InvoiceServices.CombinedOpenClearedItems> InvoiceItemList{get;set;}    
    public InvoiceServices.DocumentUrl oDocUrl{get;set;} 
    public String strUrl{get;set;} 
    public String strCompanyCode;
    public String strSalesOrgCode{get;set;}
    public String strDistChanCode;
    public String strDivisionCode;
    public Decimal accountSapId{get;set;}
    public InvoiceServices.InvoiceItemsRequest oRequest;
    public String profileName{get;set;}
    public Decimal totalAmount{get;set;}
    public String frmtTotalAmount{get;set;}
    //added for CRM-8236
    public string UserBusinessUnit{get;set;}
    boolean uslUser;
    public Source_System_Detail__c oSSD{get;set;}
    
    // Updated for CRM-8236
    public InvoiceControllerNew(ApexPages.StandardController controller) {    
         id id1 = userinfo.getProfileId();
         If(Schema.sObjectType.profile.fields.Name.isAccessible())
         {
         Profile pObj = [select Name from profile where id = :id1];
         profileName = pObj.Name;
         }
        

         String UserBusinessUnit = LCRMGenericComponent.getUserBU();
         if(profileName == 'GLI Sales User' || profileName == 'GLI Sales Ops User' ){
             uslUser = true;
         } else{
             uslUser =false;
         }
          String ObjectName= controller.getRecord().getSObjectType().getDescribe().getName();
         System.debug('ObjectName-->'+ObjectName);
         try{
              sSelectedOption = System.Label.AccountRec_SOOpen;
              strUrl='';
              InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
              //if(objid.startswith('a9d')){
              if(ObjectName== 'Source_System_Detail__c'){
                  if((uslUser && (UserBusinessUnit == 'USL' || UserBusinessUnit=='LMS' || UserBusinessUnit == 'FindLaw'))|| profileName == 'System Administrator'){
                      System.debug('USL');
                      oSSD = new Source_System_Detail__c();
                      oSSD = (Source_System_Detail__c) controller.getRecord();
                      System.debug('recordId'+oSSD.id);
                      If(Schema.sObjectType.Source_System_Detail__c.isAccessible())
                      {
                      oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.CompanyCodeDescription__c, Account_Name__r.Sales_Org__c, Account_Name__r.DistributionChannel__c, Account_Name__r.DivisionCodeDescription__c FROM Source_System_Detail__c where id = :oSSD.id  ];  
                      System.debug('oSSD+'+oSSD+'oSSD.LCRM_Sales_org__c-->'+oSSD.LCRM_Sales_org__c);
                      }
                      
                      if(oSSD != null && oSSD.LCRM_Sales_org__c == 'WEST'){
                          InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
                          IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.LCRM_Sales_org__c);
                          strCompanyCode = oIXOSCodeMap.Company_Code__c;
                          strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                          strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
                          strDivisionCode = oIXOSCodeMap.Division_Code__c;
                          if(oSSD.Source_System_Account_Number__c != null ){  
                                accountSapId = Decimal.valueOf(oSSD.Source_System_Account_Number__c);
                          }else{
                                throw new AppUtil.AppException(Label.SAPError);  
                          }
                      }else if(oSSD.LCRM_Sales_org__c == null){
                          throw new AppUtil.AppException(Label.SalesOrgError);  
                      }else {
                        throw new AppUtil.AppException(Label.SalesOrgOtherthanWESTError);    
                      }
                  }    
              }
             else if(ObjectName == 'Account'){
             //else if(objid.startswith('001')){
                System.debug('Other Users');
                oAccount = new account();
                oAccount = (account) controller.getRecord();
                If(Schema.sObjectType.account.isAccessible())   
                {        
                oAccount = [select id, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c from account where id = :oAccount.Id];
                IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAccount.Sales_org__c);
                strCompanyCode = oIXOSCodeMap.Company_Code__c;
                strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
                strDivisionCode = oIXOSCodeMap.Division_Code__c; 
                }
                
                if(oAccount.SAPAccountNumber__c != null ){ 
                   accountSapId = Decimal.valueOf(oAccount.SAPAccountNumber__c);
                }
                else{
                        //ApexPages.addMessages(new AppUtil.AppException('SAP Account Number is null')); 
                     //throw new AppUtil.AppException('SAP Account Number is null');//Replaced with custom label as part of S2E Optimization
                    throw new AppUtil.AppException(Label.SAPError);  
                }
                if(oAccount.Sales_Org__c == null){
                    //throw new AppUtil.AppException('Sales Org is null');//Replaced with custom label as part of S2E Optimization
                    throw new AppUtil.AppException(Label.SalesOrgError);  
                }
             }
            //sSelectedOption = 'All';           
                      
            
            /*if(profileName == 'LatAm User' || profileName == 'System Administrator'){
            //    Begindt = system.today().addDays(-365).format();
            //}else{
            //    Begindt = system.today().addDays(-180).format();} -- commented alltogether to reduce character for s2e optimization */
           Begindt = system.today().addDays(-365).format();
           Enddt = system.today().format();
           System.debug('accountSapId '+accountSapId );
           InvoiceItemList = getInvoiceItemList(Begindt,Enddt);
        }catch(Exception oException){
            ApexPages.addMessages(oException);
        }
    }
    
    
    public void setInvoiceDateRange(){
        try{
              InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
              InvoiceItemList = getInvoiceItemList(Begindt,Enddt);       
        }catch (Exception oException){
            ApexPages.addMessages(oException);
        }        
    }
   
    public list<InvoiceServices.CombinedOpenClearedItems> getInvoiceItemList(String invoiceBeginDate,String invoiceEndDate){
        try{
            System.debug('getInvoiceItemList');
            String accessToken=DellBoomiTokenGeneration.getAuthToken();
            totalAmount = 0;
            frmttotalAmount = '0';
            Integer iTotalNumberOfDays = Date.parse(invoiceBeginDate).daysBetween(Date.parse(invoiceEndDate));
/*system.debug('iTotalNumberOfDays' + iTotalNumberOfDays );-- commented to reduce character for s2e optimization */
            if(invoiceBeginDate != null ||  invoiceEndDate != null){
                if(Date.parse(invoiceBeginDate) > Date.parse(invoiceEndDate)){
                     //throw new AppUtil.AppException('Begin Date must be less than End Date');//Replaced with custom label as part of S2E Optimization
                    throw new AppUtil.AppException(Label.DateError);  
                //}else if(iTotalNumberOfDays > 180 && profileName != 'LatAm User' && profileName != 'System Administrator'){
                //    throw new AppUtil.AppException('Date range should not exceed 180 days'); 
                }else if(iTotalNumberOfDays > 365){
                    throw new AppUtil.AppException(System.Label.AccountRec_DateRangeErrMsg); 
                }           
            }  
            oRequest = new InvoiceServices.InvoiceItemsRequest(); 
            WebServiceSettings__c oWebServiceSettings;
            //if(profileName != 'LatAm User' && profileName != 'System Administrator'){
            //    oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServices');    
            //}else{
                oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServicesMISSOA');
            //}
/*System.debug('Endpoint : '+oWebServiceSettings.Endpoint__c);-- commented to reduce character for s2e optimization */
            oRequest.accessToken = accessToken;
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            //oRequest.Username = oWebServiceSettings.Username__c;
            //oRequest.Password = oWebServiceSettings.Password__c;
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
            if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOOpenDue || sSelectedOption == System.Label.AccountRec_SOOpenNotDue){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceServices invSerObj = new InvoiceServices();
            //if(profileName != 'LatAm User' && profileName != 'System Administrator'){
            //    InvoiceItemList = new InvoiceServices().getInvoiceItems(oRequest) ;  
            //}else{
                InvoiceItemList = invSerObj.getInvoiceItemsMISSOA(oRequest,sSelectedOption) ;
            //}
/*System.debug('InvoiceItemList : '+InvoiceItemList);-- commented to reduce character for s2e optimization */
            /*InvoiceWSObject.OpenItem tt = new InvoiceWSObject.OpenItem();
            tt.amount = 100;
            tt.DocumentType = 'AA';
            InvoiceWSObject.OpenItem tt1 = new InvoiceWSObject.OpenItem();
            tt1.amount = 101;
            tt1.DocumentType = 'AR';
            InvoiceServices.CombinedOpenClearedItems t = new InvoiceServices.CombinedOpenClearedItems(tt);
            InvoiceServices.CombinedOpenClearedItems t1 = new InvoiceServices.CombinedOpenClearedItems(tt1);
            InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>{t,t1};
            */
            if(InvoiceItemList.IsEmpty()){
                InvoiceItemList = new List<InvoiceServices.CombinedOpenClearedItems>();
            }else{
                totalAmount = invSerObj.totalAmount; 
                frmtTotalAmount = invSerObj.frmtTotalAmount;
            } 
        }catch(Exception oException){
            if(oException.getMessage().Contains('Customer Record Not Found For SAPID'))
                oException.setMessage('Customer Record Not Found For SAPID: '+ accountSapId );
            ApexPages.addMessages(oException);
/*System.debug('Exception : '+oException.getMessage());
            System.debug('Exception : '+oException.getStackTraceString());-- commented to reduce character for s2e optimization */
        } 
        System.debug('InvoiceItemList-->'+InvoiceItemList);
        return InvoiceItemList;
    }
    
    
    public PageReference getDocUrl(){
        system.debug('@@inside DocUrl');
        InvoiceServices  oInvoiceServices = new InvoiceServices();
        referenceKey = Apexpages.currentPage().getParameters().get('refkey');
        
        strUrl = '';
        oDocurl = new InvoiceServices.DocumentUrl();
        try{
            if(referenceKey != ''){
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
                    }else{
                        mapInvoiceDocTypes.put(oInvoiceDocType.Sales_Org__c,oInvoiceDocType.Doc_Types__c);
                    }
                }
                oDocrequest.EndPoint = oWebServiceSettings.Endpoint__c;
                //oDocrequest.Username = oWebServiceSettings.Username__c;
/*system.debug('DocRequest' + oRequest);-- commented to reduce character for s2e optimization */
                //oDocrequest.Password = oWebServiceSettings.Password__c;
                try{
                    String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration

                    oDocrequest.accessToken=accessToken;
            }
                    catch(Exception e){
                    ApexPages.addMessages(e);
            }
                oDocrequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();
                system.debug('DocRequest' + oRequest);
                oDocrequest.AccountSAPID = Integer.valueof(oAccount.SAPAccountNumber__c);
                oDocrequest.CompanyCode = strCompanyCode ;
                oDocrequest.SalesOrgCode = strSalesOrgCode;
                oDocrequest.DivisionCode = strDivisionCode;
                oDocrequest.DistChanCode = strDistChanCode;
                oDocrequest.ReferenceKey1 = referenceKey.escapeHtml4();
                oDocrequest.DocumentType = new List<String>();
                // oDocrequest.DocumentType = doclist;
/*system.debug(mapInvoiceDocTypes.get(strSalesOrgCode).split(';').size()+'hello');-- commented to reduce character for s2e optimization */
                oDocrequest.DocumentType = mapInvoiceDocTypes.get(strSalesOrgCode).split(';');
/*system.debug('DocRequest' + oRequest);
                system.debug('Document Response' + oDocurl);-- commented to reduce character for s2e optimization */
                oDocUrl = oInvoiceServices.getInvoiceDocumentUrl(oDocrequest);
/*system.debug('Document Response' + oDocurl);-- commented to reduce character for s2e optimization */
            }
/*system.debug('*********oDoc' + oDocUrl);-- commented to reduce character for s2e optimization */
            if(oDocUrl.Url != null){
                strUrl = oDocUrl.Url;
/*system.debug('MyUrl' +oDocUrl.Url);-- commented to reduce character for s2e optimization */
                //return oDocUrl.Url; 
                return null;
            }     
        }catch(Exception oException){
            if(oException.getMessage().contains('NO_PROVIDED_IMAGE_TYPES_CONFIG'))
               //ApexPages.addMessages(new AppUtil.AppException('The requested image is not found')); //Replaced with custom label as part of S2E Optimization
                 ApexPages.addMessages(new AppUtil.AppException(Label.ImageError));
            else    
                ApexPages.addMessages(oException);
        } 
        return null;
    }
    
    public List<SelectOption> getInvoiceItemType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(System.Label.AccountRec_SOAll,System.Label.AccountRec_SOAll));
        options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
        //if(profileName == 'LatAm User' || profileName == 'System Administrator'){
            options.add(new SelectOption(System.Label.AccountRec_SOOpenDue,System.Label.AccountRec_SOOpenDue));
            options.add(new SelectOption(System.Label.AccountRec_SOOpenNotDue,System.Label.AccountRec_SOOpenNotDue));
        //}
        options.add(new SelectOption(System.Label.AccountRec_SOCleared,System.Label.AccountRec_SOCleared));
        return options;
    }
    
    /*public String getDynamicFormatString()
    {
        Decimal value = 1000.10;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
        String decimalSep = formattedValue.substring(5,6);
        return '{0,number,\'#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00\'}';
    }*/
}