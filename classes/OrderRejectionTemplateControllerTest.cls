@isTest
private class OrderRejectionTemplateControllerTest {

@isTest
public static void testEmailComp()

{

     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
    
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Account testAccount = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    insert testAccount;
    
    Pricebook2 standardPriceBook = new Pricebook2(Name='Standard Price Book', isActive=true);
    insert standardPriceBook;
       
    Date todaysDate = system.today();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
    Opportunity testOpportunity = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp', stagename='5%',pricebook2Id=standardPriceBook.id, closedate=todaysDate,forecastcategoryname='Omitted',accountId=testAccount.id);
    insert testOpportunity;
    
    Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', CurrencyIsoCode='USD', Apttus_Proposal__Opportunity__c=testOpportunity.id,Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
    insert testProposal;
    
    Apttus_Config2__ProductConfiguration__c testProdConfig =new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = testProposal.id);
    insert testProdConfig;
     
    Product2 testProduct=new Product2(name='TestProduct',APTS_Inventory_Applicable__c=true);
    insert testProduct;
    
    APTS_Attribute_Value__c testAttributeValue=new APTS_Attribute_Value__c(name='Test Attribute',APTS_Product__c=testProduct.id);
    insert testAttributeValue;
    
    APTS_Attribute_Value_Combination__c testAttributeCombination=new APTS_Attribute_Value_Combination__c(name='Test Combination',APTS_Inventory_Available__c=0,APTS_Attribute_Value1__c=testAttributeValue.id,APTS_Product__c=testProduct.id);
    insert testAttributeCombination;
    
    List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    
    Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = testProdConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__LineStatus__c='New',
          APTS_Combination_Key__c=testAttributeCombination.id,
          Apttus_Proposal__Proposal__c=testProposal.id);
    lineItemList.add(pl1);
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__Quantity2__c = 2,
          Apttus_QPConfig__ConfigurationId__c = testProdConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_QPConfig__LineStatus__c ='New',
          APTS_Combination_Key__c=testAttributeCombination.id,
          Apttus_Proposal__Proposal__c=testProposal.id);
     lineItemList.add(pl2);
     insert lineItemList;
     
     test.startTest();
       
       APTS_OrderRejectionTemplateController obj=new APTS_OrderRejectionTemplateController();
       obj.quoteId=testProposal.id;
       obj.getLineItems();
       
     test.stopTest();
      
    
    
}

}