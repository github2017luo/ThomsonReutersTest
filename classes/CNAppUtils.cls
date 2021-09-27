/**
* {Purpose} - Application utility methods which are reusable across various parts with in the application.
*
* @author   Shah Kadirmohideen
* @version  2011-10-26
*/
  
/** 
* CHANGE HISTORY
* =============================================================================
* Date          Name                            Description
* 2011-10-26    Shah Kadirmohideen              Created
* 2012-01-01    Shah Kadirmohideen              Added the following methods:
                                                    decodeJsonFieldNames(), parseRelationshipData(), parseContactsData(), parseCompanyData()     
* 2012-01-20    Shah Kadirmohideen              Incorporated enhanced list (go to list) functionality related changes.
* 2012-01-30    Mike Eaton                      Added isChatterEnabled method
* 2012-02-03    Mike Eaton                      Fix BUG-0081 - Object 'AccountFeed' related error
* 2012-04-29    Shah Kadirmohideen              Modified getTopDomain() signature. Enhanced error handling by including additional attributes in the email.
*                                               Added concatenateListIds() method
* 2012-05-04    Shah Kadirmohideen              Added fix for Exception: No content to map to Object due to end of input - by checking for empty string before
*                                               invoking JSON.deserialize() method.
* 2012-07-13    Shah Kadirmohideen              Fixed Array Index Out of Bounds error in getTopDomain() method
* 2012-07-16    Shah Kadirmohideen              Added prepareExceptionGenericInfo() method
* 2012-09-30    Shah Kadirmohideen              Added handleException() and generateToken() methods
* 2013-08-19    Mike Eaton                      Added support for Data_Sensitive_Display_Value__c field
* 2013-08-30    Mike Eaton                      Updated to stub out new Addresses & Signatures JSON response nodes
* 2013-09-06    Mike Eaton                      TODO:  Update to a newer API version to automatically ignore JSON attribute errors
* 2014-06-01    Mike Eaton                      Added WS getSecurityToken method
* 2014-06-07    Mike Eaton                      Added asynch insertLogEntry()
* 2014-07-13    Mike Eaton                      Added Security_Token__c and Support_Notification_Email__c field to custom app settings
* 2014-08-27    David Sarbello                  Modified method insertLogEntry for tracking user interaction
* 2014-09-06    David Sarbello                  Added method to generate CSV contents for Audit Log
* 2014-09-07    David Sarbello                  Over load method sendEmail to allow for attachment
* 2014-09-11    Mike Eaton                      Added sendSecurityToken() method
* 2014-09-12    Mike Eaton                      Added insertAuditLog() calls
* 2014-09-15    David Sarbello                  Modified getAppCustomSetting, isServiceActive per Mike E. to resolve DEAD_LOCK issues during testing
* 2014-09-23    Mike Eaton                      Updated API version from 23.0 to 25.0 for JSON parsing behavior
* 2014-09-23    David Sarbello                  Modified fetchExistingCustomSetting - added WS_API_Version__c
* 2014-11-16  	Mike Eaton 						Re-added custom settings for Contact Action's Search/Add and Show Email/Phone 
* 2014-12-01 	Mike Eaton 						Corrected inconsistencies in codebase
* 2014-12-09	Mike Eaton						Added getContactEnableActionColumn()
* =============================================================================
*/
public class CNAppUtils {     
    public static String sHttpBodyInTestContext;  //Used in test context. Test method will set the expected value on this variable. 
    public static Map<String, String> mapJSONFieldMapping = new Map<String, String>();  //key->what we get from CN, value->local variable name in CNData class
      
    static {
        mapJSONFieldMapping.put('"PhoneNumbers"', '"Phones"');
        mapJSONFieldMapping.put('"Name"', '"companyName"');
        mapJSONFieldMapping.put('"ScoreValue"', '"score"');
        mapJSONFieldMapping.put('"Number"', '"phoneNumber"');
        mapJSONFieldMapping.put('"Location"', '"workingLocation"');
    }
     
    public static String decodeJsonFieldNames(String sJSONString) {
        for (String sJSONFieldName : mapJSONFieldMapping.keySet()) {
            String sObjectFieldName = mapJSONFieldMapping.get(sJSONFieldName);
            sJSONString = sJSONString.replace(sJSONFieldName, sObjectFieldName);
        }   
        return sJSONString;
    }
    
    //Parses contact relationships JSON into usable local objects.
    public static List<CNData.CNRelationship> parseRelationshipData(String sJSONString) {
        if (isEmpty(sJSONString)) return new List<CNData.CNRelationship>();        
        sJSONString = CNAppUtils.decodeJsonFieldNames(sJSONString);
        List<CNData.CNRelationship> listRelationships =
                (List<CNData.CNRelationship>)JSON.deserialize(sJSONString, List<CNData.CNRelationship>.class);

        System.debug('json parsing complete');
        System.debug('listRelationships: ' + listRelationships);
        if (listRelationships != null) {
            for (CNData.CNRelationship oRel : listRelationships) {
                oRel.checkForSensitiveData();
                System.debug('oRel: ' + oRel);
            }
        }        
        return listRelationships;
    }
  
    //Parses contacts JSON into usable local objects.
    public static List<CNData.CNContact> parseContactsData(String sJSONString) {
        if (isEmpty(sJSONString)) return new List<CNData.CNContact>();

        sJSONString = CNAppUtils.decodeJsonFieldNames(sJSONString);
        List<CNData.CNContact> listContacts =
                (List<CNData.CNContact>)JSON.deserialize(sJSONString, List<CNData.CNContact>.class);

        System.debug('listContacts: ' + listContacts);
        return listContacts;
    }

    
    //Parses company JSON into usable local objects.
    public static List<CNData.CNCompany> parseCompanyData(String sJSONString) {
        if (isEmpty(sJSONString)) return new List<CNData.CNCompany>();

        sJSONString = CNAppUtils.decodeJsonFieldNames(sJSONString);
        system.debug('decodeJsonFieldNames :' +sJSONString);
        List<CNData.CNCompany> listCompanies =
                (List<CNData.CNCompany>)JSON.deserialize(sJSONString, List<CNData.CNCompany>.class);

        System.debug('listCompanies: ' + listCompanies);
        return listCompanies;
    }
    
    //Returns the app setting record
    public static CN_App_Settings__c getAppCustomSetting(){
    	return CN_App_Settings__c.getAll().get(CNConstants.APP_SETTING_KEY);       
    }
    
    //Returns true if the 'Is Active' field is set to true on App setting. This is the master flag which controls the entire functionality.
    public static Boolean isServiceActive() {        
        return getAppCustomSetting().WS_Is_Active__c == true;        
    }
    
    //[CR-069] M.Eaton - Returns the default value of the Data Sensitive custom setting
    public static String getDataSensitiveDefault() {
        return '';//getAppCustomSetting().Data_Sensitive_Display_Value__c;
    }

/* [SOW #32 M.Eaton - Custom Setting: Enhancement Attributes]    */
    //Returns the custom setting for Contact Component Enable Add
    public static Boolean getContactEnableAddAction() {
    	return getAppCustomSetting().Enable_Contact_Add_Action__c;
    }

    //Returns the custom setting for Contact Component Enable Search
    public static Boolean getContactEnableSearchAction() {
    	return getAppCustomSetting().Enable_Contact_Search_Action__c;    	
    }
    
     //Returns the custom setting for Contact Component Show Email
    public static Boolean getContactShowEmail() {
    	return getAppCustomSetting().Show_Email_Data__c;
    }

