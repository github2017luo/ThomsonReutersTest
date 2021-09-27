/**
 * Provides testing specific helper methods for apex callouts
 *
 * @author  Srikanth Kuruva
 * @version 2012-05-14
 */
 public class MockWebserviceResponses
{
    public Map<string, object> mapMockWebServiceResponse;
    Integer numberOfSubscriptions = 125;
    
    //Constructors
    /**
     * Default constructor.
     */
    public static ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element getQuoteResponse(){
        ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element oResponseElement = new ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element();
        oResponseElement.originatingOrderNumber = '';
        oResponseElement.orderNumber = '';
        oResponseElement.iDocNumber = '568756345';
        oResponseElement.sapOrderMessage = new ecomTocServicesThomsonCom20Orders.SapOrderMessage();
        return oResponseElement;
    }
    public static ecomCustomerServiceV02.CreateCustomerResponse getCustomerResponse(){
        ecomCustomerServiceV02.CreateCustomerResponse oResponseElement = new ecomCustomerServiceV02.CreateCustomerResponse();
        oResponseElement.customerNumber = '123_1';        
        ecomCustomerServiceV02.PartnerFunction oPartner = new ecomCustomerServiceV02.PartnerFunction();
        oPartner.partnerFunctionId = 'SP';
        oResponseElement.partnerFunction = new ecomCustomerServiceV02.PartnerFunction[] {oPartner};         
        return oResponseElement;
    }
    // mock response class for ecm
    public static DataQualityUtil.MatchAccountsResponse getEcmResponse(){
        Account acc = new Account();
        acc = [SELECT Id, Name FROM Account LIMIT 1];
        //(Name = 'Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        
        
        DataQualityUtil.MatchAccountsResponse ecmResponse = new DataQualityUtil.MatchAccountsResponse();
        DataQualityUtil.ECMAccountInfo ecmaccInfo = new DataQualityUtil.ECMAccountInfo();
        ecmaccInfo.MatchScore = 1;
        ecmaccInfo.Name = 'Test';
        ecmaccInfo.Street1 = '1';
        ecmaccInfo.Street2 = 'street';
        ecmaccInfo.Country = 'US';
        ecmaccInfo.State = 'IL';
        ecmaccInfo.City = 'CHICAGO';
        ecmaccInfo.PostalCode = '6161-6162';
        ecmaccInfo.SourceSystemId = acc.Id;
        ecmaccInfo.AddressId = '12';
        list<DataQualityUtil.ECMAccountInfo> ecmAccList = new list<DataQualityUtil.ECMAccountInfo>();
        ecmAccList.add(ecmaccInfo);
        ecmResponse.ECMAccounts = ecmAccList;
        ecmResponse.SFDCAccounts = ecmAccList;
        return ecmResponse;
    }
    
    public static  List<DataQualityUtil.ContactInfo> getContactInfoResponse() {
    
         List<DataQualityUtil.ContactInfo> listContactInfo = new List<DataQualityUtil.ContactInfo>(); 
         DataQualityUtil.ContactInfo conInfo = new  DataQualityUtil.ContactInfo();
         list<Contact> contactList = [SELECT Id from Contact LIMIT 1]; 
         conInfo.MDBCustomerID = '123';
         conInfo.MDBContactID = contactList[0].Id;
         conInfo.contactID = contactList[0].Id;
         conInfo.Name = 'Test name';
         conInfo.EMail = 'Sreenu.d2tcs.com';
         conInfo.Score = '1';
         listContactInfo.add(conInfo);
         return listContactInfo;
    }
         
   
    // Added by Sreenu for M360
    public static IDQContactMatchesObjects.WS_contact_searchResponseElement_element [] getIDQMatchesResponse(){
        IDQContactMatchesObjects.WS_contact_searchResponseElement_element oResponseElement = new IDQContactMatchesObjects.WS_contact_searchResponseElement_element();
        DataQualityUtil.ContactInfoNonSfdc cins = new DataQualityUtil.ContactInfoNonSfdc();
        list<IDQContactMatchesObjects.WS_contact_searchResponseElement_element> cinsList = new list<IDQContactMatchesObjects.WS_contact_searchResponseElement_element>();
        Contact con = new Contact(FirstName = 'Test', Person_ID__C = '123', LastName = 'Test', Email = 'sreenu.d@tcs.com');
         oResponseElement.PERSON_ID = string.valueof('123'); 
         oResponseElement.FIRST_NAME_MCM = con.FirstName;
         oResponseElement.LAST_NAME_MCM = con.LastName;
          oResponseElement.EMAIL_MCM = con.Email;
        // cins .phoneNo = 
        oResponseElement.ACCOUNT_NAME_MCM = 'Test Account';
         oResponseElement.BUSINESS_UNIT = 'Salesforce.com';
         oResponseElement.MATCH_SCORE = '1';
         cinsList.add(oResponseElement);
         
        // CdmResponse = cinsList;
         
         return cinsList;
     
    }
    
