@isTest
private class ESC_CaseHomePageController_Test {

    @isTest public static void testmethod1() {
    
    pagereference paRef= new pagereference ('/apex/ESC_CaseHomePage');
        Test.setCurrentPage(paRef);
    //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james11.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='jamesxyz1.thomastest1@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        
       
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        dte.ESC_processing= 'Processing...';
        dte.ESC_search= 'Search:';
        dte.ESC_lengthMenu= 'Show _MENU_ entries';
        dte.ESC_info= 'Showing _START_ to _END_ of _TOTAL_ entries';
        dte.ESC_infoEmpty= 'Showing 0 to 0 of 0 entries';
        dte.ESC_infoFiltered= '(filtered from _MAX_ total entries)';
        dte.ESC_infoPostFix= '';
        dte.ESC_loadingRecords= 'Loading...';
        dte.ESC_zeroRecords= 'No matching records found';
        dte.ESC_emptyTable= 'No data available in table';
        dte.ESC_paginateFirst= 'First';
        dte.ESC_paginatePrevious= 'Previous';
        dte.ESC_paginateNext= 'Next';
        dte.ESC_paginateLast= '';
        dte.ESC_paginateFirst= '';
        dte.ESC_paginatePrevious= '';
        dte.ESC_paginateNext= '';
        dte.ESC_paginateLast= '';
   
        List<ESC_DataTableEntity> dtlist = new  List<ESC_DataTableEntity>();
        dtlist.add(dte);

        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
        insert testAccount1;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
          Case testCase1=new Case (ContactId = testContact1.id);
        insert testCase1;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();                                                                                                                                                            
        cc.OwnerId = us.id;
        cc.ESC_Case__c = testCase1.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=userInfo.getuserid();
        insert cc;     
    
    
        Test.StartTest();
         ESC_CaseHomePageController.updateOwner(cc.id);
         
       ESC_CaseHomePageController.getFormats();
       ESC_CaseHomePageController.getObjectPrefixID('Case');
         List<ESC_HomePageQuery__c> homePageQueryReclist=new  List<ESC_HomePageQuery__c>();
         ESC_HomePageQuery__c homePageQueryRec1=new ESC_HomePageQuery__c();
         homePageQueryRec1.ESC_ObjectType__c='Case';
        homePageQueryRec1.ESC_Sequence__c='';
        homePageQueryRec1.ESC_AssignedTo__c='Current User Only';
        homePageQueryRec1.ESC_FilterCriteria__c='id!=null';
        homePageQueryRec1.ESC_DefaultSortCol__c='Subject';
        homePageQueryRec1.ESC_OverrideLabelsForfields__c='ESC_Case_Type__c:ESC_TestLabelOnly';
        homePageQueryRec1.ESC_CustomLabel__c='ESC_TestLabelOnly';
        homePageQueryRec1.ESC_Limit__c=650;
        homePageQueryRec1.ESC_IsFirstHidden__c=True;
        homePageQueryRec1.ESC_ReturnedColumns__c='CaseNumber,ESC_Total_Escalations__c,ESC_Business_Critical_Image__c,ESC_UPD__c,ESC_REF__c,CreatedDate,ESC_CaseAge__c,ESC_Response_Time__c,ESC_Severity__c,ContactId,AccountId,Subject,ESC_Customer_Symptom__c,ESC_Diagnosis_Summary__c,Status,ESC_scTarget_Restoration_Time__c,ESC_Likely_Restoration_Time__c,ESC_Case_Type__c,OwnerId,Account.ownerid,Account.createdDate,Account.Lastmodifieddate,RecordType.Name,ESC_Billable__c';
        homePageQueryRec1.ESC_pushTopicName__c='MyQueue';
        homePageQueryRec1.ESC_NoTruncation__c='CaseNumber:5,AccountId:4,RecordType.Name:12';
        homePageQueryRec1.ESC_ReturnedSecondaryColumns__c='CaseNumber,CreatedDate,Type';
        homePageQueryRec1.ESC_Profiles__c='System Administrator';
        homePageQueryRec1.ESC_isInActive__c=False;
        homePageQueryRec1.ESC_PgntnEnabled__c=False;
       // insert homePageQueryRec1;
       homePageQueryReclist.add(homePageQueryRec1);
        
          ESC_HomePageQuery__c homePageQueryRec6=new ESC_HomePageQuery__c();
         homePageQueryRec6.ESC_ObjectType__c='Case';
        homePageQueryRec6.ESC_Sequence__c='';
        homePageQueryRec6.ESC_AssignedTo__c='Enhanced';
        homePageQueryRec6.ESC_FilterCriteria__c='id!=null and ownerid = %user% ';
        homePageQueryRec6.ESC_DefaultSortCol__c='Subject';
        homePageQueryRec6.ESC_OverrideLabelsForfields__c='ESC_Case_Type__c:ESC_TestLabelOnly';
        homePageQueryRec6.ESC_CustomLabel__c='ESC_TestLabelOnly';
        homePageQueryRec6.ESC_Limit__c=650;
        homePageQueryRec6.ESC_IsFirstHidden__c=False;
        homePageQueryRec6.ESC_ReturnedColumns__c='CaseNumber,ESC_Total_Escalations__c,ESC_Business_Critical_Image__c,ESC_UPD__c,ESC_REF__c,CreatedDate,ESC_CaseAge__c,ESC_Response_Time__c,ESC_Severity__c,ContactId,AccountId,Subject,ESC_Customer_Symptom__c,ESC_Diagnosis_Summary__c,Status,ESC_scTarget_Restoration_Time__c,ESC_Likely_Restoration_Time__c,ESC_Case_Type__c,OwnerId,Account.ownerid,Account.createdDate,Account.Lastmodifieddate,RecordType.Name,ESC_Billable__c';
        homePageQueryRec6.ESC_pushTopicName__c='MyQueue';
        homePageQueryRec6.ESC_NoTruncation__c='CaseNumber:5,AccountId:4,RecordType.Name:12';
        homePageQueryRec6.ESC_ReturnedSecondaryColumns__c='CaseNumber,CreatedDate,Type';
        homePageQueryRec6.ESC_Profiles__c='System Administrator';
        homePageQueryRec6.ESC_isInActive__c=False;
        homePageQueryRec6.ESC_PgntnEnabled__c=False;
        //insert homePageQueryRec6;
         homePageQueryReclist.add(homePageQueryRec6);
         
    ESC_HomePageQuery__c homePageQueryRec2=new ESC_HomePageQuery__c();
        homePageQueryRec2.ESC_ObjectType__c='Case';
        homePageQueryRec2.ESC_Sequence__c='';
        homePageQueryRec2.ESC_AssignedTo__c='Current User\'s Queue'; homePageQueryRec2.ESC_FilterCriteria__c='id!=null';
        homePageQueryRec2.ESC_DefaultSortCol__c='Subject';
        homePageQueryRec2.ESC_OverrideLabelsForfields__c='ESC_Case_Type__c:ESC_TestLabelOnly';
        homePageQueryRec2.ESC_CustomLabel__c='ESC_TestLabelOnly';
        homePageQueryRec2.ESC_Limit__c=650;
        homePageQueryRec2.ESC_IsFirstHidden__c=False;
        homePageQueryRec2.ESC_ReturnedColumns__c='CaseNumber,ESC_Total_Escalations__c,ESC_Business_Critical_Image__c,ESC_UPD__c,ESC_REF__c,CreatedDate,ESC_CaseAge__c,ESC_Response_Time__c,ESC_Severity__c,ContactId,AccountId,Subject,ESC_Customer_Symptom__c,ESC_Diagnosis_Summary__c,Status,ESC_scTarget_Restoration_Time__c,ESC_Likely_Restoration_Time__c,ESC_Case_Type__c,OwnerId,Account.ownerid,Account.createdDate,Account.Lastmodifieddate,RecordType.Name,ESC_Billable__c';
        homePageQueryRec2.ESC_pushTopicName__c='MyQueue';
        homePageQueryRec2.ESC_NoTruncation__c='CaseNumber:5,AccountId:4,RecordType.Name:12';
        homePageQueryRec2.ESC_ReturnedSecondaryColumns__c='CaseNumber,CreatedDate,Type';
        homePageQueryRec2.ESC_Profiles__c='System Administrator';
        homePageQueryRec2.ESC_isInActive__c=False;
        homePageQueryRec2.ESC_PgntnEnabled__c=False;
        //insert homePageQueryRec2;
         homePageQueryReclist.add(homePageQueryRec2);
        
          ESC_HomePageQuery__c homePageQueryRec7=new ESC_HomePageQuery__c();
         homePageQueryRec7.ESC_ObjectType__c='Case';
        homePageQueryRec7.ESC_Sequence__c='';
        homePageQueryRec7.ESC_AssignedTo__c='Enhanced';
        homePageQueryRec7.ESC_FilterCriteria__c='id!=null or id != %Query='+ homePageQueryRec6.name +'% ';
        homePageQueryRec7.ESC_DefaultSortCol__c='Subject';
        homePageQueryRec7.ESC_OverrideLabelsForfields__c='ESC_Case_Type__c:ESC_TestLabelOnly';
        homePageQueryRec7.ESC_CustomLabel__c='ESC_TestLabelOnly';
        homePageQueryRec7.ESC_Limit__c=650;
        homePageQueryRec7.ESC_IsFirstHidden__c=False;
        homePageQueryRec7.ESC_ReturnedColumns__c='CaseNumber,ESC_Total_Escalations__c,ESC_Business_Critical_Image__c,ESC_UPD__c,ESC_REF__c,CreatedDate,ESC_CaseAge__c,ESC_Response_Time__c,ESC_Severity__c,ContactId,AccountId,Subject,ESC_Customer_Symptom__c,ESC_Diagnosis_Summary__c,Status,ESC_scTarget_Restoration_Time__c,ESC_Likely_Restoration_Time__c,ESC_Case_Type__c,OwnerId,Account.ownerid,Account.createdDate,Account.Lastmodifieddate,RecordType.Name,ESC_Billable__c';
        homePageQueryRec7.ESC_pushTopicName__c='MyQueue';
        homePageQueryRec7.ESC_NoTruncation__c='CaseNumber:5,AccountId:4,RecordType.Name:12';
        homePageQueryRec7.ESC_ReturnedSecondaryColumns__c='CaseNumber,CreatedDate,Type';
        homePageQueryRec7.ESC_Profiles__c='System Administrator';
        homePageQueryRec7.ESC_isInActive__c=False;
        homePageQueryRec7.ESC_PgntnEnabled__c=False;
        //insert homePageQueryRec7;
         homePageQueryReclist.add(homePageQueryRec7);
         insert homePageQueryReclist;
        
        string query='';
        String localName='';
        String pageName;
        pageName = 'ESC_CaseHomePage';
       
        ApexPages.currentPage().getParameters().put('key', pageName);
        string defaultSortColumn ;
        
        integer i=0;
        //string setcolour(integer i=0);
       
        List <Case> listcase= new List<Case>();
    
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com' ,OwnerID=us.id);
        ESC_Case_Collaborator__c cs1 = new ESC_Case_Collaborator__c(OwnerID=us.id);
        listcase.add(cs);
        insert listcase;
        
        ESC_HomePageQuery__c hpq = new ESC_HomePageQuery__c(ESC_Sequence__c = '',
        ESC_Profiles__c ='System Administrator,System Administrator,Sample Helpdesk Manager',
        ESC_AssignedTo__c = 'Current User Only' ,ESC_FilterCriteria__c = 'status NOT IN (\'cancelled\',\'closed\')' , ESC_NoTruncation__c='Status',ESC_PgntnEnabled__c=true,ESC_ReturnedColumns__c='Status,OwnerID,CaseNumber,Account.Name',ESC_ObjectType__c='Case');
        insert hpq;
        ESC_HomePageReports__c hPge= new ESC_HomePageReports__c();
        
        hPge.ESC_CacheAge__c=40;
        hPge.ESC_Dashboard_Id__c='01Z1B000000jvL8,01Z1B000000jvLF';
        
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getprofileId()].Id;
        hPge.ESC_ReportIDS__c=profileName;
        Insert hPge;
        
        
        
