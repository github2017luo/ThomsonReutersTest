/*
======================================================================================================================
CLASS NAME:  XREFSObjectFamily_Test
======================================================================================================================
PURPOSE:  code coverage for Trigger GLILoadTrackerAfterEventListener.This class is used for to code coverage 
for Re-parenting of Notes and Attachment of Account, opportunity, Training Event, Case 
using XREF Account, XREF Opportunity, XREF Case, XREF Training Event, newly created Custom Objects. 

JIRA story: CRM-13837 Re parenting of Notes & Attachments across all Objects

Referenced by : XREFAccountFamily_Batch, XREFOpportunityFamily_Batch, XREFCaseFamily_Batch, XREFTrainingEventFamily_Batch
CHANGE HISTORY:
Classes covered:
1. GLILoadTrackerAfterEventListener
2. XREFAccountFamily_Batch
3. XREFOpportunityFamily_Batch
4. XREFCaseFamily_Batch
5. XREFTrainingEventFamily_Batch
6. XREFFamilyHelper_class
======================================================================================================================
DATE           Developer NAME              DESC
22/03/2017      Abhirup Banik             Created
======================================================================================================================
*/
@isTest( seeAllData = false)
public class XREFSObjectFamily_Test {
    @isTest static void testXREFAccountObject() {
        List<Account> Accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        Accountlst.add(oAccountA);
        
        Account oAccountB = UnitTest.getAccountInstance();
        Accountlst.add(oAccountB);
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'];
        User oUser = UnitTest.getUserInstance();
        oUser.ProfileId  = testprofile.id;
        oUser.isActive = false;
        insert oUser;
        
        if(Accountlst.size()>0){
        insert Accountlst;
        }
        Attachment attA=new Attachment();
        Blob b1 = Blob.valueOf('Test Data');  
        attA.ParentId =oAccountA.Id;  
        attA.Name = 'Testing';  
        attA.Body = b1;  
        attA.Description='Test';
        attA.OwnerId = oUser.Id;
        insert attA;
        
        Note noteA=new Note();  
        noteA.ParentId =oAccountA.Id;  
        noteA.Title = 'Testing';  
        noteA.Body = 'Test Note';  
        noteA.OwnerId = oUser.Id;
        insert noteA;
        
        XREF_Account_Family__c xa = new XREF_Account_Family__c();
        xa.Old_Id__c = (String)oAccountA.Id;
        xa.New_Id__c = (String)oAccountB.Id;
        insert xa;
        
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
        cs.Name ='XREFAccountFamily_Batch';
        cs.Object__c ='Account';
        cs.Batch_Size__c = 200 ;
        insert cs;
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Account Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest();   
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        Update gliloadtracker;   
        Test.StopTest(); 
        
        Note noteB = [Select Id,ParentId,Title from Note where ParentId = :oAccountB.id limit 1];
        System.assertEquals(NoteB.Title, NoteA.Title);
    }
    @isTest static void testXREFCaseObject() {
        List<Case> Caselst = new List<Case>();
        Case oCaseA = UnitTest.getCaseInstance();
        Caselst.add(oCaseA);
        
        Case oCaseB = UnitTest.getCaseInstance();
        Caselst.add(oCaseB);
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'];
        User oUser = UnitTest.getUserInstance();
        oUser.ProfileId  = testprofile.id;
        oUser.isActive = true;
        insert oUser;
        
        if(Caselst.size()>0){
        insert Caselst;
        }
        
        
        Attachment attA=new Attachment();
        Blob b1 = Blob.valueOf('Test Data');  
        attA.ParentId =oCaseA.Id;  
        attA.Name = 'Testing';  
        attA.Body = b1;  
        attA.Description='Test';
        attA.OwnerID = oUser.id;
        insert attA;
                        
        XREF_Case_Family__c xa = new XREF_Case_Family__c();
        xa.Old_Id__c = (String)oCaseA.Id;
        xa.New_Id__c = (String)oCaseB.Id;
        insert xa;
        
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
        cs.Name ='XREFCaseFamily_Batch';
        cs.Object__c ='Case';
        cs.Batch_Size__c = 200 ;
        insert cs;
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Case Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest();   
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        Test.StopTest(); 
        Attachment attB = [Select Id,ParentId,Name from Attachment where ParentId = :oCaseB.id limit 1];
        System.assertEquals(attB.Name, attA.Name);
    }
    