    public static ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element getPersonIDresponse() {
        ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element oResponse = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element ();
        oResponse.PERSON_ID = '123';
        oResponse.ACCOUNT_NAME = 'test Account';
        oResponse.FIRST_NAME = 'Test';
        oResponse.LAST_NAME = 'test';
        oResponse.EMAIL = 'sreenu.d2tcs.com';
        oResponse.BUSINESS_UNIT = 'Practical Law';
        return oResponse; 
    }
    public static List<DataQualityUtil.ContactInfoNonSfdc> getmatchedIDQContacts() {
        List<DataQualityUtil.ContactInfoNonSfdc> listMatched = new List<DataQualityUtil.ContactInfoNonSfdc>();
        DataQualityUtil.ContactInfoNonSfdc matched = new DataQualityUtil.ContactInfoNonSfdc();
        matched.personID = 'Test';
        matched.firstName = 'Test';
        matched.lastName = 'Test';
        matched.phoneNo = '1234567899';
        matched.email = 'sreenu.d@tcs.com';
        matched.accountName = 'test Account';
        matched.BU = 'Salesforce.com';
        matched.score = '1';
        listMatched.add(matched);
        return listMatched;        
    }
    //Ended by Sreenu for M360
    
    /*    public static ecomCustomerServiceV02ODT2.CreateCustomerResponse getCustomerResponseODT(){
        ecomCustomerServiceV02ODT2.CreateCustomerResponse oResponseElement = new ecomCustomerServiceV02ODT2.CreateCustomerResponse();
        oResponseElement.customerNumber = '123_1';        
        ecomCustomerServiceV02ODT2.PartnerFunction oPartner = new ecomCustomerServiceV02ODT2.PartnerFunction();
        oPartner.partnerFunctionId = 'SP';
        oResponseElement.partnerFunction = new ecomCustomerServiceV02ODT2.PartnerFunction[] {oPartner};         
        return oResponseElement;
    } */
    public MockWebserviceResponses()
    {
        mapMockWebServiceResponse = new Map<string, object>();
        list<ServiceNotesWSObjects.ServiceNoteItem> listMockResponseServiceItems = new list<ServiceNotesWSObjects.ServiceNoteItem>();        
        ServiceNotesWSObjects.ServiceNoteItem oServiceNoteItem = new ServiceNotesWSObjects.ServiceNoteItem();
        oServiceNoteItem  = BuildServiceNotesResponse();
        listMockResponseServiceItems.add(oServiceNoteItem);
        mapMockWebServiceResponse.put('GetServiceNoteItems', listMockResponseServiceItems);
        mapMockWebServiceResponse.put('GetServiceNoteDetail', oServiceNoteItem );
        mapMockWebServiceResponse.put('GetSubItems', getMockSubItems() );
        mapMockWebServiceResponse.put('CalculatePDA', getMockCalculatePdaItem() );
        
    }
    public SubscriptionsWSObject.PdaItem getMockCalculatePdaItem()
    {
        SubscriptionsWSObject.PdaItem oMockPdaItem = new SubscriptionsWSObject.PdaItem();
        oMockPdaItem.TotalEstimatedUpKeep = 419.50;
        oMockPdaItem.TotalDiscount = 83.90;
        oMockPdaItem.TotalUpKeepAfterDiscount = 335.60;
        oMockPdaItem.TotalMonthlySavings = 6.99;
        oMockPdaItem.TotalMinimumIncremental = 125.85;
        SubscriptionsWSObject.PdaLineItem oMockPdaLineItem = new SubscriptionsWSObject.PdaLineItem();
        oMockPdaLineItem.SubKey = '638289580701428031';
        oMockPdaLineItem.DiscountPerUnit = 83.90;
        oMockPdaLineItem.EstimatedUpKeep = 419.50;
        oMockPdaLineItem.Discount = 83.90;
        oMockPdaLineItem.UpKeepAfterDiscount = 335.60;
        oMockPdaLineItem.MinimumIncremental = 125.85;
        oMockPdaItem.PdaLineItem = new SubscriptionsWSObject.PdaLineItem[]{};
        oMockPdaItem.PdaLineItem.add(oMockPdaLineItem);
        return oMockPdaItem ;
    }
    
