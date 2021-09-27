/**
 * Provides static application specific helper methods and constants
 * <p>
 * The purpose of this class is to centralize re-usable constants and methods
 * that can be utilized by multiple modules. This class should not include any
 * business logic or details specific to a sObject, Class, or Custom Module.
 *
 * @author  John De Santiago - Thomson Reuters Code Share
 * @version 2010-11-01
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2010-11-01   John De Santiago        Created
 * 2010-11-15   John De Santiago        Added getWebServiceSettings method
 * 2011-02-22   John De Santiago        Fixed decimal format method
 * 2011-08-01   Nick Cook               Added toTitleCase method
 * 2016-03-25   TCS                     Changes for MCL-1393
 * 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
 * =============================================================================
 */
public without sharing class AppUtil {
    //Private Constants
    private static final integer MAX_INNER_EXCEPTIONS = 3;
    private static AppUtil instance;
    //Private Variables
    private Map<string, List<RecordType>> mapRecordTypes;
    //Public Constants
    public static final string NEW_LINE_CHAR = '\r\n';
    
    //Constructors
    /**
     * Default private constructor.
     */
    private AppUtil() { 
        mapRecordTypes = null;
    } 
    
    //Public Static Methods
    
    /**
     * Provides a singleton instance of the application utility class 
     * allowing global transactions values to be stored and accessed.
     */
    public static AppUtil getInstance() {
        if (instance == null) {
            instance = new AppUtil();
        }
        return instance;
    }
    
    /**
     * Determines if the specified string is null or blank by trimming any trailing spaces.
     *
     * @param   sValue  the string to evaluate for null or blank
     * @param   iLength the max length of the string
     * @return  a string truncated to the specified length
     */
    public static string truncateString(string sValue, integer iLength) {
        string sTruncatedString = '';
        if (sValue != null && iLength != 0){
            if (iLength > sValue.length()){
                iLength = sValue.length();
            }
            sTruncatedString = sValue.substring(0, iLength);
        }
        return sTruncatedString;
    }
    
    /**
     * Evaluates the specified string and returns a string matching padded or truncated
     * to the specified length
     *
     * @param   sValue  the string to evaluate
     * @param   iLength the desired length of the string
     * @return  a fixed width string based on the specified length.
     */ 
    public static string fixedWidthString(string sValue, integer iLength){
        return truncateString(rightPadString(sValue, ' ', iLength), iLength);
    }
    
    /**
     * Pads the specified string to the right and returns a string matching the requested length
     *
     * @param   sValue      the string to evaluate
     * @param   sPadValue   the string value to pad
     * @param   iLength     the desired number of times to append the sPadValue to the sValue
     * @return  a fixed width string based on the specified length.
     */ 
    public static string rightPadString(string sValue, string sPadValue, integer iLength){
        string sPaddedString = (sValue == null ? '' : sValue);
        for (integer i=0; i < iLength; i++){
            sPaddedString += sPadValue;
        }
        return sPaddedString;
    }
    
    /**
     * Pads the specified string to the left and returns a string matching the requested length
     *
     * @param   sValue      the string to evaluate
     * @param   sPadValue   the string value to pad
     * @param   iLength     the desired number of times to append the sPadValue to the sValue
     * @return  a fixed width string based on the specified length.
     */ 
    public static string leftPadString(string sValue, string sPadValue, integer iLength){
        string sPaddedString = (sValue == null ? '' : sValue);
        for (integer i=0; i < iLength; i++) {
            sPaddedString = sPadValue + sPaddedString;
        }
        return sPaddedString;
    }
        
    /**
     * Determines if the specified string is null or blank by trimming any trailing spaces.
     *
     * @param   sValue  the string to evaluate for null or blank
     * @return  true if the string is null or blank, otherwise returns false.
     */
    public static boolean isEmpty(string sValue) {
        return (sValue == null || sValue.trim().length() == 0);
    }
    
    /**
     * Determines if the supplied value is null or empty and returns
     * the value or the specified default value if null
     *
     * @param   sValue      the string to evaluate
     * @param   sDefault    the string to return if the value is null
     * @return  the default value if null, otherwise returns the supplied value unchanged
     */
    public static string isNull(string sValue, string sDefault) {
        return isEmpty(sValue) ? sDefault : sValue;
    }
    
    /**
     * Determines if the supplied value is null and returns
     * the value or the specified default value if null
     *
     * @param   dValue      the decimal to evaluate
     * @param   dDefault    the decimal to return if the value is null
     * @return  the default value if null, otherwise returns the supplied value unchanged
     */
    public static decimal isNull(decimal dValue, decimal dDefault) {
        return (dValue == null) ? dDefault : dValue;    
    }
    
    /**
     * Determines if the supplied value is null and returns
     * the value or the specified default value if null
     *
     * @param   iValue      the integer to evaluate
     * @param   iDefault    the integer to return if the value is null
     * @return  the default value if null, otherwise returns the supplied value unchanged
     */
    public static integer isNull(integer iValue, integer iDefault) {
        return (iValue == null) ? iDefault : iValue;    
    }
    
    /**
     * Formats the specified date to a string using the supplied format
     * <p>
     * This function converts the date to a datetime value and uses the
     * formatDateTime method to perform the formatting request
     *
     * @param   dValue      the date value to format
     * @param   sFormat     the format the date should be represented as
     * @param   sDefault    the value to return if the dValue is null
     * @return  a formatted string representation of the supplied date.
     */
    public static string formatDate(date dValue, string sFormat, string sDefault) {
        string sFormattedDate = sDefault;
        if (dValue != null && sFormat != null) {
            DateTime dtValue = DateTime.newInstance(dValue.year(), dValue.month(), dValue.day());
            sFormattedDate = formatDateTime(dtValue, sFormat, sDefault);
        }
        return sFormattedDate;
    }
    
    /**
     * Formats the specified datetime to a string using the supplied format
     *
     * @param   dtValue     the datetime value to format
     * @param   sFormat     the format the datetime should be represented as
     * @param   sDefault    the value to return if the dtValue is null
     * @return  a formatted string representation of the supplied datetime.
     */
    public static string formatDateTime(datetime dtValue, string sFormat, string sDefault) {
        string sFormattedDateTime = sDefault;
        if (dtValue != null && sFormat != null){
            sFormattedDateTime = dtValue.format(sFormat);
        }
        return sFormattedDateTime;
    }
    
    /**
     * Formats the specified decimal to a string
     *
     * @param   decValue    the decimal value to format
     * @param   iScale      the number of decimal places to display
     * @param   sDefault    the value to return if the decValue is null
     * @return  a formatted string representation of the supplied decimal
     */
    public static string formatDecimal(decimal decValue, integer iScale, string sDefault) {
        string sFormattedDecimal = sDefault;
        if (decValue != null){
            sFormattedDecimal = decValue.setScale(iScale).toPlainString();
        }
        return sFormattedDecimal;
    }
    
    /**
     * converts a given string to Title Case where the
     * first letter of every word is capitalised and the rest are lower
     
     * @param   phrase      the title/phrase to be converted
     */ 
    public static String toTitleCase(String phrase){
         String titlePhrase = '';
        //a set of words that should always (or at least, almost always) be in lower case when in Title Case
        //eg "The Day of the Jackal."  First and last word of a phrase should always be Capped though.
      Set<String> forceLower = new Set<String>{'of', 'the', 'for', 'and', 'a', 'to', 'at' ,'an', 'but', 'if', 'or', 'nor'};
      Set<String> keepUpper = new Set<String>{'N', 'NE', 'NW','S','SE', 'SW', 'W', 'E'};
      if(phrase != null && phrase.length() > 0){
            String[] splitPhrase = phrase.trim().split(' ');
            for(integer i = 0; i < splitPhrase.size(); i++){
                if(!forceLower.contains(splitPhrase[i].toLowerCase()) || i == 0 || i == (splitPhrase.size()-1) ){
                    if(keepUpper.contains(splitPhrase[i])) {
                        titlePhrase += splitPhrase[i];
                    }
                    else {
                        titlePhrase += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
                    }
                }
                else{
                    titlePhrase += splitPhrase[i].toLowerCase()+' ';
                }
            }
        }
        return titlePhrase.trim();
    }
        
    /**
     * Static helper method that retrieves a url parameter from a page reference and returns
     * the specified default value if the url parameter is null.
     *
     * @param   oPageReference  the page reference containing the url parameters to retrieve
     * @param   sParamName      the name of the url parameter to return
     * @param   sParamDefault   the default value to return if the url parameter is null or empty
     * @return  a string representing the url parameter value or the default value.
     */
    public static string getURLParam(PageReference oPageReference, string sParamName, string sParamDefault) {
        string sParamValue = sParamDefault;
        if (oPageReference != null){
            Map<string, string> mapParameters = oPageReference.getParameters();
            if (mapParameters != null && mapParameters.containsKey(sParamName)) {
                sParamValue = AppUtil.isNull(mapParameters.get(sParamName), sParamDefault);
            }
        }
        return sParamValue;
    }
    
    /**
     * Static method that retrieves and validates web service settings entry by name.
     * <p>
     * Validation verifies that service is active and throws a WebServiceSettingsException if the service
     * is inactive with the configured service unavailable description text as the error message.
     *
     * @param   sServiceName    the name of the configured web service setting.
     * @return  an instance of the WebServiceSettings__c object
     */
    public static WebServiceSettings__c getWebServiceSettings(string sServiceName) {
        WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(sServiceName);
        if (oWebServiceSettings == null){
            throw new InvalidWebServiceException(string.format(System.Label.InvalidServiceName, new string[] {sServiceName}));
        }
        else{
            if (!oWebServiceSettings.Active__c) {
                throw new InactiveWebServiceException(oWebServiceSettings.Service_Unavailable_Message__c);
            }
        }
        return oWebServiceSettings;
    }
    
    /**
     * Retrieves an existing exception log and returns the error message
     * based on the Display_Friendly_Error_Message__c flag
     *
     * @param   exceptionLogId      the exception log id to query
     * @param   sDefaultMessage     the message to return if the exception log number is not found
     * @return  the user message based on the Display_Friendly_Error_Message__c flag, otherwise returns
     *          the specified default message.
     */
    public static string getUserErrorMessage(Id exceptionlogId, string sDefaultMessage) {
        string sUserMessage = sDefaultMessage;
        //Get existing exception log message
        List<Exception_Log__c> listExceptionLog = [SELECT Id, Name, User_Message__c, Exception_Message__c FROM Exception_Log__c WHERE Id=:exceptionLogId];
        if (!listExceptionLog.isEmpty()) {
            SystemSettings__c oSystemSettings = SystemSettings__c.getInstance();
            Exception_Log__c oExceptionLog = listExceptionLog[0];
            if (oSystemSettings.Display_Friendly_Error_Message__c) {
                sUserMessage = oExceptionLog.User_Message__c;
                sUserMessage += AppUtil.NEW_LINE_CHAR;
                sUserMessage += string.format(System.Label.ExceptionLogReference, new string[] {oExceptionLog.Name});
            }
            else {
                sUserMessage = oExceptionLog.Exception_Message__c;
            }
        }
        return sUserMessage;
    }
    
    /**
     * Static error handler method which logs the error to the exception log returning
     * a user friendly error message and a reference number for error details where possible.
     * <p>
     * Defaults the error handler result to the default value which will return either the
     * user friendly message or full exception details based on the Display Friendly Error Message
     * flag specified in the System Settings.
     *
     * @param   oException  an instance of the exception to handle
     * @return  a formatted message based on the users profile
     */
    public static string handleError(Exception oException){
        return handleError(oException, HandleErrorResult.DefaultMessage);
    }
    
    /**
     * Static error handler method which logs the error to the exception log returning
     * a user friendly error message and a reference number for error details where possible.
     * <p>
     * If an exception is determined to be a DML Custom Validation type exception then the
     * validation error message is returned as an empty string and the error is not logged. 
     * This will allow system admins to continue to maintain validation errors and reduce 
     * any unecessary logging to the exception log.
     *
     * @param   oException  an instance of the exception to handle
     * @param   eResultType an enum value indicating the type of result to return
     * @return  the message specified by the HandleErrorResult enum
     */
    public static string handleError(Exception oException, HandleErrorResult eResultType){
        string sResult = System.Label.GenericErrorMessage;
        try {
            //Build Error Message
            string sUserMessage = System.Label.GenericErrorMessage;
            string sErrorMessage = oException.getMessage();
            string sErrorDetails = '';
            string sExceptionLogId = null;
            SystemSettings__c oSystemSettings = SystemSettings__c.getInstance();
            if (oSystemSettings != null && oSystemSettings.Default_Error_Message__c != null) {
                sUserMessage = oSystemSettings.Default_Error_Message__c;    
            }
            //Test if DML Validation Error
            boolean bIsValidationError = false;
            if (oException instanceof DMLException){
                System.DMLException oDMLException = (System.DMLException) oException;
                if (oDMLException.getDmlType(0) == System.StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    bIsValidationError = true;
                }
            }
            if (bIsValidationError){
                //Ignore Validation Error Message - Error is already natively attached to the record and field
                sUserMessage = '';
            }
            else{
                //Get Inner Exceptions
                integer iInnerExceptionCounter = 0;
                Exception oInnerException = oException.getCause();
                while (oInnerException != null) {
                    iInnerExceptionCounter++;
                    sErrorDetails += AppUtil.NEW_LINE_CHAR;
                    sErrorDetails += oInnerException.getTypeName() + ' - ';
                    sErrorDetails += oInnerException.getMessage();
                    sErrorDetails += AppUtil.NEW_LINE_CHAR;
                    if (iInnerExceptionCounter >= MAX_INNER_EXCEPTIONS) {
                        break;
                    }
                    else {
                        oInnerException = oException.getCause();
                    }
                }
                //Insert Log Entry
                Exception_Log__c oExceptionLog = new Exception_Log__c();
                oExceptionLog.User_Message__c = sUserMessage;
                oExceptionLog.Exception_Type__c = oException.getTypeName();
                oExceptionLog.Exception_Message__c = sErrorMessage;
                oExceptionLog.Additional_Information__c = sErrorDetails;
                Database.SaveResult sr = Database.insert(oExceptionLog, false);
                string sExceptionLogNumber = '';
                if (sr.isSuccess()) {
                    sExceptionLogId = sr.Id;
                    sUserMessage = getUserErrorMessage(sr.Id, sUserMessage);
                }
                else{
                    sUserMessage += AppUtil.NEW_LINE_CHAR;
                    sUserMessage += string.format(System.Label.ExceptionLogError, new string[] {sr.getErrors()[0].getMessage()});
                }
            }
            //Determine Return Result
            if (eResultType == HandleErrorResult.DefaultMessage) {
                if (oSystemSettings.Display_Friendly_Error_Message__c) {
                    sResult = sUserMessage;
                }
                else {
                    sResult = sErrorMessage;
                }
            }
            else if (eResultType == HandleErrorResult.FriendlyMessage) {
                sResult = sUserMessage;
            }
            else if (eResultType == HandleErrorResult.ExceptionMessage) {
                sResult = sErrorMessage;
            }
            else if (eResultType == HandleErrorResult.ExceptionId) {
                sResult = sExceptionLogId;
            }
        }
        catch (Exception oHandlerException) {
            sResult += AppUtil.NEW_LINE_CHAR;
            sResult += string.format(System.Label.ExceptionLogError, new string[] {oHandlerException.getTypeName()});
/*System.debug(LoggingLevel.ERROR, oHandlerException.getMessage()); -- commented to reduce character for s2e optimization */
        }
        return sResult;
    }
    
    //Public Methods
    /**
     * Performs a lookup for a record type id based on the supplied object type
     * and record type name.
     *
     * @param   sObjectType     the type of sObject to lookup a record type name by
     * @param   sRecordTypeName the name or developer name of the record type to lookup
     * @return  a valid record type id based on the supplied object type and name, otherwise returns null
     */
    public static Id getRecordTypeIdByName(string sObjectType, string sRecordTypeName) {
        Id recordTypeId = null;
        AppUtil oAppUtil = AppUtil.getInstance();
        Map<string, List<RecordType>> mapRecordTypes = oAppUtil.getRecordTypes();
        if (mapRecordTypes.containsKey(sObjectType)) {
            for (RecordType oRecordType : mapRecordTypes.get(sObjectType)) {
                if (sRecordTypeName.equalsIgnoreCase(oRecordType.Name) || sRecordTypeName.equalsIgnoreCase(oRecordType.DeveloperName)) {
                    recordTypeId = oRecordType.Id;
                    break;
                }
            }
        }
        return recordTypeId;
    }
    
    //Private Methods
    
    /**
     * Provides a singleton instance of record types mapped by object type 
     * reducing the need for multiple queries for record types
     * and improving system performance.
     */
    private Map<string, List<RecordType>> getRecordTypes(){
        if (mapRecordTypes == null) {
            mapRecordTypes = new Map<string, List<RecordType>>();
            List<RecordType> listRecordTypes = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType];
            for (RecordType oRecordType : listRecordTypes) {
                if (mapRecordTypes.containsKey(oRecordType.SObjectType)) {
                    mapRecordTypes.get(oRecordType.SObjectType).add(oRecordType);
                }
                else {
                    mapRecordTypes.put(oRecordType.SObjectType, new List<RecordType> { oRecordType });
                }
            }
        }
/*system.debug('mapRecordTypes..'+mapRecordTypes.get('Account')); -- commented to reduce character for s2e optimization */
        return mapRecordTypes;
    }
    
    //method to return Profile Name based on Profile ID
    public static String getProfileName(String profileID){
        String profileName = '';
        Profile_List__c pl = Profile_List__c.getValues(profileID);
        if(pl!=null && pl.Name == profileID)
            profileName = pl.Profile_Name__c;
        return profileName;
    }
    
    
    //method to return loggedin userInfo
    public static User loggedInUserDetail{
        get{
            if(loggedInUserDetail == null)loggedInUserDetail = [SELECT Id,Profile.Name,UserRole.DeveloperName,Sales_Org__c FROM User where id = :UserInfo.getUserId()];
            return loggedInUserDetail;    
        }
    }
    
    //Internal Classes
    
    /**
     * Enum indicating the type of error result information available for return
     */
    public enum HandleErrorResult {DefaultMessage, FriendlyMessage, ExceptionMessage, ExceptionId}
    
    /**
     * Default AppUtil Exception
     */
    public class AppException extends Exception {}
    
    /**
     * Custom exception thrown when an invalid web service is accessed 
     */
    public class InvalidWebServiceException extends Exception {}
    
    /**
     * Custom exception thrown when an inactive web service is accessed
     */
    public class InactiveWebServiceException extends Exception {}
}