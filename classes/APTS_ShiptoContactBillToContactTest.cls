/*
This test class is written to cover process builder 'APTS_Populate_Opportunity_Order_contact_and_SSD_on_quote' 

Process builder : APTS_Populate_Opportunity_Order_contact_and_SSD_on_quote
Apex class : APTS_ShiptoContactBillToContactTest

*/
@istest
public class APTS_ShiptoContactBillToContactTest{
    
    
    @isTest static void method1() {
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;     
         
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        WebServiceSettings__c oWebServiceSettings23 = new WebServiceSettings__c(
            Active__c = true,
            Name = 'Payment AutoCharge',
            Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
            Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings23 ;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype); 
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Account a = APTS_TestDataFactory.createAccount('test-sg-Namo');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Contact oContact2 = APTS_TestDataFactory.createContact('TestContact2',a.id);
        oContact2.firstname='Test2';
        oContact2.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact2;
        
        LCRM_Contact_SSD__c ContactSSD1 = new  LCRM_Contact_SSD__c();
        ContactSSD1.LCRM_Email__c= 'test1023@gmail.com';
        ContactSSD1.LCRM_Account_SSD__c = accountSSD.id;
        ContactSSd1.LCRM_Contact__c = oContact2.id;
        insert ContactSSD1;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        oppty.Ship_To_Contact__c=ContactSSD1.Id;
        oppty.Bill_To_Contact_SSD__c = ContactSSD1.Id;
        insert oppty;
        
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=true;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Existing_Database__c=true;
        proposal.APTS_Client_Database_Code__c='12345';
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;        
        insert proposal;
        Test.stopTest();
        
        
  }
    
}