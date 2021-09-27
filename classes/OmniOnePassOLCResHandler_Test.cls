/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-28-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class OmniOnePassOLCResHandler_Test {
     
    public static String onpassJSON = '{'+
        '   \"BOOMIHeader\": {'+
        '       \"companyId\": \"WEST\"'+
        '   },'+
        '   \"Notification\": {'+
        '       \"statusCode\": \"200\",'+
        '       \"statusDescription\": \"Success\",'+
        '       \"trackingId\": \"i0adc422f0000016176572737f91480e4\",'+
        '       \"statusDetailMessage\": \"\"'+
        '   },'+
        '    \"Header\": {'+
        '        \"AuthenticationToken\": \"\",'+
        '        \"ContextualInformation\": \"\",'+
        '        \"ProductIdentifier\": \"MISSOA\",'+
        '        \"SessionToken\": \"\",'+
        '        \"SlideInformation\": \"\",'+
        '        \"UserHostIpAddress\": \"10.204.52.1\",'+
        '        \"Version\": \"1\"'+
        '    },'+
        '    \"ServiceStatus\": {'+
        '        \"ElapsedTime\": \"0\",'+
        '        \"StartTime\": \"\\/Date(1619771564970-0500)\\/\",'+
        '        \"StatusCode\": \"0\",'+
        '        \"StatusDescription\": \"\"'+
        '    },'+
        '    \"Trace\": {'+
        '        \"ExecutionType\": \"\",'+
        '       \"ParentGuid\": \"e93e2bab1cba4555880b2f9a916c0cae\",'+
        '        \"Product\": \"MISSOA\",'+
        '        \"RootGuid\": \"e93e2bab1cba4555880b2f9a916c0cae\",'+
        '        \"ServerInformation\": \"C334ZMHOPASQF\\/36\\/17577\",'+
        '        \"SessionGuid\": \"e4f997615c5242e0a62a44b2827f96df\",'+
        '        \"TransactionGuid\": \"6b57626379394d1d9d0439a521fa59b2\",'+
        '       \"UserGuid\": \"\"'+
        '    },'+
        '    \"Results\": ['+
        '        {'+
        '            \"Criteria\": {'+
        '                \"EmailAddress\": \"FEBTest5.corp1.user1@mailinator.com\",'+
        '                \"FirstName\": \"\",'+
        '                \"Identifier\": \"\",'+
        '                \"LastName\": \"\",'+
        '                \"ProductCode\": \"\",'+
        '                \"RegistrationKey\": \"\",'+
        '                \"Username\": \"\"'+
        '            },'+
        '            \"Profiles\": ['+
        '                {'+
        '                    \"EmailAddress\": \"FEBTest5.corp1.user1@mailinator.com\",'+
        '                    \"FirstName\": \"TEST1\",'+
        '                    \"Identifier\": \"235ffaaa644a403e9bf2c1ab598fae2b\",'+
        '                    \"LastName\": \"USER1\",'+
        '                    \"Password\": \"\",'+
        '                    \"PasswordExpirationDate\": \"\\/Date(253370786399999-0600)\\/\",'+
        '                    \"PasswordLifetime\": \"0\",'+
        '                    \"ProfileType\": \"Normal\",'+
        '                    \"RegisteredProducts\": ['+
        '                        {'+
        '                            \"LastAccessedDate\": \"\",'+
        '                           \"ProductCode\": \"CBT\",'+
        '                            \"RegistrationKeys\": ['+
        '                                {'+
        '                                    \"EPaymentMethod\": \"0\",'+
        '                                    \"EPaymentSupportType\": \"\",'+
        '                                    \"IsPreferred\": \"true\",'+
        '                                    \"Name\": \"TEST\",'+
        '                                    \"Properties\": ['+
        '                                        {'+
        '                                            \"Key\": \"PrismGuid\",'+
        '                                            \"Value\": \"i0accd0bb00000177d91dc8d1e9a8f424\"'+
        '                                        }'+
        '                                    ],'+
        '                                    \"RegistrationKey\": \"2550670-NRSQG1\",'+
        '                                    \"ValidationState\": \"Valid\"'+
        '                                }'+
        '                            ]'+
        '                        }'+
        '                    ],'+
        '                    \"SecurityQuestions\": [],'+
        '                    \"Username\": \"FEBTest5.corp1.user1@mailinator.com\"'+
        '                }'+
        '            ]'+
        '        }'+
        '    ]'+
        '}';
    
    public static String olcJson = '{'+
        '    \"ESIHeader\": {'+
        '        \"applicationId\": \"CXODT\"'+
        '    },'+
        '    \"onlineContact\": ['+
        '        {'+
        '            \"contactNumber\": \"0006500519\",'+
        '            \"address\": {'+
        '                \"firstName\": \"Test1\",'+
        '                \"lastName\": \"User1\",'+
        '                \"emailAddress\": \"FEBTest5.corp1.user1@mailinator.com\"'+
        '            },'+
        '            \"account\": {'+
        '                \"accountNumber\": \"1004635821\",'+
        '                \"companyId\": \"WEST\"'+
        '            },'+
        '            \"sourceId\": \"SAP\",'+
        '            \"endDate\": \"9999-12-31T00:00:00.000-06:00\",'+
        '            \"entitlements\": ['+
        '                {'+
        '                    \"applicationId\": \"COBALT\",'+
        '                    \"status\": \"ACTIVE\",'+
        '                    \"statusReason\": \"SAP\",'+
        '                    \"appUserGuid\": \"i0accd0bb00000177d91dc8d1e9a8f424\",'+
        '                    \"accessStartDate\": \"2021-02-25\",'+
        '                    \"accessEndDate\": \"9999-12-31\",'+
        '                    \"registered\": true,'+
        '                    \"detailsIncomplete\": false,'+
        '                    \"authFirstName\": \"TEST1\",'+
        '                    \"authLastName\": \"USER1\",'+
        '                    \"authEmail\": \"FEBTest5.corp1.user1@mailinator.com\",'+
        '                    \"authId\": \"235ffaaa644a403e9bf2c1ab598fae2b\",'+
        '                    \"logonName\": \"FEBTest5.corp1.user1@mailinator.com\",'+
        '                    \"appUserRefId\": \"2550670-NRSQG1\",'+
        '                    \"appUserRefIdNickName\": \"TEST\",'+
        '                    \"appUserRefIdPrimary\": true,'+
        '                    \"lastPasswordChangeDate\": \"9998-12-31T23:59:59.9999999\",'+
        '                    \"authenticationSystem\": \"ONE_PASS\"'+
        '                },'+
        '                {'+
        '                    \"applicationId\": \"DATAROOM\",'+
        '                    \"status\": \"ACTIVE\",'+
        '                    \"statusReason\": \"SAP\",'+
        '                    \"appUserGuid\": \"i0accd6a200000177d91dccc1509a92ec\",'+
        '                    \"accessStartDate\": \"2021-02-25\",'+
        '                    \"accessEndDate\": \"9999-12-31\",'+
        '                    \"authenticationSystem\": \"ONE_PASS\"'+
        '                }'+
        '            ],'+
        '            \"onlineContactType\": \"0100\",'+
        '            \"onlineContactTypeDescription\": \"Attorney\",'+
        '            \"allowContactEmails\": false'+
        '        }'+
        '    ]'+
        '}';
 
 /**
  * @description testmethod1
  * 
  */    
    
  /*  @isTest
    public static void testmethod1(){
        contact con = new contact();
        con.firstName='get2arpit';
        con.lastname = 'TEST';
        con.email='get2arpit@me.com';
        insert con;
        
        string conJson = JSON.serialize(con);
        TrialContactWrapper  trwp = OmniOnePassOLCResHandler.getTrialContactWrapper(true,conJson,onpassJSON,olcJson);
         system.assertEquals(trwp != null , true, 'SUCCESS');
    }*/

 /**
  * @description testmethod2
  * 
  */       
  /*  @isTest
    public static void testmethod2(){
        contact con = new contact();
        con.firstName='get2arpit';
        con.lastname = 'TEST';
        con.email='get2arpit2@me.com';
        insert con;
        
        string conJson = JSON.serialize(con);
        TrialContactWrapper  trwp = OmniOnePassOLCResHandler.getTrialContactWrapper(false,conJson,onpassJSON,olcJson);
        system.assertEquals(trwp != null , true, 'SUCCESS');
    }
 */
     /**
  * @description testmethod3
  * 
  */   
    @isTest
    public static void testmethod3(){
        
        list<contact>  contacts = new list<contact>();
        contact con = new contact();
        con.firstName='get2arpit';
        con.lastname = 'TEST';
        con.email='get2arpit3@me.com';
        insert con;
        contacts.add(con); 
        
        string conJson = JSON.serialize(contacts);
        System.debug(LoggingLevel.WARN,'conJson : '+conJson );
       // OmniCallToOLCByEmailResponseWrapper olcWrap = (OmniCallToOLCByEmailResponseWrapper) System.JSON.deserialize(olcJson, OmniCallToOLCByEmailResponseWrapper.class);
        OmniOnePassResponseWrapper onePasswrap = (OmniOnePassResponseWrapper) System.JSON.deserialize(onpassJSON, OmniOnePassResponseWrapper.class);
        
        TrialOLCOnePassByEmailRespWrap trialContWrap = new TrialOLCOnePassByEmailRespWrap();
        trialContWrap.profileType='NEW_CUSTOMER';
        trialContWrap = OmniOnePassOLCResHandler.getTrialOnePassReponseWrap(onePasswrap );
        //List<TrialProductWrapper> wrper = OmniOnePassOLCResHandler.getTrialPrdWrapList(conJson);
         system.assertEquals(trialContWrap != null , true, 'SUCCESS');
        // system.assertEquals(wrper != null , true, 'SUCCESS');
    }
}