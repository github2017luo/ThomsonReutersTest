/**
 * ====================================================================================================================
 * TEST CLASS NAME: LCRM_Opportunity_Amount_Update_Test
 * FLOW NAME      : LCRM_Opportunity_Amount_Field_Update
 * ======================================================================================================================
 * CHANGE HISTORY
 * ===================================================================================================================
 */

 /**
     * LCRM_Opportunity_Amount_Update_Test
     * @description LCRM_Opportunity_Amount_Update_Test class
 */

@isTest
public class LCRM_Opportunity_Amount_Update_Test {

  @isTest
        private static void testCase(){
        String anz = [Select id from Profile where name = 'ANZ Users' limit 1].id;
        KeyValueListStore__c kv = new KeyValueListStore__c();
        kv.Name = 'ANZUsersProfileId';
        //kv.TextValue__c = [select TextValue__c from  KeyValueListStore__c where Name = 'ANZUsersProfileId'];
        //kv.TextValue__c = '00e30000001ZUki';
        kv.TextValue__c = anz;
        insert kv;
        
        String ppo = [Select id from recordtype where DeveloperName = 'Pre_Pipeline_Opportunity' limit 1].id;
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        //recT.recTypeId__C = '012a0000001ZJxn'; 
        recT.recTypeId__C = ppo;    
        //recT.recTypeId__C = [select recTypeId__C from  RecordtypeIds__c where Name = 'Pre-Pipeline Opportunities'];
        insert recT;
        
        String po = [Select id from recordtype where DeveloperName = 'Pipeline_Opportunity' limit 1].id;
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        //recT1.recTypeId__C = '012a0000001ZJxn';
        recT1.recTypeId__C = po;
        //recT1.recTypeId__C = [select recTypeId__C from  RecordtypeIds__c where Name = 'Pipeline Opportunities'];
        insert recT1;
         Id rc= [select id from RecordType where Name='GLI Pipeline Opportunity'].id;
         
         LTS_Disable_Application_Automation__c lts= new LTS_Disable_Application_Automation__c();
         lts.LTS_Disable_Process_Builders__c =  false;
         lts.SetupOwnerId=UserInfo.getOrganizationId();
         insert lts;
         user u = new user();
           u = [select id from user where id !=:userinfo.getuserid() and IsActive=true limit 1];
       
        Account acc = new Account();
            acc.Name = 'Unit Test';
            acc.BillingStreet = '123 Unit Test Street';
            acc.BillingCity='Dallas';
            acc.BillingState = 'TX';
            acc.BillingPostalCode = '75006';
            acc.BillingCountry='US';
      
        insert acc;
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName  = 'Contact Record';
        con.Email = 'Test@tr.com';
        con.AccountId = acc.id;
        insert con;
        //Pricebook2 testPricebook = [SELECT Id, Name, SystemModstamp FROM Pricebook2 where IsActive=true and isStandard=true limit 1];
        //insert testPricebook;
        Opportunity objOpty =  new Opportunity();
        objOpty.AccountId = acc.id;
        objOpty.Name = 'Unit Test Opportuntiy';
        objOpty.CloseDate = System.Today() + 5;
        objOpty.StageName = 'Qualifying';
        objOpty.Is_GLI__c = true;
        objOpty.ForecastCategoryName = 'Omitted';
        objOpty.Key_Contact__c = con.id;
        objOpty.RecordTypeId = rc;
        //objOpty.Pricebook2Id = testPricebook.id;
        insert objOpty;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        insert testProd1;
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=1);
        insert testEntry1 ;
         List<OpportunityLineItem> listtestOppLineitem = new List<OpportunityLineItem>();
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,LCRM_Units__c=2,UnitPrice =3,OpportunityId = objOpty.Id,PricebookEntryId=testEntry1.id));
                insert listtestOppLineitem;
        
        //objOpty.LCRM_Total_Actual_Incremental__c = 4847.00;
        //objOpty.LCRM_Total_Actual_Renewal__c = 8847.00;
        
        objOpty.Renewal_Flag__c = true;
         test.startTest();
         update objOpty;
         
         system.debug(LoggingLevel.DEBUG,'LCRM_Total_Actual_Renewal__c'+objOpty.LCRM_Total_Actual_Renewal__c);
         System.assertEquals( objOpty.Amount,objOpty.LCRM_Total_Actual_Renewal__c,'USD 8,847.00');
         //System.assertEquals( objOpty.Amount,objOpty.LCRM_Total_Actual_Renewal__c,null);
         //test.stopTest();
         
         objOpty.Renewal_Flag__c = false;
         //test.startTest();
         update objOpty;
          system.debug(LoggingLevel.DEBUG,'LCRM_Total_Actual_Incremental__c '+objOpty.LCRM_Total_Actual_Incremental__c );
         System.assertEquals( objOpty.Amount,objOpty.LCRM_Total_Actual_Incremental__c ,'USD 4,847.00');
         test.stopTest();
         }
        
}