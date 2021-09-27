/**
 * {Purpose} � This class should encapsulate all of the direct interactions with
 *        the ContactNet web services including authentication and callouts
 *        for version 14R1 API
 * 
 * @author   David Sarbello
 * @version  2014.10.21
 */

/** 
 * CHANGE HISTORY
 * =============================================================================
 * Date          Name                    Description
 * 2014.10.21    David Sarbello          Created     
 * 2015-08-19       Glen Cunningham         Added login params as constants and contentType
 * 2015-12-01       Glen Cunningham         Added call to release info
 * =============================================================================
 */
public class CNServices_14 {
    //Private variables
    private static final String sClassName = 'CNServices_14';
    public static string CNCompanyID;
    public static string sAccountID;
    public static string sURL_Base;
    public static string sUID;
    public static string sPWD;
    public static string AUTHTOKEN{get;set;}
    public static string OAUTHTOKEN{get;set;}
    public static CNData.CNCompany currCompany{get;set;}
    /* PUBLIC METHODS */    
    /*----------------------------------------------------------------------------------------------*/
    //Represents a Core call to 14R1 - 3 exist (Authenticate, AutoComplete, and SearchResults)
    // ok 4 with this one but it really doesn't count
    public static String ReleaseInfo(string url){           
        CN_App_Settings__c c  = [SELECT  WS_Endpoint__c,WS_Timeout__c,Auth_Cookie_API_14__c FROM CN_App_Settings__c];
        HttpResponse oRes = CNAppUtils_14.getResponse(  
                url + '/' +
                CNConstants_14.URL_14R1_RELEASEINFO, 
                c.WS_Timeout__c,
                'GET','','','','');                 
        if(oRes!=null){
            system.debug('***result of call=:' + oRes.getBody());   
            if(oRes.getStatusCode() == 200){
                string json = oRes.getBody();
                CNData_14_Version ver = CNData_14_Version.parse(json);
                return (ver!=null)?ver.Version:'0';
            }
        }
        return null;        
    }
    /*----------------------------------------------------------------------------------------------*/
    //Represents a Core call to 14R1 - 3 exist (Authenticate, AutoComplete, and SearchResults)
    public static String AutoComplete(Integer iBitMask, String sText){
        system.debug('called Autocomplete with:' + string.valueOf(iBitMask) + ' ' + sText);     
        if(sText==null){return null;}       
        if(CNAppUtils_14.AUTHTOKEN != null){
            CN_App_Settings__c c  = [SELECT  WS_Endpoint__c,WS_Timeout__c,Auth_Cookie_API_14__c FROM CN_App_Settings__c];
            HttpResponse oRes = CNAppUtils_14.getResponse(  
                    c.WS_Endpoint__c + 
                    CNConstants_14.URL_14R1_AUTOCOMPLETE+
                    '?bitmask='+iBitMask+
                    '&text='+sText + '&skip=0&take=1', 
                    c.WS_Timeout__c,
                    'GET','','','','');                 
            if(oRes!=null){
                system.debug('***result of call=:' + oRes.getBody());   
                if(oRes.getStatusCode() == 200){
                    return oRes.getBody();
                }
            }
        }
        return null;
    }    
    /*----------------------------------------------------------------------------------------------*/
    //Represents a Core call to 14R1 - 3 exist (Authenticate, AutoComplete, and SearchResults)

