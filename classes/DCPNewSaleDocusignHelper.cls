/**
    @description Docusign helper class. Call from creation and view classes.
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-19          Benjamin Her                DCP-1548 DCPDocusignHelper Initial Creation
    2021-06-15          Avudaiappan A               DCP-2252 Repurposed from Ben Class
            
 */
public without sharing class DCPNewSaleDocusignHelper{

    public static String defaultAuthenticationHeader; //This authentication header is the default and should always work
    public static String docusignConnectUrl;
    public static String docusignConnectUser;
    public static String docusignConnectPassword;
    public static String docusignConnectIntegrationKey;
    public static Apttus_DocuApi__DocuSignUser__c oDocuSignAccount = 
        [SELECT Apttus_DocuApi__DocuSignAccountId__c, Apttus_DocuApi__DocuSignEmailAddress__c, Apttus_DocuApi__DocuSignUserName__c
        FROM Apttus_DocuApi__DocuSignUser__c
        WHERE Apttus_DocuApi__Default__c = true
        LIMIT 1];

    /**
        @description Populates the Docusignconnection information
     */
    public static void getDocusignConnectionInfo(){

        Digital_Firm_Defaults__mdt defaultSenderOnBehalf = 
            [SELECT Label, DocuSign_Send_on_Behalf_of_Email__c, Opportunity_Owner__c FROM Digital_Firm_Defaults__mdt where Proposal_Approval_Segment__c ='Small Law' and Opportunity_Type__c = 'New Sales' WITH SECURITY_ENFORCED LIMIT 1 ];

        // get DocuSign connection information 
        if (WebServiceSettings__c.getInstance('Digital DocuSign Connection') != null) {

            docusignConnectUrl = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Endpoint__c;
            docusignConnectUser = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Username__c;
            // password contains password and integration key
            String sTemp = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Password__c;
            List<String> listTemp = (sTemp.split(':'));
            docusignConnectPassword = listTemp[0];
            docusignConnectIntegrationKey = listTemp[1];

            defaultAuthenticationHeader =
                '<DocuSignCredentials>' +
                '<Username>' + docusignConnectUser + '</Username>' +
                '<Password>' + docusignConnectPassword + '</Password>' +
                '<IntegratorKey>' + docusignConnectIntegrationKey + '</IntegratorKey>' +
                '<SendOnBehalfOf>' + defaultSenderOnBehalf.DocuSign_Send_on_Behalf_of_Email__c + '</SendOnBehalfOf>' +
                '</DocuSignCredentials>';
        }
    }

    /**
        @description Returns the base Docusign account URL
        @return Returns string of the base Docusign account URL
     */
    public static String getDocusignAccountEndpoint(){
        
        HttpResponse docuSignResponse = new HttpResponse();
        String accountUrl = '';

        docuSignResponse = httpGetRequest(docusignConnectUrl, defaultAuthenticationHeader);

        if (docuSignResponse.getStatusCode() == 200) {
            DocusignLoginResponse docusignResBody = (DocusignLoginResponse)JSON.deserialize(docuSignResponse.getBody(),DocusignLoginResponse.class);

            for(Map<String,String> docusignAccount: docusignResBody.loginAccounts){
                if(docusignAccount.containsKey('accountId')
                    && docusignAccount.get('accountId') == oDocuSignAccount.Apttus_DocuApi__DocuSignAccountId__c
                    && docusignAccount.containsKey('baseUrl')){
                    
                    accountUrl = docusignAccount.get('baseUrl');
                    break;
                }
            }
        } 
        else {
            throw new DCCustomException(docuSignResponse.toString());
        }

        return accountUrl;
    }
    
    /** 
    * @description : setup response for GET request
    * @param endPoint : request end point
    * @param authentication : credenitals
    * @return HttpResponse : http response 
    */    
    public static HttpResponse httpGetRequest(String endPoint, String authentication) {
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http();

        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-DocuSign-Authentication', authentication);
        request.setMethod('GET');

        // send request
        response = http.send(request);
        return response;

    } // end httpGetRequest() method

    /** 
    * @description : setup response for PUT request
    * @param endPoint : request end point
    * @param authentication : credenitals
    * @param body : body for the request
    * @return HttpResponse : http response 
    */      
    public static HttpResponse httpPutRequest(String endPoint, String authentication, String body) {
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http();

        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-DocuSign-Authentication', authentication);
        request.setMethod('PUT');
        request.setBody(body);

        // send the request
        response = http.send(request);
        return response;

    } // end httpPostRequest() method

    //Custom class used to store Docusign login response
    private class DocusignLoginResponse{
        List<Map<String,String>> loginAccounts;
    }
}