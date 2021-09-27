@isTest
public class EliteCPQRequestCancelController_Test{
    @testSetup static void testDataSetUp() {
        
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
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
               
        Profile eliteProfile = [SELECT Id FROM profile WHERE name='Elite User'];
        User eliteUser = new User(alias = 'eUser', email='user@elite.com', 
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = eliteProfile.Id, employeenumber='0144021',
                               timezonesidkey='America/Los_Angeles', username='user@elite.com',Rep_Type_Description__c='testElite');        
        insert eliteUser;
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Is_GLI__c = true;
        /* Commented out for CRM-6072
        gliAccount.Validated_Account__c = true;
        */
        gliAccount.RecordTypeId=accountRT.Id;
        insert gliAccount;
        
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Parent Test Opportunity CPQ';
        gliOpty.StageName = 'Appointment Scheduled';
        gliOpty.is_gli__c = true;
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.OwnerId = eliteUser.Id;
        insert gliOpty;
        
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.Subject = 'CPQ - '+gliOpty.Name;
        gliCase.Status = 'Draft';
        gliCase.OwnerId = gliOpty.OwnerId;
        gliCase.Is_GLI__c = gliOpty.Is_GLI__c;
        gliCase.LCRM_Sub_BU__c = gliOpty.LCRM_Sub_BU__c;
        gliCase.Opportunity__c = gliOpty.Id;
        gliCase.AccountID = gliAccount.Id;
        gliCase.RecordTypeId=caseRT.Id;
        insert gliCase;
        
        
    }
    
    public static testMethod void testCancelCPQRequest(){
    
        Case c = [SELECT Id from Case LIMIT 1];
        c.LCRM_Cancel_Request__c = false;
        update c;
        User usr = [Select Id FROM User WHERE email='user@elite.com' and alias = 'eUser' and employeenumber='0144021'];
        
        Test.startTest();
              system.runAs(usr){
                EliteCPQRequestCancelController.cancelCPQRequest(c.id);
            }
        Test.stopTest();
    
    }
    
    public static testMethod void testCancelCPQRequest1(){
    
        Case c = [SELECT Id from Case LIMIT 1];
        c.LCRM_Cancel_Request__c = true;
        update c;
        User usr = [Select Id FROM User WHERE email='user@elite.com' and alias = 'eUser' and employeenumber='0144021'];
        
        Test.startTest();
              system.runAs(usr){
                EliteCPQRequestCancelController.cancelCPQRequest(c.id);
            }
        Test.stopTest();
    }
}