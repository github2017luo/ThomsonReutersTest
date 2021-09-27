/**
 * Validates the functionality provided by the ValidationResult class.
 *
 * @author	John De Santiago
 * @version	2011-01-06
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2011-01-06   John De Santiago        IM2407671 - Created
 * =============================================================================
 */
 
@IsTest
private class ValidationResult_Test {
	//Test Method
	
	/**
	 * Test Method that validates creating and populating the properties
	 * of the ValidationResult data structure.
	 */
	static testMethod void TestValidationResult() {
		ValidationResult oResult = new ValidationResult();
		oResult.IsValid = true;
		oResult.Failures.add('Unit Test Failure Entry');
		
		string sHtml = oResult.getHTMLErrorMessage();
		
		System.assert(oResult.Failures.isEmpty() == false, 'Expected validation failures data set to not be empty');
	}
}