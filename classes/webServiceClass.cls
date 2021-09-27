/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2018-06-14   Matthew Main            Creating OnePass Integration Per ESD-312
* =============================================================================
*/

public virtual class webServiceClass {

    String webServiceName {get;set;}
    public String endpointURL {get;set;}
    String userName {get;set;}
    String password {get;set;}
    String serviceUnavailableString {get;set;}
    public Integer timeout {get;set;}
    private String authorizationHeader;


    public webServiceClass(String serviceName){
        webServiceName = serviceName;
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

        timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();
        username = oWebServiceSettings.Username__c;
        password = oWebServiceSettings.Password__c;
        serviceUnavailableString = oWebServiceSettings.Service_Unavailable_Message__c;
        endpointURL = oWebServiceSettings.Endpoint__c;


    }
    public webServiceClass(){

    }

    public static List<Source_System_Detail__c> getSourceSystemDetails(Set<Id> listAccId,String strSubBu){
        System.debug('**call Method getSourceSystemDetails**');
        if(strSubBu == 'USL'){
            System.debug('USL');
            return [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c  IN ('USL') and LCRM_Sales_Org__c!= null];
        }else{
            System.debug('Other Profiles ');
            return [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c=:strSubBu and LCRM_Sales_Org__c!= null];
        }
    }
/*
    public static List<LCRM_Contact_SSD__c> getContactSourceSystemsDetails(List<Id> listConId, String strSubBu){
        System.debug('**call Method getContactSourceSystems**');
        if(strSubBu == 'USL'){
            System.debug('USL');
            try {
                List<LCRM_Contact_SSD__c> contactSSD = [Select id, name, LCRM_Contact__c, LCRM_Contact_ID__c, LCRM_Source_Contact_Id__c from LCRM_Contact_SSD__c Where LCRM_Contact__c in :listConId and LCRM_Legacy_Contact_Type__c = 'sapwrp'];
                System.debug('############## ContactSSD:' + contactSSD);
                return contactSSD;
            }
            catch(exception e){
                System.debug('Exception in webServiceClass.getContactSourceSystemsDetails:' + e.getMessage());
                throw e;
            }
            }else{
            System.debug('Other Profiles ');
            return [Select id, name, LCRM_Contact__c, LCRM_Contact_ID__c, LCRM_Source_Contact_Id__c from LCRM_Contact_SSD__c Where LCRM_Contact__c in :listConId and LCRM_Legacy_Contact_Type__c = 'sapwrp'];
        }

    }
*/
    /*public abstract String getEndpoint(String orgId);

    public abstract void setEndpoint();
*/
    public String getAuthorizationString(){
        if(authorizationHeader == null) {
            Blob blobCredentials = Blob.valueOf(userName + ':' + password);
            authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        }

        return authorizationHeader;

    }




}