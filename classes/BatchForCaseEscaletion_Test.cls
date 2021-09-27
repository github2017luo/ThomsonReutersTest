/***********************************************************************************************
Purpose      : Test class for BatchForCaseEscaletion class 
Developed By : Anshu Thakur
Date         : 01/04/2017
Changed Log  :
************************************************************************************************/
@istest
public class BatchForCaseEscaletion_Test {
    public static testmethod void batchForCaseEscaletion_Test(){

        List<Case> lstCase = new List<Case>();
        List<Case_Escalation_Settings__c> lstCaseEscSet = new List<Case_Escalation_Settings__c>();
        
        //Calling method from UnitTest class to prepare test data for Custom Settings
        UnitTest.createTestData();
        
        //Preparing Profile_List__c Custom Setting tets data foe System Admin profile
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'System Administrator';
        objPro.Profile_Name__c = 'System Administrator';        
        objPro.ProfileId__c = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        INSERT objPro;
        
        //Preparing Case_Escalation_Settings__c Custom Setting test data : set 1
        Case_Escalation_Settings__c oCaseEscSet1 = new Case_Escalation_Settings__c();
        oCaseEscSet1.name = 'LATAM Escalation- Level 0';       
        oCaseEscSet1.Escalation_Level__c = 0;
        oCaseEscSet1.Escalation_SLA_Max__c = 40;
        oCaseEscSet1.Escalation_SLA_Min__c = 32;
        lstCaseEscSet.add(oCaseEscSet1);
        
        //Preparing Case_Escalation_Settings__c Custom Setting test data : set 2
        Case_Escalation_Settings__c oCaseEscSet2 = new Case_Escalation_Settings__c();
        oCaseEscSet2.name = 'LATAM Escalation- Level 1';       
        oCaseEscSet2.Escalation_Level__c = 1;
        oCaseEscSet2.Escalation_SLA_Max__c = 24;
        oCaseEscSet2.Escalation_SLA_Min__c = 16;
        lstCaseEscSet.add(oCaseEscSet2);
        
        //Preparing Case_Escalation_Settings__c Custom Setting test data : set 3
        Case_Escalation_Settings__c oCaseEscSet3 = new Case_Escalation_Settings__c();
        oCaseEscSet3.name = 'LATAM Escalation- Level 2';       
        oCaseEscSet3.Escalation_Level__c = 2;
        oCaseEscSet3.Escalation_SLA_Max__c = 16;
        oCaseEscSet3.Escalation_SLA_Min__c = 8;
        lstCaseEscSet.add(oCaseEscSet3);
        
        INSERT lstCaseEscSet;
        
        //Preparing User test data
        User objUser = new User();
        objUser.Username = 'TestUser@TR.com';
        objUser.LastName = 'XYZ';
        objUser.Email = 'abc@xyz.com';
        objUser.Alias = 'abctest';
        objUser.CommunityNickname = 'CommunityNickname.testUser';
        objUser.TimeZoneSidKey = 'America/Los_Angeles';
        objUser.LocaleSidKey = 'en_US';
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.ProfileId = objPro.ProfileId__c;
        INSERT objUser;
        
        //Preparing Case test data :set1
        Case objCase1 = new Case();
        objCase1.CurrencyIsoCode = 'USD';
        objCase1.Origin = 'Fax';
        objCase1.Status = 'On Hold';
        objCase1.Last_Modified_Date__c = (System.now() - 4);
        objCase1.OwnerId = objUser.Id;
        objCase1.ANZ_Issue__c = 'CAC - Administrativo';
        objCase1.Escalation_Level_Number__c = 0;
        objCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        lstCase.add(objCase1);
        
        //Preparing Case test data :set2
        Case objCase2 = new Case();
        objCase2.CurrencyIsoCode = 'NZD';
        objCase2.Origin = 'Mail';
        objCase2.Status = 'New';
        objCase2.Last_Modified_Date__c = (System.now() - 2);
        objCase2.OwnerId = objUser.Id;
        objCase2.ANZ_Issue__c = 'CAC - Proview';
        objCase2.Escalation_Level_Number__c = 1;
        objCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        lstCase.add(objCase2);
        
        //Preparing Case test data :set3
        Case objCase3 = new Case();
        objCase3.CurrencyIsoCode = 'BRL';
        objCase3.Origin = 'Web';
        objCase3.Status = 'Escalated';
        objCase3.Last_Modified_Date__c = (System.now() - 1);
        objCase3.OwnerId = objUser.Id;
        objCase3.ANZ_Issue__c = 'CAC - Servicio Online';
        objCase3.Escalation_Level_Number__c = 2;
        objCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        lstCase.add(objCase3);
        
        //Preparing Case test data :set4
        Case objCase4 = new Case();
        objCase4.CurrencyIsoCode = 'BRL';
        objCase4.Origin = 'Web';
        objCase4.Status = 'Closed';
        objCase4.Last_Modified_Date__c = System.now();
        objCase4.OwnerId = objUser.Id;
        objCase4.ANZ_Issue__c = 'Billing';
        objCase4.Escalation_Level_Number__c = 1;
        //objCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        lstCase.add(objCase4);
        
        //Preparing Case in bulk
        for(Integer i=0;i<2;i++){
            Case bulkCase = new Case();
            bulkCase.CurrencyIsoCode = 'BRL';
            bulkCase.Origin = 'Web';
            bulkCase.Status = 'Closed';
            bulkCase.Last_Modified_Date__c = (System.now() - 1);
            bulkCase.OwnerId = objUser.Id;
            bulkCase.ANZ_Issue__c = 'CAC - Servicio Online';
            bulkCase.Escalation_Level_Number__c = 2;
            bulkCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
            lstCase.add(bulkCase);
        }
                
        Test.StartTest();
        System.runAs(objUser){
            INSERT lstCase;
            BatchForCaseEscaletion objBatchCaseEsc= new BatchForCaseEscaletion();
            Database.executeBatch(objBatchCaseEsc);  
        }
        System.assertEquals(objCase3.Status,'Escalated');
        Test.StopTest();
    }
}