     @isTest static void testXREFTrainingEventObject() {         
        List<Training_Event__c > TrainingEventlst = new List<Training_Event__c >();
        Training_Event__c  oteA = UnitTest.getTrainingEventInstance();
        TrainingEventlst.add(oteA);
        
        Training_Event__c  oteB = UnitTest.getTrainingEventInstance();
        TrainingEventlst.add(oteB);
        
        if(TrainingEventlst.size()>0){
        insert TrainingEventlst;
        }
        Attachment attA=new Attachment();
        Blob b1 = Blob.valueOf('Test Data');  
        attA.ParentId =oteA.Id;  
        attA.Name = 'Testing';  
        attA.Body = b1;  
        attA.Description='Test';
        insert attA;
        
        Note noteA=new Note();  
        noteA.ParentId =oteA.Id;  
        noteA.Title = 'Testing';  
        noteA.Body = 'Test Note';  
        insert noteA;
                
        XREF_TrainingEvent_Family__c xa = new XREF_TrainingEvent_Family__c();
        xa.Old_Id__c = (String)oteA.Id;
        xa.New_Id__c = (String)oteB.Id;
        insert xa;
        
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
        cs.Name ='XREFTrainingEventFamily_Batch';
        cs.Object__c ='Training Event';
        cs.Batch_Size__c = 200 ;
        insert cs;
        
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF TrainingEvent Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest();   
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        Test.StopTest(); 
         
        Attachment attB = [Select Id,ParentId,Name from Attachment where ParentId = :oteB.id limit 1];
        System.assertEquals(attB.Name, attA.Name);
    }
    
