/* Class: Digital_Create_Email_TemplateController
 * Purpose: This class sends personalized mails to reps on click of button on opportunity.
 * Created: 4-Feb-2021
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2021-02-04   Ameeta Antonio          DLT-21406 - [SFDC][REN][SL,CORP,GOVT,ML] Personalized Rep Email
 * 2021-02-25   Brenda Shields			DLT-21454 - [SFDC][SLF, CORP, GOVT, MLF][REN] Send Rep Renewal Email data to Eloqua
 * 2021-03-30   Brenda Shields          DLT-21576 - Fix Prod issue.  In the Eloqua URL, send the Account SSD ID, not the Account ID
 * ==================================================================================================================================   
 */
/** 
 * @description : Class created to send email to reps
*/ 
public with sharing class Digital_Create_Email_TemplateController {

    Id opportunityId;
    List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
 
/** 
* @description : errorFlag
* @return : boolean
*/
    public boolean errorFlag {get;set;}
/** 
* @description : inputMsg
* @return : String
*/
    public String inputMsg {get;set;}

/** 
* @description : constructor for Digital_Create_Email_TemplateController class
*/
    public Digital_Create_Email_TemplateController(){
        opportunityId = ApexPages.currentPage().getParameters().get('id');
        
        // get a list of all the presented proposals for which mail needs to be sent
        if(opportunityId != null){
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
               proposalList = [SELECT Id, Apttus_Proposal__Approval_Stage__c, Apttus_Proposal__Account__c, 
                Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.Contract_Type__c, 
				Apttus_Proposal__Opportunity__r.Key_Contact__r.FirstName, Apttus_Proposal__Opportunity__r.Key_Contact__r.LastName,
				Apttus_Proposal__Opportunity__r.Key_Contact__r.Email, Apttus_Proposal__Opportunity__r.ownerid,  
				Apttus_Proposal__Opportunity__r.owner.FirstName, Apttus_Proposal__Opportunity__r.owner.LastName,
				Apttus_Proposal__Opportunity__r.owner.Title, Apttus_Proposal__Opportunity__r.owner.Phone, 
				Apttus_Proposal__Opportunity__r.owner.Email, Apttus_Proposal__Opportunity__r.Renewal_Date__c,
				Apttus_Proposal__Opportunity__r.Source_System_Detail__c,
				Apttus_Proposal__Opportunity__r.Source_System_Detail__r.BU_Segment_Level_2__c
				from Apttus_Proposal__Proposal__c 
                where Apttus_Proposal__Opportunity__c =: opportunityId AND is_Digital_Channel__c = TRUE AND 
                Apttus_Proposal__Approval_Stage__c = 'Presented' AND Digital_Quote_Type__c = 'Manual'];  
            }
            
        }
        System.debug(LoggingLevel.INFO,'ProposalList'+proposalList );
        
        errorFlag = false;
        
        //set Error message if no proposals present as per conditions.
        checkValidProposal();
    }
    
    private void checkValidProposal(){
        if(proposalList.isEmpty()) {
           errorFlag = true; 
        }
        
    }
    
/** 
* @description : sendEmail method tosend emails to reps
* @return : PageReference
*/    
    public PageReference sendEmail() {
    	string strDetailURL;
    	
        if (String.isBlank(inputMsg)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter inpust message'));
            return null;
        }
        
        if (!proposalList.isEmpty()) {
        	// build URL
      		strDetailURL = '';
      		
      		// remove spaces from the message text as it will break the URL
      		// SFDC will use + as space, this seems to work correctly for URL as well as text in the email
      		inputMsg = inputMsg.replaceAll(' ','+'); 
      		// carriage return and line feed break th URL as well.  Set with spaces
      		inputMsg = inputMsg.replace('\r\n', '++');
      		inputMsg = inputMsg.replace('\n', '++');
			inputMsg = inputMsg.replace('\r', '++');
      		
      		// format the date to remove time
      		string strRenewalDate = proposalList[0].Apttus_Proposal__Opportunity__r.Renewal_Date__c.format();
      		
     		// Add Quote and Opportunity details
     		// check for what kind of offer this is and set value to "Rep NTO" or "Rep Renewal"
     		if (proposalList[0].Apttus_Proposal__Opportunity__r.Contract_Type__c == 'NTO') {
     			strDetailURL += '&offerType=' + 'Rep NTO';
        	} else {
        		strDetailURL += '&offerType=' + 'Rep Renewal';
        	}
			// set Contact Information
			strDetailURL += setContactInformation(proposalList[0]);     		

     		strDetailURL += '&comments=' + inputMsg;
     		strDetailURL += '&renewaldate=' + strRenewalDate;
     		strDetailURL += '&segment=' + proposalList[0].Apttus_Proposal__Opportunity__r.Source_System_Detail__r.BU_Segment_Level_2__c;
     		// make sure ids are only 15 characters, not 18
     		//strDetailURL += '&proposalAccountId=' + String.valueOf(proposalList[0].Apttus_Proposal__Account__c).left(15);
     		// this needs to be the Account SSD ID, not the Account ID
     		strDetailURL += '&proposalAccountId=' + String.valueOf(proposalList[0].Apttus_Proposal__Opportunity__r.Source_System_Detail__c).left(15);
     		strDetailURL += '&opportunityId=' + String.valueOf(proposalList[0].Apttus_Proposal__Opportunity__c).left(15);
			// set Rep Information
			strDetailURL += setRepInformation(proposalList[0]);

            //We shouldn't pass in "null" as a value, we can just remove them
            if (strDetailURL.contains(' ')) {
            	strDetailURL = strDetailURL.replaceAll('null','');  
            }
            //The URL has issues with it contains any blanks
            if (strDetailURL.contains(' ')) {
            	strDetailURL = strDetailURL.replaceAll(' ','+');  
            }
            
            system.debug(LoggingLevel.INFO, 'InputMessage: ' + inputMsg);
        	system.debug(LoggingLevel.INFO, 'Opp Detail URL: ' + strDetailURL);
            
            // execute Eloqua Email Callout
            execEloquaCallout(strDetailURL);
        }
        
        Pagereference currentRecUrl = new PageReference('/' + opportunityId);
        return currentRecUrl;
    }

