/**
* {Purpose} – Manages go to list page properties
*
* @author	Shah Kadirmohideen
* @version	2012-01-20
*/   
  
/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-01-20	Shah Kadirmohideen		Created      
* =============================================================================
*/
public abstract class CNEnhancedListHandler {
    //Private variables
    public ApexPages.StandardSetController oSetController;
    
    //Publc variables 
    public String sSortBy {get; set;} 
    public String sSortDirection {get; set;}
    public String sStartsWith {get; set;} 
	public Integer iTotalRecords {get; set;}
    public CNAppUtils.CNWebServiceQueueHandler oQueueHandler;
    public String tabName {get; set;}
	
	/* CONSTRUCTORS */
	
    public CNEnhancedListHandler() {  
    	this.sSortBy = 'Raw_Score__c';
    	this.sSortDirection = 'DESC';
    	this.sStartsWith = 'All';
    	this.iTotalRecords = 0;
    }
    
    /* PUBLIC METHODS */
    
    //Fetches the current set of records from the controller.
    public List<CNData.CNRelationship> getRelationships() { 
        List<CN_Relationship__c> listRels = (List<CN_Relationship__c>) oSetController.getRecords();
        System.debug('selected records from DB by setController: ' + listRels.size());
        return massageRelationships(listRels);
    }

	//Pulls the next set of records from the set controller
    public PageReference nextPage() {
    	if (hasDataLost() == false) { 
	        oSetController.next();
    	} 
        return null;     
    }
	
	//Pulls the previous set of records from the set controller.
    public PageReference prevPage() { 
    	if (hasDataLost() == false) {
	        oSetController.previous();
    	} 
        return null; 
    }
	
	//Filter the current page result by a starting letter which was selected by the user
    public PageReference filterPage() { 
    	if (hasDataLost() == false) {
	    	this.sStartsWith = ApexPages.currentPage().getParameters().get('indexLetter');
	    	System.debug('indexLetter: ' + sStartsWith);
	    	initSetController();
    	}
        return null; 
    }

	//Sorts the current page result by a single column which was selected by the user
    public PageReference sortPage() {  
    	if (hasDataLost() == false) { 
	    	String sSortByOld = this.sSortBy;
	    	this.sSortBy = ApexPages.currentPage().getParameters().get('sortField');
	    	if (sSortByOld != sSortBy) {
	    		if (sSortBy == 'Last_Modification_Time__c') {
	    			this.sSortDirection = 'DESC';
	    		}
	    		else {
	    			this.sSortDirection = 'ASC';
	    		}
	    		sStartsWith = 'All';
	    	}
	    	else {
	    		this.sSortDirection = ApexPages.currentPage().getParameters().get('sortDirection');
	    	}
	    	System.debug('sortBy: ' + sSortBy + ', sortDirection: ' + sSortDirection);
	    	initSetController();
    	}
        return null; 
    }

	//Calculates the total records count across all pages
    public Integer getTotalRecords() {
		return oSetController.getResultSize();
    }
    
    //Identifies if the list has previous page with at least one record
    public Boolean getHasPreviousPage() {
		return oSetController.getHasPrevious();
    }
	
	//Identifies if the list has next page with at least one record    
    public Boolean getHasNextPage() {
		return oSetController.getHasNext();
    }
    
    //Returns the reference to the current instance
    public CNEnhancedListHandler getCurrentReference() {
    	return this;	
    }
    
    /* ABSTRACT METHODS */
	
	//Prepares the query string for the table    
    public abstract String getQueryString();
      
    //Converts the data structs from one format to another
    public abstract List<CNData.CNRelationship> massageRelationships(List<CN_Relationship__c> listRelationshipInSObject);
    
	//Loads queue handler record
	public abstract void loadQueueHandler();
    
    /* PRIVATE METHODS */
    
    //Initializes the set controller by passing the query string
    protected void initSetController() {
    	Integer pageSize = CNAppUtils.getAppCustomSetting().Enhanced_List_Data_Display_Size__c.intValue();
        if(oSetController==null){
        	oSetController = new ApexPages.StandardSetController(Database.getQueryLocator(getQueryString()));
        }
        oSetController.setPageSize(pageSize);
        this.iTotalRecords = getTotalRecords();
        loadQueueHandler();
        hasDataLost();
    }
	
	//Checks if the data was lost during the middle of user activity. Shows error message to the user to reload the page.
	private Boolean hasDataLost() {
		if(oQueueHandler!=null){
	    	oQueueHandler.refresh();  //Checks if the cache was removed by cleanup job
	    	if (oQueueHandler.oQueue == null) {
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, prepareDataExpiredErrorMessage()));
	    		return true;	
	    	}
		}
    	return false;
	}
	
	//Prepares the error message for data lost reasons. This happens when the data clean up deletes the relationship when it was viewed by end user.    
    private String prepareDataExpiredErrorMessage() {
		String dataType = null;
		if (oQueueHandler.sAcctId != null) {
			dataType = 'account ';
		}
		else {
			dataType = 'contact ';
		}
		
		String msg = 'ContactNet data has expired. Please click the above ' + dataType + 
						'link to refresh the ' + dataType + 'detail page.';
		return msg;
    }
    
}