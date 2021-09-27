/**
* {Purpose} � Contains all constants for API version 14
*
* @author   David Sarbello
* @version  2014.10.21
*/ 

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2014.10.21    David Sarbello          Created
* =============================================================================
*/
public class CNConstants_14 {
    
    //ContactNet 14R1 API URL
    //public static final String URL_14R1_BASE = 'https://163.231.241.6';
    //public static final String DEV_14R1_UID = 'demo';
    //public static final String DEV_14R1_PWD = 'p@ssw0rd';
    
    //ContactNet 14R1 API RESOURCES
    public static final String URL_14R1_LOGIN = '/api/Authentication/Login';
    public static final String URL_14R1_AUTOCOMPLETE = '/api/AutoComplete';
    public static final String URL_14R1_SEARCHRESULTS = '/api/SearchResults';
    public static final String URL_14R1_SEARCHRESULTSDETAILS = '/api/SearchResultsDetail';
    public static final String URL_14R1_RELEASEINFO = '/api/releaseinfo';
    
    //ContactNet 14R1 API AutoComplete BitMasks
    public static final Integer AUTOCOMPLETE_14R1_BITMASK_CONTACTS = 1;
    public static final Integer AUTOCOMPLETE_14R1_BITMASK_CONTACT_TITLES = 2;
    public static final Integer AUTOCOMPLETE_14R1_BITMASK_COLLEAGUES = 4;
    public static final Integer AUTOCOMPLETE_14R1_BITMASK_INDUSTRIES = 8;
    public static final Integer AUTOCOMPLETE_14R1_BITMASK_COMPANIES = 16;
    public static final Integer AUTOCOMPLETE_14R1_BITMASK_LOCATIONS = 32;

    //ContactNet 14R1 API SearchResult ViewTypes
    public static final Integer SEARCHRESULT_14R1_VIEWTYPE_CONTACTS = 1;
    public static final Integer SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES = 2;
    public static final Integer SEARCHRESULT_14R1_VIEWTYPE_COMPANIES = 10;    
    
    public static final Integer HOURS_UNTIL_AUTH_COOKIE_IS_STALE = 8;  
}