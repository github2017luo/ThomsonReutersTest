/**
* {Purpose} -  
*     Visualforce controller to fetch BDP Corporate Insight widget via API
*
* @author  Glen Cunningham
* @version  2015-10-14
*/ 
  
/** 
* CHANGE HISTORY
* =============================================================================
* Date      Name              Description
* 2015-10-14  Glen Cunningham        Created
* 2015-11-11  Glen Cunningham		added error handling to display page 
*									messages in case of login failure etc.
*
* =============================================================================
*/  
public with sharing class CNCorporateInsight {
	public string sCompanyCNID{get;set;}
	public string endPoint{get;set;}
	public string msg{get;set;}	 
	public string token{get;set;}	
	private ApexPages.StandardController localcontroller{get;set;}
	public string id{get;set;}
	public string sHREF{get;set;}
	public static string code{get;set;}
	public string returnURL{get;set;}
	public Boolean showOAuth{get;set;}
	 
	public CNCorporateInsight(ApexPages.StandardController controller)
	{
		string err =  ApexPages.currentPage().getParameters().get('error');
	  	if(err == null){
			msg='';
			localcontroller = controller;
			id=ApexPages.currentPage().getParameters().get('id');
			token = ApexPages.currentPage().getParameters().get('token');
			if(token!=null){
				CNAppUtils_14.AUTHTOKEN = token;
			}
			string e = ApexPages.currentPage().getParameters().get('expires');
			integer expires = (e!=null)?integer.valueOf(e):0;
			System.debug('constructor CNCorporateInsight starts');	
			String pageName = ApexPages.CurrentPage().getUrl(); 
			pageName = pageName.replaceFirst('/apex/','');
			pageName = EncodingUtil.urlEncode(pageName, 'UTF-8'); 
			string[] pageNameExtra = pageName.split('%3F',0);
			pageName = pageNameExtra[0];
			//get token 	
			User u = [SELECT BDP_OAuth_Expires_At__c,BDP_OAuth_Token__c FROM User where id=:UserInfo.getUserId()];
			if(u.BDP_OAuth_Token__c != null){	
				CNAppUtils_14.AUTHTOKEN = u.BDP_OAuth_Token__c;
				System.debug('called loadpagedata');
				loadPageData();			
			}else{		 
				if(CNAppUtils_14.AUTHTOKEN != null){
					system.debug('called with existing AUTHTOKEN');
					loadPageData();
				}else{
                    CN_App_Settings__c  csett = [SELECT OAUTH_URL__c,APP_OAUTH_CLIENTID__c FROM CN_App_Settings__c order by createddate desc limit 1];
                    sHREF = csett.OAUTH_URL__c +'/identity/connect/authorize?client_id=' + csett.APP_OAUTH_CLIENTID__c + '&redirect_uri=';
					sHREF += EncodingUtil.urlEncode(system.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CNGetAuth','UTF-8');
					sHREF += '&scope=cnapi&response_type=code&state=' + pageName + '-' + id;
					System.debug('sHREF=' + sHREF);
					doAuthorize(sHREF);				
				}
			}
	  	}else{
	  		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,err));
	  		system.debug('returned error in call to oauth');
	  	}
	}
	public PageReference doAuthorize(string url){
		PageReference pageRef = new PageReference(url); 
		pageRef.setRedirect(true); 
		system.debug('url for redirect=' + url);
		return pageRef; 
	}
	public void loadPageData(){
		
		 system.debug('entered loadPageData');
		//check if we are responding to requests or are shutdown for maintenance
		CN_App_Settings__c csett = [SELECT WS_Endpoint__c,WS_Is_Active__c,WS_Timeout__c,WS_Unavailable_Message__c FROM CN_App_Settings__c];
		if(csett.WS_Is_Active__c){
			Account oAcct;
			string sId = ApexPages.currentPage().getParameters().get('id');
			//think we will need to brute force the object type by the id value
			List<Account> a1 = [select id from Account where id=:sId];
			List<Lead> l1 = [select id from Lead where id=:sId];
			List<Opportunity> o1 = [select id from Opportunity where id=:sId];
			String sEmailDomain;
			//use describe to determine which page we are loading
			if(a1.size()>0){    
				sEmailDomain = CNAppUtils.getTopDomain([SELECT Email FROM Contact WHERE Email != NULL AND AccountId =: sId LIMIT 10000]);
			}
			if(l1.size()>0){ 
				//get company name to lookup possible account match
				Lead ld = [Select Company from Lead where id =: sId]; //since this is not a requird field it will may be null   
				//and now account
				Account ac;
				List<Account> acl = [Select Id from Account where name =: ld.Company];
				if(acl.size()>0){
					ac = acl[0];
				}else{
					msg = 'No Data Available (105)';
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
					return;
				}
				sEmailDomain = CNAppUtils.getTopDomain([SELECT Email FROM Contact WHERE Email != NULL AND AccountId =: ac.Id LIMIT 10000]);
			}
			if(o1.size()>0){ 
				//get company name to lookup possible account match
				Opportunity oOp = [select id,name,AccountId from Opportunity where Id=: sId];
				sEmailDomain = CNAppUtils.getTopDomain([SELECT Email FROM Contact WHERE Email != NULL AND AccountId =: oOp.AccountId LIMIT 10000]);
			}

			if(CNServices_14.CNCompanyID==null){
				try{
					 
					CNServices_14.fetchCompany(sEmailDomain);
					if(CNServices_14.CNCompanyID==null){
						msg = 'No Data Available (103)';
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
					}
					if(CNServices_14.currCompany.IsOa==false){
						msg = 'No Data Available (104)';
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
					}
				}catch(Exception e){
					msg = 'No Data Available (105)';
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
				}				
			}
			if(CNServices_14.currCompany != null){	        	
				if(CNServices_14.currCompany.IsOa==false){
					msg = 'No Data Available (104)';
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
				}
			}	
			if(msg==''){	      
				sCompanyCNID = CNServices_14.CNCompanyID;
				//add isOa company check
				if(sCompanyCNID!=''){
					endPoint = csett.WS_Endpoint__c; 	
				} else{
					msg = 'No Data Available (105)';
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));     
				} 
			}
		}else{
			msg = csett.WS_Unavailable_Message__c;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
		} 
		sHREF = endPoint + '/oacompany/' + sCompanyCNID;
		system.debug('sHREF=' + sHREF);		
	}	
}