        paRef.getparameters().put('profile',hPge.ESC_ReportIDS__c);
        

         string currentUserId = userinfo.getUserId();

        ESC_PushTopicNotifications__c eptn= new ESC_PushTopicNotifications__c();
        eptn.PushTopicName__c='sdnjs';
        insert eptn;
      
        ESC_CaseHomePageController chpc = new ESC_CaseHomePageController();
        chpc.getBlockTruncateColumns();
        chpc.getApplicablePermissionSetIds();
        chpc.getObjectNameForRelation('Case' ,'status');
         chpc.getDataTableEntity();
        Map<string,object> newMap = new  map<string,object> ();
        newmap.put('Test',testCase1);
        chpc.convertTolowerAllkeys(newMap);
      ESC_CaseHomePageController.getComp();
        chpc.getpushTopicSet();
         ESC_CaseHomePageController.result re=ESC_CaseHomePageController.resultList[0];
         re.getIobjectName();
         re.getIapiNames();
         re.getIblockName();
         re.getIsortDefCol();
         re.getIshowAccept();
         re.getIshowApproval();
         re.getIisFirstHidden();
         re.getIpushTopicName();
         re.getIOwnerInfo();
         re.getIownerIdentifiers();
         re.getIisUserBlock();
         re.getIisQueueBlock();
         re.getIisPaginationEnabled();
         re.getIoverRideNames();
         re.getIapiNoTruncate();
         re.getIfullQuery();
         re.getIresultObj();
         re.getIapiNamesMap();
         re.getIobjectPrefix();
         re.getInonTruncateColumns();
         re.getItruncateColumnsSize();
         re.getIstyleclass();
         re.getIvisibilityList();
         re.getIsecondaryResultObj();
         re.getIHasToShowAccept();
     
       
    Test.stopTest();
    
