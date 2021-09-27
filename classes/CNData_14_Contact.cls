/**
 * {Purpose} – Contains various inner classes to represent ContactNet data API Version 14 Contact
 *
 * @author  David Sarbello
 * @version  2014-10-20
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date      Name          Description
 * 2014-10-20  David Sarbello      Created.   
 * 2015-08-30	Glen Cunningham	extended for bitmask etc.   
 * =============================================================================
 */ 
public class CNData_14_Contact {

	/** 
	 * Contains properties for contact
	 */
	private class Values {
		public Integer id;
		public String name;
	}

	private class Filters {
		public Integer lowValue;
		public Integer highValue;
		public String name;
		public Boolean xon;
		public Object currentValue;
		public List<Values> values;
	}

	private class ColumnMetaData {
		public String Title;
		public Integer RenderType;
		public List<String> Fields;
	}

	private List<Filters> Filters        {get; set;}
	private List<ColumnMetaData> ColumnMetaData  {get; set;}
	public List<Results> Results         {get; set;}
	private Integer TrackedSearchId       {get; set;}

	public class Results {
		public Long   OrganizationId       {get; set;}
		public String   OrganizationName     {get; set;}
		public String   Phone           {get; set;}
		public String   Industry         {get; set;}
		public String   MailingAddress       {get; set;}
		public Boolean   HasVisibleSignatures   {get; set;}
		public String   FirstName         {get; set;}
		public String   LastName         {get; set;}
		public String   Title           {get; set;}
		public String   Email           {get; set;}
		public Integer   Id             {get; set;}
		public Double   Strength         {get; set;}
		public Integer   SourcesBitmask       {get; set;}
		public Integer   MostRecentSource     {get; set;}
		public String   MostRecentSourceDate   {get; set;}
		public String   Recency         {get; set;}
		public Integer   RelationshipCount     {get; set;}
	}


	public static CNData_14_Contact parse(String json) {
		//Integer iStart = json.indexOf('\"Results\":');
		//String modifiedJson = '{' + json.substring(iStart);
		system.debug('contact parse json=' + json);
		return (CNData_14_Contact) System.JSON.deserialize(json, CNData_14_Contact.class);
	}

	public static list<CNData.CNContact> MapTo(CNData_14_Contact pContacts) {
		return new list<CNData.CNContact>();
	}

