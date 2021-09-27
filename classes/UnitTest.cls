/**
 * Provides static unit testing specific helper methods and implements a
 * singleton design pattern for web service callout testing.
 * <p>
 * The purpose of this class is to centralize the instantiation of objects
 * that are utilized by unit tests. This will allow default values to be 
 * pre-populated and maintained at a central location easing the maintenance of
 * unit test objects, which are affected by ongoing system configuration activities
 * such as the creation of validation and workflow rules.
 *
 * @author  Nick Cook
 * @version 2011-07-08
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2011-07-08   Nick Cook               Created
 * 2012-04-02   Partha                  Modified
 * 2012-06-14   John De Santiago        Removed support for bulk instance methods as they did not provide
 *                                      any significant value to testing
 * 2012-06-20   Glenda Ninan            Add mock testing for Advanced Search
 * =============================================================================
 */
public without sharing class UnitTest {
    //Protected Members
    private static UnitTest oUnitTest = new UnitTest();
    
    //Private Variables
    private Map<string, object> mapMockWebServiceResponse;
    
    //Properties
    public static Map<string, object> MockWebServiceResponse {
        get { return oUnitTest.mapMockWebServiceResponse; }
    }
    
    //Constructors
    
    /**
     * Default constructor.
     */
    private UnitTest() {
        mapMockWebServiceResponse = new Map<string, object>();        
        
        // Subscriptions
        SubscriptionsWSObject.SubItem oSubItem = new SubscriptionsWSObject.SubItem();            
        mapMockWebServiceResponse.put('SubscriptionServices',oSubItem);
        //SubscriptionsWSObject.SubLineItem oSubLineItem  = new SubscriptionsWSObject.SubLineItem();
        //mapMockWebServiceResponse.put('SubsLine',oSubLineItem);
        SubscriptionsWSObject.SubUserItem oSubUserItem  = new SubscriptionsWSObject.SubUserItem();
        mapMockWebServiceResponse.put('SubsUser',oSubUserItem );
        
        // ContactPasswords
        
       /* ContactPasswordWSObjects.AccountOnlineUser oAccountOnlineUser = new ContactPasswordWSObjects.AccountOnlineUser();
        mapMockWebServiceResponse.put('ContactPasswordsServices',oAccountOnlineUser);*/
        
        // Ixos
        IxosWSObjects.IXOSDocument oIxos = new IxosWSObjects.IXOSDocument();
        mapMockWebServiceResponse.put('IXOSServices',oIxos);
        
        // IncentivePassword
        IncentivePasswordRegistrationWS.OpenPromotion oPromo = new IncentivePasswordRegistrationWS.OpenPromotion();
        mapMockWebServiceResponse.put('IncentivePromoRegistration',oPromo );
        IncentivePasswordRegistrationWS.UserRegistration oPass = new IncentivePasswordRegistrationWS.UserRegistration();
        oPass.PromotionUser= new IncentivePasswordRegistrationWS.PromotionUser();
        oPass.IncentivePassword = new IncentivePasswordRegistrationWS.IncentivePassword();          
        mapMockWebServiceResponse.put('IncentivePasswordRegistration',oPass);

        //AdvancedSearchWS.RunSearch
        Map<String, AdvancedSearchWS.RunSearchResponse_element> RunSearch_map_x = new Map<String, AdvancedSearchWS.RunSearchResponse_element>();
        AdvancedSearchWS.RunSearchResponse_element RunSearch_x = new AdvancedSearchWS.RunSearchResponse_element();

        AdvancedSearchWS.SearchResult oResult = new AdvancedSearchWS.SearchResult();
        oResult.SelectParmName = new String[] {'Name 1','Name 2'};
        
        AdvancedSearchWS.ParmValue oParmValue = new AdvancedSearchWS.ParmValue();
        oParmValue.ParmValue = new String[] {'Name 1','Name 2','Name 3','SAP Account Number','Phone 1','Address Line 1','City','State','0','0','0','Contact Name','Zip'}; 
        AdvancedSearchWS.ParmValueRecord oParmValueRec = new AdvancedSearchWS.ParmValueRecord();
        oParmValueRec.ParmValue = oParmValue;
        List<AdvancedSearchWS.ParmValueRecord> listParmValue = new List<AdvancedSearchWS.ParmValueRecord> ();
        listParmValue.Add(oParmValueRec);
        oResult.ParmValueRecord = listParmValue;
        RunSearch_x.SearchResult = oResult;
        RunSearch_map_x.put('response_x',RunSearch_x);
        mapMockWebServiceResponse.put('AS.RunSearch',RunSearch_map_x);
        
        //AdvancedSearchWS.GetSearchParm
        Map<String, AdvancedSearchWS.GetSearchParmsResponse_element> GetSearchParm_map_x = new Map<String, AdvancedSearchWS.GetSearchParmsResponse_element>();
        AdvancedSearchWS.GetSearchParmsResponse_element GetSearchParmsResponse_x = new AdvancedSearchWS.GetSearchParmsResponse_element();
        AdvancedSearchWS.SearchParm SearchParm = New AdvancedSearchWS.SearchParm();
        SearchParm.UseInSelect = true;
        SearchParm.UseInBlock = true;
        List<AdvancedSearchWS.SearchParm> listSearchParm = new List<AdvancedSearchWS.SearchParm>();
        listSearchParm.Add(SearchParm);
        GetSearchParmsResponse_x.SearchParm = listSearchParm;           
        GetSearchParm_map_x.put('response_x',GetSearchParmsResponse_x);
        mapMockWebServiceResponse.put('AS.GetSearchParms',GetSearchParm_map_x);
        
        //AdvancedSearchWS.GetSearchParmValues
        Map<String, AdvancedSearchWS.GetSearchParmValuesResponse_element> GetSearchParmValues_map_x = new Map<String, AdvancedSearchWS.GetSearchParmValuesResponse_element>();
        AdvancedSearchWS.GetSearchParmValuesResponse_element GetSearchParmValuesResponse_x = new AdvancedSearchWS.GetSearchParmValuesResponse_element();
        AdvancedSearchWS.SearchParmItem SearchParmItem = New AdvancedSearchWS.SearchParmItem();
        SearchParmItem.ParmName = 'Name 1';
        SearchParmItem.ParmValue = new String[] {'Frank','Jasmin'};
        List<AdvancedSearchWS.SearchParmItem> listSearchParmItem = new List<AdvancedSearchWS.SearchParmItem>();
        listSearchParmItem.Add(SearchParmItem);
        GetSearchParmValuesResponse_x.SearchParmItem = listSearchParmItem;              

        GetSearchParmValues_map_x.put('response_x',GetSearchParmValuesResponse_x);
        mapMockWebServiceResponse.put('AS.GetSearchParmValues',GetSearchParmValues_map_x);
        
        ContactPasswordWSESI.OnlineUser oOnlineUser = new ContactPasswordWSESI.OnlineUser();  
        ContactPasswordWSESI.AccountOnlineUser oAccountOnlineUser  = new ContactPasswordWSESI.AccountOnlineUser();
        ContactPasswordWSESI.FederatedIdentity oFederatedIdentity = new ContactPasswordWSESI.FederatedIdentity();         
        ContactPasswordWSESI.Contact oContact = new ContactPasswordWSESI.Contact();
        ContactPasswordWSESI.PrismUser oPrismUser = new ContactPasswordWSESI.PrismUser();
        oFederatedIdentity.OnePassUserName='Test';
        oFederatedIdentity.Product='Test';
        oFederatedIdentity.RegistrationKey='Test';
        oFederatedIdentity.IsMigrated=false;
        oFederatedIdentity.IsPreferred=false;
        oFederatedIdentity.NickName='Test';
        oFederatedIdentity.LastLoginTS=String.ValueOf(System.now());
        oFederatedIdentity.Email='Test';
        
        oContact.Domain = 'Test';
        oContact.StatusDesc = 'Test';
                
        oPrismUser.PwdSecEffDt = string.valueof(System.today());
        oPrismUser.PwdSecEndDt = string.valueof(System.today());
        oPrismUser.PwdSecReasonCode = 'Test';
        
        oOnlineUser.FederatedIdentity = oFederatedIdentity ;
        oOnlineUser.Contact = oContact;
        oOnlineUser.PrismUser = oPrismUser;
        
        oAccountOnlineUser.StartRec = 1;
        oAccountOnlineUser.EndRec = 2;
        oAccountOnlineUser.TotalRecs = 2;
       // oAccountOnlineUser.OnlineUser.add(oOnlineUser);
        oAccountOnlineUser.OnlineUser = new List<ContactPasswordWSESI.OnlineUser>();
        oAccountOnlineUser.OnlineUser.add(oOnlineUser);
        
        mapMockWebServiceResponse.put('ContactPasswordsServices',oOnlineUser);
        mapMockWebServiceResponse.put('ContactPasswordsServicesAcc',oAccountOnlineUser);
        
        List<GetPaidNoteServicesWS.GetPaidNoteItem> getPaid = new List<GetPaidNoteServicesWS.GetPaidNoteItem>();
        GetPaidNoteServicesWS.GetPaidNoteItem oNoteItem = new GetPaidNoteServicesWS.GetPaidNoteItem();   
        oNoteItem.CollectorCode='TestCode';
        oNoteItem.CollectorName='TestName';
        oNoteItem.CreateDt=System.today();
        oNoteItem.ModifyDt=System.today();
        oNoteItem.Note='TestNote';
        getPaid.add(oNoteItem);
        mapMockWebServiceResponse.put('GetNotes',getPaid);
    }

    //Get Instance Methods
    
    /**
     * Static method that generates an instance of an Lead object
     * with its required field values pre-populated.
     *
     * @return  an instance of an Lead that has not been committed
     *          to the database
     */
    public static Lead getLeadInstance() {
        Lead oLead = new Lead();
        oLead.FirstName = 'Unit';
        oLead.LastName = 'Tester';
        oLead.Company = 'Unit Test Company';
        oLead.Status = 'Contacting';
        
        //Setup required mock web service requests - added to support lead conversions
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        
        MDBIntegrationUtil_Test.setupUpsertContactServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertContactSuccessResponse();
        
        return oLead;
    }
    
    /**
     * Static method that generates an instance of an Lead_Product__c object
     * with its required field values pre-populated.
     *
     * @return  an instance of an Lead_Product__c that has not been committed
     *          to the database
     */
    public static Lead_Product__c getLeadProductInstance(Id leadId, Id productId) {
        Lead_Product__c oLeadProduct = new Lead_Product__c();
        oLeadProduct.Lead__c = leadId;
        oLeadProduct.Product__c = productId;
        
        return oLeadProduct;
    }
    
    /**
     * Static method that generates an instance of an Account object
     * with its required field values pre-populated.
     *
     * @return  an instance of an Account that has not been committed
     *          to the database
     */
    public static Account getAccountInstance() {
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        //Setup required mock web service requests
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        
        return oAccount;
    }
    
    /**
     * Static method that generates an instance of a Contact object
     * with its required field values pre-populated.
     *
     * @param   accountId   the id of the master account record
     * @return  an instance of a Contact that has not been committed
     *          to the database
     */
    public static Contact getContactInstance(Id accountId) {
        Contact oContact = new Contact();
        oContact.AccountId = accountId;
        oContact.FirstName = 'Unit';
        oContact.LastName = 'Test';
        oContact.MailingStreet = '123 Unit Test';
        oContact.MailingCity = 'Dallas';
        oContact.MailingCountry ='US';
        oContact.MailingState = 'TX';
        oContact.MailingPostalCode = '75019';
        
        //Setup required mock web service requests
        MDBIntegrationUtil_Test.setupUpsertContactServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertContactSuccessResponse();
        
        return oContact;
    }

    /**
     * Static method that generates an instance of an Opportunity object
     * with its required field values pre-populated.
     *
     * @param   accountId   the id of the master account record
     * @return  an instance of an Opportunity that has not been committed
     *          to the database
     */
    public static Opportunity getOpportunityInstance(Id accountId) {
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = accountId;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = 'Prospect';
        
        return oOpportunity;
    }
    
    /**
     * Static method that generates an instance of a Product object
     * with its required field values pre-populated.
     *
     * @return  an instance of a Product that has not been committed
     *          to the database
     */
    public static Product2 getProductInstance() {
        Product2 oProduct = new Product2();
        oProduct.Name = 'Unit Test Product';
        oProduct.isActive = true;
        
        return oProduct;
    }
   
    /**
     * Static method that generates an instance of a task object
     * with its required field values pre-populated.
     *
     * @param whatId
     * @param closed to indicate open or closed task
     * @return  an instance of a task that has not been committed
     *          to the database
     */
    public static task getTaskInstance(Id whatId, boolean isClosed) {
        Task oTask = new Task();
        oTask.WhatId = whatId;
        oTask.ActivityDate = system.today();
        
        if(isClosed == true) {
            oTask.status= 'Completed';
        }
             
        return oTask;
    }

    /**
     * Static method that generates an instance of a Opportunity_Product_Type__c object
     * with its required field values pre-populated.
     *
     * @return  an instance of a Opportunity_Product_Type__c that has not been committed
     *          to the database
     */
    public static Opportunity_Product_Type__c getOpportunityProductTypeInstance(Id opportunityId) {
        Opportunity_Product_Type__c oOpportunityProductType = new Opportunity_Product_Type__c();
        oOpportunityProductType.Opportunity__c = opportunityId;
        oOpportunityProductType.Product_Category__c = 'Book';
        oOpportunityProductType.Product_Type__c = 'Add-On';
        
        return oOpportunityProductType;
    }
    
    /**
     * Static method that generates an instance of an AdvancedSearch__c object
     * with its required field values pre-populated.
     *
     * @return  an instance of an AdvancedSearch__c that has not been committed
     *          to the database
     */
    public static AdvancedSearch__c getAdvancedSearchInstance() {
        AdvancedSearch__c oAdvancedSearch = new AdvancedSearch__c();
        oAdvancedSearch.Name = 'Unit Test Search';
        
        return oAdvancedSearch;
    }
    
    /**
     * Static method that generates an instance of a AdvancedSearchDetail__c object
     * with its required field values pre-populated.
     *
     * @param   advancedSearchId   the id of the master advanced search record
     * @return  an instance of an AdvancedSearchDetail__c object that has not been committed
     *          to the database
     */
    public static AdvancedSearchDetail__c getAdvancedSearchDetailInstance(Id advancedSearchId) {
        AdvancedSearchDetail__c oAdvancedSearchDetail = new AdvancedSearchDetail__c();
        oAdvancedSearchDetail.AdvancedSearch__c = advancedSearchId;
        oAdvancedSearchDetail.Name = 'Name';
        oAdvancedSearchDetail.Operator__c = 'Equal';
        oAdvancedSearchDetail.DataType__c = 'Text';
        
        return oAdvancedSearchDetail;
    }
    /**
     * Static method that generates an instance of a Case object
     * with its required field values pre-populated.
     *
     * @return  an instance of a Case that has not been committed
     *          to the database
     */
    public static Case getCaseInstance() {
                
        Case oCase = new Case();
        oCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        oCase.CurrencyIsoCode = 'USD';
        oCase.Origin = 'Email';        
                
        return oCase;
    }
    
     /**
     * Static method that generates an instance of an User object
     * with its required field values pre-populated.
     *
     * @return  an instance of an User that has not been committed
     *          to the database
     */
    public static User getUserInstance() {
                
         Id someProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;   
        User oUser = new User();
        oUser.profileId = someProfile;
        oUSer.Username = 'TestUser@TR.com';
        oUser.LastName = 'XYZ';
        oUser.Email = 'abc@xyz.com';
        oUser.Alias = 'abctest';
        oUSer.CommunityNickname = 'CommunityNickname.testUser';
        oUSer.TimeZoneSidKey = 'America/Los_Angeles';
        oUser.LocaleSidKey = 'en_US';
        oUser.EmailEncodingKey = 'ISO-8859-1';
        oUSer.LanguageLocaleKey = 'en_US';        
                       
        return oUser;
    }
    
    /**
     * Static method that generates an instance of Training Event object
     * with its required field values pre-populated.
     *
     * @return  an instance of Training Event that has not been committed
     *          to the database
     */
    public static Training_Event__c getTrainingEventInstance() {
                
        Training_Event__c oTrainingEvent = new Training_Event__c();
        oTrainingEvent.Training_Name__c  = 'Test Training Event';
                       
        return oTrainingEvent;
    }
    
    /********************************************************************************************
    MethodName: createTestData
    Description: Method is used for creating test data.
    CreatedBy: Sushen Adhikary 
    CreatedDate: 04-Aug-2016
    LastModifiedBy: Sushen Adhikary 
    LastModifiedDate: 04-Aug-2016
    Reason for Change:
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
   
    public static void createTestData()
    {
        //  
        KeyValueListStore__c oKeyValue = new KeyValueListStore__c();
        oKeyValue.name = 'ANZUsersProfileId';       
        oKeyValue.TextValue__c = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1].Id;
        INSERT oKeyValue;
        
        //
        RecordtypeIds__c orecordType = new RecordtypeIds__c ();
        orecordType.name ='ANZ Case';        
        orecordType.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName = 'ANZ' LIMIT 1].Id; 
        INSERT orecordType;
        
        //
        RecordtypeIds__c orecordType1 = new RecordtypeIds__c ();
        orecordType1.name ='Pipeline Opportunities';       
        orecordType1.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Pipeline_Opportunity' LIMIT 1].Id; 
        INSERT orecordType1;
        
        //
        RecordtypeIds__c orecordType2 = new RecordtypeIds__c ();
        orecordType2.name ='Pre-Pipeline Opportunities';       
        orecordType2.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Pre_Pipeline_Opportunity' LIMIT 1].Id; 
        INSERT orecordType2;
        
        //
        RecordtypeIds__c orecordType3 = new RecordtypeIds__c ();
        orecordType3.name ='Prospect';        
        orecordType3.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Prospect' LIMIT 1].Id;
        INSERT orecordType3;
        
        //
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';       
        orecordType5.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'LATAM_Renewal_Opportunity' LIMIT 1].Id;
        INSERT orecordType5;
        
        //
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';        
        orecordType6.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote' AND DeveloperName = 'LATAM_Renewal_Quote' LIMIT 1].Id;
        INSERT orecordType6;
        
        //
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';        
        objPro.ProfileId__c = [SELECT Id FROM Profile WHERE Name = 'Partner Portal User' LIMIT 1].Id;
        INSERT objPro;
        
        //
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';        
        objPro1.ProfileId__c = [SELECT Id FROM Profile WHERE Name = 'LatAm User' LIMIT 1].Id;
        INSERT objPro1;
        
        //
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';        
        objPro2.ProfileId__c = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        INSERT objPro2;
        
        //
        List<BulkAccountMergeSettings__c> lstOjAccMrg = new List<BulkAccountMergeSettings__c>();
        lstOjAccMrg.add(new BulkAccountMergeSettings__c(Name = 'Fields',Value__c = 'Legacy_System_ID__c' ));
        lstOjAccMrg.add(new BulkAccountMergeSettings__c(Name = 'ToEmailAddress',Value__c = 'abc@test.com' ));        
        INSERT lstOjAccMrg;
        
    }
    
    /********************************************************************************************
    MethodName: createOptiTestData
    Description: Method is used for creating test data.
    CreatedBy: Priyanka Kar
    Fixed Defect#: S2E Optimisation
    *********************************************************************************************/
    public static void createOptiTestData(){    
        list<IXOSCodeMap__c> lstContacts=new   list<IXOSCodeMap__c>();//bulk List of custom setting object for bulk insert
        IXOSCodeMap__c csContactFields=new IXOSCodeMap__c(); //Custom Setting for Contact Fields
        csContactFields.Name='WEST';//Static record 1 of custom setting
        csContactFields.Company_Code__c='0010';
        csContactFields.Dist_Chan_Code__c='W';
        csContactFields.Division_Code__c='W';
        csContactFields.Sales_Org_Code__c='West';
        lstContacts.add(csContactFields);
        insert lstContacts;
        
        list<WebServiceSettings__c> lstWebServ = new list<WebServiceSettings__c>();
        WebServiceSettings__c oKeyValue = new WebServiceSettings__c();
        oKeyValue.name = 'ContactPasswordsESI';       
        oKeyValue.Active__c = true;
        oKeyValue.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue.Password__c = 'sfdconepass123';
        oKeyValue.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue.Timeout__c = 120;
        oKeyValue.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue);
        
        WebServiceSettings__c oKeyValue1 = new WebServiceSettings__c();
        oKeyValue1.name = 'SubscriptionServices';       
        oKeyValue1.Active__c = true;
        oKeyValue1.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue1.Password__c = 'sfdconepass123';
        oKeyValue1.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue1.Timeout__c = 120;
        oKeyValue1.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue1);
        
        WebServiceSettings__c oKeyValue2 = new WebServiceSettings__c();
        oKeyValue2.name = 'BigRuleCreateCustomer';       
        oKeyValue2.Active__c = true;
        oKeyValue2.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue2.Password__c = 'sfdconepass123';
        oKeyValue2.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue2.Timeout__c = 120;
        oKeyValue2.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue2);
        
        WebServiceSettings__c oKeyValue3 = new WebServiceSettings__c();
        oKeyValue3.name = 'DQ.CleanseAddressService';       
        oKeyValue3.Active__c = true;
        oKeyValue3.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue3.Password__c = 'sfdconepass123';
        oKeyValue3.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue3.Timeout__c = 120;
        oKeyValue3.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue3);
        
        WebServiceSettings__c oKeyValue4 = new WebServiceSettings__c();
        oKeyValue4.name = 'InvoiceServicesMISSOA';       
        oKeyValue4.Active__c = true;
        oKeyValue4.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue4.Password__c = 'sfdconepass123';
        oKeyValue4.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue4.Timeout__c = 120;
        oKeyValue4.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue4);
        
        WebServiceSettings__c oKeyValue5 = new WebServiceSettings__c();
        oKeyValue5.name = 'InvoiceServices';       
        oKeyValue5.Active__c = true;
        oKeyValue5.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue5.Password__c = 'sfdconepass123';
        oKeyValue5.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue5.Timeout__c = 120;
        oKeyValue5.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue5);
        
        WebServiceSettings__c oKeyValue6 = new WebServiceSettings__c();
        oKeyValue6.name = 'Incentive Passwords';       
        oKeyValue6.Active__c = true;
        oKeyValue6.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue6.Password__c = 'sfdconepass123';
        oKeyValue6.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue6.Timeout__c = 120;
        oKeyValue6.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue6);
        
        WebServiceSettings__c oKeyValue7 = new WebServiceSettings__c();
        oKeyValue7.name = 'RemoveRenewalRequest';       
        oKeyValue7.Active__c = true;
        oKeyValue7.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue7.Password__c = 'sfdconepass123';
        oKeyValue7.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue7.Timeout__c = 120;
        oKeyValue7.Username__c = 'Salesforce';
        lstWebServ.add(oKeyValue7);
        INSERT lstWebServ;
        
        IncentivePromoTypes__c instpro = new IncentivePromoTypes__c();
        instpro.name = 'Westlaw';       
        instpro.DomainName__c = 'abc';
        instpro.CompanyCode__c = 'WEST';
        instpro.Type__c ='21edsf';
        INSERT instpro ;  
        
        ReportLinks__c repLink = new ReportLinks__c();
        repLink.name = 'Order';       
        repLink.Link__c= 'abc';
        INSERT repLink ; 
    
        
        InvoiceDocType__c oInvDcTyp = new InvoiceDocType__c();
        oInvDcTyp.name = 'WEST';       
        oInvDcTyp.Doc_Types__c = 'abc';
        oInvDcTyp.Sales_Org__c = 'WEST';
        INSERT oInvDcTyp;
        
        List<OrderType__c> ListDisplayOrders = new List<OrderType__c>();
        OrderType__c ot = new OrderType__c();
        ot.name='New';
        ot.Spanish__c='Nuevas';
        ot.Values__c='ZNEW';
        ot.Portuguese__c='Novos';
        ListDisplayOrders.add(ot);
        
        OrderType__c ot1 = new OrderType__c();
        ot1.name='All';
        ot1.Spanish__c='Todas';
        ot1.Values__c='test';
        ot1.Portuguese__c='Todos';
        ListDisplayOrders.add(ot1);
        INSERT ListDisplayOrders;
        
         AccountTaxNumSalOrgSetting__c Acctax = new AccountTaxNumSalOrgSetting__c();
        Acctax.Name = 'LatAm User';
        Acctax.Active__c=True;
        Acctax.Sales_Org__c='LLEY';
        Acctax.Customer_Group_Exclude__c='LatAm User';
        Acctax.Sales_Org_warning__c='FSCO';
        insert Acctax; 
    }
}