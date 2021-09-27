/**
* @file name          : DCPLeadServiceTest
* @description        : This is Test class for Lead Services
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 05/20/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 05/24/2021   Servendra Kumar    DCP-1678     Created 
* 01/09/2021    Priyanka Mondal    DCP-4205     Coverage for - Orchestrate the Customer Validation Logic
* =============================================================================
**/
@isTest(seeAllData=false)
public class DCPLeadServiceTest {
    
    /**
* @description
*/ 
    public class PrepareDataWrapper {
        String lname;
        String leadId;
        String actionParm;
        String cartId;
        String leadsourceCountryCode;
        String leadOriginSite;
        boolean isOnlineContact;
        string productfamily;
        string onepassid;
        string accountANumber;
    }
    /**
* @description
* @param pdw
* @return
*/ 
    public static DCPLeadRequestHandler.DCPOrders prepareData(PrepareDataWrapper pdw) {
        
        DCPLeadRequestHandler.DCPOrders dcpOrders = new DCPLeadRequestHandler.DCPOrders();
        DCPLeadRequestHandler.DCPOrder dcpOrder = new DCPLeadRequestHandler.DCPOrder();
        DCPLeadRequestHandler.DCPCustomerDetails dcpCustomerDetails = new DCPLeadRequestHandler.DCPCustomerDetails();
        DCPLeadRequestHandler.DCPLAccountDetails dcpAccountDetails = new DCPLeadRequestHandler.DCPLAccountDetails();
        DCPLeadRequestHandler.customerAddress dcpCustomerAddress = new  DCPLeadRequestHandler.customerAddress();
        DCPLeadRequestHandler.References dcpRef = new DCPLeadRequestHandler.References();
        DCPLeadRequestHandler.ActionParams dcpActionParams = new DCPLeadRequestHandler.ActionParams();
        DCPLeadRequestHandler.OnlineContactsFieldsClass onlineContactField  = new DCPLeadRequestHandler.OnlineContactsFieldsClass();
        List<DCPLeadRequestHandler.OnlineContactsFieldsClass> onlineContactFieldList = new List<DCPLeadRequestHandler.OnlineContactsFieldsClass>();
        
        DCPLeadRequestHandler.ConvertLeadWrapperDetails convertLeadWrapperDetails = new DCPLeadRequestHandler.ConvertLeadWrapperDetails();
        convertLeadWrapperDetails.leadId = null;
        convertLeadWrapperDetails.emailId = null;
        convertLeadWrapperDetails.cartId = null;
        convertLeadWrapperDetails.westAccNumber = null;
        convertLeadWrapperDetails.quoteId = null;
        //convertLeadWrapperDetails.ConvertLeadWrapperDetails();
        DCPLeadRequestHandler.ContactUpdateToRespWrap contactUpdateToRespWrap = new DCPLeadRequestHandler.ContactUpdateToRespWrap();
        contactUpdateToRespWrap.conIdw = null;
        contactUpdateToRespWrap.leadsListw = null;
        contactUpdateToRespWrap.refDetw = null;
        contactUpdateToRespWrap.respw = null;
        // contactUpdateToRespWrap.ContactUpdateToRespWrap();
        DCPLeadRequestHandler.ConvertLeadWrapper convertLeadWrapper = new DCPLeadRequestHandler.ConvertLeadWrapper();
        convertLeadWrapper.conIdw = null;
        convertLeadWrapper.leadsw = null;
        convertLeadWrapper.refDetailsw = null;
        convertLeadWrapper.ssdRecw = null;
        //convertLeadWrapper.ConvertLeadWrapper();
        DCPLeadRequestHandler.CreateOpptyWrap createOpptyWrap = new DCPLeadRequestHandler.CreateOpptyWrap();
        createOpptyWrap.accIDw = null;
        createOpptyWrap.accNamew = null;
        createOpptyWrap.accSsdw = null;
        createOpptyWrap.conIDw = null;
        // createOpptyWrap.CreateOpptyWrap();
        createOpptyWrap.leads = null;
        createOpptyWrap.rdw = null;
        createOpptyWrap.ssdRecw = null;
        DCPLeadRequestHandler.CreateNewSsdWrap createNewSsdWrap = new DCPLeadRequestHandler.CreateNewSsdWrap();
        createNewSsdWrap.lwr = null;
        // createNewSsdWrap.CreateNewSsdWrap();
        createNewSsdWrap.oAccountNamew = null;
        createNewSsdWrap.oAccountw = null;
        createNewSsdWrap.shippingOnlyw = null;
        DCPLeadRequestHandler.ReferenceDetails referenceDetails = new DCPLeadRequestHandler.ReferenceDetails();
        referenceDetails.accountSSDId = null;
        referenceDetails.accountShippingSSDId = null;
        referenceDetails.accountSSDId = null;
        referenceDetails.contactSSDId = null;
        referenceDetails.contractTerm = null;
        referenceDetails.convertedAccId = null;
        referenceDetails.convertedConId = null;
        referenceDetails.convertedOppId = null;
        referenceDetails.errorObject = null;
        referenceDetails.recordResult = null;
        referenceDetails.refDesc = null;
        // referenceDetails.ReferenceDetails();
        referenceDetails.accountShippingSSDId = null;
        DCPLeadRequestHandler.LeadConversionWrapper leadConversionWrapper = new DCPLeadRequestHandler.LeadConversionWrapper();
        leadConversionWrapper.leads = null;
        leadConversionWrapper.accID = null;
        leadConversionWrapper.conId = null;
        leadConversionWrapper.oppId = null;
        
        LIST<DCPLeadRequestHandler.proviewIds> proviewids = new LIST<DCPLeadRequestHandler.proviewIds>();
        DCPLeadRequestHandler.proviewIds p1= new DCPLeadRequestHandler.proviewIds();
        p1.productCode = '365214';
        proviewids.add(p1);
        
        LIST<DCPLeadRequestHandler.OnlineContactsFieldsClass> proviewOnlineContacts = new LIST<DCPLeadRequestHandler.OnlineContactsFieldsClass>();
        DCPLeadRequestHandler.OnlineContactsFieldsClass poc = new DCPLeadRequestHandler.OnlineContactsFieldsClass();
        poc.pFirstName = 'HelloName';
        poc.pLastName = 'HelloLastName';
        poc.pEmail = 'HelloName342@xingxong.com';
        poc.pPosition = 'Attorny';
        poc.pType = 'Contact';
        poc.isAdmin = true;
        poc.jurisdiction = 'Test juri';
        poc.entitlementProducts = proviewids;
        
        proviewOnlineContacts.add(poc);
        
        dcpOrder.isExistingCustomer = false;
        dcpOrder.LeadsourceCountryCode = pdw.leadsourceCountryCode;
        dcpOrder.LeadOriginSite = pdw.leadOriginSite;
        dcpOrder.siteLanguageCode = 'English';
       // dcpOrder.productFamily ='WestLaw Classic';
        
        dcpCustomerDetails.firstName = 'Servendra';
        dcpCustomerDetails.lastName = pdw.lname;
        dcpCustomerDetails.businessEmail = 'testfirst.testlast@test.com';
        dcpCustomerDetails.isPhysicalSameAsBillingAddress = true;
        dcpCustomerDetails.isOLCAvailalble = true;
        dcpCustomerDetails.businessPhoneNumber = '254173978';
        dcpCustomerDetails.shippingPhoneNumber = '324178923';
        dcpCustomerDetails.shippingFirstName = 'Servendra';
        dcpCustomerDetails.shippingLastName = 'K';
        
        
        dcpCustomerAddress.street1='610 Opperman Dr';
        dcpCustomerAddress.street2='';
        dcpCustomerAddress.city='Eagan';
        dcpCustomerAddress.state='AL';
        dcpCustomerAddress.zipCode='55123';
        dcpCustomerAddress.country='US';
        
      // DCP-4205 - Priyanka Mondal     
        dcpAccountDetails.organizationName = 'TCS';
        dcpAccountDetails.accountANumber = '123456';
        dcpAccountDetails.billingAddress = dcpCustomerAddress;
        dcpAccountDetails.organizationType = 'Law Firm';
        //dcpAccountDetails.onePassGUID ='10108';
        
        
        onlineContactField.pFirstName = 'OlcFirst';
        onlineContactField.pLastName = 'OlcLast';
        onlineContactField.pEmail = 'testolc123';
        onlineContactField.pPosition = 'Attorney';
        onlineContactField.pType = 'User';
        onlineContactField.isAdmin = true;
        onlineContactField.jurisdiction = 'Alaska';
        onlineContactField.entitlementProducts = proviewids;
        
        onlineContactFieldList.add(onlineContactField);
        
        dcpRef.leadId= pdw.leadId;
        dcpRef.cartId= pdw.cartId;
        dcpActionParams.leadAction= pdw.actionParm;
        
        dcpCustomerDetails.organizationDetails=dcpAccountDetails;
        dcpCustomerDetails.shippingAddress=dcpCustomerAddress;
        
        dcpOrder.customerDetails=dcpCustomerDetails;
        if(!pdw.isOnlineContact){
            dcpOrder.entitlementContacts = proviewOnlineContacts;
        }else{
            dcpOrder.entitlementContacts = onlineContactFieldList;
        }       
        
        
        dcpOrders.OrderDetails=dcpOrder;
        dcpOrders.actionParamsDetails=dcpActionParams;
        dcpOrders.referencesDetails=dcpRef;
        
        return dcpOrders;
        
    }
    /**
* @description
*/ 
    public static testMethod  void testDCPCreateProcess(){
        
        Apttus_Config2__ProductConfiguration__c cartRec = createProductConfigurations();
        DCPLeadService processCreate = new DCPLeadService();
        
        // insert lead
        lead ldb = new lead();
        ldb.FirstName='Servendra';
        ldb.LastName='Kumar';
        ldb.Email='testfirst.testlast5874@test.com';        
        ldb.IsConverted=false;
        ldb.Company='TCS';
        
        ldb.Billing_Street__c = 'Banito Blanco 822';
        ldb.Billing_City__c = 'New Yark';
        ldb.Billing_State__c = 'NY';
        ldb.Billing_Country__c ='US';
        ldb.TRstore_Billadd_differenceto_shipping__c = true;
        ldb.SAPAccountNumber__c = '12345623';
        ldb.Is_GLI__c=true;
        insert ldb;
        System.assert(ldb != null, 'Inserted lead');
        String jsonMsg='{"dcpOrder":{"OrderDetails":{"isExistingCustomer":true,"LeadsourceCountryCode":"US","LeadOriginSite":"TPRO","productFamily":"product",customerDetails":{"firstName":"CustomerFirstName","lastName":"CustomerLastName","businessEmail":"customeremailtestFeb20@mailinator.com","isPhysicalSameAsBillingAddress":true,"businessPhoneNumber":"(987) 654- 1230","shippingPhoneNumber":"(987) 654- 1230","organizationDetails":{"organizationName":"ABC Corp","onePassGUID":"99","accountANumber":"1001000","organizationType":"SLF 2-3","billingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"1001000"}},"shippingAddress":{"street1":"610 Opperman Dr","street2":"","city":"Eagan","state":"AL","zipCode":"55123","country":"US","accNumber":"12345"}}},"referencesDetails":{"leadId":"'+ ldb.id +'","cartId":"'+  cartRec.id +'"},"actionParamsDetails":{"leadAction":"create"}}}';
        
        
        
        Test.startTest();
        createStaticValues();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/newsale/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        
        PrepareDataWrapper pdw = new PrepareDataWrapper();
        pdw.lname = 'Kumar';
        pdw.leadId = ldb.id;
        pdw.leadsourceCountryCode = 'US';
        pdw.leadOriginSite = 'TPRO';
        pdw.actionParm = 'create';
        pdw.cartId = cartRec.id;
        pdw.isOnlineContact = true;
       // pdw.onepassid='11';
        //pdw.productfamily='efe';
       // pdw.AccountANumber='343';
        
        DCPLeadRequestHandler.DCPOrders dcpOrder0 = DCPLeadServiceTest.prepareData(pdw);
        DCPLeadRequest.processLead(dcpOrder0);
        processCreate.processLead(dcpOrder0);
        
        PrepareDataWrapper pdw1 = new PrepareDataWrapper();
        pdw1.lname = 'Kumar';
        pdw1.leadId =ldb.id;
        pdw1.leadsourceCountryCode = 'US';
        pdw1.leadOriginSite = 'TPRO';
        pdw1.actionParm = 'create';
        pdw1.cartId = cartRec.id;
        pdw1.isOnlineContact = true;
       // pdw1.onepassid='101012';
       // pdw1.productfamily='product';
       // pdw1.AccountANumber='434';
        
        DCPLeadRequestHandler.DCPOrders dcpOrder = DCPLeadServiceTest.prepareData(pdw1);
         // DCPLeadRequest.processLead(dcpOrder);
        processCreate.processLead(dcpOrder);
        
        lead ld = new lead();
        ld.FirstName='Servendra';
        ld.LastName='Kumar';
        ld.Email='testfirst.testlast@test.com';
        ld.IsConverted=false;
        ld.Company='TCS';
        
        ld.Product_Configuration__c=cartRec.Id;
        insert ld;
        
        //System.assertEquals( ld.Email , 'testfirst.testlast@test.com');
        
        system.debug(LoggingLevel.Info,res);
        PrepareDataWrapper pdw2 = new PrepareDataWrapper();
        pdw2.lname = null;
        pdw2.leadId = ld.id;
        pdw2.leadsourceCountryCode = 'US';
        pdw2.leadOriginSite = 'TPRO';
        pdw2.actionParm = 'create';
        pdw2.cartId = cartRec.id;
        pdw2.isOnlineContact = false;
        DCPLeadRequestHandler.DCPOrders dcpOrder2 = DCPLeadServiceTest.prepareData(pdw2);
        processCreate.processLead(dcpOrder2);
        
        PrepareDataWrapper pdw3 = new PrepareDataWrapper();
        pdw3.lname = null;
        pdw3.leadId = ld.id;
        pdw3.leadsourceCountryCode = 'CA';
        pdw3.leadOriginSite = 'UECAPR';
        pdw3.actionParm = 'create';
        pdw3.cartId = cartRec.id;
        pdw3.isOnlineContact = false;
        DCPLeadRequestHandler.DCPOrders dcpOrder3 = DCPLeadServiceTest.prepareData(pdw3);
        processCreate.processLead(dcpOrder3);
        
        PrepareDataWrapper pdw4 = new PrepareDataWrapper();
        pdw4.lname = null;
        pdw4.leadId = null;
        pdw3.leadsourceCountryCode = null;
        pdw3.leadOriginSite = null;
        pdw4.actionParm = null;
        pdw4.cartId = null;
        pdw4.isOnlineContact = false;
        DCPLeadRequestHandler.DCPOrders dcpOrder4 = DCPLeadServiceTest.prepareData(pdw4);
        processCreate.processLead(dcpOrder4);
        
        PrepareDataWrapper pdw5 = new PrepareDataWrapper();
        pdw5.lname = 'Kumar';
        pdw5.leadId = ldb.id;
        pdw5.leadsourceCountryCode = 'US';
        pdw5.leadOriginSite = 'TPRO';
        pdw5.actionParm = 'create';
        pdw5.cartId = cartRec.id;
        pdw5.isOnlineContact = true;
        //pdw5.onepassid='';
        //pdw5.productfamily='';
       // pdw5.AccountANumber='';
        
        DCPLeadRequestHandler.DCPOrders dcpOrder5 = DCPLeadServiceTest.prepareData(pdw5);
        //DCPLeadRequest.processLead(dcpOrder5);
        processCreate.processLead(dcpOrder5);
        
        
        Test.stopTest();  
        
    }
    /**
* @description
* @return
*/ 
    public static Apttus_Config2__ProductConfiguration__c  createProductConfigurations() {
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        //insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        insert prodConfigObj;
        
        return prodConfigObj;
        
    }
    
