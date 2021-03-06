//
// Generated by OmniEntitlOLCPostbackWrapper http://OmniEntitlOLCPostbackWrapper.herokuapp.com/
//

@IsTest
public class OmniEntitlOLCPostbackWrapper_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"trialId\":\"asfD567gh98nhy12obc\",'+
        '   \"customerNumber\":7001234567,'+
        '   \"products\":['+
        '      {'+
        '         \"productId\":\"2345678901\",'+
        '        \"referenceId\":\"Mfhkgk789d4h5A8ABC\",'+
        '         \"status\":{'+
        '            \"statusCode\":\"COMPLETE\",'+
        '            \"statusDescription\":\"Entitlement is done for all the contacts.\"'+
        '         },'+
        '         \"contact\":['+
        '            {'+
        '               \"contactNumber\":\"8001234567\",'+
        '              \"extContactId\":\"APfhgk789d4h5A8ABC\",'+
        '               \"profileIdentifier\":\"123dfgt7890jhffd\",'+
        '               \"status\":{'+
        '                  \"statusCode\":\"COMPLETE\",'+
        '                  \"statusDescription\":\"User is entitled.\"'+
        '               },'+
        '               \"users\":['+
        '                  {'+
        '                     \"userGUID\":\"ACFHKDK73934943BDKDIM\",'+
        '                     \"domain\":\"COBALT\"'+
        '                  },'+
        '                 {'+
        '                     \"userGUID\":\"ABCHKDK73934943BDMORR\",'+
        '                     \"domain\":\"DATAROOM\"'+
        '                  }'+
        '               ]'+
        '            }'+
        '         ]'+
        '      }'+
        '   ]'+
        '}';
        OmniEntitlOLCPostbackWrapper obj = OmniEntitlOLCPostbackWrapper.parse(json);
        System.assertEquals(true,obj != null,'SUCCESS');
    }
}