@IsTest
public class CreateEntitlementRequest_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"actionCode\": \"Trial\",'+
		'  \"isTrial\": true,'+
		'  \"onlineContact\": ['+
		'    {'+
		'      \"contactNumber\": \"0006304983\",'+
		'      \"address\": {'+
		'        \"firstName\": \"Test2\",'+
		'        \"lastName\": \"User2\",'+
		'        \"phone\": \"\",'+
		'        \"emailAddress\": \"aug16.slf177@mailinator.com\",'+
		'        \"country\": \"US\"'+
		'      },'+
		'      \"account\": {'+
		'        \"accountNumber\": \"1004631211\"'+
		'      },'+
		'      \"primaryRequester\": \"aug16.slf177@mailinator.com\",'+
		'      \"invited\": \"false\",'+
		'      \"extensibleAttributes\": ['+
		'        {'+
		'          \"key\": \"rollback\",'+
		'          \"value\": \"false\"'+
		'        },'+
		'        {'+
		'          \"key\": \"appUserGUID\",'+
		'          \"value\": \"i0acc051b000001653ad6126e3f834e7d\"'+
		'        }'+
		'      ],'+
		'      \"entitlements\": ['+
		'        {'+
		'          \"templateId\": \"410\",'+
		'          \"templateType\": \"PROFILE ID\",'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"campaignCode\",'+
		'              \"value\": \"H92758\"'+
		'            },'+
		'            {'+
		'              \"key\": \"Offer Channel\",'+
		'              \"value\": \"ODT\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720440\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000031\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720442\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000030\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720453\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000032\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720455\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000027\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720457\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000026\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720459\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6126e3f834e7d\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000029\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720461\"'+
		'            }'+
		'          ]'+
		'        }'+
		'      ]'+
		'    },'+
		'    {'+
		'      \"contactNumber\": \"0006304982\",'+
		'      \"address\": {'+
		'        \"firstName\": \"Test1\",'+
		'        \"lastName\": \"User1\",'+
		'        \"phone\": \"\",'+
		'        \"emailAddress\": \"aug16.slf176@mailinator.com\",'+
		'        \"country\": \"US\"'+
		'      },'+
		'      \"account\": {'+
		'        \"accountNumber\": \"1004631211\"'+
		'      },'+
		'      \"primaryRequester\": \"aug16.slf177@mailinator.com\",'+
		'      \"invited\": \"false\",'+
		'      \"extensibleAttributes\": ['+
		'        {'+
		'          \"key\": \"rollback\",'+
		'          \"value\": \"false\"'+
		'        },'+
		'        {'+
		'          \"key\": \"appUserGUID\",'+
		'          \"value\": \"i0acc051b000001653ad612633f834e7b\"'+
		'        }'+
		'      ],'+
		'      \"entitlements\": ['+
		'        {'+
		'          \"templateId\": \"410\",'+
		'          \"templateType\": \"PROFILE ID\",'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"campaignCode\",'+
		'              \"value\": \"H92758\"'+
		'            },'+
		'            {'+
		'              \"key\": \"Offer Channel\",'+
		'              \"value\": \"ODT\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720440\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000031\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720442\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000030\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720453\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000032\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720455\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000027\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720457\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000026\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720459\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad612633f834e7b\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000029\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720461\"'+
		'            }'+
		'          ]'+
		'        }'+
		'      ]'+
		'    },'+
		'    {'+
		'      \"contactNumber\": \"0006304984\",'+
		'      \"address\": {'+
		'        \"firstName\": \"Test3\",'+
		'        \"lastName\": \"User3\",'+
		'        \"phone\": \"\",'+
		'        \"emailAddress\": \"aug16.slf178@mailinator.com\",'+
		'        \"country\": \"US\"'+
		'      },'+
		'      \"account\": {'+
		'        \"accountNumber\": \"1004631211\"'+
		'      },'+
		'      \"primaryRequester\": \"aug16.slf177@mailinator.com\",'+
		'      \"invited\": \"false\",'+
		'      \"extensibleAttributes\": ['+
		'        {'+
		'          \"key\": \"rollback\",'+
		'          \"value\": \"false\"'+
		'        },'+
		'        {'+
		'          \"key\": \"appUserGUID\",'+
		'          \"value\": \"i0acc051b000001653ad6127a3f834e7f\"'+
		'        }'+
		'      ],'+
		'      \"entitlements\": ['+
		'        {'+
		'          \"templateId\": \"410\",'+
		'          \"templateType\": \"PROFILE ID\",'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"campaignCode\",'+
		'              \"value\": \"H92758\"'+
		'            },'+
		'            {'+
		'              \"key\": \"Offer Channel\",'+
		'              \"value\": \"ODT\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720440\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000031\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720442\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000030\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720453\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000032\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720455\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000027\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720457\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000026\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720459\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"appUserGuid\": \"i0acc051b000001653ad6127a3f834e7f\",'+
		'          \"accessStartDate\": \"2018-11-28\",'+
		'          \"accessEndDate\": \"2018-12-05\",'+
		'          \"extensibleAttributes\": ['+
		'            {'+
		'              \"key\": \"promotionCode\",'+
		'              \"value\": \"31000029\"'+
		'            },'+
		'            {'+
		'              \"key\": \"discount\",'+
		'              \"value\": \"1.00\"'+
		'            },'+
		'            {'+
		'              \"key\": \"trackingCode\",'+
		'              \"value\": \"720461\"'+
		'            }'+
		'          ]'+
		'        }'+
		'      ]'+
		'    }'+
		'  ],'+
		'  \"ESIHeader\": {'+
		'    \"applicationId\": \"CXODT\",'+
		'    \"transactionId\": \"be521503-2d94-c0eb-468f-1b95f725025d\",'+
		'    \"companyId\": \"West\",'+
		'    \"configGroup\": \"RRQ\"'+
		'  }'+
		'}';
		CreateEntitlementRequest obj = CreateEntitlementRequest.parse(json);
		System.assert(obj != null);
	}
}