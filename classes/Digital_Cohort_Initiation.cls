/********************************************************************************
 Class Name  : Digital_Cohort_Initiation
 Description : Creates Digital Validation Settings records from DS Data List View

 CHANGE HISTORY
 ==============================================================================
 Date            Name                    Jira             Description
 31-05-2020      Rahul Natarajan         DLT-18904        Created For CXD Project
 31-12-2020      Brenda Shields          DLT-21098        Add option to run automation and post validation searately
 *********************************************************************************/
public without sharing class Digital_Cohort_Initiation{

	// list of automation jobs
	public list<Digital_CohortContainerClass.JobsAutomation> lstJobsAutomation{get;set;}
	public Digital_CohortWrapperClass.CohortValidationWrapper valWrapper{get;set;}
	public ApexPages.StandardSetController stdCntrlr {get;set;}
    map<string, string> mapDigitalSettings = new map<string, string>();
    list<Product_Account_Detail__c> dsListFinal;
    list<Product_Account_Detail__c> dsList;
    boolean bDisplayJobStatus;  
    Boolean dvsResult;
    
    public Digital_Cohort_Initiation(ApexPages.StandardSetController controller) {
    	lstJobsAutomation = new List<Digital_CohortContainerClass.JobsAutomation>();
    	valWrapper = new Digital_CohortWrapperClass.CohortValidationWrapper();
			                               
        valWrapper.digitalSettings = getDigitalSettings();
        
        dslistfinal = new List<Product_Account_Detail__c>();
        dslist = new List<Product_Account_Detail__c>();
        valWrapper.selName = '';
        valWrapper.dsName = '';
        valWrapper.statusValue = 'newrecord';
        valWrapper.batchSize = 1;
        dvsResult = false;
        this.stdCntrlr = controller;
    }
    
    
	// Submit button request - validate and submit the appropriate job
    public void submitRequest() {
    	
		// check to see what job was selected     
		system.debug(LoggingLevel.INFO, 'submit request: ' + valWrapper.selJob);	
		
		// if the request is for the automation run, then sub the 1st job in the digital chain
    	if (valWrapper.selJob == 'AutomationJob') {
    		submitAutomation();
		// if the request is for the Post validation only job, then submit the 1st job in the digital validation chain    		
    	} else if (valWrapper.selJob == 'Post-CohortsOnly') {	
    		submitPostValidation();
    	// else check and run either the automation/validaion jobs or the pre-validation job
    	} else {
    		dupcheck();
    	}
    }
  
  
  	// Submit the first job in the Digital Automation Chain
    public void submitAutomation() {
		// This will run only the Digital Automation jobs.  No validation job will execute		
		Digital_OpportunityDigitalFlagSync dx = new Digital_OpportunityDigitalFlagSync();
		Database.executeBatch(dx, 50);
    }
    
    
    // submit the first job in the Cohort Validation Chain
     public void submitPostValidation() {
		// This will run only the validation jobs.  
		// An existing Digital Settings record needs to be selected
		system.debug(LoggingLevel.INFO, 'Submit Post Val job for Setting Name: ' + valWrapper.dsName);
		if (valWrapper.dsName == '') {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a Name for this validation run.'));
            valWrapper.statusValue = 'newrecord';
        } else {
        	// Delete any existing messages
        	deleteExistingMessages(valWrapper.dsName);
        	// Update existing customers for this validation run
        	updateExistingCustomers(valWrapper.dsName);
            // run job
            if (Schema.sObjectType.Digital_Settings__c.isQueryable()) { 
        		list<Digital_Settings__c> ds = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c 
        				from Digital_Settings__c 
        				where Id =: valWrapper.dsName 
            			and RecordTypeId =: Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId() and CreatedById =:Userinfo.getUserId()];
        		if (!ds.isEmpty()) {
            		Database.executeBatch(new Digital_Cohort_SSDCheck(ds[0]), Integer.valueOf(ds[0].Batch_Size__c));
        		}
            }
		}			
    }
    
       
    public void dupcheck() {  	
    	boolean bError = false;
    	bError = checkForErrors();
    	if (bError) { 
    		return;
    	}
        try {
            valWrapper.dsSettingsList = new list<Digital_Settings__c>();
            if (Schema.sObjectType.Digital_Settings__c.isQueryable()) {
                valWrapper.dsSettingsList = [Select Id, Name, Class__c, Batch_Size__c, Batch_Id__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c, Segment__c
                                  from Digital_Settings__c
                                  where (Job_Status__c = 'Started' or Job_Status__c = 'In Progress') and RecordTypeId = :Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId()];
                if (!(valWrapper.dsSettingsList.isEmpty())) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf('Below Existing Job is running')));
                    valWrapper.statusValue = 'existingvalues';
                } else {
                 	// create new Digital Setting for this job
                   	Digital_Settings__c dvs = createDigitalSetting(); //new Digital_Settings__c();
                    if (dvs == null) {
                      	return;
               		}
                    dsList = (Product_Account_Detail__c[])stdCntrlr.getSelected();
                    if (dsList.size() == 0) {    
                      	dvsResult = Digital_Cohort_DcCreation.dsCreation(dvs.Id, null);
                    } else {
                        for (Product_Account_Detail__c dsdata : [SELECT Bypass_Automation__c, Id, Renewal_Date__c, ZP_Cust_Number__c,Digital_Firm__c 
                                                                 FROM Product_Account_Detail__c
                                                                 WHERE ID In :dsList]) {
                            dsListFinal.add(dsdata);
                        }
                        dvsResult = Digital_Cohort_DcCreation.dsCreation(dvs.Id, dsListFinal);
                    }
                    if (dvsResult == true) {
                        valWrapper.dsSettingsList.add(dvs);    
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Job Triggered Succesfully')); 
                        valWrapper.statusValue = 'jobSuccess';
                    }
                }
            }

        } catch (Exception e) { 
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(e)));    
        }
    }
    
    
    // Used for showing customer number for particular account in dropdown list
    public list<SelectOption> getdigitalSettings() {
    	list<SelectOption> dSetting = new list<SelectOption>();
    
    	for (Digital_Settings__c digSettings : [Select Id, Name 
        						from Digital_Settings__c
								order by CreatedDate desc]) {
    		mapDigitalSettings.put(digSettings.Name, digSettings.Id);
 			dSetting.add(new SelectOption(digSettings.Id, digSettings.Name));
      	}
        return dSetting;					
    }
    

    public void refreshStatus() {
    	map<integer, string> mapJobNames = new map<integer, string>();
    	map<string, AsyncApexJob> mapApexAutoJobs = new map<string, AsyncApexJob>();
    	list<AsyncApexJob> jobsProcessingList = new list<AsyncApexJob>();
    	
		lstJobsAutomation.clear();
		// build a map of all the automation jobs
		mapJobNames.put(0, 'Digital_OpportunityDigitalFlagSync');
		mapJobNames.put(1, 'Digital_ProposalAutomation');
		mapJobNames.put(2, 'Digital_BestProposalAutomation');
		mapJobNames.put(3, 'Digital_BestValueProposalCloneAutomation');
		mapJobNames.put(4, 'Digital_PremiumProposalAutomation');
		mapJobNames.put(5, 'DigitalBundleBatch');
		mapJobNames.put(6, 'Digital_FinalizeCart');
		mapJobNames.put(7, 'Digital_MasterContactsBatch');
		mapJobNames.put(8, 'Digital_PasswordHoldersBatch');
		mapJobNames.put(9, 'Digital_OnlineContactsExport');
		mapJobNames.put(10, 'Digital_GenerateDocumentsBatch');
		mapJobNames.put(11, 'DigitalDocuSignEnvelopeCreation');
					
		// Select all automation jobs that are running or are completed	
    	if (Schema.sObjectType.AsyncApexJob.isQueryable()) {
    		// all status - and Status in ('Queued','Processing','Preparing','Holding') 
        	jobsProcessingList = [Select Status, ApexClass.Name, TotalJobItems, JobItemsProcessed, CreatedDate, 
        							CreatedBy.Name, CompletedDate, ExtendedStatus
        						from AsyncApexJob 
								where ApexClass.Name like 'Digital%' 
								and JobType in ('ScheduledApex','BatchApex')
								Order by CreatedDate asc];
			// build a map of all the jobs selected								
			for (AsyncApexJob oJob : jobsProcessingList) {
				// if multiple jobs - save the most recirent one - fixed by order by
				mapApexAutoJobs.put(oJob.ApexClass.Name, oJob);
			}	
			// build the records to display in the page
			for (integer i = 0; i < 12; i++) {
				string strJobName = mapJobNames.get(i);
				if (mapApexAutoJobs.ContainsKey(strJobName)) {
					lstJobsAutomation.add(new Digital_CohortContainerClass.JobsAutomation(strJobName, mapApexAutoJobs.get(strJobName)));
				} else {
					lstJobsAutomation.add(new Digital_CohortContainerClass.JobsAutomation(strJobName, null));
				}
			}
			
        }  
    }
    
    
    // Delete any existing Validation Messages if we are re-running a validation
    private void deleteExistingMessages(string dsSettingName) {
    	system.debug(LoggingLevel.INFO, 'Delete Messages for Setting Name: ' + dsSettingName);
    	if (Schema.sObjectType.Digital_Message__c.isQueryable() && 
        	Schema.sObjectType.Digital_Message__c.isDeletable()) { 
        		
    		list<Digital_Message__c> digMessages = [Select id
								from Digital_Message__c 
								where Digital_Settings__c =: dsSettingName];
			if (!digMessages.isEmpty()) {									
				try {
					delete digMessages;
				} catch (Exception e) { 
        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(e)));
				}
			}    
		}				
    }
    
    
    // Update the customers for this validation run to they will be re-processed
    private void updateExistingCustomers(string dsSettingName) { 
        system.debug(LoggingLevel.INFO, 'Delete Messages for Setting Name: ' + dsSettingName);
        if (Schema.sObjectType.Digital_Customer__c.isQueryable() && 
        	Schema.sObjectType.Digital_Customer__c.isUpdateable()) { 
        
    		list<Digital_Customer__c> digCustomers = [Select id, Cohort_Execution__c 
								from Digital_Customer__c 
								where Digital_Settings__c =: dsSettingName AND Cohort_Execution__c = true];
			for (Digital_Customer__c oCustomer : digCustomers) {
				oCustomer.Cohort_Execution__c = false;
			}					
			if (!digCustomers.isEmpty()) {						
				try {
					update digCustomers;
				} catch (Exception e) { 
        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(e)));    
				}
			}
		}	
    }
   
   
   	// create a new Digital Setting record for this validation run
	private Digital_Settings__c createDigitalSetting() {
		Digital_Settings__c dvs = new Digital_Settings__c();
        dvs.Name = valWrapper.selName;
        dvs.Data_Status__c = valWrapper.selJob;
        dvs.Segment__c = valWrapper.selSeg;
        dvs.Batch_Size__c = valWrapper.batchSize;
        system.debug(LoggingLevel.INFO, 'Insert new Digital Setting: ' + dvs);
                        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Database.SaveResult sr = Database.insert(dvs, dml);
        // add error logic
        if (!sr.isSuccess()) {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf('Digital Settings record could not be created')));
           	valWrapper.statusValue = 'existingvalues';
           	return null;
        }
        return dvs;
	}    
	
	
	// check for any errors before submitting the job
	private boolean checkForErrors() {
		boolean bError = false;
		
		if (valWrapper.selName == '' || valWrapper.batchSize == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please fill all values'));
            valWrapper.statusValue = 'newrecord';
            bError = true;
        }
        if (valWrapper.batchSize < 1 || valWrapper.batchSize > 5) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Available Batch Values between 1 and 10'));
            valWrapper.statusValue = 'newrecord';
            bError = true;
        }    
		return bError;
	}            		

}