    public InvoiceWSObject.DocumentUrl GetMockInvoiceDocumentUrl(){
        InvoiceWSObject.DocumentUrl oDocumentUrl = new InvoiceWSObject.DocumentUrl();
        oDocumentUrl.Url= 'testUrl';
        
        return oDocumentUrl;
    }
    
    public InvoiceWSObject.OpenClearedItems GetMockInvoiceItems(){
        InvoiceWSObject.OpenClearedItems  oOpenClearedItemsResponse = new InvoiceWSObject.OpenClearedItems ();
        
        oOpenClearedItemsResponse.TotalOpenItemAmount = Decimal.valueOf('1234');
        oOpenClearedItemsResponse.TotalOpenItemAmountInvoiced = Decimal.valueOf('1234');
        oOpenClearedItemsResponse.PastDueBalance = Decimal.valueOf('1234');
        
        InvoiceWSObject.OpenItem oOpenItem = new InvoiceWSObject.OpenItem();
        oOpenItem.PastDueFlag = true;
        oOpenItem.DocumentDt = date.parse('12/27/2009');
        oOpenItem.DocumentType = 'test';
        oOpenItem.DocumentNumber = '123';
        oOpenItem.InvoiceNumber = '123';
        oOpenItem.ReferenceKey1 = '123';
        oOpenItem.DebitCreditInd = '123';
        oOpenItem.Amount = Decimal.valueOf('1234');
        oOpenItem.ReasonCode = 'test';
        oOpenItem.BaselineDt = date.parse('12/27/2009');
        oOpenItem.ArrearDays = 1;
        oOpenItem.LineNumber = 1;
        oOpenItem.ServicesRenderedDt = date.parse('12/27/2009');
        oOpenItem.ClearingDt = date.parse('12/27/2009');
        oOpenItem.PostingDt = date.parse('12/27/2009');
        oOpenItem.ShortDesc = 'Test';
        oOpenItem.LongDesc = 'test';
        oOpenItem.PdfLinkInd = 'test';
        oOpenItem.DunningArea = 'test';
        oOpenItem.ProcessingStatus = 'test';
        oOpenItem.ShipToAcctSapID = Decimal.valueOf('1234');
        oOpenItem.DunningBlock = 'test';
        
        oOpenClearedItemsResponse.OpenItem = new List<InvoiceWSObject.OpenItem>();
        oOpenClearedItemsResponse.OpenItem.add(oOpenItem);
        
        InvoiceWSObject.ClearedItem oClearedItem  = new InvoiceWSObject.ClearedItem();
        oClearedItem.DocumentDt = date.parse('12/27/2009');
        oClearedItem.DocumentType = 'test';
        oClearedItem.DocumentNumber = '123';
        oClearedItem.InvoiceNumber = '123';
        oClearedItem.ReferenceKey1 = '123';
        oClearedItem.DebitCreditInd = '123';  
        oClearedItem.CurrencyInd = '123';  
        oClearedItem.Amount = Decimal.valueOf('1234');
        oClearedItem.ReasonCode = 'test';  
        oClearedItem.BaselineDt = date.parse('12/27/2009');  
        oClearedItem.DueDt =   date.parse('12/27/2009');  
        oClearedItem.ArrearDays = 1;  
        oClearedItem.AllocationNumber = '12';  
        oClearedItem.ClearingDt = date.parse('12/27/2009');  
        oClearedItem.ClearingDocumentNumber = '12';  
        oClearedItem.PostingDt = date.parse('12/27/2009');
        oClearedItem.ShortDesc = 'Test';
        oClearedItem.LongDesc = 'test'; 
        oClearedItem.DunningArea = 'test';  
        oClearedItem.DunningBlock = 'test';  
        oClearedItem.DunningLevel =1;  
        oClearedItem.LastDunnedDt  = date.parse('12/27/2009'); 
        oClearedItem.PaymentMethod = 'test';  
        oClearedItem.ReferenceDocumentNumber = 'test';  
        oClearedItem.Referencekey2 = 'test';  
        oClearedItem.SpecialGeneralLedgerInd = 'test';  
        oClearedItem.ShipToAcctSapID = Decimal.valueOf('1234');
        
        oOpenClearedItemsResponse.ClearedItem = new List<InvoiceWSObject.ClearedItem>();
        oOpenClearedItemsResponse.ClearedItem.add(oClearedItem);
        
        return oOpenClearedItemsResponse ;
    }
    
