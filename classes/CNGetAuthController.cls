public with sharing class CNGetAuthController {
	public string code{get;set;}	
	public string token{get;set;}
	public string referrer{get;set;}
	public integer expires{get;set;}
	public string state{get;set;}
	
	public CNGetAuthController(){
		System.debug('****called into cngetauth');
		code = ApexPages.currentPage().getParameters().get('code');		
		System.debug('****code=' + code);
		state = ApexPages.currentPage().getParameters().get('state');//we pass the original Account-Lead-Contact-Opp id in this parameter		
		System.debug('****state=' + state);
		if(code!=null){
			requestToken();	
		}   
		if(token!=null){
			returnToPage();	
		}                   
	}
	public void requestToken(){		 
		CN_App_Settings__c  csett = [SELECT APP_OAUTH_CLIENTID__c,APP_OAUTH_SECRET__c,
			                             APP_OAUTH_TOKEN__c,OAuth_Expiration_Time__c,
			                             OAUTH_GRANTTYPE__c,OAUTH_URL__c FROM CN_App_Settings__c 
			                             limit 1];
		Http oHttp = new Http();
		HttpRequest oReq = new HttpRequest();	                             
        HttpResponse oRes = new HttpResponse();	
        oReq.setTimeout(60000); 
        oReq.setEndpoint(csett.OAUTH_URL__c  + '/identity/connect/token'); 
        oReq.setMethod('POST');	
		Blob headerValue = Blob.valueOf( csett.APP_OAUTH_CLIENTID__c + ':' + csett.APP_OAUTH_SECRET__c); 
 		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);  
 		system.debug('authorizationHeader header=' + authorizationHeader);
 		oReq.setHeader('Authorization', authorizationHeader);
 		 
        string sBody = 'grant_type=authorization_code';         
        sBody += '&code=' + code;  
        sBody += '&redirect_uri=' + EncodingUtil.urlEncode(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CNGetAuth','UTF-8');
        system.debug('body=' + sBody);
        oReq.setBody(sBody);
        try {
        	oRes = oHttp.send(oReq);
	    } catch(System.CalloutException e) {
	        System.debug('Callout error: '+ e);
	        System.debug('res=' + oRes.toString());
	    }        
        System.debug('****result of call  ' + oRes);
        System.debug('****BODY: '+oRes.getBody());
        string json = oRes.getBody();
        token=json;
        if(json !='' && json.contains('<')==false){
	        CNOAuthToken oat = CNOAuthToken.parse(json);
	        token = oat.access_token;
	        expires = oat.expires_in;
	        referrer = ApexPages.currentPage().getHeaders().get('Referer');
	        string type = oat.token_type;
	    	System.debug('****STATUS:'+oRes.getStatus()); 
	    	System.debug('****STATUS_CODE:'+oRes.getStatusCode());		    	
			CNAppUtils_14.AUTHTOKEN = token;
 			CNAppUtils_14.tokenExpires = expires; 				 			
        }	                
	} 		
	public PageReference returnToPage(){
		//where to go?
		System.debug('called into returnToPage()');
		string[] whereToGo = state.split('-');
		System.debug('whereToGo= ' + whereToGo[0]);
		PageReference pageRef;		
		//if(whereToGo[0].contains('cnCorporateInsightPage')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/' + whereToGo[0]); 
		//}
		/*if(whereToGo[0].contains('cnCorporateInsight_Lead')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cnCorporateInsight_Lead'); 
		}
		if(whereToGo[0].contains('cnCorporateInsight_Opportunity')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cnCorporateInsight_Opportunity'); 
		}
		if(whereToGo[0].contains('cnAccountRelationshipView')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cnAccountRelationshipView'); 
		}
		if(whereToGo[0].contains('cnContactRelationshipView')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cnContactRelationshipView'); 
		}
		if(whereToGo[0].contains('cnLeadView')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cnLeadView'); 
		}
		if(whereToGo[0].contains('cnOpportunityView')){
		 	pageRef = new PageReference(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cnOpportunityView'); 
		}*/
		// if token is null we should raise error and stop as likely the call to /token failed		
		if(token == null){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Failed to Connect to OAuth Server'));
		    pageRef.getParameters().put('error','Failed to Connect to OAuth Server');
		} 
		pageRef.getParameters().put('id',whereToGo[1]);
		System.debug('id= ' + whereToGo[1]);
		pageRef.getParameters().put('token',token);
		System.debug('token= ' + token);
		pageRef.getParameters().put('expires',string.valueOf(expires));
		pageRef.setRedirect(true); 
		System.debug('pageRef=' + pageRef);		
		return pageRef; 
	}
}