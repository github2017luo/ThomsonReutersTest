/**
* {Purpose}  Parser CNData_14_SearchResults_ViewType10
*			converts json to class
* @author   Glen Cunningham
* @version  11-6-2015
*/ 

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
*  
* =============================================================================
*/
public class CNData_14_SearchResults_ViewType10 {

  public class Values {
    public Integer id;
    public String name;
  }

  public class Filters {
    public Integer lowValue;
    public Integer highValue;
    public String name;
    public Boolean xon;
    public Object currentValue;
    public List<Values> values;
  }

  public class ColumnMetaData {
    public String Title;
    public Integer RenderType;
    public List<String> Fields;
  }

  public List<Filters> Filters;
  public List<ColumnMetaData> ColumnMetaData;
  public List<Results> Results;
  public Integer TrackedSearchId;

  public class Results {
    public String Name;
    public String HomepageUrl;
    public String TelephoneNumber;
    public Integer ColleagueCount;
    public Integer ContactCount;
    public Long Id;
    public Double Strength;
    public Integer SourcesBitmask;
    public Integer MostRecentSource;
    public String MostRecentSourceDate;
    public String Recency;
    public Integer RelationshipCount;
  }

  
    public static CNData_14_SearchResults_ViewType10 parse(String json) {
          Integer iStart = json.indexOf('\"Results\":');
          String modifiedJson = '{' + json.substring(iStart);
          System.debug('@@@@@ CNData_14_SearchResults_ViewType10.parse: modifiedJson:' + modifiedJson);
          return (CNData_14_SearchResults_ViewType10) System.JSON.deserialize(modifiedJson, CNData_14_SearchResults_ViewType10.class);
    }
    
  public static list<CNData.CNCompany> MapTo(list<CNData_14_SearchResults_ViewType10.Results> oResults) {
    System.debug('@@@@@ CNData_14_SearchResults_ViewType10.MapTo: oCompany:' + oResults);
    list<CNData.CNCompany> listCompanies = new list<CNData.CNCompany>();
    CNData.CNCompany oCompany = new CNData.CNCompany();    
    for (Results r : oResults) {
      oCompany           = new CNData.CNCompany();
      oCompany.CNID        = String.ValueOf(r.Id);
      oCompany.companyName    = r.Name;
      oCompany.NumberOfColleagues  = r.ColleagueCount;
      oCompany.NumberOfContacts  = r.ContactCount;
      listCompanies.add(oCompany);
    }    
    return listCompanies;    
  }
   
}