/**
* {Purpose} – Contains various inner classes to represent ContactNet data API Version 14 AutoComplete
*        AutoComplete is a general way to search for Companies, Contacts, and Colleagues
* @author   David Sarbello
* @version  2014-10-20
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2014-10-20    David Sarbello          Created.      
* =============================================================================
*/ 
public class CNData_14_AutoComplete {

    public class Collection {
        public Integer NumColleagues      {get; set;} //Valid when bitmask = 16 (Company) OR bitmask = 1 (Contact)
        public Integer NumContacts          {get; set;} //Valid when bitmask = 16 (Company) 
        public Integer NumRelationships      {get; set;} //Valid when bitmask = 16 (Company) 
        public Boolean HasFamilyTree      {get; set;} //Valid when bitmask = 16 (Company)
        public String Id                  {get; set;} //Valid when bitmask = 16 (Company) OR bitmask = 1 (Contact)
        public String DisplayValue        {get; set;} //Valid when bitmask = 16 (Company) OR bitmask = 1 (Contact)
        public Boolean IsOa				{get;set;}//Valid when bitmask = 16
        public String Title          {get; set;} //Valid when bitmask = 1 (Contact)
        public String OrganizationName    {get; set;}  //Valid when bitmask = 1 (Contact)
    }

    public List<Collection_Z> Collection;  

    public class Collection_Z {
        public Integer Type;
        public List<Collection> Collection;
        public Integer TotalResults;
    }

    public static CNData_14_AutoComplete parse(String json) {
    	system.debug('autocomplete json' + json);
        return (CNData_14_AutoComplete) System.JSON.deserialize(json, CNData_14_AutoComplete.class);
    }


  public static CNData_14_AutoComplete.Collection getSingleItem(integer iIndex, CNData_14_AutoComplete oCollection) {
      List<CNData_14_AutoComplete.Collection_Z> oParent   = oCollection.Collection;
      CNData_14_AutoComplete.Collection_Z oSingleParent   = oParent.get(0);
      CNData_14_AutoComplete.Collection oSingleChild     = oSingleParent.Collection.get(iIndex);
      return oSingleChild;
  }

  public static CNData_14_AutoComplete.Collection getSingleItemSortedByRelationshipCountDesending(CNData_14_AutoComplete oCollection) {
  		
      List<CNData_14_AutoComplete.Collection_Z> oParent   = oCollection.Collection;
      if(oParent==null) return null;
      if(oParent.size()==0) return null;
      CNData_14_AutoComplete.Collection_Z oParentChild   = oParent.get(0);
      
      CNData_14_AutoComplete.Collection oSingleChildForReturn = new CNData_14_AutoComplete.Collection();
      oSingleChildForReturn.NumRelationships = 0;
      CNData_14_AutoComplete.Collection oSingleChild = new CNData_14_AutoComplete.Collection();
      
      for (Integer i = 0; i < oParentChild.Collection.size(); i++) {
        oSingleChild = getSingleItem(i, oCollection);
        if (oSingleChild.NumRelationships > oSingleChildForReturn.NumRelationships) oSingleChildForReturn = oSingleChild;
      }

      return oSingleChildForReturn;
  }
  
  //TODO Change Name to MapToBaseCompany
  public static CNData.CNCompany MapTo(CNData_14_AutoComplete.Collection oItem) {
  	if(oItem==null) return null;
    CNData.CNCompany oCompany = new CNData.CNCompany();
    oCompany.CNID        = oItem.Id;
    oCompany.companyName    = oItem.DisplayValue;
    oCompany.NumberOfColleagues  = oItem.NumColleagues;
    oCompany.NumberOfContacts  = oItem.NumContacts;
    oCompany.hasRelationship  = oItem.HasFamilyTree;
    oCompany.IsOa = oItem.IsOa;
    return oCompany;
  }
  
  public static CNData.CNContact MapToBaseContact(CNData_14_AutoComplete.Collection oItem) {
    CNData.CNContact oContact = new CNData.CNContact();
    oContact.CNID          = oItem.Id;
    oContact.FullName        = oItem.DisplayValue;
    oContact.NumberOfRelationships  = oItem.NumColleagues;
    //oContact.            = oItem.OrganizationName;
    oContact.Title          = oItem.Title;
    return oContact;
  }    

}