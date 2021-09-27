/* APTS_PropProdAttValTriggerTest
 * Test class for APTS_ProposalProductAttributeValueTrigger.
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
   *    Akshay Mewada, 12/01/2017 - Created.
   ***************************************************************************************************
    Modified by:Surya, APTTUS on-15/2/2018-  Rewritten APTS_PropProdAttValTriggerTest Class as a part of GLI OC
*/
@isTest
public with sharing class APTS_PropProdAttValTriggerTest {
    
    
     @testSetUp static void test_triggerEvent()
    {
        
        
        
     //Inserting the keyvalue store
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
        /*//Dynamic retrieval of Pipeline Opportunity RecordType id Using schema
        Id RecordType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();*/
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
        
     //Inserting in to account using testdatafactory
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.sales_org__c='WEST';
        insert a;
        
    //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
        
    //creating and inserting opportinity
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('Test Oppty',a.id,'10%',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

     //Inserting proposal
         Apttus_Proposal__Proposal__c testProposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         insert testProposal;
     //Inserting Product
         Product2 testProd = APTS_TestDataFactory.createProduct('TestProd','Test Family');
         insert testProd;
            
     //inserting in to custom settings object 
            List<APTS_CPRO_Material_Numbers__c> cprolist = new List<APTS_CPRO_Material_Numbers__c>();
            APTS_CPRO_Material_Numbers__c cpro= new APTS_CPRO_Material_Numbers__c(Name='CPRO Primary 17-20',Core__c ='Primary',APTS_Low_Points__c=1,APTS_High_Points__c=4);
            cprolist.add(cpro);
             APTS_CPRO_Material_Numbers__c cpro1= new APTS_CPRO_Material_Numbers__c(Name='CPRO Essentials 1-1',Core__c ='Essential',APTS_Low_Points__c=1,APTS_High_Points__c=4);
            cprolist.add(cpro1);
            APTS_CPRO_Material_Numbers__c cpro2= new APTS_CPRO_Material_Numbers__c(Name='CPRO Essentials 10-1',Core__c ='Essentials',APTS_Low_Points__c=1,APTS_High_Points__c=4);
            cprolist.add(cpro2);
            insert cprolist;
        
            
        //Creating new object for proposal line item and inserting values
            List<Apttus_Proposal__Proposal_Line_Item__c> testPropLineItem = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            /*Apttus_Proposal__Proposal_Line_Item__c appi = new Apttus_Proposal__Proposal_Line_Item__c();                                                                                                   
            appi.Apttus_Proposal__Proposal__c = testProposal.Id; 
            appi.APTS_Corporate_Select__c = 'Essential';
            appi.Apttus_Proposal__Product__c=testProd.Id;
            testPropLineItem.add(appi);*/ 
                       
            Apttus_Proposal__Proposal_Line_Item__c appi1 = new Apttus_Proposal__Proposal_Line_Item__c();                                                                                                   
            appi1.Apttus_Proposal__Proposal__c = testProposal.Id; 
            appi1.APTS_Corporate_Select__c = 'Primary';
            appi1.Apttus_Proposal__Product__c=testProd.Id;
            testPropLineItem.add(appi1); 
         
         insert testPropLineItem;
          }
              
        @isTest static void testSignatureBlock() {
          
          //retrieving account
              Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
          //retrieving opportunity
              Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='Test Oppty' LIMIT 1];
          //retrieving proposal & proposal_line_item
              Apttus_Proposal__Proposal__c testProposal=[SELECT id from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='Test Oppty' LIMIT 1];
          
          
          Apttus_Proposal__Proposal_Line_Item__c testPropLineItem =[SELECT id,name from Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c=:testProposal.id LIMIT 1];
          
          
            
            Test.startTest();
            Apttus_QPConfig__ProposalProductAttributeValue__c testpav = new Apttus_QPConfig__ProposalProductAttributeValue__c(Apttus_QPConfig__LineItemId__c=testPropLineItem.id,APTS_Total_Number_of_Points__c=3);
            insert testpav;
            
            test.stopTest();  
                
    }
}