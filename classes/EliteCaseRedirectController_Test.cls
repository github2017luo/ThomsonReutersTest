@isTest
public class EliteCaseRedirectController_Test{
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
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
        insert optyStage;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
        insert optyStage1;
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                                     TRWaySales__I_acknowledge_required__c = true);
    
        insert exitConfig;
        
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
               
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
        
        
    }
    
    public static testMethod void testRedirectPage(){
    
        Opportunity oppty = [SELECT Id from Opportunity LIMIT 1];
        User usr = [Select Id FROM User WHERE email='user@elite.com' and alias = 'eUser' and employeenumber='0144021'];
        
        PageReference oPage = Page.EliteCaseRedirectPage;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', oppty.Id);
        
        EliteCaseRedirectController controller = new EliteCaseRedirectController();
        Test.startTest();
              system.runAs(usr){
                controller.redirectPage();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
    
    }
    
    public static testMethod void testRedirectPage1(){
    
        Opportunity oppty = [SELECT Id,Name,OwnerId,Is_GLI__c,LCRM_Sub_BU__c from Opportunity LIMIT 1];
        Account acc = [SELECT Id from Account LIMIT 1];
        recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
       
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.Subject = 'CPQ - '+oppty.Name;
        gliCase.Status = 'Draft';
        gliCase.OwnerId = oppty.OwnerId;
        gliCase.Is_GLI__c = oppty.Is_GLI__c;
        gliCase.LCRM_Sub_BU__c = oppty.LCRM_Sub_BU__c;
        gliCase.Opportunity__c = oppty.Id;
        gliCase.AccountID = acc.Id;
        gliCase.RecordTypeId=caseRT.Id;
        insert gliCase;
        
        User usr = [Select Id FROM User WHERE email='user@elite.com' and alias = 'eUser' and employeenumber='0144021'];
        
        PageReference oPage = Page.EliteCaseRedirectPage;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('id', oppty.Id);
        
        EliteCaseRedirectController controller = new EliteCaseRedirectController();
        Test.startTest();
              system.runAs(usr){
                controller.redirectPage();
            }
        Test.stopTest();
    
    }
    
    
 }