/**
 * {Purpose} � This class provides a parser from the CNDE relationship information
 * 		for the contact/colleague to a list of relationship data
 * 
 * @author   Glen Cunningham
 * @version  2015.12.01
 */
/** 
 * CHANGE HISTORY
 * =============================================================================
 * Date          Name                    Description
 * 2015-12-01		Glen Cunningham 		 
 * =============================================================================
 */
public class CNData_14_ColleagueContacts {
	
	public string Vcard;
	public string Phone;
	public List<Relationships> Relationships;
	public Integer NumResults;

	public class Relationships {
		public Integer OrganizationId;
		public string OrganizationName;
		public string Phone;
		public string Industry;
		public string MailingAddress;
		public Boolean HasVisibleSignatures;
		public String FirstName;
		public String LastName;
		public String Title;
		public String Email;
		public Integer Id;
		public Double Strength;
		public Integer SourcesBitmask;
		public Integer MostRecentSource;
		public String MostRecentSourceDate;
		public String Recency;
		public string RelationshipCount;
	}

	public static CNData_14_ColleagueContacts parse(String json) {
		system.debug('json coll cont' + json);
		return (CNData_14_ColleagueContacts) System.JSON.deserialize(json, CNData_14_ColleagueContacts.class);
	}

	public static List<CNData.CNRelationship> MapTo(list<CNData_14_ColleagueContacts.Relationships> oColleagues, CNData.CNCompany oCompany) {

		System.debug('@@@@@ CNData_14_ColleagueContact.MapTo: oCompany:' + oCompany);
		System.debug('@@@@@ CNData_14_ColleagueContact.MapTo: oColleagues:' + oColleagues);

		list<CNData.CNRelationship> baseColleagues = new list<CNData.CNRelationship>();

		for (CNData_14_ColleagueContacts.Relationships newColleague : oColleagues) {

			CNData.CNRelationship newBaseColleague = new CNData.CNRelationship();
			//      
			CNData.CNContact baseCon 	= new CNData.CNContact();
			if (newColleague.Phone != null) {
				CNData.CNPhone oPhone = new CNData.CNPhone(newColleague.Phone,'');
				baseCon.phones.add(oPhone); 
			}else{
				system.debug('NO PHONE NO !!!!!!!!');
			}
			baseCon.firstName         = newColleague.FirstName; 
			baseCon.lastName         	= newColleague.LastName; 
			baseCon.title           	= newColleague.Title;       
			if (newColleague.Email != null){ baseCon.emailAddresses.add(newColleague.Email);}
			baseCon.CNID           	= String.ValueOf(newColleague.Id); 
			baseCon.Score          	= double.valueOf(newColleague.Strength); //this gives us 0-7 weighting      
			baseCon.sources         	= getSourcesFromMask(newColleague.SourcesBitmask);        
			baseCon.LastModificationTime  	= newColleague.Recency; 
			newBaseColleague.Company       	= oCompany;
			newBaseColleague.contact 			= baseCon;
			integer daysBetween = Date.today().daysBetween(Date.valueOf(newColleague.MostRecentSourceDate));
			string years = string.valueOf(integer.valueOf(math.abs(daysBetween)/365));
			string yearString = (years=='1')?'year':'years';
			string days = string.valueOf(Math.Mod(math.abs(daysBetween),365));
			string dayString = (days=='1')?'day':'days';
			baseCon.recencyNumber 	= daysBetween;
			boolean d = CNAppUtils.getAppCustomSetting().Recency_as_Date__c;
			if(d==false){
				newBaseColleague.contact.LastModificationTime = (integer.valueOf(math.abs(daysBetween)/365)>0)?years + ' ' + yearString + ' ' + days + ' ' + dayString:days  + ' ' + dayString;
			}else{
				List<string> d1 = newColleague.MostRecentSourceDate.split('T');
				List<string> t = d1[0].split('-');      	
				newBaseColleague.contact.LastModificationTime = t[1] + '-' + t[2] + '-' + t[0];
			}
			newBaseColleague.contact.recencyNumber = daysBetween;
			baseColleagues.add(newBaseColleague);
		}
		system.debug('completed colleagueContactMapTo baseColleagues.size=' + baseColleagues.size());
		return baseColleagues;
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