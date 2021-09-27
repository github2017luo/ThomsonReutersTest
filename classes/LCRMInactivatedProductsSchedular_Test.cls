@isTest
public class LCRMInactivatedProductsSchedular_Test{

    @isTest public static void testNotification(){
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
        
        LCRM_BatchSize__c bs = new LCRM_BatchSize__c(LCRM_NotifyOpportunityTeam__c='200');
        insert bs;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='UKI Users'];   
       User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'UKI',timezonesidkey='America/Los_Angeles', username='User' + Math.random()*100 + '@test.com',Rep_Type_Description__c='test');        
       insert u1;
       User u2 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'UKI',timezonesidkey='America/Los_Angeles', username='User' + Math.random()*100 + '@test.com',Rep_Type_Description__c='test');        
       insert u2;
       User u3 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='fr_CA', 
                           localesidkey='fr_CA', profileid = p1.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'UKI',timezonesidkey='America/Los_Angeles', username='User' + Math.random()*100 + '@test.com',Rep_Type_Description__c='test');        
       insert u3;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Test Account';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
       Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
       gliOpty.Name = 'Test Opportunity';
       gliOpty.is_gli__c = true;
       gliOpty.RecordTypeId = opptyRT.Id;
       gliOpty.OwnerId = u1.Id;
       insert gliOpty;
       
       OpportunityTeamMember opptyMember1 = new OpportunityTeamMember();
       opptyMember1.OpportunityId = gliOpty.id;
       //opptyMember1.OpportunityAccessLevel = 'Read Only';
       opptyMember1.UserId = u2.id;
       insert opptyMember1;
       
       OpportunityTeamMember opptyMember2 = new OpportunityTeamMember();
       opptyMember2.OpportunityId = gliOpty.id;
       //opptyMember2.OpportunityAccessLevel = 'Read Only';
       opptyMember2.UserId = u3.id;
       insert opptyMember2;
       
       Product2 ukiProduct = new Product2();
       ukiProduct.Name = 'Test Product';
       ukiProduct.IsActive = true;
       ukiProduct.LCRM_Sub_Bu__c = 'UKI';
       insert ukiProduct;
       
       Id standardPBId = Test.getStandardPricebookId();
       Pricebook2 customPB = new Pricebook2(Name='Test GLI Pricebook', isActive=true);
       insert customPB;
       
       PricebookEntry pbe1 = new PricebookEntry (Pricebook2Id=standardPBId, Product2Id=ukiProduct.id, IsActive=true, UnitPrice=100.0);
       insert pbe1;
       PricebookEntry pbe2 = new PricebookEntry (Pricebook2Id=customPB.id, Product2Id=ukiProduct.id, IsActive=true, UnitPrice=100.0);
       insert pbe2;
       
       OpportunityLineItem opptyProduct = new OpportunityLineItem();
       opptyProduct.OpportunityId = gliOpty.Id;
       opptyProduct.PricebookEntryId = pbe2.Id;
       opptyProduct.LCRM_Units__c = 5;
       insert opptyProduct;
       
       Test.startTest();
           ukiProduct.IsActive = false;
           update ukiProduct;
           
           LCRMInactivatedProductsSchedular sh = new LCRMInactivatedProductsSchedular();
           String cron = '0 0 0 * * ?'; 
           system.schedule('Test LCRMInactivatedProductsSchedular', cron, sh);
       Test.stopTest();
       System.assert(ukiProduct.LCRM_Inactivated_Date__c==null,ukiProduct.LCRM_Inactivated_Date__c);
    } 
}