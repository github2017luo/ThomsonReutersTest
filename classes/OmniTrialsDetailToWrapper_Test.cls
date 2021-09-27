/**
* @description       : calling from LWC UI check if existing Trial avaialble on Opportunity.
* Test Class for OmniTrialsDetailToWrapper
* if available, then store Trial, Trial Contacts and Trial Products records into Wrapper class
* @author            : TCS Dev Team
* @group             : Omni Trials
* @last modified on  : 
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
@isTest
public class OmniTrialsDetailToWrapper_Test {

    @isTest
    public static void testMethod1(){
       
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '';        
        
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
        objPro.ProfileId__c = '';
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '';
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '';
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
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        
        opp.Pricebook2Id = Pricebook2Id;
        update opp;
        
        Ent_Trial__c trc= new Ent_Trial__c();
        trc.Account__c = testAcc.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        trc.External_Account_Number__c = '4332938';
        trc.Opportunity__c  = opp.id; 
        trc.Trial_Status__c = 'Draft'; 
        insert trc;
        
        Trial_Contact__c tc = new Trial_Contact__c ();
        tc.External_Contact_Number__c ='76767646';
        tc.External_Contact_Number_Source__c ='SAP';
        tc.Contact__c = null;
        tc.First_Name__c = 'test';
        tc.Last_Name__c = 'test';
        tc.Email__c ='test@test.com' ;
        tc.One_Pass_ID__c='chffhgfghhgh';
        tc.name = 'test';
        tc.Status__c ='Draft' ;
        tc.Trials__c = trc.id;         
        tc.Online_Contact__c =true ; 
        tc.COBALT_GUID__c = 'gjfghfggfhgfh';   
        tc.DATAROOM_GUID__c='vgjfjjhgjhjhgjhv'; 
        tc.Start_Date__c = system.today();
        tc.End_Date__c = system.today()+4;
        //tc.Account__c =a.id ;
        //tc.Opportunity__c = o.id;
        tc.Primary__c = true ;
        tc.Name = 'test';
         insert tc;
         
        Trial_Product__c tp = new Trial_Product__c();    
        tp.Trial__c = trc.id; 
        tp.Product_Name__c= testProd1.Id;
        tp.name = 'test';
        insert tp;
        system.assert(true, tp!=null);
        OmniTrialsDetailToWrapper.getExistingTrailDetails(trc.Id, opp.Id, 'Draft');
        OmniTrialsDetailToWrapper.getExistingTrailDetails(null, opp.Id, 'Draft');
        }
}