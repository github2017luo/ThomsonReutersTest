/** 
 * @description : Test class
* Class         : Process Builder - Omni Trial Contact Email Update
* Purpose       : Test class codevoverage 
* Created Date  : 06-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
@isTest
public class OmniTrialContactEmailUpdate_Test {
    
   /**
    * @description testMethod
    */
    @isTest
    public static void testMethod1(){
       
        Product2 prdList = new Product2();
        prdList.ProductCode='test';
        prdList.Name = 'Test';
        
        
       
          Account acc = new Account();
          acc.name = 'test acc';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc.BU_Region__c = 'Canada';
          acc.Bu_Segment__c = 'Professional Tax';
          acc.Is_GLI__c = true;
          insert acc;
        //Create contact
    Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = acc.Id,
        Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
       
        Opportunity testOpportunity = UnitTest.getOpportunityInstance(acc.Id);        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = testOpportunity.id;
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl;
        
          Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.contact__c = contact1.Id;
        insert trlCon;
        
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        insert trprd;    
        
        Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
        trialPrdCont.Trial_Contact__c = trlCon.id;
        trialPrdCont.Trial_Product__c = trprd.Id;
        trialPrdCont.Trials__c = trl.Id;
        insert trialPrdCont;
        
        
        contact1.Email = System.now().millisecond() + 'test@test.cooom';
        update contact1;
        
        List<Trial_contact__c> trlist = [select id from trial_contact__c where email__c = : contact1.Email];
        system.assertEquals(true,trlist.size()>0,'SUCCESS');
    }
    
     /**
    * @description testMethod2
    */
    @isTest
    public static void testMethod2(){
       LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Product2 prdList = new Product2();
        prdList.ProductCode='test';
        prdList.Name = 'Test';
        
        
       
          Account acc = new Account();
          acc.name = 'test acc';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc.BU_Region__c = 'Canada';
          acc.Bu_Segment__c = 'Professional Tax';
          acc.Is_GLI__c = true;
          insert acc;
        //Create contact
    Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = acc.Id,
        Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
       
        Opportunity testOpportunity = UnitTest.getOpportunityInstance(acc.Id);        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = testOpportunity.id;
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl;
        
          Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.contact__c = contact1.Id;
        insert trlCon;
        
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        insert trprd;    
        
        Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
        trialPrdCont.Trial_Contact__c = trlCon.id;
        trialPrdCont.Trial_Product__c = trprd.Id;
        trialPrdCont.Trials__c = trl.Id;
        insert trialPrdCont;
        
        
        contact1.Email = System.now().millisecond() + 'test@test.cooom';
        update contact1;
        
        List<Trial_contact__c> trlist = [select id from trial_contact__c where email__c = : contact1.Email];
        system.assertEquals(false,trlist.size()>0,'SUCCESS');
    }
}