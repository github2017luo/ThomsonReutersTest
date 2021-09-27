/**
*	{Purpose} - Controller class for GLILeadCloneVF Visualforce Page.
*			    Used the Utility class "Cloneutility"
*				Test code coverage provided by the following class:
*				- LeadClonewithRelatedListControllerTest
*
*	CHANGE HISTORY
*	=============================================================================
*	Date		Name				Description
*	20181026	Vivek Ravi		    Created
*	=============================================================================
**/
  public class LeadClonewithRelatedListController 
  {
	
  		//added an instance varaible for the standard controller
  		public ApexPages.StandardController controller {get; set;}
  		// add the instance for the variables being passed by id on the url
  		@TestVisible private Lead Ld ;
  		// to set the new id of the record that is created
  		@TestVisible private ID newRecordId;
  		// initialize variable to set the old id of the record
  		
 		//Intialize the Boolean variable used just for test coverage     
  		public Boolean TestError {get;set;} 
        // to set the new name of the record that is created -used in the apex message
        @TestVisible private string newRecordName;
     
    
    
  		// initialize the controller
  		public LeadClonewithRelatedListController(ApexPages.StandardController controller) 
    	{

  			//initialize the standard controller
  			this.controller = controller;
  			Ld =new Lead();
  			// load the current record
  			Ld = (Lead)controller.getRecord();
  			this.TestError=false;    
  			if(Ld.id != null)
  			{
      			Ld = [Select id,Status From Lead where id=:Ld.id];
  			}
			System.debug(logginglevel.ERROR, '********** Lead (Constructor): ' + Ld);
  		}
    
  		// method called from the GLILeadClone VF page action attribute to clone the Lead
  		public PageReference cloneWithItems() 
         {
  			PageReference pageRef = null;
  			//clone the lead only if the Lead Status is "Telesales Accepted"    
  			if(Ld.Status=='Telesales Accepted')
            {   
			
  				// setup the save point for rollback
  				Savepoint sp = Database.setSavepoint();
  				Lead newld;
  				//set the oldrecord id value
				
  				try 
                {	
					String oldRecordId = Ld.Id;
				
  					if(this.TestError==true)
  					{

    					Integer testInteger = (5/0);        
  					}
  					//Pass the lead object and Lead id to the Cloneutility class to get all the creatable fields on objects
  					String leadSOQL = CloneUtility.getCreatableFieldsSOQL('lead', ' id =: oldRecordId');

  					Lead Ld1 = (Lead)Database.query(leadSOQL);

  					newld = Ld1.clone(false, true);

  					newld.Parent_Lead_ID__c = Ld1.id;

  					insert newld;
            
  					// set the id and name of the new Lead created
  					newRecordId = newld.id;
                    newRecordName = newld.name;
            
  					// Query all the Marketing Activities related list records from the Old lead record 
  					// through CloneUtility class to fetch all the fields and add it to the list
  					List<ELOQUA__Marketing_Activity__c> marketingitems =  (List<ELOQUA__Marketing_Activity__c>)Database.query(CloneUtility.getCreatableFieldsSOQL('ELOQUA__Marketing_Activity__c',' ELOQUA__Lead__c =: oldRecordId'));

                    //list to store the new cloned Marketing activity records
  					List<ELOQUA__Marketing_Activity__c> newmarketingitems = new List<ELOQUA__Marketing_Activity__c> ();
            
  					//loop through the marketingitems list,clone the records and assign the Parent lead id to it
  					for (ELOQUA__Marketing_Activity__c pi : marketingitems ) 
            		{                                        
  						ELOQUA__Marketing_Activity__c newPI = pi.clone(false, true);
  						newPI.ELOQUA__Lead__c = newld.id;
  						newmarketingitems.add(newPI);
  					}
                    
  					// check if the Marketingitem list is null and insert the list
  					if (!newmarketingitems.isEmpty()) 
  					{
  						insert newmarketingitems;
  					}
            
  					// Query all the Campaign member related list records from the Old lead record 
  					// through CloneUtility class to fetch all the fields and add it to the list
  					List<CampaignMember> campaignitems = (List<CampaignMember>)Database.query(CloneUtility.getCreatableFieldsSOQL('CampaignMember','LeadId =: oldRecordId'));
            		
  					//list to store the new Campaign member related list records
		  			List<CampaignMember> newcampaignitems = new List<CampaignMember>();
  					for (CampaignMember ci : campaignitems)
  					{
  						CampaignMember newCI = ci.clone(false,true);
  						newCI.LeadId = newld.id;
  						newCI.Cloned_from_Lead__c = true;    
  						newcampaignitems.add(newCI);
  					}
                   
  					// check if the campaignitems list is null and insert the records
  					if (!newcampaignitems.isEmpty()) 
  					{
  						insert newcampaignitems;
  					}
      			}
         
  				catch (Exception e)
                {
                   
  						// roll everything back in case of error
  						Database.rollback(sp);
  					 	// Log the error
  						String errorPoint = 'LeadCloneWithItemsController.cloneWithItems()';
  						String errorMessage = e.getMessage();
  						TR_Retention__Error_Log__c newErrorLog = new TR_Retention__Error_Log__c(TR_Retention__Error_Point__c = errorPoint,
                                    	   								  TR_Retention__Error_Message__c = errorMessage);
  						insert newErrorLog;
  						// Display a clean error message to the User.
  						ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.GLILeadClone_Save_Error_message));
  						return pageref;
  				}
  			}
  			else 
  				{ 
                   
  						ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.GLILeadclonewithStatus_TelesalesAcceptedonly_Error));
  						return pageRef;
  				}
  			// link to hold the new recordid used in the apex message
  			String clonedRecordLink = '<a href="/'+newRecordId+'">'+newRecordName+'</a>';
            
            // Once the clone button is clicked, the below message is displayed with the Cloned record link 
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Lead has been cloned! <br/> Please click on this link to view the cloned record'+ clonedRecordLink ));
  			
             return pageref;
  			}
  	}