@IsTest
public class ESC_JSON2ApexOnePassService_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"OnlineUser\": ['+
        '    {'+
        '      \"FederatedIdentity\": {'+
        '        \"OnePassUserName\": \"jillian.minnick@thomsonreuters.com\",'+
        '        \"Product\": \"CBT\",'+
        '        \"RegistrationKey\": \"9995271460-HHN1A153483141\",'+
        '        \"IsMigrated\": \"0\",'+
        '        \"IsPreferred\": \"0\",'+
        '        \"NickName\": \"ODT\",'+
        '        \"LastLoginTS\": \"2017-06-20T10:56:09.657\",'+
        '        \"Email\": \"jillian.minnick@thomsonreuters.com\"'+
        '      },'+
        '       \"Contact\": {'+
        '            \"AcctSapId\": \"123456789\",'+
        '            \"CompanyCode\": \"0010\",'+
        '            \"SalesOrgCode\": \"WEST\",'+
        '            \"DistChanCode\": \"W\",'+
        '            \"DivisionCode\": \"W\",'+
        '            \"ContactSapId\": \"123456789\",'+
        '            \"MdbContactId\": \"123456789\",'+
        '            \"Domain\": \"COBALT\",'+
        '            \"OnlineId\": \"123456789\",'+
        '            \"StatusId\": \"123456789\",'+
        '            \"StatusDesc\": \"123456789\",'+
        '            \"FirstName\": \"jillian\",'+
        '            \"LastName\": \"minnick\"'+
        '         },'+
        '      \"PrismUser\": {'+
        '        \"Guid\": null,'+
        '        \"UserId\": null,'+
        '        \"Password\": null,'+
        '        \"PwdSecEffDt\": null,'+
        '        \"PwdSecEndDt\": null,'+
        '        \"PwdSecReasonCode\": null,'+
        '        \"IsNewUser\": \"0\"'+
        '      }'+
        '    },'+
        '    {'+
        '      \"FederatedIdentity\": {'+
        '        \"OnePassUserName\": \"jillian.minnick@thomsonreuters.com\",'+
        '        \"Product\": \"SLWB\",'+
        '        \"RegistrationKey\": \"9995263847-XGLZN368279972\",'+
        '        \"IsMigrated\": \"0\",'+
        '        \"IsPreferred\": \"0\",'+
        '        \"NickName\": \"ODT\",'+
        '        \"LastLoginTS\": \"2017-11-10T12:06:37.96\",'+
        '        \"Email\": \"jillian.minnick@thomsonreuters.com\"'+
        '      },'+
        '     \"Contact\": {'+
        '            \"AcctSapId\": \"123456789\",'+
        '            \"CompanyCode\": \"0010\",'+
        '            \"SalesOrgCode\": \"WEST\",'+
        '            \"DistChanCode\": \"W\",'+
        '            \"DivisionCode\": \"W\",'+
        '            \"ContactSapId\": \"123456789\",'+
        '            \"MdbContactId\": \"123456789\",'+
        '            \"Domain\": \"COBALT\",'+
        '            \"OnlineId\": \"123456789\",'+
        '            \"StatusId\": \"123456789\",'+
        '            \"StatusDesc\": \"123456789\",'+
        '            \"FirstName\": \"jillian\",'+
        '            \"LastName\": \"minnick\"'+
        '         },'+
        '      \"PrismUser\": {'+
        '        \"Guid\": null,'+
        '        \"UserId\": null,'+
        '        \"Password\": null,'+
        '        \"PwdSecEffDt\": null,'+
        '        \"PwdSecEndDt\": null,'+
        '        \"PwdSecReasonCode\": null,'+
        '        \"IsNewUser\": \"0\"'+
        '      }'+
        '    }'+
        '  ]'+
        '}';
        ESC_JSON2ApexOnePassService obj = ESC_JSON2ApexOnePassService.parse(json);
        System.assert(obj != null);
    }
}