    public ARWebServices.InvoiceItems GetMockInvoiceItemsMISSOA(){
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
        
        return responseObjTemp;
    }
    
    public ContactPasswordWSObjects.AccountOnlineUser getAccountOnlineUser(){
        ContactPasswordWSObjects.AccountOnlineUser oMockAccountOnlineUser = new ContactPasswordWSObjects.AccountOnlineUser();
        oMockAccountOnlineUser.StartRec = 1;
        oMockAccountOnlineUser.EndRec = 5;
        oMockAccountOnlineUser.TotalRecs = 5;
        contactPasswordWSObjects.OnlineUser[] oOnlineUser = new contactPasswordWSObjects.OnlineUser[]{};
        oMockAccountOnlineUser.OnlineUser = oOnlineUser;
        return oMockAccountOnlineUser;
    }
    
    public SubscriptionsWSObject.Sub getMockSub(){
      //Integer numberOfSubscriptions = 5;
      SubscriptionsWSObject.Sub oMockSub = new SubscriptionsWSObject.Sub();
      oMockSub.StartRec = 1;
      oMockSub.EndRec = numberOfSubscriptions;
      oMockSub.TotalRecs = numberOfSubscriptions;
      oMockSub.subItem = new SubscriptionsWSObject.SubItem[]{};
      oMockSub.subItem = getMockSubItems();
      return oMockSub;
    
    }
    public List<SubscriptionsWSObject.SubItem> getMockSubItems()
    {
        //Integer numberOfSubscriptions = 5;
        
        List<SubscriptionsWSObject.SubItem> listMockSubItems = new List<SubscriptionsWSObject.SubItem>();
        for(Integer i=0; i<numberOfSubscriptions; i++){
            SubscriptionsWSObject.SubItem oMockSubItem = new SubscriptionsWSObject.SubItem();
            oMockSubItem.SubKey = '63828958070142803'+i;
            oMockSubItem.AcctSapId = 1000053413;
            oMockSubItem.CompanyCode = '0010';
            oMockSubItem.SalesOrgCode = 'WEST';
            oMockSubItem.DistChanCode = 'W';
            oMockSubItem.DivisionCode = 'W';
            oMockSubItem.SubscriptionStatus = 'ACTIVE';
            oMockSubItem.MaterialNumber = '000000000013826928';
            oMockSubItem.MaterialDesc = 'CA APP REP 4TH SUB';
            oMockSubItem.ContractNumber = '0701428031';
            oMockSubItem.OrderItem = '000010';
            oMockSubItem.ContractStartDt = System.Date.today();
            oMockSubItem.ContractEndDt = System.Date.today();
            oMockSubItem.TermEndDt = System.Date.today();
            oMockSubItem.ContractType = 'NBP';
            oMockSubItem.ProductTitle = 'California Appellate Reports, 4th';
            oMockSubItem.ProgramDiscountId = '';
            oMockSubItem.ProgramDiscountDesc = '';
            oMockSubItem.ProgramDiscountPercent = 0;
            oMockSubItem.DiscountQuantity = 0;
            oMockSubItem.Quantity = 1;
            oMockSubItem.ContentGroup = '';
            oMockSubItem.BandedAttorneyCount = '00000';
            oMockSubItem.MediaHighLevelCode = '07';
            oMockSubItem.MediaHighLevelDesc = 'Print';
            oMockSubItem.DealId = '0';
            oMockSubItem.EstimatedUnitUpKeep = 0;
            oMockSubItem.FindlawLocationCode = '0';
            oMockSubItem.FindlawLocationDesc = '0';
            oMockSubItem.FindlawPracticeAreaCode = '';
            oMockSubItem.FindlawPracticeAreaDesc = '';
            oMockSubItem.AutoRenewFlag = false;
            oMockSubItem.LapsedReasonCode = '';
            oMockSubItem.LapsedReasonDesc = '';
            oMockSubItem.LapsedDate = System.Date.today();
            oMockSubItem.WestpackFlag = true;
            oMockSubItem.FirstYearDiscount = 0;
            oMockSubItem.BandedRetailRate = 0;
            oMockSubItem.MonthlyCharge = 0;
            oMockSubItem.PerUserRate = 0;
            oMockSubItem.RetailUserRate = 0;
            listMockSubItems.add(oMockSubItem);
        }
        System.debug(listMockSubItems);
        return listMockSubItems; 
    }
    public ServiceNotesWSObjects.ServiceNoteItem BuildServiceNotesResponse()
    {
        ServiceNotesWSObjects.ServiceNoteItem oServiceNoteItem = new ServiceNotesWSObjects.ServiceNoteItem();
        oServiceNoteItem.ServiceNoteId = '1';
        oServiceNoteItem.StatusId = 'StatusId';
        oServiceNoteItem.StatusDesc = 'StatusDesc';
        oServiceNoteItem.DepartmentId = 'DepartmentId';
        oServiceNoteItem.DepartmentDesc = 'DepartmentDesc';
        oServiceNoteItem.Requester = 'Requester';
        oServiceNoteItem.ContactMethod = 'ContactMethod';
        oServiceNoteItem.PriorityId = 'PriorityId';
        oServiceNoteItem.PriorityDesc = 'PriorityDesc';
        ServiceNotesWSObjects.ActivityCodeItem oActivityCodeItem = new ServiceNotesWSObjects.ActivityCodeItem();
        oActivityCodeItem.ActivityCodeId = '11';
        oActivityCodeItem.ActivityCodeDesc = 'ActivityCodeDesc';
        oServiceNoteItem.ActivityCodeItemList = new ServiceNotesWSObjects.ActivityCodeItem[]{oActivityCodeItem};
        //oServiceNoteItem.ActivityCodeItemList[0] = oActivityCodeItem;
        oServiceNoteItem.ShortDesc = 'ShortDesc';
        oServiceNoteItem.LongDesc = 'LongDesc';
        oServiceNoteItem.CreateTS = System.DateTime.Now();
        oServiceNoteItem.ChangedBy = 'ChangedBy';
        oServiceNoteItem.ChangedOnDate = System.Date.Today();
        return oServiceNoteItem;
    }
    
     
     
