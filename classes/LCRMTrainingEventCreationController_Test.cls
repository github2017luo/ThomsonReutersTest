@isTest
public class LCRMTrainingEventCreationController_Test{

@testSetup static void testDataSetUp() {
    
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId');
        insert keyValue;
      //RecordtypeIds__c rt = [SELECT recTypeId__c,Name FROM RecordtypeIds__c WHERE Name ='Pre-Pipeline Opportunities' limit 1];
        //RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        
      RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities');
        insert rt;
         //RecordtypeIds__c rt1 = [SELECT recTypeId__c,Name FROM RecordtypeIds__c WHERE Name ='Pipeline Opportunities' limit 1];
        //RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities');
        insert rt1;
      //RecordtypeIds__c rt2 = [SELECT recTypeId__c,Name FROM RecordtypeIds__c WHERE Name ='LATAM Renewal Opportunity' limit 1];
        //RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
      RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity' );
      insert rt2;
         // RecordtypeIds__c rt3 = [SELECT recTypeId__c,Name FROM RecordtypeIds__c WHERE Name ='GLI Pipeline Opportunity' limit 1]  ; 
        //RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
      RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity');
        insert rt3;
        
    //Profile plist = [SELECT Id,name FROM Profile WHERE Name ='Partner Portal User' limit 1];
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User');
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
        
        FieldId__c fi = new FieldId__c(TrainingEventTabPage__c='/a0K/o');
        insert fi;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
       
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'TR Legal Sales Rep'];
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 
        
