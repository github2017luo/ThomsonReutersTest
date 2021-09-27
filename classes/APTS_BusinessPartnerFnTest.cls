/* APTS_BusinessPartnerFnTest
 * Test class for APTS_BusinessPartnerFunctionPage page.
 *
 * Developer: Akshay Mewada, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
   ***************************************************************************************************
   Modification Log:
   *
   *    Akshay Mewada, 10/16/2016 - Created.
   ***************************************************************************************************
*/
@isTest 
private class APTS_BusinessPartnerFnTest {
    
    @isTest static void testBusinessPartnerPage() {
        
        PageReference ref = Page.APTS_BundleGroupPage;
        Test.setCurrentPage(ref);
        
  
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Test.startTest();
        Account account = new Account();
        account.RecordTypeId=accRecordTypeId;
        account.name='test-sg';
        account.sales_org__c='ABEP';
        account.customer_group__c='Academic';
        account.customer_type__c='Organization';
        account.customer_class_c__c='Academic Lecturer';
        account.billingCity = 'Test billing city';
        account.billingState = 'Test billing state';
        account.billingPostalCode = 'PO 123456';
        insert account;
        
        Apttus_Config2__PriceList__c pl =new Apttus_Config2__PriceList__c(name='Thomson Reuters Master - US Legal', apttus_config2__active__c=true);
        insert pl;
       
     
        
       
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        //Inserting another account for Different Ssd which needs to be added to Proposal.APTS_SSD_ship_to__c
        Account acc = APTS_TestDataFactory.createAccount('Sample Account');
        insert acc;
        
         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Source_System_Account_Number__c='11111112';
        accountSSD.LCRM_SAP_Account_Number__c ='11111112';//Addded by gowthami CRM-11116 
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
       
        Source_System_Detail__c sSD=APTS_TestDataFactory.createSourceSystem(acc);
        sSD.RecordtypeId=ssdRecorType;
        sSD.Name='XYZ';
        sSD.Source_System_Name__c='XYZ';
        sSD.Account_Name__c=acc.ID;
        sSD.Account_Inactive__c=false;
        sSD.LCRM_Customer_Group__c='Academic';
        sSD.Source_System_Account_Number__c='11111112';
        sSD.LCRM_SAP_Account_Number__c ='11111112';//Addded by gowthami CRM-11116 
        sSD.LCRM_Sales_Org__c='WEST';
        insert sSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

        
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordTypeId=devRecordTypeId;
        proposal.Apttus_Proposal__Proposal_Name__c='TST-10'; 
        proposal.Apttus_Proposal__Approval_Stage__c='Draft'; 
        proposal.Apttus_Proposal__Proposal_Category__c='Quote'; 
        proposal.Apttus_Proposal__ReadyToGenerate__c = true; 
        proposal.Apttus_Proposal__ReadyToPresent__c= true; 
        proposal.Apttus_QPConfig__PriceListId__c=pl.id;
        proposal.APTS_SSD_Sold_To__c= accountSSD.ID;
        proposal.APTS_SSD_ship_to__c=sSD.ID;
        proposal.APTS_SSD_bill_to__c=sSD.ID;
        proposal.APTS_Payer__c=ssd.Id;
        insert proposal;
        
        List<Business_Partner_Function__c> bpfList=new List<Business_Partner_Function__c>();
        Business_Partner_Function__c bpf1 = new Business_Partner_Function__c();
        bpf1.Relationship_Type__c ='Bill-to party';
        bpf1.Related_Account_GLI__c=accountSSD.id;
        bpf1.Sold_To_Account_GLI__c=accountSSD.id;
        bpf1.Related_Account__c=a.id;
        bpf1.Sold_To_Account__c=a.id;
        bpfList.add(bpf1);

        Business_Partner_Function__c bpf2 = new Business_Partner_Function__c();
        bpf2.Relationship_Type__c ='Ship-to party';
        bpf2.Related_Account_GLI__c=accountSSD.id;
        bpf2.Sold_To_Account_GLI__c=accountSSD.id;
        bpf2.Related_Account__c=a.id;
        bpf2.Sold_To_Account__c=a.id;
        bpfList.add(bpf2);
        
        Business_Partner_Function__c bpf3 = new Business_Partner_Function__c();
        bpf3.Relationship_Type__c ='Payer';
        bpf3.Related_Account_GLI__c=accountSSD.id;
        bpf3.Sold_To_Account_GLI__c=accountSSD.id;
        bpf3.Related_Account__c=a.id;
        bpf3.Sold_To_Account__c=a.id;
        bpfList.add(bpf3);
        
        insert bpfList;

        ApexPages.StandardController stdController = new ApexPages.StandardController(proposal);
        ApexPages.currentPage().getParameters().put('id', proposal.ID);
        ApexPages.currentPage().getParameters().put('selectedBillTo', bpf1.ID);
        ApexPages.currentPage().getParameters().put('selectedShipTo', bpf2.ID);
        ApexPages.currentPage().getParameters().put('selectedPayer', bpf3.ID);
        
        
        APTS_BusinessPartnerFnExt extension = new APTS_BusinessPartnerFnExt(stdController);
       // ApexPages.StandardController stdController1= new ApexPages.StandardController();
        extension.cancel();
        extension.onSelectionShipTo();
        extension.onSelectionBillTo();
        extension.onSelectionPayer();
        extension.onClickResetBillTo();
        extension.onClickResetShipTo();
        extension.onClickResetPayer();
        //extension.save();
        extension.sortByName();
        extension.sortByCity();
        extension.getBPFBill();
        extension.getBPFShip();
        extension.getBPFPayer();
        extension.sortByAccNumber();
        Test.stopTest();
    }
    
   
    
}