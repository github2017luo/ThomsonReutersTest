/**
 * Validates the functionality provided by the InvoiceController class.
 *
 * @author  TCS
 * @version  2016-09-27
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2016-09-27   TCS                     Created                                                                   
 * =============================================================================
 */


@isTest
public class InvoiceServices_Test{
    
    public static testmethod void testInvoiceServicesMISSOA(){
        

		UnitTest.createTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1234';
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;
        //IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(testAcc1.Sales_org__c);
        IXOSCodeMap__c oIXOSCodeMap = new IXOSCodeMap__c();
        oIXOSCodeMap.Name='West';
        oIXOSCodeMap.Company_Code__c='0010';
        oIXOSCodeMap.Dist_Chan_Code__c='W';
        oIXOSCodeMap.Division_Code__c='W';
        oIXOSCodeMap.Sales_Org_Code__c='WEST';
        insert oIXOSCodeMap;  
        try{
            AppUtil.getWebServiceSettings('InvoiceServicesMISSOA');
        }catch(Exception e){
            WebServiceSettings__c oAddressCleanseSettings = new WebServiceSettings__c();
            oAddressCleanseSettings.Name = 'InvoiceServicesMISSOA';
            oAddressCleanseSettings.Endpoint__c = 'https:\\thomsonreuters.com';
            oAddressCleanseSettings.Timeout__c = 5;
            oAddressCleanseSettings.Active__c = true;
            oAddressCleanseSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
            insert oAddressCleanseSettings;
        }
        Test.StartTest();
        	ARWebServices.invoiceItems arweb = new ARWebServices.invoiceItems();
            InvoiceServices.InvoiceItemsRequest oRequest = new InvoiceServices.InvoiceItemsRequest(); 
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServicesMISSOA');
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Username = oWebServiceSettings.Username__c;
            oRequest.Password = oWebServiceSettings.Password__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();            
            oRequest.AccountSAPID = Decimal.valueOf(testAcc1.SAPAccountNumber__c);
            oRequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
            oRequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            oRequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            oRequest.DivisionCode = oIXOSCodeMap.Division_Code__c;
            oRequest.OpenItemsRequested = true;
            oRequest.ClearedItemsRequested = true;
            oRequest.AdditionalTextRequested = true;
            oRequest.InvoiceBegDt = date.parse('06/27/2009');
            oRequest.InvoiceEndDt = date.parse('12/27/2009');
            InvoiceServices invSerObj = new InvoiceServices();
            List<InvoiceServices.CombinedOpenClearedItems> InvoiceItemList = invSerObj.getInvoiceItemsMISSOA(oRequest,'All') ;
            
            String sSelectedOption = System.Label.AccountRec_SOOpen;
            if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOOpenDue || sSelectedOption == System.Label.AccountRec_SOOpenNotDue){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceItemList = invSerObj.getInvoiceItemsMISSOA(oRequest,sSelectedOption) ;
            
            sSelectedOption = System.Label.AccountRec_SOOpenDue;
            if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOOpenDue || sSelectedOption == System.Label.AccountRec_SOOpenNotDue){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceItemList = invSerObj.getInvoiceItemsMISSOA(oRequest,sSelectedOption) ;
            
            sSelectedOption = System.Label.AccountRec_SOOpenNotDue;
            if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOOpenDue || sSelectedOption == System.Label.AccountRec_SOOpenNotDue){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceItemList = invSerObj.getInvoiceItemsMISSOA(oRequest,sSelectedOption) ;
            
            sSelectedOption = System.Label.AccountRec_SOCleared;
            if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOOpenDue || sSelectedOption == System.Label.AccountRec_SOOpenNotDue){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceItemList = invSerObj.getInvoiceItemsMISSOA(oRequest,sSelectedOption) ;
        Test.StopTest();
    }
    
