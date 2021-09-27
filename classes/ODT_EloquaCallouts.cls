/*============================================================================================
    Name                : ODT_EloquaCallouts
    Description         : This class is developed as part of CXD-ODT project and it is a helper class for contactsListCon class
    Created Date        : 3/15/2018
    Author              : TCS CXD ODT team
  
  Enhancements:
      Date          Name                Jira        Description
    1)  01-05-2020    Rahul Natarajan    DLT-19818   ODT track Product Details is not dynamically sent from SFDC to Eloqua
    2)  12-11-2020    Brenda Shields     DLT-21106   Update parameter name from uniqueID to odtuniqueid via new label and fix PMD errors   
==============================================================================================*/


public without sharing class ODT_EloquaCallouts {

    string trialID;
    string addUserURL = '';
    string prodCategory;
    list<Invite_Colleagues__c> iCList;
    list<String> requestList;
    public boolean isCreated;
    public Trial__c trial{get;set;}
    public Opportunity_Trial__c opptrial{get;set;}
    
    
    public ODT_EloquaCallouts(String arg) {
        trialID = arg;
        requestList = new list<String>();
        system.debug(LoggingLevel.INFO, 'trial'+trialID);
        
        if (Schema.sObjectType.Trial__c.isQueryable() && Schema.sObjectType.Opportunity_Trial__c.isQueryable()) {
         
        	trial = [SELECT id, Trial_Status__c, Trial_End_Date__c,Trial_Start_Date__c ,ODT_Trial_Extend_Date__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Email__c, 
               		ODT_SAP_Account_Number__c, Contact_id_SAP__c,Is_Lapsed__c,  Contact_LeadId__c,  Contact_LeadId__r.Id, Contact_LeadId__r.Name, 
		            Source_System_Detail__r.Account_Name__c, GUID__c,Is_Lead_Converted__c ,Trial_Id__c, Trial_Source__c, No_Of_Times_Extended__c,Contact_LeadId__r.convertedOpportunityId,
        		    Contact_LeadId__r.convertedAccountId,Source_System_Detail__r.Account_Name__r.name, Contact_LeadId__r.Company, Profile_Type__c , Trial_Initiated_Mode__c, 
               		ODT_Product_Bundle__r.Bundle_ID__c, ODT_Product_Bundle__r.cellcode__c,Source_System_Detail__c,Source_System_Detail__r.Name, Source_System_Detail__r.LCRM_Phone__c, Source_System_Detail__r.Country__c, Source_System_Detail__r.Postal_Code__c, ODT_Product_Bundle__r.Business_Type__c,ODT_Product_Bundle__r.Trial_Expiry_Days__c, Unique_Identifier__c,
               		(SELECT ID, Email__c, First_Name__c, Last_Name__c, Trial__r.trial_source__c, Trial__r.ODT_SAP_Account_Number__c, Trial__r.Contact_id_SAP__c, Trial__r.Global_Trial_ID__c, Trial__r.ODT_Email__c, Trial__r.Trial_Start_Date__c, Trial__r.Trial_End_Date__c, Trial__r.ODT_Trial_Product_Category__c, SapContactId__c, Trial__c, User_Auth_ID__c, Trial__r.Is_Lapsed__c, Unique_Identifier__c  
               		FROM Invite_Colleagues__r WHERE Trial_Status__c='Rep Initiated') 
               		from Trial__c WHERE id =: trialID WITH SECURITY_ENFORCED];
        	if (trial.Trial_Source__c == 'SFDC') {
            	opptrial = [SELECT id, Opportunity__c, Trial__c from Opportunity_Trial__c WHERE Trial__c=:trial.Id LIMIT 1];
        	}   
        }
    }
    
    
    public void eloquaCall() {
        system.debug(LoggingLevel.INFO, 'execute callout'); 
        
        // get Product Category
        //string prodCategory;
        prodCategory = getProductCategory(trial);

        WebServiceSettings__c oWebServiceSettings2;    
        HttpRequest req = new HttpRequest();    
        
        system.debug(LoggingLevel.INFO, 'tessstt: ' + trial.Source_System_Detail__r.Account_Name__c);
        //Account newAcc = new Account();
        //newAcc=[SELECT ID, Name, SAPAccountNumber__c, Trial_Status__c, FrozenMarketSegment__c FROM Account WHERE id=: trial.Source_System_Detail__r.Account_Name__c];
        
        string trialSource = trial.Trial_Source__c;
        //String addUserURL = '';
        boolean isPrimary = false;
        boolean isInvitedColl = false;
        //boolean isAdduser = true;
        String uRLType = Label.ODT_Rep_Initiated_URL;
        String rawURL;
        string trialstatus = 'Invite';
        
        if (trialSource == 'SFDC') { 
            oWebServiceSettings2 = AppUtil.getWebServiceSettings('ODTEloquaServiceSFDCSource');
        } else {
         	oWebServiceSettings2 = AppUtil.getWebServiceSettings('ODTEloquaServiceOtherSources');
        }
           
        //if(URLType.containsIgnoreCase('V1') ){
            /*  //preparing the URL for Eloqua 
        string rawURL ='emailAddress='+this.email+'&firstName='+this.Fname+'&lastName='+this.lname+'&accountNumber='+this.sapAId+'&contactID='+this.sapCId+'&trialStatus='+trialstatus +'&country=US&sfdcAccountId='+ this.sfdcAId+'&SFDCContactID='+this.sfdcCId+'&SAPAccountNumber='+this.sapAId+'&SAPContactID='+this.sapCId+'&guid='+this.appGUId+'&TrialSource=SFDC'+'&trialId='+this.sDomain+'&companyName='+newAcc.Name+'&opportunityID='+this.oppId+'&trialrecordId='+this.TId+'&opportunityID='+this.oppId+'&retURL='; 
        
        //preparing the encrypted URL for AEM 
        string rawURLToencrypt = 'email='+this.email+'&firstName='+this.Fname+'&lastName='+this.lname+'&accountNumber='+this.sapAId+'&contactId='+this.sapCId+'&trialStatus='+trialstatus +'&country=US&sfdcAccountId='+ this.sfdcAId+'&SFDCContactID='+this.sfdcCId+'&SAPAccountNumber='+this.sapAId+'&SAPContactID='+this.sapCId+'&cobaltGuid='+this.appGUId+'&trialSource=SFDC'+'&trialId='+this.sDomain+'&trialCategory='+prodCategory+'&businessType='+newAcc.FrozenMarketSegment__c+'&opportunityID='+this.oppId+'&retURL='; 
        
        if(rawURLToencrypt.contains(' '))
        rawURLToencrypt = rawURLToencrypt.replaceAll(' ','');
        
        if(rawURL.contains(' '))
        rawURL = rawURL.replaceAll(' ','_');
        
        system.debug('rawURLToencrypt .......'+rawURLToencrypt);
        system.debug('rawURL .......'+rawURL);
        
        Blob onDemandTrialBlob = blob.valueof('ondemandtrialpro');
        string onDemandTrialString = EncodingUtil.base64Encode(onDemandTrialBlob);
        Blob cryptoKey = EncodingUtil.base64Decode(onDemandTrialString);
        Blob data = Blob.valueOf(rawURLToencrypt);
        Blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String encryptedURL = EncodingUtil.base64Encode(encryptedData);
        
        String encodedURL = EncodingUtil.urlEncode(encryptedURL, 'UTF-8');
        
        system.debug('encrypted URL.......'+encryptedData);
        system.debug('encrypted URL.......'+encryptedURL);
        system.debug('encoded URL.......'+encodedURL);
        
        system.debug('encrypted URL.......'+encryptedURL);
        
        req.setEndpoint(oWebServiceSettings2.Endpoint__c+'&encryptedURL='+encodedURL+'&trialcategory='+prodCategory+'&'+rawURL);
        */ 
        //}
        //else 
        if (URLType.containsIgnoreCase('V2')) {
         //  addUserURL ='&TrialStartDate='+ string.valueOf(trial.Trial_Start_Date__c)+'&TrialEndDate='+ string.valueOf(trial.Trial_End_Date__c)+'&emailResendP='+isPrimary+'&emailResendC='+isInvitedColl+'&isLapsed='+trial.Is_Lapsed__c+'&addUser='+isAdduser;
         //string encryptedURL;
            // set addUserURL - trial start/end date
            addUserURL += setTrialStartEndDt(isPrimary, isInvitedColl, trial);

            for (Invite_Colleagues__c ic : trial.Invite_Colleagues__r) {
            	
            	// build the raw URL Parameter list
            	rawURL = buildRawURL(ic, trial);
      			system.debug(LoggingLevel.INFO, 'Final rawURL ODT_EloquaCallouts ......... ' + rawURL); 
      			 
                req.setEndpoint(oWebServiceSettings2.Endpoint__c+'&'+rawURL );
                req.setMethod('GET');
                requestList.add(String.valueOf(req));
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                //req.setEndpoint(oWebServiceSettings2.Endpoint__c+'&encryptedURL='+encryptedURL+'&trialcategory='+prodCategory+'&'+rawURL);
                req.setTimeout(120000)  ;
                
                Http http = new Http();
                HTTPResponse res;
                if (!test.isrunningtest()) {  
                	res = http.send(req);   
                } else {
                    // Code for test classes
                    res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
                    res.setBody('Success');
                    res.setStatusCode(200); 
                }
                system.debug(LoggingLevel.INFO, 'req--->'+req);
                system.debug(LoggingLevel.INFO, 'BODY--->'+res.getBody());
                system.debug(LoggingLevel.INFO, 'STATUS--->'+res.getStatus());
                system.debug(LoggingLevel.INFO, 'STATUS_CODE--->'+res.getStatusCode());
            }  // end ofr IC
        }
        system.debug(LoggingLevel.INFO, 'requestList-->'+requestList);
    }
    
    
    public void createNotes(){
        if(requestList.size()!=0){
            for(String r : requestList){
                CallToOLCTofetchActiveTr.createNote(trial.id, String.valueOf(r));
            }
        }
    }


	// build the URL parameter string
	private string buildRawURL(Invite_Colleagues__c ic, Trial__c trial) {
		string strRawURL = '';
		            	
            	// build URL Values
            	strRawURL = setURLInitialValues(prodCategory, ic, trial);
                // set Profile Type and additional parameters
                strRawURL += setAdditionalParms(trial);

                if (addUserURL != '') {
                    strRawURL += addUserURL;
                }
                // set company name and Profile Type information
                strRawURL += setSSDCompany(ic, trial);
                // set email parameters
                strRawURL += setICEmail(ic, trial);
                // set encryptedURL
                strRawURL += setEncryptedURL(ic);

              	//  string pt = returnCustomerType(trial.Profile_Type__c);
                
                // finish setting url
                strRawURL += finalizeURL(ic, trial);
               	// rawURL += '&organizationType='+trial.ODT_Product_Bundle__r.Business_Type__c+'&customerType='+trial.Profile_Type__c+'&uniqueID='+trial.Unique_Identifier__c;
               	if (strRawURL.contains(' ')) {
                    strRawURL = strRawURL.replaceAll(' ','_');
                }
		
		return strRawURL;
	}   
    
    
    // get Product Category
    private string getProductCategory(Trial__c trial) {
        string strProdCategory;
        list<ODT_Product_Bundle__c> listPrdBundle;
        
        if (Schema.sObjectType.ODT_Product_Bundle__c.isQueryable()) {
        	listPrdBundle = [SELECT ID, Name, Bundle_ID__c, Bundle_Type__c, Company_Code__c, Product_Category__c 
        				from ODT_Product_Bundle__c WHERE Is_Enabled_For_Sales_Rep_Trial__c = TRUE 
        				AND Is_Active__c = TRUE AND Bundle_Type__c = 'CTX' ORDER BY Bundle_Order__c ASC ];
        }
        if (!listPrdBundle.isEmpty()) {
            for (ODT_Product_Bundle__c odtprods : listPrdBundle) {
                if (trial.Trial_Id__c == odtprods.Bundle_ID__c) {
            		strProdCategory = odtprods.Product_Category__c;
        		}
            } 
        }
        return strProdCategory;
    }
    
    
    // build URL Values
    private string setURLInitialValues(string prodCategory, Invite_Colleagues__c ic, Trial__c trial) {
    	string strRawURL = '';
    	String tStatus;
    	            
        if (trial.Profile_Type__c == 'NET_NEW') {
            tStatus = 'Invite';  
            //isAdduser = false;
        } else {
          	tStatus = 'Accepted'; 
            //isAdduser = true;
        }
            
        strRawURL = 'emailAddress=' + ic.Email__c + '&trialrecordId=' + trial.Id + '&trialStatus=' + tStatus +
        	'&TrialSource=' + trial.Trial_Source__c +'&trialcategory=' + prodCategory + 
        	'&firstName=' + ic.First_Name__c + '&lastName=' + ic.Last_Name__c;
        strRawURL += '&InviteeSFDCID=' + ic.id + '&retURL=';
        if (trial.Trial_Initiated_Mode__c == 'Started Immediately') {
            strRawURL += '&repType=Started';
        } else {
            strRawURL +='&repType=Initiated';
        }
        return strRawURL;
	}
      
               
	private string setSSDCompany(Invite_Colleagues__c ic, Trial__c trial) {
     	string strRawURL = '';
     	string encryptedURL;

        if (ic.trial__r.trial_source__c == 'SFDC') {
           if ((trial.Source_System_Detail__r.Account_Name__r.name != null) && (trial.Source_System_Detail__r.Account_Name__r.name != '')) {
            	strRawURL +='&companyName='+trial.Source_System_Detail__r.Account_Name__r.name;
            } 
        } else {
            if ((trial.Contact_LeadId__r.Company != null) && (trial.Contact_LeadId__r.Company != '')) {
            	strRawURL +='&companyName='+trial.Contact_LeadId__r.Company;  
            }
        }
		if (trial.Source_System_Detail__c != null) {
            if ((trial.Source_System_Detail__r.Name != null) && (trial.Source_System_Detail__r.Name != '')) {  
            	strRawURL += '&companyName='+trial.Source_System_Detail__r.Name;  
            }
            if ((trial.Source_System_Detail__r.LCRM_Phone__c != null) && (trial.Source_System_Detail__r.LCRM_Phone__c != '')) {  
            	strRawURL += '&Phone='+trial.Source_System_Detail__r.LCRM_Phone__c;    
            }
            if ((trial.Source_System_Detail__r.Country__c != null) && (trial.Source_System_Detail__r.Country__c != '')) {  
            	strRawURL += '&country='+trial.Source_System_Detail__r.Country__c;  
            }
            if ((trial.Source_System_Detail__r.Postal_Code__c != null) && (trial.Source_System_Detail__r.Postal_Code__c != '')) {  
              	strRawURL += '&zipcode='+trial.Source_System_Detail__r.Postal_Code__c;  
            }
        }
		return strRawURL;     
	}
	
	
	// set user email requests
	private string setICEmail(Invite_Colleagues__c ic, Trial__c trial) {
     	string strRawURL = '';

        if (trial.Trial_Initiated_Mode__c == 'Started Immediately' && trial.ODT_Email__c == ic.Email__c ) {
   			strRawURL += '&addUser=false&isPrimaryRequester=true';
   		}
        if (trial.ODT_Email__c != ic.Email__c) {
          	strRawURL += '&addUser=true&isPrimaryRequester=false';   
        }
		return strRawURL;     
	}
	
	
	private string setEncryptedURL(Invite_Colleagues__c ic) {
     	string strRawURL = '';
     	string encryptedURL;
        
        if(trial.Profile_Type__c == 'NET_NEW') {
           	encryptedURL = ODT_AddNetnewInvitedcolleagueCallout.sendEloquaRequestToINC(ic);
           	if (encryptedURL != null && encryptedURL != '') {
           		strRawURL += '&encryptedURL='+encryptedURL; 
           	}
        }
		return strRawURL;     
	}	
	
	
	// set addUserURL - trial start/end date - email values
    public string setTrialStartEndDt(boolean isPrimary, boolean isInvitedColl, Trial__c trial) {
    	string strRawURL = '';
		string tRStartdateEnddate = '';
		
        if (trial.Trial_Start_Date__c != null) {
           tRStartdateEnddate  = '&TrialStartDate=' + string.valueOf(trial.Trial_Start_Date__c);
        }   
        if (trial.Trial_End_Date__c != null) {
            tRStartdateEnddate  += '&TrialEndDate=' + string.valueOf(trial.Trial_End_Date__c);
        }
              
        if (tRStartdateEnddate != '') {
            strRawURL += tRStartdateEnddate;
        }
        strRawURL += '&emailResendP='+isPrimary+'&emailResendC='+isInvitedColl+'&isLapsed='+trial.Is_Lapsed__c;
        
    	return strRawURL; 
	}
	
	
	// set additional parameters from the trial
    public string setAdditionalParms(Trial__c trial) {
    	string strRawURL = '';	
       	string strProfileType;
       	
        if (trial.Profile_Type__c == 'NET_NEW') {
       		strProfileType = '&olc';
	    } else {
           	strProfileType = '&sap';
        }
       	if ((trial.ODT_SAP_Account_Number__c != null) && (trial.ODT_SAP_Account_Number__c != '')) { 
	       	strRawURL += strProfileType + 'AccountId=' + trial.ODT_SAP_Account_Number__c;
        }
        if ((trial.Contact_id_SAP__c != null) && (trial.Contact_id_SAP__c != '')) {
       	   	strRawURL += strProfileType + 'ContactId=' + trial.Contact_id_SAP__c;
       	}    
				
        if (String.IsNotBlank(trial.Source_System_Detail__c)) {
            strRawURL +='&accountSSD='+trial.Source_System_Detail__c;
        }
                
       	//  DLT-19818  Starts
  		if (trial.ODT_Product_Bundle__r.Trial_Expiry_Days__c != null) {
   			strRawURL +='&trialLength='+trial.ODT_Product_Bundle__r.Trial_Expiry_Days__c;
   		}
   		if (trial.ODT_Product_Bundle__r.Bundle_ID__c != null) {
   			strRawURL +='&trialId='+trial.ODT_Product_Bundle__r.Bundle_ID__c;
   		}
   		if (trial.ODT_Product_Bundle__r.cellcode__c != null) {
   			strRawURL +='&cellCode='+trial.ODT_Product_Bundle__r.cellcode__c; 
   		}
   		//  DLT-19818 Ends
     	
	    return strRawURL; 
	}
				

    // finish setting url
    public string finalizeURL(Invite_Colleagues__c ic, Trial__c trial) {
    	string strRawURL = '';	
				
		if ((trial.ODT_Product_Bundle__r.Business_Type__c != null) && (trial.ODT_Product_Bundle__r.Business_Type__c != '')) {
        	strRawURL += '&organizationType='+trial.ODT_Product_Bundle__r.Business_Type__c;
        }
        strRawURL +='&customerType='+trial.Profile_Type__c;
               			
        // DLT-21106 - parm name has changed - use label to get parameter text ODT_Unique_ID_Parameter
        if ((ic.Unique_Identifier__c != null) && (ic.Unique_Identifier__c != '')) {
          	strRawURL += Label.ODT_Unique_ID_Parameter + ic.Unique_Identifier__c;
        }
		return strRawURL;
    }
     
                    
  /*  public static string returnCustomerType(String ProfileType){
        if(ProfileType.equalsIgnoreCase('NET_NEW')){
            return 'New';
        }
        else if(ProfileType.equalsIgnoreCase('EXISTING_USER_SAME_DOMAIN') || ProfileType.equalsIgnoreCase('EXISTING_USER_NEW_DOMAIN')){
            return 'Existing';  
        }
        return null;
    } */
}