/**
 * test fo CNOAuth 
 *
 */ 
@IsTest
public class CNOAuthToken_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'\"access_token\": \"RFyCnQyyy2gLi2yeTv3A\",'+
		'\"expires_in\": 3600,'+
		'\"token_type\": \"Bearer\"'+
		'}';
		CNOAuthToken obj = CNOAuthToken.parse(json);
		System.assert(obj != null);
	}
}