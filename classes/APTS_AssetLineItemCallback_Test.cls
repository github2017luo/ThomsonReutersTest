@isTest
public class APTS_AssetLineItemCallback_Test{

    @isTest static void testMethodOne(){
    
        Apttus_Config2__ConfigCustomClasses__c aptCc = new Apttus_Config2__ConfigCustomClasses__c();
        aptCC.Apttus_Config2__PricingCallbackClass__c = 'APTS_AssetLineItemCallback';
        aptCC.Name = 'Custom Classes';
        insert aptCC;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
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
         //Inserting account
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        insert a;
        Set<Id> accIds = new Set<Id>{a.Id};
      
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
     
     //Inserting opportunity
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

    //Inserting pricelist
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
    //Inserting proposal
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.Apttus_Proposal__Proposal_Name__c = 'TestPro';
        proposal.APTS_SSD_bill_to__c= accountSSD.Id;
        proposal.APTS_SSD_ship_to__c= accountSSD.Id;
        insert proposal;
        
        
     //Inserting Products 
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.IsActive        = true;
          prodObj.CurrencyIsoCode = 'USD';
         prodObj.APTS_Corporate_Select__c = 'Primary'; //added
          insert prodObj; 
    //Inserting price list item    
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
    
    //Inserting prodconfig list    
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
         List<String> list1 = new List<String>();         
         list1.add('');
         Date testdate = System.Date.Today();
        
        APTS_AssetLineItemCallback oAPTS_AssetLineItemCallback = new APTS_AssetLineItemCallback();
        oAPTS_AssetLineItemCallback.start(null,null,list1);
        oAPTS_AssetLineItemCallback.getAssetSearchScope();
        oAPTS_AssetLineItemCallback.getFilterExpr(null);   
        oAPTS_AssetLineItemCallback.getQueryFilter(accountSSD.id);    
        oAPTS_AssetLineItemCallback.finish();
        oAPTS_AssetLineItemCallback.validateAssetTermination(accIds,accIds,testdate);
        
    }
}