    public static String SearchResults(String sViewType, String sCriteria, String sSkip, String sTake){       
        //
        string sMethodName = 'SearchResults';
        CN_App_Settings__c c  = [SELECT  WS_Endpoint__c,WS_Timeout__c,Auth_Cookie_API_14__c FROM CN_App_Settings__c];
        String sURL = c.WS_Endpoint__c + CNConstants_14.URL_14R1_SEARCHRESULTS;        
        string sBody = 'viewtype='+sViewType;
        sBody += '&criteria='+sCriteria;
        sBody += '&skip='+sSkip;
        sBody += '&take='+sTake;        
        system.debug('@@@@@'+sClassName+'.'+ sMethodName +'; Sending Body:'+sBody);
        try{    
            HttpResponse oRes = CNAppUtils_14.getResponse(  sURL, 
                    c.WS_Timeout__c, 
                    'POST',
                    sBody,
                    '',
                    'application/x-www-form-urlencoded',
                    ''); 
            return oRes.getBody();
        }
        catch(System.CalloutException er){
            system.debug('*********SYSTEM.CALLOUT EXCEPTION in SearchResults');
            return '';
        }catch(Exception e){            
            return '';
        } 
    }      
    //Represents a Core call to 14R1 - 3 exist (Authenticate, AutoComplete, and SearchResults)
    public static String SearchResultsDetails(String sViewType, String ColleagueId, String sCriteria, String sSkip, String sTake){        
        String sMethodName = 'SearchResultsDetails';              
        CN_App_Settings__c c  = [SELECT  WS_Endpoint__c,WS_Timeout__c,Auth_Cookie_API_14__c FROM CN_App_Settings__c];
        String sURL = c.WS_Endpoint__c + CNConstants_14.URL_14R1_SEARCHRESULTSDETAILS;        
        string sBody = 'viewtype='+sViewType;
        sBody += '&id='+ColleagueId;
        sBody += '&criteria='+sCriteria;
        sBody += '&skip='+sSkip;
        sBody += '&take='+sTake;                
        system.debug('@@@@@'+sClassName+'.'+sMethodName +'; Sending Body:'+sBody);
        try{     
            HttpResponse oRes = CNAppUtils_14.getResponse(  sURL, 
                    c.WS_Timeout__c, 
                    'POST',
                    sBody,
                    '',
                    'application/x-www-form-urlencoded',
                    ''); 

            return oRes.getBody();
        }catch(System.CalloutException er){
            system.debug('*********SYSTEM.CALLOUT EXCEPTION in SearchResultsDetails');
            return '';
        }catch(Exception e){            
            return '';
        }     
    }    
    /*----------------------------------------------------------------------------------------------*/
    //Determines how to get/save the Authentication Cookie
    public static String fetchAuthenticationCookie(Boolean bForceAuthentication) {
        return CNAppUtils_14.AUTHTOKEN;/*
        String sMethodName = 'fetchAuthenticationCookie';
        CN_App_Settings__c oCS = CNAppUtils.getAppCustomSetting();
        String sCookie = '';
        if (oCS.Auth_Cookie_API_14_Timestamp__c == null) { //Has it ever been set? If not then we MUST Authenticate.
            bForceAuthentication = true;
        }
        else if (oCS.Auth_Cookie_API_14__c == null || oCS.Auth_Cookie_API_14__c == '') {
            bForceAuthentication = true;
        }       
        else if (oCS.Auth_Cookie_API_14_Timestamp__c != null) { //Is the Auth Cookie really old? If so then we MUST Authenticate
            long iMinutesSinceLastAuthenticated = ((System.Now().getTime() - oCS.Auth_Cookie_API_14_Timestamp__c.getTime()));
            system.debug('@@@@@'+sClassName+'.'+sMethodName +'; Calculated milliseconds:'+iMinutesSinceLastAuthenticated + '; Stale Age: ' + (1000*60*60*CNConstants_14.HOURS_UNTIL_AUTH_COOKIE_IS_STALE));
            if (iMinutesSinceLastAuthenticated > (1000*60*60*CNConstants_14.HOURS_UNTIL_AUTH_COOKIE_IS_STALE)) {
                bForceAuthentication = true;
                system.debug('@@@@@'+sClassName+'.'+sMethodName +'; ForceAuthentication set to:'+bForceAuthentication);
            }
        }
        if (bForceAuthentication) {
            sCookie = Authenticate();
            //Write the received cookie to the Custom Settings
            if (sCookie != null) {
                if (sCookie.length() <= 255) { 
                    oCS.Auth_Cookie_API_14__c           = sCookie;
                    oCS.Auth_Cookie_API_14_Overflow__c  = '';
                }
                else if (sCookie.length() > 255) {
                    oCS.Auth_Cookie_API_14__c           = sCookie.substring(0,255);
                    oCS.Auth_Cookie_API_14_Overflow__c  = sCookie.substring(256);
                    system.debug('@@@@@'+sClassName+'.'+sMethodName +'; sCookie.substring(0,255):'+sCookie.substring(0,255));
                    system.debug('@@@@@'+sClassName+'.'+sMethodName +'; sCookie.substring(256):'+sCookie.substring(255));
                }
                oCS.Auth_Cookie_API_14_Timestamp__c     = System.Now();
            }
            update oCS;
        } else {
            //Get Cookie from Cache/Custom Setting. If missing or invalid then re-authenticate
            sCookie = oCS.Auth_Cookie_API_14__c + oCS.Auth_Cookie_API_14_Overflow__c;
            if (CnAppUtils.isEmpty(sCookie)) 
                sCookie = fetchAuthenticationCookie(true);
        }
        system.debug('@@@@@'+sClassName+'.'+sMethodName +'; Return cookie:'+sCookie);
        return sCookie; */
    }    
    /*----------------------------------------------------------------------------------------------*/
    public static CNData.CNCompany fetchCompany(String sCompanyDomainORCompanyName){
        //if no company die
        if(sCompanyDomainORCompanyName != ''){
            //Make the call to get any matches
            String sJSON = AutoComplete( CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_COMPANIES, sCompanyDomainORCompanyName);
            System.debug('@@@@@ fetchCompany JSON: ' + sJSON);            
            //Parse results
            if(sJSON!=null && sJSON!=''){
                CNData_14_AutoComplete oResults = CNData_14_AutoComplete.parse(sJSON);
                system.debug('*********CNData_14_AutoComplete.parse(sJSON)' + sJSON);
                CNData_14_AutoComplete.Collection oCompany = CNData_14_AutoComplete.getSingleItemSortedByRelationshipCountDesending(oResults);
                CNCompanyID = (oCompany!=null)?oCompany.Id:''; 
                currCompany = CNData_14_AutoComplete.MapTo(oCompany);
                return currCompany;
            }
        }   
        return null;     
    }
    /*----------------------------------------------------------------------------------------------*/
    public static CNData.CNContact fetchContact(String sContactEmail){ 
        //Make the call to get any matches
        System.debug('@@@@@ fetchContact email=: ' + sContactEmail);
        String sJSON = AutoComplete( CNConstants_14.AUTOCOMPLETE_14R1_BITMASK_CONTACTS, sContactEmail);
        System.debug('@@@@@ fetchContact JSON: ' + sJSON);
        if(sJSON!=null){
            if(sJSON.length()>20){
                //Parse results
                CNData_14_AutoComplete oResults = CNData_14_AutoComplete.parse(sJSON);
                CNData_14_AutoComplete.Collection oContact = CNData_14_AutoComplete.getSingleItem(0, oResults);
                return CNData_14_AutoComplete.MapToBaseContact(oContact);
            }
        } 
        return null;
    }    
    /*----------------------------------------------------------------------------------------------*/
    public static list<CNData.CNColleague> fetchCompanyColleagues(CNData.CNCompany oCompany, string sSkip, string sTake) {
        String sJSON = SearchResults(String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES), 
                '{"Companies":[{"Id":"' + oCompany.CNID + '"}]}',
                sSkip, sTake);
        CNData_14_Colleague oColleagues = CNData_14_Colleague.parse(sJSON);        
        return CNData_14_Colleague.MapTo(oColleagues.Results, oCompany);        
    }
    /*----------------------------------------------------------------------------------------------*/
    //Attempts to get COMPANY information for a CONTACT using the CONTACTID
    private static CNData.CNCompany fetchContactsCompany(String sContactCNID) {
        String sMethodName = 'fetchContactsCompany';
        String sJsonData = null;
        CNData.CNCompany oCompany = new CNData.CNCompany(); 
        sJsonData = SearchResults(  String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COMPANIES), 
                '{"Contacts":[{"Id":"' + sContactCNID + '"}]}',
                '0','10');    
        if (Test.isRunningTest()) {
            string json = '{"Filters":[{"lowValue":1,"highValue":5,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"},{"id":2,"name":"AddressBook"}],"name":"sources","on":false,"currentValue":null},{"lowValue":269,"highValue":655,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":279,"highValue":848,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},{"name":"recency","on":false,"currentValue":null},{"values":["Boston","New York","Seville","Washington"],"name":"office","on":false,"currentValue":null},{"values":["Administrative Support","Business & Finance","Commercial Law","Employment","Federal","Human Resources","Immigration","Information Services","Intellectual Property","Litigation","Secretarial Support"],"name":"department","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Office","RenderType":4,"Fields":["Office"]},{"Title":"Department","RenderType":4,"Fields":["Department"]}],"Results":[{"Office":"Boston","Department":"Litigation","Phone":"","FirstName":"William","LastName":"Matsui","Title":"Partner","Email":"wilmatsui@yourcompany.com","Id":504,"Strength":4.81,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-05T00:00:00","Recency":"274 days","RelationshipCount":6},{"Office":"New York","Department":"Litigation","Phone":"","FirstName":"Lauren","LastName":"Weiners","Title":"Associate","Email":"lauweiners@yourcompany.com","Id":328,"Strength":4.58,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-05T00:00:00","Recency":"274 days","RelationshipCount":9},{"Office":"Boston","Department":"Litigation","Phone":"","FirstName":"Scott","LastName":"Durazo","Title":"Partner","Email":"scodurazo@yourcompany.com","Id":522,"Strength":4.48,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-20T00:00:00","Recency":"290 days","RelationshipCount":4},{"Office":"New York","Department":"Litigation","Phone":"","FirstName":"Vanessa","LastName":"Griffiths","Title":"Associate Consultant","Email":"vangriffiths@yourcompany.com","Id":265,"Strength":4.36,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-10T00:00:00","Recency":"269 days","RelationshipCount":18},{"Office":"Boston","Department":"","Phone":"","FirstName":"Mario","LastName":"Ainsworth","Title":"Administrative Secretary","Email":"marainsworth@yourcompany.com","Id":1053,"Strength":3.78,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-29T00:00:00","Recency":"281 days","RelationshipCount":4},{"Office":"New York","Department":"Litigation","Phone":"","FirstName":"Rachna","LastName":"Baird","Title":"Of Counsel","Email":"racbaird@yourcompany.com","Id":288,"Strength":3.66,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-27T00:00:00","Recency":"314 days","RelationshipCount":1},{"Office":"Boston","Department":"Business & Finance","Phone":"","FirstName":"Toni","LastName":"Ramistella","Title":"Associate","Email":"tonramistella@yourcompany.com","Id":963,"Strength":3.61,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-07T00:00:00","Recency":"303 days","RelationshipCount":1},{"Office":"New York","Department":"","Phone":"","FirstName":"Dan","LastName":"Brower","Title":"Legal Secretary","Email":"danbrower@yourcompany.com","Id":369,"Strength":3.55,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-22T00:00:00","Recency":"319 days","RelationshipCount":2},{"Office":"Boston","Department":"Litigation","Phone":"","FirstName":"Nicole","LastName":"Vechionacci","Title":"Associate","Email":"nicvechionacci@yourcompany.com","Id":923,"Strength":3.41,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-11-19T00:00:00","Recency":"352 days","RelationshipCount":2},{"Office":"Boston","Department":"Business & Finance","Phone":"","FirstName":"Erin","LastName":"Young","Title":"Partner","Email":"eriyoung@yourcompany.com","Id":444,"Strength":3.39,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-08T00:00:00","Recency":"333 days","RelationshipCount":2},{"Office":"Boston","Department":"Business & Finance","Phone":"","FirstName":"Joey","LastName":"Sky","Title":"Associate","Email":"joesky@yourcompany.com","Id":986,"Strength":3.27,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-01T00:00:00","Recency":"309 days","RelationshipCount":2},{"Office":"Boston","Department":"Litigation","Phone":"","FirstName":"Giovanna","LastName":"Cabrera","Title":"Partner","Email":"giocabrera@yourcompany.com","Id":547,"Strength":3.26,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-25T00:00:00","Recency":"285 days","RelationshipCount":2},{"Office":"New York","Department":"Administrative Support","Phone":"","FirstName":"Meghann","LastName":"Vanderwal","Title":"Associate","Email":"megvanderwal@yourcompany.com","Id":343,"Strength":3.12,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-10-20T00:00:00","Recency":"1 year<br>17 days","RelationshipCount":1},{"Office":"New York","Department":"Business & Finance","Phone":"","FirstName":"Nick","LastName":"Ruger","Title":"Associate","Email":"nicruger@yourcompany.com","Id":262,"Strength":2.95,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-05T00:00:00","Recency":"274 days","RelationshipCount":1},{"Office":"New York","Department":"Secretarial Support","Phone":"","FirstName":"Helah","LastName":"Kaufman","Title":"Secretary","Email":"helkaufman@yourcompany.com","Id":306,"Strength":2.84,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-16T00:00:00","Recency":"325 days","RelationshipCount":2},{"Office":"New York","Department":"","Phone":"","FirstName":"Eric","LastName":"Young","Title":"Summer Intern","Email":"eyoung@yourcompany.com","Id":42672,"Strength":2.83,"SourcesBitmask":3,"MostRecentSource":1,"MostRecentSourceDate":"2014-10-26T00:00:00","Recency":"1 year<br>11 days","RelationshipCount":1},{"Office":"Boston","Department":"Litigation","Phone":"","FirstName":"Sheryl","LastName":"Dickerson","Title":"Associate","Email":"shedickerson@yourcompany.com","Id":970,"Strength":2.58,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-15T00:00:00","Recency":"326 days","RelationshipCount":1},{"Office":"Boston","Department":"Secretarial Support","Phone":"","FirstName":"Jamie","LastName":"Pope","Title":"Secretary","Email":"jampope@yourcompany.com","Id":784,"Strength":2.45,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-06T00:00:00","Recency":"335 days","RelationshipCount":2},{"Office":"New York","Department":"Commercial Law","Phone":"","FirstName":"Jackie","LastName":"Simons","Title":"Manager of Library Services NY","Email":"jacsimons@yourcompany.com","Id":310,"Strength":2.41,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-31T00:00:00","Recency":"279 days","RelationshipCount":1},{"Office":"New York","Department":"Secretarial Support","Phone":"","FirstName":"Laura","LastName":"Boursiquot","Title":"Secretary","Email":"lauboursiquot@yourcompany.com","Id":292,"Strength":2.41,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-10-26T00:00:00","Recency":"1 year<br>11 days","RelationshipCount":5},{"Office":"New York","Department":"Secretarial Support","Phone":"","FirstName":"Jim","LastName":"Eide","Title":"Secretary","Email":"jimeide@yourcompany.com","Id":303,"Strength":2.30,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-12-16T00:00:00","Recency":"325 days","RelationshipCount":1}],"NumResults":50,"TrackedSearchId":63233}';
        }
         
        CNData_14_SearchResults_ViewType10 oCompanies = CNData_14_SearchResults_ViewType10.parse(sJsonData);
        List<CNData.CNCompany> listCompanies = CNData_14_SearchResults_ViewType10.MapTo(oCompanies.Results);
        if (listCompanies.size() > 0)
            return listCompanies.get(0);
        else
            return oCompany;        
    }
    /*----------------------------------------------------------------------------------------------*/  
    //Create a collection of CNRelationship based on CNData.Colleague
    public static List<CNData.CNRelationship> generateRelationships(String sType, List<CNData.CNColleague> listColleagues) {

        String sMethodName = 'generateRelationships';
        //Build the Relationships.
        List<CNData.CNRelationship> oRelationships  = new List<CNData.CNRelationship>();
        CNData.CNRelationship oRel                  = new CNData.CNRelationship();
        if(listColleagues==null){return null;}
        for (CNData.CNColleague c : listColleagues) {
            System.debug('@@@@@' + sClassName + '.' + sMethodName + ' Colleague: =>' + c);
            oRel = new CNData.CNRelationship();
            oRel.Type = sType; //CnConstants.RELATIONSHIP_TYPE_TOCOMPANY; 
            oRel.colleague = c;
            //oRel.contact = c.
            oRel.company = c.company;          
            oRel.score = c.score;
            //set graph display values
            if(c.score>0.49){oRel.d1 = 'selected';}
            if(c.score>1.49){oRel.d2 = 'selected';}
            if(c.score>2.49){oRel.d3 = 'selected';}
            if(c.score>3.49){oRel.d4 = 'selected';}
            if(c.score>4.49){oRel.d5 = 'selected';}
            if(c.score>5.49){oRel.d6 = 'selected';}
            if(c.score>6.49){oRel.d7 = 'selected';}
            system.debug('############score=' + c.score + ' d1=' + oRel.d1);
            oRel.normalizedScore = c.normalizedScore;
            oRel.sources = c.sources;
            oRelationships.add(oRel);
        }           
        return oRelationships;
    }
    /*----------------------------------------------------------------------------------------------*/
    //Get a stated CNCompany using CompanyDomain or CompanyName
    public static CNData.CNCompany LoadCompany(String sCompanyName, String sCompanyDomain) {
        String sCompanySearch = '';

        CNData.CNCompany oCompany = new CNData.CNCompany();
        sCompanySearch = (CNAppUtils.isEmpty(sCompanyDomain) ? sCompanyName : sCompanyDomain);

        if (!CNAppUtils.isEmpty(sCompanySearch))
            oCompany = fetchCompany(sCompanySearch);

        return oCompany;
    }
    /*----------------------------------------------------------------------------------------------*/
    public static CNData.CNWebserviceResult fetchCompanyContacts(String sCompanyName, String sCompanyDomain, String sCompanyCNID, Integer iContactSize, 
            Integer iContactIndex, Boolean isFutureContext) {
        String sMethodName = 'fetchCompanyContacts';
        system.debug('@@@@@'+sClassName + '.' + sMethodName + '; Enter'); 
        //string coID = sCompanyCNID; 
        CNData.CNCompany oCompany = new CNData.CNCompany(); 
        oCompany = LoadCompany(sCompanyName, sCompanyDomain); 
        //      
        String sJsonData = null;
        CNData.CNWebserviceResult oResult   = new CNData.CNWebserviceResult();               
        try {
            sJsonData = SearchResults(  String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_CONTACTS), 
                    '{"Companies":[{"Id":"' + sCompanyCNID + '"}]}',
                    String.ValueOf(iContactIndex),
                    String.ValueOf(iContactSize));
            System.debug('###########+++>' + sClassName + '.' + sMethodName + ' sJsonData: ' + sJsonData);
        }
        catch (Exception e) {
            String moreInfo = 'sCompanyName: ' + sCompanyName + ', sCompanyDomain: ' + sCompanyDomain + ', sCompanyCNID: ' + sCompanyCNID + 
                    ', iContactSize: ' + iContactSize + ', iContactIndex: ' + iContactIndex + ', isFutureContext: ' + isFutureContext;
            system.debug('error calling out to fetchCompanyContacts ' + moreInfo );
            return prepareServiceError(e, oResult, isFutureContext, moreInfo);
        }
        if (Test.isRunningTest()) {
            sJsonData = '{"Filters":[{"lowValue":1,"highValue":5,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"},{"id":2,"name":"AddressBook"}],"name":"sources","on":false,"currentValue":null},{"lowValue":199,"highValue":585,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":209,"highValue":778,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},{"name":"recency","on":false,"currentValue":null},{"lowValue":199,"highValue":585,"name":"userActivity","on":false,"currentValue":null},{"values":[{"id":3,"name":"Entry-Level"},{"id":5,"name":"Management/Advisor"}],"name":"seniority","on":false,"currentValue":null},{"values":[],"name":"functions","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Company","RenderType":3,"Fields":["OrganizationName"]}],"Results":[{"OrganizationId":5000428393,"OrganizationName":"Simpson Thacher And Bartlett Mnp Llp","Phone":null,"Industry":"<IndustryGroupPaths><IndustryGroupPath>Professional, Scientific, and Technical Services &amp;gt; Legal Services &amp;gt; Offices of Lawyers</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"","LastName":"","Title":"","Email":"tmcevoy@stblaw.com","Id":1644555,"Strength":4.71,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-05T00:00:00","Recency":"204 days","RelationshipCount":9},{"OrganizationId":5000428393,"OrganizationName":"Simpson Thacher And Bartlett Mnp Llp","Phone":null,"Industry":"<IndustryGroupPaths><IndustryGroupPath>Professional, Scientific, and Technical Services &amp;gt; Legal Services &amp;gt; Offices of Lawyers</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"","LastName":"","Title":"","Email":"mchepiga@stblaw.com","Id":1671425,"Strength":4.46,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-02T00:00:00","Recency":"207 days","RelationshipCount":6},{"OrganizationId":5000428393,"OrganizationName":"Simpson Thacher And Bartlett Mnp Llp","Phone":null,"Industry":"<IndustryGroupPaths><IndustryGroupPath>Professional, Scientific, and Technical Services &amp;gt; Legal Services &amp;gt; Offices of Lawyers</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Tara","LastName":"Gabbai","Title":"","Email":"tgabbai@stblaw.com","Id":1669115,"Strength":4.16,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-05T00:00:00","Recency":"204 days","RelationshipCount":1},{"OrganizationId":5000428393,"OrganizationName":"Simpson Thacher And Bartlett Mnp Llp","Phone":"212-455-2000-455-2861","Industry":"<IndustryGroupPaths><IndustryGroupPath>Professional, Scientific, and Technical Services &amp;gt; Legal Services &amp;gt; Offices of Lawyers</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"David","LastName":"Elbaum","Title":"","Email":"delbaum@stblaw.com","Id":1658379,"Strength":4.16,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-20T00:00:00","Recency":"220 days","RelationshipCount":4},{"OrganizationId":5000428393,"OrganizationName":"Simpson Thacher And Bartlett Mnp Llp","Phone":"212-455-2000","Industry":"<IndustryGroupPaths><IndustryGroupPath>Professional, Scientific, and Technical Services &amp;gt; Legal Services &amp;gt; Offices of Lawyers</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Kenneth","LastName":"Logan","Title":"","Email":"klogan@stblaw.com","Id":1691073,"Strength":4.04,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-20T00:00:00","Recency":"220 days","RelationshipCount":4}],"NumResults":67,"TrackedSearchId":38395}';
        }
        if(sJsonData.contains('{"Filters":[{"lowValue"')==false){return null;}
        CNData_14_Contact oContacts = CNData_14_Contact.parse(CNAppUtils.decodeJsonFieldNames(sJsonData));
        if(oContacts==null){return null;}
        List<CNData.CNContact> listContacts = CNData_14_Contact.MapTo(oContacts.Results, oCompany);
        oResult.listContacts = new List<CNData.CNContact>();
        for (CNData.CNContact oCont : listContacts) {
            oResult.listContacts.add(oCont);
        }
        if(oCompany==null){return null;}   
        oResult.sCompanyCNID = oCompany.CNID;
        //Set relationship count based on how we got the Company information
        oResult.iTotalRelationships = listContacts.size();//oCompany.NumberOfContacts;//(bSearchCompany ? oCompany.NumberOfContacts : listContacts.size());
        System.debug('@@@@@' + sClassName + '.' + sMethodName + ': returning response: ' + oResult);
        return oResult;
    }
    /*----------------------------------------------------------------------------------------------*/
    public static CNData.CNWebserviceResult fetchCompanyColleagues(String sCompanyName, String sCompanyDomain, String sCompanyCNID, Integer iSize, 
            Integer iIndex, Boolean isFutureContext) {

        String sMethodName                  = 'fetchCompanyColleagues';
        system.debug('@@@@@'+sClassName + '.' + sMethodName + '; Enter');
        CNData.CNWebserviceResult oResult   = new CNData.CNWebserviceResult();
        String sJsonData                    = null;
        CNData.CNCompany oCompany           = new CNData.CNCompany();
        Boolean bSearchCompany = false;
        try {
            //Set the flag to indicate if we searched for the company record or are building it
            bSearchCompany = ( CNAppUtils.isEmpty(sCompanyCNID) ? true : false);
            if (bSearchCompany) 
                oCompany = LoadCompany(sCompanyName, sCompanyDomain);
            else
                oCompany.CNID = sCompanyCNID;
            string oCompanyCNID = (oCompany!=null)?oCompany.CNID:'';
            if(oCompany==null) return null;
            sJsonData = SearchResults(  String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES), 
                    '{"Companies":[{"Id":"' + oCompanyCNID + '"}]}',
                    String.ValueOf(iIndex),
                    String.ValueOf(iSize));
            System.debug('@@@@@' + sClassName + '.' + sMethodName + ' sJsonData: ' + sJsonData);
            if (validateJsonData(sJsonData, 'SearchResults', isFutureContext) == false) {
                oResult.errorFound = true;
                return oResult;
            }
        }
        catch (Exception e) {
            String moreInfo = 'sCompanyName: ' + sCompanyName + ', sCompanyDomain: ' + sCompanyDomain + ', sCompanyCNID: ' + sCompanyCNID + 
                    ', iSize: ' + iSize + ', iIndex: ' + iIndex + ', isFutureContext: ' + isFutureContext;
            return prepareServiceError(e, oResult, isFutureContext, moreInfo);
        }
        CNData_14_Colleague oColleagues = CNData_14_Colleague.parse(sJsonData);
        system.debug('**********CNData_14_Colleague:' + sJsonData);
        List<CNData.CNColleague> listColleagues = CNData_14_Colleague.MapTo(oColleagues.Results, oCompany);
        //Build the Relationships.
        List<CNData.CNRelationship> oRelationships  = new List<CNData.CNRelationship>();
        oRelationships = generateRelationships(CnConstants.RELATIONSHIP_TYPE_TOCOMPANY, listColleagues);
        oResult.listRelationships = oRelationships;
        oResult.sCompanyCNID = oCompany.CNID;
        //Set relationship count based on how we got the Company information
        oResult.iTotalRelationships = (oRelationships!=null)?oRelationships.size():0;
        System.debug('@@@@@' + sClassName + '.' + sMethodName + ': returning response: ' + oResult);
        return oResult;
    }   
    /*----------------------------------------------------------------------------------------------*/  
    //Drilldown on a Colleague on Colleague Tab on Account
    public static CNData.CNWebserviceResult fetchRelationshipsForColleague(String sColleagueCNID, String sCompanyCNID, Integer iSize, Integer iIndex) {

        String sMethodName = 'fetchRelationshipsForColleague';
        system.debug('@@@@@'+sClassName + '.' + sMethodName + '; Enter');        
        CNData.CNWebserviceResult oResult = new CNData.CNWebserviceResult();
        String sJsonData  = null;
        try {            
            System.debug('@@@@@' + sClassName + '.' + sMethodName +  'ViewType:' + CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_CONTACTS + ' sColleagueCNID: ' + sColleagueCNID +  ' sCompanyCNID: ' + sCompanyCNID +  ' iSize: ' + iSize +  ' iIndex: ' + iIndex);
            sJsonData = SearchResultsDetails(String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_CONTACTS), 
                    sColleagueCNID,
                    '{"IsOrSearch":false, "Companies":[{"Id":"' + sCompanyCNID + '"}]}', //NOTE: This could be "Contacts" "Colleagues" instead?????
                    String.ValueOf(iIndex),
                    String.ValueOf(iSize));
            System.debug('@#@#@' + sClassName + '.' + sMethodName +  ' sJsonData: ' + sJsonData);
            if (validateJsonData(sJsonData, 'SearchResults', false) == false) {
                oResult.errorFound = true;
                return oResult;
            }
        }
        catch (Exception e) {
            String moreInfo = 'sColleagueCNID: ' + sColleagueCNID + ', sCompanyCNID: ' + sCompanyCNID + ', iSize: ' + iSize + ', iIndex: ' + iIndex;
            return prepareServiceError(e, oResult, false, moreInfo);
        }
        system.debug('attempting parse on colleague json');
        CNData_14_ColleagueContacts oColleagues = CNData_14_ColleagueContacts.parse(sJsonData);
        system.debug('succeeded in parsing coleagueContact json');
        if(oColleagues==null){return null;}
        CNData.CNCompany oCompany   = new CNData.CNCompany();
        oCompany.CNID               = sCompanyCNID;
        system.debug('attempting mapto on colleague list size of list=' + oColleagues.Relationships.size());
        List<CNData.CNRelationship> listColleagues = CNData_14_ColleagueContacts.MapTo(oColleagues.Relationships, oCompany);
        ///**************************** need to  create releationships  
        for(CNData.CNRelationship oRel : listColleagues ){
            oRel.Type = 'toColleague';
            CNData.CNContact c = oRel.contact;
            oRel.company = c.company;          
            oRel.score = c.score;
            //set graph display values
            if(c.score>0.49){oRel.d1 = 'selected';}
            if(c.score>1.49){oRel.d2 = 'selected';}
            if(c.score>2.49){oRel.d3 = 'selected';}
            if(c.score>3.49){oRel.d4 = 'selected';}
            if(c.score>4.49){oRel.d5 = 'selected';}
            if(c.score>5.49){oRel.d6 = 'selected';}
            if(c.score>6.49){oRel.d7 = 'selected';}
            system.debug('############score=' + c.score + ' d1=' + oRel.d1);
            oRel.normalizedScore = c.normalizedScore;
            //oRel.index =
            oRel.sources = c.sources;
        }
        oResult.listRelationships   = listColleagues;
        oResult.sContactCNID        = sColleagueCNID;
        oResult.sCompanyCNID        = oCompany.CNID;
        oResult.iTotalRelationships = listColleagues.size();
        return oResult;
    } 
    /*----------------------------------------------------------------------------------------------*/      
    //Performs contact search (based on email address) and returns the colleague relationships for that contact. 
    public static CNData.CNWebserviceResult fetchRelationshipsForContactEmail(String sEmailAddress, Integer iRelationshipSize) {
        //Multiple Steps
        // Step 1 - AutoComplete using Contact Email and bitmask = AUTOCOMPLETE_14R1_BITMASK_CONTACTS
        // Step 2 - SearchResults using Step 1's returned ID and viewType = SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES
        // STEP 3 - AutoComplete call using "OrganizationName" (STEP 1) and bitmask=16 to Get Company ID
        
        String sMethodName                  = 'fetchRelationshipsForContactEmail';
        system.debug('@@@@@'+sClassName + '.' + sMethodName + '; Enter');
        CNData.CNWebserviceResult oResult   = new CNData.CNWebserviceResult();
        String sJsonData                    = null;
        //STEP 1        
        CNData.CNContact oContact = fetchContact(sEmailAddress);
        if(oContact==null){return null;}
        system.debug('fetch contact returned:'+ oContact);
        try {
            //STEP 2
            sJsonData = SearchResults(  String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES), 
                    '{"Contacts":[{"Id":"' + oContact.CNID + '"}]}',
                    '0',
                    String.ValueOf(iRelationshipSize));
            System.debug('@@@@@4444' + sClassName + '.' + sMethodName + ' sJsonData: ' + sJsonData);
            if (validateJsonData(sJsonData, 'SearchResults', false) == false) {
                oResult.errorFound = true;
                return oResult;
            }
        }
        catch (Exception e) {
            String moreInfo = 'Getting Colleagues (' + sMethodName + ') sEmailAddress: ' + sEmailAddress + ', iRelationshipSize: ' + iRelationshipSize;
            return prepareServiceError(e, oResult, false, moreInfo);
        }
        CNData_14_Colleague oColleagues         = new CNData_14_Colleague();
        List<CNData.CNColleague> listColleagues = new List<CNData.CNColleague>();
        CNData.CNCompany oCompany               = new CNData.CNCompany();
        if (Test.isRunningTest()) {
            sJsonData = '{"Results":[{"Office":"Washington","Department":"Administrative Support","Phone":"","FirstName":"Gina","LastName":"Boil","Title":"Senior Counsel","Email":"ginboil@yourcompany.com","Id":33144,"Strength":4.26,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":7},{"Office":"Boston","Department":"Information Services","Phone":"","FirstName":"Eric","LastName":"Ripa","Title":"Senior Systems Administrator","Email":"eriripa@yourcompany.com","Id":709,"Strength":3.78,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":17},{"Office":"Boston","Department":"Secretarial Support","Phone":"","FirstName":"Jason","LastName":"Lurenz","Title":"Secretary","Email":"jaslurenz@yourcompany.com","Id":700,"Strength":3.73,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":1},{"Office":"Boston","Department":"Employment","Phone":"","FirstName":"Peter","LastName":"Kovach","Title":"Assistant","Email":"pkovach@yourcompany.com","Id":40998,"Strength":3.51,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":1},{"Office":"New York","Department":"","Phone":"","FirstName":"Ashley","LastName":"Dorai","Title":"Senior Vice President","Email":"ashdorai@yourcompany.com","Id":331,"Strength":3.47,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-05-04T18:34:13.62","Recency":"114 days","RelationshipCount":2}],"NumResults":59,"TrackedSearchId":38328}';
        }
        
        try {
            oColleagues = CNData_14_Colleague.parse(sJsonData);
            //STEP 3
            //oCompany = fetchCompany(oContact.OrganizationName);
            oCompany = fetchContactsCompany(oContact.CNID);
            listColleagues = CNData_14_Colleague.MapTo(oColleagues.Results, oCompany);          
        }
        catch (Exception e) {
            String moreInfo = 'Getting Company (' + sMethodName + ') sEmailAddress: ' + sEmailAddress + ', iRelationshipSize: ' + iRelationshipSize;
            return prepareServiceError(e, oResult, false, moreInfo);
        }
        //Build the Relationships.
        List<CNData.CNRelationship> oRelationships  = new List<CNData.CNRelationship>();
        oRelationships = generateRelationships(CnConstants.RELATIONSHIP_TYPE_TOCONTACT, listColleagues);
        system.debug('finished generating relationships oRelationships.size=' +oRelationships.size() ) ;   
        oResult.listRelationships   = oRelationships;
        oResult.sContactCNID        = oContact.CNID;
        oResult.sCompanyCNID        = oCompany.CNID;
        oResult.iTotalRelationships = oRelationships.size(); //oContact.NumberOfRelationships;
        System.debug('returning response: ' + oResult);
        return oResult;
    }  
    /*----------------------------------------------------------------------------------------------*/  
    public static CNData.CNWebserviceResult fetchRelationshipsForContactCNID(String sContactCNID, Integer iSize, Integer iIndex, Boolean isFutureContext) {
        //Multiple Steps
        // Step 1 - SearchResults using sContactCNID to attempt to get the Contact Company information
        // STEP 2 - SearchResults call using sContactCNID and SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES to get Colleagues for Contact

        String sMethodName                      = 'fetchRelationshipsForContactCNID';
        system.debug('@@@@@'+sClassName + '.' + sMethodName + '; Enter');
        CNData.CNWebserviceResult oResult       = new CNData.CNWebserviceResult();
        String sJsonData                        = null;
        CNData.CNCompany oCompany               = new CNData.CNCompany();
        List<CNData.CNColleague> listColleagues = new List<CNData.CNColleague>();  
        try {
            //STEP 1
            oCompany = fetchContactsCompany(sContactCNID);
            //STEP 2
            sJsonData = SearchResults(  String.ValueOf(CNConstants_14.SEARCHRESULT_14R1_VIEWTYPE_COLLEAGUES), 
                    '{"Contacts":[{"Id":"' + sContactCNID + '"}]}',
                    String.ValueOf(iIndex),
                    String.ValueOf(iSize));
            System.debug('@@@@@' + sClassName + '.' + sMethodName + ' sJsonData: ' + sJsonData);
            if (validateJsonData(sJsonData, 'SearchResults', isFutureContext) == false) {
                oResult.errorFound = true;
                return oResult;
            }
            CNData_14_Colleague oColleagues = new CNData_14_Colleague();
            oColleagues     = CNData_14_Colleague.parse(sJsonData);
            listColleagues  = CNData_14_Colleague.MapTo(oColleagues.Results, oCompany);         
        }
        catch (Exception e) {
            String moreInfo = 'Getting Colleagues (' + sMethodName + ') sContactCNID: ' + sContactCNID+ ', iSize: ' + iSize + ', iIndex: ' + iIndex + ', isFutureContext: ' + isFutureContext;
            return prepareServiceError(e, oResult, isFutureContext, moreInfo);
        }
        //Build the Relationships.
        List<CNData.CNRelationship> oRelationships  = new List<CNData.CNRelationship>();
        oRelationships = generateRelationships(CnConstants.RELATIONSHIP_TYPE_TOCONTACT, listColleagues);
        oResult.listRelationships   = oRelationships;
        oResult.sContactCNID        = sContactCNID;
        oResult.sCompanyCNID        = oCompany.CNID;
        oResult.iTotalRelationships = oRelationships.size();
        System.debug('returning response: ' + oResult);
        return oResult;
    }   

    //Checks if the web service response has invalid data
    private static Boolean hasNonJsonData(String oData) {
        return CNAppUtils.isEmpty(oData) || oData.startsWith('<') || oData.Contains('error');
    }

    //Validates json response and adds invalid json response message to visual force page if error found. If no issues, returns true.
    public static Boolean validateJsonData(String sJsonData, String sAPI, Boolean bIsFutureContext) {

        if (hasNonJsonData(sJsonData)) {
            String sErrorMessage = 'CN Web service returned invalid content';  
            String sMoreInfo = 'API: ' + sAPI + ', JSON Response: ' + CNAppUtils.trim(sJsonData, 1000); 
            CNAppUtils.handleException(new CNData.CNExceptionInfo(sErrorMessage, ApexPages.Severity.ERROR, 
                    sClassName, 'validateJsonData()', 
                    sMoreInfo, !bIsFutureContext, true, true, 'Invalid JSON Data'));
            return false;
        }
        return true;
    } 

    //Prepares error messages when exception occurs during web service call out
    private static CNData.CNWebserviceResult prepareServiceError(Exception oExp, CNData.CNWebserviceResult oResult, 
            Boolean bIsFutureContext, String sMoreInfo) {
        CNAppUtils.handleException(new CNData.CNExceptionInfo(oExp, ApexPages.Severity.ERROR, 
                sClassName, 'prepareServiceError()',
                sMoreInfo, !bIsFutureContext, true, 'CN Service Error'));
        oResult.errorFound = true;
        System.debug('error has been located. oResult: ' + oResult);
        return oResult;
    }
}