/**
* @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :  
 * @last modified on  : 06-03-2021
* @last modified by  : 
* Modifications Log  
 * Ver   Date         Author                               Modification
* 1.0   06-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class OmniOnePassOLCCallout_Test {

    public static boolean isFromTest = true;
    public static OmniOnePassResponseWrapper omniWrapper;
    
    @isTest
    public static void testMethod1(){
       
        
        list<TrialContactWrapper> trlContacts = new list<TrialContactWrapper>();
        
         Account acc = new Account();
          acc.name = 'test acc';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc.BU_Region__c = 'Canada';
          acc.Bu_Segment__c = 'Professional Tax';
          acc.Is_GLI__c = true;
          insert acc;
          
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(acc.Id);
          
        
        Ent_Trial__c trc= new Ent_Trial__c();
        trc.Account__c = acc.id;
        trc.Opportunity__c = testOpportunity.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        trc.External_Account_Number__c = '4332938';
        insert trc;
               
        TrialContactWrapper tw = new TrialContactWrapper();
        TrialOLCOnePassByEmailRespWrap olcOnepassVar = new TrialOLCOnePassByEmailRespWrap();
        olcOnepassVar.externalAccountNumber='1234567';
        olcOnepassVar.externalAccountNumberSource ='test';
        olcOnepassVar.companyId = 'CID00123';
        olcOnepassVar.cobaltGUID ='CGID0921';
        olcOnepassVar.dataRoomGUID = 'DRMGID002';
        olcOnepassVar.profileType = 'NEW_CUSTOMER';
        tw.email = 'TEST@GMAIL.COM';
        olcOnepassVar.externalContactNumber = 'ex00312';
        olcOnepassVar.externalContactNumberSource ='Test';
        tw.firstName = 'fname';
        tw.lastName='lname';
        olcOnepassVar.onePassId ='12321232';
        tw.onlineContact=true;
        //tw.contactId = '121212';
        tw.fullName = 'fullname';
        tw.isPrimaySelectedFromUI = true;
        //tw.trialContRecordId ;
        tw.trialId=trc.ID;
        tw.trialstatus='active';
        tw.gsiPrimaryFlag = true;
        tw.onlineContactDesignation = true;
        tw.oLCStatus = 'active';
        
        //trialCont.olcOnePass = olcOnepassVar;
        
        trlContacts.add(tw);


        list<WebServiceSettings__c> wbSettings = new list<WebServiceSettings__c>();
        WebServiceSettings__c  wb = new WebServiceSettings__c ();
        wb.Name = 'OmniGenericEntitlementService';
        wb.CurrencyIsoCode = 'USD';
        wb.Active__c = true;
        wb.password__c='s2esandboxESI12c';
        wb.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb.Timeout__c = 120 ; 
        wbSettings.add(wb);
        
        WebServiceSettings__c  wb1 = new WebServiceSettings__c ();
        wb1.Name = 'OmniOnePassToBoomi';
        wb1.CurrencyIsoCode = 'USD';
        wb1.Active__c = true;
        wb1.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb1.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb1.Timeout__c = 120 ; 
        wbSettings.add(wb1);
        
        insert wbSettings;
        generateWrapper();        
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        
        List<TrialContactWrapper> res = OmniOnePassOLCCallout.getTrialContsWrapFromOLCOnePass(System.JSON.serialize(trlContacts));
        test.stopTest();

        System.assertEquals(true,res!=null,'Success');
    }
    
    
    
    @isTest
    public static void testMethod2(){
        
         
        
        list<TrialContactWrapper> trlContacts = new list<TrialContactWrapper>();
        
         Account acc = new Account();
          acc.name = 'test acc';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc.BU_Region__c = 'Canada';
          acc.Bu_Segment__c = 'Professional Tax';
          acc.Is_GLI__c = true;
          insert acc;
          
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(acc.Id);
        
        Ent_Trial__c trc= new Ent_Trial__c();
        trc.Account__c = acc.id;
        trc.Opportunity__c = testOpportunity.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        trc.External_Account_Number__c = '4332938';
        insert trc;
        
        
        TrialContactWrapper tw = new TrialContactWrapper();
        
        TrialOLCOnePassByEmailRespWrap olcOnepassVar = new TrialOLCOnePassByEmailRespWrap();
        
        olcOnepassVar.externalAccountNumber='1234567';
        olcOnepassVar.externalAccountNumberSource ='test';
        olcOnepassVar.companyId = 'CID00123';
        olcOnepassVar.cobaltGUID ='CGID0921';
        olcOnepassVar.dataRoomGUID = 'DRMGID002';
        olcOnepassVar.profileType = 'NEW_CUSTOMER';
        tw.email = 'TEST@GMAIL.COM';
        olcOnepassVar.externalContactNumber = 'ex00312';
        olcOnepassVar.externalContactNumberSource ='Test';
        tw.firstName = 'fname';
        tw.lastName='lname';
        olcOnepassVar.onePassId ='12321232';
        tw.onlineContact=true;
        //tw.contactId = '121212';
        tw.fullName = 'fullname';
        tw.isPrimaySelectedFromUI = true;
        //tw.trialContRecordId ;
        tw.trialId=trc.ID;
        tw.trialstatus='active';
        tw.gsiPrimaryFlag = true;
        tw.onlineContactDesignation = true;
        tw.oLCStatus = 'active';
        
        //trialCont.olcOnePass = olcOnepassVar ;
        
        trlContacts.add(tw);


        list<WebServiceSettings__c> wbSettings = new list<WebServiceSettings__c>();
        WebServiceSettings__c  wb = new WebServiceSettings__c ();
        wb.Name = 'OmniGenericEntitlementService';
        wb.CurrencyIsoCode = 'USD';
        wb.Active__c = true;
        wb.password__c='s2esandboxESI12c';
        wb.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb.Timeout__c = 120 ; 
        wbSettings.add(wb);
        
        WebServiceSettings__c  wb1 = new WebServiceSettings__c ();
        wb1.Name = 'OmniOnePassToBoomi';
        wb1.CurrencyIsoCode = 'USD';
        wb1.Active__c = true;
        wb1.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb1.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb1.Timeout__c = 120 ; 
        wbSettings.add(wb1);
        
         WebServiceSettings__c  wb2 = new WebServiceSettings__c ();
        wb2.Name = 'OmniBoomiToken';
        wb2.CurrencyIsoCode = 'USD';
        wb2.Active__c = true;
        wb2.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb2.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb2.Timeout__c = 120 ; 
        wbSettings.add(wb2);
        
        insert wbSettings;
        generateWrapper();
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        isFromTest = false;
       List<TrialContactWrapper> res = OmniOnePassOLCCallout.getTrialContsWrapFromOLCOnePass(System.JSON.serialize(trlContacts));
        test.stopTest();
        System.assertEquals(true,res!=null,'Success');
        
       
    }
    
    
    @isTest
    public static void testMethod3(){
        OmniCallToOLCByEmailRequestWrapper ow = new OmniCallToOLCByEmailRequestWrapper();
        ow.emailAddress = 'Test@testEmail.com';
        OmniCallToOLCByEmailRequestWrapper.ESIHeader esiHeader = new  OmniCallToOLCByEmailRequestWrapper.ESIHeader('12345676');
        OmniCallToOLCByEmailRequestWrapper.Account acc = new OmniCallToOLCByEmailRequestWrapper.Account('123232');
        OmniCallToOLCByEmailRequestWrapper.OnlineContactFilter contactFilter = new OmniCallToOLCByEmailRequestWrapper.OnlineContactFilter('Test','Test');
        ow.esiHeader = esiHeader;
        ow.onlineContactFilter = contactFilter;
        ow.account = acc;
        string jsonStr = JSON.serialize(ow);
        OmniCallToOLCByEmailRequestWrapper ow2 = OmniCallToOLCByEmailRequestWrapper.parse(jsonStr);
        system.assertEquals('Test@testEmail.com', ow2.emailAddress, 'SUCCESS');
    }
    
    /**
     * @description : generateWrapper
     */
    public static void generateWrapper(){
        Omniwrapper  = new OmniOnePassResponseWrapper();
        
        OmniOnePassResponseWrapper.BOOMIHeader  bHeader= new OmniOnePassResponseWrapper.BOOMIHeader();
        bHeader.companyId = '1234567';
        
        OmniOnePassResponseWrapper.Notification ntfc = new OmniOnePassResponseWrapper.Notification();
        ntfc.statusCode = 'Test121';
        ntfc.statusDescription = 'Test';
        ntfc.statusDetailMessage = 'Test';
        ntfc.trackingId = '2323232323';
        
         OmniOnePassResponseGenereicWrapper.Header hdr = new OmniOnePassResponseGenereicWrapper.Header();
        hdr.AuthenticationToken = 'Test token';
        hdr.ContextualInformation = 'test';
        //hdr.ProductIdentifier = 'Prdo';
        //hdr.SessionToken = 'test';
        //hdr.SlideInformation = 'test';
        //hdr.UserHostIpAddress = '123.23.234.12';
        //hdr.Version = 'v1.0';
        
        OmniOnePassResponseWrapper.ServiceStatus servc = new OmniOnePassResponseWrapper.ServiceStatus();
        servc.ElapsedTime = '11:03:34';
       servc.StartTime = '10:10:10';
        servc.StatusCode = '200';
        servc.StatusDescription = 'test';
        
        OmniOnePassResponseGenereicWrapper.Trace trce = new OmniOnePassResponseGenereicWrapper.Trace();
        trce.ExecutionType = 'test';
        trce.ParentGuid = '2232';
        trce.Product='P3232';
        trce.RootGuid = 'R3434';
        trce.ServerInformation = 'TEST';
        trce.SessionGuid = 'S2323';
        trce.TransactionGuid = 'T43434';
        trce.UserGuid = '43434';        
        
        OmniOnePassResponseGenereicWrapper.Criteria crtr = new  OmniOnePassResponseGenereicWrapper.Criteria();
        crtr.EmailAddress = 'test@gmail.com';
        crtr.FirstName = 'FNAME';
        crtr.Identifier = 'I2323';
        crtr.LastName = 'Lname';
        crtr.ProductCode = 'P4343';
        crtr.RegistrationKey = 'R4343434';
        crtr.Username= 'TEST@Gmail.com';
        
        LIST<OmniTrialsProfilesWrapper.Profiles> profiles = new LIST<OmniTrialsProfilesWrapper.Profiles>();
        OmniTrialsProfilesWrapper.Profiles prfls = new OmniTrialsProfilesWrapper.Profiles();
        prfls.EmailAddress = 'Test@gmail.com';
        prfls.FirstName ='Fname';
        prfls.Identifier ='ID3434';
        prfls.LastName = 'Lname';
        prfls.Password = 'PWD';
        prfls.PasswordExpirationDate = '06-06-2021';
        prfls.PasswordLifetime = '90';
        prfls.ProfileType ='admin';
        prfls.Username = 'TEST@GMAIL.COM';
        profiles.add(prfls);
        
        list<OmniOnePassResponseWrapper.Results> res = new list<OmniOnePassResponseWrapper.Results>();
        OmniOnePassResponseWrapper.Results result = new OmniOnePassResponseWrapper.Results();
        result.Criteria = crtr;
        result.Profiles = profiles;
        res.add(result);
        
        Omniwrapper.BOOMIHeader = bHeader;
        Omniwrapper.Notification = ntfc;
        Omniwrapper.Header = hdr;
        Omniwrapper.ServiceStatus =servc;
        Omniwrapper.Trace = trce;
        Omniwrapper.Results =res;
        
        OmniTrialsProfilesWrapper.omniTestMethod();
        OmniOnePassResponseGenereicWrapper.omniTestMethod();
        OmniRegistrationKeyWrapper.omniTestMethod();
        TrialContactWrapper.omniTestMethod();
        TrialOLCOnePassByEmailRespWrap.omniTestMethod();
        OmniTrialOnlineContactWrapper.omniTestMethod();
        OmniOLCEntitlementsWrapper.omniTestMethod();
        TrialProductWrapper.omniTestMethod();
    }
}