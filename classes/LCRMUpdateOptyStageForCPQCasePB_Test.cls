/*
    Process Builder: LCRM_Update_Opportunity_Stage_for_CPQ_Case test class
*/
@isTest
public class LCRMUpdateOptyStageForCPQCasePB_Test{
     
     public static testmethod void testDataSetUp() {
    
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
        insert optyStage;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
        insert optyStage1;
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                             TRWaySales__I_acknowledge_required__c = true);
        
        insert exitConfig;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
        recordtype caseRTClosed = [select id from recordtype where name ='Elite Closed CPQ Requests' and sobjecttype='Case' limit 1];
        
        Profile p1 = [SELECT Id FROM profile WHERE name='Elite User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                   emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                   localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                   Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01@mydomain.com',Rep_Type_Description__c='test');        
        insert u1;
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account CPQ';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.ECM_Party_ID__c ='1234554321123455432';
        insert gliAccount;
        
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Parent Test Opportunity CPQ';
        gliOpty.is_gli__c = true;
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.OwnerId = u1.Id;
        insert gliOpty;
        
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.Subject = 'CPQ - '+gliOpty.Name;
        gliCase.Status = 'Draft';
        gliCase.OwnerId = gliOpty.OwnerId;
        gliCase.Is_GLI__c = true;
        gliCase.LCRM_Sub_BU__c = gliOpty.LCRM_Sub_BU__c;
        gliCase.Opportunity__c = gliOpty.Id;
        gliCase.AccountID = gliAccount.Id;
        gliCase.RecordTypeId=caseRT.Id;
        insert gliCase;
        
        gliCase.Is_GLI__c = true;
        gliCase.RecordTypeId=caseRT.Id;
        gliCase.Status = 'Client Accepted';
        update gliCase;
        
        Case cccc= [Select id, status, Is_GLI__c, RecordType.DeveloperName from case where Id=: gliCase.Id];
        System.assertEquals(cccc.status,'Client Accepted');
        System.assertEquals(cccc.Is_GLI__c,true);
        System.assertEquals(cccc.RecordType.DeveloperName,'Elite_CPQ_Requests');
    
    }
       
     public static testmethod void testDataSetUp1() {
    
        LTS_Disable_Application_Automation__c ll = new LTS_Disable_Application_Automation__c();
        ll.LTS_Disable_Triggers__c = true;
        ll.LTS_Disable_Workflow_Rules__c = true;
        insert ll;
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
        insert optyStage;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
        insert optyStage1;
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                             TRWaySales__I_acknowledge_required__c = true);
        
        insert exitConfig;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
        recordtype caseRTClosed = [select id from recordtype where name ='Elite Closed CPQ Requests' and sobjecttype='Case' limit 1];
        
        Profile p1 = [SELECT Id FROM profile WHERE name='Elite User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                   emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                   localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                   Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01@mydomain.com',Rep_Type_Description__c='test');        
        insert u1;
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account CPQ';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.ECM_Party_ID__c ='1234554321123455432';
        insert gliAccount;
        
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Parent Test Opportunity CPQ';
        gliOpty.is_gli__c = true;
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.OwnerId = u1.Id;
        insert gliOpty;
        
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.Subject = 'CPQ - '+gliOpty.Name;
        gliCase.Status = 'Draft';
        gliCase.OwnerId = gliOpty.OwnerId;
        gliCase.Is_GLI__c = true;
        gliCase.LCRM_Sub_BU__c = gliOpty.LCRM_Sub_BU__c;
        gliCase.Opportunity__c = gliOpty.Id;
        gliCase.AccountID = gliAccount.Id;
        gliCase.RecordTypeId=caseRTClosed.Id;
        insert gliCase;
        
        gliCase.Is_GLI__c = true;
        gliCase.RecordTypeId=caseRTClosed.Id;
        gliCase.Status = 'Closed';
        update gliCase;
        
        Case cccc= [Select id, status, Is_GLI__c, RecordType.DeveloperName from case where Id=: gliCase.Id];
        System.assertEquals(cccc.status,'Closed');
        System.assertEquals(cccc.Is_GLI__c,true);
        System.assertEquals(cccc.RecordType.DeveloperName,'Elite_Closed_CPQ_Requests');
        
    }
    
}