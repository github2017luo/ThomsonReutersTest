@IsTest
public class ReactivateEntitlementRequest_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'   \"ESIHeader\": {'+
		'      \"applicationId\": \"CXODT\",'+
		'      \"companyId\": \"WEST\",'+
		'      \"transactionId\": \"0000-8000-2282-1382\"'+
		'   },'+
		'   \"onlineContacts\": [{'+
		'      \"contactNumber\": \"0006140135\",'+
		'      \"account\": {'+
		'         \"accountNumber\": \"1004625067\"'+
		'      },'+
		'      \"sourceId\": \"ODT TEMPLT\",'+
		'      \"entitlements\": {'+
		'         \"templateId\": \"43\",'+
		'         \"templateType\": \"PROFILE ID\",'+
		'         \"subscriptions\": {'+
		'            \"offerId\": \"720172\",'+
		'            \"dataOwner\": \"ODT\",'+
		'            \"offerChannel\": \"email\",'+
		'            \"trialAdjEndTimestamp\": \"2018-12-12\"'+
		'         }'+
		'      }'+
		'   },'+
		'   {'+
		'      \"contactNumber\": \"0006140134\",'+
		'      \"account\": {'+
		'         \"accountNumber\": \"1004625067\"'+
		'      },'+
		'      \"sourceId\": \"ODT TEMPLT\",'+
		'      \"entitlements\": {'+
		'         \"templateId\": \"43\",'+
		'         \"templateType\": \"PROFILE ID\",'+
		'         \"subscriptions\": {'+
		'            \"offerId\": \"720172\",'+
		'            \"dataOwner\": \"ODT\",'+
		'            \"offerChannel\": \"email\",'+
		'            \"trialAdjEndTimestamp\": \"2018-12-12\"'+
		'         }'+
		'      }'+
		'   }'+
		'   ]'+
		'}';
		ReactivateEntitlementRequest obj = ReactivateEntitlementRequest.parse(json);
		System.assert(obj != null);
	}
}