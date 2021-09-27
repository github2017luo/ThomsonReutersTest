@isTest
public class DCPRenewalOpportunity_Test{
    
    @TestSetup
    static void makeData(){
    
        DCPTestDataFactory.disableApplicationAutomation();
        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        insert ssd;
        
        Source_System_Detail__c ssd2 = new Source_System_Detail__c();
        ssd2.Name = 'ABCD';
        ssd2.Source_System_Name__c = 'ABCD';
        ssd2.Account_Inactive__c = false;
        ssd2.LCRM_SAP_Account_Number__c = '1004284494';
        ssd2.BU_Segment_Level_2__c = 'Medium Law';
        ssd2.State__c = 'CA';
        ssd2.LCRM_Customer_Group__c = 'FIRM';
        ssd2.Account_Name__c = acc.id;
        insert ssd2;

        Source_System_Detail__c ssd3 = new Source_System_Detail__c();
        ssd3.Name = 'ABCDE';
        ssd3.Source_System_Name__c = 'ABCDE';
        ssd3.Account_Inactive__c = false;
        ssd3.LCRM_SAP_Account_Number__c = '1004284494';
        ssd3.BU_Segment_Level_2__c = 'Corp-SMB';
        ssd3.State__c = 'CA';
        ssd3.LCRM_Customer_Group__c = 'FIRM';
        ssd3.Account_Name__c = acc.id;
        insert ssd3;

        Source_System_Detail__c ssd4 = new Source_System_Detail__c();
        ssd4.Name = 'ABCDEF';
        ssd4.Source_System_Name__c = 'ABCDEF';
        ssd4.Account_Inactive__c = false;
        ssd4.LCRM_SAP_Account_Number__c = '1004284494';
        ssd4.BU_Segment_Level_2__c = 'State Government';
        ssd4.State__c = 'CA';
        ssd4.LCRM_Customer_Group__c = 'FIRM';
        ssd4.Account_Name__c = acc.id;
        insert ssd4;
    
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        insert con;
              
        Opportunity opp = (Opportunity)objectToDataMap.get('Opportunity');
        opp.StageName = 'ContactingSLF';
        opp.Renewal_Date__c = system.today().addDays(180);
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = con.id;
        insert opp;

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Opportunity2';
        opp2.isdigitalSpearhead__c = TRUE;
        opp2.CloseDate = System.Today() + 30;
        opp2.StageName = 'Appointment Scheduled';
        opp2.Renewal_Date__c = System.Today() + 1;
        opp2.StageName = 'ContactingMLF';
        opp2.Renewal_Date__c = system.today().addDays(180);
        opp2.AccountId = acc.id;
        opp2.Source_System_Detail__c = ssd2.id;
        opp2.Key_Contact__c = con.id;
        insert opp2;

        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Opportunity3';
        opp3.isdigitalSpearhead__c = TRUE;
        opp3.CloseDate = System.Today() + 30;
        opp3.StageName = 'Appointment Scheduled';
        opp3.Renewal_Date__c = System.Today() + 1;
        opp3.StageName = 'ContactingCorp';
        opp3.Renewal_Date__c = system.today().addDays(180);
        opp3.AccountId = acc.id;
        opp3.Source_System_Detail__c = ssd3.id;
        opp3.Key_Contact__c = con.id;
        insert opp3;

        Opportunity opp4 = new Opportunity();
        opp4.Name = 'Test Opportunity4';
        opp4.isdigitalSpearhead__c = TRUE;
        opp4.CloseDate = System.Today() + 30;
        opp4.StageName = 'Appointment Scheduled';
        opp4.Renewal_Date__c = System.Today() + 1;
        opp4.StageName = 'ContactingGov';
        opp4.Renewal_Date__c = system.today().addDays(180); 
        opp4.AccountId = acc.id;
        opp4.Source_System_Detail__c = ssd4.id;
        opp4.Key_Contact__c = con.id;
        insert opp4;

    }

    @isTest
    private static void testSmallLaw(){
        
        Opportunity opp = [SELECT id FROM Opportunity WHERE Name = 'Test Opportunity' ];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE BU_Segment_Level_2__c = 'Small Law' ];
        opp = DCPOpportunity.getOpportunity(new List<Id>{opp.Id})[0];
        ssd = DCPSSD.getSSD(new List<Id>{ssd.Id})[0];
        DCPRenewalSetting.getRenewalSetting();
        Test.startTest();
        DCPRenewalOpportunityWrapper opportunityWrapper = DCPRenewalOpportunity.populateOpportunityDetails(opp,ssd);
        System.assert(opportunityWrapper != null, 'Wrapper is null');
        Test.stopTest();
    }
    
    @isTest
    private static void testMediumLaw(){

        Opportunity opp = [SELECT id FROM Opportunity WHERE Name = 'Test Opportunity2' LIMIT 1];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE BU_Segment_Level_2__c = 'Medium Law' ];
        opp = DCPOpportunity.getOpportunity(new List<Id>{opp.Id})[0];
        ssd = DCPSSD.getSSD(new List<Id>{ssd.Id})[0];
        DCPRenewalSetting.getRenewalSetting();
        Test.startTest();
        DCPRenewalOpportunityWrapper opportunityWrapper = DCPRenewalOpportunity.populateOpportunityDetails(opp,ssd);
        System.assert(opportunityWrapper != null, 'Wrapper is null');
        Test.stopTest();
    }
    
    @isTest
    private static void testCorporate(){

        Opportunity opp = [SELECT id FROM Opportunity WHERE Name = 'Test Opportunity3' LIMIT 1];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE BU_Segment_Level_2__c = 'Corp-SMB' ];
        opp = DCPOpportunity.getOpportunity(new List<Id>{opp.Id})[0];
        ssd = DCPSSD.getSSD(new List<Id>{ssd.Id})[0];
        DCPRenewalSetting.getRenewalSetting();
        Test.startTest();
        DCPRenewalOpportunityWrapper opportunityWrapper = DCPRenewalOpportunity.populateOpportunityDetails(opp,ssd);
        System.assert(opportunityWrapper != null, 'Wrapper is null');
        Test.stopTest();
    }
    
    @isTest
    private static void testGovernment(){

        Opportunity opp = [SELECT id FROM Opportunity WHERE Name = 'Test Opportunity4' LIMIT 1];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE BU_Segment_Level_2__c = 'State Government' ];
        opp = DCPOpportunity.getOpportunity(new List<Id>{opp.Id})[0];
        ssd = DCPSSD.getSSD(new List<Id>{ssd.Id})[0];
        DCPRenewalSetting.getRenewalSetting();
        Test.startTest();
        DCPRenewalOpportunityWrapper opportunityWrapper = DCPRenewalOpportunity.populateOpportunityDetails(opp,ssd);
        System.assert(opportunityWrapper != null, 'Wrapper is null');
        Test.stopTest();
    }    
}