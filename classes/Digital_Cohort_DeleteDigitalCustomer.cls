/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_DeleteDigitalCustomer
 DESCRIPTION : Deletes Digital Customer Data Other Last 3 Digital Settings
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_DeleteDigitalCustomer implements Database.Batchable<Digital_Customer__c>, Database.Stateful{
	List<Digital_Customer__c> dclist;
	public Digital_Cohort_DeleteDigitalCustomer(List<Digital_Customer__c> digitalCustomerList){
		this.dclist = digitalCustomerList;
	}

	public Iterable<Digital_Customer__c> start(Database.BatchableContext bc){
		return dclist;
	}

	public void execute(Database.BatchableContext bc, List<Digital_Customer__c> scope){
		try{
			if (!scope.isEmpty()){
				delete scope;
			}
		} catch (Exception e){ Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c= e.getMessage(),Exception_Type__c = e.getStackTraceString(),Additional_Information__c = String.valueof(e.getLineNumber()),User_Message__c = String.valueof(e.getCause()),Class_Reference__c = 'Digital_Cohort_DeleteDigitalMessages > Execute'); insert ex; }
	}

	public void finish(Database.BatchableContext bc){
	}
}