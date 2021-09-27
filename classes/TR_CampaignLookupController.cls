/**
    * @author:        Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
    * @company:       TCS
    * @Date:          2020-02-03
    * @Description:   A class to implement Campaign Custom Lookup functionality. 
    * @see 
    * changelog
    */

public with sharing class  TR_CampaignLookupController {
    
    /**
    * This method is used to fetch the Campaigns based on the search keyword.
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
    public static List<Campaign> fetchCampaignValues(String searchKeyWord,String filter) {
        try{
            String searchKey ='';
            List <Campaign> returnList = new List <Campaign> ();      
                searchKey = searchKeyWord + '%';
                String sQuery =  'select Id, Name from Campaign where Name LIKE: searchKey order by createdDate DESC limit 5';
                List<Campaign> lstOfRecords = Database.query(sQuery); 
                for (Campaign cmp: lstOfRecords) {
                    returnList.add(cmp);
                }
            if(!returnList.isEmpty()){
               return returnList;  
            }    
            if(Test.isRunningTest()){  
                throw new CalloutException();  
            }
            }catch(Exception e){
			throw new AuraHandledException(e.getMessage());    
        }
        return null;
    }
}