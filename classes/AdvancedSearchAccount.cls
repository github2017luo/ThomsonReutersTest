/**
 * Represents an Advanced Search Account for use with the AdvancedSearchWS web service
 * <p>
 * Provides methods for sorting
 *
 * @author  John De Santiago
 * @version 2012-07-23
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-23   John De Santiago        Created 
 * 2013-02-12   Glenda Ninan            Defect #3740 - Remove field Number Of Attorneys - Loc
 * 2013-04-24   Nandita Shet            QC #3702 - Add field Number Of Attorneys - Org
 * 2017-09-27   Rinesh Rajan            Added line to get Source_System_Details  Id and Name 
 * 2018-01-06   Arti Choudhari          Mdified code [CRM-11595]- Added a boolean variable to store the seleted records from Advanced Search page 
 * =============================================================================
 */
global class AdvancedSearchAccount implements Comparable {
    public Id AccountId {get;set;}
    public Id SSDID {get;set;} 
    public string SSDIDName {get;set;}
    public string Name {get;set;}
    public string Name2 {get;set;}
    public string Name3 {get;set;}
    public string SAPAccountNumber {get;set;}
    public string Phone1 {get;set;}
    public string AddressLine1 {get;set;}
    public string City {get;set;}
    public string State {get;set;}
    public integer NumberOfAttorneyLocations {get;set;}
    public integer NumberOfAttorneyOrg {get;set;}
    public integer TotalActiveSubs {get;set;}
    public integer TotalLapsedSubs {get;set;}
    public string ContactName {get;set;}
    public string ZipCode {get;set;}
    public string SortBy {get;set;}
    public boolean SortAscending {get;set;}
	//Arti: To store the seleted records from Advanced Search page
    public boolean bSelected {get;set;}
    //Constructors
    
    /**
     * Default Constructor
     */
    public AdvancedSearchAccount() {
        this.SortBy = 'Name';
        this.SortAscending = true;
        this.NumberOfAttorneyOrg = 0;
        this.bSelected=false;
        //this.NumberOfAttorneyLocations = 0;
        //this.TotalActiveSubs = 0;
        //this.TotalLapsedSubs = 0;
    }
    
    /**
     * Compares the current object with the specified object
     *
     * @param   compareTo   an object which can be casted to an AdvancedSearchAccount
     */
    global Integer compareTo(Object compareTo) {
        AdvancedSearchAccount oCompareTo = (AdvancedSearchAccount) compareTo;
        
        if (SortBy == 'Name') {
            return compareStrings(this.Name, oCompareTo.Name);
        }
        else if (SortBy == 'Name2') {
            return compareStrings(this.Name2, oCompareTo.Name2);
        }
        else if (SortBy == 'Name3') {
            return compareStrings(this.Name3, oCompareTo.Name3);
        }
        else if (SortBy == 'SAPAccountNumber') {
            return compareStrings(this.SAPAccountNumber, oCompareTo.SAPAccountNumber);
        }
        else if (SortBy == 'Phone1') {
            return compareStrings(this.Phone1, oCompareTo.Phone1);
        }
        else if (SortBy == 'AddressLine1') {
            return compareStrings(this.AddressLine1, oCompareTo.AddressLine1);
        }
        else if (SortBy == 'City') {
            return compareStrings(this.City, oCompareTo.City);
        }
        else if (SortBy == 'State') {
            return compareStrings(this.State, oCompareTo.State);
        }
        else if (SortBy == 'NumberOfAttorneyLocations') {
            return compareIntegers(this.NumberOfAttorneyLocations, oCompareTo.NumberOfAttorneyLocations);
        }
        else if (SortBy == 'NumberOfAttorneyOrg') {
            return compareIntegers(this.NumberOfAttorneyOrg, oCompareTo.NumberOfAttorneyOrg);
        }
        else if (SortBy == 'TotalActiveSubs') {
            return compareIntegers(this.TotalActiveSubs, oCompareTo.TotalActiveSubs);
        }
        else if (SortBy == 'TotalLapsedSubs') {
            return compareIntegers(this.TotalLapsedSubs, oCompareTo.TotalLapsedSubs);
        }
        else if (SortBy == 'ContactName') {
            return compareStrings(this.ContactName, oCompareTo.ContactName);
        }
        else if (SortBy == 'ZipCode') {
            return compareStrings(this.ZipCode, oCompareTo.ZipCode);
        }
        else {
            return 0;
        }
    }
    
    //Private Methods
    
    /**
     * Performs a string comparison for the specified values
     *
     * @param   sVal1   primary comparison value
     * @param   sVal2   secondary comparison value
     * @return  an integer
     */
    private integer compareStrings(string sVal1, string sVal2) {
        sVal1 = AppUtil.isNull(sVal1, '');
        sVal2 = AppUtil.isNull(sVal2, '');
        
        integer iCompare = sVal1.compareTo(sVal2);
        return SortAscending ? iCompare : iCompare * -1;
    }
    
    /**
     * Performs an integer comparison for the specified values
     *
     * @param   iVal1   primary comparison value
     * @param   iVal2   secondary comparison value
     * @return  an integer 
     */
    private integer compareIntegers(integer iVal1, integer iVal2) {
        iVal1 = AppUtil.isNull(iVal1, 0);
        iVal2 = AppUtil.isNull(iVal2, 0);
        
        if (iVal1 > iVal2) {
            return SortAscending? 1 : -1;
        }
        else if (iVal1 < iVal2) {
            return SortAscending ? -1 : 1;
        }
        else {
            return 0;
        }
    }
}