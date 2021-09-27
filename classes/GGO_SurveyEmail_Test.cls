@isTest
public class GGO_SurveyEmail_Test {


    @isTest
    private static void GGo_SurveyEmailTest1() {
        
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        test.startTest();
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.LCRM_Sub_BU__c = 'GGO';
        case1.ESC_Send_Survey__c = false;
        insert case1;
        
        case1.Status='Closed';
        update case1;
        system.assertEquals(case1.Status,'Closed');
        test.StopTest();
        
    
    }
    
    @isTest
    private static void GGO_SurveyEmailTest2() {
        
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        test.StartTest();
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.Status='Closed';
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();
        case1.LCRM_Sub_BU__c = 'GGO';
        case1.ESC_Send_Survey__c = true;
        case1.ESC_Survey_Sent__c = false;
        insert case1;
        system.assertEquals(case1.ESC_Survey_Sent__c,false);
        test.stopTest();
        
        
        
        
    
    }
}