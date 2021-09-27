/**
* This is the test class for maasOptyUpdate class.
* @ Author: Anshita Sharma
* Last Modified: Sep 7, 2012
*/

@isTest
private class opptyMassRemoveTeamMemberController_Test
{

 /**   public opptyMassRemoveTeamMemberController(ApexPages.StandardSetController controller)
    {
    
    }
  */      
      
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
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Induvidual';
        acc1.Customer_Group__c = 'ACADEMIC';
        acc1.Industry = 'Energy';
        acc1.SAPAccountNumber__c = '1000550771';
        acc1.Phone = '91 080 67259841';
        insert acc1;        
        
        Opportunity oppty1 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '10%',OwnerId='005a000000A6hKzAAJ');
        opptyLst.add(oppty1);
        
        Opportunity oppty2 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%',Ownerid='005a000000A6hKzAAJ');
        opptyLst.add(oppty2);
        
        insert opptyLst;
        
        
        OpportunityTeamMember optm = new OpportunityTeamMember();
        optm.OpportunityId = opptyLst[0].Id;
        optm.UserID = opptyLst[0].OwnerId;
        insert optm ;
       
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opptyLst);
        con.setSelected(opptyLst);

        opptyMassRemoveTeamMemberController mu = new opptyMassRemoveTeamMemberController(con); 
        mu.OppTeamMember =optm ;    
        massOptyStatusUpdateController mu1 = new massOptyStatusUpdateController(con);   
        
              
       Test.startTest();
        List<opptyMassRemoveTeamMemberController.OptyMassAdd> listOptyMass = new List<opptyMassRemoveTeamMemberController.OptyMassAdd>();
        listOptyMass.add( new opptyMassRemoveTeamMemberController.OptyMassAdd(oppty1));
        mu.OptyMassWrapper = listOptyMass;
        mu.OptyMassList = listOptyMass;
        mu.setOpt('Update all');
        mu.getOpt();
        mu.saveOpty();
        OpportunityTeamMember opt = new OpportunityTeamMember();
        mu.winLoss = '';
        mu.selectStage = '';
        
        string test1 = 'Hello Oppty';
        opptyMassRemoveTeamMemberController.isRequired = true;
        mu.isEdit = true;
        System.assertEquals(2, mu.getMySelectedSize());
        System.assertEquals(2, mu.getNonEditListSize());
        System.assertEquals(0, mu.getNonAssignListSize());
        System.assertEquals(0, mu.getEditListSize());
        System.assertEquals(0, mu.getEditList().size());
        System.assertEquals(2, mu.getNonEditList().size());
        System.assertEquals(0, mu.getNonAssignList().size());
        System.assertEquals(null, mu.Test());
        System.assertEquals('Update all', mu.getOpt());
        mu.setOpt('Update Individual Opportunity');
        System.assertEquals('Update Individual Opportunity', mu.getOpt());
        mu.setOpt('Update all Opportunities');        
        System.assertEquals(2, mu.getItems().size()); 
        
        try{
        mu.OppTeamMemberToBeRemoved(opptyLst);
        }
        catch(exception ex){
        }
        
        mu.getOpps();  
        opptyMassRemoveTeamMemberController.onStagenamechange(test1);
        try{
        System.assertEquals('/006', mu.saveOpty().getURL());
        }
        catch(exception ex){
        }   
        
        opptyMassRemoveTeamMemberController.OptyMassAdd oppslctd  = new opptyMassRemoveTeamMemberController.OptyMassAdd(oppty1);
        
                      
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
        
        opptyMassRemoveTeamMemberController mu2 = new opptyMassRemoveTeamMemberController(con1);       
        massOptyStatusUpdateController mu3 = new massOptyStatusUpdateController(con1);
           

    } 
    
    public static testMethod void testMassOptyUpdate1()
    {
         
        Date dt=System.Today();
        List<Opportunity> opptyLst = new List<Opportunity>();
        List<Opportunity> opptyLst1 = new List<Opportunity>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        
        Account acc1= UnitTest.getAccountInstance();
        acc1.Name = 'testAccount';
        acc1.Customer_Type__c = 'Induvidual';
        acc1.Customer_Group__c = 'ACADEMIC';
        acc1.Industry = 'Energy';
        acc1.SAPAccountNumber__c = '1000550771';
        acc1.Phone = '91 080 67259841';
        insert acc1;        
        
        Opportunity oppty1 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty1',StageName = '10%',OwnerId='005a000000A6hKzAAJ');
        opptyLst.add(oppty1);
        
        Opportunity oppty2 = new Opportunity(CloseDate= dt, Win_Loss__c='Kickout',AccountId = acc1.Id,name='testClass_Oppty2',StageName = '100%',Ownerid='005a000000A6hKzAAJ');
        opptyLst.add(oppty2);
        
        insert opptyLst;
        
        
        OpportunityTeamMember optm = new OpportunityTeamMember();
        optm.OpportunityId = opptyLst[0].Id;
        optm.UserID = opptyLst[0].OwnerId;
        insert optm ;
        RecordtypeIds__c recid = new RecordtypeIds__c();
        recid.Name = 'Pipeline Opportunities';
        recid.recTypeId__c = '01230000001MA4g';
        insert recid;
        PageReference oPageopptyMassRemoveTeamMember = Page.opptyMassRemoveTeamMember;
        Test.setCurrentPage(oPageopptyMassRemoveTeamMember);
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(opptyLst);
        con.setSelected(opptyLst);

        opptyMassRemoveTeamMemberController mu = new opptyMassRemoveTeamMemberController(con); 
        mu.OppTeamMember =optm ;    
        massOptyStatusUpdateController mu1 = new massOptyStatusUpdateController(con);   
        
              
       Test.startTest();
        
        mu.saveOpty();
        OpportunityTeamMember opt = new OpportunityTeamMember();
        mu.winLoss = '';
        mu.selectStage = '';
        
        string test1 = 'Hello Oppty';
        opptyMassRemoveTeamMemberController.isRequired = true;
        mu.isEdit = true;
        System.assertEquals(1, mu.getMySelectedSize());
        System.assertEquals(1, mu.getNonEditListSize());
        System.assertEquals(1, mu.getNonAssignListSize());
        System.assertEquals(1, mu.getEditListSize());
        System.assertEquals(1, mu.getEditList().size());
        System.assertEquals(1, mu.getNonEditList().size());
        System.assertEquals(1, mu.getNonAssignList().size());
        System.assertEquals(null, mu.Test());
        System.assertEquals('Update all Opportunities', mu.getOpt());
        mu.setOpt('Update Individual Opportunity');
        System.assertEquals('Update Individual Opportunity', mu.getOpt());
        mu.setOpt('Update all Opportunities');        
        System.assertEquals(2, mu.getItems().size()); 
        try{
        mu.OppTeamMemberToBeRemoved(opptyLst);
        }
        catch(exception ex){
        }
        mu.getOpps();  
        opptyMassRemoveTeamMemberController.onStagenamechange(test1);
        try{
        System.assertEquals('/006', mu.saveOpty().getURL());
        }
        catch(exception ex){
        }   
        
        opptyMassRemoveTeamMemberController.OptyMassAdd oppslctd  = new opptyMassRemoveTeamMemberController.OptyMassAdd(oppty1);
        
                      
        System.assertEquals(0, mu1.getPpoOppEditListSize());
        System.assertEquals(1, mu1.getPpoOppNonEditListSize());
        System.assertEquals(0, mu1.getPpoOppEditList().size());
        System.assertEquals(1, mu1.getPpoOppNonEditList().size());
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
        
        opptyMassRemoveTeamMemberController mu2 = new opptyMassRemoveTeamMemberController(con1);       
        massOptyStatusUpdateController mu3 = new massOptyStatusUpdateController(con1);
           

    }
    
}