    //Returns the custom setting for Contact Component Show Phone
    public static Boolean getContactShowPhone() {
    	return getAppCustomSetting().Show_Phone_Data__c;    	
    }       
    
    //Returns whether the Action column should be displayed at all
    public static Boolean getContactEnableActionColumn() {
    /* TODO - Left off here! */	
    	if(	getAppCustomSetting().Enable_Contact_Add_Action__c || 
    		getAppCustomSetting().Enable_Contact_Search_Action__c) {
    		return true;
    	}
    	else {
    		return false;
    	}
    }
    public static Boolean getShowColleagueEmailData(){
    	return getAppCustomSetting().Show_Colleague_Email_Data__c;    	
    }       						
	public static Boolean getShowColleagueLocation(){
    	return getAppCustomSetting().Show_Colleague_Location__c;    	
    }       
	public static Boolean getShowColleaguePhoneData(){
    	return getAppCustomSetting().Show_Colleague_Phone_Data__c;    	
    }       
	public static Boolean getShowColleagueRecency(){
    	return getAppCustomSetting().Show_Colleague_Recency__c;    	
    }         
	public static Boolean getShowColleagueRelationshipStrength(){
    	return getAppCustomSetting().Show_Colleague_Relationship_Strength__c;    	
    }       
	public static Boolean getShowColleagueSource(){
    	return getAppCustomSetting().Show_Colleague_Source__c;    	
    }        
	public static Boolean getShowColleagueTitle(){
    	return getAppCustomSetting().Show_Colleague_Title__c;    	
    }       
	public static Boolean getShowContactEmailData(){
    	return getAppCustomSetting().Show_Contact_Email_Data__c;    	
    }       
	public static Boolean getShowContactLocation(){
    	return getAppCustomSetting().Show_Contact_Location__c;    	
    }       
	public static Boolean getShowContactPhoneData(){
    	return getAppCustomSetting().Show_Contact_Phone_Data__c;    	
    }       
	public static Boolean getShowContactRecency(){
    	return getAppCustomSetting().Show_Contact_Recency__c;    	
    }       
	public static Boolean getShowContactRelationshipStrength(){
    	return getAppCustomSetting().Show_Contact_Relationship_Strength__c;    	
    }       
	public static Boolean getShowContactSource(){
    	return getAppCustomSetting().Show_Contact_Source__c;    	
    }       
	public static Boolean getShowContactTitle(){
    	return getAppCustomSetting().Show_Contact_Title__c;    	
    }       
	public static Boolean getShowEmailData(){
    	return getAppCustomSetting().Show_Email_Data__c;    	
    }        
	public static Boolean getShowPhoneData(){
    	return getAppCustomSetting().Show_Phone_Data__c;    	
    }       
    /**
        Handles any type of exception or validation message. 
        It adds the message to the user interface and also sends out email based input request.
        It leverages custom setting to identify if the message displayed on the user interface is 
        original or generic. This method is invoked by all parts of the application to handle
        any type of exceptions. 
    */
    public static void handleException(CNData.CNExceptionInfo oExpInfo) {                
        //Display the original error message to the user interface (VF page) only if custom setting allows. Otherwise display 
        //the general error message.
        String sMessage = null;
        String sTrackingId = generateToken(15);
        if (oExpInfo.bAddToPage) {
            //Now decide if we should display the original exception message or a wrapped general message based on custom setting
            if (true == getAppCustomSetting().Display_General_Error_Message__c) {
                //Prepare the general error message without any debugging information 
                sMessage = prepareGeneralErrorMessage(sTrackingId);
                oExpInfo.oSeverity = ApexPages.Severity.WARNING;  //always display warning message for general message
            }
            else {
                //Prepare the orignal error message with debugging information
                sMessage = prepareExceptionHeaderMessage(sTrackingId);
                sMessage += '\n\n' + generateOriginalErrorMessageTrace(oExpInfo, sTrackingId, oExpInfo.bAddDebugInfoToPage);
            }
            
            try {
                ApexPages.addMessage(new ApexPages.Message(oExpInfo.oSeverity, sMessage.replace('\n', '<br/>')));
            }
            catch (Exception ignore) {
                //Exception could be thrown if the context is either future or batch where there is no VF page involved
            }
        }        
        //Send email to system administrators with debugging information(not controlled by custom setting)
        if (oExpInfo.bSendEmail) {
            sMessage = prepareExceptionHeaderMessage(sTrackingId);
            sMessage += '\n\n' + generateOriginalErrorMessageTrace(oExpInfo, sTrackingId, oExpInfo.bAddDebugInfoToEmail);
            sMessage += '\n\n' + CNConstants.EXCEPTION_EMAIL_FOOTER_MSG;
            String sEmailSubject = 'Business Development Premier Integration Error: ' + oExpInfo.sEmailSubject;
            String sToEmail = CNAppUtils.getAppCustomSetting().Error_Notification__c; //single email
            system.debug('*** handleException *** ' + smessage);
            //sendEmail(new String[]{sToEmail}, sEmailSubject, sMessage);
        }
    }
    
