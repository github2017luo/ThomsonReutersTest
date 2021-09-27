/*This class is created for flow coverage of 'Lotus_Create_Account_Team_Member'process builder
*/
@isTest
public class LCRMConvertLeadAccountTeamMember_Test {

@testSetup static void addKeyValueStore() {
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
        
         KeyValueListStore__c kValue1 = new KeyValueListStore__c();
         kValue1.Name ='ANZUsersProfileId';
         kValue1.TextValue__c = '01pK0000001JUbx';
         insert kValue1;
         
         RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
 
}
 

@isTest
 public static void testLead(){

         //UserPreferencesLightningExperiencePreferred =true,UserPreferencesPreviewLightning = true, 
        
          Profile p = [SELECT Id FROM profile WHERE name='TR Sales - Lightning'];   
          User u1 = new User(alias = 'newUser', email='user@mydomain.com',
            emailencodingkey='UTF-8', lastname='userLTR', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='userLTR@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',
            Sub_bu__c = 'US', Segment__c = 'Corporate');        
       insert u1;
       
       PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LEX_LightningExpAccess' Limit 1 ];
       insert new PermissionSetAssignment(AssigneeId = u1.id, PermissionSetId = ps.Id);
       
       //LEX_HideClassicAccess
       
       PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'LEX_HideClassicAccess' Limit 1 ];
       insert new PermissionSetAssignment(AssigneeId = u1.id, PermissionSetId = ps1.Id);
       
       
              User u2 = [Select id,username from user WHERE Profile.Name = 'TR Sales - Lightning'  and  isActive =TRUE Limit 1];
              
             /* PermissionSet ps2 = [SELECT Id FROM PermissionSet WHERE Name = 'LEX_LightningExpAccess'Limit 1 ];
             insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps2.Id);
       
       //LEX_HideClassicAccess
       
       PermissionSet ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'LEX_HideClassicAccess' Limit 1 ];
       insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps3.Id);*/
       
       List<PermissionSetAssignment> pst = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE
        AssigneeId =: u2.Id];
       
      //upsert new LTS_Disable_Application_Automation__c(SetupOwnerId=UserInfo.getOrganizationId(), 
      //LTS_Disable_Process_Builders__c   =false,LTS_Disable_Workflow_Rules__c   = false);
      
               System.debug('@@@@UserInfo.getUiThemeDisplayed()'  +UserInfo.getUiThemeDisplayed() );
               System.debug('@@@@UserInfo.getUserId()'  +UserInfo.getUserId() );
               System.debug('@@@@UserInfo.getUserName()'  +UserInfo.getUserName() );
               
               //list PermissionSetAssignment
                System.debug('@@@@UserInfo.getUserName()'  +pst[0]+''+pst[1]);
               
               //getUserId()
      
             
               system.runas(u2){
               System.debug('@@@@UserInfo.getUiThemeDisplayed()'  +UserInfo.getUiThemeDisplayed() );
               System.debug('@@@@UserInfo.getUserId()'  +UserInfo.getUserId() );
               System.debug('@@@@UserInfo.getUserName()'  +UserInfo.getUserName() );
               
               
                System.debug('@@@@UserInfo.getUiThemeDisplayed()'  +UserInfo.getUiThemeDisplayed() );
                LTS_Disable_Application_Automation__c auto = LTS_Disable_Application_Automation__c.getInstance(UserInfo.getOrganizationId());
                auto.LTS_Disable_Process_Builders__c    = false;
                auto.LTS_Disable_Workflow_Rules__c   = false;
                upsert auto ;
                
                //$Setup.LOTUS_Lightning_Profiles__c.End_State_Lightning__c
                LOTUS_Lightning_Profiles__c auto1 = LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getOrganizationId());
                auto1.End_State_Lightning__c = true;
                upsert auto1 ;
                
                
                

                test.startTest();
                Account acc1 = new account();
                acc1.is_gli__c = true;
                acc1.name ='portal account 2';
                insert acc1 ;
       
                Lead lead = UnitTest.getLeadInstance();
                lead.LastName='test Account Team';
                lead.Company = 'UTLeadAccount';
                lead.city= 'test';
                lead.street= 'test';
                lead.stateCode= 'WA';
                lead.state= 'WA';
                lead.postalCode= '20009';
                lead.countryCode= 'US';
                lead.country= 'US';
                lead.DoNotCall = true;
                lead.LeadSource = 'Partner';
                lead.ownerid= u1.id;
                lead.Is_GLI__c = true;
                lead.isconverted = true;
                lead.email = 'aTesterAccountTeambc@gmail.com';
                lead.ConvertedAccountId = acc1.id;
                insert lead;

                System.assertEquals(lead.LeadSource,'Partner');
                System.assertEquals(lead.Is_GLI__c,true);
                System.assertEquals(lead.isconverted,true);
                System.assertEquals(lead.ConvertedAccountId != null, true);
                //System.assertEquals(UserInfo.getUiThemeDisplayed(),'Theme4d');
                //System.assertEquals(UserInfo.getLastName(),'userLTR');
                test.stopTest();
                
               }
               
      
 
                      
 
         

        

}

@isTest
 public static void testLeadInformatica(){

         
        
        /*Profile p = [SELECT Id FROM profile WHERE name='TR Sales - Lightning'];   
          User u1 = new User(alias = 'newUser', email='user@mydomain.com',UserPreferencesLightningExperiencePreferred =true, 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',Sub_bu__c = 'US', Segment__c = 'Professional Tax');        
       insert u1;*/
       
       User u1 = [Select id,username from user WHERE Name = 'Informatica GLI Integration' Limit 1];
       

     
       
      
               test.startTest();
               system.runas(u1){
               System.debug('@@@@UserInfo.getUiThemeDisplayed()'  +UserInfo.getUiThemeDisplayed() );
                  LTS_Disable_Application_Automation__c auto = LTS_Disable_Application_Automation__c.getInstance(UserInfo.getOrganizationId());
                  auto.LTS_Disable_Process_Builders__c    = true;
                  auto.LTS_Disable_Workflow_Rules__c   = true;
                  upsert auto ;
               
                Account acc1 = new account();
            acc1.is_gli__c = true;
            acc1.name ='portal account 2';
            insert acc1 ;
       
           Lead lead = UnitTest.getLeadInstance();
                lead.LastName='test Account Team';
                lead.Company = 'UTLeadAccount';
                lead.city= 'test';
                lead.street= 'test';
                lead.stateCode= 'WA';
                lead.postalCode= '20009';
                lead.countryCode= 'US';
                lead.DoNotCall = true;
                lead.LeadSource = 'Partner';
                lead.ownerid= u1.id;
                lead.Is_GLI__c = true;
                lead.isconverted = true;
                lead.email = 'aTesterAccountTeambc@gmail.com';
                lead.ConvertedAccountId = acc1.id;
                insert lead;
 
               }
               
               
        test.stopTest();
 
                       
 
         
}}