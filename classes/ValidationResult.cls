/**
 * Data structure representing the results of a validation rule test
 *
 * @author	John De Santiago
 * @version	2011-01-06
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2011-01-06   John De Santiago        Created
 * =============================================================================
 */
public class ValidationResult {
	
	//Properties 
	
	public boolean IsValid {get;set;}
	public Set<string> Failures {get;set;}

	//Constructors
	
	/**
	 * Default Constructor
	 */
	public ValidationResult() {
		IsValid = false;
		Failures = new Set<string>();
	}
	
	//Public Methods
	
	/**
	 * Generates an html formatted message ideal for displaying
	 * a list of validation failures to the user
	 *
	 * @return a string
	 */
	public string getHTMLErrorMessage() {
		string sErrorMessage = '<ul style="margin:0;padding: 2px 0 0 0;">';
		
		for (string sFailure : Failures) {
			sErrorMessage += '<li style="margin:0 0 0 15px; padding: 2px 0;color: red;">' + sFailure  + '</li>';
		}
		
		sErrorMessage += '</ul>';
		return sErrorMessage;
	}
}