    //Returns true if the input data is non empty and non null
    public static Boolean isNonEmpty(String sData) {
        return !performEmptyCheck(sData, true);
    }     
    //Returns true if the input data is empty or null
    public static Boolean isEmpty(String sData) {
        return performEmptyCheck(sData, true);
    }    
    //Concatenates a collection of string by adding the separator in between.
    public static String concatenateSet(Set<String> setData, String sSep) {
        String sResult = '';
        if (setData == null) return sResult;
        Integer iIndex = 1;
        for (String sEle : setData) {
            sResult += sEle;
            if (iIndex < setData.size()) sResult += sSep;
            iIndex++;
        }
        System.debug('concatenated result: ' + sResult);
        return sResult;
    }
    //Concatenates a collection of string by adding the separator in between.
    public static String concatenateList(List<String> listData, String sSep) {
        String sResult = '';
        if (listData == null) return sResult;
        Integer iIndex=1;
        for (String sEle : listData) {
            sResult += sEle;
            if (iIndex < listData.size()) sResult += sSep;
            iIndex++;
        }
        System.debug('concatenated result: ' + sResult);
        return sResult;
    }
    //Concatenates a collection of string by adding the separator in between.
    public static String concatenateListIds(List<Id> listData, String sSep) {
        String sResult = '';
        if (listData == null) return sResult;
        Integer iIndex=1;
        for (String sEle : listData) {
            sResult += sEle;
            if (iIndex < listData.size()) sResult += sSep;
            iIndex++;
        }
        System.debug('concatenated result: ' + sResult);
        return sResult;
    }       
    //Adds request parameters to the input URL and optionally encodes the parameter values.
    public static String prepareURL(String sUrl, Map<String, String> mapParams, Boolean bEncode) {
        if (isEmpty(sUrl) || mapParams == null || mapParams.size() == 0) { 
            return sUrl;
        }
        sUrl = addQuestionMarkIfNecessary(sUrl);
        sUrl = addAmpersandIfNecessary(sUrl);
        sUrl = addParametersToURL(sUrl, mapParams, bEncode);
        System.debug('sUrl: ' + sUrl);
        return sUrl;
    } 
    //Validates custom setting to make sure that the setup entries are available for the integration to work properly.
    public static Boolean validateAppSettings() {
        if (getAppCustomSetting() == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Custom setting (CN App Settings) is not setup properly. It is missing the record by name \'' + CNConstants.APP_SETTING_KEY + '\'.'));
            return false;
        }        
        if (CNAppUtils.isServiceActive() == false) {
            String sMsg = CNAppUtils.getAppCustomSetting().WS_Unavailable_Message__c;
            System.debug('Message : ' + sMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, sMsg));
            return false;
        }        
        System.debug('custom setting is good');
        return true;    
    }
    
    //Return the Top Most frequently occurring Domain
    public static String getTopDomain(List<Contact> listContacts) {
        System.debug('getTopDomain starts: ' + listContacts);
        if (listContacts==null) {
            return null;
        } 
        String sEmail;
        String sDomain = '';
        set<String> setDomains = new set<String>();
        map<String, Integer> mapDomainRank = new map<String, Integer>();
        
        for (Contact oContact : listContacts){
            System.debug('oContact: ' + oContact);
            sEmail = oContact.Email;
            String[] arrayEmailParts = sEmail.split('@');
            if (arrayEmailParts != null && arrayEmailParts.size() == 2) {
                sDomain = arrayEmailParts.get(1);
            }
            System.debug('email: ' + sEmail + ', domain: ' + sDomain);
            
            // If domain already exists, increment rank
            if (mapDomainRank.containsKey(sDomain)){
                Integer iCount = mapDomainRank.get(sDomain);
                mapDomainRank.put(sDomain, (iCount + 1));
            } else {
                // Add new domain with an initial rank of 1
                mapDomainRank.put(sDomain, 1);
            }
        }
        system.debug('rank map: ' + mapDomainRank); 
        
        // Loop through unique domains to determine most common
        setDomains = mapDomainRank.keyset();
        String sTopDomain;
    
        for (String s : setDomains) {
            if (sTopDomain==null) {
                sTopDomain = s;
            } else {
                if (mapDomainRank.get(sTopDomain) < mapDomainRank.get(s)) {
                    sTopDomain = s;  
                }
            }
        }
        System.debug('top domain: ' + sTopDomain);
        return sTopDomain;          
    }   
    
    //Converts relationship data from CN format to SFDC format for Contact record type
    public static List<CN_Relationship__c> convertCNRelationshipForContact(List<CNData.CNRelationship> listCNRelationships, String sSFDCAcctId, String sWSQueueId) {
        System.debug('convertCNRelationshipForContact starts'); 
        List<CN_Relationship__c> listSFDCRelationships = new List<CN_Relationship__c>();
        String recTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        
        for (CNData.CNRelationship oRel : listCNRelationships) {
            CNData.CNContact oCont = oRel.contact;
            System.debug('oCont: ' + oCont);
            String lastModificationTime = null;
            if (oCont != null) {
                lastModificationTime = oCont.LastModificationTime;
            }        
            listSFDCRelationships.add(new CN_Relationship__c(CNID__c=trim(oCont.CNID, 50), Account__c=sSFDCAcctId, Firstname__c=trim(oCont.firstName, 150), 
                        Lastname__c=trim(oCont.lastName, 150), 
                        First_Email__c=trim(oCont.getFirstEmail(), 150), All_Emails__c=trim(oCont.getConcatenatedEmails(), 1500),    
                        Working_Location__c=trim(oCont.workingLocation, 255), 
                        First_Phone__c=trim(oCont.getConcatenatedPhones(), 150), All_Phones__c=trim(oCont.getConcatenatedPhones(), 1500), 
                        Normalized_Score__c=oRel.normalizedScore, Raw_Score__c=oRel.score, CN_Webservice_Queue__c=sWSQueueId,
                        Source__c=CNAppUtils.concatenateSet(oRel.sources, ';'), Title__c=trim(oCont.Title, 255), RecordTypeId=recTypeId,
                        Last_Modification_Time__c=convertJSONDate(lastModificationTime), Company_CNID__c=oRel.company != null ? trim(oRel.company.CNID, 50): null, 
                        Fullname__c=prepareFullname(oCont.firstName, oCont.lastName, oCont.getFirstEmail()))); 
        }
        System.debug('listSFDCRelationships: ' + listSFDCRelationships.size());
        //upsert listSFDCRelationships;//GMC
        return listSFDCRelationships;
    }  

    //Converts relationship data from CN format to SFDC format for Colleague record type
    public static List<CN_Relationship__c> convertCNRelationshipForColleague(List<CNData.CNRelationship> listCNRelationships, String sSFDCAcctId, String sSFDCContId,
                                                                                                                String sWSQueueId) {
        System.debug('convertCNRelationshipForColleague starts'); 
        List<CN_Relationship__c> listSFDCRelationships = new List<CN_Relationship__c>();
        String recTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Colleague').getRecordTypeId();

        for (CNData.CNRelationship oRel : listCNRelationships) {
            CNData.CNColleague oCol = oRel.colleague;
            CNData.CNContact oCont = oRel.contact;
            System.debug('oCont: ' + oCont);
            
            String companyCNID = null, lastModificationTime = null;
            if (oRel.company != null) {
                companyCNID = oRel.company.CNID;
            }
            else if (oRel.contact != null && oRel.contact.company != null) {
                companyCNID = oRel.contact.company.CNID;
            }
            
            if (oCont != null) {
                lastModificationTime = oCont.LastModificationTime;
            }
            
            listSFDCRelationships.add(new CN_Relationship__c(CNID__c=trim(oCol.CNID, 50), Account__c=sSFDCAcctId, Contact__c=sSFDCContId, 
                        Firstname__c=trim(oCol.firstName, 150), Lastname__c=trim(oCol.lastName, 150), 
                        First_Email__c=trim(oCol.getFirstEmail(), 150), All_Emails__c=trim(oCol.getConcatenatedEmails(), 1500), 
                        Working_Location__c=trim(oCol.workingLocation, 255), 
                        First_Phone__c=trim(oCol.getConcatenatedPhones(), 150), All_Phones__c=trim(oCol.getConcatenatedPhones(), 1500),
                        Normalized_Score__c=oRel.normalizedScore, Raw_Score__c=oRel.score, 
                        Source__c=CNAppUtils.concatenateSet(oRel.sources, ';'), Title__c=trim(oCol.Title, 255), RecordTypeId=recTypeId,
                        Department__c=trim(oCol.department, 255), Company_CNID__c=trim(companyCNID, 50), CN_Webservice_Queue__c=sWSQueueId,
                        Fullname__c=prepareFullname(oCol.firstName, oCol.lastName, oCol.getFirstEmail())));   
        }
        System.debug('listSFDCRelationships: ' + listSFDCRelationships.size());
        //upsert listSFDCRelationships;//GMC
        return listSFDCRelationships;
    }    
    
    //Pulls contacts from Salesforce for a given account id.
    public static List<CNData.CNRelationship> fetchContactsFromSFDC(String sSFDCAcctId, Integer iLimit, Boolean fromAccount) {
        String soql = prepareRelationshipSOQL('Contact', sSFDCAcctId, null, iLimit, 'Raw_Score__c', 'DESC', null);
        List<CN_Relationship__c> listSFDCRelationships = Database.query(soql); 
        
        // TODO: Insert Audit Log
        system.debug('-- insertLogEntry ---');
        CNAppUtils.insertLogEntry('Account Component - Contacts Tab', 'Call to Cache', 
                                    'Retrieve Company Contact data from temp cache' , sSFDCAcctId, null);        
        
        return convertCustomObjectToContactRelationship(listSFDCRelationships, fromAccount);
    }
    
    //TODO - M.Eaton - Add Sensitive Data support
    //Converts the relationship data from one format (custom object) to another (object)
    public static List<CNData.CNRelationship> convertCustomObjectToContactRelationship(List<CN_Relationship__c> listSFDCRelationships, Boolean fromAccount) {
        List<CNData.CNRelationship> listCNRelationships = new List<CNData.CNRelationship>();
        for (CN_Relationship__c oRelSFDC : listSFDCRelationships) {
            CNData.CNRelationship oRelCN = new CNData.CNRelationship();
            CNData.CNContact oCont = new CNData.CNContact();            
            oCont.CNID = oRelSFDC.CNID__c;
            oCont.firstName = oRelSFDC.Firstname__c;
            oCont.lastName = oRelSFDC.Lastname__c;
            oCont.fullName = oRelSFDC.Fullname__c;
            system.debug('All_Emails__c: ' + oRelSFDC.All_Emails__c);
            oCont.emailAddresses = splitAsList(oRelSFDC.All_Emails__c, ';');
            system.debug('splitAsList(All_Emails__c: ' + splitAsList(oRelSFDC.All_Emails__c, ';'));
            system.debug('All_Phones__c: ' + oRelSFDC.All_Phones__c);
            oCont.phones = splitPhones(oRelSFDC.All_Phones__c, ';');
            system.debug('splitPhones(All_Phones__c: ' + splitPhones(oRelSFDC.All_Phones__c, ';'));
            oCont.workingLocation = oRelSFDC.Working_Location__c;
            oCont.title = oRelSFDC.Title__c;
            oCont.LastModificationTimeAlt = oRelSFDC.Last_Modification_Time__c;
            CNData.CNCompany oComp = new CNData.CNCompany();
            oComp.CNID = oRelSFDC.Company_CNID__c;
            oRelCN.company = oComp;
            oRelCN.score = oRelSFDC.Raw_Score__c;
            //set graph display values
			if(oRelCN.score>0.49){oRelCN.d1 = 'selected';}
			if(oRelCN.score>1.49){oRelCN.d2 = 'selected';}
			if(oRelCN.score>2.49){oRelCN.d3 = 'selected';}
			if(oRelCN.score>3.49){oRelCN.d4 = 'selected';}
			if(oRelCN.score>4.49){oRelCN.d5 = 'selected';}
			if(oRelCN.score>5.49){oRelCN.d6 = 'selected';}
			if(oRelCN.score>6.49){oRelCN.d7 = 'selected';}
			system.debug('############score=' + oRelCN.score + ' d1=' + oRelCN.d1);
            oRelCN.normalizedScore = convertDecimalToInteger(oRelSFDC.Normalized_Score__c);
            oRelCN.sources = splitAsSet(oRelSFDC.Source__c, ';');
            oRelCN.contact = oCont;
            listCNRelationships.add(oRelCN);
        }         
        System.debug('listCNRelationships: ' + listCNRelationships.size());
        return listCNRelationships;
    }  
    
    //Pulls colleagues from Salesforce for a given account or contact id.
    public static List<CNData.CNRelationship> fetchColleaguesFromSFDC(String sSFDCAcctId, String sSFDCContId, Integer iLimit, Boolean fromAccount) {
        String soql = prepareRelationshipSOQL('Colleague', sSFDCAcctId, sSFDCContId, iLimit, 'Raw_Score__c', 'DESC', null);
        List<CN_Relationship__c> listSFDCRelationships = Database.query(soql); 
        
        // TODO: Insert Audit Log
        system.debug('-- insertLogEntry ---');
        if (fromAccount) {
            CNAppUtils.insertLogEntry('Account Component - Colleagues Tab', 'Call to Cache', 
                                        'Retrieve Company Colleagues data from temp cache' , sSFDCAcctId, sSFDCContId);
        }
        else { // fromContact
            CNAppUtils.insertLogEntry('Contact Component - Colleagues Tab', 'Call to Cache', 
                                        'Retrieve Contact Colleagues data from temp cache' , sSFDCAcctId, sSFDCContId);
        }        
        return convertCustomObjectToColleagueRelationship(listSFDCRelationships, fromAccount);
    }
    
    //Converts the relationship data from one format (custom object) to another (object)
    public static List<CNData.CNRelationship> convertCustomObjectToColleagueRelationship(List<CN_Relationship__c> listSFDCRelationships, Boolean fromAccount) {
        List<CNData.CNRelationship> listCNRelationships = new List<CNData.CNRelationship>();
        for (CN_Relationship__c oRelSFDC : listSFDCRelationships) {
            CNData.CNRelationship oRelCN = new CNData.CNRelationship();
            CNData.CNColleague oCol = new CNData.CNColleague();
            
            oCol.CNID = oRelSFDC.CNID__c;
            oCol.firstName = oRelSFDC.Firstname__c;
            oCol.lastName = oRelSFDC.Lastname__c;
            oCol.fullName = oRelSFDC.Fullname__c;
            oCol.emailAddresses = splitAsList(oRelSFDC.All_Emails__c, ';');
            oCol.phones = splitPhones(oRelSFDC.All_Phones__c, ';');
            oCol.workingLocation = oRelSFDC.Working_Location__c;
            oCol.title = oRelSFDC.Title__c;
            oCol.department = oRelSFDC.Department__c;            
            CNData.CNCompany oComp = new CNData.CNCompany();
            oComp.CNID = oRelSFDC.Company_CNID__c;
            oRelCN.company = oComp;
            oRelCN.score = oRelSFDC.Raw_Score__c;
            //set graph display values
			if(oRelCN.score>0.49){oRelCN.d1 = 'selected';}
			if(oRelCN.score>1.49){oRelCN.d2 = 'selected';}
			if(oRelCN.score>2.49){oRelCN.d3 = 'selected';}
			if(oRelCN.score>3.49){oRelCN.d4 = 'selected';}
			if(oRelCN.score>4.49){oRelCN.d5 = 'selected';}
			if(oRelCN.score>5.49){oRelCN.d6 = 'selected';}
			if(oRelCN.score>6.49){oRelCN.d7 = 'selected';}
			system.debug('############score=' + oRelCN.score + ' d1=' + oRelCN.d1);
            oRelCN.normalizedScore = convertDecimalToInteger(oRelSFDC.Normalized_Score__c);
            oRelCN.sources = splitAsSet(oRelSFDC.Source__c, ';');
            oRelCN.colleague = oCol;
            listCNRelationships.add(oRelCN);
        }		
        System.debug('listCNRelationships: ' + listCNRelationships.size());
        return listCNRelationships;
    }
    
    //Converts date string from JSON format to Native Salesforce format. Example JSON: \/Date(1321336800000-0600)\/
    public static DateTime convertJSONDate(String sJSONDate) {
        System.debug('sJSONDate: ' + sJSONDate);
        if (sJSONDate == null) return null;
        Integer iStartIndex = sJSONDate.indexOf('(');
        if (iStartIndex == -1) return null;
        Integer iEndIndex = sJSONDate.indexOf(')');
        if (iEndIndex == -1) return null;
        String sDateAndTime = sJSONDate.substring(iStartIndex+1, iEndIndex);
        Long lDatePart=0, lTimePart=0;
        if (sDateAndTime.contains('-')) {
            iEndIndex = sDateAndTime.indexOf('-');
            lDatePart = Long.valueOf(sDateAndTime.substring(0, iEndIndex));
            lTimePart = Long.valueOf(sDateAndTime.substring(iEndIndex));  //including the minus symmbol
            lTimePart = (lTimePart / 100) * 60 * 60 * 1000;  //converting hours into milli seconds
        }
        else {
            lDatePart = Long.valueOf(sDateAndTime);
        }
        
        Long lDateAndTime = lDatePart + lTimePart;
        System.debug('lDatePart: ' + lDatePart + ', lTimePart: ' + lTimePart + ', lDateAndTime: ' + lDateAndTime);

        DateTime dtNativeDate = DateTime.newInstance(lDatePart);
        System.debug('dtNativeDate: ' + dtNativeDate + ', formatted: ' + dtNativeDate.format());
        return dtNativeDate;
    }
    
    //Splits the input string using the delimiter and returns the result as list
    public static List<String> splitAsList(String sData, String sSeparator) {
        if (sData != null) {
            return sData.split(sSeparator);
        }       
        return null;
    }

    //Splits the input string using the delimiter and returns the result as set
    public static Set<String> splitAsSet(String sData, String sSeparator) {
        if (sData != null) {
            Set<String> setData = new Set<String>();
            for (String sSingle : sData.split(sSeparator)) {
                setData.add(sSingle);
            }
            return setData;
        }         
        return null;
    }

    //Prepare relationship SOQL 
    public static String prepareRelationshipSOQL(String sRecordTypeName, String sSFDCAcctId, String sSFDCContId, Integer iLimit, 
                                String sSortBy, String sSortDirection, String sStartsWith) {
        Id recTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get(sRecordTypeName).getRecordTypeId();
        
        System.debug('sSFDCAcctId: ' + sSFDCAcctId + ', sSFDCContId: ' + sSFDCContId);
        String soql = 'Select Id, Account__c, CNID__c, Contact__c, Department__c, First_Email__c, All_Emails__c, Company_CNID__c, Fullname__c, ' +
                    'Firstname__c, Last_Modification_Time__c, Lastname__c, First_Phone__c, All_Phones__c, Raw_Score__c, ' +
                    'Normalized_Score__c, Source__c, Title__c, Working_Location__c ' +
                    'from CN_Relationship__c where RecordTypeId=\'' + recTypeId + '\' and ';
        if (sSFDCAcctId != null) {
            soql += 'Account__c=\'' + sSFDCAcctId + '\' ';
        }
        else {
            soql += 'Contact__c=\'' + sSFDCContId + '\' ';
        }
        
        if (sStartsWith == 'all' || sStartsWith == 'other') {
            sStartsWith = null;
        }       
        
        if (sStartsWith != null && sSortBy != null && sSortBy != 'Raw_Score__c' && sSortBy != 'Last_Modification_Time__c') {
            soql += 'and ' + sSortBy    + ' like \'' + sStartsWith + '%\' ';
        }
        
        if (sSortBy != null && sSortDirection != null) {
            soql += 'order by ' + sSortBy + ' ' + sSortDirection + ' NULLS LAST ';
        }
        
        if (iLimit > 0) {
            soql += 'limit ' + iLimit;
        }
        
        System.debug('relationship fetch SOQL: ' + soql);
        return soql;
    }   
    
    //Deletes all cached data
    public static void deleteCacheFromCustomObjects() {
        delete [Select Id from CN_Webservice_Queue__c];
        delete [Select Id from CN_Relationship__c];
    }
    
    //Trims the input string to a spoecified length and also removes trailing spaces.
    public static String trim(String sData, Integer iTrimSize) {
        if (sData != null) {
            sData = sData.trim();
            if (sData.length() <= iTrimSize) {
                return sData;
            }
            return sData.substring(0, iTrimSize);
        }
        return null;
    }

    //Sends out email using Salesforce email service and allows an attachment
    public static void sendEmail(String[] listTos, String sSubject, String sBody, Blob attachmentBlob, String attachmentFileName) {
        System.debug('sending email with attachment using Salesforce email service');
        Messaging.SingleEmailMessage oMail = new Messaging.SingleEmailMessage();
        oMail.setSenderDisplayName(CNConstants.ERROR_EMAIL_SENDER_DISPLAY_NAME);
        oMail.setToAddresses(listTos);
        oMail.setSubject(sSubject);
        oMail.setPlainTextBody(sBody);
        
        Messaging.EmailFileAttachment oAttachment = new Messaging.EmailFileAttachment();
        oAttachment.setFileName(attachmentFileName);
        oAttachment.setBody(attachmentBlob);
        oMail.setFileAttachments(new Messaging.EmailFileAttachment[]{oAttachment});


        if (!Test.isRunningTest() && listTos != null && listTos.size() > 0) {
           // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { oMail });
        }       
    }

    //Sends out email using Salesforce email service
    public static void sendEmail(String[] listTos, String sSubject, String sBody) {
        System.debug('sending email using Salesforce email service');
        Messaging.SingleEmailMessage oMail = new Messaging.SingleEmailMessage();
        oMail.setSenderDisplayName(CNConstants.ERROR_EMAIL_SENDER_DISPLAY_NAME);
        oMail.setToAddresses(listTos);
        oMail.setSubject(sSubject);
        oMail.setPlainTextBody(sBody);
        // Sets HTML body in case it the recipient can receive HTML emails
        oMail.setHtmlBody(sBody);
        
        if (!Test.isRunningTest() && listTos != null && listTos.size() > 0) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { oMail });
        }       
    }
    
            
    // Test if Chatter has been enabled in order to support Global search
    public static boolean isChatterEnabled() {
        boolean isEnabled = true;
        string sChatterDisabledExMsg = 'sObject type \'AccountFeed\' is not supported.';
        try{
            //Query AccountFeed object 
            SObject oAF = database.query('SELECT Id FROM AccountFeed LIMIT 1');
            return isEnabled;
        }
        catch(System.RequiredFeatureMissingException ex){
            system.debug('Chatter is disabled');
            isEnabled = false;
            return isEnabled;
        }
        catch(System.Exception ex){
            if (ex.getMessage() == sChatterDisabledExMsg) {
                system.debug('Chatter is disabled');
                isEnabled = false;
                return isEnabled;
            }
            return isEnabled;
        }
    }
    
    //Fetches existing custom setting from database
    /* 06/01/2014 [M.Eaton] - Considered removal credentials from the return values WS_Auth_Key__c, WS_Consumer_Name__c, WS_Endpoint__c, */
    /* 07/13/2014 [M.Eaton] - Added security token and support notification email fields */
    /* 11/16/2014 [M.Eaton] - Added SOW#32 fields; Add/Search Action and Show Email/Phone data columns */
    public static CN_App_Settings__c fetchExistingCustomSetting() {
        List<CN_App_Settings__c> listSettings = [SELECT APP_OAUTH_CLIENTID__c,
        APP_OAUTH_SECRET__c,APP_OAUTH_TOKEN__c,APP_PASSWORD__c,APP_USERNAME__c,
        Audit_Log_Expiration_Age_Days__c,Auth_Cookie_API_14_Overflow__c,
        Auth_Cookie_API_14_Timestamp__c,Auth_Cookie_API_14__c,CN_Password__c,
        CN_User_Name__c,CreatedById,CreatedDate,Data_Cache_Size__c,
        Data_Cleanup_Job_Id__c,Data_Display_Size__c,Data_Expiration_Hours__c,
        Data_Sensitive_Display_Value__c,Display_General_Error_Message__c,
        Enable_Contact_Add_Action__c,Enable_Contact_Search_Action__c,
        Enable_Data_Cleanup_Job__c,Enhanced_List_Data_Display_Size__c,
        Error_Notification__c,Exclude_Sensitive_Audit_Log_Data__c,
        Feedback_Notification_Email__c,Feedback_Notification_Subject__c,
        General_Error_Message__c,Id,Inner_Relationship_Data_Display_Size__c,
        IsDeleted,LastModifiedById,LastModifiedDate,Max_Data_Storage__c,
        Name,OAuth_Expiration_Time__c,OAUTH_GRANTTYPE__c,OAUTH_URL__c,
        Recency_as_Date__c,Security_Token__c,SetupOwnerId,Show_Colleague_Email_Data__c,
        Show_Colleague_Location__c,Show_Colleague_Phone_Data__c,
        Show_Colleague_Recency__c,Show_Colleague_Relationship_Strength__c,
        Show_Colleague_Source__c,Show_Colleague_Title__c,Show_Contact_Email_Data__c,
        Show_Contact_Location__c,Show_Contact_Phone_Data__c,Show_Contact_Recency__c,
        Show_Contact_Relationship_Strength__c,Show_Contact_Source__c,Show_Contact_Title__c,
        Show_Email_Data__c,Show_Phone_Data__c,Support_Notification_Email__c,SystemModstamp,
        WS_API_Version__c,WS_Auth_Key__c,WS_Consumer_Name__c,WS_Endpoint__c,WS_Is_Active__c,
        WS_Timeout__c,WS_Unavailable_Message__c,Account_Rel__c,Account__c,Contact_Relationship__c,
        Corp_Insight__c,Login_Failed__c,OA_company__c
        FROM CN_App_Settings__c WHERE Name=:CNConstants.APP_SETTING_KEY limit 1]; 
        if (listSettings.size() == 1) {
            return listSettings.get(0);
        }        
        return null;                
    }   
    
    //Generates random string using a specified length
    public static String generateToken(Integer length) {
        DateTime d = System.now();
        Long ll = d.getTime();
        String newS = '' + ll;
        String algorithmName = 'HMacSHA1';
        Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(newS),
        Blob.valueOf('clt'));
        String token = EncodingUtil.urlEncode(EncodingUtil.base64Encode(mac), 'UTF-8');
        token = token.replaceAll('%', 'p');
        if (length > 0 && token.length() > length) {
            return token.substring(0, length);  
        }
        else {
            return token;
        }
    }
    
    //Returns true if record is subject to sensitive data display
    public static Boolean useSensitiveDataDisplay(String sFirstPhone, String sFirstEmail) {
        if (sFirstPhone == null && sFirstEmail == null) 
            return true;
        else
            return false;
    }
    

    //Returns Security Token to be concatenated to Web Service Auth Key
    public static String getSecurityToken(){
        //return UserInfo.getOrganizationId();
        return generateToken(CNConstants.SECURITY_TOKEN_LENGTH);
        //system.debug('Security Token = ' + sToken);
    }
    
    //Emails the Security Token to Support Notification Email in Custom Settings
    @future
    public static void sendSecurityToken() {
        System.debug('sendSecurityToken starts.');
        
        String sMessage = 'Your Security Token Is Enclosed.</br></br>';
        sMessage += 'Dear ContactNet Configuration Administrator,</br></br>';
        sMessage += 'When accessing ContactNet (CN) from salesforce.com, you must add a security token to your password when ' +
                    'configuring the CN security <b>Consumer Name</b> credentials in order to allow communication between the ' +
                    'CN for Salesforce package components and the CN web services.</br></br>';
        sMessage += 'New security tokens are automatically sent to you when your <b>Auth Key</b> is changed or when you request ' +
                    'to <b>Reset</b> your <b>Security Token</b> from the package configuration page.</br></br>';
        sMessage += 'Your new security token is below. Note that security tokens are case sensitive.</br></br>';
        sMessage += '<b>Consumer Name:</b> ' +  CNAppUtils.getAppCustomSetting().WS_Consumer_Name__c + '</br>';
        sMessage += '<b>Security Token:</b> ' +  CNAppUtils.getAppCustomSetting().Security_Token__c + '</br></br>';
        sMessage += 'Please add your security token to your password when configuring the ContactNet Server Security.';
                                            
        String sEmailSubject = 'ContactNet for Salesforce - Security Token Confirmation';
        String sToEmail = CNAppUtils.getAppCustomSetting().Support_Notification_Email__c; //single email

        sendEmail(new String[]{sToEmail}, sEmailSubject, sMessage);

    }
        
    //Creates log entry for auditing
    @future
    public static void insertLogEntry(String sComponentSource, String sActionType, String sActionDesc, Id acctID, Id contID){
        DateTime dtExpiryDate = System.now();

        try {
            dtExpiryDate = System.now().addDays(CNAppUtils.getAppCustomSetting().Audit_Log_Expiration_Age_Days__c.intValue());
        } catch (Exception e) {
            dtExpiryDate = System.now().addDays(30);
        }

        CN_Audit_Log__c oLog = new CN_Audit_Log__c();
        oLog.Component_Source__c = sComponentSource;
        oLog.Action_Type__c = sActionType;
        oLog.Action_Description__c = sActionDesc;
        oLog.User__c = UserInfo.getUserId();
        oLog.Account__c = acctID;
        oLog.Contact__c = contID;
        oLog.Expiration_Date__c = dtExpiryDate;
        insert oLog;  
    }     
    
    //Creates log entry for auditing from package configuration page (Package Administration auditing) 
    @future
    public static void insertLogEntry(String sComponentSource, String sActionType, String sActionDesc){
        DateTime dtExpiryDate = System.now();

        try {
            dtExpiryDate = System.now().addDays(CNAppUtils.getAppCustomSetting().Audit_Log_Expiration_Age_Days__c.intValue());
        } catch (Exception e) {
            dtExpiryDate = System.now().addDays(30);
        }

        CN_Audit_Log__c oLog = new CN_Audit_Log__c();
        oLog.Component_Source__c = sComponentSource;
        oLog.Action_Type__c = sActionType;
        oLog.Action_Description__c = sActionDesc;
        oLog.User__c = UserInfo.getUserId();
        //oLog.Account__c = acctID;
        //oLog.Contact__c = contID;
        oLog.Expiration_Date__c = dtExpiryDate;
        insert oLog;  
    }       

    //Creates log entry for auditing
    public static void insertLogEntry_Sync(String sComponentSource, String sActionType, String sActionDesc, Id acctID, Id contID){
        DateTime dtExpiryDate = System.now();

        try {
            dtExpiryDate = System.now().addDays(CNAppUtils.getAppCustomSetting().Audit_Log_Expiration_Age_Days__c.intValue());
        } catch (Exception e) {
            dtExpiryDate = System.now().addDays(30);
        }

        CN_Audit_Log__c oLog = new CN_Audit_Log__c();
        oLog.Component_Source__c = sComponentSource;
        oLog.Action_Type__c = sActionType;
        oLog.Action_Description__c = sActionDesc;
        oLog.User__c = UserInfo.getUserId();
        oLog.Account__c = acctID;
        oLog.Contact__c = contID;
        oLog.Expiration_Date__c = dtExpiryDate;
        insert oLog;  
    }     
    
    //Emails the Summary Audit Report to the Support Notification Email in Custom Settings
    @future
    public static void sendSummaryAuditReport() {
        System.debug('SendSummaryAuditReport starts.');

        String sMessage = 'Below is your ContactNet Summary Audit Log for the past 30 days.';
        String sEmailSubject = 'ContactNet Summary Audit Report. Generated on ' + System.Now();
        String sToEmail = CNAppUtils.getAppCustomSetting().Support_Notification_Email__c; //single email

        sMessage += '\r\n\r\n' + GenerateSummaryAuditLogReport(30);

        sendEmail(new String[]{sToEmail}, sEmailSubject, sMessage);

    }

    //2014-09-08 Sarbello - Deletes records from CN Audit Log if Expired
    public static void cleanAuditLog() {
        System.debug('CleanAuditLog starts.');

        try {
            database.delete([SELECT id FROM CN_Audit_Log__c WHERE Expired__c = 'Yes' LIMIT 50000], false);
        } catch (System.Exception e) {
            system.debug('@@@@@ error: ' + e);
        } 

    }


    //Method to generate a Summary Report for the Audit Log records
    public static String generateSummaryAuditLogReport(Integer daysBack) {
        System.debug('GenerateSummaryAuditLogReport starts.');

        String contents = 'Count        Action Type \r\n';

        DateTime age = Date.today();


        try
        {
            //Calculate the age
            age = age - daysBack;

            // SOQL to get information required for CSV file
            AggregateResult[] aggList = [SELECT count(Id), Action_Type__c
                                                        FROM CN_Audit_Log__c
                                                        WHERE CreatedDate >= :age
                                                        GROUP BY Action_Type__c
                                                        ORDER BY count(Id), Action_Type__c];
            
               
            if (!aggList.isEmpty())
            {
                for (AggregateResult ar : aggList)
                {    
                    contents += ar.get('expr0') + '         ' + ar.get('Action_Type__c') + '\r\n';
                }
            }

           
        } catch (System.Exception e) {
            system.debug('@@@@@ error: ' + e);
        }    

        return contents;
        
    }
    /* PRIVATE METHODS */

    /* Potentially deleting if new logic on how to Download a CSV works
    //Detects if string contains a comma and returns string enclosed in quotes if needed
    private static String manageNull(String s) {
        Return (s==null ? '' : s);
    }
    */
    
    //Prepares the original error message using the exception object or error message.
    //This message is used for UI display and email.
    private static String generateOriginalErrorMessageTrace(CNData.CNExceptionInfo oExpInfo, String sTrackingId, Boolean bAddDebugInfo) {
        String sMessage = null;
        //Prepares exception header message
        if (oExpInfo.oExp != null) {
            if (oExpInfo.oExp.getMessage().toLowerCase().contains('timed out')) {
                sMessage = getAppCustomSetting().WS_Unavailable_Message__c;
            }
            else {
                sMessage = oExpInfo.oExp.getMessage();
            }
        }
        else {
            sMessage = oExpInfo.sExp;
        }

        //Prepare exception debugging information
        if (bAddDebugInfo) {
            sMessage += '\n\nOrg Name: ' + UserInfo.getOrganizationName() +  
                    '\nOrg Id: ' + UserInfo.getOrganizationId() + 
                    '\nUser Login Name: ' + UserInfo.getUsername() +  
                    '\nUser Full Name: ' + UserInfo.getName();
            if (CNAppUtils.isNonEmpty(oExpInfo.sClassName)) { 
                sMessage += '\nClass/Method Name: ' + oExpInfo.sClassName + '.' + oExpInfo.sMethodName;
            }
            if (oExpInfo.oExp != null) {
                sMessage += '\nLine Number: ' + oExpInfo.oExp.getLineNumber() + 
                        '\nType: ' + oExpInfo.oExp.getTypeName() + 
                        '\nStackTrace: ' + oExpInfo.oExp.getStackTraceString(); 
            }
            if (CNAppUtils.isNonEmpty(oExpInfo.sMoreInfo)) {
                sMessage += '\nMore Info: ' + oExpInfo.sMoreInfo;
            }
        }
        
        System.debug('sMessage: ' + sMessage);
        return sMessage;
    }
    
    //Prepares general error message using custom setting entry and an unique tracking id
    private static String prepareGeneralErrorMessage(String sTrackingId) {
        String sMessage = getAppCustomSetting().General_Error_Message__c;
        sMessage = sMessage.replace('{TOKEN}', sTrackingId);
        System.debug('sMessage: ' + sMessage);
        return sMessage;
    }

    //Prepares exception header message using constant variable and an unique tracking id
    private static String prepareExceptionHeaderMessage(String sTrackingId) {
        String sMessage = CNConstants.EXCEPTION_HEADER_MSG;
        sMessage = sMessage.replace('{TOKEN}', sTrackingId);
        System.debug('sMessage: ' + sMessage);
        return sMessage;
    }
        
    //Splits the input phone string (concatenated by semi-colon) into a collection of phone numbers.
    private static List<CNData.CNPhone> splitPhones(String sPhoneData, String sSeparator) {
        if (CNAppUtils.isEmpty(sPhoneData)) return null;
        List<String> listPhonesWithType = sPhoneData.split(sSeparator);
        List<CNData.CNPhone> listPhones = new List<CNData.CNPhone>();
        for (String sPhoneWithType : listPhonesWithType) {
            Integer iIndex = sPhoneWithType.lastIndexOf('(');
            if (iIndex > 0) {
                String sPhone = sPhoneWithType.substring(0, iIndex-1).trim();
                String sType = sPhoneWithType.substring(iIndex+1).replace(')', '').trim();
                listPhones.add(new CNData.CNPhone(sPhone, sType));
            }
            else {
                listPhones.add(new CNData.CNPhone(sPhoneWithType, ''));
            }
        } 
        return listPhones;
    }
    
    //Adds question mark to the end of the url only if the url doesn't already have question mark.
    private static String addQuestionMarkIfNecessary(String sUrl) 
    {
        if (sUrl.contains('?') == true)
        {
            return sUrl;
        }
        else 
        {
            return sUrl + '?';
        }
    }
    
    //Adds ampersand symbol to the end of the URL if the url doesn't end with ampersand
    private static String addAmpersandIfNecessary(String sUrl) 
    {
        if (sUrl.contains('?') == true)
        {
            if (sUrl.endsWith('?') == false)
            {
                if (sUrl.endsWith('&') == false)
                {
                    return sUrl + '&';                  
                }
            }   
        }
        return sUrl;
    }
    
    //Adds the parameters into the URL using key=value template
    private static String addParametersToURL(String sUrl, Map<String, String> mapParams, Boolean bEncode) 
    {
        if (mapParams == null) return sUrl;
        
        Integer iCount = 0;
        for (String key : mapParams.keySet()) 
        {
            sUrl += key + '=';
            if (bEncode) {
                 sUrl += EncodingUtil.urlEncode(mapParams.get(key), 'UTF-8');
            }
            else {
                sUrl += mapParams.get(key);
            }
            
            iCount++;
            if (iCount < mapParams.size())
            {
                sUrl += '&';
            }
        }
        return sUrl;
    }
    
    //Returns true if the input data is empty or null. 
    private static Boolean performEmptyCheck(String sData, Boolean bNullStringCheck) {
        if (sData == null || sData.trim().length() == 0) return true;
        if (bNullStringCheck && sData == 'null') return true;
        return false;
    }   
    
    //It concatenates firstname and lastname. If the concatenated value is empty, it returns email.
    private static String prepareFullname(String firstName, String lastName, String email) {
        if (CNAppUtils.isEmpty(firstName) && CNAppUtils.isEmpty(lastName)) {
            return trim(email, 255);
        }
        else {
            if (CNAppUtils.isEmpty(firstName)) {
                firstName = '';
            }
            if (CNAppUtils.isEmpty(lastName)) {
                lastName = '';
            }
            return trim(firstName + ' ' + lastName, 150);
        }
        return null;
    }
    
    //Converts decimal to integer data type
    private static Integer convertDecimalToInteger(Decimal dDecimalVal) {
        if (dDecimalVal != null) {
            return dDecimalVal.intValue();
        }
        return null;
    }


    

    /* INNER CLASSES */
    
    public class CNWebServiceQueueHandler {
        //Public variables
        public String sAcctId {get; set;}
        public String sContId {get; set;}
        public String sCompanyCNID {get; set;}
        public CN_Webservice_Queue__c oQueue {get; set;}
        public Id queueId {get {return oQueue.Id;}}
        public String tabName {get; set;}  //Colleague, Contact
        
        //public constants
        public final String INITIAL_DATA_RECEIVED_STATUS = 'Initial Data Received';
        public final String ALL_DATA_RECEIVED_STATUS = 'All Data Received';
        public final String FAILED_STATUS = 'Failed';
        
        /* CONSTRUCTORS */
        
        //Constructor by account/contact id
        public CNWebServiceQueueHandler(String sAcctId, String sContId, String sCompanyCNID, String tabName) {
            //return;//GMC
            System.debug('CNWebServiceQueueHandler constructor sAcctId: ' + sAcctId + ' sContId: ' + sContId + ' sCompanyCNID: ' +  sCompanyCNID +  'tabName ' + tabName);
            System.debug('sAcctId: ' + sAcctId + ', sContId: ' + sContId + ', sCompanyCNID: ' + sCompanyCNID);
            this.sAcctId = sAcctId;
            this.sContId = sContId; 
            this.sCompanyCNID = sCompanyCNID;
            this.tabName = tabName;
            loadQueueByAcctOrContId();          
        }
        
        //Constructor by queue id
        public CNWebServiceQueueHandler(String sQueueId, String tabName) {
            loadQueueByQueueId(sQueueId);
            this.tabName = tabName;
        }
        
        /* PUBLIC METHODS */
        
        //Checks if the queue is loaded
        public Boolean queueExistsWithFullyLoaded() {
            System.debug('oQueue: ' + oQueue + ', tabName: ' + tabName);
            if (this.oQueue != null) {
                if (oQueue.Contact__c != null) {
                    System.debug('returning colleague status for contact record');
                    return oQueue.Colleague_Status__c == ALL_DATA_RECEIVED_STATUS;
                }
                else if (oQueue.Account__c != null) {
                    if (tabName == 'Colleague') {
                        System.debug('returning colleague status for account record');
                        return oQueue.Colleague_Status__c == ALL_DATA_RECEIVED_STATUS;
                    }
                    if (tabName == 'Contact') {
                        System.debug('returning contact status for account record');
                        return oQueue.Contact_Status__c == ALL_DATA_RECEIVED_STATUS;
                    }
                }
            }   
            System.debug('returning false');
            return false;
        }
         
        //Creates a new web service queue record which acts as the master record for the local relationship cache
        public void createQueue() {
            System.debug('createQueue starts. oQueue: ' + oQueue);
            loadQueueByAcctOrContId();
            if (this.oQueue == null) { //Queue doesn't exist already
                DateTime dtExpiryDate = System.now().addHours(CNAppUtils.getAppCustomSetting().Data_Expiration_Hours__c.intValue());
                this.oQueue = new CN_Webservice_Queue__c(Account__c=sAcctId, Contact__c=sContId, Company_CNID__c=this.sCompanyCNID,  
                                                                Expiration_Date__c=dtExpiryDate);
                if (this.sAcctId != null) {
                    oQueue.RecordTypeId = Schema.SObjectType.CN_Webservice_Queue__c.getRecordTypeInfosByName().get('Account').getRecordTypeId();
                    oQueue.Unique_Id__c = sAcctId;
                }  
                else {
                    oQueue.RecordTypeId = Schema.SObjectType.CN_Webservice_Queue__c.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
                    oQueue.Unique_Id__c = sContId;
                } 
                insert oQueue;
                loadQueueByQueueId(oQueue.Id);
                System.debug('new queue has been created: ' + this.oQueue);  
            }
        }
        
        //Updates web service queue to indicate that the contact relationships have been persisted in local cache.
        public void updateContactStatus(String sStatus) {
            System.debug('updating contact status - oQueue: ' + oQueue);
            if (oQueue != null) {
                //The following style of update (using a new object) is needed to make sure that we don't corrupt the colleague status which may get updated asynchronously.
                CN_Webservice_Queue__c oTempQueue = new CN_Webservice_Queue__c(Id=oQueue.Id, Contact_Status__c=sStatus);  
                update oTempQueue;
                System.debug('contact status updated as: ' + sStatus);
            }
        }
    
        //Updates web service queue to indicate that the colleague relationships have been persisted in local cache.
        public void updateColleagueStatus(String sStatus) {
            System.debug('updating colleague status - oQueue: ' + oQueue);
            if (oQueue != null) {
                //The following style of update (using a new object) is needed to make sure that we don't corrupt the contact status which may get updated asynchronously.
                CN_Webservice_Queue__c oTempQueue = new CN_Webservice_Queue__c(Id=oQueue.Id, Colleague_Status__c=sStatus);  
                update oTempQueue;
                System.debug('colleague status updated as: ' + sStatus);
            }
        }
        
        //Reloads the queue record
        public void refresh() {
            System.debug('refreshing....oQueue: ' + oQueue);
            if (oQueue != null) {
                loadQueueByQueueId(oQueue.Id);
            }
            else {
                loadQueueByAcctOrContId();
            }
        }  
        
        //Returns total colleagues count
        public Integer getTotalColleagues() {
            if (oQueue != null) {
                return oQueue.Total_Colleague_Relationships__c.intValue();
            }
            return 0;
        }

        //Returns total contacts count
        public Integer getTotalContacts() {
            if (oQueue != null) {
                return oQueue.Total_Contact_Relationships__c.intValue();
            }
            return 0;
        }
    
        /* PRIVATE METHODS */
        
        //Loads queue by queue id
        private void loadQueueByQueueId(String sQueueId) {
            System.debug('loadQueueByQueueId starts - sQueueId: ' + sQueueId);
            List<CN_Webservice_Queue__c> listQueues = [Select Id, Account__c, Colleague_Status__c, Company_CNID__c, Contact__c, Contact_Status__c,
                                Total_Colleague_Relationships__c, Total_Contact_Relationships__c 
                                from CN_Webservice_Queue__c where Id=:sQueueId limit 1];    
            if (listQueues.size() == 1) {
                this.oQueue = listQueues.get(0);
                this.sCompanyCNID = oQueue.Company_CNID__c;
            }
            else {
                this.oQueue = null;
                this.sCompanyCNID = null;
            }
            System.debug('oQueue loaded: ' + oQueue);
        }
        
        //Loads queue by account or contact id
        private void loadQueueByAcctOrContId() {
            System.debug('loadQueueByAcctOrContId starts - sAcctId: ' + sAcctId + ', sContId: ' + sContId);
            if (sAcctId != null) {
                List<CN_Webservice_Queue__c> listQueues = [Select Id, Account__c, Colleague_Status__c, Company_CNID__c, Contact__c, Contact_Status__c,
                                        Total_Colleague_Relationships__c, Total_Contact_Relationships__c
                                        from CN_Webservice_Queue__c where Account__c=:sAcctId limit 1];
                if (listQueues.size() == 1) {
                    this.oQueue = listQueues.get(0);
                    this.sCompanyCNID = oQueue.Company_CNID__c;
                }
            }
            else if (sContId != null) {
                List<CN_Webservice_Queue__c> listQueues = [Select Id, Account__c, Colleague_Status__c, Company_CNID__c, Contact__c, Contact_Status__c, 
                                        Total_Colleague_Relationships__c, Total_Contact_Relationships__c
                                        from CN_Webservice_Queue__c where Contact__c=:sContId limit 1];
                if (listQueues.size() == 1) {
                    this.oQueue = listQueues.get(0);
                    this.sCompanyCNID = oQueue.Company_CNID__c;
                }
            }
            System.debug('oQueue loaded: ' + oQueue);
        }
        
    }

}