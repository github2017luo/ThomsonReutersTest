/*============================================================================================
    Name                : CallToOLCTofetchActiveTr  
    Description         : This class is developed as part of CXD-ODT project and it is serving as helper class for contactsListCon class  
    Created Date        : 2/15/2018 
    Author              : TCS CXD ODT team
    Modification History: Modified by Mallik for showing all contacts which are available  OLC
                          Optimizing the code by Harshitha

                          Modified by Harshitha
                          DLT-8079: creating Lead and Trial records from SFDC end when rep Initiates a Trial

                          Modified by Ameeta Antonio 
                          DLT-10234 : Modified the class as part of GLI Migration.

                          Modified by Harshitha[10/04/2018]
                          DLT-12370: Added a method to create Invited Colleague record to capture Primary user details

              Modified by Mallikarjuna Rao,Ameeta Antonio
              DLT-12958 : [SFDC] TM/SR-N-Initiate: 2.b inactive sub - SFDC: ability to initiate a trial and link accounts
                    with valid and invalid Reason codes
                     DLT-19237 : [SFDC] Add Trail End date function to check according ODT bundle data
                     DLT-19937 : [SFDC] Add ODT Product Info on Trials
                     DLT-19957 : [SFDC] Add ODT product Detail on ODT Number of days trial Extended
            
 * 2020-09-20   Brenda Shields          DLT-20747 - Remove isPrivate setting from Note attachment
 * 2020-11-20   Brenda Shields          DLT-21153 - Revert name to "OnlineContactFilter" (not "onlineContactFilter") lines 587/594              
==============================================================================================*/

