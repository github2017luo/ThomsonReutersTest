@isTest
public Class APTS_ProposalDirectDebitPostBack_Test {
    public static testMethod void DirectDebitInfo() {
        
                Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id,ESC_tocLanguage__c = 'French-Canadian');
        insert cont;
        system.debug('contact '+cont);
                Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
         Source_System_Detail__c accountSSD= new Source_System_Detail__c();
         accountSSD.RecordtypeId=ssdRecorType;
         accountSSD.Name='ABC';
         accountSSD.Source_System_Name__c='ABC';
         accountSSD.Account_Name__c=acc.ID;
         accountSSD.Source_System_Account_Number__c='12312312';
         accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
         accountSSD.Account_Inactive__c=false;
         accountSSD.City__c='california';
         //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
         //accountSSD.LCRM_Industry__c='TAX';
         
          insert accountSSD;
         
      List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
        
        };
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
         Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        insert oProposal;
        APTS_ProposalDirectDebitPostBack.DirectDebitInfo oQuote = new APTS_ProposalDirectDebitPostBack.DirectDebitInfo();
        oQuote.AccountNumber = '9865650868076';
        oQuote.RoutingNumber = '9879067865';
        oQuote.BankName ='test';
        oQuote.proposalID = oProposal.Id;
        String Message = APTS_ProposalDirectDebitPostBack.getTokenInfo(oQuote); 
        //system.assertEquals(Message, 'Success');      
    }
    public static testMethod void ExceptionfetchTokenInfo() {
        APTS_ProposalDirectDebitPostBack.DirectDebitInfo oQuote = new APTS_ProposalDirectDebitPostBack.DirectDebitInfo();
        oQuote.AccountNumber = '9865650868076';
        oQuote.RoutingNumber = '9879067865';
        oQuote.BankName ='test';
        String Message = APTS_ProposalDirectDebitPostBack.getTokenInfo(oQuote);
        system.assertEquals(Message, 'Exception while updating the Proposal');       
    } 
}