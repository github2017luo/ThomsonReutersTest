/**
 * Validates the functionality provided by the KeyValuePair class.
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
@IsTest
private class KeyValuePair_Test {

	/**
	 * Validates that the KeyValuePair class properly
	 * parses a key value pair with user defined and
	 * default delimiters
	 */
	static testMethod void testParseKeyValuePair() {
		//Setup Test
		string sKeyValuePairA = 'keyA:valA';
		string sKeyValuePairB = 'keyB;valB';
		string sKeyValuePairC = 'keyC-valC';
		
		Test.startTest();
		
		//Test A
		string sValueA = KeyValuePair.parse(sKeyValuePairA).Value;
		System.assertEquals('valA', sValueA, 'Parse did not return the expected value for TestA');
		
		//Test B
		string sValueB = KeyValuePair.parse(sKeyValuePairB, ';').Value;
		System.assertEquals('valB', sValueB, 'Parse did not return the expected value for TestB');
		
		//Test C
		string sValueC = KeyValuePair.parse(sKeyValuePairC).Value;
		System.assertEquals(sKeyValuePairC, sValueC, 'Expected string to not be parsed and to match the original argument for TestC');
		
		//Test D
		string sValueD = KeyValuePair.parse(null).Value;
		System.assert(sValueD == null, 'Expected a null string to be returned when a null argument is specified for Test D');
		
		//Test E
		string sValueE = KeyValuePair.parse('').Value;
		System.assert(sValueE == null, 'Expected a null string to be returned when an empty string is specified for Test E');
		
		Test.stopTest();
	}
	
	/**
	 * Validates that the KeyValuePair class properly
	 * combines the Key and Value property values into
	 * a single key value pair string using user defined
	 * and default delimiters
	 */
	static testMethod void testCombineKeyValuePair() {
		//Setup Test
		KeyValuePair oKeyValuePairA = new KeyValuePair('keyA', 'valA');
		KeyValuePair oKeyValuePairB = new KeyValuePair('keyB', 'valB');
		KeyValuePair oKeyValuePairC = new KeyValuePair(null, 'valC');
		KeyValuePair oKeyValuePairD = new KeyValuePair('keyD', null);
		KeyValuePair oKeyValuePairE = new KeyValuePair(null, null);
		KeyValuePair oKeyValuePairF = new KeyValuePair('keyF', 'valF');
		
		Test.startTest();
		
		//Test A
		string sKeyValuePairA = oKeyValuePairA.combine();
		System.assertEquals('keyA:valA', sKeyValuePairA, 'Expected key value pair string delimited with default delimiter');
		
		//Test B
		string sKeyValuePairB = oKeyValuePairB.combine(';');
		System.assertEquals('keyB;valB', sKeyValuePairB, 'Expected key value pair string delimited with user defined delimiter');
		
		//Test C
		string sKeyValuePairC = oKeyValuePairC.combine();
		System.assertEquals('valC', sKeyValuePairC, 'Expected string containing the supplied value');
		
		//Test D
		string sKeyValuePairD = oKeyValuePairD.combine();
		System.assertEquals('keyD', sKeyValuePairD, 'Expected string containing the supplied key');
		
		//Test E
		string sKeyValuePairE = oKeyValuePairE.combine();
		System.assert(sKeyValuePairE != null, 'Expected non-null value to be returned when a null Key and Value are supplied');
		
		//Test F
		string sKeyValuePairF = oKeyValuePairF.combine(null);
		System.assertEquals('keyF:valF', sKeyValuePairF, 'Expected key value pair string delimited with default delimiter when null delimiter is supplied');
		
		Test.stopTest();
	}
}