@IsTest
public class ReactivateEntitlementResponse_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"billingGroupNumber\": \"1004625067\",'+
		'    \"billingGroupName\": \"TEST_SAMPLE_11\",'+
		'    \"status\": \"Success\",'+
		'    \"contactInformation\": ['+
		'        {'+
		'            \"contactTransactionId\": \"0000-8000-2282-1382\",'+
		'            \"contactNumber\": \"0006140135\",'+
		'            \"success\": \"true\",'+
		'            \"entitlements\": ['+
		'                {'+
		'                    \"applicationId\": \"COBALT\",'+
		'                    \"appUserId\": \"9995259385\",'+
		'                    \"appUserPassword\": \"LIR9F727755937\",'+
		'                    \"appUserGuid\": \"i0ace19a80000015b43cdf9998b1d46aa\"'+
		'                }'+
		'            ]'+
		'        },'+
		'        {'+
		'            \"contactTransactionId\": \"0000-8000-2282-1382\",'+
		'            \"contactNumber\": \"0006140134\",'+
		'            \"success\": \"true\",'+
		'            \"entitlements\": ['+
		'                {'+
		'                    \"applicationId\": \"COBALT\",'+
		'                    \"appUserId\": \"9995259384\",'+
		'                    \"appUserPassword\": \"3HNX3505551144\",'+
		'                    \"appUserGuid\": \"i0acc051b0000015b43cc917101da841d\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    ]'+
		'}';
		ReactivateEntitlementResponse obj = ReactivateEntitlementResponse.parse(json);
		System.assert(obj != null);
	}
}