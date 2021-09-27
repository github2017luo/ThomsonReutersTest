/**
    @description Contact data layer class for DCP projects.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
 */
public without sharing class DCPContact{

    /**
        @description Stores the queried contact
     */
    public static List<Contact> conList;
    
    /**
        @description Run queries on Contact object
        @param contactIds List of contact ids to query
        @return Returns the queried contact
     */
    public static List<Contact> getContact(List<id> contactIds){
        conList=   
                [SELECT id, FirstName, LastName, Email
                FROM Contact
                WHERE id IN : contactIds
                WITH SECURITY_ENFORCED];
                
        return conList;
    }

    /**
        @description Updates Contact object
        @param conUpdateList List of contact ids to update
     */

    /** 
    public static void updateContact(List<Contact> conUpdateList){
        Database.SaveResult[] results = Database.update(conUpdateList,false);
    }
    */
    
}