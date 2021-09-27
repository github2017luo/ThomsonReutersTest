/**
* {Purpose} – Contains various inner classes to represent ContactNet data API Version 14 Colleague
*
* @author   David Sarbello
* @version  2014-10-20
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2014-10-20    David Sarbello          Created.  
* 2015-08-30	Glen Cunningham			extended for bitmask etc.
* =============================================================================
*/ 
public class CNData_14_Colleague {

    private class Values {
        public Integer id;
        public String name;
    }

    private class Filters {
        public String lowValue;
        public String highValue;
        public String name;
        public Boolean xon;
        public Object currentValue;
        public List<Values> values;
    }

    private class ColumnMetaData {
        public String Title;
        public String RenderType;
        public List<String> Fields;
    }

    private List<Filters> Filters        {get; set;}
    private List<ColumnMetaData> ColumnMetaData  {get; set;}
    public List<Results> Results        {get; set;}
    private Integer TrackedSearchId        {get; set;}

    public class Results {
        public String   Office           {get; set;}
        public String   Department         {get; set;}
        public String   Phone           {get; set;}
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

    
    public static CNData_14_Colleague parse(String json) {
          Integer iStart = json.indexOf('\"Results\":');
          system.debug('json=' + json);
          if(iStart>0){
	          String modifiedJson = '{' + json.substring(iStart);
	          System.debug('@@@@@ CNData_14_Colleague.parse: modifiedJson:' + modifiedJson);
	          return (CNData_14_Colleague) System.JSON.deserialize(modifiedJson, CNData_14_Colleague.class);
          }else{
          	 return (CNData_14_Colleague) System.JSON.deserialize(json, CNData_14_Colleague.class);
          }
          return null;
    }
    
  public static list<CNData.CNColleague> MapTo(list<CNData_14_Colleague.Results> oColleagues, CNData.CNCompany oCompany) {
    
    System.debug('@@@@@ CNData_14_Colleague.MapTo: oCompany:' + oCompany);
    System.debug('@@@@@ CNData_14_Colleague.MapTo: oColleagues:' + oColleagues);
    if(oColleagues==null){return null;}
    list<CNData.CNColleague> baseColleagues = new list<CNData.CNColleague>();
    
    for (CNData_14_Colleague.Results newColleague : oColleagues) {      
      CNData.CNColleague newBaseColleague = new CNData.CNColleague();      
      newBaseColleague.workingLocation    = newColleague.Office;
      newBaseColleague.Department       = newColleague.Department;      
      if (newColleague.Phone != null) {
        CNData.CNPhone oPhone = new CNData.CNPhone(newColleague.Phone,'');
        newBaseColleague.phones.add(oPhone); 
      }else{
      	system.debug('NO PHONE NO !!!!');
      }      
      newBaseColleague.firstName         = newColleague.FirstName; 
      newBaseColleague.lastName         = newColleague.LastName; 
      newBaseColleague.title           = newColleague.Title;      
      if (newColleague.Email != null) newBaseColleague.emailAddresses.add(newColleague.Email);
      newBaseColleague.CNID           = String.ValueOf(newColleague.Id); 
      newBaseColleague.Score          = double.valueOf(newColleague.Strength); //this gives us 0-7 weighting
      newBaseColleague.sources         = getSourcesFromMask(newColleague.SourcesBitmask); 
      newBaseColleague.workingLocation  = newColleague.Office;     
      newBaseColleague.LastModificationTime  = newColleague.Recency; 
      //newBaseColleague.LastModificationTimeAlt = Date.valueOf(newColleague.MostRecentSourceDate);
      newBaseColleague.NumberOfRelationships   = newColleague.RelationshipCount;
      newBaseColleague.Company        = oCompany;      
      integer daysBetween = Date.today().daysBetween(Date.valueOf(newColleague.MostRecentSourceDate));
      newBaseColleague.recencyNumber = daysBetween;
      //change back to using years,days per 84409
      string years = string.valueOf(integer.valueOf(math.abs(daysBetween)/365));
      string yearString = (years=='1')?'year':'years';
      string days = string.valueOf(Math.Mod(math.abs(daysBetween),365));
      string dayString = (days=='1')?'day':'days';
      boolean d = CNAppUtils.getAppCustomSetting().Recency_as_Date__c;
      if(d==false){
      	newBaseColleague.LastModificationTime = (integer.valueOf(math.abs(daysBetween)/365)>0)?years + ' ' + yearString + ' ' + days + ' ' + dayString:days  + ' ' + dayString;
      }else{
      	List<string> d1 = newColleague.MostRecentSourceDate.split('T');
      	List<string> t = d1[0].split('-');      	
      	newBaseColleague.LastModificationTime = t[1] + '-' + t[2] + '-' + t[0];
      }
      newBaseColleague.recencyNumber = daysBetween;
      baseColleagues.add(newBaseColleague);
    }    
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