     public list<CredentialInfoWSObject.CredentialInfoItem> getMockClearInfo(){
     
     list<CredentialInfoWSObject.CredentialInfoItem> listCredInfoItems = new list<CredentialInfoWSObject.CredentialInfoItem>();
     CredentialInfoWSObject.CredentialInfoItem oMockCredInfo = new CredentialInfoWSObject.CredentialInfoItem();
      oMockCredInfo.Domain = 'WESTLAW';
      oMockCredInfo.CredentialProgress = 'CC';
      oMockCredInfo.CredentialProgressDesc = 'Credentialing Complete';
      oMockCredInfo.CredentialStatus = 'CE';
      oMockCredInfo.CredentialStatusDesc = 'Credentialing Expired';
      oMockCredInfo.BusinessType = 'IF';
      oMockCredInfo.BusinessTypeDesc = 'Investigative Firm';
      oMockCredInfo.RestrictionCls = '5B';
      oMockCredInfo.RestrictionClsDesc = 'Truncated Identifying Information';
      oMockCredInfo.ProgessDt = System.Date.today();
      oMockCredInfo.StatusDt = System.Date.today();
      oMockCredInfo.OnsiteInspectionDt = System.Date.today();
      listCredInfoItems.add(oMockCredInfo);
      return listCredInfoItems ;
     }
     
