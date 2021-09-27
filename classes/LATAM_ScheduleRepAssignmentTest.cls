/*************************************************************
@Name:           LATAM_ScheduleRepAssignmentTest
@Author:         Kruti Shah
@CreateDate:     08/09/2019
@Test Class For: LATAM_ScheduleBatchToCreateRepAssignment
************************************************************/
@isTest
private class LATAM_ScheduleRepAssignmentTest
{
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        insert accountSSD;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        
        List<Apttus_Proposal__Proposal__c> lstOfprops = new List<Apttus_Proposal__Proposal__c>();
        for(Integer i = 1; i <= 20; i++){
            Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c (Apttus_Proposal__Account__c=a.Id);
            proposal.Apttus_Proposal__Proposal_Name__c='Renew Canada'+i;
            proposal.Apttus_Proposal__Approval_Stage__c='Draft';
            proposal.Apttus_Proposal__Account__c = a.Id;
            proposal.APTS_Proposal_Business_Unit__c='Canada';
            proposal.RecordtypeId = propRecorType;            
            proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
            proposal.Apttus_Proposal__Account__c = a.Id;
            proposal.Apttus_QPConfig__IsSystemGenerated__c =true;
            proposal.Auto_Renewal_Quote__c=true;
            lstOfprops.add(proposal);
        }
        Insert lstOfprops ;      
        
        Test.startTest();
        
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new LATAM_ScheduleBatchToCreateRepAssignment());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
        // Add assert here to validate result
    }
    
    static testmethod void schedulerTest_Canada() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        insert accountSSD;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        
        List<Apttus_Proposal__Proposal__c> lstOfprops = new List<Apttus_Proposal__Proposal__c>();
        for(Integer i = 1; i <= 20; i++){
            Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c (Apttus_Proposal__Account__c=a.Id);
            proposal.Apttus_Proposal__Proposal_Name__c='Renew Canada'+i;
            proposal.Apttus_Proposal__Approval_Stage__c='Void';
            proposal.APTS_Proposal_Business_Unit__c='Canada';
            proposal.RecordtypeId = propRecorType;            
            proposal.APTS_SSD_Sold_To__c = accountSSD.Id;  
            proposal.Apttus_QPConfig__IsSystemGenerated__c =true;
            proposal.Auto_Renewal_Quote__c=true;
            lstOfprops.add(proposal);
        }
        Insert lstOfprops ;        
        
        Test.startTest();        
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new LATAM_ScheduleBatchToCreateRepAssignment());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);        
        Test.stopTest();        
    }
}