@isTest
private class APTS_SegmentSelectorControllerTest {
    
    @isTest static void test_Select_Segment() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
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
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'Canada'; 
        proposal.Customer_Group__c = 'ACADEMIC';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
        APTS_Clause_Mapping_Per_Segment__c mapping = new APTS_Clause_Mapping_Per_Segment__c(APTS_Approval_Segment__c = 'Corporate Large', APTS_Applicable_Clauses__c = 'Non Avail Funds - Online; Non Avail Funds - Print');
        insert mapping;

        //Schema.DescribeFieldResult fieldResult = Apttus_Config2__ProductConfiguration__c.APTS_Clauses_Selected__c.getDescribe();
        //String value = fieldResult.getPicklistValues().get(0).getValue();
        String value = mapping.APTS_Applicable_Clauses__c;
        System.debug('value___' + value);
        //PageReference pf = new PageReference('/apex/APTS_SegmentSelectorPage?id='+prodConfig.Id); retId
        PageReference pf = new PageReference('/apex/APTS_SegmentSelectorPage?retId='+proposal.Id); 
        Test.setCurrentPage(pf);
        APTS_SegmentSelectorController segmentCtrl = new APTS_SegmentSelectorController();
        List<SelectOption> selOpts = segmentCtrl.getItems();
        segmentCtrl.applicableClauses = value;
        List<String> sval =  new List<String>();
        sval.add('CAN- Budget Reduc');
        system.debug('sval +++++' + sval);
        system.debug('segmentCtrl.selectedValues +++++' + segmentCtrl.selectedValues);
        segmentCtrl.selectedValues = new List<String>();
        segmentCtrl.selectedValues.addAll(sval);
        system.debug('segmentCtrl.selectedValues +++++11' + segmentCtrl.selectedValues);
         
        segmentCtrl.proposal.APTS_Selected_Clauses__c  = value;
        
        System.debug('segmentCtrl.proposal.APTS_Selected_Clauses__c' + segmentCtrl.proposal.APTS_Selected_Clauses__c);
        Test.startTest();
        segmentCtrl.doSave();

        //prodConfig = [SELECT APTS_Clauses_Selected__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id =: prodConfig.Id];
        //System.assertEquals(value, prodConfig.APTS_Clauses_Selected__c);

        segmentCtrl.doCancel();
        Test.stopTest();
    }
    
}