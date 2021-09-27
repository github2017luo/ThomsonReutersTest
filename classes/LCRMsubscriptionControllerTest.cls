/*
======================================================================================================================
CLASS NAME:    LCRMsubscriptionControllertest  
======================================================================================================================
=
PURPOSE:    Code coverage for LCRMsubscriptionController and LCRMsubscriptionsJsonWrapper

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
10/26/2017       Radhika Pawar     [CRM-7821] [SFDC DEV] Code behind the Subscription button on the account
======================================================================================================================
*/

@isTest
public class LCRMsubscriptionControllerTest {
    
    @isTest static void testLCRMSubscriptionSendRequest() {
        User testUser = getTestPrintUser();
		
        //insert testUser;
        System.runAs(testUser) {
            KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            getListOfSSD(accRecord, testUser);
            List < WebServiceSettings__c > lstofSubscriptionWebServ = getLstofSubscriptionWebServ();
            
            //Values for View Picklist
            getListofSubscriptionTypes();
            
            //Sort picklist Values
            getListOfSortOrder();
            
            //Picklist value for Sort field by
            List<SubscriptionSortByField__c> listofSubscriptionSortByField =getListofSubscriptionSortByField();
            System.assert(listofSubscriptionSortByField!= null, true);
            System.assertEquals('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount', lstofSubscriptionWebServ[0].Endpoint__c,'Endpoint URL should be matched');
            //End
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.displayLCRMSubcriptioninfo();
            //
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.assertEquals(200,res.getStatusCode(),'Res should come');
            System.assertEquals('application/json', res.getHeader('Content-Type'),'Header should be JSON type'); 
            //
            oSubscription.getSubscriptionListOptions();
            oSubscription.selectall =true;
            oSubscription.saveselectedopen();
            //List<selectOption> options =  oSubscription.sortSubscriptionByfield;
            //System.debug('options: '+options);
            oSubscription.getSortByOrder();
            oSubscription.nextPage();
            oSubscription.updatePage();
            oSubscription.previousPage();
            // oSubscription.print();
            
            //PageReference pageref2 = oSubscription.saveAsPDF();
            //System.debug('pageref2 : '+pageref2 );
            //PageReference pageref1 = oSubscription.saveAsExcel();
            //System.debug('pageref1 : '+pageref1 );
            
            Test.stopTest();
            LCRMsubscriptionController oSubscriptionSort = new LCRMsubscriptionController(oStandardController);
            oSubscriptionSort.sortSubscription();
            oSubscriptionSort.processSelected();
            //oSubscriptionSort.saveselectedopen();
            oSubscriptionSort.selectalllineitem();
        } 
        
    }
    