    //
    @isTest static void testXREFOpptyObject() {
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
        // KeyValueListStore__c Insert All for update Some Fields When Oppty Closed Lost
        List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        //For Opportunity
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);

        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);

        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'LCRM Oppty Competitor?';
        KeyvalueStore2.TextValue__c = 'No';
        lstOfKeyStore.add(KeyvalueStore2);
        //End Opportunity

        //For Task type
        KeyValueListStore__c KeyTaskvalueSt = new KeyValueListStore__c();
        KeyTaskvalueSt.name='LCRM Task Type';
        KeyTaskvalueSt.TextValue__c='To Do';
        lstOfKeyStore.add(KeyTaskvalueSt);
        //Task Status
        KeyValueListStore__c KeyTaskstatusval = new KeyValueListStore__c();
        KeyTaskstatusval.name='LCRM Task Status';
        KeyTaskstatusval.TextValue__c='In Progress';
        lstOfKeyStore.add(KeyTaskstatusval);
        //Task Subject
        KeyValueListStore__c KeyTaskSubval = new KeyValueListStore__c();
        KeyTaskSubval.name='LCRM Task Subject';
        KeyTaskSubval.TextValue__c='Please update Customer Cancellation Reason and optional Competitor information on the Opportunity Win/Loss information.';
        lstOfKeyStore.add(KeyTaskSubval);
        //Task Priority
        KeyValueListStore__c KeyTaskPrival = new KeyValueListStore__c();
        KeyTaskPrival.name='LCRM Task Priority';
        KeyTaskPrival.TextValue__c='Normal';
        lstOfKeyStore.add(KeyTaskPrival);
        //Task Value End
        //OpportunityLineIteam Action
        KeyValueListStore__c KeyOpptyProdActionVal = new KeyValueListStore__c();
        KeyOpptyProdActionVal.name='LCRM Oppty Prod Action';
        KeyOpptyProdActionVal.TextValue__c='Cancel';
        lstOfKeyStore.add(KeyOpptyProdActionVal);
        //OpportunityLineIteam LCRM_Cancel_Reason

        KeyValueListStore__c KeyOpptyProdRes = new KeyValueListStore__c();
        KeyOpptyProdRes.name='LCRM Oppty Prod CancelReason';
        KeyOpptyProdRes.TextValue__c='Billing System Cancellation';
        lstOfKeyStore.add(KeyOpptyProdRes);
        //End OpportunityLine Iteam

        if(lstOfKeyStore.size()>0){ 
            insert lstOfKeyStore;
        }
        //
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;

        //
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;        
        //Standard PricebookEntry 
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //
        System.assertEquals(testEntry1.pricebook2id, customPB.id);
        //
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];

        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 

        User gliUser;
        System.runAs(new User(Id=UserInfo.getUserId())){       
            gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = ukiProfile.Id;
            gliUser.UserRoleId = ukiRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            insert gliUser;

        }
        List<Account> Acclist = new list<Account>(); 
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account Training Event';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.OwnerId = gliUser.Id;
        Acclist.add( gliAccount);

        //
        Account gliAccountB = UnitTest.getAccountInstance();
        gliAccountB.Name = 'Test Account';
        gliAccountB.Is_GLI__c = true;
        gliAccountB.RecordTypeId=accountRT.Id;
        gliAccountB.OwnerId = gliUser.Id;
        Acclist.add( gliAccountB);

        if(!Acclist.isempty()){
        insert Acclist;
        }

        Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
        gliContact.RecordTypeId = conRT.Id;
        gliContact.OwnerId = gliUser.Id;
        insert gliContact;

        System.assertEquals(gliContact.AccountId, gliAccount.id);

        List<Opportunity> OpptyList = new  List<Opportunity>();

        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Test Opportunity Training Event';
        gliOpty.Key_Contact__c = gliContact.id;
        gliOpty.Renewal_Flag__c = true;
        gliOpty.currencyIsoCode = 'USD';
        gliOpty.StageName = 'Needs Analysis';
        gliOpty.LCRM_Status__c = 'Cancelled'; 
        gliOpty.LCRM_Cancellation_Process__c = false;
        gliOpty.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOpty.is_gli__c = true;
        gliOpty.LCRM_Sub_BU__c='UKI';
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.CurrencyIsoCode = 'USD';
        gliOpty.Expiration_Date__c=Date.Today();
        gliOpty.OwnerId = gliUser.Id;
        System.debug('gliOpty : '+gliOpty);
        OpptyList.add(gliOpty);
        //insert gliOpty;

        //

        //Opportunity Product   
        Opportunity gliOptyRenew = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOptyRenew.Name = 'Oppty Renewal Cancellation';
        gliOptyRenew.Key_Contact__c = gliContact.id;
        gliOptyRenew.Renewal_Flag__c = true;
        gliOptyRenew.currencyIsoCode = 'USD';
        gliOptyRenew.StageName = 'Closed Lost';
        gliOptyRenew.Win_Loss__c='Lost';
        gliOptyRenew.Reason__c='Other';
        gliOptyRenew.Was_There_a_Competitor__c ='No';

        gliOptyRenew.LCRM_Status__c = 'Open'; 
        gliOptyRenew.LCRM_Cancellation_Process__c = false;
        gliOptyRenew.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOptyRenew.is_gli__c = true;
        gliOptyRenew.LCRM_Sub_BU__c='UKI';
        gliOptyRenew.RecordTypeId = opptyRT.Id;
        gliOptyRenew.CurrencyIsoCode = 'USD';
        gliOptyRenew.Expiration_Date__c=Date.Today();
        gliOptyRenew.OwnerId = gliUser.Id;
        System.debug('gliOptyRenew : '+gliOptyRenew);
        OpptyList.add(gliOptyRenew);

        //Pending Cancel Status
        Opportunity gliOptyPendingCancel = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOptyPendingCancel.Name = 'Test Opportunity Training Event';
        gliOptyPendingCancel.Key_Contact__c = gliContact.id;
        gliOptyPendingCancel.Renewal_Flag__c = true;
        gliOptyPendingCancel.currencyIsoCode = 'USD';
        gliOptyPendingCancel.StageName = 'Needs Analysis';
        gliOptyPendingCancel.LCRM_Status__c = 'Pending Cancel'; 
        gliOptyPendingCancel.LCRM_Cancellation_Process__c = false;
        gliOptyPendingCancel.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOptyPendingCancel.is_gli__c = true;
        gliOptyPendingCancel.LCRM_Sub_BU__c='UKI';
        gliOptyPendingCancel.RecordTypeId = opptyRT.Id;
        gliOptyPendingCancel.CurrencyIsoCode = 'USD';
        gliOptyPendingCancel.Expiration_Date__c=Date.Today();
        gliOptyPendingCancel.OwnerId = gliUser.Id;
        System.debug('gliOptyPendingCancel : '+gliOptyPendingCancel);
        OpptyList.add(gliOptyPendingCancel);

        //check size of Opportunity
        if(OpptyList.size()>0){
            insert OpptyList;
        }
        System.debug('OpptyList:-'+OpptyList);
        
        
        Attachment attA=new Attachment();
        Blob b1 = Blob.valueOf('Test Data');  
        attA.ParentId =gliOpty.Id;  
        attA.Name = 'Testing';  
        attA.Body = b1;  
        attA.Description='Test';
       insert attA;

        Note noteA=new Note();  
        noteA.ParentId =gliOpty.Id;  
        noteA.Title = 'Testing';  
        noteA.Body = 'Test Note';  
        insert noteA;

        XREF_Opportunity_Family__c xa = new XREF_Opportunity_Family__c();
        xa.Old_Id__c = (String)gliOpty.Id;
        xa.New_Id__c = (String)gliOptyRenew.Id;
        insert xa;
        
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
            cs.Name ='XREFOpportunityFamily_Batch';
            cs.Object__c ='Opportunity';
            cs.Batch_Size__c = 200 ;
            insert cs;
            
        try{
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Opportunity Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest();   
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker;      
        Test.StopTest(); 
        }catch(exception Ex){
            System.debug('Error:-'+Ex);
        }
        
    }//End class
    
    @isTest static void testXREFExceptionObject() {
        User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        
        
        List<Account> Accountlst = new List<Account>();
        Account oAccountA = UnitTest.getAccountInstance();
        Accountlst.add(oAccountA);
        
        Account oAccountB = UnitTest.getAccountInstance();
        Accountlst.add(oAccountB);
        
        
        if(Accountlst.size()>0){
         insert Accountlst;
        }
        
        Attachment attA=new Attachment();
        Blob b1 = Blob.valueOf('Test Data');  
        attA.ParentId =oAccountA.Id;  
        attA.Name = 'Testing';  
        attA.Body = b1;  
        attA.Description='Test';
        attA.OwnerId = testUser.Id;
        insert attA;
        
        Note noteA=new Note();  
        noteA.ParentId =oAccountA.Id;  
        noteA.Title = 'Testing';  
        noteA.Body = 'Test Note';  
        noteA.OwnerId = testUser.Id;
        insert noteA;
        
        
        try{
        List<XREF_Account_Family__c> xacc= new List<XREF_Account_Family__c>();
        XREF_Account_Family__c xa = new XREF_Account_Family__c();
        xa.Old_Id__c = (String)oAccountA.Id;
        xa.New_Id__c = 'a123124VC0081254xz';
        xacc.add(xa);   
        if(xacc.size()>0){
            insert xacc;
        }
        testUser.IsActive= true;
        update testUser;
        
        LCRM_BatchsizeDefine__c cs = new LCRM_BatchsizeDefine__c();
        cs.Name ='XREFAccountFamily_Batch';
        cs.Object__c ='Account';
        cs.Batch_Size__c = 200 ;
        insert cs;
            
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica XREF Account Family Load';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest();   
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 10, 16, 11, 30, 0);
        Update gliloadtracker;
        Test.StopTest();
        //System.assert(e, msg)
        }catch(Exception ex){
            System.debug('error:-'+ex);
        }
 
    }//end method

}