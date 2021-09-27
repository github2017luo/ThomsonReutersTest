/**
    @description Account data layer class for DCP projects.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
 */
public without sharing class DCPAccount{

    /**
        @description Stores the queried accounts
     */
    public static List<Account> accList;
    
    /**
        @description Run queries on Account object
        @param accountIds List of account ids to query
        @return Returns the queried accounts
     */
    public static List<Account> getAccounts(List<id> accountIds){
        accList =   
                [SELECT id, Name
                FROM Account 
                WHERE id IN : accountIds
                WITH SECURITY_ENFORCED];
                
        return accList;
    }

   

    /**
        @description Updates Account object
        @param accUpdateList List of account ids to update
     */

    /** 
    public static void updateAccount(List<Account> accUpdateList){
        Database.SaveResult[] results = Database.update(accUpdateList,false);
    }
    */
}