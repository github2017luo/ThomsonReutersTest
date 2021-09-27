/**
 * @author: Anshita Sharma
 * @version 2012-08-29
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2012-08-29   Anshita Sharma      Created
 * =============================================================================
 */
 
trigger UpdateAccOnContact on Course__c(after update, after insert)
{
    Map<Id, Course__c> cseMap = new Map<Id, Course__c>();
    List<Contact> conLstUpdate = new List<Contact>();
    
    for(Course__c cse:Trigger.new)
    {
        if(cse.Contact_Name__r.AccountId == null)
            cseMap.put(cse.Contact_Name__c, cse);
    }
    
    for(List<Contact> conLst:[select Id, Name, AccountId from Contact where Id IN:cseMap.keySet()])
    {
        for(Contact con:conLst)
        {
            if(con.AccountId == null)
            {
                con.AccountId = (cseMap.get(con.Id)).Account_Name__c;
                conLstUpdate.add(con);
            }    
        }
    }
    if(!conLstUpdate.isEmpty())
        update(conLstUpdate);
}