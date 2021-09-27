/**
*	{Purpose} - Test Class for LeadCloneWithItemsController class.
*             - Test Class for CloneUtility class   
*	CHANGE HISTORY
*	=============================================================================
*	Date		Name				Description
*	20181018	Vivek Ravi		     Created
*	=============================================================================
**/
@isTest
public class LeadClonewithRelatedListControllerTest 
{
    
      //method to test the positive scenario 
      private static testMethod void testcloneController_Positive()
      {
      Id gliLeadRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'GLI'].Id;
	  Id glicampaignRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Campaign' AND DeveloperName = 'GLI'].Id;        
      
      //Create a Lead record
      Lead testLead = new Lead(RecordTypeId = gliLeadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Telesales Accepted');
      insert testLead;
        
      //Create a Campaign record
      Campaign caRec = new Campaign(RecordTypeId = glicampaignRTId,
                                     Name ='Test Campaign');
        
   	  insert caRec;
        
      //create a Campaign member record
      CampaignMember camRec =  new CampaignMember(
                                                    Campaignid = caRec.id,
                                                    Leadid = testLead.id
                                                   );
      insert camRec; 
       
      // create Marketing Activites record
      ELOQUA__Marketing_Activity__c marRec = new ELOQUA__Marketing_Activity__c(
            																	  Name ='Test Marketing act', 
            																	  ELOQUA__Lead__c = testLead.id 
        																		  );
        
      insert marRec;
        
      Test.startTest();
      // Construct the standard controller
      ApexPages.StandardController SController = new ApexPages.StandardController(testLead);
      // create the controller 
      LeadClonewithRelatedListController ext = new LeadClonewithRelatedListController(SController);
   
      // call the cloneWithItems method
      ext.cloneWithItems();
      // check that the new Lead was created successfully
      //List<Lead> newLeads = [select id from Lead where id = :ext.newRecordId];
      List<Lead> newLeads = [select id from Lead where Parent_Lead_ID__c = :testLead.Id];
      System.assertEquals(newLeads.size(),1);
      // check that the Campaign history related list was created
      List<CampaignMember> newCampMemItems = [Select c.Id From CampaignMember c where Leadid = :newLeads[0].id];
      System.assertEquals(newCampMemItems.size(),1);
      //check that the Marketing Activity related list was created
      List<ELOQUA__Marketing_Activity__c> newMarketActItems = [Select m.Id From ELOQUA__Marketing_Activity__c m where ELOQUA__Lead__c = :newLeads[0].id];
      System.assertEquals(newMarketActItems.size(),1);
      // Switch back to runtime context
      Test.stopTest();
      }
    
    // method to test the negative scenario
	private static testMethod void testcloneController_Negative()
    {    
        Id gliLeadRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'GLI'].Id;
        
        //Create a Lead record
        Lead testLead = new Lead(RecordTypeId = gliLeadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Telesales Accepted');
        insert testLead;
        
		Test.startTest();
			  
			// Construct the standard controller
			ApexPages.StandardController Controller = new ApexPages.StandardController(testLead);
			// create the controller 
			LeadClonewithRelatedListController ext = new LeadClonewithRelatedListController(Controller);

			ext.TestError =true;
        	
      		// call the cloneWithItems method
			try
			{
				ext.cloneWithItems();
			}	
			catch(Exception ex) 
			{
				String errorMessage = ex.getMessage();
				System.assertEquals(true,errorMessage.contains(Label.GLILeadClone_Save_Error_message));
			}
			
		Test.stopTest();
        
	}
    
      //method to test the Bulk records
	private static testMethod void testcloneController_Bulk(){
        
      	Id gliLeadRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'GLI'].Id;
	  	Id glicampaignRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Campaign' AND DeveloperName = 'GLI'].Id;        
      //Create a Lead record
      Lead testLead = new Lead(RecordTypeId = gliLeadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Telesales Accepted');
      insert testLead;
        
      //create set of 5 Campaign records
      List<Campaign> campList = new List<Campaign>();
      for (Integer i = 0; i < 5; i++) 
      {
      	Campaign caRec = new Campaign(RecordTypeId = glicampaignRTId,
                                     Name ='Test Campaign'+ i);
        
      	campList.add(caRec);
      }
      insert campList;
        
      //create set of 5 Campaignmember  records
      List<CampaignMember> campmemList = new List<CampaignMember>();
      for (Integer i = 0; i < 5; i++) 
      {
      	CampaignMember camRec =  new CampaignMember(
                                                    Campaignid = campList[i].id,
                                                    Leadid = testLead.id
                                                   );
        
      	campmemList.add(camRec);
      }
      insert campmemList;
        
      //create set of 5 Marketing Actvites records        
      List<ELOQUA__Marketing_Activity__c> marActList = new List<ELOQUA__Marketing_Activity__c>();
      for (Integer i = 0; i < 5; i++) {
      ELOQUA__Marketing_Activity__c marRec =  new ELOQUA__Marketing_Activity__c(Name ='Test Marketing act' + i, 
            																	  ELOQUA__Lead__c = testLead.id 
                                                   );
        
      marActList.add(marRec);
      }
      insert marActList;
        
        
      Test.startTest();
      // Construct the standard controller
      ApexPages.StandardController Controller = new ApexPages.StandardController(testLead);
      // create the controller 
      LeadClonewithRelatedListController ext = new LeadClonewithRelatedListController(Controller);
      
      // call the cloneWithItems method
      ext.cloneWithItems();
      // check that the new Lead was created successfully
      // List<Lead> newLeads = [select id from Lead where id = :ext.newRecordId];
	  List<Lead> newLeads = [select id from Lead where Parent_Lead_ID__c = :testLead.Id];
      System.assertEquals(newLeads.size(),1);
      // check that the Campaign history related list was created
      List<CampaignMember> newCampMemItems = [Select c.Id From CampaignMember c where Leadid = :newLeads[0].id];
      System.assertEquals(newCampMemItems.size(),5);
      // check that the Marketing Activity related list was created
      List<ELOQUA__Marketing_Activity__c> newMarketActItems = [Select m.Id From ELOQUA__Marketing_Activity__c m where ELOQUA__Lead__c = :newLeads[0].id];
      System.assertEquals(newMarketActItems.size(),5);
      // Switch back to runtime context
      Test.stopTest();
      }
    
    // method to test the negative scenario
	private static testMethod void testcloneController_Negativetwo()
    {    
        Id gliLeadRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'GLI'].Id;
        
        //Create a Lead record
        Lead testLead = new Lead(RecordTypeId = gliLeadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked');
        insert testLead;
        
		Test.startTest();
			  
			// Construct the standard controller
			ApexPages.StandardController Controller = new ApexPages.StandardController(testLead);
			// create the controller 
			LeadClonewithRelatedListController ext = new LeadClonewithRelatedListController(Controller);

			// call the cloneWithItems method
			try
			{
				ext.cloneWithItems();
			}	
			catch(Exception ex) 
			{
				String errorMessage = ex.getMessage();
				System.assertEquals(true,errorMessage.contains(Label.GLILeadclonewithStatus_TelesalesAcceptedonly_Error));
			}
			
		Test.stopTest();
        
	}

}