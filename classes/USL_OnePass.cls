/**
 * USL_OnePass object. Used to present the information retrieved from ESI, ONePass, OLC and Prism.
 *
 * @author  Matthew Main
 * @version  2018-06-20
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-06-14   Matthew Main            Creating OnePass Integration Per ESD-312
 * =============================================================================
 */
public without sharing class USL_OnePass {
    public LCRM_Contact_SSD__c contactSSD {get;set;}
    public USL_OnePass onePass {get;set;}
    //public List<USL_OnePass> onePassList {get;set;}
    public List<USL_OnePass_Entitlement> entitlements {get;set;}
    public ID contactId;
    public string SAPContactId{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string onePaseUsername{get;set;}
    public String status{get;set;}
    public String domain{get;set;}
    public String ProductRegistrationKey{get;set;}
    public String UserGUID{get;set;}
    public String nickName{get;set;}
    public DateTime lastLogin{get;set;}
    public static List<String> domains = new List<String>{ 'BUSLAW','COBALT', 'CLEAR','DRAFTING','ORION', 'SLW','CAYMAN', 'EREADER', 'RFI'};


   
    public USL_OnePass(ApexPages.StandardController controller) {
        contactSSD = (LCRM_Contact_SSD__c) controller.getRecord();
        contactSSD = [SELECT LCRM_Source_Contact_Id__c, Name from LCRM_Contact_SSD__c where Id = : contactSSD.id];

        if(onePass == null) {
            List<Id> contactIdList = new List<Id>();
            contactIdList.add(contactSSD.id);
            onePass = USL_OnePassWS.GetOnePassDetails(contactSSD);
            System.debug('OnePassList passed to USL_OnePass:' + onePass);
        }
    }

    public USL_OnePass() {

    }

    public static USL_OnePass parseEntitlements(JSONParser parser) {

        USL_OnePass onepass = new USL_OnePass();
        List<USL_OnePass_Entitlement> entitlements = new List<USL_OnePass_Entitlement>();

        if(parser.nextToken() == null){
            return null;
        }

        while (parser.nextToken() != null) {

            try {

                System.debug('########################## Hit line 55.');
                System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&& Token:' + parser.getCurrentName());

                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'contactNumber')) {
                    parser.nextToken();
                    onepass.SAPContactId = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'firstName')) {
                    parser.nextToken();
                    onepass.firstName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'lastName')) {
                    parser.nextToken();
                    onepass.lastName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
                    parser.nextToken();
                    onePass.status = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'appUserGuid')) {
                    parser.nextToken();
                    onePass.UserGUID = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'entitlements')) {
                    while(parser.getCurrentToken() != JSONToken.END_ARRAY){
                        USL_OnePass_Entitlement parsedEntitlement = new USL_OnePass_Entitlement(parser, onePass);

                        if(domains.contains(parsedEntitlement.applicationId)){
                            entitlements.add(parsedEntitlement);
                        }

                        parser.nextToken();
                    }

                }
            } catch (exception e) {
                    System.debug('############:' + e.getMessage());
                    throw e;
            }

        }

        System.debug('Created the following entitlements:' + entitlements);
        System.debug('Created Object OnePass from JSON:' + onePass);
        //serviceNoteItem.ActivityCodeItemList = ACIList;
        onePass.entitlements = entitlements;
        return onePass;
    }

    public static USL_OnePass createTestData(){

        USL_OnePass onePass = new USL_OnePass();

        onePass.contactSSD = new LCRM_Contact_SSD__c();
        //onePass.contactId = contact.id;
        onePass.SAPContactId = '0006266225';
        onePass.firstName = 'firstName - sdfjhfgdjkla';
        onePass.lastName = 'lastName - dfsjkgfl';
        onePass.onePaseUsername = 'onePassUserName - sdakjlhdfgjlkh';
        onePass.status = 'Active';
        onePass.domain = 'domain';
        onePass.ProductRegistrationKey = 'ProductRegistrationKey';
        onePass.UserGUID = 'i0ace19660000016092b5b40a83e4f87a';
        onePass.nickName = 'NickName - asdflkjfg';
        onePass.lastLogin = DateTime.now();
        return onePass;

    }

    public static String sampleResponse(){

        String json = '{'+
        '                            "onlineContact" : [ {'+
        '                            "contactNumber" : "0006266225",'+
        '                            "address" : {'+
        '                            "firstName" : "Test1",'+
        '                            "lastName" : "User1"'+
        '                            },'+
        '                            "account" : {'+
        '                            "accountNumber" : "1004627675",'+
        '                            "companyId" : "WEST"'+
        '                            },'+
        '                            "sourceId" : "SAP",'+
        '                            "endDate" : "9999-12-31T00:00:00.000-06:00",'+
        '                            "entitlements" : [ {'+
            '                            "status" : "ACTIVE",'+
            '                            "applicationId" : "COBALT",'+
            '                            "appUserGuid" : "i0ace19660000016092b5b40a83e4f87a",'+
                    '                    "accessStartDate" : "2017-12-26",'+
                    '                    "accessEndDate" : "9999-12-31",'+
                    '                    "statusReason" : "SAP",'+
                    '                    "logonName" : "testLoginName",'+
                    '                    "appUserRefIdNickName" : "testNickName",'+
                    '                    "appUserRefId" : "TestRefId",'+ 
                    '                    "authenticationSystem" : "COBALT",'+
                    '                    "authLastName" : "authLastName",'+
                    '                    "lastLogonDate" : "lastLoginTest"'+
                    '                    }, {'+
                    '                    "status" : "ACTIVE",'+
                    '                    "applicationId" : "DATAROOM",'+
                    '                    "appUserGuid" : "i0acc051b0000016092b5b68dead9d7fd",'+
                    '                    "accessStartDate" : "2017-12-26",'+
                    '                    "accessEndDate" : "9999-12-31",'+
                    '                    "statusReason" : "SAP"'+
                    '                    }, {'+
                    '                    "status" : "ACTIVE",'+
                    '                    "applicationId" : "WESTLAW",'+
                    '                    "appUserGuid" : "10175320",'+
                    '                    "accessStartDate" : "2017-12-26",'+
                    '                    "accessEndDate" : "9999-12-31",'+
                '                            "statusReason" : "SAP"'+
                '                            } ],'+
                '                            "onlineContactType" : "0100",'+
                        '                            "allowContactEmails" : false'+
                        '                            } ]'+
                        '                            }';

        return json;
    }

    public class USL_OnePass_Entitlement{
        public String status {get;set;}
        public String applicationId {get;set;}
        public String appUserGUID {get;set;}
        public String accessStartDate {get;set;}
        public String accessEndDate {get;set;}
        public String statusReason {get;set;}
        public String logonName{get;set;}
        public String nickName {get;set;}
        public String registrationKey {get;set;}
        public String authFirstName {get;set;}
        public String authLastName {get;set;}
        public String authenticationSystem {get;set;}
        public String lastLogin {get;Set;}
        public USL_OnePass onePass {get;set;}


        public USL_OnePass_Entitlement(JSONParser parser, USL_OnePass onePass){

            this.onePass = onePass;

            while (parser.getCurrentToken()  !=  JSONToken.END_OBJECT) {


                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
                    parser.nextToken();
                    status = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'applicationId')) {
                    parser.nextToken();
                    applicationId = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'appUserGUID')) {
                    parser.nextToken();
                    appUserGUID = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'accessStartDate')) {
                    parser.nextToken();
                    accessStartDate = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'accessEndDate')) {
                    parser.nextToken();
                    accessEndDate = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'statusReason')) {
                    parser.nextToken();
                    statusReason = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'logonName')) {
                    parser.nextToken();
                    logonName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'appUserRefIdNickName')) {
                    parser.nextToken();
                    nickName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'appUserRefId')) {
                    parser.nextToken();
                    registrationKey = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'authenticationSystem')) {
                    parser.nextToken();
                    authenticationSystem = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'authFirstName')) {
                    parser.nextToken();
                    authFirstName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'authLastName')) {
                    parser.nextToken();
                    authLastName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'lastLogonDate')) {
                    parser.nextToken();
                    lastLogin = parser.getText();
                }


                parser.nextToken();

            }

            //parser.nextToken();


        }


    }
    

}