@isTest
private class Buttonerrormsgtest
{
  
  
  static testMethod void Buttonerrormsg()
  {   Account oAccount = new Account(Name='Pathra Test', SAPAccountNumber__c ='11334455', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();

        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='ReasonWithCompetitor';
        keyvaluestore1.TextValue__c='Content';
        insert keyvaluestore1;
        
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

         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=oAccount.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=oAccount;
        insert oppty;

        Apttus_Proposal__Proposal__c p = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert p;
      
        Contact oContact = new Contact(FirstName='S',LastName='Pathra',Account=oAccount);
        insert oContact;
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        //Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test', APTS_PaymentGateway_URL__c='',Apttus_Proposal__Account__c = oAccount.Id,APTS_Payment_Option__c = 'Credit Card',APTS_Order_Confirmation_Contact__r=oContact);
        //insert oProposal; 
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=p.Id);
        insert order;
      Buttonerrormsg buttId = new Buttonerrormsg();
      Buttonerrormsg.PermissiontoButton(p.Id);
  }
}