     public list<CredentialInfoWSObject.BusinessRestrictionItem> getMockIPRestrictionInfo()
         {
             
             CredentialInfoWSObject.BusinessRestrictionItem oMockIPInfo = new CredentialInfoWSObject.BusinessRestrictionItem();
             List<CredentialInfoWSObject.BusinessRestrictionItem> listIPInfoItems = new list<CredentialInfoWSObject.BusinessRestrictionItem>();
             oMockIPInfo.BusinessRestriction = 'Test BR';
             oMockIPInfo.BusinessRestrictionDesc = 'Test BRD';
             listIPInfoItems.add(oMockIPInfo);
             return listIPInfoItems;
         }
     
     public CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem getMockCredInfo()
         {
          CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem oMockCredInfo = new CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem();
          oMockCredInfo.CredentialInfoItem = getMockClearInfo();
          oMockCredInfo.BusinessRestrictionItem = getMockIPRestrictionInfo(); 
          return oMockCredInfo;
         }
      
       public list<IPRestrictionWSObject.IPRestrictionItem> getMockIPInfo()
          {
          List<IPRestrictionWSObject.IPRestrictionItem> listMockIPInfo = new list<IPRestrictionWSObject.IPRestrictionItem>();
          IPRestrictionWSObject.IPRestrictionItem oMockIPInfo = new IPRestrictionWSObject.IPRestrictionItem();
          oMockIPInfo.AcctSapId = 1234;
          oMockIPInfo.GroupType = 'FF';
          oMockIPInfo.GroupID = '000000000194103';
          oMockIPInfo.IPRestrictionType = 'CC';
          oMockIPInfo.IPRestrictionDesc = 'Country Code';
          oMockIPInfo.IPAddress = '38.98.105.115';
          oMockIPInfo.IPUpper = '38.98.105.115';
          oMockIPInfo.CountryCode = 'PR';
          oMockIPInfo.CountryDesc = 'Puerto Rico';
          oMockIPInfo.EffectiveBegDt = System.Date.today();
          oMockIPInfo.EffectiveEndDt = System.Date.today();
          listMockIPInfo.add(oMockIPInfo);
          
          return listMockIPInfo;
          }
    
