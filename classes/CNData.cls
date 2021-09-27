/**
 * {Purpose} – Contains various inner classes to represent ContactNet data
 *
 * @author  Shah Kadirmohideen
 * @version  2011-10-26
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date      Name          Description
 * 2011-10-26  Shah Kadirmohideen    Created.      
 * 2012-02-02  Shah Kadirmohideen    Changed some of the variable names to work with JSON format
 * 2012-01-20  Shah Kadirmohideen    Incorporated enhanced list (go to list) functionality related changes.
 * 2012-07-12  Shah Kadirmohideen    Added support for calendar icon display
 * 2012-10-04  Shah Kadirmohideen    Added CNExceptionInfo inner class
 * 2013-09-03  Mike Eaton         Added support for retrieving CNContact Addresses but NOT stored in cache at this time!
 * 2013-09-04  Mike Eaton        [CR-070] Added initial support for the addition of Signatures node in the JSON response
 * 2013-09-08  Mike Eaton        [CR-063] Added support for identify the signatures as a source 
 * =============================================================================
 */ 
public class CNData {  
	/***/

	/* Contains properties for contact
	 */
	public static String sortBy {get; set;}
	public static String innersortBy {get; set;}
	public static String whichSort {get; set;}  

	public virtual class CNContact {
		/* Public variables */
		public String CNID {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String fullName {get; set;}
		public List<String> emailAddresses {get; set;}
		public String title {get; set;}
		public List<CNPhone> phones {get; set;}
		public CNCompany company {get; set;}
		public Set<String> sources {get; set;}
		public List<CNRelationship> relationships {get; set;}
		public Integer normalizedScore {get; set;}
		public Double score {get; set;}  //raw score
		public String workingLocation {get; set;}
		public String POBox {get; set;}
		public String StreetAddress {get; set;}
		public String Locality {get; set;}
		public String Region {get; set;}
		public String PostalCode {get; set;}
		public List<String> identifiers {get; set;}
		public Boolean IsDeleted {get; set;}
		public String LastModificationTime {get; set;}
		public DateTime LastModificationTimeAlt {get; set;}
		public integer recencyNumber {get;set;} 
		public Integer NumberOfRelationships {get; set;}

		//[CR-063] M.Eaton - stubbed out to prevent JSON failure on CNWS2.1 (NOT cached)
		public List<CNAddress> addresses {get; set;}
		public List<String> signatures {get; set;}

		public Boolean innerRelationshipExpanded {get; set;}
		public CNPaginator paginator {get; set;}


		//Constructor
		public CNContact() {
			this.emailAddresses = new List<String>();
			this.phones = new List<CNPhone>();
			this.innerRelationshipExpanded = false;
			//[CR-063] M.Eaton - stubbed out support for addresses and signatures
			this.addresses = new List<CNAddress>();
			this.signatures = new List<String>();
		}

		//Returns the contact full name by concatenating firstname & lastname
		public String getFullNamePrepared() {

			if (CNAppUtils.isNonEmpty(this.fullName)) return this.fullName;
			String sFullName = '';
			string nm='';
			if (CNAppUtils.isNonEmpty(firstName)) sFullName = firstName;
			if (CNAppUtils.isNonEmpty(lastName)) {
				if (sFullName.trim().length() > 0) sFullName += ' ';
				sFullName += lastName;
				//nm = lastName + ', ' + sFullName;
			} 
			return sFullName;
			//return nm;
		}

		//Returns the contact full name or email - whichever is non null
		public String getFullNameOrEmail() {
			String sReturn = getFullNamePrepared();
			if (CNAppUtils.isEmpty(sReturn)) {
				sReturn = getFirstEmail();
			} 
			return sReturn;
		}

		//Checks if the contact name is present or not
		public Boolean getIsNamePresent() {
			return CNAppUtils.isNonEmpty(getFullNamePrepared());  
		}

		//Prepares the relationship title based on either fullname or email
		public String getRelationshipTitle() {
			String sReturn = null;
			if (CNAppUtils.isNonEmpty(firstName) || CNAppUtils.isNonEmpty(lastName)) {
				sReturn = getFullNamePrepared();
				if (sReturn.endsWith('s') == false) {
					sReturn += '\'s';
				}
			} 
			else {
				String sEm = getFirstEmail();
				System.debug('firstEmail: ' + sEm + ', CNID: ' + CNID);
				sReturn = sEm;  
			}
			return sReturn + ' Relationships';
		}

		//Returns true if the phone is one of the sources
		public Boolean getIsPhoneSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISPHONE);
		}

