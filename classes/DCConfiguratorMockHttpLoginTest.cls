global class DCConfiguratorMockHttpLoginTest implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {     
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        res.setHeader('SOAPAction', 'login');
        res.setBody('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://cs65.salesforce.com/services/Soap/m/40.0/00D0m0000000NsO</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>true</sandbox><serverUrl>https://cs65.salesforce.com/services/Soap/u/40.0/00D0m0000000NsO</serverUrl><sessionId>SESSION_ID_REMOVED</sessionId><userId>0050m000000IbIKAA0</userId><userInfo><accessibilityMode>false</accessibilityMode><chatterExternal>false</chatterExternal><currencySymbol xsi:nil="true"/><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode xsi:nil="true"/><orgDefaultCurrencyLocale xsi:nil="true"/><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00D0m0000000NsOEAU</organizationId><organizationMultiCurrency>true</organizationMultiCurrency><organizationName>TRP Core Legal</organizationName><profileId>00e30000001gFezAAE</profileId><roleId>00E13000002ICC4EAO</roleId><sessionSecondsValid>14400</sessionSecondsValid><userDefaultCurrencyIsoCode>USD</userDefaultCurrencyIsoCode><userEmail>ramesh.munagala@forsysinc.com</userEmail><userFullName>Aravind Maara</userFullName><userId>0050m000000IbIKAA0</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>aravind.maara@forsysinc.com</userName><userTimeZone>America/Los_Angeles</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>');
    
        res.setStatusCode(200);
        
        return res;            
    
    
    }                
}