public without sharing class CallToOLCTofetchActiveTr {

    //START OF Request Classes
    public class DetailsToOLCTofetchActiveTr {
        public esiHeader esiHeader {
            get;
            set;
        }
        public String accountNumber {
            get;
            set;
        }
        public String startDate {
            get;
            set;
        }
        public String endDate {
            get;
            set;
        }

        public DetailsToOLCTofetchActiveTr(String accNum, string stDate, string edDate, esiHeader esih) {
            esiHeader = esih;
            accountNumber = accNum;
            startDate = stDate;
            endDate = eddate;
        }
    }

    public class esiHeader {
        public String applicationId {
            get;
            set;
        }
        public esiHeader(string appId) {
            applicationId = appId;
        }
    }
    // End of Request Classes

    //Start Of body classes
    public class TrialHistoryResponse {
        public CallToOLCTofetchActiveTr.cls_confirmations[] confirmations;
        public String trackingId; //2ccef284-fd16-4c78-99ca-684a86875506
        public boolean hasTrial;
        public CallToOLCTofetchActiveTr.cls_trials[] trials;
    }

    public class cls_confirmations {
        public string trackingID;
    }

    public class cls_trials {
        public String contactNumber; //0006270038
        public cls_offers[] offers;
        public cls_extensibleAttributes[] extensibleAttributes;
    }
    public class cls_offers {
        public String offerId; //720440
        public String domains; //COBALT
    }
    public class cls_extensibleAttributes {
        public String key; //trialStartDate
        public String value; //2018-02-05
    }
    //End of Body Classes


    // Get trial details (check to see if there are any active trials for this Account)
    public static boolean CallOLCForActiveTrials(string accountID) {
        Boolean hasTrial = false;

        try {
            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ODTSubscriptionService');

            blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

            CallToOLCTofetchActiveTr.esiHeader esih = new CallToOLCTofetchActiveTr.esiHeader(Label.ODT_ESI_App_userID);

            string todaysDate = string.valueOf(system.today().Year()) + '-' + string.valueOf(system.today().month()) + '-' + string.valueOf(system.today().day());
            string sixMonthssDate = string.valueOf(system.today().addMonths(-6).Year()) + '-' + string.valueOf(system.today().addMonths(-6).month()) + '-' + string.valueOf(system.today().addMonths(-6).day());

            CallToOLCTofetchActiveTr.DetailsToOLCTofetchActiveTr dolcdata = new CallToOLCTofetchActiveTr.DetailsToOLCTofetchActiveTr(accountID, sixMonthssDate, todaysDate, esih);

            String esibodyInviteCollBody = JSON.serialize(dolcdata);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(esibodyInviteCollBody);
            system.debug(LoggingLevel.INFO, '0000000000000       ' + esibodyInviteCollBody);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(120000);

            Http http = new Http();
            HTTPResponse res;

            system.debug(LoggingLevel.INFO, '111111111111111       ' + req);
            if (!test.isrunningtest()) { 
            	res = http.send(req);
            } else {
                //Test Classes Response.
                res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"confirmations" : [ null ], "trackingId" : "e464eb1b-9a81-4b75-9170-a763d833893e", "hasTrial" : true, "trials" : [ {   "contactNumber" : "0006271252",   "offers" : [ {     "offerId" : "720440",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271253",   "offers" : [ {     "offerId" : "720440",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271254",   "offers" : [ {     "offerId" : "720440",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271252",   "offers" : [ {     "offerId" : "720442",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271253",   "offers" : [ {     "offerId" : "720442",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271254",   "offers" : [ {     "offerId" : "720442",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271252",   "offers" : [ {     "offerId" : "720455",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271253",   "offers" : [ {     "offerId" : "720455",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] }, {   "contactNumber" : "0006271254",   "offers" : [ {     "offerId" : "720455",     "domains" : "COBALT"   } ],   "extensibleAttributes" : [ {     "key" : "trialStartDate",     "value" : "2017-02-15"   }, {     "key" : "trialEndDate",     "value" : "2017-02-22"   }, {     "key" : "trialAdjEndTimestamp",     "value" : null   }, {     "key" : "trialReasonCode",     "value" : null   }, {     "key" : "trialReactivateCount",     "value" : "0"   } ] } ]}');
                res.setStatusCode(200);
            }
            //system.debug(LoggingLevel.INFO, '222222       ' + res + '      ' + res.getBody());
            if (res.getStatusCode() == 200) {
				hasTrial = ProcessRequestHelper(res);
			// else response not 200
            } else {
                hasTrial = true;
            }
            //system.debug(LoggingLevel.INFO, 'hasTrial......' + hasTrial);          
		} catch (Exception e) { 
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
            //system.debug(LoggingLevel.INFO, 'Line Number- 199: ' + e);
        }          
        return hasTrial;
    }
    
    
    // Process response for details of Trials(to know is there any Active trials exists on selected Account)
    public static boolean processRequestHelper(HttpResponse res) {
    	Boolean hasTrial = false;
    	
		CallToOLCTofetchActiveTr.TrialHistoryResponse esiResp;
        try {
        	//system.debug(LoggingLevel.INFO, 'From try..........');
            esiResp = (CallToOLCTofetchActiveTr.TrialHistoryResponse) JSON.deserialize(res.getBody(), CallToOLCTofetchActiveTr.TrialHistoryResponse.class);

        } catch (exception e) {
            //system.debug(LoggingLevel.INFO, 'From catch..........');
            esiResp = (CallToOLCTofetchActiveTr.TrialHistoryResponse) JSON.deserialize(res.getBody().replacefirst('null', '{ }'), CallToOLCTofetchActiveTr.TrialHistoryResponse.class);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
        }
        if (esiResp.trials == null || !esiResp.hasTrial) {
        	return false;
        }
        	
        for (CallToOLCTofetchActiveTr.cls_trials trls: esiResp.trials) {
			//system.debug(LoggingLevel.INFO, 'trls.extensibleAttributes:.......' + trls.extensibleAttributes);
            for (CallToOLCTofetchActiveTr.cls_extensibleAttributes exta: trls.extensibleAttributes) {
				hasTrial = checkHasTrial(exta);
				if (hasTrial) {
                   	break;
              	}
            }  // for loop end

           	if (hasTrial) {
               	break;
          	}
        }  // for loop end
        return hasTrial;
    }
    
    
    public static boolean checkHasTrial(CallToOLCTofetchActiveTr.cls_extensibleAttributes exta) {
        string haveaTrialexd;
        string haveaTrialed;

        if (exta.key == 'trialAdjEndTimestamp' && exta.value != null) {
       		haveaTrialexd = exta.value;
            if (buildTrialDate(haveaTrialexd)) {
            	return true;
            }
        }    
        if (exta.key == 'trialEndDate' && exta.value != null) {
        	haveaTrialed = exta.value;
            if (buildTrialDate(haveaTrialed)) {
                return true;
           	}
        }
        return false;
    }
	               
                
    // Build date validation
    public static boolean buildTrialDate(string checkDate) {
    	string extYear = checkDate.substring(0, 4); 
        string extMonth = checkDate.substring(5, 7); 
        string extDay = checkDate.substring(8, 10);
        Date exdDate = Date.newInstance(integer.valueof(extYear), integer.valueof(extMonth), integer.valueof(extDay));
                                
        system.debug(LoggingLevel.INFO, 'extYear: ' + extYear + ', extMonth: ' + extMonth + ', extDay: ' + extDay +
                ', exdDate: ' + exdDate);
        if (system.today().DaysBetween(exdDate) > 0) { 
           	return true;
        } else {
        	return false;
        }
    }
    

    // Code to fetch Lapsed Account details 
    public static LapsedAccountDetails checkLapsedAccountDetails(string sSDAccountNumber) {

        LapsedAccountDetails lapsedAcc;
        Boolean isLapsedSuccess = false;
        Boolean isValidReason = true;
        String lapsedCode;
        String lapsedDesc;
        map<String, string> reasonCodeMap = new map<String, String>();

        try {
            list<ODT_Trial_Reason_Codes__mdt > reasonCodeList = new list<ODT_Trial_Reason_Codes__mdt > ([Select ODT_Reason_Code__c, ODT_Reason_Description__c, ODT_Reason_Validity__c FROM ODT_Trial_Reason_Codes__mdt]);
            if (reasonCodeList.size() > 0) {
                for (ODT_Trial_Reason_Codes__mdt code: reasonCodeList) {
                    reasonCodeMap.put(code.ODT_Reason_Code__c, code.ODT_Reason_Description__c);
                }
            }

            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ODTGetLapsedAccountDetails');

            LapsedAccountWrapper.LapsedReqWrapper lapsedAccreq = LapsedAccountWrapper.checkLapsedAccountDetails(sSDAccountNumber);
            String esiLapsedService = JSON.serialize(lapsedAccreq);

            HttpRequest req = new HttpRequest();
            req = LapsedAccountWrapper.callESIService(esiLapsedService, oWebServiceSettings); //1);
            HTTPResponse res;
            Http http = new Http();
            //system.debug(LoggingLevel.INFO, 'Calling Lapsed Request ........' + req);

            if (!test.isrunningtest()) { 
            	res = http.send(req);
            } else {
                res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"statusDetails":[{"statusCode":"200","statusDescription":"SUCCESS"}],"subscription":[{"subscriptionNumber":"0111387539","subscriptionType":"NBP","subscriptionStatus":"LAPSED","material":{"materialNumber":"000000000013997625","materialDescription":"CD TX LEG PR FMS FOCD SUB"},"adjustments":[{"discountCode":null,"discountAmount":"0","discountPercent":"0","discountReason":null}],"account":[{"accountNumber":"1000597251"}],"subscriptionLines":[{"subscriptionLineNumber":"000010","quantity":"1","practiceAreaCode":null,"practiceAreaDescription":null,"locationCode":null,"locationDescription":null,"dealId":null,"lapseDate":"20171130","lapsedReasonCode":"PT","lapsedReasonDescription":"Sub - Product Termination","contentGroupNumber":" ","titleId":"Texas Legal Practice Forms - Forms on CD-ROM","autoRenewFlag":null,"firstYearDiscount":null,"netAmount":0,"priceRates":[{"priceRateType":"BANDED","priceRate":"0"},{"priceRateType":"PERUSER","priceRate":null},{"priceRateType":"RETAILUSER","priceRate":null}]}],"bandRange":{"userCount":"00000"},"startDate":"20031203","endDate":"0","classifications":[{"classificationName":"estimatedUnitUpKeep","classificationType":"216.5"}],"storageKey":"698522970111387539","levelCode":["02"],"levelValue":["CD-ROM"]}]}');
                res.setStatusCode(200);
            }
            //system.debug(LoggingLevel.INFO, 'Calling Lapsed response ........' + res.getBody());

            if (res.getStatusCode() == 200) {
                LapsedAccountResponse esiLapsedAccResp = (LapsedAccountResponse) JSON.deserialize(res.getBody(), LapsedAccountResponse.class);
                ////system.debug(LoggingLevel.INFO, '-------Rajan---------Test 1---esiLapsedAccResp-' + esiLapsedAccResp);
                Boolean isreqSuccess = FALSE;

                for (LapsedAccountResponse.statusDetails lstatus: esiLapsedAccResp.statusDetails) {
                    if (lstatus.statusCode == '200'){
                        isreqSuccess = true;
                    }
                }
                
                //system.debug(LoggingLevel.INFO, '-------Rajan---------Test 2----');
                if (isreqSuccess) {
                	lapsedAcc = checkLapsedAccountDetailsHelper(esiLapsedAccResp, reasonCodeMap);
                }
            }

        } catch (Exception e) { 
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
            //system.debug(LoggingLevel.INFO, 'Line Number- 199: ' + e); 
        }
        return lapsedAcc;
    }


    // Check response details for Lapsed Account  
    public static LapsedAccountDetails checkLapsedAccountDetailsHelper(LapsedAccountResponse esiLapsedAccResp, map<string, string> reasonCodeMap) {
        LapsedAccountDetails lapsedAcc;
        Boolean isLapsedSuccess = false;
        Boolean isValidReason = true;
        String lapsedCode = null;
        String lapsedDesc = null;        
        
        for (LapsedAccountResponse.subscription sub: esiLapsedAccResp.subscription) {
			//System.debug('esiLapsedAccResp.subscriptionLines========='+esiLapsedAccResp.subscriptionLines);

            if (sub.SubscriptionLines == null) {
            	break;
            }
                        	
            for (LapsedAccountResponse.SubscriptionLines subLines: sub.SubscriptionLines) {
                if (sub.subscriptionStatus.equalsIgnoreCase('LAPSED')) {
                    isLapsedSuccess = true;
                    if (reasonCodeMap.containsKey(subLines.lapsedReasonCode)) {
                      	lapsedCode = subLines.lapsedReasonCode; lapsedDesc = subLines.lapsedReasonDescription; isValidReason = FALSE;
                    } else if (isValidReason == true) {
                       	lapsedCode = subLines.lapsedReasonCode;
                        lapsedDesc = subLines.lapsedReasonDescription;
                        isValidReason = true;
                    }
                }
            }
        }  // end for
        lapsedAcc = new LapsedAccountDetails(lapsedCode, lapsedDesc, isLapsedSuccess);
        return lapsedAcc;
    }
   
    
    // Code to display the Online Contacts
    public static HTTPResponse showOnlineContacts(string accountID) {
        HTTPResponse res;

        try {
            WebServiceSettings__c oWebServiceSettings1 = AppUtil.getWebServiceSettings('ODTGenericEntitlementService');

            String username = oWebServiceSettings1.Username__c;
            String password = oWebServiceSettings1.Password__c;

            blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

            ESIHeaderCls esih = new ESIHeaderCls(Label.ODT_ESI_App_userID);
            accountCls acch = new accountCls(accountID);
            callInviteCol callhcol = new callInviteCol(esih, acch);

            String esibodyInviteCollBody = JSON.serialize(callhcol);

            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            //req.setEndpoint('https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/qa/getEntitlements');
            req.setEndpoint(oWebServiceSettings1.Endpoint__c);
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(esibodyInviteCollBody);

            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(120000);

            Http http = new Http();

            system.debug(LoggingLevel.INFO, 'Request.................' + req);
            system.debug(LoggingLevel.INFO, 'Request Body.................' + req.getBody());

            if (!test.isrunningtest()) { 
            	res = http.send(req);
            } else {
                res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"ESIHeader":{"applicationId":"CXODT"},"onlineContact":[{"contactNumber":"0006271252","address":{"firstName":"Test1","lastName":"User1"},"account":{"accountNumber":"1004631219","companyId":"WEST"},"sourceId":"SAP","endDate":"9999-12-31T00:00:00.000-06:00","entitlements":[{"applicationId":"COBALT","status":"INACTIVE","statusReason":"SAP","appUserGuid":"i0ace1966000001653b0a457c49cb4ae6","accessStartDate":"2018-08-14","accessEndDate":"2018-10-26","authenticationSystem":"ONE_PASS"},{"applicationId":"DATAROOM","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0ace19a8000001653b0a4746c5a1946c","accessStartDate":"2018-08-14","accessEndDate":"9999-12-31","authenticationSystem":"ONE_PASS"},{"applicationId":"SLW","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0acd9cd600000166afec05ae248c6d95","accessStartDate":"2018-10-26","accessEndDate":"9999-12-31","registered":true,"detailsIncomplete":false,"authFirstName":"TEST1","authLastName":"USER1","authEmail":"aug16.slf193@mailinator.com","authId":"4b831d3885e346ac849028c9e1c06aa4","logonName":"aug16.slf193@mailinator.com","appUserRefId":"2297100-YOMIM6","appUserRefIdPrimary":true,"appUserRefIdNickName":"test","lastPasswordChangeDate":"9998-12-31T23:59:59.9999999","authenticationSystem":"ONE_PASS"}],"onlineContactType":"0100","onlineContactTypeDescription":"Attorney","allowContactEmails":false},{"contactNumber":"0006305031","address":{"firstName":"Test2","lastName":"User2"},"account":{"accountNumber":"1004631219","companyId":"WEST"},"sourceId":"SAP","endDate":"9999-12-31T00:00:00.000-06:00","entitlements":[{"applicationId":"COBALT","status":"INACTIVE","statusReason":"SAP","appUserGuid":"i0ace1966000001653b0a45c349cb4ae8","accessStartDate":"2018-08-14","accessEndDate":"2018-10-26","authenticationSystem":"ONE_PASS"},{"applicationId":"DATAROOM","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0ace19a8000001653b0a474dc5a1946e","accessStartDate":"2018-08-14","accessEndDate":"9999-12-31","authenticationSystem":"ONE_PASS"},{"applicationId":"SLW","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0acd9cd600000166afec05b1248c6d97","accessStartDate":"2018-10-26","accessEndDate":"9999-12-31","registered":true,"detailsIncomplete":false,"authFirstName":"TEST2","authLastName":"USER2","authEmail":"aug16.slf194@mailinator.com","authId":"dd792e0e20af4053a6e2a4636e42a84f","logonName":"aug16.slf194@mailinator.com","appUserRefId":"2252565-UBHPA62297101-NNZKO9","appUserRefIdPrimary":true,"appUserRefIdNickName":"TEST2 test","lastPasswordChangeDate":"9998-12-31T23:59:59.9999999","authenticationSystem":"ONE_PASS"}],"onlineContactType":"0100","onlineContactTypeDescription":"Attorney","allowContactEmails":false},{"contactNumber":"0006305032","address":{"firstName":"Test3","lastName":"User3"},"account":{"accountNumber":"1004631219","companyId":"WEST"},"sourceId":"SAP","endDate":"9999-12-31T00:00:00.000-06:00","entitlements":[{"applicationId":"COBALT","status":"INACTIVE","statusReason":"SAP","appUserGuid":"i0ace1966000001653b0a45f449cb4aea","accessStartDate":"2018-08-14","accessEndDate":"2018-10-26","registered":true,"detailsIncomplete":false,"authFirstName":"TEST2","authLastName":"USER2","authEmail":"aug16.slf194@mailinator.com","authId":"dd792e0e20af4053a6e2a4636e42a84f","logonName":"aug16.slf194@mailinator.com","appUserRefId":"2252565-UBHPA62297101-NNZKO9","appUserRefIdPrimary":true,"appUserRefIdNickName":"TEST2 test","lastPasswordChangeDate":"9998-12-31T23:59:59.9999999","authenticationSystem":"ONE_PASS"},{"applicationId":"DATAROOM","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0ace19a8000001653b0a4756c5a19470","accessStartDate":"2018-08-14","accessEndDate":"9999-12-31","authenticationSystem":"ONE_PASS"},{"applicationId":"SLW","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0acd9cd600000166afec05b4248c6d99","accessStartDate":"2018-10-26","accessEndDate":"9999-12-31","registered":true,"detailsIncomplete":false,"authFirstName":"TEST3","authLastName":"USER3","authEmail":"aug16.slf195@mailinator.com","authId":"b5ea87267f814028842567635212043d","logonName":"aug16.slf195@mailinator.com","appUserRefId":"2252566-IHAJB22297102-GSKDE3","appUserRefIdPrimary":true,"appUserRefIdNickName":"TEST3 test","lastPasswordChangeDate":"9998-12-31T23:59:59.9999999","authenticationSystem":"ONE_PASS"}],"onlineContactType":"0100","onlineContactTypeDescription":"Attorney","allowContactEmails":false},{"contactNumber":"0006305033","address":{"firstName":"Test4","lastName":"User4"},"account":{"accountNumber":"1004631219","companyId":"WEST"},"sourceId":"SAP","endDate":"9999-12-31T00:00:00.000-06:00","entitlements":[{"applicationId":"COBALT","status":"INACTIVE","statusReason":"SAP","appUserGuid":"i0ace1966000001653b0a461c49cb4aec","accessStartDate":"2018-08-14","accessEndDate":"2018-10-26","registered":true,"detailsIncomplete":false,"authFirstName":"TEST3","authLastName":"USER3","authEmail":"aug16.slf195@mailinator.com","authId":"b5ea87267f814028842567635212043d","logonName":"aug16.slf195@mailinator.com","appUserRefId":"2252566-IHAJB22297102-GSKDE3","appUserRefIdPrimary":true,"appUserRefIdNickName":"TEST3 test","lastPasswordChangeDate":"9998-12-31T23:59:59.9999999","authenticationSystem":"ONE_PASS"},{"applicationId":"DATAROOM","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0ace19a8000001653b0a475ec5a19472","accessStartDate":"2018-08-14","accessEndDate":"9999-12-31","authenticationSystem":"ONE_PASS"},{"applicationId":"SLW","status":"ACTIVE","statusReason":"SAP","appUserGuid":"i0acd9cd600000166afec05b6248c6d9b","accessStartDate":"2018-10-26","accessEndDate":"9999-12-31","registered":true,"detailsIncomplete":false,"authFirstName":"TEST4","authLastName":"USER4","authEmail":"aug16.slf192@mailinator.com","authId":"d4f18132d6e54ba6bcbbb8dd98d7e39c","logonName":"aug16.slf192@mailinator.com","appUserRefId":"2297103-MMUAY4","appUserRefIdPrimary":true,"appUserRefIdNickName":"test","lastPasswordChangeDate":"9998-12-31T23:59:59.9999999","authenticationSystem":"ONE_PASS"}],"onlineContactType":"0100","onlineContactTypeDescription":"Attorney","allowContactEmails":false}]}');
                res.setStatusCode(200);
            }

            system.debug(LoggingLevel.INFO, 'Res...........' + res);
            system.debug(LoggingLevel.INFO, 'Res Body...........' + res.getBody());
        } catch (Exception e) { ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
            system.debug(LoggingLevel.INFO, 'Line number 261: ' + e);
            
        }
        return res;
    }
    

    public static Database.UpsertResult createOpportunity(Account acc, String firstName, String lastName, String email, String leadType, Source_System_Detail__c ssdRec, Id campaign, String hiveCode, String opptyId) {
        string optyRTName = Static_Values__c.getAll().get('GLIOpportunityRecordType').value__c;
        system.debug(LoggingLevel.INFO, 'Opportunity creation start');
        Opportunity opp = New Opportunity();
        if (opptyId == null) {
            opp.Name = acc.Name;
            opp.closeDate = [Select EndDate From Period Where type = 'Quarter'
                and StartDate = THIS_FISCAL_QUARTER
            ].EndDate;
            opp.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(optyRTName).getRecordTypeId();
            system.debug(LoggingLevel.INFO, 'Opportunity creation start 2');
            opp.StageName = 'Appointment Scheduled';
            opp.Probability = 10;
            opp.AccountId = acc.Id;
            opp.ForecastCategoryName = 'Omitted';
            opp.Source_System_Detail__c = ssdRec.Id;
            //opp.ContactPhone__c =acc.phone;
            opp.LeadSource = 'Rep Generated';
            opp.Source_Type__c = 'On Demand Trial';
            opp.Source__c = 'Rep Generated';
            opp.LCRM_Customer_Group__c = ssdRec.LCRM_Customer_Group__c;
            opp.LCRM_Status__c = 'Open';
            opp.Campaign_Cell__c = 'Free Trial';
            //opp.Lead_Type__c = leadType;  //'A'
            opp.First_Name__c = firstName;
            opp.Last_Name__c = lastName;
            opp.Email__c = email;
            opp.CampaignId = campaign;
            opp.Offer_Code__c = hiveCode;
        } else {
            system.debug(LoggingLevel.INFO, 'oppty selected');
            opp.Id = opptyId;
            opp.CampaignId = campaign;
            opp.Offer_Code__c = hiveCode;
        }
        Database.UpsertResult optyResult = Database.upsert(opp, false);
        system.debug(LoggingLevel.INFO, 'optyResult............' + optyResult);

        return optyResult;
    }
    

    //Creation of Opportunity Trial Juction Record
    public static Opportunity_Trial__c createOpportunityTrialJun(String selectedOppId, String trialId) {

        system.debug(LoggingLevel.INFO, 'Opportunity Trial Junction creation start Opp Id: ' + selectedOppId + ' Trial Id: ' + trialId);
        Opportunity_Trial__c oppTrialJun = New Opportunity_Trial__c();
        oppTrialJun.Opportunity__c = selectedOppId;
        oppTrialJun.Trial__c = trialId;
        return oppTrialJun;
    }

    //Creation of Trial record
    public static Database.UpsertResult createTrial(String trialId, String contactSAPID, Id accSSDId, String email, String sAPAccountNumber, Id productBundle, String productCategory, String trId, String lapsedCode, boolean isLapsed, String profileType, String profileID, String sAPpromotionCode, boolean isAccepted) {

        Integer trailexpiryduration;
        Date tD = date.today();
        String todaydate = DateTime.newInstance(tD.year(), tD.month(), tD.day()).format('YYYY-MM-dd');
        system.debug(LoggingLevel.INFO, 'Trial creation start');
        Trial__c newTrial = new Trial__c();
        newTrial.Trial_Id__c = trialId;
        newTrial.Source_System_Detail__c = accSSDId;
        //newTrial.Contact_LeadId__c = leadId;
        newTrial.Trial_Source__c = label.ODT_Trial_Source;
        newTrial.InvitedDateTime__c = System.today();
        newTrial.Contact_id_SAP__c = contactSAPID;
        newTrial.Trial_Status__c = 'Rep Initiated';
        newTrial.Trial_Journey__c = 'Rep Initiated Journey';
        //DLT-11455 Start : Trial reinitiate functionality
        newTrial.ODT_Email__c = email;
        newTrial.ODT_SAP_Account_Number__c = sAPAccountNumber;
        newTrial.ODT_Product_Bundle__c = productBundle;

        newTrial.ODT_Trial_Product_Category__c = productCategory;
        if (trId != null){ newTrial.id = trId; }
            
        //DLT-11455 end
        newTrial.Lapsed_Reason_Code__c = lapsedCode;
        newTrial.Is_Lapsed__c = isLapsed;
        newTrial.Profile_Type__c = profileType;
        newTrial.Profile_ID__c = profileID;
        newTrial.SAP_Promotion_Code__c = sAPpromotionCode;
        newTrial.Unique_Identifier__c = todaydate + '|' + newTrial.ODT_Email__c;
        SObjectType objectType = ODT_Product_Bundle__c.getSObjectType();
        Schema.DescribeSObjectResult objectDescription = objectType.getDescribe();

        ODT_Product_Bundle__c odd = [Select Name, Trial_Expiry_Days__c from ODT_Product_Bundle__c where Id =: productBundle WITH SECURITY_ENFORCED limit 1];
        newTrial.Trial_products__c = odd.Name; //DLT-19937
      	trailexpiryduration = Integer.valueof(odd.Trial_Expiry_Days__c);
        if (trailexpiryduration != null) {
            newTrial.ODT_Number_Of_Days_Trial_Extended__c = trailexpiryduration; // Added as part of DLT-19957
        }
        if (isAccepted) {
            newTrial.Trial_Start_Date__c = date.today();
            //  newTrial.Trial_End_Date__c=date.today()+7;     Commented as part of DLT-19237
            //DLT-19237 Starts Here
            if (trailexpiryduration != null) {
                newTrial.Trial_End_Date__c = date.today() + trailexpiryduration;
            }
            //DLT-19237 Ends Here
            newTrial.Trial_Initiated_Mode__c = 'Started Immediately';
        } else {
            newTrial.Trial_Initiated_Mode__c = 'Started by Marketing';
        }

        Database.UpsertResult trialResult = Database.upsert(newTrial, false);
        return trialResult;
    }
    

    //create Note record which contains request body
    public static Database.SaveResult createNote(String trialId, String reqBody) {
    	// DLT-20747 - remove IsPrivate setting from Note
    	
        system.debug(LoggingLevel.INFO, 'create noteResult');

        Note nt = new Note();

        nt.Title = 'Eloqua Post back request';
        String reqBodyStr = '';

        if (String.isNotBlank(reqBody)) {
            reqBodyStr = reqBody.left(30000);
        }
        nt.Body = reqBodyStr;
        nt.ParentId = trialId;
        //nt.IsPrivate = TRUE;

        Database.SaveResult noteResult = Database.insert(nt, false);
        system.debug(LoggingLevel.INFO, 'noteResult+++' + noteResult);
        return noteResult;
    }


    //DLT-12370 Starts: Added by Harshitha for capturing Primary User details on Trials as Invited Colleague
    public static database.UpsertResult createInvitedColleague(Id ssdAccountId, String email, String firstName, String lastName, String sapContactId, Id trialId, boolean isPrimaryUser, String incId) {
        Invite_Colleagues__c ic = new Invite_Colleagues__c();
        if (ssdAccountId != null) {
            ic.Source_System_Detail__c = ssdAccountId;
        }
        ic.Email__c = email;
        ic.First_Name__c = firstName;
        ic.Last_Name__c = lastName;
        ic.SapContactId__c = sapContactId;
        if (trialId != null){
            ic.Trial__c = trialId;
        }  
        ic.Primary_User__c = isPrimaryUser;
        ic.Trial_Status__c = 'Rep Initiated';
        ic.Trial_Request_Date__c = System.today();
        if (incId != null){
            ic.id = incId;
        }
        system.debug(LoggingLevel.INFO, 'before upsert' + ic);
        //Schema.SObjectField externalField=Invite_Colleagues__c.Email__c; /***** This is not required bcz we are not making this field as unique and externalId, based on ID only we will update the record  */
        Database.UpsertResult iNCResult = Database.upsert(ic, false);
        system.debug(LoggingLevel.INFO, 'id' + iNCResult.getErrors());
        return iNCResult;
    }
    //DLT-12370 Ends


    //Wrapper Classes for getOnlineContacts
    public class ESIHeaderCls {
        public string applicationId {
            get;
            set;
        }
        public ESIHeaderCls(string appId) {
            applicationId = appId;
        }
    }

    public class accountCls {
        public string accountNumber {
            get;
            set;
        }
        public accountCls(string accId) {
            accountNumber = accId;
        }
    }

    public class OnlineContactFiltercls {
        public string checkPrism {
            get;
            set;
        }
        public OnlineContactFilterCls() {
            checkPrism = 'false';
        }
    }

    public class callInviteCol {
        public ESIHeaderCls ESIHeader {
            get;
            set;
        }
        public accountCls account {
            get;
            set;
        }
        public string userGuidDomain {
            get;
            set;
        }
        public OnlineContactFilterCls OnlineContactFilter {
            get;
            set;
        }
        public callInviteCol(ESIHeaderCls esih, accountCls acch) {
            ESIHeader = esih;
            account = acch;
            OnlineContactFilter = new OnlineContactFilterCls();
            //userGuidDomain = 'COBALT';
        }
    }

    //START : DLT-12958 Wrapper class for ODT Lapsed Reason Code
    public class LapsedAccountDetails {
        public string reasonCode {
            get;
            set;
        }
        public string reasonDesc {
            get;
            set;
        }
        public boolean isLapsed {
            get;
            set;
        }
        public LapsedAccountDetails(string lapsedCode, string lapsedDesc, boolean checkLapsedStatus) {
            reasonCode = lapsedCode;
            reasonDesc = lapsedDesc;
            isLapsed = checkLapsedStatus;
        }
    }
    //END : DLT-12958 Wrapper class for ODT Lapsed Reason Code
}