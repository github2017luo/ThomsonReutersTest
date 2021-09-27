@isTest
public class LCRMCancelEmailTemplateControllerTest{

    Public static testMethod Void testData(){
    
        //Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='ANZ Users'];
		Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='ANZ Users'];
        
          User testUser = new User(
          Alias = 'standt', 
          Email='abc1@testorg.com',
          EmailEncodingKey='UTF-8', 
          LastName='Testing', 
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          ProfileId = stdProfile.Id,
          TimeZoneSidKey='America/Los_Angeles',
          Sub_Bu__c ='UKI',
          Sales_Org__c = 'LRA',
          UserName='abc1@testorg.com'
        ); 
        
        System.runAs(testUser)
        {
            Account testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
            insert testcontact;
            
            
            
            KeyValueListStore__c listStore=new KeyValueListStore__c();
            listStore.Name = 'ANZUsersProfileId';
            listStore.TextValue__c = stdProfile.Id;
            insert listStore;
            
            
            RecordtypeIds__c recT= new RecordtypeIds__c();
            recT.name= 'Pre-Pipeline Opportunities';
            recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();      
            insert recT;
            
            RecordtypeIds__c recT1= new RecordtypeIds__c();
            recT1.Name= 'Pipeline Opportunities';
            recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
            insert recT1;
            
            //Map <String,Schema.RecordTypeInfo> recordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
            //Id RecTypeIdinadj = recordTypeMap.get('Pre-Pipeline Opportunities').getRecordTypeId();
            
            //OpportunityAfterEventListener opptyListener = new OpportunityAfterEventListener();
             //Set<String> setANZSalesOrg1 = new Set<String>{'LRA','BKRS'};   
            //opptyListener.setANZSalesOrg  = setANZSalesOrg1;
            
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp1.Renewal_Flag__c = true;
            testOpp1.Expected_Start_Date__c= date.Today();
            testOpp1.Expected_End_Date__c = date.Today() + 5;
            testOpp1.Expiration_Date__c = date.today() + 50;
            testOpp1.RecordTypeId = recT.recTypeId__C;
            insert testOpp1;
            
            Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp2.Renewal_Flag__c = true;
            testOpp2.Expected_Start_Date__c= null;
            testOpp2.Expected_End_Date__c = null;
            testOpp2.Expiration_Date__c = null;
            testOpp2.RecordTypeId = recT1.recTypeId__C;
            insert testOpp2;
            
            
            Opportunity oppTy = [Select Id,Renewal_Flag__c ,Expected_Start_Date__c,Expected_End_Date__c ,Expiration_Date__c ,Opportunity_Owner_s_Sales_Org__c from opportunity where id =:testOpp1.Id];
            
            system.assertEquals(testUser.Sales_Org__c,oppTy.Opportunity_Owner_s_Sales_Org__c);
            Product2 testProd =UnitTest.getProductInstance();
            insert testProd;
            
           // List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];   
                  
            PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
            insert testEntry;
            
            OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
            insert testLineItem;
            
             LCRMCancelEmailTemplateController ocontroller = new LCRMCancelEmailTemplateController();
             ocontroller.opptyId = testOpp1.Id;
             List<Opportunity> opp = ocontroller.getoppty();
             
             testOpp1.Expected_Start_Date__c= null;
             testOpp1.Expected_End_Date__c = null;
             testOpp1.Expiration_Date__c = null;
             update testOpp1;
             ocontroller.opptyId = testOpp1.Id;
             opp = ocontroller.getoppty();
             
             /*LCRMCancelEmailTemplateController ocontroller1 = new LCRMCancelEmailTemplateController();
             ocontroller1.opptyId = testOpp2.Id;
             List<Opportunity> oppt = ocontroller1.getoppty();*/
         }
    }
}