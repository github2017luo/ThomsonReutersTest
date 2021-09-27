/**
    @description Opportunity data layer class for DCP projects.
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
 */
public without sharing class DCPOpportunity{

    /**
        @description Stores the queried opportunity
     */
    public static List<Opportunity> oppList;
    
    /**
        @description Run queries on Opportunity object
        @param opportunityIds List of contact ids to query
        @return Returns the queried opportunity
     */
    public static List<Opportunity> getOpportunity(List<id> opportunityIds){
        oppList =   
                [SELECT Id, isDigitalSpearHead__c,Renewal_Date__c, Key_Contact__c, Campaign_Code__c,sub_Campaign_Code__c
                FROM Opportunity
                WHERE id IN : opportunityIds
                WITH SECURITY_ENFORCED];
                
        return oppList;
    }
    
    /**
        @description Updates Opportunity object
        @param oppUpdateList List of opportunity ids to update
     */
    /*
    public static void updateOpportunity(List<Opportunity> oppUpdateList){
        Database.SaveResult[] results = Database.update(oppUpdateList,false);
    }*/
    
}