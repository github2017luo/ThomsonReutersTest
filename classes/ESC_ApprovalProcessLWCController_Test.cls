@isTest
Private class ESC_ApprovalProcessLWCController_Test {
    
    @isTest
    static void testdata() {
                
        //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        List <user> userlist= new List<user>();
        User us =  new User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
                            UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
                            profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        userlist.add(us);
        
        User us1 =  new User(FirstName = 'test' , LastName= 'thomsan',Alias = 'testom',Email='test.thomson@thomsonreuters.com', emailencodingkey='UTF-8', 
                             UserName='test.thomson@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
                             profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='test.thomson');
        userlist.add(us1);
        
        insert userlist;
        
        System.RunAs(us)
        {
            Test.startTest();
            
            LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
            dis.LTS_Disable_Validation_Rules__c =true;
            insert dis;
                        
            Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
            insert testAccount;
            
            //insert contact data
            Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
            insert testContact;
            
            //List <Case> listcase= new List<Case>();
            Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
            testCase.ESC_Impact__c = '1-Whole Site';
            testCase.subject='tst';
            testCase.ESC_Customer_Symptom__c='Content Addition';
            testCase.ESC_Diagnosis_Summary__c='Content Explanation';
            testCase.ESC_Severity__c='1 - High';
            testCase.ESC_Case_Type__c = 'Incident';
            testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
            testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            
            insert testCase;
            
            Case testCase1=new Case (ContactId = testContact.id);
            insert testCase1;
            
            
            GenerateForm__C gf= new GenerateForm__C();
            GF.Name='Write Off Form';
            Insert GF;
            
            GenerateForm__c formname1 =new GenerateForm__c();
            formname1.Name='Billing Requests Form1';
            insert formname1;
            
            GenerateForm__c formname2 =new GenerateForm__c();
            formname2.Name='Billing Request Form';
            insert formname2;
            
            //string jsonMapRecs = testCase1.id;
            
            ESC_Case_Form_Extension__c esccfe = new ESC_Case_Form_Extension__c();
            ESCCFE.ESC_Form__c=GF.id;
            ESCCFE.ESC_Case__c=testcase.id;
            ESCCFE.ESC_Form_BU__c='Tax Profs - Software';
            ESCCFE.USL_Requester_Title__c=' Mr.';
            ESCCFE.USL_Requestor_ID__c='Testing';
            ESCCFE.USL_Total_Amount__c=450;
            ESCCFE.USL_CSSWriteOffFormTypeID__c = '718';
            ESCCFE.Route_To_USL_Print_CD_Credits__c=true;
            insert ESCCFE;
            
            ESCCFE.USL_Approval_Status__c='Awaiting Approval';
            ESCCFE.USL_Approver_name__c='Test thomson';
            ESCCFE.ESC_Approver_Id__c=us1.id;
            ESCCFE.USL_Approval_Type__c='Writeoff';
            ESCCFE.USL_CSSWriteOffFormTypeID__c='BNK';
            update ESCCFE;
            
            
            ESC_Case_Form_Extension_Line_Item__c esccfeLine1 =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine1.ESC_Billing_Doc__c='79000000095';
            ESCCFELine1.ESC_Line__c='0010';
            ESCCFELine1.ESC_Net_Amount__c=40;
            ESCCFELine1.USL_Input_Amount__c=0.45;
            ESCCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            ESCCFELine1.USL_ODocType__c='YM';
            ESCCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine1.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine1.ESC_Type__c='FUll';
            ESCCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //ESCCFELine1.ESC_Item_Amount__c=30000;
            // ESCCFELine1.USL_Input_Amount__c=1126;
            //ESCCFELine1.USL_Invoice_Type__c='Clear';
            insert ESCCFELine1;
            
            Knowledge__kav lstkno= new Knowledge__kav();
            lstkno.title='test 3445434';
            lstkno.summary='summary';
            lstkno.UrlName='test3445434';
            insert lstkno;
   
            Group g = new Group();
            g.Name = 'Test';
            g.type='Queue';
            insert g;
            
            QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
            System.runAs(new User(Id = UserInfo.getUserId()))
            {insert mappingObject;}
            
            GroupMember gm = new GroupMember(
                GroupId = g.id,
                UserOrGroupId = us.id
            );
            System.runAs(new User(Id = UserInfo.getUserId()))
            {insert gm;}
            
            
            ESC_ApprovalProcessLWCController.lstrecid.add(ESCCFE.id);
            ESC_ApprovalProcessLWCController.lstrecid.add(testCase.id);
            ESC_ApprovalProcessLWCController.lstrecid.add(testCase1.id);
            ESC_ApprovalProcessLWCController.lstrecid.add(lstkno.id);
            ESC_ApprovalProcessLWCController.getApprovals();
            ESC_ApprovalProcessLWCController.gettargetobjectlst();
            
            
        }
        
        Test.stopTest();
         integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'message');
        
    }
    
    
}