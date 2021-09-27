@isTest
public class OmniTrialContactTriggerHandler_Test {
    
    @testSetup static void setup() {
        Account acc = new Account();
        acc.name = 'test acc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        acc.BU_Region__c = 'Canada';
        acc.Bu_Segment__c = 'Professional Tax';
        acc.Is_GLI__c = true;
        acc.hasActiveTrial__c= false;
        insert acc;
        
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = acc.Id,
        Email = System.now().millisecond() + 'test@test.com',
        Contact_Group__c = 'Non-Sales Contact',
         Has_Active_Trial__c = false
       );
      
    insert(contact1);
        
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = acc.Id;
        testOpportunity.Name = 'Unit Test Opportuntiy';
        testOpportunity.CloseDate = System.Today() + 5;
        testOpportunity.StageName = 'Prospect';
        
        
        lead ld = new lead();
        ld.LastName = 'TestLMN';
        ld.FirstName = 'fNAMEsd';        
        ld.Status = 'Contacting';
        ld.company='test';
        insert ld;  
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        //trl.Opportunity__c = testOpportunity.id;
        //trl.lead__c = ld.id;
        trl.Trial_Status__c = 'Accepted';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        trl.Extended__c = false;
        insert trl;
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        
        list<Trial_Product__c> trialProducts = new list<Trial_Product__c>();
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        trprd.Relationship_Type__c = 'Plan to Plan';
        
        trialProducts.add(trprd);
         Trial_Product__c trprd1 = new Trial_Product__c();
        trprd1.Product_Name__c = prd.id;
        trprd1.Trial__c = trl.id;
        trprd1.Name= 'Test Name';
        trprd1.Relationship_Type__c = 'Accessory Product';
        trialProducts.add(trprd1);
        insert trialProducts;  
        
        List<Trial_Contact__c> trconlist = new List <Trial_Contact__c>();
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlcon.Contact__c = contact1.id;
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.Entitlement_Email_Sent__c = false ;
        trconlist.add(trlCon);
        
        Trial_Contact__c trlCon2 = new Trial_Contact__c();
        trlCon2.Email__c = 'gete2arpijt@me.com';
        trlCon2.Trials__c = trl.id;
        trlCon2.name = 'testnam';
        trlCon2.Status__c  = 'Active';
        trlcon2.Contact__c = contact1.id;
        trlCon2.First_Name__c = 'testFname';
        trlCon2.Last_Name__c = 'testlname';        
        trlcon2.Name= 'Test Name';
        trlcon2.Entitlement_Email_Sent__c = false ;
        trconlist.add(trlcon2);
        
        insert trconlist;
        
        
        
        KeyValueListStore__c kvlQA = new KeyValueListStore__c();
        kvlQA.name ='OmniEloquaCallTestEnv';
        kvlQA.TextValue__c = 'QA';
        insert kvlQA;
        KeyValueListStore__c kvl = new KeyValueListStore__c();
        kvl.name ='OmniTrialPrdSizeToEloqua';
        kvl.TextValue__c = '123232';
        insert kvl;
        KeyValueListStore__c kvl2 = new KeyValueListStore__c();
        kvl2.name ='OmniEloquaCallEncryptionKey';
        kvl2.TextValue__c = 'ondemandtrialpro';
        insert kvl2;
         
        
        
    }
    
    
    @isTest
    public static void testMethod1(){ 
        Test.startTest();        
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 2] ;
        trlcon[0].Status__c='Active';
        trlcon[1].Status__c='Invited';
        update trlcon;      
        Ent_Trial__c  etrl = [select id,Trial_Status__c from  Ent_Trial__c limit 1] ;           
        system.assertEquals('Active', etrl.Trial_Status__c , 'SUCCESS');
        Test.stopTest();
    }
    @isTest
    public static void testMethod2(){ 
        Test.startTest();       
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 1] ;
        delete trlcon;       
        Ent_Trial__c  etrl = [select id,Trial_Status__c from  Ent_Trial__c limit 1] ;
        system.assertEquals('Active', etrl.Trial_Status__c , 'SUCCESS');
        Test.stopTest();
    }
    @isTest
    public static void testMethod3(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 2] ;
        trlcon[0].Status__c='Draft';
        trlcon[1].Status__c='Accepted';
        update trlcon;
        Ent_Trial__c  etrl = [select id,Trial_Status__c from  Ent_Trial__c limit 1] ;
        system.assertEquals('Accepted', etrl.Trial_Status__c , 'SUCCESS');
        Test.stopTest();
    }
    
    
    @isTest
    public static void testMethod4(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 2] ;
        trlcon[0].Status__c='Draft';
        trlcon[1].Status__c='Invited';
        update trlcon;
        Ent_Trial__c  etrl = [select id,Trial_Status__c from  Ent_Trial__c limit 1] ;
        system.assertEquals('Invited', etrl.Trial_Status__c , 'SUCCESS');
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod5(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 2] ;
            trlcon[0].Status__c='TimedOut';
        trlcon[1].Status__c='TimedOut';
        update trlcon;
        Ent_Trial__c  etrl = [select id,Trial_Status__c from  Ent_Trial__c limit 1] ;
        system.assertEquals('TimedOut', etrl.Trial_Status__c , 'SUCCESS');
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod6(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 1] ;
        trlcon[0].Status__c='Ended';
        update trlcon;
        Digital_Blacklist_or_CompetitorList__c  blackList = [select Type__c from  Digital_Blacklist_or_CompetitorList__c limit 1] ;
        system.assertEquals('Blacklist', blackList.Type__c , 'SUCCESS');
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod7(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [Select id, Status__c,Contact__c from  Trial_Contact__c limit 2] ;
        trlcon[0].Status__c='Active';
        trlcon[1].Status__c='Active';
        update trlcon;
        Contact con = [Select id, Has_Active_Trial__c from Contact limit 1] ;
        system.assertEquals(true, con.Has_Active_Trial__c , 'SUCCESS');
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod8(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [Select id, Status__c,Contact__c from  Trial_Contact__c limit 2] ;
        trlcon[0].Status__c='Extended';
        trlcon[1].Status__c='Extended';
        update trlcon;        
        Ent_Trial__c  etrl = [select id,Trial_Status__c,Extended__c from  Ent_Trial__c limit 1] ;
        system.assertEquals(true, etrl.Extended__c , 'SUCCESS');
        Test.stopTest();
        
    }
    
    @isTest
    public static void testMethod9(){ 
        Test.startTest();
        List<Trial_Contact__c> trlcon = [Select id, Status__c,Contact__c from  Trial_Contact__c limit 2] ;
        trlcon[0].Status__c='Timedout';
        trlcon[1].Status__c='TimedOut';
        update trlcon;
        Contact con = [Select id, Has_Active_Trial__c from Contact limit 1] ;
        system.assertEquals(false, con.Has_Active_Trial__c , 'SUCCESS');
        Test.stopTest();
    }
    
}