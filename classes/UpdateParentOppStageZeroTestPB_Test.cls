/*
 Process Builder Test Class: Update Parent Opp stage to 0%
*/
@isTest
public class UpdateParentOppStageZeroTestPB_Test
{
    public static testmethod void createCaseTest(){
    
    List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
    new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
    new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
    insert keyvaluestore;


    RecordtypeIds__c recT= new RecordtypeIds__c();
    recT.name= 'Pre-Pipeline Opportunities';
    recT.recTypeId__C = '012a0000001ZJxn';        
    insert recT;

    RecordtypeIds__c recT1= new RecordtypeIds__c();
    recT1.Name= 'Pipeline Opportunities';
    recT1.recTypeId__C = '012a0000001ZJxn';
    insert recT1;

    RecordtypeIds__c recT2= new RecordtypeIds__c();
    recT2.Name= 'LATAM Renewal Opportunity';
    recT2.recTypeId__C = '012a0000001ZJxn';
    insert recT2;        

    RecordtypeIds__c orecordType4 = new RecordtypeIds__c ();
    orecordType4.name ='Customer';
    orecordType4.recTypeId__c = '01230000001MA4a';
    insert orecordType4;

    Id pricebookId = Test.getStandardPricebookId();

    Pricebook2 pb = new Pricebook2();
    pb.IsActive =true;
    pb.Name ='Price Book';
    insert pb;

    Product2 pr = new Product2();
    pr.Name ='Product';
    insert pr;

    PricebookEntry spe = new PricebookEntry ();
    spe.IsActive=true;
    spe.Pricebook2Id=pricebookId;
    spe.Product2Id=pr.Id;
    spe.UnitPrice =0;
    insert spe;            

    PricebookEntry pe = new PricebookEntry ();
    pe.IsActive=true;
    pe.Pricebook2Id=pb.Id;
    pe.Product2Id=pr.Id;
    pe.UnitPrice =10;
    insert pe;        

    //system.runAs(u1){
    Account testAcc = new Account();
    testAcc = UnitTest.getAccountInstance();
    testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
    testAcc.SAPAccountNumber__c = '1004879124';       
    insert testAcc;  

    Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
    testcontact.LastName = 'testContact';
    testcontact.FirstName = 'testContact';
    testcontact.AccountId = testAcc.Id;
    testcontact.email = 'testfirst.testlast@thomson.com';
    testcontact.Work_Direct__c= '1234567891';
    insert testcontact;    

    Opportunity testOpp1 = UnitTest.getOpportunityInstance(testacc.Id);
    testOpp1.Renewal_Flag__c = true;
    testOpp1.Selling_Organization__c = 'LRA';
    testopp1.Pricebook2Id = pb.Id;
    //testopp1.Pricebook2Id = Test.getStandardPricebookId();
    testopp1.stageName= '90%';
    testopp1.is_Master_Opportunity__c = true;
    testopp1.CurrencyIsoCode='USD';
    insert testOpp1;

    OpportunityLineItem oli = new OpportunityLineItem();
    oli.OpportunityId = testOpp1.Id;
    oli.Quantity = 1;
    oli.List_Price__c = 100;
    oli.PricebookEntryId =pe.Id;
    oli.MOLI_id__c='1111';
    insert oli;

    Opportunity testOpp2 = UnitTest.getOpportunityInstance(testacc.Id);
    testOpp2.Renewal_Flag__c = true;
    testOpp2.Selling_Organization__c = 'LRA';
    testopp1.Pricebook2Id = pb.Id;
    //testopp1.Pricebook2Id = Test.getStandardPricebookId();
    testOpp2.stageName= '0%';
    testOpp2.Master_Opportunity__c = testOpp1.Id;
    testopp2.CurrencyIsoCode='ARS';
    insert testOpp2;            

    
}


}