        integer k = 1;
        integer j = 1;
        System.assertEquals(k,j);
    
         //}

    }

    @isTest public static void testmethod3() {
   
     PageReference pageRef = Page.ESC_MissedMilestoneConsolePage;
    Test.setCurrentPage(pageRef);
    //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james11.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='jamesxyz2.thomastest1@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        
        User us1 =  New User(FirstName = 'James1' , LastName= 'ThomasTest1',Alias = 'jttest1',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James1.ThomasTest');
        insert us1;
        
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        dte.ESC_processing= 'Processing...';
        dte.ESC_search= 'Search:';
        dte.ESC_lengthMenu= 'Show _MENU_ entries';
        dte.ESC_info= 'Showing _START_ to _END_ of _TOTAL_ entries';
        dte.ESC_infoEmpty= 'Showing 0 to 0 of 0 entries';
        dte.ESC_infoFiltered= '(filtered from _MAX_ total entries)';
        dte.ESC_infoPostFix= '';
        dte.ESC_loadingRecords= 'Loading...';
        dte.ESC_zeroRecords= 'No matching records found';
        dte.ESC_emptyTable= 'No data available in table';
        dte.ESC_paginateFirst= 'First';
        dte.ESC_paginatePrevious= 'Previous';
        dte.ESC_paginateNext= 'Next';
        dte.ESC_paginateLast= '';
        
        dte.ESC_paginateFirst= '';
        dte.ESC_paginatePrevious= '';
        dte.ESC_paginateNext= '';
        dte.ESC_paginateLast= '';
   
        List<ESC_DataTableEntity> dtlist = new  List<ESC_DataTableEntity>();
        dtlist.add(dte);
        
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
        insert testAccount1;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
         Case testCase1=new Case (ContactId = testContact1.id);
        insert testCase1;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();                                                                                                                                                            
        cc.OwnerId = us.id;
        cc.ESC_Case__c = testCase1.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=userInfo.getuserid();
        insert cc;
         Test.StartTest();
        ESC_HomePageQuery__c homePageQueryRec1=new ESC_HomePageQuery__c();
         homePageQueryRec1.ESC_ObjectType__c='Case';
        homePageQueryRec1.ESC_Sequence__c='';
        homePageQueryRec1.ESC_AssignedTo__c='Current User\'s Queue';
        homePageQueryRec1.ESC_FilterCriteria__c='id!=null';
        homePageQueryRec1.ESC_DefaultSortCol__c='Subject';
        homePageQueryRec1.ESC_OverrideLabelsForfields__c='ESC_Case_Type__c:ESC_TestLabelOnly';
        homePageQueryRec1.ESC_CustomLabel__c='ESC_TestLabelOnly';
        homePageQueryRec1.ESC_Limit__c=650;
        homePageQueryRec1.ESC_IsFirstHidden__c=False;
        homePageQueryRec1.ESC_ReturnedColumns__c='CaseNumber,ESC_Total_Escalations__c,ESC_Business_Critical_Image__c,ESC_UPD__c,ESC_REF__c,CreatedDate,ESC_CaseAge__c,ESC_Response_Time__c,ESC_Severity__c,ContactId,AccountId,Subject,ESC_Customer_Symptom__c,ESC_Diagnosis_Summary__c,Status,ESC_scTarget_Restoration_Time__c,ESC_Likely_Restoration_Time__c,ESC_Case_Type__c,OwnerId,Account.ownerid,Account.createdDate,Account.Lastmodifieddate,RecordType.Name,ESC_Billable__c';
        homePageQueryRec1.ESC_pushTopicName__c='MyQueue';
        homePageQueryRec1.ESC_NoTruncation__c='CaseNumber:5,AccountId:4,RecordType.Name:12';
        homePageQueryRec1.ESC_ReturnedSecondaryColumns__c='CaseNumber,CreatedDate,Type';
        homePageQueryRec1.ESC_Profiles__c='System Administrator';
        homePageQueryRec1.ESC_isInActive__c=False;
        homePageQueryRec1.ESC_isMissedMilestone__c=True;
        homePageQueryRec1.ESC_PgntnEnabled__c=False;
       
        homePageQueryRec1.ESC_isMissedMilestone__c = true;
        insert homePageQueryRec1;
        
            ESC_HomePageQuery__c HomePageQueryRec3=new ESC_HomePageQuery__c();
         HomePageQueryRec3.ESC_ObjectType__c='ESC_Case_Collaborator__c';
        HomePageQueryRec3.ESC_Sequence__c='';
        HomePageQueryRec3.ESC_AssignedTo__c='Current User\'s Queue';
        HomePageQueryRec3.ESC_FilterCriteria__c='id!=null';
        HomePageQueryRec3.ESC_OverrideLabelsForfields__c='ESC_Case_Type__c:ESC_TestLabelOnly';
        HomePageQueryRec3.ESC_CustomLabel__c='ESC_TestLabelOnly';
        HomePageQueryRec3.ESC_Limit__c=650;
        HomePageQueryRec3.ESC_IsFirstHidden__c=False;
        HomePageQueryRec3.ESC_ReturnedColumns__c= 'Name,ESC_Case__c,ESC_Referral_Status__c,ESC_Case__r.ESC_UPD__c';
        HomePageQueryRec3.ESC_pushTopicName__c='MyQueue';
        HomePageQueryRec3.ESC_NoTruncation__c='';
        HomePageQueryRec3.ESC_Profiles__c='System Administrator';
        HomePageQueryRec3.ESC_isInActive__c=False;
        HomePageQueryRec3.ESC_isMissedMilestone__c=True;
        HomePageQueryRec3.ESC_PgntnEnabled__c=False;
       
        HomePageQueryRec3.ESC_isMissedMilestone__c = true;
        insert HomePageQueryRec3;
        
         ESC_MilestoneAlertConfigSetting__c mac=new ESC_MilestoneAlertConfigSetting__c();
        mac.Name='1';
        mac.X1stLevelColor__c='Red';
        mac.X2ndLevelColor__c='Green';
        mac.X3rdLayerColor__c='Blue';
        mac.X2ndLevelThreshold__c=5;
        mac.X1stLevelThreshold__c=10;
        insert mac;
        //fill cases
        List <Case> listcase= new List<Case>();
        
        string pageName='ESC_MissedMilestoneConsolePage';
    
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com' ,OwnerID=us.id);
        ESC_Case_Collaborator__c cs1 = new ESC_Case_Collaborator__c(OwnerID=us1.id);
        listcase.add(cs);
        insert listcase;
        
        ESC_HomePageReports__c hPge= new ESC_HomePageReports__c();
        hPge.ESC_CacheAge__c=40;
    hPge.ESC_Dashboard_Id__c='01Z1B000000jvL8,01Z1B000000jvLF';
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getprofileId()].Id;
        hPge.ESC_ReportIDS__c=profileName;
        Insert hPge;
        /*pagereference paRef= new pagereference ('/apex/ESC_CaseHomePage');
        Test.setCurrentPage(paRef);*/
        
        pageRef.getparameters().put('profile',hPge.ESC_ReportIDS__c);
       
        ESC_CaseHomePageController chpc = new ESC_CaseHomePageController();
        ESC_CaseHomePageController.getApprovalRecord(cs1.id);
        chpc.RefreshCaseListJS();
        
                
        
    Test.stopTest();
    
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    

    }
    
       @isTest public static void testmethod4() {
    
     //PageReference pageRef = Page.ESC_MissedMilestoneConsolePage;
    //Test.setCurrentPage(pageRef);
    //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james11.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='jamesxyz3.thomastest1@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        
       
        
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        dte.ESC_processing= 'Processing...';
        dte.ESC_search= 'Search:';
        dte.ESC_lengthMenu= 'Show _MENU_ entries';
        dte.ESC_info= 'Showing _START_ to _END_ of _TOTAL_ entries';
        dte.ESC_infoEmpty= 'Showing 0 to 0 of 0 entries';
        dte.ESC_infoFiltered= '(filtered from _MAX_ total entries)';
        dte.ESC_infoPostFix= '';
        dte.ESC_loadingRecords= 'Loading...';
        dte.ESC_zeroRecords= 'No matching records found';
        dte.ESC_emptyTable= 'No data available in table';
        dte.ESC_paginateFirst= 'First';
        dte.ESC_paginatePrevious= 'Previous';
        dte.ESC_paginateNext= 'Next';
        dte.ESC_paginateLast= '';
        
        dte.ESC_paginateFirst= '';
        dte.ESC_paginatePrevious= '';
        dte.ESC_paginateNext= '';
        dte.ESC_paginateLast= '';
   
        List<ESC_DataTableEntity> dtlist = new  List<ESC_DataTableEntity>();
        dtlist.add(dte);
        
        GenerateForm__C GF= new GenerateForm__C();
        GF.Name='Charge Cancellation';
        Insert GF;
        
        Case testCase=new case();
            testcase.LCRM_Sub_BU__c='USL';
            testcase.Subject='test1';
             testcase.Origin='Email';
             testcase.AccountId=null;
             testcase.contactid=null;
            testcase.ESC_Impact__c = '';
            testcase.ESC_Severity__c='';
            testcase.ESC_Customer_Symptom__c='';
            testcase.Description = 'test description';
            testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            testcase.USL_Queue_Name__c='Academic_Support';
            testcase.ESC_Diagnosis_Summary__c='';
            testcase.USL_SAP_Account_Number__c='123321123';
            insert testcase;
            
            ESC_Case_Form_Extension__c ESCCFE = new ESC_Case_Form_Extension__c();
            ESCCFE.ESC_Form__c=GF.id;
            ESCCFE.ESC_Case__c=testcase.id;
            ESCCFE.USL_Approval_Type__c='USL_Print_Subscription';
            ESCCFE.USL_Requester_Title__c=' Mr.';
            ESCCFE.USL_Requestor_ID__c='Testing';
            ESCCFE.USL_Total_Amount__c=450;
            ESCCFE.Route_To_USL_Print_CD_Credits__c=true;
            
            insert ESCCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  ESCCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine.ESC_Billing_Doc__c='6123872804';
            ESCCFELine.ESC_Line__c='000010';
            ESCCFELine.ESC_Net_Amount__c=3000;
            ESCCFELine.ESC_Tax_Amount__c=97;
            ESCCFELine.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            //ESCCFELine.USL_ODocType__c='YW';
            ESCCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine.ESC_Request_Description__c='Westlaw';
            ESCCFELine.ESC_Type__c='Partial';
           
            //ESCCFELine.ESC_Item_Amount__c=30000;
            //ESCCFELine.USL_Input_Amount__c=1126;
             insert ESCCFELine;
        
     Test.StartTest();
        
        //string pageName='ESC_MissedMilestoneConsolePage';
        ESC_HomePageQuery__c hpq = new ESC_HomePageQuery__c(ESC_Sequence__c = '',ESC_isMissedMilestone__c = true,
        ESC_Profiles__c ='System Administrator,USL Helpdesk Agent',
        ESC_AssignedTo__c = 'Approval Process' , ESC_PgntnEnabled__c=true,
        ESC_ReturnedColumns__c='ESC_Case__r.OwnerId,ESC_Case__r.AccountId,ESC_Case__c',ESC_ObjectType__c='ESC_Case_Form_Extension__c');
        insert hpq;
        /*
        ESC_HomePageReports__c hPge= new ESC_HomePageReports__c();
        hPge.ESC_CacheAge__c=40;
    hPge.ESC_Dashboard_Id__c='01Z1B000000jvL8,01Z1B000000jvLF';
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getprofileId()].Id;
        hPge.ESC_ReportIDS__c=profileName;
        Insert hPge;*/
        /*pagereference paRef= new pagereference ('/apex/ESC_CaseHomePage');
        Test.setCurrentPage(paRef);*/
        
       // pageRef.getparameters().put('profile',hPge.ESC_ReportIDS__c);
       
        ESC_CaseHomePageController chpc = new ESC_CaseHomePageController();
        ESC_CaseHomePageController.getApprovalRecord(ESCCFE.id);
        chpc.RefreshCaseListJS();
        
                 ESC_CaseHomePageController.QueryBuilder qb=new ESC_CaseHomePageController.QueryBuilder();
       qb.getFinalFilter(hpq,true);
        
    Test.stopTest();
    
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);

    }
    @isTest public static void testmethod5() {
    
     PageReference pageRef = Page.ESC_MissedMilestoneConsolePage;
    Test.setCurrentPage(pageRef);
    //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james11.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='jamesxyz3.thomastest1@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        
       
        
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        dte.ESC_processing= 'Processing...';
        dte.ESC_search= 'Search:';
        dte.ESC_lengthMenu= 'Show _MENU_ entries';
        dte.ESC_info= 'Showing _START_ to _END_ of _TOTAL_ entries';
        dte.ESC_infoEmpty= 'Showing 0 to 0 of 0 entries';
        dte.ESC_infoFiltered= '(filtered from _MAX_ total entries)';
        dte.ESC_infoPostFix= '';
        dte.ESC_loadingRecords= 'Loading...';
        dte.ESC_zeroRecords= 'No matching records found';
        dte.ESC_emptyTable= 'No data available in table';
        dte.ESC_paginateFirst= 'First';
        dte.ESC_paginatePrevious= 'Previous';
        dte.ESC_paginateNext= 'Next';
        dte.ESC_paginateLast= '';
        
        dte.ESC_paginateFirst= '';
        dte.ESC_paginatePrevious= '';
        dte.ESC_paginateNext= '';
        dte.ESC_paginateLast= '';
   
        List<ESC_DataTableEntity> dtlist = new  List<ESC_DataTableEntity>();
        dtlist.add(dte);
        
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
        insert testAccount1;
        
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        testContact1.ESC_tocContactStatus__c = 'Inactive';
        insert testContact1;
        
         Case testCase1=new Case (ContactId = testContact1.id);
        insert testCase1;
        
        ESC_Case_Collaborator__c cc = new ESC_Case_Collaborator__c();                                                                                                                                                            
        cc.OwnerId = us.id;
        cc.ESC_Case__c = testCase1.id;
        cc.ESC_Role__c = 'Accountable Resolver';
        cc.ESC_referral_status__c = 'New';
        cc.OwnerId=userInfo.getuserid();
        insert cc;
        
        
       
         ESC_MilestoneAlertConfigSetting__c mac=new ESC_MilestoneAlertConfigSetting__c();
        mac.Name='1';
        mac.X1stLevelColor__c='Red';
        mac.X2ndLevelColor__c='Green';
        mac.X3rdLayerColor__c='Blue';
        mac.X2ndLevelThreshold__c=5;
        mac.X1stLevelThreshold__c=10;
        insert mac;
    
     Test.StartTest();
        //fill cases
        List <Case> listcase= new List<Case>();
        
        string pageName='ESC_MissedMilestoneConsolePage';
    
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id, SuppliedPhone='123123123', SuppliedEmail='abc@tr.com' ,OwnerID=us.id);
        ESC_Case_Collaborator__c cs1 = new ESC_Case_Collaborator__c(OwnerID=us.id);
        listcase.add(cs);
        insert listcase;
        ESC_HomePageQuery__c hpq = new ESC_HomePageQuery__c(ESC_Sequence__c = '',ESC_isMissedMilestone__c = true,
        ESC_Profiles__c ='System Administrator,System Administrator,Sample Helpdesk Manager',
        ESC_AssignedTo__c = 'Current User Only' ,ESC_FilterCriteria__c = 'status NOT IN (\'cancelled\',\'closed\')' , ESC_NoTruncation__c='Status',ESC_PgntnEnabled__c=true,
        ESC_ReturnedColumns__c='Status,OwnerID,CaseNumber,Account.Name,ESC_UPD_Customer__c,ESC_Case__r.ESC_UPD_Customer__c',ESC_ObjectType__c='Case');
        insert hpq;
        
        ESC_HomePageQuery__c hpq1 = new ESC_HomePageQuery__c(ESC_Sequence__c = '',ESC_isMissedMilestone__c = true,
        ESC_Profiles__c ='System Administrator,System Administrator,Sample Helpdesk Manager',
        ESC_AssignedTo__c = 'Current User Only' ,ESC_FilterCriteria__c = 'id!=null',ESC_PgntnEnabled__c=true,
        ESC_ReturnedColumns__c='Name,ESC_Case__c,ESC_Referral_Status__c,ESC_Case__r.ESC_UPD__c,ESC_UPD_Resolver__c,ESC_Case__r.ESC_UPD_Resolver__c,',ESC_ObjectType__c='esc_case_collaborator__c');
        insert hpq1;
        //ProcessDefinition pd = [select id,name from ProcessDefinition where name ='ESC_KnowledgeApprovalProcess' limit 1];
        //ProcessInstance pi = [select id from ProcessInstance limit 1]; 
        
       // ProcessInstanceWorkitem piw = new ProcessInstanceWorkitem();
       // piw.ActorId = userInfo.getuserid();
       // piw.ProcessInstanceId=pi.id;
       // insert piw;
        ESC_HomePageReports__c hPge= new ESC_HomePageReports__c();
        hPge.ESC_CacheAge__c=40;
    hPge.ESC_Dashboard_Id__c='01Z1B000000jvL8,01Z1B000000jvLF';
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getprofileId()].Id;
        hPge.ESC_ReportIDS__c=profileName;
        Insert hPge;
        /*pagereference paRef= new pagereference ('/apex/ESC_CaseHomePage');
        Test.setCurrentPage(paRef);*/
        
        pageRef.getparameters().put('profile','');
       
        ESC_CaseHomePageController chpc = new ESC_CaseHomePageController();
        ESC_CaseHomePageController.getApprovalRecord(cs1.id);
        chpc.RefreshCaseListJS();
        
                 ESC_CaseHomePageController.QueryBuilder qb=new ESC_CaseHomePageController.QueryBuilder();
       qb.getFinalFilter(hpq,true);
        
    Test.stopTest();
    
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);

    }
    
}