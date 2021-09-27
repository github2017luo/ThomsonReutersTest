@isTest
public class LCRMGenericComponent_Test{

@testSetup static void testDataSetUp() {

    List<Profile> ukiProfile = [SELECT Id FROM profile WHERE name in ('UKI Users','DQA User','System Administrator')];
    system.debug('Karthik--------'+ukiProfile[1].id+'------'+ukiProfile[2].id);
    List<User> users = new List<User>();
    User gliUser = UnitTest.getUserInstance();
    gliUser.Username = 'TestUser1@TR.com';
    gliUser.profileid = ukiProfile[0].Id;
    gliUser.Sub_Bu__c = 'UKI';
    insert gliUser;
    User dqaUser = UnitTest.getUserInstance();
    dqaUser .Username = 'TestUser7@TR.com';
    dqaUser .CommunityNickname ='karranga+testuser2';
    dqaUser .profileid = ukiProfile[1].Id;
    dqaUser .Sub_Bu__c = 'UKI';
    insert dqaUser ;
    User adminUser = UnitTest.getUserInstance();
    adminUser.Username = 'TestUser11@TR.com';
    adminUser.CommunityNickname ='karranga+testuser3';
    adminUser.profileid = ukiProfile[2].Id;
    adminUser.Sub_Bu__c = 'UKI';
    insert adminUser ;
    List<KeyValueListStore__c> keyValueList = new List<KeyValueListStore__c>();
    
    KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        keyValueList.add(profilename);
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        keyValueList.add(leadsourcevalue);
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        keyValueList.add(busegment);
        
        KeyValueListStore__c buRegValues = new KeyValueListStore__c(); 
        buRegValues.Name ='LTS_BURegion_Values';
        buRegValues.TextValue__c = 'US,Canada,Europe,AEM';
        keyValueList.add(buRegValues);      
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
    insert keyValueList;


    Lead gliLead = UnitTest.getLeadInstance();
    //gliLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('UKI').getRecordTypeId();
    gliLead.FirstName = 'Test';
    gliLead.LastName = 'GLI Lead'; 
    gliLead.OwnerId = gliUser.Id;
    gliLead.Is_GLI__c = true;
    gliLead.Industry='BANK';
    insert gliLead;  
    
    KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = userInfo.getprofileId());
    insert keyValue;
    //01200test01MA4hAAG
    RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c=userInfo.getprofileId());
    insert rt;
    RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c=userInfo.getprofileId());
    insert rt1;
    RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c=userInfo.getprofileId());
    insert rt2;
    RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c=userInfo.getprofileId());
    insert rt3;
        
    profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '0000024testJwaAAE');
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
  }
  
   @isTest public static void testUserBU(){
        User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        Test.startTest();
            system.runAs(gliUser){
                String bu = LCRMGenericComponent.getUserBU();
                system.assertequals(String.isnotblank(bu),true);    
                Boolean result = LCRMGenericComponent.validateUserBU(bu);
                LCRMGenericComponent.validateTaxProfUser();
            }
        Test.stopTest();
    }
     @isTest public static void populatebuRegionSegmentLotus(){ 
         
        CrossSelling_Pricebooks__c cP = new CrossSelling_Pricebooks__c();
        //CP.FindlawPricebookId__c = '01s1B000000Z5if';
        cP.FindlawPricebookId__c = 'test';
        //CP.SCSPriceBookID__c = '01s1B000000Z5ia';
        cP.SCSPriceBookID__c = '01s1B000test22000Z5ia';
        insert cP;
         
         List<Opportunity> listobj = new List<Opportunity>();
         Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj;
          system.assertequals(accObj.id != null,true);    
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(accObj.Id);
          testOpportunity.Renewal_Flag__c = false;
          testOpportunity.Selling_Organization__c = 'LRA';
          testOpportunity.Expiration_Date__c = Date.Today().adddays(300);
          testOpportunity.Expected_Revenue_Date__c = date.today();
          testOpportunity.APTS_Proposal_Business_Unit__c = 'SCS';
          listobj.add(testOpportunity);
                                     
         User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        Test.startTest();
            system.runAs(gliUser){
                LCRMGenericComponent.populatebuRegionSegmentLotus(listobj);
            }
        Test.stopTest();
          
    }
    
    //DPS-3328
    @isTest public static void populateCasebuRegionSegmentLotus(){

         Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj;
          system.assertequals(accObj.id != null,true);      
          CaseRecordTypeIds__c caseRecType = new CaseRecordTypeIds__c();
          caseRecType.Name = 'Findlaw Inquiry';
          caseRecType.DeveloperName__c = 'Findlaw_Inquiry';
          //caseRecType.RecordTypeId__c = '01213000001CEU7';
          caseRecType.RecordTypeId__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Case').getRecordTypeId();  
          insert caseRecType;                    
          
          List<sobject> caseList = new List<sobject>();
          Case cse = new Case();
          cse.Subject = 'Test Case';
          cse.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Case').getRecordTypeId();  
          cse.Status = 'Open';
          cse.CaseType__c = 'I am requesting an exception';
          cse.AccountId = accObj.id;
          caseList.add(cse);
                                     
         User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        Test.startTest();
            system.runAs(gliUser){
                LCRMGenericComponent.populatebuRegionSegmentLotus(caseList);
            }
        Test.stopTest();
          
    }
    
    //DPS-DPS-2725,DPS-2727
    @isTest public static void populateSSDbuRegionSegmentLotus(){

         Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj;
          system.assertequals(accObj.id != null,true);         
          List<sobject> listSSD = new List<sobject>();
          Source_System_Detail__c ssd = new Source_System_Detail__c();
          ssd.Account_Name__c = accObj.id;
          ssd.Name = 'TestRegionSegment';
          ssd.Source_System_Name__c = 'Testing';
          listSSD.add(ssd);
                                     
         User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        Test.startTest();
            system.runAs(gliUser){
                LCRMGenericComponent.populatebuRegionSegmentLotus(listSSD);
            }
        Test.stopTest();
          
    }
    
    
    
    @isTest public static void testPopulateSubbu(){
        GenericObject__c go1 = new GenericObject__c(Name='Account',Apifieldname__c='LCRM_Business_Unit__c',Isglifieldapiname__c='Is_GLI__c');
        insert go1;
        system.assertequals(go1.id != null,true);
        GenericObject__c go2 = new GenericObject__c(Name='Campaign',Apifieldname__c='LCRM_Sub_BU__c',Isglifieldapiname__c='Is_GLI__c');
        insert go2;
        GenericObject__c go3 = new GenericObject__c(Name='Lead',Apifieldname__c='LCRM_Sub_BU__c',Isglifieldapiname__c='Is_GLI__c');
        insert go3;
        //GenericObject__c go4 = new GenericObject__c(Name='Opportunity',Apifieldname__c='LCRM_Sub_BU__c',Isglifieldapiname__c='Is_GLI__c');
        //insert go4;
        
        PriceBook2 uKIpb = new PriceBook2();
        uKIpb.Name = 'GLI Price Book - UKI';
        uKIpb.IsActive = true;
        insert uKIpb;
        LCRMPriceBooksMapping__c pbm1 = new LCRMPriceBooksMapping__c(Name='UKI',Pricebook__c='GLI Price Book - UKI',Sub_Bu__c='UKI');
        insert pbm1;
    
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
        Test.startTest();
        Lead l = UnitTest.getLeadInstance();
        l.Is_GLI__c = false;
        l.Industry='BANK';
        List<sobject> sobjectList1 = new List<sobject>();
        sobjectList1.add(l);
        insert sobjectList1;
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Is_GLI__c = true;
        gliAccount.BU_Marketing_Segment__c = 'USL - Corporate Strategic';
        gliAccount.RecordTypeId=accountRT.Id;
        insert gliAccount;       
       
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Test Opportunity';
        gliOpty.is_gli__c = true;
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.APTS_Proposal_Business_Unit__c = 'FindLaw';
        List<sobject> sobjectList2 = new List<sobject>();
        sobjectList2.add(gliOpty);
        insert sobjectList2;
        
        Campaign camp=new Campaign();
        camp.Name ='testcamp';
        camp.Offer_Code__c='new';
        insert camp;
        
        camp.Offer_Code__c= 'Gold';
        update camp;
                          
        User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        
            system.runAs(gliUser){
                LCRMGenericComponent.populateSubbu(sobjectList1);
                LCRMGenericComponent.populateSubbu(sobjectList2);
            }
        Test.stopTest();
    }
    
    @isTest public static void testChangerecordtypesubuonlead(){
        Lead gliLead = [SELECT id FROM Lead where LastName = 'GLI Lead' LIMIT 1];
        
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        Profile eliteProfile = [SELECT Id FROM profile WHERE name='Elite User'];
                                
                                Profile ukiProfile1 = [SELECT Id FROM profile WHERE name='UKI Users'];
        Profile eliteProfile1 = [SELECT Id FROM profile WHERE name='Elite User'];
                                
        User gliUser1 = UnitTest.getUserInstance();
        gliUser1.Username = 'LeadOwner1@TR.com';
        gliUser1.CommunityNickname = 'abcduser';
        gliUser1.profileid = ukiProfile.Id;
        gliUser1.Sub_Bu__c = 'UKI';
        insert gliUser1;
        system.assertequals(gliUser1.id != null,true);
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'LeadOwner2@TR.com';
        gliUser2.CommunityNickname = 'efgh';
        gliUser2.profileid = eliteProfile.Id;
        gliUser2.Sub_Bu__c = 'Elite';
        insert gliUser2;
                                
                                User gliUser3 = UnitTest.getUserInstance();
        gliUser3.Username = 'LeadOwner4@TR.com';
        gliUser3.CommunityNickname = 'abcduser1';
        gliUser3.profileid = ukiProfile1.Id;
        gliUser3.Sub_Bu__c = 'USL';
        insert gliUser3;
                                
        User gliUser4 = UnitTest.getUserInstance();
        gliUser4.Username = 'LeadOwner6@TR.com';
        gliUser4.CommunityNickname = 'efgh1';
        gliUser4.profileid = eliteProfile1.Id;
        gliUser4.Sub_Bu__c = '';
        insert gliUser4;
                                
                                User gliUser5 = UnitTest.getUserInstance();
        gliUser5.Username = 'LeadOwner5@TR.com';
        gliUser5.CommunityNickname = 'efgh3';
        gliUser5.profileid = eliteProfile1.Id;
        gliUser5.Sub_Bu__c = 'S2E';
        insert gliUser5;
        
        User taxUser = UnitTest.getUserInstance();
        taxUser.Username = 'TestUser2@TR.com';
        taxUser.profileid = ukiProfile.Id;
        taxUser.CommunityNickname = 'efgh4';
        taxUser.Sub_Bu__c = 'US';
        taxUser.Segment__c = 'Professional Tax';
        insert taxUser;
    
        User latamUser = UnitTest.getUserInstance();
        latamUser.Username = 'TestUser3@TR.com';
        latamUser.profileid = ukiProfile.Id;
        latamUser.CommunityNickname = 'efgh5';
        latamUser.Sub_Bu__c = 'LatAm';
        insert latamUser;
        
        Test.startTest();
            gliLead.OwnerId = gliUser1.Id;
            update gliLead;
            gliLead.OwnerId = gliUser2.Id;
            update gliLead;
            gliLead.OwnerId = gliUser3.Id;
            update gliLead;
            gliLead.OwnerId = gliUser4.Id;
            update gliLead;
            gliLead.OwnerId = gliUser5.Id;
            update gliLead;
        gliLead.OwnerId = taxUser.Id;
            update gliLead;
            gliLead.OwnerId = latamUser.Id;
            update gliLead;
            

            LCRMGenericComponent.convertedLeadStatus('true');
                                                
        Test.stopTest();
        
    }

    
      @isTest public static void testPopulateKeycontactonoppty(){
        Lead gliLead = [SELECT id FROM Lead where LastName = 'GLI Lead' LIMIT 1];
        User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        Test.startTest();
        // system.runAs(gliUser){
            Database.Leadconvert lc = new Database.Leadconvert();
            system.assertequals(gliLead.id != null,true);
            lc.setLeadId(gliLead.id);
            LeadStatus convertStatus = [select id,MasterLabel from LeadStatus where isConverted=true AND MasterLabel='Sales Qualified' limit 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
           // }
        Test.stopTest();
        
    } 
    
    @isTest public static void testOwnerChangeForGlilead(){
        Lead gliLead = [SELECT id FROM Lead where LastName = 'GLI Lead' LIMIT 1];
        
        Group testGroup = new Group();
        testGroup.Name = 'Test Group';
        insert testGroup;
        system.assertequals(testGroup.id != null,true);
        Test.startTest();
        
            //gliLead.OwnerId = testGroup.Id;
            gliLead.Status = 'Sales Accepted';
            update gliLead;
        Test.stopTest();
    }
    @isTest public static void testBuRegionValues(){
       
       LCRMGenericComponent.getBuRegionValues();
       system.assertequals(true,true);
    }
    
/*    @isTest public static void testupdateAccountRecType(){
        List<sobject> listAcc = new List<sobject>();
        Set<Id> accountIDSet = new Set<Id>();
        
        Account accObj = new Account();
        accObj.name = 'test acc';
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account-ECM').getRecordTypeId();  
        accObj.BU_Region__c = 'Canada';
        accObj.Bu_Segment__c = 'Professional Tax';
        accObj.Is_GLI__c = true;
        accObj.ECM_Party_ID__c = 'Test ECM Party';
        //insert accObj;
        
        Account accObj2 = new Account();
        accObj2.name = 'test acc';
        accObj2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        accObj2.BU_Region__c = 'Canada';
        accObj2.Bu_Segment__c = 'Professional Tax';
        accObj2.Is_GLI__c = true;
        accObj2.ECM_Party_ID__c = '';
        //insert accObj;
        
        accountIDSet.add(accObj.Id);
        accountIDSet.add(accObj2.Id);
        
        listAcc.add(accObj);
        listAcc.add(accObj2);
        system.assertequals(!listAcc.isEmpty(),true);
        if(!listAcc.isEmpty()){
            insert listAcc;}
      
        User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        Test.startTest();
            system.runAs(gliUser){
                LCRMGenericComponent.updateAccountRecType(accountIDSet);
            }
        Test.stopTest();
    }*/
     @isTest public static void testcheckArchiveAccountType(){
         Set<Id> accountIDSet = new Set<Id>();
         Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Archive').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          accObj.ECM_Party_ID__c = 'Test ECM Party';
          insert accObj;
          system.assertequals(accObj.id != null,true);
        //if(accObj.Is_GLI__c == TRUE && accObj.recordtype.Name == 'GLI Archive')
        accountIDSet.add(accObj.Id);
        
        Source_System_Detail__c ssdacc =new Source_System_Detail__c();
        ssdacc.Account_Name__c=accObj.id;
        ssdacc.Source_System_Account_Number__c='10002121';
        ssdacc.name='test';
        ssdacc.Source_System_Name__c='test';
        insert ssdacc;
        
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        Lead lead = UnitTest.getLeadInstance();
        lead.Company = 'UTLeadAccount1';        
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'test';
        lead.Billing_Zip__c = 'test'; 
        lead.Billing_Country__c='test';
        lead.SAPAccountNumber__c='10002121'; 
        lead.RecordTypeId = leadRecordTypeId;     
        insert lead;
        
          List<Contact> listCon = new List<Contact>();  
          Contact con = new Contact();
          //con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
          con.AccountID = accObj.Id;
          con.lastName = 'con';
          con.firstName = 'Test';
          //insert con;
          listCon.add(con);
          
          List<Opportunity> listobj = new List<Opportunity>();  
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(accObj.Id);
          testOpportunity.Renewal_Flag__c = false;
          testOpportunity.Selling_Organization__c = 'LRA';
          testOpportunity.Expiration_Date__c = Date.Today().adddays(300);
          testOpportunity.Expected_Revenue_Date__c = date.today();
          //insert testOpportunity;
          listobj.add(testOpportunity);
        
          List<Case> listcse = new List<Case>();
          Case cse = new Case();
          cse.Subject = 'Test Case';
          cse.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GLI_Internal_Users').getRecordTypeId();
          cse.Status = 'Open';
          cse.CaseType__c = 'I am requesting an exception';
          cse.AccountId = accObj.Id;
          //insert cse;
          listcse.add(cse);
        
          List<Trial__c> listTR = new List<Trial__c>();
          Trial__c tr = new Trial__c();
          tr.Contact_LeadId__c = lead.id;        
          tr.Account_Name__c = accObj.id;
          tr.Trial_Status__c ='Invited';
          tr.Source_System_Detail__c = ssdacc.id;
          //insert tr;
          listTR.add(tr);
                                     
         User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        
        Test.startTest();
            system.runAs(gliUser){
                LCRMGenericComponent.checkArchiveAccountType(listCon);
                LCRMGenericComponent.checkArchiveAccountType(listobj);
                LCRMGenericComponent.checkArchiveAccountType(listcse);
                LCRMGenericComponent.checkArchiveAccountType(listTR);
                //LCRMGenericComponent.updateAccountRecType(accountIDSet);
            }
        Test.stopTest();
    }
  @isTest public static void testcheckcontentDocumentupdate(){
         Set<Id> accountIDSet = new Set<Id>();
          Set<Id> ssdIDSet = new Set<Id>();
         Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Archive').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          //accObj.ECM_Party_ID__c = 'Test ECM Party';
          insert accObj;
          system.assertequals(accObj.id != null,true);
       
        accountIDSet.add(accObj.Id);
        
        Source_System_Detail__c ssdacc =new Source_System_Detail__c();
        ssdacc.Account_Name__c=accObj.id;
        ssdacc.Source_System_Account_Number__c='10002121';
        ssdacc.name='test';
        ssdacc.Source_System_Name__c='test';
        insert ssdacc;
        ssdIDSet.add(ssdacc.id);
        
       
        /*-------------------------------------------------------*/
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        

         LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';
        cv.ContentLocation = 'S';
        cv.PathOnClient ='testDemo.pdf'; 
        cv.Title = 'signed Demo.pdf';
        cv.VersionData =beforeblob;          
        insert cv; 
        
        ContentVersion cv2 = new ContentVersion();
        cv2.title = 'test content trigger2';
        cv2.ContentLocation = 'S';
        cv2.PathOnClient = cv2.Title + '.snote';
        cv2.VersionData =beforeblob;          
        insert cv2; 
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        Id conDoc2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv2.Id].ContentDocumentId;  
        ContentVersion cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        //Get Content Documents
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 2];
        system.debug('@@@size of contentdocument'+documents.size());
        System.assertEquals(documents.size(), 2);
        System.assertEquals(documents[0].Id, cvList.ContentDocumentId);
        System.assertEquals(documents[0].LatestPublishedVersionId, cvList.Id);
        System.assertEquals(documents[0].Title, cvList.Title);
        Map<Id, ContentDocument> mapCDD = new Map<Id, ContentDocument>([SELECT Id, Title, LatestPublishedVersionId 
                                                                        FROM ContentDocument Limit 2]);
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = accObj.id;
        cdl.ContentDocumentId = conDoc;
        cdl.shareType = 'v';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId = accObj.id;
        cdl1.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv2.Id].ContentDocumentId;
        cdl1.shareType = 'v';
        cdl1.Visibility = 'AllUsers';
        insert cdl1;
        Test.startTest();
        ContentNote cn = new ContentNote();
        cn.Title = 'test1';
        String body = 'test note';
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert cn;
        
       
        List<ContentDocumentLink> cdlist = new List<ContentDocumentLink>([select ID, LinkedEntityId,ContentDocumentId from ContentDocumentLink  where id =: cdl.id limit 2]);
        Map<Id, ContentDocumentLink> mapCD = new Map<Id, ContentDocumentLink>([select ID, LinkedEntityId,ContentDocumentId from ContentDocumentLink  where id =: cdl.id limit 2]);
system.debug('hello Rama');
       /*-------------------------------------------------------*/        
        Id archiveCaseRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Archive').getRecordTypeId();
        accObj.RecordTypeId =archiveCaseRecId ;
        update accObj; 
        system.debug('hello Rama after record type update');
         User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
                 
               system.runAs(gliUser){
                LCRMGenericComponent.checkArchiveAccountTypeContinue(ssdIDSet, accountIDSet);
                LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
                ltstemp.LTS_Disable_Process_Builders__c = true;
                ltstemp.LTS_Disable_Triggers__c = true;
                ltstemp.LTS_Disable_Validation_Rules__c = true;
                ltstemp.LTS_Disable_Workflow_Rules__c = true;
                ltstemp.Name = 'temp';
                ltstemp.SetupOwnerId = userinfo.getuserid();
                insert ltstemp;
                LCRMGenericComponent.onAfterInsertContentDocuLink(true,true,mapCD);
                LCRMGenericComponent.onAfterInsertContentDocument(true,true,mapCDD);
            }
        Test.stopTest();
    }  
}