    // mock response class for CDS service
    public static DataQualityUtil.MatchContactsSearchResponse getCDSResponse(){
        
        DataQualityUtil.CDSContactInfo sfdcContact = new DataQualityUtil.CDSContactInfo();
        sfdcContact.Source_System_ID = '987654321';
        
        sfdcContact.First_Name = 'Arpit';
        sfdcContact.Last_Name = 'Patel';
        sfdcContact.Account_Name = 'Test & Co.';
        sfdcContact.Account_Address = '1313 Mockingbird Lane.';
        sfdcContact.City = 'Eagan';
        sfdcContact.State = 'MN';
        sfdcContact.Contact_Email = 'Taoheed.Ansari@tcs.com';
        sfdcContact.Contact_Phone = '123456789';
        sfdcContact.Job_Function = 'Sales';
        sfdcContact.Party_ID = '123456';
        sfdcContact.Title = 'Director';
        
        DataQualityUtil.CDSContactInfo cdsContact = new DataQualityUtil.CDSContactInfo();
        cdsContact.Source_System_ID = '12345';
        
        cdsContact.First_Name = 'Taoheed';
        cdsContact.Last_Name = 'Ansari';
        cdsContact.Account_Name = 'ABC Company';
        cdsContact.Contact_Email = 'Taoheed.Ansari@tcs.com';
        cdsContact.Contact_Phone = '9892743338';
        cdsContact.Job_Function = 'Sales';
        cdsContact.Title = 'Director';
        cdsContact.Party_ID = '987654';
        DataQualityUtil.MatchContactsSearchResponse match = new DataQualityUtil.MatchContactsSearchResponse();
        List<DataQualityUtil.CDSContactInfo> cdsContactList = new List<DataQualityUtil.CDSContactInfo>();
        List<DataQualityUtil.CDSContactInfo> sfdcContactList = new List<DataQualityUtil.CDSContactInfo>();
        cdsContactList.add(cdsContact);
        sfdcContactList.add(sfdcContact);
        
        match.CDSContacts = cdsContactList;
        match.SFDCContacts = sfdcContactList;
        return match;
    }
      
    //mock response class for strikeIron Email service
    public static StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord getStrikeIronEmailResponse(){
        StrikeIronEmailService.SIWsStatus ServiceStatus = new StrikeIronEmailService.SIWsStatus();
        StrikeIronEmailService.VerifyEmailRecord ServiceResult = new StrikeIronEmailService.VerifyEmailRecord();
        ServiceStatus.StatusDescription = 'Email Valid';
        StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord respObj = new StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord();
        respObj.ServiceStatus = ServiceStatus;
        respObj.ServiceResult = ServiceResult;
        return respObj;
    }  
    
    //mock response class for strikeIron Email service
    public static StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus getStrikeIronPhoneResponse(String PhoneStr){
        System.debug('PhoneStr : phone mock : '+PhoneStr);
        List<StrikeIronPhoneService.GlobalPhoneEntryWithStatus> statusArray = new List<StrikeIronPhoneService.GlobalPhoneEntryWithStatus>();
        List<String> phoneList = (phoneStr!=null && phoneStr!='')?phoneStr.split(','):new List<String>();
        System.debug('phoneList : '+phoneList);
        for(String str : phoneList){
            StrikeIronPhoneService.GlobalPhoneEntryWithStatus tempStatus = new StrikeIronPhoneService.GlobalPhoneEntryWithStatus();
            StrikeIronPhoneService.SIWsStatus siwstat= new StrikeIronPhoneService.SIWsStatus();
            siwstat.StatusDescription = 'Valid Number';
            tempStatus.ItemStatus = siwstat;
            statusArray.add(tempStatus);
        }
        
        StrikeIronPhoneService.ArrayOfGlobalPhoneEntryWithStatus Results = new StrikeIronPhoneService.ArrayOfGlobalPhoneEntryWithStatus();
        Results.GlobalPhoneEntryWithStatus = statusArray;
        StrikeIronPhoneService.SIWsResultArrayOfGlobalPhoneEntryWithStatus ServiceResult = new StrikeIronPhoneService.SIWsResultArrayOfGlobalPhoneEntryWithStatus();
        ServiceResult.Results = Results; 
        StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus respObj = new StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus();
        respObj.ServiceResult = ServiceResult; 
        return respObj;
    }    
  
}