		//Returns true if the email is one of the sources
		public Boolean getIsEmailSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISEMAIL);
		}

		//Returns true if calendar is one of the sources
		public Boolean getIsCalendarSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISCALENDAR);
		}

		//Returns true if the address book is one of the sources
		public Boolean getIsAddressBookSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISADDRESSBOOK);
		}

		//Returns true if the Salesforce CRM is one of the sources
		public Boolean getIsCRMSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISCRM);
		}
		//Returns true if the VisitSource is one of the sources
		public Boolean getIsVisitSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISVISIT);
		}
		//Returns true if the AccntMgr is one of the sources
		public Boolean getIsAccntMgr() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISACCNTMGR);
		}
		//Returns true if the IARELATIONSHIP is one of the sources
		public Boolean getIsIARelationship() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISIARELATIONSHIP);
		}
		//Returns true if the IARELATIONSHIP is one of the sources
		public Boolean getIsReferral() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISREFERRAL);
		}    
		//Returns true if the Time and Billing is one of the sources
		public Boolean getIsBillingSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISBILLING);
		}

		//[CR-063] Retuns true if there are signatures on the contact
		public Boolean getIsSignatureSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISSIGNATURE);
		}

		//returns the first phone number from the collection
		public CNPhone getFirstPhone() {
			return phones != null && phones.size() > 0 ? phones.get(0) : null;
		}

		//Returns the first phone number from the collection
		public String getFirstPhoneNumber() {
			return phones != null && phones.size() > 0 ? phones.get(0).phoneNumber : null;
		}

		//Returns mobile number if any found
		public String getMobilePhoneNumber() {
			if (phones != null) {
				for (CNPhone oPhone : phones) {
					if (oPhone.isMobilePhone()) {
						return oPhone.phoneNumber;
					}
				}
			}
			return null;
		}

		//Returns the first phone number from the collection which will be displayed in collapsed mode
		public List<String> getCollapsedPhones() {
			List<String> listPhones = new List<String>();
			CNPhone oPh = getFirstPhone();
			if (oPh != null) {
				listPhones.add(oPh.phoneNumber);
			}
			return listPhones;
		}

		//Returns all the phone numbers which will be displayed in expanded mode.
		public List<String> getExpandedPhones() {
			List<String> listPhones = new List<String>();
			if (phones != null) {
				for (CNPhone oPh : phones) {
					listPhones.add(oPh.getPhoneNumberWithType());
				}
			}
			return listPhones;
		}

		//Returns semi-colon separated phones as a string
		public String getConcatenatedPhones() {
			return CNAppUtils.concatenateList(getExpandedPhones(), ';');  
		}

		//Returns the first email address from the collection
		public String getFirstEmail() {
			return emailAddresses != null && emailAddresses.size() > 0 ? emailAddresses.get(0) : null;
		}

		//Returns the first email address which will be displayed in collapsed mode
		public List<String> getCollapsedEmails() {
			List<String> listEmails = new List<String>();
			String sEmail = getFirstEmail();
			if (sEmail != null) {
				listEmails.add(sEmail);
			}
			return listEmails;
		}

		//Returns all email addresses which will be displayed in expanded mode.
		public List<String> getExpandedEmails() {
			List<String> listEmails = new List<String>();
			if (emailAddresses != null) {
				for (String sEmail : emailAddresses) {
					listEmails.add(sEmail);
				}
			}
			return listEmails;
		}

		//Returns semi-colon separated emails as a string.
		public String getConcatenatedEmails() {
			return CNAppUtils.concatenateList(emailAddresses, ';');  
		}

		//Returns true if the title is empty
		public Boolean getIsTitleEmpty() {
			return CNAppUtils.isEmpty(title);
		}

		//Returns the last modified date as a string  including the time portion
		public String getLastModificationTimeFormatted() {
			if (LastModificationTimeAlt != null) {
				return LastModificationTimeAlt.format('MM-dd-yyyy');
			}
			else {
				return '';
			}
		}
	}


	/**
	 * Contains properties for colleague.
	 */
	public class CNColleague extends CNContact {
		public String department {get; set;}
	}

	/**
	 * Contains properties for company.
	 */
	public class CNCompany {
		/* Public variables */
		public String CNID {get; set;}
		public List<CNContact> contacts {get; set;}
		public Double firmOrganizationScore {get; set;}
		public Boolean hasRelationship {get; set;}
		public Boolean isClient {get; set;}
		public String companyName {get; set;}
		public Integer normalizedFirmOrganizationScore {get; set;}
		public List<CNRelationship> relationships {get; set;}
		public Set<String> sources {get; set;}
		public List<String> identifiers {get; set;}
		public Boolean IsDeleted {get; set;}
		public Boolean IsOa {get;set;}
		public Integer NumberOfColleagues {get; set;}
		public Integer NumberOfContacts {get; set;}
	}  

	/**
	 * Contains properties for a relationship which could fall under one of the following scenarios:
	 *  - Colleague & Contact
	 *  - Colleague & Company
	 *  - Colleague & Industry
	 */
	public class CNRelationship implements Comparable{
		/* Public variables */
		public String Type {get; set;}  //toContact, toCompany, toIndustry
		public Double score {get; set;}    //raw score
		public Integer normalizedScore {get; set;}
		public CNColleague colleague {get; set;}  //colleague who has the relationship
		public CNContact contact {get; set;}  //if type=contact
		public CNCompany company {get; set;}  //if type=company
		public Integer index {get; set;}
		public Set<String> sources {get; set;}
		public Boolean display {get; set;}
		//additional column vars from configuration page 
		// note to whomever follows me in this code, if you do not do the boolean math here  
		// and if any columns/elements are not specifically ANDed to hidden when display==false  Salesforce
		//renders spurious artifacts in the grid rows (especially the hidden row) so as lame as this is it works
		// to produce a useable UI
		private Boolean ShowColleagueEmailData;
		public  Boolean getShowColleagueEmailData() {
			return CNAppUtils.getShowColleagueEmailData() && display;
		}
		public void setShowColleagueEmailData(Boolean v){
			ShowColleagueEmailData = v;
		}
		private Boolean ShowColleagueLocation;
		public  Boolean getShowColleagueLocation() {
			return CNAppUtils.getShowColleagueLocation() && display;
		}
		public void setShowColleagueLocation(boolean v){
			ShowColleagueLocation = v;
		}
		private Boolean ShowColleaguePhoneData;
		public  Boolean getShowColleaguePhoneData() {
			return CNAppUtils.getShowColleaguePhoneData() && display;
		}
		public void setShowColleaguePhoneData(Boolean v){
			ShowColleaguePhoneData = v;
		}
		private Boolean ShowColleagueRecency;
		public  Boolean getShowColleagueRecency() {
			return CNAppUtils.getShowColleagueRecency() && display;  
		}  
		public void setShowColleagueRecency(Boolean v){
			ShowColleagueRecency = v;
		}
		private Boolean ShowColleagueRelationshipStrength;
		public  Boolean getShowColleagueRelationshipStrength() {
			return CNAppUtils.getShowColleagueRelationshipStrength() && display;
		}
		public void setShowColleagueRelationshipStrength(Boolean v){
			ShowColleagueRelationshipStrength = v;
		}
		private Boolean ShowColleagueSource;
		public  Boolean getShowColleagueSource() {
			return CNAppUtils.getShowColleagueSource() && display;
		}
		public void setShowColleagueSource(Boolean v){
			ShowColleagueSource = v;
		}
		private Boolean ShowColleagueTitle;
		public  Boolean getShowColleagueTitle() {
			return CNAppUtils.getShowColleagueTitle() && display;
		}
		public void setShowColleagueTitle(Boolean v){
			ShowColleagueTitle = v;
		}
		private Boolean ShowContactEmailData;	
		public  Boolean getShowContactEmailData() {
			return CNAppUtils.getShowContactEmailData() && display;
		}
		public void setShowContactEmailData(Boolean v){
			ShowContactEmailData = v;
		}
		private Boolean ShowContactLocation;
		public  Boolean getShowContactLocation() {
			return CNAppUtils.getShowContactLocation() && display;
		}
		public void setShowContactLocation(Boolean v){
			ShowContactLocation = v;
		}
		private Boolean ShowContactPhoneData;
		public  Boolean getShowContactPhoneData() {
			return CNAppUtils.getShowContactPhoneData() && display;
		}
		public void setShowContactPhoneData(Boolean v){
			ShowContactPhoneData = v;
		}
		private Boolean ShowContactRecency;
		public  Boolean getShowContactRecency() {
			return CNAppUtils.getShowContactRecency() && display;
		}
		public void setShowContactRecency(Boolean v){
			ShowContactRecency = v;
		}
		private Boolean ShowContactRelationshipStrength;
		public  Boolean getShowContactRelationshipStrength() {
			return CNAppUtils.getShowContactRelationshipStrength() && display;
		}
		public void setShowContactRelationshipStrength(Boolean v){
			ShowContactRelationshipStrength = v;
		}
		private Boolean ShowContactSource;
		public  Boolean getShowContactSource() {
			return CNAppUtils.getShowContactSource() && display;
		}
		public void setShowContactSource(Boolean v){
			ShowContactSource = v;
		}
		private Boolean ShowContactTitle;
		public  Boolean getShowContactTitle() {
			return CNAppUtils.getShowContactTitle() && display;
		}
		public void setShowContactTitle(Boolean v){
			ShowContactTitle = v;
		}
		private Boolean ShowEmailData;
		public  Boolean getShowEmailData() {
			return CNAppUtils.getShowEmailData() && display; 
		} 
		public void setShowEmailData(Boolean v){
			ShowEmailData = v;
		}
		private Boolean ShowPhoneData;
		public  Boolean getShowPhoneData() {
			return CNAppUtils.getShowPhoneData() && display;
		}
		public void setShowPhoneData(Boolean v){
			ShowPhoneData = v;
		} 
		private Boolean showContactEmail;
		public  Boolean getshowContactEmail(){
			return CNAppUtils.getContactShowEmail() && display;
		}
		public void setshowContactEmail(Boolean v){
			showContactEmail = v;
		}  
		private  Boolean showContactPhone;                          
		public  Boolean getshowContactPhone(){
			return CNAppUtils.getContactShowPhone() && display;
		}   
		public void setshowContactPhone(Boolean v){
			showContactPhone = v;
		}      
		private Boolean enableContactActionColumn;                  
		public  Boolean getenableContactActionColumn()  {
			return CNAppUtils.getContactEnableActionColumn() && display;
		}
		public void setenableContactActionColumn(Boolean v){
			enableContactActionColumn = v;
		}
		private Boolean enableContactSearchColumn;
		public  Boolean getenableContactSearchColumn()  {
			return CNAppUtils.getContactEnableSearchAction() && CNAppUtils.getContactEnableActionColumn()  && display;
		}
		public void setenableContactSearchColumn(Boolean v){
			enableContactSearchColumn = v;
		}
		private Boolean enableContactAddColumn;
		public  Boolean getenableContactAddColumn()  {
			return CNAppUtils.getContactEnableAddAction() && CNAppUtils.getContactEnableActionColumn()  && display;
		}
		public void setenableContactAddColumn(Boolean v){
			enableContactAddColumn = v;
		}
		// 
		public Boolean expanded {get; set;}
		public CNIndustry industry {get; set;}
		public Boolean enhancedList {get; set;}
		//[CR-069] M. Eaton - added to support Sensitive Data usage
		public Boolean isSensitiveData {get; set;}
		//add 'selected' as return for each item < score so we can display bar graph correctly
		public string d1{get;set;}
		public string d2{get;set;}
		public string d3{get;set;}
		public string d4{get;set;}
		public string d5{get;set;}
		public string d6{get;set;}
		public string d7{get;set;}

		/* Private variables */    
		private Boolean innerTableDisplayMode = false;

		/* Constructor */
		public CNRelationship() {
			expanded = false;
			enhancedList = false;
		}
		//
		public Integer compareTo(Object compareTo){
			//check which field is set above and which direction       
			CNRelationship CNRelationship = (CNRelationship) compareTo;
			//
			if(CNRelationship.contact!=null && CNData.innersortBy!=null && whichSort == 'inner'){
				//relationship score
				if (CNData.innersortBy.equals('innerscoreAsc')){    
					return (contact.score > CNRelationship.contact.score)?1:0;             
				}
				if (CNData.innersortBy.equals('innerscoreDesc')) {                
					return (contact.score > CNRelationship.contact.score)?0:1;
				}  
				//Name	           
				if (CNData.innersortBy.equals('innernameAsc')){                          
					return (contact.lastName > CNRelationship.contact.lastName)?0:1;             
				}
				if (CNData.innersortBy.equals('innernameDesc')) {             
					return (contact.lastName > CNRelationship.contact.lastName)?1:0;
				}
				//title
				if (CNData.innersortBy.equals('innertitleAsc')){          
					return (contact.title > CNRelationship.contact.title)?0:1;             
				}
				if (CNData.innersortBy.equals('innertitleDesc')) {
					return (contact.title > CNRelationship.contact.title)?1:0;
				}
				//email
				if (CNData.innersortBy.equals('inneremailAsc')){               
					return (contact.emailAddresses[0] > CNRelationship.contact.emailAddresses[0])?0:1;             
				}
				if (CNData.innersortBy.equals('inneremailDesc')) {
					return (contact.emailAddresses[0] > CNRelationship.contact.emailAddresses[0])?1:0;
				}  
				//phones - phone numbers are not comparable so no go here unless we implement custom 
				if (CNData.innersortBy.equals('innerphoneAsc')){                 
					//return (contact.phones[0] > CNRelationship.contact.phones[0])?1:0;             
				}
				if (CNData.innersortBy.equals('innerphoneDesc')) {                
					//return (contact.phones[0] > CNRelationship.contact.phones[0])?0:1;
				}  
				//Recency
				if (CNData.innersortBy.equals('innerrecencyAsc')){
					return (contact.recencyNumber > CNRelationship.contact.recencyNumber)?1:0;
				}
				if (CNData.innersortBy.equals('innerrecencyDesc')) {        
					return (contact.recencyNumber > CNRelationship.contact.recencyNumber)?0:1;                     
				} 
				return -1;
			}
			//
			if(CNRelationship.contact!=null && CNData.sortBy!=null){
				//relationship score
				if (CNData.sortBy.equals('scoreAsc')){    
					return (contact.score > CNRelationship.contact.score)?1:0;             
				}
				if (CNData.sortBy.equals('scoreDesc')) {                
					return (contact.score > CNRelationship.contact.score)?0:1;
				}  
				//Name	           
				if (CNData.sortBy.equals('nameAsc')){                          
					return (contact.lastName > CNRelationship.contact.lastName)?0:1;             
				}
				if (CNData.sortBy.equals('nameDesc')) {             
					return (contact.lastName > CNRelationship.contact.lastName)?1:0;
				}
				//title
				if (CNData.sortBy.equals('titleAsc')){          
					return (contact.title > CNRelationship.contact.title)?0:1;             
				}
				if (CNData.sortBy.equals('titleDesc')) {
					return (contact.title > CNRelationship.contact.title)?1:0;
				}
				//email
				if (CNData.sortBy.equals('emailAsc')){               
					return (contact.emailAddresses[0] > CNRelationship.contact.emailAddresses[0])?0:1;             
				}
				if (CNData.sortBy.equals('emailDesc')) {
					return (contact.emailAddresses[0] > CNRelationship.contact.emailAddresses[0])?1:0;
				}  
				//phones - phone numbers are not comparable so no go here unless we implement custom 
				if (CNData.sortBy.equals('phoneAsc')){                 
					//return (contact.phones[0] > CNRelationship.contact.phones[0])?1:0;             
				}
				if (CNData.sortBy.equals('phoneDesc')) {                
					//return (contact.phones[0] > CNRelationship.contact.phones[0])?0:1;
				}  
				//Recency
				if (CNData.sortBy.equals('recencyAsc')){
					return (contact.recencyNumber > CNRelationship.contact.recencyNumber)?1:0;
				}
				if (CNData.sortBy.equals('recencyDesc')) {        
					return (contact.recencyNumber > CNRelationship.contact.recencyNumber)?0:1;                     
				} 
				return -1;
			}
			if(CNRelationship.colleague!=null && CNData.sortBy!=null){
				//relationship score
				if (CNData.sortBy.equals('scoreAsc')){    
					return (colleague.score > CNRelationship.colleague.score)?1:0;             
				}
				if (CNData.sortBy.equals('scoreDesc')) {                
					return (colleague.score > CNRelationship.colleague.score)?0:1;
				}  
				//Name
				if (CNData.sortBy.equals('nameAsc')){                          
					return (colleague.lastName > CNRelationship.colleague.lastName)?0:1;             
				}
				if (CNData.sortBy.equals('nameDesc')) {             
					return (colleague.lastName > CNRelationship.colleague.lastName)?1:0;
				}  
				//title
				if (CNData.sortBy.equals('titleAsc')){          
					return (colleague.title > CNRelationship.colleague.title)?0:1;             
				}
				if (CNData.sortBy.equals('titleDesc')) {
					return (colleague.title > CNRelationship.colleague.title)?1:0;
				}
				//email
				if (CNData.sortBy.equals('emailAsc')){ 
					if(colleague.emailAddresses.size()>0&&CNRelationship.colleague.emailAddresses.size()>0){              
						return (colleague.emailAddresses[0] > CNRelationship.colleague.emailAddresses[0])?0:1; 
					}else{
						return -1;
					}      
				}
				if (CNData.sortBy.equals('emailDesc')) {
					if(colleague.emailAddresses.size()>0&&CNRelationship.colleague.emailAddresses.size()>0){              
						return (colleague.emailAddresses[0] > CNRelationship.colleague.emailAddresses[0])?1:0; 
					}else{
						return -1;
					}  
				}  
				//phones - phone numbers are not comparable so no go here unless we implement custom 
				if (CNData.sortBy.equals('phoneAsc')){                 
					//return (colleague.phones[0] > CNRelationship.colleague.phones[0])?1:0;             
				}
				if (CNData.sortBy.equals('phoneDesc')) {                
					//return (colleague.phones[0] > CNRelationship.colleague.phones[0])?0:1;
				}  
				//Recency
				if (CNData.sortBy.equals('recencyAsc')){
					return (colleague.recencyNumber > CNRelationship.colleague.recencyNumber)?1:0;
				}
				if (CNData.sortBy.equals('recencyDesc')) {        
					return (colleague.recencyNumber > CNRelationship.colleague.recencyNumber)?0:1;                     
				} 
				//workingLocation
				if (CNData.sortBy.equals('locationAsc')){
					return (colleague.workingLocation > CNRelationship.colleague.workingLocation)?0:1;
				}
				if (CNData.sortBy.equals('locationDesc')) {        
					return (colleague.workingLocation > CNRelationship.colleague.workingLocation)?1:0;                     
				} 
				return -1;
			}
			//
			if(CNRelationship.colleague!=null && CNData.innersortBy!=null && whichsort == 'inner'){
				//relationship score
				if (CNData.innersortBy.equals('innerscoreAsc')){    
					return (colleague.score > CNRelationship.colleague.score)?1:0;             
				}
				if (CNData.innersortBy.equals('innerscoreDesc')) {                
					return (colleague.score > CNRelationship.colleague.score)?0:1;
				}  
				//Name
				if (CNData.innersortBy.equals('innernameAsc')){                          
					return (colleague.lastName > CNRelationship.colleague.lastName)?0:1;             
				}
				if (CNData.innersortBy.equals('innernameDesc')) {             
					return (colleague.lastName > CNRelationship.colleague.lastName)?1:0;
				}  
				//title
				if (CNData.innersortBy.equals('innertitleAsc')){          
					return (colleague.title > CNRelationship.colleague.title)?0:1;             
				}
				if (CNData.innersortBy.equals('innertitleDesc')) {
					return (colleague.title > CNRelationship.colleague.title)?1:0;
				}
				//email
				if (CNData.innersortBy.equals('inneremailAsc')){ 
					if(colleague.emailAddresses.size()>0&&CNRelationship.colleague.emailAddresses.size()>0){              
						return (colleague.emailAddresses[0] > CNRelationship.colleague.emailAddresses[0])?0:1; 
					}else{
						return -1;
					}      
				}
				if (CNData.innersortBy.equals('inneremailDesc')) {
					if(colleague.emailAddresses.size()>0&&CNRelationship.colleague.emailAddresses.size()>0){              
						return (colleague.emailAddresses[0] > CNRelationship.colleague.emailAddresses[0])?1:0; 
					}else{
						return -1;
					}  
				}  
				//phones - phone numbers are not comparable so no go here unless we implement custom 
				if (CNData.innersortBy.equals('innerphoneAsc')){                 
					//return (colleague.phones[0] > CNRelationship.colleague.phones[0])?1:0;             
				}
				if (CNData.innersortBy.equals('innerphoneDesc')) {                
					//return (colleague.phones[0] > CNRelationship.colleague.phones[0])?0:1;
				}  
				//Recency
				if (CNData.innersortBy.equals('innerrecencyAsc')){
					return (colleague.recencyNumber > CNRelationship.colleague.recencyNumber)?1:0;
				}
				if (CNData.innersortBy.equals('innerrecencyDesc')) {        
					return (colleague.recencyNumber > CNRelationship.colleague.recencyNumber)?0:1;                     
				} 
				//workingLocation
				if (CNData.innersortBy.equals('innerlocationAsc')){
					return (colleague.workingLocation > CNRelationship.colleague.workingLocation)?0:1;
				}
				if (CNData.innersortBy.equals('innerlocationDesc')) {        
					return (colleague.workingLocation > CNRelationship.colleague.workingLocation)?1:0;                     
				} 
				return -1;
			}
			//
			return -1;
		}   
		//Returns true if the phone is one of the sources
		public Boolean getIsPhoneSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISPHONE);
		}

		//Returns true if the email is one of the sources
		public Boolean getIsEmailSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISEMAIL);
		}

		//Returns true if calendar is one of the sources
		public Boolean getIsCalendarSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISCALENDAR);
		}

		//Returns true if the address book is one of the sources
		public Boolean getIsAddressBookSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISADDRESSBOOK);
		}

		//Returns true if the Salesforce CRM is one of the sources
		public Boolean getIsCRMSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISCRM);
		}

		//Returns true if the Time and Billing is one of the sources
		public Boolean getIsBillingSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISBILLING);
		}
		//Returns true if the VisitSource is one of the sources
		public Boolean getIsVisitSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISVISIT);
		}
		//Returns true if the AccntMgr is one of the sources
		public Boolean getIsAccntMgr() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISACCNTMGR);
		}
		//Returns true if the IARELATIONSHIP is one of the sources
		public Boolean getIsIARelationship() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISIARELATIONSHIP);
		}
		//Returns true if the IARELATIONSHIP is one of the sources
		public Boolean getIsReferral() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISREFERRAL);
		}    
		//[CR-063] Retuns true if there are signatures on the contact
		public Boolean getIsSignatureSource() {
			return sources != null && sources.contains(CNConstants.SOURCE_TYPE_ISSIGNATURE);
		}    

		//Returns the hidden index by adding 1 to the visible row index.
		public Integer getHiddenRowIndex() {    	
			return index + 1;
		}
		Public void setHiddenRowIndex(integer value){
			index = value;
		}    
		//Identifies if the inner table can be displayed or not.
		public String getInnerTableDisplay() {
			if (innerTableDisplayMode) {
				innerTableDisplayMode = false;
				return '';
			}
			else {
				innerTableDisplayMode = true;
				return 'none';
			}
		}  

		public Boolean getIsDisplayLastUpdateDate() {
			return display && CNPaginator.displayLastUpdateDate;
		}  

		//[CR-069] M.Eaton - Sets the underlying contact details need to be set to unavailable
		public void checkForSensitiveData() {
			if (type == CNConstants.RELATIONSHIP_TYPE_TOCONTACT ) {
				if (contact.getFirstEmail() == null) { 
					contact.emailAddresses.add('Email ' + CNAppUtils.getDataSensitiveDefault());
				}
				if (contact.getFirstPhoneNumber() == null ) {
					contact.phones = new List<CNData.CNPhone>{new CNData.CNPhone('Phone ' + CNAppUtils.getDataSensitiveDefault(), '')};
				}
				//isSensitiveData = true;
			}

		}

	}  

	/**
	 * Contains the relationship and few other information which are returned from any CN web service call
	 */ 
	public class CNWebserviceResult {
		/* Public variables */
		public List<CNData.CNRelationship> listRelationships {get; set;}
		public List<CNData.CNContact> listContacts {get; set;}
		public String sContactCNID {get; set;}
		public String sCompanyCNID {get; set;}
		public Integer iTotalRelationships {get; set;}
		public Boolean errorFound {get; set;}

		/* CONSTRUCTORS */

		public CNWebserviceResult() {
			errorFound = false;
		}
	}  

	/**
	 *  Represents a phone number along with it's type (home, cell, work, work2 etc)
	 */  
	public class CNPhone {
		/* Public variables */
		public String phoneNumber {get; set;}
		public String Type {get; set;}

		/* CONSTRUCTORS */
		public CNPhone(String pn, String phType) {
			this.phoneNumber = pn;
			this.Type = phType;
		}

		//Returns the phone type in lower case.
		public String getTypeFormatted() {
			if (Type != null) {
				return Type.toLowerCase();
			}
			return '';
		}

		//Returns the phone number & type concatenated.
		public String getPhoneNumberWithType() {
			String sPhone = phoneNumber;
			if (Type != null) {
				sPhone += ' (' + Type.toLowerCase() + ')';
			}
			return sPhone;
		}

		//Identifies if the phone number is mobile
		public Boolean isMobilePhone() {
			return Type != null && (Type.contains('cell') || Type.contains('mobile'));
		}
	}  

	/**
	 *  Represents an address with 
	 */  
	public class CNAddress {
		/* Public variables */
		public String city {get; set;}
		public String countryName {get; set;}
		public String poBox {get; set;}
		public String postalCode {get; set;}
		public String state {get; set;}
		public String street {get; set;}
		public String street2 {get; set;}
		public String Type {get; set;}

		/* CONSTRUCTORS */
		public CNAddress() {
			this.city = null;
			this.countryName = null;
			this.poBox = null;
			this.postalCode = null;
			this.state = null;
			this.street = null;
			this.street2 = null;
			this.Type = null;
		}
	}

	/**
	 *  Represents industry
	 */
	public class CNIndustry {

	}
	//inner class to holdeach set of displayed inner table data so 
	//multiple innertables can be displayed at once
	//and each can support seperate sorting and paging
	public class innerTableData{
		public List<CNData.CNRelationship> relationshipListFull{get;set;} //total list of relationships for this CN
		public List<CNData.CNRelationship> relationshipListDisplayPage{get;set;} //currently selected page
		public string CNID{get;set;} //confirm match to outer table row
		public integer pagerStartNumber{get;set;}
		public integer pagerEndNumber{get;set;}
		public integer pagerCurrentNumber{get;set;}
		public string sortOrder{get;set;}
		public string typeOf{get;set;}
		public CNData.CNRelationship hiddenColleagueRelationshipExpanded {get; set;}  //most recently expanded colleague relationship
		public CNData.CNRelationship hiddenContactRelationshipExpanded {get; set;}
		public integer lastIndex{get;set;} 
		//public  CNPaginator colleagueDetailPaginator {get; set;}  
		//public  CNPaginator contactDetailPaginator {get; set;}   
	}
	/**
	 * Custom exception
	 */
	public class CNException extends Exception {
	}

	/**
	 * Value object class which holds exception related information for logging & debugging purposes
	 */
	public class CNExceptionInfo {
		public Exception oExp;
		public String sExp;
		public ApexPages.Severity oSeverity;
		public String sClassName;
		public String sMethodName;
		public String sMoreInfo; 
		public Boolean bAddToPage; 
		public Boolean bAddDebugInfoToPage;
		public Boolean bSendEmail; 
		public String sEmailSubject;
		public Boolean bAddDebugInfoToEmail = true;  //Error email will always contains debugging information

		//Use this constructor when an exception occurs in the application
		public CNExceptionInfo(Exception oExp, ApexPages.Severity oSeverity, 
				String sClassName, String sMethodName, 
				String sMoreInfo, Boolean bAddToPage, 
				Boolean bSendEmail, String sEmailSubject) {
			this.oExp = oExp;
			this.oSeverity = oSeverity;
			this.sClassName = sClassName;
			this.sMethodName = sMethodName;
			this.sMoreInfo = sMoreInfo;
			this.bAddToPage = bAddToPage;
			this.bSendEmail = bSendEmail;
			this.sEmailSubject = sEmailSubject;
			this.bAddDebugInfoToPage = true;
		}

		//Use this constructor when a validation fails
		public CNExceptionInfo(String sExp, ApexPages.Severity oSeverity, 
				String sClassName, String sMethodName, 
				String sMoreInfo, Boolean bAddToPage, Boolean bAddDebugInfoToPage, 
				Boolean bSendEmail, String sEmailSubject) {
			this.sExp = sExp;
			this.oSeverity = oSeverity;
			this.sClassName = sClassName;
			this.sMethodName = sMethodName;
			this.sMoreInfo = sMoreInfo;
			this.bAddToPage = bAddToPage;
			this.bSendEmail = bSendEmail;
			this.sEmailSubject = sEmailSubject;
			this.bAddDebugInfoToPage = bAddDebugInfoToPage;
		}
	}  
}