/** 
* @description : method to build rep parameters for Eloqua URL
* @param proposalList : proposal line item
* @return string : parameter values
*/     
    private string setRepInformation(Apttus_Proposal__Proposal__c proposalList) {
    	string strRepURL;
    	strRepURL = '';
    	// build url for all Rep values
    	strRepURL += '&repFirstName=' + proposalList.Apttus_Proposal__Opportunity__r.owner.FirstName;
     	strRepURL += '&repLastName=' + proposalList.Apttus_Proposal__Opportunity__r.owner.LastName;
     	strRepURL += '&repTitle=' + proposalList.Apttus_Proposal__Opportunity__r.owner.Title;
     	strRepURL += '&repPhone=' + proposalList.Apttus_Proposal__Opportunity__r.owner.Phone;
     	strRepURL += '&repEmail=' + proposalList.Apttus_Proposal__Opportunity__r.owner.Email;
    	return strRepURL;
    }
    
/** 
* @description : method to build contact parameters for Eloqua URL
* @param proposalList : proposal line item
* @return string : parameter values
*/     
    private string setContactInformation(Apttus_Proposal__Proposal__c proposalList) {
    	string strContactURL;
    	strContactURL = '';
    	// buile url for all Contact values
    	strContactURL += '&firstName=' + proposalList.Apttus_Proposal__Opportunity__r.Key_Contact__r.FirstName;
     	strContactURL += '&lastName=' + proposalList.Apttus_Proposal__Opportunity__r.Key_Contact__r.LastName;
     	strContactURL += '&emailAddress=' + proposalList.Apttus_Proposal__Opportunity__r.Key_Contact__r.Email;
    	return strContactURL;
    }
    
/** 
* @description : method to do Eloqua callout to send email message
* @param strDetailURL : custom URL parameters
*/    
    private void execEloquaCallout(string strDetailURL) {

    	// get Eloqua web service values
    	// test base URL = 'https://s1594852615.t.eloqua.com/e/f2?elqFormName=cxd-sfdc-rep-offers&elqSiteID=1594852615';
    	WebServiceSettings__c oWebServiceSettings2; 
    	oWebServiceSettings2 = AppUtil.getWebServiceSettings('DigitalRepDrivenEloquaService');
    	
        //Eloqua callout logic
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(oWebServiceSettings2.Endpoint__c + '&' + strDetailURL);
	    req.setMethod('GET');
    	req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setTimeout(120000);
                
       	Http http = new Http();
        HTTPResponse res;
        if (!test.isrunningtest()) {
        	res = http.send(req);
       	} else {
	        // Code for test classes.......
    	  	res = new HttpResponse();
          	res.setHeader('Content-Type', 'application/json');
            res.setBody('Success');
	        res.setStatusCode(200); 
        }
       	system.debug(LoggingLevel.INFO, 'Request: ' + req);
        system.debug(LoggingLevel.INFO, 'BODY: ' + res.getBody());
        system.debug(LoggingLevel.INFO, 'STATUS:' + res.getStatus());
       	system.debug(LoggingLevel.INFO, 'STATUS_CODE:' + res.getStatusCode());
        system.debug(LoggingLevel.INFO, 'Eloque URL: ' + oWebServiceSettings2.Endpoint__c + '&' + strDetailURL);
    }

/** 
* @description : returnToOpp method to redirect to oppty page
* @return : PageReference
*/     
    public PageReference returnToOpp() {
        Pagereference currentRecUrl = new PageReference('/' + opportunityId);
        return currentRecUrl;       
    }
}