/**
* This is the test class for maasOptyUpdate class.
* @ Author: Anshita Sharma
* Last Modified: Sep 7, 2012
* =============================================================================
* Date         Name                    Description
* 2012-09-04   Anshita Sharma           Created
* 2018 -02-09  Harika Devi Kalidindi    Added testMassOptyUpdateIndividualOpportunity,testMassOptyUpdateWithRepPermissionSet,testMassOptyUpdateMethod1 methodsas part of CRM -5600 for code coverage 
* =============================================================================
*/

@isTest
private class massOptyUpdateController_Test
{

   
    
    public massOptyUpdateController_Test()
    {
         
    }
    
      
    public static testMethod void testMassOptyUpdate()
    {
         
        Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        
        Contact u = new Contact(FirstName='Steve',LastName='Mark', Email='stevemark@gmail.com');
        insert u;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = '1000578984';
        insert acc1;        
        
        string rId = [SELECT Id FROM RecordType WHERE SobjectType = 'opportunity' AND Name = 'Pipeline Opportunity'].Id;
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '100%');
        opptyLst.add(oppty1);
        
        Opportunity oppty2 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%');
        opptyLst.add(oppty2);
        
               
        insert opptyLst;

        
                      
        List<Opportunity> lstopps=[Select Id,OwnerId from Opportunity];
        Map<Id,Id> TargetId =new Map<Id,Id>();
        TargetId.put(lstopps[0].Id,lstopps[0].OwnerId);
        TargetId.put(lstopps[1].Id,lstopps[1].OwnerId);
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opptyLst);
        con.setSelected(opptyLst);

        massOptyUpdateController mu = new massOptyUpdateController(con);     
        massOptyStatusUpdateController mu1 = new massOptyStatusUpdateController(con);
        
        Map<Id,Id> mappreviousowner = new  Map<Id,Id>();  
        mappreviousowner.Put(lstopps[0].Id,lstopps[0].OwnerId);
        mappreviousowner.Put(lstopps[1].Id,lstopps[1].OwnerId);
        Test.startTest();
        
        mu.saveOpty();
        mu.isRemovePrevOwnerfromTeammember = TRUE;
        mu.isSendEmailNotification = TRUE;
        massOptyUpdateController.isRequired = TRUE;
        mu.winLoss = '';
        mu.selectStage = '';
        System.assertEquals(2, mu.getMySelectedSize());
        System.assertEquals(2, mu.getNonEditListSize());
        System.assertEquals(0, mu.getNonAssignListSize());
        System.assertEquals(0, mu.getEditListSize());
        System.assertEquals(0, mu.getEditList().size());
        System.assertEquals(2, mu.getNonEditList().size());
        System.assertEquals(0, mu.getNonAssignList().size());
        System.assertEquals(null, mu.Test());
        mu.getOpps();
        System.assertEquals('Update all Opportunities', mu.getOpt());
        mu.setOpt('Update Individual Opportunity');
        System.assertEquals('Update Individual Opportunity', mu.getOpt());
        mu.setOpt('Update all Opportunities');        
        System.assertEquals(2, mu.getItems().size());
        try{          
        mu.RemoveOppTeamMember(opptyLst,mappreviousowner);
        }
        catch(exception ex){
        }
        
 //       User Ownerdetails = [Select Email from User where Id =: opptyLst[0].OwnerId];
        //mu.SendEmailNotificationToNewOwner(new String[]{u.Email}, opptyLst[0].Id);
         mu.SendEmailNotificationToNewOwner(TargetId,opptyLst);
        massOptyUpdateController.oOppSelected oppslctd  = new massOptyUpdateController.oOppSelected(oppty1);
                  
 //       System.debug('+++++ saveOpty' + mu.saveOpty().getURL()); 
     
        //System.assertEquals('/006', mu.saveOpty().getURL());   
        
        
        System.assertEquals(0, mu1.getPpoOppEditListSize());
        System.assertEquals(2, mu1.getPpoOppNonEditListSize());
        System.assertEquals(0, mu1.getPpoOppEditList().size());
        System.assertEquals(2, mu1.getPpoOppNonEditList().size());
        System.assertEquals(null, mu1.Test());
        System.assertEquals('Update all Opportunities', mu1.getOpt());
        mu1.setOpt('Update Individual Opportunity');
        System.assertEquals('Update Individual Opportunity', mu1.getOpt());
        mu1.setOpt('Update all Opportunities');        
        System.assertEquals(2, mu1.getItems().size());         
        
        System.assertEquals('/006', mu1.saveOpty().getURL());   
        
        Test.stopTest();
        
        ApexPages.StandardSetController con1 = new ApexPages.StandardSetController(opptyLst1);
        con.setSelected(opptyLst1);

        massOptyUpdateController mu2 = new massOptyUpdateController(con1);       
        massOptyStatusUpdateController mu3 = new massOptyStatusUpdateController(con1);

    }
    

    public static testMethod void testMassOptyUpdate2()
    {
         
        Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
       /* List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds; */
        
        string rId = [SELECT Id FROM RecordType WHERE SobjectType = 'opportunity' AND Name = 'Pipeline Opportunity'].Id;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = '1000578984';
        insert acc1;        
        
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '100%');
        opptyLst1.add(oppty1);
        
        Opportunity oppty2 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%');
        opptyLst1.add(oppty2);
        
               
  //      insert opptyLst1;
         
        string str = 'Hello';              
        massOptyUpdateController.onStagenamechange(str);
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opptyLst);
  //      con.setSelected(opptyLst1);

        massOptyUpdateController mu = new massOptyUpdateController(con);     
        massOptyStatusUpdateController mu1 = new massOptyStatusUpdateController(con);   
                
        Test.startTest();
        
        mu.saveOpty();
         massOptyUpdateController.oOppSelected oppslctd  = new massOptyUpdateController.oOppSelected(oppty1);
        mu.isRemovePrevOwnerfromTeammember = true;
        
        mu.isSendEmailNotification = true;
        
        massOptyUpdateController.isRequired = TRUE;
        mu.winLoss = '';
        mu.selectStage = '';
        
        mu.isNotAll = False;
        
        Test.stopTest();
    } 
    
    public static testMethod void testMassOptyUpdateMethod()
    {
         
       Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
       /* List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds; */
        
        string rId = [SELECT Id FROM RecordType WHERE SobjectType = 'opportunity' AND Name = 'Pipeline Opportunity'].Id;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = '1000578984';
        insert acc1;        
        
        
        
        
        
        RecordtypeIds__c recType = new RecordtypeIds__c();
        recType.Name='Pre-Pipeline Opportunities';
        recType.recTypeId__c = '01230000001MA4h';
        insert recType;
        RecordtypeIds__c recType1 = new RecordtypeIds__c();
        recType1.Name='Pipeline Opportunities';
        recType1.recTypeId__c = '01230000001MA4g';
        insert recType1;  
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = recType1.recTypeId__c, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '100%');
        opptyLst1.add(oppty1);
        Opportunity oppty2 = new Opportunity(RecordTypeId = recType.recTypeId__c, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%');
        opptyLst1.add(oppty2);     
        insert opptyLst1;
        system.debug('opptyLst1...'+opptyLst1);
        string str = 'Hello';              
        massOptyUpdateController.onStagenamechange(str);
        PageReference pageRef = Page.massUpdateOppty;        
            Test.setCurrentPage(pageRef);    
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opptyLst1);
          con.setSelected(opptyLst1);

        massOptyUpdateController mu = new massOptyUpdateController(con);     
        massOptyStatusUpdateController mu1 = new massOptyStatusUpdateController(con);   
                
        Test.startTest();
        string str1 = 'Nothing';
        mu.setopt(str1);
        mu.saveOpty();
         massOptyUpdateController.oOppSelected oppslctd  = new massOptyUpdateController.oOppSelected(oppty1);
        mu.isRemovePrevOwnerfromTeammember = true;
        
        mu.isSendEmailNotification = true;
        
        massOptyUpdateController.isRequired = TRUE;
        mu.winLoss = '';
        mu.selectStage = '';
        
        mu.isNotAll = False;
        
        Test.stopTest();
    } 
    
    //Harika 09 Feb 2018 - Added as part of CRM -5600 for code coverage
   
   public static testMethod void testMassOptyUpdateMethod1()
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        
        User u= UnitTest.getUserInstance();
        u.Username = 'testuser@trpcorelegal.com';
        u.profileid = p.Id;
        
        insert u;
         
         
        
        System.runAs(u)
         { 
       Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
       /* List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds; */
        
        string rId = [SELECT Id FROM RecordType WHERE SobjectType = 'opportunity' AND Name = 'Pipeline Opportunity'].Id;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = '1000578984';
        insert acc1;        
        
        
        
        
        
        RecordtypeIds__c recType = new RecordtypeIds__c();
        recType.Name='Pre-Pipeline Opportunities';
        recType.recTypeId__c = '01230000001MA4h';
        insert recType;
        RecordtypeIds__c recType1 = new RecordtypeIds__c();
        recType1.Name='Pipeline Opportunities';
        recType1.recTypeId__c = '01230000001MA4g';
        insert recType1;  
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = recType1.recTypeId__c, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '10%');
        opptyLst1.add(oppty1);
        Opportunity oppty2 = new Opportunity(RecordTypeId = recType.recTypeId__c, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%');
        opptyLst1.add(oppty2);     
        insert opptyLst1;
        system.debug('opptyLst1...'+opptyLst1);
        string str = 'Hello';              
        massOptyUpdateController.onStagenamechange(str);
        PageReference pageRef = Page.massUpdateOppty;        
            Test.setCurrentPage(pageRef);    
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opptyLst1);
          con.setSelected(opptyLst1);

        massOptyUpdateController mu = new massOptyUpdateController(con);     
        massOptyStatusUpdateController mu1 = new massOptyStatusUpdateController(con);   
                
        Test.startTest();
        
        mu.opt ='Update Individual Opportunity';
        mu.setopt('Update Individual Opportunity');
        
        
         massOptyUpdateController.oOppSelected oppslctd  = new massOptyUpdateController.oOppSelected(oppty2);
        mu.isRemovePrevOwnerfromTeammember = true;
        
        mu.isSendEmailNotification = true;
        
        mu.saveOpty();
        massOptyUpdateController.oOppSelected oppslctd1  = new massOptyUpdateController.oOppSelected(oppty1);
        mu.isRemovePrevOwnerfromTeammember = true;
        
        mu.isSendEmailNotification = true;
        
        
        
        
        massOptyUpdateController.isRequired = TRUE;
        mu.winLoss = '';
        mu.selectStage = '';
        
        mu.isNotAll = False;
        
        Test.stopTest();
        }
    } 
    
    
    //Harika 09 Feb 2018 - Added as part of CRM -5600 for code coverage
     public static testMethod void testMassOptyUpdateWithRepPermissionSet()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User ouser = UnitTest.getUserInstance();
        ouser .Username = 'testuser@trpcorelegal.com';
        ouser .profileid = p.Id;
        
        insert ouser ;
         
         User ouser1 = UnitTest.getUserInstance();
         ouser1 .Username = 'user@mydomain.com.'+Math.random();
         ouser1 .profileid = p.Id;
         ouser1 .Alias = 'test1';
          ouser1 .CommunityNickname= 'test1';
         ouser1.LastName ='Testing1';
         ouser .Sub_Bu__c = 'USL';
         insert ouser1 ;
       
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Opportunity_Mass_Transfer_Sales_Reps'];
 insert new PermissionSetAssignment(AssigneeId = ouser.id, PermissionSetId = ps.Id );
        System.runAs(ouser)
         { 
         Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        
        Contact u = new Contact(FirstName='Steve',LastName='Mark', Email='stevemark@gmail.com');
        insert u;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = '1000578984';
        insert acc1;        
        
        string rId = [SELECT Id FROM RecordType WHERE SobjectType = 'opportunity' AND Name = 'Pipeline Opportunity'].Id;
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '10%');
        opptyLst.add(oppty1);
        Opportunity oppty2 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%');
        opptyLst.add(oppty2);
        
        insert opptyLst;
        
        Opportunity oppty3 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty3',StageName = '10%');
        opptyLst1.add(oppty3);
        Opportunity oppty4 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty4',StageName = '100%');
        opptyLst1.add(oppty4);
        insert opptyLst1;
       
                      
        List<Opportunity> lstopps=[Select Id,OwnerId from Opportunity];
        List<OpportunityTeamMember> lstopptyteam = new List<OpportunityTeamMember>();
        OpportunityTeamMember otm = new OpportunityTeamMember (OpportunityId = lstopps[0].Id,UserId = lstopps[0].OwnerId,TeamMemberRole = 'Sales Rep');
        lstopptyteam.add(otm);
        OpportunityTeamMember otm1 = new OpportunityTeamMember (OpportunityId = lstopps[1].Id,UserId = lstopps[1].OwnerId,TeamMemberRole = 'Sales Rep');
        lstopptyteam.add(otm1);
        OpportunityTeamMember otm2 = new OpportunityTeamMember (OpportunityId = lstopps[2].Id,UserId = lstopps[2].OwnerId,TeamMemberRole = 'Sales Rep');
        lstopptyteam.add(otm2);
        OpportunityTeamMember otm3 = new OpportunityTeamMember (OpportunityId = lstopps[3].Id,UserId = lstopps[3].OwnerId,TeamMemberRole = 'Sales Rep');
        lstopptyteam.add(otm3);
        
        insert lstopptyteam;
        
        List<Opportunity> lstupdatedopps = new List<Opportunity>();
        for(Opportunity opp1:opptyLst)
        {
        opp1.OwnerId =ouser1.Id;
        lstupdatedopps.add(opp1);
        }
        
        string str = 'Hello';              
        massOptyUpdateController.onStagenamechange(str);
        PageReference pageRef = Page.massUpdateOppty;        
          Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(lstupdatedopps);
        con.setSelected(lstupdatedopps);

        massOptyUpdateController mu = new massOptyUpdateController(con);     
        
        Map<Id,Id> TargetId = new map<Id,Id>();
        TargetId.Put(lstopps[0].Id,lstopps[0].OwnerId);
        TargetId.Put(lstopps[1].Id,lstopps[1].OwnerId);
        TargetId.Put(lstopps[2].Id,lstopps[2].OwnerId);
        TargetId.Put(lstopps[3].Id,lstopps[3].OwnerId);
        
        Map<Id,Id> mappreviousowner = new  Map<Id,Id>();  
        mappreviousowner.Put(lstopps[0].Id,lstopps[0].OwnerId);
        mappreviousowner.Put(lstopps[1].Id,lstopps[1].OwnerId);
        mappreviousowner.Put(lstopps[2].Id,lstopps[2].OwnerId);
        mappreviousowner.Put(lstopps[3].Id,lstopps[3].OwnerId);
        Test.startTest();
        
        
        
        mu.isRemovePrevOwnerfromTeammember = TRUE;
        mu.isSendEmailNotification = TRUE;
        massOptyUpdateController.isRequired = TRUE;
        
        mu.winLoss = '';
        mu.selectStage = '';
        System.assertEquals(2, mu.getMySelectedSize());
        System.assertEquals(2, mu.getNonEditListSize());
        System.assertEquals(0, mu.getNonAssignListSize());
        System.assertEquals(0, mu.getEditListSize());
        System.assertEquals(0, mu.getEditList().size());
        System.assertEquals(2, mu.getNonEditList().size());
        System.assertEquals(0, mu.getNonAssignList().size());
        System.assertEquals(null, mu.Test());
        mu.getOpps();
        System.assertEquals('Update all Opportunities', mu.getOpt());
        mu.setOpt('Update Individual Opportunity');
        System.assertEquals('Update Individual Opportunity', mu.getOpt());
        
        mu.setOpt('Update all Opportunities');        
        System.assertEquals(2, mu.getItems().size());
        try{ 
        mu.RemoveOppTeamMember(lstopps,mappreviousowner);
        }
        catch(exception ex){
        }
       // mu.SendEmailNotificationToNewOwner(new String[]{u.Email}, opptyLst[0].Id);
        mu.SendEmailNotificationToNewOwner(TargetId,opptyLst);
        massOptyUpdateController.oOppSelected oppslctd  = new massOptyUpdateController.oOppSelected(lstupdatedopps[0]);
        
       oppslctd.isRemovePrevOwnerfromTeammemberSelected =true;
         oppslctd.isSendEmailNotificationSelected = true;
                 
         
        mu.saveOpty();        
        
           
        
        
        Test.stopTest();

    }
    

          } 
          
          //Harika 09 Feb 2018 - Added as part of CRM -5600 for code coverage
  public static testMethod void testMassOptyUpdateIndividualOpportunity()
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User ouser = UnitTest.getUserInstance();
        ouser .Username = 'testuser@trpcorelegal.com';
        ouser .profileid = p.Id;
        ouser .Sub_Bu__c = 'USL';
        insert ouser ;
         
         User ouser1 = UnitTest.getUserInstance();
         ouser1 .Username = 'user@mydomain.com.'+Math.random();
         ouser1 .profileid = p.Id;
         ouser1 .Alias = 'test1';
         ouser1 .CommunityNickname= 'test1';
         
         ouser1.LastName ='Testing1';
         insert ouser1 ;
            
         
       
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Opportunity_Mass_Transfer_Sales_Reps'];
 insert new PermissionSetAssignment(AssigneeId = ouser.id, PermissionSetId = ps.Id );
        System.runAs(ouser)
         { 
         Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        
        Contact u = new Contact(FirstName='Steve',LastName='Mark', Email='stevemark@gmail.com');
        insert u;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Organization';
        acc1.Customer_Group__c = '';
        acc1.Industry = 'GVT-COUNTY';
        acc1.SAPAccountNumber__c = '1000578984';
        insert acc1;        
        
        string rId = [SELECT Id FROM RecordType WHERE SobjectType = 'opportunity' AND Name = 'Pipeline Opportunity'].Id;
        
        Opportunity oppty1 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '100%');
        opptyLst.add(oppty1);
        Opportunity oppty2 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%');
        opptyLst.add(oppty2);
        
        insert opptyLst;
        
        Opportunity oppty3 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty3',StageName = '100%');
        opptyLst1.add(oppty3);
        Opportunity oppty4 = new Opportunity(RecordTypeId = rId, CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty4',StageName = '100%');
        opptyLst1.add(oppty4);
        insert opptyLst1;
        
        List<Opportunity> lstopps=[Select Id,OwnerId from Opportunity];
        
        
        List<Opportunity> lstupdatedopps = new List<Opportunity>();
        for(Opportunity opp1:opptyLst)
        {
        opp1.OwnerId =ouser1.Id;
        lstupdatedopps.add(opp1);
        }
        Map<Id,Opportunity> mapfinallist=new Map<Id,Opportunity>();
             for(Opportunity opp:opptyLst1){
                 mapfinallist.put(opp.Id,opp);
             }
        string str = 'Hello';              
        massOptyUpdateController.onStagenamechange(str);
        PageReference pageRef = Page.massUpdateOppty;        
          Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(lstupdatedopps);
        con.setSelected(lstupdatedopps);

        massOptyUpdateController mu = new massOptyUpdateController(con);     
        
        Map<Id,id> TargetId=new Map<Id,Id>();
        TargetId.put(lstopps[0].Id,lstopps[0].OwnerId);
        TargetId.put(lstopps[1].Id,lstopps[1].OwnerId);
        TargetId.put(lstopps[2].Id,lstopps[2].OwnerId);
        TargetId.put(lstopps[3].Id,lstopps[3].OwnerId);
        
        Map<Id,Id> mappreviousowner = new  Map<Id,Id>();  
        mappreviousowner.Put(lstopps[0].Id,lstopps[0].OwnerId);
        mappreviousowner.Put(lstopps[1].Id,lstopps[1].OwnerId);
        mappreviousowner.Put(lstopps[2].Id,lstopps[2].OwnerId);
        mappreviousowner.Put(lstopps[3].Id,lstopps[3].OwnerId);
        Test.startTest();
        
        
        mu.isRemovePrevOwnerfromTeammember = TRUE;
        mu.isSendEmailNotification = TRUE;
        massOptyUpdateController.isRequired = TRUE;
        
        mu.winLoss = '';
        mu.selectStage = '';
        System.assertEquals(2, mu.getMySelectedSize());
        System.assertEquals(2, mu.getNonEditListSize());
        System.assertEquals(0, mu.getNonAssignListSize());
        System.assertEquals(0, mu.getEditListSize());
        System.assertEquals(0, mu.getEditList().size());
        System.assertEquals(2, mu.getNonEditList().size());
        System.assertEquals(0, mu.getNonAssignList().size());
        System.assertEquals(null, mu.Test());
        mu.getOpps();
       
        mu.setOpt('Update Individual Opportunity');
        System.assertEquals('Update Individual Opportunity', mu.getOpt());
        
        
        try{ 
        mu.RemoveOppTeamMember(lstopps,mappreviousowner);
        }
        catch(exception ex){
        }
        //mu.SendEmailNotificationToNewOwner(new String[]{u.Email}, opptyLst[0].Id);
        mu.SendEmailNotificationToNewOwner(TargetId,opptyLst);
        
        massOptyUpdateController.oOppSelected oppslctd  = new massOptyUpdateController.oOppSelected(lstupdatedopps[0]);
        massOptyUpdateController.oOppSelected oppslctd1  = new massOptyUpdateController.oOppSelected(lstupdatedopps[1]);
        
       oppslctd.isRemovePrevOwnerfromTeammemberSelected =true;
         oppslctd.isSendEmailNotificationSelected = true;
         oppslctd1.isRemovePrevOwnerfromTeammemberSelected =true;
         oppslctd1.isSendEmailNotificationSelected = true;
          
         
        mu.saveOpty();   
        
        Test.stopTest();

    }
    

          }
    
                                                                                 
}