    @isTest static void testSalesOrgUnavailable() {
        Profile testProfile = [SELECT Id 
                               FROM profile
                               WHERE Name = 'System Administrator' 
                               LIMIT 1];
        User testUser = new User(LastName = 'test user 1', 
                                 Username = 'test.user.1@example.com', 
                                 Email = 'test.1@example.com', 
                                 Alias = 'testu1',
                                 Sub_Bu__c='USL',                            
                                 TimeZoneSidKey = 'GMT', 
                                 LocaleSidKey = 'en_GB', 
                                 EmailEncodingKey = 'ISO-8859-1', 
                                 ProfileId = testProfile.Id, 
                                 LanguageLocaleKey = 'pt_BR'); 
										 
        System.runAs(testUser){
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            final String strSalesOrgVal='WEST'; 
            List < Source_System_Detail__c > listOfSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c ssdWithSAPNo = new Source_System_Detail__c();
            ssdWithSAPNo.name = 'SSD_01';
            ssdWithSAPNo.Source_System_Account_Number__c = '1000440816';
            ssdWithSAPNo.Account_Name__c = accRecord.id;
            ssdWithSAPNo.Source_System_Name__c = 'LCRMGLI';
            ssdWithSAPNo.LCRM_Sales_Org__c = strSalesOrgVal;
            ssdWithSAPNo.LCRM_Sub_BU__c = testUser.Sub_Bu__c;
            listOfSSD.add(ssdWithSAPNo);
            
            Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
            ssdWithSalesOrg.name = 'SSD_02';
            ssdWithSalesOrg.Source_System_Account_Number__c = '1004683611';
            ssdWithSalesOrg.Account_Name__c = accRecord.id;
            ssdWithSalesOrg.Source_System_Name__c = 'LCRMGLISSD';
            ssdWithSalesOrg.LCRM_Sales_Org__c =strSalesOrgVal;  
            ssdWithSalesOrg.LCRM_Sub_BU__c = testUser.Sub_Bu__c;
            listOfSSD.add(ssdWithSalesOrg);
            
            if (listOfSSD.size() > 0) {
                insert listOfSSD;
            }
            
            List < WebServiceSettings__c > lstofSubscriptionWebServ = new List < WebServiceSettings__c > ();
            WebServiceSettings__c subscriptionWebService = new WebServiceSettings__c();
            subscriptionWebService.name = 'LCRMSubscriptionServices';
            subscriptionWebService.Active__c = true;
            subscriptionWebService.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount';
            subscriptionWebService.Password__c = 'Gliu$er123';
            subscriptionWebService.Service_Unavailable_Message__c = 'GLI Subscription Services is not available';
            subscriptionWebService.Timeout__c = 120;
            subscriptionWebService.Username__c = 'gliuser';
            lstofSubscriptionWebServ.add(subscriptionWebService);
            
            if (lstofSubscriptionWebServ.size() > 0) {
                insert lstofSubscriptionWebServ;
            }
            
            //End
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            //
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req);
            
            System.assertEquals(200,res.getStatusCode(),'Status code 200');
            System.assertEquals('application/json', res.getHeader('Content-Type'),'Content Type JSOn');
            //
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.displayLCRMSubcriptioninfo();
            oSubscription.getSubscriptionListOptions();
            //List<selectOption> options =  oSubscription.sortSubscriptionByfield;
            oSubscription.getSortByOrder();
            
            Test.stopTest();
        } 
        
    }//
    
    
    //
    @isTest static void testDifferenceSalesOrg() {
        User testSMGEUser = new User(
            Alias = 'SMGEUser', 
            Email='SMGE@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'SMGE',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='SMGE@testorg.com'
        );
        insert testSMGEUser;
		
        System.runAs(testSMGEUser) {
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            
            Account parentaccRecord = new Account();
            parentaccRecord = UnitTest.getAccountInstance();
            parentaccRecord.SAPAccountNumber__c = '001104567';
            insert parentaccRecord;
            
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.parentid = parentaccRecord.id;
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            
            final String strSalesOrgVal='WEST'; 
            List < Source_System_Detail__c > listOfSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c ssdWithSAPNo = new Source_System_Detail__c();
            ssdWithSAPNo.name = 'SSD_01';
            ssdWithSAPNo.Source_System_Account_Number__c = '1000440816';
            ssdWithSAPNo.Account_Name__c = accRecord.id;
            ssdWithSAPNo.Source_System_Name__c = 'LCRMGLI';
            ssdWithSAPNo.LCRM_Sales_Org__c = strSalesOrgVal;
            ssdWithSAPNo.LCRM_Sub_BU__c = testSMGEUser.Sub_Bu__c;
            listOfSSD.add(ssdWithSAPNo);
            
            Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
            ssdWithSalesOrg.name = 'SSD_02';
            ssdWithSalesOrg.Source_System_Account_Number__c = '1004683611';
            ssdWithSalesOrg.Account_Name__c = accRecord.id;
            ssdWithSalesOrg.Source_System_Name__c = 'LCRMGLISSD';
            ssdWithSalesOrg.LCRM_Sales_Org__c =strSalesOrgVal; 
            ssdWithSalesOrg.LCRM_Sub_BU__c = testSMGEUser.Sub_Bu__c;
            listOfSSD.add(ssdWithSalesOrg);
            
            if (listOfSSD.size() > 0) {
                insert listOfSSD;
            }
            
            List < WebServiceSettings__c > lstofSubscriptionWebServ = new List < WebServiceSettings__c > ();
            WebServiceSettings__c subscriptionWebService = new WebServiceSettings__c();
            subscriptionWebService.name = 'LCRMSubscriptionServices';
            subscriptionWebService.Active__c = true;
            subscriptionWebService.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount';
            subscriptionWebService.Password__c = 'Gliu$er123';
            subscriptionWebService.Service_Unavailable_Message__c = 'GLI Subscription Services is not available';
            subscriptionWebService.Timeout__c = 120;
            subscriptionWebService.Username__c = 'gliuser';
            lstofSubscriptionWebServ.add(subscriptionWebService);
            
            if (lstofSubscriptionWebServ.size() > 0) {
                insert lstofSubscriptionWebServ;
            }
            
            //End
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.displayLCRMSubcriptioninfo();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.assertEquals(200,res.getStatusCode(), '200 status code');
            System.assertEquals('application/json', res.getHeader('Content-Type'),'Content Type JSON'); 
            oSubscription.getSubscriptionListOptions();
            //List<selectOption> options =  oSubscription.sortSubscriptionByfield;
            oSubscription.getSortByOrder();
            Test.stopTest();
        }    
    }
    
    @isTest static void testOnlineSubType() {
        
        User testOnlineUser =getTestUserexp();
        
        System.assert(testOnlineUser != null, true);
        System.runAs(testOnlineUser) {
            
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            
            Product2 testProd1 =UnitTest.getProductInstance();
            testProd1.ProductCode ='000000000030302837';
            testprod1.IsActive = true;
            insert testprod1;
            
            List < Source_System_Detail__c > listOfSSD = getListOfSSD(accRecord, testOnlineUser);   
            System.assert(listOfSSD!= null, true);
            
            List < WebServiceSettings__c > lstofSubscriptionWebServ = getLstofSubscriptionWebServ();
            System.assert(lstofSubscriptionWebServ!= null, true);
            
            //Values for View Picklist
            List<SubscriptionTypes__c> listofSubscriptionTypes = getListofSubscriptionTypes();
            System.assert(listofSubscriptionTypes!= null, true);
            //Sort picklist Values
            
            List<Sort_Order__c> listOfSortOrder = getListOfSortOrder();
            System.assert(listOfSortOrder!= null, true);
            //Picklist value for Sort field by
            
            List<SubscriptionSortByField__c> listofSubscriptionSortByField =getListofSubscriptionSortByField();
            System.assert(listofSubscriptionSortByField!= null, true);
            
            //End
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.sSelectedOption ='Online';
            oSubscription.displayLCRMSubcriptioninfo();
            oSubscription.getSubscriptionListOptions();
            List<selectOption> options =  oSubscription.sortSubscriptionByfield;
            System.assert(options!= null, true);
            oSubscription.getSortByOrder();
            oSubscription.nextPage();
            oSubscription.updatePage();
            oSubscription.previousPage();
            Test.stopTest();
            
        } 
        
    }
    
    /** 
    * @description Get User
    * @return User Sobject
    */ 
    public static User getTestPrintUser(){
		KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
		testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
		testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
		insert testLcrmSUBBU;
        User testPrintUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testPrintUser;
        return testPrintUser;
    }
    
    /** 
    * @description Subscription TYpes
    * @return Type
    */ 
    public static List<SubscriptionTypes__c> getPrintListofSubscriptionTypes(){
		KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
		testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
		testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
		insert testLcrmSUBBU;
        List<SubscriptionTypes__c> listofSubscriptionTypes = new List<SubscriptionTypes__c>();
            
            SubscriptionTypes__c atciveSubscriptiontype = new SubscriptionTypes__c();
            atciveSubscriptiontype.name='All Active';
            atciveSubscriptiontype.Portuguese__c='Todas Ativas';
            atciveSubscriptiontype.Spanish__c='Todas Activas';
            listofSubscriptionTypes.add(atciveSubscriptiontype);
            
            SubscriptionTypes__c lapsedSubscriptiontype = new SubscriptionTypes__c();
            lapsedSubscriptiontype.name='All Lapsed';
            lapsedSubscriptiontype.Portuguese__c='Todas Inativas';
            lapsedSubscriptiontype.Spanish__c='Todas Inactivas';
            listofSubscriptionTypes.add(lapsedSubscriptiontype);
            
            SubscriptionTypes__c findlawSubscriptiontype = new SubscriptionTypes__c();
            findlawSubscriptiontype.name='FindLaw';
            findlawSubscriptiontype.Portuguese__c='FindLaw';
            findlawSubscriptiontype.Spanish__c='FindLaw';
            listofSubscriptionTypes.add(findlawSubscriptiontype);
            
            SubscriptionTypes__c onlineSubscriptiontype = new SubscriptionTypes__c();
            onlineSubscriptiontype.name='Online';
            onlineSubscriptiontype.Portuguese__c='Online';
            onlineSubscriptiontype.Spanish__c='Online';
            listofSubscriptionTypes.add(onlineSubscriptiontype);
            
            SubscriptionTypes__c printSubscriptiontype = new SubscriptionTypes__c();
            printSubscriptiontype.name='Print';
            printSubscriptiontype.Portuguese__c='Impresso';
            printSubscriptiontype.Spanish__c='Impreso';
            listofSubscriptionTypes.add(printSubscriptiontype);
            
            SubscriptionTypes__c wpdSubscriptiontype = new SubscriptionTypes__c();
            wpdSubscriptiontype.name='WPD';
            wpdSubscriptiontype.Portuguese__c='WPD';
            wpdSubscriptiontype.Spanish__c='WPD';
            listofSubscriptionTypes.add(wpdSubscriptiontype);
            
            if(listofSubscriptionTypes.size()>0){
                insert listofSubscriptionTypes;
            }
        return listofSubscriptionTypes;
    }
    @isTest static void testPrintSubType() {
        User testPrintUser = getTestPrintUser();
         System.assert(testPrintUser!= null, true);
        System.runAs(testPrintUser) {
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            
            Product2 testProd1 =UnitTest.getProductInstance();
            testProd1.ProductCode ='000000000030302837';
            testprod1.IsActive = true;
            insert testprod1;
            
            final String strSalesOrgVal='WEST'; 
            List < Source_System_Detail__c > listOfSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c ssdWithSAPNo = new Source_System_Detail__c();
            ssdWithSAPNo.name = 'SSD_01';
            ssdWithSAPNo.Source_System_Account_Number__c = '1000002046';
            ssdWithSAPNo.Account_Name__c = accRecord.id;
            ssdWithSAPNo.Source_System_Name__c = 'LCRMGLI';
            ssdWithSAPNo.LCRM_Sales_Org__c = strSalesOrgVal;
            ssdWithSAPNo.LCRM_Sub_BU__c = testPrintUser.Sub_Bu__c;
            listOfSSD.add(ssdWithSAPNo);
            
            Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
            ssdWithSalesOrg.name = 'SSD_02';
            ssdWithSalesOrg.Source_System_Account_Number__c = '1000287469';
            ssdWithSalesOrg.Account_Name__c = accRecord.id;
            ssdWithSalesOrg.Source_System_Name__c = 'LCRMGLISSD';
            ssdWithSalesOrg.LCRM_Sales_Org__c =strSalesOrgVal;  
            ssdWithSalesOrg.LCRM_Sub_BU__c = testPrintUser.Sub_Bu__c;
            listOfSSD.add(ssdWithSalesOrg);
            
            if (listOfSSD.size() > 0) {
                insert listOfSSD;
            }
            
            List < WebServiceSettings__c > lstofSubscriptionWebServ = new List < WebServiceSettings__c > ();
            WebServiceSettings__c subscriptionWebService = new WebServiceSettings__c();
            subscriptionWebService.name = 'LCRMSubscriptionServices';
            subscriptionWebService.Active__c = true;
            subscriptionWebService.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount';
            subscriptionWebService.Password__c = 'Gliu$er123';
            subscriptionWebService.Service_Unavailable_Message__c = 'GLI Subscription Services is not available';
            subscriptionWebService.Timeout__c = 120;
            subscriptionWebService.Username__c = 'gliuser';
            lstofSubscriptionWebServ.add(subscriptionWebService);
            
            if (lstofSubscriptionWebServ.size() > 0) {
                insert lstofSubscriptionWebServ;
            }
            
            //Values for View Picklist List<SubscriptionTypes__c> listofSubscriptionTypes = 
            getPrintListofSubscriptionTypes();
            //Sort picklist Values List<Sort_Order__c> listOfSortOrder =
            getlistOfSortOrder();
            /*
            List<Sort_Order__c> listOfSortOrder = new List<Sort_Order__c>();
            
            Sort_Order__c ascSortOder = new Sort_Order__c();
            ascSortOder.Name='ASC';
            ascSortOder.English__c = 'Ascending';
            ascSortOder.LCRM_Sort_Order__c='ascending';
            ascSortOder.Portuguese__c='Ascendente';
            ascSortOder.Spanish__c='Ascendente';
            listOfSortOrder.add(ascSortOder);
            
            Sort_Order__c descSortOder = new Sort_Order__c();
            descSortOder.Name='DESC';
            descSortOder.English__c='Descending';
            descSortOder.LCRM_Sort_Order__c='descending';
            descSortOder.Portuguese__c='Descendente';
            descSortOder.Spanish__c='Descendente';
            listOfSortOrder.add(descSortOder);
            
            if(listOfSortOrder.size()>0){
                insert listOfSortOrder;
            }
            */
            //Picklist value for Sort field by -List<SubscriptionSortByField__c> listofSubscriptionSortByField = 
            getListofSubscriptionSortByField();
            /*
            List<SubscriptionSortByField__c> listofSubscriptionSortByField = new List<SubscriptionSortByField__c>();
            
            SubscriptionSortByField__c bandedAttorneyCountSubField = new SubscriptionSortByField__c();
            bandedAttorneyCountSubField.Name='Banded Attorney Count';
            bandedAttorneyCountSubField.LCRM_Sort_By__c='BANDED_ATRNY_CNT';
            bandedAttorneyCountSubField.Portuguese__c = 'Banded Attorney Count';
            bandedAttorneyCountSubField.Sort_By__c='BandedAttorneyCount ';
            bandedAttorneyCountSubField.Spanish__c='Banded Attorney Count';
            listofSubscriptionSortByField.add(bandedAttorneyCountSubField);
            
            SubscriptionSortByField__c bandedRetailRateSubField = new SubscriptionSortByField__c();
            bandedRetailRateSubField.Name='Banded Retail Rate';
            bandedRetailRateSubField.Portuguese__c = 'Banded Retail Rate';
            bandedRetailRateSubField.Spanish__c='Banded Retail Rate';
            bandedRetailRateSubField.Sort_By__c='BandedRetailRate';
            bandedRetailRateSubField.LCRM_Sort_By__c='BAND_RETAIL_AMT';
            listofSubscriptionSortByField.add(bandedRetailRateSubField);
            
            
            SubscriptionSortByField__c contractTypeSubField = new SubscriptionSortByField__c();
            contractTypeSubField.Name= 'Contract Description';
            contractTypeSubField.Portuguese__c = 'Descrição do Contrato';
            contractTypeSubField.Spanish__c='Descripción Contrato';
            contractTypeSubField.Sort_By__c='ContractType';
            contractTypeSubField.LCRM_Sort_By__c='CONTRACT_TYPE';
            listofSubscriptionSortByField.add(contractTypeSubField);
            
            SubscriptionSortByField__c contractEndDtSubField = new SubscriptionSortByField__c();
            contractEndDtSubField.Name='Contract End Date';
            contractEndDtSubField.Portuguese__c = 'Data de término do Contrato';
            contractEndDtSubField.Spanish__c='Fecha Final Contrato';
            contractEndDtSubField.Sort_By__c='ContractEndDt';
            contractEndDtSubField.LCRM_Sort_By__c='CONTRACT_END';
            listofSubscriptionSortByField.add(contractEndDtSubField);
            
            SubscriptionSortByField__c contractStartDtSubField = new SubscriptionSortByField__c();
            contractStartDtSubField.Name = 'Contract Start Date';
            contractStartDtSubField.Portuguese__c = 'Data de início do Contrato';
            contractStartDtSubField.Spanish__c='Fecha Inicio Contrato';
            contractStartDtSubField.Sort_By__c='ContractStartDt';
            contractStartDtSubField.LCRM_Sort_By__c='CONTRACT_START';
            listofSubscriptionSortByField.add(contractStartDtSubField);
            
            SubscriptionSortByField__c detailsSubField = new SubscriptionSortByField__c();
            detailsSubField.Name= 'Details';
            detailsSubField.Portuguese__c = 'Detalhes';
            detailsSubField.Spanish__c='Detalles';
            detailsSubField.Sort_By__c='ProgramDiscountDesc';
            detailsSubField.LCRM_Sort_By__c='DISC_PROG_DESC';
            listofSubscriptionSortByField.add(detailsSubField);
            
            SubscriptionSortByField__c estimatedUnitSubField = new SubscriptionSortByField__c();
            estimatedUnitSubField.Name='Estimated Unit Upkeep';
            estimatedUnitSubField.Portuguese__c = 'Unidade estimada de manutenção';
            estimatedUnitSubField.Spanish__c='Unidad Estimada Mantenimiento';
            estimatedUnitSubField.Sort_By__c='EstimatedUnitUpKeep';
            estimatedUnitSubField.LCRM_Sort_By__c='EST_UPKEEP';
            listofSubscriptionSortByField.add(estimatedUnitSubField);
            
            
            SubscriptionSortByField__c  flLocationSubField = new SubscriptionSortByField__c();
            flLocationSubField.Name='FL Sub Location';
            flLocationSubField.Portuguese__c = 'FL Sub Localização';
            flLocationSubField.Spanish__c='FL Sub Locación';
            flLocationSubField.Sort_By__c='FindlawLocationDesc';
            flLocationSubField.LCRM_Sort_By__c='FL_LOCATION_DESC';
            listofSubscriptionSortByField.add(flLocationSubField);
            
            SubscriptionSortByField__c flSubPracticeSubField = new SubscriptionSortByField__c();
            flSubPracticeSubField.Name='FL Sub Practice';
            flSubPracticeSubField.Portuguese__c = 'FL Sub Practica';
            flSubPracticeSubField.Spanish__c='FL Sub Practica';
            flSubPracticeSubField.Sort_By__c='FindlawPracticeAreaDesc';
            flSubPracticeSubField.LCRM_Sort_By__c='FL_PRACTICE_DESC';
            listofSubscriptionSortByField.add(flSubPracticeSubField);
            
            SubscriptionSortByField__c lapsedDateSubField = new SubscriptionSortByField__c();
            lapsedDateSubField.Name='Lapsed Date';
            lapsedDateSubField.Portuguese__c = 'Data de inativação';
            lapsedDateSubField.Spanish__c='Fecha Inactivación';
            lapsedDateSubField.Sort_By__c='LapsedDate';
            lapsedDateSubField.LCRM_Sort_By__c='LPS_DATE';
            listofSubscriptionSortByField.add(lapsedDateSubField);
            
            
            SubscriptionSortByField__c materialDestSubField = new SubscriptionSortByField__c();
            materialDestSubField.Name='Material Description';
            materialDestSubField.Portuguese__c = 'Descrição do Material';
            materialDestSubField.Spanish__c='Descripción Material';
            materialDestSubField.Sort_By__c='MaterialDesc';
            materialDestSubField.LCRM_Sort_By__c='MATERIAL_DESC';
            listofSubscriptionSortByField.add(materialDestSubField);
            
            SubscriptionSortByField__c materialNumberSubField = new SubscriptionSortByField__c();
            materialNumberSubField.Name='Material Number';
            materialNumberSubField.Portuguese__c = 'Número de Material';
            materialNumberSubField.Spanish__c='Número de Material';
            materialNumberSubField.Sort_By__c='MaterialNumber';
            materialNumberSubField.LCRM_Sort_By__c='MATERIAL_NUMBER';
            listofSubscriptionSortByField.add(materialNumberSubField);
            
            SubscriptionSortByField__c monthlyChargeSubField = new SubscriptionSortByField__c();
            monthlyChargeSubField.Name='Monthly Charge';
            monthlyChargeSubField.Portuguese__c = 'Carga Mensal';
            monthlyChargeSubField.Spanish__c='Cargo Mensual';
            monthlyChargeSubField.Sort_By__c='MonthlyCharge';
            monthlyChargeSubField.LCRM_Sort_By__c='MONTHLY_CHARGE';
            listofSubscriptionSortByField.add(monthlyChargeSubField);
            
            SubscriptionSortByField__c productTitleSubField = new SubscriptionSortByField__c();
            productTitleSubField.Name='Product Title';
            productTitleSubField.Portuguese__c = 'Nome do Produto';
            productTitleSubField.Spanish__c='Producto';
            productTitleSubField.Sort_By__c='ProductTitle';
            productTitleSubField.LCRM_Sort_By__c='PRODUCT_TITLE';
            listofSubscriptionSortByField.add(productTitleSubField);
            
            SubscriptionSortByField__c quantitySubField = new SubscriptionSortByField__c();
            quantitySubField.Name='Quantity';
            quantitySubField.Portuguese__c = 'Quantidade';
            quantitySubField.Spanish__c='Cantidad';
            quantitySubField.Sort_By__c='Quantity';
            quantitySubField.LCRM_Sort_By__c='QUANTITY';
            listofSubscriptionSortByField.add(quantitySubField);
            
            SubscriptionSortByField__c statusSubField = new SubscriptionSortByField__c();
            statusSubField.Name='Status';
            statusSubField.Portuguese__c = 'Status';
            statusSubField.Spanish__c='Estado';
            statusSubField.Sort_By__c='SubscriptionStatus';
            statusSubField.LCRM_Sort_By__c='SUB_STATUS';
            listofSubscriptionSortByField.add(statusSubField);
            
            if(listofSubscriptionSortByField.size()>0){
                insert listofSubscriptionSortByField;
            } */
            //End
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.sSelectedOption ='Print';
            oSubscription.displayLCRMSubcriptioninfo();
            oSubscription.getSubscriptionListOptions();
            //List<selectOption> options =  
           // oSubscription.sortSubscriptionByfield();
            oSubscription.getSortByOrder();
            oSubscription.nextPage();
            oSubscription.updatePage();
            oSubscription.previousPage();
            Test.stopTest();
        } 
    }
    //
    /** 
    * @description User Creation
    * @return User Sobject
    */ 
    public static User getTestUserexp(){
        
        User testUserexp = new User(
            Alias = 'EUser', 
            Email='ExceptionTest@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='GLI', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'West',
            Sub_Bu__c='Usl',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='ExceptionTest@testorg.com'
        );
        insert testUserexp;
		KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
		testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
		testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
		insert testLcrmSUBBU;
        return testUserexp;
    }
    
    /** 
    * @description Get SSD list
    * @return SSD List
    * @param accRecord account record 
    * @param testUserexp user Sobject
    */ 
    public static List < Source_System_Detail__c > getListOfSSD(Account accRecord, User testUserexp){
        final String strSalesOrgVal='West';
        List < Source_System_Detail__c > listOfSSD = new List < Source_System_Detail__c > ();
        Source_System_Detail__c ssdWithSAPNo = new Source_System_Detail__c();
        ssdWithSAPNo.name = 'SSD_01';
        ssdWithSAPNo.Source_System_Account_Number__c = '3421';
        ssdWithSAPNo.Account_Name__c = accRecord.id;
        ssdWithSAPNo.Source_System_Name__c = 'LCRMGLI';
        ssdWithSAPNo.LCRM_Sales_Org__c = strSalesOrgVal;
        ssdWithSAPNo.LCRM_Sub_BU__c = testUserexp.Sub_Bu__c;
        listOfSSD.add(ssdWithSAPNo);
        
        Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
        ssdWithSalesOrg.name = 'SSD_02';
        ssdWithSalesOrg.Source_System_Account_Number__c = '456';
        ssdWithSalesOrg.Account_Name__c = accRecord.id;
        ssdWithSalesOrg.Source_System_Name__c = 'LCRMGLISSD';
        ssdWithSalesOrg.LCRM_Sales_Org__c =strSalesOrgVal; 
        ssdWithSalesOrg.LCRM_Sub_BU__c = testUserexp.Sub_Bu__c;
        listOfSSD.add(ssdWithSalesOrg);
		
		KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
		testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
		testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
		insert testLcrmSUBBU;
        
        if (listOfSSD.size() > 0) {
            insert listOfSSD;
        }
        return listOfSSD;
    }
    
    /** 
    * @description Webservice Setting
    * @return Webservice setting
    */ 
    public static List < WebServiceSettings__c > getLstofSubscriptionWebServ(){
        List < WebServiceSettings__c > lstofSubscriptionWebServ = new List < WebServiceSettings__c > ();
        WebServiceSettings__c subscriptionWebService = new WebServiceSettings__c();
        subscriptionWebService.name = 'LCRMSubscriptionServices';
        subscriptionWebService.Active__c = true;
        subscriptionWebService.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount';
        subscriptionWebService.Password__c = 'Gliu$er123';
        subscriptionWebService.Service_Unavailable_Message__c = 'GLI Subscription Services is not available';
        subscriptionWebService.Timeout__c = 120;
        subscriptionWebService.Username__c = 'gliuser';
        lstofSubscriptionWebServ.add(subscriptionWebService);
        KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
		testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
		testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
		insert testLcrmSUBBU;
        if (lstofSubscriptionWebServ.size() > 0) {
            insert lstofSubscriptionWebServ;
        }
        return lstofSubscriptionWebServ;
    }
    
    /** 
    * @description Exception
    * @return Exception Handling
    */ 
    public static List<LCRM_Exception_Handling__c> getExceptionlist(){
        //LCRM_Exception_Handling__c
        List<LCRM_Exception_Handling__c> exceptionlist = new List<LCRM_Exception_Handling__c>();
        LCRM_Exception_Handling__c exceptionwebservice = new LCRM_Exception_Handling__c();
        exceptionwebservice.name='1';
        exceptionwebservice.Status_Code__c='400';
        exceptionwebservice.Status_Description__c='No Data Found.Please Check the Inputs';
        exceptionwebservice.Status_Reason__c='Business fault. When there is no data retrieved from EDW';
        exceptionwebservice.UI_Error_Message_English__c='There is no matched data retrieved from EDW';
        exceptionwebservice.UI_Error_Message_Portuguese__c='';
        exceptionwebservice.UI_Error_Message_Spanish__c='';
        exceptionwebservice.Webservice_Name__c='Subscription';
        exceptionwebservice.Webservice_type__c='Rest';
        exceptionwebservice.Destination_System__c='EDW';
        exceptionlist.add(exceptionwebservice);
        
        LCRM_Exception_Handling__c serverRelatedexp = new LCRM_Exception_Handling__c();
        serverRelatedexp.name='2';
        serverRelatedexp.Status_Code__c='500';
        serverRelatedexp.Status_Description__c='Internal Server Error';
        serverRelatedexp.Status_Reason__c='Server Fault - When target system is down. All Server related issues will have 500 Status code';
        serverRelatedexp.UI_Error_Message_English__c='EDW server is down.';
        serverRelatedexp.UI_Error_Message_Portuguese__c='';
        serverRelatedexp.UI_Error_Message_Spanish__c='';
        serverRelatedexp.Webservice_Name__c='Subscription';
        serverRelatedexp.Webservice_type__c='Rest';
        serverRelatedexp.Destination_System__c='EDW';
        exceptionlist.add(serverRelatedexp);
        if(Exceptionlist.size()>0){
            insert exceptionlist;               
        }
		KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
		testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
		testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
		insert testLcrmSUBBU;
        return exceptionlist;
    }
    
    /** 
    * @description Subscription Types
    * @return Get Subscription List Type
    */ 
    public static List<SubscriptionTypes__c> getListofSubscriptionTypes(){
        List<SubscriptionTypes__c> listofSubscriptionTypes = new List<SubscriptionTypes__c>();
            
            SubscriptionTypes__c atciveSubscriptiontype = new SubscriptionTypes__c();
            atciveSubscriptiontype.name='All Active';
            atciveSubscriptiontype.Portuguese__c='Todas Ativas';
            atciveSubscriptiontype.Spanish__c='Todas Activas';
            listofSubscriptionTypes.add(atciveSubscriptiontype);
            
            SubscriptionTypes__c lapsedSubscriptiontype = new SubscriptionTypes__c();
            lapsedSubscriptiontype.name='All Lapsed';
            lapsedSubscriptiontype.Portuguese__c='Todas Inativas';
            lapsedSubscriptiontype.Spanish__c='Todas Inactivas';
            listofSubscriptionTypes.add(lapsedSubscriptiontype);
            
            SubscriptionTypes__c findlawSubscriptiontype = new SubscriptionTypes__c();
            findlawSubscriptiontype.name='FindLaw';
            findlawSubscriptiontype.Portuguese__c='FindLaw';
            findlawSubscriptiontype.Spanish__c='FindLaw';
            listofSubscriptionTypes.add(findlawSubscriptiontype);
            
            SubscriptionTypes__c onlineSubscriptiontype = new SubscriptionTypes__c();
            onlineSubscriptiontype.name='Online';
            onlineSubscriptiontype.Portuguese__c='Online';
            onlineSubscriptiontype.Spanish__c='Online';
            listofSubscriptionTypes.add(onlineSubscriptiontype);
            
            SubscriptionTypes__c printSubscriptiontype = new SubscriptionTypes__c();
            printSubscriptiontype.name='Print';
            printSubscriptiontype.Portuguese__c='Impresso';
            printSubscriptiontype.Spanish__c='Impreso';
            listofSubscriptionTypes.add(printSubscriptiontype);
            
            SubscriptionTypes__c wpdSubscriptiontype = new SubscriptionTypes__c();
            wpdSubscriptiontype.name='WPD';
            wpdSubscriptiontype.Portuguese__c='WPD';
            wpdSubscriptiontype.Spanish__c='WPD';
            listofSubscriptionTypes.add(wpdSubscriptiontype);
            
            if(listofSubscriptionTypes.size()>0){
                insert listofSubscriptionTypes;
            }
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            return listofSubscriptionTypes;
    }
    
    /** 
    * @description Get Sort Orger Lsit
    * @return Sort Order
    */ 
    public static List<Sort_Order__c> getListOfSortOrder(){
        List<Sort_Order__c> listOfSortOrder = new List<Sort_Order__c>();
            
            Sort_Order__c ascSortOder = new Sort_Order__c();
            ascSortOder.Name='ASC';
            ascSortOder.English__c = 'Ascending';
            ascSortOder.LCRM_Sort_Order__c='ascending';
            ascSortOder.Portuguese__c='Ascendente';
            ascSortOder.Spanish__c='Ascendente';
            listOfSortOrder.add(ascSortOder);
            
            Sort_Order__c descSortOder = new Sort_Order__c();
            descSortOder.Name='DESC';
            descSortOder.English__c='Descending';
            descSortOder.LCRM_Sort_Order__c='descending';
            descSortOder.Portuguese__c='Descendente';
            descSortOder.Spanish__c='Descendente';
            listOfSortOrder.add(descSortOder);
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            if(listOfSortOrder.size()>0){
                insert listOfSortOrder;
            }
        return listOfSortOrder;
    }
    
    /** 
    * @description Get Subscription Sort By Field
    * @return Sort B List
    */ 
    public static List<SubscriptionSortByField__c> getListofSubscriptionSortByField(){
        List<SubscriptionSortByField__c> listofSubscriptionSortByField = new List<SubscriptionSortByField__c>();
            SubscriptionSortByField__c bandedAttorneyCountSubField = new SubscriptionSortByField__c();
            bandedAttorneyCountSubField.Name='Banded Attorney Count';
            bandedAttorneyCountSubField.LCRM_Sort_By__c='BANDED_ATRNY_CNT';
            bandedAttorneyCountSubField.Portuguese__c = 'Banded Attorney Count';
            bandedAttorneyCountSubField.Sort_By__c='BandedAttorneyCount ';
            bandedAttorneyCountSubField.Spanish__c='Banded Attorney Count';
            listofSubscriptionSortByField.add(bandedAttorneyCountSubField);
            
            SubscriptionSortByField__c bandedRetailRateSubField = new SubscriptionSortByField__c();
            bandedRetailRateSubField.Name='Banded Retail Rate';
            bandedRetailRateSubField.Portuguese__c = 'Banded Retail Rate';
            bandedRetailRateSubField.Spanish__c='Banded Retail Rate';
            bandedRetailRateSubField.Sort_By__c='BandedRetailRate';
            bandedRetailRateSubField.LCRM_Sort_By__c='BAND_RETAIL_AMT';
            listofSubscriptionSortByField.add(bandedRetailRateSubField);
            
            
            SubscriptionSortByField__c contractTypeSubField = new SubscriptionSortByField__c();
            contractTypeSubField.Name= 'Contract Description';
            contractTypeSubField.Portuguese__c = 'Descrição do Contrato';
            contractTypeSubField.Spanish__c='Descripción Contrato';
            contractTypeSubField.Sort_By__c='ContractType';
            contractTypeSubField.LCRM_Sort_By__c='CONTRACT_TYPE';
            listofSubscriptionSortByField.add(contractTypeSubField);
            
            SubscriptionSortByField__c contractEndDtSubField = new SubscriptionSortByField__c();
            contractEndDtSubField.Name='Contract End Date';
            contractEndDtSubField.Portuguese__c = 'Data de término do Contrato';
            contractEndDtSubField.Spanish__c='Fecha Final Contrato';
            contractEndDtSubField.Sort_By__c='ContractEndDt';
            contractEndDtSubField.LCRM_Sort_By__c='CONTRACT_END';
            listofSubscriptionSortByField.add(contractEndDtSubField);
            
            SubscriptionSortByField__c contractStartDtSubField = new SubscriptionSortByField__c();
            contractStartDtSubField.Name = 'Contract Start Date';
            contractStartDtSubField.Portuguese__c = 'Data de início do Contrato';
            contractStartDtSubField.Spanish__c='Fecha Inicio Contrato';
            contractStartDtSubField.Sort_By__c='ContractStartDt';
            contractStartDtSubField.LCRM_Sort_By__c='CONTRACT_START';
            listofSubscriptionSortByField.add(contractStartDtSubField);
            
            SubscriptionSortByField__c detailsSubField = new SubscriptionSortByField__c();
            detailsSubField.Name= 'Details';
            detailsSubField.Portuguese__c = 'Detalhes';
            detailsSubField.Spanish__c='Detalles';
            detailsSubField.Sort_By__c='ProgramDiscountDesc';
            detailsSubField.LCRM_Sort_By__c='DISC_PROG_DESC';
            listofSubscriptionSortByField.add(detailsSubField);
            
            SubscriptionSortByField__c estimatedUnitSubField = new SubscriptionSortByField__c();
            estimatedUnitSubField.Name='Estimated Unit Upkeep';
            estimatedUnitSubField.Portuguese__c = 'Unidade estimada de manutenção';
            estimatedUnitSubField.Spanish__c='Unidad Estimada Mantenimiento';
            estimatedUnitSubField.Sort_By__c='EstimatedUnitUpKeep';
            estimatedUnitSubField.LCRM_Sort_By__c='EST_UPKEEP';
            listofSubscriptionSortByField.add(estimatedUnitSubField);
            
            
            SubscriptionSortByField__c  flLocationSubField = new SubscriptionSortByField__c();
            flLocationSubField.Name='FL Sub Location';
            flLocationSubField.Portuguese__c = 'FL Sub Localização';
            flLocationSubField.Spanish__c='FL Sub Locación';
            flLocationSubField.Sort_By__c='FindlawLocationDesc';
            flLocationSubField.LCRM_Sort_By__c='FL_LOCATION_DESC';
            listofSubscriptionSortByField.add(flLocationSubField);
            
            SubscriptionSortByField__c flSubPracticeSubField = new SubscriptionSortByField__c();
            flSubPracticeSubField.Name='FL Sub Practice';
            flSubPracticeSubField.Portuguese__c = 'FL Sub Practica';
            flSubPracticeSubField.Spanish__c='FL Sub Practica';
            flSubPracticeSubField.Sort_By__c='FindlawPracticeAreaDesc';
            flSubPracticeSubField.LCRM_Sort_By__c='FL_PRACTICE_DESC';
            listofSubscriptionSortByField.add(flSubPracticeSubField);
            
            SubscriptionSortByField__c lapsedDateSubField = new SubscriptionSortByField__c();
            lapsedDateSubField.Name='Lapsed Date';
            lapsedDateSubField.Portuguese__c = 'Data de inativação';
            lapsedDateSubField.Spanish__c='Fecha Inactivación';
            lapsedDateSubField.Sort_By__c='LapsedDate';
            lapsedDateSubField.LCRM_Sort_By__c='LPS_DATE';
            listofSubscriptionSortByField.add(lapsedDateSubField);
            
            
            SubscriptionSortByField__c materialDestSubField = new SubscriptionSortByField__c();
            materialDestSubField.Name='Material Description';
            materialDestSubField.Portuguese__c = 'Descrição do Material';
            materialDestSubField.Spanish__c='Descripción Material';
            materialDestSubField.Sort_By__c='MaterialDesc';
            materialDestSubField.LCRM_Sort_By__c='MATERIAL_DESC';
            listofSubscriptionSortByField.add(materialDestSubField);
            
            SubscriptionSortByField__c materialNumberSubField = new SubscriptionSortByField__c();
            materialNumberSubField.Name='Material Number';
            materialNumberSubField.Portuguese__c = 'Número de Material';
            materialNumberSubField.Spanish__c='Número de Material';
            materialNumberSubField.Sort_By__c='MaterialNumber';
            materialNumberSubField.LCRM_Sort_By__c='MATERIAL_NUMBER';
            listofSubscriptionSortByField.add(materialNumberSubField);
            
            SubscriptionSortByField__c monthlyChargeSubField = new SubscriptionSortByField__c();
            monthlyChargeSubField.Name='Monthly Charge';
            monthlyChargeSubField.Portuguese__c = 'Carga Mensal';
            monthlyChargeSubField.Spanish__c='Cargo Mensual';
            monthlyChargeSubField.Sort_By__c='MonthlyCharge';
            monthlyChargeSubField.LCRM_Sort_By__c='MONTHLY_CHARGE';
            listofSubscriptionSortByField.add(monthlyChargeSubField);
            
            SubscriptionSortByField__c productTitleSubField = new SubscriptionSortByField__c();
            productTitleSubField.Name='Product Title';
            productTitleSubField.Portuguese__c = 'Nome do Produto';
            productTitleSubField.Spanish__c='Producto';
            productTitleSubField.Sort_By__c='ProductTitle';
            productTitleSubField.LCRM_Sort_By__c='PRODUCT_TITLE';
            listofSubscriptionSortByField.add(productTitleSubField);
            
            SubscriptionSortByField__c quantitySubField = new SubscriptionSortByField__c();
            quantitySubField.Name='Quantity';
            quantitySubField.Portuguese__c = 'Quantidade';
            quantitySubField.Spanish__c='Cantidad';
            quantitySubField.Sort_By__c='Quantity';
            quantitySubField.LCRM_Sort_By__c='QUANTITY';
            listofSubscriptionSortByField.add(quantitySubField);
            
            SubscriptionSortByField__c statusSubField = new SubscriptionSortByField__c();
            statusSubField.Name='Status';
            statusSubField.Portuguese__c = 'Status';
            statusSubField.Spanish__c='Estado';
            statusSubField.Sort_By__c='SubscriptionStatus';
            statusSubField.LCRM_Sort_By__c='SUB_STATUS';
            listofSubscriptionSortByField.add(statusSubField);
            
            if(listofSubscriptionSortByField.size()>0){
                insert listofSubscriptionSortByField;
            }           
        return listofSubscriptionSortByField;

    }
    @isTest static void testSubscriptionforException() {
        
        User testUserexp = getTestUserexp();
        System.assert(testUserexp!= null, true);
        System.runAs(testUserexp) {
            
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            //final String strSalesOrgVal='West';
            
            //List < Source_System_Detail__c > listOfSSD =
            getListOfSSD(accRecord, testUserexp);           
            
            //List < WebServiceSettings__c > lstofSubscriptionWebServ =
            getLstofSubscriptionWebServ();
            
            //List<LCRM_Exception_Handling__c> exceptionlist = 
            getExceptionlist();
            
            //List<SubscriptionTypes__c> listofSubscriptionTypes =
            getListofSubscriptionTypes();
            //Values for View Picklist
            //Sort picklist Values
            
            List<Sort_Order__c> listOfSortOrder = getListOfSortOrder();
             System.assert(listOfSortOrder!= null, true);
            //Picklist value for Sort field by
            List<SubscriptionSortByField__c> listofSubscriptionSortByField =getListofSubscriptionSortByField();
               System.assert(listofSubscriptionSortByField != null, true);         //End
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionException');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.sSelectedOption ='FindLaw';
            oSubscription.displayLCRMSubcriptioninfo();
            oSubscription.getSubscriptionListOptions();
            //List<selectOption> options =  
            //oSubscription.sortSubscriptionByfield();
            oSubscription.getSortByOrder();
            Test.stopTest();
        } 
    }
    
    //
    @isTest static void testLCRMSubscriptionNoSSD() {
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {  
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;        
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;     
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.sSelectedOption ='ALL Lapsed';
            oSubscription.displayLCRMSubcriptioninfo();
            //
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req); 
            System.assertEquals(200,res.getStatusCode(),'200 status code');
            System.assertEquals('application/json', res.getHeader('Content-Type'),'Content Type JSOn');             
            Test.stopTest();
        } 
        
    }
    
    @isTest static void testLCRMSubscriptionNoSubBU() {
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {          
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;     
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.sSelectedOption ='WPD';
            oSubscription.displayLCRMSubcriptioninfo();
            //
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req); 
            System.assertEquals(200,res.getStatusCode(),'200 status code');
            System.assertEquals('application/json', res.getHeader('Content-Type'),'Content Type JSOn');             
            Test.stopTest();
        } 
        
    }
    
    @isTest static void testLCRMSubscriptionEliteSubBU() {
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c ='UK',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {          
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;     
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetLCRMSubscriptionResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController = new ApexPages.StandardController(accRecord);
            LCRMsubscriptionController oSubscription = new LCRMsubscriptionController(oStandardController);
            oSubscription.sSelectedOption ='WPD';
            oSubscription.displayLCRMSubcriptioninfo();
            //
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://esi-dev.thomsonreuters.com/osb/SubscriptionService/SubscriptionsService_Rest/getSubscriptionsByAccount');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req); 
            System.assertEquals(200,res.getStatusCode(),'200 status code');
            System.assertEquals('application/json', res.getHeader('Content-Type'),'Content Type JSOn');             
            Test.stopTest();
        } 
        
    }
    
    //
    
    static testMethod void testSelectedSubsOption(){
        
        
        Profile testProfile = [SELECT Id 
                               FROM profile
                               WHERE Name = 'System Administrator' 
                               LIMIT 1];
        
        User testUser = new User(LastName = 'test user 1', 
                                 Username = 'test.user.1@example.com', 
                                 Email = 'test.1@example.com', 
                                 Alias = 'testu1', 
                                 TimeZoneSidKey = 'GMT', 
                                 LocaleSidKey = 'en_GB', 
                                 EmailEncodingKey = 'ISO-8859-1', 
                                 ProfileId = testProfile.Id, 
                                 LanguageLocaleKey = 'pt_BR');   
        System.assert(testUser != null, true);   
        System.runas(testUser)
        {
				
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            Account testAcc1 = UnitTest.getAccountInstance();
            ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
            Test.setCurrentPageReference(Page.subscriptions);  
            LCRMsubscriptionController controller = new LCRMsubscriptionController(sc); 
            
            controller.sSelectedOption = 'All Lapsed';
            controller.displayLCRMSubcriptioninfo();
            
            controller.sSelectedOption = 'All Active';
            controller.displayLCRMSubcriptioninfo();
            
            controller.sSelectedOption = 'Online';
            controller.displayLCRMSubcriptioninfo();
            
            controller.sSelectedOption = 'FindLaw';
            controller.displayLCRMSubcriptioninfo();
            
            controller.sSelectedOption = 'Print';
            controller.displayLCRMSubcriptioninfo();
            
            controller.sSelectedOption = 'WPD';
            controller.displayLCRMSubcriptioninfo();
            
        }
        User testUser1 = new User(LastName = 'test user 1', 
                                  Username = 'test.user.11@example.com', 
                                  Email = 'test.1@example.com', 
                                  Alias = 'testu1', 
                                  TimeZoneSidKey = 'GMT', 
                                  LocaleSidKey = 'en_GB', 
                                  EmailEncodingKey = 'ISO-8859-1', 
                                  ProfileId = testProfile.Id, 
                                  LanguageLocaleKey = 'es');   
        System.runas(testUser1)
        {
			KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
			testLcrmSUBBU.Name = 'LCRMOrderSubscriptionUserSubBU';
			testLcrmSUBBU.TextValue__c = 'US,USL,LMS,FindLaw';
			insert testLcrmSUBBU;
            Account testAcc2 = UnitTest.getAccountInstance();
            ApexPages.standardController sc = new ApexPages.standardController(testAcc2);
            Test.setCurrentPageReference(Page.subscriptions);  
            LCRMsubscriptionController controller1 = new LCRMsubscriptionController(sc); 
            
            controller1.sSelectedOption = 'All Lapsed';
            controller1.displayLCRMSubcriptioninfo();
            
            controller1.sSelectedOption = 'All Active';
            controller1.displayLCRMSubcriptioninfo();
            
            controller1.sSelectedOption = 'Online';
            controller1.displayLCRMSubcriptioninfo();
            
            controller1.sSelectedOption = 'FindLaw';
            controller1.displayLCRMSubcriptioninfo();
            
            controller1.sSelectedOption = 'Print';
            controller1.displayLCRMSubcriptioninfo();
            
            controller1.sSelectedOption = 'WPD';
            controller1.displayLCRMSubcriptioninfo();
            controller1.getSubscriptionListOptions();
            
            
        }
        
        
    }
    
}