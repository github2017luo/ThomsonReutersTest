@IsTest
public class CreateEntitlementResponse_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'   \"ESIHeader\": {'+
		'      \"transactionId\": \"3a6ff7c-1da93123a23445c21244abcfr\"'+
		'   },'+
		'   \"Notification\": {'+
		'      \"statusCode\": \"200\",'+
		'      \"statusDescription\": \"SUCCESS\",'+
		'      \"statusDetailMessage\": null'+
		'   }'+
		'}';
		CreateEntitlementResponse obj = CreateEntitlementResponse.parse(json);
		System.assert(obj != null);
	}
}