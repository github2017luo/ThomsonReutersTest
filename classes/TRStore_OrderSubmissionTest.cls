@isTest(seeAllData=false)
public class TRStore_OrderSubmissionTest {
    
    public static testMethod void testData(){
        
        // insert static value
        
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePELeadConvertCode', value__c='LeadConvert'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c='OrderConfirmation'),
            new Static_Values__c(name='LeadSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com')
            };
        insert staticCSList;
        
        LTS_Disable_Application_Automation__c lts = new LTS_Disable_Application_Automation__c(LTS_Disable_Process_Builders__c=true, LTS_Disable_Validation_Rules__c=true);
         insert lts;
                
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'AND Profile.id =:p.id limit 1];
        LIST<KeyValueListStore__c> keyValueList = new LIST<KeyValueListStore__c>();
        KeyValueListStore__c kv = new KeyValueListStore__c(TextValue__c=p.id, name='ANZUsersProfileId' );
         KeyValueListStore__c kv1 = new KeyValueListStore__c(TextValue__c='Content,Functionality', name='ReasonWithCompetitor');
        keyValueList.add(kv);
        keyValueList.add(kv1);
        insert keyValueList;
        
        string rtId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        string rtId2 = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        LIST<RecordtypeIds__c> rtIds = new LIST<RecordtypeIds__c >();
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name='Pre-Pipeline Opportunities', recTypeId__c =rtId); 
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name='Pipeline Opportunities', recTypeId__c =rtId2); 
        rtIds.add(rt);
        rtIds.add(rt2);        
        insert rtIds;
        
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                
                insert WebserviceList;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';        
        pbook.IsActive = true;
        insert pbook;
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectRefId__c =propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfigObj;
        
        // insert acc
        Account acc =APTS_TestDataFactory.createAccount('Test');
        Insert acc;
        
        /*//Create AccountSSD record
Source_System_Detail__c accSSD = new Source_System_Detail__c();
accSSD.Name = 'Test Account SSD';
accSSD.Source_System_Name__c = 'Test System';
accSSD.Source_System_Account_Number__c = '173468930';
accSSD.Account_Name__c = acc.id;
//accSSD.Trial_Status__c = '';
//accSSD.LCRM_Market_Segment__c = 'SLF 4-6';
insert accSSD;*/
        
        // insert ssd
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='ON',Country__c='CA',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD;
        
        Source_System_Detail__c accountSSD1= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABCD',Source_System_Name__c='ABCD',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='ON',Country__c='CA',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD1;
        
        // insert contact
        contact con = APTS_TestDataFactory.createContact('test',acc.id);
        con.FirstName='Amy';
        insert con ;
        
        //create opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = rt.recTypeId__c;
        opp.Owner = u;
        opp.StageName='Prospect';
        opp.AccountId = acc.Id;
        opp.Pricebook2id = pbook.id ;
        opp.Source_System_Detail__c = accountSSD.Id;
        opp.ShipTo_Source_System_Detail__c = accountSSD1.id;
        insert opp;
        
        // insert lead
        lead ld = new lead();
        ld.FirstName='Amy';
        ld.Lead_region__c='TR Store Canada Print';
        ld.LastName='anto';
        ld.Email='testfirst.testfirst@test.com';        
        ld.IsConverted=true;
        ld.Company='TCS';
        ld.Product_Configuration__c=prodConfigObj.Id;
        ld.ConvertedAccountId =acc.id;
        ld.ConvertedContactId=con.id;
        ld.ConvertedOpportunityId=opp.id;
        insert ld;
        
         // insert lead
        lead ld2 = new lead();
        ld2.FirstName='Test';
        ld2.LastName='Lead';
        ld2.Email='testfirst.testlast@test.com';        
        ld2.IsConverted=true;
        ld2.Company='TCS';
        ld2.Product_Configuration__c=prodConfigObj.Id;   
        ld2.Billing_Street__c = 'Banito Blanco 822';
        ld2.Billing_City__c = 'New Yark';
        ld2.Billing_State__c = 'New yark';
        ld2.Billing_Country__c ='United States';
        ld2.Billing_Zip__c = '51123';
        ld2.TRstore_Billadd_differenceto_shipping__c = true;
        ld2.Street = 'Banito Blanco 823';
        ld2.City = 'Toronto';
        ld2.State = 'ON';
        ld2.Country ='CA';
        ld2.PostalCode = '12345';
        ld2.SAPAccountNumber__c = '';
        ld2.Is_GLI__c=true;
        ld2.ConvertedAccountId =acc.id;
        ld2.ConvertedContactId=con.id;
        ld2.ConvertedOpportunityId=opp.id;
        insert ld2;
        
         Online_Contacts__c onlineContact = new Online_Contacts__c();
                     Customer_Master_Contacts__c ms = new Customer_Master_Contacts__c();
                        
                        onlineContact.First_Name__c = 'pFirstName';
                        onlineContact.Last_Name__c = 'pLastName';
                        onlineContact.Email__c = 'pEmail@mailinator.com';
                        onlineContact.WLEc_Juris__c = 'jurisdiction';
                        onlineContact.Position__c = 'pTitle';                        
                        onlineContact.Type__c = 'pType';

                        onlineContact.Lead__c = ld.Id;
                        onlineContact.Product_Configuration__c = prodConfigObj.id; 
           
           insert       onlineContact;        
        
        Customer_Master_Contacts__c  msd = new Customer_Master_Contacts__c();
        msd.First_Name__c = 'FirstName';
                        msd.Last_Name__c = 'pLastName';
                        msd.Email_Address__c = 'pEmail@mailinator.com';
                        msd.Lead__c = ld.Id;
                        msd.Material__c = '25478';
                        
                        
                        insert msd;
       
        
        Test.startTest();
        TRStore_OrderService.TRStore_RequestClass trReq = new TRStore_OrderService.TRStore_RequestClass();
        trReq.leadId = ld.id;
        trReq.cartId = prodConfigObj.id;
        trReq.quoteId= propObj.id;
        trReq.emailID = ld.email;       
        trReq.accNumber = '';
        trReq.requestFor='OrderConfirmation';
        trReq.OrderComplete = false;


        TRStoreLeadprocess.convertLead(ld.Id, prodConfigObj.id, ld.Email, null);          
        TRStore_OrderService.getDetailsForOrderSubmission(trReq);        
        system.enqueueJob(new TRStore_OrderSubmissionQueueable(propObj.id, prodConfigObj.id, ld.id));
        
        
        TRStore_OrderService.TRStore_RequestClass trReq1 = new TRStore_OrderService.TRStore_RequestClass();
        trReq1.leadId = ld2.id;
        trReq1.cartId = prodConfigObj.id;
        trReq1.quoteId= propObj.id;
        trReq1.emailID = ld2.email;     
        trReq1.accNumber = '';
        trReq1.requestFor='OrderConfirmation';
        trReq1.OrderComplete = false;

        TRStoreLeadprocess.convertLead(ld2.Id, prodConfigObj.id, ld2.Email, null);
        
        System.assertEquals(true,ld2.isConverted);
        
        TRStore_OrderService.getDetailsForOrderSubmission(trReq1 );
        
        system.enqueueJob(new TRStore_OrderSubmissionQueueable(propObj.id, prodConfigObj.id, ld2.id));
        
       // TRStore_OrderCreateQueueable ordercreate = new TRStore_OrderCreateQueueable(propObj.id);
       // ordercreate.execute(null);
        Test.stopTest();
        
        
    }    
             
}