    public static testmethod void testInvoiceServicesRocket(){
        

		UnitTest.createTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1234';
        testAcc1.Sales_Org__c = 'West';
        insert testAcc1;
        
        //IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(testAcc1.Sales_org__c);
        IXOSCodeMap__c oIXOSCodeMap = new IXOSCodeMap__c();
        oIXOSCodeMap.Name='West';
        oIXOSCodeMap.Company_Code__c='0010';
        oIXOSCodeMap.Dist_Chan_Code__c='W';
        oIXOSCodeMap.Division_Code__c='W';
        oIXOSCodeMap.Sales_Org_Code__c='WEST';
        insert oIXOSCodeMap;  
        
        try{
            AppUtil.getWebServiceSettings('InvoiceServices');
        }catch(Exception e){
            WebServiceSettings__c oAddressCleanseSettings = new WebServiceSettings__c();
            oAddressCleanseSettings.Name = 'InvoiceServices';
            oAddressCleanseSettings.Endpoint__c = 'https:\\thomsonreuters.com';
            oAddressCleanseSettings.Timeout__c = 5;
            oAddressCleanseSettings.Active__c = true;
            oAddressCleanseSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
            insert oAddressCleanseSettings;
        }
        
        Test.StartTest();
            InvoiceServices.InvoiceItemsRequest oRequest = new InvoiceServices.InvoiceItemsRequest(); 
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServices');
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Username = oWebServiceSettings.Username__c;
            oRequest.Password = oWebServiceSettings.Password__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();            
            oRequest.AccountSAPID = Decimal.valueOf(testAcc1.SAPAccountNumber__c);
        system.debug('test12'+ oIXOSCodeMap.Company_Code__c);
            oRequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
            oRequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            oRequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            oRequest.DivisionCode = oIXOSCodeMap.Division_Code__c;
            oRequest.OpenItemsRequested = true;
            oRequest.ClearedItemsRequested = true;
            oRequest.AdditionalTextRequested = true;
            oRequest.InvoiceBegDt = date.parse('06/27/2009');
            oRequest.InvoiceEndDt = date.parse('12/27/2009');
            InvoiceServices invSerObj = new InvoiceServices();
            List<InvoiceServices.CombinedOpenClearedItems> InvoiceItemList = invSerObj.getInvoiceItems(oRequest) ;
            
            String sSelectedOption = System.Label.AccountRec_SOOpen;
            if(sSelectedOption == System.Label.AccountRec_SOOpen){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceItemList = invSerObj.getInvoiceItems(oRequest) ;
            
            sSelectedOption = System.Label.AccountRec_SOCleared;
            if(sSelectedOption == System.Label.AccountRec_SOOpen){  
              oRequest.OpenItemsRequested = true;
              oRequest.ClearedItemsRequested = false;
            }   
            if(sSelectedOption == System.Label.AccountRec_SOCleared){                                   
              oRequest.OpenItemsRequested = false;
              oRequest.ClearedItemsRequested = true;
            }   
            InvoiceItemList = invSerObj.getInvoiceItems(oRequest) ;
            InvoiceServices.OpenItem t1 = new InvoiceServices.OpenItem();
            InvoiceServices.ClearedItem t2 = new InvoiceServices.ClearedItem();
            invSerObj.returnService(oRequest);
        Test.StopTest();
    }
    
    public static testmethod void testInvoiceDocServicesRocket(){
        
        

		UnitTest.createTestData();
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1234';
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;
        //IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(testAcc1.Sales_org__c);
        IXOSCodeMap__c oIXOSCodeMap = new IXOSCodeMap__c();
        oIXOSCodeMap.Name='West';
        oIXOSCodeMap.Company_Code__c='0010';
        oIXOSCodeMap.Dist_Chan_Code__c='W';
        oIXOSCodeMap.Division_Code__c='W';
        oIXOSCodeMap.Sales_Org_Code__c='WEST';
        insert oIXOSCodeMap;  
        try{
            AppUtil.getWebServiceSettings('InvoiceServices');
        }catch(Exception e){
            WebServiceSettings__c oAddressCleanseSettings = new WebServiceSettings__c();
            oAddressCleanseSettings.Name = 'InvoiceServices';
            oAddressCleanseSettings.Endpoint__c = 'https:\\thomsonreuters.com';
            oAddressCleanseSettings.Timeout__c = 5;
            oAddressCleanseSettings.Active__c = true;
            oAddressCleanseSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
            insert oAddressCleanseSettings;
        }
        
        Test.StartTest();
            InvoiceServices.InvoiceDocUrlRequest oDocrequest = new InvoiceServices.InvoiceDocUrlRequest();
            //InvoiceServices.InvoiceItemsRequest oRequest = new InvoiceServices.InvoiceItemsRequest(); 
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServices');
            oDocrequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oDocrequest.Username = oWebServiceSettings.Username__c;
            oDocrequest.Password = oWebServiceSettings.Password__c;
            oDocrequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();            
            oDocrequest.AccountSAPID = Decimal.valueOf(testAcc1.SAPAccountNumber__c);
        system.debug('test123'+ oIXOSCodeMap.Company_Code__c);
            oDocrequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
        
            oDocrequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            oDocrequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            oDocrequest.DivisionCode = oIXOSCodeMap.Division_Code__c;
            oDocrequest.ReferenceKey1 = '1234';
            oDocrequest.DocumentType = new List<String>();
            oDocrequest.DocumentType =  new List<String>{'test'};//mapInvoiceDocTypes.get(strSalesOrgCode).split(';');
            InvoiceServices invSerObj = new InvoiceServices();
            InvoiceServices.DocumentUrl oDocUrl = invSerObj.getInvoiceDocumentUrl(oDocrequest);
      
        Test.StopTest();
    }
  
   
    public static testmethod void openItemTest(){
       
        InvoiceServices.OpenItem a = new InvoiceServices.OpenItem();
        a.PastDueFlag=true;
        a.DocumentDt=System.today()+5;
        a.DocumentType ='hello';
        a.DocumentNumber ='hello1';
        a.InvoiceNumber ='hello2';
        a.ReferenceKey1 = 'hello3';
        a.DebitCreditInd = 'hello4';
        a.Amount = 5.0;
        a.ReasonCode = '5463';
        a.BaselineDt = System.today()+5;
        a.ArrearDays = 5;
        a.LineNumber = 54;
        a.ServicesRenderedDt = System.today()+5;
        a.ClearingDt = System.today()+5;
        a.PostingDt = System.today()+5;
        a.ShortDesc = 'hello5';
        a.LongDesc = 'hello6';
        a.PdfLinkInd = 'hello7';
        a.DunningArea = 'hello8';
        a.ProcessingStatus = 'hello9';
        a.ShipToAcctSapID = 5.0;
        a.DunningBlock ='hello10';
        
        InvoiceServices.ClearedItem a1 = new InvoiceServices.ClearedItem();
       
        a1.DocumentDt=System.today()+5;
        a1.DocumentType ='hello';
        a1.DocumentNumber ='hello1';
        a1.InvoiceNumber ='hello2';
        a1.ReferenceKey1 = 'hello3';
        a1.DebitCreditInd = 'hello4';
        a1.Amount = 5.0;
        a1.ReasonCode = '5463';
        a1.BaselineDt = System.today()+5;
        a1.DueDt = System.today()+5;
        a1.ArrearDays = 5;
        a1.AllocationNumber ='hello5';
        a1.ClearingDt = System.today()+5;
        a1.ClearingDocumentNumber = 'hello6';
        a1.PostingDt = System.today()+5;
        a1.ShortDesc = 'hello7';
        a1.LongDesc = 'hello8';
        a1.DunningArea = 'hello9';
        a1.DunningBlock = 'hello10';
        a1.DunningLevel = 23;
        a1.LastDunnedDt = System.today()+5;
        a1.PaymentMethod = 'pay';
        a1.ReferenceDocumentNumber = 'pay1';
        a1.Referencekey2 = 'pay2';
        a1.SpecialGeneralLedgerInd = 'pay3';
        a1.ShipToAcctSapID =4.0;
        
        ARWebServices.InvoiceItems responseObjtemp = new ARWebServices.InvoiceItems();
         
    }
    
    
    public ARWebServices.InvoiceItems GetMockInvoiceItemsMISSOA2(){
        ARWebServices.InvoiceItems  responseObjTemp = new ARWebServices.InvoiceItems();
        ARWebServices.InvoiceItemsOpenCleared responseObj= new ARWebServices.InvoiceItemsOpenCleared();
        
        responseObj.TotalOpenItemAmount = '1234';
        responseObj.TotalOpenItemAmountInvoiced = '1234';
        responseObj.PastDueBalance = '1234';

        ARWebServices.ClearedItemsOutList oClearedItem  = new ARWebServices.ClearedItemsOutList();
        oClearedItem.DocumentDt = '12/27/2009';
        oClearedItem.DocumentType = 'test';
        oClearedItem.DocumentNumber = '123';
        oClearedItem.InvoiceNumber = '123';
        oClearedItem.ReferenceKey1 = '123';
        oClearedItem.DebitCreditInd = '123';  
        oClearedItem.CurrencyInd = '123';  
        oClearedItem.Amount = '1234';
        oClearedItem.ReasonCode = 'test';  
        oClearedItem.BlineDate = '12/27/2009';  
        oClearedItem.DueDt =   '12/27/2009';  
        oClearedItem.ArrearDays = '1';  
        oClearedItem.AllocationNumber = '12';  
        oClearedItem.ClearingDt = '12/27/2009';  
        oClearedItem.ClearingDocumentNumber = '12';  
        oClearedItem.PostingDt = '12/27/2009';
        oClearedItem.ShortDesc = 'Test';
        oClearedItem.LongDesc = 'test'; 
        oClearedItem.DunningArea = 'test';  
        oClearedItem.DunningBlock = 'test';  
        oClearedItem.DunningLevel = '1';  
        oClearedItem.LastDunnedDt  = '12/27/2009'; 
        oClearedItem.PaymentMethod = 'test';  
        oClearedItem.ReferenceDocumentNumber = 'test';  
        oClearedItem.Referencekey2 = 'test';  
        oClearedItem.SpecialGeneralLedgerInd = 'test';  
        oClearedItem.ShipToAcctSapID = '1234';
        oClearedItem.CompCode = '0010';
        ARWebServices.ClearedItemsOutList[] item1 = new ARWebServices.ClearedItemsOutList[]{oClearedItem};
        ARWebServices.InvoiceClearedItemsOut item1a = new ARWebServices.InvoiceClearedItemsOut();
        item1a.item = item1;
        responseObj.ClearedItemsOut = new ARWebServices.InvoiceClearedItemsOut[]{item1a };
       // responseObjTemp.invoiceItems= responseObj;
        
        ARWebServices.OpenItemsOutList oOpenItem = new ARWebServices.OpenItemsOutList();
        oOpenItem.PastDueFlag = true;
        oOpenItem.DocumentDt = '12/27/2009';
        oOpenItem.DocumentType = 'test';
        oOpenItem.DocumentNumber = '123';
        oOpenItem.InvoiceNumber = '123';
        oOpenItem.ReferenceKey1 = '123';
        oOpenItem.DebitCreditInd = '123';
        oOpenItem.Amount = '1234';
        oOpenItem.ReasonCode = 'test';
        oOpenItem.BaselineDt = '12/27/2009';
        oOpenItem.ArrearDays = '1';
        oOpenItem.LineNumber = '1';
        oOpenItem.ServicesRenderedDt = '12/27/2009';
        oOpenItem.ClearingDt = '12/27/2009';
        oOpenItem.PostingDt = '12/27/2009';
        oOpenItem.ShortDesc = 'Test';
        oOpenItem.LongDesc = 'test';
        oOpenItem.PdfLinkInd = 'test';
        oOpenItem.DunningArea = 'test';
        oOpenItem.ProcessingStatus = 'test';
        oOpenItem.ShipToAcctSapID = '1234';
        oOpenItem.DunningBlock = 'test';
        oOpenItem.CompCode = '0010';
        ARWebServices.OpenItemsOutList oOpenItem1 = new ARWebServices.OpenItemsOutList();
        oOpenItem1.PastDueFlag = false;
        oOpenItem1.DocumentDt = '12/27/2009';
        oOpenItem1.DocumentType = 'test';
        oOpenItem1.DocumentNumber = '123';
        oOpenItem1.InvoiceNumber = '123';
        oOpenItem1.ReferenceKey1 = '123';
        oOpenItem1.DebitCreditInd = '123';
        oOpenItem1.Amount = '1234';
        oOpenItem1.ReasonCode = 'test';
        oOpenItem1.BaselineDt = '12/27/2009';
        oOpenItem1.ArrearDays = '1';
        oOpenItem1.LineNumber = '1';
        oOpenItem1.ServicesRenderedDt = '12/27/2009';
        oOpenItem1.ClearingDt = '12/27/2009';
        oOpenItem1.PostingDt = '12/27/2009';
        oOpenItem1.ShortDesc = 'Test';
        oOpenItem1.LongDesc = 'test';
        oOpenItem1.PdfLinkInd = 'test';
        oOpenItem1.DunningArea = 'test';
        oOpenItem1.ProcessingStatus = 'test';
        oOpenItem1.ShipToAcctSapID = '1234';
        oOpenItem1.DunningBlock = 'test';
        oOpenItem1.CompCode = '0010';
        ARWebServices.OpenItemsOutList[] item2 = new ARWebServices.OpenItemsOutList[]{oOpenItem,oOpenItem1};
        ARWebServices.InvoiceOpenItemsOut item2a = new ARWebServices.InvoiceOpenItemsOut();
        item2a.item = item2;
        responseObj.OpenItemsOut = new ARWebServices.InvoiceOpenItemsOut[]{item2a};
        responseObjTemp.invoiceItems= responseObj;
        
        return responseObjTemp;
    }
 
    }