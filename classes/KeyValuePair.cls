/**
 * Provides methods for generating and parsing key value pairs utilzing a
 * user defined delimiter or a default delimiter defined as a constant
 *
 * @author	John De Santiago - Thomson Reuters Code Share
 * @version	2011-01-11
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2011-01-11   John De Santiago        Created
 * =============================================================================
 */
public class KeyValuePair {
	//Constants
	public static final string DEFAULT_DELIMITER = ':';
	
	//Properties
	public string Key {get;set;}
	public string Value {get;set;}
	
	//Constructors
	
	/**
	 * Default Constructor
	 */
	public KeyValuePair() {
		Key = null;
		Value = null;		
	}
	
	/**
	 * Constructor that initializes the class with the specified
	 * key and value strings
	 *
	 * @param	sKey	a string representing the key part of the key value pair
	 * @param	sValue	a string represenging the value part of the key value pair
	 */
	public KeyValuePair(string sKey, string sValue) {
		Key = sKey;
		Value = sValue;
	}
	
	//Static Methods
	
	/**
	 * Parses the supplied string into key value pairs using the
	 * default delimiter
	 *
	 * @param	sKeyValue	the string to parse
	 * @return	an instance of the KeyValuePair object
	 */
	public static KeyValuePair parse(string sKeyValue) {
		return parse(sKeyValue, DEFAULT_DELIMITER);
	}
	
	/**
	 * Parses the supplied string into key value pairs usins the 
	 * specified delimiter
	 *
	 * @param	sKeyValue	the string to parse
	 * @param	sDelimiter	the string delimiter
	 * @return	an instance of the KeyValuePair object
	 */
	public static KeyValuePair parse(string sKeyValue, string sDelimiter) {
		KeyValuePair oKeyValuePair = new KeyValuePair();
		
		if (!AppUtil.isEmpty(sKeyValue)) {
			if (sKeyValue.contains(sDelimiter)) {
				string[] data = sKeyValue.split(sDelimiter, 2);
				
				oKeyValuePair.Key = data[0];
				oKeyValuePair.Value = data[1];
			}
			else {
				oKeyValuePair.Value = sKeyValue;
			}
		}
		
		return oKeyValuePair;
	}
	
	//Public Methods
	
	/**
	 * Combines the Key and Value property values into a single
	 * key value pair string utilizing the default delimiter
	 *
	 * @return	a string representing the key value pair. If a key
	 * 			value pair can not be generated then an empty string
	 *			is returned.
	 */
	public string combine() {
		return combine(DEFAULT_DELIMITER);
	}
	
	/**
	 * Combines the Key and Value property values into a single
	 * key value pair string utilizing the specified delimiter
	 *
	 * @param	sDelimiter	the string to delimit the Key and Value property values
	 * @return	a string representing the key value pair. If a key value pair can not
	 *			be generated then an empty string is returned.
	 */
	public string combine(string sDelimiter) {
		string sKeyValuePair = '';
		
		//Validate Delimiter
		if (AppUtil.isEmpty(sDelimiter)) {
			sDelimiter = DEFAULT_DELIMITER;
		}
		
		//Combine Key and Value properties
		if (Key != null && Value != null) {
			sKeyValuePair = Key.trim() + sDelimiter + Value.trim();	
		}
		else if (Key != null && Value == null) {
			sKeyValuePair = Key.trim();
		}
		else if (Key == null && Value != null) {
			sKeyValuePair = Value.trim();
		}
		
		return sKeyValuePair;
	}
}