    /**
* @description
*/ 
    public static void createStaticValues() {
        
        // insert campaign
        Campaign c1 = new Campaign();
        c1.Name = 'Test Campaign 1';
        insert c1;
        
        // insert price book
        pricebook2 cpb = new pricebook2();
        cpb.name = 'GLI Price Book - US Legal/LMS';
        
        insert cpb;
        
        // insert custom settings [Static_Values__c ]
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>();
        Static_Values__c stl = new Static_Values__c(name='LeadConvertOwnerId', value__c=userInfo.getUserId());
        Static_Values__c sth = new Static_Values__c(name='Hive9Code', value__c='432217');
        Static_Values__c stc = new Static_Values__c(name='SFDCCampaignId', value__c=c1.id);
        Static_Values__c sts = new Static_Values__c(name='SSDNotFound', value__c='Sample Text'); 
        Static_Values__c stpb = new Static_Values__c(name='PriceBookName', value__c= 'GLI Price Book - US Legal/LMS');
        Static_Values__c stlc = new Static_Values__c(name='TRStorePELeadConvertCode', value__c= 'LeadConvert');
        Static_Values__c stoc = new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c= 'OrderConfirmation');
        Static_Values__c stmc = new Static_Values__c(name='TRStoremicrositeOrderComplete', value__c= 'MicrositeOrderComplete');        
        Static_Values__c strt = new Static_Values__c(name='SSDRecordType', value__c= 'LOTUS Source Systems'); 
        Static_Values__c stca = new Static_Values__c(name='Hive9CodeCA', value__c='9009510'); 
        Static_Values__c stus = new Static_Values__c(name='Hive9CodeUS', value__c='9009510');
        Static_Values__c stcca = new Static_Values__c(name='SFDCCampaignIdCA', value__c=c1.id);
        Static_Values__c stcus = new Static_Values__c(name='SFDCCampaignIdUS', value__c=c1.id);         
        Static_Values__c stlgid = new Static_Values__c(name='LeadOwnerGroupId', value__c= 'aemconnect.user@trpcorelegal.com');
        Static_Values__c stlrtn = new Static_Values__c(name='LeadRecordTypeName', value__c= 'GLI');     
        Static_Values__c stmic = new Static_Values__c(name='trc', value__c= 'TR Store');
        Static_Values__c stLse = new Static_Values__c(name='LeadSupportEmail', value__c= 'kanishk.singhvi@thomsonreuters.com');
        Static_Values__c stOse = new Static_Values__c(name='OrderProcessSupportEmail', value__c= 'kanishk.singhvi@thomsonreuters.com');
        Static_Values__c stIntBestRate = new Static_Values__c(name='ShipMethodMicrositeIntBestPrice', value__c= 'International best Rate');
        Static_Values__c stPayOptMicro = new Static_Values__c(name='PaymentOptionMicrosite', value__c= 'Pay by Charge Code');
        Static_Values__c storpDe = new Static_Values__c(name='cartOrphanCartDeleteDays', value__c= '0');
        Static_Values__c stcn = new Static_Values__c(name='cartName', value__c= 'Auto Generated');
        Static_Values__c stcs = new Static_Values__c(name='cartStatus', value__c= 'New');
        Static_Values__c stclm = new Static_Values__c(name='cartModifiedAliase', value__c= userInfo.getUserId());
        Static_Values__c stcsc = new Static_Values__c(name='cartDeleteTimeFrame', value__c= '0 0 21 ? * MON-FRI *');
        
