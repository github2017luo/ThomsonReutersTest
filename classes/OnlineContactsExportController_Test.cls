@isTest(seeAllData = True)
public class OnlineContactsExportController_Test {
  
    public static testMethod void processController() {
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');       
            insert ssdAccount; 
        
        Opportunity Opp = UnitTest.getOpportunityInstance(oAccount.Id);
        Opp.source_system_detail__c = ssdAccount.Id; 
        insert Opp;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();   
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = Opp.Id);   
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = '12346789',QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',NAIC_Name__c = 'abc', NAIC_Number__c = '12345');
        insert oc1;
        PageReference pageRef = Page.OnlineContactsExport;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        OnlineContactsExportController ocec = new OnlineContactsExportController();
    }
}