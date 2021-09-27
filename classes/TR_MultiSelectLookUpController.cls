/**
    * @author:        Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
    * @company:       TCS
    * @Date:          2020-02-03
    * @Description:   A class to implement MultiSelect Custom Lookup functionality. 
    * @see 
    * changelog
    */

public with sharing class TR_MultiSelectLookUpController {
    
    /**
    * This method is used to fetch multiple SObjects records based on the search keyword and the SObjectName.
    * <p>since 47.0 (Force.com ApiVersion)</p>
    * <p>
    * changelog
    * <br> - 2020-02-03 Jayanth Kumar <jayanth.kumar@thomsonreuters.com> 
    * <br> -- Created
    * </p>
    * @author   Jayanth Kumar
    * @date     2020-02-03 
    */
    
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        try{
            String searchKey = '%' + searchKeyWord + '%';
            List < sObject > returnList = new List < sObject > ();
            
            List<string> lstExcludeitems = new List<string>();
            for(sObject item : ExcludeitemsList ){
                lstExcludeitems.add(item.id);
            }
            
            if(ObjectName == 'Campaign')
            {
            // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
            String sQuery =  'select id, Name,StartDate,NumberOfContacts,NumberOfLeads from Campaign where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
            List < sObject > lstOfRecords = Database.query(sQuery);
            
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
            }
			return returnList;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());    
        }
    }
}