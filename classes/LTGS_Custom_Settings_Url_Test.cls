/* Class: LTGS_Custom_Settings_Url_Test
 * Purpose: Test class for the Controller class LTGS_Custom_Settings_Url
 * Created: 3/7/2019
 * Author: Vinodhini
 
 * CHANGE HISTORY
 * ==========================================================================================================
 *  Date          Name                 Description
 *  2019-03-07    Vinodhini            Initial Version
 * ==========================================================================================================
 
 */

@isTest
public class LTGS_Custom_Settings_Url_Test {

    static testMethod void testDataSetUp() {
               
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = '00e30000001ZUki';        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMMergeOpportunityPageSize';
        kvs1.TextValue__C = '20'; 
         
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMMergeOpportunityExcludeStage';
        kvs2.TextValue__C = 'Contract Signed,Order Complete,Closed Lost';  
        
        insert new List<KeyValueListStore__c>{kvs,kvs1,kvs2};
        
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
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT new List<Profile_List__c>{objPro, objPro1, objPro2};
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        Id Pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
        System.debug('testEntry : '+testEntry);
        insert new List<PricebookEntry>{testEntry};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();    
        testAcc.Is_GLI__c = true;    
        insert testAcc;
        
        List<Opportunity> oppty = new List<Opportunity>();
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.stageName = 'Appointment Scheduled';
        testopp1.Pricebook2Id = Pricebook2Id;
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.Is_GLI__c = TRUE;
        testOpp1.LCRM_Sub_BU__c = 'Elite';
        testOpp1.Expected_End_Date__c = Date.Today();
        testOpp1.CurrencyIsoCode = 'USD';
        testOpp1.LCRM_Split_On__c = false;
        testOpp1.Expiration_Date__c = Date.Today();
        System.debug('Pricebook2Id  : '+testopp1.Pricebook2Id+' : '+Pricebook2Id);
        oppty.add(testOpp1);
                
        insert oppty;
        
        //LTGS_Custom_Settings_Url.getCustomSettings(keyValue[0].name);
        LTGS_Custom_Settings_Url.getCustomSettings(kvs.Name);
        LTGS_Custom_Settings_Url.optyDetails(testOpp1.Id);
        
        
        
    }        
}