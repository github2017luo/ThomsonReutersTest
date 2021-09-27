/***********************************************************************************************
Purpose      : Test class for CaseMgmtBatch class 
Developed By : Anshu Thakur
Date         : 12/19/2016
Changed Log  :
************************************************************************************************/
@istest
public class CaseMgmtBatch_Test {
    public static testmethod void caseMgmtBatch_Test(){

        List<Case> lstCase = new List<Case>();
        
        //Calling method from UnitTest class to prepare test data for Custom Settings
        UnitTest.createTestData();

        //Preparing Case test data :set1
        Case objCase1 = new Case();
        objCase1.Status = 'On Hold';
        objCase1.CurrencyIsoCode = 'USD';
        objCase1.Origin = 'Fax';
        objCase1.Last_Modified_Date__c = System.now().addDays(-3);
        objCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        lstCase.add(objCase1);
        
        //Preparing Case test data :set2
        Case objCase2 = new Case();
        objCase2.Status = 'Escalated';
        objCase2.CurrencyIsoCode = 'NZD';
        objCase2.Origin = 'Mail';
        objCase2.Last_Modified_Date__c = System.now().addDays(-5);
        objCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        lstCase.add(objCase2);
        
        //Preparing Case test data :set3
        Case objCase3 = new Case();
        objCase3.Status = 'Escalated';
        objCase3.CurrencyIsoCode = 'BRL';
        objCase3.Origin = 'Web';
        objCase3.Last_Modified_Date__c = System.now().addDays(-7);
        objCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        lstCase.add(objCase3);
        
        //Preparing Case in bulk + negative testing scenario
        for(Integer i=0;i<2;i++){
            Case bulkCase = new Case();
            bulkCase.CurrencyIsoCode = 'BRL';
            bulkCase.Origin = 'Web';
            bulkCase.Status = 'Closed';
            bulkCase.Last_Modified_Date__c = (System.now());
            bulkCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
            lstCase.add(bulkCase);
        }
                
        Test.StartTest();
        INSERT lstCase;
        CaseMgmtBatch objCaseMgmtBatch= new CaseMgmtBatch();
        Database.executeBatch(objCaseMgmtBatch);  
        System.assertEquals(objCase3.Status,'Escalated'); 
        Test.StopTest();
     }
}