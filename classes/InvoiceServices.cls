/*CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC

2020-03-26        Shyamsundar Shet        BMP-1593 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

======================================================================================================================
*/

public with sharing class InvoiceServices {

    //Constants 
    public static final string WebServiceName = 'InvoiceServices';
    //public List<OpenItem> listOpenItem ;
    //public List<ClearedItem> listClearedItem ;
    public List<CombinedOpenClearedItems> listCombinedOpenClearedItems ;
    public Decimal totalAmount;
    public String frmtTotalAmount;
    public String TotalOpenItemAmount;
    public String TotalOpenItemAmountInvoiced;
    public String PastDueBalance;
    public static Map<String,IXOSCodeMap__c> oIXOSCodeMap;
                        
    public InvoiceServices() {
        oIXOSCodeMap = new Map<String,IXOSCodeMap__c>();
        for(IXOSCodeMap__c tempObj : IXOSCodeMap__c.getAll().Values()){
            oIXOSCodeMap.put(tempObj.Company_Code__c,tempObj);
        }
    }
    
    public DocumentUrl getInvoiceDocumentUrl(InvoiceDocUrlRequest oRequest){
        DocumentUrl oDocumentUrl = new DocumentUrl();
        InvoiceWSObject.DocumentUrl oResponse = new InvoiceWSObject.DocumentUrl();
        System.debug(oRequest+'Nand****');
        ValidationResult oValidationResult = validateRequest(oRequest);
        if(Test.isRunningTest())
        {
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            oResponse = oMockResponse.GetMockInvoiceDocumentUrl();
            System.debug(oResponse +'Nand****');
        }else{
            if (oValidationResult.IsValid == true){    
                  oResponse = returnservice(oRequest).GetInvoiceDocumentUrl(oRequest.AccountSAPID, oRequest.ReferenceKey1 ,oRequest.CompanyCode,
                                                                          oRequest.SalesOrgCode,oRequest.DistChanCode ,
                                                                          oRequest.DivisionCode,oRequest.DocumentType);
           }
        }
        if(oResponse!=null){
            oDocumentUrl = new DocumentUrl(oResponse);System.debug(oDocumentUrl +'Nand$$$response');
        }
        return oDocumentUrl ;
    }
    
    public List<CombinedOpenClearedItems> getInvoiceItems(InvoiceServices.InvoiceItemsRequest oInvoiceItemsRequest){
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);    
        oInvoiceItemsRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        //InvoiceWS.Invoice_v4_0Port oService = new InvoiceWS.Invoice_v4_0Port();
        //oService.inputHttpHeaders_x = new Map<String, String>();
        /*try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration

          oInvoiceItemsRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        }*/
        oInvoiceItemsRequest.Username = oWebServiceSettings.Username__c;
        oInvoiceItemsRequest.Password = oWebServiceSettings.Password__c;
        oInvoiceItemsRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();
        
        listCombinedOpenClearedItems = new List<CombinedOpenClearedItems>();
        OpenClearedItems oOpenClearedItems = new OpenClearedItems();
    
        ValidationResult oValidationResult = validateRequest(oInvoiceItemsRequest);
        InvoiceWSObject.OpenClearedItems  oOpenClearedItemsResponse = new InvoiceWSObject.OpenClearedItems ();

        if(Test.isRunningTest()){
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            oOpenClearedItemsResponse = oMockResponse.GetMockInvoiceItems();
            System.debug(oOpenClearedItemsResponse+'Nand****');
        }else{
            if(oValidationResult.IsValid == true){  
                oOpenClearedItemsResponse = returnservice(oInvoiceItemsRequest).GetInvoiceItems
                                                (
                                                oInvoiceItemsRequest.AccountSAPID,oInvoiceItemsRequest.CompanyCode,
                                                oInvoiceItemsRequest.SalesOrgCode,oInvoiceItemsRequest.DistChanCode,
                                                oInvoiceItemsRequest.DivisionCode,oInvoiceItemsRequest.InvoiceBegDt , 
                                                oInvoiceItemsRequest.InvoiceEndDt,oInvoiceItemsRequest.OpenItemsRequested, 
                                                oInvoiceItemsRequest.ClearedItemsRequested,oInvoiceItemsRequest.AdditionalTextRequested);
            }                         
        }
        if(oOpenClearedItemsResponse != null){
            oOpenClearedItems.TotalOpenItemAmount = oOpenClearedItemsResponse.TotalOpenItemAmount;
            oOpenClearedItems.TotalOpenItemAmountInvoiced = oOpenClearedItemsResponse.TotalOpenItemAmountInvoiced;
            oOpenClearedItems.PastDueBalance = oOpenClearedItemsResponse.PastDueBalance;
            if(oOpenClearedItemsResponse.OpenItem!=null){
                for(InvoiceWSObject.OpenItem oOpenitem : oOpenClearedItemsResponse.OpenItem){
                    listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oOpenitem));                    
                }  
            }
            if(oOpenClearedItemsResponse.ClearedItem!=null){                  
                for(InvoiceWSObject.ClearedItem oClearedItem  : oOpenClearedItemsResponse.ClearedItem ){
                    listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oClearedItem));
                }
            }
        }
        return listCombinedOpenClearedItems ;       
    }
    
    public List<CombinedOpenClearedItems> getInvoiceItemsMISSOA(InvoiceServices.InvoiceItemsRequest oInvoiceItemsRequest, String sSelectedOption){
        totalAmount = 0;
        frmttotalAmount = '0';
        listCombinedOpenClearedItems = new List<CombinedOpenClearedItems>();
        //validate request Obj
        ValidationResult oValidationResult = validateRequest(oInvoiceItemsRequest);
        ARWebServices.InvoiceItems responseObjtemp = new ARWebServices.InvoiceItems();
        if(oValidationResult.IsValid == true){  
            //try{
                String profileName;
                id id1 = userinfo.getProfileId();
                Profile pObj = [select Name from profile where id = :id1];
                
                profileName = pObj.Name;
                //Prepare AR service request Obj
                ARWebServices.GetInvoiceItemsRequest reqObj = new ARWebServices.GetInvoiceItemsRequest();
                //build the parameters for sending the request
                reqObj.context = new ARWebServices.context_element();
                reqObj.context.productId = (KeyValueListStore__c.getInstance('ARServiceProductId')==null)?'':KeyValueListStore__c.getInstance('ARServiceProductId').TextValue__c; //'SF03';//similar to BigRuleProductId
                reqObj.context.configGroup = (KeyValueListStore__c.getInstance('ARServiceCconfigGroup')==null)?'':KeyValueListStore__c.getInstance('ARServiceCconfigGroup').TextValue__c; //'TRD';//similar to BigRuleCconfigGroup
                reqObj.Cleared = 'Y';//oInvoiceItemsRequest.ClearedItemsRequested;
                reqObj.acctSapId = String.valueOf(oInvoiceItemsRequest.AccountSAPID);
                reqObj.invoiceBegDt = String.valueOf(oInvoiceItemsRequest.InvoiceBegDt);
                reqObj.IRootId = '';
                reqObj.ISourceId = '';
                reqObj.invoiceEndDt = String.valueOf(oInvoiceItemsRequest.InvoiceEndDt);
                reqObj.OpenItemsRequested = oInvoiceItemsRequest.OpenItemsRequested;
                reqObj.ClearedItemsRequested = oInvoiceItemsRequest.ClearedItemsRequested;
                reqObj.AdditionalTextRequested = oInvoiceItemsRequest.AdditionalTextRequested;
                //if(profileName == 'LatAm User' || profileName == 'System Administrator'){
                    reqObj.companyCode = '';
                    reqObj.SalesOrgCode = '';
                    reqObj.distChanCode = '';
                    reqObj.divisionCode = '';
                //}else{
                //    reqObj.companyCode = oInvoiceItemsRequest.CompanyCode;
                //    reqObj.SalesOrgCode = oInvoiceItemsRequest.SalesOrgCode;
                //    reqObj.distChanCode = oInvoiceItemsRequest.DistChanCode;
                //    reqObj.divisionCode = oInvoiceItemsRequest.DivisionCode;
                //} 
                
                ARWebServices.ARServiceV01 serObj = new ARWebServices.ARServiceV01();
                serObj.endpoint_x = oInvoiceItemsRequest.EndPoint;
                serObj.inputHttpHeaders_x = new Map<String,String>();
                //Blob blobCredentials = Blob.valueOf(oInvoiceItemsRequest.Username + ':' + oInvoiceItemsRequest.Password);
                //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
                string sAuthorizationHeader = 'Bearer ' + oInvoiceItemsRequest.accessToken;
                serObj.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                serObj.outputHttpHeaders_x = new Map<String,String>();
                serObj.timeout_x = (Decimal.ValueOf(oInvoiceItemsRequest.Timeout) * 10).intValue();
                ARWebServicesHeaders.X_element eleObj = new ARWebServicesHeaders.X_element();
                eleObj.ServiceVersion = System.label.ARServiceVersion; //'16.02';//similar to customerServiceVersion
                ARWebServicesHeaders.Message_element msgEleObj = new ARWebServicesHeaders.Message_element();
                msgEleObj.X = eleObj;
                ARWebServicesHeaders.TocHeader_element headEleObj = new ARWebServicesHeaders.TocHeader_element();
                headEleObj.Message = msgEleObj;
                serObj.header = headEleObj;
                System.debug('Request obj0 : '+serObj.timeout_x);
                System.debug('Request obj : '+reqObj);
                if(Test.isRunningTest())
                {
                      InvoiceServices_Test oMockResponse = new InvoiceServices_Test();  
                    //MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
                    responseObjtemp = oMockResponse.GetMockInvoiceItemsMISSOA2();
                    //responseObjtemp = oMockResponse.GetMockInvoiceItemsMISSOA();
                    System.debug(responseObjtemp+'Nand****');
                }
                else{
                    responseObjtemp = serObj.getInvoiceItems(reqObj);
                }
                System.debug('Response obj : '+responseObjtemp);
                if(responseObjtemp != null && responseObjtemp.invoiceItems!=null){
                    ARWebServices.InvoiceItemsOpenCleared responseObj = responseObjtemp.invoiceItems;
                    TotalOpenItemAmount = responseObj.TotalOpenItemAmount;
                    TotalOpenItemAmountInvoiced = responseObj.TotalOpenItemAmountInvoiced;
                    PastDueBalance = responseObj.PastDueBalance;
                    if(sSelectedOption == System.Label.AccountRec_SOAll){
                        if(responseObj.OpenItemsOut!=null && responseObj.OpenItemsOut.size()>0){// && responseObj.OpenItemsOut[0].item!=null
                            for(ARWebServices.InvoiceOpenItemsOut invOpItemList :  responseObj.OpenItemsOut){
                                if(invOpItemList.item != null){
                                    for(ARWebServices.OpenItemsOutList oOpenitem : invOpItemList.item){//responseObj.OpenItemsOut[0].item
                                        listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oOpenitem));                    
                                    } 
                                }
                            } 
                        }
                        if(responseObj.ClearedItemsOut!=null && responseObj.ClearedItemsOut.size()>0){// && responseObj.ClearedItemsOut[0].item!=null                  
                            for(ARWebServices.InvoiceClearedItemsOut invClrItemList :  responseObj.ClearedItemsOut){
                                if(invClrItemList.item != null){
                                    for(ARWebServices.ClearedItemsOutList oClearedItem  : invClrItemList.item){//responseObj.ClearedItemsOut[0].item
                                        listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oClearedItem));
                                    }
                                }
                            }
                        }
                    }else if(sSelectedOption == System.Label.AccountRec_SOOpen){  
                        if(responseObj.OpenItemsOut!=null && responseObj.OpenItemsOut.size()>0){// && responseObj.OpenItemsOut[0].item!=null
                            for(ARWebServices.InvoiceOpenItemsOut invOpItemList :  responseObj.OpenItemsOut){
                                if(invOpItemList.item != null){
                                    for(ARWebServices.OpenItemsOutList oOpenitem : invOpItemList.item){//responseObj.OpenItemsOut[0].item
                                        CombinedOpenClearedItems tempObj = new CombinedOpenClearedItems(oOpenitem);
                                        listCombinedOpenClearedItems.add(tempObj);  
                                        totalAmount += tempObj.Amount;   
                                        //listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oOpenitem));  
                                        //Decimal amountVal = (oOpenItem.Amount==null || oOpenItem.Amount=='')?0.0:Decimal.valueOf(oOpenItem.Amount);
                                        //amountVal = (oOpenItem.DebitCreditInd!=null && oOpenItem.DebitCreditInd!='' && oOpenItem.DebitCreditInd=='H')?-1*amountVal:amountVal;
                                        //totalAmount += amountVal;                  
                                        //totalAmount += Decimal.valueOf(oOpenItem.Amount);                  
                                    } 
                                }
                            } 
                        }
                        //totalAmount = Decimal.valueOf(TotalOpenItemAmount);
                    }else if(sSelectedOption == System.Label.AccountRec_SOOpenDue){ 
                        if(responseObj.OpenItemsOut!=null && responseObj.OpenItemsOut.size()>0){// && responseObj.OpenItemsOut[0].item!=null
                            for(ARWebServices.InvoiceOpenItemsOut invOpItemList :  responseObj.OpenItemsOut){
                                if(invOpItemList.item != null){
                                    for(ARWebServices.OpenItemsOutList oOpenitem : invOpItemList.item){//responseObj.OpenItemsOut[0].item
                                        CombinedOpenClearedItems tempObj = new CombinedOpenClearedItems(oOpenitem);
                                        if(tempObj.DueDt!=null && tempObj.DueDt < Date.Today()){
                                        //if(oOpenitem.PastDueFlag == TRUE){
                                            listCombinedOpenClearedItems.add(tempObj);  
                                            totalAmount += tempObj.Amount;                  
                                            //listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oOpenitem));  
                                            //Decimal amountVal = (oOpenItem.Amount==null || oOpenItem.Amount=='')?0.0:Decimal.valueOf(oOpenItem.Amount);
                                            //amountVal = (oOpenItem.DebitCreditInd!=null && oOpenItem.DebitCreditInd!='' && oOpenItem.DebitCreditInd=='H')?-1*amountVal:amountVal;
                                            //totalAmount += amountVal;                  
                                            //totalAmount += Decimal.valueOf(oOpenItem.Amount); 
                                        }                 
                                    }
                                }
                            }  
                        }
                        //totalAmount = Decimal.valueOf(PastDueBalance);
                    }else if(sSelectedOption == System.Label.AccountRec_SOOpenNotDue){  
                         if(responseObj.OpenItemsOut!=null && responseObj.OpenItemsOut.size()>0){// && responseObj.OpenItemsOut[0].item!=null
                            for(ARWebServices.InvoiceOpenItemsOut invOpItemList :  responseObj.OpenItemsOut){
                                if(invOpItemList.item != null){
                                    for(ARWebServices.OpenItemsOutList oOpenitem : invOpItemList.item){//responseObj.OpenItemsOut[0].item
                                        CombinedOpenClearedItems tempObj = new CombinedOpenClearedItems(oOpenitem);
                                        if(tempObj.DueDt!=null && tempObj.DueDt >= Date.Today()){
                                        //if(oOpenitem.PastDueFlag == FALSE){
                                            listCombinedOpenClearedItems.add(tempObj);  
                                            totalAmount += tempObj.Amount;                  
                                            //listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oOpenitem));  
                                            //Decimal amountVal = (oOpenItem.Amount==null || oOpenItem.Amount=='')?0.0:Decimal.valueOf(oOpenItem.Amount);
                                            //amountVal = (oOpenItem.DebitCreditInd!=null && oOpenItem.DebitCreditInd!='' && oOpenItem.DebitCreditInd=='H')?-1*amountVal:amountVal;
                                            //totalAmount += amountVal;                  
                                            //totalAmount += Decimal.valueOf(oOpenItem.Amount); 
                                        }                 
                                    }
                                }
                            }  
                        }
                        //totalAmount = Decimal.valueOf(TotalOpenItemAmountInvoiced);
                    }else if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
                        if(responseObj.ClearedItemsOut!=null && responseObj.ClearedItemsOut.size()>0){// && responseObj.ClearedItemsOut[0].item!=null                  
                            for(ARWebServices.InvoiceClearedItemsOut invClrItemList :  responseObj.ClearedItemsOut){
                                if(invClrItemList.item != null){
                                    for(ARWebServices.ClearedItemsOutList oClearedItem  : invClrItemList.item){//responseObj.ClearedItemsOut[0].item
                                        listCombinedOpenClearedItems.add(new CombinedOpenClearedItems(oClearedItem));
                                    }
                                }
                            }
                        }
                    }
                    frmttotalAmount = getfrmtAmountValue(totalAmount);   
                }
            //}catch(Exception e){
            //    System.debug('Exception : '+e.getMessage());
            //    System.debug('Exception : '+e.getStackTraceString());
            //}
        }
        return listCombinedOpenClearedItems ;      
    }
    
    public Static String getfrmtAmountValue(Decimal amt){
        Decimal value = 1000.10;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
        String decimalSep = formattedValue.substring(5,6);
        
        Long amountVal = amt.longValue();
        String frmtAmt = amt.format();
        if(amountVal == amt){
            frmtAmt = amt.format()+decimalSep+'0';
        }
        //system.debug('test : '+amt+' : '+amountVal+' : '+(amountVal == amt)+' : '+amt.setScale(2)+' : '+frmtAmt);
        return frmtAmt;
    }
    
    public virtual class Request{
        public string EndPoint {get;set;}
        public string Username {get;set;}
        public string Password {get;set;}
        public integer Timeout {get;set;}
        public Decimal AccountSAPID {get;set;}
        public String CompanyCode {get;set;}
        public String SalesOrgCode {get;set;}
        public String DistChanCode {get;set;}
        public String DivisionCode {get;set;}
        public String accessToken {get;set;}
    }
    
    
    public class InvoiceDocUrlRequest extends Request{
        public String ReferenceKey1 {get;set;}
        public String[] DocumentType {get;set;}
    }
    
    public class InvoiceItemsRequest extends Request{
        public Boolean OpenItemsRequested {get;set;}
        public Boolean ClearedItemsRequested {get;set;}
        public Boolean AdditionalTextRequested {get;set;}
        public Date InvoiceBegDt {get;set;}
        public date InvoiceEndDt {get;set;}
    }
    
    Public InvoiceWS.Invoice_v4_0Port returnService(Request oRequest){
        InvoiceWS.Invoice_v4_0Port oService = new InvoiceWS.Invoice_v4_0Port();
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.timeout_x = oRequest.Timeout;
        oService.endpoint_x = oRequest.EndPoint;      
        //Blob blobCredentials = Blob.valueOf(oRequest.Username + ':' + oRequest.Password);
        //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        try{
                string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;//retreives the token as part of Rocket to Dellboomi migration
        
                oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
                catch(Exception e){
            ApexPages.addMessages(e);
    }             

        oService.outputHttpHeaders_x = new Map<String,String>();
        return oService;
    }
        
        
    public ValidationResult validateRequest(Request oRequest) {
        ValidationResult oValidation = new ValidationResult();
        oValidation.IsValid = true;
        if (oRequest != null){
            //Validate Request Credentials
            boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
            if (isMissingEndpoint){
                oValidation.IsValid = false;
                oValidation.Failures.add('Invalid request. Web service endpoint is not configured');
            }
            //Validate Timeout Limit
            boolean isTimeoutValid = (oRequest.Timeout > 0);
            if (!isTimeoutValid){
                oValidation.IsValid = false;
                oValidation.Failures.Add(System.Label.InvalidTimeoutValue);  
            }
        }
        else{
          oValidation.IsValid = false;
          oValidation.Failures.add('Invalid Request Object. Request can not be null');
        }
        return oValidation;
    }
      
    
    public class OpenItem{
        public Boolean PastDueFlag {get;set;}
        public Date DocumentDt {get;set;}
        public String DocumentType {get;set;}
        public String DocumentNumber {get;set;}
        public String InvoiceNumber {get;set;}
        public String ReferenceKey1 {get;set;}
        public String DebitCreditInd {get;set;}
        public Decimal Amount {get;set;}
        public String ReasonCode {get;set;}
        public Date BaselineDt {get;set;}
        public Integer ArrearDays {get;set;}
        public Integer LineNumber {get;set;}
        public Date ServicesRenderedDt {get;set;}
        public Date ClearingDt {get;set;}
        public Date PostingDt {get;set;}
        public String ShortDesc {get;set;}
        public String LongDesc {get;set;}
        public String PdfLinkInd {get;set;}
        public String DunningArea {get;set;}
        public String ProcessingStatus {get;set;}
        public Decimal ShipToAcctSapID {get;set;}
        public String DunningBlock {get;set;}
        
    }
    
    public class ClearedItem{
        public Date DocumentDt {get;set;}
        public String DocumentType {get;set;}
        public String DocumentNumber {get;set;}
        public String InvoiceNumber {get;set;}
        public String ReferenceKey1 {get;set;}
        public String DebitCreditInd {get;set;}
        public String CurrencyInd {get;set;}
        public Decimal Amount {get;set;}
        public String ReasonCode {get;set;}
        public Date BaselineDt {get;set;}
        public Date DueDt {get;set;}
        public Integer ArrearDays {get;set;}
        public String AllocationNumber {get;set;}
        public Date ClearingDt {get;set;}
        public String ClearingDocumentNumber {get;set;}
        public Date PostingDt {get;set;}
        public String ShortDesc {get;set;}
        public String LongDesc {get;set;}
        public String DunningArea {get;set;}
        public String DunningBlock {get;set;}
        public Integer DunningLevel {get;set;}
        public Date LastDunnedDt {get;set;}
        public String PaymentMethod {get;set;}
        public String ReferenceDocumentNumber {get;set;}
        public String Referencekey2 {get;set;}
        public String SpecialGeneralLedgerInd {get;set;}
        public Decimal ShipToAcctSapID {get;set;}
    }
    
    public class CombinedOpenClearedItems{
        public Boolean PastDueFlag {get;set;}
        public Date DocumentDt {get;set;}
        public String DocumentType {get;set;}
        public String DocumentDesc {get;set;}
        public String DocumentNumber {get;set;}
        public String InvoiceNumber {get;set;}
        public String ReferenceKey1 {get;set;}
        public String DebitCreditInd {get;set;}
        public Decimal Amount {get;set;}
        public String frmtAmount {get;set;}
        public String ReasonCode {get;set;}
        public Date BaselineDt {get;set;}
        public Integer ArrearDays {get;set;}
        public Integer LineNumber {get;set;}
        public Date ServicesRenderedDt {get;set;}
        public Date ClearingDt {get;set;}
        public Date PostingDt {get;set;}
        public String ShortDesc {get;set;}
        public String LongDesc {get;set;}
        public String PdfLinkInd {get;set;}
        public String DunningArea {get;set;}
        public String ProcessingStatus {get;set;}
        public Decimal ShipToAcctSapID {get;set;}
        public String DunningBlock {get;set;}
        public String CurrencyInd {get;set;}
        public Date DueDt {get;set;}
        public String AllocationNumber {get;set;}
        public String ClearingDocumentNumber {get;set;}
        public Integer DunningLevel {get;set;}
        public Date LastDunnedDt {get;set;}
        public String PaymentMethod {get;set;}
        public String ReferenceDocumentNumber {get;set;}
        public String Referencekey2 {get;set;}
        public String SpecialGeneralLedgerInd {get;set;}
        public String compCode{get;set;}
        public String salesOrg{get;set;}
    public String reference{get;set;}
        
        public CombinedOpenClearedItems(InvoiceWSObject.OpenItem oOpenitem){
            PastDueFlag  = oOpenItem.PastDueFlag;
            DocumentDt  = oOpenItem.DocumentDt;
            DocumentType  = oOpenItem.DocumentType;
            DocumentDesc  = getDocumentDesc(DocumentType);
            DocumentNumber  = oOpenItem.DocumentNumber;
            InvoiceNumber  = oOpenItem.InvoiceNumber;
            ReferenceKey1  = oOpenItem.ReferenceKey1;
            DebitCreditInd  = oOpenItem.DebitCreditInd;
            Amount  = oOpenItem.Amount;
            ReasonCode  = oOpenItem.ReasonCode;
            BaselineDt  = oOpenItem.BaselineDt;
            ArrearDays  = oOpenItem.ArrearDays;
            LineNumber  = oOpenItem.LineNumber;
            ServicesRenderedDt  = oOpenItem.ServicesRenderedDt;
            ClearingDt  = oOpenItem.ClearingDt;
            PostingDt  = oOpenItem.PostingDt;
            ShortDesc  = oOpenItem.ShortDesc;
            LongDesc  = oOpenItem.LongDesc;
            PdfLinkInd  = oOpenItem.PdfLinkInd;
            DunningArea  = oOpenItem.DunningArea;
            ProcessingStatus  = oOpenItem.ProcessingStatus;
            ShipToAcctSapID  = oOpenItem.ShipToAcctSapID;
            DunningBlock  = oOpenItem.DunningBlock;
        }
        public CombinedOpenClearedItems(InvoiceWSObject.ClearedItem oClearedItem){
            DocumentDt  = oClearedItem.DocumentDt;
            DocumentType  = oClearedItem.DocumentType;
            DocumentDesc  = getDocumentDesc(DocumentType);
            DocumentNumber  = oClearedItem.DocumentNumber;
            InvoiceNumber  = oClearedItem.InvoiceNumber;
            ReferenceKey1  = oClearedItem.ReferenceKey1;
            DebitCreditInd  = oClearedItem.DebitCreditInd;
            CurrencyInd = oClearedItem.CurrencyInd ;
            Amount  = oClearedItem.Amount;
            ReasonCode  = oClearedItem.ReasonCode;
            BaselineDt  = oClearedItem.BaselineDt;
            DueDt = oClearedItem.DueDt ;
            ArrearDays  = oClearedItem.ArrearDays;
            AllocationNumber = oClearedItem.AllocationNumber ;                
            ClearingDt  = oClearedItem.ClearingDt;
            ClearingDocumentNumber = oClearedItem.ClearingDocumentNumber ;
            PostingDt  = oClearedItem.PostingDt;
            ShortDesc  = oClearedItem.ShortDesc;
            LongDesc  = oClearedItem.LongDesc;                
            DunningArea  = oClearedItem.DunningArea;
            DunningBlock  = oClearedItem.DunningBlock;
            DunningLevel = oClearedItem.DunningLevel ;
            LastDunnedDt = oClearedItem.LastDunnedDt ;
            PaymentMethod = oClearedItem.PaymentMethod ;
            ReferenceDocumentNumber = oClearedItem.ReferenceDocumentNumber ;
            Referencekey2 = oClearedItem.Referencekey2 ;
            SpecialGeneralLedgerInd = oClearedItem.SpecialGeneralLedgerInd ;
            ShipToAcctSapID  = oClearedItem.ShipToAcctSapID;
        }
        public CombinedOpenClearedItems(ARWebServices.ClearedItemsOutList oClearedItem){
      reference = oClearedItem.ReferenceDocumentNumber;
            DocumentDt  = parseDateValue(oClearedItem.DocumentDt);
            DocumentType  = oClearedItem.DocumentType;
            DocumentDesc  = getDocumentDesc(DocumentType);
            DocumentNumber  = oClearedItem.DocumentNumber;
            InvoiceNumber  = oClearedItem.InvoiceNumber;
            ReferenceKey1  = oClearedItem.ReferenceKey1;
            DebitCreditInd  = oClearedItem.DebitCreditInd;
            CurrencyInd = oClearedItem.CurrencyInd;
            //Amount  = (oClearedItem.Amount==null || oClearedItem.Amount=='')?0.0:Decimal.valueOf(oClearedItem.Amount);
            Amount  = getAmountValue(oClearedItem.Amount, oClearedItem.DebitCreditInd);
            frmtAmount = Amount.format();
            ReasonCode  = oClearedItem.ReasonCode;
            BaselineDt  = parseDateValue(oClearedItem.BlineDate);
            DueDt = parseDateValue(oClearedItem.DueDt);
            ArrearDays  = (oClearedItem.ArrearDays==null || oClearedItem.ArrearDays=='')?0:Integer.valueOf(oClearedItem.ArrearDays);
            AllocationNumber = oClearedItem.AllocationNumber;                
            ClearingDt  = parseDateValue(oClearedItem.ClearingDt);
            ClearingDocumentNumber = oClearedItem.ClearingDocumentNumber;
            PostingDt  = parseDateValue(oClearedItem.PostingDt);
            ShortDesc  = oClearedItem.ShortDesc;
            LongDesc  = oClearedItem.LongDesc;                
            DunningArea  = oClearedItem.DunningArea;
            DunningBlock  = oClearedItem.DunningBlock;
            DunningLevel = (oClearedItem.DunningLevel==null || oClearedItem.DunningLevel=='')?0:Integer.valueOf(oClearedItem.DunningLevel);
            LastDunnedDt = parseDateValue(oClearedItem.LastDunnedDt);
            PaymentMethod = oClearedItem.PaymentMethod;
            ReferenceDocumentNumber = oClearedItem.ReferenceDocumentNumber;
            Referencekey2 = oClearedItem.Referencekey2;
            SpecialGeneralLedgerInd = oClearedItem.SpecialGeneralLedgerInd;
            ShipToAcctSapID = (oClearedItem.ShipToAcctSapID==null || oClearedItem.ShipToAcctSapID=='')?0.0:Decimal.valueOf(oClearedItem.ShipToAcctSapID);
            compCode = oClearedItem.CompCode;
            salesOrg = (InvoiceServices.oIXOSCodeMap.get(compCode)!=null)?InvoiceServices.oIXOSCodeMap.get(compCode).Sales_Org_Code__c:'';
        }
        public CombinedOpenClearedItems(ARWebServices.OpenItemsOutList oOpenitem){
      reference = oOpenitem.ReferenceDocumentNumber;
            PastDueFlag  = oOpenItem.PastDueFlag;
            DocumentDt  = parseDateValue(oOpenItem.DocumentDt);
            DocumentType  = oOpenItem.DocumentType;
            DocumentDesc  = getDocumentDesc(DocumentType);
            DocumentNumber  = oOpenItem.DocumentNumber;
            InvoiceNumber  = oOpenItem.InvoiceNumber;
            ReferenceKey1  = oOpenItem.ReferenceKey1;
            DebitCreditInd  = oOpenItem.DebitCreditInd;
            CurrencyInd = oOpenItem.Currency_x;
            //Amount  = (oOpenItem.Amount==null || oOpenItem.Amount=='')?0.0:Decimal.valueOf(oOpenItem.Amount);
            Amount  = getAmountValue(oOpenItem.Amount, oOpenItem.DebitCreditInd);
            frmtAmount = InvoiceServices.getfrmtAmountValue(Amount);
            ReasonCode  = oOpenItem.ReasonCode;
            BaselineDt  = parseDateValue(oOpenItem.BaselineDt);
            DueDt = parseDateValue(oOpenItem.DueDt);
            ArrearDays  = (oOpenItem.ArrearDays==null || oOpenItem.ArrearDays=='')?0:Integer.valueOf(oOpenItem.ArrearDays);
            LineNumber  = (oOpenItem.LineNumber==null || oOpenItem.LineNumber=='')?0:Integer.valueOf(oOpenItem.LineNumber);
            ServicesRenderedDt  = parseDateValue(oOpenItem.ServicesRenderedDt);
            ClearingDt  = parseDateValue(oOpenItem.ClearingDt);
            PostingDt  = parseDateValue(oOpenItem.PostingDt);
            ShortDesc  = oOpenItem.ShortDesc;
            LongDesc  = oOpenItem.LongDesc;
            PdfLinkInd  = oOpenItem.PdfLinkInd;
            DunningArea  = oOpenItem.DunningArea;
            ProcessingStatus  = oOpenItem.ProcessingStatus;
            ShipToAcctSapID  = (oOpenItem.ShipToAcctSapID==null || oOpenItem.ShipToAcctSapID=='')?0.0:Decimal.valueOf(oOpenItem.ShipToAcctSapID);
            DunningBlock  = oOpenItem.DunningBlock;
            compCode = oOpenItem.CompCode;
            salesOrg = (InvoiceServices.oIXOSCodeMap.get(compCode)!=null)?InvoiceServices.oIXOSCodeMap.get(compCode).Sales_Org_Code__c:'';
        }
        public String getDocumentDesc(String docCode){
            String docDesc = '';
            if(DocumentCodeToDescMap__c.getValues(docCode) != null){
                if(userinfo.getLanguage() == 'es'){
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc_Spanish__c;
                }else if(userinfo.getLanguage() == 'pt_BR'){
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc_Portuguese__c;
                }else{
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c;
                }
                if(docDesc==null || docDesc==''){
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c;
                }
            }
            //if(DocumentCodeToDescMap__c.getValues(docCode) != null && DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c!=null && DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c!=''){
            //    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c;
            //}
            return docDesc;
        }
        public Date parseDateValue(String dtString){
            Date dtValue = null;
            try{
                //System.debug('dtString : '+dtString); 
                if(dtString != null && dtString !=''){
                    List<String> splitDate = dtString.split('/');
                    if(splitDate != null && splitDate.size() == 3){
                        Integer day = (splitDate[1]==null || splitDate[1]=='')?0:Integer.valueOf(splitDate[1]);
                        Integer month = (splitDate[0]==null || splitDate[0]=='')?0:Integer.valueOf(splitDate[0]);
                        Integer year = (splitDate[2]==null || splitDate[2]=='')?0:Integer.valueOf(splitDate[2]);
                        if(day != 0 && month != 0 && year != 0)
                            dtValue = Date.newinstance(year, month, day);
                    }
                }
                //dtValue = (dtString == null || dtString =='')?null:Date.parse(dtString);
            }catch(Exception e){System.debug('e msg: '+e.getMessage());System.debug('e trace: '+e.getStackTraceString());}
            //System.debug('dtString : return : '+dtValue);
            return dtValue;
        }
        public Decimal getAmountValue(String amt, String ind){
            Decimal amountVal = (amt==null || amt=='')?0.0:Decimal.valueOf(amt);
            amountVal = (ind!=null && ind!='' && ind=='H')?-1*amountVal:amountVal;
            return amountVal;
        }
    }
    
    public class OpenClearedItems {
        public Decimal TotalOpenItemAmount {get;set;}
        public Decimal TotalOpenItemAmountInvoiced {get;set;}
        public Decimal PastDueBalance {get;set;}
        public List<ClearedItem> ListClearedItem {get;set;}
        public List<OpenItem> ListOpenItem {get;set;}
        
        public OpenClearedItems(){
            ListClearedItem = new List<ClearedItem>();
            ListOpenItem = new List<OpenItem>();
        }
    }
    
    public class DocumentUrl {
        public String Url {get;set;}
        public DocumentUrl(){}
        public DocumentUrl(InvoiceWSObject.DocumentUrl oDocumentUrl){
            Url =oDocumentUrl.Url;
        }
    }
    /*
    public class InvoiceItem {
        public String BillingDocumentNumber {get;set;}
        public String InvoiceNumber {get;set;}
        public Integer LineItemNumber {get;set;}
        public Integer PositionNumber {get;set;}
        public Decimal NumberOfUnits {get;set;}
        public Decimal NetPerUnit {get;set;}
        public Decimal TotalNetAmount {get;set;}
        public Decimal TaxPerUnit {get;set;}
        public Decimal TotalTaxAmount {get;set;}
        public String MaterialNumber {get;set;}
        public String MaterialDesc {get;set;}
        public Date ServicesRenderedDt {get;set;}
    }
     
    public class InvoiceDetail {
        public Decimal NetAmount {get;set;}
        public Decimal TaxAmount {get;set;}
        public Decimal TotalAmount {get;set;}
        public List <InvoiceItem> ListInvoiceItem {get;set;}
    }*/
}