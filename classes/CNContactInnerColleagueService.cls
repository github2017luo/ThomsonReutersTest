public class CNContactInnerColleagueService extends CNListHandler{
	 
	public List<CNData.CNRelationship> listContactRelationships;
	public Integer iTotalContactRecords;
	public integer iAlternateIndex{get;set;}	
	public CNContactInnerColleagueService(){
	
	}
	public CNContactInnerColleagueService(List<CNData.CNRelationship> oList){
		this.listContactRelationships = oList;
	}
	//Invokes CN service to search for contact relationships based on contact email. Returns true if CN has more data to return.
	public override Boolean fetchInitialDataFromCN() {
		return true;
	}
	
	//Fetches the relationship data from Relationship__c custom object from Salesforce
	public override Boolean fetchAllDataFromSFDC() {
		return true;
	}
	   
	//Invokes CN service to search for CNID based on contact email address
	public override Boolean fetchMoreDataFromCN() {
		return true;
	}
	
	//Returns the next set of records from cache or from CN
	public override List<Object> massageNextPageData(List<Object> listNextPageData) {
		return listNextPageData;
	}		 
	
	//Loads queue handler record from custom object
	public override void loadQueueHandler() {
	} 
	
	//Returns the total cached relationships count
	public override Integer getCachedRelationshipsCount() {
		return null;
	}
	
}