	public static list<CNData.CNContact> MapTo(list<CNData_14_Contact.Results> oContacts, CNData.CNCompany oCompany) {

		list<CNData.CNContact> baseContacts = new list<CNData.CNContact>();

		for (CNData_14_Contact.Results newContact : oContacts) {

			CNData.CNContact newBaseContact = new CNData.CNContact();             

			if (newContact.Phone != null) {
				CNData.CNPhone oPhone = new CNData.CNPhone(newContact.Phone,'');
				newBaseContact.phones.add(oPhone); 
			}else{
				system.debug('PHONE NO IS NULL !!!!');
			}

			newBaseContact.firstName       = newContact.FirstName; 
			newBaseContact.lastName        = newContact.LastName; 
			newBaseContact.title           = newContact.Title;      
			if(newContact.Email != null) newBaseContact.emailAddresses.add(newContact.Email);       
			newBaseContact.CNID            = String.ValueOf(newContact.Id); 
			newBaseContact.Score           = double.valueOf(newContact.Strength); //this gives us 0-7 weighting
			newBaseContact.sources         = getSourcesFromMask(newContact.SourcesBitmask); 
			//parse xml address string
			system.debug('addressxml : ===>>>' + newContact.MailingAddress);
			if(newContact.MailingAddress!=null && newContact.MailingAddress.contains('<')){
				string xml = EncodingUtil.urlDecode(newContact.MailingAddress, 'UTF-8');      	
				Dom.Document doc = new Dom.Document();
				doc.load(xml);
				Dom.XMLNode mailAddr = doc.getRootElement();       	
				try{
					newBaseContact.POBox = mailAddr.getChildElement('POBox', null).getText();
					newBaseContact.StreetAddress = mailAddr.getChildElement('StreetAddress', null).getText();
					newBaseContact.Locality = mailAddr.getChildElement('Locality', null).getText();
					newBaseContact.Region = mailAddr.getChildElement('Region', null).getText();
					newBaseContact.PostalCode = mailAddr.getChildElement('PostalCode', null).getText();
				}catch(exception e){}
			}																			 
			newBaseContact.workingLocation             = newContact.MailingAddress;
			newBaseContact.LastModificationTime    	 = newContact.Recency; 

			newBaseContact.NumberOfRelationships   	 = newContact.RelationshipCount;
			newBaseContact.Company          			 = oCompany;      
			integer daysBetween = Date.today().daysBetween(Date.valueOf(newContact.MostRecentSourceDate));
			//change back to using years,days per 84409
			string years = string.valueOf(integer.valueOf(math.abs(daysBetween)/365));
			string yearString = (years=='1')?'year':'years';
			string days = string.valueOf(Math.Mod(math.abs(daysBetween),365));
			string dayString = (days=='1')?'day':'days';
			boolean d = CNAppUtils.getAppCustomSetting().Recency_as_Date__c;
			if(d==false){
				newBaseContact.LastModificationTime = (integer.valueOf(math.abs(daysBetween)/365)>0)?years + ' ' + yearString + ' ' + days + ' ' + dayString:days  + ' ' + dayString;
			}else{
				List<string> d1 = newContact.MostRecentSourceDate.split('T');
				List<string> t = d1[0].split('-');      	
				newBaseContact.LastModificationTime = t[1] + '-' + t[2] + '-' + t[0];
			}
			newBaseContact.recencyNumber = daysBetween;
			baseContacts.add(newBaseContact);
		}    
		return baseContacts;
	}
	private static set<string> getSourcesFromMask(integer bitMask){
		set<string> sources = new set<string>();

		/*Id	Name			Bitmask	HasConversations	ScoreProviderFunction			SFValue
1		Email			1		1					EmailRelationshipScores			IsEmailSource
2		AddressBook		2		0					AddressBookRelationshipScores	IsAddressBookSource
3		Phone			16		1					AddressBookRelationshipScores	IsPhoneSource
4		Visit			32		1					AddressBookRelationshipScores	IsVisit
5		Contract		64		1					AddressBookRelationshipScores	IsBillingSource
6		AccntMgr		128		0					AddressBookRelationshipScores	IsAccntMgr
7		Calendar		512		1					CalendarRelationshipScores		IsCalendarSource
8		CRMContact		1024	1					AddressBookRelationshipScores	IsCRMSource
9		IARelationship	2048	0					AddressBookRelationshipScores	IsIARelationship
10		Referral		4096	1					AddressBookRelationshipScores	IsReferral
11		Signature		8192	0					AddressBookRelationshipScores   IsSignature*/
		//bitmask is 1  	 
		integer mask = 1;//000000000000001
		if((bitMask & mask) == 1){sources.add('IsEmail');}
		mask = 2;	//00000000000010	
		if((bitMask & mask) == 2){sources.add('IsAddressBook');}
		mask = 16; // 00000000010000		
		if((bitMask & mask) == 16){sources.add('IsPhone');}
		mask = 32; // 00000000100000	 
		if((bitMask & mask) == 32){sources.add('IsVisit');}
		mask = 64; // 00000001000000	
		if((bitMask & mask) == 64){sources.add('IsContract');}
		mask = 128; // 00000010000000	
		if((bitMask & mask) == 128){sources.add('IsAccntMgr');}
		mask = 512; // 00001000000000
		if((bitMask & mask) == 512){sources.add('IsCalendar');}
		mask = 1024; // 00010000000000
		if((bitMask & mask) == 1024){sources.add('IsCRMContact');}
		mask = 2048; // 00100000000000
		if((bitMask & mask) == 2048){sources.add('IsIARelationship');}
		mask = 4096; // 01000000000000
		if((bitMask & mask) == 4096){sources.add('IsReferral');}
		mask = 8192; // 10000000000000
		if((bitMask & mask) == 8192){sources.add('IsSignature');}	
		return sources;
	}

}