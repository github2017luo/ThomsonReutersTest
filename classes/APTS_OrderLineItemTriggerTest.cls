@isTest(seeAllData = false)
private class APTS_OrderLineItemTriggerTest {
     static testMethod void testMethod1() {
     
     LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
         
     Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        
        System.assertequals('test-sg',a.Name,'Success');
        
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
         
        //Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
       Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');     
       insert oProduct;
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
         
       Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
       proposal.Apttus_Proposal__Account__c=a.id;
       proposal.APTS_SSD_Sold_To__c=accountSSD.id;
       proposal.Apttus_Proposal__Opportunity__c = opp.id;
       proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
       proposal.APTS_Existing_Database__c=true;
       proposal.APTS_Client_Database_Code__c='12345';
       insert proposal;
        
        
        Map<id,Apttus_Config2__Order__c> ordersMap = new Map<id,Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order.Apttus_QPConfig__ProposalId__c = proposal.id;
        order.Apttus_Config2__ActivatedDate__c=null;       
        order.IDOC__c=null; 
        insert order;  
        System.debug(LoggingLevel.DEBUG,'Order @ 1'+ order.Id + order.Apttus_QPConfig__ProposalId__c + order.Apttus_Config2__Status__c + order.IDOC__c + order.APTS_SAP_Status__c);
         ordersMap.put(order.id,order);
         Apttus_Config2__Order__c order1 = [Select Name,IDOC__c,Apttus_Config2__Status__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__c,
        Apttus_QPConfig__ProposalId__r.Name,Apttus_Config2__OrderDate__c 
        from Apttus_Config2__Order__c where Id = :order.Id ];
        System.debug(LoggingLevel.DEBUG,'Order @ 2'+ order1.Id + order1.Apttus_QPConfig__ProposalId__c +  order1.Apttus_Config2__Status__c + order1.IDOC__c + order1.APTS_SAP_Status__c);
        Apttus_Config2__AssetLineItem__c asl = new Apttus_Config2__AssetLineItem__c (name='test', Apttus_Config2__AssetStatus__c= 'New');
         
        insert asl;
         
        CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
        insert family;
         

        Apttus_Config2__OrderLineItem__c oli = new Apttus_Config2__OrderLineItem__c (Apttus_Config2__LineStatus__c ='New',
                                                                                     Apttus_Config2__OrderId__c=order1.id,
                                                                                     Apttus_Config2__ProductId__c = oProduct.Id,
                                                                                      Apttus_QPConfig__ProposalId__c=proposal.Id,
                                                                                    Apttus_Config2__AssetLineItemId__c=asl.id,
                                                                                    APTS_Proposal_Business_Unit__c='Corp OneOTC US');
    
        insert oli;    
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
      attribute3.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
      attribute3.Apttus_Config2__LineItemId__c=oli.id;
      Insert attribute3;
      
      Test.startTest();
      oli.Apttus_Config2__AttributeValueId__c = attribute3.ID;
      update oli;
      Test.stopTest();
    }       
}