        User gliUser;
        System.runAs(new User(Id=UserInfo.getUserId())){       
            gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = ukiProfile.Id;
            gliUser.UserRoleId = ukiRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            insert gliUser;
        
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = gliUser.Id);
            insert psa; 
        }
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account Training Event';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.OwnerId = gliUser.Id;
        insert gliAccount;
       
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Test Opportunity Training Event';
        gliOpty.is_gli__c = true;
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.OwnerId = gliUser.Id;
        insert gliOpty;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
        gliContact.RecordTypeId = conRT.Id;
        gliContact.OwnerId = gliUser.Id;
        insert gliContact;
        
        SFDC_Acct_Plan__c oAccPlan= new SFDC_Acct_Plan__c();
        oAccPlan.name= 'TestPlan';
        oAccPlan.Account__c= gliAccount.id;
        oAccPlan.Account_Type__c= 'New Customer';
        oAccPlan.Planning_Year__c='FY2011';
        oAccPlan.Plan_FY_Product_Sales_Goal__c= 0.0;
        oAccPlan.Plan_Status__c='Not Started';
        oAccPlan.Ownerid= gliUser.Id;
        INSERT oAccPlan;
        
        SFDC_Strategy__c oStrg = new SFDC_Strategy__c();
        oStrg.Name = 'test';
        oStrg.SFDC_Acct_Plan__c= oAccPlan.ID;
        oStrg.Account__c= gliAccount.id;
        oStrg.Strategy_Owning_Group__c= 'Sales';
        oStrg.Strategy_Status__c= 'Not Started';
        oStrg.Est_Comp_Date__c= system.today();
        oAccPlan.Ownerid= gliUser.Id;
        insert oStrg;
        
       Training_Event__c otr= new Training_Event__c();
       otr.Training_Name__c='Training event';
       otr.Strategy__c= oStrg.id;
       oAccPlan.Ownerid= gliUser.Id;
       insert otr;
        
      }
      
     //creating training event from tab
    @isTest public static void testCreateTeFromTab(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        PageReference oPage = Page.LCRMTrainingEventCreation;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventCreationController controller = new LCRMTrainingEventCreationController(new ApexPages.StandardController(new Training_Event__c(Training_Name__c='Test TE')));
        Test.startTest();
            system.runAs(gliUser){
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
        Training_Event__c te = [SELECT Id FROM Training_Event__c LIMIT 1];
        System.assert(te.id!=null,'Training Event not created');
    }
    
    //creating training event from account
    @isTest public static void testCreateTeFromAccount(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Account gliAccount = [SELECT Id FROM Account WHERE Name = 'Test Account Training Event'LIMIT 1];
        
        PageReference oPage = Page.LCRMTrainingEventCreation;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('AccId', gliAccount.Id);
        
        LCRMTrainingEventCreationController controller = new LCRMTrainingEventCreationController(new ApexPages.StandardController(new Training_Event__c(Training_Name__c='Test TE')));
        Test.startTest();
            system.runAs(gliUser){
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
        Training_Event__c te = [SELECT Id FROM Training_Event__c LIMIT 1];
        System.assert(te.id!=null,'Training Event not created');
    }
    
    //creating training event from contact
    @isTest public static void testCreateTeFromContact(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Contact gliContact = [SELECT Id,AccountId FROM Contact LIMIT 1];
        
        PageReference oPage = Page.LCRMTrainingEventCreation;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('AccId', gliContact.AccountId);
        ApexPages.currentPage().getParameters().put('ConId', gliContact.Id);
        
        LCRMTrainingEventCreationController controller = new LCRMTrainingEventCreationController(new ApexPages.StandardController(new Training_Event__c(Training_Name__c='Test TE',LCRM_Primary_Contact__c =gliContact.Id)));
        Test.startTest();
            system.runAs(gliUser){
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
        Training_Event__c te = [SELECT Id FROM Training_Event__c LIMIT 1];
        System.assert(te.id!=null,'Training Event not created');
    }
    
    //creating training event from opportunity
    @isTest public static void testCreateTeFromOpportunity(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Opportunity gliOpty = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        
        PageReference oPage = Page.LCRMTrainingEventCreation;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('AccId', gliOpty.AccountId);
        ApexPages.currentPage().getParameters().put('OppId', gliOpty.Id);
        
        LCRMTrainingEventCreationController controller = new LCRMTrainingEventCreationController(new ApexPages.StandardController(new Training_Event__c(Training_Name__c='Test TE',LCRM_Opportunity__c = gliOpty.Id)));
        Test.startTest();
            system.runAs(gliUser){
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
        Training_Event__c te = [SELECT Id FROM Training_Event__c LIMIT 1];
        System.assert(te.id!=null,'Training Event not created');
    }
    
    //creating training event with exception
    @isTest public static void testCreateTeWithException(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        PageReference oPage = Page.LCRMTrainingEventCreation;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventCreationController controller = new LCRMTrainingEventCreationController(new ApexPages.StandardController(new Training_Event__c()));
        Test.startTest();
            system.runAs(gliUser){
                try{ 
                    controller.save();
                    controller.cancel();
                }
                catch(Exception e){
                    System.assert(e.getMessage().contains('Insert failed.'),e.getMessage());
                }
            }
        Test.stopTest();
    }
    
    
      //#5591 Added by Arti: creating training event from Strategy
    @isTest public static void testCreateTeFromStrategy(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        SFDC_Strategy__c oGLIStrg = [SELECT Id,Account__c  FROM SFDC_Strategy__c where name='test' LIMIT 1];
        Training_Event__c oTrainingEvent= [select id, Strategy__c,Training_Name__c from Training_Event__c where Training_Name__c= 'Training event' limit 1];
        
        PageReference oPage = Page.LCRMTrainingEventCreation;
        Test.setCurrentPage(oPage); 
        ApexPages.currentPage().getParameters().put('StrategyId', oGLIStrg.ID);
        
        LCRMTrainingEventCreationController controller = new LCRMTrainingEventCreationController(new ApexPages.StandardController(new Training_Event__c(Training_Name__c=oTrainingEvent.Training_Name__c,Strategy__c = oGLIStrg.Id)));
        Test.startTest();
            system.runAs(gliUser){
                //controller.StrategyId= oGLIStrg.id;
                List<SFDC_Strategy__c> listStr= [select id, Account__c from SFDC_Strategy__c where id=:oGLIStrg.id];
                controller.save();
                controller.cancel();
                    
              System.assertEquals(listStr.size(),1,'size'); 
              System.assert(oGLIStrg.id!=null,'glistrg');  
              
            }
        Test.stopTest();
      }
}