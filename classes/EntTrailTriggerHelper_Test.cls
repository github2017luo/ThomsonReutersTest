@isTest
public class EntTrailTriggerHelper_Test { 
    
     @testSetup static void setup() {
        Account acc = new Account();
        acc.name = 'test acc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        acc.BU_Region__c = 'Canada';
        acc.Bu_Segment__c = 'Professional Tax';
        acc.Is_GLI__c = true;
        acc.hasActiveTrial__c= false;
        insert acc;
        
         
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = [select Id from Profile where Name='ANZ Users' limit 1].Id;        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMSplit_AllowedStages';
        kvs1.TextValue__C = 'Appointment Scheduled,Needs Analysis,Solution Recommended,Generate Contract,Negotiate Contract,Contract Signed,Order Complete,Closed Lost';        
        
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMSplit_ExcludeAction';
        kvs2.TextValue__C = 'Remove';        
        
        KeyValueListStore__c kvs3= new KeyValueListStore__c();
        kvs3.name= '    LCRMSplit_ProdLimit';
        kvs3.TextValue__C = '20';        
        
        KeyValueListStore__c kvs4= new KeyValueListStore__c();
        kvs4.name= 'LCRMSplit_TeamLimit';
        kvs4.TextValue__C = '20';        
        
        insert new List<KeyValueListStore__c>{kvs, kvs1, kvs2, kvs3, kvs4};
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = [select Id from Profile where Name='Partner Portal User' limit 1].Id; // '00ea00000024JwaAAE';
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = [select Id from Profile where Name='LatAm User' limit 1].Id; //'00ea00000024JzKAAU';
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = [select Id from Profile where Name='System Administrator' limit 1].Id; //'00e30000001gFezAAE';
        INSERT new List<Profile_List__c>{objPro, objPro1, objPro2};
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        Id pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
        insert new List<PricebookEntry>{testEntry};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();    
        testAcc.Is_GLI__c = true;    
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Pricebook2Id;
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        //testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = TRUE;
        
        insert testOpp1;
         
         contact con = new contact();
         con.firstname = 'Test';
         con.lastname = 'lnmae';
         con.Email ='test@testmail.com';
         insert con;
       
        
        lead ld = new lead();
        ld.LastName = 'Test';
        ld.FirstName = 'fNAME';
        //ld.Account__c = acc.Id;
        ld.Status = 'Contacting';
        ld.company='test';
        insert ld;  
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = testOpp1.id;
        //trl.Contact__c = con.id;
        trl.lead__c = ld.id;
        trl.Trial_Status__c = 'Active';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl;       
    }
  
    
    @isTest
    public static void testMethod2(){
        
        Account acc = new Account();
        acc.name = 'test acc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        acc.BU_Region__c = 'Canada';
        acc.Bu_Segment__c = 'Professional Tax';
        acc.Is_GLI__c = true;
        acc.hasActiveTrial__c= false;
        insert acc;
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = acc.Id;
        testOpportunity.Name = 'Unit Test Opportuntiy2';
        testOpportunity.CloseDate = System.Today() - 5;
        testOpportunity.StageName = 'Prospect';
        //insert testOpportunity;
        
        lead ld = new lead();
        ld.LastName = 'Test';
        ld.FirstName = 'fNAME';
        //ld.Account__c = acc.Id;
        ld.Status = 'Contacting';
        ld.company='test';
        insert ld;  
        
         contact con = new contact();
         con.firstname = 'Test';
         con.lastname = 'lnmae';
         con.Email ='test@testmail1.com';
         insert con;
        
        list< Ent_Trial__c> trls= new list<Ent_Trial__c>();
        Ent_Trial__c trl= new  Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = testOpportunity.id;
        trl.lead__c = ld.id;
        //trl.Contact__c = con.id;
        trl.Trial_Status__c = 'Active';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        trls.add(trl);
        
        Ent_Trial__c trl1= new  Ent_Trial__c();
        trl1.Account__c = acc.id;
        trl1.Opportunity__c = testOpportunity.id;
        //trl.Contact__c = con.id;
        trl1.lead__c = ld.id;
        trl1.Trial_Status__c = 'Active';
        trl1.Trial_Start_Date__c  =system.today();
        trl1.Trial_End_Date__c = system.today();
        trl1.External_Account_Number__c = '4332938';
        trls.add(trl1);
        insert trls;

         // EntTrialTriggerHandler.isRecursive = false;
         Ent_Trial__c etrl = [select id,External_Account_Number__c from  Ent_Trial__c limit 1] ;
        etrl.External_Account_Number__c = '454545';
        update etrl;
        
        EntTrialTriggerHandler.isRecursive = false;
        delete etrl;

      system.assertEquals('4332938', trl1.External_Account_Number__c , 'SUCCESS');
    }
    
    
    
}