@isTest
private class APTS_DocuSignEnvelRecpStatTriggerTest {
 
  @isTest
  static void setup(){ 
       
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        System.assertequals('test',a.Name,'Success');
        
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        
        KeyValueListStore__c keyval1 = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        keyvaluestoreList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
         List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
       // Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
         
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'New',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
        Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');     
       insert oProduct;
       Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
       proposal.Apttus_Proposal__Account__c=a.id;
       proposal.APTS_SSD_Sold_To__c=accountSSD.id;
       proposal.Apttus_Proposal__Opportunity__c = opp.id;
       proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
       proposal.APTS_Existing_Database__c=true;
       proposal.APTS_Client_Database_Code__c='12345';
       proposal.Apttus_Proposal__Approval_Stage__c='Presented';
       proposal.Apttus_Proposal__Primary__c=false;

    Apttus_DocuApi__DocuSignEnvelope__c oEnvelope = DCTestData.createDocuSignEnvelope('voided', proposal.id);
    oEnvelope.Apttus_DocuApi__RecallReason__c = '';
    oEnvelope.Apttus_DocuApi__EnvelopeId__c = 'ce12dc3d-ffff-4444-aaaa-3b0494af30b9';
    insert proposal;
      insert oEnvelope; 
    
  }


  @isTest   
    static void test1()
    {   setup();
      //  Account account =  [SELECT id FROM Account WHERE Name='Test'];
    //    Apttus_Proposal__Proposal__c proposal =[SELECT id,Apttus_Proposal__Approval_Stage__c,APTS_Existing_Database__c,Apttus_Proposal__Account__c,APTS_SSD_Sold_To__c,Apttus_Proposal__Opportunity__c,APTS_Proposal_Business_Unit__c  FROM  Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__c =: account.id ];
        

        Apttus_DocuApi__DocuSignEnvelope__c docSignEnv = [SELECT Apttus_DocuApi__EnvelopeId__c,Apttus_DocuApi__Status__c 
                                                            FROM Apttus_DocuApi__DocuSignEnvelope__c 
                                                            WHERE Apttus_DocuApi__EnvelopeId__c  = 'ce12dc3d-ffff-4444-aaaa-3b0494af30b9'];
    
       List <Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c> docuSignEnvelopeRS = new List<Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c>(); 
        //Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c doc = [SELECT id,Apttus_DocuApi__Status__c FROM Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c WHERE Apttus_DocuApi__DocuSignEnvelopeId__c =: docSignEnv.Apttus_DocuApi__EnvelopeId__c];
        //doc.Apttus_DocuApi__Status__c ='Completed';
       Test.startTest();  
          Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c doc = new Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c();
          doc.Apttus_DocuApi__DocuSignEnvelopeId__c=docSignEnv.id;
          doc.Apttus_DocuApi__Email__c = 'random@random.com';
          doc.Apttus_DocuApi__Status__c ='Completed';
      // insert doc;
       docuSignEnvelopeRS.add(doc);   
     
        insert docuSignEnvelopeRS;     
       // APTS_DocuSignEnvelopeStatTriggerHandler.adminAcceptprocess(docuSignEnvelopeRS);
      //  APTS_DocuSignEnvelopeStatTriggerHandler.exclusionframework(docuSignEnvelopeRS);
      System.assertEquals('Completed',doc.Apttus_DocuApi__Status__c,'status does not match');
        Test.stopTest();                                           
    }



}