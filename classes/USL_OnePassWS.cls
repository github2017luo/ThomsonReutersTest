/**
* Contains Methods for creating the Rest callout to ESI.
*
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2018-06-14   Matthew Main            Creating OnePass Integration Per ESD-312
* =============================================================================
*/

public class USL_OnePassWS extends webServiceClass{

        static User sCurrentUser = [select LanguageLocaleKey,Sales_Org__c,Sub_Bu__c from User where id = :UserInfo.getUserId()];
        static String strSubBu  = sCurrentUser.Sub_Bu__c;
        public static String applcationId = 'ESCU';
        //public static String UserGUIDDomain = 'COBALT';
        static webServiceClass webRequest = new webServiceClass('USL_OnePass');
        static String sapList;
        public static ID OrgId = UserInfo.getOrganizationId().substring(0,15);
        static LCRM_Contact_SSD__c contactSSD;

        //getServiceNoteList
        public static USL_OnePass GetOnePassDetails(LCRM_Contact_SSD__c cSSD) {

            //sapList = decimalArrayToStringList(contactSapId);
            //List<LCRM_Contact_SSD__c> contactSSDList = getContactSourceSystemsDetails(contactIdList, strSubBu);

            if(cSSD != null){
                contactSSD = cSSD;
                //contactSSD = contactSSDList.get(0);

                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();

                String JSONReq = buildJSON();
                System.debug('############# JSON RequestString:' + JSONReq);

                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', webRequest.getAuthorizationString());
                req.setEndpoint(webRequest.endpointURL);
                req.setBody(JSONReq);
                req.setTimeout(webRequest.timeout);

                System.debug('############# TIMEOUT:' + webRequest.timeout);
                System.debug('############# REQUEST:' + req);
                System.debug('############# Authorization:' + webRequest.getAuthorizationString());



                try {
                    if (!Test.isRunningTest()) {
                        res =  http.send(req);
                        System.debug('Response Body:' + res.getBody());

                        JSONParser parser = JSON.createParser(res.getBody());
                        Integer statusCode = res.getStatusCode();//getStatusCode(parser);
                        return getOnePassFromJson(parser, statusCode);
                    }

                    //return onePass;
                }
                catch (System.CalloutException e) {
                    //TODO Create a Exception Object Record
                    System.debug('Callout error: ' + e);
                    System.debug(res.toString());
                    throw e;
                }

                return null;

            }

            else{
                ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                commonCalloutException.setMessage('The following query did not return any results: [Select id, name, LCRM_Contact__c, LCRM_Contact_ID__c, LCRM_Source_Contact_Id__c from LCRM_Contact_SSD__c Where LCRM_Contact__c in :listConId and LCRM_Legacy_Contact_Type__c = \'sapwrp\']');
                throw commonCalloutException;
            }

       

        }

        public static String buildJson(){
            return '{"ESIHeader": {' +
                        '"applicationId": "' + applcationId + '"' +
                        '},' +
                      '"contactId": ["' + contactSSD.LCRM_Source_Contact_Id__c + '"],'+
                      '"OnlineContactFilter": {"checkPrism" : "true", "checkEntitlementDetails" :"true"}'+
                    '}';

        }

        public static String decimalArrayToStringList(Decimal[] decimalArray){
            String sapList = '';
            for(Decimal d : decimalArray){
                if(d != 0 ){
                    sapList += String.valueOf(d) + '", "';
                }

            }

            sapList = sapList.substring(0, sapList.length()-4);
            return sapList;
        }

        public static String getDateString(Date d){

            String year = String.valueOf(d.year());
            String month;
            String day;

            if(Integer.valueOf(d.month()) < 10){
                month = '0' + String.valueOf(d.month());
            }else{
                month= String.valueOf(d.month());
            }
            if(Integer.valueOf(d.day()) < 10){
                day = '0' + String.valueOf(d.day());
            }else{
                day = String.valueOf(d.day());
            }

            return '"' + year + '-' + month + '-' + day + '"';
        }


        public static USL_OnePass getOnePassFromJson(JSONParser parser, Integer statusCode) {
            List<USL_OnePass> onePassList = new List<USL_OnePass>();
            USL_onePass lastOnePass = new USL_onePass();
            if (statusCode != 200) {
                //TODO Create Exception Opject
                String errorMsg = parseErrorMessage(parser);
                ApexPages.addMessages(new AppUtil.AppException(errorMsg));
                 
                if (!Test.isRunningTest()) {
                    throw new ESC_HandlerCustomException(errorMsg);
                }
            }


            if (statusCode == 200) {
                List<USL_OnePass> List_USL_OnePass = new List<USL_OnePass>();
                //ServiceNotesWSObjects.noteItems[] noteItems = new ServiceNotesWSObjects.noteItems[]();

                while (parser.nextToken() != null) {
                    //if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() != 'changedOnDate')) {
                    System.debug('################Status Code was 200! yay!');

                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        System.debug('#################Start of object found! Object Name is: ' + parser.getText());
                        return USL_OnePass.parseEntitlements(parser);

                    }
                }


            }

            return null;
        }



        public static String parseErrorMessage(JSONParser parser){

            String statusDescription = 'Status Description: ';
            String statusDetailMessage = 'Status Detail Message: ';

            while (parser.getCurrentToken() != JSONToken.END_OBJECT && parser.nextToken()!= null) {

                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'statusDescription')) {
                    parser.nextToken();
                    statusDescription += parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == ' statusDetailMessage')) {
                    parser.nextToken();
                    statusDetailMessage += parser.getText();
                }

            }

            return statusDescription + '\n' +  statusDetailMessage;

        }

        public static ServiceNotesWSObjects.ActivityCodeItem parseActivityCodeItemList(JSONParser parser){
            ServiceNotesWSObjects.ActivityCodeItem aci = new ServiceNotesWSObjects.ActivityCodeItem();

            while (parser.getCurrentToken() != JSONToken.END_OBJECT && parser.nextToken()!= null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'activityCodeId')) {
                    parser.nextToken();
                    aci.ActivityCodeId = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'activityCodeDesc')) {
                    parser.nextToken();
                    aci.ActivityCodeDesc = parser.getText();
                }

            }
            parser.nextToken();
            return aci;
        }

        public static String getStatusCode(JSONParser parser){
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'statusCode')) {
                    parser.nextToken();
                    return parser.getText();
                }
            }
            return null;



        }


}