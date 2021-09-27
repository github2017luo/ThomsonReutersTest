@isTest
global class MockUSLSubbillingcontroller implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
       String json=     '{'+
        '    "billPlanHeader": {'+
        '        "subscriptionNumber": "0110160241",'+
        '        "subscriptionLines": ['+
        '            {'+
        '                "subscriptionLineNumber": "000010"'+
        '            }'+
        '        ],'+
        '        "billPlanInfo": {'+
        '            "billPlanNumber": "0000614928",'+
        '            "billPlanStartDate": "2001-09-25",'+
        '            "billPlanEndDate": "2003-08-15",'+
        '            "billPlanType": "Z3",'+
        '            "billPlanDescription": "Z3"'+
        '        },'+
        '        "endDate": "2003-09-24"'+
        '    },'+
        '    "billPlanDetails": ['+
        '        {'+
        '            "settlementDate": "0000-00-00",'+
        '            "billItemStartDate": "0000-00-00",'+
        '            "billItemEndDate": "0000-00-00",'+
        '            "billItemPrice": "0.00",'+
        '            "billCurrency": null,'+
        '            "block": null,'+
        '            "billItemStatus": null,'+
        '            "billItemType": null,'+
        '            "manaulDateInd": null,'+
        '            "correctionDateInd": null,'+
        '            "paymentTerms": null,'+
        '            "dateCategory": null'+
        '        },'+
        '        {'+
        '            "settlementDate": "2001-09-25",'+
        '            "billItemStartDate": "2002-09-24",'+
        '            "billItemEndDate": "2001-10-12",'+
        '            "billItemPrice": "1879.20",'+
        '            "billCurrency": "USD",'+
        '            "block": null,'+
        '            "billItemStatus": "C",'+
        '            "billItemType": "ZANN",'+
        '            "manaulDateInd": null,'+
        '            "correctionDateInd": null,'+
        '            "paymentTerms": null,'+
        '            "dateCategory": "03"'+
        '        },'+
        '        {'+
        '            "settlementDate": "2002-09-25",'+
        '            "billItemStartDate": "2003-09-24",'+
        '            "billItemEndDate": "2002-09-25",'+
        '            "billItemPrice": "2340.00",'+
        '            "billCurrency": "USD",'+
        '            "block": null,'+
        '            "billItemStatus": "C",'+
        '            "billItemType": "ZANN",'+
        '            "manaulDateInd": null,'+
        '            "correctionDateInd": null,'+
        '            "paymentTerms": null,'+
        '            "dateCategory": "03"'+
        '        },'+
        '        {'+
        '            "settlementDate": "2003-08-16",'+
        '            "billItemStartDate": "2003-09-24",'+
        '            "billItemEndDate": "2003-08-16",'+
        '            "billItemPrice": "-256.64",'+
        '            "billCurrency": "USD",'+
        '            "block": null,'+
        '            "billItemStatus": "C",'+
        '            "billItemType": "ZPCM",'+
        '            "manaulDateInd": "Y",'+
        '            "correctionDateInd": "A",'+
        '            "paymentTerms": null,'+
        '            "dateCategory": "03"'+
        '        }'+
        '    ],'+
        '    "statusDetails": ['+
        '        {'+
        '            "statusCode": "200",'+
        '            "statusDescription": "Success",'+
        '            "statusDetailMessage": "Get Billing Plans Successful.    3 detail records found."'+
        '        }'+
        '    ]'+
        '}';

            system.debug('Mock webservice callout');
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
           // res.setEndpoint('http://api.salesforce.com/foo/bar');
            res.setBody(json);
            res.setStatusCode(200);
            system.debug('res....'+res);
            return res;
        }
        
    }