        Static_Values__c stusow = new Static_Values__c(name='TransactLeadOwnerGroupUS', value__c= userinfo.getUserName());
        Static_Values__c stcaow = new Static_Values__c(name='TransactLeadOwnerGroupCA', value__c= userinfo.getUserName());
        Static_Values__c stuest = new Static_Values__c(name='UECAPR', value__c= 'UE Store Canada PRINT');
        Static_Values__c stueoc = new Static_Values__c(name='TransactOrderConfirmationCode', value__c= 'OrderConfirmation');
        
        
        
        staticCSList.add(stl);
        staticCSList.add(sth);
        staticCSList.add(stc); 
        staticCSList.add(sts);
        staticCSList.add(stpb);
        staticCSList.add(stlc);
        staticCSList.add(stoc);
        staticCSList.add(strt);
        staticCSList.add(stca);
        staticCSList.add(stus);
        staticCSList.add(stcca);
        staticCSList.add(stcus);
        staticCSList.add(stmc);
        staticCSList.add(stlgid);
        staticCSList.add(stlrtn);
        staticCSList.add(stmic);
        staticCSList.add(stLse);
        staticCSList.add(stOse);
        staticCSList.add(stIntBestRate);
        staticCSList.add(stPayOptMicro);
        staticCSList.add(storpDe);
        staticCSList.add(stcn);
        staticCSList.add(stcs);
        staticCSList.add(stclm);
        staticCSList.add(stcsc);
        staticCSList.add(stcaow);
        staticCSList.add(stusow);
        staticCSList.add(stuest);
        staticCSList.add(stueoc);
        
        
        insert staticCSList;              
    }   
}