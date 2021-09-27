/**============================================================================================
    Name                : ODTTrialManagement
    Description         : This class is developed as part of CXD-ODT project :DLT-13384,DLT-13386
                          It serves as a service for the Extend and End Trial functionality wherein we are 
                          passing the details required for extension or end trial to OLC via ESI.
    Created Date        : 11/1/2018
    Author              : Ameeta Antonio
    Modification History:
    DATE            DEVELOPER       CHANGE HISTORY
    11/1/2018       Ameeta Antonio   Created
    10/1/2020       Rahul           DLT-20756 :[SFDC] [ODT] Critical and Blocker Code scan issue     
==============================================================================================**/
public without sharing class ODTTrialManagement { 
    public static boolean testServiceBoolean; 
    public static HttpResponse postTrialExtendDetails(Id trialId, String operation, String reasonCode, String trialEndDate) {

        list < ODTTrialManageResponseWrapper.OnlineContact > oclist = new list < ODTTrialManageResponseWrapper.OnlineContact > ();
        ODTTrialManageResponseWrapper.ESIHeader esihdr;
        ODTTrialManageResponseWrapper.Account acc1;
        ODTTrialManageResponseWrapper.OnlineContact oc;
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ODTTrialExtensionService');
        String username = oWebServiceSettings.Username__c;
        String password = oWebServiceSettings.Password__c;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        Http http = new Http();
        HTTPResponse res;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(oWebServiceSettings.Endpoint__c);
        request.setHeader('content-type', 'application/json');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Authorization', authorizationHeader);
        esihdr = new ODTTrialManageResponseWrapper.ESIHeader();
        esihdr.applicationId = Label.ODT_ESI_App_userID;
        List < Trial__c > trialList = [Select id, name, Trial_End_Date__c, Trial_Id__c, ODT_SAP_Account_Number__c, Contact_LeadId__c, Contact_id_SAP__c, Trial_Source__c, (Select ID, SapContactId__c, Primary_User__c, Email__c, Trial_Status__c FROM Invite_Colleagues__r WHERE Primary_User__c = FALSE AND Trial_Status__c =: 'Accepted') from Trial__c where id =: trialId WITH SECURITY_ENFORCED];
        system.debug('Triallist************' + trialList);
        ODTTrialManageResponseWrapper.Entitlements entit;
        ODTTrialManageResponseWrapper.Entitlements entit2;
        List < ODTTrialManageResponseWrapper.Entitlements > entitlementlist;
        ODTTrialManageResponseWrapper.Subscriptions sub;
        ODTTrialManageResponseWrapper.ExtensibleAttributes extAttr;

        if (trialList.size() > 0) {
            for (Trial__c tr: trialList) {
                System.debug('enter first trial loop');
                oc = new ODTTrialManageResponseWrapper.OnlineContact();
                sub = new ODTTrialManageResponseWrapper.Subscriptions();
                extAttr = new ODTTrialManageResponseWrapper.ExtensibleAttributes();
                entitlementlist = new list < ODTTrialManageResponseWrapper.Entitlements > ();
                acc1 = new ODTTrialManageResponseWrapper.Account();
                acc1.accountNumber = tr.ODT_SAP_Account_Number__c;
                entit = new ODTTrialManageResponseWrapper.Entitlements();
                sub.trialReasonCode = reasonCode;
                sub.trialEndDate = trialEndDate;
                sub.offerId = tr.Trial_Id__c;
                sub.dataOwner = 'ODT';
                extAttr.value = 'true';
                //DLT-20756 - PMD Fix 
                if (operation.equalsIgnoreCase('Extend')) {
                    extAttr.key = 'ExtendTrial';
                } else if (operation.equalsIgnoreCase('End')) {
                    extAttr.key = 'EndTrial';
                }
                entit.subscriptions = sub;
                entit.ExtensibleAttributes = extAttr;
                entitlementlist.add(entit);
                oc.contactNumber = tr.Contact_id_SAP__c;
                oc.Account = acc1;
                oc.entitlements = entitlementlist;
                oclist.add(oc);
            }

            for (Trial__c tr: trialList) {
                System.debug('enter second trial loop');
                if (tr.Invite_Colleagues__r.size() > 0) {
                    for (Invite_Colleagues__c inv: tr.Invite_Colleagues__r) {
                        oc = new ODTTrialManageResponseWrapper.OnlineContact();
                        sub = new ODTTrialManageResponseWrapper.Subscriptions();
                        extAttr = new ODTTrialManageResponseWrapper.ExtensibleAttributes();
                        entitlementlist = new list < ODTTrialManageResponseWrapper.Entitlements > ();
                        acc1 = new ODTTrialManageResponseWrapper.Account();
                        acc1.accountNumber = tr.ODT_SAP_Account_Number__c;
                        entit = new ODTTrialManageResponseWrapper.Entitlements();
                        sub.trialReasonCode = reasonCode;
                        sub.trialEndDate = trialEndDate;
                        sub.offerId = tr.Trial_Id__c;
                        sub.dataOwner = 'ODT';
                        extAttr.value = 'true';
                        //DLT-20756 - PMD Fix
                        if (operation.equalsIgnoreCase('Extend')) {
                            extAttr.key = 'ExtendTrial';
                        } else if (operation.equalsIgnoreCase('End')) {
                            extAttr.key = 'EndTrial';
                        }
                        entit.subscriptions = sub;
                        entit.ExtensibleAttributes = extAttr;
                        entitlementlist.add(entit);
                        oc.contactNumber = inv.SapContactId__c;
                        oc.Account = acc1;
                        oc.entitlements = entitlementlist;
                        oclist.add(oc);
                    }
                }
            }
            System.debug('oclist' + oclist);
            try {
                ODTTrialManageResponseWrapper req = new ODTTrialManageResponseWrapper();
                if (!oclist.isEmpty() && oclist.size() > 0) {
                    req.onlineContact = oclist;
                    req.context = '';
                    req.ESIHeader = esihdr;
                    //DLT-20756 - PMD Fix
                    String jsonString = JSON.serialize(req);
                    system.debug('serialized JSON' + jsonString);
                    // Set the body as a JSON object
                    request.setBody(jsonString);
                    if (!test.isrunningtest()) {
                        res = new http().send(request);
                    } else {
                        // Code for test classes.......
                        res = new HttpResponse();
                        res.setHeader('Content-Type', 'application/json');
                        res.setBody('{"ESIHeader" : {    "applicationId" : "CXODT"  },  "Notification" : {    "statusCode" : "200",    "statusDescription" : "SUCCESS",    "statusDetailMessage" : null,    "trackingId" : null  },  "onlineContact" : [ {    "contactNumber" : "8000227813",    "entitlements" : [ {      "subscriptions" : [ {        "subscriptionStatus" : "true",        "subscriptionMessage":"success",        "offerId" : [ "720902" ],        "dataOwner" : [ "ODT" ],        "trialEffDate" : "2018-11-20",        "trialEndDate" : "2018-11-20",       "trialReasonCode" : "Product Purchased"      } ]    } ]  } ]}');
                        //DLT-20756 - PMD Fix
                        if (!ODTTrialManagement.testServiceBoolean) {
                            res.setStatusCode(200);
                        } else {
                            res.setBody('{"ESIHeader" : {    "applicationId" : "CXODT"  },  "Notification" : {    "statusCode" : "400",    "statusDescription" : "SUCCESS",    "statusDetailMessage" : null,    "trackingId" : null  },  "onlineContact" : [ {    "contactNumber" : "8000227813",    "entitlements" : [ {      "subscriptions" : [ {        "subscriptionStatus" : "true",        "subscriptionMessage":"success",        "offerId" : [ "720902" ],        "dataOwner" : [ "ODT" ],        "trialEffDate" : "2018-11-20",        "trialEndDate" : "2018-11-20",       "trialReasonCode" : "Product Purchased"      } ]    } ]  } ]}');
                            res.setStatusCode(200);
                        }
                    }
                }
            } catch (Exception e) {
                system.debug('ErrorMsg***' + e.getMessage());
                system.debug('***********' + res);
            }
        }
        // Parse the JSON response
        if (res != null) {
            if (res.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' +
                    res.getStatusCode() + ' ' + res.getStatus());
                System.debug(res.getBody());
            } else {
                System.debug('Res' + res.getBody());
            }
        }
        return res;
    }
}