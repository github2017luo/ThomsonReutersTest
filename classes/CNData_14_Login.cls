/**
*  CNData_14_Login Provides parse of Login call to CN API
*
* @author   Glen Cunningham
* @version  2015.11.5
*/ 

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
*  
* =============================================================================
*/
public class CNData_14_Login {

  public String status;
  public String token;
  public Integer userId;
  public Integer userAccessGroupId;
  public String fullName;
  public Features features;

  public class Features {
    public Boolean hasCorporateIntelligenceShowNetworkUpdates;
    public Boolean hasDashboardShowNetworkUpdates;
    public Boolean hasEnableSignatureViewing;
    public Boolean hasFirmReportsActivities;
    public Boolean hasFirmReportsCompanyOverview;
    public Boolean hasFirmReportsContactOverview;
    public Boolean hasFirmReportsFriendlyColleagues;
    public Boolean hasFirmReportsIndustryGroupOverview;
    public Boolean hasFirmReportsNewRelationships;
    public Boolean hasFirmReportsRelationshipsByTitle;
    public Boolean hasFirmReportsSearchExport;
    public Boolean hasFirmReportsUsageReport;
    public Boolean hasNetworkUpdatesShowCalendarAppointments;
    public Boolean hasNetworkUpdatesShowNewRelationships;
    public Boolean hasNetworkUpdatesShowRoleChanges;
    public Boolean hasSavedSearchesCreateAndEdit;
    public Boolean hasSearchBulkEmail;
    public Boolean hasSearchColleagues;
    public Boolean hasSearchCompanies;
    public Boolean hasSearchContacts;
    public Boolean hasSearchIndustries;
    public Boolean hasSearchLocations;
    public Boolean hasSearchResultsColleagues;
    public Boolean hasSearchResultsCompanies;
    public Boolean hasSearchResultsContacts;
    public Boolean hasSearchResultsIndustries;
    public Boolean hasSearchResultsLocations;
    public Boolean hasSearchResultsNewColleagues;
    public Boolean hasSearchResultsNewContacts;
    public Boolean hasSearchResultsOutOfTouchContacts;
    public Boolean hasSearchResultsOutOfTouchPersonal;
    public Boolean hasSearchResultsStrongRelationships;
    public Boolean hasSearchResultsViews;
    public Boolean hasSharingAddressBook;
    public Boolean hasSharingCalendar;
    public Boolean hasSharingMail;
    public Boolean hasShowSourcedSignatures;
    public Boolean hasShowVCard;
    public Boolean hasSyncAddressBook;
    public Boolean hasSyncCalendar;
    public Boolean hasSyncMail;
    public Boolean hasSyncSignatures;
    public Boolean hasUserAdmin;
  }

  
  public static CNData_14_Login parse(String json) {
  	if(json!=''){
    	return (CNData_14_Login) System.JSON.deserialize(json, CNData_14_Login.class);
  	}
  	return null;
  }
  
}