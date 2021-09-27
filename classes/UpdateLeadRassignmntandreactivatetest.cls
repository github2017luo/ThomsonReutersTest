/*
 Class name :   UpdateLeadRassignmntandreactivatetest
 Description : This class is used to cover process builder named 'Process_to_Update_the_Most_recent_Lead_Reassignment_and_Reactivated_date' 
 versionid: 3011B000000g34y
 */
@istest
 public with sharing class UpdateLeadRassignmntandreactivatetest{
    @testSetup static void addKeyValueStore() {

        Group testGroup = new Group(Name='SDR Qualified Lead Queue', Type='Queue');
        insert testGroup;

        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Lead');
        insert testQueue;

        Group testGroup2 = new Group(Name='SDR Qualified Lead Queue Test', Type='Queue');
        insert testGroup2;

        QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup2.id, SObjectType = 'Lead');
        insert testQueue2;
                
        }
    //Criteria : Update Most recent Qualified Date field based on Lead Owner
    /**
     * AND(     NOT($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Process_Builders__c ), [Lead].Is_GLI__c =TRUE,

             ISBLANK([Lead].Most_Recent_Qualified_Date__c ) ,

            ISCHANGED([Lead].OwnerId ) , 
                 
            LEFT([Lead].OwnerId ,3) = '00G',
            
            LEFT(PRIORVALUE([Lead].OwnerId  ),3)='00G' ,    
                  
            OR(ISPICKVAL([Lead].Status , "Unworked"), 

            ISPICKVAL([Lead].Status , "Telesales Accepted")  ),    
                   
             [Lead].Owner:Queue.DeveloperName  = "SDR_Qualified_Lead_Queue"
         )
     */
    @isTest static void decision1() {

        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;

        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;

        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        

        Group gr = [Select Name,Type FROM Group WHERE Name = 'SDR Qualified Lead Queue' Limit 1];
        QueuesObject qObj = [Select Id,QueueID FROM QueuesObject WHERE QueueID =: gr.Id];

        Group gr2 = [Select Name,Type FROM Group WHERE Name = 'SDR Qualified Lead Queue Test' Limit 1];
        QueuesObject qObj2 = [Select Id,QueueID FROM QueuesObject WHERE QueueID =: gr2.Id];

        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead testLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit';
        TestLead1.LastName = 'Tester1';
        TestLead1.Company = 'UnitTestCompany';
        //TestLead1.Account__c=acc.Id;
        TestLead1.is_GLI__c =true;
        TestLead1.ownerId = gr.id;
        TestLead1.Sales_Org__c='GLI';
        //TestLead1.Status = 'Unworked'; 
        TestLead1.status = 'DisQualified';
        TestLead1.TRWayLeadMgmt__Panorama_DQ_Reason__c = 'No budget';        
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        System.assert(TestLead1.Status == 'DisQualified');
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
        insert listlead;

        listlead[0].status = 'Unworked';
        listlead[0].ownerId = gr2.id;
        //listlead[0].TRWayLeadMgmt__Panorama_DQ_Reason__c = 'No budget';
        update listlead;
        }

    }
    @isTest static void decision2() {

        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;

        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;

        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        

        Group gr = [Select Name,Type FROM Group WHERE Name = 'SDR Qualified Lead Queue' Limit 1];
        QueuesObject qObj = [Select Id,QueueID FROM QueuesObject WHERE QueueID =: gr.Id];

        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        test.starttest();
        Lead testLead1 = UnitTest.getLeadInstance();
        TestLead1.LeadSource='Customer Service'; 
        TestLead1 .RecordTypeId=leadRt.Id;      
        TestLead1.SAPAccountNumber__c = '98711';
        TestLead1.FirstName = 'Unit';
        TestLead1.LastName = 'Tester1';
        TestLead1.Company = 'UnitTestCompany';
        //TestLead1.Account__c=acc.Id;
        TestLead1.is_GLI__c =true;
        //TestLead1.ownerId = gr.id;
        TestLead1.Sales_Org__c='GLI';
        //TestLead1.Status = 'Unworked'; 
        TestLead1.status = 'Unworked';
        //TestLead1.TRWayLeadMgmt__Panorama_DQ_Reason__c = 'No budget';        
        TestLead1.Billing_Country__c='US';
        TestLead1.Description='Lead is created for GLI';
        System.assert(TestLead1.Status == 'Unworked');
        listlead.add(TestLead1);
        
        if(listlead.size()>0){
        insert listlead;

        listlead[0].OwnerId = gr.Id;
        //listlead[0].TRWayLeadMgmt__Panorama_DQ_Reason__c = 'No budget';
        update listlead;
        }

    }
    
    
}